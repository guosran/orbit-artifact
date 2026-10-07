#!/usr/bin/env python3
"""Run explicit diagnostic fusion/fission controls through native replay.

This is a diagnostic-only harness. Python names the control pair/cut and
collects measurements; C++ materializes each typed action, replays its source
proof, reconstructs candidate bodies, predicts fresh costs, and owns the
complete-program schedule. Each search receives only its explicit seed rows
plus the identity candidate, in a separate output root from the main curve.

Fusion candidates use 1x2 for the fused task, matching the two 1x1 parent
tasks' total CGRA count. The LU fission control uses two 1x1 children and a
2x1 unsplit parent control, again matching total CGRA count.
"""
from __future__ import annotations

import argparse
from collections import Counter
import copy
from datetime import datetime, timezone
import importlib.util
import json
import os
from pathlib import Path
import re
import subprocess
import sys
from typing import Any, Mapping, Sequence


SCRIPT = Path(__file__).resolve()
SCRIPT_ROOT = SCRIPT.parents[1]
ACTION_SCHEMA = "orbit-joint-neighborhood-typed-actions-v1"
FISSION_STAGE = "full-joint-fission"
FUSION_STAGE = "full-joint"
WORKLOAD_CONTROLS = {
    "harris": {
        "label": "pc-harris-task0-task1",
        "family": "fusion",
        "first": "Task_0",
        "second": "Task_1",
        "mode": "producer-consumer-retained",
        "expected_parent_loads": 4,
        "expected_parent_stores": 2,
        "expected_fused_loads": 3,
        "expected_fused_stores": 2,
    },
    "radar": {
        "label": "pc-radar-task16-task17",
        "family": "fusion",
        "first": "Task_16",
        "second": "Task_17",
        "mode": "producer-consumer-retained",
        "expected_parent_loads": 6,
        "expected_parent_stores": 2,
        "expected_fused_loads": 5,
        "expected_fused_stores": 2,
    },
    "radar-sibling": {
        "label": "sibling-radar-task4-task5",
        "workload": "radar",
        "family": "sibling-fusion",
        "first": "Task_4",
        "second": "Task_5",
        "mode": "sibling",
        "expected_parent_loads": 8,
        "expected_parent_stores": 2,
        "expected_fused_loads": 4,
        "expected_fused_stores": 2,
    },
}


class ProbeError(RuntimeError):
    """A controlled probe could not preserve its evidence contract."""


def _write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + f".partial-{os.getpid()}")
    try:
        temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n",
                             encoding="utf-8")
        os.replace(temporary, path)
    finally:
        try:
            temporary.unlink()
        except FileNotFoundError:
            pass


def _read_json(path: Path, description: str) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
        raise ProbeError(f"{description} is unreadable: {path}: {error}") from error
    if not isinstance(value, dict):
        raise ProbeError(f"{description} must be a JSON object: {path}")
    return value


def _regular_file(path: Path, description: str, *, executable: bool = False) -> Path:
    if path.is_symlink() or not path.is_file():
        raise ProbeError(f"{description} is missing or is not a regular file: {path}")
    if executable and not os.access(path, os.X_OK):
        raise ProbeError(f"{description} is not executable: {path}")
    return path.resolve()


def _resolve_config_path(value: Any, *, base: Path, artifact_root: Path,
                         description: str, required: bool = True) -> Path | None:
    if value is None and not required:
        return None
    if isinstance(value, os.PathLike):
        value = os.fspath(value)
    if not isinstance(value, str) or not value:
        raise ProbeError(f"config is missing {description}")
    expanded = value.replace("${ARTIFACT_ROOT}", str(artifact_root))
    if "${" in expanded:
        raise ProbeError(f"config {description} has an unresolved variable: {value}")
    path = Path(expanded)
    if not path.is_absolute():
        path = base / path
    return path.resolve()


def load_workload_config(config_path: Path, artifact_root: Path,
                         workload: str, args: argparse.Namespace) -> dict[str, Any]:
    config = _read_json(config_path, "probe config")
    workloads = config.get("workloads")
    if not isinstance(workloads, dict) or not isinstance(workloads.get(workload), dict):
        raise ProbeError(f"config has no workloads.{workload} entry")
    defaults = config.get("defaults", {})
    if not isinstance(defaults, dict):
        raise ProbeError("config defaults must be an object")
    item = workloads[workload]
    config_base_value = config.get("config_base")
    config_base = _resolve_config_path(
        config_base_value, base=config_path.parent, artifact_root=artifact_root,
        description="config_base", required=False) if config_base_value else config_path.parent
    assert config_base is not None

    def pick(key: str, *aliases: str) -> Any:
        for candidate in (key, *aliases):
            if candidate in item:
                return item[candidate]
        for candidate in (key, *aliases):
            if candidate in defaults:
                return defaults[candidate]
        return None

    paths: dict[str, Path | None] = {}
    required_paths = {
        "canonical": "canonical",
        "parent_cost_file": "parent_cost_file",
        "model_cache": "model_cache",
    }
    optional_paths = {
        "prepared_source_file": "prepared_source_file",
        "cost_cache": "cost_cache",
        "architecture": "architecture",
        "inter_task_network": "inter_task_network",
        "sram_config": "sram_config",
        "reference_root": "reference_root",
    }
    for key, description in required_paths.items():
        paths[key] = _resolve_config_path(
            pick(key, "model" if key == "model_cache" else key),
            base=config_base, artifact_root=artifact_root,
            description=f"{workload}.{description}")
    for key, description in optional_paths.items():
        override = getattr(args, key, None) if key in {
            "architecture", "inter_task_network", "sram_config", "reference_root"
        } else None
        value = override if override is not None else pick(key)
        # CLI paths are supplied by argparse as Path objects. Resolve them
        # against the artifact checkout, while paths read from the JSON config
        # remain relative to config_base.
        base = artifact_root if override is not None else config_base
        fallback: Path | None = None
        if key == "architecture":
            fallback = artifact_root / "config/architectures/amoeba_4x4_cgra_2x2_context6.yaml"
        elif key == "inter_task_network":
            fallback = artifact_root / "config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml"
        elif key == "sram_config":
            fallback = artifact_root / "config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json"
        elif key == "reference_root":
            fallback = artifact_root / ".work/selected-native-numeric-gate"
        paths[key] = (_resolve_config_path(value, base=base,
                                           artifact_root=artifact_root,
                                           description=f"{workload}.{description}",
                                           required=False)
                      if value is not None else fallback)
    paths["cost_cache"] = _resolve_config_path(
        pick("cost_cache"), base=config_base, artifact_root=artifact_root,
        description=f"{workload}.cost_cache", required=False)
    for key in ("canonical", "parent_cost_file", "model_cache", "architecture",
                "inter_task_network", "sram_config"):
        value = paths[key]
        if value is None:
            raise ProbeError(f"resolved path missing for {workload}.{key}")
        _regular_file(value, f"{workload} {key}")
    for key in ("prepared_source_file", "cost_cache", "reference_root"):
        value = paths[key]
        if key == "prepared_source_file" and value is not None:
            _regular_file(value, f"{workload} prepared source")
        elif key == "cost_cache" and value is not None and (value.is_symlink() or not value.is_file()):
            raise ProbeError(f"{workload} cost cache is missing or not a regular file: {value}")
        elif key == "reference_root" and value is not None and (value.is_symlink() or not value.is_dir()):
            raise ProbeError(f"numeric reference root is missing or not a directory: {value}")
    function = item.get("function")
    return {**item, **paths, "function": function,
            "config_base": config_base}


def _load_module(name: str, path: Path) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ProbeError(f"cannot load existing replay helper: {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def _helpers(artifact_root: Path) -> tuple[Any, Any]:
    nr = _load_module("controlled_probe_neighborhood_replay",
                      artifact_root / "scripts/neighborhood_replay.py")
    replay = _load_module("controlled_probe_cpp_replay",
                          artifact_root / "scripts/replay_cpp_global_top5.py")
    nr.ROOT = artifact_root
    nr.REPLAY_SCRIPT = artifact_root / "scripts/replay_cpp_global_top5.py"
    nr.DEFAULT_NUMERIC_GATE = artifact_root / "scripts/run_input0_numeric.py"
    replay.ROOT = artifact_root
    return nr, replay


def _run_logged(argv: Sequence[str], directory: Path, label: str,
                artifact_root: Path) -> dict[str, Any]:
    directory.mkdir(parents=True, exist_ok=True)
    command_path = directory / f"{label}.command.json"
    if command_path.exists():
        raise ProbeError(f"refusing to overwrite command evidence: {command_path}")
    stdout_path = directory / f"{label}.stdout.log"
    stderr_path = directory / f"{label}.stderr.log"
    record = {
        "schema": "orbit-controlled-probe-command-v1",
        "argv": [str(item) for item in argv],
        "status": "running",
        "started_utc": datetime.now(timezone.utc).isoformat(),
        "subprocess_timeout": None,
        "stdout": str(stdout_path),
        "stderr": str(stderr_path),
    }
    _write_json(command_path, record)
    try:
        with stdout_path.open("w", encoding="utf-8") as stdout, \
                stderr_path.open("w", encoding="utf-8") as stderr:
            result = subprocess.run([str(item) for item in argv], cwd=artifact_root,
                                    stdout=stdout, stderr=stderr, check=False)
        record.update(status="finished", exit_code=result.returncode,
                      ended_utc=datetime.now(timezone.utc).isoformat())
    except OSError as error:
        record.update(status="failed", error=f"{type(error).__name__}: {error}",
                      ended_utc=datetime.now(timezone.utc).isoformat())
        _write_json(command_path, record)
        raise ProbeError(f"cannot run command {label}: {error}") from error
    _write_json(command_path, record)
    return record


def _assert_cxx_path_safe(*paths: Path) -> None:
    for path in paths:
        if any(character.isspace() for character in str(path)):
            raise ProbeError(f"C++ pass option paths cannot contain whitespace: {path}")


def _primitive(kind: str, first: str = "", second: str = "", mode: str = "",
               *, left_nodes: Sequence[int] = ()) -> dict[str, Any]:
    return {"kind": kind, "firstTask": first, "secondTask": second,
            "axis": 0, "factor": 1, "mode": mode,
            "leftNodes": list(left_nodes)}


def _typed_action(family: str, label: str, *, primitives: Sequence[Mapping[str, Any]] = (),
                  shape_task: str = "", rows: int = 0, cols: int = 0) -> dict[str, Any]:
    return {"family": family, "label": label,
            "primitives": [dict(primitive) for primitive in primitives],
            "shapeTask": shape_task, "shapeRows": rows, "shapeCols": cols,
            "canonicalReset": False}


def _fusion_action(control: Mapping[str, Any]) -> dict[str, Any]:
    first, second, mode = control["first"], control["second"], control["mode"]
    if control["family"] == "sibling-fusion":
        return _typed_action(
            "sibling-fusion", f"sibling-fuse:{first}:{second}",
            primitives=[_primitive("sibling-fusion", first, second, "sibling")])
    return _typed_action(
        "fusion", f"fuse:{first}:{second}:{mode}",
        primitives=[_primitive("fusion", first, second, mode)])


def fusion_actions(control: Mapping[str, Any], fused_task: str, *,
                   shape_rows: int = 1, shape_cols: int = 2) -> list[dict[str, Any]]:
    if (shape_rows, shape_cols) not in {(1, 2), (2, 1)}:
        raise ProbeError("same-resource fusion controls support only 1x2 or 2x1")
    fusion = _fusion_action(control)
    shape = _typed_action("shape", f"shape:{fused_task}:{shape_rows}x{shape_cols}",
                          shape_task=fused_task, rows=shape_rows, cols=shape_cols)
    return [fusion, shape]


def shape_action(task: str, rows: int, cols: int) -> dict[str, Any]:
    return _typed_action("shape", f"shape:{task}:{rows}x{cols}",
                         shape_task=task, rows=rows, cols=cols)


def _action_document(canonical: Path, function: str, stage: str,
                     max_partition_factor: int,
                     actions: Sequence[Mapping[str, Any]], *,
                     prepared_source: Path | None = None,
                     fission_cap: int | None = None) -> dict[str, Any]:
    value: dict[str, Any] = {
        "schema": ACTION_SCHEMA,
        "canonicalInput": str(canonical),
        "candidateInput": str(canonical),
        "function": function,
        "stage": stage,
        "maxPartitionFactor": max_partition_factor,
        "actions": [dict(action) for action in actions],
    }
    if prepared_source is not None:
        payload = prepared_source.read_bytes()
        try:
            exact_text = payload.decode("utf-8")
        except UnicodeDecodeError as error:
            raise ProbeError(f"prepared source is not UTF-8: {prepared_source}") from error
        value.update(preparedSourceInput=str(prepared_source),
                     preparedSourceExactBytes=exact_text,
                     maxFissionActionsPerTask=fission_cap)
    return value


def _direct_replay(*, optimizer: Path, architecture: Path, canonical: Path,
                   function: str, stage: str, output_dir: Path,
                   action: Mapping[str, Any], max_partition_factor: int,
                   artifact_root: Path, prepared_source: Path | None = None,
                   fission_cap: int | None = None) -> tuple[dict[str, Any], dict[str, Any]]:
    action_file = output_dir / "actions.json"
    replay_dir = output_dir / "replay"
    _assert_cxx_path_safe(*(path for path in
                            (optimizer, architecture, canonical, action_file,
                             replay_dir, prepared_source) if path is not None))
    action_document = _action_document(
        canonical, function, stage, max_partition_factor, action["actions"],
        prepared_source=prepared_source, fission_cap=fission_cap)
    _write_json(action_file, action_document)
    option = (f"action-file={action_file} canonical-input={canonical} "
              f"candidate-input={canonical} function={function} stage={stage} "
              f"max-partition-factor={max_partition_factor} output-dir={replay_dir}")
    if prepared_source is not None:
        option += (f" prepared-source-file={prepared_source}"
                   f" max-fission-actions-per-task={fission_cap}")
    command = _run_logged(
        [str(optimizer), str(canonical), "--verify-each",
         f"--architecture-spec={architecture}",
         "--replay-joint-neighborhood-actions=" + option,
         "--mlir-print-op-generic", "-o", "/dev/null"],
        output_dir, "typed-replay", artifact_root)
    if command.get("exit_code") != 0:
        raise ProbeError(f"C++ typed replay failed; see {command['stderr']}")
    facts = _read_json(replay_dir / "source-facts.json", "C++ typed replay facts")
    candidate = replay_dir / "candidate.mlir"
    if (facts.get("schema") != "orbit-joint-neighborhood-action-replay-facts-v1" or
            facts.get("status") != "complete" or
            facts.get("candidate_module") != "candidate.mlir" or
            facts.get("source_iteration_domain_verified") is not True or
            facts.get("actions_applied") != len(action["actions"]) or
            not candidate.is_file()):
        raise ProbeError("C++ typed replay facts do not prove a complete requested candidate")
    expected_fission = any(row.get("family") == "fission" for row in action["actions"])
    if facts.get("fission_source_replay_verified") is not expected_fission:
        raise ProbeError("C++ typed replay facts do not match the requested source fission")
    return facts, command


def _source_cut_census(*, optimizer: Path, prepared_source: Path,
                       function: str, fission_cap: int,
                       output_dir: Path, artifact_root: Path) -> tuple[dict[str, Any], dict[str, Any]]:
    census = output_dir / "source-cut-census.json"
    _assert_cxx_path_safe(optimizer, prepared_source, census)
    command = _run_logged(
        [str(optimizer), str(prepared_source),
         "--verify-taskflow-fission-source-replay="
         f"enumerate-function={function} max-fission-actions-per-task={fission_cap} "
         f"output={census}", "-o", "/dev/null"],
        output_dir, "source-cut-census", artifact_root)
    if command.get("exit_code") != 0:
        raise ProbeError(f"C++ source-cut census failed; see {command['stderr']}")
    value = _read_json(census, "C++ source-cut census")
    if (value.get("schema") != "orbit-taskflow-fission-source-cut-census-v1" or
            value.get("status") != "complete" or value.get("mapper_invoked") is not False or
            value.get("function") != function):
        raise ProbeError("C++ source-cut census is incomplete or bound to another function")
    return value, command


def _first_legal_cut(census: Mapping[str, Any], preferred_task: str | None = None
                     ) -> tuple[str, list[int]]:
    tasks = census.get("tasks")
    if not isinstance(tasks, list):
        raise ProbeError("source-cut census has no task list")
    choices: list[tuple[str, list[int]]] = []
    for row in tasks:
        if not isinstance(row, dict) or row.get("status") != "supported":
            continue
        cuts = row.get("left_nodes")
        if not isinstance(cuts, list):
            continue
        for cut in cuts:
            if (isinstance(cut, list) and cut and
                    all(type(node) is int and node >= 0 for node in cut) and
                    list(cut) == sorted(set(cut))):
                choices.append((str(row.get("task", "")), list(cut)))
    if preferred_task:
        choices = [row for row in choices if row[0] == preferred_task]
    choices = [row for row in choices if row[0]]
    if not choices:
        name = f" for {preferred_task}" if preferred_task else ""
        raise ProbeError(f"C++ source census contains no complete legal cut{name}")
    return choices[0]


def _diagnostic_search_command(nr: Any, *, optimizer: Path, canonical: Path,
                               output_dir: Path, function: str, stage: str,
                               architecture: Path, protocol: Mapping[str, Any],
                               protocol_path: Path, source_contract: Path,
                               model_cache: Path, cost_cache: Path | None,
                               parent_cost_file: Path,
                               inter_task_network: Path | None,
                               workload: str, seed_manifest: Path,
                               candidate_budget: int,
                               prepared_source: Path | None,
                               fission_cap: int | None,
                               checkpoint: Path) -> list[str]:
    """Build the normal C++ search command, then bind diagnostic-only seeds.

    The public stage-chain launcher rejects seed imports by design. This
    dedicated command stays inside the C++ source-owned path and carries only
    this diagnostic's typed facts. Its output directory and two/three-score
    ceiling are disjoint from the main experiment.
    """
    command = nr.build_search_command(
        optimizer=optimizer, canonical=canonical, output_dir=output_dir,
        function=function, stage=stage, architecture=architecture,
        protocol=protocol, checkpoint=checkpoint, seed_manifest=None,
        previous_winner=None, parent_cost_file=parent_cost_file,
        model_cache=model_cache, cost_cache=cost_cache,
        max_rounds=1, max_candidates=candidate_budget,
        beam_width=1, diversity_slots=1, resume=None,
        protocol_path=protocol_path, source_contract_file=source_contract,
        workload=workload, inter_task_network=inter_task_network,
        stage_initialization="independent",
        prepared_source_file=prepared_source,
        max_fission_actions_per_task=fission_cap)
    key = "--search-joint-neighborhood="
    matches = [index for index, value in enumerate(command) if value.startswith(key)]
    if len(matches) != 1:
        raise ProbeError("normal C++ search command has no unique search option")
    index = matches[0]
    command[index] += f" seed-manifest={seed_manifest}"
    _assert_cxx_path_safe(seed_manifest, checkpoint, output_dir)
    return command


def _protocol_search_budget(protocol: Mapping[str, Any]) -> dict[str, Any]:
    search = protocol.get("search")
    if not isinstance(search, Mapping):
        raise ProbeError("protocol has no search object for C++ budget binding")
    names = ("max_rounds", "max_unique_complete_candidates_scored",
             "beam_width", "diversity_min_slots", "max_partition_factor",
             "native_shortlist", "max_fission_actions_per_task",
             "diagnostic_ii_ceiling", "round_score_quota")
    return {name: search.get(name) for name in names}


def _validate_search_budget_binding(protocol: Mapping[str, Any],
                                    options: Mapping[str, int]) -> None:
    """Mirror every strict budget comparison in C++ search binding."""
    search = protocol.get("search")
    if not isinstance(search, Mapping):
        raise ProbeError("protocol has no search object for C++ budget binding")
    fields = {
        "max_rounds": "max_rounds",
        "max_candidates": "max_unique_complete_candidates_scored",
        "beam_width": "beam_width",
        "diversity_slots": "diversity_min_slots",
        "max_partition_factor": "max_partition_factor",
    }
    mismatches = {
        protocol_field: {"protocol": search.get(protocol_field),
                         "cxx_option": options.get(option)}
        for option, protocol_field in fields.items()
        if search.get(protocol_field) != options.get(option)
    }
    if mismatches:
        raise ProbeError("diagnostic search budgets do not match their bound "
                         f"protocol: {mismatches}")


def _write_diagnostic_protocol(protocol: Mapping[str, Any], *,
                               output_dir: Path, candidate_budget: int
                               ) -> tuple[Path, dict[str, Any], dict[str, Any]]:
    """Bind bounded controls to a diagnostic-only protocol copy.

    The C++ pass rejects zero max-rounds and requires its five budget options
    to equal the bound protocol. One round with an exact identity-plus-seed
    candidate cap admits only the explicit controls for scoring.
    """
    if candidate_budget not in (2, 3):
        raise ProbeError("controlled diagnostic searches must score exactly 2 or 3 candidates")
    diagnostic = copy.deepcopy(dict(protocol))
    search = diagnostic.get("search")
    if not isinstance(search, dict):
        raise ProbeError("common protocol has no mutable search object")
    main_budget = _protocol_search_budget(protocol)
    required_main = {"max_rounds": 4,
                     "max_unique_complete_candidates_scored": 4096,
                     "beam_width": 16, "diversity_min_slots": 4,
                     "native_shortlist": 5}
    if any(main_budget.get(name) != value for name, value in required_main.items()):
        raise ProbeError("common protocol no longer has the preserved main-curve "
                         f"budget: {main_budget}")
    options = {"max_rounds": 1, "max_candidates": candidate_budget,
               "beam_width": 1, "diversity_slots": 1,
               "max_partition_factor": main_budget["max_partition_factor"]}
    search.update(max_rounds=options["max_rounds"],
                  max_unique_complete_candidates_scored=options["max_candidates"],
                  beam_width=options["beam_width"],
                  diversity_min_slots=options["diversity_slots"])
    _validate_search_budget_binding(diagnostic, options)
    if search.get("native_shortlist") != main_budget["native_shortlist"]:
        raise ProbeError("diagnostic protocol changed the common native shortlist")

    path = output_dir / "diagnostic-common-protocol.json"
    if path.exists() or path.is_symlink():
        raise ProbeError(f"diagnostic protocol path already exists: {path}")
    _write_json(path, diagnostic)
    execution = diagnostic.get("execution")
    receipt = {
        "diagnostic_only": True,
        "path": str(path.resolve()),
        "main_curve_search_budget": main_budget,
        "diagnostic_search_budget": _protocol_search_budget(diagnostic),
        "protocol_execution_budget": {
            "scoring_workers": (execution.get("scoring_workers")
                                if isinstance(execution, Mapping) else None)},
        "cxx_search_options": options,
        "scored_candidate_composition": {
            "identity": 1, "explicit_control_seeds": candidate_budget - 1,
            "total": candidate_budget},
        "main_curve_budget_changed": False,
    }
    return path.resolve(), diagnostic, receipt


def _history_key(value: Mapping[str, Any]) -> str:
    history = value.get("action_history")
    if not isinstance(history, dict) or history.get("known") is not True:
        raise ProbeError("C++ record lacks authenticated typed action history")
    relevant = {key: history.get(key) for key in
                ("initialShapes", "actions", "fissionActions")}
    return json.dumps(relevant, sort_keys=True, separators=(",", ":"))


def _task_spans(module_text: str) -> dict[str, tuple[int, int, int, int, str]]:
    """Locate generic Taskflow task bodies for byte/op statistics only."""
    result_value = r"%[\w.$-]+(?::\d+)?"
    result_prefix = (r"(?:" + result_value +
                     r"(?:\s*,\s*" + result_value + r")*\s*=\s*)?")
    pattern = re.compile(r"(?m)^\s*" + result_prefix + r"\"taskflow\.task\"\(")
    spans: dict[str, tuple[int, int, int, int, str]] = {}
    plain = _mask_strings(module_text)
    for match in pattern.finditer(module_text):
        region_start = module_text.find("({", match.end())
        if region_start < 0:
            continue
        header_end = region_start + 2
        header = module_text[match.start():header_end]
        name_match = re.search(r'task_name\s*=\s*"([^"\\]+)"', header)
        if not name_match:
            continue
        name = name_match.group(1)
        brace = plain.find("{", region_start)
        if brace < 0:
            continue
        depth = 0
        end = -1
        for position in range(brace, len(plain)):
            if plain[position] == "{":
                depth += 1
            elif plain[position] == "}":
                depth -= 1
                if depth == 0:
                    end = position
                    break
        if end < 0:
            continue
        if name in spans:
            raise ProbeError(f"generic candidate repeats Taskflow task name {name}")
        body = module_text[brace + 1:end]
        byte_count = len(body.encode("utf-8"))
        result_prefix = r"(?:%[\w.$-]+(?::\d+)?(?:\s*,\s*%[\w.$-]+(?::\d+)?)*\s*=\s*)?"
        op_names = re.findall(
            r'(?m)^\s*' + result_prefix + r'"([A-Za-z_][\w.]*)"\s*\(', body)
        counts = Counter(op_names)
        header_to_end = module_text[match.start():end + 1]
        loads = sum(value for key, value in counts.items()
                    if key.rsplit(".", 1)[-1] in {"load", "ld"} or
                    key.rsplit(".", 1)[-1].startswith(("load_", "ld_")))
        stores = sum(value for key, value in counts.items()
                     if key.rsplit(".", 1)[-1] in {"store", "st"} or
                     key.rsplit(".", 1)[-1].startswith(("store_", "st_")))
        spans[name] = (match.start(), end + 1, brace + 1, end,
                       json.dumps({"body_bytes": byte_count,
                                   "operation_count": len(op_names),
                                   "operation_counts": dict(sorted(counts.items())),
                                   "loads": loads,
                                   "stores": stores,
                                   "compiled_ii": _integer_attr(header_to_end, "compiled_ii"),
                                   "selected_trip_count": _integer_attr(
                                       header_to_end, "amoeba.selected_trip_count"),
                                   "source_firings": _integer_attr(
                                       header_to_end, "current_taskflow_firing_count")},
                                  sort_keys=True))
    return spans


def _mask_strings(text: str) -> str:
    masked = list(text)
    quoted = False
    escaped = False
    for index, character in enumerate(text):
        if quoted:
            masked[index] = "\n" if character == "\n" else "\0"
            if escaped:
                escaped = False
            elif character == "\\":
                escaped = True
            elif character == '"':
                quoted = False
        elif character == '"':
            masked[index] = "\0"
            quoted = True
    return "".join(masked)


def _integer_attr(text: str, name: str) -> int | None:
    match = re.search(re.escape(name) + r"\s*=\s*(-?[0-9]+)", text)
    return int(match.group(1)) if match else None


def body_statistics(path: Path) -> dict[str, dict[str, Any]]:
    text = path.read_text(encoding="utf-8")
    result = {}
    for name, (_, _, body_start, body_end, encoded) in _task_spans(text).items():
        del body_start, body_end
        result[name] = json.loads(encoded)
    return result


def _task_cost_map(selection: Mapping[str, Any]) -> dict[str, dict[str, Any]]:
    score = selection.get("score_record")
    costs = score.get("task_costs") if isinstance(score, dict) else None
    schedule = score.get("task_schedule") if isinstance(score, dict) else None
    if not isinstance(costs, list) or not isinstance(schedule, list):
        raise ProbeError("C++ score record has no source-owned task costs/schedule")
    placements = {row.get("task"): row for row in schedule if isinstance(row, dict)}
    result = {}
    for cost in costs:
        if not isinstance(cost, dict) or not isinstance(cost.get("task"), str):
            raise ProbeError("C++ score record contains a malformed task cost")
        row = dict(cost)
        placement = placements.get(row["task"])
        if placement:
            row["shape"] = {key: placement[key] for key in ("rows", "cols")}
            row["placement"] = {key: placement[key] for key in
                                ("row", "col", "start_cycle", "end_cycle")}
        result[row["task"]] = row
    return result


def _source_task_map(facts: Mapping[str, Any]) -> dict[str, dict[str, Any]]:
    rows = facts.get("tasks")
    if not isinstance(rows, list):
        raise ProbeError("C++ replay facts have no source-domain task rows")
    result = {}
    for row in rows:
        if not isinstance(row, dict) or not isinstance(row.get("task"), str):
            raise ProbeError("C++ replay facts contain a malformed source-domain task")
        result[row["task"]] = row
    return result


def _compiler_fused_task_name(parent_facts: Mapping[str, Any],
                              fused_facts: Mapping[str, Any],
                              first: str, second: str) -> str:
    """Resolve the new task from C++ task sets instead of naming convention."""
    parent_tasks = set(_source_task_map(parent_facts))
    fused_tasks = set(_source_task_map(fused_facts))
    if first not in parent_tasks or second not in parent_tasks:
        raise ProbeError("canonical C++ replay facts omit a fusion parent")
    unchanged = parent_tasks - {first, second}
    missing = unchanged - fused_tasks
    if missing:
        raise ProbeError("C++ fusion replay facts lost unrelated tasks: " +
                         ", ".join(sorted(missing)))
    added = fused_tasks - unchanged
    if len(added) != 1:
        raise ProbeError("C++ fusion replay facts do not identify exactly one "
                         f"replacement task: {sorted(added)}")
    fused = next(iter(added))
    if fused in parent_tasks:
        raise ProbeError("C++ fusion replacement task collides with a canonical task")
    return fused


def _verified_fission_children(parent_facts: Mapping[str, Any],
                               split_facts: Mapping[str, Any],
                               parent_task: str,
                               left_nodes: Sequence[int]
                               ) -> tuple[list[dict[str, Any]], dict[str, Any]]:
    """Validate C++ exact source replay and its actual child-domain bindings."""
    if (split_facts.get("schema") != "orbit-joint-neighborhood-action-replay-facts-v1" or
            split_facts.get("status") != "complete" or
            split_facts.get("actions_applied") != 1 or
            split_facts.get("source_iteration_domain_verified") is not True or
            split_facts.get("fission_source_replay_verified") is not True):
        raise ProbeError("C++ fission facts lack a complete exact source replay")

    history = split_facts.get("action_history")
    actions = history.get("fissionActions") if isinstance(history, dict) else None
    if (not isinstance(history, dict) or history.get("known") is not True or
            not isinstance(actions, list) or len(actions) != 1):
        raise ProbeError("C++ fission facts lack one authenticated typed cut action")
    action = actions[0]
    primitives = action.get("primitives") if isinstance(action, dict) else None
    if (not isinstance(action, dict) or action.get("family") != "fission" or
            not isinstance(primitives, list) or len(primitives) != 1 or
            not isinstance(primitives[0], dict) or
            primitives[0].get("kind") != "fission" or
            primitives[0].get("firstTask") != parent_task or
            primitives[0].get("leftNodes") != list(left_nodes)):
        raise ProbeError("C++ fission action history does not bind the selected source cut")

    steps = [row for row in split_facts.get("steps", [])
             if isinstance(row, dict) and row.get("family") == "fission"]
    if (len(steps) != 1 or
            steps[0].get("status") != "exact-source-replay-verified" or
            steps[0].get("counter_domain_policy") !=
            "retained-per-operation-not-disjoint-firing-partitions"):
        raise ProbeError("C++ fission step lacks exact source replay verification")

    parent_tasks = _source_task_map(parent_facts)
    parent_domain = parent_tasks.get(parent_task)
    if not isinstance(parent_domain, dict) or parent_domain.get("complete") is not True:
        raise ProbeError("canonical C++ facts omit the complete fission parent domain")
    split_tasks = _source_task_map(split_facts)
    if parent_task in split_tasks:
        raise ProbeError("C++ fission candidate still contains the unsplit parent")
    child_names = [f"{parent_task}.split.0", f"{parent_task}.split.1"]
    if any(name not in split_tasks for name in child_names):
        raise ProbeError("C++ fission candidate lacks its two actual split children")
    children = [split_tasks[name] for name in child_names]
    for child in children:
        witness = child.get("canonical_witness")
        source_binding = child.get("source_control_binding")
        current_binding = child.get("current_control_binding")
        if (child.get("complete") is not True or
                child.get("current_domain_status") != "certified-complete" or
                witness != parent_domain.get("canonical_witness") or
                child.get("source_multiplicity") != parent_domain.get("source_multiplicity") or
                child.get("represented_multiplicity") !=
                parent_domain.get("represented_multiplicity") or
                child.get("current_taskflow_firing_count") !=
                parent_domain.get("current_taskflow_firing_count") or
                child.get("current_source_work_count") !=
                parent_domain.get("current_source_work_count") or
                not isinstance(witness, str) or not witness or
                not isinstance(source_binding, str) or
                not source_binding.startswith("amoeba-source-iteration-domain-v1\n") or
                witness not in source_binding or
                not isinstance(current_binding, str) or
                not current_binding.startswith("amoeba-source-iteration-domain-v1\n") or
                witness not in current_binding):
            raise ProbeError(f"C++ fission child source binding/domain is incomplete: "
                             f"{child.get('task')}")
    return children, steps[0]


def _resource_count(selection: Mapping[str, Any]) -> int:
    costs = _task_cost_map(selection)
    if not costs or any(not isinstance(row.get("shape"), dict) for row in costs.values()):
        raise ProbeError("C++ score schedule does not provide a shape for every task")
    return sum(int(row["shape"]["rows"]) * int(row["shape"]["cols"])
               for row in costs.values())


def _load_actual_trace(native_dir: Path, rank: int, validator: Any) -> dict[str, Any]:
    native = native_dir / f"rank-{rank}" / "native.mlir"
    text = native.read_text(encoding="utf-8")
    dictionary = validator.AttributeParser(
        validator.extract_dictionary(text, "joint_scheduling_actual_trace")).document()
    return dictionary


def _numeric_gate(*, artifact_root: Path, optimizer: Path, llvm_build: Path,
                  reference_root: Path, workload: str, stage: str,
                  native_root: Path, ranks: Sequence[int], output_dir: Path
                  ) -> tuple[list[dict[str, Any]], dict[str, Any]]:
    numeric_output = output_dir / "numeric"
    command = _run_logged(
        [sys.executable, str(artifact_root / "scripts/run_input0_numeric.py"),
         "--artifact-root", str(artifact_root), "--output-root", str(numeric_output),
         "--reference-root", str(reference_root), "--llvm-build", str(llvm_build),
         "--optimizer", str(optimizer), "--native-root", str(native_root),
         "--workloads", workload, "--stage", stage,
         "--ranks", *[str(rank) for rank in ranks], "--jobs", "1"],
        output_dir, "numeric-gate", artifact_root)
    records_path = numeric_output / "latest-batch.json"
    batch = _read_json(records_path, "numeric result batch")
    records = batch.get("records")
    if not isinstance(records, list):
        raise ProbeError("numeric gate did not publish a record list")
    if command.get("exit_code") != 0 and all(
            row.get("status") == "pass" for row in records if isinstance(row, dict)):
        raise ProbeError("numeric gate exited nonzero despite all pass records")
    return [row for row in records if isinstance(row, dict)], command


def nr_scheduler_from_protocol(protocol_path: Path) -> dict[str, str] | None:
    value = _read_json(protocol_path, "protocol")
    scheduler = value.get("scheduler")
    expected = {"backend": "orbit-production", "dispatch_policy": "critical-path",
                "timing": "common-explicit-network"}
    if scheduler is None:
        return None
    if scheduler != expected:
        raise ProbeError("protocol scheduler differs from the common production profile")
    return dict(expected)


def _source_binding(nr: Any, *, protocol: Mapping[str, Any], protocol_path: Path,
                    canonical: Path, optimizer: Path, architecture: Path,
                    model_cache: Path, cost_cache: Path | None,
                    parent_cost_file: Path, source_contract: Path,
                    network: Path, prepared_source: Path | None,
                    fission_cap: int | None) -> dict[str, Any]:
    value = nr.source_binding(
        protocol, canonical, optimizer, architecture, model_cache, cost_cache,
        parent_cost_file, source_contract, network, prepared_source, fission_cap,
        protocol_path=protocol_path)
    value["stage_initialization"] = "independent"
    return value


def _source_contract_checks(protocol_path: Path, source_pin: str) -> dict[str, Any]:
    protocol = _read_json(protocol_path, "protocol")
    if protocol.get("schema") != "orbit-amoeba-input0-neighborhood-v3":
        raise ProbeError("protocol schema is not orbit-amoeba-input0-neighborhood-v3")
    if protocol.get("source_commit") != source_pin:
        raise ProbeError("--source-pin differs from the exact protocol source_commit")
    if protocol.get("stage_scheme") != FISSION_STAGE:
        raise ProbeError("controlled fission protocol must bind full-joint-fission")
    search = protocol.get("search")
    if not isinstance(search, dict):
        raise ProbeError("protocol has no search object")
    max_factor = search.get("max_partition_factor", 4)
    if max_factor not in (4, 8) or isinstance(max_factor, bool):
        raise ProbeError("protocol max_partition_factor must be 4 or 8")
    fission_cap = search.get("max_fission_actions_per_task")
    if not isinstance(fission_cap, int) or isinstance(fission_cap, bool) or fission_cap <= 0:
        raise ProbeError("protocol must bind a positive max_fission_actions_per_task")
    nr_ceiling = search.get("diagnostic_ii_ceiling")
    if nr_ceiling is not None and nr_ceiling not in (20, 23):
        raise ProbeError("protocol diagnostic II ceiling must be 20 or 23")
    return {"protocol": protocol, "max_partition_factor": max_factor,
            "fission_cap": fission_cap}


def _native_and_numeric(*, nr: Any, replay: Any,
                        candidate_selections: Sequence[dict[str, Any]],
                        identity_control: dict[str, Any] | None,
                        pair_controls: Sequence[dict[str, Any]],
                        artifact_root: Path, optimizer: Path, llvm_build: Path,
                        reference_root: Path, architecture: Path,
                        network: Path, sram_config: Path,
                        mapping_cache: Path, stage: str, workload: str,
                        canonical: Path, function: str, protocol_path: Path,
                        source_contract: Path, source_binding: Path,
                        prepared_source: Path | None, max_partition_factor: int,
                        fission_cap: int | None, output_dir: Path
                        ) -> tuple[dict[str, Any], dict[str, Any], list[dict[str, Any]]]:
    replay_rows = list(candidate_selections)
    if identity_control is not None:
        replay_rows.append(identity_control)
    replay_rows.extend(pair_controls)
    native_dir = output_dir / "native"
    summary = nr.replay_records(
        replay_rows,
        output_dir=native_dir, optimizer=optimizer, architecture=architecture,
        mapping_cache=mapping_cache, manifest=Path(replay_rows[0]["shape_manifest_file"]),
        graph_manifests=None, sram_config=sram_config, jobs=1,
        inter_task_network=network, scheduler=nr.scheduler_profile(
            _read_json(protocol_path, "protocol")),
        audit_mapper_calls=False, stage=stage, canonical=canonical,
        function=function, workload=workload, protocol=protocol_path,
        source_contract_file=source_contract,
        prepared_source_file=prepared_source,
        source_binding_file=source_binding,
        max_partition_factor=max_partition_factor,
        max_fission_actions_per_task=fission_cap)
    ranks = [int(row["rank"]) for row in replay_rows]
    if summary.get("status") != "native_replayed":
        failed = [row for row in summary.get("records", [])
                  if row.get("status") != "native_replayed" or
                  row.get("mapper_equality") != "pass" or
                  row.get("independent_trace") != "pass"]
        raise ProbeError(f"native complete-program replay failed for {len(failed)} records")
    numeric_records, numeric_command = _numeric_gate(
        artifact_root=artifact_root, optimizer=optimizer, llvm_build=llvm_build,
        reference_root=reference_root, workload=workload,
        stage="controlled-" + output_dir.name,
        native_root=native_dir, ranks=ranks, output_dir=output_dir)
    numeric_by_rank = {row.get("rank"): row for row in numeric_records}
    native_by_rank = {row.get("rank"): row for row in summary.get("records", [])}
    for rank in ranks:
        gate = numeric_by_rank.get(rank)
        native_row = native_by_rank.get(rank)
        if gate is None or gate.get("status") != "pass" or native_row is None:
            raise ProbeError(f"numeric full-program gate did not pass rank {rank}")
        native_row["numeric"] = "pass"
        native_row["numeric_gate_record"] = gate
        native_path = native_dir / f"rank-{rank}" / "result.json"
        _write_json(native_path, native_row)
    _write_json(native_dir / "summary.json", summary)
    return summary, numeric_command, numeric_records


def _selected_row(rows: Sequence[Mapping[str, Any]], expected: Mapping[str, Any]
                  ) -> dict[str, Any]:
    key = _history_key(expected)
    matched = [dict(row) for row in rows if _history_key(row) == key]
    if len(matched) != 1:
        raise ProbeError("search did not emit exactly one C++ selection for requested typed history")
    return matched[0]


def _validate_search_receipt(*, rows: Sequence[Mapping[str, Any]],
                             summary: Mapping[str, Any],
                             seed_facts: Sequence[Mapping[str, Any]],
                             protocol: Mapping[str, Any], protocol_path: Path,
                             source_pin: str, stage: str,
                             candidate_budget: int
                             ) -> tuple[list[dict[str, Any]], dict[str, Any], dict[str, Any]]:
    """Require the C++ search's complete, protocol-bound best-found receipt.

    The current C++ JSONL contract records success as ``status=best-found``;
    it does not emit a ``complete`` boolean.  Accept that specific terminal
    status only when the summary, header, footer, budget, source binding, and
    every explicit typed seed agree.  This rejects truncated output and other
    terminal statuses while preserving the C++-owned ranking and scores.
    """
    if len(rows) < 3:
        raise ProbeError("C++ top-five archive is truncated before header/selections/footer")
    headers = [row for row in rows if row.get("record_type") == "header"]
    footers = [row for row in rows if row.get("record_type") == "footer"]
    if (len(headers) != 1 or len(footers) != 1 or
            rows[0].get("record_type") != "header" or
            rows[-1].get("record_type") != "footer"):
        raise ProbeError("C++ top-five archive must have one leading header and terminal footer")
    header, footer = dict(headers[0]), dict(footers[0])
    selections = [dict(row) for row in rows if row.get("record_type") == "selection"]
    if len(selections) != candidate_budget:
        raise ProbeError("C++ archive selection count differs from identity plus explicit seeds")

    required = {
        "schema": "orbit-neighborhood-search-v2",
        "source_commit": source_pin,
        "stage": stage,
        "protocol_path": str(protocol_path.resolve()),
        "max_candidates": candidate_budget,
        "max_rounds": 1,
        "beam_width": 1,
        "diversity_slots": 1,
        "max_partition_factor": protocol.get("search", {}).get("max_partition_factor"),
        "best_found": True,
        "identity_control_retained": True,
        "stop_reason": "max-unique-candidates",
        "unique_complete_candidates_scored": candidate_budget,
        "unique_scored_candidates": candidate_budget,
        "unique_valid_candidates": candidate_budget,
        "native_shortlist_count": candidate_budget,
        "native_top5_required": True,
    }
    if (footer.get("status") != "best-found" or
            header.get("status") is not None):
        raise ProbeError("C++ search footer is not terminal best-found")
    for label, receipt in (("header", header), ("footer", footer)):
        for field, expected in required.items():
            if receipt.get(field) != expected:
                raise ProbeError(f"C++ search {label} has an unbound or incomplete {field}")
    if summary.get("record_type") is not None or summary.get("status") is not None:
        raise ProbeError("C++ search summary has unexpected terminal record metadata")
    footer_payload = {key: value for key, value in footer.items()
                      if key not in {"record_type", "status"}}
    if dict(summary) != footer_payload:
        raise ProbeError("C++ search summary does not exactly match the JSONL footer")

    ranks = [row.get("rank") for row in selections]
    if any(not isinstance(rank, int) or isinstance(rank, bool) for rank in ranks) or \
            ranks != list(range(candidate_budget)):
        raise ProbeError("C++ selections do not contain the complete ordered diagnostic ranks")
    if any(row.get("valid") is not True for row in selections):
        raise ProbeError("C++ archive contains an invalid controlled selection")
    history_keys = [_history_key(row) for row in selections]
    if len(set(history_keys)) != len(history_keys):
        raise ProbeError("C++ archive repeats a typed action history")
    for seed in seed_facts:
        _selected_row(selections, seed)

    # The identity selection is the no-op history over the same canonical
    # initial shapes as the explicit controls.  Require it as the only extra
    # selection so a different, hidden candidate cannot consume diagnostic
    # budget or stand in for the canonical comparison.
    seed_history = seed_facts[0].get("action_history")
    if not isinstance(seed_history, dict):
        raise ProbeError("explicit C++ seed lacks typed history for identity binding")
    identity_history = dict(seed_history)
    identity_history.update(actions=[], fissionActions=[])
    identity = {"action_history": identity_history}
    if sum(_history_key(row) == _history_key(identity) for row in selections) != 1:
        raise ProbeError("C++ archive omitted the canonical identity selection")
    if any(_history_key(row) not in {*history_keys} for row in selections):
        raise ProbeError("C++ archive contains an unexpected typed diagnostic candidate")
    return selections, header, footer


def _run_search(*, nr: Any, optimizer: Path, canonical: Path, function: str,
                stage: str, architecture: Path, protocol: Mapping[str, Any],
                protocol_path: Path, source_contract: Path, model_cache: Path,
                cost_cache: Path | None, parent_cost_file: Path,
                network: Path, workload: str, seed_facts: Sequence[Mapping[str, Any]],
                prepared_source: Path | None, fission_cap: int | None,
                output_dir: Path, artifact_root: Path,
                diagnostic_budget_receipt: Mapping[str, Any]
                ) -> tuple[list[dict[str, Any]], dict[str, Any]]:
    search_dir = output_dir / "search"
    search_dir.mkdir(parents=True, exist_ok=False)
    seed_manifest = output_dir / "diagnostic-seeds.jsonl"
    seed_manifest.write_text("".join(json.dumps(row, sort_keys=True) + "\n"
                                       for row in seed_facts), encoding="utf-8")
    checkpoint = output_dir / "checkpoint.json"
    candidate_budget = 1 + len(seed_facts)  # C++ identity plus explicit controls.
    options = {"max_rounds": 1, "max_candidates": candidate_budget,
               "beam_width": 1, "diversity_slots": 1,
               "max_partition_factor": protocol.get("search", {}).get(
                   "max_partition_factor")}
    _validate_search_budget_binding(protocol, options)
    if (diagnostic_budget_receipt.get("diagnostic_only") is not True or
            diagnostic_budget_receipt.get("cxx_search_options") != options or
            diagnostic_budget_receipt.get("main_curve_budget_changed") is not False):
        raise ProbeError("diagnostic budget receipt does not match the exact C++ search options")
    _assert_cxx_path_safe(*(path for path in
                            (optimizer, canonical, output_dir, architecture,
                             checkpoint, seed_manifest, protocol_path,
                             source_contract, model_cache, parent_cost_file,
                             network, cost_cache, prepared_source)
                            if path is not None))
    command = _diagnostic_search_command(
        nr, optimizer=optimizer, canonical=canonical, output_dir=search_dir,
        function=function, stage=stage, architecture=architecture,
        protocol=protocol, protocol_path=protocol_path,
        source_contract=source_contract, model_cache=model_cache,
        cost_cache=cost_cache, parent_cost_file=parent_cost_file,
        inter_task_network=network, workload=workload,
        seed_manifest=seed_manifest, candidate_budget=candidate_budget,
        prepared_source=prepared_source, fission_cap=fission_cap,
        checkpoint=checkpoint)
    command_record = _run_logged(command, output_dir, "diagnostic-search", artifact_root)
    if command_record.get("exit_code") != 0:
        raise ProbeError(f"C++ diagnostic fresh-score search failed; see {command_record['stderr']}")
    result_path = search_dir / "search-summary.json"
    footer = _read_json(result_path, "C++ search summary")
    top5_path = nr.find_output_file(search_dir,
                                   ("global-top5.jsonl", "top5.jsonl", "native-top5.jsonl"))
    rows = nr.read_jsonl(top5_path)
    selections, header, end = _validate_search_receipt(
        rows=rows, summary=footer, seed_facts=seed_facts,
        protocol=protocol, protocol_path=protocol_path,
        source_pin=str(protocol.get("source_commit", "")), stage=stage,
        candidate_budget=candidate_budget)
    selections = [nr.normalize_selection(row) for row in selections]
    archive_record = {"command": command_record,
                      "seed_manifest": str(seed_manifest),
                      "top5": str(top5_path), "header": header,
                      "footer": end, "search_summary": footer,
                      "candidate_score_budget": candidate_budget,
                      "diagnostic_search_protocol": dict(diagnostic_budget_receipt),
                      "main_curve_budget_changed": False,
                      "selections": selections}
    _write_json(output_dir / "search-evidence.json", archive_record)
    return selections, archive_record


def _fusion_probe(*, name: str, control: Mapping[str, Any], args: argparse.Namespace,
                  nr: Any, replay: Any, protocol_data: Mapping[str, Any],
                  max_partition_factor: int, artifact_root: Path,
                  source_contract: Path, output_root: Path) -> dict[str, Any]:
    workload = str(control.get("workload", name.split("-")[0]))
    data = load_workload_config(args.config, artifact_root, workload, args)
    canonical = data["canonical"]
    prepared = data["prepared_source_file"]
    if prepared is None:
        raise ProbeError(f"config has no prepared_source_file for {workload}; required for replay binding")
    function = nr.infer_function(canonical, data.get("function"))
    probe_root = output_root / control["label"]
    probe_root.mkdir(parents=True, exist_ok=False)
    parent_facts, parent_command = _direct_replay(
        optimizer=args.optimizer.resolve(), architecture=data["architecture"],
        canonical=canonical, function=function, stage=FUSION_STAGE,
        output_dir=probe_root / "parent-source-replay",
        action={"actions": []}, max_partition_factor=max_partition_factor,
        artifact_root=artifact_root)
    fusion_action = _fusion_action(control)
    name_facts, name_command = _direct_replay(
        optimizer=args.optimizer.resolve(), architecture=data["architecture"],
        canonical=canonical, function=function, stage=FUSION_STAGE,
        output_dir=probe_root / "fusion-name-replay",
        action={"actions": [fusion_action]},
        max_partition_factor=max_partition_factor, artifact_root=artifact_root)
    fused_task = _compiler_fused_task_name(
        parent_facts, name_facts, control["first"], control["second"])
    requested_fusion_shape = (args.pc_fusion_shape if control["family"] == "fusion"
                              else "1x2")
    fusion_rows, fusion_cols = (int(part) for part in requested_fusion_shape.split("x"))
    actions = fusion_actions(control, fused_task,
                             shape_rows=fusion_rows, shape_cols=fusion_cols)
    facts, direct_command = _direct_replay(
        optimizer=args.optimizer.resolve(), architecture=data["architecture"],
        canonical=canonical, function=function, stage=FUSION_STAGE,
        output_dir=probe_root / "typed-action", action={"actions": actions},
        max_partition_factor=max_partition_factor, artifact_root=artifact_root)
    expected_memory = {"first": control["first"], "second": control["second"],
                       "fused": fused_task}
    before = body_statistics(canonical)
    transformed = body_statistics(probe_root / "typed-action/replay/candidate.mlir")
    try:
        parent_loads = before[expected_memory["first"]]["loads"] + before[expected_memory["second"]]["loads"]
        parent_stores = before[expected_memory["first"]]["stores"] + before[expected_memory["second"]]["stores"]
        fused_body = transformed[expected_memory["fused"]]
    except KeyError as error:
        raise ProbeError(f"C++ typed candidate lacks a task needed for operation statistics: {error}") from error
    if (parent_loads != control["expected_parent_loads"] or
            parent_stores != control["expected_parent_stores"]):
        raise ProbeError("canonical C++ parent body memory counts differ from the expected control")
    if (fused_body["loads"] != control["expected_fused_loads"] or
            fused_body["stores"] != control["expected_fused_stores"]):
        raise ProbeError("C++ fusion body did not produce the expected retained public-output memory counts")
    parent_source_tasks = _source_task_map(parent_facts)
    fused_source_tasks = _source_task_map(facts)
    if _compiler_fused_task_name(parent_facts, facts, control["first"],
                                 control["second"]) != fused_task:
        raise ProbeError("C++ shaped fusion replay changed the compiler-resolved task name")
    if any(task not in parent_source_tasks for task in
           (expected_memory["first"], expected_memory["second"])):
        raise ProbeError("canonical C++ replay facts omit a fusion parent source domain")
    if expected_memory["fused"] not in fused_source_tasks:
        raise ProbeError("C++ fusion replay facts omit the transformed fused source domain")
    if (any(parent_source_tasks[task].get("complete") is not True for task in
            (expected_memory["first"], expected_memory["second"])) or
            fused_source_tasks[expected_memory["fused"]].get("complete") is not True):
        raise ProbeError("C++ fusion source domains are not complete for all parent/fused tasks")
    seed_fact = facts
    diagnostic_protocol_path, diagnostic_protocol, budget_receipt = \
        _write_diagnostic_protocol(protocol_data, output_dir=probe_root,
                                   candidate_budget=2)
    source_binding_path = probe_root / "source-binding.json"
    binding = _source_binding(
        nr, protocol=diagnostic_protocol, protocol_path=diagnostic_protocol_path,
        canonical=canonical, optimizer=args.optimizer.resolve(),
        architecture=data["architecture"], model_cache=data["model_cache"],
        cost_cache=data["cost_cache"], parent_cost_file=data["parent_cost_file"],
        source_contract=source_contract, network=data["inter_task_network"],
        prepared_source=None, fission_cap=None)
    _write_json(source_binding_path, binding)
    selections, search_evidence = _run_search(
        nr=nr, optimizer=args.optimizer.resolve(), canonical=canonical,
        function=function, stage=FUSION_STAGE, architecture=data["architecture"],
        protocol=diagnostic_protocol, protocol_path=diagnostic_protocol_path,
        source_contract=source_contract, model_cache=data["model_cache"],
        cost_cache=data["cost_cache"], parent_cost_file=data["parent_cost_file"],
        network=data["inter_task_network"], workload=workload,
        seed_facts=[seed_fact], prepared_source=None, fission_cap=None,
        output_dir=probe_root, artifact_root=artifact_root,
        diagnostic_budget_receipt=budget_receipt)
    transformed_selection = _selected_row(selections, seed_fact)
    identity_controls = nr.load_cpp_controls(
        probe_root / "search/controls.jsonl", require_previous=False)
    identity = next((row for row in identity_controls if row["control_role"] == "identity"), None)
    if identity is None:
        raise ProbeError("C++ diagnostic search did not retain its identity control")
    resources_parent = _resource_count(identity)
    resources_fused = _resource_count(transformed_selection)
    if resources_parent != resources_fused:
        raise ProbeError(f"fusion whole-program CGRA counts differ: parent={resources_parent}, fused={resources_fused}")
    parent_costs = _task_cost_map(identity)
    fused_costs = _task_cost_map(transformed_selection)
    parent_shapes = {task: parent_costs[task].get("shape")
                     for task in (control["first"], control["second"])}
    fused_shape = fused_costs.get(expected_memory["fused"], {}).get("shape")
    if any(shape != {"rows": 1, "cols": 1} for shape in parent_shapes.values()):
        raise ProbeError(f"same-resource fusion parent tasks are not both 1x1: {parent_shapes}")
    expected_fused_shape = {"rows": fusion_rows, "cols": fusion_cols}
    if fused_shape != expected_fused_shape:
        raise ProbeError(f"C++ fused task shape is not the explicit control: {fused_shape}")
    parent_pair_resources = sum(shape["rows"] * shape["cols"]
                                for shape in parent_shapes.values() if shape)
    fused_task_resources = fused_shape["rows"] * fused_shape["cols"]
    if parent_pair_resources != fused_task_resources:
        raise ProbeError("fusion pair shape does not preserve targeted CGRA count")
    selected = [transformed_selection]
    replay_summary, numeric_command, numeric_records = _native_and_numeric(
        nr=nr, replay=replay, candidate_selections=selected,
        identity_control=identity, pair_controls=[],
        artifact_root=artifact_root, optimizer=args.optimizer.resolve(),
        llvm_build=args.llvm_build.resolve(),
        reference_root=data["reference_root"], architecture=data["architecture"],
        network=data["inter_task_network"], sram_config=data["sram_config"],
        mapping_cache=output_root / "mapper-cache" / workload,
        stage=FUSION_STAGE, workload=workload, canonical=canonical,
        function=function, protocol_path=diagnostic_protocol_path,
        source_contract=source_contract, source_binding=source_binding_path,
        prepared_source=None, max_partition_factor=max_partition_factor,
        fission_cap=None, output_dir=probe_root)
    native_records = {row["candidate_id"]: row for row in replay_summary["records"]}
    numeric_by_rank = {row.get("rank"): row for row in numeric_records}
    candidate_native = native_records.get(transformed_selection["candidate_id"], {})
    rank = transformed_selection["rank"]
    parent_rank = identity["rank"]
    parent_native = native_records.get(identity["candidate_id"], {})
    score_costs = _task_cost_map(transformed_selection)
    parent_score_costs = _task_cost_map(identity)
    candidate_ir = Path(transformed_selection["mapper_replay_path"])
    parent_ir = Path(identity["mapper_replay_path"])
    candidate_stats = body_statistics(candidate_ir)
    parent_candidate_stats = body_statistics(parent_ir)
    trace = _load_actual_trace(probe_root / "native", rank,
                               _load_module("controlled_probe_trace_validator",
                                            artifact_root / "scripts/validate_embedded_native_trace.py"))
    parent_trace = _load_actual_trace(probe_root / "native", parent_rank,
                                      _load_module("controlled_probe_trace_validator_parent",
                                                   artifact_root / "scripts/validate_embedded_native_trace.py"))
    native_record = _read_json(probe_root / f"native/rank-{rank}/result.json",
                               "native candidate result")
    numeric = numeric_by_rank.get(rank)
    result = {
        "schema": "orbit-controlled-fusion-fission-probe-v1",
        "status": "complete" if candidate_native.get("status") == "native_replayed" and
                  numeric and numeric.get("status") == "pass" else "incomplete",
        "diagnostic_only": True,
        "search_winner_claim": False,
        "workload": workload,
        "probe": control["label"],
        "kind": control["family"],
        "typed_actions": actions,
        "typed_action_history": transformed_selection.get("action_history"),
        "requested_fused_shape": expected_fused_shape,
        "parent_source_replay": {"facts": parent_facts, "command": parent_command},
        "fusion_name_discovery_replay": {"facts": name_facts,
                                         "command": name_command},
        "typed_replay_facts": facts,
        "typed_replay_command": direct_command,
        "fresh_score_search": search_evidence,
        "diagnostic_search_protocol": budget_receipt,
        "native_summary": replay_summary,
        "numeric_command": numeric_command,
        "numeric_gate": numeric,
        "resource_comparison": {"parent_task_pair_cgra_count": parent_pair_resources,
                                "fused_task_cgra_count": fused_task_resources,
                                "same_pair_resources": parent_pair_resources == fused_task_resources,
                                "whole_program_parent_cgra_count": resources_parent,
                                "whole_program_fused_cgra_count": resources_fused,
                                "same_total_resources": resources_parent == resources_fused,
                                "parent_task_shapes": parent_shapes,
                                "fused_shape": fused_shape},
        "memory_operations": {
            "parent_pair": {"loads": parent_loads, "stores": parent_stores,
                             "tasks": {task: before[task] for task in
                                       (expected_memory["first"], expected_memory["second"])},
                             "source_domains": {
                                 task: parent_source_tasks[task] for task in
                                 (expected_memory["first"], expected_memory["second"])}},
            "fused_task": {"task": expected_memory["fused"], **fused_body},
            "removed_loads": parent_loads - fused_body["loads"],
            "removed_stores": parent_stores - fused_body["stores"],
            "public_output_stores_preserved": fused_body["stores"] == parent_stores,
            "fused_source_domain": fused_source_tasks[expected_memory["fused"]],
        },
        "candidate": {
            "candidate_id": transformed_selection["candidate_id"],
            "rank": rank,
            "candidate_body_bytes": candidate_ir.stat().st_size,
            "task_bodies": candidate_stats,
            "task_costs_and_shapes": score_costs,
            "source_firings_and_domains": {
                "fused": fused_source_tasks[expected_memory["fused"]]},
            "predicted_cycles": transformed_selection["predicted_whole_program_cycles"],
            "native_cycles": candidate_native.get("native_cycles"),
            "replayed_communication_edges": transformed_selection.get(
                "replayed_communication_edges"),
            "communication_trace_known": transformed_selection.get(
                "communication_trace_known"),
            "numeric": native_record.get("numeric"),
            "mapper_equality": candidate_native.get("mapper_equality"),
            "trace": {"status": candidate_native.get("independent_trace"),
                      "dependencies": trace.get("dependencies"),
                      "routes": trace.get("routes"),
                      "actual_task_schedule": trace.get("task_schedule")},
        },
        "parent_identity": {"candidate_id": identity["candidate_id"],
                             "rank": parent_rank,
                             "candidate_body_bytes": parent_ir.stat().st_size,
                             "task_bodies": parent_candidate_stats,
                             "task_costs_and_shapes": parent_score_costs,
                             "source_firings_and_domains": {
                                 task: parent_source_tasks[task] for task in
                                 (expected_memory["first"], expected_memory["second"])},
                             "predicted_cycles": identity["predicted_whole_program_cycles"],
                             "native_cycles": parent_native.get("native_cycles"),
                             "numeric": numeric_by_rank.get(parent_rank, {}).get("status"),
                             "replayed_communication_edges": identity.get(
                                 "replayed_communication_edges"),
                             "communication_trace_known": identity.get(
                                 "communication_trace_known"),
                             "mapper_equality": parent_native.get("mapper_equality"),
                             "trace": {"status": parent_native.get("independent_trace"),
                                       "dependencies": parent_trace.get("dependencies"),
                                       "routes": parent_trace.get("routes"),
                                       "actual_task_schedule": parent_trace.get(
                                           "task_schedule")},
                             "resource_count": resources_parent},
        "negative_fixture_commands": negative_fixture_commands(args.optimizer,
                                                                  args.source_root),
        "existing_fixture_checks": args.fixture_check_evidence,
    }
    _write_json(probe_root / "result.json", result)
    if result["status"] != "complete":
        raise ProbeError(f"fusion native/numeric evidence incomplete for {control['label']}")
    return result


def _fission_probe(*, args: argparse.Namespace, nr: Any, replay: Any,
                   protocol_data: Mapping[str, Any], max_partition_factor: int,
                   fission_cap: int, artifact_root: Path,
                   source_contract: Path, output_root: Path) -> dict[str, Any]:
    workload = args.fission_workload
    data = load_workload_config(args.config, artifact_root, workload, args)
    canonical = data["canonical"]
    prepared = data["prepared_source_file"]
    if prepared is None:
        raise ProbeError(f"config has no prepared_source_file for fission workload {workload}")
    function = nr.infer_function(canonical, data.get("function"))
    probe_root = output_root / f"fission-{workload}"
    probe_root.mkdir(parents=True, exist_ok=False)
    census, census_command = _source_cut_census(
        optimizer=args.optimizer.resolve(), prepared_source=prepared,
        function=function, fission_cap=fission_cap,
        output_dir=probe_root / "census", artifact_root=artifact_root)
    parent_task, left_nodes = _first_legal_cut(census, args.fission_task)
    label = "fission:" + parent_task + ":left=" + ",".join(str(node) for node in left_nodes)
    fission_action = _typed_action(
        "fission", label,
        primitives=[_primitive("fission", parent_task, "", "", left_nodes=left_nodes)])
    # Split children each receive the default 1x1. Their parent comparison is
    # explicitly assigned 2x1, so both programs consume two CGRAs at the task.
    parent_facts, parent_command = _direct_replay(
        optimizer=args.optimizer.resolve(), architecture=data["architecture"],
        canonical=canonical, function=function, stage=FISSION_STAGE,
        output_dir=probe_root / "parent-control-replay",
        action={"actions": [shape_action(parent_task, 2, 1)]},
        max_partition_factor=max_partition_factor, artifact_root=artifact_root,
        prepared_source=prepared, fission_cap=fission_cap)
    split_facts, split_command = _direct_replay(
        optimizer=args.optimizer.resolve(), architecture=data["architecture"],
        canonical=canonical, function=function, stage=FISSION_STAGE,
        output_dir=probe_root / "fission-control-replay",
        action={"actions": [fission_action]},
        max_partition_factor=max_partition_factor, artifact_root=artifact_root,
        prepared_source=prepared, fission_cap=fission_cap)
    source_tasks = split_facts.get("tasks")
    if (not isinstance(source_tasks, list) or not source_tasks or
            any(not isinstance(row, dict) or row.get("complete") is not True
                for row in source_tasks)):
        raise ProbeError("C++ fission replay did not verify complete source domains for every child")
    children, fission_step = _verified_fission_children(
        parent_facts, split_facts, parent_task, left_nodes)

    diagnostic_protocol_path, diagnostic_protocol, budget_receipt = \
        _write_diagnostic_protocol(protocol_data, output_dir=probe_root,
                                   candidate_budget=3)
    binding_path = probe_root / "source-binding.json"
    binding = _source_binding(
        nr, protocol=diagnostic_protocol, protocol_path=diagnostic_protocol_path,
        canonical=canonical, optimizer=args.optimizer.resolve(),
        architecture=data["architecture"], model_cache=data["model_cache"],
        cost_cache=data["cost_cache"], parent_cost_file=data["parent_cost_file"],
        source_contract=source_contract, network=data["inter_task_network"],
        prepared_source=prepared, fission_cap=fission_cap)
    _write_json(binding_path, binding)
    selections, search_evidence = _run_search(
        nr=nr, optimizer=args.optimizer.resolve(), canonical=canonical,
        function=function, stage=FISSION_STAGE,
        architecture=data["architecture"], protocol=diagnostic_protocol,
        protocol_path=diagnostic_protocol_path, source_contract=source_contract,
        model_cache=data["model_cache"], cost_cache=data["cost_cache"],
        parent_cost_file=data["parent_cost_file"],
        network=data["inter_task_network"], workload=workload,
        seed_facts=[parent_facts, split_facts], prepared_source=prepared,
        fission_cap=fission_cap, output_dir=probe_root,
        artifact_root=artifact_root, diagnostic_budget_receipt=budget_receipt)
    parent_selection = _selected_row(selections, parent_facts)
    split_selection = _selected_row(selections, split_facts)
    parent_resources = _resource_count(parent_selection)
    child_resources = _resource_count(split_selection)
    if parent_resources != child_resources:
        raise ProbeError(f"fission controls differ in CGRA count: parent={parent_resources}, split={child_resources}")
    parent_score_map = _task_cost_map(parent_selection)
    score_map = _task_cost_map(split_selection)
    parent_task_shape = parent_score_map.get(parent_task, {}).get("shape")
    if parent_task_shape != {"rows": 2, "cols": 1}:
        raise ProbeError(f"fission parent is not the explicit 2x1 resource control: {parent_task_shape}")
    if any(score_map.get(row["task"], {}).get("shape") != {"rows": 1, "cols": 1}
           for row in children):
        raise ProbeError("fission child shapes are not the explicit 1x1 resource controls")
    parent_pair_resources = parent_task_shape["rows"] * parent_task_shape["cols"]
    child_pair_resources = sum(score_map[row["task"]]["shape"]["rows"] *
                               score_map[row["task"]]["shape"]["cols"]
                               for row in children)
    if parent_pair_resources != child_pair_resources:
        raise ProbeError("fission parent and split children consume different targeted CGRA counts")
    if split_selection.get("action_history", {}).get("fissionActions") == []:
        raise ProbeError("C++ fresh-score selection lost its typed source fission action")
    result_selection = [parent_selection, split_selection]
    replay_summary, numeric_command, numeric_records = _native_and_numeric(
        nr=nr, replay=replay, candidate_selections=result_selection,
        identity_control=None, pair_controls=[], artifact_root=artifact_root,
        optimizer=args.optimizer.resolve(), llvm_build=args.llvm_build.resolve(),
        reference_root=data["reference_root"], architecture=data["architecture"],
        network=data["inter_task_network"], sram_config=data["sram_config"],
        mapping_cache=output_root / "mapper-cache" / workload,
        stage=FISSION_STAGE, workload=workload, canonical=canonical,
        function=function, protocol_path=diagnostic_protocol_path,
        source_contract=source_contract, source_binding=binding_path,
        prepared_source=prepared, max_partition_factor=max_partition_factor,
        fission_cap=fission_cap, output_dir=probe_root)
    parent_path = Path(parent_selection["mapper_replay_path"])
    parent_stats = body_statistics(parent_path)
    split_path = Path(split_selection["mapper_replay_path"])
    split_stats = body_statistics(split_path)
    child_names = [str(row["task"]) for row in children]
    if parent_task not in parent_stats or any(name not in split_stats for name in child_names):
        raise ProbeError("generic C++ candidate is missing the original or actual child task body")
    native_by_id = {row["candidate_id"]: row for row in replay_summary["records"]}
    trace_validator = _load_module("controlled_probe_trace_validator_fission",
                                   artifact_root / "scripts/validate_embedded_native_trace.py")
    split_trace = _load_actual_trace(probe_root / "native", split_selection["rank"],
                                     trace_validator)
    parent_trace = _load_actual_trace(probe_root / "native", parent_selection["rank"],
                                      trace_validator)
    split_native = native_by_id.get(split_selection["candidate_id"], {})
    parent_native = native_by_id.get(parent_selection["candidate_id"], {})
    source_replay = split_native.get("source_fission_replay")
    if not isinstance(source_replay, dict) or source_replay.get("status") != "verified":
        raise ProbeError("native full-program replay did not preserve exact typed source-fission replay")
    numeric_by_rank = {row.get("rank"): row for row in numeric_records}
    child_costs = {
        name: {**(score_map.get(name) or {}),
               "source_firings": next(row.get("current_taskflow_firing_count")
                                      for row in children if row["task"] == name),
               "source_multiplicity": next(row.get("source_multiplicity")
                                           for row in children if row["task"] == name)}
        for name in child_names}
    result = {
        "schema": "orbit-controlled-fusion-fission-probe-v1",
        "status": "complete" if split_native.get("status") == "native_replayed" and
                  split_native.get("numeric") == "pass" else "incomplete",
        "diagnostic_only": True,
        "search_winner_claim": False,
        "workload": workload,
        "probe": f"fission-{workload}-{parent_task}",
        "kind": "source-fission",
        "selected_legal_cut": {"task": parent_task, "left_nodes": left_nodes,
                                "cut_count_for_task": next(
                                    row.get("legal_cut_count") for row in census["tasks"]
                                    if row.get("task") == parent_task)},
        "source_cut_census": census,
        "source_cut_census_command": census_command,
        "parent_control_replay": {"facts": parent_facts, "command": parent_command},
        "typed_action_history": split_selection.get("action_history"),
        "parent_control_action_history": parent_selection.get("action_history"),
        "source_fission_replay": {"facts": split_facts, "command": split_command,
                                   "child_source_facts": children,
                                   "coverage_and_no_duplication": {
                                       "status": "verified-by-C++-verifyTaskflowFissionReplay",
                                       "fission_source_replay_verified":
                                           split_facts["fission_source_replay_verified"],
                                       "exact_source_replay_step": fission_step,
                                       "typed_cut_action": split_facts[
                                           "action_history"]["fissionActions"][0],
                                       "child_source_partitions": [
                                           {"task": row["task"],
                                            "represented_multiplicity": row.get("represented_multiplicity"),
                                            "source_multiplicity": row.get("source_multiplicity"),
                                            "canonical_witness": row["canonical_witness"],
                                            "source_control_binding_present": True,
                                            "current_control_binding_present": True}
                                           for row in children]}},
        "fresh_score_search": search_evidence,
        "diagnostic_search_protocol": budget_receipt,
        "native_summary": replay_summary,
        "numeric_command": numeric_command,
        "resource_comparison": {"unsplit_parent_task_cgra_count": parent_pair_resources,
                                "split_children_cgra_count": child_pair_resources,
                                "same_task_resources": parent_pair_resources == child_pair_resources,
                                "whole_program_parent_cgra_count": parent_resources,
                                "whole_program_split_cgra_count": child_resources,
                                "same_total_resources": parent_resources == child_resources,
                                "unsplit_parent_shape": "2x1",
                                "split_child_shapes": {name: "1x1" for name in child_names}},
        "original_parent_body": {"task": parent_task,
                                  "candidate_body_bytes": parent_path.stat().st_size,
                                  **parent_stats[parent_task],
                                  "source_domain": next(
                                      row for row in parent_facts["tasks"]
                                      if row.get("task") == parent_task)},
        "actual_child_bodies_and_costs": {
            name: {"body": split_stats.get(name), "cost": child_costs.get(name),
                   "source_domain": next(row for row in children if row["task"] == name)}
            for name in child_names},
        "parent_control_candidate": {
            "candidate_id": parent_selection["candidate_id"],
            "rank": parent_selection["rank"],
            "candidate_body_bytes": parent_path.stat().st_size,
            "task_bodies": parent_stats,
            "task_costs_and_shapes": parent_score_map,
            "predicted_cycles": parent_selection["predicted_whole_program_cycles"],
            "native_cycles": parent_native.get("native_cycles"),
            "numeric": numeric_by_rank.get(parent_selection["rank"]),
            "replayed_communication_edges": parent_selection.get(
                "replayed_communication_edges"),
            "communication_trace_known": parent_selection.get(
                "communication_trace_known"),
            "mapper_equality": parent_native.get("mapper_equality"),
            "trace": {"status": parent_native.get("independent_trace"),
                      "dependencies": parent_trace.get("dependencies"),
                      "routes": parent_trace.get("routes"),
                      "actual_task_schedule": parent_trace.get("task_schedule")}},
        "candidate": {"candidate_id": split_selection["candidate_id"],
                       "rank": split_selection["rank"],
                       "candidate_body_bytes": split_path.stat().st_size,
                       "predicted_cycles": split_selection["predicted_whole_program_cycles"],
                       "native_cycles": split_native.get("native_cycles"),
                       "native_numeric": numeric_by_rank.get(split_selection["rank"]),
                       "replayed_communication_edges": split_selection.get(
                           "replayed_communication_edges"),
                       "communication_trace_known": split_selection.get(
                           "communication_trace_known"),
                       "mapper_equality": split_native.get("mapper_equality"),
                       "typed_source_replay": source_replay,
                       "trace": {"status": split_native.get("independent_trace"),
                                 "dependencies": split_trace.get("dependencies"),
                                 "routes": split_trace.get("routes"),
                                 "actual_task_schedule": split_trace.get("task_schedule")}},
        "negative_fixture_commands": negative_fixture_commands(args.optimizer,
                                                                  args.source_root),
        "existing_fixture_checks": args.fixture_check_evidence,
    }
    _write_json(probe_root / "result.json", result)
    if result["status"] != "complete":
        raise ProbeError("fission full-program native/numeric/trace evidence is incomplete")
    return result


def negative_fixture_commands(optimizer: Path, source_root: Path) -> list[dict[str, Any]]:
    directory = source_root / "test/multi-cgra/taskflow/joint-scheduling"
    tests = [
        ("fission-task-source-reject-alias.mlir",
         "builtin.module(func.func(fission-task{task-name=Alias left-nodes=0}))"),
        ("fission-task-source-reject-effect.mlir",
         "builtin.module(func.func(fission-task{task-name=Effect left-nodes=0:1}))"),
        ("fission-task-source-reject-stale-domain.mlir",
         "builtin.module(func.func(fission-task{task-name=Stale left-nodes=0:1}))"),
        ("source-iteration-domain-forged-proof.mlir",
         "builtin.module(bind-source-iteration-domain)"),
    ]
    return [{"status": "scheduled-by-this-harness", "fixture": str(directory / name),
             "argv": [str(optimizer), str(directory / name),
                      f"--pass-pipeline={pipeline}", "--verify-diagnostics", "-o", "/dev/null"]}
            for name, pipeline in tests]


def run_existing_fixture_checks(*, source_root: Path,
                                optimizer: Path, output_root: Path,
                                artifact_root: Path) -> list[dict[str, Any]]:
    """Run the existing C++-backed forwarding and fission proof checkers."""
    test_dir = source_root / "test/multi-cgra/taskflow/joint-scheduling"
    forwarding_checker = test_dir / "run-producer-consumer-composite-source-domain-checks.py"
    forwarding_fixture = test_dir / "producer-consumer-composite-source-domain.mlir"
    if not forwarding_checker.is_file() or not forwarding_fixture.is_file():
        raise ProbeError(f"source checkout lacks the forwarded-fusion proof fixture: {test_dir}")
    reject_commands = negative_fixture_commands(optimizer, source_root)
    reject_fixtures = [Path(row["fixture"]) for row in reject_commands]
    missing = [path for path in reject_fixtures if not path.is_file()]
    if missing:
        raise ProbeError("source checkout lacks required negative fixtures: " +
                         ", ".join(str(path) for path in missing))

    checks = []
    forward_record = _run_logged(
        [sys.executable, str(forwarding_checker), str(forwarding_fixture), str(optimizer)],
        output_root, "forwarded-fusion-source-domain-checks", artifact_root)
    checks.append({"kind": "forwarded-private-store-load-positive-and-tamper-negatives",
                   "status": "pass" if forward_record.get("exit_code") == 0 else "fail",
                   "command": forward_record})
    negative_evidence = []
    for index, row in enumerate(reject_commands):
        record = _run_logged(row["argv"], output_root,
                             f"fission-source-negative-{index + 1}", artifact_root)
        negative_evidence.append({"fixture": row["fixture"],
                                  "status": "pass" if record.get("exit_code") == 0 else "fail",
                                  "command": record})
    checks.append({"kind": "forged-metadata-alias-effect-stale-domain-negatives",
                   "status": "pass" if all(row["status"] == "pass"
                                            for row in negative_evidence) else "fail",
                   "fixtures": negative_evidence})
    return checks


def _parse_args(argv: Sequence[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--artifact-root", "--artifactroot", dest="artifact_root",
                        type=Path, required=True)
    parser.add_argument("--source-root", type=Path, required=True,
                        help="source checkout containing native fixture tests")
    parser.add_argument("--source-pin", "--pin", dest="source_pin", required=True,
                        help="must exactly match protocol source_commit")
    parser.add_argument("--optimizer", type=Path, required=True)
    parser.add_argument("--source-contract", "--source-contract-file", "--contract",
                        dest="source_contract", type=Path, required=True)
    parser.add_argument("--protocol", type=Path, required=True)
    parser.add_argument("--config", type=Path, required=True,
                        help="per-workload canonical/prepared-source/parent-cost config")
    parser.add_argument("--llvm-build", "--llvm", dest="llvm_build",
                        type=Path, required=True)
    parser.add_argument("--output-root", "--output", dest="output_root",
                        type=Path, required=True,
                        help="must be a fresh diagnostic-only result root")
    parser.add_argument("--architecture", type=Path)
    parser.add_argument("--inter-task-network", type=Path)
    parser.add_argument("--sram-config", type=Path)
    parser.add_argument("--reference-root", type=Path)
    parser.add_argument("--fission-workload", choices=("lu", "harris"), default="lu")
    parser.add_argument("--fission-task", default="Task_0")
    parser.add_argument("--pc-fusion-shape", choices=("1x2", "2x1"), default="1x2",
                        help="same-two-CGRA orientation for the Harris/Radar PC controls; sibling stays 1x2")
    parser.add_argument("--skip-fission", action="store_true")
    parser.add_argument("--skip-fusion", action="store_true")
    return parser.parse_args(argv)


def run(args: argparse.Namespace) -> int:
    artifact_root = args.artifact_root.resolve()
    args.source_root = args.source_root.resolve()
    args.config = args.config.resolve()
    args.protocol = args.protocol.resolve()
    args.source_contract = args.source_contract.resolve()
    args.optimizer = args.optimizer.resolve()
    args.llvm_build = args.llvm_build.resolve()
    if not artifact_root.is_dir():
        raise ProbeError(f"artifact root does not exist: {artifact_root}")
    if SCRIPT_ROOT.resolve() != artifact_root:
        raise ProbeError("--artifact-root must be the checkout containing this script and C++ replay helpers")
    if not (args.source_root / "test/multi-cgra/taskflow/joint-scheduling").is_dir():
        raise ProbeError(f"--source-root has no joint-scheduling fixtures: {args.source_root}")
    _regular_file(args.optimizer, "pinned optimizer", executable=True)
    _regular_file(args.source_contract, "source contract")
    _regular_file(args.protocol, "protocol")
    _regular_file(args.config, "probe config")
    if not args.llvm_build.is_dir():
        raise ProbeError(f"LLVM build directory does not exist: {args.llvm_build}")
    _regular_file(args.llvm_build / "bin/mlir-opt", "LLVM mlir-opt", executable=True)
    bound = _source_contract_checks(args.protocol, args.source_pin)
    protocol_data = bound["protocol"]
    max_partition_factor = bound["max_partition_factor"]
    fission_cap = bound["fission_cap"]
    output_root = args.output_root.resolve()
    if args.output_root.is_symlink():
        raise ProbeError(f"output root must not be a symlink: {args.output_root}")
    if output_root.exists():
        if not output_root.is_dir() or any(output_root.iterdir()):
            raise ProbeError(f"output root must be new and empty: {output_root}")
    else:
        output_root.mkdir(parents=True)
    nr, replay = _helpers(artifact_root)
    header = {
        "schema": "orbit-controlled-fusion-fission-probes-v1",
        "status": "running",
        "diagnostic_only": True,
        "search_winner_claim": False,
        "artifact_root": str(artifact_root),
        "source_root": str(args.source_root),
        "source_pin": args.source_pin,
        "optimizer": str(args.optimizer),
        "source_contract": str(args.source_contract),
        "protocol": str(args.protocol),
        "config": str(args.config),
        "llvm_build": str(args.llvm_build),
        "output_root": str(output_root),
        "pc_fusion_shape": args.pc_fusion_shape,
        "main_curve_budget_changed": False,
        "negative_fixture_commands": negative_fixture_commands(args.optimizer,
                                                                  args.source_root),
        "controls": [],
    }
    _write_json(output_root / "run.json", header)
    try:
        args.fixture_check_evidence = run_existing_fixture_checks(
            source_root=args.source_root,
            optimizer=args.optimizer, output_root=output_root,
            artifact_root=artifact_root)
    except Exception as error:
        header.update(status="incomplete",
                      fixture_check_failure=f"{type(error).__name__}: {error}",
                      fixture_check_evidence=getattr(args, "fixture_check_evidence", []))
        _write_json(output_root / "run.json", header)
        raise
    header["fixture_check_evidence"] = args.fixture_check_evidence
    _write_json(output_root / "run.json", header)
    if any(row["status"] != "pass" for row in args.fixture_check_evidence):
        header.update(status="incomplete",
                      fixture_check_failure="one or more existing native fixtures failed")
        _write_json(output_root / "run.json", header)
        failures = [row for row in args.fixture_check_evidence
                    if row["status"] != "pass"]
        print(f"controlled fusion/fission fixture checks failed ({len(failures)}):",
              file=sys.stderr)
        for row in failures:
            detail = row.get("failure")
            nested = row.get("fixtures")
            if isinstance(nested, list):
                failed = [
                    f"{Path(item.get('fixture', 'fixture')).name} "
                    f"(exit {item.get('command', {}).get('exit_code')})"
                    for item in nested if item.get("status") != "pass"
                ]
                detail = ", ".join(failed) or detail
            command = row.get("command")
            if detail is None and isinstance(command, dict):
                detail = f"exit {command.get('exit_code')}"
            print(f"  - {row.get('kind', 'fixture')}: "
                  f"{detail or row.get('status')}", file=sys.stderr)
        return 1
    errors: list[str] = []
    results: list[dict[str, Any]] = []
    if not args.skip_fusion:
        for name, control in WORKLOAD_CONTROLS.items():
            try:
                value = _fusion_probe(
                    name=name, control=control, args=args, nr=nr, replay=replay,
                    protocol_data=protocol_data,
                    max_partition_factor=max_partition_factor,
                    artifact_root=artifact_root, source_contract=args.source_contract,
                    output_root=output_root)
                results.append(value)
            except Exception as error:
                label = str(control["label"])
                result = {"schema": "orbit-controlled-fusion-fission-probe-v1",
                          "status": "failed", "diagnostic_only": True,
                          "search_winner_claim": False, "probe": label,
                          "failure": f"{type(error).__name__}: {error}"}
                probe_dir = output_root / label
                probe_dir.mkdir(parents=True, exist_ok=True)
                _write_json(probe_dir / "result.json", result)
                results.append(result)
                errors.append(f"{label}: {error}")
    if not args.skip_fission:
        try:
            value = _fission_probe(
                args=args, nr=nr, replay=replay, protocol_data=protocol_data,
                max_partition_factor=max_partition_factor, fission_cap=fission_cap,
                artifact_root=artifact_root, source_contract=args.source_contract,
                output_root=output_root)
            results.append(value)
        except Exception as error:
            label = f"fission-{args.fission_workload}"
            probe_dir = output_root / label
            probe_dir.mkdir(parents=True, exist_ok=True)
            failure = {"schema": "orbit-controlled-fusion-fission-probe-v1",
                       "status": "failed", "diagnostic_only": True,
                       "search_winner_claim": False, "probe": label,
                       "failure": f"{type(error).__name__}: {error}"}
            _write_json(probe_dir / "result.json", failure)
            results.append(failure)
            errors.append(f"{label}: {error}")
    header.update(status="complete" if not errors else "incomplete",
                  controls=results, failures=errors)
    _write_json(output_root / "run.json", header)
    if errors:
        print(f"controlled fusion/fission probes failed ({len(errors)}):",
              file=sys.stderr)
        for error in errors:
            print(f"  - {error}", file=sys.stderr)
    return 0 if not errors else 1


def main(argv: Sequence[str] | None = None) -> int:
    args = _parse_args(argv)
    try:
        return run(args)
    except (ProbeError, OSError, ValueError, KeyError, TypeError) as error:
        print(f"controlled fusion/fission probes failed: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
