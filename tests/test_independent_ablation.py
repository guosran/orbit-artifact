"""Independent ablations reject imported search state before C++ or mapper work."""
from pathlib import Path
import sys
import pytest
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import neighborhood_replay as replay


def test_protocol_defaults_to_independent_and_rejects_policy_override():
    protocol = {"search": {"stage_initialization": "independent"}}
    assert replay.stage_initialization_policy(protocol) == "independent"
    with pytest.raises(replay.ContractError, match="differs"):
        replay.stage_initialization_policy(protocol, "previous-winner")


@pytest.mark.parametrize("key", ["seed_manifest", "previous_winner", "historical_native_winner"])
def test_independent_replay_rejects_every_seed_input(key):
    with pytest.raises(replay.ContractError, match="cannot import"):
        replay.stage_initialization_policy({}, "independent", **{key: Path("old-stage.jsonl")})
    with pytest.raises(replay.ContractError, match="cannot import"):
        replay.stage_initialization_policy({"historical_native_winners": {"lu": "old.jsonl"}}, "independent")


def test_all_stage_search_commands_are_unseeded_and_keep_full_budget():
    for stage in replay.STAGES:
        command = replay.build_search_command(
            optimizer=Path("opt"), canonical=Path("original.mlir"), output_dir=Path(stage),
            function="main", stage=stage, architecture=Path("arch.yaml"),
            protocol={"search": {"stage_initialization": "independent"}},
            checkpoint=Path(stage) / "checkpoint.json", seed_manifest=None,
            previous_winner=None, parent_cost_file=None, model_cache=None, cost_cache=None,
            max_rounds=4, max_candidates=4096, beam_width=16, diversity_slots=4, resume=None)
        options = next(item for item in command if item.startswith("--search-joint-neighborhood="))
        assert f"stage={stage}" in options
        assert "max-rounds=4" in options and "max-candidates=4096" in options
        assert not any(key in options for key in ["previous-winner=", "seed-manifest=", "historical-native-winner=", "resume="])
        assert command[1] == "original.mlir"
