#!/usr/bin/env python3
"""Render an evidence-aware comparison of full-program fusion/fission results.

Fresh stage cycles are read only from validated per-stage ``result.json`` files.
Missing or incomplete evidence is represented as null and is never plotted as 0.
The output directory must be separate from every measured result directory.
"""
from __future__ import annotations

import argparse
import json
import math
from pathlib import Path
from typing import Any, Dict, Iterable, List, Mapping, Optional, Sequence, Tuple


WORKLOADS = ("llama", "lu", "harris", "radar", "gcn", "raytracing")
STAGES = (
    ("S1", "shape-temporal"),
    ("S2", "shape-temporal-replica"),
    ("S3", "shape-temporal-replica-tiling"),
    ("S4", "full-joint"),
    ("S5", "full-joint-fission"),
)
STAGE_IDS = dict(STAGES)
STAGE_IDS_REVERSE = {value: key for key, value in STAGES}
SCHEMA = "orbit-fusion-fission-full-program-comparison-v1"
COMMON_SCHEMA = "orbit-common-dfg-amoeba-accepted-summary-v1"
HISTORICAL_SCHEMA = "orbit-input0-memory-fusion-fission-r9-frozen-summary-v1"
HISTORICAL_RECEIPTS_SCHEMA = "orbit-input0-memory-fusion-fission-r9-stage-receipts-v1"
STAGE_RESULT_SCHEMA = "orbit-neighborhood-stage-result-v1"


class ComparisonError(ValueError):
    """Raised when an input cannot be safely interpreted as comparison data."""


def _read_json(path: Path, label: str) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
        raise ComparisonError(f"cannot read {label} JSON at {path}: {error}") from error


def _positive_cycles(value: Any) -> Optional[int]:
    if isinstance(value, int) and not isinstance(value, bool) and value > 0:
        return value
    return None


def _source_ref(path: Path) -> Dict[str, str]:
    return {"path_as_recorded": str(path), "basename": path.name,
            "path_role": "capture provenance; not a portable binding"}


def _gates_pass(row: Mapping[str, Any], keys: Sequence[str]) -> bool:
    gates = row.get("gates")
    return isinstance(gates, dict) and all(gates.get(key) == "pass" for key in keys)


def _ray_domain_exclusion(row: Mapping[str, Any], summary_path: Path) -> Dict[str, Any]:
    recorded = row.get("domain_admission")
    if not isinstance(recorded, str) or not recorded:
        return {"valid": False, "reason": "domain-admission-reference-missing"}
    path = Path(recorded)
    if not path.is_absolute():
        path = summary_path.parent / path
    try:
        admission = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeDecodeError, json.JSONDecodeError):
        return {"valid": False, "reason": "domain-admission-record-unavailable",
                "path_as_recorded": str(path)}
    proof = admission.get("canonical_source_proof") if isinstance(admission, dict) else None
    blocking = admission.get("blocking_rows") if isinstance(admission, dict) else None
    task13 = [entry for entry in blocking if isinstance(entry, dict) and
              entry.get("task") == "Task_13"] if isinstance(blocking, list) else []
    facts = task13[0] if len(task13) == 1 else {}
    lower_bound = facts.get("analytical_lower_bound")
    runtime_ceiling = facts.get("runtime_ceiling_ii")
    valid = (
        isinstance(admission, dict) and
        admission.get("schema") == "orbit-input0-all-unit-model-domain-admission-v1" and
        admission.get("workload") == "raytracing" and
        admission.get("status") == "unsupported-model-domain" and
        admission.get("mapper_invoked") is False and
        admission.get("canonical_module_witness_matches_input") is True and
        isinstance(proof, dict) and
        proof.get("canonical_matches_native_recreation_after_path_rebase") is True and
        proof.get("mapper_invoked") is False and
        len(task13) == 1 and facts.get("status") == "unsupported-model-domain" and
        facts.get("support_status") == "unsupported" and
        isinstance(lower_bound, int) and not isinstance(lower_bound, bool) and
        isinstance(runtime_ceiling, int) and not isinstance(runtime_ceiling, bool) and
        lower_bound > runtime_ceiling and
        admission.get("runtime_ii_ceiling") == runtime_ceiling
    )
    return {
        "valid": valid,
        "reason": None if valid else "domain-admission-proof-incomplete-or-inconsistent",
        "path_as_recorded": str(path),
        "task": facts.get("task"),
        "analytical_lower_bound": lower_bound,
        "runtime_ceiling_ii": runtime_ceiling,
        "mapper_invoked": admission.get("mapper_invoked") if isinstance(admission, dict) else None,
    }


def _fixed1x1(path: Path) -> Tuple[Dict[str, Dict[str, Any]], Dict[str, Any]]:
    data = _read_json(path, "fixed1x1 summary")
    if not isinstance(data, list):
        raise ComparisonError("fixed1x1 summary must be the runner's workload-result list")
    rows: Dict[str, Mapping[str, Any]] = {}
    for row in data:
        if not isinstance(row, dict) or row.get("workload") not in WORKLOADS:
            raise ComparisonError("fixed1x1 summary contains an unknown or malformed workload row")
        workload = row["workload"]
        if workload in rows:
            raise ComparisonError(f"fixed1x1 summary repeats workload {workload}")
        rows[workload] = row

    result: Dict[str, Dict[str, Any]] = {}
    for workload in WORKLOADS:
        row = rows.get(workload)
        if row is None:
            result[workload] = {"status": "pending", "cycles": None,
                                "reason": "missing-summary-row"}
            continue
        cycles = _positive_cycles(row.get("baseline_cycles"))
        status = row.get("status")
        domain_exclusion = _ray_domain_exclusion(row, path) if workload == "raytracing" else None
        if (workload == "raytracing" and status == "unsupported-model-domain" and
                cycles is None and row.get("actual_cycles_claim") == "none" and
                row.get("mapper_equality") == "not-run" and
                row.get("numeric") == "not-run" and
                row.get("independent_trace") == "not-run" and domain_exclusion["valid"]):
            normalized_status = "not_applicable"
            reason = "compiler-proved-model-domain-exclusion"
        elif (status == "complete" and cycles is not None and
              row.get("mapper_equality") == "pass" and row.get("numeric") == "pass" and
              row.get("independent_trace") == "pass"):
            normalized_status = "complete"
            reason = None
        else:
            normalized_status = "incomplete"
            reason = (domain_exclusion.get("reason") if workload == "raytracing" and
                      status == "unsupported-model-domain" else None) or \
                     "baseline-gates-or-cycle-value-incomplete"
            cycles = None
        result[workload] = {
            "status": normalized_status,
            "source_status": status,
            "cycles": cycles,
            "reason": reason,
            "domain_admission_path_as_recorded": domain_exclusion.get("path_as_recorded")
                if domain_exclusion else None,
            "domain_admission_validation": domain_exclusion,
            "protocol_path_as_recorded": row.get("protocol"),
            "source_contract_path_as_recorded": row.get("source_contract"),
            "architecture_path_as_recorded": row.get("architecture"),
        }
    metadata = {
        "summary": _source_ref(path),
        "row_count": len(rows),
        "missing_workloads": [workload for workload in WORKLOADS if workload not in rows],
    }
    return result, metadata


def _common_amoeba(path: Path) -> Tuple[Dict[str, Dict[str, Any]], Dict[str, Any]]:
    data = _read_json(path, "common AMOEBA summary")
    if (not isinstance(data, dict) or data.get("schema") != COMMON_SCHEMA or
            data.get("input_index") != 0):
        raise ComparisonError("common AMOEBA input must be the accepted input-0 common-DFG summary")
    rows_value = data.get("rows")
    if not isinstance(rows_value, list):
        raise ComparisonError("common AMOEBA summary has no row list")
    rows: Dict[str, Mapping[str, Any]] = {}
    for row in rows_value:
        if not isinstance(row, dict) or row.get("workload") not in WORKLOADS:
            raise ComparisonError("common AMOEBA summary contains an unknown or malformed workload")
        workload = row["workload"]
        if workload in rows:
            raise ComparisonError(f"common AMOEBA summary repeats workload {workload}")
        rows[workload] = row

    result: Dict[str, Dict[str, Any]] = {}
    for workload in WORKLOADS:
        row = rows.get(workload)
        if row is None:
            result[workload] = {"status": "pending", "cycles": None,
                                "reason": "no-common-dfg-record"}
            continue
        cycles = _positive_cycles(row.get("common_amoeba_native_cycles"))
        if (data.get("status") == "complete" and cycles is not None and
                _gates_pass(row, ("mapper", "trace", "numeric"))):
            status = "complete"
            reason = None
        else:
            status = "incomplete"
            reason = "common-amoeba-gates-or-cycle-value-incomplete"
            cycles = None
        result[workload] = {
            "status": status,
            "cycles": cycles,
            "reason": reason,
            "gates": row.get("gates"),
            "result_path_as_recorded": row.get("result") if isinstance(row.get("result"), str) else None,
        }
    metadata = {
        "summary": _source_ref(path),
        "source_schema": data.get("schema"),
        "source_status": data.get("status"),
        "input_index": data.get("input_index"),
        "allocation_policy": data.get("allocation_policy"),
        "row_count": len(rows),
        "raytracing_status": result["raytracing"]["status"],
    }
    return result, metadata


def _common_ray_result(path: Optional[Path], common: Dict[str, Dict[str, Any]]) -> Dict[str, Any]:
    if path is None:
        return {"status": "pending", "cycles": None,
                "reason": "common-amoeba-ray-record-not-provided"}
    data = _read_json(path, "common AMOEBA Ray result")
    row: Optional[Mapping[str, Any]] = None
    if isinstance(data, dict) and isinstance(data.get("rows"), list):
        matches = [item for item in data["rows"]
                   if isinstance(item, dict) and item.get("workload") == "raytracing"]
        if len(matches) == 1:
            row = matches[0]
    elif isinstance(data, dict) and data.get("workload") == "raytracing":
        row = data
    if row is None:
        return {"status": "incomplete", "cycles": None,
                "reason": "common-amoeba-ray-record-has-no-unique-ray-row",
                "source": _source_ref(path)}

    cycles = None
    for key in ("common_amoeba_native_cycles", "native_cycles", "actual_stage_cycles", "cycles"):
        cycles = _positive_cycles(row.get(key))
        if cycles is not None:
            break
    gates = row.get("gates")
    gates_ok = _gates_pass(row, ("mapper", "trace", "numeric")) if isinstance(gates, dict) else (
        row.get("status") in ("complete", "native_replayed") and
        row.get("mapper_equality", row.get("mapper")) == "pass" and
        row.get("trace", row.get("independent_trace")) == "pass" and
        row.get("numeric") == "pass")
    if cycles is not None and gates_ok:
        common["raytracing"] = {"status": "complete", "cycles": cycles,
                                "reason": None, "source": _source_ref(path)}
        return common["raytracing"]
    common["raytracing"] = {"status": "incomplete", "cycles": None,
                            "reason": "common-amoeba-ray-gates-or-cycle-value-incomplete",
                            "source": _source_ref(path), "source_status": row.get("status")}
    return common["raytracing"]


def _historical_r9(summary_path: Path, receipts_path: Path) -> Tuple[
        Dict[str, Dict[str, Dict[str, Any]]], Dict[str, Any]]:
    summary = _read_json(summary_path, "historical R9 summary")
    receipts = _read_json(receipts_path, "historical R9 stage receipts")
    if (not isinstance(summary, dict) or summary.get("schema") != HISTORICAL_SCHEMA or
            summary.get("input_index") != 0):
        raise ComparisonError("historical source is not the public R9 input-0 summary")
    if (not isinstance(receipts, dict) or receipts.get("schema") != HISTORICAL_RECEIPTS_SCHEMA or
            not isinstance(receipts.get("records"), list)):
        raise ComparisonError("historical source is not the public R9 stage-receipts document")
    rows_value = summary.get("rows")
    if not isinstance(rows_value, list):
        raise ComparisonError("historical R9 summary has no workload rows")
    summary_rows: Dict[str, Mapping[str, Any]] = {}
    for row in rows_value:
        if not isinstance(row, dict) or row.get("workload") not in WORKLOADS:
            raise ComparisonError("historical R9 summary contains a malformed workload row")
        if row["workload"] in summary_rows:
            raise ComparisonError(f"historical R9 summary repeats workload {row['workload']}")
        summary_rows[row["workload"]] = row

    receipt_rows: Dict[Tuple[str, str], Mapping[str, Any]] = {}
    for row in receipts["records"]:
        if not isinstance(row, dict):
            raise ComparisonError("historical R9 receipts contain a malformed record")
        workload, stage_name = row.get("workload"), row.get("stage")
        stage = STAGE_IDS_REVERSE.get(stage_name)
        if workload not in WORKLOADS or stage is None:
            raise ComparisonError("historical R9 receipt has an unknown workload or stage")
        key = (workload, stage)
        if key in receipt_rows:
            raise ComparisonError(f"historical R9 receipt repeats {workload}/{stage}")
        receipt_rows[key] = row

    normalized: Dict[str, Dict[str, Dict[str, Any]]] = {}
    for workload in WORKLOADS:
        summary_row = summary_rows.get(workload)
        stage_values = summary_row.get("stages") if summary_row else None
        normalized[workload] = {}
        for stage, _ in STAGES:
            receipt = receipt_rows.get((workload, stage))
            if receipt is None:
                normalized[workload][stage] = {"status": "incomplete", "cycles": None,
                                               "reason": "historical-stage-receipt-missing"}
                continue
            cycles = _positive_cycles(receipt.get("cycles"))
            gates_ok = (receipt.get("status") == "native_replayed" and
                        receipt.get("native_top5_status") == "native_replayed" and
                        receipt.get("numeric") == "pass" and receipt.get("trace") == "pass" and
                        receipt.get("stage_initialization") == "independent")
            summary_cycles = _positive_cycles(stage_values.get(stage)) if isinstance(stage_values, dict) else None
            if gates_ok and cycles is not None and summary_cycles == cycles:
                status = "complete"
                reason = None
            else:
                status = "incomplete"
                reason = "historical-receipt-or-public-summary-validation-failed"
                cycles = None
            normalized[workload][stage] = {
                "status": status,
                "cycles": cycles,
                "reason": reason,
                "source_status": receipt.get("status"),
                "actual_stage_cycle_source": receipt.get("actual_stage_cycle_source"),
                "stage_initialization": receipt.get("stage_initialization"),
                "protocol_path_as_recorded": receipt.get("source_binding", {}).get("protocol")
                    if isinstance(receipt.get("source_binding"), dict) else None,
                "source_binding_paths_are_capture_provenance": True,
            }
    expected_records = len(WORKLOADS) * len(STAGES)
    complete_records = sum(row[stage]["status"] == "complete"
                           for row in normalized.values() for stage, _ in STAGES)
    metadata = {
        "summary": _source_ref(summary_path),
        "stage_receipts": _source_ref(receipts_path),
        "source_schema": summary.get("schema"),
        "source_status": summary.get("status"),
        "run_revision": summary.get("run_revision"),
        "stage_order": summary.get("stage_order"),
        "formal_go": summary.get("formal_go"),
        "raw_runtime_paths_are_capture_provenance": summary.get("raw_runtime_paths_are_capture_provenance"),
        "expected_stage_records": expected_records,
        "validated_stage_records": complete_records,
        "status": "complete" if complete_records == expected_records else "incomplete",
    }
    return normalized, metadata


def _stage_binding_evidence(result: Mapping[str, Any], result_path: Path) -> Tuple[bool, Optional[str], Optional[str]]:
    value = result.get("source_binding")
    if not isinstance(value, str) or not value:
        return False, None, "source-binding-path-missing"
    path = Path(value)
    if not path.is_absolute():
        path = result_path.parent / path
    expected = result_path.parent / "source-binding.json"
    if path.resolve() != expected.resolve() or not path.is_file():
        return False, str(path), "source-binding-file-missing-or-mismatched"
    try:
        binding = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeDecodeError, json.JSONDecodeError):
        return False, str(path), "source-binding-json-invalid"
    if (not isinstance(binding, dict) or
            binding.get("schema") != "orbit-neighborhood-source-binding-v1" or
            binding.get("stage_initialization") != "independent"):
        return False, str(path), "stage-not-proven-independent"
    for key in ("optimizer", "source_contract_file", "protocol", "architecture"):
        if not isinstance(binding.get(key), str) or not binding[key]:
            return False, str(path), "source-binding-lacks-required-pin-paths"
    if result.get("protocol") != binding.get("protocol"):
        return False, str(path), "result-protocol-differs-from-source-binding"
    return True, str(path), None


def _fresh_stage(root: Optional[Path], workload: str, stage: str) -> Dict[str, Any]:
    if root is None:
        return {"status": "pending", "cycles": None, "reason": "fresh-results-root-not-provided"}
    result_path = root / workload / STAGE_IDS[stage] / "result.json"
    if not result_path.is_file():
        return {"status": "pending", "cycles": None,
                "reason": "stage-result-json-missing",
                "result_path_as_recorded": str(result_path)}
    try:
        result = json.loads(result_path.read_text(encoding="utf-8"))
    except (OSError, UnicodeDecodeError, json.JSONDecodeError):
        return {"status": "incomplete", "cycles": None,
                "reason": "stage-result-json-invalid",
                "result_path_as_recorded": str(result_path)}
    if not isinstance(result, dict):
        return {"status": "incomplete", "cycles": None,
                "reason": "stage-result-json-not-an-object",
                "result_path_as_recorded": str(result_path)}

    source_status = result.get("status")
    identity_ok = (result.get("schema") == STAGE_RESULT_SCHEMA and
                   result.get("workload") == workload and result.get("stage") == STAGE_IDS[stage])
    binding_ok, binding_path, binding_reason = _stage_binding_evidence(result, result_path)
    cycles = _positive_cycles(result.get("actual_stage_cycles"))
    gates_ok = (source_status == "native_replayed" and
                result.get("numeric") == "pass" and result.get("trace") == "pass" and
                result.get("native_top5_status") == "native_replayed" and
                identity_ok and binding_ok and cycles is not None)
    if gates_ok:
        status, reason = "complete", None
    else:
        status, reason = "incomplete", binding_reason or "native-numeric-trace-or-cycle-gate-incomplete"
        # A cycle number attached to a failed or unbound result is deliberately withheld.
        cycles = None
    return {
        "status": status,
        "cycles": cycles,
        "reason": reason,
        "source_status": source_status,
        "source_numeric": result.get("numeric"),
        "source_trace": result.get("trace"),
        "native_top5_status": result.get("native_top5_status"),
        "stage_initialization": "independent" if binding_ok else None,
        "reported_stage_identity_matches_request": identity_ok,
        "result_path_as_recorded": str(result_path),
        "source_binding_path_as_recorded": binding_path,
        "protocol_path_as_recorded": result.get("protocol"),
        "optimizer_path_as_recorded": result.get("optimizer"),
        "source_contract_path_as_recorded": result.get("source_contract"),
        "evidence_paths_are_capture_provenance": True,
    }


def _summary_provenance(path: Optional[Path]) -> Optional[Dict[str, Any]]:
    if path is None:
        return None
    data = _read_json(path, "public fresh-stage summary")
    if not isinstance(data, dict):
        return {"summary": _source_ref(path), "role": "provenance-only",
                "cycle_values_consumed": False, "source_status": "malformed-summary"}
    allowed = ("schema", "status", "cohort_id", "run_revision", "input_index", "source_commit",
               "optimizer", "source_contract", "protocol", "architecture", "raw_runtime_root",
               "raw_runtime_paths_are_capture_provenance", "formal_go")
    fields = {key: data.get(key) for key in allowed
              if isinstance(data.get(key), (str, int, bool)) or data.get(key) is None}
    rows_out = []
    rows = data.get("rows")
    if isinstance(rows, list):
        for row in rows:
            if not isinstance(row, dict):
                continue
            rows_out.append({key: row.get(key) for key in (
                "workload", "status", "protocol", "optimizer", "source_contract", "result", "source_binding")
                if isinstance(row.get(key), (str, int, bool)) or row.get(key) is None})
    return {
        "summary": _source_ref(path),
        "role": "provenance-only",
        "cycle_values_consumed": False,
        "path_reuse_claim": False,
        "source_status": data.get("status"),
        "source_fields": fields,
        "row_evidence": rows_out,
    }


def _percent_reduction(reference: Mapping[str, Any], candidate: Mapping[str, Any]) -> Optional[float]:
    ref_cycles = reference.get("cycles")
    candidate_cycles = candidate.get("cycles")
    if (_positive_cycles(ref_cycles) is None or _positive_cycles(candidate_cycles) is None):
        return None
    return round((ref_cycles - candidate_cycles) * 100.0 / ref_cycles, 4)


def build_comparison(*, full_results_root: Optional[Path], fixed_summary: Path,
                     common_summary: Path, historical_summary: Path,
                     historical_receipts: Path, common_ray_result: Optional[Path] = None,
                     public_stage_summary: Optional[Path] = None) -> Dict[str, Any]:
    fixed, fixed_meta = _fixed1x1(fixed_summary)
    common, common_meta = _common_amoeba(common_summary)
    common_ray = _common_ray_result(common_ray_result, common)
    historical, historical_meta = _historical_r9(historical_summary, historical_receipts)
    fresh = {workload: {stage: _fresh_stage(full_results_root, workload, stage)
                        for stage, _ in STAGES} for workload in WORKLOADS}
    fresh_complete = sum(stage_row["status"] == "complete"
                         for rows in fresh.values() for stage_row in rows.values())
    fresh_present = sum(stage_row.get("result_path_as_recorded") is not None
                        for rows in fresh.values() for stage_row in rows.values())
    expected = len(WORKLOADS) * len(STAGES)
    if fresh_complete == expected:
        fresh_status = "complete"
    elif fresh_present == 0:
        fresh_status = "not-started"
    else:
        fresh_status = "incomplete"

    rows_out = []
    for workload in WORKLOADS:
        historical_stages = historical[workload]
        fresh_stages = fresh[workload]
        reductions = {
            stage: {
                "vs_common_amoeba_percent": _percent_reduction(common[workload], fresh_stages[stage]),
                "vs_fixed1x1_percent": _percent_reduction(fixed[workload], fresh_stages[stage]),
            }
            for stage, _ in STAGES
        }
        rows_out.append({
            "workload": workload,
            "fixed1x1": fixed[workload],
            "common_amoeba": common[workload],
            "historical_r9": historical_stages,
            "fresh_full": fresh_stages,
            "fresh_reductions_percent": reductions,
        })

    return {
        "schema": SCHEMA,
        "comparison_scope": "full-program scheduled cycle counts; lower is better",
        "fresh_cohort": {
            "status": fresh_status,
            "complete_stages": fresh_complete,
            "expected_stages": expected,
            "result_files_present": fresh_present,
            "cycles_from_incomplete_results_are_withheld": True,
            "full_results_root_as_recorded": str(full_results_root) if full_results_root else None,
        },
        "inputs": {
            "fixed1x1": fixed_meta,
            "common_amoeba": common_meta,
            "historical_r9": historical_meta,
            "full_results_root": _source_ref(full_results_root) if full_results_root else None,
            "public_stage_summary": _summary_provenance(public_stage_summary),
            "common_amoeba_ray_result": _source_ref(common_ray_result) if common_ray_result else None,
            "provenance_semantics": (
                "Recorded absolute protocol/source-binding/result paths identify the captured evidence only; "
                "they are not portable bindings or clean-clone commands."
            ),
        },
        "workloads": rows_out,
        "completion_policy": {
            "fresh_stage_requires": ["native_replayed", "native top5 replayed", "numeric pass",
                                     "independent trace pass", "independent initialization"],
            "missing_value": None,
            "zero_is_never_a_missing_or_incomplete_value": True,
            "raytracing_fixed1x1": "not_applicable only with the explicit compiler-proved domain-exclusion record",
            "raytracing_common_amoeba": "pending until a completed common-DFG Ray record is supplied",
        },
    }


def _cycles_text(record: Mapping[str, Any]) -> str:
    cycles = record.get("cycles")
    if _positive_cycles(cycles) is not None:
        return f"{cycles:,}"
    status = record.get("status")
    if status == "not_applicable":
        return "N/A (proved domain exclusion)"
    if status == "pending":
        return "pending"
    return "incomplete"


def comparison_markdown(data: Mapping[str, Any]) -> str:
    cohort = data["fresh_cohort"]
    lines = [
        "# Fusion/fission full-program comparison",
        "",
        f"Fresh six-program, five-stage cohort: **{cohort['status']}** "
        f"({cohort['complete_stages']}/{cohort['expected_stages']} stages passed all recorded gates).",
        "",
        "Cycles are whole-program scheduled cycles; lower is better. Fresh-stage values come from "
        "per-stage `result.json` records only when native top-five replay, numeric validation, "
        "independent trace, and independent stage initialization all pass. Missing and incomplete "
        "values are shown as pending/incomplete and never converted to zero.",
        "",
        "The fixed Ray unit baseline is N/A because the compiler-proved Task 13 model lower bound "
        "exceeds the diagnostic II ceiling. The common-DFG AMOEBA Ray value remains pending until "
        "its own record is supplied.",
        "",
        "| Workload | Fixed 1×1 | Common AMOEBA | R9 S1 | R9 S2 | R9 S3 | R9 S4 | R9 S5 | "
        "Fresh S1 | Fresh S2 | Fresh S3 | Fresh S4 | Fresh S5 |",
        "|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|",
    ]
    for row in data["workloads"]:
        cells = [row["workload"], _cycles_text(row["fixed1x1"]), _cycles_text(row["common_amoeba"])]
        cells.extend(_cycles_text(row["historical_r9"][stage]) for stage, _ in STAGES)
        cells.extend(_cycles_text(row["fresh_full"][stage]) for stage, _ in STAGES)
        lines.append("| " + " | ".join(cells) + " |")
    lines.extend([
        "",
        "## Evidence and limits",
        "",
        "The historical R9 stages are retained as a separate prior cohort. They are not substituted "
        "for the fresh S1–S5 measurements. No values are combined across different DFGs or search budgets.",
        "",
        "Recorded absolute paths in result and source-binding records are provenance pointers for the "
        "captured run. They are not portable source bindings. Re-run with the current protocol, source "
        "contract, optimizer pin, and result root to reproduce measurements in another checkout.",
        "",
        "For the detailed source-fix status, controlled memory-operation probes, and reproduction command, "
        "see `docs/FUSION_FISSION_RESULTS_20261007.md`.",
        "",
    ])
    return "\n".join(lines)


def _plot_rows(data: Mapping[str, Any], output: Path) -> Dict[str, Any]:
    try:
        import matplotlib
        matplotlib.use("Agg")
        import matplotlib.pyplot as plt
    except ImportError:
        _write_minimal_svg(data, output.with_suffix(".svg"))
        return {"svg": str(output.with_suffix(".svg")), "png": None,
                "renderer": "dependency-free-standalone-svg", "png_status": "matplotlib-unavailable"}

    labels = ["Fixed 1x1", "Common AMOEBA"] + [f"R9 {stage}" for stage, _ in STAGES] + \
        [f"Fresh {stage}" for stage, _ in STAGES]
    colors = ["#5b6573", "#8a929e"] + ["#3976a8"] * len(STAGES) + ["#e47a2e"] * len(STAGES)
    fig, axes = plt.subplots(3, 2, figsize=(16, 14), constrained_layout=True)
    axes_flat = list(axes.flat)
    for axis, row in zip(axes_flat, data["workloads"]):
        records = [row["fixed1x1"], row["common_amoeba"]]
        records.extend(row["historical_r9"][stage] for stage, _ in STAGES)
        records.extend(row["fresh_full"][stage] for stage, _ in STAGES)
        values = [record.get("cycles") if _positive_cycles(record.get("cycles")) else None
                  for record in records]
        positive = [value for value in values if value is not None]
        if positive:
            left = min(positive) / 2.0
            right = max(positive) * 2.2
        else:
            left, right = 1.0, 10.0
        y_positions = list(range(len(labels)))
        for index, (value, record, color) in enumerate(zip(values, records, colors)):
            if value is not None:
                axis.barh(index, value, color=color, height=0.62)
                axis.text(value * 1.04, index, f"{value:,}", va="center", fontsize=7)
            else:
                annotation = "N/A" if record.get("status") == "not_applicable" else (
                    "pending" if record.get("status") == "pending" else "incomplete")
                axis.text(left * 1.08, index, annotation, va="center", fontsize=7,
                          color="#666666", fontstyle="italic")
        axis.set_xscale("log")
        axis.set_xlim(left, right)
        axis.set_yticks(y_positions)
        axis.set_yticklabels(labels)
        axis.invert_yaxis()
        axis.set_title(row["workload"], loc="left", fontweight="bold")
        axis.set_xlabel("full-program scheduled cycles (log scale)")
        axis.grid(axis="x", which="both", alpha=0.22)
    for axis in axes_flat[len(data["workloads"]):]:
        axis.axis("off")
    fig.suptitle("Input-0 fusion/fission comparison — missing stages remain explicit", fontsize=16)
    output.parent.mkdir(parents=True, exist_ok=True)
    svg_path, png_path = output.with_suffix(".svg"), output.with_suffix(".png")
    fig.savefig(svg_path, format="svg", metadata={"Title": "Input-0 fusion/fission full-program comparison"})
    fig.savefig(png_path, format="png", dpi=180)
    plt.close(fig)
    return {"svg": str(svg_path), "png": str(png_path), "renderer": "matplotlib-standalone"}


def _write_minimal_svg(data: Mapping[str, Any], path: Path) -> None:
    """Write a dependency-free SVG fallback with values/statuses in its labels."""
    width, row_height = 1200, 38
    top, left, label_width = 100, 40, 180
    chart_width = 940
    height = top + len(WORKLOADS) * row_height + 80
    rows = {row["workload"]: row for row in data["workloads"]}
    all_values = [record.get("cycles")
                  for row in data["workloads"]
                  for record in ([row["fixed1x1"], row["common_amoeba"]] +
                                 [row["historical_r9"][stage] for stage, _ in STAGES] +
                                 [row["fresh_full"][stage] for stage, _ in STAGES])
                  if _positive_cycles(record.get("cycles")) is not None]
    log_min = math.log10(min(all_values)) if all_values else 0.0
    log_max = math.log10(max(all_values)) if all_values else 1.0
    log_span = max(1e-12, log_max - log_min)
    fragments = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" '
        f'viewBox="0 0 {width} {height}">',
        '<rect width="100%" height="100%" fill="white"/>',
        '<text x="40" y="42" font-family="sans-serif" font-size="22">'
        'Input-0 fusion/fission comparison — incomplete values are not zero</text>',
        '<text x="40" y="70" font-family="sans-serif" font-size="14">'
        f"Fresh cohort: {data['fresh_cohort']['status']} "
        f"({data['fresh_cohort']['complete_stages']}/{data['fresh_cohort']['expected_stages']})</text>",
    ]
    labels = ["Fixed 1x1", "Common AMOEBA"] + [f"R9 {stage}" for stage, _ in STAGES] + \
        [f"Fresh {stage}" for stage, _ in STAGES]
    colors = ["#5b6573", "#8a929e"] + ["#3976a8"] * 5 + ["#e47a2e"] * 5
    for workload_index, workload in enumerate(WORKLOADS):
        row = rows[workload]
        y = top + workload_index * row_height
        fragments.append(f'<text x="{left}" y="{y+18}" font-family="sans-serif" font-size="14">{workload}</text>')
        records = [row["fixed1x1"], row["common_amoeba"]]
        records.extend(row["historical_r9"][stage] for stage, _ in STAGES)
        records.extend(row["fresh_full"][stage] for stage, _ in STAGES)
        for index, (label, record, color) in enumerate(zip(labels, records, colors)):
            x = left + label_width + index * (chart_width / len(labels))
            value = record.get("cycles")
            text = f"{value:,}" if _positive_cycles(value) else (
                "N/A" if record.get("status") == "not_applicable" else
                "pending" if record.get("status") == "pending" else "incomplete")
            if _positive_cycles(value):
                slot_width = chart_width / len(labels)
                bar_width = 6 + (math.log10(value) - log_min) / log_span * (slot_width - 8)
                fragments.append(f'<rect x="{x:.1f}" y="{y}" width="{bar_width:.1f}" height="14" fill="{color}"/>')
                fragments.append(f'<text x="{x:.1f}" y="{y+30}" font-family="sans-serif" font-size="8">{label}: {text}</text>')
            else:
                fragments.append(f'<text x="{x:.1f}" y="{y+30}" font-family="sans-serif" font-size="8" fill="#666">{label}: {text}</text>')
    fragments.append('</svg>')
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(fragments) + "\n", encoding="utf-8")


def _assert_output_separate(output: Path, input_roots: Iterable[Optional[Path]]) -> None:
    output_resolved = output.resolve()
    for root in input_roots:
        if root is None:
            continue
        source = root.resolve()
        if (output_resolved == source or source in output_resolved.parents or
                output_resolved in source.parents):
            raise ComparisonError(
                f"output directory must be separate from measured input roots: {source}")


def render(args: argparse.Namespace) -> Dict[str, Any]:
    full_root = args.full_results_root.resolve() if args.full_results_root else None
    output_root = args.output_root.resolve()
    _assert_output_separate(output_root, (
        full_root,
        args.fixed_summary.resolve().parent,
        args.common_amoeba_summary.resolve().parent,
        args.historical_summary.resolve().parent,
        args.historical_stage_receipts.resolve().parent,
        args.public_stage_summary.resolve().parent if args.public_stage_summary else None,
        args.common_amoeba_ray_result.resolve().parent if args.common_amoeba_ray_result else None,
    ))
    data = build_comparison(
        full_results_root=full_root,
        fixed_summary=args.fixed_summary,
        common_summary=args.common_amoeba_summary,
        historical_summary=args.historical_summary,
        historical_receipts=args.historical_stage_receipts,
        common_ray_result=args.common_amoeba_ray_result,
        public_stage_summary=args.public_stage_summary,
    )
    output_root.mkdir(parents=True, exist_ok=True)
    json_path = output_root / "comparison.json"
    markdown_path = output_root / "comparison.md"
    plot_path = output_root / "comparison.svg"
    json_path.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    markdown_path.write_text(comparison_markdown(data), encoding="utf-8")
    plot_outputs = _plot_rows(data, plot_path)
    return {"comparison_json": str(json_path), "comparison_markdown": str(markdown_path),
            "plot": plot_outputs, "fresh_cohort_status": data["fresh_cohort"]["status"],
            "complete_stages": data["fresh_cohort"]["complete_stages"],
            "expected_stages": data["fresh_cohort"]["expected_stages"]}


def main(argv: Optional[Sequence[str]] = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--full-results-root", type=Path,
                        help="fresh full six-workload result root; may be absent before the run starts")
    parser.add_argument("--fixed-summary", type=Path, required=True)
    parser.add_argument("--common-amoeba-summary", type=Path, required=True)
    parser.add_argument("--common-amoeba-ray-result", type=Path)
    parser.add_argument("--historical-summary", type=Path, required=True)
    parser.add_argument("--historical-stage-receipts", type=Path, required=True)
    parser.add_argument("--public-stage-summary", type=Path,
                        help="optional public summary used for provenance only, never as a cycle source")
    parser.add_argument("--output-root", type=Path, required=True,
                        help="standalone rendering output, outside all measured result roots")
    args = parser.parse_args(argv)
    try:
        result = render(args)
    except ComparisonError as error:
        parser.error(str(error))
    print(json.dumps(result, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
