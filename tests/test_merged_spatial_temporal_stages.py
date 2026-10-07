"""Four-stage runs bind their numbering and independently launch every dimension."""
from dataclasses import replace
import json

import pytest

from test_neighborhood_stage_chain import chain, setup_inputs, FakeRunner, write_json


def merged_inputs(tmp_path):
    config, options = setup_inputs(tmp_path, ("lu",))
    protocol = json.loads(options.protocol.read_text())
    protocol["stages"] = list(chain.STAGES)
    protocol["stage_scheme"] = "merged-spatial-temporal"
    protocol["search"] = {"stage_initialization": "independent"}
    write_json(options.protocol, protocol)
    return config, replace(options, stage_initialization="independent", start_stage=None)


def test_four_stages_are_fresh_complete_program_runs(tmp_path, monkeypatch):
    config, options = merged_inputs(tmp_path)
    runner = FakeRunner()
    monkeypatch.setattr(chain, "_run_logged", runner)
    assert chain.run_chain(config, options) == 0
    calls = [row for row in runner.calls if row[0] != "table"]
    assert [stage for _, stage, _ in calls] == list(chain.STAGES)
    assert len(calls) == 4 and "shape-only" not in chain.STAGES
    for _, stage, argv in calls:
        assert runner._arg(argv, "--canonical") == config["workloads"]["lu"]["canonical"]
        assert not {"--previous-winner", "--seed-manifest", "--resume", "--skip-search"} & set(argv)
        binding = json.loads((options.output_root / "lu" / stage / "chain-binding.json").read_text())
        assert binding["stage_scheme"] == "merged-spatial-temporal"
        assert binding["stage_order"] == list(chain.STAGES)
    state = json.loads(chain._state_path(options.output_root).read_text())
    assert state["binding"]["stages"] == list(chain.STAGES)


def test_historical_protocol_keeps_five_stage_numbering(tmp_path):
    _, options = setup_inputs(tmp_path, ("lu",))
    assert chain.stage_order(options) == chain.LEGACY_STAGES
    assert len(chain.stage_order(options)) == 5


def test_fixed_dispatch_stage_cannot_enter_merged_chain(tmp_path):
    _, options = merged_inputs(tmp_path)
    with pytest.raises(chain.ChainError, match="unknown start stage"):
        chain._validate_options(replace(options, start_stage="shape-only"))


def test_protocol_cannot_silently_change_stage_order(tmp_path):
    with pytest.raises(chain.ChainError, match="merged four-stage, historical five-stage, or canonical fission stage order"):
        chain.protocol_stages({"stages": list(reversed(chain.STAGES))})


def test_parallel_recovery_uses_bound_four_stage_order(tmp_path, monkeypatch):
    import sys
    sys.path.insert(0, str(chain.ROOT / "scripts"))
    import run_neighborhood_parallel_recovery as recovery
    monkeypatch.setattr(recovery, "chain", chain)
    config, options = merged_inputs(tmp_path)
    runner = FakeRunner()
    monkeypatch.setattr(chain, "_run_logged", runner)
    config_path = tmp_path / "chain-config.json"
    write_json(config_path, config)
    argv = ["python3", "run_neighborhood_stage_chain.py", "--config", str(config_path)]
    for flag, value in [("--output-root", options.output_root), ("--protocol", options.protocol),
                        ("--source-contract-file", options.source_contract_file),
                        ("--optimizer", options.optimizer), ("--architecture", options.architecture),
                        ("--mapping-cache", options.mapping_cache), ("--replay-script", options.replay_script),
                        ("--table-script", options.table_script)]:
        argv.extend([flag, str(value)])
    argv.extend(["--workloads", "lu", "--stage-initialization", "independent"])
    command_file = tmp_path / "command.json"
    write_json(command_file, argv)
    assert recovery.run(command_file, "lu", 1) == 0
    assert [stage for workload, stage, _ in runner.calls if workload != "table"] == list(chain.STAGES)
    for _, _, command in runner.calls:
        assert "--previous-winner" not in command
