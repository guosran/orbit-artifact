#!/usr/bin/env python3
"""Measure C++ source-certified all-unit inputs under the ablation protocol."""
from __future__ import annotations

import argparse
import copy
import json
from pathlib import Path
import shutil
import sys

from neighborhood_replay import infer_function
from replay_cpp_global_top5 import invoke, write
import validate_embedded_native_trace as trace_validator

ROOT = Path(__file__).resolve().parents[1]
SHARED_ORBIT_SCHEDULER = {
    "backend": "orbit-production",
    "dispatch_policy": "critical-path",
    "timing": "common-explicit-network",
}
STANDARD_ARCHITECTURE = ROOT / "config/architectures/amoeba_4x4_cgra_2x2_context6.yaml"
DIAGNOSTIC_ARCHITECTURE = ROOT / "config/architectures/amoeba_4x4_cgra_2x2_context6_ctrlmem23_diagnostic.yaml"
DOMAIN_EXCLUSION_POLICY = "compiler-proved-runtime-II-ceiling-v1"
DIRECT_MODEL_NAMESPACE = "orbit-per-cgra-2x2-direct-4member-v1"
SOURCE_REPOSITORY = "https://github.com/guosran/orbit.git"
TRAINING_II_CEILING = 20
DIAGNOSTIC_RUNTIME_II_CEILING = 23
RAY_TASKS = tuple(f"Task_{index}" for index in range(27))
RAY_MODEL_QUERY_SHAPES = ((2, 2), (2, 4), (2, 6), (2, 8),
                          (4, 2), (4, 4), (6, 2), (8, 2))
DIRECT_MODEL_NAME = "orbit-cgra-ii-per-cgra-2x2-direct-4member-v1"


def bound_stage(protocol):
    stages = protocol.get("stages")
    if isinstance(stages, list) and stages:
        first = stages[0]
        name = first.get("name") if isinstance(first, dict) else first
        if isinstance(name, str):
            return name
    order = protocol.get("stage_order")
    if isinstance(order, list) and order and isinstance(order[0], str):
        return order[0]
    return "shape-only"


def ray_domain_exclusion_enabled(workload, protocol):
    """Return whether the explicit, Ray-only 23-II admission policy is bound."""
    if workload != "raytracing":
        return False
    policy = protocol.get("fixed1x1_domain_exclusion_policy")
    search = protocol.get("search", {})
    ceiling = search.get("diagnostic_ii_ceiling") if isinstance(search, dict) else None
    if policy is None and ceiling is None:
        return False
    if (policy != DOMAIN_EXCLUSION_POLICY or
            ceiling != DIAGNOSTIC_RUNTIME_II_CEILING):
        raise ValueError("Ray model-domain admission requires the named policy and diagnostic II ceiling 23")
    return True


def resolve_selected_path(value, fallback, config_base):
    """Resolve an optional workload path, preserving the global CLI default."""
    if value is None:
        return fallback
    if not isinstance(value, str) or not value:
        raise ValueError("workload architecture/protocol overrides must be nonempty paths")
    value = value.replace("${ARTIFACT_ROOT}", str(ROOT))
    path = Path(value)
    if not path.is_absolute():
        path = config_base / path
    return path.resolve()


def selected_workload_context(workload, entry, config_base, args, default_protocol):
    """Apply the established workload-local architecture/protocol overrides."""
    selected = copy.copy(args)
    selected.architecture = resolve_selected_path(
        entry.get("architecture"), args.architecture, config_base)
    selected.protocol = resolve_selected_path(
        entry.get("protocol"), args.protocol, config_base)
    protocol = default_protocol
    if selected.protocol != args.protocol:
        protocol = json.loads(selected.protocol.read_text())
    validate_workload_architecture(workload, protocol, selected.architecture)
    return selected, protocol


def validate_workload_architecture(workload, protocol, architecture):
    """Bind accepted live paths by exact YAML bytes, not inode/path identity."""
    diagnostic = ray_domain_exclusion_enabled(workload, protocol)
    expected = DIAGNOSTIC_ARCHITECTURE if diagnostic else STANDARD_ARCHITECTURE
    try:
        actual_text = architecture.read_text(encoding="utf-8")
        expected_text = expected.read_text(encoding="utf-8")
    except OSError as error:
        raise ValueError(f"cannot read selected architecture YAML: {error}") from error
    if actual_text != expected_text:
        label = "diagnostic ctrlmem=23" if diagnostic else "frozen ctrlmem=20"
        raise ValueError(f"{workload} architecture bytes differ from the {label} YAML")


def _entry_proof_path(entry, key, config_base):
    path = resolve_selected_path(entry.get(key), None, config_base)
    if path is None:
        raise ValueError(f"Ray domain admission requires workload entry path {key!r}")
    return path


def _recorded_command(record, label, argument_index=None):
    commands = record.get("commands")
    if not isinstance(commands, list):
        raise ValueError("Ray canonical proof record has no command list")
    matches = [command for command in commands
               if isinstance(command, dict) and command.get("label") == label]
    if len(matches) != 1 or matches[0].get("exit_code") != 0:
        raise ValueError(f"Ray canonical proof lacks one successful {label} command")
    command = matches[0]
    argv = command.get("argv")
    if not isinstance(argv, list) or not argv or any(not isinstance(item, str) for item in argv):
        raise ValueError(f"Ray canonical {label} command argv is malformed")
    if argument_index is not None and (len(argv) <= argument_index or not argv[argument_index]):
        raise ValueError(f"Ray canonical {label} command is missing its input path")
    output = command.get("output")
    if not isinstance(output, str) or not output:
        output_index = next((index + 1 for index, item in enumerate(argv[:-1])
                             if item == "-o"), None)
        if output_index is not None and output_index < len(argv):
            output = argv[output_index]
    if not isinstance(output, str) or not output:
        raise ValueError(f"Ray canonical {label} command is missing its output path")
    command["output"] = output
    return command


def validate_ray_canonical_proof(canonical, entry, config_base):
    identity_path = _entry_proof_path(entry, "source_identity_record", config_base)
    lowering_path = _entry_proof_path(entry, "canonical_lowering_record", config_base)
    try:
        identity = json.loads(identity_path.read_text())
        lowering = json.loads(lowering_path.read_text())
    except (OSError, json.JSONDecodeError) as error:
        raise ValueError(f"Ray canonical source proof is unreadable: {error}") from error
    identity = _require_mapping(identity, "source-identity record")
    lowering = _require_mapping(lowering, "canonical-lowering record")
    if (identity.get("schema") != "orbit-amoeba-original-ray-input0-source-identity-v1" or
            identity.get("original_git_index_path") != "Evaluation/Raytracing/L3/raytracing.mlir" or
            identity.get("native_generic_input0_bytes_equal") is not True or
            identity.get("no_source_fission") is not True or
            identity.get("binding") != {"argument": 0, "value": 1472}):
        raise ValueError("Ray canonical input lacks the exact original-source identity proof")
    original_command = _recorded_command(identity, "original-input0", 1)
    artifact_command = _recorded_command(identity, "artifact-input0", 1)
    artifact_input = identity.get("artifact_input")
    if (not isinstance(artifact_input, str) or
            str(Path(artifact_input).resolve()) not in artifact_command["argv"]):
        raise ValueError("Ray source-identity proof command differs from its recorded artifact input")
    if not any(Path(argument).name == "amoeba-index-original.mlir"
               for argument in original_command["argv"]):
        raise ValueError("Ray original input0 command does not name the captured source-index module")
    try:
        original_input0 = Path(original_command["output"]).read_bytes()
        artifact_input0 = Path(artifact_command["output"]).read_bytes()
    except OSError as error:
        raise ValueError(f"Ray source-identity command output is unreadable: {error}") from error
    if original_input0 != artifact_input0:
        raise ValueError("Ray original and artifact input0 proof outputs differ in exact bytes")
    if (lowering.get("schema") != "orbit-original-ray-canonical-lowering-repair-v1" or
            Path(str(lowering.get("canonical", ""))).resolve() != canonical.resolve() or
            lowering.get("exact_r4_canonical_bytes_equal") is not True or
            lowering.get("original_unfissioned_input") is not True):
        raise ValueError("Ray canonical input lacks the exact unfissioned r4 lowering proof")
    prefix_command = _recorded_command(lowering, "prefix", 1)
    lower_command = _recorded_command(lowering, "lower", 1)
    lowered = Path(str(lowering.get("lowered", "")))
    pre_neura = Path(str(lowering.get("pre_neura", "")))
    source = Path(str(lowering.get("source", "")))
    if (not lowered.is_file() or not pre_neura.is_file() or not source.is_file() or
            Path(prefix_command["output"]).resolve() != pre_neura.resolve() or
            Path(lower_command["output"]).resolve() != lowered.resolve() or
            str(source.resolve()) not in prefix_command["argv"] or
            str(pre_neura.resolve()) not in lower_command["argv"]):
        raise ValueError("Ray canonical lowering output differs from its successful native lower command")
    try:
        canonical_bytes = canonical.read_bytes()
        lowered_bytes = lowered.read_bytes()
    except OSError as error:
        raise ValueError(f"Ray canonical or lowered module is unreadable: {error}") from error
    if canonical_bytes != lowered_bytes:
        raise ValueError("Ray canonical module bytes differ from the successful native lowered artifact")
    return {
        "source_identity_record": str(identity_path),
        "canonical_lowering_record": str(lowering_path),
        "native_generic_input0_bytes_equal": True,
        "source_input0_outputs_exact_bytes_equal": True,
        "exact_r4_canonical_bytes_equal": True,
        "original_unfissioned_input": True,
        "canonical_matches_lowered_artifact_exact_bytes": True,
    }


def bound_scheduler(protocol, args, workload=None):
    value = protocol.get("scheduler")
    if value is None:
        return None
    if value != SHARED_ORBIT_SCHEDULER:
        raise ValueError("protocol scheduler must bind the shared ORBIT critical-path profile")
    names = tuple(item.get("name") for item in protocol.get("stages", [])
                  if isinstance(item, dict))
    expected = ("shape-temporal", "shape-temporal-replica",
                "shape-temporal-replica-tiling", "full-joint")
    if protocol.get("stage_scheme") == "full-joint-fission":
        expected += ("full-joint-fission",)
    if (names != expected or tuple(protocol.get("stage_order", [])) != expected or
            any(not isinstance(item, dict) or item.get("dispatch") != "critical-path" or
                item.get("scheduling_mode") != "spatial-temporal"
                for item in protocol.get("stages", []))):
        raise ValueError("shared ORBIT fixed1x1 requires the bound independent critical-path stage protocol")
    if not args.inter_task_network:
        raise ValueError("shared ORBIT scheduler requires the common explicit inter-task network")
    expected_network = ROOT / "config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml"
    expected_network_binding = "${ARTIFACT_ROOT}/config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml"
    expected_architecture_bindings = {
        "${ARTIFACT_ROOT}/config/architectures/amoeba_4x4_cgra_2x2_context6.yaml",
        "${ARTIFACT_ROOT}/config/architectures/amoeba_4x4_cgra_2x2_context6_ctrlmem23_diagnostic.yaml",
    }
    expected_model_binding = "${ARTIFACT_ROOT}/reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json"
    if args.inter_task_network.resolve() != expected_network.resolve():
        raise ValueError("shared ORBIT scheduler must use the unchanged common network specification")
    if (protocol.get("inter_task_network_spec") != expected_network_binding or
            protocol.get("architecture") not in expected_architecture_bindings or
            protocol.get("model_ensemble") != expected_model_binding or
            args.architecture.read_text(encoding="utf-8") !=
            (DIAGNOSTIC_ARCHITECTURE if ray_domain_exclusion_enabled(
                workload, protocol) else STANDARD_ARCHITECTURE).read_text(encoding="utf-8")):
        raise ValueError("fixed1x1 architecture, model, or network differs from the v59 protocol binding")
    if args.output_root.name != protocol.get("fixed1x1_cohort_id"):
        raise ValueError("fixed1x1 output root must match the protocol's fresh cohort ID")
    contract = json.loads(args.source_contract_file.read_text())
    if (contract.get("schema") != "orbit-neighborhood-exact-source-model-contract-v1" or
            contract.get("model_namespace") != protocol.get("model_namespace") or
            contract.get("source_commit") != protocol.get("source_commit") or
            contract.get("immutable_optimizer_pin") != protocol.get("optimizer_pin") or
            protocol.get("source_contract_file") != "${ARTIFACT_ROOT}/" + str(
                args.source_contract_file.resolve().relative_to(ROOT))):
        raise ValueError("fixed1x1 source/model contract differs from the bound v59 protocol")
    model_payloads = contract.get("model_payloads")
    model_path = ROOT / "reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json"
    if (not isinstance(model_payloads, list) or not model_payloads or
            not isinstance(model_payloads[0], dict) or not model_path.is_file() or
            model_payloads[0].get("path") != "ensemble.json" or
            model_payloads[0].get("text") != model_path.read_text()):
        raise ValueError("fixed1x1 source/model contract does not bind the v59 model bytes")
    replay_payloads = contract.get("replay_payloads")
    if (not isinstance(replay_payloads, list) or
            not any(isinstance(item, dict) and item.get("path") == expected_network.relative_to(ROOT).as_posix()
                    and item.get("text") == expected_network.read_text()
                    for item in replay_payloads)):
        raise ValueError("source/model contract does not bind the common network bytes")
    return dict(SHARED_ORBIT_SCHEDULER)


def _protocol_file_path(value, label):
    if not isinstance(value, str) or not value:
        raise ValueError(f"protocol {label} must be a nonempty path")
    value = value.replace("${ARTIFACT_ROOT}", str(ROOT))
    path = Path(value)
    if not path.is_absolute():
        path = ROOT / path
    return path.resolve()


def _require_mapping(value, label):
    if not isinstance(value, dict):
        raise ValueError(f"native domain preflight {label} must be a JSON object")
    return value


def _require_exact_unit_space(space_path, function):
    try:
        lines = [json.loads(line) for line in space_path.read_text().splitlines()]
    except (OSError, json.JSONDecodeError) as error:
        raise ValueError(f"native domain candidate space is unreadable: {error}") from error
    if len(lines) != 2:
        raise ValueError("native domain candidate space must contain one manifest and one footer")
    manifest = _require_mapping(lines[0], "candidate-space manifest")
    footer = _require_mapping(lines[1], "candidate-space footer")
    if (manifest.get("schema") != "amoeba-analytical-task-space" or
            manifest.get("record_type") != "space" or
            manifest.get("representation") != "factored" or
            manifest.get("function") != function or
            manifest.get("graph_variant_id") != "identity" or
            manifest.get("max_cgras_per_task") != 1 or
            manifest.get("candidate_count") not in ("1", 1) or
            manifest.get("exact") is not True):
        raise ValueError("native domain candidate space is not the exact one-candidate all-unit identity space")
    factors = manifest.get("factors")
    if not isinstance(factors, list) or tuple(
            factor.get("task") if isinstance(factor, dict) else None
            for factor in factors) != RAY_TASKS:
        raise ValueError("native domain candidate space does not cover the exact original 27-task Ray graph")
    for factor in factors:
        shapes = factor.get("shapes")
        if (not isinstance(shapes, list) or len(shapes) != 1 or
                not isinstance(shapes[0], dict) or
                shapes[0].get("rows") != 1 or shapes[0].get("cols") != 1 or
                shapes[0].get("kind") != "rect" or
                shapes[0].get("cgra_count") != 1 or
                shapes[0].get("cgra_shape") != "1x1" or
                shapes[0].get("mapper_tile_rows") != 2 or
                shapes[0].get("mapper_tile_cols") != 2):
            raise ValueError("native domain candidate space contains a non-unit or malformed task shape")
    if (footer.get("schema") != "amoeba-analytical-task-space" or
            footer.get("record_type") != "footer" or
            footer.get("representation") != "factored" or
            footer.get("candidate_count") not in ("1", 1) or
            footer.get("status") != "unranked-factored-space"):
        raise ValueError("native domain candidate-space footer does not bind the one all-unit candidate")
    return manifest


def _expected_diagnostic_override(architecture_text):
    return {
        "schema": "per-cgra-2x2-ii-extrapolation-v1",
        "training_ii_ceiling": TRAINING_II_CEILING,
        "runtime_ii_ceiling": DIAGNOSTIC_RUNTIME_II_CEILING,
        "training_architecture_exact_yaml_text": STANDARD_ARCHITECTURE.read_text(encoding="utf-8"),
        "runtime_architecture_exact_yaml_text": architecture_text,
        "extrapolation_enabled": True,
        "formal": False,
        "output_rule": "min(lower_bound + softplus(logit), diagnostic_runtime_ii_ceiling)",
    }


def validate_domain_catalog(space_path, catalog_path, canonical, function,
                            protocol, architecture):
    """Validate the complete native model preflight and return only proven blockers."""
    manifest = _require_exact_unit_space(space_path, function)
    try:
        catalog = json.loads(catalog_path.read_text())
    except (OSError, json.JSONDecodeError) as error:
        raise ValueError(f"native domain cost catalog is unreadable: {error}") from error
    catalog = _require_mapping(catalog, "cost catalog")
    namespace = protocol.get("model_namespace")
    source_repository = protocol.get("source_git_repository")
    source_commit = protocol.get("source_commit")
    if (namespace != DIRECT_MODEL_NAMESPACE or source_repository != SOURCE_REPOSITORY or
            not isinstance(source_commit, str) or not source_commit):
        raise ValueError("Ray domain protocol lacks the pinned direct-model source identity")
    if (catalog.get("schema") != "amoeba-task-shape-cost" or
            catalog.get("function") != function or catalog.get("namespace") != namespace):
        raise ValueError("native domain cost catalog schema, function, or namespace differs from the request")

    metadata = _require_mapping(catalog.get("predictor_metadata"), "predictor metadata")
    architecture_text = architecture.read_text(encoding="utf-8")
    model_ensemble = _protocol_file_path(protocol.get("model_ensemble"), "model_ensemble")
    try:
        model_bundle = json.loads(model_ensemble.read_text())
    except (OSError, json.JSONDecodeError) as error:
        raise ValueError(f"pinned direct-model ensemble is unreadable: {error}") from error
    model_bundle = _require_mapping(model_bundle, "pinned direct-model ensemble")
    bundle_source_model = _require_mapping(model_bundle.get("source_model"), "pinned model source provenance")
    bundle_feature_contract = _require_mapping(model_bundle.get("feature_contract"), "pinned model feature contract")
    bundle_shape_protocol = _require_mapping(model_bundle.get("shape_protocol"), "pinned model shape protocol")
    bundle_architecture = _require_mapping(model_bundle.get("architecture"), "pinned model architecture")
    bundle_members = model_bundle.get("members")
    member_seeds = [member.get("seed") for member in bundle_members
                    if isinstance(member, dict)] if isinstance(bundle_members, list) else []
    if (model_bundle.get("schema") != "orbit-cgra-ii-per-cgra-2x2-direct-ensemble-cpp-v1" or
            model_bundle.get("model_namespace") != namespace or
            member_seeds != [17, 41, 113, 239] or
            bundle_architecture.get("exact_yaml_text") != STANDARD_ARCHITECTURE.read_text(encoding="utf-8")):
        raise ValueError("pinned direct-model ensemble schema, namespace, members, or training architecture changed")
    architecture_contract = "neura-architecture-v1:" + architecture.stem
    witness = metadata.get("canonical_module_witness")
    canonical_text = canonical.read_text(encoding="utf-8")
    if not canonical_text.endswith("\n") or witness != canonical_text[:-1]:
        raise ValueError("native predictor canonical-module witness differs from the full canonical generic IR")
    expected_metadata = {
        "architecture_contract": architecture_contract,
        "architecture_path": str(architecture.resolve()),
        "architecture_schema": "neura-architecture-v1",
        "candidate_only": True,
        "candidate_count": 1,
        "diagnostic_only": True,
        "direct_ensemble": {
            "member_count": 4,
            "member_seeds": member_seeds,
            "reduction": "arithmetic_mean",
            "uncertainty": "population_standard_deviation",
        },
        "feature_contract_id": bundle_feature_contract.get("contract_id"),
        "feature_extractor": bundle_feature_contract.get("extractor"),
        "feature_frontend": "c++-mlir-current-body-direct-148-v1",
        "formal": False,
        "model": DIRECT_MODEL_NAME,
        "model_interval_max_ii": TRAINING_II_CEILING,
        "model_schema": model_bundle["schema"],
        "model_status": "candidate_pending_amoeba_benchmark_overlap_audit",
        "old_4x4_labels_reused": False,
        "predictor_source": "per-cgra-2x2-direct-four-member-ii-predictor",
        "production_ready": False,
        "provenance_schema": "orbit-cost-provenance-v1",
        "quality_status": "candidate_pending_amoeba_benchmark_overlap_audit",
        "shape_protocol_id": bundle_shape_protocol.get("protocol_id"),
        "source_commit": source_commit,
        "source_graph_id": "identity",
        "source_repository": source_repository,
        "source_task_ids": list(RAY_TASKS),
        "supports_whole_program_latency_or_throughput_claim": False,
        "unsupported_prediction_policy": "analytical-lower-bound-exceeds-diagnostic-runtime-ceiling-v1",
    }
    for key, expected in expected_metadata.items():
        if metadata.get(key) != expected:
            raise ValueError(f"native predictor metadata field {key!r} differs from the bound domain preflight")
    if metadata.get("source_model") != bundle_source_model:
        raise ValueError("native predictor source-model provenance differs from the full pinned ensemble value")
    if metadata.get("ranking_policy") != {
            "mapper_success_probability": "not_predicted",
            "objective": "predicted_scheduler_makespan",
            "uses_mapper_success_probability": False}:
        raise ValueError("native predictor ranking metadata differs from the direct-model contract")
    if metadata.get("diagnostic_override") != _expected_diagnostic_override(architecture_text):
        raise ValueError("native predictor diagnostic override is missing or differs from all eight bound fields")

    entries = catalog.get("entries")
    expected_query_keys = {
        (task, rows, cols)
        for task in RAY_TASKS
        for rows, cols in RAY_MODEL_QUERY_SHAPES
    }
    if not isinstance(entries, list) or len(entries) != len(expected_query_keys):
        raise ValueError("native domain cost catalog must contain the complete 27-task by 8-shape query inventory")
    by_query = {}
    for row in entries:
        if not isinstance(row, dict):
            raise ValueError("native domain cost catalog contains a malformed query row")
        task = row.get("task")
        rows, cols = row.get("mapper_tile_rows"), row.get("mapper_tile_cols")
        key = (task, rows, cols)
        if task not in RAY_TASKS or key in by_query:
            raise ValueError("native domain cost catalog has an unexpected or duplicate task-shape query")
        if (key not in expected_query_keys or
                row.get("runtime_ceiling_ii") != DIAGNOSTIC_RUNTIME_II_CEILING or
                row.get("training_ceiling_ii") != TRAINING_II_CEILING):
            raise ValueError("native domain query is outside the exact eight-shape direct-model inventory or ceilings")
        by_query[key] = row
    if set(by_query) != expected_query_keys:
        raise ValueError("native domain cost catalog does not cover the full source-owned task-shape query inventory")

    blockers = []
    for task, rows, cols in sorted(expected_query_keys):
        row = by_query[(task, rows, cols)]
        lower_bound = row.get("analytical_lower_bound")
        if not isinstance(lower_bound, int) or isinstance(lower_bound, bool) or lower_bound < 0:
            raise ValueError("native domain query has a malformed analytical lower bound")
        unsupported = row.get("support_status") == "unsupported" or row.get("status") == "unsupported-model-domain"
        if task == "Task_13" and unsupported:
            if (row.get("status") != "unsupported-model-domain" or
                    row.get("support_status") != "unsupported" or
                    row.get("unsupported_reason") != "analytical-lower-bound-exceeds-diagnostic-runtime-ceiling" or
                    row.get("extrapolation_status") != "outside-diagnostic-runtime-domain" or
                    row.get("model_interval_max_ii") != TRAINING_II_CEILING or
                    lower_bound <= DIAGNOSTIC_RUNTIME_II_CEILING or
                    "predicted_ii" in row or "direct_ensemble_members" in row):
                raise ValueError("Task_13 unsupported query is not the exact compiler-proved runtime-domain record")
            if rows == 2 and cols == 2:
                if lower_bound != 83:
                    raise ValueError("Task_13 unit query lower bound differs from the exact compiler proof (83)")
                blockers.append(row)
            continue
        if (unsupported or row.get("support_status") != "supported" or
                lower_bound > DIAGNOSTIC_RUNTIME_II_CEILING):
            raise ValueError(f"native model-domain query for {task} is unsupported or contradicts its lower bound")
        predicted = row.get("predicted_ii")
        if (not isinstance(predicted, (int, float)) or isinstance(predicted, bool) or
                predicted <= 0 or predicted > DIAGNOSTIC_RUNTIME_II_CEILING):
            raise ValueError(f"native model-domain query for {task} lacks a runtime-bounded prediction")
        spread = row.get("predicted_ii_std")
        members = row.get("direct_ensemble_members")
        if (row.get("candidate_only") is not True or row.get("production_ready") is not False or
                row.get("model_status") != "candidate_pending_amoeba_benchmark_overlap_audit" or
                row.get("ii_mean_source") != "direct_four_member_arithmetic_mean" or
                not isinstance(spread, (int, float)) or isinstance(spread, bool) or spread < 0 or
                not isinstance(members, list) or len(members) != 4):
            raise ValueError(f"native model-domain query for {task} lacks the direct-ensemble feature/prediction proof")
        for index, seed in enumerate((17, 41, 113, 239)):
            member = members[index]
            if (not isinstance(member, dict) or member.get("member_index") != index or
                    member.get("seed") != seed or
                    not isinstance(member.get("predicted_ii"), (int, float)) or
                    isinstance(member.get("predicted_ii"), bool) or
                    not 0 < member["predicted_ii"] <= DIAGNOSTIC_RUNTIME_II_CEILING):
                raise ValueError(f"native model-domain query for {task} lacks the four pinned member predictions")
    if len(blockers) > 1:
        raise ValueError("native domain catalog has more than one permitted Ray exclusion query")
    return manifest, blockers


def build_domain_admission_receipt(*, optimizer, source_contract, protocol_path,
                                   architecture, canonical, function, space_path,
                                   catalog_path, blocker, commands, canonical_proof):
    return {
        "schema": "orbit-input0-all-unit-model-domain-admission-v1",
        "status": "unsupported-model-domain",
        "kind": "compiler-proved-lower-bound-exceeds-configured-runtime-ceiling",
        "workload": "raytracing",
        "task": "Task_13",
        "optimizer": str(optimizer),
        "source_contract": str(source_contract),
        "protocol": str(protocol_path),
        "architecture": str(architecture),
        "canonical_input": str(canonical),
        "function": function,
        "runtime_ii_ceiling": DIAGNOSTIC_RUNTIME_II_CEILING,
        "training_ii_ceiling": TRAINING_II_CEILING,
        "space_file": str(space_path),
        "cost_catalog": str(catalog_path),
        "blocking_rows": [blocker],
        "canonical_module_witness_matches_input": True,
        "canonical_source_proof": canonical_proof,
        "commands": commands,
        "formal_go": False,
        "mapper_invoked": False,
    }


def native_orchestration_option(dispatch_policy):
    if dispatch_policy not in {"fixed", "critical-path"}:
        raise ValueError("unknown native dispatch policy")
    return (
        "--orchestrate-tasks-on-accelerators="
        "orchestration-strategy=analytical-based-task-orchestration "
        f"scheduling-mode=spatial-temporal dispatch-policy={dispatch_policy} "
        "communication-mode=explicit exact-replay-timing=mapped"
    )


def measure(workload, entry, config_base, protocol, args):
    directory = args.output_root / workload
    directory.mkdir()
    original = Path(entry["canonical"])
    if not original.is_absolute():
        original = config_base / original
    canonical = directory / "canonical-input.mlir"
    shutil.copyfile(original, canonical)
    function = infer_function(canonical, entry.get("function"))
    scheduler = bound_scheduler(protocol, args, workload)
    stage = bound_stage(protocol)
    dispatch_policy = scheduler["dispatch_policy"] if scheduler else "fixed"
    result = {
        "schema": "orbit-input0-all-unit-native-v1", "workload": workload,
        "status": "incomplete", "shape_per_task": "1x1 CGRA",
        "ml_model_consumed": False, "baseline_cycles": None,
        "mapper_equality": "pending", "numeric": "pending",
        "independent_trace": "pending", "sram_gate": "pending",
        "formal_go": False, "canonical_input": str(canonical),
        "optimizer": str(args.optimizer), "architecture": str(args.architecture),
        "source_contract": str(args.source_contract_file),
        "protocol": str(args.protocol), "commands": {},
        "scheduler": scheduler,
        "stage": stage,
    }
    base_options = ["--verify-each", f"--architecture-spec={args.architecture}"]
    if args.inter_task_network:
        base_options.append(f"--joint-inter-task-network-spec={args.inter_task_network}")
        result["inter_task_network"] = str(args.inter_task_network)
        result["inter_task_network_text"] = args.inter_task_network.read_text()

    def run(label, input_path, flags, output_path):
        result["status"] = label + "_running"
        write(directory / "result.json", result)
        command = invoke([str(args.optimizer), str(input_path), *base_options,
                          *flags, "--mlir-print-op-generic", "-o", str(output_path)],
                         directory, label)
        result["commands"][label] = command
        if command["exit_code"]:
            result.update(status=label + "_failed", blocker=label + "_process_failed")
            write(directory / "result.json", result)
            return False
        return True

    if ray_domain_exclusion_enabled(workload, protocol):
        canonical_proof = validate_ray_canonical_proof(original, entry, config_base)
        if (protocol.get("model_namespace") != DIRECT_MODEL_NAMESPACE or
                protocol.get("source_git_repository") != SOURCE_REPOSITORY or
                not isinstance(protocol.get("source_commit"), str) or
                not protocol.get("source_commit")):
            raise ValueError("Ray diagnostic protocol lacks the direct-model source identity")
        ensemble = _protocol_file_path(protocol.get("model_ensemble"), "model_ensemble")
        if not ensemble.is_file():
            raise ValueError("Ray diagnostic protocol model ensemble is missing")
        space = directory / "domain-space.jsonl"
        catalog = directory / "domain-cost-catalog.json"
        cache = directory / "domain-ml-cache.json"
        for path in (space, catalog, cache):
            if path.exists() or path.is_symlink():
                raise ValueError(f"Ray domain preflight output must be fresh: {path}")
        enumerate_flag = (
            f"--enumerate-analytical-task-candidates=function={function} output={space} "
            "factored-output=true max-cgras-per-task=1 graph-variant-id=identity")
        if not run("domain-space", original, [enumerate_flag], "/dev/null"):
            raise RuntimeError("native Ray all-unit model-domain space enumeration failed")
        cost_flag = (
            "--predict-analytical-task-cost-catalog=" + " ".join((
                f"function={function}",
                f"space-file={space}",
                f"ensemble-file={ensemble}",
                f"checkpoint-dir={ensemble.parent}",
                "architecture-contract=neura-architecture-v1:" + args.architecture.stem,
                f"architecture-path={args.architecture}",
                "source-git-repository=" + protocol["source_git_repository"],
                "source-git-commit=" + protocol["source_commit"],
                "graph-variant-id=identity",
                "model-namespace=" + protocol["model_namespace"],
                f"cache={cache}",
                f"output={catalog}",
                "allow-unsupported-above-model-ceiling=true",
                "diagnostic-ii-ceiling=23",
            )))
        if not run("domain-predictor", original, [cost_flag], "/dev/null"):
            raise RuntimeError("native Ray all-unit model-domain predictor failed")
        _, blocking_rows = validate_domain_catalog(
            space, catalog, original, function, protocol, args.architecture)
        if blocking_rows:
            receipt_path = directory / "model-domain-admission.json"
            receipt = build_domain_admission_receipt(
                optimizer=args.optimizer,
                source_contract=args.source_contract_file,
                protocol_path=args.protocol,
                architecture=args.architecture,
                canonical=original,
                function=function,
                space_path=space,
                catalog_path=catalog,
                blocker=blocking_rows[0],
                commands={key: result["commands"][key]
                          for key in ("domain-space", "domain-predictor")},
                canonical_proof=canonical_proof,
            )
            write(receipt_path, receipt)
            result.update(
                status="unsupported-model-domain",
                baseline_cycles=None,
                mapper_equality="not-run",
                numeric="not-run",
                independent_trace="not-run",
                sram_gate="not-run",
                domain_admission=str(receipt_path),
                domain_preflight_model_prediction_consumed=True,
                actual_cycles_claim="none",
            )
            write(directory / "result.json", result)
            return result

    search = protocol.get("search", {})
    active = search.get("active_transfer_arguments_by_workload", {}).get(
        workload, search.get("active_transfer_arguments", []))
    if active:
        proof_path = directory / "active-transfer-proof.json"
        prepared = directory / "active-transfer-input.mlir"
        if not run("active-transfer", canonical, [
                "--prove-static-active-transfer-shapes="
                f"function={function} arguments={','.join(map(str, active))} "
                f"report-output={proof_path}"], prepared):
            return result
        proof = json.loads(proof_path.read_text())
        if (search.get("active_transfer_require_proven", True) and
                (len(proof["proofs"]) != len(active) or
                 any(row.get("status") != "proven" for row in proof["proofs"]))):
            result.update(status="active-transfer_failed", blocker="required_active_transfer_unproven")
            write(directory / "result.json", result)
            return result
        result["active_transfer_proof"] = str(proof_path)
        canonical = prepared

    space = directory / "all-unit-space.jsonl"
    candidate = directory / "all-unit.mlir"
    mapped = directory / "mapped.mlir"
    native_root = directory / "native"
    native = native_root / "rank-0/native.mlir"
    native.parent.mkdir(parents=True)
    enumerate_flag = (
        f"--enumerate-analytical-task-candidates=function={function} output={space} "
        "factored-output=true max-cgras-per-task=1 graph-variant-id=identity")
    if not run("materialize", canonical, [enumerate_flag,
            f"--materialize-analytical-task-candidate=function={function} "
            f"candidates={space} candidate-id=candidate-0"], candidate):
        return result
    if not run("mapper", candidate, [
            f"--map-joint-scheduling-tasks=function={function} candidate-id=candidate-0 "
            f"all-unit-baseline=true mapping-cache-dir={args.mapping_cache}"], mapped):
        return result
    if not run("native", mapped, [
            native_orchestration_option(dispatch_policy)], native):
        return result

    manifest = json.loads(space.read_text().splitlines()[0])
    assert manifest["candidate_count"] == 1 and manifest["graph_variant_id"] == "identity"
    task_shapes = []
    for factor in manifest["factors"]:
        assert len(factor["shapes"]) == 1 and factor["shapes"][0]["cgra_count"] == 1
        task_shapes.append({"task": factor["task"], "trip_count": factor["trip_count"],
                            "shape": factor["shapes"][0]})
    trace = trace_validator.validate(native.read_text(),
        {"candidate_id": "candidate-0", "task_shapes": task_shapes}, "identity")
    write(directory / "independent-trace.json", trace)
    result.update(independent_trace=trace["status"], baseline_cycles=trace["native_cycles"],
                  mapper_equality="pass" if mapped.read_text().count(
                      "amoeba.mapper_replay_verified") == len(task_shapes) else "fail",
                  status="numeric_running")
    write(directory / "result.json", result)
    numeric = invoke([sys.executable, str(ROOT / "scripts/run_input0_numeric.py"),
        "--workloads", workload, "--stage", stage, "--ranks", "0",
        "--native-root", str(native_root), "--output-root", str(directory / "numeric"),
        "--optimizer", str(args.optimizer), "--llvm-build", str(args.llvm_build),
        "--jobs", "1"], directory, "numeric")
    result["commands"]["numeric"] = numeric
    result["numeric"] = "pass" if numeric["exit_code"] == 0 else "fail"
    capacity = json.loads(args.sram_config.read_text())
    assert capacity["schema"] == "orbit-vectorcgra-sram-configuration-v1"
    result["sram_capacity_config"] = str(args.sram_config)
    if capacity["per_cgra_capacity_bytes"] is None:
        assert capacity["capacity_status"] == "pending"
        result.update(sram_blocker="target_sram_capacity_unestablished", sram_capacity_evaluated=False)
    else:
        gate = directory / "sram-gate.json"
        if run("sram", native, [
                "--verify-production-sram-native-capacity-gate="
                f"capacity-bytes-per-cgra={capacity['per_cgra_capacity_bytes']} "
                f"grid-rows={capacity['fabric_rows']} grid-columns={capacity['fabric_columns']} output={gate}"],
                "/dev/null"):
            evidence = json.loads(gate.read_text())
            result.update(sram_gate=evidence["status"], sram_evidence=str(gate))
        else:
            result.update(sram_gate="pending", sram_blocker="native_sram_evidence_process_failed")
    result["status"] = ("complete" if result["numeric"] == result["independent_trace"] ==
                        result["mapper_equality"] == "pass" else "validation_failed")
    write(directory / "result.json", result)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for flag in ("config", "protocol", "source-contract-file", "optimizer", "architecture",
                 "mapping-cache", "output-root", "llvm-build", "sram-config"):
        parser.add_argument("--" + flag, type=Path, required=True)
    parser.add_argument("--inter-task-network", type=Path)
    parser.add_argument("--workloads", nargs="+")
    args = parser.parse_args()
    for key, value in vars(args).items():
        if isinstance(value, Path):
            setattr(args, key, value.resolve())
    config = json.loads(args.config.read_text())
    protocol = json.loads(args.protocol.read_text())
    args.output_root.mkdir(parents=True, exist_ok=False)
    args.mapping_cache.mkdir(parents=True, exist_ok=True)
    rows = []
    for workload in args.workloads or list(config["workloads"]):
        entry = config["workloads"][workload]
        selected_args, selected_protocol = selected_workload_context(
            workload, entry, args.config.parent, args, protocol)
        rows.append(measure(workload, entry, args.config.parent, selected_protocol, selected_args))
        write(args.output_root / "summary.json", rows)
        print(json.dumps({key: rows[-1].get(key) for key in
                          ("workload", "status", "baseline_cycles", "blocker",
                           "domain_admission")}), flush=True)
    def accepted(row):
        if row.get("status") == "complete":
            return True
        if (row.get("workload") != "raytracing" or
                row.get("status") != "unsupported-model-domain" or
                row.get("baseline_cycles") is not None or
                row.get("mapper_equality") != "not-run" or
                row.get("numeric") != "not-run" or
                row.get("independent_trace") != "not-run"):
            return False
        receipt_path = Path(str(row.get("domain_admission", "")))
        if not receipt_path.is_file():
            return False
        try:
            receipt = json.loads(receipt_path.read_text())
        except (OSError, json.JSONDecodeError):
            return False
        return (receipt.get("schema") == "orbit-input0-all-unit-model-domain-admission-v1" and
                receipt.get("status") == "unsupported-model-domain" and
                receipt.get("kind") ==
                "compiler-proved-lower-bound-exceeds-configured-runtime-ceiling" and
                receipt.get("workload") == "raytracing" and
                receipt.get("formal_go") is False and
                receipt.get("mapper_invoked") is False and
                receipt_path.resolve() == (args.output_root / "raytracing" /
                                            "model-domain-admission.json").resolve())
    return 0 if all(accepted(row) for row in rows) else 2


if __name__ == "__main__":
    raise SystemExit(main())
