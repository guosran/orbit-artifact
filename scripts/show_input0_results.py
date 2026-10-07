#!/usr/bin/env python3
"""Show measured input-0 ORBIT stages and aligned baseline cycles."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import re

from render_neighborhood_table import LEGACY_STAGES, STAGES, resolve_stage_order


ROOT = Path(__file__).resolve().parents[1]
WORKLOADS = ("gcn", "harris", "llama", "lu", "radar", "raytracing")
DEFAULT_COHORT = "input0-neighborhood-2x2-v59-shared-scheduler-r3"
SHARED_ORBIT_COHORT = "input0-neighborhood-2x2-v59-shared-scheduler-r3"
SHARED_RAY_FISSION_COHORT = "input0-ray-fission-2x2-v59-shared-scheduler-r3"
SHARED_BASELINE_COHORT = "input0-all-unit-2x2-v59-shared-scheduler-r3"
SHARED_AMOEBA_COHORT = "input0-amoeba-full-2x2-v59-shared-scheduler-r3"
SHARED_SCHEDULER = {
    "backend": "orbit-production",
    "dispatch_policy": "critical-path",
    "timing": "common-explicit-network",
}
SHARED_PROTOCOLS = {
    SHARED_ORBIT_COHORT: ".work/input0-neighborhood-2x2-v59-shared-scheduler-r3/protocol-bound.json",
    SHARED_RAY_FISSION_COHORT: ".work/input0-ray-fission-2x2-v59-shared-scheduler-r3/protocol-bound.json",
}
SHARED_SOURCE_CONTRACT = ".work/post-publication/source-model-contract-v59-shared-scheduler-r3.json"
HISTORICAL_COHORTS = {
    "v19": ("neighborhood-v19", "ray-fission-v19"),
    "v38": ("input0-neighborhood-2x2-v38", "input0-ray-fission-2x2-v38"),
    "v57": ("input0-neighborhood-2x2-v57-independent",
            "input0-ray-fission-2x2-v57-independent"),
    "v58": ("input0-neighborhood-2x2-v58-merged-stages",
            "input0-ray-fission-2x2-v58-merged-stages"),
}
MODEL_NAMESPACE = "orbit-per-cgra-2x2-direct-4member-v1"
ARCHITECTURE = "config/architectures/amoeba_4x4_cgra_2x2_context6.yaml"
DIAGNOSTIC_ARCHITECTURE = "config/architectures/amoeba_4x4_cgra_2x2_context6_ctrlmem23_diagnostic.yaml"
NETWORK = "config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml"


def read_json(path: Path) -> dict | None:
    if not path.is_file():
        return None
    try:
        value = json.loads(path.read_text())
    except (OSError, ValueError):
        return None
    return value if isinstance(value, dict) else None


def artifact_path(value: object) -> Path | None:
    if not isinstance(value, str):
        return None
    prefix = "${ARTIFACT_ROOT}/"
    if value.startswith(prefix):
        return (ROOT / value[len(prefix):]).resolve()
    path = Path(value)
    return path.resolve() if path.is_absolute() else (ROOT / path).resolve()


def shared_protocol(cohort: str) -> tuple[dict, Path, Path] | None:
    relative_protocol = SHARED_PROTOCOLS.get(cohort)
    if relative_protocol is None:
        return None
    protocol_path = (ROOT / relative_protocol).resolve()
    protocol = read_json(protocol_path)
    contract_path = (ROOT / SHARED_SOURCE_CONTRACT).resolve()
    contract = read_json(contract_path)
    network_path = (ROOT / NETWORK).resolve()
    if not isinstance(protocol, dict) or not isinstance(contract, dict):
        return None
    model_path = artifact_path(protocol.get("model_ensemble"))
    model_payloads = contract.get("model_payloads", [])
    replay_payloads = contract.get("replay_payloads", [])
    expected_stages = ("shape-temporal", "shape-temporal-replica",
                       "shape-temporal-replica-tiling", "full-joint")
    if (not protocol or not contract or not network_path.is_file() or
            protocol.get("cohort_id") != cohort or
            protocol.get("scheduler") != SHARED_SCHEDULER or
            not isinstance(protocol.get("stage_order"), list) or
            tuple(protocol["stage_order"]) != expected_stages or
            not isinstance(protocol.get("stages"), list) or
            tuple(stage.get("name") for stage in protocol["stages"] if isinstance(stage, dict)) != expected_stages or
            any(not isinstance(stage, dict) or stage.get("dispatch") != "critical-path" or
                stage.get("scheduling_mode") != "spatial-temporal"
                for stage in protocol.get("stages", [])) or
            protocol.get("model_namespace") != MODEL_NAMESPACE or
            artifact_path(protocol.get("source_contract_file")) != contract_path or
            artifact_path(protocol.get("architecture")) != (ROOT / ARCHITECTURE).resolve() or
            artifact_path(protocol.get("inter_task_network_spec")) != network_path or
            contract.get("model_namespace") != MODEL_NAMESPACE or
            contract.get("source_commit") != protocol.get("source_commit") or
            protocol.get("optimizer_pin") != contract.get("immutable_optimizer_pin") or
            not model_path or not model_path.is_file() or
            not isinstance(model_payloads, list) or not model_payloads or
            not isinstance(model_payloads[0], dict) or
            model_path.read_text() != model_payloads[0].get("text") or
            not isinstance(replay_payloads, list) or
            not any(item.get("path") == NETWORK and item.get("text") == network_path.read_text()
                    for item in replay_payloads if isinstance(item, dict))):
        return None
    return protocol, protocol_path, contract_path


def common_network_path(value: object) -> Path | None:
    """Admit a recorded runtime copy only if its full bytes match the contract network."""
    path = artifact_path(value)
    common = (ROOT / NETWORK).resolve()
    if path and path.is_file() and common.is_file() and path.read_bytes() == common.read_bytes():
        return path
    return None


def shared_orbit_result_binding(result: dict, cohort: str) -> bool:
    bound = shared_protocol(cohort)
    if bound is None:
        return False
    protocol, protocol_path, contract_path = bound
    result_protocol = artifact_path(result.get("protocol"))
    binding_value = result.get("source_binding")
    if not isinstance(binding_value, str):
        return False
    binding_path = artifact_path(binding_value)
    binding = read_json(binding_path) if binding_path else None
    network = common_network_path(binding.get("inter_task_network")) if binding else None
    if network is None:
        return False
    search_header = result.get("search_header") or {}
    native_summaries = (result.get("native_top5") or {}, result.get("native_controls") or {})
    return bool(
        result_protocol == protocol_path and binding and
        result.get("scheduler") == SHARED_SCHEDULER and
        isinstance(search_header, dict) and
        search_header.get("schedule_space") == "production-scheduler" and
        search_header.get("dispatch_policy") == SHARED_SCHEDULER["dispatch_policy"] and
        all(isinstance(summary, dict) and summary.get("status") == "native_replayed" and
            isinstance(summary.get("records"), list) and summary["records"] and
            len(summary["records"]) == sum(isinstance(record, dict) for record in summary["records"]) and
            all(record.get("status") == "native_replayed" and
                record.get("scheduler_backend") == "orchestrate-tasks-on-accelerators" and
                record.get("replay_timing_policy") == "production-scheduler-with-mapped-durations"
                for record in summary["records"])
            for summary in native_summaries) and
        binding.get("scheduler") == SHARED_SCHEDULER and
        binding.get("protocol_schema") == protocol.get("schema") and
        binding.get("source_contract_file") == str(contract_path) and
        binding.get("source_commit") == protocol.get("source_commit") and
        artifact_path(binding.get("architecture")) == (ROOT / ARCHITECTURE).resolve() and
        artifact_path(binding.get("inter_task_network")) == network and
        binding.get("inter_task_network_text") == network.read_text() and
        isinstance(binding.get("optimizer"), str) and
        Path(binding["optimizer"]).is_file() and
        Path(binding["optimizer"]).name == Path(str(protocol.get("optimizer_pin"))).name and
        artifact_path(binding.get("model_cache")) == artifact_path(protocol.get("model_ensemble"))
    )


def shared_model_domain_exclusion(cohort: str) -> bool:
    bound = shared_protocol(cohort)
    if bound is None:
        return False
    protocol, protocol_path, contract_path = bound
    evidence_path = ROOT / "results" / cohort / "model-domain-evidence.json"
    evidence = read_json(evidence_path)
    if not evidence:
        return False
    binding = evidence.get("source_binding") or {}
    network = common_network_path(binding.get("inter_task_network")) if isinstance(binding, dict) else None
    exact_payloads = evidence.get("exact_payloads") or {}
    model_path = artifact_path(protocol.get("model_ensemble"))
    if network is None or not isinstance(binding, dict) or not isinstance(exact_payloads, dict):
        return False
    for key, path in (("source_contract_file", contract_path),
                      ("protocol", protocol_path),
                      ("architecture", (ROOT / ARCHITECTURE).resolve()),
                      ("inter_task_network", network)):
        payload = exact_payloads.get(key) or {}
        if (not path.is_file() or not isinstance(payload, dict) or
                payload.get("path") != str(path) or payload.get("exact_bytes") != path.read_text()):
            return False
    model_payload = exact_payloads.get("ensemble") or {}
    if (not model_path or not isinstance(model_payload, dict) or
            model_payload.get("path") != str(model_path) or
            not model_path.is_file() or model_payload.get("exact_bytes") != model_path.read_text()):
        return False
    queries = evidence.get("queries")
    return bool(
        evidence.get("schema") == "orbit-model-domain-exclusion-evidence-v1" and
        evidence.get("status") == "proved_outside_model_interval" and
        evidence.get("workload") == "raytracing" and evidence.get("task") == "Task_13" and
        evidence.get("model_namespace") == MODEL_NAMESPACE and
        evidence.get("model_interval_max_ii") == 20 and
        evidence.get("protocol") == str(protocol_path) and
        binding.get("scheduler") == SHARED_SCHEDULER and
        binding.get("source_contract_file") == str(contract_path) and
        binding.get("source_commit") == protocol.get("source_commit") and
        artifact_path(binding.get("inter_task_network")) == network and
        artifact_path(binding.get("model_cache")) == model_path and
        binding.get("inter_task_network_text") == network.read_text() and
        isinstance(queries, list) and len(queries) == 8 and
        all(isinstance(row, dict) and row.get("task") == "Task_13" and
            row.get("status") == "unsupported-model-domain" and
            row.get("support_status") == "unsupported" and
            row.get("model_interval_max_ii") == 20 and
            row.get("analytical_lower_bound", 0) > 20 and
            "predicted_ii" not in row for row in queries)
    )


def frozen_final_results(cohort: str) -> dict | None:
    return (read_json(ROOT / "diagnostics" / f"{cohort}-frozen" / "neighborhood-final-results.json") or
            read_json(ROOT / "diagnostics" / cohort / "neighborhood-final-results.json"))


def cycles(value: object) -> str:
    return f"{value:,}" if isinstance(value, int) and not isinstance(value, bool) and value > 0 else "—"


def orbit_cycles(workload: str, stage: str, cohort: str = DEFAULT_COHORT) -> str:
    result = read_json(ROOT / "results" / cohort / workload / stage / "result.json")
    if cohort in SHARED_PROTOCOLS:
        if (result is None or not shared_orbit_result_binding(result, cohort) or
                result.get("scheduler") != SHARED_SCHEDULER):
            return "—"
        if (result.get("numeric") != "pass" or result.get("trace") != "pass" or
                result.get("status") != "native_replayed"):
            return "—"
        return cycles(result.get("actual_stage_cycles"))
    if result is None:
        frozen = frozen_final_results(cohort)
        if not frozen or frozen.get("schema") != "orbit-neighborhood-final-results-v1":
            return "—"
        provenance = frozen.get("provenance") or {}
        if cohort not in {"neighborhood-v19", "ray-fission-v19"} and (
                provenance.get("model_namespace") != MODEL_NAMESPACE or
                provenance.get("architecture") != ARCHITECTURE or
                provenance.get("inter_task_network") != NETWORK):
            return "—"
        result = next((row for row in frozen.get("rows", []) if
                       row.get("workload") == workload and row.get("stage") == stage), None)
    if not result or result.get("numeric") != "pass" or result.get("trace") != "pass":
        return "—"
    return cycles(result.get("actual_stage_cycles"))


def cohort_stage_order(cohort: str) -> tuple[str, ...]:
    documents = []
    frozen = frozen_final_results(cohort)
    if frozen:
        documents.append(frozen)
    for workload in WORKLOADS:
        for stage in (*STAGES, "shape-only"):
            result = read_json(ROOT / "results" / cohort / workload / stage / "result.json")
            if result is None:
                continue
            documents.append(result)
            protocol_value = result.get("protocol")
            if isinstance(protocol_value, str):
                protocol = read_json(Path(protocol_value))
                if protocol:
                    documents.append(protocol)
    historical_names = {name for pair in HISTORICAL_COHORTS.values() for name in pair}
    if cohort in set(HISTORICAL_COHORTS["v58"]):
        return STAGES
    has_recorded_order = any(
        any(key in document for key in ("stage_order", "stages", "stage_scheme"))
        for document in documents
    )
    if cohort in historical_names | {"neighborhood-v19"} and not has_recorded_order:
        return LEGACY_STAGES
    observed = [stage for stage in (*STAGES, "shape-only")
                if any((ROOT / "results" / cohort / workload / stage / "result.json").is_file()
                       for workload in WORKLOADS)]
    try:
        return resolve_stage_order(*documents, observed_stages=observed)
    except ValueError:
        if cohort in historical_names | {"neighborhood-v19"}:
            return LEGACY_STAGES
        return STAGES


def all_unit_cycles(rows: dict, workload: str, cohort: str = DEFAULT_COHORT) -> str:
    if cohort == DEFAULT_COHORT:
        result = read_json(ROOT / "results" / SHARED_BASELINE_COHORT / workload / "result.json")
        bound = shared_protocol(cohort)
        if not result or bound is None:
            return "—"
        protocol, protocol_path, contract_path = bound
        network = (ROOT / NETWORK).resolve()
        if (result.get("status") != "complete" or
                result.get("scheduler") != SHARED_SCHEDULER or
                artifact_path(result.get("protocol")) != protocol_path or
                artifact_path(result.get("source_contract")) != contract_path or
                artifact_path(result.get("architecture")) != (ROOT / ARCHITECTURE).resolve() or
                not isinstance(result.get("optimizer"), str) or
                not Path(result["optimizer"]).is_file() or
                Path(result["optimizer"]).name != Path(str(protocol.get("optimizer_pin"))).name or
                artifact_path(result.get("inter_task_network")) != network or
                result.get("inter_task_network_text") != network.read_text() or
                any(result.get(key) != "pass" for key in
                    ("mapper_equality", "numeric", "independent_trace"))):
            return "—"
        native_argv = ((result.get("commands") or {}).get("native") or {}).get("argv", [])
        if (not isinstance(native_argv, list) or
                not any(isinstance(item, str) and "dispatch-policy=critical-path" in item
                        for item in native_argv) or
                f"--joint-inter-task-network-spec={network}" not in native_argv):
            return "—"
        return cycles(result.get("baseline_cycles"))
    result = rows.get(workload)
    if not result or any(result.get(key) != "pass" for key in
                         ("mapper_equality", "numeric", "independent_trace")):
        return "—"
    return cycles(result.get("baseline_cycles"))


def amoeba_cycles(workload: str, cohort: str = DEFAULT_COHORT) -> str:
    shared = cohort == DEFAULT_COHORT
    result_root = (SHARED_AMOEBA_COHORT if shared else "input0-amoeba-full-2x2-direct")
    result = read_json(ROOT / "results" / result_root / workload / "result.json")
    if result is None and not shared:
        frozen = read_json(ROOT / "reference/input0-neighborhood/evidence/2x2-original-amoeba-baselines.json") or {}
        result = next((row for row in frozen.get("rows", []) if row.get("workload") == workload), None)
    if not result or result.get("status") != "complete":
        return "—"
    if result.get("input_index") != 0 or result.get("input_id") != "input0":
        return "—"
    if result.get("model_namespace") != MODEL_NAMESPACE:
        return "—"
    if result.get("architecture") != ARCHITECTURE or result.get("inter_task_network") != NETWORK:
        return "—"
    if any(result.get(key) != "pass" for key in
           ("mapper_equality", "numeric", "independent_trace")):
        return "—"
    if shared:
        decisions = result.get("preserved_original_decisions") or {}
        policy = result.get("replica_timing_policy") or {}
        f45 = result.get("original_f45_scheduler") or {}
        trace_counts = result.get("trace_counts") or result.get("trace_result") or {}
        if not all(isinstance(value, dict) for value in (decisions, policy, f45, trace_counts)):
            return "—"
        amoeba_contract = read_json((ROOT / SHARED_SOURCE_CONTRACT).resolve()) or {}
        contract_model = (ROOT / "reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json").resolve()
        contract_replays = amoeba_contract.get("replay_payloads")
        runtime_optimizer = artifact_path(result.get("optimizer"))
        immutable_optimizer_pin = amoeba_contract.get("immutable_optimizer_pin")
        original_order = decisions.get("original_dispatch_order")
        production_order = decisions.get("production_dispatch_order")
        if (result.get("scheduler") != SHARED_SCHEDULER or
                result.get("shared_scheduler_resource_only") is not True or
                artifact_path(result.get("source_model_contract")) != (ROOT / SHARED_SOURCE_CONTRACT).resolve() or
                amoeba_contract.get("schema") != "orbit-neighborhood-exact-source-model-contract-v1" or
                amoeba_contract.get("model_namespace") != MODEL_NAMESPACE or
                not isinstance(amoeba_contract.get("model_payloads"), list) or
                not amoeba_contract["model_payloads"] or
                not isinstance(amoeba_contract["model_payloads"][0], dict) or
                amoeba_contract["model_payloads"][0].get("path") != "ensemble.json" or
                not contract_model.is_file() or
                amoeba_contract["model_payloads"][0].get("text") != contract_model.read_text() or
                not isinstance(immutable_optimizer_pin, str) or
                immutable_optimizer_pin.split("/")[-1] !=
                (runtime_optimizer.name if runtime_optimizer else None) or
                not isinstance(contract_replays, list) or
                not any(isinstance(item, dict) and item.get("path") == NETWORK and
                        item.get("text") == (ROOT / NETWORK).read_text()
                        for item in contract_replays) or
                decisions.get("status") != "pass" or
                decisions.get("scope") != "selected-shapes-counts-and-replicas-only" or
                decisions.get("placement_and_dispatch_preserved") is not False or
                type(decisions.get("task_count")) is not int or decisions["task_count"] <= 0 or
                decisions.get("task_count") != trace_counts.get("task_count") or
                not isinstance(original_order, list) or len(original_order) != decisions.get("task_count") or
                not isinstance(production_order, list) or len(production_order) != decisions.get("task_count") or
                any(not isinstance(item, str) for item in original_order) or
                any(not isinstance(item, str) for item in production_order) or
                len(set(original_order)) != len(original_order) or
                len(set(production_order)) != len(production_order) or
                set(original_order) != set(production_order) or
                f45.get("status") != "pass" or
                policy.get("schema") != "amoeba-original-f45-replica-scaling-v1" or
                policy.get("duration_formula") != "ceil(ceil(catalog_startup_cycles + compiled_ii * (source_macro_firings - 1)) / original_active_replicas)" or
                policy.get("child_mapper_profiles_used") is not False or
                policy.get("replica_duration_rule") != "ceil-full-parent-mapped-duration-over-original-active-replicas-v1" or
                policy.get("status") != "original-f45-scheduler-estimate"):
            return "—"
    return cycles(result.get("native_cycles"))


def progress_reason(progress: dict) -> str:
    reason = str(progress.get("reason") or progress.get("error") or "")
    if progress.get("status") in ("failed", "unsupported", "unsupported_unproven", "incomplete"):
        evidence = progress.get("evidence_root")
        step = progress.get("current_step") or progress.get("step")
        if isinstance(evidence, str) and isinstance(step, str) and re.fullmatch(r"[A-Za-z0-9_-]+", step):
            log = ROOT / evidence / f"{step}.stderr.log"
            try:
                log.resolve().relative_to(ROOT.resolve())
                with log.open(errors="replace") as stream:
                    consumed = 0
                    for line in stream:
                        consumed += len(line)
                        if "error:" in line:
                            reason = line.split("error:", 1)[1].strip()
                            break
                        if consumed > 1024 * 1024:
                            break
            except (OSError, ValueError):
                pass
    if "error:" in reason:
        reason = reason.split("error:", 1)[1].splitlines()[0]
    if any(token in reason for token in ("scheduler_start_time =", "replica_shapes =", "see current operation")):
        return "步骤未通过；完整诊断保留在该步骤的 stderr.log"
    return " ".join(reason.split())[:300]


def amoeba_progress(workload: str, cohort: str = DEFAULT_COHORT) -> str:
    """Keep task profiling separate from validated whole-program timing."""
    details = []
    amoeba_root = (SHARED_AMOEBA_COHORT if cohort == DEFAULT_COHORT
                   else "input0-amoeba-full-2x2-direct")
    result_dir = ROOT / "results" / amoeba_root / workload
    progress = read_json(result_dir / "progress.json")
    result = read_json(result_dir / "result.json") or {}
    profile = None
    profile_path = (result.get("fresh_mapper_profiles") or {}).get("path")
    if not profile_path and progress and isinstance(progress.get("profile_root"), str):
        profile_path = progress["profile_root"] + "/task-profiles.json"
    if isinstance(profile_path, str):
        candidate = ROOT / profile_path
        try:
            candidate.resolve().relative_to(ROOT.resolve())
            profile = read_json(candidate)
        except ValueError:
            pass
    if not profile and cohort != DEFAULT_COHORT:
        profile = (read_json(ROOT / f".work/post-publication/amoeba-input0-{workload}-2x2-v41-reprofile/task-profiles.json") or
                   read_json(ROOT / f".work/post-publication/amoeba-input0-{workload}-2x2-v40-reprofile/task-profiles.json"))
    if profile:
        done = profile.get("completed_candidate_count")
        total = profile.get("expected_candidate_count")
        if isinstance(done, int) and isinstance(total, int):
            details.append(f"task/shape mapper {done}/{total}")
    if not progress and cohort != DEFAULT_COHORT:
        progress = read_json(ROOT / f".work/post-publication/amoeba-input0-{workload}-2x2-v41-direct-baseline/progress.json")
    if not progress and cohort != DEFAULT_COHORT:
        progress = read_json(ROOT / f".work/post-publication/amoeba-input0-{workload}-2x2-v41-reprofile/progress.json")
    if amoeba_cycles(workload, cohort) != "—":
        details.append("整程序 cycles 已通过验证")
    elif progress:
        step = progress.get("current_step") or progress.get("step") or "整程序验证"
        status = progress.get("status") or "pending"
        details.append(f"当前步骤 {step} ({status})")
        reason = progress_reason(progress)
        if reason:
            details.append("原因：" + reason)
    else:
        details.append("整程序 cycles 尚未通过验证")
    if amoeba_cycles(workload, cohort) == "—" and cohort != DEFAULT_COHORT:
        retimer = read_json(ROOT / f".work/post-publication/amoeba-input0-{workload}-2x2-v41-direct-baseline/retimer-result.json")
        if retimer and retimer.get("cost_catalog_namespace") == MODEL_NAMESPACE:
            estimate = cycles(retimer.get("mapped_whole_program_cycles"))
            if estimate != "—":
                details.append(f"retimer 计时预估 {estimate} cycles（未通过完整验证）")
    return "；".join(details)


def ray_ii23_progress() -> str | None:
    directory = ROOT / "results/input0-amoeba-ii23-diagnostic/raytracing"
    result = read_json(directory / "result.json")
    progress = read_json(directory / "progress.json")
    if result is None and progress is None:
        result = read_json(ROOT / "reference/input0-neighborhood/evidence/2x2-ii23-ray-diagnostic.json")
    if not result and not progress:
        return None
    result = result or {}
    progress = progress or {}
    accepted = (
        result.get("status") == "complete"
        and result.get("input_index") == 0 and result.get("input_id") == "input0"
        and result.get("runtime_ii_ceiling") == 23
        and result.get("training_ii_ceiling") == 20
        and result.get("model_extrapolation") is True
        and result.get("formal_go") is False
        and result.get("model_namespace") == MODEL_NAMESPACE
        and result.get("architecture") == DIAGNOSTIC_ARCHITECTURE
        and result.get("inter_task_network") == NETWORK
        and all(result.get(key) == "pass" for key in ("mapper_equality", "numeric", "independent_trace"))
    )
    details = ["Ray II=23 补充（模型训练上限仍为20）：整程序 cycles="
               + (cycles(result.get("native_cycles")) if accepted else "—")]
    profiles = result.get("fresh_mapper_profiles") or progress.get("fresh_mapper_profiles") or {}
    done, total = profiles.get("completed"), profiles.get("expected")
    if type(done) is int and type(total) is int:
        details.append(f"mapper {done}/{total}")
    if not accepted:
        details.append("当前步骤 " + str(progress.get("current_step") or result.get("failed_step") or "整程序验证"))
        reason = progress_reason(progress) or str(result.get("reason") or "")
        if reason:
            details.append(reason[:300])
    return "；".join(details)


def shared_ray_ii23_progress() -> str | None:
    directory = ROOT / "results/input0-amoeba-ii23-v59-shared-scheduler-r3/raytracing"
    result = read_json(directory / "result.json")
    progress = read_json(directory / "progress.json")
    if result is None and progress is None:
        return None
    result = result or {}
    progress = progress or {}
    contract = read_json((ROOT / SHARED_SOURCE_CONTRACT).resolve()) or {}
    policy = result.get("replica_timing_policy") or {}
    decisions = result.get("preserved_original_decisions") or {}
    trace = result.get("trace_result") or result.get("trace_counts") or {}
    f45 = result.get("original_f45_scheduler") or {}
    if not all(isinstance(value, dict) for value in (policy, decisions, trace, f45)):
        policy, decisions, trace, f45 = {}, {}, {}, {}
    original_order = decisions.get("original_dispatch_order")
    production_order = decisions.get("production_dispatch_order")
    network = (ROOT / NETWORK).resolve()
    accepted = (
        result.get("status") == "complete" and
        result.get("input_index") == 0 and result.get("input_id") == "input0" and
        result.get("runtime_ii_ceiling") == 23 and result.get("training_ii_ceiling") == 20 and
        result.get("model_extrapolation") is True and result.get("formal_go") is False and
        result.get("model_namespace") == MODEL_NAMESPACE and
        result.get("architecture") == DIAGNOSTIC_ARCHITECTURE and
        result.get("inter_task_network") == NETWORK and
        result.get("scheduler") == SHARED_SCHEDULER and
        result.get("shared_scheduler_resource_only") is True and
        artifact_path(result.get("source_model_contract")) == (ROOT / SHARED_SOURCE_CONTRACT).resolve() and
        contract.get("schema") == "orbit-neighborhood-exact-source-model-contract-v1" and
        contract.get("model_namespace") == MODEL_NAMESPACE and
        isinstance(contract.get("replay_payloads"), list) and
        any(isinstance(item, dict) and item.get("path") == NETWORK and
            item.get("text") == network.read_text()
            for item in contract.get("replay_payloads", [])) and
        f45.get("status") == "pass" and
        policy.get("schema") == "amoeba-original-f45-replica-scaling-v1" and
        policy.get("duration_formula") == "ceil(ceil(catalog_startup_cycles + compiled_ii * (source_macro_firings - 1)) / original_active_replicas)" and
        policy.get("child_mapper_profiles_used") is False and
        policy.get("replica_duration_rule") == "ceil-full-parent-mapped-duration-over-original-active-replicas-v1" and
        policy.get("status") == "original-f45-scheduler-estimate" and
        decisions.get("status") == "pass" and
        decisions.get("scope") == "selected-shapes-counts-and-replicas-only" and
        decisions.get("placement_and_dispatch_preserved") is False and
        type(decisions.get("task_count")) is int and
        decisions.get("task_count") == trace.get("task_count") and
        isinstance(original_order, list) and len(original_order) == decisions.get("task_count") and
        isinstance(production_order, list) and len(production_order) == decisions.get("task_count") and
        all(isinstance(item, str) for item in original_order) and
        all(isinstance(item, str) for item in production_order) and
        len(set(original_order)) == len(original_order) and
        len(set(production_order)) == len(production_order) and
        set(original_order) == set(production_order) and
        all(result.get(key) == "pass" for key in
            ("mapper_equality", "numeric", "independent_trace")) and
        type(result.get("native_cycles")) is int and result["native_cycles"] > 0
    )
    label = "共享 ORBIT 调度 Ray II=23 补充（训练上限仍为20）：整程序 cycles="
    details = [label + (cycles(result.get("native_cycles")) if accepted else "—")]
    if not accepted:
        details.append("当前步骤 " + str(progress.get("current_step") or result.get("failed_step") or "整程序验证"))
        reason = progress_reason(progress) or str(result.get("reason") or "")
        if reason:
            details.append(reason[:300])
    return "；".join(details)


def print_orbit_progress(cohort: str, fission_cohort: str, stages: tuple[str, ...]) -> None:
    if cohort != DEFAULT_COHORT:
        return
    queue = read_json(ROOT / ".work/post-publication/paper-2x2-v59-shared-scheduler-r3-queue.json") or {}
    state = read_json(ROOT / ".work/post-publication/paper-2x2-v59-shared-scheduler-r3-cohort.json") or {}
    if queue or state:
        status = {"waiting-for-lanes": "等待旧任务释放计算核",
                  "running": "按队列运行", "complete": "全部完成",
                  "incomplete": "部分任务未完成"}.get(state.get("status"), "协调器已记录")
        dispatch = queue.get("dispatch_status", "状态未记录")
        print(f"ORBIT v59 四阶段进度：{dispatch}；{status}。")
    for workload in (*WORKLOADS[:-1], "raytracing-fission"):
        fission = workload == "raytracing-fission"
        actual = "raytracing" if fission else workload
        root = ROOT / "results" / (fission_cohort if fission else cohort)
        progress = read_json(root / "parallel" / actual / "progress.json") or {}
        batch = read_json(root / "parallel/batch.json") or {}
        records = progress.get("stages", {})
        finished = sum(records.get(stage, {}).get("status") in ("complete", "reused")
                       for stage in stages)
        failed = sum(records.get(stage, {}).get("status") == "failed" for stage in stages)
        running = (progress.get("status") == "running" or
                   batch.get("workloads", {}).get(actual, {}).get("status") == "running")
        current = next((i + 1 for i, stage in enumerate(stages)
                        if records.get(stage, {}).get("status") not in ("complete", "reused", "failed")), None)
        detail = "已完成" if finished == len(stages) else (
            f"运行中，当前 S{current}" if running and current is not None else
            "存在失败，见阶段日志" if failed else "已排队，等待计算核")
        print(f"  {workload}: {finished}/{len(stages)} 阶段通过；{detail}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    history = parser.add_mutually_exclusive_group()
    history.add_argument("--historical-v19", action="store_true", help="show archived five-stage v19 diagnostics")
    history.add_argument("--historical-v38", action="store_true", help="show archived five-stage v38 diagnostics")
    history.add_argument("--historical-v57", action="store_true", help="show archived five-stage v57 results")
    history.add_argument("--historical-v58", action="store_true", help="show superseded four-stage v58 diagnostics")
    history.add_argument("--historical-ray-ii23", action="store_true", help="show the older Ray II=23 diagnostic explicitly")
    parser.add_argument("--cohort", help="read a named results cohort")
    args = parser.parse_args()
    selected_history = next((version for version in ("v19", "v38", "v57", "v58", "ray_ii23")
                             if getattr(args, f"historical_{version}")), None)
    if selected_history and args.cohort:
        parser.error("--cohort cannot be combined with a historical cohort option")
    if selected_history:
        if selected_history == "ray_ii23":
            cohort = DEFAULT_COHORT
            fission_cohort = SHARED_RAY_FISSION_COHORT
        else:
            cohort, fission_cohort = HISTORICAL_COHORTS[selected_history]
    else:
        cohort = args.cohort or DEFAULT_COHORT
        fission_cohort = cohort.replace("input0-neighborhood", "input0-ray-fission")
    stage_order = cohort_stage_order(cohort)
    if cohort == DEFAULT_COHORT:
        print("v59 新四阶段独立实验：固定1x1、AMOEBA 保留形状/副本选择后重新调度、S1–S4 均使用同一 ORBIT 通信感知调度器与 critical-path dispatch。未通过验证的结果显示为 —。")
        print("新 AMOEBA 列要求原始 F45 形状/任务计数/副本证明、父任务 replica estimate、共同网络计时及共享调度器证据全部通过。")
    elif selected_history == "v38":
        print("历史 v38：保留原始 S1–S5 标签；该 cohort 使用前一阶段 winner 初始化。")
    elif selected_history == "v19":
        print("历史 v19：保留原始 S1–S5 标签；基线列留空，因为其硬件与当前 2×2-PE 基线不同。")
    elif selected_history == "v58":
        print("历史 v58：已由全新 v59 shared-scheduler cohort 取代；仅显示原始四阶段记录，不导入其结果或 checkpoint。")
    elif selected_history == "ray_ii23":
        print("主表仍显示 v59；仅下方 Ray II=23 行切换到显式指定的历史诊断。")
    else:
        print(f"历史/指定 cohort：保留其记录的原始 {len(stage_order)} 阶段顺序和 S1–S{len(stage_order)} 标签。")
    supplement = read_json(ROOT / "reference/input0-neighborhood/evidence/2x2-supplemental-baselines.json") or {}
    all_unit = supplement.get("all_unit") or {}
    rows = {row["workload"]: row for row in all_unit.get("rows", [])
            if isinstance(row, dict) and isinstance(row.get("workload"), str)}
    headings = ("程序", "固定1x1", "AMOEBA", *(f"S{i}" for i in range(1, len(stage_order) + 1)))
    print(" ".join(f"{name:>15}" for name in headings))
    for workload in WORKLOADS:
        ray_excluded = (workload == "raytracing" and
                        (cohort not in SHARED_PROTOCOLS or shared_model_domain_exclusion(cohort)))
        stage_values = (["超域"] * len(stage_order) if ray_excluded else
                        [orbit_cycles(workload, stage, cohort) for stage in stage_order])
        baseline_values = (("—", "—") if selected_history == "v19" else
                           (all_unit_cycles(rows, workload, cohort), amoeba_cycles(workload, cohort)))
        values = (workload, *baseline_values, *stage_values)
        print(" ".join(f"{value:>15}" for value in values))
    print("单位：整程序 native cycles；— 表示尚无通过验证的 cycles；主表保留 II≤20 配置，Ray 的 II=23 补充单列。")
    fission_order = cohort_stage_order(fission_cohort)
    fission = [orbit_cycles("raytracing", stage, fission_cohort) for stage in fission_order]
    print("Ray fission 补充：" + "；".join(f"S{i + 1}={value}" for i, value in enumerate(fission)))
    print_orbit_progress(cohort, fission_cohort, stage_order)
    print("ORBIT 与 AMOEBA 保留各自的 DFG 和候选空间；共同的是生产调度器、critical-path dispatch 与显式网络计时。")
    print("AMOEBA input-0 进度（mapper profile 数量不等于整程序 cycles）：")
    for workload in WORKLOADS:
        print(f"  {workload}: {amoeba_progress(workload, cohort)}")
    ray_diagnostic = (ray_ii23_progress() if selected_history == "ray_ii23" else
                      shared_ray_ii23_progress() if cohort == DEFAULT_COHORT else None)
    if ray_diagnostic:
        print(ray_diagnostic)


if __name__ == "__main__":
    main()
