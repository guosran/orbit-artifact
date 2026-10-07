"""Fresh original-Ray source proof and model-domain admission tests."""
from __future__ import annotations

import json
from pathlib import Path
import sys
from types import SimpleNamespace

import pytest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

import prepare_input0_source_domains as source_domains
import run_input0_all_unit_baselines as all_unit


def write_json(path: Path, value: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


def write_jsonl(path: Path, rows) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("".join(json.dumps(row, sort_keys=True) + "\n" for row in rows))


def make_preparation(root: Path):
    config_base = root / ".work/fresh-ray-prep"
    ray_dir = config_base / "raytracing"
    ray_dir.mkdir(parents=True)
    canonical = ray_dir / "canonical.mlir"
    taskflow = ray_dir / "taskflow-affine.mlir"
    prepared = ray_dir / "pre-neura.mlir"
    taskflow.write_text('original taskflow source\n')
    canonical.write_text(f'"builtin.module"() ({{\n  // prepared-input={taskflow}\n}}) : () -> ()\n\n')
    prepared.write_text(f'prepared-input={taskflow}\n')
    top = {
        "schema": "orbit-input0-neighborhood-v19-preparation-v1",
        "status": "prepared",
        "source_domain_output": str(config_base),
        "workloads": ["llama", "lu", "gcn", "harris", "radar", "raytracing"],
        "runtime_ii_ceiling_by_workload": {"raytracing": 23},
        "training_ii_ceiling": 20,
        "ray_fission_split_at": 0,
    }
    write_json(config_base / "preparation.json", top)
    workload = {
        "workload": "raytracing",
        "function": source_domains.CONTRACTS["raytracing"]["function"],
        "status": "prepared",
        "canonical": str(canonical),
        "prepared_source_file": str(prepared),
        "ray_fission_split_at": 0,
        "runtime_ii_ceiling": 23,
        "training_ii_ceiling": 20,
        "complete_task_count": 27,
    }
    write_json(ray_dir / "preparation.json", workload)
    return config_base, canonical, prepared


def make_source_manifest(root: Path):
    source_root = root / "reference/input0-source-domains"
    source = source_root / "inputs/raytracing.mlir"
    caller = source_root / "callers/raytracing.mlir"
    source.parent.mkdir(parents=True)
    caller.parent.mkdir(parents=True)
    source.write_text("amoeba.static_bound.arg.0 = 1472 : i64\n")
    caller.write_text("caller evidence\n")
    function = source_domains.CONTRACTS["raytracing"]["function"]
    write_json(source_root / "manifest.json", {
        "schema": "orbit-input0-complete-affine-source-inputs-v1",
        "records": [{
            "workload": "raytracing",
            "input": "inputs/raytracing.mlir",
            "benchmark_source": "Evaluation/Raytracing/L3/raytracing.mlir",
            "fixed_input": 0,
            "static_scalar_argument": 0,
            "static_scalar_value": 1472,
            "source_contains_complete_affine_domains": True,
            "caller_evidence": "callers/raytracing.mlir",
            "specialization_pass": (
                "--bind-static-scalar-argument=function=" + function +
                " argument=0 value=1472"
            ),
        }],
    })
    return source, caller


def make_binding(tmp_path: Path):
    root = tmp_path / "artifact"
    root.mkdir()
    config_base, canonical, prepared = make_preparation(root)
    taskflow = canonical.parent / "taskflow-affine.mlir"
    source, caller = make_source_manifest(root)
    optimizer = root / ".work/pinned/mlir-amoeba-opt"
    optimizer.parent.mkdir(parents=True)
    optimizer.write_text("test optimizer pin\n")
    contract_path = root / ".work/source-contract.json"
    protocol_path = root / ".work/ray-protocol.json"
    ensemble_path = root / "reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json"
    ensemble_path.parent.mkdir(parents=True)
    model_source = {"repository": "https://example.invalid/predictor", "commit": "model-commit"}
    standard = root / "config/architectures/training.yaml"
    diagnostic = root / "config/architectures/runtime-23.yaml"
    standard.parent.mkdir(parents=True)
    standard.write_text("architecture: training-20\n")
    diagnostic.write_text("architecture: runtime-23\n")
    write_json(ensemble_path, {
        "schema": "orbit-cgra-ii-per-cgra-2x2-direct-ensemble-cpp-v1",
        "model_namespace": all_unit.DIRECT_MODEL_NAMESPACE,
        "source_model": model_source,
        "feature_contract": {
            "contract_id": "cgra-ii-pre-mapper-features-148-2x2-per-cgra-v1",
            "extractor": "cgra_ii_predictor.mapper_model:mapper_feature_vector",
        },
        "shape_protocol": {"protocol_id": "amoeba-static-rectangles-2x2-per-cgra-max4"},
        "architecture": {"exact_yaml_text": standard.read_text()},
        "members": [{"seed": seed} for seed in (17, 41, 113, 239)],
    })
    source_commit = "0123456789abcdef0123456789abcdef01234567"
    optimizer_pin = str(optimizer.resolve())
    replay_payloads = [
        {"path": "scripts/run_input0_all_unit_baselines.py",
         "text": Path(all_unit.__file__).read_text()},
        {"path": "scripts/prepare_input0_source_domains.py",
         "text": Path(source_domains.__file__).read_text()},
    ]
    write_json(contract_path, {
        "schema": "orbit-neighborhood-exact-source-model-contract-v1",
        "source_commit": source_commit,
        "published_source_commit": source_commit,
        "model_namespace": all_unit.DIRECT_MODEL_NAMESPACE,
        "immutable_optimizer_pin": optimizer_pin,
        "replay_payloads": replay_payloads,
        "model_payloads": [{"path": "ensemble.json", "text": ensemble_path.read_text()}],
    })
    protocol = {
        "model_namespace": all_unit.DIRECT_MODEL_NAMESPACE,
        "source_git_repository": all_unit.SOURCE_REPOSITORY,
        "source_commit": source_commit,
        "project_source_commit": source_commit,
        "optimizer_pin": optimizer_pin,
        "source_contract_file": str(contract_path.resolve()),
        "model_ensemble": str(ensemble_path.resolve()),
        "fixed1x1_domain_exclusion_policy": all_unit.DOMAIN_EXCLUSION_POLICY,
        "search": {"diagnostic_ii_ceiling": 23},
    }
    write_json(protocol_path, protocol)
    args = SimpleNamespace(
        output_root=root / "results/input0-all-unit-fresh-ray",
        optimizer=optimizer,
        architecture=diagnostic,
        source_contract_file=contract_path,
        protocol=protocol_path,
        inter_task_network=None,
        mapping_cache=root / ".work/mapping-cache",
        llvm_build=root / ".work/llvm-build",
        sram_config=root / "config/sram.json",
    )
    args.output_root.mkdir(parents=True)
    args.mapping_cache.mkdir(parents=True)
    return {
        "root": root,
        "config_base": config_base,
        "canonical": canonical,
        "taskflow": taskflow,
        "prepared": prepared,
        "source": source,
        "caller": caller,
        "standard": standard,
        "diagnostic": diagnostic,
        "contract_path": contract_path,
        "protocol_path": protocol_path,
        "protocol": protocol,
        "args": args,
        "entry": {"canonical": str(canonical), "prepared_source_file": str(prepared)},
        "original_canonical_bytes": canonical.read_bytes(),
        "original_taskflow_bytes": taskflow.read_bytes(),
        "original_prepared_bytes": prepared.read_bytes(),
    }


def fake_native_repreparation(monkeypatch, fixture, *, task_count=27):

    def fake_invoke(argv, directory, label):
        function = source_domains.CONTRACTS["raytracing"]["function"]
        if label == "taskflow":
            output = Path(argv[argv.index("-o") + 1])
            output.write_bytes(fixture["original_taskflow_bytes"])
        elif label == "prepare-fission-source":
            output = Path(argv[argv.index("-o") + 1])
            configured = str(fixture["taskflow"].resolve()).encode()
            generated = str((output.parent / "taskflow-affine.mlir").resolve()).encode()
            output.write_bytes(fixture["original_prepared_bytes"].replace(configured, generated))
        elif label == "normalize":
            output = Path(argv[argv.index("-o") + 1])
            assert Path(argv[1]).name == "pre-neura.mlir"
            configured = str(fixture["taskflow"].resolve()).encode()
            generated = str((output.parent / "taskflow-affine.mlir").resolve()).encode()
            output.write_bytes(fixture["original_canonical_bytes"].replace(configured, generated))
        elif label == "facts":
            flag = next(value for value in argv if value.startswith("--extract-joint-task-graph-facts="))
            output = Path(flag.split("output=", 1)[1].split()[0])
            write_json(output, {
                "schema": "amoeba-joint-task-graph-facts",
                "function": function,
                "tasks": [{
                    "task_name": f"Task_{index}",
                    "source_iteration_domain_status": "certified-complete",
                    "source_iteration_domain_certified": True,
                    "source_iteration_domain_complete": True,
                    "taskflow_trip_count": 1,
                    "effective_mapper_firing_count": 1,
                    "source_iteration_work_count": 1,
                } for index in range(task_count)],
            })
        elif label == "caller-noalias":
            flag = next(value for value in argv if value.startswith("--import-input0-caller-noalias="))
            output = Path(flag.split("evidence-output=", 1)[1].split()[0])
            write_json(output, {"schema": "test-caller-proof"})
        return {"argv": argv, "exit_code": 0, "status": "finished"}

    monkeypatch.setattr(source_domains, "invoke", fake_invoke)


def test_fresh_ray_source_proof_recreates_prepared_and_canonical_bytes(tmp_path, monkeypatch):
    fixture = make_binding(tmp_path)
    monkeypatch.setattr(all_unit, "ROOT", fixture["root"])
    fake_native_repreparation(monkeypatch, fixture)

    proof = all_unit.validate_fresh_ray_canonical_proof(
        fixture["canonical"], fixture["entry"], fixture["config_base"],
        args=fixture["args"], protocol=fixture["protocol"],
        proof_directory=fixture["args"].output_root / "raytracing/canonical-source-proof")

    assert proof["schema"] == "orbit-ray-fresh-original-canonical-source-proof-v1"
    assert proof["proof_scope"] == "original-input0-unfissioned-raytracing-27-task-source"
    assert proof["task_ids"] == [f"Task_{index}" for index in range(27)]
    assert proof["bindings"]["configured_canonical"]["sha256"] == proof["bindings"]["path_rebased_native_canonical"]["sha256"]
    assert proof["bindings"]["configured_prepared_source"]["sha256"] == proof["bindings"]["path_rebased_native_prepared_source"]["sha256"]
    assert proof["source_domain_verification"] == "native-cpp-pass-exited-successfully"
    assert Path(proof["receipt_path"]).is_file()


@pytest.mark.parametrize("tamper", [
    "canonical", "prepared", "split", "task-count", "source-pin", "source-input",
    "runtime-payload", "model-payload",
])
def test_fresh_ray_source_proof_rejects_changed_or_nonoriginal_inputs(tmp_path, monkeypatch, tamper):
    fixture = make_binding(tmp_path)
    monkeypatch.setattr(all_unit, "ROOT", fixture["root"])
    task_count = 28 if tamper == "task-count" else 27
    fake_native_repreparation(monkeypatch, fixture, task_count=task_count)
    if tamper == "canonical":
        fixture["canonical"].write_text("changed canonical\n")
    elif tamper == "prepared":
        fixture["prepared"].write_text("changed prepared source\n")
    elif tamper == "split":
        path = fixture["config_base"] / "raytracing/preparation.json"
        value = json.loads(path.read_text())
        value["ray_fission_split_at"] = 1
        write_json(path, value)
    elif tamper == "source-pin":
        contract = json.loads(fixture["contract_path"].read_text())
        contract["source_commit"] = "changed-source-commit"
        write_json(fixture["contract_path"], contract)
    elif tamper == "source-input":
        fixture["source"].write_text("amoeba.static_bound.arg.0 = 1473 : i64\n")
    elif tamper == "runtime-payload":
        contract = json.loads(fixture["contract_path"].read_text())
        contract["replay_payloads"][0]["text"] += "# changed runtime payload\n"
        write_json(fixture["contract_path"], contract)
    elif tamper == "model-payload":
        contract = json.loads(fixture["contract_path"].read_text())
        contract["model_payloads"][0]["text"] += "\n"
        write_json(fixture["contract_path"], contract)

    with pytest.raises((ValueError, source_domains.PreparationError)):
        all_unit.validate_fresh_ray_canonical_proof(
            fixture["canonical"], fixture["entry"], fixture["config_base"],
            args=fixture["args"], protocol=fixture["protocol"],
            proof_directory=fixture["args"].output_root / "raytracing/canonical-source-proof")


def _native_space(function):
    return {
        "schema": "amoeba-analytical-task-space",
        "record_type": "space",
        "representation": "factored",
        "function": function,
        "graph_variant_id": "identity",
        "max_cgras_per_task": 1,
        "candidate_count": 1,
        "exact": True,
        "factors": [{
            "task": task,
            "trip_count": 1,
            "shapes": [{
                "rows": 1, "cols": 1, "kind": "rect", "cgra_count": 1,
                "cgra_shape": "1x1", "mapper_tile_rows": 2, "mapper_tile_cols": 2,
            }],
        } for task in all_unit.RAY_TASKS],
    }


def _native_catalog(canonical, protocol, architecture, ensemble):
    model = json.loads(ensemble.read_text())
    architecture_text = architecture.read_text()
    metadata = {
        "architecture_contract": "neura-architecture-v1:" + architecture.stem,
        "architecture_path": str(architecture.resolve()),
        "architecture_schema": "neura-architecture-v1",
        "candidate_only": True,
        "candidate_count": 1,
        "diagnostic_only": True,
        "direct_ensemble": {
            "member_count": 4, "member_seeds": [17, 41, 113, 239],
            "reduction": "arithmetic_mean", "uncertainty": "population_standard_deviation",
        },
        "feature_contract_id": model["feature_contract"]["contract_id"],
        "feature_extractor": model["feature_contract"]["extractor"],
        "feature_frontend": "c++-mlir-current-body-direct-148-v1",
        "formal": False,
        "model": all_unit.DIRECT_MODEL_NAME,
        "model_interval_max_ii": 20,
        "model_schema": model["schema"],
        "model_status": "candidate_pending_amoeba_benchmark_overlap_audit",
        "old_4x4_labels_reused": False,
        "production_ready": False,
        "predictor_source": "per-cgra-2x2-direct-four-member-ii-predictor",
        "provenance_schema": "orbit-cost-provenance-v1",
        "quality_status": "candidate_pending_amoeba_benchmark_overlap_audit",
        "shape_protocol_id": model["shape_protocol"]["protocol_id"],
        "source_commit": protocol["source_commit"],
        "source_graph_id": "identity",
        "source_repository": all_unit.SOURCE_REPOSITORY,
        "source_task_ids": list(all_unit.RAY_TASKS),
        "supports_whole_program_latency_or_throughput_claim": False,
        "unsupported_prediction_policy": "analytical-lower-bound-exceeds-diagnostic-runtime-ceiling-v1",
        "source_model": model["source_model"],
        "canonical_module_witness": canonical.read_text()[:-1],
        "ranking_policy": {
            "mapper_success_probability": "not_predicted",
            "objective": "predicted_scheduler_makespan",
            "uses_mapper_success_probability": False,
        },
        "diagnostic_override": all_unit._expected_diagnostic_override(architecture_text),
    }
    entries = []
    blocker = None
    unsupported_task13 = {
        (2, 2): 83, (2, 4): 42, (2, 6): 28,
        (4, 2): 42, (6, 2): 28,
    }
    for task in all_unit.RAY_TASKS:
        for rows, cols in all_unit.RAY_MODEL_QUERY_SHAPES:
            row = {
                "task": task,
                "mapper_tile_rows": rows,
                "mapper_tile_cols": cols,
                "runtime_ceiling_ii": 23,
                "training_ceiling_ii": 20,
                "analytical_lower_bound": 1,
                "support_status": "supported",
                "candidate_only": True,
                "production_ready": False,
                "model_status": "candidate_pending_amoeba_benchmark_overlap_audit",
                "ii_mean_source": "direct_four_member_arithmetic_mean",
                "predicted_ii": 2.5,
                "predicted_ii_std": 0.2,
                "direct_ensemble_members": [
                    {"member_index": index, "seed": seed, "predicted_ii": 2.5}
                    for index, seed in enumerate((17, 41, 113, 239))
                ],
            }
            if task == "Task_13" and (rows, cols) in unsupported_task13:
                lower_bound = unsupported_task13[(rows, cols)]
                row.update(
                    analytical_lower_bound=lower_bound,
                    extrapolation_status="outside-diagnostic-runtime-domain",
                    status="unsupported-model-domain",
                    support_status="unsupported",
                    unsupported_reason="analytical-lower-bound-exceeds-diagnostic-runtime-ceiling",
                    model_interval_max_ii=20,
                )
                for key in ("predicted_ii", "predicted_ii_std", "direct_ensemble_members"):
                    row.pop(key)
                if (rows, cols) == (2, 2):
                    blocker = row
            elif task == "Task_13":
                row.update(analytical_lower_bound=21, predicted_ii=23)
            entries.append(row)
    return {"schema": "amoeba-task-shape-cost", "function": source_domains.CONTRACTS[
        "raytracing"]["function"], "namespace": all_unit.DIRECT_MODEL_NAMESPACE,
        "predictor_metadata": metadata, "entries": entries}, blocker


def test_fresh_ray_preflight_proves_task13_lower_bound_and_skips_mapper(tmp_path, monkeypatch):
    fixture = make_binding(tmp_path)
    root = fixture["root"]
    monkeypatch.setattr(all_unit, "ROOT", root)
    monkeypatch.setattr(all_unit, "STANDARD_ARCHITECTURE", fixture["standard"])
    monkeypatch.setattr(all_unit, "DIAGNOSTIC_ARCHITECTURE", fixture["diagnostic"])
    monkeypatch.setattr(all_unit, "infer_function",
                        lambda path, explicit: source_domains.CONTRACTS["raytracing"]["function"])
    fake_native_repreparation(monkeypatch, fixture)
    ensemble = Path(fixture["protocol"]["model_ensemble"])
    catalog, blocker = _native_catalog(
        fixture["canonical"], fixture["protocol"], fixture["diagnostic"], ensemble)
    labels = []

    def fake_invoke(argv, directory, label):
        labels.append(label)
        if label == "domain-space":
            encoded = next(arg for arg in argv if arg.startswith("--enumerate-analytical-task-candidates="))
            output = Path(encoded.split("output=", 1)[1].split()[0])
            manifest = _native_space(source_domains.CONTRACTS["raytracing"]["function"])
            footer = {
                "schema": "amoeba-analytical-task-space",
                "record_type": "footer",
                "representation": "factored",
                "candidate_count": 1,
                "status": "unranked-factored-space",
            }
            write_jsonl(output, [manifest, footer])
        elif label == "domain-predictor":
            encoded = next(arg for arg in argv if arg.startswith("--predict-analytical-task-cost-catalog="))
            output = Path(encoded.split("output=", 1)[1].split()[0])
            write_json(output, catalog)
        else:
            pytest.fail(f"unexpected native baseline command: {label}")
        return {"argv": argv, "status": "finished", "exit_code": 0}

    monkeypatch.setattr(all_unit, "invoke", fake_invoke)
    result = all_unit.measure(
        "raytracing", fixture["entry"], fixture["config_base"], fixture["protocol"], fixture["args"])

    assert blocker["task"] == "Task_13"
    assert blocker["analytical_lower_bound"] == 83
    assert result["status"] == "unsupported-model-domain"
    assert result["baseline_cycles"] is None
    assert result["mapper_equality"] == result["numeric"] == result["independent_trace"] == "not-run"
    assert labels == ["domain-space", "domain-predictor"]
    receipt = json.loads(Path(result["domain_admission"]).read_text())
    assert receipt["blocking_rows"] == [blocker]
    assert receipt["canonical_source_proof"]["task_count"] == 27
    assert receipt["mapper_invoked"] is False
