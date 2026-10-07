#!/usr/bin/env python3
"""Prepare or run the durable six-workload input-0 fusion/fission cohort.

The default invocation is a read-only launch plan.  ``--prepare-runtime``
creates a new frozen runtime by copying the accepted v59-r3 runtime and then
overlaying the current public ``scripts/``, ``config/``, and ``reference/``
bytes.  ``--launch`` starts the three four-CPU lanes and returns only after
every workload has completed all five native-replayed stages.  It has no
subprocess timeout and never kills workers.

The launcher does not build the optimizer.  A root-owned acceptance record
must certify the exact pin, source contract, protocol/configuration, canonical
lowering, complete source-cut census, and native fixtures before either
runtime preparation or launch is permitted.

Run it from the public artifact checkout after the root acceptance marker is
written.  The first command freezes the runtime; the second prints a read-only
plan with the exact all-unit and six workload commands; the third starts the
persistent coordinator from a host process namespace.  The fixed1x1 baseline
runs serially on CPUs 0-3 before the three four-CPU neighborhood lanes.  A
stopped coordinator can resume only with the same paths and bytes::

    python3 scripts/run_input0_memory_fusion_fission_queue.py --prepare-runtime
    python3 scripts/run_input0_memory_fusion_fission_queue.py
    nohup python3 scripts/run_input0_memory_fusion_fission_queue.py \
    --launch --host-pid-view-verified \
      > .work/post-publication/input0-memory-fusion-fission-r9-launch.log 2>&1 &
    python3 scripts/run_input0_memory_fusion_fission_queue.py --status

Use ``--resume`` with the launch command only after the previous coordinator
has exited.  The launcher preserves partial output and starts a new fixed1x1
attempt rather than clearing an incomplete result directory.
"""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import fcntl
import json
import os
from pathlib import Path
import re
import shutil
import stat
import subprocess
import sys
import tempfile
import time
from typing import Any, Mapping, Sequence


ARTIFACT_ROOT = Path(__file__).resolve().parents[1]
COHORT_NAME = "input0-neighborhood-2x2-v60-memory-fusion-fission-r5-20261006"
WORKLOADS = ("llama", "lu", "harris", "radar", "gcn", "raytracing")
STAGES = (
    "shape-temporal",
    "shape-temporal-replica",
    "shape-temporal-replica-tiling",
    "full-joint",
    "full-joint-fission",
)
LANES = (
    {"index": 0, "cpus": (0, 1, 2, 3), "workloads": ("llama", "lu")},
    {"index": 1, "cpus": (4, 5, 6, 7), "workloads": ("harris", "radar")},
    {"index": 2, "cpus": (8, 9, 10, 11), "workloads": ("gcn", "raytracing")},
)
OLD_RECOVERY_SCHEMA = "orbit-full-input0-proof-repair-recovery-v1"
OLD_RADAR_RETRY_SCHEMA = "orbit-r4-workload-independent-retry-v1"
ACCEPTANCE_SCHEMA = "orbit-memory-fusion-fission-native-acceptance-v1"
FREEZE_SCHEMA = "orbit-input0-frozen-runtime-overlay-v1"
STATE_SCHEMA = "orbit-input0-memory-fusion-fission-runtime-v1"
NETWORK_RELATIVE = Path("config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml")
ARCHITECTURE_RELATIVE = Path("config/architectures/amoeba_4x4_cgra_2x2_context6.yaml")
SRAM_RELATIVE = Path("config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json")
OLD_RECOVERY_PID = 682238
OLD_GCN_RETRY_PID = 685052
FIXED1X1_COHORT_ID = "input0-all-unit-2x2-v60-memory-fusion-fission-r5-20261006"
RAY_DIAGNOSTIC_II_CEILING = 23
FIXED1X1_CLOSED_STATUSES = {"complete", "complete-with-model-domain-exclusion"}
DEFAULT_LLVM_BUILD = Path("/home/x/shiran/llvm-project/build")
RAY_TASK_IDS = tuple(f"Task_{index}" for index in range(27))
RAY_COST_SHAPES = ((2, 2), (2, 4), (2, 6), (2, 8),
                   (4, 2), (4, 4), (6, 2), (8, 2))
RAY_SOURCE_IDENTITY_RELATIVE = Path(
    ".work/source-fission-original-ray-repair-20261006/upstream-source-check/summary.json")
RAY_LOWERING_RECORD_RELATIVE = Path(
    ".work/source-fission-original-ray-repair-20261006/canonical-lowering-record.json")
RAY_SOURCE_INPUT_RELATIVE = Path("reference/input0-source-domains/inputs/raytracing.mlir")
RAY_NATIVE_MODEL = "orbit-cgra-ii-per-cgra-2x2-direct-4member-v1"


class QueueError(RuntimeError):
    """The cohort cannot safely be prepared or launched."""


def _utc_now() -> str:
    return datetime.now(timezone.utc).isoformat()


def _json(path: Path) -> Any:
    if path.is_symlink() or not path.is_file():
        raise QueueError(f"required regular file is missing or is a symlink: {path}")
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
        raise QueueError(f"cannot read JSON {path}: {error}") from error


def _assert_no_symlink_components(path: Path) -> Path:
    """Return an absolute path after rejecting every existing symlink component."""
    absolute = Path(os.path.abspath(os.fspath(path)))
    current = Path(absolute.anchor)
    for part in absolute.parts[1:]:
        current = current / part
        try:
            mode = current.lstat().st_mode
        except FileNotFoundError:
            continue
        except OSError as error:
            raise QueueError(f"cannot inspect path component {current}: {error}") from error
        if stat.S_ISLNK(mode):
            raise QueueError(f"symlink path component is not allowed: {current}")
    return absolute


def _regular_file(path: Path, field: str, *, executable: bool = False) -> Path:
    absolute = _assert_no_symlink_components(path)
    try:
        mode = absolute.stat().st_mode
    except OSError as error:
        raise QueueError(f"{field} does not exist: {absolute}: {error}") from error
    if not stat.S_ISREG(mode):
        raise QueueError(f"{field} is not a regular file: {absolute}")
    if executable and not os.access(absolute, os.X_OK):
        raise QueueError(f"{field} is not executable: {absolute}")
    return absolute


def _stream_equal(left: Path, right: Path, *, chunk_size: int = 1024 * 1024) -> bool:
    """Compare exact bytes without deriving a hash identity."""
    try:
        if left.stat().st_size != right.stat().st_size:
            return False
        with left.open("rb") as left_file, right.open("rb") as right_file:
            while True:
                left_chunk = left_file.read(chunk_size)
                right_chunk = right_file.read(chunk_size)
                if left_chunk != right_chunk:
                    return False
                if not left_chunk:
                    return True
    except OSError as error:
        raise QueueError(f"cannot compare {left} and {right}: {error}") from error


def _atomic_json(path: Path, document: Mapping[str, Any]) -> None:
    _assert_no_symlink_components(path.parent)
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.is_symlink():
        raise QueueError(f"refusing to replace symlink state file: {path}")
    temporary = path.with_name(path.name + f".partial-{os.getpid()}-{time.time_ns()}")
    with temporary.open("x", encoding="utf-8") as stream:
        json.dump(document, stream, indent=2, sort_keys=True)
        stream.write("\n")
        stream.flush()
        os.fsync(stream.fileno())
    os.replace(temporary, path)


def _copy_exact(source: Path, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    with source.open("rb") as source_stream, destination.open("xb") as destination_stream:
        shutil.copyfileobj(source_stream, destination_stream, length=1024 * 1024)
        destination_stream.flush()
        os.fsync(destination_stream.fileno())
    shutil.copystat(source, destination, follow_symlinks=False)
    if not _stream_equal(source, destination):
        raise QueueError(f"exact-byte copy verification failed: {source} -> {destination}")


def _overlay_files(source_root: Path, destination_root: Path) -> list[dict[str, Any]]:
    """Overlay one source tree while rejecting symlinks and special files."""
    source_root = _regular_directory(source_root, "overlay source")
    destination_root = _regular_directory(destination_root, "frozen overlay destination")
    records: list[dict[str, Any]] = []
    for directory, dirs, files in os.walk(source_root, topdown=True, followlinks=False):
        base = Path(directory)
        dirs[:] = sorted(name for name in dirs if name not in {"__pycache__", ".pytest_cache"})
        for name in dirs:
            source = base / name
            if source.is_symlink():
                raise QueueError(f"symlink in frozen overlay source: {source}")
            target = destination_root / source.relative_to(source_root)
            if target.is_symlink():
                raise QueueError(f"symlink in frozen overlay destination: {target}")
            if target.exists() and not target.is_dir():
                raise QueueError(f"non-directory blocks frozen overlay: {target}")
            target.mkdir(parents=True, exist_ok=True)
        for name in sorted(files):
            source = base / name
            if source.is_symlink() or not source.is_file():
                raise QueueError(f"non-regular file in frozen overlay source: {source}")
            relative = source.relative_to(source_root)
            target = destination_root / relative
            if target.is_symlink():
                raise QueueError(f"symlink in frozen overlay destination: {target}")
            target.parent.mkdir(parents=True, exist_ok=True)
            if target.exists():
                if not target.is_file():
                    raise QueueError(f"non-file blocks frozen overlay: {target}")
                target.unlink()
            _copy_exact(source, target)
            records.append({"source": str(source),
                            "runtime_relative_path": str(Path(destination_root.name) / relative),
                            "size_bytes": source.stat().st_size})
    return records


def _regular_directory(path: Path, field: str) -> Path:
    absolute = _assert_no_symlink_components(path)
    if not absolute.is_dir():
        raise QueueError(f"{field} is not a directory: {absolute}")
    return absolute


def _path_is_under(path: Path, parent: Path) -> bool:
    try:
        path.resolve().relative_to(parent.resolve())
        return True
    except ValueError:
        return False


def _resolve_template_path(value: Any, artifact_root: Path, field: str) -> Path:
    if not isinstance(value, str) or not value:
        raise QueueError(f"protocol {field} must be a non-empty path")
    expanded = value.replace("${ARTIFACT_ROOT}", str(artifact_root))
    if "${" in expanded:
        raise QueueError(f"protocol {field} has an unsupported unresolved variable: {value}")
    return _assert_no_symlink_components(Path(expanded))


def _validate_protocol(protocol: Mapping[str, Any], *, artifact_root: Path,
                       optimizer: Path, source_contract: Path,
                       architecture_relative: Path = ARCHITECTURE_RELATIVE) -> None:
    expected_stage_entries = protocol.get("stages")
    if (protocol.get("schema") != "orbit-amoeba-input0-neighborhood-v3" or
            protocol.get("stage_scheme") != "full-joint-fission" or
            protocol.get("stage_order") != list(STAGES) or
            not isinstance(expected_stage_entries, list) or
            tuple(item.get("name") if isinstance(item, dict) else item
                  for item in expected_stage_entries) != STAGES):
        raise QueueError("protocol must bind the independent five-stage full-joint-fission order")
    search = protocol.get("search")
    if not isinstance(search, dict) or search.get("max_fission_actions_per_task") != 64:
        raise QueueError("protocol search.max_fission_actions_per_task must equal 64")
    if (search.get("max_rounds") != 4 or
            search.get("max_unique_complete_candidates_scored") != 4096 or
            search.get("beam_width") != 16 or search.get("diversity_min_slots") != 4 or
            search.get("stage_initialization") != "independent"):
        raise QueueError("protocol must bind independent 4-round/4096/beam-16/diversity-4 searches")
    if (search.get("active_transfer_arguments_by_workload") != {"gcn": list(range(1, 13))} or
            search.get("active_transfer_require_proven") is not True):
        raise QueueError("protocol must bind the accepted GCN active-transfer proof arguments 1-12")
    execution = protocol.get("execution_policy")
    if not isinstance(execution, dict) or any((
            execution.get("cores") != 12,
            execution.get("workload_workers") != 3,
            execution.get("mapper_jobs_per_workload") != 4,
            execution.get("compile_and_link_jobs") != 1,
            execution.get("subprocess_timeout") is not None)):
        raise QueueError("protocol must bind three four-CPU lanes, build j1, and no mapper timeout")
    if _resolve_template_path(protocol.get("optimizer_pin"), artifact_root, "optimizer_pin") != optimizer:
        raise QueueError("protocol optimizer_pin differs from the accepted optimizer path")
    if _resolve_template_path(protocol.get("source_contract_file"), artifact_root,
                              "source_contract_file") != source_contract:
        raise QueueError("protocol source_contract_file differs from the accepted contract path")
    if (protocol.get("architecture") != "${ARTIFACT_ROOT}/" + architecture_relative.as_posix() or
            protocol.get("sram_capacity_config") != "${ARTIFACT_ROOT}/" + SRAM_RELATIVE.as_posix() or
            protocol.get("model_ensemble") != "${ARTIFACT_ROOT}/reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json"):
        raise QueueError("protocol architecture, SRAM, or model binding differs from the accepted runtime inputs")
    if protocol.get("fixed1x1_cohort_id") != FIXED1X1_COHORT_ID:
        raise QueueError("protocol fixed1x1_cohort_id must bind the fresh v60/r5 baseline cohort")
    if protocol.get("inter_task_network_spec") != "${ARTIFACT_ROOT}/" + NETWORK_RELATIVE.as_posix():
        raise QueueError("protocol network must resolve to the frozen runtime common network")


def _resolve_config_file(value: Any, *, config_path: Path, artifact_root: Path,
                         field: str, fallback: Path | None = None) -> Path:
    if value is None:
        if fallback is None:
            raise QueueError(f"{field} is required")
        return _regular_file(fallback, field)
    if not isinstance(value, str) or not value:
        raise QueueError(f"{field} must be a non-empty path")
    expanded = value.replace("${ARTIFACT_ROOT}", str(artifact_root))
    if "${" in expanded:
        raise QueueError(f"{field} contains an unsupported unresolved variable: {value}")
    path = Path(expanded)
    if not path.is_absolute():
        path = config_path.parent / path
    return _regular_file(path, field)


def _validate_chain_config(config: Mapping[str, Any], *, config_path: Path,
                           lowering_path: Path, artifact_root: Path,
                           default_architecture: Path,
                           default_protocol: Path) -> dict[str, dict[str, Path]]:
    if config.get("schema") != "orbit-amoeba-input0-neighborhood-chain-config-v1":
        raise QueueError("chain config has an unsupported schema")
    workloads = config.get("workloads")
    if not isinstance(workloads, dict) or set(workloads) != set(WORKLOADS):
        raise QueueError("chain config must define exactly the six measured workloads")
    defaults = config.get("defaults")
    if not isinstance(defaults, dict) or not defaults.get("model_cache"):
        raise QueueError("chain config must define the pinned common model cache")
    model = _regular_file(Path(str(defaults["model_cache"])), "common model cache")
    lowering_rows = _json(lowering_path)
    if not isinstance(lowering_rows, list):
        raise QueueError("canonical-lowering acceptance witness must be a JSON array")
    lowered_by_workload: dict[str, Mapping[str, Any]] = {}
    for row in lowering_rows:
        if not isinstance(row, dict) or row.get("exact_r4_canonical_bytes_equal") is not True:
            raise QueueError("canonical-lowering witness has an unaccepted or malformed row")
        raw_name = row.get("workload")
        name = "raytracing" if raw_name == "raytracing-fission" else raw_name
        if name not in WORKLOADS or name in lowered_by_workload:
            raise QueueError(f"canonical-lowering witness has unexpected/duplicate workload: {raw_name}")
        lowered_by_workload[name] = row
    if set(lowered_by_workload) != set(WORKLOADS):
        raise QueueError("canonical-lowering witness must cover all six workloads")

    resolved: dict[str, dict[str, Path]] = {}
    for workload in WORKLOADS:
        item = workloads[workload]
        if not isinstance(item, dict):
            raise QueueError(f"{workload}: chain config entry must be an object")
        prepared_value = item.get("prepared_source_file")
        canonical_value = item.get("canonical")
        if not isinstance(prepared_value, str) or not isinstance(canonical_value, str):
            raise QueueError(f"{workload}: canonical and prepared_source_file are required")
        prepared = _regular_file(Path(prepared_value), f"{workload} prepared source")
        canonical = _regular_file(Path(canonical_value), f"{workload} canonical input")
        parent_cost = _regular_file(Path(str(item.get("parent_cost_file", ""))),
                                    f"{workload} parent cost catalog")
        mapper_cost = _regular_file(Path(str(item.get("cost_cache", ""))),
                                    f"{workload} mapper cost cache")
        architecture = _resolve_config_file(item.get("architecture"),
                                             config_path=config_path,
                                             artifact_root=artifact_root,
                                             field=f"{workload} architecture",
                                             fallback=default_architecture)
        protocol = _resolve_config_file(item.get("protocol"),
                                        config_path=config_path,
                                        artifact_root=artifact_root,
                                        field=f"{workload} protocol",
                                        fallback=default_protocol)
        source_identity = None
        canonical_lowering_record = None
        if workload == "raytracing":
            source_identity = _resolve_config_file(
                item.get("source_identity_record"), config_path=config_path,
                artifact_root=artifact_root, field="Ray source identity record")
            canonical_lowering_record = _resolve_config_file(
                item.get("canonical_lowering_record"), config_path=config_path,
                artifact_root=artifact_root, field="Ray canonical-lowering record")
            if (source_identity != artifact_root / RAY_SOURCE_IDENTITY_RELATIVE or
                    canonical_lowering_record != artifact_root / RAY_LOWERING_RECORD_RELATIVE):
                raise QueueError("Ray source proof records differ from the accepted original-source witnesses")
        elif item.get("source_identity_record") is not None or item.get("canonical_lowering_record") is not None:
            raise QueueError(f"{workload}: Ray-only source identity record fields are not permitted")
        row = lowered_by_workload[workload]
        accepted_prepared = _regular_file(Path(str(row.get("pre_neura", ""))),
                                          f"{workload} accepted prepared source")
        accepted_lowered = _regular_file(Path(str(row.get("lowered", ""))),
                                         f"{workload} accepted lowered canonical")
        _regular_file(Path(str(row.get("source", ""))), f"{workload} source witness")
        if prepared != accepted_prepared or not _stream_equal(canonical, accepted_lowered):
            raise QueueError(f"{workload}: prepared/canonical source bytes differ from lowering witness")
        resolved[workload] = {"prepared": prepared, "canonical": canonical,
                              "parent_cost": parent_cost, "mapper_cost": mapper_cost,
                              "model": model, "architecture": architecture,
                              "protocol": protocol}
        if workload == "raytracing":
            resolved[workload]["source_identity_record"] = source_identity
            resolved[workload]["canonical_lowering_record"] = canonical_lowering_record
    return resolved


def _validate_workload_bindings(resolved_config: Mapping[str, Mapping[str, Path]], *,
                                artifact_root: Path, main_protocol_path: Path,
                                main_protocol: Mapping[str, Any], optimizer: Path,
                                source_contract: Path,
                                runtime_root: Path) -> dict[str, dict[str, Any]]:
    """Bind each workload to its explicit public architecture/protocol inputs.

    The only permitted per-workload protocol delta is Ray's diagnostic II=23
    admission ceiling and its matching architecture path. All other protocol
    policy remains byte-structurally equal to the shared protocol.
    """
    bindings: dict[str, dict[str, Any]] = {}
    for workload in WORKLOADS:
        item = resolved_config[workload]
        architecture = _regular_file(item["architecture"], f"{workload} selected architecture")
        protocol_path = _regular_file(item["protocol"], f"{workload} selected protocol")
        try:
            relative_architecture = architecture.relative_to(artifact_root)
            protocol_path.relative_to(artifact_root)
        except ValueError as error:
            raise QueueError(f"{workload} architecture and protocol must be inside the public artifact checkout") from error
        protocol = _json(protocol_path)
        if not isinstance(protocol, dict):
            raise QueueError(f"{workload} selected protocol must be a JSON object")
        parent_catalog = _json(item["parent_cost"])
        predictor_metadata = parent_catalog.get("predictor_metadata")
        if (not isinstance(predictor_metadata, dict) or
                predictor_metadata.get("architecture_path") != str(architecture)):
            raise QueueError(f"{workload} parent-cost catalog architecture path differs from the selected public architecture")
        _validate_protocol(protocol, artifact_root=artifact_root, optimizer=optimizer,
                           source_contract=source_contract,
                           architecture_relative=relative_architecture)
        _validate_contract_header(source_contract, protocol)

        if workload != "raytracing":
            if protocol_path != main_protocol_path or architecture != resolved_config["llama"]["architecture"]:
                raise QueueError(f"{workload} must use the shared architecture and main protocol")
            if protocol.get("fixed1x1_domain_exclusion_policy") is not None:
                raise QueueError(f"{workload} must not enable the Ray model-domain exclusion policy")
        else:
            search = protocol.get("search")
            if not isinstance(search, dict) or search.get("diagnostic_ii_ceiling") != RAY_DIAGNOSTIC_II_CEILING:
                raise QueueError("Ray protocol must bind diagnostic search.ii ceiling 23")
            if (protocol.get("diagnostic_only") is not True or
                    protocol.get("formal_go") is not False or
                    protocol.get("runtime_ii_ceiling") != 23 or
                    protocol.get("training_ii_ceiling") != 20 or
                    not isinstance(protocol.get("fabric"), dict) or
                    protocol["fabric"].get("ctrl_mem_size") != 23):
                raise QueueError("Ray protocol must bind diagnostic ctrl-mem/runtime II 23 with training II 20")
            if architecture == resolved_config["llama"]["architecture"]:
                raise QueueError("Ray diagnostic-II-23 architecture must be distinct from the shared II=20 architecture")
            base = json.loads(json.dumps(main_protocol))
            override = json.loads(json.dumps(protocol))
            exclusion_policy = override.pop("fixed1x1_domain_exclusion_policy", None)
            if exclusion_policy != "compiler-proved-runtime-II-ceiling-v1":
                raise QueueError("Ray diagnostic protocol lacks the accepted compiler-proved domain exclusion policy")
            if isinstance(base.get("search"), dict):
                base["search"].pop("diagnostic_ii_ceiling", None)
            if isinstance(override.get("search"), dict):
                override["search"].pop("diagnostic_ii_ceiling", None)
            for field in ("diagnostic_only", "formal_go", "runtime_ii_ceiling", "training_ii_ceiling"):
                override.pop(field, None)
            if isinstance(base.get("fabric"), dict):
                base["fabric"]["ctrl_mem_size"] = 23
            base["architecture"] = override.get("architecture")
            if override != base:
                raise QueueError("Ray diagnostic protocol changes policy beyond architecture and II=23")
            if protocol_path == main_protocol_path:
                raise QueueError("Ray must use the separately bound diagnostic-II-23 protocol")

        frozen_architecture = _assert_no_symlink_components(runtime_root / relative_architecture)
        bindings[workload] = {"architecture": architecture,
                              "frozen_architecture": frozen_architecture,
                              "protocol": protocol_path,
                              "protocol_json": protocol,
                              "protocol_bytes": protocol_path.read_bytes()}
    return bindings


def _assert_bound_files_unchanged(context: Mapping[str, Any]) -> None:
    """Fail if launch inputs changed after the preflight read their exact bytes."""
    if _regular_file(context["config_path"], "bound workload config").read_bytes() != context["config_bytes"]:
        raise QueueError("workload config exact bytes changed after preflight")
    for workload in WORKLOADS:
        binding = context["workload_bindings"][workload]
        protocol = _regular_file(binding["protocol"], f"{workload} bound protocol")
        if protocol.read_bytes() != binding["protocol_bytes"]:
            raise QueueError(f"{workload} selected protocol exact bytes changed after preflight")


def _validate_acceptance_marker(marker_path: Path, *, optimizer: Path,
                                source_contract: Path, protocol: Path,
                                config_path: Path, workloads: Sequence[str] = WORKLOADS) -> dict[str, Any]:
    marker = _json(marker_path)
    if not isinstance(marker, dict) or marker.get("schema") != ACCEPTANCE_SCHEMA:
        raise QueueError(f"native acceptance marker must use schema {ACCEPTANCE_SCHEMA}")
    if marker.get("status") != "accepted":
        raise QueueError("native acceptance marker is not accepted")
    exact_paths = {"optimizer": optimizer, "source_contract": source_contract,
                   "protocol": protocol, "config": config_path}
    for field, expected in exact_paths.items():
        observed = marker.get(field)
        if not isinstance(observed, str) or _assert_no_symlink_components(Path(observed)) != expected:
            raise QueueError(f"acceptance marker {field} path does not match the requested run")
    for field in ("canonical_lowering_verified", "census_complete",
                  "native_source_fusion_and_fission_verified", "fixtures_passed",
                  "tamper_controls_passed"):
        if marker.get(field) is not True:
            raise QueueError(f"acceptance marker lacks required positive gate: {field}")
    census_paths = marker.get("census_paths")
    if isinstance(census_paths, dict):
        normalized = {("raytracing" if key == "raytracing-fission" else key): value
                      for key, value in census_paths.items()}
        if set(normalized) != set(workloads) or len(normalized) != len(census_paths):
            raise QueueError("acceptance marker source census must cover exactly all six workloads")
        paths = [normalized[workload] for workload in workloads]
    elif isinstance(census_paths, list):
        if len(census_paths) != len(workloads):
            raise QueueError("acceptance marker must name six source census files")
        paths = census_paths
    else:
        raise QueueError("acceptance marker census_paths must be a workload map or six-path list")
    if len({str(path) for path in paths}) != len(paths):
        raise QueueError("acceptance marker source census paths must be distinct")
    for value in paths:
        if not isinstance(value, str):
            raise QueueError("acceptance marker contains a non-string census path")
        _regular_file(Path(value), "accepted source-cut census")
    return marker


def _validate_contract_payloads(contract_path: Path, *, artifact_root: Path,
                                runtime_root: Path) -> dict[str, Any]:
    contract = _json(contract_path)
    if contract.get("schema") != "orbit-neighborhood-exact-source-model-contract-v1":
        raise QueueError("source contract has an unexpected schema")
    replay_payloads = contract.get("replay_payloads")
    if not isinstance(replay_payloads, list) or not replay_payloads:
        raise QueueError("source contract must include exact replay payloads")
    checked: list[str] = []
    for row in replay_payloads:
        if not isinstance(row, dict) or not isinstance(row.get("path"), str) or not isinstance(row.get("text"), str):
            raise QueueError("source contract contains a malformed replay payload")
        relative = Path(row["path"])
        if relative.is_absolute() or ".." in relative.parts:
            raise QueueError(f"source contract replay path must be relative and contained: {relative}")
        current = _regular_file(artifact_root / relative, "current replay payload")
        frozen = _regular_file(runtime_root / relative, "frozen replay payload")
        expected = row["text"].encode("utf-8")
        if current.read_bytes() != expected or not _stream_equal(current, frozen):
            raise QueueError(f"source contract replay payload differs from current/frozen bytes: {relative}")
        checked.append(str(relative))
    model_payloads = contract.get("model_payloads")
    if not isinstance(model_payloads, list) or not model_payloads:
        raise QueueError("source contract must include model payloads")
    model_root = runtime_root / "reference/input0-neighborhood/models/per-cgra-2x2"
    for row in model_payloads:
        if not isinstance(row, dict) or not isinstance(row.get("path"), str) or not isinstance(row.get("text"), str):
            raise QueueError("source contract contains a malformed model payload")
        relative = Path(row["path"])
        if relative.is_absolute() or ".." in relative.parts:
            raise QueueError(f"source contract model path must be relative and contained: {relative}")
        payload = _regular_file(model_root / relative, "frozen model payload")
        if payload.read_bytes() != row["text"].encode("utf-8"):
            raise QueueError(f"source contract model payload differs from frozen bytes: {relative}")
    return {"replay_payload_count": len(checked), "replay_payloads": checked,
            "model_payload_count": len(model_payloads)}


def _validate_contract_header(contract_path: Path, protocol: Mapping[str, Any]) -> dict[str, Any]:
    contract = _json(contract_path)
    if (contract.get("schema") != "orbit-neighborhood-exact-source-model-contract-v1" or
            contract.get("model_namespace") != protocol.get("model_namespace") or
            contract.get("source_commit") != protocol.get("source_commit") or
            contract.get("immutable_optimizer_pin") != protocol.get("optimizer_pin")):
        raise QueueError("source model contract header differs from protocol model/source/pin binding")
    return contract


def _validate_prior_lane_closure(recovery_path: Path, radar_retry_path: Path) -> tuple[dict[str, Any], dict[str, Any]]:
    recovery = _json(recovery_path)
    retry = _json(radar_retry_path)
    if recovery.get("schema") != OLD_RECOVERY_SCHEMA:
        raise QueueError("prior r4 recovery state has an unexpected schema")
    lanes = recovery.get("lanes")
    workloads = recovery.get("workloads")
    if not isinstance(lanes, dict) or not isinstance(workloads, dict):
        raise QueueError("prior r4 recovery state lacks lane/workload records")
    expected_lanes = {"0": ((0, 1, 2, 3), ("llama", "lu")),
                      "1": ((4, 5, 6, 7), ("harris", "radar"))}
    for lane, (cpus, names) in expected_lanes.items():
        record = lanes.get(lane)
        if (not isinstance(record, dict) or tuple(record.get("cpus", ())) != cpus or
                tuple(record.get("workloads", ())) != names):
            raise QueueError(f"prior r4 lane {lane} does not match its recorded CPU/workload assignment")
    for workload in ("llama", "lu", "harris"):
        record = workloads.get(workload)
        if not isinstance(record, dict) or record.get("status") != "complete" or record.get("exit_code") != 0:
            raise QueueError(f"prior r4 {workload} lane is not recorded complete")
    radar = workloads.get("radar")
    if not isinstance(radar, dict) or radar.get("status") not in {"failed", "complete"}:
        raise QueueError("prior r4 Radar lane is not recorded as a closed failure or completion")
    if ((radar.get("status") == "failed" and radar.get("exit_code") in (None, 0)) or
            (radar.get("status") == "complete" and radar.get("exit_code") != 0)):
        raise QueueError("prior r4 Radar terminal status conflicts with its exit code")
    if (retry.get("schema") != OLD_RADAR_RETRY_SCHEMA or retry.get("workload") != "radar" or
            retry.get("status") != "complete" or retry.get("exit_code") != 0):
        raise QueueError("prior Radar canonical retry is not recorded complete")
    return recovery, retry


def _validate_prior_lane2_terminal(recovery_path: Path, retry_path: Path) -> tuple[dict[str, Any], dict[str, Any]]:
    recovery = _json(recovery_path)
    retry = _json(retry_path)
    if recovery.get("schema") != OLD_RECOVERY_SCHEMA:
        raise QueueError("prior r4 recovery state schema changed while waiting")
    if recovery.get("status") in {"running", "starting"}:
        raise QueueError("prior r4 coordinator still reports active")
    if retry.get("schema") != OLD_RADAR_RETRY_SCHEMA or retry.get("status") != "complete":
        raise QueueError("prior Radar retry is no longer recorded complete")
    prior_workloads = recovery.get("workloads", {})
    if not isinstance(prior_workloads, dict):
        raise QueueError("prior r4 recovery state lacks workload records")
    if any(isinstance(prior_workloads.get(name), dict) and
           prior_workloads[name].get("status") == "running"
           for name in ("gcn", "raytracing-fission")):
        raise QueueError("prior r4 GCN/Ray workload state still reports active after PID exit")
    return recovery, retry


def _proc_identity(pid: int) -> dict[str, Any] | None:
    process_dir = Path("/proc") / str(pid)
    try:
        raw_cmdline = (process_dir / "cmdline").read_bytes()
        raw_stat = (process_dir / "stat").read_text(encoding="ascii")
    except FileNotFoundError:
        return None
    except OSError as error:
        raise QueueError(f"cannot safely inspect host PID {pid}: {error}") from error
    if not raw_cmdline:
        raise QueueError(f"PID {pid} exists but its command line is not observable")
    # Field 22 (start time) follows the closing parenthesis around comm.  This
    # distinguishes an exited process from a later reuse of the same PID.
    close = raw_stat.rfind(")")
    fields = raw_stat[close + 1:].split()
    if close < 0 or len(fields) <= 19:
        raise QueueError(f"cannot parse /proc/{pid}/stat to pin process identity")
    command = raw_cmdline.replace(b"\0", b" ").decode("utf-8", errors="replace").strip()
    return {"pid": pid, "start_time_ticks": fields[19], "cmdline": command}


def _copy_provenance_file(source: Path, destination: Path) -> dict[str, Any]:
    source = _regular_file(source, "provenance input")
    _copy_exact(source, destination)
    return {"source": str(source), "snapshot": str(destination),
            "size_bytes": source.stat().st_size}


def _verify_frozen_runtime(runtime_root: Path, *, source_root: Path) -> dict[str, Any]:
    runtime_root = _regular_directory(runtime_root, "frozen runtime")
    manifest = _json(runtime_root / "freeze-manifest.json")
    if manifest.get("schema") != FREEZE_SCHEMA or manifest.get("source_root") != str(source_root):
        raise QueueError("frozen runtime manifest does not match this artifact root")
    records = manifest.get("overlay_files")
    if not isinstance(records, list):
        raise QueueError("frozen runtime manifest has no overlay file inventory")
    for record in records:
        if not isinstance(record, dict):
            raise QueueError("frozen runtime manifest contains a malformed file row")
        source = _regular_file(Path(str(record.get("source", ""))), "frozen source file")
        target = _regular_file(runtime_root / str(record.get("runtime_relative_path", "")),
                               "frozen runtime file")
        if source.stat().st_size != record.get("size_bytes") or not _stream_equal(source, target):
            raise QueueError(f"frozen runtime bytes differ from current public source: {source}")
        expected_mode = record.get("mode")
        if expected_mode is not None and stat.S_IMODE(target.stat().st_mode) != expected_mode:
            raise QueueError(f"frozen runtime mode differs from its manifest: {target}")
    optimizer_source = _regular_file(Path(str(manifest.get("optimizer_source", ""))),
                                     "accepted optimizer source", executable=True)
    optimizer_relative = str(optimizer_source.relative_to(source_root))
    optimizer_rows = [row for row in records if
                      row.get("source") == str(optimizer_source) and
                      row.get("runtime_relative_path") == optimizer_relative]
    if len(optimizer_rows) != 1:
        raise QueueError("frozen runtime must contain exactly one copied optimizer pin")
    optimizer_path = runtime_root / optimizer_rows[0]["runtime_relative_path"]
    if stat.S_IMODE(optimizer_path.stat().st_mode) != 0o555:
        raise QueueError("frozen optimizer pin must be read-only and executable (mode 0555)")
    contract_source_value = manifest.get("source_contract_source")
    if not isinstance(contract_source_value, str):
        raise QueueError("frozen runtime manifest does not identify the accepted source contract")
    contract_source = _regular_file(Path(contract_source_value), "accepted source contract")
    expected_binding = _validate_contract_payloads(contract_source, artifact_root=source_root,
                                                    runtime_root=runtime_root)
    if manifest.get("source_contract_payload_binding") != expected_binding:
        raise QueueError("source-contract payload binding differs from the frozen runtime manifest")
    return manifest


def prepare_frozen_runtime(*, artifact_root: Path, runtime_root: Path,
                           base_runtime: Path, optimizer: Path,
                           source_contract: Path) -> dict[str, Any]:
    artifact_root = _regular_directory(artifact_root, "artifact root")
    base_runtime = _regular_directory(base_runtime, "base frozen runtime")
    runtime_root = _assert_no_symlink_components(runtime_root)
    if runtime_root.exists():
        return _verify_frozen_runtime(runtime_root, source_root=artifact_root)
    _assert_no_symlink_components(runtime_root.parent).mkdir(parents=True, exist_ok=True)
    staging = runtime_root.with_name(runtime_root.name + f".partial-{os.getpid()}")
    if staging.exists() or staging.is_symlink():
        raise QueueError(f"frozen runtime staging path already exists: {staging}")
    try:
        shutil.copytree(base_runtime, staging, symlinks=True)
        overlay: list[dict[str, Any]] = []
        for dirname in ("scripts", "config", "reference"):
            source = artifact_root / dirname
            target = staging / dirname
            # The freshly copied base must not contain symlinks in overlay
            # trees; following one could write outside the new runtime.
            for current, dirs, files in os.walk(target, followlinks=False):
                for name in dirs + files:
                    candidate = Path(current) / name
                    if candidate.is_symlink():
                        raise QueueError(f"symlink in copied runtime overlay tree: {candidate}")
            overlay.extend(_overlay_files(source, target))
        for source in (optimizer, source_contract):
            relative = source.relative_to(artifact_root)
            target = staging / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            if target.is_symlink():
                raise QueueError(f"symlink blocks frozen pin/contract copy: {target}")
            if target.exists():
                if not target.is_file():
                    raise QueueError(f"non-file blocks frozen pin/contract copy: {target}")
                target.unlink()
            _copy_exact(source, target)
            mode = 0o555 if source == optimizer else stat.S_IMODE(source.stat().st_mode)
            os.chmod(target, mode)
            overlay.append({"source": str(source), "runtime_relative_path": str(relative),
                            "size_bytes": source.stat().st_size, "mode": mode})
        payload_binding = _validate_contract_payloads(source_contract,
                                                      artifact_root=artifact_root,
                                                      runtime_root=staging)
        manifest = {"schema": FREEZE_SCHEMA, "created_utc": _utc_now(),
                    "base_runtime": str(base_runtime), "source_root": str(artifact_root),
                    "optimizer_source": str(optimizer),
                    "source_contract_source": str(source_contract),
                    "overlay_directories": ["scripts", "config", "reference"],
                    "identity_policy": "exact byte comparison; no hash",
                    "overlay_files": overlay,
                    "source_contract_payload_binding": payload_binding}
        _atomic_json(staging / "freeze-manifest.json", manifest)
        for record in overlay:
            source = Path(record["source"])
            target = staging / record["runtime_relative_path"]
            if not _stream_equal(source, target):
                raise QueueError(f"frozen overlay verification failed: {source}")
        os.replace(staging, runtime_root)
        return _verify_frozen_runtime(runtime_root, source_root=artifact_root)
    except BaseException:
        # Keep an interrupted staging tree for inspection; never silently
        # delete an artifact created by a failed freeze.
        raise


def _worker_command(*, python: str, taskset: str, runtime_root: Path,
                    chain_command_file: Path, workload: str,
                    cpus: Sequence[int]) -> list[str]:
    return [taskset, "--cpu-list", f"{cpus[0]}-{cpus[-1]}", python,
            str(runtime_root / "scripts/run_neighborhood_parallel_recovery.py"),
            "--chain-command-file", str(chain_command_file), "--workload", workload,
            "--jobs", "4", "--cleanup-search-temporaries"]


def _next_fixed1x1_root(results_root: Path, protocol: Mapping[str, Any],
                        requested: Path | None = None) -> Path:
    cohort = protocol.get("fixed1x1_cohort_id")
    if cohort != FIXED1X1_COHORT_ID:
        raise QueueError("protocol fixed1x1 cohort ID differs from the v60/r5 name")
    if requested is not None:
        selected = _assert_no_symlink_components(requested)
        if selected.name != cohort or not str(selected).startswith("/tmp/"):
            raise QueueError("fixed1x1 result root must be under /tmp and end in the bound cohort ID")
        return selected
    parent = results_root / "fixed1x1"
    for attempt in range(1, 10000):
        selected = parent / f"attempt-{attempt:04d}" / cohort
        _assert_no_symlink_components(selected)
        if selected.exists() or selected.is_symlink():
            if selected.is_symlink() or not selected.is_dir():
                raise QueueError(f"unsafe fixed1x1 attempt path: {selected}")
            continue
        return selected
    raise QueueError("could not allocate an unused fixed1x1 attempt directory")


def _fixed1x1_command(*, python: str, taskset: str, runtime_root: Path,
                      fixed1x1_root: Path, config_path: Path,
                      protocol: Path, source_contract: Path,
                      optimizer: Path, llvm_build: Path,
                      architecture: Path) -> list[str]:
    return [taskset, "--cpu-list", "0-3", python,
            str(runtime_root / "scripts/run_input0_all_unit_baselines.py"),
            "--config", str(config_path), "--protocol", str(protocol),
            "--source-contract-file", str(source_contract), "--optimizer", str(optimizer),
            "--architecture", str(architecture),
            "--mapping-cache", str(fixed1x1_root / "mapper-cache"),
            "--output-root", str(fixed1x1_root), "--llvm-build", str(llvm_build),
            "--sram-config", str(runtime_root / SRAM_RELATIVE),
            "--inter-task-network", str(runtime_root / NETWORK_RELATIVE),
            "--workloads", *WORKLOADS]


def _chain_command(*, python: str, runtime_root: Path, output_root: Path,
                   config_path: Path, protocol: Path, source_contract: Path,
                   optimizer: Path, architecture: Path) -> list[str]:
    return [python, str(runtime_root / "scripts/run_neighborhood_stage_chain.py"),
            "--config", str(config_path), "--output-root", str(output_root),
            "--protocol", str(protocol), "--source-contract-file", str(source_contract),
            "--optimizer", str(optimizer),
            "--architecture", str(architecture),
            "--sram-config", str(runtime_root / SRAM_RELATIVE),
            "--mapping-cache", str(output_root / "mapper-cache"),
            "--replay-script", str(runtime_root / "scripts/neighborhood_replay.py"),
            "--table-script", str(runtime_root / "scripts/render_neighborhood_table.py"),
            "--workloads", *WORKLOADS, "--jobs", "4", "--stage-initialization", "independent",
            "--max-rounds", "4", "--max-candidates", "4096", "--beam-width", "16",
            "--diversity-slots", "4", "--inter-task-network", str(runtime_root / NETWORK_RELATIVE)]


def _verify_workload_results(results_root: Path, workload: str, *,
                             optimizer: Path, source_contract: Path,
                             protocol: Path, architecture: Path,
                             frozen_architecture: Path,
                             network: Path) -> dict[str, Any]:
    if not _stream_equal(architecture, frozen_architecture):
        raise QueueError("public architecture bytes differ from the frozen runtime snapshot")
    stage_rows: dict[str, Any] = {}
    for stage in STAGES:
        stage_dir = _regular_directory(results_root / workload / stage,
                                       f"{workload}/{stage} result directory")
        result = _json(stage_dir / "result.json")
        source_binding = _json(stage_dir / "source-binding.json")
        binding_path = stage_dir / "source-binding.json"
        if (result.get("status") != "native_replayed" or result.get("numeric") != "pass" or
                result.get("trace") != "pass" or result.get("native_top5_status") != "native_replayed"):
            raise QueueError(f"{workload}/{stage} lacks complete native, trace, and numeric evidence")
        if (source_binding.get("optimizer") != str(optimizer) or
                source_binding.get("source_contract_file") != str(source_contract) or
                source_binding.get("protocol") != str(protocol) or
                source_binding.get("architecture") != str(architecture) or
                source_binding.get("stage_initialization") != "independent" or
                source_binding.get("inter_task_network") != str(network) or
                result.get("source_binding") != str(binding_path)):
            raise QueueError(f"{workload}/{stage} source binding differs from the accepted run")
        cycles = result.get("actual_stage_cycles")
        if not isinstance(cycles, int) or isinstance(cycles, bool) or cycles <= 0:
            raise QueueError(f"{workload}/{stage} has no positive native stage-cycle result")
        stage_rows[stage] = {"status": result["status"], "numeric": result["numeric"],
                             "trace": result["trace"], "native_top5_status": result["native_top5_status"],
                             "actual_stage_cycles": cycles, "result": str(stage_dir / "result.json"),
                             "source_binding": str(binding_path)}
    return {"status": "complete", "phase": "all-five-stages-native-trace-numeric-pass",
            "stages": stage_rows}


def _read_workload_progress(results_root: Path, workload: str) -> dict[str, Any] | None:
    path = results_root / "parallel" / workload / "progress.json"
    if not path.exists():
        return None
    state = _json(path)
    if state.get("schema") != "orbit-neighborhood-parallel-recovery-v1":
        raise QueueError(f"{path} has an unexpected parallel worker schema")
    return state


def _verify_parallel_progress(results_root: Path, workload: str) -> dict[str, Any]:
    progress = _read_workload_progress(results_root, workload)
    if progress is None or progress.get("status") != "complete":
        raise QueueError(f"{workload} parallel recovery progress is not complete")
    if progress.get("stage_order") != list(STAGES):
        raise QueueError(f"{workload} parallel recovery stage order differs from protocol")
    stages = progress.get("stages")
    if not isinstance(stages, dict) or set(stages) != set(STAGES):
        raise QueueError(f"{workload} parallel recovery progress lacks all five stages")
    if any(not isinstance(stages[stage], dict) or stages[stage].get("status") not in {"complete", "reused"}
           for stage in STAGES):
        raise QueueError(f"{workload} parallel recovery contains an incomplete stage")
    return progress


def _freeze_context(args: argparse.Namespace) -> dict[str, Any]:
    root = _regular_directory(args.artifact_root, "artifact root")
    cohort = root / ".work" / COHORT_NAME
    protocol = _regular_file(args.protocol, "bound protocol")
    config_path = _regular_file(args.config, "workload config")
    live_optimizer = _regular_file(args.optimizer, "optimizer pin", executable=True)
    live_source_contract = _regular_file(args.source_contract, "source model contract")
    lowering = _regular_file(args.lowering_acceptance, "canonical-lowering acceptance")
    marker_path = _regular_file(args.acceptance_marker, "native acceptance marker")
    architecture = _regular_file(root / ARCHITECTURE_RELATIVE, "public architecture config")
    sram = _regular_file(root / SRAM_RELATIVE, "public SRAM config")
    public_network = _regular_file(root / NETWORK_RELATIVE, "public common network")
    protocol_json = _json(protocol)
    _validate_protocol(protocol_json, artifact_root=root,
                       optimizer=live_optimizer, source_contract=live_source_contract)
    _validate_contract_header(live_source_contract, protocol_json)
    config = _json(config_path)
    resolved_config = _validate_chain_config(config, config_path=config_path,
                                             lowering_path=lowering,
                                             artifact_root=root,
                                             default_architecture=architecture,
                                             default_protocol=protocol)
    expected_model = _regular_file(root / "reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json",
                                   "protocol common model ensemble")
    if resolved_config[WORKLOADS[0]]["model"] != expected_model:
        raise QueueError("chain config model cache differs from the protocol common model ensemble")
    marker = _validate_acceptance_marker(marker_path, optimizer=live_optimizer,
                                         source_contract=live_source_contract, protocol=protocol,
                                         config_path=config_path)
    runtime_root = _assert_no_symlink_components(args.runtime_root)
    workload_bindings = _validate_workload_bindings(
        resolved_config, artifact_root=root, main_protocol_path=protocol,
        main_protocol=protocol_json, optimizer=live_optimizer,
        source_contract=live_source_contract, runtime_root=runtime_root)
    frozen_optimizer = _assert_no_symlink_components(runtime_root / live_optimizer.relative_to(root))
    frozen_source_contract = _assert_no_symlink_components(runtime_root / live_source_contract.relative_to(root))
    results_root = _assert_no_symlink_components(args.results_root)
    if not results_root.is_absolute() or not str(results_root).startswith("/tmp/"):
        raise QueueError("results root must be a fresh path under /tmp")
    _validate_prior_lane_closure(args.prior_recovery_state, args.prior_radar_retry_state)
    return {"artifact_root": root, "cohort": cohort, "protocol": protocol,
            "protocol_json": protocol_json, "config": config, "config_path": config_path,
            "config_bytes": config_path.read_bytes(),
            "resolved_config": resolved_config, "workload_bindings": workload_bindings,
            "optimizer": frozen_optimizer,
            "source_contract": frozen_source_contract,
            "live_optimizer": live_optimizer, "live_source_contract": live_source_contract,
            "lowering": lowering,
            "acceptance_marker": marker_path, "acceptance": marker,
            "runtime_root": runtime_root, "base_runtime": _regular_directory(args.base_runtime,
                                                                                 "v59-r3 base runtime"),
            "results_root": results_root, "architecture": architecture, "sram": sram,
            "public_network": public_network,
            "prior_recovery_state": _regular_file(args.prior_recovery_state, "prior recovery state"),
            "prior_radar_retry_state": _regular_file(args.prior_radar_retry_state,
                                                       "prior Radar retry state"),
            "prior_gcn_retry_state": _regular_file(args.prior_gcn_retry_state,
                                                     "prior GCN retry state"),
            "llvm_build": _regular_directory(args.llvm_build, "LLVM build directory")}


def _write_freeze(args: argparse.Namespace, context: Mapping[str, Any]) -> dict[str, Any]:
    manifest = prepare_frozen_runtime(artifact_root=context["artifact_root"],
                                      runtime_root=context["runtime_root"],
                                      base_runtime=context["base_runtime"],
                                      optimizer=context["live_optimizer"],
                                      source_contract=context["live_source_contract"])
    payload_binding = _validate_contract_payloads(
        context["live_source_contract"], artifact_root=context["artifact_root"],
        runtime_root=context["runtime_root"])
    manifest["source_contract_payload_binding"] = payload_binding
    return manifest


def _plan(args: argparse.Namespace, context: Mapping[str, Any], *, runtime_ready: bool,
          fixed1x1_root: Path | None = None) -> dict[str, Any]:
    _assert_bound_files_unchanged(context)
    taskset = shutil.which("taskset")
    if taskset is None:
        raise QueueError("taskset is required to enforce the three disjoint four-CPU lanes")
    available = os.sched_getaffinity(0) if hasattr(os, "sched_getaffinity") else set(range(12))
    if not set(range(12)).issubset(available):
        raise QueueError(f"current process affinity does not include CPUs 0-11: {sorted(available)}")
    python = str(Path(sys.executable).resolve())
    runtime_root = context["runtime_root"]
    network = runtime_root / NETWORK_RELATIVE
    frozen_architecture = runtime_root / ARCHITECTURE_RELATIVE
    architecture_matches_frozen = (_stream_equal(context["architecture"], frozen_architecture)
                                   if runtime_ready else None)
    if runtime_ready and not architecture_matches_frozen:
        raise QueueError("public architecture bytes differ from the frozen runtime snapshot")
    workload_architecture_bindings = {}
    for workload in WORKLOADS:
        binding = context["workload_bindings"][workload]
        frozen_path = binding["frozen_architecture"]
        bytes_match = (_stream_equal(binding["architecture"], frozen_path)
                       if runtime_ready else None)
        if runtime_ready and not bytes_match:
            raise QueueError(f"{workload} selected architecture bytes differ from the frozen runtime snapshot")
        workload_architecture_bindings[workload] = {
            "architecture": str(binding["architecture"]),
            "frozen_architecture": str(frozen_path),
            "architecture_bytes_match_frozen": bytes_match,
            "protocol": str(binding["protocol"]),
        }
    fixed_root = _next_fixed1x1_root(context["results_root"], context["protocol_json"],
                                    requested=fixed1x1_root)
    chain = _chain_command(python=python, runtime_root=runtime_root,
                           output_root=context["results_root"], config_path=context["config_path"],
                           protocol=context["protocol"], source_contract=context["source_contract"],
                           optimizer=context["optimizer"],
                           architecture=context["architecture"])
    workers = []
    for lane in LANES:
        for workload in lane["workloads"]:
            workers.append({"lane": lane["index"], "cpus": list(lane["cpus"]),
                            "workload": workload,
                            "argv": _worker_command(python=python, taskset=taskset,
                                                    runtime_root=runtime_root,
                                                    chain_command_file=context["results_root"] / "chain-command.json",
                                                    workload=workload, cpus=lane["cpus"]),
                            "cleanup_search_temporaries": True, "subprocess_timeout": None})
    return {"schema": "orbit-input0-memory-fusion-fission-plan-v1",
            "preflight": "passed", "launchable": runtime_ready,
            "runtime_prepared": runtime_ready,
            "runtime_root": str(runtime_root), "runtime_base": str(context["base_runtime"]),
            "optimizer": str(context["optimizer"]),
            "source_contract": str(context["source_contract"]),
            "protocol": str(context["protocol"]), "config": str(context["config_path"]),
            "architecture": str(context["architecture"]),
            "frozen_architecture": str(frozen_architecture),
            "architecture_bytes_match_frozen": architecture_matches_frozen,
            "workload_bindings": workload_architecture_bindings,
            "acceptance_marker": str(context["acceptance_marker"]),
            "results_root": str(context["results_root"]),
            "fixed1x1_results_root": str(fixed_root),
            "llvm_build": str(context["llvm_build"]),
            "network": str(network),
            "network_bytes_match_current_public_config": (
                _stream_equal(context["public_network"], network) if runtime_ready else None),
            "stage_order": list(STAGES), "workloads": list(WORKLOADS),
            "max_host_cores": 12, "subprocess_timeout": None,
            "fixed1x1_argv": _fixed1x1_command(
                python=python, taskset=taskset, runtime_root=runtime_root,
                fixed1x1_root=fixed_root, config_path=context["config_path"],
                protocol=context["protocol"], source_contract=context["source_contract"],
                optimizer=context["optimizer"], llvm_build=context["llvm_build"],
                architecture=context["architecture"]),
            "fixed1x1_lane_cpus": [0, 1, 2, 3],
            "chain_argv": chain, "worker_commands": workers,
            "old_process_gate": {"required_pids": [OLD_RECOVERY_PID, OLD_GCN_RETRY_PID],
                                 "gate_before_lane": 2,
                                 "host_pid_view_required_for_launch": True},
            "prior_lane_state": {
                "recovery": str(context["prior_recovery_state"]),
                "radar_retry": str(context["prior_radar_retry_state"]),
                "lane0_and_lane1_closed": True}}


def _write_start_provenance(context: Mapping[str, Any], plan: Mapping[str, Any],
                            runtime_manifest: Mapping[str, Any], args: argparse.Namespace) -> None:
    results_root = context["results_root"]
    provenance = results_root / "provenance"
    if provenance.exists() or provenance.is_symlink():
        if provenance.is_symlink() or not provenance.is_dir():
            raise QueueError(f"unsafe provenance path: {provenance}")
    provenance.mkdir(parents=True, exist_ok=True)
    copies = [
        (context["protocol"], provenance / "protocol-bound.json"),
        (context["config_path"], provenance / "input0-chain.json"),
        (context["architecture"], provenance / "public-architecture.yaml"),
        (context["runtime_root"] / ARCHITECTURE_RELATIVE,
         provenance / "frozen-architecture.yaml"),
        (context["runtime_root"] / NETWORK_RELATIVE,
         provenance / "frozen-inter-task-network.yaml"),
        (context["source_contract"], provenance / "source-model-contract.json"),
        (context["live_source_contract"], provenance / "accepted-source-model-contract.json"),
        (context["acceptance_marker"], provenance / "native-acceptance.json"),
        (context["lowering"], provenance / "canonical-source-lowering-acceptance.json"),
    ]
    for workload in WORKLOADS:
        binding = context["workload_bindings"][workload]
        copies.extend((
            (binding["architecture"], provenance / f"{workload}-public-architecture.yaml"),
            (binding["frozen_architecture"], provenance / f"{workload}-frozen-architecture.yaml"),
            (binding["protocol"], provenance / f"{workload}-protocol-bound.json"),
        ))
    snapshots: list[dict[str, Any]] = []
    for source, destination in copies:
        if destination.exists() or destination.is_symlink():
            if destination.is_symlink() or not destination.is_file() or not _stream_equal(source, destination):
                raise QueueError(f"existing provenance snapshot differs: {destination}")
            snapshots.append({"source": str(source), "snapshot": str(destination),
                              "size_bytes": source.stat().st_size})
        else:
            snapshots.append(_copy_provenance_file(source, destination))
    marker = context["acceptance"]
    census_paths = marker["census_paths"]
    census_values = (list(census_paths.values()) if isinstance(census_paths, dict)
                     else list(census_paths))
    census_dir = provenance / "source-cut-census"
    _assert_no_symlink_components(census_dir).mkdir(parents=True, exist_ok=True)
    for index, value in enumerate(census_values):
        source = _regular_file(Path(value), "accepted source-cut census")
        destination = census_dir / f"census-{index:02d}-{source.name}"
        if destination.exists() or destination.is_symlink():
            if destination.is_symlink() or not destination.is_file() or not _stream_equal(source, destination):
                raise QueueError(f"existing source-cut census snapshot differs: {destination}")
            snapshots.append({"source": str(source), "snapshot": str(destination),
                              "size_bytes": source.stat().st_size})
        else:
            snapshots.append(_copy_provenance_file(source, destination))
    for source, stem in ((context["prior_recovery_state"], "prior-r4-recovery-state"),
                         (context["prior_radar_retry_state"], "prior-radar-retry-state"),
                         (context["prior_gcn_retry_state"], "prior-gcn-s2-retry-state")):
        source = _regular_file(source, "prior runtime state")
        attempt = 1
        while True:
            destination = provenance / f"{stem}-observed-{attempt:04d}.json"
            if not destination.exists() and not destination.is_symlink():
                snapshots.append(_copy_provenance_file(source, destination))
                break
            if destination.is_symlink():
                raise QueueError(f"unsafe prior-state snapshot: {destination}")
            if destination.is_file() and _stream_equal(source, destination):
                snapshots.append({"source": str(source), "snapshot": str(destination),
                                  "size_bytes": source.stat().st_size})
                break
            attempt += 1
    command_file = results_root / "chain-command.json"
    if command_file.exists() or command_file.is_symlink():
        existing = _json(command_file)
        if existing != plan["chain_argv"]:
            raise QueueError("existing chain command differs from this exact run")
    else:
        _atomic_json(command_file, plan["chain_argv"])
    plans_dir = provenance / "plans"
    _assert_no_symlink_components(plans_dir).mkdir(parents=True, exist_ok=True)
    attempt = 1
    while True:
        plan_path = plans_dir / f"run-plan-attempt-{attempt:04d}.json"
        if not plan_path.exists() and not plan_path.is_symlink():
            _atomic_json(plan_path, plan)
            break
        if plan_path.is_symlink():
            raise QueueError(f"unsafe run-plan history entry: {plan_path}")
        if _json(plan_path) == plan:
            break
        attempt += 1
    snapshot_number = 1
    while True:
        snapshot_manifest = provenance / f"input-snapshot-manifest-{snapshot_number:04d}.json"
        if not snapshot_manifest.exists() and not snapshot_manifest.is_symlink():
            _atomic_json(snapshot_manifest,
                         {"schema": "orbit-input0-fusion-fission-input-snapshots-v1",
                          "identity_policy": "exact bytes; no hash", "files": snapshots,
                          "frozen_runtime_manifest": str(context["runtime_root"] / "freeze-manifest.json"),
                          "frozen_runtime_overlay_count": len(runtime_manifest.get("overlay_files", [])),
                          "created_utc": _utc_now()})
            break
        if snapshot_manifest.is_symlink():
            raise QueueError(f"unsafe input snapshot manifest: {snapshot_manifest}")
        snapshot_number += 1


def _verify_baseline_source_binding(result: Mapping[str, Any], workload: str,
                                   root: Path, context: Mapping[str, Any]) -> None:
    selected = context["workload_bindings"][workload]
    expected_paths = {
        "optimizer": context["optimizer"],
        "source_contract": context["source_contract"],
        "protocol": selected["protocol"],
        "architecture": selected["architecture"],
        "inter_task_network": context["runtime_root"] / NETWORK_RELATIVE,
    }
    for key, expected in expected_paths.items():
        if result.get(key) != str(expected):
            raise QueueError(f"{workload} fixed1x1 {key} binding differs from the accepted run")
    network = _regular_file(context["runtime_root"] / NETWORK_RELATIVE,
                            "frozen inter-task network")
    network_text = network.read_text(encoding="utf-8")
    if result.get("inter_task_network_text") != network_text:
        raise QueueError(f"{workload} fixed1x1 network contents differ from the frozen runtime")
    public_architecture = _regular_file(selected["architecture"], f"{workload} public architecture")
    frozen_architecture = _regular_file(selected["frozen_architecture"],
                                        f"{workload} frozen architecture")
    if not _stream_equal(public_architecture, frozen_architecture):
        raise QueueError(f"{workload} public architecture bytes differ from the frozen runtime snapshot")
    source_record = context["resolved_config"].get(workload)
    if not isinstance(source_record, dict) or not isinstance(source_record.get("canonical"), Path):
        raise QueueError(f"{workload} has no validated configured canonical source")
    configured = _regular_file(source_record["canonical"], f"{workload} configured canonical")
    canonical_copy = _regular_file(root / workload / "canonical-input.mlir",
                                   f"{workload} fixed1x1 canonical copy")
    if (result.get("canonical_input") != str(canonical_copy) or
            not _stream_equal(configured, canonical_copy)):
        raise QueueError(f"{workload} fixed1x1 canonical copy differs from its configured source")


def _verify_ray_model_domain_exclusion(result: Mapping[str, Any], row: Mapping[str, Any],
                                       result_path: Path, root: Path,
                                       context: Mapping[str, Any]) -> dict[str, Any]:
    """Verify the one permitted Ray fixed1x1 N/A using native predictor evidence.

    This is strictly a model-domain exclusion. It cannot authorize a mapper
    failure or a missing native, trace, or numeric result for any measured row.
    """
    if (result.get("schema") != "orbit-input0-all-unit-native-v1" or
            result.get("status") != "unsupported-model-domain" or
            result.get("baseline_cycles") is not None or result.get("formal_go") is not False or
            result.get("ml_model_consumed") is not False or
            result.get("domain_preflight_model_prediction_consumed") is not True or
            result.get("actual_cycles_claim", "none") != "none" or
            result.get("mapper_equality") != "not-run" or
            result.get("numeric") != "not-run" or
            result.get("independent_trace") != "not-run" or
            result.get("sram_gate") != "not-run" or
            result.get("trace", "not-run") != "not-run"):
        raise QueueError("Ray model-domain exclusion must have no measured baseline, mapper, trace, or numeric claim")
    result_commands = result.get("commands")
    if not isinstance(result_commands, dict) or set(result_commands) != {"domain-space", "domain-predictor"}:
        raise QueueError("Ray model-domain exclusion may record only successful native space/predictor commands")
    for name, command in result_commands.items():
        if not isinstance(command, dict) or command.get("status") != "finished" or command.get("exit_code") != 0:
            raise QueueError(f"Ray model-domain {name} command lacks a successful native receipt")

    ray_dir = _regular_directory(root / "raytracing", "Ray model-domain output directory")
    expected_admission = ray_dir / "model-domain-admission.json"
    if result.get("domain_admission") != str(expected_admission):
        raise QueueError("Ray result does not point at its attempt-local model-domain admission receipt")
    receipt = _json(_regular_file(expected_admission, "Ray model-domain admission receipt"))
    binding = context["workload_bindings"]["raytracing"]
    source = context["resolved_config"]["raytracing"]
    canonical_copy = _regular_file(root / "raytracing" / "canonical-input.mlir",
                                   "Ray all-unit canonical input")
    configured_canonical = _regular_file(source["canonical"], "configured original Ray canonical")
    configured_cost_catalog = _regular_file(source["parent_cost"], "Ray parent cost catalog")
    if result.get("canonical_input") != str(canonical_copy) or not _stream_equal(configured_canonical, canonical_copy):
        raise QueueError("Ray domain exclusion is not bound to the exact configured original canonical")

    expected_space_path = ray_dir / "domain-space.jsonl"
    expected_catalog_path = ray_dir / "domain-cost-catalog.json"
    space_path = _regular_file(expected_space_path, "Ray C++ all-unit space witness")
    catalog_path = _regular_file(expected_catalog_path, "Ray C++ all-unit cost catalog")
    if receipt.get("space_file") != str(space_path) or receipt.get("cost_catalog") != str(catalog_path):
        raise QueueError("Ray admission receipt does not point at its attempt-local native outputs")
    receipt_canonical = receipt.get("canonical_input")
    if (receipt_canonical not in (str(canonical_copy), str(configured_canonical)) or
            not _stream_equal(Path(str(receipt_canonical)), canonical_copy)):
        raise QueueError("Ray domain receipt does not bind the exact configured original canonical")
    configured_catalog = _json(configured_cost_catalog)

    canonical_text = canonical_copy.read_text(encoding="utf-8")
    functions = re.findall(r'\bsym_name\s*=\s*"([^"]+)"', canonical_text)
    if len(functions) != 1:
        raise QueueError("Ray exact canonical must identify exactly one source function")
    function = functions[0]

    expected_fields = {
        "schema": "orbit-input0-all-unit-model-domain-admission-v1",
        "status": "unsupported-model-domain",
        "kind": "compiler-proved-lower-bound-exceeds-configured-runtime-ceiling",
        "workload": "raytracing",
        "task": "Task_13",
        "optimizer": str(context["optimizer"]),
        "source_contract": str(context["source_contract"]),
        "protocol": str(binding["protocol"]),
        "architecture": str(binding["architecture"]),
        "function": function,
        "runtime_ii_ceiling": 23,
        "training_ii_ceiling": 20,
        "cost_catalog": str(catalog_path),
        "formal_go": False,
        "mapper_invoked": False,
        "canonical_module_witness_matches_input": True,
    }
    for key, expected in expected_fields.items():
        if receipt.get(key) != expected:
            raise QueueError(f"Ray model-domain admission receipt has an unaccepted {key} field")

    try:
        space_rows = [json.loads(line) for line in space_path.read_text(encoding="utf-8").splitlines()
                      if line.strip()]
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
        raise QueueError(f"Ray native all-unit space witness is unreadable: {error}") from error
    if len(space_rows) != 2 or not all(isinstance(item, dict) for item in space_rows):
        raise QueueError("Ray native all-unit space must contain one exact manifest and footer")
    space, footer = space_rows
    factors = space.get("factors")
    if (space.get("schema") != "amoeba-analytical-task-space" or
            space.get("record_type") != "space" or
            space.get("representation") != "factored" or
            space.get("function") != function or
            space.get("graph_variant_id") != "identity" or
            space.get("max_cgras_per_task") != 1 or
            space.get("exact") is not True or
            space.get("candidate_count") not in (1, "1") or
            not isinstance(factors, list)):
        raise QueueError("Ray native space witness does not bind a single identity all-unit candidate")
    factor_tasks = [factor.get("task") for factor in factors if isinstance(factor, dict)]
    if factor_tasks != list(RAY_TASK_IDS):
        raise QueueError("Ray native space witness does not preserve the complete ordered 27-task source inventory")
    if any(not isinstance(factor.get("shapes"), list) or len(factor["shapes"]) != 1 or
           not isinstance(factor["shapes"][0], dict) or
           factor["shapes"][0].get("cgra_count") != 1 or
           factor["shapes"][0].get("rows") != 1 or factor["shapes"][0].get("cols") != 1
           or factor["shapes"][0].get("mapper_tile_rows") != 2
           or factor["shapes"][0].get("mapper_tile_cols") != 2
           or not isinstance(factor.get("trip_count"), int)
           or isinstance(factor.get("trip_count"), bool)
           or factor.get("trip_count") <= 0
           for factor in factors):
        raise QueueError("Ray native space witness is not the all-unit identity shape assignment")
    if (footer.get("schema") != "amoeba-analytical-task-space" or
            footer.get("record_type") != "footer" or
            footer.get("representation") != "factored" or
            footer.get("candidate_count") not in (1, "1") or
            footer.get("exact") is not True or
            footer.get("status") != "unranked-factored-space"):
        raise QueueError("Ray all-unit space footer does not certify one complete exact candidate")

    catalog = _json(catalog_path)
    if (not isinstance(catalog, dict) or catalog.get("schema") != "amoeba-task-shape-cost" or
            catalog.get("function") != function or
            catalog.get("namespace") != binding["protocol_json"].get("model_namespace")):
        raise QueueError("Ray native cost catalog schema/function/namespace differs from the bound model")
    if (not isinstance(configured_catalog, dict) or
            configured_catalog.get("schema") != catalog.get("schema") or
            configured_catalog.get("function") != catalog.get("function") or
            configured_catalog.get("namespace") != catalog.get("namespace")):
        raise QueueError("Ray native unit predictor catalog identity differs from the configured parent catalog")
    metadata = catalog.get("predictor_metadata")
    model_path = _regular_file(source["model"], "Ray pinned direct-model ensemble")
    model = _json(model_path)
    if not isinstance(metadata, dict):
        raise QueueError("Ray native cost catalog has no predictor metadata")
    architecture_text = binding["architecture"].read_text(encoding="utf-8")
    standard_architecture = _regular_file(context["artifact_root"] / ARCHITECTURE_RELATIVE,
                                          "standard architecture")
    standard_text = standard_architecture.read_text(encoding="utf-8")
    expected_diagnostic_override = {
        "schema": "per-cgra-2x2-ii-extrapolation-v1",
        "training_ii_ceiling": 20,
        "runtime_ii_ceiling": 23,
        "training_architecture_exact_yaml_text": standard_text,
        "runtime_architecture_exact_yaml_text": architecture_text,
        "extrapolation_enabled": True,
        "formal": False,
        "output_rule": "min(lower_bound + softplus(logit), diagnostic_runtime_ii_ceiling)",
    }
    canonical_witness = metadata.get("canonical_module_witness")
    if (not canonical_text.endswith("\n") or
            canonical_witness != canonical_text[:-1] or
            metadata.get("architecture_path") != str(binding["architecture"]) or
            metadata.get("architecture_contract") !=
            "neura-architecture-v1:" + binding["architecture"].stem or
            metadata.get("candidate_only") is not True or
            metadata.get("diagnostic_only") is not True or
            metadata.get("formal") is not False or
            metadata.get("model_interval_max_ii") != 20 or
            metadata.get("model") != RAY_NATIVE_MODEL or
            metadata.get("model_schema") != "orbit-cgra-ii-per-cgra-2x2-direct-ensemble-cpp-v1" or
            metadata.get("source_graph_id") != "identity" or
            metadata.get("source_repository") != binding["protocol_json"].get("source_git_repository") or
            metadata.get("source_commit") != binding["protocol_json"].get("source_commit") or
            metadata.get("source_task_ids") != list(RAY_TASK_IDS) or
            metadata.get("source_model") != model.get("source_model") or
            metadata.get("direct_ensemble") != {
                "member_count": 4, "member_seeds": [17, 41, 113, 239],
                "reduction": "arithmetic_mean",
                "uncertainty": "population_standard_deviation"} or
            metadata.get("diagnostic_override") != expected_diagnostic_override):
        raise QueueError("Ray native predictor metadata differs from the exact architecture/model/source/canonical binding")

    configured_metadata = configured_catalog.get("predictor_metadata")
    if not isinstance(configured_metadata, dict):
        raise QueueError("Ray configured parent catalog has no predictor provenance")
    # candidate_count describes the input space (the parent catalog covers a
    # larger set than this one-candidate unit preflight). All model, source,
    # canonical-module, architecture, and inference metadata must still agree.
    native_metadata = dict(metadata)
    configured_metadata = dict(configured_metadata)
    native_metadata.pop("candidate_count", None)
    configured_metadata.pop("candidate_count", None)
    if configured_metadata != native_metadata:
        raise QueueError("Ray native unit predictor metadata differs from the configured parent catalog")

    entries = catalog.get("entries")
    if not isinstance(entries, list) or len(entries) != len(RAY_TASK_IDS) * len(RAY_COST_SHAPES):
        raise QueueError("Ray native parent-cost catalog must contain the complete 27-by-8 predictor inventory")
    by_task_shape: dict[tuple[str, int, int], Mapping[str, Any]] = {}
    for entry in entries:
        if not isinstance(entry, dict):
            raise QueueError("Ray native parent-cost catalog contains a malformed row")
        task = entry.get("task")
        tile_rows = entry.get("mapper_tile_rows")
        tile_cols = entry.get("mapper_tile_cols")
        if (task not in RAY_TASK_IDS or (tile_rows, tile_cols) not in RAY_COST_SHAPES or
                (task, tile_rows, tile_cols) in by_task_shape or
                entry.get("runtime_ceiling_ii") != 23 or
                entry.get("training_ceiling_ii") != 20):
            raise QueueError("Ray native parent-cost catalog has an unexpected/duplicate shape query")
        by_task_shape[(task, tile_rows, tile_cols)] = entry
    expected_task_shapes = {(task, rows, cols) for task in RAY_TASK_IDS
                            for rows, cols in RAY_COST_SHAPES}
    if set(by_task_shape) != expected_task_shapes:
        raise QueueError("Ray native parent-cost catalog does not cover every task and legal PE shape")
    configured_entries = configured_catalog.get("entries")
    if not isinstance(configured_entries, list) or len(configured_entries) != len(expected_task_shapes):
        raise QueueError("Ray configured parent catalog lacks the complete 27-by-8 task/shape inventory")
    configured_by_task_shape = {}
    for entry in configured_entries:
        if not isinstance(entry, dict):
            raise QueueError("Ray configured parent catalog contains a malformed row")
        key = (entry.get("task"), entry.get("mapper_tile_rows"), entry.get("mapper_tile_cols"))
        if key not in expected_task_shapes or key in configured_by_task_shape:
            raise QueueError("Ray configured parent catalog has an unexpected/duplicate task/shape query")
        configured_by_task_shape[key] = entry
    if set(configured_by_task_shape) != expected_task_shapes:
        raise QueueError("Ray configured parent catalog does not cover every legal task/shape query")
    for key, entry in by_task_shape.items():
        configured_entry = configured_by_task_shape[key]
        if entry != configured_entry:
            raise QueueError("Ray native unit predictor query differs from the configured parent catalog")

    unit_rows = {task: by_task_shape[(task, 2, 2)] for task in RAY_TASK_IDS}
    blockers = [entry for entry in unit_rows.values()
                if entry.get("support_status") == "unsupported" or
                entry.get("status") == "unsupported-model-domain"]
    if len(blockers) != 1 or blockers[0].get("task") != "Task_13" or receipt.get("blocking_rows") != blockers:
        raise QueueError("Ray exclusion blocking row differs from the exact C++ parent cost catalog row")
    for task, unit_row in unit_rows.items():
        if task == "Task_13":
            continue
        predicted = unit_row.get("predicted_ii")
        if (unit_row.get("support_status") != "supported" or
                unit_row.get("status") == "unsupported-model-domain" or
                not isinstance(predicted, (int, float)) or isinstance(predicted, bool) or
                predicted <= 0 or predicted > 23):
            raise QueueError(f"Ray fixed1x1 predictor query for {task} is not supported under II=23")
    native_row = blockers[0]
    if (native_row.get("analytical_lower_bound") != 83 or
            native_row.get("mapper_tile_rows") != 2 or native_row.get("mapper_tile_cols") != 2 or
            native_row.get("runtime_ceiling_ii") != 23 or native_row.get("training_ceiling_ii") != 20 or
            native_row.get("support_status") != "unsupported" or
            native_row.get("status") != "unsupported-model-domain" or
            native_row.get("unsupported_reason") != "analytical-lower-bound-exceeds-diagnostic-runtime-ceiling" or
            native_row.get("extrapolation_status") != "outside-diagnostic-runtime-domain" or
            native_row.get("model_interval_max_ii") != 20 or
            native_row.get("analytical_lower_bound") <= 23 or
            "predicted_ii" in native_row):
        raise QueueError("Ray C++ predictor row does not prove the accepted 83 > 23 model-domain bound")

    proof = receipt.get("canonical_source_proof")
    expected_identity = source["source_identity_record"]
    expected_lowering_record = source["canonical_lowering_record"]
    if (not isinstance(proof, dict) or set(proof) != {
            "source_identity_record", "canonical_lowering_record",
            "source_input0_outputs_exact_bytes_equal", "native_generic_input0_bytes_equal",
            "exact_r4_canonical_bytes_equal", "original_unfissioned_input",
            "canonical_matches_lowered_artifact_exact_bytes"} or
            proof.get("source_identity_record") != str(expected_identity) or
            proof.get("canonical_lowering_record") != str(expected_lowering_record) or
            proof.get("source_input0_outputs_exact_bytes_equal") is not True or
            proof.get("native_generic_input0_bytes_equal") is not True or
            proof.get("exact_r4_canonical_bytes_equal") is not True or
            proof.get("original_unfissioned_input") is not True or
            proof.get("canonical_matches_lowered_artifact_exact_bytes") is not True):
        raise QueueError("Ray domain receipt lacks the exact accepted original-source and canonical-lowering records")
    identity = _json(_regular_file(expected_identity, "Ray original source identity record"))
    lowering_record = _json(_regular_file(expected_lowering_record, "Ray canonical-lowering source record"))
    if (identity.get("schema") != "orbit-amoeba-original-ray-input0-source-identity-v1" or
            identity.get("artifact_input") != str(context["artifact_root"] / RAY_SOURCE_INPUT_RELATIVE) or
            identity.get("binding") != {"argument": 0, "value": 1472} or
            identity.get("native_generic_input0_bytes_equal") is not True or
            identity.get("no_source_fission") is not True):
        raise QueueError("Ray original-source identity record does not prove the input-0 unfissioned witness")
    lowering_rows = _json(context["lowering"])
    ray_lowering = [entry for entry in lowering_rows if isinstance(entry, dict) and
                    entry.get("workload") == "raytracing"]
    if (len(ray_lowering) != 1 or
            ray_lowering[0].get("exact_r4_canonical_bytes_equal") is not True or
            Path(str(ray_lowering[0].get("pre_neura", ""))) != source["prepared"] or
            not _stream_equal(Path(str(ray_lowering[0].get("lowered", ""))), configured_canonical)):
        raise QueueError("Ray canonical-lowering witness is not unique")
    for field in ("source", "pre_neura", "lowered"):
        record_value = lowering_record.get(field)
        accepted_value = ray_lowering[0].get(field)
        if not isinstance(record_value, str) or record_value != accepted_value:
            raise QueueError(f"Ray canonical-lowering record {field} path differs from the accepted lowering manifest")
        _regular_file(Path(record_value), f"Ray canonical-lowering {field} witness")
    if (lowering_record.get("canonical") != str(configured_canonical) or
            not _stream_equal(Path(str(lowering_record.get("canonical", ""))), canonical_copy)):
        raise QueueError("Ray canonical-lowering record does not bind the configured canonical path and bytes")
    if (lowering_record.get("schema") != "orbit-original-ray-canonical-lowering-repair-v1" or
            lowering_record.get("exact_r4_canonical_bytes_equal") is not True or
            lowering_record.get("original_unfissioned_input") is not True or
            not _stream_equal(Path(lowering_record["pre_neura"]), source["prepared"]) or
            not _stream_equal(Path(lowering_record["lowered"]), configured_canonical)):
        raise QueueError("Ray canonical-lowering record does not bind the exact configured original module")

    for name, command in result_commands.items():
        command_path = ray_dir / f"{name}.command.json"
        if _json(_regular_file(command_path, f"Ray {name} native command record")) != command:
            raise QueueError(f"Ray {name} command record differs from result.json")
        argv = command.get("argv") if isinstance(command, dict) else None
        if (not isinstance(argv, list) or len(argv) < 8 or
                argv[0] != str(context["optimizer"]) or
                argv[1] not in (str(canonical_copy), str(configured_canonical)) or
                not _stream_equal(Path(argv[1]), canonical_copy) or
                "--verify-each" not in argv or
                f"--architecture-spec={binding['architecture']}" not in argv or
                f"--joint-inter-task-network-spec={context['runtime_root'] / NETWORK_RELATIVE}" not in argv or
                argv[-3:] != ["--mlir-print-op-generic", "-o", "/dev/null"]):
            raise QueueError(f"Ray {name} command is not a native query of the bound canonical under the accepted target")
        for log_field, log_suffix in (("stdout_log", "stdout"), ("stderr_log", "stderr")):
            log_value = command.get(log_field)
            expected_log = ray_dir / f"{name}.{log_suffix}.gz"
            if log_value != str(expected_log):
                raise QueueError(f"Ray {name} command has an unexpected {log_field}")
            _regular_file(expected_log, f"Ray {name} {log_field}")

    public_model_ensemble = _regular_file(_resolve_template_path(
        binding["protocol_json"].get("model_ensemble"), context["artifact_root"],
        "Ray model_ensemble"), "Ray public model ensemble")
    model_ensemble = _regular_file(_resolve_template_path(
        binding["protocol_json"].get("model_ensemble"), context["runtime_root"],
        "Ray frozen model_ensemble"), "Ray frozen model ensemble")
    if not _stream_equal(public_model_ensemble, model_ensemble):
        raise QueueError("Ray frozen predictor model bytes differ from the public model")
    expected_space_option = (
        f"--enumerate-analytical-task-candidates=function={function} output={space_path} "
        "factored-output=true max-cgras-per-task=1 graph-variant-id=identity")
    expected_predictor_option = "--predict-analytical-task-cost-catalog=" + " ".join((
        f"function={function}", f"space-file={space_path}",
        f"ensemble-file={model_ensemble}", f"checkpoint-dir={model_ensemble.parent}",
        "architecture-contract=neura-architecture-v1:" + binding["architecture"].stem,
        f"architecture-path={binding['architecture']}",
        "source-git-repository=" + binding["protocol_json"]["source_git_repository"],
        "source-git-commit=" + binding["protocol_json"]["source_commit"],
        "graph-variant-id=identity",
        "model-namespace=" + binding["protocol_json"]["model_namespace"],
        f"cache={ray_dir / 'domain-ml-cache.json'}",
        f"output={catalog_path}",
        "allow-unsupported-above-model-ceiling=true",
        "diagnostic-ii-ceiling=23"))
    for name, expected_option in (("domain-space", expected_space_option),
                                  ("domain-predictor", expected_predictor_option)):
        argv = result_commands[name]["argv"]
        if argv.count(expected_option) != 1:
            raise QueueError(f"Ray {name} native command options differ from the exact model-domain request")
    _regular_file(ray_dir / "domain-ml-cache.json", "Ray native predictor cache")

    receipt_commands = receipt.get("commands")
    if not isinstance(receipt_commands, dict) or set(receipt_commands) != {"domain-space", "domain-predictor"}:
        raise QueueError("Ray model-domain receipt must name only the native space and predictor checks")
    for name, command in receipt_commands.items():
        if (not isinstance(command, dict) or command != result_commands.get(name) or
                command.get("status") != "finished" or command.get("exit_code") != 0):
            raise QueueError(f"Ray admission receipt {name} command did not complete successfully")
    for forbidden in ("mapper", "native", "numeric", "trace", "mapped.mlir",
                      "independent-trace.json", "numeric-summary.json", "all-unit.mlir", "rank-0"):
        if (ray_dir / forbidden).exists() or (ray_dir / forbidden).is_symlink():
            raise QueueError(f"Ray model-domain exclusion unexpectedly has a {forbidden} output")
    return {"status": "unsupported-model-domain", "baseline_cycles": None,
            "result": str(result_path), "domain_admission": str(expected_admission),
            "task": "Task_13", "analytical_lower_bound": 83,
            "runtime_ii_ceiling": 23, "training_ii_ceiling": 20}


def _verify_fixed1x1_results(root: Path, context: Mapping[str, Any]) -> dict[str, Any]:
    _assert_bound_files_unchanged(context)
    root = _regular_directory(root, "fixed1x1 result root")
    if root.name != FIXED1X1_COHORT_ID:
        raise QueueError("fixed1x1 result directory name differs from the bound protocol cohort")
    summary_path = _regular_file(root / "summary.json", "fixed1x1 summary")
    summary = _json(summary_path)
    if not isinstance(summary, list):
        raise QueueError("fixed1x1 summary must contain the six workload result rows")
    summary_by_workload = {}
    for row in summary:
        if not isinstance(row, dict) or row.get("workload") not in WORKLOADS:
            raise QueueError("fixed1x1 summary contains an unknown/malformed workload row")
        if row["workload"] in summary_by_workload:
            raise QueueError(f"fixed1x1 summary contains duplicate workload {row['workload']}")
        summary_by_workload[row["workload"]] = row
    if set(summary_by_workload) != set(WORKLOADS):
        raise QueueError("fixed1x1 summary does not cover all six workloads")
    workloads: dict[str, Any] = {}
    for workload in WORKLOADS:
        result_path = _regular_file(root / workload / "result.json",
                                    f"{workload} fixed1x1 result")
        result = _json(result_path)
        if not isinstance(result, dict):
            raise QueueError(f"{workload} fixed1x1 result must be a JSON object")
        if result.get("workload") != workload:
            raise QueueError(f"{workload} fixed1x1 result names a different workload")
        _verify_baseline_source_binding(result, workload, root, context)
        row = summary_by_workload[workload]
        if workload == "raytracing" and result.get("status") == "unsupported-model-domain":
            exclusion = _verify_ray_model_domain_exclusion(result, row, result_path, root, context)
            if (row.get("status") != "unsupported-model-domain" or
                    row.get("baseline_cycles") is not None):
                raise QueueError("Ray fixed1x1 summary row disagrees with its model-domain exclusion")
            for key in ("optimizer", "source_contract", "protocol", "architecture",
                        "inter_task_network", "canonical_input"):
                if row.get(key) != result.get(key):
                    raise QueueError(f"Ray model-domain summary/result {key} fields differ")
            workloads[workload] = exclusion
            continue
        if (result.get("status") != "complete" or result.get("numeric") != "pass" or
                result.get("independent_trace") != "pass" or
                result.get("mapper_equality") != "pass"):
            raise QueueError(f"{workload} fixed1x1 baseline lacks native/trace/numeric validation")
        commands = result.get("commands")
        if not isinstance(commands, dict):
            raise QueueError(f"{workload} fixed1x1 lacks its production command records")
        for command_name in ("materialize", "mapper", "native", "numeric"):
            command = commands.get(command_name)
            if (not isinstance(command, dict) or command.get("status") != "finished" or
                    command.get("exit_code") != 0):
                raise QueueError(f"{workload} fixed1x1 lacks a successful {command_name} command")
        cycles = result.get("baseline_cycles")
        if not isinstance(cycles, int) or isinstance(cycles, bool) or cycles <= 0:
            raise QueueError(f"{workload} fixed1x1 baseline has no positive native cycle result")
        if row.get("status") != "complete":
            raise QueueError(f"{workload} fixed1x1 summary row is not complete")
        for key in ("baseline_cycles", "optimizer", "source_contract", "protocol",
                    "architecture", "inter_task_network", "canonical_input"):
            if row.get(key) != result.get(key):
                raise QueueError(f"{workload} fixed1x1 summary/result {key} fields differ")
        workloads[workload] = {"status": "complete", "baseline_cycles": cycles,
                               "result": str(result_path),
                               "independent_trace": result["independent_trace"],
                               "numeric": result["numeric"],
                               "mapper_equality": result["mapper_equality"]}
    status = ("complete-with-model-domain-exclusion"
              if workloads.get("raytracing", {}).get("status") == "unsupported-model-domain"
              else "complete")
    return {"status": status, "summary": str(summary_path), "workloads": workloads}


def _verify_fixed1x1_state(state: Mapping[str, Any], context: Mapping[str, Any]) -> dict[str, Any]:
    """Revalidate closed baseline evidence and its per-workload state bindings."""
    root_value = state.get("fixed1x1_results_root")
    if not isinstance(root_value, str):
        raise QueueError("closed fixed1x1 state does not identify its result directory")
    verified = _verify_fixed1x1_results(Path(root_value), context)
    if state.get("fixed1x1_status") != verified["status"]:
        raise QueueError("closed fixed1x1 state status differs from its independently verified summary")
    saved = state.get("fixed1x1")
    workloads = state.get("workloads")
    if not isinstance(saved, dict) or saved.get("status") != verified["status"] or \
            saved.get("summary") != verified["summary"] or not isinstance(workloads, dict):
        raise QueueError("closed fixed1x1 state summary does not match its result files")
    for workload in WORKLOADS:
        result_row = verified["workloads"][workload]
        summary_row = saved.get("workloads", {}).get(workload)
        workload_state = workloads.get(workload)
        if (not isinstance(summary_row, dict) or not isinstance(workload_state, dict) or
                summary_row.get("status") != result_row.get("status") or
                summary_row.get("baseline_cycles") != result_row.get("baseline_cycles") or
                summary_row.get("result") != result_row.get("result") or
                workload_state.get("baseline_status") != result_row.get("status") or
                workload_state.get("baseline_cycles") != result_row.get("baseline_cycles") or
                workload_state.get("baseline_result") != result_row.get("result")):
            raise QueueError(f"closed fixed1x1 {workload} state differs from independently verified files")
    return verified


def _child_environment(context: Mapping[str, Any]) -> dict[str, str]:
    environment = os.environ.copy()
    environment["ORBIT_LLVM_BUILD"] = str(context["llvm_build"])
    return environment


def _run_fixed1x1(args: argparse.Namespace, context: Mapping[str, Any],
                  plan: Mapping[str, Any], state_path: Path,
                  state: dict[str, Any]) -> bool:
    root = Path(plan["fixed1x1_results_root"])
    if root.exists():
        try:
            verified = _verify_fixed1x1_results(root, context)
        except QueueError as error:
            state.setdefault("fixed1x1_attempts", []).append({
                "results_root": str(root), "status": "preserved-incomplete",
                "reason": str(error), "observed_utc": _utc_now()})
            state["fixed1x1_status"] = "incomplete"
            state["fixed1x1_failure"] = str(error)
            for workload in WORKLOADS:
                state["workloads"][workload]["baseline_status"] = "incomplete"
            _persist_state(state_path, state)
            return False
        state.update(fixed1x1_results_root=str(root), fixed1x1_status=verified["status"],
                     fixed1x1=verified)
        for workload, baseline in verified["workloads"].items():
            state["workloads"][workload].update(
                baseline_status=baseline["status"],
                baseline_cycles=baseline.get("baseline_cycles"),
                baseline_result=baseline["result"])
        return True
    _assert_no_symlink_components(root.parent).mkdir(parents=True, exist_ok=True)
    command = list(plan["fixed1x1_argv"])
    _assert_bound_files_unchanged(context)
    log_path = context["results_root"] / "logs" / "fixed1x1.log"
    _assert_no_symlink_components(log_path.parent).mkdir(parents=True, exist_ok=True)
    if log_path.exists() or log_path.is_symlink():
        attempt = 1
        while True:
            candidate = log_path.with_name(f"fixed1x1-attempt-{attempt:04d}.log")
            if not candidate.exists() and not candidate.is_symlink():
                log_path = candidate
                break
            attempt += 1
    state.update(phase="running-fresh-fixed1x1-six-workload-baseline",
                 fixed1x1_status="running", fixed1x1_results_root=str(root),
                 fixed1x1_argv=command, fixed1x1_log=str(log_path),
                 fixed1x1_attempt_started_utc=_utc_now())
    for workload in WORKLOADS:
        state["workloads"][workload].update(baseline_status="running",
                                            baseline_results_root=str(root))
    _persist_state(state_path, state)
    try:
        with log_path.open("xb") as log:
            process = subprocess.Popen(command, cwd=context["runtime_root"],
                                        stdout=log, stderr=subprocess.STDOUT,
                                        close_fds=True, start_new_session=True,
                                        env=_child_environment(context))
            state["fixed1x1_pid"] = process.pid
            _persist_state(state_path, state)
            while process.poll() is None:
                time.sleep(args.poll_interval_seconds)
                state["phase"] = "running-fresh-fixed1x1-six-workload-baseline"
                _persist_state(state_path, state)
            exit_code = process.returncode
    except OSError as error:
        state.update(fixed1x1_status="failed", fixed1x1_failure=f"{type(error).__name__}: {error}",
                     phase="fixed1x1-launch-failed", ended_utc=_utc_now())
        for workload in WORKLOADS:
            state["workloads"][workload]["baseline_status"] = "incomplete"
        _persist_state(state_path, state)
        return False
    state["fixed1x1_exit_code"] = exit_code
    state["fixed1x1_ended_utc"] = _utc_now()
    if exit_code != 0:
        state.update(fixed1x1_status="failed", fixed1x1_failure=f"fixed1x1 command exited {exit_code}",
                     phase="fixed1x1-command-failed")
        for workload in WORKLOADS:
            state["workloads"][workload]["baseline_status"] = "incomplete"
        _persist_state(state_path, state)
        return False
    try:
        verified = _verify_fixed1x1_results(root, context)
    except QueueError as error:
        state.update(fixed1x1_status="incomplete", fixed1x1_failure=str(error),
                     phase="fixed1x1-final-evidence-incomplete")
        for workload in WORKLOADS:
            state["workloads"][workload]["baseline_status"] = "incomplete"
        _persist_state(state_path, state)
        return False
    for workload, baseline in verified["workloads"].items():
        state["workloads"][workload].update(
            baseline_status=baseline["status"],
            baseline_cycles=baseline.get("baseline_cycles"),
            baseline_result=baseline["result"])
    state.update(fixed1x1_status=verified["status"], fixed1x1=verified,
                 phase="fixed1x1-complete")
    _persist_state(state_path, state)
    return True


def _verify_all_results(context: Mapping[str, Any]) -> dict[str, dict[str, Any]]:
    _assert_bound_files_unchanged(context)
    verified: dict[str, dict[str, Any]] = {}
    network = context["runtime_root"] / NETWORK_RELATIVE
    for workload in WORKLOADS:
        _verify_parallel_progress(context["results_root"], workload)
        verified[workload] = _verify_workload_results(
            context["results_root"], workload, optimizer=context["optimizer"],
            source_contract=context["source_contract"],
            protocol=context["workload_bindings"][workload]["protocol"],
            architecture=context["workload_bindings"][workload]["architecture"],
            frozen_architecture=context["workload_bindings"][workload]["frozen_architecture"],
            network=network)
    return verified


def _check_resume_state(context: Mapping[str, Any], state_path: Path) -> dict[str, Any] | None:
    results_root = context["results_root"]
    exists = results_root.exists()
    state_exists = state_path.exists()
    if exists != state_exists:
        raise QueueError("resume requires both the result root and coordinator state, or neither")
    if not exists:
        return None
    state = _json(state_path)
    if state.get("schema") != STATE_SCHEMA or state.get("cohort_id") != COHORT_NAME:
        raise QueueError("existing result root belongs to another coordinator schema/cohort")
    for key, path in (("optimizer", context["optimizer"]),
                      ("source_contract", context["source_contract"]),
                      ("protocol", context["protocol"]),
                      ("config", context["config_path"]),
                      ("architecture", context["architecture"]),
                      ("frozen_architecture", context["runtime_root"] / ARCHITECTURE_RELATIVE),
                      ("results_root", results_root),
                      ("runtime_root", context["runtime_root"])):
        if state.get(key) != str(path):
            raise QueueError(f"existing coordinator state has a different {key}")
    expected_workload_bindings = {
        workload: {"architecture": str(context["workload_bindings"][workload]["architecture"]),
                   "frozen_architecture": str(context["workload_bindings"][workload]["frozen_architecture"]),
                   "protocol": str(context["workload_bindings"][workload]["protocol"])}
        for workload in WORKLOADS}
    if state.get("workload_bindings") != expected_workload_bindings:
        raise QueueError("existing coordinator state has different per-workload source bindings")
    if state.get("architecture_bytes_match_frozen") is not True:
        raise QueueError("existing coordinator state lacks the frozen architecture byte binding")
    if state.get("accepted_optimizer") != str(context["live_optimizer"]):
        raise QueueError("existing coordinator accepted optimizer path differs")
    if state.get("accepted_source_contract") != str(context["live_source_contract"]):
        raise QueueError("existing coordinator accepted source-contract path differs")
    provenance = results_root / "provenance"
    config_snapshot = _regular_file(provenance / "input0-chain.json",
                                    "existing workload-config byte witness")
    if not _stream_equal(context["config_path"], config_snapshot):
        raise QueueError("workload config bytes differ from the existing run's exact input snapshot")
    for workload in WORKLOADS:
        protocol_snapshot = _regular_file(provenance / f"{workload}-protocol-bound.json",
                                          f"existing {workload} protocol byte witness")
        if not _stream_equal(context["workload_bindings"][workload]["protocol"], protocol_snapshot):
            raise QueueError(f"{workload} protocol bytes differ from the existing run's exact input snapshot")
        architecture_snapshot = _regular_file(provenance / f"{workload}-public-architecture.yaml",
                                              f"existing {workload} architecture byte witness")
        if not _stream_equal(context["workload_bindings"][workload]["architecture"], architecture_snapshot):
            raise QueueError(f"{workload} architecture bytes differ from the existing run's exact input snapshot")
    return state


def _initial_state(context: Mapping[str, Any], plan: Mapping[str, Any],
                   args: argparse.Namespace) -> dict[str, Any]:
    return {"schema": STATE_SCHEMA, "cohort_id": COHORT_NAME,
            "optimizer": str(context["optimizer"]),
            "accepted_optimizer": str(context["live_optimizer"]),
            "source_contract": str(context["source_contract"]),
            "accepted_source_contract": str(context["live_source_contract"]),
            "protocol": str(context["protocol"]), "config": str(context["config_path"]),
            "architecture": str(context["architecture"]),
            "frozen_architecture": str(context["runtime_root"] / ARCHITECTURE_RELATIVE),
            "architecture_bytes_match_frozen": True,
            "workload_bindings": {
                workload: {"architecture": str(context["workload_bindings"][workload]["architecture"]),
                           "frozen_architecture": str(context["workload_bindings"][workload]["frozen_architecture"]),
                           "protocol": str(context["workload_bindings"][workload]["protocol"])}
                for workload in WORKLOADS},
            "acceptance_marker": str(context["acceptance_marker"]),
            "results_root": str(context["results_root"]),
            "runtime_root": str(context["runtime_root"]),
            "runtime_base": str(context["base_runtime"]),
            "status": "starting", "phase": "preflight-complete",
            "pid": os.getpid(), "argv": list(sys.argv),
            "stage_order": list(STAGES), "subprocess_timeout": None,
            "max_host_cores": 12, "compile_and_link_jobs": 1,
            "started_utc": _utc_now(), "ended_utc": None,
            "fixed1x1_status": "queued",
            "fixed1x1_results_root": str(plan["fixed1x1_results_root"]),
            "fixed1x1_attempts": [],
            "host_pid_view_verified": bool(args.host_pid_view_verified),
            "old_process_wait": {"pids": [OLD_RECOVERY_PID, OLD_GCN_RETRY_PID],
                                 "status": "pending", "observations": []},
            "lanes": {str(lane["index"]): {
                "cpus": list(lane["cpus"]), "workloads": list(lane["workloads"]),
                "status": "queued", "active_workload": None}
                for lane in LANES},
            "workloads": {workload: {"status": "queued", "phase": "queued",
                                     "lane": next(lane["index"] for lane in LANES
                                                  if workload in lane["workloads"]),
                                     "stage_order": list(STAGES)}
                          for workload in WORKLOADS},
            "plan": dict(plan)}


def _persist_state(path: Path, state: dict[str, Any]) -> None:
    state["updated_utc"] = _utc_now()
    _atomic_json(path, state)
    results_copy = Path(state["results_root"]) / "coordinator-state.json"
    if results_copy != path:
        _atomic_json(results_copy, state)


def _process_wait(context: Mapping[str, Any], state_path: Path,
                  state: dict[str, Any]) -> bool:
    """Poll the two old host PIDs without blocking first-lane progress."""
    gate = state["old_process_wait"]
    tracked = gate.setdefault("tracked", {})
    observations = []
    for pid in (OLD_RECOVERY_PID, OLD_GCN_RETRY_PID):
        key = str(pid)
        current = _proc_identity(pid)
        previous = tracked.get(key)
        if previous is None:
            tracked[key] = ({"status": "active", "identity": current} if current is not None
                            else {"status": "absent", "identity": None})
        elif previous.get("status") == "absent":
            if current is not None:
                raise QueueError(f"old PID {pid} appeared after the host gate observed it absent")
        elif previous.get("status") == "active":
            identity = previous.get("identity")
            if current is not None and isinstance(identity, dict) and (
                    current.get("start_time_ticks") != identity.get("start_time_ticks") or
                    current.get("cmdline") != identity.get("cmdline")):
                raise QueueError(f"old PID {pid} was reused before its exit was observed")
            if current is None:
                tracked[key] = {"status": "absent", "identity": identity,
                                "exited_observed_utc": _utc_now()}
        else:
            raise QueueError(f"old PID gate has malformed tracking state for {pid}")
        observations.append({"pid": pid, **tracked[key]})
    gate.setdefault("observations", []).append({"observed_utc": _utc_now(),
                                                 "processes": observations})
    if any(tracked[str(pid)]["status"] != "absent" for pid in (OLD_RECOVERY_PID, OLD_GCN_RETRY_PID)):
        gate["status"] = "waiting"
        state["phase"] = "waiting-for-prior-r4-gcn-lane-to-close"
        _persist_state(state_path, state)
        return False
    old_recovery, old_retry = _validate_prior_lane2_terminal(
        context["prior_recovery_state"], context["prior_radar_retry_state"])
    retry = _json(context["prior_gcn_retry_state"])
    if retry.get("schema") != "orbit-full-input0-followup-canonical-retry-v1":
        raise QueueError("prior GCN S2 retry state has an unexpected schema")
    if retry.get("status") not in {"complete", "failed", "incomplete"}:
        raise QueueError("prior GCN S2 retry is not recorded terminal after its PID exited")
    gate.update(status="closed", closed_utc=_utc_now(),
                recovery_status=old_recovery.get("status"),
                gcn_retry_status=retry.get("status"),
                radar_retry_status=old_retry.get("status"))
    state["phase"] = "old-r4-lane-closed"
    _persist_state(state_path, state)
    return True


def _run_cohort(args: argparse.Namespace, context: Mapping[str, Any],
                runtime_manifest: Mapping[str, Any], plan: Mapping[str, Any]) -> int:
    results_root = context["results_root"]
    state_path = context["artifact_root"] / ".work" / "post-publication" / \
        "full-input0-memory-fusion-fission-r9-original-ray-ii23-queue-v2-runtime-20261006.json"
    _assert_no_symlink_components(state_path.parent).mkdir(parents=True, exist_ok=True)
    if state_path.is_symlink():
        raise QueueError(f"coordinator public state is a symlink: {state_path}")
    state_old = _check_resume_state(context, state_path)
    if results_root.exists() and (results_root.is_symlink() or not results_root.is_dir()):
        raise QueueError(f"results root is unsafe: {results_root}")
    if state_old is not None and not args.resume:
        raise QueueError("existing results require --resume after exact binding checks")
    if state_old is None and args.resume:
        raise QueueError("--resume was requested but no prior coordinator run exists")
    _assert_no_symlink_components(results_root.parent).mkdir(parents=True, exist_ok=True)
    if not results_root.exists():
        results_root.mkdir(parents=True, exist_ok=False)
    lock_path = results_root / ".coordinator.lock"
    if lock_path.is_symlink():
        raise QueueError(f"coordinator lock is a symlink: {lock_path}")
    lock_flags = os.O_CREAT | os.O_RDWR | getattr(os, "O_NOFOLLOW", 0)
    lock_fd = os.open(lock_path, lock_flags, 0o600)
    with os.fdopen(lock_fd, "a+") as lock:
        try:
            fcntl.flock(lock.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError as error:
            raise QueueError("another coordinator already owns this results root") from error
        if state_old is not None and state_old.get("status") == "complete":
            _verify_fixed1x1_state(state_old, context)
            _verify_all_results(context)
            raise QueueError("this exact cohort is already complete; refusing duplicate launch")
        if state_old is not None:
            state = state_old
            if state.get("plan", {}).get("chain_argv") != plan["chain_argv"]:
                raise QueueError("existing coordinator command differs from the exact frozen chain command")
            for workload in WORKLOADS:
                record = state.get("workloads", {}).get(workload, {})
                if record.get("status") == "complete":
                    _verify_workload_results(results_root, workload,
                                             optimizer=context["optimizer"],
                                             source_contract=context["source_contract"],
                                             protocol=context["workload_bindings"][workload]["protocol"],
                                             architecture=context["workload_bindings"][workload]["architecture"],
                                             frozen_architecture=context["workload_bindings"][workload]["frozen_architecture"],
                                             network=context["runtime_root"] / NETWORK_RELATIVE)
                worker_pid = record.get("worker_pid")
                if record.get("status") == "running" and isinstance(worker_pid, int):
                    if _proc_identity(worker_pid) is not None:
                        raise QueueError(f"cannot resume while prior {workload} worker {worker_pid} is active")
            state["status"] = "running"
            state["phase"] = "resuming-exact-bound-workload-progress"
            state["pid"] = os.getpid()
            state["argv"] = list(sys.argv)
            old_fixed_root = state.get("fixed1x1_results_root")
            if state.get("fixed1x1_status") in FIXED1X1_CLOSED_STATUSES and isinstance(old_fixed_root, str):
                fixed_root = Path(old_fixed_root)
                _verify_fixed1x1_state(state, context)
            else:
                if state.get("fixed1x1_status") == "running" and isinstance(state.get("fixed1x1_pid"), int):
                    if _proc_identity(state["fixed1x1_pid"]) is not None:
                        raise QueueError("cannot resume while the prior fixed1x1 baseline process is active")
                fixed_root = _next_fixed1x1_root(results_root, context["protocol_json"])
                if isinstance(old_fixed_root, str):
                    state.setdefault("fixed1x1_attempts", []).append({
                        "results_root": old_fixed_root,
                        "status": state.get("fixed1x1_status", "incomplete"),
                        "preserved": True, "observed_utc": _utc_now()})
                state["fixed1x1_results_root"] = str(fixed_root)
                state["fixed1x1_status"] = "queued"
            plan = _plan(args, context, runtime_ready=True, fixed1x1_root=fixed_root)
            state.setdefault("plan_history", []).append(state.get("plan", {}))
            state["plan"] = dict(plan)
        else:
            fixed_root = _next_fixed1x1_root(results_root, context["protocol_json"])
            plan = _plan(args, context, runtime_ready=True, fixed1x1_root=fixed_root)
            state = _initial_state(context, plan, args)
            state["status"] = "running"
        state["fixed1x1_results_root"] = plan["fixed1x1_results_root"]
        _write_start_provenance(context, plan, runtime_manifest, args)
        _persist_state(state_path, state)

        # The exact six-program 1x1 native/trace/numeric baseline gets CPU
        # 0-3 first, before any four-worker neighborhood lane is started.
        if state.get("fixed1x1_status") not in FIXED1X1_CLOSED_STATUSES:
            if not _run_fixed1x1(args, context, plan, state_path, state):
                state.update(status="incomplete", phase="fixed1x1-baseline-incomplete",
                             ended_utc=_utc_now())
                _persist_state(state_path, state)
                return 2
        else:
            state["phase"] = "fixed1x1-complete-reused-exactly"
            _persist_state(state_path, state)
        mapping_cache = results_root / "mapper-cache"
        _assert_no_symlink_components(mapping_cache).mkdir(parents=True, exist_ok=True)

        # Prepare the exact shared byte contract before launching parallel
        # per-workload workers, avoiding concurrent initialization races.
        scripts_dir = context["runtime_root"] / "scripts"
        sys.path.insert(0, str(scripts_dir))
        try:
            import run_neighborhood_stage_chain as chain
            chain_options, config_path = chain._parse_args(plan["chain_argv"][2:])
            config = chain.load_config(config_path)
            config["config_base"] = str(config_path.parent.resolve())
            chain._validate_options(chain_options)
            chain.validate_stage_inputs(config, chain_options,
                                        config_base=config_path.parent.resolve())
            manifest = chain._ensure_contract_snapshot(
                context["results_root"], chain._contract_specs(
                    config, chain_options, config_base=config_path.parent.resolve()))
        except (ImportError, OSError, ValueError, json.JSONDecodeError, AttributeError) as error:
            state.update(status="incomplete", phase="contract-preparation-failed",
                         failure=f"{type(error).__name__}: {error}", ended_utc=_utc_now())
            _persist_state(state_path, state)
            raise QueueError(f"cannot prepare exact chain source contract: {error}") from error
        state["contract_manifest"] = str(manifest)
        _persist_state(state_path, state)

        taskset = shutil.which("taskset")
        if taskset is None:
            raise QueueError("taskset disappeared after preflight")
        python = str(Path(sys.executable).resolve())
        lane_offsets = {}
        for lane in LANES:
            offset = 0
            while offset < len(lane["workloads"]):
                workload = lane["workloads"][offset]
                if state["workloads"].get(workload, {}).get("status") != "complete":
                    break
                offset += 1
            lane_offsets[lane["index"]] = offset
        running: dict[str, dict[str, Any]] = {}
        lane2_released = False

        def start_workload(lane: Mapping[str, Any], workload: str) -> None:
            _assert_bound_files_unchanged(context)
            command = _worker_command(python=python, taskset=taskset,
                                      runtime_root=context["runtime_root"],
                                      chain_command_file=results_root / "chain-command.json",
                                      workload=workload, cpus=lane["cpus"])
            attempt = int(state["workloads"][workload].get("worker_attempt", 0)) + 1
            log_path = results_root / "logs" / f"{workload}-attempt-{attempt:04d}.log"
            _assert_no_symlink_components(log_path.parent).mkdir(parents=True, exist_ok=True)
            if log_path.exists() or log_path.is_symlink():
                raise QueueError(f"worker log already exists; use a clean resume record: {log_path}")
            log = log_path.open("xb")
            try:
                process = subprocess.Popen(command, cwd=context["runtime_root"],
                                            stdout=log, stderr=subprocess.STDOUT,
                                            close_fds=True, start_new_session=True,
                                            env=_child_environment(context))
            except OSError:
                log.close()
                raise
            log.close()
            state["workloads"][workload].update(status="running", phase="five-stage-search",
                                                worker_attempt=attempt,
                                                started_utc=_utc_now(), worker_pid=process.pid,
                                                argv=command, log=str(log_path),
                                                cpu_affinity=list(lane["cpus"]))
            state["lanes"][str(lane["index"])].update(status="running", active_workload=workload)
            running[workload] = {"process": process, "lane": lane, "argv": command,
                                 "log": log_path}
            _persist_state(state_path, state)

        def finish_workload(workload: str, exit_code: int) -> None:
            item = running.pop(workload)
            lane = item["lane"]
            record = state["workloads"][workload]
            record["exit_code"] = exit_code
            record["ended_utc"] = _utc_now()
            progress = _read_workload_progress(results_root, workload)
            if progress is not None:
                record["parallel_progress"] = str(results_root / "parallel" / workload / "progress.json")
                record["parallel_status"] = progress.get("status")
                record["stage_statuses"] = {
                    name: details.get("status") for name, details in progress.get("stages", {}).items()
                    if isinstance(details, dict)}
            if exit_code == 0:
                try:
                    progress = _verify_parallel_progress(results_root, workload)
                    verified = _verify_workload_results(
                        results_root, workload, optimizer=context["optimizer"],
                        source_contract=context["source_contract"],
                        protocol=context["workload_bindings"][workload]["protocol"],
                        architecture=context["workload_bindings"][workload]["architecture"],
                        frozen_architecture=context["workload_bindings"][workload]["frozen_architecture"],
                        network=context["runtime_root"] / NETWORK_RELATIVE)
                    record.update(verified)
                    record["parallel_status"] = progress.get("status")
                except QueueError as error:
                    record.update(status="incomplete", phase="final-evidence-check-failed",
                                  failure=str(error))
            else:
                record.update(status="failed", phase="worker-exit-nonzero",
                              failure=f"parallel worker exited {exit_code}")
            state["lanes"][str(lane["index"])].update(active_workload=None,
                                                         last_workload=workload,
                                                         last_exit_code=exit_code)
            _persist_state(state_path, state)

        # Lanes 0 and 1 are already closed in the prior runtime, so start their
        # fresh r5 passes immediately.  The old GCN/Ray lane remains a barrier.
        for index in (0, 1):
            lane = LANES[index]
            if lane_offsets[index] < len(lane["workloads"]):
                state["lanes"][str(index)]["status"] = "running"
                start_workload(lane, lane["workloads"][lane_offsets[index]])
            else:
                state["lanes"][str(index)]["status"] = "complete"
                state["lanes"][str(index)]["ended_utc"] = _utc_now()
        state["phase"] = "running-first-two-fresh-lanes"
        _persist_state(state_path, state)

        while any(lane_offsets[index] < len(LANES[index]["workloads"]) for index in range(3)) or running:
            for workload, item in list(running.items()):
                exit_code = item["process"].poll()
                if exit_code is None:
                    continue
                finish_workload(workload, exit_code)
                lane = item["lane"]
                lane_index = lane["index"]
                lane_offsets[lane_index] += 1
                if lane_offsets[lane_index] < len(lane["workloads"]):
                    next_workload = lane["workloads"][lane_offsets[lane_index]]
                    if lane_index != 2 or lane2_released:
                        start_workload(lane, next_workload)
                else:
                    state["lanes"][str(lane_index)]["status"] = "complete"
                    state["lanes"][str(lane_index)]["ended_utc"] = _utc_now()
                    _persist_state(state_path, state)
            if not lane2_released and lane_offsets[2] < len(LANES[2]["workloads"]):
                # The wait runs while lanes 0 and 1 continue.  It is indefinite
                # by design: no mapper timeout and no process termination.
                if _process_wait(context, state_path, state):
                    lane2_released = True
                    start_workload(LANES[2], LANES[2]["workloads"][lane_offsets[2]])
            time.sleep(args.poll_interval_seconds)

        state["ended_utc"] = _utc_now()
        try:
            _verify_fixed1x1_state(state, context)
            verified = _verify_all_results(context)
        except QueueError as error:
            state.update(status="incomplete", phase="final-cohort-validation-failed",
                         failure=str(error))
            _persist_state(state_path, state)
            return 2
        for workload, record in verified.items():
            state["workloads"][workload].update(record)
        state.update(status="complete", phase="all-six-workloads-five-stages-validated",
                     final_validation="native replay, independent trace, numeric, and exact source binding passed")
        _persist_state(state_path, state)
        return 0


def _arguments(argv: Sequence[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--prepare-runtime", action="store_true",
                      help="copy v59-r3 and overlay current scripts/config/reference, without running mapper jobs")
    mode.add_argument("--launch", action="store_true",
                      help="launch the durable 12-CPU coordinator after all acceptance gates")
    mode.add_argument("--status", action="store_true", help="print the public runtime status JSON")
    parser.add_argument("--artifact-root", type=Path, default=ARTIFACT_ROOT)
    parser.add_argument("--protocol", type=Path)
    parser.add_argument("--config", type=Path)
    parser.add_argument("--optimizer", type=Path)
    parser.add_argument("--source-contract", type=Path)
    parser.add_argument("--lowering-acceptance", type=Path)
    parser.add_argument("--acceptance-marker", type=Path)
    parser.add_argument("--base-runtime", type=Path)
    parser.add_argument("--runtime-root", type=Path)
    parser.add_argument("--results-root", type=Path)
    parser.add_argument("--fixed1x1-results-root", type=Path,
                        help="optional unused /tmp path whose basename matches the protocol's fixed1x1 cohort ID")
    parser.add_argument("--llvm-build", type=Path, default=DEFAULT_LLVM_BUILD)
    parser.add_argument("--prior-recovery-state", type=Path)
    parser.add_argument("--prior-radar-retry-state", type=Path)
    parser.add_argument("--prior-gcn-retry-state", type=Path)
    parser.add_argument("--poll-interval-seconds", type=int, default=300)
    parser.add_argument("--host-pid-view-verified", action="store_true",
                        help="confirm /proc here is the host process namespace before the old-PID barrier")
    parser.add_argument("--resume", action="store_true",
                        help="resume an exact existing run root after verifying every bound input")
    return parser.parse_args(argv)


def _fill_defaults(args: argparse.Namespace) -> None:
    root = Path(args.artifact_root).absolute()
    cohort = root / ".work" / COHORT_NAME
    defaults = {
        "protocol": cohort / "protocol-bound-original-ray-ii23-r9-queue-v2.json",
        "config": cohort / "input0-chain-original-ray-ii23-r9-queue-v2.json",
        "optimizer": root / ".work/control-variables-and-tiling-20261006/mlir-amoeba-opt-memory-fusion-fission-r9-original-ray-ii23-stable-features-20261006",
        "source_contract": root / ".work/control-variables-and-tiling-20261006/source-model-contract-memory-fusion-fission-r9-original-ray-ii23-stable-features-queue-v2-20261006.json",
        "lowering_acceptance": root / ".work/source-fission-original-ray-repair-20261006/canonical-source-lowering-acceptance.json",
        "acceptance_marker": root / ".work/control-variables-and-tiling-20261006/memory-fusion-fission-r9-queue-v2-native-acceptance-20261006.json",
        "base_runtime": root / ".work/shared-scheduler-artifact-runtime-v59-r3",
        "runtime_root": Path("/tmp/orbit-input0-v60-memory-fusion-fission-r5-20261006/runtime-frozen-r6"),
        "results_root": Path("/tmp/orbit-input0-v60-memory-fusion-fission-r5-20261006/results-original-ray-v6/" + COHORT_NAME),
        "prior_recovery_state": root / ".work/post-publication/full-input0-inplace-proof-r4-recovery-runtime-20261006.json",
        "prior_radar_retry_state": root / ".work/post-publication/radar-r4-independent-retry-runtime-20261006.json",
        "prior_gcn_retry_state": root / ".work/post-publication/full-input0-inplace-proof-r4-final-retry-runtime-20261006.json",
    }
    for name, value in defaults.items():
        if getattr(args, name) is None:
            setattr(args, name, value)
        setattr(args, name, Path(getattr(args, name)).absolute())
    args.llvm_build = Path(args.llvm_build).absolute()
    if args.fixed1x1_results_root is not None:
        args.fixed1x1_results_root = Path(args.fixed1x1_results_root).absolute()
    args.artifact_root = root


def main(argv: Sequence[str] | None = None) -> int:
    args = _arguments(argv)
    _fill_defaults(args)
    state_path = args.artifact_root / ".work/post-publication/full-input0-memory-fusion-fission-r9-original-ray-ii23-queue-v2-runtime-20261006.json"
    try:
        if args.poll_interval_seconds <= 0:
            raise QueueError("poll interval must be positive")
        if args.status:
            state = _json(state_path)
            print(json.dumps(state, indent=2, sort_keys=True))
            return 0
        if args.launch and not args.host_pid_view_verified:
            raise QueueError("--launch requires --host-pid-view-verified; the default exec sandbox may hide host PIDs")
        context = _freeze_context(args)
        if args.prepare_runtime:
            manifest = _write_freeze(args, context)
            plan = _plan(args, context, runtime_ready=True,
                         fixed1x1_root=args.fixed1x1_results_root)
            print(json.dumps({"status": "prepared", "runtime_root": str(context["runtime_root"]),
                              "overlay_file_count": len(manifest["overlay_files"]),
                              "plan": plan}, indent=2, sort_keys=True))
            return 0
        runtime_manifest = None
        if context["runtime_root"].exists():
            runtime_manifest = _verify_frozen_runtime(context["runtime_root"],
                                                       source_root=context["artifact_root"])
            runtime_manifest["source_contract_payload_binding"] = _validate_contract_payloads(
                context["live_source_contract"], artifact_root=context["artifact_root"],
                runtime_root=context["runtime_root"])
        if not args.launch:
            plan = _plan(args, context, runtime_ready=runtime_manifest is not None,
                         fixed1x1_root=args.fixed1x1_results_root)
            print(json.dumps(plan, indent=2, sort_keys=True))
            return 0
        if runtime_manifest is None:
            runtime_manifest = _write_freeze(args, context)
        plan = _plan(args, context, runtime_ready=True,
                     fixed1x1_root=args.fixed1x1_results_root)
        if not plan["network_bytes_match_current_public_config"]:
            raise QueueError("frozen network bytes differ from the current public network config")
        recovery, retry = _validate_prior_lane_closure(
            context["prior_recovery_state"], context["prior_radar_retry_state"])
        print(json.dumps({"status": "launching", "recovery_state": recovery.get("status"),
                          "radar_retry_status": retry.get("status"),
                          "plan": plan}, indent=2, sort_keys=True), flush=True)
        return _run_cohort(args, context, runtime_manifest, plan)
    except (QueueError, OSError, ValueError, json.JSONDecodeError) as error:
        if args.launch and state_path.is_file() and not state_path.is_symlink():
            try:
                state = _json(state_path)
                if state.get("pid") == os.getpid() and state.get("status") in {"starting", "running"}:
                    state.update(status="incomplete", phase="coordinator-error",
                                 failure=f"{type(error).__name__}: {error}", ended_utc=_utc_now())
                    _persist_state(state_path, state)
            except (QueueError, OSError, ValueError, json.JSONDecodeError):
                pass
        print(f"input0 memory/fusion/fission queue error: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
