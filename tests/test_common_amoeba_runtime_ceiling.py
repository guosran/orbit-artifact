"""Actual common mapper profiles obey the explicitly bound runtime ceiling."""
import copy
import json
from pathlib import Path
import subprocess
import sys

import pytest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
import validate_common_amoeba_retiming as common
import run_input0_memory_fusion_fission_queue as queue
import write_neighborhood_publication_command as command


def profiles(architecture, ii):
    task = {"task": "Task_0", "sample_trip_count": 3,
            "source_iteration_domain_certified": True,
            "source_iteration_domain_complete": True,
            "source_iteration_domain_status": "certified-complete",
            "source_iteration_work_count": 3}
    rows, attempts = [], []
    for index, shape in enumerate(common.SHAPES, 1):
        r, c = map(int, shape.split("x"))
        rows.append({**task, "composed_cgra_shape": shape,
                     "compiled_ii": ii, "structural_startup_cycles": 2,
                     "steps": 2, "materialized_operation_count": 1,
                     "estimated_latency": 2 + ii * 2,
                     "duration_formula": common.FORMULA,
                     "duration_provenance": common.PROFILE_PROVENANCE,
                     "mapper_succeeded": True, "composed_cgra_count": r * c,
                     "mapper_tile_rows": 2 * r, "mapper_tile_cols": 2 * c,
                     "pre_mapper_wrapper_bytes": "body",
                     "pre_mapper_wrapper_byte_count": 4})
        attempts.append({"task": "Task_0", "candidate_index_in_task": index,
                         "shape": shape, "mapper_succeeded": True,
                         "profile_created": True})
    return {"format": "amoeba-task-profile-v1",
            "profile_provenance": common.PROFILE_PROVENANCE,
            "duration_formula": common.FORMULA,
            "architecture_spec_text": architecture,
            "whole_program_scheduler_invoked": False,
            "source_iteration_domain_coverage_verified": True,
            "shape_domain": list(common.SHAPES),
            "hardware_coordinates": {"multi_cgra_grid_rows": 4,
                "multi_cgra_grid_cols": 4, "per_cgra_tile_rows": 2,
                "per_cgra_tile_cols": 2, "total_mapper_rows": 8,
                "total_mapper_cols": 8},
            "canonical_module_witness_bytes": "module",
            "canonical_module_witness_byte_count": 6,
            "canonical_function_witness_bytes": "function",
            "canonical_function_witness_byte_count": 8,
            "task_count": 1, "expected_candidate_count": 8,
            "completed_candidate_count": 8, "candidate_attempts": attempts,
            "tasks": [{**task, "profiles": rows}]}


def test_common_actual_profiles_require_exact_runtime_architecture_and_ii():
    training = (ROOT / "config/architectures/amoeba_4x4_cgra_2x2_context6.yaml").read_text()
    runtime = (ROOT / "config/architectures/amoeba_4x4_cgra_2x2_context6_ctrlmem23_diagnostic.yaml").read_text()
    common.validate_profile_inventory(profiles(training, 20), training)
    common.validate_profile_inventory(profiles(runtime, 23), runtime, 23)
    for text, ii, ceiling in ((training, 21, 20), (runtime, 24, 23)):
        with pytest.raises(ValueError, match="mapper II exceeds runtime ceiling"):
            common.validate_profile_inventory(profiles(text, ii), text, ceiling)
    with pytest.raises(ValueError, match="authorized control-memory"):
        common.validate_profile_inventory(profiles(runtime, 23), runtime)
    altered = runtime.replace("num_registers: 32", "num_registers: 31")
    assert altered != runtime
    with pytest.raises(ValueError, match="authorized control-memory"):
        common.validate_profile_inventory(profiles(altered, 23), altered, 23)


def test_fresh_queue_cohort_ids_cannot_alias_or_escape_revision():
    protocol = {"cohort_id": "input0-neighborhood-2x2-v61-funnel-20261007",
                "fixed1x1_cohort_id": "input0-all-unit-2x2-v61-funnel-20261007"}
    assert queue._cohort_ids(protocol) == tuple(protocol.values())
    for field, value in (("cohort_id", "input0-neighborhood-2x2-../R9"),
                         ("fixed1x1_cohort_id", queue.FIXED1X1_COHORT_ID)):
        bad = copy.deepcopy(protocol)
        bad[field] = value
        with pytest.raises(queue.QueueError):
            queue._cohort_ids(bad)


def test_original_ray_preparation_preserves_the_generic_fission_seam(tmp_path):
    output = tmp_path / "ray-source"
    argv = [sys.executable, str(ROOT / "scripts/prepare_input0_source_domains.py"),
            "--artifact-root", str(ROOT), "--optimizer", "/usr/bin/true",
            "--architecture", str(ROOT / "config/architectures/amoeba_4x4_cgra_2x2_context6_ctrlmem23_diagnostic.yaml"),
            "--model", str(ROOT / "reference/input0-neighborhood/models/per-cgra-2x2"),
            "--source-repository", "https://github.com/guosran/orbit.git",
            "--source-commit", "fresh-fixture-binding", "--cost-catalog",
            "--allow-unsupported-model-shapes", "--diagnostic-ii-ceiling", "23",
            "--emit-fission-source", "--workloads", "raytracing",
            "--output-root", str(output), "--dry-run"]
    result = subprocess.run(argv, text=True, capture_output=True)
    assert result.returncode == 0, result.stderr
    plan = json.loads((output / "raytracing/plan.json").read_text())
    assert plan["expected_task_count"] == 27
    assert "ray-fission" not in plan["steps"]
    prefix = plan["steps"]["prepare-fission-source"]
    suffix = plan["steps"]["normalize"]
    assert "--construct-hyperblock-from-task" in prefix
    assert "--convert-taskflow-to-neura" in suffix
    assert suffix[1] == prefix[-1]
    predictor = plan["steps"]["predict-cost-catalog"]
    assert any("diagnostic-ii-ceiling=23" in arg for arg in predictor)
    wrong = list(argv)
    wrong[wrong.index("--workloads") + 1] = "harris"
    wrong[wrong.index("--output-root") + 1] = str(tmp_path / "wrong")
    rejected = subprocess.run(wrong, text=True, capture_output=True)
    assert rejected.returncode != 0
    assert "only original Ray" in rejected.stderr


def test_five_stage_template_requires_prepared_source_for_all_six(tmp_path):
    protocol = json.loads((ROOT / "reference/input0-neighborhood/protocol-2x2-fusion-fission-funnel-template.json").read_text())
    command.validate_v19_protocol(protocol)
    config = {"schema": "orbit-amoeba-input0-neighborhood-chain-config-v1",
              "workloads": {w: {"canonical": f"{w}/canonical.mlir",
                "parent_cost_file": f"{w}/cost-catalog.json",
                "cost_cache": f"{w}/ml-cache.json",
                "prepared_source_file": f"{w}/pre-neura.mlir"}
                for w in command.WORKLOADS}}
    command.validate_chain_config(config, fission=True)
    del config["workloads"]["raytracing"]["prepared_source_file"]
    with pytest.raises(command.CommandError, match="prepared pre-Neura source"):
        command.validate_chain_config(config, fission=True)


def test_fresh_six_program_preparer_uses_ii23_only_for_original_ray(tmp_path):
    output = tmp_path / "six-source"
    result = subprocess.run([sys.executable,
        str(ROOT / "scripts/prepare_input0_neighborhood_reproduction.py"),
        "--artifact-root", str(ROOT), "--optimizer", "/usr/bin/true",
        "--architecture", str(ROOT / "config/architectures/amoeba_4x4_cgra_2x2_context6.yaml"),
        "--model-root", str(ROOT / "reference/input0-neighborhood/models/per-cgra-2x2"),
        "--source-repository", "https://github.com/guosran/orbit.git",
        "--source-commit", "fresh-fixture-binding", "--emit-fission-source",
        "--original-ray-diagnostic-ii23", "--output-root", str(output), "--dry-run"],
        text=True, capture_output=True)
    assert result.returncode == 0, result.stderr
    for name in command.WORKLOADS:
        plan = json.loads((output / name / "plan.json").read_text())
        predictor = plan["steps"]["predict-cost-catalog"]
        ceiling = 23 if name == "raytracing" else 20
        assert any(f"diagnostic-ii-ceiling={ceiling}" in arg for arg in predictor)
        assert "prepare-fission-source" in plan["steps"]
        if name == "raytracing":
            assert plan["expected_task_count"] == 27
            assert "ray-fission" not in plan["steps"]
    config = json.loads((output / "input0-chain.json").read_text())
    assert set(config["workloads"]) == set(command.WORKLOADS)


def test_five_stage_command_writer_binds_ray_override_without_changing_prepared_config(tmp_path, monkeypatch):
    import shutil
    artifact = tmp_path / "artifact"
    source = tmp_path / "source"
    source.mkdir()
    build = artifact / ".work/build"
    build.mkdir(parents=True)
    optimizer = build / "optimizer"
    optimizer.write_text("#!/bin/sh\nexit 0\n")
    optimizer.chmod(0o755)
    for relative in ("config/architectures", "config/networks",
                     "reference/input0-neighborhood/models/per-cgra-2x2"):
        shutil.copytree(ROOT / relative, artifact / relative)
    model = artifact / "reference/input0-neighborhood/models/per-cgra-2x2"
    ensemble = model / "ensemble.json"
    model_metadata = json.loads(ensemble.read_text())
    head = "a" * 40
    monkeypatch.setattr(command, "git_value", lambda root, *args: "" if args[0] == "status" else head)
    monkeypatch.setattr(command, "require_ancestor", lambda *args: None)
    prep = artifact / ".work/prepared"
    prep.mkdir()
    config = {"schema": "orbit-amoeba-input0-neighborhood-chain-config-v1",
              "defaults": {"model_cache": str(ensemble)},
              "workloads": {w: {"canonical": f"{w}/canonical.mlir",
                  "parent_cost_file": f"{w}/cost-catalog.json",
                  "cost_cache": f"{w}/ml-cache.json",
                  "prepared_source_file": f"{w}/pre-neura.mlir"} for w in command.WORKLOADS}}
    config_path = prep / "input0-chain.json"
    config_path.write_text(json.dumps(config))
    original_config = config_path.read_bytes()
    arch = artifact / "config/architectures/amoeba_4x4_cgra_2x2_context6.yaml"
    ray_arch = artifact / "config/architectures/amoeba_4x4_cgra_2x2_context6_ctrlmem23_diagnostic.yaml"
    (prep / "raytracing").mkdir()
    (prep / "raytracing/cost-catalog.json").write_text(json.dumps({"predictor_metadata": {
        "architecture_path": str(ray_arch), "diagnostic_override": {
            "runtime_ii_ceiling": 23, "training_ii_ceiling": 20,
            "runtime_architecture_exact_yaml_text": ray_arch.read_text(),
            "training_architecture_exact_yaml_text": arch.read_text()}}}))
    contract = prep / "contract.json"
    contract.write_text(json.dumps({"published_source_commit": head, "source_commit": head,
        "model_namespace": model_metadata["model_namespace"],
        "model_payloads": [{"path": "ensemble.json", "text": ensemble.read_text()}]}))
    template = artifact / "reference/input0-neighborhood/template.json"
    shutil.copy(ROOT / "reference/input0-neighborhood/protocol-2x2-fusion-fission-funnel-template.json", template)
    protocol = json.loads(template.read_text())
    bound = prep / "protocol-bound.json"
    command_file = prep / "command.json"
    assert command.main(["--artifact-root", str(artifact), "--source-root", str(source),
        "--build-root", str(build), "--source-base", head, "--source-variant", "v61-funnel",
        "--config", str(config_path), "--protocol-template", str(template),
        "--protocol-output", str(bound), "--source-contract-file", str(contract),
        "--optimizer", str(optimizer), "--architecture", str(arch), "--model-root", str(model),
        "--sram-config", str(artifact / "config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json"),
        "--inter-task-network", str(artifact / "config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml"),
        "--stage-scheme", "full-joint-fission", "--output-root",
        str(artifact / "results" / protocol["cohort_id"]), "--output", str(command_file)]) == 0
    assert config_path.read_bytes() == original_config
    main_protocol = json.loads(bound.read_text())
    ray_protocol = json.loads((prep / "protocol-bound-ray-ii23.json").read_text())
    assert main_protocol["stage_order"] == list(queue.STAGES)
    assert main_protocol["search"]["stage_initialization"] == "independent"
    assert ray_protocol["search"]["diagnostic_ii_ceiling"] == 23
    assert ray_protocol["training_ii_ceiling"] == 20
    runtime = json.loads((prep / "input0-chain-runtime-ii23.json").read_text())
    assert runtime["workloads"]["raytracing"]["protocol"] == "protocol-bound-ray-ii23.json"
    assert all("protocol" not in runtime["workloads"][w] for w in command.WORKLOADS if w != "raytracing")
    argv = json.loads(command_file.read_text())
    assert argv[argv.index("--config") + 1].endswith("input0-chain-runtime-ii23.json")


def test_embedded_path_validator_source_is_not_a_machine_binding():
    assert not command.contains_machine_local_path('forbidden = ("/home/", "/Users/")')
    for text in ('{"optimizer": "/home/user/build/optimizer"}',
                 '{"optimizer": "/Users/user/build/optimizer"}',
                 json.dumps({"optimizer": "C:\\Users\\user\\build\\optimizer"})):
        assert command.contains_machine_local_path(text)
