"""Contract tests for the resumable neighborhood chain launcher.

The fake command runner emits records shaped like the source-owned C++
selection/native interfaces.  It never supplies a Python-generated score or
shape tuple; the tests exercise only orchestration and evidence handling.
"""
from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import pytest
import sys


SCRIPT = Path(__file__).resolve().parents[1] / "scripts/run_neighborhood_stage_chain.py"
SPEC = importlib.util.spec_from_file_location("stage_chain_launcher_tested", SCRIPT)
assert SPEC is not None and SPEC.loader is not None
chain = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = chain
SPEC.loader.exec_module(chain)


def write_json(path: Path, value: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


def setup_inputs(tmp_path: Path, workloads: tuple[str, ...]) -> tuple[dict, chain.ChainOptions]:
    protocol = tmp_path / "protocol.json"
    write_json(protocol, {
        "schema": "orbit-amoeba-input0-neighborhood-v3",
        "source_commit": "a57376e7043b1681e64e7169c5a8cb02eb192331",
        "stages": list(chain.LEGACY_STAGES),
    })
    source_contract = tmp_path / "source-model-contract.json"
    source_contract.write_text("contract\n")
    optimizer = tmp_path / "mlir-amoeba-opt"
    optimizer.write_text("binary\n")
    architecture = tmp_path / "architecture.yaml"
    architecture.write_text("architecture\n")
    replay = tmp_path / "neighborhood_replay.py"
    replay.write_text("# mocked\n")
    table = tmp_path / "render_neighborhood_table.py"
    table.write_text("# mocked\n")
    mapping_cache = tmp_path / "mapping-cache"
    mapping_cache.mkdir()
    canonical = tmp_path / "canonical.mlir"
    canonical.write_text("module { func.func @main() }\n")
    config = {
        "schema": "orbit-amoeba-input0-neighborhood-chain-config-v1",
        "config_base": str(tmp_path),
        "workloads": {
            workload: {"canonical": str(canonical), "function": "main"}
            for workload in workloads
        },
    }
    options = chain.ChainOptions(
        output_root=tmp_path / "run",
        protocol=protocol,
        source_contract_file=source_contract,
        optimizer=optimizer,
        architecture=architecture,
        mapping_cache=mapping_cache,
        replay_script=replay,
        table_script=table,
        workloads=workloads, stage_initialization="previous-winner",
        start_stage=chain.LEGACY_STAGES[0],
    )
    return config, options


class FakeRunner:
    def __init__(self, *, fail: tuple[str, str] | None = None):
        self.calls: list[tuple[str, str, list[str]]] = []
        self.fail = fail

    @staticmethod
    def _arg(argv: list[str], name: str) -> str:
        return argv[argv.index(name) + 1]

    def __call__(self, argv, directory: Path, label: str):
        argv = [str(item) for item in argv]
        if "--stage" not in argv:
            self.calls.append(("table", "table", argv))
            return {"status": "finished", "exit_code": 0, "argv": argv}
        workload = self._arg(argv, "--workload")
        stage = self._arg(argv, "--stage")
        output = Path(self._arg(argv, "--output-dir"))
        self.calls.append((workload, stage, argv))
        if self.fail == (workload, stage):
            output.mkdir(parents=True, exist_ok=True)
            write_json(output / "result.json", {
                "schema": "orbit-neighborhood-stage-result-v1",
                "status": "incomplete", "workload": workload, "stage": stage,
                "stop_reason": "mocked-search-failure", "best_found": True,
            })
            return {"status": "finished", "exit_code": 7, "argv": argv}

        search = output / "search"
        search.mkdir(parents=True, exist_ok=True)
        (output / "search-result.json").write_text("{}\n")
        source_dir = output / "source-owned"
        source_dir.mkdir(parents=True, exist_ok=True)

        top5 = []
        native_top5 = []
        for rank in range(5):
            candidate_id = f"{workload}-{stage}-top-{rank}"
            module = source_dir / f"{candidate_id}.mlir"
            score = source_dir / f"{candidate_id}.score.jsonl"
            manifest = source_dir / f"{candidate_id}.shape.jsonl"
            for path in (module, score, manifest):
                path.write_text("source-owned\n")
            row = {
                "record_type": "selection", "candidate_id": candidate_id,
                "graph_variant_id": f"graph-{stage}", "rank": rank,
                "predicted_whole_program_cycles": 100 + rank,
                "mapper_replay_path": str(module),
                "score_file_path": str(score),
                "shape_manifest_file": str(manifest),
                "shape_candidate_id": f"shape-{candidate_id}",
                "score_record": {"shape_candidate_id": f"shape-{candidate_id}"},
            }
            top5.append(row)
            native_top5.append({
                "rank": rank, "candidate_id": candidate_id,
                "graph_variant_id": f"graph-{stage}",
                "native_cycles": 100 + rank, "status": "native_replayed",
                "independent_trace": "pass", "mapper_equality": "pass",
                "numeric": "pass",
            })

        control_id = f"{workload}-{stage}-identity-control"
        module = source_dir / f"{control_id}.mlir"
        score = source_dir / f"{control_id}.score.jsonl"
        manifest = source_dir / f"{control_id}.shape.jsonl"
        for path in (module, score, manifest):
            path.write_text("source-owned-control\n")
        control = {
            "record_type": "control", "control_role": "identity",
            "candidate_id": control_id, "graph_variant_id": f"graph-{stage}",
            "rank": 5, "predicted_whole_program_cycles": 999,
            "mapper_replay_path": str(module), "score_file_path": str(score),
            "shape_manifest_file": str(manifest),
            "shape_candidate_id": f"shape-{control_id}",
            "score_record": {"shape_candidate_id": f"shape-{control_id}"},
        }
        (search / "global-top5.jsonl").write_text("\n".join(
            json.dumps(row) for row in [
                {"record_type": "header", "schema": "fixture"},
                *top5,
                {"record_type": "footer", "complete": True},
            ]) + "\n")
        (search / "controls.jsonl").write_text(json.dumps(control) + "\n")
        result = {
            "schema": "orbit-neighborhood-stage-result-v1",
            "status": "native_replayed", "workload": workload, "stage": stage,
            "top5": top5, "controls": [control],
            "native_top5": {"status": "native_replayed", "records": native_top5},
            "native_controls": {"status": "native_replayed", "records": [{
                "rank": 5, "candidate_id": control_id,
                "graph_variant_id": f"graph-{stage}",
                # The control deliberately wins.  It must become the next
                # stage's C++ previous-winner row.
                "native_cycles": 1, "status": "native_replayed",
                "control_role": "identity", "independent_trace": "pass",
                "mapper_equality": "pass", "numeric": "pass",
            }]},
            "actual_stage_cycles": 1, "best_found": True, "exhaustive": False,
        }
        write_json(output / "result.json", result)
        return {"status": "finished", "exit_code": 0, "argv": argv}


@pytest.mark.parametrize("retry_fails", [False, True])
def test_parallel_recovery_retries_failed_numeric_without_search(
    tmp_path, monkeypatch, retry_fails
):
    config, options = setup_inputs(tmp_path, ("llama",))
    first = FakeRunner()
    monkeypatch.setattr(chain, "_run_logged", first)
    assert chain.run_chain(config, options) == 0
    stage = chain.LEGACY_STAGES[0]
    directory = options.output_root / "llama" / stage
    result_path = directory / "result.json"
    result = json.loads(result_path.read_text())
    for key in ("native_top5", "native_controls"):
        for record in result[key]["records"]:
            record["numeric"] = "incomplete"
    write_json(result_path, result)

    spec = importlib.util.spec_from_file_location(
        "parallel_recovery_tested", SCRIPT.with_name("run_neighborhood_parallel_recovery.py")
    )
    assert spec is not None and spec.loader is not None
    monkeypatch.setitem(sys.modules, "run_neighborhood_stage_chain", chain)
    recovery = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(recovery)
    config_path = tmp_path / "config.json"
    write_json(config_path, config)
    command_path = tmp_path / "command.json"
    write_json(command_path, [sys.executable, str(SCRIPT)])
    monkeypatch.setattr(chain, "_parse_args", lambda _: (options, config_path))
    retry = FakeRunner(fail=("llama", stage) if retry_fails else None)
    monkeypatch.setattr(chain, "_run_logged", retry)

    assert recovery.run(command_path, "llama", 4) == (2 if retry_fails else 0)
    assert len(retry.calls) == 1
    assert "--skip-search" in retry.calls[0][2]
    progress = json.loads((options.output_root / "parallel/llama/progress.json").read_text())
    assert "existing_validation_incomplete" in progress["stages"][stage]
    later = progress["stages"][chain.LEGACY_STAGES[1]]["status"]
    assert later == ("blocked" if retry_fails else "reused")


def test_resume_skips_completed_stages_and_control_winner_is_forwarded(tmp_path, monkeypatch):
    workloads = ("llama",)
    config, options = setup_inputs(tmp_path, workloads)
    runner = FakeRunner()
    monkeypatch.setattr(chain, "_run_logged", runner)
    assert chain.run_chain(config, options) == 0
    replay_calls = [call for call in runner.calls if call[0] == "llama"]
    assert [(item[0], item[1]) for item in replay_calls] == [
        ("llama", stage) for stage in chain.LEGACY_STAGES
    ]
    winner = json.loads((options.output_root / "llama" / chain.LEGACY_STAGES[0] /
                         "previous-winner.jsonl").read_text().splitlines()[0])
    assert winner["record_type"] == "control"
    assert winner["control_role"] == "identity"
    assert "identity-control" in winner["candidate_id"]
    stage2_call = next(item for item in replay_calls if item[1] == chain.LEGACY_STAGES[1])
    previous = Path(runner._arg(stage2_call[2], "--previous-winner"))
    assert json.loads(previous.read_text().splitlines()[0])["candidate_id"] == winner["candidate_id"]

    runner.calls.clear()
    assert chain.run_chain(config, options) == 0
    assert [call for call in runner.calls if call[0] == "llama"] == []
    state = json.loads((options.output_root / "chain-progress.json").read_text())
    assert state["status"] == "complete"


def test_failed_stage_is_durable_and_other_workload_continues_in_order(tmp_path, monkeypatch):
    workloads = ("llama", "lu")
    config, options = setup_inputs(tmp_path, workloads)
    runner = FakeRunner(fail=("llama", "shape-temporal-replica"))
    monkeypatch.setattr(chain, "_run_logged", runner)
    assert chain.run_chain(config, options) == 2
    calls = [(workload, stage) for workload, stage, _ in runner.calls
             if workload != "table"]
    assert calls == [
        ("llama", "shape-only"), ("llama", "shape-temporal"),
        ("llama", "shape-temporal-replica"),
        *[("lu", stage) for stage in chain.LEGACY_STAGES],
    ]
    failed = options.output_root / "llama" / "shape-temporal-replica" / "result.json"
    value = json.loads(failed.read_text())
    assert value["status"] == "incomplete"
    assert value["stop_reason"] == "mocked-search-failure"
    assert not (options.output_root / "llama" / "shape-temporal-replica-tiling" /
                "result.json").exists()
    state = json.loads((options.output_root / "chain-progress.json").read_text())
    assert state["status"] == "incomplete"
    assert state["workloads"]["lu"]["status"] == "complete"


def _run_complete_fixture(tmp_path: Path, monkeypatch, *, config: dict,
                          options: chain.ChainOptions) -> FakeRunner:
    """Create a complete fake chain and return the runner for assertions."""
    runner = FakeRunner()
    monkeypatch.setattr(chain, "_run_logged", runner)
    assert chain.run_chain(config, options) == 0
    return runner


def assert_no_hash_identity(value: object) -> None:
    """The contract uses direct byte comparison; no digest key is emitted."""
    if isinstance(value, dict):
        for key, child in value.items():
            assert str(key).lower() not in {"hash", "sha", "sha1", "sha256", "digest"}
            assert_no_hash_identity(child)
    elif isinstance(value, list):
        for child in value:
            assert_no_hash_identity(child)


def test_contract_snapshot_rejects_same_path_byte_mutations(tmp_path, monkeypatch):
    """A continuation is bound to bytes, not merely to input path names."""
    targets = ("protocol", "source_contract_file", "optimizer", "architecture", "canonical")
    for target in targets:
        case = tmp_path / target
        case.mkdir()
        config, options = setup_inputs(case, ("llama",))
        _run_complete_fixture(case, monkeypatch, config=config, options=options)
        manifest = json.loads(
            (options.output_root / chain.CONTRACT_DIR / "contract-manifest.json").read_text())
        assert manifest["identity_policy"] == "direct byte comparison; no hash"
        assert_no_hash_identity(manifest)

        if target == "canonical":
            path = case / "canonical.mlir"
        else:
            path = getattr(options, target)
        path.write_text(path.read_text() + "changed\n")
        with pytest.raises(chain.ChainError, match="immutable chain input bytes changed"):
            chain.run_chain(config, options)


def test_shared_contract_snapshots_include_parent_cost_and_recursive_model_but_not_mutable_cache(
        tmp_path, monkeypatch):
    config, options = setup_inputs(tmp_path, ("llama",))
    parent_cost = tmp_path / "parent-costs.json"
    parent_cost.write_text("parent-cost-v1\n")
    model = tmp_path / "ensemble.json"
    weights = tmp_path / "weights.json"
    weights.write_text(json.dumps({"version": 1}) + "\n")
    model.write_text(json.dumps({"weights": "weights.json"}) + "\n")
    mutable_cache = tmp_path / "mutable-cost-cache.json"
    mutable_cache.write_text("cache-v1\n")
    config["workloads"]["llama"]["parent_cost_file"] = str(parent_cost)
    config["workloads"]["llama"]["model_cache"] = str(model)
    options = chain.ChainOptions(**{
        **options.__dict__,
        "model_cache": model,
        "cost_cache": mutable_cache,
    })

    _run_complete_fixture(tmp_path, monkeypatch, config=config, options=options)
    manifest_path = options.output_root / chain.CONTRACT_DIR / "contract-manifest.json"
    manifest = json.loads(manifest_path.read_text())
    source_paths = {source["path"] for source in manifest["sources"]}
    assert str(options.optimizer) in source_paths
    assert str(options.protocol) in source_paths
    assert str(options.source_contract_file) in source_paths
    assert str(tmp_path / "canonical.mlir") in source_paths
    assert str(parent_cost) in source_paths
    assert str(model) in source_paths
    assert str(weights) in source_paths
    assert str(mutable_cache) not in source_paths
    assert_no_hash_identity(manifest)
    for source in manifest["sources"]:
        snapshot = Path(source["snapshot"])
        assert snapshot.is_file()
        assert snapshot.read_bytes() == Path(source["path"]).read_bytes()

    # Runtime cost-cache contents are intentionally mutable and do not change
    # the continuation binding.  The completed stages should be reused.
    mutable_cache.write_text("cache-v2\n")
    runner = FakeRunner()
    monkeypatch.setattr(chain, "_run_logged", runner)
    assert chain.run_chain(config, options) == 0
    assert [call for call in runner.calls if call[0] == "llama"] == []


def test_numeric_failure_cannot_supply_the_forwarded_winner(tmp_path):
    runner = FakeRunner()
    config, options = setup_inputs(tmp_path, ("llama",))
    stage_dir = options.output_root / "llama" / chain.LEGACY_STAGES[0]
    command = runner([
        "python", "replay", "--workload", "llama", "--stage", chain.LEGACY_STAGES[0],
        "--output-dir", str(stage_dir)], stage_dir, "replay")
    assert command["exit_code"] == 0
    result = json.loads((stage_dir / "result.json").read_text())
    result["native_top5"]["records"][0]["native_cycles"] = 1
    result["native_top5"]["records"][0]["numeric"] = "fail"
    result["native_top5"]["records"][1]["native_cycles"] = 2
    result["native_top5"]["records"][1]["numeric"] = "pass"
    result["native_controls"]["records"][0]["native_cycles"] = 3
    measured, row = chain.choose_measured_winner(result)
    assert measured["candidate_id"].endswith("top-1")
    assert row["candidate_id"].endswith("top-1")

    for record in result["native_top5"]["records"]:
        record["numeric"] = "fail"
    result["native_controls"]["records"][0]["numeric"] = "fail"
    with pytest.raises(chain.ChainError, match="no native-replayed candidate"):
        chain.choose_measured_winner(result)


def test_start_stage_runs_only_suffix_with_external_previous_winner(tmp_path, monkeypatch):
    config, options = setup_inputs(tmp_path, ("llama", "lu"))
    options = chain.ChainOptions(**{
        **options.__dict__,
        "start_stage": chain.LEGACY_STAGES[2],
    })
    previous = tmp_path / "previous-winner.jsonl"
    previous.write_text(json.dumps({"record_type": "selection",
                                    "candidate_id": "external",
                                    "graph_variant_id": "external-graph"}) + "\n")
    for workload in options.workloads:
        config["workloads"][workload]["stages"] = {
            chain.LEGACY_STAGES[2]: {"previous_winner": str(previous)}
        }
    runner = _run_complete_fixture(tmp_path, monkeypatch, config=config, options=options)
    calls = [(workload, stage) for workload, stage, _ in runner.calls
             if workload != "table"]
    assert calls == [
        *[(workload, stage) for workload in options.workloads for stage in chain.LEGACY_STAGES[2:]]
    ]
    state = json.loads((options.output_root / "chain-progress.json").read_text())
    for workload in options.workloads:
        stages = state["workloads"][workload]["stages"]
        assert stages[chain.LEGACY_STAGES[0]]["status"] == "outside-start"
        assert stages[chain.LEGACY_STAGES[1]]["status"] == "outside-start"
        assert all(stages[stage]["status"] == "complete" for stage in chain.LEGACY_STAGES[2:])


def test_network_override_bytes_bind_stage_and_replay(tmp_path):
    config, options = setup_inputs(tmp_path, ("gcn",))
    network = tmp_path / "network.yaml"
    network.write_text("inter_task_network: original\n")
    options = chain.ChainOptions(**{**options.__dict__, "inter_task_network": network})
    entry = config["workloads"]["gcn"]
    expected = chain.expected_binding(entry, "gcn", chain.LEGACY_STAGES[0], options, config_base=tmp_path)
    source = {**expected, "source_commit": chain._protocol_source_commit(expected)}
    assert chain._compatible_source_binding(source, expected)
    mutated = {**source, "inter_task_network_text": "inter_task_network: changed\n"}
    assert not chain._compatible_source_binding(mutated, expected)
    assert not chain._compatible_source_binding({key: value for key, value in source.items() if not key.startswith("inter_task_network")}, expected)
    command = chain._build_replay_command(entry=entry, workload="gcn", stage=chain.LEGACY_STAGES[0], options=options, config_base=tmp_path, stage_dir=tmp_path / "stage", previous_winner=None, resume=False, skip_search=False)
    assert command[command.index("--inter-task-network") + 1] == str(network)


def test_workload_architecture_and_protocol_overrides_are_pinned_and_forwarded(tmp_path):
    config, options = setup_inputs(tmp_path, ("raytracing", "gcn"))
    ray_architecture = tmp_path / "architecture-ii23.yaml"
    ray_architecture.write_text("ctrlmem_ii_limit: 23\n")
    ray_protocol = tmp_path / "protocol-ii23.json"
    protocol = json.loads(options.protocol.read_text())
    protocol["search"] = {
        "diagnostic_ii_ceiling": 23,
        "supported_shape_bootstrap_policy":
            "minimum-area-supported-model-shape-v1",
    }
    write_json(ray_protocol, protocol)
    config["workloads"]["raytracing"].update({
        "architecture": str(ray_architecture),
        "protocol": str(ray_protocol),
    })
    chain._validate_options(options, config, config_base=tmp_path)

    ray = config["workloads"]["raytracing"]
    expected = chain.expected_binding(
        ray, "raytracing", chain.LEGACY_STAGES[0], options, config_base=tmp_path)
    assert expected["architecture"] == str(ray_architecture.resolve())
    assert expected["protocol"] == str(ray_protocol.resolve())
    assert expected["diagnostic_ii_ceiling"] == 23

    command = chain._build_replay_command(
        workload="raytracing", stage=chain.LEGACY_STAGES[0], entry=ray,
        options=options, config_base=tmp_path, stage_dir=tmp_path / "ray-stage",
        previous_winner=None, resume=True, skip_search=False)
    assert command[command.index("--architecture") + 1] == str(ray_architecture.resolve())
    assert command[command.index("--protocol") + 1] == str(ray_protocol.resolve())
    assert command[command.index("--resume") + 1] == str((tmp_path / "ray-stage" / "checkpoint.json").resolve())

    default = chain.expected_binding(
        config["workloads"]["gcn"], "gcn", chain.LEGACY_STAGES[0], options,
        config_base=tmp_path)
    assert default["architecture"] == str(options.architecture.resolve())
    assert default["protocol"] == str(options.protocol.resolve())
    assert "diagnostic_ii_ceiling" not in default

    specs = chain._contract_specs(config, options, config_base=tmp_path)
    pinned = {item["path"]: item for item in specs}
    for path, kind in ((ray_architecture.resolve(), "architecture"),
                       (ray_protocol.resolve(), "protocol")):
        assert kind in pinned[str(path)]["kinds"]
        assert {"workload": "raytracing", "stage": None} in pinned[str(path)]["contexts"]

    source = {**expected, "source_commit": protocol["source_commit"],
              "stage_initialization": options.stage_initialization}
    assert chain._compatible_source_binding(source, expected)
    assert not chain._compatible_source_binding(
        {**source, "diagnostic_ii_ceiling": 20}, expected)
    assert not chain._compatible_source_binding(
        {**source, "protocol": str(options.protocol.resolve())}, expected)

    binding_path = tmp_path / "ray-stage" / "chain-binding.json"
    chain.atomic_write(binding_path, expected)
    assert chain._stage_binding_matches(binding_path, expected)
    chain.atomic_write(binding_path, {**expected, "diagnostic_ii_ceiling": 20})
    assert not chain._stage_binding_matches(binding_path, expected)

    chain._ensure_contract_snapshot(
        options.output_root,
        chain._contract_specs(config, options, config_base=tmp_path))
    protocol["search"]["diagnostic_ii_ceiling"] = 20
    write_json(ray_protocol, protocol)
    with pytest.raises(chain.ChainError, match="immutable chain input bytes changed"):
        chain._ensure_contract_snapshot(
            options.output_root,
            chain._contract_specs(config, options, config_base=tmp_path))


def test_full_joint_fission_is_an_independent_pinned_stage_with_native_options(tmp_path):
    from dataclasses import replace

    config, options = setup_inputs(tmp_path, ("llama",))
    prepared = tmp_path / "llama-pre-neura.mlir"
    prepared.write_text('module { func.func @main() {} }\n', encoding="utf-8")
    config["workloads"]["llama"]["prepared_source_file"] = str(prepared)
    protocol = json.loads(options.protocol.read_text())
    protocol.update({
        "stage_scheme": chain.FISSION_STAGE,
        "stages": list(chain.FISSION_STAGES),
        "search": {"stage_initialization": "independent",
                   "max_fission_actions_per_task": 64,
                   "max_partition_factor": 8},
    })
    write_json(options.protocol, protocol)
    options = replace(options, stage_initialization="independent",
                      start_stage=chain.FISSION_STAGE)
    chain._validate_options(options)
    chain.validate_stage_inputs(config, options, config_base=tmp_path)
    contract_manifest = chain._ensure_contract_snapshot(
        options.output_root,
        chain._contract_specs(config, options, config_base=tmp_path))

    expected = chain.expected_binding(
        config["workloads"]["llama"], "llama", chain.FISSION_STAGE,
        options, config_base=tmp_path, contract_manifest=contract_manifest)
    assert expected["stage_scheme"] == chain.FISSION_STAGE
    assert expected["prepared_source_file"] == str(prepared.resolve())
    assert Path(expected["prepared_source_snapshot"]).read_bytes() == prepared.read_bytes()
    assert expected["prepared_source_size_bytes"] == prepared.stat().st_size
    assert expected["max_fission_actions_per_task"] == 64

    source_binding = {
        "canonical_program": expected["canonical_program"],
        "optimizer": expected["optimizer"],
        "architecture": expected["architecture"],
        "protocol": expected["protocol"],
        "model_cache": expected["model_cache"], "cost_cache": expected["cost_cache"],
        "parent_cost_file": expected["parent_cost_file"],
        "source_commit": chain._protocol_source_commit(expected),
        "protocol_schema": expected["protocol_schema"],
        "source_contract_file": expected["source_contract_file"],
        "stage_initialization": "independent",
        "prepared_source_file": str(prepared.resolve()),
        "prepared_source_exact_text": prepared.read_text(encoding="utf-8"),
        "prepared_source_size_bytes": prepared.stat().st_size,
        "max_fission_actions_per_task": 64,
    }
    assert chain._compatible_source_binding(source_binding, expected)
    assert not chain._compatible_source_binding(
        {**source_binding, "prepared_source_exact_text": "changed"}, expected)

    command = chain._build_replay_command(
        workload="llama", stage=chain.FISSION_STAGE,
        entry=config["workloads"]["llama"], options=options,
        config_base=tmp_path, stage_dir=options.output_root / "llama" / chain.FISSION_STAGE,
        previous_winner=None, resume=False, skip_search=False)
    assert command[command.index("--stage-initialization") + 1] == "independent"
    assert command[command.index("--prepared-source-file") + 1] == str(prepared.resolve())
    assert command[command.index("--max-fission-actions-per-task") + 1] == "64"
    assert "--previous-winner" not in command and "--seed-manifest" not in command

    config["workloads"]["llama"].pop("prepared_source_file")
    with pytest.raises(chain.ChainError, match="prepared_source_file is missing"):
        chain.validate_stage_inputs(config, options, config_base=tmp_path)


def independent_options(options, **kwargs):
    from dataclasses import replace
    return replace(options, stage_initialization="independent", **kwargs)


def test_independent_stages_all_start_from_same_canonical_without_winner(tmp_path, monkeypatch):
    config, options = setup_inputs(tmp_path, ("llama",))
    options = independent_options(options)
    runner = FakeRunner()
    monkeypatch.setattr(chain, "_run_logged", runner)
    assert chain.run_chain(config, options) == 0
    calls = [argv for workload, _, argv in runner.calls if workload != "table"]
    assert len(calls) == 5
    assert {runner._arg(argv, "--canonical") for argv in calls} == {config["workloads"]["llama"]["canonical"]}
    assert len({runner._arg(argv, "--checkpoint") for argv in calls}) == 5
    for argv in calls:
        assert runner._arg(argv, "--stage-initialization") == "independent"
        assert not {"--previous-winner", "--seed-manifest", "--resume", "--skip-search"} & set(argv)
    for stage in chain.LEGACY_STAGES:
        launch = json.loads((options.output_root / "llama" / stage / "launch.json").read_text())
        assert launch["previous_winner"] is None
        assert launch["stage_initialization"] == "independent"


def test_independent_stage_can_start_at_s5_and_continue_after_failed_stage(tmp_path, monkeypatch):
    config, options = setup_inputs(tmp_path, ("llama",))
    options = independent_options(options, start_stage="full-joint")
    runner = FakeRunner()
    monkeypatch.setattr(chain, "_run_logged", runner)
    assert chain.run_chain(config, options) == 0
    assert [(workload, stage) for workload, stage, _ in runner.calls if workload != "table"] == [("llama", "full-joint")]
    options = independent_options(options, start_stage="shape-only", output_root=tmp_path / "new-run")
    runner = FakeRunner(fail=("llama", "shape-only"))
    monkeypatch.setattr(chain, "_run_logged", runner)
    assert chain.run_chain(config, options) == 2
    assert [stage for workload, stage, _ in runner.calls if workload != "table"] == list(chain.LEGACY_STAGES)


@pytest.mark.parametrize("seed_key", ["seed_manifest", "previous_winner", "historical_native_winner", "reuse_result"])
def test_independent_stages_reject_imported_seeds_and_results(tmp_path, seed_key):
    config, options = setup_inputs(tmp_path, ("llama",))
    config["workloads"]["llama"].setdefault("stages", {})["full-joint"] = {seed_key: "historical.jsonl"}
    with pytest.raises(chain.ChainError, match="cannot import"):
        chain.run_chain(config, independent_options(options))
    assert not options.output_root.exists()


def test_independent_stages_reject_different_canonical_and_old_binding(tmp_path, monkeypatch):
    config, options = setup_inputs(tmp_path, ("llama",))
    config["workloads"]["llama"]["stages"] = {"full-joint": {"canonical": "previous-stage.mlir"}}
    with pytest.raises(chain.ChainError, match="same canonical"):
        chain.run_chain(config, independent_options(options))
    config["workloads"]["llama"].pop("stages")
    monkeypatch.setattr(chain, "_run_logged", FakeRunner())
    assert chain.run_chain(config, options) == 0
    with pytest.raises(chain.ChainError, match="binding differs"):
        chain.run_chain(config, independent_options(options))
