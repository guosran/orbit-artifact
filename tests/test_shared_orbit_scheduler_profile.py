"""Fresh shared-scheduler protocols bind search, replay, and fixed1x1 together."""
import json
from pathlib import Path
import sys
from types import SimpleNamespace

import pytest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

import neighborhood_replay as replay
import run_input0_all_unit_baselines as all_unit
import run_neighborhood_stage_chain as chain
import show_input0_results as viewer

PROFILE = {
    "backend": "orbit-production",
    "dispatch_policy": "critical-path",
    "timing": "common-explicit-network",
}
STAGES = (
    "shape-temporal", "shape-temporal-replica",
    "shape-temporal-replica-tiling", "full-joint",
)
NETWORK = ROOT / "config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml"


def protocol(cohort):
    path = ROOT / "reference/input0-neighborhood" / (
        "protocol-2x2-ray-fission-shared-orbit-scheduler-template.json"
        if "ray-fission" in cohort else
        "protocol-2x2-shared-orbit-scheduler-template.json")
    for revision in ("r2", "r3"):
        if cohort.endswith("-" + revision):
            path = path.with_name(path.name.replace("-template.json", "-" + revision + "-template.json"))
    return json.loads(path.read_text())


def test_v59_templates_bind_the_same_four_independent_stages():
    for cohort in (
        "input0-neighborhood-2x2-v59-shared-scheduler",
        "input0-ray-fission-2x2-v59-shared-scheduler",
        "input0-neighborhood-2x2-v59-shared-scheduler-r2",
        "input0-ray-fission-2x2-v59-shared-scheduler-r2",
        "input0-neighborhood-2x2-v59-shared-scheduler-r3",
        "input0-ray-fission-2x2-v59-shared-scheduler-r3",
    ):
        document = protocol(cohort)
        assert document["cohort_id"] == cohort
        assert document["scheduler"] == PROFILE
        assert tuple(document["stage_order"]) == STAGES
        assert [stage["dispatch"] for stage in document["stages"]] == ["critical-path"] * 4
        assert [stage["scheduling_mode"] for stage in document["stages"]] == ["spatial-temporal"] * 4
        assert document["search"]["stage_initialization"] == "independent"
        assert document["inter_task_network_spec"].endswith(
            "/config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml")


def test_search_and_native_replay_require_production_critical_path_headers(tmp_path):
    document = protocol("input0-neighborhood-2x2-v59-shared-scheduler")
    canonical = tmp_path / "canonical.mlir"
    optimizer = tmp_path / "optimizer"
    architecture = tmp_path / "architecture.yaml"
    protocol_path = tmp_path / "protocol.json"
    protocol_path.write_text(json.dumps(document))
    command = replay.build_search_command(
        optimizer=optimizer, canonical=canonical, output_dir=tmp_path / "search",
        function="main", stage="shape-temporal", architecture=architecture,
        protocol=document, checkpoint=tmp_path / "checkpoint.json", seed_manifest=None,
        previous_winner=None, parent_cost_file=None, model_cache=None, cost_cache=None,
        max_rounds=4, max_candidates=4096, beam_width=16, diversity_slots=4,
        resume=None, protocol_path=protocol_path, inter_task_network=NETWORK,
        stage_initialization="independent")
    joined = " ".join(command)
    assert "protocol=" + str(protocol_path) in joined
    assert "--joint-inter-task-network-spec=" + str(NETWORK) in joined
    assert "scheduler-backend=" not in joined

    score = tmp_path / "score.jsonl"
    header = {"schedule_space": "production-scheduler", "dispatch_policy": "critical-path"}
    score.write_text(json.dumps(header) + "\n")
    selection = {"score_file_path": str(score), "candidate_id": "candidate-1"}
    replay.validate_scheduler_selections(PROFILE, header, [selection])
    with pytest.raises(replay.ContractError, match="scheduler policy"):
        replay.validate_scheduler_selections(
            PROFILE, {**header, "dispatch_policy": "fixed"}, [selection])
    replay.require_native_scheduler({"records": [{
        "status": "native_replayed",
        "scheduler_backend": "orchestrate-tasks-on-accelerators",
        "replay_timing_policy": "production-scheduler-with-mapped-durations",
    }]}, PROFILE)
    with pytest.raises(replay.ContractError, match="native replay"):
        replay.require_native_scheduler({"records": [{
            "status": "native_replayed", "scheduler_backend": "orbit-exact-enumerator",
        }]}, PROFILE)


def test_chain_binding_and_fixed1x1_dispatch_are_scheduler_specific(tmp_path, monkeypatch):
    document = protocol("input0-neighborhood-2x2-v59-shared-scheduler")
    protocol_path = tmp_path / "protocol.json"
    protocol_path.write_text(json.dumps(document))
    optimizer = tmp_path / "optimizer"
    canonical = tmp_path / "canonical.mlir"
    canonical.write_text("module {}\n")
    contract = tmp_path / "source-contract.json"
    contract.write_text("{}")
    architecture = tmp_path / "architecture.yaml"
    architecture.write_text("architecture\n")
    mapping_cache = tmp_path / "mapping-cache"
    mapping_cache.mkdir()
    options = chain.ChainOptions(
        output_root=tmp_path / "results", protocol=protocol_path,
        source_contract_file=contract, optimizer=optimizer, architecture=architecture,
        mapping_cache=mapping_cache, inter_task_network=NETWORK,
        workloads=("lu",), stage_initialization="independent")
    binding = chain.expected_binding(
        {"canonical": "canonical.mlir", "function": "main"}, "lu", STAGES[0],
        options, config_base=tmp_path)
    assert binding["scheduler"] == PROFILE
    source_binding = {**binding, "source_commit": document["source_commit"]}
    assert chain._compatible_source_binding(source_binding, binding)
    assert not chain._compatible_source_binding({**source_binding, "scheduler": None}, binding)

    monkeypatch.setattr(all_unit, "ROOT", tmp_path)
    network = tmp_path / "config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml"
    network.parent.mkdir(parents=True)
    network.write_text("common network\n")
    architecture_file = tmp_path / "config/architectures/amoeba_4x4_cgra_2x2_context6.yaml"
    architecture_file.parent.mkdir(parents=True)
    architecture_file.write_text(all_unit.STANDARD_ARCHITECTURE.read_text())
    model = tmp_path / "reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json"
    model.parent.mkdir(parents=True)
    model.write_text('{"model_namespace":"orbit-per-cgra-2x2-direct-4member-v1"}\n')
    document.update({
        "inter_task_network_spec": "${ARTIFACT_ROOT}/config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml",
        "architecture": "${ARTIFACT_ROOT}/config/architectures/amoeba_4x4_cgra_2x2_context6.yaml",
        "model_ensemble": "${ARTIFACT_ROOT}/reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json",
        "source_contract_file": "${ARTIFACT_ROOT}/source-contract.json",
        "optimizer_pin": "${ORBIT_BUILD}/bin/amoeba-opt",
    })
    (tmp_path / "source-contract.json").write_text(json.dumps({
        "schema": "orbit-neighborhood-exact-source-model-contract-v1",
        "model_namespace": document["model_namespace"],
        "source_commit": document["source_commit"],
        "immutable_optimizer_pin": document["optimizer_pin"],
        "model_payloads": [{"path": "ensemble.json", "text": model.read_text()}],
        "replay_payloads": [{
            "path": "config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml",
            "text": network.read_text(),
        }],
    }))
    args = SimpleNamespace(
        inter_task_network=network, architecture=architecture_file,
        source_contract_file=tmp_path / "source-contract.json",
        output_root=tmp_path / "input0-all-unit-2x2-v59-shared-scheduler")
    assert all_unit.bound_scheduler(document, args) == PROFILE
    fission_document = {**document, "stage_scheme": "full-joint-fission",
        "stage_order": [*document["stage_order"], "full-joint-fission"],
        "stages": [*document["stages"], {
            "name": "full-joint-fission", "dispatch": "critical-path",
            "scheduling_mode": "spatial-temporal"}]}
    assert all_unit.bound_scheduler(fission_document, args) == PROFILE
    fission_document["stages"][-1]["dispatch"] = "fixed"
    with pytest.raises(ValueError, match="critical-path stage protocol"):
        all_unit.bound_scheduler(fission_document, args)
    assert "dispatch-policy=critical-path" in all_unit.native_orchestration_option("critical-path")
    assert "dispatch-policy=fixed" in all_unit.native_orchestration_option("fixed")


def test_protocols_without_scheduler_metadata_keep_legacy_defaults():
    assert replay.scheduler_profile({}) is None
    assert chain.protocol_scheduler({}) is None
    assert "dispatch-policy=fixed" in all_unit.native_orchestration_option("fixed")


def test_stage_viewer_accepts_exact_runtime_network_copy_and_rejects_tampering(tmp_path, monkeypatch):
    monkeypatch.setattr(viewer, "ROOT", tmp_path)
    network = tmp_path / viewer.NETWORK
    network.parent.mkdir(parents=True)
    network.write_text("common explicit network\n")
    runtime_network = tmp_path / "runtime/network.yaml"
    runtime_network.parent.mkdir()
    runtime_network.write_bytes(network.read_bytes())
    optimizer = tmp_path / "optimizer"
    optimizer.touch()
    protocol_path, contract_path = tmp_path / "protocol.json", tmp_path / "contract.json"
    model = tmp_path / "ensemble.json"
    document = {"schema": "orbit-amoeba-input0-neighborhood-v3", "source_commit": "source",
                "optimizer_pin": str(optimizer), "model_ensemble": str(model)}
    monkeypatch.setattr(viewer, "shared_protocol", lambda cohort: (document, protocol_path, contract_path))
    binding_path = tmp_path / "source-binding.json"
    binding = {"scheduler": PROFILE, "protocol_schema": document["schema"],
               "source_contract_file": str(contract_path), "source_commit": "source",
               "architecture": str(tmp_path / viewer.ARCHITECTURE),
               "inter_task_network": str(runtime_network), "inter_task_network_text": network.read_text(),
               "optimizer": str(optimizer), "model_cache": str(model)}
    binding_path.write_text(json.dumps(binding))
    record = {"status": "native_replayed", "scheduler_backend": "orchestrate-tasks-on-accelerators",
              "replay_timing_policy": "production-scheduler-with-mapped-durations"}
    result = {"protocol": str(protocol_path), "source_binding": str(binding_path), "scheduler": PROFILE,
              "search_header": {"schedule_space": "production-scheduler", "dispatch_policy": "critical-path"},
              "native_top5": {"status": "native_replayed", "records": [record] * 5},
              "native_controls": {"status": "native_replayed", "records": [record]}}
    assert viewer.shared_orbit_result_binding(result, "cohort")
    runtime_network.write_text("changed network\n")
    assert not viewer.shared_orbit_result_binding(result, "cohort")
    runtime_network.write_bytes(network.read_bytes())
    binding["inter_task_network_text"] = "changed embedded network\n"
    binding_path.write_text(json.dumps(binding))
    assert not viewer.shared_orbit_result_binding(result, "cohort")
