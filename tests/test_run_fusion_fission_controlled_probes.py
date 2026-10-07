"""Lightweight contracts for the explicit diagnostic probe launcher."""
from __future__ import annotations

import importlib.util
import json
import copy
from pathlib import Path
import sys
from types import SimpleNamespace

import pytest


SCRIPT = (Path(__file__).resolve().parents[1] /
          "scripts/run_fusion_fission_controlled_probes.py")
SPEC = importlib.util.spec_from_file_location("controlled_probes_tested", SCRIPT)
assert SPEC is not None and SPEC.loader is not None
probes = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = probes
SPEC.loader.exec_module(probes)


def test_fusion_controls_preserve_the_parent_pair_resource_count():
    pc = probes.fusion_actions(probes.WORKLOAD_CONTROLS["harris"],
                               "Task_0.fuse.Task_1")
    sibling = probes.fusion_actions(probes.WORKLOAD_CONTROLS["radar-sibling"],
                                    "Task_4.fuse.Task_5")

    assert pc[0]["family"] == "fusion"
    assert pc[0]["primitives"][0]["mode"] == "producer-consumer-retained"
    assert pc[0]["primitives"][0]["firstTask"] == "Task_0"
    assert pc[0]["primitives"][0]["secondTask"] == "Task_1"
    assert pc[1]["shapeTask"] == "Task_0.fuse.Task_1"
    assert pc[1]["shapeRows"] * pc[1]["shapeCols"] == 2
    assert sibling[0]["family"] == "sibling-fusion"
    assert sibling[0]["primitives"][0]["mode"] == "sibling"
    assert sibling[1]["shapeRows"] * sibling[1]["shapeCols"] == 2


def test_cut_selection_uses_only_source_census_legal_rows():
    census = {"tasks": [
        {"task": "Task_0", "status": "unsupported", "left_nodes": [[0]]},
        {"task": "Task_1", "status": "supported", "left_nodes": [[0, 2], [1]]},
    ]}
    assert probes._first_legal_cut(census) == ("Task_1", [0, 2])
    assert probes._first_legal_cut(census, "Task_1") == ("Task_1", [0, 2])


def test_search_command_has_only_explicit_diagnostic_seeds_and_budget(tmp_path):
    captured = {}

    def build_search_command(**kwargs):
        captured.update(kwargs)
        return ["optimizer", "--search-joint-neighborhood=output-dir=search"]

    nr = SimpleNamespace(build_search_command=build_search_command)
    paths = {name: tmp_path / name for name in
             ("optimizer", "canonical.mlir", "search", "architecture.yaml",
              "protocol.json", "contract.json", "model.json", "parent.json",
              "network.yaml", "seeds.jsonl", "checkpoint.json")}
    argv = probes._diagnostic_search_command(
        nr, optimizer=paths["optimizer"], canonical=paths["canonical.mlir"],
        output_dir=paths["search"], function="main", stage="full-joint",
        architecture=paths["architecture.yaml"], protocol={},
        protocol_path=paths["protocol.json"], source_contract=paths["contract.json"],
        model_cache=paths["model.json"], cost_cache=None,
        parent_cost_file=paths["parent.json"],
        inter_task_network=paths["network.yaml"], workload="harris",
        seed_manifest=paths["seeds.jsonl"], candidate_budget=2,
        prepared_source=None, fission_cap=None,
        checkpoint=paths["checkpoint.json"])

    assert "seed-manifest=" + str(paths["seeds.jsonl"]) in argv[-1]
    assert captured["seed_manifest"] is None
    assert captured["stage_initialization"] == "independent"
    assert captured["max_rounds"] == 1
    assert captured["max_candidates"] == 2
    assert captured["beam_width"] == captured["diversity_slots"] == 1


def _captured_r10c_common_protocol():
    # Search/execution budget fields taken from the actual bound R10c protocol.
    return {
        "schema": "orbit-amoeba-input0-neighborhood-v3",
        "source_commit": "45cef07ffa91f289398bcd82bbd0f9207f021a55",
        "stage_scheme": "full-joint-fission",
        "scheduler": {"backend": "orbit-production",
                      "dispatch_policy": "critical-path",
                      "timing": "common-explicit-network"},
        "execution": {"scoring_workers": 4, "cpus_per_lane": 4},
        "search": {
            "max_rounds": 4,
            "max_unique_complete_candidates_scored": 4096,
            "beam_width": 16,
            "diversity_min_slots": 4,
            "max_partition_factor": 8,
            "native_shortlist": 5,
            "max_fission_actions_per_task": 64,
            "diagnostic_ii_ceiling": 20,
            "supported_shape_bootstrap_policy":
                "minimum-area-supported-model-shape-v1",
        },
    }


@pytest.mark.parametrize("candidate_budget", [2, 3])
def test_r10c_diagnostic_protocol_matches_every_cpp_budget_without_touching_main(
        tmp_path, candidate_budget):
    main = _captured_r10c_common_protocol()
    original = copy.deepcopy(main)
    path, diagnostic, receipt = probes._write_diagnostic_protocol(
        main, output_dir=tmp_path, candidate_budget=candidate_budget)
    options = {"max_rounds": 1, "max_candidates": candidate_budget,
               "beam_width": 1, "diversity_slots": 1,
               "max_partition_factor": 8}

    probes._validate_search_budget_binding(diagnostic, options)
    assert json.loads(path.read_text(encoding="utf-8")) == diagnostic
    assert main == original
    expected = copy.deepcopy(original)
    expected["search"].update(
        max_rounds=1,
        max_unique_complete_candidates_scored=candidate_budget,
        beam_width=1,
        diversity_min_slots=1)
    assert diagnostic == expected
    assert probes._protocol_search_budget(original) == {
        "max_rounds": 4,
        "max_unique_complete_candidates_scored": 4096,
        "beam_width": 16,
        "diversity_min_slots": 4,
        "max_partition_factor": 8,
        "native_shortlist": 5,
        "max_fission_actions_per_task": 64,
        "diagnostic_ii_ceiling": 20,
        "round_score_quota": None,
    }
    assert probes._protocol_search_budget(diagnostic) == {
        "max_rounds": 1,
        "max_unique_complete_candidates_scored": candidate_budget,
        "beam_width": 1,
        "diversity_min_slots": 1,
        "max_partition_factor": 8,
        "native_shortlist": 5,
        "max_fission_actions_per_task": 64,
        "diagnostic_ii_ceiling": 20,
        "round_score_quota": None,
    }
    assert receipt["protocol_execution_budget"] == {"scoring_workers": 4}
    assert receipt["cxx_search_options"] == options
    assert receipt["main_curve_budget_changed"] is False
    assert receipt["scored_candidate_composition"] == {
        "identity": 1, "explicit_control_seeds": candidate_budget - 1,
        "total": candidate_budget}


@pytest.mark.parametrize(("option", "protocol_field"), [
    ("max_rounds", "max_rounds"),
    ("max_candidates", "max_unique_complete_candidates_scored"),
    ("beam_width", "beam_width"),
    ("diversity_slots", "diversity_min_slots"),
    ("max_partition_factor", "max_partition_factor"),
])
def test_r10c_cpp_budget_guard_checks_each_protocol_bound_field(option,
                                                                protocol_field):
    protocol = _captured_r10c_common_protocol()
    options = {"max_rounds": 4, "max_candidates": 4096,
               "beam_width": 16, "diversity_slots": 4,
               "max_partition_factor": 8}
    probes._validate_search_budget_binding(protocol, options)
    options[option] += 1
    with pytest.raises(probes.ProbeError, match=protocol_field):
        probes._validate_search_budget_binding(protocol, options)


def test_r10c_main_curve_protocol_rejects_old_bounded_cli_options():
    # This is the exact R10c mismatch: bounded command values were paired with
    # the unmodified 4/4096/16/4 main protocol and C++ failed before search.
    main = _captured_r10c_common_protocol()
    old_cli = {"max_rounds": 1, "max_candidates": 2,
               "beam_width": 1, "diversity_slots": 1,
               "max_partition_factor": 8}
    with pytest.raises(probes.ProbeError, match="search budgets do not match"):
        probes._validate_search_budget_binding(main, old_cli)


def test_body_statistics_are_read_only_counts_from_generic_cpp_output(tmp_path):
    candidate = tmp_path / "candidate.mlir"
    candidate.write_text('''module {
  "taskflow.task"() <{task_name = "Task_0"}> ({
    %893 = "neura.load_indexed"(%891, %892) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input0"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>
    "neura.store_indexed"(%912, %913, %914) <{operandSegmentSizes = array<i32: 1, 0, 2>}> {rhs_value = "%input6"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()
  }) : () -> ()
}
''', encoding="utf-8")

    stats = probes.body_statistics(candidate)
    assert stats["Task_0"]["loads"] == 1
    assert stats["Task_0"]["stores"] == 1
    assert stats["Task_0"]["operation_count"] == 2
    assert stats["Task_0"]["body_bytes"] > 0


def test_captured_harris_and_radar_task_fragments_count_real_post_neura_memory_ops(tmp_path):
    # Exact generic operation lines captured from the read-only Harris/Radar
    # canonical task bodies. These protect the post-Neura ld/st accounting
    # used by the live experiment.
    tasks = {
        "Task_0": [
            '%893 = "neura.load_indexed"(%891, %892) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input0"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>',
            '%898 = "neura.load_indexed"(%896, %897) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>',
            '%906 = "neura.load_indexed"(%904, %905) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input4"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>',
            '"neura.store_indexed"(%912, %913, %914) <{operandSegmentSizes = array<i32: 1, 0, 2>}> {rhs_value = "%input6"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()',
        ],
        "Task_1": [
            '%821 = "neura.load_indexed"(%819, %820) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input0"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>',
            '"neura.store_indexed"(%881, %882, %883) <{operandSegmentSizes = array<i32: 1, 0, 2>}> {rhs_value = "%input4"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()',
        ],
        "Task_16": [
            '%202 = "neura.load_indexed"(%200, %201) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input0"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>',
            '%205 = "neura.load_indexed"(%203, %204) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>',
            '"neura.store_indexed"(%211, %212, %213) <{operandSegmentSizes = array<i32: 1, 0, 2>}> {rhs_value = "%input2"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()',
        ],
        "Task_17": [
            '%155 = "neura.load_indexed"(%153, %154) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input0"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>',
            '%160 = "neura.load_indexed"(%158, %159) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input0"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>',
            '%170 = "neura.load_indexed"(%168, %169) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input0"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>',
            '%181 = "neura.load_indexed"(%179, %180) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>',
            '"neura.store_indexed"(%188, %189, %190) <{operandSegmentSizes = array<i32: 1, 0, 2>}> {rhs_value = "%input2"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()',
        ],
        "Task_4": [
            '%729 = "neura.load_indexed"(%727, %728) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input0"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>',
            '%732 = "neura.load_indexed"(%730, %731) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>',
            '%741 = "neura.load_indexed"(%739, %740) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>',
            '%744 = "neura.load_indexed"(%742, %743) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input3"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>',
            '"neura.store_indexed"(%769, %770, %771) <{operandSegmentSizes = array<i32: 1, 0, 2>}> {rhs_value = "%input5"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()',
        ],
        "Task_5": [
            '%659 = "neura.load_indexed"(%657, %658) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input0"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>',
            '%662 = "neura.load_indexed"(%660, %661) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input1"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>',
            '%671 = "neura.load_indexed"(%669, %670) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input2"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>',
            '%674 = "neura.load_indexed"(%672, %673) <{operandSegmentSizes = array<i32: 0, 2>}> {lhs_value = "%input3"} : (!neura.data<index, i1>, !neura.data<index, i1>) -> !neura.data<i32, i1>',
            '"neura.store_indexed"(%699, %700, %701) <{operandSegmentSizes = array<i32: 1, 0, 2>}> {rhs_value = "%input5"} : (!neura.data<i32, i1>, !neura.data<index, i1>, !neura.data<index, i1>) -> ()',
        ],
    }
    module = "module {\n" + "\n".join(
        '  "taskflow.task"() <{task_name = "' + name + '"}> ({\n' +
        "\n".join("    " + operation for operation in operations) +
        "\n  }) : () -> ()"
        for name, operations in tasks.items()) + "\n}\n"
    candidate = tmp_path / "captured-real-memory-ops.mlir"
    candidate.write_text(module, encoding="utf-8")
    stats = probes.body_statistics(candidate)

    def pair(first, second):
        return (stats[first]["loads"] + stats[second]["loads"],
                stats[first]["stores"] + stats[second]["stores"])

    assert pair("Task_0", "Task_1") == (4, 2)
    assert pair("Task_16", "Task_17") == (6, 2)
    assert pair("Task_4", "Task_5") == (8, 2)
    assert stats["Task_17"]["operation_counts"]["neura.load_indexed"] == 4


def test_generic_operation_names_with_multi_result_lhs_are_counted(tmp_path):
    candidate = tmp_path / "multi-result.mlir"
    candidate.write_text('''module {
  "taskflow.task"() <{task_name = "Task_0"}> ({
    %0:2 = "neura.load_indexed"(%arg0, %arg1) : (index, index) -> (i32, i32)
  }) : () -> ()
}
''', encoding="utf-8")
    stats = probes.body_statistics(candidate)
    assert stats["Task_0"]["loads"] == 1
    assert stats["Task_0"]["operation_count"] == 1


def test_cli_accepts_parent_requested_explicit_aliases():
    args = probes._parse_args([
        "--artifactroot", "/a", "--source-root", "/s", "--pin", "pin",
        "--optimizer", "/o", "--contract", "/c", "--protocol", "/p",
        "--config", "/cfg", "--llvm", "/llvm", "--output", "/out",
    ])
    assert args.artifact_root == Path("/a")
    assert args.source_pin == "pin"
    assert args.source_contract == Path("/c")
    assert args.llvm_build == Path("/llvm")
    assert args.output_root == Path("/out")


def test_cli_path_overrides_resolve_from_artifact_root_not_config_base(tmp_path):
    artifact_root = tmp_path / "artifact"
    config_base = artifact_root / "inputs"
    cli_base = artifact_root / "cli-config"
    config_base.mkdir(parents=True)
    (cli_base / "reference").mkdir(parents=True)
    for relative in ("canonical.mlir", "parent-cost.json", "model-cache.json",
                     "configured-architecture.yaml", "configured-network.yaml",
                     "configured-sram.json"):
        (config_base / relative).write_text("{}\n", encoding="utf-8")
    for relative in ("architecture.yaml", "network.yaml", "sram.json"):
        (cli_base / relative).write_text("{}\n", encoding="utf-8")

    config_path = artifact_root / "probe-config.json"
    config_path.write_text(json.dumps({
        "config_base": "inputs",
        "workloads": {"harris": {
            "canonical": "canonical.mlir",
            "parent_cost_file": "parent-cost.json",
            "model_cache": "model-cache.json",
            "architecture": "configured-architecture.yaml",
            "inter_task_network": "configured-network.yaml",
            "sram_config": "configured-sram.json",
            "reference_root": "configured-reference",
        }},
    }), encoding="utf-8")

    # argparse's type=Path is the actual source of the CLI override values.
    args = probes._parse_args([
        "--artifact-root", str(artifact_root), "--source-root", str(tmp_path),
        "--pin", "test-pin", "--optimizer", str(tmp_path / "optimizer"),
        "--source-contract", str(tmp_path / "contract.json"),
        "--protocol", str(tmp_path / "protocol.json"),
        "--config", str(config_path), "--llvm-build", str(tmp_path / "llvm"),
        "--output-root", str(tmp_path / "out"),
        "--architecture", "cli-config/architecture.yaml",
        "--inter-task-network", "cli-config/network.yaml",
        "--sram-config", "cli-config/sram.json",
        "--reference-root", "cli-config/reference",
    ])

    workload = probes.load_workload_config(config_path, artifact_root,
                                           "harris", args)
    assert isinstance(args.architecture, Path)
    assert workload["canonical"] == (config_base / "canonical.mlir").resolve()
    assert workload["parent_cost_file"] == (config_base / "parent-cost.json").resolve()
    assert workload["model_cache"] == (config_base / "model-cache.json").resolve()
    assert workload["architecture"] == (cli_base / "architecture.yaml").resolve()
    assert workload["inter_task_network"] == (cli_base / "network.yaml").resolve()
    assert workload["sram_config"] == (cli_base / "sram.json").resolve()
    assert workload["reference_root"] == (cli_base / "reference").resolve()


def test_task_statistics_include_multi_result_fused_task_headers_from_r10b(tmp_path):
    # Captured R10b fusion headers use a multi-result Taskflow op (`%11:2 =`),
    # which the previous task-span expression skipped entirely.
    candidate = tmp_path / "r10b-multi-result-fused-task.mlir"
    candidate.write_text('''module {
  %11:2 = "taskflow.task"() <{resultSegmentSizes = array<i32: 0, 2, 0>, task_name = "Task_0.fuse.Task_1"}> ({
    %0 = "neura.load_indexed"() : () -> i32
    "neura.store_indexed"() : () -> ()
    "taskflow.yield"() : () -> ()
  }) : () -> ()
}
''', encoding="utf-8")

    stats = probes.body_statistics(candidate)
    assert stats["Task_0.fuse.Task_1"]["loads"] == 1
    assert stats["Task_0.fuse.Task_1"]["stores"] == 1


def test_fused_task_name_is_derived_from_cpp_source_fact_task_sets():
    # Task names and the replay-facts schema match the retained R10b C++ output.
    parent = {"schema": "orbit-joint-neighborhood-action-replay-facts-v1",
              "tasks": [{"task": name, "complete": True} for name in
                        ("Task_0", "Task_1", "Task_2")]}
    fused = {"schema": "orbit-joint-neighborhood-action-replay-facts-v1",
             "tasks": [{"task": name, "complete": True} for name in
                       ("Task_0.fuse.Task_1", "Task_2")]}

    assert probes._compiler_fused_task_name(parent, fused, "Task_0", "Task_1") == \
        "Task_0.fuse.Task_1"
    assert probes._compiler_fused_task_name(parent, fused, "Task_0", "Task_1") not in {
        "Task_0", "Task_1"}


def _r10b_lu_source_facts(parent_task, children):
    witness = ("amoeba-source-iteration-domain-v1\ncomplete=1\n"
               "represented_multiplicity=64\ninternal_multiplicity=1\n"
               "source_multiplicity=64\naxis_count=2\n")
    parent = {"schema": "orbit-joint-neighborhood-action-replay-facts-v1",
              "status": "complete", "source_iteration_domain_verified": True,
              "tasks": [{"task": parent_task, "complete": True,
                         "canonical_witness": witness,
                         "source_multiplicity": 64,
                         "represented_multiplicity": 64,
                         "current_taskflow_firing_count": 64,
                         "current_source_work_count": 64}]}
    action = {"canonicalReset": False, "family": "fission",
              "label": f"fission:{parent_task}:left=0",
              "primitives": [{"axis": 0, "factor": 1, "firstTask": parent_task,
                              "kind": "fission", "leftNodes": [0],
                              "mode": "", "secondTask": ""}],
              "shapeCols": 0, "shapeRows": 0, "shapeTask": ""}
    source_rows = []
    for name, part_index in children:
        control_binding = (
            "amoeba-source-iteration-domain-v1\n"
            f"domain_witness_bytes={len(witness.encode('utf-8'))}:{witness}\n\n"
            f"r10b-child-binding-{part_index}")
        source_rows.append({
            "task": name, "complete": True, "canonical_witness": witness,
            "represented_multiplicity": 64, "source_multiplicity": 64,
            "current_taskflow_firing_count": 64, "current_source_work_count": 64,
            "current_domain_status": "certified-complete",
            # In actual R10b, this field is empty because the children retain
            # the same iteration domain; it is not an operation-cut proof.
            "partition_proof": "",
            "source_control_binding": control_binding,
            "current_control_binding": control_binding,
        })
    split = {
        "schema": "orbit-joint-neighborhood-action-replay-facts-v1",
        "status": "complete", "actions_applied": 1,
        "source_iteration_domain_verified": True,
        "fission_source_replay_verified": True,
        "action_history": {"known": True, "fissionActions": [action]},
        "steps": [{"family": "fission", "label": action["label"],
                   "status": "exact-source-replay-verified",
                   "counter_domain_policy":
                       "retained-per-operation-not-disjoint-firing-partitions"}],
        "tasks": source_rows,
    }
    return parent, split


def test_r10b_lu_fission_proof_uses_cpp_exact_replay_and_child_bindings():
    parent, split = _r10b_lu_source_facts(
        "Task_0", [("Task_0.split.0", 0), ("Task_0.split.1", 1)])

    children, step = probes._verified_fission_children(parent, split, "Task_0", [0])

    assert [row["task"] for row in children] == ["Task_0.split.0", "Task_0.split.1"]
    assert step["status"] == "exact-source-replay-verified"
    assert all(not row["partition_proof"] for row in children)


def test_r10b_lu_fission_proof_rejects_missing_cpp_replay_or_child_binding():
    parent, split = _r10b_lu_source_facts(
        "Task_0", [("Task_0.split.0", 0), ("Task_0.split.1", 1)])
    split["fission_source_replay_verified"] = False
    with pytest.raises(probes.ProbeError, match="complete exact source replay"):
        probes._verified_fission_children(parent, split, "Task_0", [0])

    parent, split = _r10b_lu_source_facts(
        "Task_0", [("Task_0.split.0", 0), ("Task_0.split.1", 1)])
    split["tasks"][1]["current_control_binding"] = ""
    with pytest.raises(probes.ProbeError, match="source binding/domain is incomplete"):
        probes._verified_fission_children(parent, split, "Task_0", [0])
