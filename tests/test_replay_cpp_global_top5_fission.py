from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import sys
from types import SimpleNamespace

import pytest


SCRIPT = Path(__file__).resolve().parents[1] / "scripts/replay_cpp_global_top5.py"
sys.path.insert(0, str(SCRIPT.parent))
SPEC = importlib.util.spec_from_file_location("replay_cpp_global_top5_fission_test", SCRIPT)
assert SPEC is not None and SPEC.loader is not None
replay = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = replay
SPEC.loader.exec_module(replay)


def write_json(path: Path, value: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def _fixture(tmp_path: Path, monkeypatch, *, native_match: bool = True,
             active_arguments: list[int] | None = None):
    canonical = tmp_path / "canonical.mlir"
    canonical_bytes = b"module { func.func @kernel() }\n"
    canonical.write_bytes(canonical_bytes)
    prepared = tmp_path / "prepared-source.mlir"
    prepared_bytes = b"module { func.func @kernel() { \"taskflow.task\"() } }\n"
    prepared.write_bytes(prepared_bytes)
    protocol = tmp_path / "protocol.json"
    protocol_value = {
        "schema": "orbit-amoeba-input0-neighborhood-v3",
        "stage_scheme": replay.FISSION_STAGE,
        "source_commit": "fixture-commit",
        "inter_task_network_spec": "${ARTIFACT_ROOT}/config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml",
        "search": {"max_fission_actions_per_task": 64,
                   "max_partition_factor": 8},
    }
    if active_arguments:
        protocol_value["search"]["active_transfer_arguments"] = active_arguments
        protocol_value["search"]["active_transfer_require_proven"] = True
    write_json(protocol, protocol_value)
    network = (replay.ROOT / replay.COMMON_INTER_TASK_NETWORK).resolve()
    network_text = network.read_text(encoding="utf-8")
    contract = tmp_path / "source-contract.json"
    contract.write_text("contract\n", encoding="utf-8")
    public_binding = tmp_path / "source-binding.json"
    write_json(public_binding, {
        "schema": "orbit-neighborhood-source-binding-v1",
        "stage_initialization": "independent",
        "prepared_source_file": str(prepared.resolve()),
        "prepared_source_exact_text": prepared_bytes.decode("utf-8"),
        "prepared_source_size_bytes": len(prepared_bytes),
        "max_fission_actions_per_task": 64,
        "inter_task_network": str(network),
        "inter_task_network_text": network_text,
    })
    cpp_binding = tmp_path / "search-source-binding.json"
    cpp_witness = {
        "schema": "orbit-neighborhood-exact-binding-v1",
        "stage": replay.FISSION_STAGE,
        "prepared_source_file": str(prepared.resolve()),
        "prepared_source_exact_bytes": prepared_bytes.decode("utf-8"),
        "prepared_source_lowering_pipeline": "builtin.module(exact-source-owned-pipeline)",
        "max_fission_actions_per_task": 64,
        "max_partition_factor": 8,
        "fission_source_replay": "orbit-taskflow-fission-source-replay-v1",
        "inter_task_network_spec_override": {"exact_bytes": network_text},
        "files": {
            "prepared_taskflow_source": {
                "path": str(prepared.resolve()),
                "exact_bytes": prepared_bytes.decode("utf-8"),
            },
            "protocol": {"path": str(protocol.resolve()),
                         "exact_bytes": protocol.read_text(encoding="utf-8")},
            "source_and_model_contract": {
                "path": str(contract.resolve()),
                "exact_bytes": contract.read_text(encoding="utf-8"),
            },
        },
    }
    if active_arguments:
        cpp_witness["active_transfer_proof"] = {
            "schema": "orbit-static-active-transfer-proof-v1",
            "arguments_option": ",".join(str(item) for item in active_arguments),
            "arguments": active_arguments,
            "require_proven": True,
            "witness_encoding": "exact-byte-interned-active-transfer-v1",
        }
    write_json(cpp_binding, cpp_witness)
    candidate = tmp_path / "search-candidate.mlir"
    candidate_bytes = b"module { func.func @kernel() { \"taskflow.task\"() } }\n"
    candidate.write_bytes(candidate_bytes)
    fission_action = {
        "family": "fission", "label": "fission:root:left=0,1",
        "shapeTask": "", "shapeRows": 0, "shapeCols": 0,
        "canonicalReset": False,
        "primitives": [{"kind": "fission", "firstTask": "root",
                        "secondTask": "", "mode": "", "axis": 0,
                        "factor": 1, "leftNodes": [0, 1]}],
    }
    shape_action = {
        "family": "shape", "label": "shape:root_L:1x2",
        "shapeTask": "root_L", "shapeRows": 1, "shapeCols": 2,
        "canonicalReset": False, "primitives": [],
    }
    selection = {
        "candidate_id": "candidate-0", "rank": 0,
        "candidate_path": str(candidate), "mapper_replay_path": str(candidate),
        "source_binding_witness": str(cpp_binding),
        "action_history": {
            "schema": replay.HISTORY_SCHEMA, "known": True,
            "canonicalFactKey": "source-replay-pending",
            "initialShapes": [{"task": "root_L", "rows": 1, "cols": 1},
                              {"task": "root_R", "rows": 1, "cols": 1}],
            "fissionActions": [fission_action], "actions": [shape_action],
        },
    }
    args = SimpleNamespace(
        canonical=canonical, prepared_source_file=prepared,
        source_binding_file=public_binding, max_fission_actions_per_task=64,
        max_partition_factor=8, function="kernel", optimizer=tmp_path / "amoeba-opt",
        architecture=tmp_path / "arch.yaml", protocol=protocol,
        source_contract_file=contract,
        inter_task_network=network,
    )
    args.optimizer.write_text("compiler\n", encoding="utf-8")
    args.architecture.write_text("architecture\n", encoding="utf-8")
    public_value = json.loads(public_binding.read_text(encoding="utf-8"))
    public_value.update({
        "canonical_program": str(canonical.resolve()),
        "optimizer": str(args.optimizer.resolve()),
        "architecture": str(args.architecture.resolve()),
        "protocol_schema": protocol_value["schema"],
        "source_commit": protocol_value["source_commit"],
        "source_contract_file": str(contract.resolve()),
    })
    write_json(public_binding, public_value)
    cpp_witness["files"]["architecture"] = {
        "path": str(args.architecture.resolve()),
        "exact_bytes": args.architecture.read_text(encoding="utf-8"),
    }
    write_json(cpp_binding, cpp_witness)

    calls = []

    def fake_invoke(argv, directory, label):
        calls.append(argv)
        option = next(arg.split("=", 1)[1] for arg in argv
                      if arg.startswith("--replay-joint-neighborhood-actions="))
        values = dict(token.split("=", 1) for token in option.split())
        action_file = Path(values["action-file"])
        output = Path(values["output-dir"])
        action_text = action_file.read_text(encoding="utf-8")
        action_doc = json.loads(action_text)
        steps = []
        fission_count = 0
        for index, action in enumerate(action_doc["actions"]):
            is_fission = action["family"] == "fission"
            fission_count += int(is_fission)
            steps.append({"index": index, "label": action["label"],
                          "family": action["family"],
                          "status": "exact-source-replay-verified" if is_fission else "applied"})
        facts = {
            "schema": replay.REPLAY_FACTS_SCHEMA, "status": "complete",
            "canonical_input_path": str(canonical.resolve()),
            "candidate_input_path": str(canonical.resolve()),
            "action_file_path": str(action_file), "stage": replay.FISSION_STAGE,
            "source_iteration_domain_verified": True,
            "fission_source_replay_verified": fission_count != 0,
            "candidate_module": "candidate.mlir",
            "prepared_source_input_path": str(prepared.resolve()),
            "prepared_source_input_witness": "prepared-source.mlir",
            "expected_candidate_path": str(candidate.resolve()),
            "expected_candidate_witness": "expected-candidate.mlir",
            "expected_candidate_exact_replay_match": native_match,
            "expected_candidate_comparison":
                "exact-generic-module-after-removing-only-function-graph-variant-id",
            "max_fission_actions_per_task": 64, "max_partition_factor": 8,
            "actions_applied": len(action_doc["actions"]), "steps": steps,
        }
        if action_doc.get("activeTransferArguments"):
            facts.update({
                "active_transfer_replay_verified": True,
                "active_transfer_arguments": action_doc["activeTransferArguments"],
                "active_transfer_require_proven": action_doc["activeTransferRequireProven"],
            })
        output.mkdir(parents=True)
        (output / "source-facts.json").write_text(
            json.dumps(facts), encoding="utf-8")
        (output / "canonical-input.mlir").write_bytes(canonical_bytes)
        (output / "candidate-input.mlir").write_bytes(canonical_bytes)
        (output / "actions.json").write_text(action_text, encoding="utf-8")
        (output / "prepared-source.mlir").write_bytes(prepared_bytes)
        (output / "expected-candidate.mlir").write_bytes(candidate_bytes)
        (output / "candidate.mlir").write_bytes(candidate_bytes)
        return {"status": "finished", "exit_code": 0, "argv": argv}

    monkeypatch.setattr(replay, "invoke", fake_invoke)
    return args, selection, calls


def test_native_fission_replay_uses_typed_prefix_and_exact_pinned_inputs(tmp_path, monkeypatch):
    args, selection, calls = _fixture(tmp_path, monkeypatch)
    receipt = replay.replay_fission_candidate(selection, args, tmp_path / "rank-0")

    assert receipt["status"] == "verified"
    assert receipt["fission_action_count"] == 1
    assert receipt["ordinary_action_count"] == 1
    command = calls[0]
    option = next(arg.split("=", 1)[1] for arg in command
                  if arg.startswith("--replay-joint-neighborhood-actions="))
    native_options = dict(token.split("=", 1) for token in option.split())
    action_path = Path(native_options["action-file"])
    action = json.loads(action_path.read_text(encoding="utf-8"))
    assert action["canonicalInput"] == action["candidateInput"] == str(args.canonical.resolve())
    assert action["preparedSourceInput"] == str(args.prepared_source_file.resolve())
    assert [row["family"] for row in action["actions"]] == ["fission", "shape"]
    assert action["actions"][0] == selection["action_history"]["fissionActions"][0]
    assert action["actions"][1] == selection["action_history"]["actions"][0]
    assert native_options["expected-candidate-file"] == str(Path(selection["candidate_path"]).resolve())
    assert Path(receipt["prepared_source_replay_witness"]).read_bytes() == args.prepared_source_file.read_bytes()


def test_fission_replay_rejects_candidate_mismatch_from_native_comparator(tmp_path, monkeypatch):
    args, selection, _ = _fixture(tmp_path, monkeypatch, native_match=False)
    with pytest.raises(replay.FissionReplayError, match="exact replay"):
        replay.replay_fission_candidate(selection, args, tmp_path / "rank-0")


def test_rebased_fission_contract_keeps_exact_prefix_suffix_replay(tmp_path, monkeypatch):
    args, selection, calls = _fixture(tmp_path, monkeypatch)
    witness_path = Path(selection["source_binding_witness"])
    witness = json.loads(witness_path.read_text())
    witness["fission_source_replay"] = (
        "orbit-taskflow-fission-source-replay-v2-ordinary-suffix-rebase")
    write_json(witness_path, witness)
    receipt = replay.replay_fission_candidate(selection, args, tmp_path / "rank-0")
    assert receipt["status"] == "verified"
    assert receipt["fission_action_count"] == 1
    assert receipt["ordinary_action_count"] == 1
    assert len(calls) == 1


@pytest.mark.parametrize("contract", [None, {}, [], "orbit-taskflow-fission-source-replay-v2",
                                    "orbit-taskflow-fission-source-replay-v3"])
def test_unknown_fission_contract_blocks_native_replay(tmp_path, monkeypatch, contract):
    args, selection, calls = _fixture(tmp_path, monkeypatch)
    witness_path = Path(selection["source_binding_witness"])
    witness = json.loads(witness_path.read_text())
    witness["fission_source_replay"] = contract
    write_json(witness_path, witness)
    with pytest.raises(replay.FissionReplayError, match="lowering policy"):
        replay.replay_fission_candidate(selection, args, tmp_path / "rank-0")
    assert calls == []


def test_active_transfer_options_are_copied_from_protocol_and_native_facts(tmp_path, monkeypatch):
    args, selection, calls = _fixture(
        tmp_path, monkeypatch, active_arguments=[1, 3, 7])
    receipt = replay.replay_fission_candidate(selection, args, tmp_path / "rank-0")

    option = next(arg.split("=", 1)[1] for arg in calls[0]
                  if arg.startswith("--replay-joint-neighborhood-actions="))
    native_options = dict(token.split("=", 1) for token in option.split())
    action = json.loads(Path(native_options["action-file"]).read_text(encoding="utf-8"))
    assert action["activeTransferArguments"] == [1, 3, 7]
    assert action["activeTransferRequireProven"] is True
    assert native_options["active-transfer-arguments"] == "1,3,7"
    assert native_options["active-transfer-require-proven"] == "true"
    assert receipt["active_transfer_arguments"] == [1, 3, 7]
    assert receipt["active_transfer_require_proven"] is True


@pytest.mark.parametrize(
    "tamper",
    ["cpp_bytes", "public_path", "public_text", "protocol_path", "cli_path"],
)
def test_fission_replay_rejects_network_binding_mismatch(tmp_path, monkeypatch,
                                                         tamper):
    args, selection, calls = _fixture(tmp_path, monkeypatch)
    public_binding = json.loads(args.source_binding_file.read_text(encoding="utf-8"))
    witness_path = Path(selection["source_binding_witness"])
    witness = json.loads(witness_path.read_text(encoding="utf-8"))

    if tamper == "cpp_bytes":
        witness["inter_task_network_spec_override"]["exact_bytes"] += "# altered\n"
        write_json(witness_path, witness)
    elif tamper == "public_path":
        wrong_path = tmp_path / "different-network.yaml"
        wrong_path.write_text("different network\n", encoding="utf-8")
        public_binding["inter_task_network"] = str(wrong_path.resolve())
        write_json(args.source_binding_file, public_binding)
    elif tamper == "public_text":
        public_binding["inter_task_network_text"] += "# altered\n"
        write_json(args.source_binding_file, public_binding)
    elif tamper == "protocol_path":
        protocol_value = json.loads(args.protocol.read_text(encoding="utf-8"))
        protocol_value["inter_task_network_spec"] = "${ARTIFACT_ROOT}/config/networks/other.yaml"
        write_json(args.protocol, protocol_value)
        witness["files"]["protocol"]["exact_bytes"] = args.protocol.read_text(
            encoding="utf-8")
        write_json(witness_path, witness)
    else:
        wrong_path = tmp_path / "different-network.yaml"
        wrong_path.write_text("different network\n", encoding="utf-8")
        args.inter_task_network = wrong_path

    with pytest.raises(replay.FissionReplayError, match="network"):
        replay.replay_fission_candidate(selection, args, tmp_path / "rank-0")
    assert calls == []


def test_fission_replay_failure_blocks_mapper_invocation(tmp_path, monkeypatch):
    score = tmp_path / "score.jsonl"
    score.write_text(json.dumps({"schedule_space": "production-scheduler",
                                 "dispatch_policy": "critical-path"}) + "\n",
                     encoding="utf-8")
    selection = {
        "score_record": {"task_costs": [], "task_schedule": []},
        "score_file_path": str(score), "candidate_id": "candidate-0", "rank": 0,
        "graph_variant_id": "identity", "certified": False,
        "predicted_whole_program_cycles": 1,
    }
    args = SimpleNamespace(
        stage=replay.FISSION_STAGE, output_dir=tmp_path / "native",
        optimizer=tmp_path / "amoeba-opt", architecture=tmp_path / "arch.yaml",
        manifest=tmp_path / "missing-manifest.json", graph_manifests=None,
        inter_task_network=None,
    )
    calls = []
    monkeypatch.setattr(replay, "invoke", lambda *values: calls.append(values))

    result = replay.replay(selection, args)

    assert result["status"] == "incomplete"
    assert result["blocker"].startswith("source_fission_replay_failed:")
    assert calls == []
    assert not (args.output_dir / "rank-0" / "mapped.mlir").exists()
