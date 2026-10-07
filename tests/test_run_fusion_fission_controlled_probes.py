"""Lightweight contracts for the explicit diagnostic probe launcher."""
from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import sys
from types import SimpleNamespace


SCRIPT = (Path(__file__).resolve().parents[1] /
          "scripts/run_fusion_fission_controlled_probes.py")
SPEC = importlib.util.spec_from_file_location("controlled_probes_tested", SCRIPT)
assert SPEC is not None and SPEC.loader is not None
probes = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = probes
SPEC.loader.exec_module(probes)


def test_fusion_controls_preserve_the_parent_pair_resource_count():
    pc = probes.fusion_actions(probes.WORKLOAD_CONTROLS["harris"])
    sibling = probes.fusion_actions(probes.WORKLOAD_CONTROLS["radar-sibling"])

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
