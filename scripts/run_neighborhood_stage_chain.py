#!/usr/bin/env python3
"""Run independently initialized input-0 ablation stages with exact resume binding.

The C++ ``search-joint-neighborhood`` pass remains the owner of action
generation, legality, canonicalisation, scoring, and archive ordering.  This
module only wires already source-owned records through
``scripts/neighborhood_replay.py``.  In particular it never constructs a
candidate, derives a score, or ranks a shortlist in Python.

The launcher is configuration driven and defaults to independent stages. Each
stage starts from the same original canonical program, explores every enabled
family and owns its checkpoint. Cross-stage seeds and imported results are
rejected. The explicit previous-winner policy remains for historical runs;
exact bindings prevent the two policies from sharing a result namespace.
"""
from __future__ import annotations

import argparse
from dataclasses import dataclass, replace
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import time
from typing import Any, Callable, Mapping, Sequence


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_REPLAY = ROOT / "scripts/neighborhood_replay.py"
DEFAULT_TABLE = ROOT / "scripts/render_neighborhood_table.py"
DEFAULT_PROTOCOL = ROOT / "config/protocols/amoeba_input0_neighborhood_v3.json"
WORKLOADS = ("llama", "lu", "harris", "radar", "gcn", "raytracing")
STAGES = (
    "shape-temporal",
    "shape-temporal-replica",
    "shape-temporal-replica-tiling",
    "full-joint",
)
LEGACY_STAGES = ("shape-only",) + STAGES
FISSION_STAGE = "full-joint-fission"
FISSION_STAGES = STAGES + (FISSION_STAGE,)
LEGACY_FISSION_STAGES = LEGACY_STAGES + (FISSION_STAGE,)
STAGE_CHOICES = LEGACY_FISSION_STAGES
CHAIN_SCHEMA = "orbit-amoeba-input0-neighborhood-chain-v1"
BINDING_SCHEMA = "orbit-neighborhood-chain-binding-v1"
CONTRACT_SCHEMA = "orbit-neighborhood-byte-contract-v1"
CONTRACT_DIR = "_binding"
SHARED_ORBIT_SCHEDULER = {
    "backend": "orbit-production",
    "dispatch_policy": "critical-path",
    "timing": "common-explicit-network",
}


class ChainError(RuntimeError):
    """The chain cannot safely continue under the requested binding."""


def protocol_stages(protocol: Mapping[str, Any]) -> tuple[str, ...]:
    """Keep historical numbering bound to its protocol; new runs use four stages."""
    declared = protocol.get("stages")
    if declared is None:
        return STAGES
    if not isinstance(declared, list):
        raise ChainError("protocol stages must be a list")
    names = tuple(item.get("name") if isinstance(item, Mapping) else item
                  for item in declared)
    if names not in (STAGES, LEGACY_STAGES, FISSION_STAGES,
                     LEGACY_FISSION_STAGES):
        raise ChainError("protocol must declare the merged four-stage, historical five-stage, or canonical fission stage order")
    return names


def protocol_scheduler(protocol: Mapping[str, Any]) -> dict[str, str] | None:
    value = protocol.get("scheduler")
    if value is None:
        return None
    if not isinstance(value, Mapping) or dict(value) != SHARED_ORBIT_SCHEDULER:
        raise ChainError("protocol scheduler must bind the shared ORBIT critical-path profile")
    if protocol_stages(protocol) not in (STAGES, FISSION_STAGES):
        raise ChainError("shared ORBIT scheduler profile requires the independent four-stage or fission protocol")
    stages = protocol.get("stages", [])
    if any(not isinstance(stage, Mapping) or stage.get("dispatch") != "critical-path"
           or stage.get("scheduling_mode") != "spatial-temporal" for stage in stages):
        raise ChainError("shared ORBIT scheduler stages must use critical-path spatial-temporal dispatch")
    return dict(SHARED_ORBIT_SCHEDULER)


def diagnostic_ii_ceiling(protocol: Mapping[str, Any]) -> int | None:
    """Read the opt-in diagnostic II ceiling carried by a workload protocol."""
    search = protocol.get("search", {})
    if not isinstance(search, Mapping):
        raise ChainError("protocol search must be an object")
    value = search.get("diagnostic_ii_ceiling")
    if value is None:
        return None
    if not isinstance(value, int) or isinstance(value, bool) or value not in (20, 23):
        raise ChainError("protocol diagnostic_ii_ceiling must be 20 or 23")
    if value == 23 and search.get("supported_shape_bootstrap_policy") != "minimum-area-supported-model-shape-v1":
        raise ChainError("diagnostic II ceiling 23 requires supported-shape bootstrap policy")
    return value


def stage_order(options: "ChainOptions") -> tuple[str, ...]:
    manifest_path = _contract_manifest_path(options.output_root)
    if manifest_path.is_file():
        # Check the frozen protocol bytes before interpreting stage metadata.
        # A malformed edit must not bypass the existing resume contract check.
        for source in read_json(manifest_path).get("sources", []):
            if source.get("path") == str(options.protocol.resolve()):
                snapshot = Path(str(source["snapshot"]))
                if not _stream_equal(options.protocol, snapshot):
                    raise ChainError(f"immutable chain input bytes changed: {options.protocol}")
    return protocol_stages(read_json(options.protocol))


def now() -> str:
    return datetime.now(timezone.utc).isoformat()


def atomic_write(path: Path, value: Any) -> None:
    """Write JSON durably enough that an interrupted launcher leaves evidence."""
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + ".partial")
    temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n",
                         encoding="utf-8")
    temporary.replace(path)


def read_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise ChainError(f"{path}: expected a JSON object")
    return value


def resolve_path(value: str | os.PathLike[str] | None, *, base: Path = ROOT) -> Path | None:
    if value is None or value == "":
        return None
    path = Path(value)
    return path.resolve() if path.is_absolute() else (base / path).resolve()


def _stream_equal(left: Path, right: Path, *, chunk_size: int = 1024 * 1024) -> bool:
    """Compare file bytes directly without creating a hash identity."""
    try:
        if left.stat().st_size != right.stat().st_size:
            return False
        with left.open("rb") as left_stream, right.open("rb") as right_stream:
            while True:
                left_chunk = left_stream.read(chunk_size)
                right_chunk = right_stream.read(chunk_size)
                if left_chunk != right_chunk:
                    return False
                if not left_chunk:
                    return True
    except OSError as error:
        raise ChainError(f"cannot compare binding bytes {left} and {right}: {error}") from error


def _copy_bytes_once(source: Path, destination: Path) -> None:
    """Copy one immutable input into the shared contract store atomically."""
    destination.parent.mkdir(parents=True, exist_ok=True)
    temporary = destination.with_name(destination.name + ".partial")
    try:
        with source.open("rb") as source_stream, temporary.open("wb") as destination_stream:
            shutil.copyfileobj(source_stream, destination_stream, length=1024 * 1024)
            destination_stream.flush()
            os.fsync(destination_stream.fileno())
        temporary.replace(destination)
    except OSError as error:
        try:
            temporary.unlink()
        except OSError:
            pass
        raise ChainError(f"cannot snapshot binding input {source}: {error}") from error


def _model_files(model_path: Path) -> list[Path]:
    """Return an ensemble and its existing recursively referenced weight files."""
    discovered: list[Path] = []
    pending = [model_path.resolve()]
    seen: set[Path] = set()
    while pending:
        current = pending.pop(0)
        if current in seen:
            continue
        seen.add(current)
        if not current.is_file():
            raise ChainError(f"model binding input does not exist: {current}")
        discovered.append(current)
        if current.suffix.lower() != ".json":
            continue
        try:
            document = json.loads(current.read_text(encoding="utf-8"))
        except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
            raise ChainError(f"model binding JSON cannot be read: {current}: {error}") from error
        values: list[Any] = []
        stack: list[Any] = [document]
        while stack:
            item = stack.pop()
            if isinstance(item, dict):
                for key, value in item.items():
                    if isinstance(value, str) and ("path" in str(key).lower() or
                                                    str(key).lower() in {"file", "filename", "weights"}):
                        values.append(value)
                    else:
                        stack.append(value)
            elif isinstance(item, list):
                stack.extend(item)
        for value in values:
            candidate = Path(value)
            if not candidate.is_absolute():
                candidate = current.parent / candidate
            candidate = candidate.resolve()
            if candidate.is_file() and candidate not in seen:
                pending.append(candidate)
    return sorted(discovered, key=lambda path: str(path))


def _contract_specs(config: Mapping[str, Any], options: "ChainOptions",
                    *, config_base: Path) -> list[dict[str, Any]]:
    """Build the immutable input list once for the entire chain.

    Cache files are deliberately absent.  They are append-only runtime stores;
    the C++ protocol and their addresses are bound in the normal launcher
    binding, while their changing contents must not invalidate a continuation.
    """
    specs: dict[Path, dict[str, Any]] = {}

    def add(path: Path | None, kind: str, workload: str | None = None,
            stage: str | None = None) -> None:
        if path is None:
            return
        path = path.resolve()
        entry = specs.setdefault(path, {"path": str(path), "kinds": [], "contexts": []})
        if kind not in entry["kinds"]:
            entry["kinds"].append(kind)
        context = {"workload": workload, "stage": stage}
        if context not in entry["contexts"]:
            entry["contexts"].append(context)

    add(options.protocol, "protocol")
    add(options.source_contract_file, "source_contract")
    add(options.architecture, "architecture")
    if options.inter_task_network is not None:
        add(options.inter_task_network, "inter_task_network")
    add(options.optimizer, "optimizer")
    add(options.seed_index, "seed_index")
    for workload in options.workloads:
        entry = _merged_workload(config, workload)
        add(_workload_input(entry, "protocol", options.protocol, base=config_base),
            "protocol", workload)
        add(_workload_input(entry, "architecture", options.architecture, base=config_base),
            "architecture", workload)
        for stage in stage_order(options):
            model_path = _path_for(entry, "model_cache", stage, base=config_base) or options.model_cache
            if model_path:
                for model_file in _model_files(model_path):
                    add(model_file, "model", workload, stage)
            add(_path_for(entry, "canonical", stage, base=config_base), "canonical", workload, stage)
            if stage == FISSION_STAGE:
                add(_path_for(entry, "prepared_source_file", stage, base=config_base),
                    "prepared_source", workload, stage)
            add(_path_for(entry, "parent_cost_file", stage, base=config_base), "parent_cost", workload, stage)
            add(_path_for(entry, "seed_manifest", stage, base=config_base), "seed_manifest", workload, stage)
            add(_path_for(entry, "previous_winner", stage, base=config_base), "previous_winner", workload, stage)
            if stage == options.start_stage:
                add(_seed_index_winner(options, workload, stage), "previous_winner", workload, stage)
            add(_path_for(entry, "reuse_result", stage, base=config_base), "reuse_result", workload, stage)
            add(_path_for(entry, "sram_config", stage, base=config_base) or options.sram_config,
                "sram_config", workload, stage)
    return sorted(specs.values(), key=lambda value: value["path"])


def _contract_manifest_path(root: Path) -> Path:
    return root / CONTRACT_DIR / "contract-manifest.json"


def _ensure_contract_snapshot(root: Path, specs: Sequence[Mapping[str, Any]]) -> Path:
    """Create/verify one shared immutable byte snapshot for this chain."""
    manifest_path = _contract_manifest_path(root)
    root.mkdir(parents=True, exist_ok=True)
    expected_sources = [
        {"path": str(item["path"]), "kinds": sorted(str(kind) for kind in item.get("kinds", [])),
         "contexts": sorted(item.get("contexts", []), key=lambda value: (str(value.get("workload")), str(value.get("stage"))))}
        for item in specs
    ]
    if manifest_path.is_file():
        manifest = read_json(manifest_path)
        if manifest.get("schema") != CONTRACT_SCHEMA:
            raise ChainError(f"{manifest_path}: unsupported immutable contract schema")
        recorded_sources = [
            {"path": str(item.get("path")), "kinds": sorted(str(kind) for kind in item.get("kinds", [])),
             "contexts": sorted(item.get("contexts", []), key=lambda value: (str(value.get("workload")), str(value.get("stage"))))}
            for item in manifest.get("sources", []) if isinstance(item, Mapping)
        ]
        if recorded_sources != expected_sources:
            raise ChainError("immutable chain inputs differ; choose a separate output namespace")
        for source in manifest["sources"]:
            original = Path(str(source["path"]))
            snapshot = Path(str(source["snapshot"]))
            if not original.is_file() or not snapshot.is_file() or not _stream_equal(original, snapshot):
                raise ChainError(f"immutable chain input bytes changed: {original}")
        return manifest_path

    source_root = root / CONTRACT_DIR / "sources"
    records: list[dict[str, Any]] = []
    try:
        for index, source in enumerate(expected_sources):
            original = Path(source["path"])
            if not original.is_file():
                raise ChainError(f"immutable chain input does not exist: {original}")
            safe_name = "".join(character if character.isalnum() or character in "._-" else "_"
                                  for character in original.name)
            snapshot = source_root / f"{index:04d}-{safe_name}"
            _copy_bytes_once(original, snapshot)
            if not _stream_equal(original, snapshot):
                raise ChainError(f"snapshot verification failed: {original}")
            record = dict(source)
            record["snapshot"] = str(snapshot)
            record["size_bytes"] = original.stat().st_size
            records.append(record)
        manifest = {"schema": CONTRACT_SCHEMA, "identity_policy": "direct byte comparison; no hash",
                    "sources": records}
        atomic_write(manifest_path, manifest)
    except BaseException:
        # Preserve diagnostics and partial snapshots for inspection.  A
        # missing manifest means the next invocation will rebuild safely.
        raise
    return manifest_path


def _file_or_none(value: Any, *, base: Path, field: str) -> str | None:
    path = resolve_path(value, base=base)
    if path is None:
        return None
    return str(path)


def load_config(path: Path) -> dict[str, Any]:
    value = read_json(path)
    schema = value.get("schema")
    if schema not in (None, "orbit-amoeba-input0-neighborhood-chain-config-v1"):
        raise ChainError(f"unsupported chain config schema: {schema!r}")
    workloads = value.get("workloads")
    if not isinstance(workloads, dict) or not workloads:
        raise ChainError("chain config must contain a non-empty workloads object")
    return value


def _merged_workload(config: Mapping[str, Any], workload: str) -> dict[str, Any]:
    defaults = config.get("defaults", {})
    entry = config.get("workloads", {}).get(workload)
    if not isinstance(defaults, dict) or not isinstance(entry, dict):
        raise ChainError(f"missing workload configuration for {workload}")
    merged = dict(defaults)
    for key, value in entry.items():
        if key == "stages" and isinstance(value, dict):
            stages = dict(merged.get("stages", {}))
            stages.update(value)
            merged[key] = stages
        else:
            merged[key] = value
    return merged


def _stage_value(entry: Mapping[str, Any], key: str, stage: str) -> Any:
    stages = entry.get("stages")
    if isinstance(stages, dict):
        stage_entry = stages.get(stage)
        if isinstance(stage_entry, dict) and key in stage_entry:
            return stage_entry[key]
    by_stage = entry.get(key + "_by_stage")
    if isinstance(by_stage, dict) and stage in by_stage:
        return by_stage[stage]
    return entry.get(key)


@dataclass(frozen=True)
class ChainOptions:
    output_root: Path
    protocol: Path
    source_contract_file: Path
    optimizer: Path
    architecture: Path
    mapping_cache: Path
    replay_script: Path = DEFAULT_REPLAY
    table_script: Path = DEFAULT_TABLE
    jobs: int = 1
    max_rounds: int = 20
    max_candidates: int = 20_000
    beam_width: int = 16
    diversity_slots: int = 4
    model_cache: Path | None = None
    cost_cache: Path | None = None
    sram_config: Path | None = None
    inter_task_network: Path | None = None
    # An optional index of source-owned historical C++ rows.  It is used only
    # to seed the first requested stage; the current optimizer must rescore
    # the row under the current protocol before it can enter the archive.
    seed_index: Path | None = None
    workloads: tuple[str, ...] = WORKLOADS
    start_stage: str | None = None
    allow_missing_table: bool = False
    stage_initialization: str = "independent"


def _validate_options(options: ChainOptions, config: Mapping[str, Any] | None = None,
                      *, config_base: Path = ROOT) -> None:
    if options.stage_initialization not in {"independent", "previous-winner"}:
        raise ChainError("unknown stage initialization policy")
    policy = read_json(options.protocol).get("search", {}).get("stage_initialization")
    if policy is not None and policy != options.stage_initialization:
        raise ChainError("stage initialization differs from the bound protocol")
    if options.stage_initialization == "independent" and options.seed_index is not None:
        raise ChainError("independent stages cannot import a seed index")
    if not 1 <= options.jobs <= 10:
        raise ChainError("jobs must be between 1 and 10; mapper budget is ten cores")
    if options.max_rounds <= 0 or options.max_candidates <= 0:
        raise ChainError("search budgets must be positive")
    if options.beam_width <= 0 or not 0 <= options.diversity_slots <= options.beam_width:
        raise ChainError("beam/diversity settings are invalid")
    if not options.workloads:
        raise ChainError("at least one workload is required")
    if options.start_stage is not None and options.start_stage not in stage_order(options):
        raise ChainError(f"unknown start stage: {options.start_stage}")
    unknown = set(options.workloads) - set(WORKLOADS)
    if unknown:
        raise ChainError(f"unknown workload(s): {sorted(unknown)}")
    for field in ("protocol", "source_contract_file", "optimizer", "architecture",
                  "replay_script"):
        if not getattr(options, field).is_file():
            raise ChainError(f"{field} does not exist: {getattr(options, field)}")
    if options.seed_index is not None and not options.seed_index.is_file():
        raise ChainError(f"seed_index does not exist: {options.seed_index}")
    if options.inter_task_network is not None and not options.inter_task_network.is_file():
        raise ChainError(f"inter_task_network does not exist: {options.inter_task_network}")
    scheduler = protocol_scheduler(read_json(options.protocol))
    protocol = read_json(options.protocol)
    if FISSION_STAGE in stage_order(options):
        if options.stage_initialization != "independent":
            raise ChainError("full-joint-fission must start independently from the canonical module")
        if protocol.get("stage_scheme") != FISSION_STAGE:
            raise ChainError("fission protocol stage_scheme must be full-joint-fission")
        cap = protocol.get("search", {}).get("max_fission_actions_per_task")
        if not isinstance(cap, int) or isinstance(cap, bool) or cap <= 0:
            raise ChainError("fission protocol must bind a positive search.max_fission_actions_per_task")
    if scheduler is not None:
        if options.inter_task_network is None:
            raise ChainError("shared ORBIT scheduler profile requires the common explicit inter-task network")
        if options.inter_task_network.resolve() != (ROOT / "config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml").resolve():
            raise ChainError("shared ORBIT scheduler must use the unchanged common network specification")
    if config is not None:
        for workload in options.workloads:
            entry = _merged_workload(config, workload)
            selected_protocol_path = _workload_input(entry, "protocol", options.protocol,
                                                     base=config_base)
            selected_architecture = _workload_input(entry, "architecture", options.architecture,
                                                    base=config_base)
            if not selected_protocol_path.is_file():
                raise ChainError(f"{workload}: protocol does not exist: {selected_protocol_path}")
            if not selected_architecture.is_file():
                raise ChainError(f"{workload}: architecture does not exist: {selected_architecture}")
            selected_protocol = read_json(selected_protocol_path)
            if protocol_stages(selected_protocol) != stage_order(options):
                raise ChainError(f"{workload}: protocol stage order differs from the chain protocol")
            if selected_protocol.get("search", {}).get("stage_initialization") not in (
                    None, options.stage_initialization):
                raise ChainError(f"{workload}: stage initialization differs from the bound protocol")
            diagnostic_ii_ceiling(selected_protocol)
            selected_scheduler = protocol_scheduler(selected_protocol)
            if selected_scheduler is not None:
                if options.inter_task_network is None:
                    raise ChainError(f"{workload}: shared ORBIT scheduler requires the common explicit inter-task network")
                if options.inter_task_network.resolve() != (ROOT / "config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml").resolve():
                    raise ChainError(f"{workload}: shared ORBIT scheduler must use the unchanged common network specification")
            if FISSION_STAGE in stage_order(options):
                if selected_protocol.get("stage_scheme") != FISSION_STAGE:
                    raise ChainError(f"{workload}: fission protocol stage_scheme must be full-joint-fission")
                cap = selected_protocol.get("search", {}).get("max_fission_actions_per_task")
                if not isinstance(cap, int) or isinstance(cap, bool) or cap <= 0:
                    raise ChainError(f"{workload}: protocol must bind a positive search.max_fission_actions_per_task")
    if not options.mapping_cache.exists():
        raise ChainError(f"mapping_cache does not exist: {options.mapping_cache}")
    if not options.table_script.is_file() and not options.allow_missing_table:
        raise ChainError(f"table script does not exist: {options.table_script}")


def _path_for(entry: Mapping[str, Any], key: str, stage: str, *, base: Path) -> Path | None:
    value = _stage_value(entry, key, stage)
    return resolve_path(value, base=base)


def _workload_input(entry: Mapping[str, Any], key: str, fallback: Path, *, base: Path) -> Path:
    """Resolve a workload-wide architecture/protocol override or its CLI default."""
    value = entry.get(key)
    selected = resolve_path(value, base=base) if value is not None else None
    return selected or fallback.resolve()


def expected_binding(entry: Mapping[str, Any], workload: str, stage: str,
                     options: ChainOptions, *, config_base: Path,
                     contract_manifest: Path | None = None) -> dict[str, Any]:
    canonical = _path_for(entry, "canonical", stage, base=config_base)
    if canonical is None:
        raise ChainError(f"{workload}: canonical is missing")
    function = _stage_value(entry, "function", stage)
    parent_cost = _path_for(entry, "parent_cost_file", stage, base=config_base)
    model_cache = _path_for(entry, "model_cache", stage, base=config_base) or options.model_cache
    cost_cache = _path_for(entry, "cost_cache", stage, base=config_base) or options.cost_cache
    seed_manifest = _path_for(entry, "seed_manifest", stage, base=config_base)
    previous_override = _path_for(entry, "previous_winner", stage, base=config_base)
    if previous_override is None and stage == options.start_stage:
        previous_override = _seed_index_winner(options, workload, stage)
    protocol_path = _workload_input(entry, "protocol", options.protocol, base=config_base)
    architecture_path = _workload_input(entry, "architecture", options.architecture,
                                        base=config_base)
    protocol = read_json(protocol_path)
    binding = {
        "schema": BINDING_SCHEMA,
        "workload": workload,
        "stage": stage,
        "canonical_program": str(canonical),
        "function": str(function or ""),
        "optimizer": str(options.optimizer),
        "architecture": str(architecture_path),
        "protocol": str(protocol_path),
        "source_contract_file": str(options.source_contract_file),
        "mapping_cache": str(options.mapping_cache),
        "seed_index": str(options.seed_index) if options.seed_index else None,
        "model_cache": str(model_cache) if model_cache else None,
        "cost_cache": str(cost_cache) if cost_cache else None,
        "parent_cost_file": str(parent_cost) if parent_cost else None,
        "seed_manifest": str(seed_manifest) if seed_manifest else None,
        "previous_winner_override": str(previous_override) if previous_override else None,
        "max_rounds": options.max_rounds,
        "max_candidates": options.max_candidates,
        "beam_width": options.beam_width,
        "diversity_slots": options.diversity_slots,
        "start_stage": options.start_stage,
        "contract_manifest": str(contract_manifest) if contract_manifest else None,
        "protocol_schema": _protocol_schema(protocol_path),
        "identity_policy": "exact protocol/source-contract binding; no hash identity",
    }
    if options.stage_initialization == "independent":
        binding["stage_initialization"] = "independent"
    if stage_order(options) == STAGES:
        binding["stage_scheme"] = "merged-spatial-temporal"
        binding["stage_order"] = list(stage_order(options))
    elif stage_order(options) in (FISSION_STAGES, LEGACY_FISSION_STAGES):
        binding["stage_scheme"] = FISSION_STAGE
        binding["stage_order"] = list(stage_order(options))
    if options.inter_task_network is not None:
        binding["inter_task_network"] = str(options.inter_task_network)
        binding["inter_task_network_text"] = options.inter_task_network.read_text()
    ceiling = diagnostic_ii_ceiling(protocol)
    if ceiling is not None:
        binding["diagnostic_ii_ceiling"] = ceiling
    scheduler = protocol_scheduler(protocol)
    if scheduler is not None:
        binding["scheduler"] = scheduler
    if stage == FISSION_STAGE:
        prepared = _path_for(entry, "prepared_source_file", stage, base=config_base)
        if prepared is None or not prepared.is_file():
            raise ChainError(f"{workload}/{stage}: prepared_source_file is missing")
        cap = protocol.get("search", {}).get("max_fission_actions_per_task")
        if not isinstance(cap, int) or isinstance(cap, bool) or cap <= 0:
            raise ChainError("fission protocol must bind a positive search.max_fission_actions_per_task")
        binding["prepared_source_file"] = str(prepared)
        binding["max_fission_actions_per_task"] = cap
        if contract_manifest is not None:
            manifest = read_json(contract_manifest)
            matches = [source for source in manifest.get("sources", [])
                       if source.get("path") == str(prepared) and
                       "prepared_source" in source.get("kinds", []) and
                       any(context.get("workload") == workload and
                           context.get("stage") == FISSION_STAGE
                           for context in source.get("contexts", []))]
            if len(matches) != 1:
                raise ChainError(f"{workload}/{stage}: prepared source is not uniquely pinned in the contract manifest")
            binding["prepared_source_snapshot"] = str(matches[0]["snapshot"])
            binding["prepared_source_size_bytes"] = matches[0]["size_bytes"]
    return binding


def _protocol_schema(path: Path) -> str | None:
    try:
        value = read_json(path)
    except (OSError, json.JSONDecodeError, ChainError):
        return None
    schema = value.get("schema")
    return str(schema) if schema is not None else None


def _stage_number(stage: str) -> int:
    if stage == "shape-only":
        return 1
    if stage in STAGES:
        return STAGES.index(stage) + 2
    if stage == FISSION_STAGE:
        return 6
    raise ChainError(f"unknown stage: {stage}")


def _seed_index_winner(options: ChainOptions, workload: str, stage: str) -> Path | None:
    """Return a historical C++ row for the requested stage's predecessor.

    The index contains source-owned JSONL rows and legacy native-cycle
    diagnostics.  Only the row path is passed to C++; this launcher never
    imports the legacy cycle value into a current result or ranking.
    """
    if options.seed_index is None or _stage_number(stage) <= 1:
        return None
    index = read_json(options.seed_index)
    key = f"{workload}-s{_stage_number(stage) - 1}"
    entry = index.get(key)
    if not isinstance(entry, Mapping):
        return None
    value = entry.get("previous_measured_winner")
    if not value:
        return None
    path = resolve_path(str(value), base=options.seed_index.parent)
    if path is None:
        return None
    if not path.is_file():
        raise ChainError(f"seed index {options.seed_index}: missing C++ winner row {path}")
    return path


def _global_binding(config: Mapping[str, Any], options: ChainOptions) -> dict[str, Any]:
    binding = {
        "schema": CHAIN_SCHEMA,
        "protocol": str(options.protocol),
        "source_contract_file": str(options.source_contract_file),
        "optimizer": str(options.optimizer),
        "architecture": str(options.architecture),
        "mapping_cache": str(options.mapping_cache),
        "seed_index": str(options.seed_index) if options.seed_index else None,
        "replay_script": str(options.replay_script),
        "table_script": str(options.table_script),
        "model_cache": str(options.model_cache) if options.model_cache else None,
        "cost_cache": str(options.cost_cache) if options.cost_cache else None,
        "jobs": options.jobs,
        "max_rounds": options.max_rounds,
        "max_candidates": options.max_candidates,
        "beam_width": options.beam_width,
        "diversity_slots": options.diversity_slots,
        "start_stage": options.start_stage,
        "protocol_schema": _protocol_schema(options.protocol),
        "workloads": list(options.workloads),
        "stages": list(stage_order(options)),
        "best_found": True,
        "exhaustive": False,
    }
    if options.stage_initialization == "independent":
        binding["stage_initialization"] = "independent"
    if stage_order(options) == STAGES:
        binding["stage_scheme"] = "merged-spatial-temporal"
    elif stage_order(options) in (FISSION_STAGES, LEGACY_FISSION_STAGES):
        binding["stage_scheme"] = FISSION_STAGE
    if options.inter_task_network is not None:
        binding["inter_task_network"] = str(options.inter_task_network)
        binding["inter_task_network_text"] = options.inter_task_network.read_text()
    scheduler = protocol_scheduler(read_json(options.protocol))
    if scheduler is not None:
        binding["scheduler"] = scheduler
    return binding


def _run_logged(argv: Sequence[str], directory: Path, label: str) -> dict[str, Any]:
    """Run one persistent command without a wall-clock timeout."""
    directory.mkdir(parents=True, exist_ok=True)
    command_path = directory / f"{label}.command.json"
    stdout_path = directory / f"{label}.stdout.log"
    stderr_path = directory / f"{label}.stderr.log"
    record: dict[str, Any] = {
        "schema": "orbit-neighborhood-chain-command-v1",
        "label": label,
        "argv": [str(item) for item in argv],
        "cwd": str(ROOT),
        "status": "running",
        "subprocess_timeout": None,
        "started_utc": now(),
        "stdout_log": str(stdout_path),
        "stderr_log": str(stderr_path),
    }
    atomic_write(command_path, record)
    with stdout_path.open("w", encoding="utf-8") as stdout, \
            stderr_path.open("w", encoding="utf-8") as stderr:
        process = subprocess.run([str(item) for item in argv], cwd=ROOT,
                                 stdout=stdout, stderr=stderr, check=False)
    record.update(status="finished", exit_code=process.returncode, ended_utc=now())
    atomic_write(command_path, record)
    return record


def _next_label(directory: Path, stem: str) -> str:
    labels = []
    for path in directory.glob(stem + "*.command.json"):
        suffix = path.name[len(stem):-len(".command.json")]
        try:
            labels.append(int(suffix.lstrip("-")) if suffix else 0)
        except ValueError:
            continue
    number = max(labels, default=-1) + 1
    return stem if number == 0 else f"{stem}-{number:03d}"


def _source_binding_from_result(result: Mapping[str, Any], result_path: Path) -> dict[str, Any] | None:
    value = result.get("source_binding")
    if not value:
        return None
    path = Path(str(value))
    if not path.is_absolute():
        path = (result_path.parent / path).resolve()
    if not path.is_file():
        return None
    try:
        return read_json(path)
    except (OSError, json.JSONDecodeError, ChainError):
        return None


def _compatible_source_binding(value: Mapping[str, Any], expected: Mapping[str, Any]) -> bool:
    """Compare semantic source inputs; output directories are intentionally ignored."""
    aliases = {"parent_cost_file": "parent_cost_file", "cost_cache": "cost_cache",
               "model_cache": "model_cache", "canonical_program": "canonical_program",
               "optimizer": "optimizer", "architecture": "architecture",
               "protocol": "protocol"}
    for expected_key, source_key in aliases.items():
        if value.get(source_key) != expected.get(expected_key):
            return False
    if expected.get("stage_initialization") == "independent" and value.get("stage_initialization") != "independent":
        return False
    for key in ("inter_task_network", "inter_task_network_text"):
        if value.get(key) != expected.get(key):
            return False
    if value.get("scheduler") != expected.get("scheduler"):
        return False
    if value.get("diagnostic_ii_ceiling") != expected.get("diagnostic_ii_ceiling"):
        return False
    if value.get("source_commit") != _protocol_source_commit(expected):
        return False
    protocol_schema = value.get("protocol_schema")
    if protocol_schema != expected.get("protocol_schema"):
        return False
    # A legacy result with no exact source-contract witness cannot be silently
    # admitted into the current protocol namespace.
    if value.get("source_contract_file") != expected.get("source_contract_file"):
        return False
    if expected.get("stage") == FISSION_STAGE:
        if (value.get("prepared_source_file") != expected.get("prepared_source_file") or
                value.get("max_fission_actions_per_task") !=
                expected.get("max_fission_actions_per_task")):
            return False
        snapshot_value = expected.get("prepared_source_snapshot")
        if not isinstance(snapshot_value, str) or not snapshot_value:
            return False
        snapshot = Path(snapshot_value)
        try:
            exact_bytes = snapshot.read_bytes()
            exact_text = exact_bytes.decode("utf-8")
        except (OSError, UnicodeDecodeError):
            return False
        if (value.get("prepared_source_exact_text") != exact_text or
                value.get("prepared_source_size_bytes") != len(exact_bytes) or
                expected.get("prepared_source_size_bytes") != len(exact_bytes)):
            return False
    return True


def _protocol_source_commit(expected: Mapping[str, Any]) -> str | None:
    protocol = expected.get("protocol")
    if not protocol:
        return None
    try:
        value = read_json(Path(str(protocol)))
    except (OSError, json.JSONDecodeError, ChainError):
        return None
    commit = value.get("source_commit")
    return str(commit) if commit is not None else None


def _stage_binding_matches(path: Path, expected: Mapping[str, Any]) -> bool:
    if not path.is_file():
        return False
    try:
        return read_json(path) == dict(expected)
    except (OSError, json.JSONDecodeError, ChainError):
        return False


def _record_failure(stage_dir: Path, *, workload: str, stage: str,
                    reason: str, command: Mapping[str, Any] | None = None) -> dict[str, Any]:
    value: dict[str, Any] = {
        "schema": "orbit-neighborhood-stage-result-v1",
        "status": "incomplete",
        "workload": workload,
        "stage": stage,
        "production_ready": False,
        "best_found": True,
        "exhaustive": False,
        "stop_reason": reason,
        "launcher_failure": reason,
    }
    if command is not None:
        value["search"] = dict(command)
    atomic_write(stage_dir / "result.json", value)
    return value


def _records_from_result(result: Mapping[str, Any], key: str) -> list[dict[str, Any]]:
    block = result.get(key)
    if isinstance(block, list):
        return [dict(item) for item in block if isinstance(item, Mapping)]
    if not isinstance(block, Mapping):
        return []
    records = block.get("records")
    return [dict(item) for item in records if isinstance(item, Mapping)] if isinstance(records, list) else []


def choose_measured_winner(result: Mapping[str, Any]) -> tuple[dict[str, Any], dict[str, Any]]:
    """Choose the measured winner, including controls, by protocol evidence.

    The returned source row is copied exactly from the C++ ``top5`` or
    ``controls`` array.  No candidate tuple or score is synthesized here.
    """
    source_rows = _records_from_result(result, "top5") + _records_from_result(result, "controls")
    source_by_key: dict[tuple[Any, Any, Any], dict[str, Any]] = {}
    for row in source_rows:
        source_by_key[(row.get("control_role"), row.get("rank"), row.get("candidate_id"))] = row
    candidates: list[tuple[float | int, int, int, dict[str, Any], dict[str, Any]]] = []
    for block_name in ("native_top5", "native_controls"):
        for order, measured in enumerate(_records_from_result(result, block_name)):
            if measured.get("status") != "native_replayed":
                continue
            if measured.get("independent_trace") != "pass":
                continue
            if measured.get("mapper_equality") != "pass":
                continue
            if measured.get("numeric") != "pass":
                continue
            cycles = measured.get("native_cycles")
            if not isinstance(cycles, (int, float)) or isinstance(cycles, bool):
                continue
            key = (measured.get("control_role"), measured.get("rank"), measured.get("candidate_id"))
            row = source_by_key.get(key)
            if row is None:
                # Some replay helpers omit control_role/rank in the measured
                # result.  Candidate identity is still source-owned and is a
                # safe fallback when it is unique.
                matches = [item for item in source_rows if item.get("candidate_id") == measured.get("candidate_id")]
                row = matches[0] if len(matches) == 1 else None
            if row is None:
                continue
            candidates.append((cycles, int(measured.get("rank", 10**9)), order,
                               measured, row))
    if not candidates:
        raise ChainError("no native-replayed candidate has mapper equality and independent trace pass")
    candidates.sort(key=lambda item: (item[0], item[1], item[2]))
    _, _, _, measured, row = candidates[0]
    if row.get("record_type") not in {"selection", "control"}:
        raise ChainError("measured winner source row is not a C++ selection/control record")
    if not row.get("candidate_id") or not row.get("graph_variant_id"):
        raise ChainError("measured winner source row lacks C++ candidate identity")
    if not (row.get("candidate_path") or row.get("mapper_replay_path") or row.get("mlir_path")):
        raise ChainError("measured winner source row lacks a C++ candidate module path")
    return measured, row


def write_winner(stage_dir: Path, result: Mapping[str, Any]) -> Path:
    measured, row = choose_measured_winner(result)
    # JSONL is the C++ seed interface.  This is a copied source row; fields are
    # not filled in or recomputed by the launcher.
    winner_path = stage_dir / "previous-winner.jsonl"
    winner_path.parent.mkdir(parents=True, exist_ok=True)
    temporary = winner_path.with_name(winner_path.name + ".partial")
    temporary.write_text(json.dumps(row, sort_keys=True) + "\n", encoding="utf-8")
    temporary.replace(winner_path)
    atomic_write(stage_dir / "winner.json", {
        "schema": "orbit-neighborhood-measured-winner-v1",
        "candidate_id": measured.get("candidate_id"),
        "graph_variant_id": measured.get("graph_variant_id"),
        "rank": measured.get("rank"),
        "control_role": measured.get("control_role"),
        "native_cycles": measured.get("native_cycles"),
        "independent_trace": measured.get("independent_trace"),
        "mapper_equality": measured.get("mapper_equality"),
        "source_row": str(winner_path),
        "source_row_record_type": row.get("record_type"),
    })
    return winner_path


def _build_replay_command(*, workload: str, stage: str, entry: Mapping[str, Any],
                          options: ChainOptions, config_base: Path, stage_dir: Path,
                          previous_winner: Path | None, resume: bool,
                          skip_search: bool) -> list[str]:
    canonical = _path_for(entry, "canonical", stage, base=config_base)
    if canonical is None:
        raise ChainError(f"{workload}/{stage}: canonical is missing")
    function = _stage_value(entry, "function", stage)
    parent_cost = _path_for(entry, "parent_cost_file", stage, base=config_base)
    model_cache = _path_for(entry, "model_cache", stage, base=config_base) or options.model_cache
    cost_cache = _path_for(entry, "cost_cache", stage, base=config_base) or options.cost_cache
    seed_manifest = _path_for(entry, "seed_manifest", stage, base=config_base)
    graph_manifests = _path_for(entry, "graph_manifests", stage, base=config_base)
    manifest = _path_for(entry, "manifest", stage, base=config_base)
    sram_config = _path_for(entry, "sram_config", stage, base=config_base) or options.sram_config
    architecture = _workload_input(entry, "architecture", options.architecture,
                                   base=config_base)
    protocol_path = _workload_input(entry, "protocol", options.protocol, base=config_base)
    protocol = read_json(protocol_path)
    checkpoint = stage_dir / "checkpoint.json"
    argv = [sys.executable, str(options.replay_script),
            "--workload", workload, "--stage", stage,
            "--canonical", str(canonical), "--output-dir", str(stage_dir),
            "--optimizer", str(options.optimizer), "--architecture", str(architecture),
            "--protocol", str(protocol_path), "--mapping-cache", str(options.mapping_cache),
            "--source-contract-file", str(options.source_contract_file),
            "--checkpoint", str(checkpoint), "--jobs", str(options.jobs),
            "--max-rounds", str(options.max_rounds),
            "--max-candidates", str(options.max_candidates),
            "--beam-width", str(options.beam_width),
            "--diversity-slots", str(options.diversity_slots)]
    if function:
        argv += ["--function", str(function)]
    if model_cache:
        argv += ["--model-cache", str(model_cache)]
    if cost_cache:
        argv += ["--cost-cache", str(cost_cache)]
    if parent_cost:
        argv += ["--parent-cost-file", str(parent_cost)]
    argv += ["--stage-initialization", options.stage_initialization]
    if options.stage_initialization == "independent":
        if seed_manifest or _path_for(entry, "previous_winner", stage, base=config_base):
            raise ChainError("independent stages cannot import seed inputs")
        previous_winner = None
    if seed_manifest:
        argv += ["--seed-manifest", str(seed_manifest)]
    if previous_winner:
        argv += ["--previous-winner", str(previous_winner)]
    if graph_manifests:
        argv += ["--graph-manifests", str(graph_manifests)]
    if manifest:
        argv += ["--manifest", str(manifest)]
    if sram_config:
        argv += ["--sram-config", str(sram_config)]
    if options.inter_task_network is not None:
        argv += ["--inter-task-network", str(options.inter_task_network)]
    if stage == FISSION_STAGE:
        prepared = _path_for(entry, "prepared_source_file", stage, base=config_base)
        if prepared is None or not prepared.is_file():
            raise ChainError(f"{workload}/{stage}: prepared_source_file is missing")
        cap = protocol.get("search", {}).get("max_fission_actions_per_task")
        if not isinstance(cap, int) or isinstance(cap, bool) or cap <= 0:
            raise ChainError("fission protocol must bind a positive search.max_fission_actions_per_task")
        if previous_winner is not None or seed_manifest is not None or options.stage_initialization != "independent":
            raise ChainError("full-joint-fission cannot import a previous winner or seed")
        argv += ["--prepared-source-file", str(prepared),
                 "--max-fission-actions-per-task", str(cap)]
    if resume:
        argv += ["--resume", str(checkpoint)]
    if skip_search:
        argv += ["--skip-search"]
    return argv


def _search_artifacts_complete(stage_dir: Path) -> bool:
    search_dir = stage_dir / "search"
    # neighborhood_replay.py writes search-result.json beside its search/
    # directory; the C++ top5/control streams live inside search/.
    return ((stage_dir / "search-result.json").is_file() and
            any((search_dir / name).is_file() for name in
                ("global-top5.jsonl", "top5.jsonl", "native-top5.jsonl")) and
            (search_dir / "controls.jsonl").is_file())


def _adopt_reuse_result(source: Path, stage_dir: Path, expected: Mapping[str, Any],
                        workload: str, stage: str) -> dict[str, Any]:
    result = read_json(source)
    if result.get("status") != "native_replayed":
        raise ChainError(f"{source}: reusable result is not native_replayed")
    binding = _source_binding_from_result(result, source)
    if binding is None or not _compatible_source_binding(binding, expected):
        raise ChainError(f"{source}: source binding is incompatible with current protocol namespace")
    result = dict(result)
    result["reuse_source_result"] = str(source.resolve())
    result["workload"] = workload
    result["stage"] = stage
    atomic_write(stage_dir / "result.json", result)
    return result


def _render_table(options: ChainOptions) -> dict[str, Any]:
    if not options.table_script.is_file():
        if options.allow_missing_table:
            return {"status": "skipped", "reason": "table-script-missing"}
        raise ChainError(f"table script does not exist: {options.table_script}")
    label = _next_label(options.output_root, "render-table")
    command = [sys.executable, str(options.table_script), "--results-root",
               str(options.output_root), "--workloads", *options.workloads,
               "--stages", *stage_order(options), "--output-dir", str(options.output_root / "table")]
    return _run_logged(command, options.output_root, label)


def _render_table_for_stage(options: ChainOptions, record: dict[str, Any]) -> bool:
    """Regenerate the machine/Markdown table and retain renderer failures."""
    try:
        command = _render_table(options)
        record["table_command"] = command
        if command.get("exit_code", 0) != 0:
            record["table_error"] = "table-render-process-failed"
            return False
        return True
    except (ChainError, OSError, ValueError) as error:
        record["table_error"] = f"{type(error).__name__}: {error}"
        return False


def _state_path(root: Path) -> Path:
    return root / "chain-progress.json"


def _load_or_start_state(root: Path, binding: Mapping[str, Any]) -> dict[str, Any]:
    path = _state_path(root)
    if path.is_file():
        state = read_json(path)
        if state.get("schema") != CHAIN_SCHEMA:
            raise ChainError(f"{path}: unsupported chain state schema")
        if state.get("binding") != dict(binding):
            raise ChainError("existing chain binding differs; choose a separate output namespace")
        return state
    state = {"schema": CHAIN_SCHEMA, "status": "running", "binding": dict(binding),
             "started_utc": now(), "updated_utc": now(), "workloads": {}, "commands": []}
    atomic_write(path, state)
    return state


def _save_state(root: Path, state: dict[str, Any]) -> None:
    state["updated_utc"] = now()
    atomic_write(_state_path(root), state)


def _stage_state(state: dict[str, Any], workload: str, stage: str) -> dict[str, Any]:
    workload_state = state.setdefault("workloads", {}).setdefault(workload, {"stages": {}})
    stages = workload_state.setdefault("stages", {})
    return stages.setdefault(stage, {"status": "pending"})


def _stage_complete(stage_dir: Path, expected: Mapping[str, Any]) -> tuple[bool, dict[str, Any] | None]:
    result_path = stage_dir / "result.json"
    if not result_path.is_file() or not _stage_binding_matches(stage_dir / "chain-binding.json", expected):
        return False, None
    try:
        result = read_json(result_path)
    except (OSError, json.JSONDecodeError, ChainError):
        return False, None
    return result.get("status") == "native_replayed", result


def validate_stage_inputs(config: Mapping[str, Any], options: ChainOptions,
                          *, config_base: Path) -> None:
    """All independent stages share one original canonical input and no search seeds."""
    if options.stage_initialization != "independent":
        return
    protocol = read_json(options.protocol)
    stages = stage_order(options)
    if FISSION_STAGE in stages:
        if options.stage_initialization != "independent":
            raise ChainError("full-joint-fission must start independently from the canonical module")
        if protocol.get("stage_scheme") != FISSION_STAGE:
            raise ChainError("fission protocol stage_scheme must be full-joint-fission")
        cap = protocol.get("search", {}).get("max_fission_actions_per_task")
        if not isinstance(cap, int) or isinstance(cap, bool) or cap <= 0:
            raise ChainError("fission protocol must bind a positive search.max_fission_actions_per_task")
    if protocol.get("historical_native_winners"):
        raise ChainError("independent stages cannot import historical native winners")
    forbidden = {"seed_manifest", "previous_winner", "historical_native_winner",
                 "seed_index", "reuse_result"}
    for workload in options.workloads:
        entry = _merged_workload(config, workload)
        workload_protocol = read_json(_workload_input(
            entry, "protocol", options.protocol, base=config_base))
        if protocol_stages(workload_protocol) != stages:
            raise ChainError(f"{workload}: protocol stage order differs from the chain protocol")
        if workload_protocol.get("historical_native_winners"):
            raise ChainError(f"{workload}: independent stages cannot import historical native winners")
        if FISSION_STAGE in stages:
            if workload_protocol.get("stage_scheme") != FISSION_STAGE:
                raise ChainError(f"{workload}: fission protocol stage_scheme must be full-joint-fission")
            cap = workload_protocol.get("search", {}).get("max_fission_actions_per_task")
            if not isinstance(cap, int) or isinstance(cap, bool) or cap <= 0:
                raise ChainError(f"{workload}: protocol must bind a positive search.max_fission_actions_per_task")
        canonical = _path_for(entry, "canonical", stages[0], base=config_base)
        function = _stage_value(entry, "function", stages[0])
        for stage in stages:
            if any(_stage_value(entry, key, stage) is not None for key in forbidden):
                raise ChainError(f"{workload}/{stage}: independent stages cannot import seeds or results")
            if (_path_for(entry, "canonical", stage, base=config_base) != canonical or
                    _stage_value(entry, "function", stage) != function):
                raise ChainError(f"{workload}: independent stages require the same canonical program and function")
            if stage == FISSION_STAGE:
                prepared = _path_for(entry, "prepared_source_file", stage, base=config_base)
                if prepared is None or not prepared.is_file():
                    raise ChainError(f"{workload}/{stage}: prepared_source_file is missing")


def run_chain(config: Mapping[str, Any], options: ChainOptions) -> int:
    """Run stages in configured workload order, returning 0 only when all finish."""
    stages = stage_order(options)
    if options.start_stage is None:
        options = replace(options, start_stage=stages[0])
    config_base = Path(str(config.get("config_base", ROOT))).resolve()
    if _contract_manifest_path(options.output_root).is_file():
        _ensure_contract_snapshot(options.output_root, _contract_specs(config, options, config_base=config_base))
    _validate_options(options, config, config_base=config_base)
    validate_stage_inputs(config, options, config_base=config_base)
    independent = options.stage_initialization == "independent"
    options.output_root.mkdir(parents=True, exist_ok=True)
    contract_manifest = _ensure_contract_snapshot(
        options.output_root, _contract_specs(config, options, config_base=config_base))
    binding = _global_binding(config, options)
    binding["contract_manifest"] = str(contract_manifest)
    state = _load_or_start_state(options.output_root, binding)
    failed = False
    start_index = stages.index(options.start_stage)
    for workload in options.workloads:
        entry = _merged_workload(config, workload)
        workload_state = state.setdefault("workloads", {}).setdefault(workload, {"stages": {}})
        blocked = False
        previous_winner: Path | None = None
        for stage in stages[:start_index]:
            record = _stage_state(state, workload, stage)
            # `_stage_state` creates a normal pending record.  An explicitly
            # later start stage must make the skipped prefix observable as
            # outside the requested run; setdefault would leave it pending.
            record["status"] = "outside-start"
            record["reason"] = f"chain start stage is {options.start_stage}"
        active_stages = stages[start_index:]
        for stage_index, stage in enumerate(active_stages, start=start_index):
            record = _stage_state(state, workload, stage)
            if independent:
                previous_winner = None
            stage_dir = options.output_root / workload / stage
            stage_dir.mkdir(parents=True, exist_ok=True)
            expected = expected_binding(entry, workload, stage, options, config_base=config_base,
                                       contract_manifest=contract_manifest)
            binding_path = stage_dir / "chain-binding.json"
            had_binding = binding_path.is_file()
            if had_binding and not _stage_binding_matches(binding_path, expected):
                record.update(status="binding-mismatch", reason="stage binding differs; use a separate namespace",
                              stage_dir=str(stage_dir))
                _save_state(options.output_root, state)
                failed = True
                blocked = not independent
                break
            if not had_binding and any((stage_dir / name).exists()
                                       for name in ("result.json", "checkpoint.json", "search")):
                record.update(status="binding-mismatch",
                              reason="existing stage artifacts lack an exact chain binding; use a separate namespace",
                              stage_dir=str(stage_dir))
                _save_state(options.output_root, state)
                failed = True
                blocked = not independent
                break
            atomic_write(binding_path, expected)
            record["stage_dir"] = str(stage_dir)

            if blocked:
                record.update(status="blocked", reason="earlier stage failed")
                _save_state(options.output_root, state)
                failed = True
                continue

            complete, result = _stage_complete(stage_dir, expected)
            if complete and result is not None:
                try:
                    previous_winner = Path(str(result.get("winner_path"))) if result.get("winner_path") else None
                    if previous_winner is None or not previous_winner.is_file():
                        previous_winner = write_winner(stage_dir, result)
                    result = dict(result)
                    result["winner_path"] = str(previous_winner)
                    atomic_write(stage_dir / "result.json", result)
                except ChainError as error:
                    record.update(status="incomplete", reason=f"winner-selection: {error}")
                    failed = True
                    blocked = not independent
                    _save_state(options.output_root, state)
                    continue
                record.update(status="reused", result=str(stage_dir / "result.json"),
                              winner_path=str(previous_winner),
                              actual_stage_cycles=result.get("actual_stage_cycles"))
                if not _render_table_for_stage(options, record):
                    failed = True
                _save_state(options.output_root, state)
                continue

            if blocked:
                record.update(status="blocked", reason="earlier stage failed")
                _save_state(options.output_root, state)
                failed = True
                continue

            stage_override = _stage_value(entry, "reuse_result", stage)
            if stage_override:
                try:
                    result = _adopt_reuse_result(resolve_path(stage_override, base=config_base),
                                                 stage_dir, expected, workload, stage)  # type: ignore[arg-type]
                    previous_winner = write_winner(stage_dir, result)
                    result["winner_path"] = str(previous_winner)
                    atomic_write(stage_dir / "result.json", result)
                    record.update(status="reused", reuse_source_result=str(resolve_path(stage_override, base=config_base)),
                                  result=str(stage_dir / "result.json"), winner_path=str(previous_winner),
                                  actual_stage_cycles=result.get("actual_stage_cycles"))
                    if not _render_table_for_stage(options, record):
                        failed = True
                    _save_state(options.output_root, state)
                    continue
                except (ChainError, OSError, TypeError) as error:
                    record.update(status="binding-mismatch", reason=f"reuse rejected: {error}")
                    failed = True
                    blocked = not independent
                    _save_state(options.output_root, state)
                    continue

            if not independent:
                if stage_index == start_index:
                    external_previous = _path_for(entry, "previous_winner", stage, base=config_base)
                    if external_previous is None:
                        external_previous = _seed_index_winner(options, workload, stage)
                    if external_previous is not None:
                        if not external_previous.is_file():
                            record.update(status="blocked", reason=f"external previous winner missing: {external_previous}")
                            failed = True
                            blocked = not independent
                            _save_state(options.output_root, state)
                            continue
                        previous_winner = external_previous
                    elif stage_index > 0:
                        record.update(status="blocked",
                                      reason="start stage requires a source-owned previous measured winner")
                        failed = True
                        blocked = not independent
                        _save_state(options.output_root, state)
                        continue
                if stage_index > start_index and previous_winner is None:
                    record.update(status="blocked", reason="previous measured winner unavailable")
                    failed = True
                    blocked = not independent
                    _save_state(options.output_root, state)
                    continue

            search_complete = _search_artifacts_complete(stage_dir)
            checkpoint = stage_dir / "checkpoint.json"
            resume = checkpoint.is_file() and not search_complete
            skip_search = search_complete
            try:
                argv = _build_replay_command(workload=workload, stage=stage, entry=entry,
                                             options=options, config_base=config_base,
                                             stage_dir=stage_dir, previous_winner=previous_winner,
                                             resume=resume, skip_search=skip_search)
                label = _next_label(stage_dir, "replay")
                command = _run_logged(argv, stage_dir, label)
                record.setdefault("attempts", []).append(command)
                atomic_write(stage_dir / "launch.json", {
                    "schema": "orbit-neighborhood-stage-launch-v1",
                    "workload": workload, "stage": stage, "argv": command.get("argv"),
                    "status": command.get("status"), "exit_code": command.get("exit_code"),
                    "resume": resume, "skip_search": skip_search,
                    "stage_initialization": options.stage_initialization,
                    "previous_winner": str(previous_winner) if previous_winner else None,
                })
                result_path = stage_dir / "result.json"
                if result_path.is_file():
                    result = read_json(result_path)
                else:
                    result = _record_failure(stage_dir, workload=workload, stage=stage,
                                             reason="replay-result-missing", command=command)
                if command.get("exit_code") != 0:
                    record.update(status="failed", reason="replay-process-failed",
                                  exit_code=command.get("exit_code"), result=str(result_path))
                    failed = True
                    blocked = not independent
                    _save_state(options.output_root, state)
                    continue
                if result.get("status") != "native_replayed":
                    record.update(status="incomplete", reason="stage-native-replay-incomplete",
                                  result=str(result_path))
                    failed = True
                    blocked = not independent
                    _save_state(options.output_root, state)
                    continue
                previous_winner = write_winner(stage_dir, result)
                result = dict(result)
                result["winner_path"] = str(previous_winner)
                atomic_write(result_path, result)
                record.update(status="complete", result=str(result_path),
                              winner_path=str(previous_winner),
                              actual_stage_cycles=result.get("actual_stage_cycles"),
                              exit_code=command.get("exit_code"))
                if not _render_table_for_stage(options, record):
                    failed = True
                _save_state(options.output_root, state)
            except (ChainError, OSError, ValueError, json.JSONDecodeError) as error:
                failure = _record_failure(stage_dir, workload=workload, stage=stage,
                                          reason=f"launcher-error: {type(error).__name__}: {error}")
                record.update(status="failed", reason=failure["stop_reason"], result=str(stage_dir / "result.json"))
                failed = True
                blocked = not independent
                _save_state(options.output_root, state)
                continue
        workload_state["status"] = "complete" if all(
            workload_state.get("stages", {}).get(item, {}).get("status") in {"complete", "reused"}
            for item in active_stages) else "incomplete"
        _save_state(options.output_root, state)
    state["status"] = "complete" if not failed and all(
        state.get("workloads", {}).get(workload, {}).get("status") == "complete"
        for workload in options.workloads) else "incomplete"
    state["ended_utc"] = now()
    _save_state(options.output_root, state)
    return 0 if state["status"] == "complete" else 2


def _parse_args(argv: Sequence[str] | None = None) -> tuple[ChainOptions, Path]:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config", type=Path, required=True,
                        help="JSON workload path/cost configuration")
    parser.add_argument("--output-root", type=Path, required=True)
    parser.add_argument("--protocol", type=Path, default=DEFAULT_PROTOCOL)
    parser.add_argument("--source-contract-file", type=Path, required=True)
    parser.add_argument("--optimizer", type=Path, required=True)
    parser.add_argument("--architecture", type=Path, required=True)
    parser.add_argument("--mapping-cache", type=Path, required=True)
    parser.add_argument("--replay-script", type=Path, default=DEFAULT_REPLAY)
    parser.add_argument("--table-script", type=Path, default=DEFAULT_TABLE)
    parser.add_argument("--model-cache", type=Path)
    parser.add_argument("--cost-cache", type=Path)
    parser.add_argument("--sram-config", type=Path)
    parser.add_argument("--inter-task-network", type=Path)
    parser.add_argument("--seed-index", type=Path,
                        help="optional index of source-owned historical C++ winner rows")
    parser.add_argument("--stage-initialization", choices=("independent", "previous-winner"),
                        default="independent", help="fresh identity per stage; warm-start only for historical replay")
    parser.add_argument("--start-stage", choices=STAGE_CHOICES,
                        help="first independently initialized stage to run")
    parser.add_argument("--workloads", nargs="+", default=list(WORKLOADS))
    parser.add_argument("--jobs", type=int, default=1)
    parser.add_argument("--max-rounds", type=int, default=20)
    parser.add_argument("--max-candidates", type=int, default=20_000)
    parser.add_argument("--beam-width", type=int, default=16)
    parser.add_argument("--diversity-slots", type=int, default=4)
    parser.add_argument("--allow-missing-table", action="store_true")
    args = parser.parse_args(argv)
    for name in ("config", "output_root", "protocol", "source_contract_file", "optimizer",
                 "architecture", "mapping_cache", "replay_script", "table_script",
                 "model_cache", "cost_cache", "sram_config", "inter_task_network", "seed_index"):
        value = getattr(args, name)
        if value is not None:
            setattr(args, name, value.resolve())
    config_path = args.config
    options = ChainOptions(
        output_root=args.output_root, protocol=args.protocol,
        source_contract_file=args.source_contract_file, optimizer=args.optimizer,
        architecture=args.architecture, mapping_cache=args.mapping_cache,
        replay_script=args.replay_script, table_script=args.table_script,
        jobs=args.jobs, max_rounds=args.max_rounds, max_candidates=args.max_candidates,
        beam_width=args.beam_width, diversity_slots=args.diversity_slots,
        model_cache=args.model_cache, cost_cache=args.cost_cache,
        sram_config=args.sram_config, inter_task_network=args.inter_task_network,
        seed_index=args.seed_index,
        workloads=tuple(args.workloads), start_stage=args.start_stage or
        protocol_stages(read_json(args.protocol))[0],
        allow_missing_table=args.allow_missing_table, stage_initialization=args.stage_initialization)
    return options, config_path


def main(argv: Sequence[str] | None = None) -> int:
    try:
        options, config_path = _parse_args(argv)
        config = load_config(config_path)
        config["config_base"] = str(config_path.parent.resolve())
        return run_chain(config, options)
    except (ChainError, OSError, ValueError, json.JSONDecodeError) as error:
        print(f"neighborhood chain error: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
