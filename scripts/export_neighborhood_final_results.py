#!/usr/bin/env python3
"""Publish a compact, portable reducer of a complete neighborhood cohort.

Candidate order and identities are copied from the C++ stage records. Native
stage cycles and winner identity use the existing render_neighborhood_table
reducer; this script does not rescore, re-rank, or select predicted candidates.
"""
from __future__ import annotations

import argparse
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path, PurePosixPath
from typing import Any, Iterable, Mapping

from render_neighborhood_table import STAGES, _native_cycles, render_markdown, stage_row


EXPECTED_STAGE_SCHEMA = "orbit-neighborhood-stage-result-v1"
EXPECTED_BINDING_SCHEMA = "orbit-neighborhood-source-binding-v1"
EXPECTED_CHECKPOINT_BINDING_SCHEMA = "orbit-neighborhood-exact-binding-v1"
EXPECTED_CHECKPOINT_SCHEMAS = {
    "orbit-neighborhood-search-checkpoint-v2",
    "orbit-neighborhood-search-checkpoint-v4",
}
FINAL_SCHEMA = "orbit-neighborhood-final-results-v1"
TABLE_SCHEMA = "orbit-neighborhood-stage-table-v1"
EXPECTED_STALE_PROTOCOL_FIELDS = {
    "optimizer_pin": ".work/post-publication/mlir-amoeba-opt-v17-source-domain-final",
    "source_contract_file": ".work/post-publication/source-model-contract-v17-source-domain.json",
    "source_variant": "correct-complete-source-iteration-domains-v17-generic-lossless",
}
EFFECTIVE_V19_SOURCE_VARIANT = "v19-corrected-neighborhood"
LOCAL_PATH_RE = re.compile(r"(?<![\w])/(?:home|tmp|Users|private|var/tmp)/[^\s\"'<>]+")
SHA_RE = re.compile(r"(?i)\b[0-9a-f]{40,64}\b")


class ExportError(ValueError):
    pass


def read_json(path: Path, label: str) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError) as exc:
        raise ExportError(f"cannot read {label}: {path}: {exc}") from exc
    if not isinstance(value, dict):
        raise ExportError(f"{label} must be a JSON object: {path}")
    return value


def _repo_relative(value: str, repo_root: Path, label: str) -> str:
    """Turn a bound path into a portable repository-relative symbol."""
    if not isinstance(value, str) or not value:
        raise ExportError(f"{label} is missing")
    if value.startswith("${ARTIFACT_ROOT}/"):
        value = value[len("${ARTIFACT_ROOT}/"):]
    if value.startswith("${ORBIT_SRC}/"):
        return value
    candidate = Path(value)
    if candidate.is_absolute():
        try:
            value = candidate.resolve(strict=False).relative_to(repo_root.resolve()).as_posix()
        except ValueError as exc:
            raise ExportError(f"{label} is outside the repository root") from exc
    path = PurePosixPath(value)
    if path.is_absolute() or ".." in path.parts:
        raise ExportError(f"{label} is not a portable repository-relative path")
    return path.as_posix()


def _bound_file_path(value: str, repo_root: Path, label: str) -> tuple[str, Path]:
    symbol = _repo_relative(value, repo_root, label)
    if symbol.startswith("${ORBIT_SRC}/"):
        raise ExportError(f"{label} points outside the artifact repository")
    return symbol, repo_root / symbol


def _clean_text(value: str, repo_root: Path) -> str:
    text = value.replace(str(repo_root.resolve()), "${ARTIFACT_ROOT}")
    return LOCAL_PATH_RE.sub("<local-path>", text)


def _portable(value: Any, repo_root: Path) -> Any:
    if isinstance(value, str):
        return _clean_text(value, repo_root)
    if isinstance(value, list):
        return [_portable(item, repo_root) for item in value]
    if isinstance(value, dict):
        return {str(key): _portable(item, repo_root) for key, item in value.items()}
    return value


def _assert_portable(value: Any, path: str = "$") -> None:
    if isinstance(value, str):
        if LOCAL_PATH_RE.search(value) or "/home/" in value or "/tmp/" in value:
            raise ExportError(f"non-portable local path survived at {path}")
        if SHA_RE.search(value):
            raise ExportError(f"commit/hash-like token survived at {path}")
    elif isinstance(value, list):
        for index, item in enumerate(value):
            _assert_portable(item, f"{path}[{index}]")
    elif isinstance(value, dict):
        for key, item in value.items():
            _assert_portable(item, f"{path}.{key}")


def _maybe_int(value: Any) -> bool:
    return isinstance(value, int) and not isinstance(value, bool)


def _small_native_command(value: Any) -> dict[str, Any] | None:
    if not isinstance(value, Mapping):
        return None
    keep = ("status", "exit_code", "started_utc", "ended_utc")
    return {key: value[key] for key in keep if key in value}


def _evidence_summary(pointer: Any, *, repo_root: Path, kind: str) -> dict[str, Any] | None:
    if not isinstance(pointer, str) or not pointer:
        return None
    try:
        symbol, path = _bound_file_path(pointer, repo_root, f"{kind} evidence")
    except ExportError:
        return {"status": "summary_unavailable", "reason": "evidence pointer is not repository-local"}
    if not path.is_file():
        return {"status": "summary_unavailable", "reason": "evidence file is missing"}
    try:
        raw = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError):
        return {"status": "summary_unavailable", "reason": "evidence file is not readable JSON"}
    if not isinstance(raw, Mapping):
        return {"status": "summary_unavailable", "reason": "evidence file is not a JSON object"}
    if kind == "numeric":
        keys = (
            "schema", "workload", "scope", "stage", "rank", "negative_control",
            "expected_mismatches", "mismatches", "element_comparisons", "actual_nonzero",
            "expected_nonzero", "compiler_owned_fixture_and_execution", "stage_admission", "status",
        )
    else:
        keys = (
            "schema", "status", "production_ready", "policy", "actual_overflow_proven",
            "conservative_capacity_proven", "conservative_upper_bound_exceeds_capacity",
            "alias_proof_complete", "copy_binding_proof_complete", "extent_proof_complete",
            "indexed_address_proof_complete", "indexed_address_proof_count", "indexed_load_count",
            "indexed_store_count", "indexed_storage_coverage_complete",
            "indexed_storage_coverage_count", "indexed_storage_coverage_failure_count",
            "observed_access_count", "placement_proof_complete", "task_count", "reason",
        )
    summary = {key: raw[key] for key in keys if key in raw}
    # The source filename and independent shared-library path are intentionally
    # omitted; the exact source cohort is summarized once at the document level.
    summary["summary_source"] = "inline projection of " + symbol
    return summary


def _error_fields(record: Mapping[str, Any], repo_root: Path) -> dict[str, Any]:
    terms = ("error", "fail", "block", "reason", "timeout")
    excluded = ("_command", "_evidence", "stdout", "stderr", "argv")
    output: dict[str, Any] = {}
    for key, value in record.items():
        lowered = key.lower()
        if not any(term in lowered for term in terms) or any(token in lowered for token in excluded):
            continue
        if isinstance(value, (str, int, float, bool)) or value is None:
            output[key] = _portable(value, repo_root)
        elif isinstance(value, list) and len(value) <= 24 and all(
                isinstance(item, (str, int, float, bool)) or item is None for item in value):
            output[key] = _portable(value, repo_root)
    return output


def project_native_record(record: Mapping[str, Any], repo_root: Path) -> dict[str, Any]:
    """Keep outcome/gate summaries while dropping commands and raw artifacts."""
    keys = (
        "rank", "control_role", "candidate_id", "graph_variant_id", "status", "native_cycles",
        "mapper_equality", "prediction_mapper_equal", "prediction_start_equality",
        "independent_trace", "numeric", "numeric_command_exit_code", "numeric_element_comparisons",
        "mapper_cache_hits", "mapper_cache_misses", "fixed_location_equality",
        "replay_timing_policy", "scheduler_backend", "production_ready", "sram_gate", "sram_blocker",
    )
    result = {key: record[key] for key in keys if key in record}
    result["mapper_command"] = _small_native_command(record.get("mapper_command"))
    result["native_command"] = _small_native_command(record.get("native_command"))
    result["sram_command"] = _small_native_command(record.get("sram_command"))
    result["numeric_summary"] = _evidence_summary(
        record.get("numeric_evidence"), repo_root=repo_root, kind="numeric")
    result["sram_summary"] = _evidence_summary(
        record.get("sram_evidence"), repo_root=repo_root, kind="sram")
    result["trace_summary"] = {
        "independent_trace": record.get("independent_trace", "pending"),
        "scheduler_backend": record.get("scheduler_backend"),
        "replay_timing_policy": record.get("replay_timing_policy"),
        "fixed_location_equality": record.get("fixed_location_equality"),
        "native_cycles": record.get("native_cycles"),
    }
    errors = _error_fields(record, repo_root)
    if errors:
        result["errors"] = errors
    return _portable(result, repo_root)


def _project_config(record: Mapping[str, Any], repo_root: Path) -> dict[str, Any]:
    transforms = record.get("transformations")
    if not isinstance(transforms, Mapping):
        transforms = {}
    action_path = transforms.get("action_path", record.get("action_path", []))
    if not isinstance(action_path, list):
        action_path = []
    actions = [_clean_text(str(item), repo_root) for item in action_path]
    shape_rows = transforms.get("shape", [])
    if not isinstance(shape_rows, list):
        shape_rows = []
    shape_fields = ("task", "rows", "cols", "mapper_tile_rows", "mapper_tile_cols", "trip_count")
    shapes = [{key: item[key] for key in shape_fields if key in item}
              for item in shape_rows if isinstance(item, Mapping)]
    choices = record.get("task_choices", [])
    task_fields = ("task", "rows", "cols", "mapper_tile_rows", "mapper_tile_cols", "trip_count")
    task_choices = [{key: item[key] for key in task_fields if key in item}
                    for item in choices if isinstance(item, Mapping)] if isinstance(choices, list) else []
    dispatch = record.get("dispatch_order", [])
    if not isinstance(dispatch, list):
        dispatch = []
    schedule = record.get("task_schedule", [])
    edges = record.get("replayed_communication_edges", [])
    config: dict[str, Any] = {
        "rank": record.get("rank"),
        "candidate_id": record.get("candidate_id"),
        "graph_variant_id": record.get("graph_variant_id"),
        "control_role": record.get("control_role"),
        "predicted_whole_program_cycles": record.get("predicted_whole_program_cycles"),
        "valid": record.get("valid"),
        "certified": record.get("certified"),
        "best_found": record.get("best_found"),
        "actions": actions,
        "action_families": list(dict.fromkeys(action.split(":", 1)[0] for action in actions)),
        "shape_configuration": shapes,
        "task_choices": task_choices,
        "communication_trace_known": record.get("communication_trace_known"),
        "production_schedule_summary": {
            "dispatch_order": dispatch,
            "scheduled_task_count": len(schedule) if isinstance(schedule, list) else None,
            "replayed_communication_edge_count": len(edges) if isinstance(edges, list) else None,
        },
    }
    for key in ("round", "parent_candidate_id", "control_candidate", "control_roles"):
        if key in record:
            config[key] = record[key]
    return _portable(config, repo_root)


def _relative_metadata_value(value: Any, repo_root: Path, label: str) -> Any:
    if isinstance(value, str) and (value.startswith("${ARTIFACT_ROOT}/") or Path(value).is_absolute()):
        return _repo_relative(value, repo_root, label)
    return value


def _load_binding(result: Mapping[str, Any], repo_root: Path, label: str) -> tuple[dict[str, Any], str]:
    symbol, path = _bound_file_path(str(result.get("source_binding", "")), repo_root,
                                    f"{label} source_binding")
    binding = read_json(path, f"{label} source binding")
    if binding.get("schema") != EXPECTED_BINDING_SCHEMA:
        raise ExportError(f"unexpected source binding schema in {symbol}")
    return binding, symbol


def _load_checkpoint_binding(result: Mapping[str, Any], repo_root: Path,
                             label: str) -> dict[str, Any]:
    checkpoint_symbol, checkpoint_path = _bound_file_path(str(result.get("checkpoint", "")),
                                                          repo_root, f"{label} checkpoint")
    binding_path = checkpoint_path.with_name(checkpoint_path.name + ".binding.json")
    binding_symbol = binding_path.relative_to(repo_root.resolve()).as_posix()
    value = read_json(binding_path, f"{label} checkpoint exact binding")
    if value.get("schema") != EXPECTED_CHECKPOINT_BINDING_SCHEMA:
        raise ExportError(f"unexpected checkpoint exact binding schema in {binding_symbol}")
    if value.get("checkpoint_contract") not in EXPECTED_CHECKPOINT_SCHEMAS:
        raise ExportError(f"unexpected checkpoint payload schema in {binding_symbol}")
    return value


def validate_cohort(protocol: Mapping[str, Any], protocol_path: Path,
                    stage_results: Iterable[tuple[str, str, Mapping[str, Any]]],
                    repo_root: Path) -> dict[str, Any]:
    """Validate runtime bindings and exact checkpoint file payload identity."""
    protocol_symbol = protocol_path.resolve(strict=False).relative_to(repo_root.resolve()).as_posix()
    search = protocol.get("search", {})
    expected_source = protocol.get("source_commit")
    expected_schema = protocol.get("schema")
    common_binding: dict[str, Any] | None = None
    exact_common_files: dict[str, tuple[str, str]] | None = None
    workload_binding: dict[str, dict[str, Any]] = {}
    workload_checkpoint: dict[str, dict[str, tuple[str, str]]] = {}
    workload_canonical: dict[str, str] = {}
    observed_contract: dict[str, Any] | None = None
    observed_architecture_contract: str | None = None
    observed_checkpoint_schema: str | None = None
    expected_contract_payload: tuple[str, str] | None = None
    expected_ensemble_payload: tuple[str, str] | None = None
    expected_architecture_payload: tuple[str, str] | None = None
    stable_binding_fields = (
        "architecture", "identity_policy", "model_cache", "optimizer", "protocol_schema",
        "schema", "source_commit", "source_contract_file", "inter_task_network",
        "inter_task_network_text",
    )
    common_payload_names = ("architecture", "ensemble", "protocol", "source_and_model_contract")
    allowed_metadata_discrepancy: list[dict[str, Any]] = []

    for workload, stage, result in stage_results:
        label = f"{workload}/{stage}"
        if result.get("schema") != EXPECTED_STAGE_SCHEMA:
            raise ExportError(f"unexpected stage result schema in {label}")
        if result.get("workload") != workload or result.get("stage") != stage:
            raise ExportError(f"workload/stage path binding mismatch in {label}")
        if result.get("status") != "native_replayed":
            raise ExportError(f"stage is not a completed native replay: {label} status={result.get('status')!r}")
        if _repo_relative(str(result.get("protocol", "")), repo_root, f"{label} protocol") != protocol_symbol:
            raise ExportError(f"protocol path mismatch in {label}")
        binding, _ = _load_binding(result, repo_root, label)
        if binding.get("protocol_schema") != expected_schema:
            raise ExportError(f"source binding protocol schema mismatch in {label}")
        if expected_source is not None and binding.get("source_commit") != expected_source:
            raise ExportError(f"source commit binding mismatch in {label}")
        current_common = {key: _relative_metadata_value(binding.get(key), repo_root,
                                                        f"{label} binding.{key}")
                          for key in stable_binding_fields}
        if common_binding is None:
            common_binding = current_common
        elif current_common != common_binding:
            if current_common.get("inter_task_network") != common_binding.get("inter_task_network") or \
                    current_common.get("inter_task_network_text") != common_binding.get("inter_task_network_text"):
                raise ExportError(f"source binding network bytes mismatch across cohort in {label}")
            raise ExportError(f"runtime source/model/architecture binding differs in {label}")
        canonical = _repo_relative(str(binding.get("canonical_program", "")), repo_root,
                                   f"{label} canonical program")
        parent_costs = _repo_relative(str(binding.get("parent_cost_file", "")), repo_root,
                                      f"{label} parent costs")
        canonical_pattern = str(protocol.get("canonical_program_pattern", "")).replace(
            "<workload>", workload)
        canonical_expected = _repo_relative(canonical_pattern, repo_root,
                                            f"{label} protocol canonical_program_pattern") \
            if canonical_pattern else ""
        if canonical_expected and canonical != canonical_expected:
            raise ExportError(f"canonical source path mismatch in {label}")
        if workload in workload_binding:
            prior = workload_binding[workload]
            for key in ("canonical_program", "cost_cache", "parent_cost_file"):
                if _relative_metadata_value(binding.get(key), repo_root, f"{label} binding.{key}") != \
                        _relative_metadata_value(prior.get(key), repo_root, f"{label} prior binding.{key}"):
                    raise ExportError(f"workload source/cost binding differs between stages: {label} {key}")
        else:
            workload_binding[workload] = binding

        checkpoint = _load_checkpoint_binding(result, repo_root, label)
        checkpoint_schema = checkpoint.get("checkpoint_contract")
        if observed_checkpoint_schema is None:
            observed_checkpoint_schema = checkpoint_schema
        elif checkpoint_schema != observed_checkpoint_schema:
            raise ExportError(f"checkpoint schema differs across cohort in {label}")
        if checkpoint.get("stage") != stage or checkpoint.get("function") != result.get("function"):
            raise ExportError(f"checkpoint stage/function binding mismatch in {label}")
        if checkpoint.get("source_commit") != expected_source:
            raise ExportError(f"checkpoint source binding mismatch in {label}")
        if checkpoint.get("model_namespace") != protocol.get("model_namespace"):
            raise ExportError(f"checkpoint model namespace mismatch in {label}")
        architecture_contract = checkpoint.get("architecture_contract")
        if not isinstance(architecture_contract, str) or not architecture_contract:
            raise ExportError(f"checkpoint architecture contract missing in {label}")
        if observed_architecture_contract is None:
            observed_architecture_contract = architecture_contract
        elif architecture_contract != observed_architecture_contract:
            raise ExportError(f"architecture contract differs in {label}")
        if (checkpoint.get("max_rounds") != search.get("max_rounds") or
                checkpoint.get("max_candidates") != search.get("max_unique_complete_candidates_scored") or
                checkpoint.get("beam_width") != search.get("beam_width") or
                checkpoint.get("diversity_slots") != search.get("diversity_min_slots")):
            raise ExportError(f"checkpoint search budget mismatch in {label}")
        if checkpoint.get("search_contract") != "orbit-neighborhood-search-v1":
            raise ExportError(f"checkpoint search contract mismatch in {label}")
        network_value = protocol.get("inter_task_network_spec")
        bound_network_path = binding.get("inter_task_network")
        bound_network_text = binding.get("inter_task_network_text")
        network_override = checkpoint.get("inter_task_network_spec_override")
        if network_value:
            network_symbol, network_path = _bound_file_path(
                str(network_value), repo_root, f"protocol inter_task_network_spec in {label}")
            current_network_text = network_path.read_text()
            if _relative_metadata_value(bound_network_path, repo_root,
                                        f"{label} binding.inter_task_network") != network_symbol:
                raise ExportError(f"source binding network path mismatch in {label}")
            if bound_network_text != current_network_text:
                raise ExportError(f"source binding network bytes mismatch in {label}")
            if checkpoint_schema != "orbit-neighborhood-search-checkpoint-v4":
                raise ExportError(f"network-bound cohorts require checkpoint v4 in {label}")
            if not isinstance(network_override, Mapping) or \
                    network_override.get("exact_bytes") != current_network_text:
                raise ExportError(f"checkpoint exact network bytes mismatch in {label}")
        elif bound_network_path is not None or bound_network_text is not None or network_override is not None:
            raise ExportError(f"network is bound at runtime but absent from protocol in {label}")
        files = checkpoint.get("files")
        if not isinstance(files, Mapping):
            raise ExportError(f"checkpoint exact file payloads missing in {label}")
        needed = (*common_payload_names, "parent_costs")
        payloads: dict[str, tuple[str, str]] = {}
        for key in needed:
            item = files.get(key)
            if not isinstance(item, Mapping) or not isinstance(item.get("path"), str) or \
                    not isinstance(item.get("exact_bytes"), str):
                raise ExportError(f"checkpoint exact payload {key} missing in {label}")
            path_symbol = _repo_relative(item["path"], repo_root, f"{label} checkpoint {key} path")
            payloads[key] = (path_symbol, item["exact_bytes"])
        if payloads["protocol"][0] != protocol_symbol:
            raise ExportError(f"checkpoint protocol path mismatch in {label}")
        protocol_text = protocol_path.read_text()
        if payloads["protocol"][1] != protocol_text:
            raise ExportError(f"checkpoint exact protocol bytes mismatch in {label}")
        if payloads["architecture"][0] != current_common["architecture"]:
            raise ExportError(f"checkpoint architecture path mismatch in {label}")
        if payloads["ensemble"][0] != current_common["model_cache"]:
            raise ExportError(f"checkpoint model path mismatch in {label}")
        if payloads["source_and_model_contract"][0] != current_common["source_contract_file"]:
            raise ExportError(f"checkpoint source contract path mismatch in {label}")
        if payloads["parent_costs"][0] != parent_costs:
            raise ExportError(f"checkpoint parent cost path mismatch in {label}")
        if workload in workload_checkpoint:
            previous_payloads = workload_checkpoint[workload]
            if previous_payloads["parent_costs"] != payloads["parent_costs"]:
                raise ExportError(f"checkpoint cost payload differs between stages: {label}")
            if workload_canonical[workload] != str(checkpoint.get("canonical_ir", "")):
                raise ExportError(f"checkpoint canonical input differs between stages: {label}")
        else:
            workload_checkpoint[workload] = payloads
            workload_canonical[workload] = str(checkpoint.get("canonical_ir", ""))
        current_exact_common = {key: payloads[key] for key in common_payload_names}
        if exact_common_files is None:
            exact_common_files = current_exact_common
        elif current_exact_common != exact_common_files:
            raise ExportError(f"exact source/model/architecture/replay cohort payload differs in {label}")

        _, contract_bytes = payloads["source_and_model_contract"]
        try:
            contract = json.loads(contract_bytes)
        except json.JSONDecodeError as exc:
            raise ExportError(f"checkpoint source/model contract is invalid JSON in {label}") from exc
        if not isinstance(contract, Mapping) or contract.get("schema") != "orbit-neighborhood-exact-source-model-contract-v1":
            raise ExportError(f"unexpected exact source/model contract in {label}")
        if contract.get("model_namespace") != protocol.get("model_namespace"):
            raise ExportError(f"source contract model namespace mismatch in {label}")
        if _repo_relative(str(contract.get("immutable_optimizer_pin", "")), repo_root,
                          f"{label} contract optimizer") != current_common["optimizer"]:
            raise ExportError(f"runtime optimizer pin is not bound by source contract in {label}")
        if contract.get("source_commit") != expected_source:
            raise ExportError(f"source contract commit binding mismatch in {label}")
        if observed_contract is None:
            observed_contract = dict(contract)
            expected_contract_payload = payloads["source_and_model_contract"]
            expected_ensemble_payload = payloads["ensemble"]
            expected_architecture_payload = payloads["architecture"]
        if payloads["source_and_model_contract"] != expected_contract_payload:
            raise ExportError(f"source contract exact payload differs in {label}")
        if payloads["ensemble"] != expected_ensemble_payload:
            raise ExportError(f"model exact payload differs in {label}")
        if payloads["architecture"] != expected_architecture_payload:
            raise ExportError(f"architecture exact payload differs in {label}")

        footer = result.get("search_footer", {})
        header = result.get("search_header", {})
        for source, name in ((footer, "footer"), (header, "header")):
            if not isinstance(source, Mapping):
                continue
            for field, expected in (
                ("max_rounds", search.get("max_rounds")),
                ("max_candidates", search.get("max_unique_complete_candidates_scored")),
                ("beam_width", search.get("beam_width")),
                ("diversity_slots", search.get("diversity_min_slots")),
                ("native_shortlist_count", search.get("native_shortlist")),
            ):
                if field in source and expected is not None and source[field] != expected:
                    raise ExportError(f"search {name} budget field {field} mismatch in {label}")
        scored = footer.get("unique_complete_candidates_scored")
        if scored is not None and (not _maybe_int(scored) or scored < 0 or
                                   scored > search.get("max_unique_complete_candidates_scored", 0)):
            raise ExportError(f"search candidate score count exceeds its bound in {label}")
        if "native_top5" not in result or not isinstance(result["native_top5"].get("records"), list) or \
                len(result["native_top5"]["records"]) != 5 or len(result.get("top5", [])) != 5:
            raise ExportError(f"completed stage must carry predicted and measured top five in {label}")
        predicted_ids = [(row.get("rank"), row.get("candidate_id"), row.get("graph_variant_id"))
                         for row in result.get("top5", [])]
        measured_ids = [(row.get("rank"), row.get("candidate_id"), row.get("graph_variant_id"))
                        for row in result["native_top5"]["records"]]
        if predicted_ids != measured_ids:
            raise ExportError(f"measured top-five records do not preserve predicted C++ order in {label}")
        if [item[0] for item in predicted_ids] != list(range(5)):
            raise ExportError(f"predicted C++ top-five ranks are not exactly 0 through 4 in {label}")
        valid_native = [record for record in result["native_top5"]["records"] +
                        result.get("native_controls", {}).get("records", [])
                        if _native_cycles(record) is not None]
        if not valid_native:
            raise ExportError(f"no verified native candidate or control in {label}")
        derived_cycles = min(record["native_cycles"] for record in valid_native)
        if not _maybe_int(derived_cycles) or derived_cycles <= 0:
            raise ExportError(f"invalid derived native stage cycles in {label}")
        claimed_cycles = result.get("actual_stage_cycles")
        if claimed_cycles is not None and claimed_cycles != derived_cycles:
            raise ExportError(f"claimed stage cycles do not match verified measured records in {label}")
        if result.get("production_ready") is True and (
                result.get("numeric") != "pass" or result.get("trace") != "pass" or
                result.get("sram") != "pass"):
            raise ExportError(f"stage claims production readiness with a failed/pending gate in {label}")

    assert common_binding is not None and observed_contract is not None and observed_architecture_contract is not None
    effective_optimizer = common_binding["optimizer"]
    effective_contract = common_binding["source_contract_file"]
    protocol_optimizer = _relative_metadata_value(protocol.get("optimizer_pin"), repo_root,
                                                 "protocol optimizer_pin")
    protocol_contract = _relative_metadata_value(protocol.get("source_contract_file"), repo_root,
                                                 "protocol source_contract_file")
    if protocol_optimizer != effective_optimizer:
        if protocol_optimizer != EXPECTED_STALE_PROTOCOL_FIELDS["optimizer_pin"] or \
                effective_optimizer != ".work/post-publication/mlir-amoeba-opt-v19-corrected-neighborhood":
            raise ExportError("unexpected optimizer protocol/runtime mismatch; refusing mixed source cohort")
        allowed_metadata_discrepancy.append({
            "field": "optimizer_pin", "protocol_value": protocol_optimizer,
            "effective_value": effective_optimizer,
            "effective_evidence": "runtime source_binding.optimizer and exact checkpoint source/model contract immutable_optimizer_pin",
        })
    if protocol_contract != effective_contract:
        if protocol_contract != EXPECTED_STALE_PROTOCOL_FIELDS["source_contract_file"] or \
                effective_contract != ".work/post-publication/source-model-contract-v19.json":
            raise ExportError("unexpected source-contract protocol/runtime mismatch; refusing mixed source cohort")
        allowed_metadata_discrepancy.append({
            "field": "source_contract_file", "protocol_value": protocol_contract,
            "effective_value": effective_contract,
            "effective_evidence": "runtime source_binding.source_contract_file and exact checkpoint file payload",
        })
    if protocol.get("source_variant") != EFFECTIVE_V19_SOURCE_VARIANT:
        legacy_v17_metadata = (
            protocol.get("source_variant") == EXPECTED_STALE_PROTOCOL_FIELDS["source_variant"] and
            effective_optimizer == ".work/post-publication/mlir-amoeba-opt-v19-corrected-neighborhood" and
            effective_contract == ".work/post-publication/source-model-contract-v19.json")
        if legacy_v17_metadata:
            allowed_metadata_discrepancy.append({
                "field": "source_variant", "protocol_value": protocol.get("source_variant"),
                "effective_value": EFFECTIVE_V19_SOURCE_VARIANT,
                "effective_evidence": {
                    "source_contract_file": effective_contract,
                    "source_file_list": observed_contract.get("source_file_list"),
                    "immutable_optimizer_pin": effective_optimizer,
                },
                "limitation": "runtime binding has no independent source_variant field; the effective source is identified by its exact contract and pin",
            })
        elif protocol_optimizer != effective_optimizer or protocol_contract != effective_contract:
            raise ExportError("source variant lacks matching exact runtime source bindings")

    if common_binding["model_cache"] != _relative_metadata_value(
            protocol.get("model_ensemble"), repo_root, "protocol model_ensemble"):
        raise ExportError("runtime model path disagrees with protocol model ensemble")
    if common_binding["architecture"] != _relative_metadata_value(
            protocol.get("architecture"), repo_root, "protocol architecture"):
        raise ExportError("runtime architecture path disagrees with protocol architecture")
    if protocol.get("schema") != "orbit-amoeba-input0-neighborhood-v3":
        raise ExportError("unsupported neighborhood protocol schema")

    sources = observed_contract.get("sources", [])
    models = observed_contract.get("model_payloads", [])
    replay = observed_contract.get("replay_payloads", [])
    source_paths = [item.get("path") for item in sources if isinstance(item, Mapping)]
    model_paths = [item.get("path") for item in models if isinstance(item, Mapping)]
    replay_paths = [item.get("path") for item in replay if isinstance(item, Mapping)]
    provenance = {
        "cohort_label": (EFFECTIVE_V19_SOURCE_VARIANT if allowed_metadata_discrepancy
                         else protocol.get("source_variant")),
        "protocol_schema": protocol.get("schema"),
        "protocol_path": protocol_symbol,
        "protocol_scope": protocol.get("scope"),
        "publication_variant": protocol.get("publication_variant"),
        "input_policy": protocol.get("input_policy"),
        "architecture": common_binding["architecture"],
        "architecture_contract": observed_architecture_contract,
        "optimizer_pin": effective_optimizer,
        "source_model_contract": effective_contract,
        "source_model_contract_schema": observed_contract.get("schema"),
        "source_file_list": observed_contract.get("source_file_list"),
        "source_file_paths": source_paths,
        "source_file_count": len(source_paths),
        "search_contract": observed_contract.get("search_contract"),
        "rewrite_contract": observed_contract.get("rewrite_contract"),
        "source_dirty_build": observed_contract.get("source_dirty"),
        "model_namespace": observed_contract.get("model_namespace"),
        "model_ensemble": common_binding["model_cache"],
        "inter_task_network": common_binding.get("inter_task_network"),
        "checkpoint_contract": observed_checkpoint_schema,
        "model_payload_paths": model_paths,
        "replay_payload_paths": replay_paths,
        "replay_payload_count": len(replay_paths),
        "budget_profile": protocol.get("budget_profile"),
        "search_budget": {
            key: search.get(key) for key in (
                "max_rounds", "max_unique_complete_candidates_scored", "beam_width",
                "cost_selected_max_slots", "diversity_min_slots", "native_shortlist",
                "max_partition_factor") if key in search
        },
        "exact_checkpoint_file_payload_keys": list(common_payload_names) + ["parent_costs"],
        "protocol_metadata_discrepancy": allowed_metadata_discrepancy,
        "provenance_limitation": (
            "The frozen protocol retains v17 descriptive source fields. Runtime source bindings and exact C++ checkpoint file payloads agree on the v19 optimizer/source contract. "
            "This table reports that discrepancy and does not claim byte-identical resume under the stale protocol metadata."
            if allowed_metadata_discrepancy else None
        ),
    }
    provenance["_validation_context"] = {
        "common_binding": common_binding,
        "exact_common_files": exact_common_files,
        "source_contract": observed_contract,
    }
    return provenance


def _validated_exclusion(protocol: Mapping[str, Any]) -> Mapping[str, Any] | None:
    exclusions = protocol.get("model_domain_exclusions")
    if exclusions in (None, {}):
        return None
    if not isinstance(exclusions, Mapping) or set(exclusions) != {"raytracing"}:
        raise ExportError("only the Raytracing model-domain exclusion is supported")
    item = exclusions["raytracing"]
    if not isinstance(item, Mapping) or item.get("status") != "unsupported_model_domain" or \
            item.get("task") != "Task_13" or item.get("model_interval_max_ii") != 20:
        raise ExportError("Raytracing exclusion must name Task_13 above the model ceiling 20")
    names = protocol.get("workloads_in_delivery_order")
    if not isinstance(names, list) or [str(name).lower() for name in names] != [
            "llama", "lu", "harris", "radar", "gcn", "raytracing"]:
        raise ExportError("the Raytracing exclusion requires the six-workload direct-model protocol")
    if protocol.get("experiment_kind") == "ray-fission-supplement":
        raise ExportError("the Ray fission supplement cannot declare a model-domain exclusion")
    if protocol.get("model_namespace") != "orbit-per-cgra-2x2-direct-4member-v1":
        raise ExportError("Raytracing exclusion requires the direct 2x2 model namespace")
    fabric = protocol.get("fabric")
    search = protocol.get("search")
    if not isinstance(fabric, Mapping) or fabric.get("per_cgra_pe_rows") != 2 or \
            fabric.get("per_cgra_pe_columns") != 2 or not isinstance(search, Mapping):
        raise ExportError("Raytracing exclusion requires a 2x2-per-CGRA shape policy")
    shapes = search.get("later_shapes")
    expected_shapes = {(2, 2), (2, 4), (4, 2), (2, 6), (6, 2), (2, 8), (8, 2), (4, 4)}
    if not isinstance(shapes, list) or len(shapes) != 8:
        raise ExportError("Raytracing exclusion requires exactly eight supported mapper shapes")
    derived_shapes: list[tuple[int, int]] = []
    for shape in shapes:
        if not isinstance(shape, list) or len(shape) != 2 or not all(_maybe_int(v) for v in shape):
            raise ExportError("Raytracing exclusion contains a malformed mapper shape")
        derived_shapes.append((shape[0] * fabric["per_cgra_pe_rows"],
                               shape[1] * fabric["per_cgra_pe_columns"]))
    if len(set(derived_shapes)) != 8 or set(derived_shapes) != expected_shapes:
        raise ExportError("Raytracing exclusion shape policy does not cover the eight direct 2x2 shapes")
    return item


def _validate_model_domain_evidence(protocol: Mapping[str, Any], protocol_path: Path,
                                    evidence_path: Path, repo_root: Path,
                                    context: Mapping[str, Any]) -> dict[str, Any]:
    """Recheck the exact C++ exclusion against the current catalog and cohort."""
    evidence_symbol, evidence_file = _bound_file_path(
        str(evidence_path), repo_root, "model-domain evidence")
    evidence = read_json(evidence_file, "model-domain evidence")
    exclusion = _validated_exclusion(protocol)
    assert exclusion is not None
    required_top = {
        "schema": "orbit-model-domain-exclusion-evidence-v1",
        "status": "proved_outside_model_interval",
        "workload": "raytracing",
        "task": "Task_13",
        "model_interval_max_ii": 20,
    }
    for key, expected in required_top.items():
        if evidence.get(key) != expected:
            raise ExportError(f"model-domain evidence {key} mismatch")
    if evidence.get("native_cycles") is not None or evidence.get("formal_go") is not False:
        raise ExportError("model-domain evidence must carry no cycles and no formal-go claim")

    common_binding = context["common_binding"]
    exact_common_files = context["exact_common_files"]
    observed_contract = context["source_contract"]
    namespace = protocol.get("model_namespace")
    if evidence.get("model_namespace") != namespace or observed_contract.get("model_namespace") != namespace:
        raise ExportError("model-domain evidence namespace differs from measured cohort")
    exact_payloads = evidence.get("exact_payloads")
    required_payload_names = {
        "canonical_program", "cost_catalog", "source_contract_file", "architecture",
        "ensemble", "inter_task_network", "protocol",
    }
    if not isinstance(exact_payloads, Mapping) or set(exact_payloads) != required_payload_names:
        raise ExportError("model-domain evidence must bind the seven exact source/resource payloads")

    payload_text: dict[str, str] = {}
    payload_paths: dict[str, str] = {}
    for name, item in exact_payloads.items():
        if not isinstance(item, Mapping) or not isinstance(item.get("path"), str) or \
                not isinstance(item.get("exact_bytes"), str):
            raise ExportError(f"model-domain evidence exact payload {name} is malformed")
        symbol, path = _bound_file_path(item["path"], repo_root,
                                        f"model-domain evidence {name} path")
        actual = path.read_text()
        if item["exact_bytes"] != actual:
            raise ExportError(f"model-domain evidence exact bytes differ from current {name} file")
        if evidence.get(name) != item["path"]:
            raise ExportError(f"model-domain evidence {name} path aliases disagree")
        payload_text[name] = actual
        payload_paths[name] = symbol

    protocol_symbol = protocol_path.resolve(strict=False).relative_to(repo_root.resolve()).as_posix()
    canonical_pattern = str(protocol.get("canonical_program_pattern", "")).replace(
        "<workload>", "raytracing")
    canonical_expected = _repo_relative(canonical_pattern, repo_root,
                                        "protocol canonical_program_pattern") \
        if canonical_pattern else ""
    if payload_paths["protocol"] != protocol_symbol or payload_text["protocol"] != protocol_path.read_text():
        raise ExportError("model-domain evidence protocol bytes do not match this export")
    if not canonical_expected or payload_paths["canonical_program"] != canonical_expected:
        raise ExportError("model-domain evidence is not bound to the canonical Raytracing program")
    if payload_paths["architecture"] != common_binding["architecture"] or \
            payload_text["architecture"] != exact_common_files["architecture"][1]:
        raise ExportError("model-domain architecture payload differs from measured cohort")
    if payload_paths["ensemble"] != common_binding["model_cache"] or \
            payload_text["ensemble"] != exact_common_files["ensemble"][1]:
        raise ExportError("model-domain ensemble payload differs from measured cohort")
    if payload_paths["source_contract_file"] != common_binding["source_contract_file"] or \
            payload_text["source_contract_file"] != exact_common_files["source_and_model_contract"][1]:
        raise ExportError("model-domain source-contract payload differs from measured cohort")
    network_path = protocol.get("inter_task_network_spec")
    if not isinstance(network_path, str) or not network_path:
        raise ExportError("model-domain exclusion requires a protocol-bound inter-task network")
    network_symbol = _repo_relative(network_path, repo_root, "protocol inter_task_network_spec")
    if payload_paths["inter_task_network"] != network_symbol or \
            payload_paths["inter_task_network"] != common_binding.get("inter_task_network") or \
            payload_text["inter_task_network"] != common_binding.get("inter_task_network_text"):
        raise ExportError("model-domain network payload differs from measured cohort")
    if payload_paths["cost_catalog"] != _repo_relative(str(evidence["cost_catalog"]), repo_root,
                                                       "model-domain cost catalog"):
        raise ExportError("model-domain cost-catalog path binding mismatch")

    binding = evidence.get("source_binding")
    if not isinstance(binding, Mapping) or binding.get("schema") != EXPECTED_BINDING_SCHEMA:
        raise ExportError("model-domain source binding is missing")
    for key, expected in (
        ("protocol_schema", protocol.get("schema")), ("source_commit", protocol.get("source_commit")),
        ("optimizer", common_binding["optimizer"]), ("architecture", common_binding["architecture"]),
        ("model_cache", common_binding["model_cache"]),
        ("source_contract_file", common_binding["source_contract_file"]),
        ("inter_task_network", common_binding.get("inter_task_network")),
    ):
        actual = binding.get(key)
        if key in {"optimizer", "architecture", "model_cache", "source_contract_file", "inter_task_network"}:
            actual = _relative_metadata_value(actual, repo_root, f"model-domain source binding.{key}")
        if actual != expected:
            raise ExportError(f"model-domain source binding {key} differs from measured cohort")
    if binding.get("canonical_program") != evidence.get("canonical_program") or \
            _relative_metadata_value(binding.get("parent_cost_file"), repo_root,
                                     "model-domain source binding.parent_cost_file") != payload_paths["cost_catalog"]:
        raise ExportError("model-domain source binding does not name its canonical program and catalog")
    if binding.get("inter_task_network_text") != payload_text["inter_task_network"]:
        raise ExportError("model-domain source binding network text differs from its exact payload")

    try:
        catalog = json.loads(payload_text["cost_catalog"])
    except json.JSONDecodeError as exc:
        raise ExportError("model-domain cost catalog is invalid JSON") from exc
    if not isinstance(catalog, Mapping) or catalog.get("schema") != "amoeba-task-shape-cost" or \
            catalog.get("namespace") != namespace:
        raise ExportError("model-domain cost catalog schema or namespace mismatch")
    metadata = catalog.get("predictor_metadata")
    if not isinstance(metadata, Mapping) or metadata.get("model_interval_max_ii") != 20:
        raise ExportError("model-domain cost catalog does not bind the expected model ceiling")
    module_witness = metadata.get("canonical_module_witness")
    if not isinstance(module_witness, str) or not module_witness or \
            evidence.get("canonical_module_witness") != module_witness or \
            evidence.get("canonical_task_witness") != module_witness:
        raise ExportError("model-domain canonical source witness differs from the C++ catalog")

    fabric = protocol.get("fabric")
    search = protocol.get("search")
    if not isinstance(fabric, Mapping) or not isinstance(search, Mapping):
        raise ExportError("model-domain proof requires protocol fabric and shape policy")
    pe_rows, pe_cols = fabric.get("per_cgra_pe_rows"), fabric.get("per_cgra_pe_columns")
    later_shapes = search.get("later_shapes")
    if not _maybe_int(pe_rows) or not _maybe_int(pe_cols) or not isinstance(later_shapes, list):
        raise ExportError("protocol does not define concrete allowed mapper shapes")
    expected_shapes: set[tuple[int, int]] = set()
    for shape in later_shapes:
        if not isinstance(shape, list) or len(shape) != 2 or not all(_maybe_int(x) for x in shape):
            raise ExportError("protocol contains a malformed allowed shape")
        expected_shapes.add((shape[0] * pe_rows, shape[1] * pe_cols))
    entries = catalog.get("entries")
    if not isinstance(entries, list):
        raise ExportError("model-domain cost catalog entries are missing")
    task_entries = [entry for entry in entries if isinstance(entry, Mapping) and
                    entry.get("task") == "Task_13"]
    coordinates = [(entry.get("mapper_tile_rows"), entry.get("mapper_tile_cols"))
                   for entry in task_entries]
    if len(task_entries) != len(expected_shapes) or set(coordinates) != expected_shapes or \
            len(coordinates) != len(set(coordinates)):
        raise ExportError("C++ catalog does not cover every allowed Task_13 mapper shape exactly once")
    ceiling = exclusion["model_interval_max_ii"]
    for entry in task_entries:
        lower_bound = entry.get("analytical_lower_bound")
        if entry.get("status") != "unsupported-model-domain" or \
                entry.get("support_status") != "unsupported" or \
                entry.get("unsupported_reason") != "analytical-lower-bound-exceeds-model-ceiling" or \
                entry.get("model_interval_max_ii") != ceiling or not _maybe_int(lower_bound) or \
                lower_bound <= ceiling or "predicted_ii" in entry:
            raise ExportError("Task_13 catalog contains a supported, malformed, or predicted cost")
    queries = evidence.get("queries")
    if not isinstance(queries, list) or queries != task_entries:
        raise ExportError("model-domain query evidence differs from exact C++ catalog entries")

    argv = evidence.get("preflight_command")
    if not isinstance(argv, list) or not argv or not all(isinstance(arg, str) for arg in argv):
        raise ExportError("model-domain C++ preflight command is missing")
    if _relative_metadata_value(argv[0], repo_root, "model-domain preflight executable") != \
            common_binding["optimizer"]:
        raise ExportError("model-domain preflight executable differs from measured optimizer pin")
    for name in required_payload_names:
        path_text = evidence[name]
        if not any(path_text in arg for arg in argv):
            raise ExportError(f"model-domain preflight command omits bound {name}")
    diagnostic = evidence.get("failure_diagnostic")
    if evidence.get("exit_code") != 1 or not isinstance(diagnostic, str) or \
            not diagnostic.endswith("error: task has no supported model shape for canonical identity: Task_13"):
        raise ExportError("C++ preflight did not fail on the expected unsupported canonical Task_13")

    shapes = [
        {"mapper_tile_rows": row, "mapper_tile_cols": col,
         "analytical_lower_bound": next(entry["analytical_lower_bound"] for entry in task_entries
                                         if (entry["mapper_tile_rows"], entry["mapper_tile_cols"]) == (row, col))}
        for row, col in sorted(expected_shapes)
    ]
    return {
        "status": "unsupported_model_domain",
        "workload": "raytracing",
        "task": "Task_13",
        "model_interval_max_ii": ceiling,
        "native_cycles": None,
        "not_run": True,
        "unsupported_shape_count": len(shapes),
        "unsupported_shapes": shapes,
        "evidence_file": evidence_symbol,
        "cxx_preflight_exit_code": evidence["exit_code"],
        "cxx_preflight_diagnostic": _portable(diagnostic, repo_root),
        "canonical_module_witness_verified": True,
    }


def _selection_rows(result: Mapping[str, Any], repo_root: Path) -> dict[str, Any]:
    top5 = result.get("top5", [])
    controls = result.get("controls", [])
    return {
        "predicted_top5": [_project_config(row, repo_root) for row in top5 if isinstance(row, Mapping)],
        "controls": [_project_config(row, repo_root) for row in controls if isinstance(row, Mapping)],
    }


def _native_group(group: Any, repo_root: Path) -> dict[str, Any]:
    if not isinstance(group, Mapping):
        return {"status": "missing", "numeric": "pending", "sram_gate": "pending", "production_ready": False,
                "records": []}
    records = group.get("records", [])
    return {
        "status": group.get("status", "pending"),
        "numeric": group.get("numeric", "pending"),
        "sram_gate": group.get("sram_gate", "pending"),
        "production_ready": group.get("production_ready", False),
        "records": [project_native_record(record, repo_root) for record in records if isinstance(record, Mapping)],
    }


def _stage_detail(result: Mapping[str, Any], repo_root: Path,
                  shared_row: Mapping[str, Any]) -> dict[str, Any]:
    selections = _selection_rows(result, repo_root)
    native_top5 = _native_group(result.get("native_top5"), repo_root)
    native_controls = _native_group(result.get("native_controls"), repo_root)
    winner_record = shared_row.get("actual_winner")
    winner_selection = shared_row.get("actual_winner_source_selection")
    winner_config = None
    if isinstance(winner_selection, Mapping):
        all_selections = [*result.get("top5", []), *result.get("controls", [])]
        match = next((row for row in all_selections
                      if row.get("candidate_id") == winner_selection.get("candidate_id") and
                      row.get("graph_variant_id") == winner_selection.get("graph_variant_id")), None)
        if match is not None:
            winner_config = _project_config(match, repo_root)
    if isinstance(winner_record, Mapping) and winner_config is None:
        raise ExportError(f"measured winner has no matching predicted/control configuration in {result.get('workload')}/{result.get('stage')}")
    footer = result.get("search_footer", {})
    reject_reasons = footer.get("reject_reasons", result.get("reject_reasons", {}))
    budget_keys = (
        "max_candidates", "max_rounds", "beam_width", "diversity_slots", "max_partition_factor",
        "native_shortlist_count", "unique_complete_candidates_scored", "unique_scored_candidates",
        "unique_valid_candidates", "cache_hits", "cache_misses", "rounds", "rounds_completed",
        "elapsed_seconds", "stop_reason", "production_scheduler_calls", "rejected_or_duplicate_candidates",
    )
    budget = {key: footer[key] for key in budget_keys if key in footer}
    budget["reject_reasons"] = _portable(reject_reasons, repo_root)
    return {
        "workload": result.get("workload"),
        "stage": result.get("stage"),
        "status": result.get("status"),
        "result_label": result.get("result_label"),
        "best_found": result.get("best_found"),
        "exhaustive": result.get("exhaustive"),
        "global_optimality_claim": result.get("global_optimality_claim", False),
        "production_ready": result.get("production_ready", False),
        "predicted_top5_order": [
            {"rank": row.get("rank"), "candidate_id": row.get("candidate_id"),
             "graph_variant_id": row.get("graph_variant_id"),
             "predicted_whole_program_cycles": row.get("predicted_whole_program_cycles")}
            for row in result.get("top5", []) if isinstance(row, Mapping)
        ],
        "predicted_top5_configuration": selections["predicted_top5"],
        "controls_configuration": selections["controls"],
        "measured_native_top5": native_top5,
        "measured_native_controls": native_controls,
        "actual_stage_cycles": shared_row.get("native_stage_cycles"),
        "actual_winner": project_native_record(winner_record, repo_root)
            if isinstance(winner_record, Mapping) else None,
        "actual_winner_configuration": winner_config,
        "relative_to_s1_cycles": shared_row.get("relative_to_s1_cycles"),
        "relative_to_previous_stage_cycles": shared_row.get("relative_to_previous_stage_cycles"),
        "relative_to_s1_percent": shared_row.get("relative_to_s1_percent"),
        "relative_to_previous_stage_percent": shared_row.get("relative_to_previous_stage_percent"),
        "budget_and_search": budget,
        "native_top5_status": result.get("native_top5_status"),
        "numeric": result.get("numeric", "pending"),
        "trace": result.get("trace", "pending"),
        "sram": result.get("sram", "pending"),
        "numeric_command_status": {
            "top5": _small_native_command(result.get("numeric_top5_command")),
            "controls": _small_native_command(result.get("numeric_controls_command")),
        },
        "stop_reason": result.get("stop_reason"),
    }


def _table_row(result: Mapping[str, Any], shared: Mapping[str, Any],
               repo_root: Path) -> dict[str, Any]:
    # Use the existing reducer's actual-cycle semantics and retain C++ top-five order.
    fields = (
        "workload", "stage", "status", "result_label", "exhaustive", "predicted_top5_cycles",
        "predicted_cxx_order", "measured_native_order", "predicted_top5_candidate_ids",
        "native_stage_cycles", "relative_to_s1_cycles", "relative_to_previous_stage_cycles",
        "relative_to_s1_percent", "relative_to_previous_stage_percent",
        "unique_complete_candidates_scored", "cache_hits", "cache_misses", "reject_reasons",
        "search_rounds", "search_elapsed_seconds", "stop_reason", "native_top5_status",
        "numeric", "trace", "sram", "best_found",
    )
    row = {field: shared.get(field) for field in fields}
    row["status"] = result.get("status")
    row["numeric"] = result.get("numeric", "pending")
    row["trace"] = result.get("trace", "pending")
    row["sram"] = result.get("sram", "pending")
    return _portable(row, repo_root)


def _unsupported_table_row(workload: str, stage: str) -> dict[str, Any]:
    return {
        "workload": workload, "stage": stage,
        "status": "unsupported_model_domain", "result_label": "not_run",
        "exhaustive": False, "predicted_top5_cycles": None,
        "predicted_cxx_order": [], "measured_native_order": [],
        "predicted_top5_candidate_ids": [], "native_stage_cycles": None,
        "relative_to_s1_cycles": None, "relative_to_previous_stage_cycles": None,
        "relative_to_s1_percent": None, "relative_to_previous_stage_percent": None,
        "unique_complete_candidates_scored": None, "cache_hits": None,
        "cache_misses": None, "reject_reasons": {}, "search_rounds": None,
        "search_elapsed_seconds": None, "stop_reason": "unsupported_model_domain",
        "native_top5_status": "not_run", "numeric": "not_applicable",
        "trace": "not_applicable", "sram": "not_applicable", "best_found": False,
    }


def _unsupported_detail_row(workload: str, stage: str,
                            exclusion_summary: Mapping[str, Any] | None) -> dict[str, Any]:
    return {
        "workload": workload, "stage": stage,
        "status": "unsupported_model_domain", "result_label": "not_run",
        "best_found": False, "exhaustive": False, "global_optimality_claim": False,
        "production_ready": False, "predicted_top5_order": [],
        "predicted_top5_configuration": [], "controls_configuration": [],
        "measured_native_top5": {"status": "not_run", "numeric": "not_applicable",
                                  "sram_gate": "not_applicable", "production_ready": False,
                                  "records": []},
        "measured_native_controls": {"status": "not_run", "numeric": "not_applicable",
                                     "sram_gate": "not_applicable", "production_ready": False,
                                     "records": []},
        "actual_stage_cycles": None, "actual_winner": None,
        "actual_winner_configuration": None, "relative_to_s1_cycles": None,
        "relative_to_previous_stage_cycles": None, "relative_to_s1_percent": None,
        "relative_to_previous_stage_percent": None, "budget_and_search": {},
        "native_top5_status": "not_run", "numeric": "not_applicable",
        "trace": "not_applicable", "sram": "not_applicable",
        "numeric_command_status": {"top5": None, "controls": None},
        "stop_reason": "unsupported_model_domain",
        "model_domain_exclusion": exclusion_summary,
    }


def _load_matrix(results_root: Path, protocol: Mapping[str, Any]) -> tuple[list[tuple[str, str, dict[str, Any]]], list[str]]:
    names = protocol.get("workloads_in_delivery_order")
    if not isinstance(names, list):
        raise ExportError("protocol workloads must be a list")
    supplement = protocol.get("experiment_kind") == "ray-fission-supplement"
    excluded = _validated_exclusion(protocol)
    if supplement:
        if [str(name).lower() for name in names] != ["raytracing"]:
            raise ExportError("Ray fission supplement must contain only Raytracing")
        if excluded is not None:
            raise ExportError("Ray fission supplement cannot carry exclusions")
    elif len(names) != 6:
        raise ExportError("direct-model protocol must list exactly six workloads")
    workloads = [str(name).lower() for name in names]
    protocol_stages = [item.get("name") for item in protocol.get("stages", []) if isinstance(item, Mapping)]
    if tuple(protocol_stages) != tuple(STAGES):
        raise ExportError("protocol stage order does not match the common neighborhood renderer")
    excluded_workload = "raytracing" if excluded is not None else None
    expected = {(workload, stage) for workload in workloads if workload != excluded_workload
                for stage in STAGES}
    present: list[tuple[str, str, dict[str, Any]]] = []
    missing: list[str] = []
    for workload in workloads:
        if workload == excluded_workload:
            continue
        for stage in STAGES:
            path = results_root / workload / stage / "result.json"
            if not path.is_file():
                missing.append(f"{workload}/{stage}")
                continue
            present.append((workload, stage, read_json(path, f"stage result {workload}/{stage}")))
    extras: list[str] = []
    for path in results_root.glob("*/*/result.json"):
        rel = path.relative_to(results_root)
        if len(rel.parts) != 3 or (rel.parts[0], rel.parts[1]) not in expected:
            extras.append(rel.as_posix())
    if extras:
        raise ExportError("unexpected stage result cells: " + ", ".join(sorted(extras)))
    return present, missing


def _read_protocol(path: Path, repo_root: Path) -> dict[str, Any]:
    try:
        path.resolve(strict=True).relative_to(repo_root.resolve())
    except (OSError, ValueError) as exc:
        raise ExportError("protocol must be a file within --repository-root") from exc
    value = read_json(path, "protocol")
    if value.get("active") is not True:
        raise ExportError("protocol is not active")
    return value


def _stage_row_with_order(result: Mapping[str, Any], s1: Any, previous: Any) -> dict[str, Any]:
    shared = stage_row(result, s1=s1, previous=previous)
    records = [*result.get("native_top5", {}).get("records", []),
               *result.get("native_controls", {}).get("records", [])]
    measured = [record["native_cycles"] for record in records if _native_cycles(record) is not None]
    if not measured:
        raise ExportError(f"no native cycles available for {result.get('workload')}/{result.get('stage')}")
    if result.get("actual_stage_cycles") is not None and result["actual_stage_cycles"] != min(measured):
        raise ExportError(f"actual stage cycles disagree with measured records for {result.get('workload')}/{result.get('stage')}")
    shared["native_stage_cycles"] = min(measured)
    return shared


def export(results_root: Path, protocol_path: Path, repo_root: Path,
           output_dir: Path, *, render_plots: bool = False,
           plot_script: Path | None = None,
           model_domain_evidence: Path | None = None) -> dict[str, Any]:
    repo_root = repo_root.resolve(strict=True)
    results_root = results_root.resolve(strict=True)
    protocol_path = protocol_path.resolve(strict=True)
    protocol = _read_protocol(protocol_path, repo_root)
    exclusion = _validated_exclusion(protocol)
    if exclusion is not None and model_domain_evidence is None:
        raise ExportError("--model-domain-evidence is required for the Raytracing exclusion")
    if exclusion is None and model_domain_evidence is not None:
        raise ExportError("model-domain evidence was supplied for a protocol without an exclusion")
    try:
        results_root.relative_to(repo_root)
    except ValueError as exc:
        raise ExportError("--results-root must be within --repository-root") from exc
    matrix, missing = _load_matrix(results_root, protocol)
    if missing:
        prefix = "incomplete six-by-five cohort" if exclusion is None and \
            protocol.get("experiment_kind") != "ray-fission-supplement" else "incomplete measured cohort"
        raise ExportError(prefix + "; missing: " + ", ".join(missing))
    expected_measured_cells = len(protocol["workloads_in_delivery_order"]) * len(STAGES)
    if exclusion is not None:
        expected_measured_cells -= len(STAGES)
    if len(matrix) != expected_measured_cells:
        raise ExportError(f"expected exactly {expected_measured_cells} measured stage records; found {len(matrix)}")
    provenance = validate_cohort(protocol, protocol_path, matrix, repo_root)
    exclusion_summary = None
    if model_domain_evidence is not None:
        exclusion_summary = _validate_model_domain_evidence(
            protocol, protocol_path, model_domain_evidence.resolve(strict=True), repo_root,
            provenance.pop("_validation_context"))
    else:
        provenance.pop("_validation_context", None)
    if exclusion_summary is not None:
        provenance["model_domain_exclusion"] = exclusion_summary

    by_workload: dict[str, dict[str, Mapping[str, Any]]] = {}
    for workload, stage, result in matrix:
        by_workload.setdefault(workload, {})[stage] = result
    rows: list[dict[str, Any]] = []
    detail_rows: list[dict[str, Any]] = []
    diagnostic_reasons: list[str] = []
    for workload in [str(name).lower() for name in protocol["workloads_in_delivery_order"]]:
        if exclusion is not None and workload == "raytracing":
            for stage in STAGES:
                rows.append(_unsupported_table_row(workload, stage))
                detail_rows.append(_unsupported_detail_row(workload, stage, exclusion_summary))
            continue
        s1_result = by_workload[workload][STAGES[0]]
        s1_candidate_records = [*s1_result.get("native_top5", {}).get("records", []),
                                *s1_result.get("native_controls", {}).get("records", [])]
        s1_values = [record["native_cycles"] for record in s1_candidate_records
                     if _native_cycles(record) is not None]
        s1 = min(s1_values)
        previous = None
        for stage in STAGES:
            result = by_workload[workload][stage]
            shared = _stage_row_with_order(result, s1, previous)
            table_row = _table_row(result, shared, repo_root)
            detail = _stage_detail(result, repo_root, shared)
            rows.append(table_row)
            detail_rows.append(detail)
            previous = shared["native_stage_cycles"]
            if result.get("sram") != "pass":
                diagnostic_reasons.append(f"{workload}/{stage}: SRAM gate {result.get('sram', 'pending')}")
            if result.get("numeric") != "pass":
                diagnostic_reasons.append(f"{workload}/{stage}: numeric gate {result.get('numeric', 'pending')}")
            if result.get("trace") != "pass":
                diagnostic_reasons.append(f"{workload}/{stage}: trace gate {result.get('trace', 'pending')}")
    if provenance["protocol_metadata_discrepancy"]:
        diagnostic_reasons.append("frozen protocol source metadata differs from effective runtime bindings")

    output: dict[str, Any] = {
        "schema": FINAL_SCHEMA,
        "protocol_schema": protocol.get("schema"),
        "cell_count": len(detail_rows),
        "workload_order": [str(name).lower() for name in protocol["workloads_in_delivery_order"]],
        "stage_order": list(STAGES),
        "experiment_kind": protocol.get("experiment_kind", "direct-model-neighborhood"),
        "model_domain_exclusions": ({"raytracing": exclusion_summary}
                                     if exclusion_summary is not None else {}),
        "publication_readiness": "diagnostic_only" if diagnostic_reasons else "evidence_complete_review_required",
        "formal_go": False,
        "diagnostic_reasons": list(dict.fromkeys(diagnostic_reasons)),
        "provenance": provenance,
        "rows": detail_rows,
    }
    _assert_portable(output)
    table_document = {
        "schema": TABLE_SCHEMA,
        "protocol": protocol.get("schema"),
        "experiment_kind": protocol.get("experiment_kind", "direct-model-neighborhood"),
        "model_domain_exclusions": ({"raytracing": exclusion_summary}
                                     if exclusion_summary is not None else {}),
        "rows": rows,
    }
    _assert_portable(table_document)

    output_dir = output_dir.resolve(strict=False)
    if output_dir.exists():
        raise ExportError(f"output directory already exists; refusing overwrite: {output_dir}")
    staging = output_dir.with_name(output_dir.name + ".staging")
    if staging.exists():
        raise ExportError(f"staging directory already exists; refusing overwrite: {staging}")
    output_dir.parent.mkdir(parents=True, exist_ok=True)
    staging.mkdir(parents=True)
    try:
        (staging / "neighborhood-final-results.json").write_text(json.dumps(output, indent=2, sort_keys=True) + "\n")
        (staging / "neighborhood-stage-table.json").write_text(json.dumps(table_document, indent=2, sort_keys=True) + "\n")
        (staging / "neighborhood-stage-table.md").write_text(render_markdown(rows))
        plot_status = "not_requested"
        if render_plots:
            measured_rows = [row for row in rows if row["status"] == "native_replayed"]
            excluded_rows = [row for row in rows if row["status"] == "unsupported_model_domain"]
            ready = all(row["status"] == "native_replayed" and row["numeric"] == "pass" and
                        row["trace"] == "pass" and isinstance(row["native_stage_cycles"], int) and
                        row["native_stage_cycles"] > 0 for row in measured_rows) and \
                    (not exclusion or len(excluded_rows) == len(STAGES))
            if ready:
                if plot_script is None:
                    raise ExportError("--render-plots requires --plot-script")
                subprocess.run([sys.executable, str(plot_script), "--table",
                                str(staging / "neighborhood-stage-table.json"),
                                "--output-dir", str(staging / "plots")], check=True)
                plot_status = "rendered_with_validated_plotter"
            else:
                plot_status = "skipped_incomplete_native_numeric_or_trace_gate"
        (staging / "render-status.json").write_text(json.dumps({"plots": plot_status}, indent=2) + "\n")
        staging.rename(output_dir)
    except Exception:
        shutil.rmtree(staging, ignore_errors=True)
        raise
    return output


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--results-root", type=Path, required=True,
                        help="results/<cohort> containing <workload>/<stage>/result.json")
    parser.add_argument("--protocol", type=Path, required=True,
                        help="the exact frozen neighborhood protocol file")
    parser.add_argument("--repository-root", type=Path, required=True,
                        help="artifact repository root; exported paths become relative to it")
    parser.add_argument("--output-dir", type=Path, required=True,
                        help="new output directory; existing paths are never overwritten")
    parser.add_argument("--render-plots", action="store_true",
                        help="run the existing plotter if its native/numeric/trace gates pass")
    parser.add_argument("--plot-script", type=Path,
                        help="existing plot_input0_neighborhood_ablation.py")
    parser.add_argument("--model-domain-evidence", type=Path,
                        help="C++-verified exact evidence for the Task_13 Raytracing exclusion")
    args = parser.parse_args(argv)
    try:
        result = export(args.results_root, args.protocol, args.repository_root,
                        args.output_dir, render_plots=args.render_plots,
                        plot_script=args.plot_script,
                        model_domain_evidence=args.model_domain_evidence)
    except (ExportError, OSError, subprocess.CalledProcessError) as exc:
        print(f"export_neighborhood_final_results: {exc}", file=sys.stderr)
        return 1
    measured = sum(row["actual_stage_cycles"] is not None for row in result["rows"])
    print(f"exported {measured} measured stage cells and {result['cell_count'] - measured} "
          f"model-domain exclusions to {args.output_dir}")
    print(f"publication_readiness={result['publication_readiness']} formal_go=false")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
