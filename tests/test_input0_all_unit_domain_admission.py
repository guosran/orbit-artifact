"""The fixed1x1 Ray exclusion is admitted only by the bound native C++ proof."""
from __future__ import annotations

import json
import os
from pathlib import Path
import sys
from types import SimpleNamespace

import pytest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

import run_input0_all_unit_baselines as all_unit


def write_json(path: Path, value: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


def fixture_preflight(tmp_path: Path, monkeypatch):
    standard = tmp_path / "frozen-standard.yaml"
    standard.write_text("architecture: training-20\n")
    diagnostic = tmp_path / "live-diagnostic.yaml"
    diagnostic.write_text("architecture: runtime-23\n")
    monkeypatch.setattr(all_unit, "STANDARD_ARCHITECTURE", standard)
    monkeypatch.setattr(all_unit, "DIAGNOSTIC_ARCHITECTURE", diagnostic)

    canonical = tmp_path / "canonical.mlir"
    canonical.write_text('"builtin.module"() ({\n}) : () -> ()\n\n')
    ensemble = tmp_path / "models" / "ensemble.json"
    ensemble.parent.mkdir()
    source_model = {
        "branch": "orbit-2x2-predictor",
        "candidate_metadata": {"candidate_only": True},
        "commit": "3ade31806cb4c92e31888109f7c42b8a77e4cbce",
        "repository": "https://github.com/guosran/cgra-ii-predictor",
    }
    write_json(ensemble, {
        "schema": "orbit-cgra-ii-per-cgra-2x2-direct-ensemble-cpp-v1",
        "model_namespace": all_unit.DIRECT_MODEL_NAMESPACE,
        "source_model": source_model,
        "feature_contract": {
            "contract_id": "cgra-ii-pre-mapper-features-148-2x2-per-cgra-v1",
            "extractor": "cgra_ii_predictor.mapper_model:mapper_feature_vector",
        },
        "shape_protocol": {"protocol_id": "amoeba-static-rectangles-2x2-per-cgra-max4"},
        "architecture": {"exact_yaml_text": standard.read_text()},
        "members": [{"seed": seed} for seed in (17, 41, 113, 239)],
    })
    protocol = {
        "model_namespace": all_unit.DIRECT_MODEL_NAMESPACE,
        "source_git_repository": all_unit.SOURCE_REPOSITORY,
        "source_commit": "0123456789abcdef",
        "model_ensemble": str(ensemble),
        "fixed1x1_domain_exclusion_policy": all_unit.DOMAIN_EXCLUSION_POLICY,
        "search": {"diagnostic_ii_ceiling": 23},
    }
    function = "raytracing_original"
    space = tmp_path / "domain-space.jsonl"
    factors = [{
        "task": task,
        "trip_count": 1,
        "shapes": [{
            "rows": 1,
            "cols": 1,
            "kind": "rect",
            "cgra_count": 1,
            "cgra_shape": "1x1",
            "mapper_tile_rows": 2,
            "mapper_tile_cols": 2,
        }],
    } for task in all_unit.RAY_TASKS]
    manifest = {
        "schema": "amoeba-analytical-task-space",
        "record_type": "space",
        "representation": "factored",
        "function": function,
        "graph_variant_id": "identity",
        "max_cgras_per_task": 1,
        "candidate_count": 1,
        "exact": True,
        "factors": factors,
    }
    footer = {
        "schema": "amoeba-analytical-task-space",
        "record_type": "footer",
        "representation": "factored",
        "candidate_count": 1,
        "status": "unranked-factored-space",
    }
    space.write_text(json.dumps(manifest) + "\n" + json.dumps(footer) + "\n")

    metadata = {
        "architecture_contract": "neura-architecture-v1:" + diagnostic.stem,
        "architecture_path": str(diagnostic.resolve()),
        "architecture_schema": "neura-architecture-v1",
        "candidate_only": True,
        "candidate_count": 1,
        "diagnostic_only": True,
        "direct_ensemble": {
            "member_count": 4,
            "member_seeds": [17, 41, 113, 239],
            "reduction": "arithmetic_mean",
            "uncertainty": "population_standard_deviation",
        },
        "feature_contract_id": "cgra-ii-pre-mapper-features-148-2x2-per-cgra-v1",
        "feature_extractor": "cgra_ii_predictor.mapper_model:mapper_feature_vector",
        "feature_frontend": "c++-mlir-current-body-direct-148-v1",
        "formal": False,
        "model": all_unit.DIRECT_MODEL_NAME,
        "model_interval_max_ii": 20,
        "model_schema": "orbit-cgra-ii-per-cgra-2x2-direct-ensemble-cpp-v1",
        "model_status": "candidate_pending_amoeba_benchmark_overlap_audit",
        "old_4x4_labels_reused": False,
        "predictor_source": "per-cgra-2x2-direct-four-member-ii-predictor",
        "provenance_schema": "orbit-cost-provenance-v1",
        "quality_status": "candidate_pending_amoeba_benchmark_overlap_audit",
        "shape_protocol_id": "amoeba-static-rectangles-2x2-per-cgra-max4",
        "source_model": source_model,
        "production_ready": False,
        "quality_status": "candidate_pending_amoeba_benchmark_overlap_audit",
        "source_commit": protocol["source_commit"],
        "source_graph_id": "identity",
        "source_repository": all_unit.SOURCE_REPOSITORY,
        "source_task_ids": list(all_unit.RAY_TASKS),
        "supports_whole_program_latency_or_throughput_claim": False,
        "unsupported_prediction_policy": "analytical-lower-bound-exceeds-diagnostic-runtime-ceiling-v1",
        "canonical_module_witness": canonical.read_text()[:-1],
        "ranking_policy": {
            "mapper_success_probability": "not_predicted",
            "objective": "predicted_scheduler_makespan",
            "uses_mapper_success_probability": False,
        },
        "diagnostic_override": all_unit._expected_diagnostic_override(diagnostic.read_text()),
    }
    catalog_rows = []
    blocker = None
    for task in all_unit.RAY_TASKS:
        for tile_rows, tile_cols in all_unit.RAY_MODEL_QUERY_SHAPES:
            row = {
                "task": task,
                "mapper_tile_rows": tile_rows,
                "mapper_tile_cols": tile_cols,
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
                    {"member_index": i, "seed": seed, "predicted_ii": 2.5}
                    for i, seed in enumerate((17, 41, 113, 239))
                ],
            }
            if task == "Task_13" and (tile_rows, tile_cols) in {
                    (2, 2), (2, 4), (2, 6), (4, 2), (6, 2)}:
                row.update(
                    analytical_lower_bound={(2, 2): 83, (2, 4): 42, (2, 6): 28,
                                            (4, 2): 42, (6, 2): 28}[(tile_rows, tile_cols)],
                    extrapolation_status="outside-diagnostic-runtime-domain",
                    status="unsupported-model-domain",
                    support_status="unsupported",
                    unsupported_reason="analytical-lower-bound-exceeds-diagnostic-runtime-ceiling",
                    model_interval_max_ii=20,
                )
                row.pop("predicted_ii")
                row.pop("predicted_ii_std")
                row.pop("direct_ensemble_members")
            elif task == "Task_13":
                row.update(analytical_lower_bound=21, predicted_ii=23)
            catalog_rows.append(row)
            if task == "Task_13" and (tile_rows, tile_cols) == (2, 2):
                blocker = row
    catalog_path = tmp_path / "domain-cost-catalog.json"
    write_json(catalog_path, {
        "schema": "amoeba-task-shape-cost",
        "function": function,
        "namespace": all_unit.DIRECT_MODEL_NAMESPACE,
        "predictor_metadata": metadata,
        "entries": catalog_rows,
    })
    proof_entry = fixture_source_proof(tmp_path, canonical)
    return standard, diagnostic, canonical, protocol, function, space, catalog_path, blocker, proof_entry


def fixture_source_proof(tmp_path: Path, canonical: Path) -> dict:
    original_input0 = tmp_path / "original-input0.mlir"
    artifact_input0 = tmp_path / "artifact-input0.mlir"
    input0 = "generic input0 fixture\n"
    original_input0.write_text(input0)
    artifact_input0.write_text(input0)
    identity = tmp_path / "source-identity.json"
    artifact_input = tmp_path / "raytracing-input.mlir"
    artifact_input.write_text("raytracing source fixture\n")
    write_json(identity, {
        "schema": "orbit-amoeba-original-ray-input0-source-identity-v1",
        "original_git_index_path": "Evaluation/Raytracing/L3/raytracing.mlir",
        "artifact_input": str(artifact_input),
        "binding": {"argument": 0, "value": 1472},
        "native_generic_input0_bytes_equal": True,
        "no_source_fission": True,
        "commands": [
            {"label": "original-input0", "argv": ["optimizer", "amoeba-index-original.mlir"],
             "exit_code": 0, "output": str(original_input0)},
            {"label": "artifact-input0",
             "argv": ["optimizer", str(artifact_input)],
             "exit_code": 0, "output": str(artifact_input0)},
        ],
    })
    lowered = tmp_path / "lowered.mlir"
    lowered.write_bytes(canonical.read_bytes())
    pre_neura = tmp_path / "pre-neura.mlir"
    pre_neura.write_text("pre-neura fixture\n")
    source = tmp_path / "source-shaped.mlir"
    source.write_text("source fixture\n")
    lowering = tmp_path / "canonical-lowering.json"
    write_json(lowering, {
        "schema": "orbit-original-ray-canonical-lowering-repair-v1",
        "source": str(source),
        "pre_neura": str(pre_neura),
        "canonical": str(canonical),
        "lowered": str(lowered),
        "exact_r4_canonical_bytes_equal": True,
        "original_unfissioned_input": True,
        "commands": [
            {"label": "prefix", "argv": ["optimizer", str(source), "-o", str(pre_neura)],
             "exit_code": 0},
            {"label": "lower", "argv": ["optimizer", str(pre_neura), "-o", str(lowered)],
             "exit_code": 0},
        ],
    })
    return {"canonical": str(canonical),
            "source_identity_record": str(identity),
            "canonical_lowering_record": str(lowering)}


def test_real_native_unit_preflight_catalog_and_mutations(tmp_path):
    artifact_root = Path(os.environ.get("ORBIT_RAY_DOMAIN_ARTIFACT_ROOT", str(ROOT))).resolve()
    preflight = artifact_root / ".work/source-fission-original-ray-repair-20261006/ii23-unit-preflight-r6"
    space = preflight / "candidate-space.jsonl"
    catalog_path = preflight / "cost-catalog.json"
    if not space.is_file() or not catalog_path.is_file():
        pytest.skip("real native r6 unit preflight artifacts are unavailable")
    catalog = json.loads(catalog_path.read_text())
    metadata = catalog["predictor_metadata"]
    command_records = json.loads((preflight / "command-record.json").read_text())
    enumeration = next(command for command in command_records if command.get("label") == "space")
    predictor = next(command for command in command_records if command.get("label") == "predict")
    canonical = Path(next(argument for argument in enumeration["argv"]
                          if Path(argument).name == "canonical.mlir"))
    predictor_flag = next(argument for argument in predictor["argv"]
                          if argument.startswith("--predict-analytical-task-cost-catalog="))
    predictor_options = dict(part.split("=", 1) for part in predictor_flag.split()[1:])
    protocol = {
        "model_namespace": catalog["namespace"],
        "source_git_repository": metadata["source_repository"],
        "source_commit": metadata["source_commit"],
        "model_ensemble": predictor_options["ensemble-file"],
    }
    architecture = Path(metadata["architecture_path"])
    function = catalog["function"]
    _, blockers = all_unit.validate_domain_catalog(
        space, catalog_path, canonical, function, protocol, architecture)
    expected_blocker = next(row for row in catalog["entries"]
                            if row.get("task") == "Task_13" and
                            row.get("mapper_tile_rows") == 2 and
                            row.get("mapper_tile_cols") == 2)
    assert blockers == [expected_blocker]
    identity = artifact_root / ".work/source-fission-original-ray-repair-20261006/upstream-source-check/summary.json"
    lowering = artifact_root / ".work/source-fission-original-ray-repair-20261006/canonical-lowering-record.json"
    proof = all_unit.validate_ray_canonical_proof(
        canonical,
        {"source_identity_record": str(identity), "canonical_lowering_record": str(lowering)},
        artifact_root)
    assert proof["source_input0_outputs_exact_bytes_equal"] is True
    assert proof["canonical_matches_lowered_artifact_exact_bytes"] is True

    mutations = (
        ("metadata model", lambda value: value["predictor_metadata"].update(
            model=catalog["namespace"])),
        ("model provenance", lambda value: value["predictor_metadata"]["source_model"].update(
            commit="tampered")),
        ("missing diagnostic field", lambda value: value["predictor_metadata"][
            "diagnostic_override"].pop("training_ii_ceiling")),
        ("query coverage", lambda value: value["entries"].pop()),
        ("unit lower bound", lambda value: next(row for row in value["entries"]
            if row.get("task") == "Task_13" and row.get("mapper_tile_rows") == 2 and
            row.get("mapper_tile_cols") == 2).update(analytical_lower_bound=23)),
        ("unrelated unsupported unit", lambda value: next(row for row in value["entries"]
            if row.get("task") == "Task_12" and row.get("mapper_tile_rows") == 2 and
            row.get("mapper_tile_cols") == 2).update(
                status="unsupported-model-domain", support_status="unsupported",
                unsupported_reason="tampered")),
    )
    for index, (label, mutate) in enumerate(mutations):
        altered = json.loads(catalog_path.read_text())
        mutate(altered)
        altered_path = tmp_path / f"mutated-native-catalog-{index}.json"
        write_json(altered_path, altered)
        with pytest.raises(ValueError, match="native|model|Task_13|unsupported|diagnostic"):
            all_unit.validate_domain_catalog(
                space, altered_path, canonical, function, protocol, architecture)


def test_domain_catalog_proof_stamps_typed_receipt_and_exact_blocking_row(tmp_path, monkeypatch):
    _, diagnostic, canonical, protocol, function, space, catalog, blocker, _ = fixture_preflight(
        tmp_path, monkeypatch)
    _, blockers = all_unit.validate_domain_catalog(
        space, catalog, canonical, function, protocol, diagnostic)
    assert blockers == [blocker]
    receipt = all_unit.build_domain_admission_receipt(
        optimizer=tmp_path / "optimizer",
        source_contract=tmp_path / "source-contract.json",
        protocol_path=tmp_path / "protocol.json",
        architecture=diagnostic,
        canonical=canonical,
        function=function,
        space_path=space,
        catalog_path=catalog,
        blocker=blockers[0],
        commands={"domain-space": {"exit_code": 0}, "domain-predictor": {"exit_code": 0}},
        canonical_proof={"exact_r4_canonical_bytes_equal": True},
    )
    assert receipt["schema"] == "orbit-input0-all-unit-model-domain-admission-v1"
    assert receipt["status"] == "unsupported-model-domain"
    assert receipt["kind"] == "compiler-proved-lower-bound-exceeds-configured-runtime-ceiling"
    assert receipt["blocking_rows"] == [blocker]
    assert receipt["runtime_ii_ceiling"] == 23
    assert receipt["training_ii_ceiling"] == 20
    assert receipt["formal_go"] is False
    assert receipt["mapper_invoked"] is False


def test_expected_ray_exclusion_returns_before_mapper_or_native_baseline(tmp_path, monkeypatch):
    _, diagnostic, canonical, protocol, _, space, catalog, _, proof_entry = fixture_preflight(
        tmp_path, monkeypatch)
    monkeypatch.setattr(all_unit, "infer_function", lambda path, explicit: "raytracing_original")
    output_root = tmp_path / "fixed-root"
    output_root.mkdir()
    args = SimpleNamespace(
        output_root=output_root,
        optimizer=tmp_path / "optimizer",
        architecture=diagnostic,
        source_contract_file=tmp_path / "source-contract.json",
        protocol=tmp_path / "protocol.json",
        inter_task_network=None,
        mapping_cache=tmp_path / "mapper-cache",
        llvm_build=tmp_path / "llvm-build",
        sram_config=tmp_path / "sram.json",
    )
    args.mapping_cache.mkdir()

    def fake_invoke(argv, directory, label):
        command = next(item for item in argv if item.startswith("--enumerate-analytical-task-candidates=")
                       or item.startswith("--predict-analytical-task-cost-catalog="))
        if label == "domain-space":
            output = command.split("output=", 1)[1].split()[0]
            Path(output).write_bytes(space.read_bytes())
        elif label == "domain-predictor":
            output = command.split("output=", 1)[1].split()[0]
            Path(output).write_bytes(catalog.read_bytes())
        else:
            pytest.fail(f"unexpected command was invoked: {label}")
        return {"argv": argv, "status": "finished", "exit_code": 0}

    monkeypatch.setattr(all_unit, "invoke", fake_invoke)
    result = all_unit.measure(
        "raytracing", {"canonical": str(canonical), **proof_entry}, tmp_path, protocol, args)
    assert result["status"] == "unsupported-model-domain"
    assert result["baseline_cycles"] is None
    assert result["mapper_equality"] == result["numeric"] == result["independent_trace"] == "not-run"
    assert set(result["commands"]) == {"domain-space", "domain-predictor"}
    assert result["domain_admission"] == str(output_root / "raytracing" / "model-domain-admission.json")
    assert not (output_root / "raytracing" / "mapped.mlir").exists()
    receipt = json.loads(Path(result["domain_admission"]).read_text())
    assert receipt["commands"]["domain-space"]["exit_code"] == 0
    assert receipt["commands"]["domain-predictor"]["exit_code"] == 0


@pytest.mark.parametrize("tamper", ["canonical", "override", "shape", "query", "lower-bound", "other-task"])
def test_domain_catalog_rejects_wrong_proof_or_query(tmp_path, monkeypatch, tamper):
    _, diagnostic, canonical, protocol, function, space, catalog_path, _, _ = fixture_preflight(
        tmp_path, monkeypatch)
    catalog = json.loads(catalog_path.read_text())
    if tamper == "canonical":
        catalog["predictor_metadata"]["canonical_module_witness"] += "tampered"
    elif tamper == "override":
        del catalog["predictor_metadata"]["diagnostic_override"]["formal"]
    elif tamper == "shape":
        catalog["entries"][-1]["mapper_tile_rows"] = 4
    elif tamper == "query":
        catalog["entries"].append(dict(catalog["entries"][0]))
    elif tamper == "lower-bound":
        row = next(row for row in catalog["entries"]
                   if row.get("task") == "Task_13" and
                   row.get("mapper_tile_rows") == 2 and row.get("mapper_tile_cols") == 2)
        row["analytical_lower_bound"] = 23
    else:
        catalog["entries"][0].update(
            status="unsupported-model-domain",
            support_status="unsupported",
            unsupported_reason="unrelated")
    write_json(catalog_path, catalog)
    with pytest.raises(ValueError):
        all_unit.validate_domain_catalog(space, catalog_path, canonical, function, protocol, diagnostic)


def test_supported_unit_rows_do_not_auto_exclude_ray(tmp_path, monkeypatch):
    _, diagnostic, canonical, protocol, function, space, catalog_path, _, _ = fixture_preflight(
        tmp_path, monkeypatch)
    catalog = json.loads(catalog_path.read_text())
    unit_index = next(i for i, row in enumerate(catalog["entries"])
                      if row.get("task") == "Task_13" and
                      row.get("mapper_tile_rows") == 2 and row.get("mapper_tile_cols") == 2)
    unit = catalog["entries"][unit_index]
    unit.update(
        analytical_lower_bound=21,
        support_status="supported",
        candidate_only=True,
        production_ready=False,
        model_status="candidate_pending_amoeba_benchmark_overlap_audit",
        ii_mean_source="direct_four_member_arithmetic_mean",
        predicted_ii=23,
        predicted_ii_std=0.2,
        direct_ensemble_members=[
            {"member_index": i, "seed": seed, "predicted_ii": 23}
            for i, seed in enumerate((17, 41, 113, 239))
        ],
    )
    for key in ("status", "unsupported_reason", "extrapolation_status", "model_interval_max_ii"):
        unit.pop(key, None)
    write_json(catalog_path, catalog)
    _, blockers = all_unit.validate_domain_catalog(
        space, catalog_path, canonical, function, protocol, diagnostic)
    assert blockers == []


def test_opt_in_is_ray_only_and_requires_both_policy_and_ceiling():
    policy = all_unit.DOMAIN_EXCLUSION_POLICY
    opted = {"fixed1x1_domain_exclusion_policy": policy,
             "search": {"diagnostic_ii_ceiling": 23}}
    assert all_unit.ray_domain_exclusion_enabled("raytracing", opted)
    assert not all_unit.ray_domain_exclusion_enabled("gcn", opted)
    with pytest.raises(ValueError):
        all_unit.ray_domain_exclusion_enabled(
            "raytracing", {"search": {"diagnostic_ii_ceiling": 23}})
    with pytest.raises(ValueError):
        all_unit.ray_domain_exclusion_enabled(
            "raytracing", {"fixed1x1_domain_exclusion_policy": policy,
                           "search": {"diagnostic_ii_ceiling": 20}})


def test_default_workload_paths_accept_a_byte_identical_live_architecture(tmp_path, monkeypatch):
    frozen = tmp_path / "frozen.yaml"
    frozen.write_text("same bytes\n")
    live = tmp_path / "accepted-live-copy.yaml"
    live.write_text(frozen.read_text())
    protocol_path = tmp_path / "protocol.json"
    protocol_path.write_text("{}\n")
    monkeypatch.setattr(all_unit, "STANDARD_ARCHITECTURE", frozen)
    args = SimpleNamespace(architecture=live, protocol=protocol_path)
    default_protocol = {}
    selected, selected_protocol = all_unit.selected_workload_context(
        "gcn", {"canonical": "unused"}, tmp_path, args, default_protocol)
    assert selected.architecture == live
    assert selected.protocol == protocol_path
    assert selected_protocol is default_protocol


def test_workload_architecture_and_protocol_overrides_are_selected(tmp_path, monkeypatch):
    standard, diagnostic, _, _, _, _, _, _, _ = fixture_preflight(tmp_path, monkeypatch)
    protocol_path = tmp_path / "ray-protocol.json"
    protocol = {"fixed1x1_domain_exclusion_policy": all_unit.DOMAIN_EXCLUSION_POLICY,
                "search": {"diagnostic_ii_ceiling": 23}}
    write_json(protocol_path, protocol)
    args = SimpleNamespace(architecture=standard, protocol=tmp_path / "global-protocol.json")
    selected, selected_protocol = all_unit.selected_workload_context(
        "raytracing",
        {"architecture": str(diagnostic), "protocol": str(protocol_path)},
        tmp_path, args, {})
    assert selected.architecture == diagnostic
    assert selected.protocol == protocol_path
    assert selected_protocol == protocol


def test_ray_source_proof_is_bound_to_restored_canonical(tmp_path, monkeypatch):
    _, _, canonical, _, _, _, _, _, proof_entry = fixture_preflight(tmp_path, monkeypatch)
    proof = all_unit.validate_ray_canonical_proof(canonical, proof_entry, tmp_path)
    assert proof["exact_r4_canonical_bytes_equal"]
    lowering_path = Path(proof_entry["canonical_lowering_record"])
    lowering = json.loads(lowering_path.read_text())
    lowering["canonical"] = str(tmp_path / "other.mlir")
    write_json(lowering_path, lowering)
    with pytest.raises(ValueError):
        all_unit.validate_ray_canonical_proof(canonical, proof_entry, tmp_path)
