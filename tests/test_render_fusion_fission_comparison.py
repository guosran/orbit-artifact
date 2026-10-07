"""Focused tests for incomplete-safe fusion/fission comparison rendering."""
from __future__ import annotations

import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

import render_fusion_fission_comparison as renderer


def write_json(path: Path, value: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2) + "\n", encoding="utf-8")


def fixture_inputs(tmp_path: Path):
    workloads = renderer.WORKLOADS
    stages = renderer.STAGES

    fixed_path = tmp_path / "measured/fixed/summary.json"
    fixed_rows = []
    admission_path = tmp_path / "measured/fixed/raytracing/model-domain-admission.json"
    write_json(admission_path, {
        "schema": "orbit-input0-all-unit-model-domain-admission-v1",
        "workload": "raytracing", "status": "unsupported-model-domain",
        "mapper_invoked": False, "runtime_ii_ceiling": 23,
        "canonical_module_witness_matches_input": True,
        "canonical_source_proof": {
            "canonical_matches_native_recreation_after_path_rebase": True,
            "mapper_invoked": False,
        },
        "blocking_rows": [{
            "task": "Task_13", "status": "unsupported-model-domain",
            "support_status": "unsupported", "analytical_lower_bound": 83,
            "runtime_ceiling_ii": 23,
        }],
    })
    for workload in workloads:
        if workload == "raytracing":
            fixed_rows.append({
                "workload": workload, "status": "unsupported-model-domain",
                "baseline_cycles": None, "actual_cycles_claim": "none",
                "mapper_equality": "not-run", "numeric": "not-run",
                "independent_trace": "not-run",
                "domain_admission": str(admission_path),
            })
        else:
            fixed_rows.append({
                "workload": workload, "status": "complete", "baseline_cycles": 1000,
                "mapper_equality": "pass", "numeric": "pass", "independent_trace": "pass",
            })
    write_json(fixed_path, fixed_rows)

    common_path = tmp_path / "measured/common/summary.json"
    common_rows = [{
        "workload": workload, "common_amoeba_native_cycles": 800,
        "gates": {"mapper": "pass", "trace": "pass", "numeric": "pass"},
        "result": "captured/common/result.json",
    } for workload in workloads if workload != "raytracing"]
    write_json(common_path, {
        "schema": renderer.COMMON_SCHEMA, "status": "complete", "input_index": 0,
        "allocation_policy": "unchanged original F45", "rows": common_rows,
    })

    historical_summary = tmp_path / "measured/r9/summary.json"
    historical_receipts = tmp_path / "measured/r9/stage-receipts.json"
    r9_rows = []
    receipts = []
    for workload in workloads:
        stage_values = {}
        for index, (stage, stage_dir) in enumerate(stages, start=1):
            cycles = 500 + index
            stage_values[stage] = cycles
            receipts.append({
                "workload": workload, "stage": stage_dir, "cycles": cycles,
                "status": "native_replayed", "numeric": "pass", "trace": "pass",
                "native_top5_status": "native_replayed", "stage_initialization": "independent",
                "source_binding": {"protocol": "captured/r9/protocol.json"},
            })
        r9_rows.append({
            "workload": workload, "fixed1x1_status": "complete",
            "fixed1x1_cycles": 1000, "common_amoeba_cycles": 800,
            "stages": stage_values,
        })
    write_json(historical_summary, {
        "schema": renderer.HISTORICAL_SCHEMA, "status": "complete", "input_index": 0,
        "run_revision": "r9-fixture", "stage_order": [stage for stage, _ in stages],
        "rows": r9_rows,
    })
    write_json(historical_receipts, {
        "schema": renderer.HISTORICAL_RECEIPTS_SCHEMA, "records": receipts,
    })

    full_root = tmp_path / "measured/fresh"
    complete_path = full_root / "llama" / renderer.STAGE_IDS["S1"]
    binding_path = complete_path / "source-binding.json"
    protocol = "captured/fresh/protocol.json"
    write_json(binding_path, {
        "schema": "orbit-neighborhood-source-binding-v1",
        "optimizer": "captured/pin/mlir-amoeba-opt",
        "source_contract_file": "captured/pin/source-contract.json",
        "protocol": protocol,
        "architecture": "captured/architecture.yaml",
        "stage_initialization": "independent",
    })
    write_json(complete_path / "result.json", {
        "schema": renderer.STAGE_RESULT_SCHEMA,
        "workload": "llama", "stage": renderer.STAGE_IDS["S1"],
        "status": "native_replayed", "actual_stage_cycles": 120,
        "numeric": "pass", "trace": "pass", "native_top5_status": "native_replayed",
        "source_binding": str(binding_path), "protocol": protocol,
    })
    incomplete_path = full_root / "llama" / renderer.STAGE_IDS["S2"]
    incomplete_binding = incomplete_path / "source-binding.json"
    write_json(incomplete_binding, {
        "schema": "orbit-neighborhood-source-binding-v1",
        "optimizer": "captured/pin/mlir-amoeba-opt",
        "source_contract_file": "captured/pin/source-contract.json",
        "protocol": protocol,
        "architecture": "captured/architecture.yaml",
        "stage_initialization": "independent",
    })
    write_json(incomplete_path / "result.json", {
        "schema": renderer.STAGE_RESULT_SCHEMA,
        "workload": "llama", "stage": renderer.STAGE_IDS["S2"],
        "status": "running", "actual_stage_cycles": 999,
        "numeric": "pending", "trace": "pending", "native_top5_status": "pending",
        "source_binding": str(incomplete_binding), "protocol": protocol,
    })

    public_summary = tmp_path / "measured/fresh-public-summary.json"
    write_json(public_summary, {
        "schema": "orbit-new-stage-public-summary-v1", "status": "incomplete",
        "cohort_id": "fresh-fixture", "protocol": protocol,
        "rows": [{"workload": "llama", "status": "incomplete", "stages": {"S1": 777}}],
    })
    return {
        "fixed": fixed_path,
        "common": common_path,
        "historical": historical_summary,
        "receipts": historical_receipts,
        "full": full_root,
        "public": public_summary,
    }


def test_comparison_keeps_incomplete_missing_and_ray_na_distinct(tmp_path):
    inputs = fixture_inputs(tmp_path)
    data = renderer.build_comparison(
        full_results_root=inputs["full"], fixed_summary=inputs["fixed"],
        common_summary=inputs["common"], historical_summary=inputs["historical"],
        historical_receipts=inputs["receipts"], public_stage_summary=inputs["public"],
    )

    by_workload = {row["workload"]: row for row in data["workloads"]}
    assert data["fresh_cohort"]["status"] == "incomplete"
    assert data["fresh_cohort"]["complete_stages"] == 1
    assert data["fresh_cohort"]["expected_stages"] == 30
    assert by_workload["llama"]["fresh_full"]["S1"]["cycles"] == 120
    assert by_workload["llama"]["fresh_full"]["S2"]["status"] == "incomplete"
    assert by_workload["llama"]["fresh_full"]["S2"]["cycles"] is None
    assert by_workload["lu"]["fresh_full"]["S1"]["status"] == "pending"
    assert by_workload["lu"]["fresh_full"]["S1"]["cycles"] is None
    assert by_workload["raytracing"]["fixed1x1"]["status"] == "not_applicable"
    assert by_workload["raytracing"]["fixed1x1"]["cycles"] is None
    assert by_workload["raytracing"]["fixed1x1"]["domain_admission_validation"]["valid"] is True
    assert by_workload["raytracing"]["fixed1x1"]["domain_admission_validation"]["analytical_lower_bound"] == 83
    assert by_workload["raytracing"]["common_amoeba"]["status"] == "pending"
    assert by_workload["raytracing"]["common_amoeba"]["cycles"] is None
    assert data["inputs"]["public_stage_summary"]["cycle_values_consumed"] is False
    assert data["inputs"]["public_stage_summary"]["row_evidence"][0].get("stages") is None
    assert all(stage["cycles"] != 0
               for row in by_workload.values()
               for stage in row["fresh_full"].values())

    markdown = renderer.comparison_markdown(data)
    assert "not-started" not in markdown
    assert "N/A (proved domain exclusion)" in markdown
    assert "pending" in markdown
    assert "120" in markdown


def test_complete_fresh_cohort_uses_all_thirty_gated_stage_records(tmp_path):
    inputs = fixture_inputs(tmp_path)
    for workload_index, workload in enumerate(renderer.WORKLOADS):
        for stage_index, (stage, stage_dir) in enumerate(renderer.STAGES):
            stage_root = inputs["full"] / workload / stage_dir
            binding_path = stage_root / "source-binding.json"
            protocol = f"captured/fresh/{workload}/{stage}/protocol.json"
            write_json(binding_path, {
                "schema": "orbit-neighborhood-source-binding-v1",
                "optimizer": "captured/pin/mlir-amoeba-opt",
                "source_contract_file": "captured/pin/source-contract.json",
                "protocol": protocol,
                "architecture": "captured/architecture.yaml",
                "stage_initialization": "independent",
            })
            write_json(stage_root / "result.json", {
                "schema": renderer.STAGE_RESULT_SCHEMA,
                "workload": workload, "stage": stage_dir,
                "status": "native_replayed",
                "actual_stage_cycles": 600 + workload_index * 10 + stage_index,
                "numeric": "pass", "trace": "pass",
                "native_top5_status": "native_replayed",
                "source_binding": str(binding_path), "protocol": protocol,
            })

    data = renderer.build_comparison(
        full_results_root=inputs["full"], fixed_summary=inputs["fixed"],
        common_summary=inputs["common"], historical_summary=inputs["historical"],
        historical_receipts=inputs["receipts"],
    )
    assert data["fresh_cohort"]["status"] == "complete"
    assert data["fresh_cohort"]["complete_stages"] == 30
    assert data["workloads"][0]["fresh_reductions_percent"]["S1"]["vs_common_amoeba_percent"] == 25.0


def test_render_writes_separate_json_markdown_and_standalone_plot(tmp_path):
    inputs = fixture_inputs(tmp_path)
    output = tmp_path / "rendered" / "comparison"
    args = renderer.argparse.Namespace(
        full_results_root=inputs["full"], fixed_summary=inputs["fixed"],
        common_amoeba_summary=inputs["common"], common_amoeba_ray_result=None,
        historical_summary=inputs["historical"], historical_stage_receipts=inputs["receipts"],
        public_stage_summary=inputs["public"], output_root=output,
    )
    result = renderer.render(args)
    assert Path(result["comparison_json"]).is_file()
    assert Path(result["comparison_markdown"]).is_file()
    svg_path = Path(result["plot"]["svg"])
    assert svg_path.is_file()
    svg = svg_path.read_text(encoding="utf-8")
    assert "<svg" in svg
    assert "<image" not in svg
    if result["plot"]["png"] is not None:
        assert Path(result["plot"]["png"]).is_file()
    assert output.resolve() not in inputs["full"].resolve().parents


def test_dependency_free_svg_uses_shared_logarithmic_value_scale(tmp_path):
    inputs = fixture_inputs(tmp_path)
    data = renderer.build_comparison(
        full_results_root=inputs["full"], fixed_summary=inputs["fixed"],
        common_summary=inputs["common"], historical_summary=inputs["historical"],
        historical_receipts=inputs["receipts"],
    )
    path = tmp_path / "fallback.svg"
    renderer._write_minimal_svg(data, path)
    svg = path.read_text(encoding="utf-8")
    widths = [float(width) for _, width in re.findall(
        r'<rect x="([0-9.]+)" y="100" width="([0-9.]+)"', svg)]
    assert len(widths) >= 2
    assert widths[0] > widths[1]  # Fixed 1x1 has 1,000 cycles; common has 800.


def test_output_inside_measurement_root_is_rejected(tmp_path):
    inputs = fixture_inputs(tmp_path)
    args = renderer.argparse.Namespace(
        full_results_root=inputs["full"], fixed_summary=inputs["fixed"],
        common_amoeba_summary=inputs["common"], common_amoeba_ray_result=None,
        historical_summary=inputs["historical"], historical_stage_receipts=inputs["receipts"],
        public_stage_summary=inputs["public"], output_root=inputs["full"] / "plot",
    )
    try:
        renderer.render(args)
    except renderer.ComparisonError as error:
        assert "separate from measured input roots" in str(error)
    else:
        raise AssertionError("renderer accepted an output nested in the measured result root")


def test_output_parent_of_measurement_root_is_rejected(tmp_path):
    inputs = fixture_inputs(tmp_path)
    args = renderer.argparse.Namespace(
        full_results_root=inputs["full"], fixed_summary=inputs["fixed"],
        common_amoeba_summary=inputs["common"], common_amoeba_ray_result=None,
        historical_summary=inputs["historical"], historical_stage_receipts=inputs["receipts"],
        public_stage_summary=None, output_root=tmp_path / "measured",
    )
    try:
        renderer.render(args)
    except renderer.ComparisonError as error:
        assert "separate from measured input roots" in str(error)
    else:
        raise AssertionError("renderer accepted an output directory containing measurements")


def test_ray_na_requires_compiler_domain_admission_proof(tmp_path):
    inputs = fixture_inputs(tmp_path)
    admission = tmp_path / "measured/fixed/raytracing/model-domain-admission.json"
    admission.unlink()
    fixed, _ = renderer._fixed1x1(inputs["fixed"])
    assert fixed["raytracing"]["status"] == "incomplete"
    assert fixed["raytracing"]["cycles"] is None
    assert fixed["raytracing"]["reason"] == "domain-admission-record-unavailable"
