#!/usr/bin/env python3
"""Run one budgeted C++ neighborhood stage and its native evidence.

The C++ ``search-joint-neighborhood`` pass owns candidate generation,
materialization, production scheduling, canonical deduplication, archive
ordering, and the five-record shortlist.  This launcher only supplies the
canonical input, resumes a checkpoint, and replays the records emitted by the
pass.  It never constructs a Cartesian product or sorts an archive in Python.

The pass output contract consumed here is intentionally close to the existing
``orbit-global-stage-top5-v1`` contract:

* ``global-top5.jsonl`` has one header, five ``record_type=selection`` rows,
  and one footer.  The row order and ranks are owned by C++ and are preserved.
* ``controls.jsonl`` has ``record_type=control`` rows for ``identity`` and,
  when supplied, ``previous_stage_measured_winner``.  These are replayed
  outside the top-five ranks.
* a row carries ``candidate_path``, ``score_file``, ``shape_manifest_file``,
  ``shape_candidate_id``, and a nested ``score_record``.  Legacy path aliases
  are accepted only when the C++ row supplies them explicitly.

The launcher delegates actual mapper/native work to the existing replay
implementation.  A mapper failure is retained in its rank directory and does
not stop the remaining records.
"""
from __future__ import annotations

import argparse
import importlib.util
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from types import SimpleNamespace
from typing import Any, Mapping, Sequence


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_OPT = ROOT / ".work/mainline-tools/mlir-amoeba-opt"
DEFAULT_ARCH = ROOT / "config/architectures/amoeba_4x4_full_mesh_context12.yaml"
DEFAULT_PROTOCOL = ROOT / ".work/input0-neighborhood-publication/protocol.json"
DEFAULT_MAPPING_CACHE = ROOT / ".work/input0-task-mapping-cache"
DEFAULT_SRAM_CONFIG = ROOT / "config/architectures/amoeba_4x4_vectorcgra_sram.json"
DEFAULT_NUMERIC_GATE = ROOT / "scripts/run_input0_numeric.py"
DEFAULT_NUMERIC_REFERENCE_ROOT = ROOT / ".work/selected-native-numeric-gate"
DEFAULT_LLAMA_HARNESS = ROOT / ".work/cpp-gate-continuation-agent/source/replica-validation/task0-task1-k2.runner.mlir"
REPLAY_SCRIPT = ROOT / "scripts/replay_cpp_global_top5.py"

STAGES = (
    "shape-only",
    "shape-temporal",
    "shape-temporal-replica",
    "shape-temporal-replica-tiling",
    "full-joint",
)


class ContractError(RuntimeError):
    """The C++/replay evidence contract is incomplete or inconsistent."""


def atomic_write(path: Path, value: Any) -> None:
    """Write a JSON value atomically and let write errors propagate."""
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + ".partial")
    temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
    temporary.replace(path)


def read_jsonl(path: Path) -> list[dict[str, Any]]:
    records: list[dict[str, Any]] = []
    for line_number, line in enumerate(path.read_text().splitlines(), 1):
        if not line.strip():
            continue
        value = json.loads(line)
        if not isinstance(value, dict):
            raise ContractError(f"{path}:{line_number}: expected JSON object")
        records.append(value)
    return records


def infer_function(canonical: Path, explicit: str | None) -> str:
    if explicit:
        return explicit
    text = canonical.read_text()
    match = re.search(r"\bfunc\.func\s+(?:public\s+)?@([^\s(]+)", text)
    if match:
        return match.group(1)
    # Source-domain preparation emits generic operation syntax. Its nested
    # proof witnesses escape quoted symbols, so only actual symbol attributes
    # are considered here. Ambiguous modules still require an explicit name.
    if text.count('"func.func"()') == 1:
        names = re.findall(r'\bsym_name\s*=\s*"([^"\n]+)"', text)
        if len(names) == 1:
            return names[0]
    raise ContractError(f"cannot infer MLIR function from {canonical}; pass --function")


def source_binding(protocol: Mapping[str, Any], canonical: Path, optimizer: Path,
                   architecture: Path, model_cache: Path | None,
                   cost_cache: Path | None,
                   parent_cost_file: Path | None = None,
                   source_contract_file: Path | None = None,
                   inter_task_network: Path | None = None) -> dict[str, Any]:
    """Record reproducibility inputs without introducing a hash identity."""
    binding = {
        "schema": "orbit-neighborhood-source-binding-v1",
        "canonical_program": str(canonical.resolve()),
        "optimizer": str(optimizer.resolve()),
        "architecture": str(architecture.resolve()),
        "model_cache": str(model_cache.resolve()) if model_cache else None,
        "cost_cache": str(cost_cache.resolve()) if cost_cache else None,
        "parent_cost_file": str(parent_cost_file.resolve()) if parent_cost_file else None,
        "source_contract_file": str(source_contract_file.resolve()) if source_contract_file else None,
        "source_commit": protocol.get("source_commit"),
        "protocol_schema": protocol.get("schema"),
        "identity_policy": "exact source/byte/path binding; no SHA-256",
    }
    if inter_task_network:
        binding["inter_task_network"] = str(inter_task_network.resolve())
        binding["inter_task_network_text"] = inter_task_network.read_text()
    return binding


def _run_logged(argv: Sequence[str], directory: Path, label: str,
                *, env: Mapping[str, str] | None = None) -> dict[str, Any]:
    """Run a persistent subprocess with durable stdout/stderr and no timeout."""
    directory.mkdir(parents=True, exist_ok=True)
    command_path = directory / f"{label}.command.json"
    command = {
        "schema": "orbit-neighborhood-command-v1",
        "argv": [str(item) for item in argv],
        "status": "running",
        "started_unix": time.time(),
        "subprocess_timeout": None,
        "stdout": str(directory / f"{label}.stdout.log"),
        "stderr": str(directory / f"{label}.stderr.log"),
    }
    atomic_write(command_path, command)
    with Path(command["stdout"]).open("w") as stdout, Path(command["stderr"]).open("w") as stderr:
        process = subprocess.run([str(item) for item in argv], cwd=ROOT,
                                 stdout=stdout, stderr=stderr,
                                 env=dict(env) if env is not None else None)
    command.update(status="finished", exit_code=process.returncode,
                   ended_unix=time.time())
    atomic_write(command_path, command)
    return command


def build_search_command(*, optimizer: Path, canonical: Path, output_dir: Path,
                         function: str, stage: str, architecture: Path,
                         protocol: Mapping[str, Any], checkpoint: Path,
                         seed_manifest: Path | None, previous_winner: Path | None,
                         parent_cost_file: Path | None, model_cache: Path | None,
                         cost_cache: Path | None,
                         max_rounds: int, max_candidates: int,
                         beam_width: int, diversity_slots: int,
                         resume: Path | None, protocol_path: Path | None = None,
                         source_contract_file: Path | None = None,
                         historical_native_winner: Path | None = None,
                         workload: str | None = None,
                         inter_task_network: Path | None = None,
                         decision_flow: str = "legacy",
                         graph_budget_percent: int = 50) -> list[str]:
    """Build the sole C++ search invocation."""
    search_options = [
        f"output-dir={output_dir}",
        f"function={function}",
        f"stage={stage}",
        f"architecture-path={architecture}",
        f"source-repository={protocol.get('source_git_repository', '')}",
        f"source-commit={protocol.get('source_commit', '')}",
        f"max-rounds={max_rounds}",
        f"max-candidates={max_candidates}",
        f"beam-width={beam_width}",
        f"diversity-slots={diversity_slots}",
        f"checkpoint={checkpoint}",
    ]
    if decision_flow != "legacy":
        if decision_flow not in {"joint", "sequential"}:
            raise ContractError(f"unknown decision flow: {decision_flow}")
        if stage != "full-joint" or previous_winner or seed_manifest or historical_native_winner:
            raise ContractError("standalone decision flows require full-joint and a common unseeded identity")
        if graph_budget_percent not in {25, 50, 75}:
            raise ContractError("graph budget percent must be 25, 50 or 75")
        search_options.extend([f"decision-flow={decision_flow}",
                               f"graph-budget-percent={graph_budget_percent}"])
    if protocol.get("model_namespace"):
        search_options.append("model-namespace=" + protocol["model_namespace"])
    # New profiles explicitly bind execution and partition caps. The frozen
    # v11 protocol omits these options and keeps its original invocation.
    execution = protocol.get("execution", {})
    search = protocol.get("search", {})
    if "supported_shape_bootstrap_policy" in search:
        bootstrap_policy = search["supported_shape_bootstrap_policy"]
        if bootstrap_policy != "minimum-area-supported-model-shape-v1":
            raise ContractError(
                "unsupported supported_shape_bootstrap_policy: "
                f"{bootstrap_policy!r}"
            )
        search_options.append("bootstrap-supported-shapes=true")
    if "scoring_workers" in execution:
        workers = execution["scoring_workers"]
        if not isinstance(workers, int) or isinstance(workers, bool) or not 1 <= workers <= 12:
            raise ContractError("protocol scoring_workers must be an integer from 1 to 12")
        search_options.append(f"scoring-workers={workers}")
    if "max_partition_factor" in search:
        cap = search["max_partition_factor"]
        if cap not in (4, 8) or isinstance(cap, bool):
            raise ContractError("protocol max_partition_factor must be 4 or 8")
        search_options.append(f"max-partition-factor={cap}")
    if protocol.get("source_iteration_domain", {}).get("required", False):
        search_options.append("require-source-iteration-domain=true")
    if protocol_path:
        search_options.append(f"protocol={protocol_path}")
    if source_contract_file:
        search_options.append(f"source-contract-file={source_contract_file}")
    active = search.get("active_transfer_arguments_by_workload", {}).get(
        workload, search.get("active_transfer_arguments", []))
    if active:
        if not isinstance(active, list) or any(not isinstance(x, int) or isinstance(x, bool) or x < 0 for x in active) or len(set(active)) != len(active):
            raise ContractError("active_transfer_arguments must be unique nonnegative integer indexes")
        search_options.append("active-transfer-arguments=" + ",".join(str(x) for x in active))
        search_options.append("active-transfer-require-proven=" + ("true" if search.get("active_transfer_require_proven", True) else "false"))
    if historical_native_winner:
        search_options.append(f"historical-native-winner={historical_native_winner}")
    if parent_cost_file:
        search_options.append(f"parent-cost-file={parent_cost_file}")
    if seed_manifest:
        search_options.append(f"seed-manifest={seed_manifest}")
    if previous_winner:
        search_options.append(f"previous-winner={previous_winner}")
    if model_cache:
        search_options.append(f"model={model_cache}")
    if cost_cache:
        search_options.append(f"cache={cost_cache}")
    if resume:
        # The source pass uses a boolean resume option; checkpoint carries the
        # exact file path.  Passing resume=<path> would be parsed as a bool
        # error and would silently defeat continuation.
        search_options.append("resume=true")
    command = [str(optimizer), str(canonical), "--verify-each",
            f"--architecture-spec={architecture}",
            "--search-joint-neighborhood=" + " ".join(search_options),
            "-o", str(output_dir / "search-output.mlir")]
    if inter_task_network is not None:
        command.append(f"--joint-inter-task-network-spec={inter_task_network}")
    return command


def _row_path(row: Mapping[str, Any], key: str, aliases: Sequence[str]) -> str | None:
    value = row.get(key)
    if value:
        return str(value)
    for alias in aliases:
        values = row.get(alias)
        if isinstance(values, list) and values:
            return str(values[0])
        if values:
            return str(values)
    return None


def normalize_selection(row: Mapping[str, Any], *, default_graph_manifests: Path | None = None,
                        control_role: str | None = None,
                        rank: int | None = None) -> dict[str, Any]:
    """Validate/alias one C++ row without changing its archive order."""
    if row.get("record_type") not in {"selection", "control"}:
        raise ContractError(f"candidate row is not a selection/control: {row.get('record_type')!r}")
    result = dict(row)
    if rank is not None:
        result["rank"] = rank
    elif "rank" not in result and control_role is None:
        raise ContractError("selection row has no compiler-owned rank")
    result["candidate_id"] = str(result.get("candidate_id", ""))
    result["graph_variant_id"] = str(result.get("graph_variant_id", result.get("semantic_graph_id", "")))
    if not result["candidate_id"] or not result["graph_variant_id"]:
        raise ContractError("candidate row lacks candidate_id or graph_variant_id")
    score_record = result.get("score_record")
    if not isinstance(score_record, dict):
        score_record = result.get("score")
    if not isinstance(score_record, dict):
        raise ContractError(f"{result['candidate_id']} has no source-owned score_record")
    result["score_record"] = score_record
    result["score_file_path"] = _row_path(
        result, "score_file_path", ("score_file", "score_file_paths"))
    result["mapper_replay_path"] = _row_path(
        result, "mapper_replay_path", ("candidate_path", "mapper_replay_paths"))
    result["shape_manifest_file"] = _row_path(
        result, "shape_manifest_file", ("candidate_manifest", "shape_manifest_paths"))
    if (not result["score_file_path"] or not result["mapper_replay_path"] or
            not result["shape_manifest_file"]):
        raise ContractError(
            f"{result['candidate_id']} lacks source-owned score_file, shape_manifest_file, or candidate_path")
    shape_candidate_id = result.get("shape_candidate_id", score_record.get("shape_candidate_id"))
    if not shape_candidate_id:
        raise ContractError(f"{result['candidate_id']} lacks source-owned shape_candidate_id")
    result["shape_candidate_id"] = str(shape_candidate_id)
    score_record["shape_candidate_id"] = result["shape_candidate_id"]
    # Keep the canonical field names expected by the existing mapper replay;
    # these are aliases only, never Python-generated score or manifest data.
    result["candidate_manifest"] = result["shape_manifest_file"]
    if "predicted_whole_program_cycles" not in result:
        result["predicted_whole_program_cycles"] = score_record.get("predicted_whole_program_cycles")
    if result["predicted_whole_program_cycles"] is None:
        raise ContractError(f"{result['candidate_id']} lacks predicted whole-program cycles")
    if "certified" not in result:
        result["certified"] = bool(result.get("complete", False))
    if control_role:
        result["control_role"] = control_role
    if default_graph_manifests and "graph_manifests" not in result:
        result["graph_manifests"] = str(default_graph_manifests)
    return result


def load_cpp_selections(path: Path) -> tuple[list[dict[str, Any]], dict[str, Any], dict[str, Any]]:
    """Load exactly the five C++ selections, preserving row order."""
    rows = read_jsonl(path)
    selected = [row for row in rows if row.get("record_type") == "selection"]
    if len(selected) != 5:
        raise ContractError(f"{path}: expected exactly five C++ selections, found {len(selected)}")
    normalized: list[dict[str, Any]] = []
    seen: set[tuple[str, str]] = set()
    for row in selected:
        value = normalize_selection(row)
        key = (value["graph_variant_id"], value["candidate_id"])
        if key in seen:
            raise ContractError(f"duplicate C++ selection {key}")
        seen.add(key)
        normalized.append(value)
    # Do not sort: the source-owned ranks and order are the evidence.
    ranks = [row.get("rank") for row in normalized]
    if any(not isinstance(rank, int) for rank in ranks) or set(ranks) != set(range(5)):
        raise ContractError(f"C++ shortlist ranks must be 0..4, got {ranks!r}")
    header = next((row for row in rows if row.get("record_type") == "header"), {})
    footer = next((row for row in reversed(rows) if row.get("record_type") == "footer"), {})
    return normalized, header, footer


def load_cpp_controls(path: Path, *, require_previous: bool) -> list[dict[str, Any]]:
    if not path.is_file():
        raise ContractError(f"C++ controls file is missing: {path}")
    rows = [row for row in read_jsonl(path) if row.get("record_type") == "control"]
    by_role: dict[str, dict[str, Any]] = {}
    next_rank = 5
    for row in rows:
        role = str(row.get("control_role", row.get("role", "")))
        if role in {"identity", "canonical_identity"}:
            role = "identity"
        elif role in {"previous_winner", "previous_stage_winner", "previous_stage_measured_winner"}:
            role = "previous_stage_measured_winner"
        if role not in {"identity", "previous_stage_measured_winner", "historical_measured_winner", "search_anchor"}:
            raise ContractError(f"unsupported control role {role!r} in {path}")
        if role in by_role:
            raise ContractError(f"duplicate control role {role!r} in {path}")
        by_role[role] = normalize_selection(row, control_role=role, rank=next_rank)
        next_rank += 1
    required = {"identity"}
    if require_previous:
        required.add("previous_stage_measured_winner")
    missing = required - set(by_role)
    if missing:
        raise ContractError(f"C++ controls file missing required roles: {sorted(missing)}")
    # This fixed role order is a replay label, not a performance order.
    return [by_role[role] for role in ("identity", "previous_stage_measured_winner", "historical_measured_winner", "search_anchor") if role in by_role]


def _load_replay_module():
    spec = importlib.util.spec_from_file_location("orbit_cpp_global_replay", REPLAY_SCRIPT)
    if spec is None or spec.loader is None:
        raise ContractError(f"cannot import replay helper {REPLAY_SCRIPT}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def _replay_args(*, optimizer: Path, architecture: Path, mapping_cache: Path,
                 output_dir: Path, graph_manifests: Path | None,
                 manifest: Path, sram_config: Path,
                 inter_task_network: Path | None = None,
                 audit_mapper_calls: bool = False) -> SimpleNamespace:
    return SimpleNamespace(optimizer=optimizer, architecture=architecture,
                           mapping_cache=mapping_cache, output_dir=output_dir,
                           graph_manifests=graph_manifests, manifest=manifest,
                           sram_config=sram_config, reuse_mapped_root=None,
                           jobs=1, inter_task_network=inter_task_network,
                           audit_mapper_calls=audit_mapper_calls)


def replay_one(selection: Mapping[str, Any], *, replay_module: Any,
               replay_args: SimpleNamespace, output_dir: Path) -> dict[str, Any]:
    """Replay one selection/control and retain exceptions as evidence."""
    result_dir = output_dir / f"rank-{selection['rank']}"
    try:
        per_record_args = SimpleNamespace(**vars(replay_args))
        per_record_args.output_dir = output_dir
        # Each complete candidate is bound to the C++-emitted shape manifest.
        # This prevents a Python fallback to the identity manifest for a
        # rewritten graph.
        per_record_args.manifest = Path(selection["shape_manifest_file"])
        value = replay_module.replay(dict(selection),
                                     per_record_args)
        value["control_role"] = selection.get("control_role")
        if value.get("status") == "native_replayed" and (
                value.get("mapper_equality") != "pass" or
                value.get("independent_trace") != "pass"):
            value.update(status="incomplete", blocker="required_mapper_or_trace_evidence_failed")
        atomic_write(result_dir / "result.json", value)
        return value
    except Exception as exc:  # mapper/trace failures must not poison siblings
        value = {
            "schema": "orbit-neighborhood-native-record-v1",
            "rank": selection.get("rank"),
            "candidate_id": selection.get("candidate_id"),
            "graph_variant_id": selection.get("graph_variant_id"),
            "control_role": selection.get("control_role"),
            "predicted_cycles": selection.get("predicted_whole_program_cycles"),
            "status": "incomplete",
            "production_ready": False,
            "numeric": "pending",
            "independent_trace": "pending",
            "mapper_equality": "pending",
            "sram_gate": "pending",
            "blocker": f"replay_exception: {type(exc).__name__}: {exc}",
        }
        atomic_write(result_dir / "result.json", value)
        return value


def replay_records(records: Sequence[Mapping[str, Any]], *, output_dir: Path,
                   optimizer: Path, architecture: Path, mapping_cache: Path,
                   manifest: Path, graph_manifests: Path | None,
                   sram_config: Path, jobs: int,
                   inter_task_network: Path | None = None,
                   audit_mapper_calls: bool = False) -> dict[str, Any]:
    replay_module = _load_replay_module()
    args = _replay_args(optimizer=optimizer, architecture=architecture,
                        mapping_cache=mapping_cache, output_dir=output_dir,
                        graph_manifests=graph_manifests, manifest=manifest,
                        sram_config=sram_config, inter_task_network=inter_task_network,
                        audit_mapper_calls=audit_mapper_calls)
    output_dir.mkdir(parents=True, exist_ok=True)
    values: list[dict[str, Any]] = []
    order = {(row.get("control_role"), row.get("rank"), row.get("candidate_id")): index
             for index, row in enumerate(records)}
    with ThreadPoolExecutor(max_workers=max(1, jobs)) as pool:
        pending = [pool.submit(replay_one, row, replay_module=replay_module,
                               replay_args=args, output_dir=output_dir)
                   for row in records]
        for future in as_completed(pending):
            values.append(future.result())
            atomic_write(output_dir / "summary.json",
                         {"schema": "orbit-neighborhood-native-summary-v1",
                          "status": "running", "records": values,
                          "production_ready": False})
    # This is record aggregation only; candidate ranking remains C++ owned.
    # Keep the C++ shortlist/control order in the machine record.  This is an
    # evidence ordering operation, never a cost sort.
    values.sort(key=lambda value: order.get(
        (value.get("control_role"), value.get("rank"), value.get("candidate_id")),
        len(order)))
    complete = bool(values) and all(value.get("status") == "native_replayed" for value in values)
    summary = {
        "schema": "orbit-neighborhood-native-summary-v1",
        "status": "native_replayed" if complete else "incomplete",
        "records": values,
        "production_ready": False,
        "numeric": "pending",
        "sram_gate": ("pass" if values and all(value.get("sram_gate") == "pass" for value in values)
                       else "fail" if any(value.get("sram_gate") == "fail" for value in values)
                       else "pending"),
    }
    atomic_write(output_dir / "summary.json", summary)
    return summary


def run_numeric_gate(*, workload: str, stage: str, native_root: Path,
                     ranks: Sequence[int], optimizer: Path, jobs: int,
                     label_suffix: str, output_dir: Path) -> dict[str, Any]:
    """Run the tracked numeric gate in a unique stage-local evidence directory."""
    existing = [rank for rank in ranks if (native_root / f"rank-{rank}" / "native.mlir").is_file()]
    command_record: dict[str, Any] = {"status": "skipped", "ranks": list(existing)}
    if not existing:
        atomic_write(output_dir / f"numeric-{label_suffix}.command.json", command_record)
        return command_record
    # Keep top-five and controls separate, and allocate a fresh directory for
    # every invocation. A failed retry cannot accidentally adopt an older
    # numeric result from this or another protocol version.
    numeric_output_root = (output_dir / "numeric" / label_suffix /
                           f"attempt-{time.time_ns()}-{os.getpid()}")
    label = f"neighborhood-{stage}-{label_suffix}"
    argv = [sys.executable, str(DEFAULT_NUMERIC_GATE),
            "--artifact-root", str(ROOT),
            "--output-root", str(numeric_output_root),
            "--reference-root", str(DEFAULT_NUMERIC_REFERENCE_ROOT),
            "--llama-harness", str(DEFAULT_LLAMA_HARNESS),
            "--workloads", workload,
            "--stage", label, "--native-root", str(native_root),
            "--optimizer", str(optimizer), "--ranks", *[str(rank) for rank in existing],
            "--jobs", str(max(1, jobs))]
    llvm_build = os.environ.get("ORBIT_LLVM_BUILD")
    if llvm_build:
        argv.extend(["--llvm-build", llvm_build])
    command_record = _run_logged(argv, output_dir, f"numeric-{label_suffix}")
    command_record["ranks"] = existing
    command_record["numeric_output_root"] = str(numeric_output_root)
    for rank in existing:
        result_path = native_root / f"rank-{rank}" / "result.json"
        if not result_path.is_file():
            continue
        value = json.loads(result_path.read_text())
        evidence = numeric_output_root / workload / f"{label}-rank-{rank}" / "result.json"
        value["numeric_command_exit_code"] = command_record.get("exit_code")
        if evidence.is_file():
            gate = json.loads(evidence.read_text())
            value["numeric"] = gate.get("status", "pending")
            value["numeric_evidence"] = str(evidence)
            value["numeric_element_comparisons"] = gate.get("element_comparisons")
        else:
            value["numeric"] = "incomplete"
            value["numeric_evidence"] = str(evidence)
            value["numeric_error"] = "numeric_gate_result_missing"
        atomic_write(result_path, value)
    refresh_native_summary(native_root)
    return command_record


def refresh_native_summary(native_root: Path) -> dict[str, Any]:
    """Refresh measured gates from durable rank records, preserving C++ order."""
    path = native_root / "summary.json"
    summary = json.loads(path.read_text())
    records = []
    for record in summary.get("records", []):
        rank_path = native_root / f"rank-{record['rank']}" / "result.json"
        records.append(json.loads(rank_path.read_text()) if rank_path.is_file() else record)
    summary["records"] = records
    for name, field in (("numeric", "numeric"), ("sram_gate", "sram_gate")):
        values = [record.get(field, "pending") for record in records]
        summary[name] = ("pass" if values and all(value == "pass" for value in values)
                         else "fail" if "fail" in values
                         else "incomplete" if "incomplete" in values
                         else "pending")
    atomic_write(path, summary)
    return summary


def numeric_gate_status(summary: Mapping[str, Any],
                        command_record: Mapping[str, Any]) -> str:
    """Keep numeric mismatches distinct from runner failures in stage output."""
    records = summary.get("records", [])
    statuses = [record.get("numeric", "pending") for record in records
                if isinstance(record, Mapping)]
    if "fail" in statuses:
        return "fail"
    if ("incomplete" in statuses or summary.get("numeric") == "incomplete" or
            command_record.get("exit_code") not in (0, None)):
        return "incomplete"
    if statuses and all(status == "pass" for status in statuses):
        return "pass"
    return "pending"


def find_output_file(directory: Path, names: Sequence[str]) -> Path:
    for name in names:
        path = directory / name
        if path.is_file():
            return path
    raise ContractError(f"C++ search did not emit any of {list(names)} under {directory}")


def validate_source_bindings(records: Sequence[Mapping[str, Any]]) -> None:
    """Reject incomplete C++ replay records before invoking the mapper."""
    for record in records:
        for field in ("score_file_path", "mapper_replay_path", "shape_manifest_file"):
            path = Path(str(record[field]))
            if not path.is_file():
                raise ContractError(
                    f"{record.get('candidate_id')} {field} is not a file: {path}")


def _protocol(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text())
    if value.get("schema") != "orbit-amoeba-input0-neighborhood-v3":
        raise ContractError(f"unexpected protocol schema in {path}: {value.get('schema')!r}")
    return value


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--workload", required=True)
    parser.add_argument("--stage", choices=STAGES, required=True)
    parser.add_argument("--decision-flow", choices=("legacy", "joint", "sequential"), default="legacy")
    parser.add_argument("--graph-budget-percent", type=int, choices=(25, 50, 75), default=50)
    parser.add_argument("--canonical", type=Path, required=True)
    parser.add_argument("--function")
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--optimizer", type=Path, default=DEFAULT_OPT)
    parser.add_argument("--architecture", type=Path, default=DEFAULT_ARCH)
    parser.add_argument("--protocol", type=Path, default=DEFAULT_PROTOCOL)
    parser.add_argument("--mapping-cache", type=Path, default=DEFAULT_MAPPING_CACHE)
    parser.add_argument("--model-cache", "--model", dest="model_cache", type=Path)
    parser.add_argument("--source-contract-file", type=Path)
    parser.add_argument("--cost-cache", type=Path)
    parser.add_argument("--parent-cost-file", type=Path)
    parser.add_argument("--seed-manifest", type=Path)
    parser.add_argument("--previous-winner", type=Path)
    parser.add_argument("--historical-native-winner", type=Path)
    parser.add_argument("--resume", type=Path)
    parser.add_argument("--checkpoint", type=Path)
    parser.add_argument("--manifest", type=Path,
                        help="factored candidate manifest used by the existing replay helper")
    parser.add_argument("--graph-manifests", type=Path)
    parser.add_argument("--sram-config", type=Path, default=DEFAULT_SRAM_CONFIG)
    parser.add_argument("--inter-task-network", type=Path)
    parser.add_argument("--jobs", type=int, default=1)
    parser.add_argument("--max-rounds", type=int, default=20)
    parser.add_argument("--max-candidates", type=int, default=20000)
    parser.add_argument("--beam-width", type=int, default=16)
    parser.add_argument("--diversity-slots", type=int, default=4)
    parser.add_argument("--skip-search", action="store_true",
                        help="replay an already completed C++ search directory")
    args = parser.parse_args(argv)
    if not 1 <= args.jobs <= 12:
        parser.error("--jobs must be between 1 and 12")
    if args.max_rounds <= 0 or args.max_candidates <= 0 or args.beam_width <= 0:
        parser.error("search budgets must be positive")
    for key in ("canonical", "output_dir", "optimizer", "architecture", "protocol",
                "mapping_cache", "model_cache", "cost_cache", "seed_manifest",
                "parent_cost_file", "source_contract_file",
                "previous_winner", "historical_native_winner", "resume", "checkpoint", "manifest",
                "graph_manifests", "sram_config", "inter_task_network"):
        value = getattr(args, key)
        if value is not None:
            setattr(args, key, value.resolve())
    if not args.canonical.is_file():
        raise ContractError(f"canonical MLIR does not exist: {args.canonical}")
    if not args.optimizer.is_file():
        raise ContractError(f"optimizer does not exist: {args.optimizer}")
    protocol = _protocol(args.protocol)
    if args.historical_native_winner is None:
        history = protocol.get("historical_native_winners", {}).get(args.workload)
        if isinstance(history, dict):
            history = history.get(args.stage)
        if history:
            if not isinstance(history, str):
                raise ContractError("historical native winner must be a selection path or a stage-to-path mapping")
            value = Path(history)
            args.historical_native_winner = (value if value.is_absolute() else args.protocol.parent / value).resolve()
    function = infer_function(args.canonical, args.function)
    output = args.output_dir
    output.mkdir(parents=True, exist_ok=True)
    search_dir = output / "search"
    # mlir-opt opens its -o destination before running any passes.
    search_dir.mkdir(parents=True, exist_ok=True)
    checkpoint = args.checkpoint or (output / "checkpoint.json")
    atomic_write(output / "source-binding.json",
                 source_binding(protocol, args.canonical, args.optimizer, args.architecture,
                                args.model_cache, args.cost_cache, args.parent_cost_file,
                                args.source_contract_file, args.inter_task_network))

    if not args.skip_search:
        command = build_search_command(
            optimizer=args.optimizer, canonical=args.canonical, output_dir=search_dir,
            function=function, stage=args.stage, architecture=args.architecture,
            protocol=protocol, checkpoint=checkpoint,
            seed_manifest=args.seed_manifest, previous_winner=args.previous_winner,
            parent_cost_file=args.parent_cost_file,
            model_cache=args.model_cache, cost_cache=args.cost_cache,
            max_rounds=args.max_rounds, max_candidates=args.max_candidates,
            beam_width=args.beam_width, diversity_slots=args.diversity_slots,
            resume=args.resume, protocol_path=args.protocol,
            source_contract_file=args.source_contract_file,
            historical_native_winner=args.historical_native_winner, workload=args.workload,
            inter_task_network=args.inter_task_network,
            decision_flow=args.decision_flow, graph_budget_percent=args.graph_budget_percent)
        search_record = _run_logged(command, output, "search")
        atomic_write(output / "search-result.json", search_record)
        if search_record.get("exit_code") != 0:
            atomic_write(output / "result.json", {
                "schema": "orbit-neighborhood-stage-result-v1",
                "status": "incomplete", "workload": args.workload,
                "stage": args.stage, "stop_reason": "fatal-search-process-error",
                "search": search_record, "production_ready": False,
            })
            return int(search_record.get("exit_code") or 1)
    else:
        search_record = json.loads((output / "search-result.json").read_text()) if (output / "search-result.json").is_file() else {"status": "reused"}

    top5_path = find_output_file(search_dir,
                                 ("global-top5.jsonl", "top5.jsonl", "native-top5.jsonl"))
    selected, header, footer = load_cpp_selections(top5_path)
    controls_path = search_dir / "controls.jsonl"
    controls = load_cpp_controls(controls_path, require_previous=args.decision_flow == "legacy" and args.stage != "shape-only")
    if args.decision_flow != "legacy" and {row["control_role"] for row in controls} != {"identity", "search_anchor"}:
        raise ContractError("standalone flows require the common identity and search_anchor validation controls")
    if args.historical_native_winner and not any(row.get("control_role") == "historical_measured_winner" for row in controls):
        raise ContractError("C++ did not retain the requested historical native control")
    validate_source_bindings([*selected, *controls])
    graph_manifests = args.graph_manifests
    if graph_manifests is None:
        candidate = search_dir / "graph-manifests.json"
        graph_manifests = candidate if candidate.is_file() else None
    manifest = args.manifest
    if manifest is None:
        manifest = Path(selected[0]["shape_manifest_file"])
    if manifest is None or not manifest.is_file():
        raise ContractError("--manifest or search/variants/identity/shapes.jsonl is required by native replay")

    top5_out = output / "native-top5"
    replay_records(selected, output_dir=top5_out, optimizer=args.optimizer,
                   architecture=args.architecture, mapping_cache=args.mapping_cache,
                   manifest=manifest, graph_manifests=graph_manifests,
                   sram_config=args.sram_config, jobs=args.jobs,
                   inter_task_network=args.inter_task_network,
                   audit_mapper_calls=args.decision_flow != "legacy")
    controls_out = output / "native-controls"
    replay_records(controls, output_dir=controls_out, optimizer=args.optimizer,
                   architecture=args.architecture, mapping_cache=args.mapping_cache,
                   manifest=manifest, graph_manifests=graph_manifests,
                   sram_config=args.sram_config, jobs=args.jobs,
                   inter_task_network=args.inter_task_network,
                   audit_mapper_calls=args.decision_flow != "legacy")
    top5_numeric = run_numeric_gate(workload=args.workload, stage=args.stage,
                                    native_root=top5_out, ranks=range(5),
                                    optimizer=args.optimizer, jobs=args.jobs,
                                    label_suffix="top5", output_dir=output)
    control_numeric = run_numeric_gate(workload=args.workload, stage=args.stage,
                                       native_root=controls_out, ranks=tuple(row["rank"] for row in controls),
                                       optimizer=args.optimizer, jobs=args.jobs,
                                       label_suffix="controls", output_dir=output)
    top5_summary = json.loads((top5_out / "summary.json").read_text())
    controls_summary = json.loads((controls_out / "summary.json").read_text())
    all_records = top5_summary.get("records", []) + controls_summary.get("records", [])
    measured = [record for record in all_records
                if record.get("status") == "native_replayed"
                and record.get("mapper_equality") == "pass"
                and record.get("independent_trace") == "pass"
                and (record.get("numeric") == "pass" if args.decision_flow != "legacy" else record.get("numeric") != "fail")
                and isinstance(record.get("native_cycles"), (int, float))]
    actual_cycles = min((record["native_cycles"] for record in measured), default=None)
    stop_reason = footer.get("stop_reason") or footer.get("search_stop_reason") or header.get("stop_reason")
    result = {
        "schema": "orbit-neighborhood-stage-result-v1",
        "status": ("native_replayed" if top5_summary.get("status") == "native_replayed"
                   and controls_summary.get("status") == "native_replayed" else "incomplete"),
        "workload": args.workload,
        "stage": args.stage,
        "decision_flow": args.decision_flow,
        "graph_budget_percent": args.graph_budget_percent if args.decision_flow == "sequential" else None,
        "function": function,
        "result_label": "best-found",
        "exhaustive": False,
        "global_optimality_claim": False,
        "source_binding": str(output / "source-binding.json"),
        "protocol": str(args.protocol),
        "search": search_record,
        "search_header": header,
        "search_footer": footer,
        "stop_reason": stop_reason or "not-reported-by-cpp",
        "checkpoint": str(checkpoint),
        "global_top5": str(top5_path),
        "top5": selected,
        "controls": controls,
        "native_top5": top5_summary,
        "native_controls": controls_summary,
        "numeric_top5_command": top5_numeric,
        "numeric_controls_command": control_numeric,
        "actual_stage_cycles": actual_cycles,
        "actual_stage_cycle_source": "minimum whole-program native cycles across measured top5 and controls" if actual_cycles is not None else None,
        "production_ready": False,
        "best_found": True,
        "native_top5_status": top5_summary.get("status"),
        "numeric": numeric_gate_status(top5_summary, top5_numeric),
        "trace": ("pass" if top5_summary.get("records") and all(record.get("independent_trace") == "pass" for record in top5_summary["records"])
                  else "fail" if any(record.get("independent_trace") == "fail" for record in top5_summary.get("records", []))
                  else "pending"),
        "sram": top5_summary.get("sram_gate", "pending"),
    }
    atomic_write(output / "result.json", result)
    print(json.dumps({"workload": args.workload, "stage": args.stage,
                      "status": result["status"], "actual_stage_cycles": actual_cycles,
                      "numeric": result["numeric"], "trace": result["trace"],
                      "sram": result["sram"]}, sort_keys=True))
    return 0 if result["status"] == "native_replayed" else 2


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (ContractError, OSError, ValueError, json.JSONDecodeError) as error:
        print(f"neighborhood replay contract error: {error}", file=sys.stderr)
        raise SystemExit(2)
