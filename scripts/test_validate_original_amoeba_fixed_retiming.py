from __future__ import annotations

import copy
import json
import math
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import validate_original_amoeba_fixed_retiming as validator


SHAPES = ("1x1", "1x2", "2x1", "1x3", "3x1", "2x2", "1x4", "4x1")


def fixture() -> tuple[str, dict, dict, dict, dict, tempfile.TemporaryDirectory]:
    temporary = tempfile.TemporaryDirectory()
    arch_path = Path(temporary.name) / "fixture-architecture.yaml"
    architecture = """inter_task_network:
  version: 1
  rows: 4
  columns: 4
  local_bandwidth_bits_per_cycle: 16
  links:
    - {src_row: 0, src_column: 0, dst_row: 0, dst_column: 1, latency_cycles: 1, bandwidth_bits_per_cycle: 16}
    - {src_row: 0, src_column: 1, dst_row: 0, dst_column: 0, latency_cycles: 1, bandwidth_bits_per_cycle: 16}
"""
    arch_path.write_text(architecture)
    names = ("A", "B")
    body_rows = []
    profile_tasks = []
    binding_tasks = []
    trace_bindings = []
    entries = []
    task_costs = []
    originals = []
    schedules = []
    source_schedule = []
    for index, name in enumerate(names):
        body = {
            "task": name,
            "static_trip_count": 5,
            "task_signature": f"task-signature-{name}",
            "counter_signature": f"counter-signature-{name}",
            "kernel_binding_signature": f"kernel-signature-{name}",
            "normalized_mapper_body": f"func @{name}() {{ return }}",
        }
        body_rows.append(body)
        profiles = []
        for shape in SHAPES:
            rows, cols = map(int, shape.split("x"))
            if shape == "4x1":
                profiles.append({"composed_cgra_shape": shape, "composed_cgra_count": rows * cols, "mapper_succeeded": False})
            else:
                profiles.append({"composed_cgra_shape": shape, "composed_cgra_count": rows * cols,
                                 "compiled_ii": 3, "steps": 2, "sample_trip_count": 5,
                                 "materialized_operation_count": 1, "estimated_latency": 14,
                                 "mapper_succeeded": True})
        profile_tasks.append({"task": name, "profiles": profiles})
        binding = {
            **body, "selected_cgra_shape": "1x1", "selected_cgra_count": 1,
            "mapper_tile_rows": 1, "mapper_tile_cols": 1, "compiled_ii": 3,
            "steps": 2, "sample_trip_count": 5,
            "materialized_operation_count": 1, "estimated_latency": 14,
            "mapper_succeeded": True,
        }
        binding_tasks.append(binding)
        profile_binding = {
            **body, "selected_profile_shape": "1x1", "selected_cgra_count": 1,
            "compiled_ii": 3, "steps": 2, "sample_trip_count": 5,
            "materialized_operation_count": 1, "profile_duration_cycles": 14,
            "catalog_startup_cycles": 2, "mapped_duration_cycles": 14,
            "mapper_succeeded": True,
            "current_ir_body_equivalence_verified": True,
        }
        trace_bindings.append(profile_binding)
        entries.append({"task": name, "mapper_tile_rows": 1, "mapper_tile_cols": 1,
                       "support_status": "supported", "startup_cycles": 2,
                       "predicted_ii": 3, "analytical_lower_bound": 1})
        task_costs.append({
            "task": name, "trip_count": 5, "profile_compiled_ii": 3,
            "profile_materialized_operation_count": 1,
            "profile_sample_trip_count": 5, "profile_steps": 2,
            "original_profile_duration_cycles": 14, "catalog_startup_cycles": 2,
            "mapped_duration_cycles": 14, "selected_profile_shape": "1x1",
        })
        row, col = 0, index
        source_schedule.append({
            "task_name": name, "dispatch_index": index,
            "composed_cgra_shape": "1x1", "composed_cgra_count": 1,
            "active_replicas": 1, "duration": 14,
            "duration_unit": "profiled-cycles",
            "placements": [{"row": row, "col": col, "replica_id": 0,
                            "context_id": 0, "scheduler_start_time": 0,
                            "scheduler_end_time": 10, "scheduler_duration": 10}],
            "replica_shapes": [{"shape": "1x1", "row": row, "col": col,
                                "placement_rows": 1, "placement_cols": 1}],
            "scheduler_start_time": 0, "scheduler_end_time": 10,
        })
        originals.append({
            "task": name, "selected_profile_shape": "1x1",
            "actual_placed_shape": "1x1", "actual_placed_row": row,
            "actual_placed_col": col, "active_replicas": 1,
            "selected_cgra_count": 1, "dispatch_index": index,
            "actual_cells": [{"row": row, "col": col, "replica_id": 0, "context_id": 0}],
            "context_ids": [0], "original_scheduler_start_internal": 0,
            "original_scheduler_end_internal": 10,
            "original_scheduler_duration_internal": 10,
            "original_profile_duration_cycles": 14,
        })
        schedule = {
            "task": name, "row": row, "col": col, "rows": 1, "cols": 1,
            "start_cycle": 0 if index == 0 else 21,
            "end_cycle": 14 if index == 0 else 35,
            "idle_cycles": 0,
            "duration_cycles": 14,
            "occupied_cells": [{"row": row, "col": col, "replica_id": 0, "context_id": 0}],
        }
        schedules.append(schedule)

    metadata = {
        "architecture_path": str(arch_path), "architecture_contract": "neura-architecture-v1:fixture",
        "model": "formal-max4-nohash-v2", "model_schema": "formal-max4-nohash-v2",
        "feature_contract_id": "fixture-features", "feature_extractor": "cpp-feature-extractor",
        "shape_protocol_id": "fixture-shapes", "source_repository": "orbit",
        "source_commit": "fixture-commit", "source_graph_id": "original-amoeba-full",
        "graph_variant_id_source": "preserved-source-id-or-original-label",
    }
    profiles = {"format": "amoeba-task-profile-v1", "function": "fixture", "task_count": 2,
                "expected_candidate_count": 16, "completed_candidate_count": 16,
                "tasks": profile_tasks,
                "candidate_attempts": [
                    {"task": name, "candidate_index_in_task": index,
                     "composed_cgra_count": math.prod(map(int, shape.split("x"))),
                     "shape": shape, "profile_created": True,
                     "mapper_succeeded": next(
                         row for task in profile_tasks if task["task"] == name
                         for row in task["profiles"] if row["composed_cgra_shape"] == shape
                     )["mapper_succeeded"]}
                    for name in ("A", "B")
                    for index, shape in enumerate(SHAPES, start=1)
                ]}
    profile_path = Path(temporary.name) / "task-profiles.json"
    profile_path.write_text(json.dumps(profiles))
    checkpoint_directory = Path(temporary.name) / "checkpoints"
    checkpoint_directory.mkdir()
    checkpoint_texts = []
    checkpoint_sources = {}
    for name in ("baseline", "large-operation", "ranking"):
        text = json.dumps({"checkpoint": name})
        (checkpoint_directory / f"{name}.json").write_text(text)
        checkpoint_texts.append({"name": name, "text": text})
        checkpoint_sources[name] = {"path": f"{name}.json"}
    ensemble = {"schema": metadata["model_schema"], "quality_status": "exploratory",
                "production_ready": False, "checkpoints": checkpoint_sources}
    ensemble_text = json.dumps(ensemble)
    ensemble_path = Path(temporary.name) / "ensemble.json"
    ensemble_path.write_text(ensemble_text)
    binding = {
        "schema": "amoeba-original-profile-body-binding-v1", "candidate_id": "candidate-0",
        "function": "fixture", "graph_variant_id": "original-amoeba-full",
        "body_export_format": "amoeba-pre-mapper-task-bodies-v1",
        "profile_file_format": "amoeba-task-profile-v1",
        "current_ir_body_equivalence_verified": True,
        "architecture_text": architecture, "architecture_path": str(arch_path),
        "profile_file": str(profile_path), "ensemble_path": str(ensemble_path),
        "ensemble_text": ensemble_text, "checkpoint_directory": str(checkpoint_directory),
        "checkpoint_texts": checkpoint_texts,
        "architecture_contract": metadata["architecture_contract"],
        **{key: metadata[key] for key in ("model", "model_schema", "feature_contract_id", "feature_extractor", "shape_protocol_id", "source_repository", "source_commit")},
        "tasks": binding_tasks,
    }
    costs = {"schema": "amoeba-task-shape-cost", "predictor_metadata": metadata,
             "original_amoeba_profile_binding": binding, "entries": entries}
    edge = {
        "edge_index": 0, "edge_id": "edge-0", "producer": "A", "consumer": "B", "kind": "raw",
        "origin": "taskflow", "scope": "tensor_wide",
        "producer_segment": "done_writes", "producer_index": 0,
        "consumer_segment": "will_reads", "consumer_index": 0,
        "payload_known": True, "payload_bits": 64,
        "transfer_region_lower": [], "transfer_region_upper": [],
    }
    second_edge = {
        "edge_index": 1, "edge_id": "edge-1", "producer": "A", "consumer": "B", "kind": "value",
        "origin": "taskflow", "scope": "tensor_wide",
        "producer_segment": "value_outputs", "producer_index": 0,
        "consumer_segment": "value_inputs", "consumer_index": 0,
        "payload_known": True, "payload_bits": 32,
        "transfer_region_lower": [], "transfer_region_upper": [],
    }
    contract = {
        "schema": "inter-task-network-v1", "resource_interval_semantics": "half-open-start-inclusive-end-exclusive",
        "version": 1, "rows": 4, "columns": 4,
        "local_bandwidth_bits_per_cycle": 16,
        "links": [
            {"link_index": 0, "source_row": 0, "source_col": 0, "destination_row": 0,
             "destination_col": 1, "latency_cycles": 1, "bandwidth_bits_per_cycle": 16},
            {"link_index": 1, "source_row": 0, "source_col": 1, "destination_row": 0,
             "destination_col": 0, "latency_cycles": 1, "bandwidth_bits_per_cycle": 16},
        ],
    }
    route = {
        "route_id": "A->B", "producer": "A", "consumer": "B", "payload_bits": 96,
        "path_latency_cycles": 1, "bottleneck_bandwidth_bits_per_cycle": 16,
        "transfer_cycles": 7, "source_row": 0, "source_col": 0,
        "destination_row": 0, "destination_col": 1,
        "producer_finish_cycle": 14, "consumer_start_cycle": 21,
        "start_cycle": 14, "ready_cycle": 21, "edge_indices": [0, 1],
        "intervals": [{"resource_kind": "network_link", "link_index": 0,
                       "start_cycle": 14, "end_cycle": 21}],
    }
    fixed_trace = {
        "schema": "amoeba-fixed-decision-trace-v1", "candidate_id": "candidate-0",
        "graph_variant_id": "original-amoeba-full", "formal_go": False,
        "iteration_domain_coverage_status": "pending",
        "iteration_domain_coverage_verified": False, "body_equivalence_checked": True,
        "communication_contract": contract, "task_profile_bindings": trace_bindings,
        "dependencies": [edge, second_edge], "routes": [route], "dispatch_order": list(names),
        "task_schedule": schedules,
    }
    result = {
        "record_type": "result", "schema": "amoeba-original-fixed-decision-retiming-v1",
        "function": "fixture", "graph_variant_id": "original-amoeba-full",
        "candidate_id": "candidate-0", "valid": True, "diagnostic_only": True,
        "formal_go": False, "body_equivalence_checked": True,
        "selected_profile_body_binding_verified": True,
        "iteration_domain_coverage_status": "pending",
        "iteration_domain_coverage_verified": False,
        "original_pipeline_interval": 10,
        "original_internal_time_unit": "scaled-internal-placement-slots",
        "original_internal_time_scale": 1, "grid_rows": 4, "grid_cols": 4,
        "mapped_whole_program_cycles": 35, "predicted_whole_program_cycles": 35,
        "replayed_communication_edges": 1, "dispatch_order": list(names),
        "original_decisions": originals, "task_costs": task_costs,
        "task_schedule": schedules, "fixed_decision_trace": fixed_trace,
    }
    ir = '''module {
  func.func @fixture() {
  } attributes {amoeba.task_scheduler_dispatch_order = ["A", "B"],
    amoeba.task_scheduler_task_schedule = [
      {task_name = "A", dispatch_index = 0 : i64, composed_cgra_shape = "1x1", composed_cgra_count = 1 : i64, active_replicas = 1 : i64, duration = 14 : i64, duration_unit = "profiled-cycles", scheduler_start_time = 0 : i64, scheduler_end_time = 10 : i64, placements = [{row = 0 : i32, col = 0 : i32, replica_id = 0 : i32, context_id = 0 : i32, scheduler_start_time = 0 : i64, scheduler_end_time = 10 : i64, scheduler_duration = 10 : i64}], replica_shapes = [{shape = "1x1", row = 0 : i32, col = 0 : i32, placement_rows = 1 : i32, placement_cols = 1 : i32}]},
      {task_name = "B", dispatch_index = 1 : i64, composed_cgra_shape = "1x1", composed_cgra_count = 1 : i64, active_replicas = 1 : i64, duration = 14 : i64, duration_unit = "profiled-cycles", scheduler_start_time = 0 : i64, scheduler_end_time = 10 : i64, placements = [{row = 0 : i32, col = 1 : i32, replica_id = 0 : i32, context_id = 0 : i32, scheduler_start_time = 0 : i64, scheduler_end_time = 10 : i64, scheduler_duration = 10 : i64}], replica_shapes = [{shape = "1x1", row = 0 : i32, col = 1 : i32, placement_rows = 1 : i32, placement_cols = 1 : i32}]}
    ], task_orchestration_summary = {strategy = "throughput-guided", pipeline_interval = 10 : i64}, amoeba.task_scheduler_time_unit = "scaled-internal-placement-slots", amoeba.task_scheduler_time_scale = 1 : i64}
}'''
    body_proof = {"format": "amoeba-pre-mapper-task-bodies-v1", "function": "fixture",
                  "task_count": 2, "tasks": body_rows}
    return ir, result, body_proof, profiles, costs, temporary


def f45_replica_fixture() -> tuple[str, dict, dict, dict, dict, tempfile.TemporaryDirectory]:
    """An explicitly certified F45 parent estimate with two real source placements."""
    ir, result, body, profiles, costs, temporary = fixture()
    policy = copy.deepcopy(validator.F45_REPLICA_TIMING_POLICY)
    result["replica_timing_policy"] = copy.deepcopy(policy)
    result["fixed_decision_trace"]["replica_timing_policy"] = copy.deepcopy(policy)

    source_profile = next(task for task in profiles["tasks"] if task["task"] == "A")
    selected_profile = next(row for row in source_profile["profiles"]
                            if row["composed_cgra_shape"] == "1x2")
    selected_profile.update({"steps": 3, "estimated_latency": 15})
    binding_task = next(row for row in costs["original_amoeba_profile_binding"]["tasks"]
                        if row["task"] == "A")
    binding_task.update({"selected_cgra_shape": "1x2", "selected_cgra_count": 2,
                         "mapper_tile_rows": 1, "mapper_tile_cols": 2,
                         "steps": 3, "estimated_latency": 15})
    profile_binding = next(row for row in result["fixed_decision_trace"]["task_profile_bindings"]
                           if row["task"] == "A")
    profile_binding.update({"selected_profile_shape": "1x2", "selected_cgra_count": 2,
                            "steps": 3, "profile_duration_cycles": 8})
    selected_cost = next(row for row in costs["entries"] if row["task"] == "A")
    selected_cost.update({"mapper_tile_rows": 1, "mapper_tile_cols": 2})

    def cell(row: int, col: int, replica_id: int, context_id: int) -> dict:
        return {"row": row, "col": col, "replica_id": replica_id,
                "context_id": context_id}

    cells_a0 = [cell(0, 0, 0, 0), cell(0, 1, 0, 1)]
    cells_a1 = [cell(2, 0, 1, 2), cell(3, 0, 1, 3)]
    cells_b = [cell(0, 2, 0, 4)]
    all_a = cells_a0 + cells_a1
    placements_a = [dict(item, scheduler_start_time=0, scheduler_end_time=10,
                         scheduler_duration=10) for item in all_a]
    placements_b = [dict(item, scheduler_start_time=0, scheduler_end_time=10,
                         scheduler_duration=10) for item in cells_b]
    source_a = {
        "task_name": "A", "dispatch_index": 0, "composed_cgra_shape": "1x2",
        "composed_cgra_count": 2, "active_replicas": 2, "duration": 8,
        "duration_unit": "profiled-cycles", "scheduler_start_time": 0,
        "scheduler_end_time": 10, "placements": placements_a,
        "replica_shapes": [
            {"replica_id": 0, "shape": "1x2", "cgra_count": 2, "row": 0,
             "col": 0, "placement_rows": 1, "placement_cols": 2},
            {"replica_id": 1, "shape": "2x1", "cgra_count": 2, "row": 2,
             "col": 0, "placement_rows": 2, "placement_cols": 1},
        ],
    }
    source_b = {
        "task_name": "B", "dispatch_index": 1, "composed_cgra_shape": "1x1",
        "composed_cgra_count": 1, "active_replicas": 1, "duration": 14,
        "duration_unit": "profiled-cycles", "scheduler_start_time": 0,
        "scheduler_end_time": 10, "placements": placements_b,
        "replica_shapes": [
            {"replica_id": 0, "shape": "1x1", "cgra_count": 1, "row": 0,
             "col": 2, "placement_rows": 1, "placement_cols": 1},
        ],
    }
    replica_a0 = {"replica_id": 0, "shape": "1x2", "cgra_count": 2,
                  "row": 0, "col": 0, "rows": 1, "cols": 2,
                  "actual_cells": cells_a0, "context_ids": [0, 1]}
    replica_a1 = {"replica_id": 1, "shape": "2x1", "cgra_count": 2,
                  "row": 2, "col": 0, "rows": 2, "cols": 1,
                  "actual_cells": cells_a1, "context_ids": [2, 3]}
    replica_b = {"replica_id": 0, "shape": "1x1", "cgra_count": 1,
                 "row": 0, "col": 2, "rows": 1, "cols": 1,
                 "actual_cells": cells_b, "context_ids": [4]}
    duration_binding = {
        "schema": "amoeba-original-f45-profile-duration-binding-v1",
        "full_parent_mapper_duration_cycles": 15,
        "f45_scheduler_duration_cycles": 8,
        "active_replicas": 2,
        "compiled_ii": 3,
        "sample_trip_count": 5,
        "steps": 3,
        "materialized_operation_count": 1,
        "rounding_rule": "ceil-full-parent-duration-over-original-active-replicas-v1",
        "status": "verified",
    }
    original_a = {
        "task": "A", "selected_profile_shape": "1x2",
        "actual_placed_shape": "1x2", "actual_placed_row": 0,
        "actual_placed_col": 0, "active_replicas": 2,
        "selected_cgra_count": 2, "dispatch_index": 0,
        "actual_cells": all_a, "context_ids": [0, 1, 2, 3],
        "original_scheduler_start_internal": 0,
        "original_scheduler_end_internal": 10,
        "original_scheduler_duration_internal": 10,
        "original_profile_duration_cycles": 8,
        "original_profile_duration_binding": duration_binding,
        "replicas": [replica_a0, replica_a1],
    }
    original_b = {
        "task": "B", "selected_profile_shape": "1x1",
        "actual_placed_shape": "1x1", "actual_placed_row": 0,
        "actual_placed_col": 2, "active_replicas": 1,
        "selected_cgra_count": 1, "dispatch_index": 1,
        "actual_cells": cells_b, "context_ids": [4],
        "original_scheduler_start_internal": 0,
        "original_scheduler_end_internal": 10,
        "original_scheduler_duration_internal": 10,
        "original_profile_duration_cycles": 14,
    }
    result["original_decisions"] = [original_a, original_b]

    timing_fields_a = {
        "full_parent_mapped_duration_cycles": 14,
        "original_active_replicas": 2,
        "replica_duration_rule": policy["replica_duration_rule"],
    }
    timing_fields_b = {
        "full_parent_mapped_duration_cycles": 14,
        "original_active_replicas": 1,
        "replica_duration_rule": policy["replica_duration_rule"],
    }
    cost_a = next(row for row in result["task_costs"] if row["task"] == "A")
    cost_a.update({"selected_profile_shape": "1x2", "profile_steps": 3,
                   "original_profile_duration_cycles": 8,
                   "mapped_duration_cycles": 7, **timing_fields_a})
    cost_b = next(row for row in result["task_costs"] if row["task"] == "B")
    cost_b.update(timing_fields_b)
    profile_binding.update({"catalog_startup_cycles": 2,
                            "mapped_duration_cycles": 7, **timing_fields_a})
    binding_b = next(row for row in result["fixed_decision_trace"]["task_profile_bindings"]
                     if row["task"] == "B")
    binding_b.update(timing_fields_b)

    architecture = """inter_task_network:
  version: 1
  rows: 4
  columns: 4
  local_bandwidth_bits_per_cycle: 16
  links:
    - {src_row: 0, src_column: 0, dst_row: 0, dst_column: 1, latency_cycles: 1, bandwidth_bits_per_cycle: 16}
    - {src_row: 0, src_column: 1, dst_row: 0, dst_column: 2, latency_cycles: 1, bandwidth_bits_per_cycle: 16}
"""
    arch_path = Path(costs["original_amoeba_profile_binding"]["architecture_path"])
    arch_path.write_text(architecture)
    costs["original_amoeba_profile_binding"]["architecture_text"] = architecture
    profile_path = Path(costs["original_amoeba_profile_binding"]["profile_file"])
    profile_path.write_text(json.dumps(profiles))

    contract = {
        "schema": "inter-task-network-v1",
        "resource_interval_semantics": "half-open-start-inclusive-end-exclusive",
        "version": 1, "rows": 4, "columns": 4,
        "local_bandwidth_bits_per_cycle": 16,
        "links": [
            {"link_index": 0, "source_row": 0, "source_col": 0,
             "destination_row": 0, "destination_col": 1,
             "latency_cycles": 1, "bandwidth_bits_per_cycle": 16},
            {"link_index": 1, "source_row": 0, "source_col": 1,
             "destination_row": 0, "destination_col": 2,
             "latency_cycles": 1, "bandwidth_bits_per_cycle": 16},
        ],
    }
    route = {
        "route_id": "A->B", "producer": "A", "consumer": "B",
        "payload_bits": 96, "path_latency_cycles": 2,
        "bottleneck_bandwidth_bits_per_cycle": 16, "transfer_cycles": 8,
        "source_row": 0, "source_col": 0,
        "destination_row": 0, "destination_col": 2,
        "producer_finish_cycle": 7, "consumer_start_cycle": 21,
        "start_cycle": 7, "ready_cycle": 15,
        "edge_indices": [0, 1],
        "intervals": [
            {"resource_kind": "network_link", "link_index": 0,
             "start_cycle": 7, "end_cycle": 15},
            {"resource_kind": "network_link", "link_index": 1,
             "start_cycle": 7, "end_cycle": 15},
        ],
    }
    trace = result["fixed_decision_trace"]
    trace["communication_contract"] = contract
    trace["routes"] = [route]

    schedule_a = {
        "task": "A", "row": 0, "col": 0, "rows": 1, "cols": 2,
        "start_cycle": 0, "end_cycle": 7, "idle_cycles": 0,
        "duration_cycles": 7, "occupied_cells": all_a,
    }
    schedule_b = {
        "task": "B", "row": 0, "col": 2, "rows": 1, "cols": 1,
        "start_cycle": 21, "end_cycle": 35, "idle_cycles": 6,
        "duration_cycles": 14, "occupied_cells": cells_b,
    }
    result["task_schedule"] = [schedule_a, schedule_b]
    trace["task_schedule"] = copy.deepcopy(result["task_schedule"])
    result["mapped_whole_program_cycles"] = 35
    result["predicted_whole_program_cycles"] = 35

    ir = '''module {
  func.func @fixture() {
  } attributes {amoeba.task_scheduler_dispatch_order = ["A", "B"],
    amoeba.task_scheduler_task_schedule = [
      {task_name = "A", dispatch_index = 0 : i64, composed_cgra_shape = "1x2", composed_cgra_count = 2 : i64, active_replicas = 2 : i64, duration = 8 : i64, duration_unit = "profiled-cycles", scheduler_start_time = 0 : i64, scheduler_end_time = 10 : i64, placements = [{row = 0 : i32, col = 0 : i32, replica_id = 0 : i32, context_id = 0 : i32, scheduler_start_time = 0 : i64, scheduler_end_time = 10 : i64, scheduler_duration = 10 : i64}, {row = 0 : i32, col = 1 : i32, replica_id = 0 : i32, context_id = 1 : i32, scheduler_start_time = 0 : i64, scheduler_end_time = 10 : i64, scheduler_duration = 10 : i64}, {row = 2 : i32, col = 0 : i32, replica_id = 1 : i32, context_id = 2 : i32, scheduler_start_time = 0 : i64, scheduler_end_time = 10 : i64, scheduler_duration = 10 : i64}, {row = 3 : i32, col = 0 : i32, replica_id = 1 : i32, context_id = 3 : i32, scheduler_start_time = 0 : i64, scheduler_end_time = 10 : i64, scheduler_duration = 10 : i64}], replica_shapes = [{replica_id = 0 : i32, shape = "1x2", cgra_count = 2 : i32, row = 0 : i32, col = 0 : i32, placement_rows = 1 : i32, placement_cols = 2 : i32}, {replica_id = 1 : i32, shape = "2x1", cgra_count = 2 : i32, row = 2 : i32, col = 0 : i32, placement_rows = 2 : i32, placement_cols = 1 : i32}]},
      {task_name = "B", dispatch_index = 1 : i64, composed_cgra_shape = "1x1", composed_cgra_count = 1 : i64, active_replicas = 1 : i64, duration = 14 : i64, duration_unit = "profiled-cycles", scheduler_start_time = 0 : i64, scheduler_end_time = 10 : i64, placements = [{row = 0 : i32, col = 2 : i32, replica_id = 0 : i32, context_id = 4 : i32, scheduler_start_time = 0 : i64, scheduler_end_time = 10 : i64, scheduler_duration = 10 : i64}], replica_shapes = [{replica_id = 0 : i32, shape = "1x1", cgra_count = 1 : i32, row = 0 : i32, col = 2 : i32, placement_rows = 1 : i32, placement_cols = 1}]}
    ], task_orchestration_summary = {strategy = "throughput-guided", pipeline_interval = 10 : i64}, amoeba.task_scheduler_time_unit = "scaled-internal-placement-slots", amoeba.task_scheduler_time_scale = 1 : i64}
}'''
    return ir, result, body, profiles, costs, temporary


def _sync_production_scheduler_witness(result: dict) -> None:
    trace = result["fixed_decision_trace"]
    decisions = {
        "dispatch_order": copy.deepcopy(result["dispatch_order"]),
        "task_schedule": copy.deepcopy(result["task_schedule"]),
    }
    result["production_scheduler_decisions"] = copy.deepcopy(decisions)
    trace["production_scheduler_decisions"] = copy.deepcopy(decisions)
    trace["dispatch_order"] = copy.deepcopy(decisions["dispatch_order"])
    trace["task_schedule"] = copy.deepcopy(decisions["task_schedule"])


def production_scheduler_fixture(
        independent_tasks: bool = False
) -> tuple[str, dict, dict, dict, dict, tempfile.TemporaryDirectory]:
    """Keep original F45 choices while replacing only its schedule decisions."""
    ir, result, body, profiles, costs, temporary = f45_replica_fixture()
    trace = result["fixed_decision_trace"]
    a_cells = [
        {"row": 0, "col": 0, "replica_id": 0, "context_id": 0},
        {"row": 0, "col": 1, "replica_id": 0, "context_id": 0},
        # F45 placed replica 1 as 2x1. The production scheduler must retain
        # the selected profile orientation, 1x2, for every replica.
        {"row": 2, "col": 0, "replica_id": 1, "context_id": 0},
        {"row": 2, "col": 1, "replica_id": 1, "context_id": 0},
    ]
    b_cell = {"row": 0, "col": 2, "replica_id": 0, "context_id": 0}
    a_schedule = {
        "task": "A", "row": 0, "col": 0, "rows": 1, "cols": 2,
        "start_cycle": 0, "end_cycle": 7, "idle_cycles": 0,
        "duration_cycles": 7, "occupied_cells": a_cells,
    }
    b_schedule = {
        "task": "B", "row": 0, "col": 2, "rows": 1, "cols": 1,
        "start_cycle": 21, "end_cycle": 35, "idle_cycles": 6,
        "duration_cycles": 14, "occupied_cells": [b_cell],
    }
    if independent_tasks:
        trace["dependencies"] = []
        trace["routes"] = []
        result["replayed_communication_edges"] = 0
        result["dispatch_order"] = ["B", "A"]
        b_schedule.update({"start_cycle": 0, "end_cycle": 14, "idle_cycles": 0})
        result["task_schedule"] = [b_schedule, a_schedule]
        result["mapped_whole_program_cycles"] = 14
        result["predicted_whole_program_cycles"] = 14
    else:
        result["dispatch_order"] = ["A", "B"]
        result["task_schedule"] = [a_schedule, b_schedule]
        result["mapped_whole_program_cycles"] = 35
        result["predicted_whole_program_cycles"] = 35
    result["scheduler"] = {
        "backend": "orbit-production",
        "dispatch_policy": "critical-path",
        "timing": "common-explicit-network",
    }
    result["shared_scheduler_resource_only"] = True
    trace["scheduler"] = copy.deepcopy(result["scheduler"])
    trace["shared_scheduler_resource_only"] = True
    trace["dispatch_order"] = copy.deepcopy(result["dispatch_order"])
    trace["task_schedule"] = copy.deepcopy(result["task_schedule"])
    _sync_production_scheduler_witness(result)
    return ir, result, body, profiles, costs, temporary


def expanded_fixture() -> tuple[str, dict, dict, dict, dict, dict, tempfile.TemporaryDirectory]:
    """A source parent split into differently oriented, actually profiled children."""
    ir, result, body, profiles, costs, temporary = fixture()
    root = Path(temporary.name)
    architecture = """inter_task_network:
  version: 1
  rows: 4
  columns: 4
  local_bandwidth_bits_per_cycle: 16
  links:
    - {src_row: 0, src_column: 0, dst_row: 0, dst_column: 1, latency_cycles: 1, bandwidth_bits_per_cycle: 16}
    - {src_row: 0, src_column: 1, dst_row: 0, dst_column: 2, latency_cycles: 1, bandwidth_bits_per_cycle: 16}
    - {src_row: 0, src_column: 2, dst_row: 0, dst_column: 1, latency_cycles: 1, bandwidth_bits_per_cycle: 16}
"""
    arch_path = Path(costs["original_amoeba_profile_binding"]["architecture_path"])
    arch_path.write_text(architecture)
    metadata = costs["predictor_metadata"]
    binding = costs["original_amoeba_profile_binding"]
    namespace = "orbit-per-cgra-2x2-direct-4member-v1"
    model_schema = "orbit-cgra-ii-per-cgra-2x2-direct-ensemble-cpp-v1"
    metadata.update({
        "model": "direct-four-member-fixture",
        "model_schema": model_schema,
        "feature_contract_id": "cgra-ii-pre-mapper-features-148-2x2-per-cgra-v1",
        "shape_protocol_id": "amoeba-static-rectangles-2x2-per-cgra-max4",
    })
    binding.update({
        "architecture_text": architecture,
        "model": metadata["model"],
        "model_schema": model_schema,
        "model_namespace": namespace,
        "feature_contract_id": metadata["feature_contract_id"],
        "shape_protocol_id": metadata["shape_protocol_id"],
    })
    source_model = {"repository": "fixture-model", "commit": "fixture-model-commit", "branch": "fixture"}
    binding["source_model"] = {
        **source_model,
        "candidate_metadata": {
            "candidate_only": True,
            "old_4x4_labels_reused": False,
            "ensemble_member_count": 4,
            "feature_count": 148,
        },
    }
    seeds = (17, 41, 113, 239)
    shape_costs: dict[str, dict[tuple[int, int], dict]] = {}
    entries: list[dict] = []
    for name in ("A", "B"):
        rows_by_shape: dict[tuple[int, int], dict] = {}
        predictions = []
        for shape in SHAPES:
            rows, cols = map(int, shape.split("x"))
            startup = 10 + rows * 5 + cols
            members = [{"member_index": index, "seed": seed, "predicted_ii": 2.0}
                       for index, seed in enumerate(seeds)]
            entry = {
                "task": name,
                "mapper_tile_rows": rows * 2,
                "mapper_tile_cols": cols * 2,
                "support_status": "supported",
                "analytical_lower_bound": 1.0,
                "predicted_ii": 2.0,
                "predicted_ii_std": 0.0,
                "startup_cycles": startup,
                "direct_ensemble_members": copy.deepcopy(members),
            }
            entries.append(entry)
            rows_by_shape[(rows, cols)] = entry
            predictions.append({
                "cgra_rows": rows,
                "cgra_cols": cols,
                "mapper_tile_rows": rows * 2,
                "mapper_tile_cols": cols * 2,
                "support_status": "supported",
                "analytical_lower_bound": 1.0,
                "predicted_ii": 2.0,
                "predicted_ii_std": 0.0,
                "startup_cycles": startup,
                "direct_ensemble_members": copy.deepcopy(members),
            })
        shape_costs[name] = rows_by_shape
        binding_task = next(row for row in binding["tasks"] if row["task"] == name)
        binding_task["direct_shape_predictions"] = predictions
        if name == "A":
            binding_task.update({"selected_cgra_shape": "1x2", "selected_cgra_count": 2,
                                 "mapper_tile_rows": 2, "mapper_tile_cols": 4})

    parent_profile = next(row for task in profiles["tasks"] if task["task"] == "A"
                          for row in task["profiles"]
                          if row["composed_cgra_shape"] == "1x2")
    parent_profile["steps"] = 3
    parent_profile["estimated_latency"] = 15
    parent_cost_binding = next(row for row in binding["tasks"] if row["task"] == "A")
    parent_cost_binding["steps"] = 3
    parent_cost_binding["estimated_latency"] = 15

    ensemble = {
        "schema": model_schema,
        "model_namespace": namespace,
        "architecture": {"exact_yaml_text": architecture},
        "members": [{"seed": seed} for seed in seeds],
        "source_model": source_model,
        "feature_contract": {"contract_id": metadata["feature_contract_id"]},
        "shape_protocol": {"protocol_id": metadata["shape_protocol_id"]},
    }
    ensemble_text = json.dumps(ensemble)
    ensemble_path = root / "direct-ensemble.json"
    ensemble_path.write_text(ensemble_text)
    binding["ensemble_text"] = ensemble_text
    binding["ensemble_path"] = str(ensemble_path)
    metadata["model_schema"] = model_schema
    costs["entries"] = entries
    profile_path = Path(binding["profile_file"])
    profile_path.write_text(json.dumps(profiles))

    def cell(row: int, col: int, replica_id: int, context_id: int) -> dict:
        return {"row": row, "col": col, "replica_id": replica_id, "context_id": context_id}

    cells_a0 = [cell(0, 0, 0, 0), cell(0, 1, 0, 1)]
    cells_a1 = [cell(2, 0, 1, 2), cell(3, 0, 1, 3)]
    cells_b = [cell(0, 2, 0, 4)]
    all_a = cells_a0 + cells_a1
    placements_a = [dict(item, scheduler_start_time=0, scheduler_end_time=10, scheduler_duration=10)
                    for item in all_a]
    placements_b = [dict(item, scheduler_start_time=0, scheduler_end_time=10, scheduler_duration=10)
                    for item in cells_b]
    source_a = {
        "task_name": "A", "dispatch_index": 0, "composed_cgra_shape": "1x2",
        "composed_cgra_count": 2, "active_replicas": 2, "duration": 14,
        "duration_unit": "profiled-cycles", "scheduler_start_time": 0,
        "scheduler_end_time": 10, "placements": placements_a,
        "replica_shapes": [
            {"replica_id": 0, "shape": "1x2", "cgra_count": 2, "row": 0, "col": 0,
             "placement_rows": 1, "placement_cols": 2},
            {"replica_id": 1, "shape": "2x1", "cgra_count": 2, "row": 2, "col": 0,
             "placement_rows": 2, "placement_cols": 1},
        ],
    }
    source_b = {
        "task_name": "B", "dispatch_index": 1, "composed_cgra_shape": "1x1",
        "composed_cgra_count": 1, "active_replicas": 1, "duration": 14,
        "duration_unit": "profiled-cycles", "scheduler_start_time": 0,
        "scheduler_end_time": 10, "placements": placements_b,
        "replica_shapes": [{"replica_id": 0, "shape": "1x1", "cgra_count": 1,
                            "row": 0, "col": 2, "placement_rows": 1, "placement_cols": 1}],
    }
    replica_a0 = {"replica_id": 0, "shape": "1x2", "cgra_count": 2, "row": 0, "col": 0,
                  "rows": 1, "cols": 2, "actual_cells": cells_a0, "context_ids": [0, 1]}
    replica_a1 = {"replica_id": 1, "shape": "2x1", "cgra_count": 2, "row": 2, "col": 0,
                  "rows": 2, "cols": 1, "actual_cells": cells_a1, "context_ids": [2, 3]}
    replica_b = {"replica_id": 0, "shape": "1x1", "cgra_count": 1, "row": 0, "col": 2,
                 "rows": 1, "cols": 1, "actual_cells": cells_b, "context_ids": [4]}
    originals = [
        {"task": "A", "selected_profile_shape": "1x2", "actual_placed_shape": "1x2",
         "actual_placed_row": 0, "actual_placed_col": 0, "active_replicas": 2,
         "selected_cgra_count": 2, "dispatch_index": 0, "actual_cells": all_a,
         "context_ids": [0, 1, 2, 3], "original_scheduler_start_internal": 0,
         "original_scheduler_end_internal": 10, "original_scheduler_duration_internal": 10,
         "original_profile_duration_cycles": 8,
         "original_profile_duration_binding": {
             "schema": "amoeba-original-f45-profile-duration-binding-v1",
             "full_parent_mapper_duration_cycles": 15,
             "f45_scheduler_duration_cycles": 8, "active_replicas": 2,
             "compiled_ii": 3, "sample_trip_count": 5, "steps": 3,
             "materialized_operation_count": 1,
             "rounding_rule": "ceil-full-parent-duration-over-original-active-replicas-v1",
             "status": "verified",
         }, "replicas": [replica_a0, replica_a1]},
        {"task": "B", "selected_profile_shape": "1x1", "actual_placed_shape": "1x1",
         "actual_placed_row": 0, "actual_placed_col": 2, "active_replicas": 1,
         "selected_cgra_count": 1, "dispatch_index": 1, "actual_cells": cells_b,
         "context_ids": [4], "original_scheduler_start_internal": 0,
         "original_scheduler_end_internal": 10, "original_scheduler_duration_internal": 10,
         "original_profile_duration_cycles": 14, "replicas": [replica_b]},
    ]
    ir = '''module {
  func.func @fixture() {
  } attributes {amoeba.task_scheduler_dispatch_order = ["A", "B"],
    amoeba.task_scheduler_task_schedule = [
      {task_name = "A", dispatch_index = 0 : i64, composed_cgra_shape = "1x2", composed_cgra_count = 2 : i64, active_replicas = 2 : i64, duration = 14 : i64, duration_unit = "profiled-cycles", scheduler_start_time = 0 : i64, scheduler_end_time = 10 : i64, placements = [{row = 0 : i32, col = 0 : i32, replica_id = 0 : i32, context_id = 0 : i32, scheduler_start_time = 0 : i64, scheduler_end_time = 10 : i64, scheduler_duration = 10 : i64}, {row = 0 : i32, col = 1 : i32, replica_id = 0 : i32, context_id = 1 : i32, scheduler_start_time = 0 : i64, scheduler_end_time = 10 : i64, scheduler_duration = 10 : i64}, {row = 2 : i32, col = 0 : i32, replica_id = 1 : i32, context_id = 2 : i32, scheduler_start_time = 0 : i64, scheduler_end_time = 10 : i64, scheduler_duration = 10 : i64}, {row = 3 : i32, col = 0 : i32, replica_id = 1 : i32, context_id = 3 : i32, scheduler_start_time = 0 : i64, scheduler_end_time = 10 : i64, scheduler_duration = 10 : i64}], replica_shapes = [{replica_id = 0 : i32, shape = "1x2", cgra_count = 2 : i32, row = 0 : i32, col = 0 : i32, placement_rows = 1 : i32, placement_cols = 2 : i32}, {replica_id = 1 : i32, shape = "2x1", cgra_count = 2 : i32, row = 2 : i32, col = 0 : i32, placement_rows = 2 : i32, placement_cols = 1 : i32}]},
      {task_name = "B", dispatch_index = 1 : i64, composed_cgra_shape = "1x1", composed_cgra_count = 1 : i64, active_replicas = 1 : i64, duration = 14 : i64, duration_unit = "profiled-cycles", scheduler_start_time = 0 : i64, scheduler_end_time = 10 : i64, placements = [{row = 0 : i32, col = 2 : i32, replica_id = 0 : i32, context_id = 4 : i32, scheduler_start_time = 0 : i64, scheduler_end_time = 10 : i64, scheduler_duration = 10 : i64}], replica_shapes = [{replica_id = 0 : i32, shape = "1x1", cgra_count = 1 : i32, row = 0 : i32, col = 2 : i32, placement_rows = 1 : i32, placement_cols = 1 : i32}]}
    ], task_orchestration_summary = {strategy = "throughput-guided", pipeline_interval = 10 : i64}, amoeba.task_scheduler_time_unit = "scaled-internal-placement-slots", amoeba.task_scheduler_time_scale = 1 : i64}
}'''
    split_parent_duration = "active_replicas = 2 : i64, duration = 14 : i64"
    assert ir.count(split_parent_duration) == 1
    ir = ir.replace(split_parent_duration,
                    "active_replicas = 2 : i64, duration = 8 : i64", 1)

    module_path = root / "materialized.mlir"
    module_path.write_text("module { func.func @fixture() {} }\n")
    body_rows = []
    profile_tasks = []
    attempts = []
    for task_name, trip, selected_shape, selected_ii, selected_steps in (
            ("A.replica.0", 3, "1x2", 4, 3), ("A.replica.1", 2, "2x1", 5, 4)):
        body_rows.append({"task": task_name, "static_trip_count": trip,
                          "task_signature": f"task-signature-{task_name}",
                          "counter_signature": f"counter-signature-{task_name}",
                          "kernel_binding_signature": f"kernel-signature-{task_name}",
                          "normalized_mapper_body": f"normalized-{task_name}"})
        child_profiles = []
        for shape in SHAPES:
            rows, cols = map(int, shape.split("x"))
            succeeded = shape != "4x1"
            profile = {"composed_cgra_shape": shape, "composed_cgra_count": rows * cols,
                       "mapper_succeeded": succeeded}
            if succeeded:
                ii = selected_ii if shape == selected_shape else 2
                steps = selected_steps if shape == selected_shape else 2
                profile.update({"compiled_ii": ii, "steps": steps,
                                "sample_trip_count": trip,
                                "materialized_operation_count": 3,
                                "estimated_latency": ii * (trip - 1) + steps})
            child_profiles.append(profile)
            attempts.append({"task": task_name, "shape": shape,
                             "candidate_index_in_task": SHAPES.index(shape) + 1,
                             "composed_cgra_count": rows * cols,
                             "profile_created": True,
                             "mapper_succeeded": succeeded})
        profile_tasks.append({"task": task_name, "profiles": child_profiles})
    child_profile_path = root / "replica-task-profiles.json"
    child_profile_doc = {"format": "amoeba-task-profile-v1", "function": "fixture",
                         "task_count": 2, "expected_candidate_count": 16,
                         "completed_candidate_count": 16, "tasks": profile_tasks,
                         "candidate_attempts": attempts}
    child_profile_path.write_text(json.dumps(child_profile_doc))
    child_body_path = root / "replica-body-export.json"
    companion_body_rows = body_rows + [copy.deepcopy(next(row for row in body["tasks"]
                                                          if row["task"] == "B"))]
    child_body_path.write_text(json.dumps({"format": "amoeba-pre-mapper-task-bodies-v1",
                                           "function": "fixture", "task_count": 3,
                                           "tasks": companion_body_rows}))
    evidence = {"schema": validator.REPLICA_PROFILE_EVIDENCE_SCHEMA, "records": [
        {"parent_task": "A", "replica_id": 0, "materialized_task": "A.replica.0",
         "function": "fixture", "materialized_module": str(module_path),
         "profile_file": str(child_profile_path), "body_export_file": str(child_body_path)},
        {"parent_task": "A", "replica_id": 1, "materialized_task": "A.replica.1",
         "function": "fixture", "materialized_module": str(module_path),
         "profile_file": str(child_profile_path), "body_export_file": str(child_body_path)},
    ]}
    domain = [{"ordinal": 0, "lower": 0, "upper": 5, "step": 1}]
    child_proofs = [
        {"replica_id": 0, "materialized_task": "A.replica.0", "trip_count": 3,
         "source_iteration_work_count": 3, "source_iteration_domain_status": "certified-complete",
         "source_iteration_domain_complete": True, "source_iteration_multiplicity": 1,
         "expanded_internal_extents": [], "partition_axis": 0,
         "selected_profile_shape": "1x2", "selected_cgra_count": 2,
         "actual_placed_shape": "1x2", "row": 0,
         "col": 0, "rows": 1, "cols": 2, "actual_cells": cells_a0,
         "context_ids": [0, 1],
         "partition_bounds": [{"ordinal": 0, "lower": 0, "upper": 3, "step": 1}]},
        {"replica_id": 1, "materialized_task": "A.replica.1", "trip_count": 2,
         "source_iteration_work_count": 2, "source_iteration_domain_status": "certified-complete",
         "source_iteration_domain_complete": True, "source_iteration_multiplicity": 1,
         "expanded_internal_extents": [], "partition_axis": 0,
         "selected_profile_shape": "2x1", "selected_cgra_count": 2,
         "actual_placed_shape": "2x1", "row": 2,
         "col": 0, "rows": 2, "cols": 1, "actual_cells": cells_a1,
         "context_ids": [2, 3],
         "partition_bounds": [{"ordinal": 0, "lower": 3, "upper": 5, "step": 1}]},
    ]
    result["original_decisions"] = originals
    result["original_parent_dispatch_order"] = ["A", "B"]
    result["replica_materialization"] = {
        "schema": validator.REPLICA_MATERIALIZATION_SCHEMA, "verified": True,
        "materialized_module": str(module_path),
        "parent_partitions": [{
            "parent_task": "A", "source_iteration_domain_status": "certified-complete",
            "source_iteration_domain_complete": True, "source_iteration_multiplicity": 1,
            "source_iteration_work_count": 5, "expanded_internal_extents": [],
            "original_replica_count": 2, "original_domain": domain,
            "replicas": child_proofs,
        }],
    }
    expanded_order = ["A.replica.0", "A.replica.1", "B"]
    result["dispatch_order"] = expanded_order
    trace = result["fixed_decision_trace"]
    trace["dispatch_order"] = expanded_order
    trace["iteration_domain_coverage_status"] = "pending"
    trace["iteration_domain_coverage_verified"] = False

    expanded_costs = []
    expanded_bindings = []
    for task_name, parent, replica_id, trip, shape, ii, steps, startup, work, cells in (
            ("A.replica.0", "A", 0, 3, "1x2", 4, 3, 17, 3, cells_a0),
            ("A.replica.1", "A", 1, 2, "2x1", 5, 4, 21, 2, cells_a1),
            ("B", "B", None, 5, "1x1", 3, 2, 16, None, cells_b)):
        rows, cols = map(int, shape.split("x"))
        if task_name == "B":
            original_profile = next(row for row in profiles["tasks"][1]["profiles"] if row["composed_cgra_shape"] == "1x1")
            body_row = body["tasks"][1]
            profile_duration = original_profile["estimated_latency"]
            operation_count = original_profile["materialized_operation_count"]
        else:
            selected_child = next(row for task in profile_tasks if task["task"] == task_name
                                  for row in task["profiles"] if row["composed_cgra_shape"] == shape)
            body_row = next(row for row in body_rows if row["task"] == task_name)
            profile_duration = selected_child["estimated_latency"]
            operation_count = selected_child["materialized_operation_count"]
        signature_fields = {key: body_row[key] for key in (
            "task_signature", "counter_signature", "kernel_binding_signature", "normalized_mapper_body")}
        binding_row = {
            "task": task_name, "parent_task": parent, "replica_id": replica_id,
            "static_trip_count": trip, "selected_profile_shape": shape,
            "selected_cgra_count": rows * cols, "selected_mapper_tile_rows": rows * 2,
            "selected_mapper_tile_cols": cols * 2, "compiled_ii": ii, "steps": steps,
            "sample_trip_count": trip, "materialized_operation_count": operation_count,
            "profile_duration_cycles": profile_duration, "catalog_startup_cycles": startup,
            "mapped_duration_cycles": math.ceil(startup + ii * (trip - 1)),
            "mapper_succeeded": True, "current_ir_body_equivalence_verified": True,
            **signature_fields,
        }
        if replica_id is not None:
            binding_row.update({"profile_file": str(child_profile_path),
                                "body_export_file": str(child_body_path),
                                "materialized_task": task_name,
                                "source_iteration_domain_status": "certified-complete",
                                "source_iteration_domain_complete": True,
                                "source_iteration_multiplicity": 1,
                                "source_iteration_work_count": work,
                                "expanded_internal_extents": []})
        expanded_bindings.append(binding_row)
        cost_row = {
            "task": task_name, "parent_task": parent, "replica_id": replica_id,
            "trip_count": trip, "selected_profile_shape": shape,
            "selected_cgra_shape": shape, "selected_cgra_count": rows * cols,
            "selected_mapper_tile_rows": rows * 2, "selected_mapper_tile_cols": cols * 2,
            "profile_compiled_ii": ii, "profile_steps": steps,
            "profile_sample_trip_count": trip, "profile_materialized_operation_count": operation_count,
            "original_profile_duration_cycles": profile_duration,
            "catalog_startup_cycles": startup,
            "mapped_duration_cycles": math.ceil(startup + ii * (trip - 1)),
        }
        if replica_id is not None:
            cost_row.update({"source_iteration_domain_status": "certified-complete",
                             "source_iteration_domain_complete": True,
                             "source_iteration_multiplicity": 1,
                             "source_iteration_work_count": work,
                             "expanded_internal_extents": []})
        expanded_costs.append(cost_row)
    result["task_costs"] = expanded_costs

    schedule = [
        {"task": "A.replica.0", "row": 0, "col": 0, "rows": 1, "cols": 2,
         "start_cycle": 0, "end_cycle": 25, "idle_cycles": 0, "duration_cycles": 25,
         "occupied_cells": cells_a0},
        {"task": "A.replica.1", "row": 2, "col": 0, "rows": 2, "cols": 1,
         "start_cycle": 0, "end_cycle": 26, "idle_cycles": 0, "duration_cycles": 26,
         "occupied_cells": cells_a1},
        {"task": "B", "row": 0, "col": 2, "rows": 1, "cols": 1,
         "start_cycle": 27, "end_cycle": 55, "idle_cycles": 0, "duration_cycles": 28,
         "occupied_cells": cells_b},
    ]
    result["task_schedule"] = schedule
    result["mapped_whole_program_cycles"] = 55
    result["predicted_whole_program_cycles"] = 55
    result["replayed_communication_edges"] = 2
    trace["task_schedule"] = copy.deepcopy(schedule)
    trace["task_profile_bindings"] = expanded_bindings
    trace["dependencies"] = [
        {"edge_index": 0, "edge_id": "edge-0", "producer": "A.replica.0", "consumer": "B",
         "kind": "raw", "origin": "taskflow", "scope": "tensor_wide",
         "producer_segment": "done_writes", "producer_index": 0,
         "consumer_segment": "will_reads", "consumer_index": 0,
         "payload_known": True, "payload_bits": 16,
         "transfer_region_lower": [], "transfer_region_upper": []},
        {"edge_index": 1, "edge_id": "edge-1", "producer": "A.replica.1", "consumer": "B",
         "kind": "control", "origin": "control", "scope": "tile_local",
         "producer_segment": "none", "producer_index": 0,
         "consumer_segment": "control", "consumer_index": 0,
         "payload_known": False, "payload_bits": None,
         "transfer_region_lower": [], "transfer_region_upper": []},
    ]
    trace["routes"] = [{
        "route_id": "A.replica.0->B", "producer": "A.replica.0", "consumer": "B",
        "payload_bits": 16, "path_latency_cycles": 1,
        "bottleneck_bandwidth_bits_per_cycle": 16, "transfer_cycles": 2,
        "source_row": 0, "source_col": 1, "destination_row": 0, "destination_col": 2,
        "producer_finish_cycle": 25, "consumer_start_cycle": 27,
        "start_cycle": 25, "ready_cycle": 27, "edge_indices": [0],
        "intervals": [{"resource_kind": "network_link", "link_index": 1,
                       "start_cycle": 25, "end_cycle": 27}],
    }]
    contract_links = []
    for index, row in enumerate((
            (0, 0, 0, 1), (0, 1, 0, 2), (0, 2, 0, 1))):
        sr, sc, dr, dc = row
        contract_links.append({"link_index": index, "source_row": sr, "source_col": sc,
                               "destination_row": dr, "destination_col": dc,
                               "latency_cycles": 1, "bandwidth_bits_per_cycle": 16})
    trace["communication_contract"] = {
        "schema": "inter-task-network-v1",
        "resource_interval_semantics": "half-open-start-inclusive-end-exclusive",
        "version": 1, "rows": 4, "columns": 4,
        "local_bandwidth_bits_per_cycle": 16, "links": contract_links,
    }
    return ir, result, body, profiles, costs, evidence, temporary


def materialized_facts_fixture(result: dict) -> dict:
    tasks = []
    for cost in result["task_costs"]:
        trip = cost["trip_count"]
        multiplicity = cost.get("source_iteration_multiplicity", 1)
        extents = cost.get("expanded_internal_extents", [])
        tasks.append({
            "task_name": cost["task"],
            "source_iteration_domain_status": "certified-complete",
            "source_iteration_domain_certified": True,
            "source_iteration_domain_complete": True,
            "trip_count_known": True,
            "taskflow_trip_count": trip,
            "effective_mapper_firing_count": trip,
            "source_iteration_work_count": cost.get("source_iteration_work_count", trip * multiplicity),
            "expanded_internal_extents": extents,
        })
    dependencies = []
    for edge in result["fixed_decision_trace"]["dependencies"]:
        payload = edge["payload_bits"]
        dependencies.append({
            "source_task": edge["producer"], "target_task": edge["consumer"],
            "kind": edge["kind"], "origin": edge["origin"], "scope": edge["scope"],
            "producer_segment": edge["producer_segment"], "producer_index": edge["producer_index"],
            "consumer_segment": edge["consumer_segment"], "consumer_index": edge["consumer_index"],
            "payload_bits": payload,
            "payload_bytes": None if payload is None else (payload + 7) // 8,
            "region_lower": None if not edge["transfer_region_lower"] else edge["transfer_region_lower"],
            "region_upper": None if not edge["transfer_region_upper"] else edge["transfer_region_upper"],
        })
    return {"schema": "amoeba-joint-task-graph-facts-v1", "mode": "fact_only",
            "function": "fixture", "tasks": tasks, "dependencies": dependencies}


class OriginalFixedRetimingValidatorTests(unittest.TestCase):
    def setUp(self) -> None:
        self.ir, self.result, self.body, self.profiles, self.costs, self.temporary = fixture()

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def test_valid_trace_including_failed_unselected_shape(self) -> None:
        report = validator.validate(self.ir, self.result, self.body, self.profiles, self.costs)
        self.assertEqual(report["status"], "pass")
        self.assertEqual(report["formal_go"], False)
        self.assertEqual(report["iteration_domain_coverage_status"], "pending")

    def test_finds_pretty_function_symbol(self) -> None:
        self.assertTrue(validator.contains_function_symbol(self.ir, "fixture"))
        self.assertFalse(validator.contains_function_symbol(self.ir, "other"))

    def test_finds_generic_function_symbol(self) -> None:
        generic = '''module {
  "func.func"() <{function_type = () -> (), sym_name = "fixture"}> ({
  }) : () -> ()
}'''
        self.assertTrue(validator.contains_function_symbol(generic, "fixture"))
        self.assertFalse(validator.contains_function_symbol(generic, "other"))
        self.assertFalse(validator.contains_function_symbol(
            '"other.op"() <{sym_name = "fixture"}> : () -> ()', "fixture"))

    def assert_invalid_after(self, mutate) -> None:
        result = copy.deepcopy(self.result)
        body = copy.deepcopy(self.body)
        profiles = copy.deepcopy(self.profiles)
        costs = copy.deepcopy(self.costs)
        mutate(result, body, profiles, costs)
        with self.assertRaises(ValueError):
            validator.validate(self.ir, result, body, profiles, costs)

    def test_rejects_corrupt_body_binding(self) -> None:
        self.assert_invalid_after(lambda result, body, profiles, costs: result["fixed_decision_trace"]["task_profile_bindings"][0].__setitem__("normalized_mapper_body", "forged"))

    def test_rejects_corrupt_selected_profile(self) -> None:
        self.assert_invalid_after(lambda result, body, profiles, costs: profiles["tasks"][0]["profiles"][0].__setitem__("compiled_ii", 4))

    def test_rejects_geometry_change(self) -> None:
        self.assert_invalid_after(lambda result, body, profiles, costs: result["fixed_decision_trace"]["task_schedule"][0]["occupied_cells"][0].__setitem__("col", 2))

    def test_rejects_discontinuous_route(self) -> None:
        self.assert_invalid_after(lambda result, body, profiles, costs: result["fixed_decision_trace"]["routes"][0]["intervals"][0].__setitem__("link_index", 1))

    def test_rejects_corrupt_route_interval(self) -> None:
        self.assert_invalid_after(lambda result, body, profiles, costs: result["fixed_decision_trace"]["routes"][0]["intervals"][0].__setitem__("end_cycle", 18))

    def test_accepts_sparse_failed_single_parent_profile_rows(self) -> None:
        task = next(row for row in self.profiles["tasks"] if row["task"] == "A")
        task["profiles"] = [row for row in task["profiles"]
                            if row["composed_cgra_shape"] != "4x1"]
        attempt = next(row for row in self.profiles["candidate_attempts"]
                       if row["task"] == "A" and row["shape"] == "4x1")
        attempt["profile_created"] = False
        profile_path = Path(self.costs["original_amoeba_profile_binding"]["profile_file"])
        profile_path.write_text(json.dumps(self.profiles))
        self.assertEqual(validator.validate(
            self.ir, self.result, self.body, self.profiles, self.costs)["status"], "pass")

    def test_rejects_forged_profile_created_for_single_parent(self) -> None:
        attempt = next(row for row in self.profiles["candidate_attempts"]
                       if row["task"] == "A" and row["shape"] == "4x1")
        attempt["profile_created"] = False
        profile_path = Path(self.costs["original_amoeba_profile_binding"]["profile_file"])
        profile_path.write_text(json.dumps(self.profiles))
        with self.assertRaises(ValueError):
            validator.validate(self.ir, self.result, self.body, self.profiles, self.costs)

    def test_accepts_legacy_ii20_profile_without_attempt_inventory(self) -> None:
        self.profiles.pop("candidate_attempts")
        profile_path = Path(self.costs["original_amoeba_profile_binding"]["profile_file"])
        profile_path.write_text(json.dumps(self.profiles))
        self.assertEqual(validator.validate(
            self.ir, self.result, self.body, self.profiles, self.costs)["status"], "pass")


class F45ReplicaTimingPolicyValidatorTests(unittest.TestCase):
    def setUp(self) -> None:
        (self.ir, self.result, self.body, self.profiles,
         self.costs, self.temporary) = f45_replica_fixture()

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def validate_current(self) -> dict:
        profile_path = Path(self.costs["original_amoeba_profile_binding"]["profile_file"])
        profile_path.write_text(json.dumps(self.profiles))
        return validator.validate(self.ir, self.result, self.body,
                                  self.profiles, self.costs)

    def assert_invalid_after(self, mutate) -> None:
        ir = self.ir
        result = copy.deepcopy(self.result)
        body = copy.deepcopy(self.body)
        profiles = copy.deepcopy(self.profiles)
        costs = copy.deepcopy(self.costs)
        changed_ir = mutate(ir, result, body, profiles, costs)
        if isinstance(changed_ir, str):
            ir = changed_ir
        profile_path = Path(costs["original_amoeba_profile_binding"]["profile_file"])
        profile_path.write_text(json.dumps(profiles))
        with self.assertRaises(ValueError):
            validator.validate(ir, result, body, profiles, costs)

    def test_accepts_explicit_original_f45_estimate_and_full_replica_inventory(self) -> None:
        self.assertEqual(self.validate_current()["status"], "pass")
        decision_a, decision_b = self.result["original_decisions"]
        self.assertEqual(decision_a["original_profile_duration_cycles"], 8)
        self.assertEqual(decision_a["original_profile_duration_binding"][
            "full_parent_mapper_duration_cycles"], 15)
        self.assertEqual(decision_a["replicas"][1]["shape"], "2x1")
        self.assertEqual(decision_a["actual_cells"],
                         self.result["task_schedule"][0]["occupied_cells"])
        self.assertNotIn("replicas", decision_b)
        costs = {row["task"]: row for row in self.result["task_costs"]}
        bindings = {row["task"]: row for row in self.result["fixed_decision_trace"][
            "task_profile_bindings"]}
        self.assertEqual(costs["A"]["full_parent_mapped_duration_cycles"], 14)
        self.assertEqual(costs["A"]["mapped_duration_cycles"], 7)
        self.assertEqual(bindings["A"]["profile_duration_cycles"], 8)
        self.assertEqual(costs["B"]["original_active_replicas"], 1)

    def test_rejects_missing_or_mismatched_policy_copy(self) -> None:
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
                                  result.pop("replica_timing_policy"))
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
                                  result["fixed_decision_trace"]["replica_timing_policy"].update(
                                      {"status": "child-profile-estimate"}))

    def test_rejects_policy_schema_extra_field_or_wrong_mode(self) -> None:
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
                                  result["replica_timing_policy"].update({"extra": True}))
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
                                  result["replica_timing_policy"].update(
                                      {"child_mapper_profiles_used": True}))
        with self.assertRaises(ValueError):
            validator.validate(self.ir, self.result, self.body, self.profiles,
                               self.costs, diagnostic_ii_ceiling=23)

    def test_rejects_multi_replica_source_without_explicit_policy(self) -> None:
        def remove_policy(ir, result, body, profiles, costs):
            result.pop("replica_timing_policy")
            result["fixed_decision_trace"].pop("replica_timing_policy")
        self.assert_invalid_after(remove_policy)

    def test_rejects_wrong_full_parent_mapped_duration_and_unscaled_task_duration(self) -> None:
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
            result["task_costs"][0].__setitem__("full_parent_mapped_duration_cycles", 7))
        def use_unscaled_duration(ir, result, body, profiles, costs):
            for row in (result["task_costs"][0],
                        result["fixed_decision_trace"]["task_profile_bindings"][0]):
                row["mapped_duration_cycles"] = 14
            for rows in (result["task_schedule"], result["fixed_decision_trace"]["task_schedule"]):
                rows[0]["end_cycle"] = 14
                rows[0]["duration_cycles"] = 14
        self.assert_invalid_after(use_unscaled_duration)

    def test_rejects_forged_f45_profile_ceil_even_if_source_and_reports_agree(self) -> None:
        def underround(ir, result, body, profiles, costs):
            result["original_decisions"][0]["original_profile_duration_cycles"] = 7
            result["original_decisions"][0]["original_profile_duration_binding"][
                "f45_scheduler_duration_cycles"] = 7
            result["fixed_decision_trace"]["task_profile_bindings"][0][
                "profile_duration_cycles"] = 7
            result["task_costs"][0]["original_profile_duration_cycles"] = 7
            return ir.replace("duration = 8 : i64", "duration = 7 : i64", 1)
        self.assert_invalid_after(underround)

    def test_rejects_wrong_or_nonexact_split_duration_certificate(self) -> None:
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
            result["original_decisions"][0]["original_profile_duration_binding"].update(
                {"full_parent_mapper_duration_cycles": 14}))
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
            result["original_decisions"][0]["original_profile_duration_binding"].pop("steps"))
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
            result["original_decisions"][1].update({
                "original_profile_duration_binding": copy.deepcopy(
                    result["original_decisions"][0]["original_profile_duration_binding"])}))

    def test_rejects_noninteger_duration_certificate_fields(self) -> None:
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
            result["original_decisions"][0]["original_profile_duration_binding"].update(
                {"compiled_ii": 3.0}))
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
            result["original_decisions"][0]["original_profile_duration_binding"].update(
                {"materialized_operation_count": True}))

    def test_rejects_implicit_singleton_schema_growth(self) -> None:
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
            result["original_decisions"][1].update({"replicas": [
                {"replica_id": 0, "shape": "1x1", "cgra_count": 1,
                 "row": 0, "col": 2, "rows": 1, "cols": 1,
                 "actual_cells": [{"row": 0, "col": 2, "replica_id": 0,
                                   "context_id": 4}], "context_ids": [4]}]}))

    def test_rejects_missing_duplicate_or_reoriented_replica_geometry(self) -> None:
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
                                  result["original_decisions"][0]["replicas"].pop())
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
                                  result["original_decisions"][0]["replicas"][1].update(
                                      {"replica_id": 0}))
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
                                  result["original_decisions"][0]["replicas"][1].update(
                                      {"shape": "1x2"}))

    def test_rejects_placement_array_order_and_context_forgery(self) -> None:
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
            result["original_decisions"][0]["actual_cells"].reverse())
        def bad_context(ir, result, body, profiles, costs):
            return ir.replace("context_id = 3 : i32", "context_id = 6 : i32", 1)
        self.assert_invalid_after(bad_context)

    def test_rejects_missing_second_replica_occupancy_and_wrong_primary_rectangle(self) -> None:
        def omit_second_replica(ir, result, body, profiles, costs):
            for rows in (result["task_schedule"],
                        result["fixed_decision_trace"]["task_schedule"]):
                rows[0]["occupied_cells"] = rows[0]["occupied_cells"][:2]
        self.assert_invalid_after(omit_second_replica)
        def report_secondary_as_primary(ir, result, body, profiles, costs):
            for rows in (result["task_schedule"],
                        result["fixed_decision_trace"]["task_schedule"]):
                rows[0].update({"row": 2, "col": 0, "rows": 2, "cols": 1})
        self.assert_invalid_after(report_secondary_as_primary)


class ProductionSchedulerRescheduleValidatorTests(unittest.TestCase):
    def setUp(self) -> None:
        self.set_fixture()

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def set_fixture(self, independent_tasks: bool = False) -> None:
        (self.ir, self.result, self.body, self.profiles, self.costs,
         self.temporary) = production_scheduler_fixture(independent_tasks)

    def validate_current(self) -> dict:
        profile_path = Path(self.costs["original_amoeba_profile_binding"]["profile_file"])
        profile_path.write_text(json.dumps(self.profiles))
        return validator.validate(self.ir, self.result, self.body,
                                  self.profiles, self.costs)

    def assert_invalid_after(self, mutate) -> None:
        ir = self.ir
        result = copy.deepcopy(self.result)
        body = copy.deepcopy(self.body)
        profiles = copy.deepcopy(self.profiles)
        costs = copy.deepcopy(self.costs)
        changed_ir = mutate(ir, result, body, profiles, costs)
        if isinstance(changed_ir, str):
            ir = changed_ir
        profile_path = Path(costs["original_amoeba_profile_binding"]["profile_file"])
        profile_path.write_text(json.dumps(profiles))
        with self.assertRaises(ValueError):
            validator.validate(ir, result, body, profiles, costs)

    def test_accepts_new_placements_with_selected_shape_and_original_f45_evidence(self) -> None:
        report = self.validate_current()
        self.assertEqual(report["status"], "pass")
        self.assertEqual(report["scheduler"], validator.PRODUCTION_SCHEDULER_POLICY)
        self.assertTrue(report["shared_scheduler_resource_only"])
        original_a = self.result["original_decisions"][0]
        self.assertEqual(original_a["replicas"][1]["shape"], "2x1")
        output_a = next(row for row in self.result["task_schedule"] if row["task"] == "A")
        replica_one = [cell for cell in output_a["occupied_cells"]
                       if cell["replica_id"] == 1]
        self.assertEqual({(cell["row"], cell["col"]) for cell in replica_one},
                         {(2, 0), (2, 1)})
        self.assertEqual(output_a["duration_cycles"], 7)

    def test_accepts_a_legal_alternate_topological_dispatch(self) -> None:
        self.temporary.cleanup()
        self.set_fixture(independent_tasks=True)
        report = self.validate_current()
        self.assertEqual(report["status"], "pass")
        self.assertEqual(self.result["dispatch_order"], ["B", "A"])
        self.assertEqual(self.result["original_decisions"][0]["dispatch_index"], 0)
        self.assertEqual(self.result["original_decisions"][1]["dispatch_index"], 1)

    def test_rejects_missing_or_changed_scheduler_witness(self) -> None:
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
                                  result.pop("scheduler"))
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
                                  result["fixed_decision_trace"]["scheduler"].update(
                                      {"timing": "legacy-fixed-decisions"}))
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
                                  result["fixed_decision_trace"].pop(
                                      "production_scheduler_decisions"))
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
                                  result["production_scheduler_decisions"][
                                      "dispatch_order"].reverse())

    def test_rejects_rescheduler_mode_without_original_f45_replica_policy(self) -> None:
        def remove_policy(ir, result, body, profiles, costs):
            result.pop("replica_timing_policy")
            result["fixed_decision_trace"].pop("replica_timing_policy")
        self.assert_invalid_after(remove_policy)

    def test_rejects_changed_original_f45_contexts_or_internal_dispatch(self) -> None:
        def alter_original_context(ir, result, body, profiles, costs):
            result["original_decisions"][0]["actual_cells"][0]["context_id"] = 5
        self.assert_invalid_after(alter_original_context)

        def alter_source_dispatch(ir, result, body, profiles, costs):
            return ir.replace('amoeba.task_scheduler_dispatch_order = ["A", "B"]',
                              'amoeba.task_scheduler_dispatch_order = ["B", "A"]')
        self.assert_invalid_after(alter_source_dispatch)

    def test_rejects_per_replica_shape_count_or_replica_count_drift(self) -> None:
        def rotate_new_replica(ir, result, body, profiles, costs):
            schedule = next(row for row in result["task_schedule"] if row["task"] == "A")
            for cell in schedule["occupied_cells"]:
                if cell["replica_id"] == 1:
                    cell["row"], cell["col"] = ((2, 2) if cell["col"] == 0
                                                  else (3, 2))
            _sync_production_scheduler_witness(result)
        self.assert_invalid_after(rotate_new_replica)

        def drop_one_cgra(ir, result, body, profiles, costs):
            schedule = next(row for row in result["task_schedule"] if row["task"] == "A")
            schedule["occupied_cells"].pop(0)
            _sync_production_scheduler_witness(result)
        self.assert_invalid_after(drop_one_cgra)

        def drop_replica(ir, result, body, profiles, costs):
            schedule = next(row for row in result["task_schedule"] if row["task"] == "A")
            schedule["occupied_cells"] = [cell for cell in schedule["occupied_cells"]
                                           if cell["replica_id"] == 0]
            _sync_production_scheduler_witness(result)
        self.assert_invalid_after(drop_replica)

    def test_rejects_changed_duration_after_ceil_parent_replica_scaling(self) -> None:
        def understate_duration(ir, result, body, profiles, costs):
            task_cost = next(row for row in result["task_costs"] if row["task"] == "A")
            task_cost["mapped_duration_cycles"] = 6
            binding = next(row for row in result["fixed_decision_trace"][
                "task_profile_bindings"] if row["task"] == "A")
            binding["mapped_duration_cycles"] = 6
            schedule = next(row for row in result["task_schedule"] if row["task"] == "A")
            schedule["end_cycle"] = 6
            schedule["duration_cycles"] = 6
            _sync_production_scheduler_witness(result)
        self.assert_invalid_after(understate_duration)

    def test_rejects_body_proof_or_production_schedule_forgery(self) -> None:
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
                                  body["tasks"][0].__setitem__("normalized_mapper_body", "forged"))
        self.assert_invalid_after(lambda ir, result, body, profiles, costs:
                                  result["task_schedule"][0].__setitem__("row", 3))

    def test_rejects_invalid_output_context_and_out_of_order_dependency(self) -> None:
        def bad_context(ir, result, body, profiles, costs):
            schedule = next(row for row in result["task_schedule"] if row["task"] == "B")
            schedule["occupied_cells"][0]["context_id"] = 6
            _sync_production_scheduler_witness(result)
        self.assert_invalid_after(bad_context)

        def reverse_dependency(ir, result, body, profiles, costs):
            result["dispatch_order"] = ["B", "A"]
            result["task_schedule"] = [result["task_schedule"][1],
                                       result["task_schedule"][0]]
            _sync_production_scheduler_witness(result)
        self.assert_invalid_after(reverse_dependency)

    def test_rejects_route_endpoint_and_resource_overlap_on_new_cells(self) -> None:
        def route_to_old_cell(ir, result, body, profiles, costs):
            result["fixed_decision_trace"]["routes"][0]["source_row"] = 3
        self.assert_invalid_after(route_to_old_cell)

        self.temporary.cleanup()
        self.set_fixture(independent_tasks=True)
        def overlap_tasks(ir, result, body, profiles, costs):
            b_schedule = next(row for row in result["task_schedule"] if row["task"] == "B")
            b_schedule.update({"row": 0, "col": 0})
            b_schedule["occupied_cells"] = [
                {"row": 0, "col": 0, "replica_id": 0, "context_id": 0}]
            a_schedule = next(row for row in result["task_schedule"] if row["task"] == "A")
            a_schedule["occupied_cells"][0]["context_id"] = 1
            _sync_production_scheduler_witness(result)
        self.assert_invalid_after(overlap_tasks)

    def test_rejects_expanded_child_mode_explicitly(self) -> None:
        with self.assertRaisesRegex(ValueError, "does not support expanded child mode"):
            validator.validate(self.ir, self.result, self.body, self.profiles,
                               self.costs, replica_profile_evidence={})


class ExpandedOriginalReplicaRetimingValidatorTests(unittest.TestCase):
    def setUp(self) -> None:
        (self.ir, self.result, self.body, self.profiles, self.costs,
         self.evidence, self.temporary) = expanded_fixture()
        self.materialized_facts = materialized_facts_fixture(self.result)

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def validate_current(self) -> dict:
        return validator.validate(
            self.ir, self.result, self.body, self.profiles, self.costs,
            self.costs["original_amoeba_profile_binding"]["architecture_text"],
            20, None, self.evidence, self.materialized_facts,
        )

    def assert_expanded_invalid_after(self, mutate) -> None:
        result = copy.deepcopy(self.result)
        body = copy.deepcopy(self.body)
        profiles = copy.deepcopy(self.profiles)
        costs = copy.deepcopy(self.costs)
        evidence = copy.deepcopy(self.evidence)
        facts = copy.deepcopy(self.materialized_facts)
        mutate(result, body, profiles, costs, evidence)
        with self.assertRaises(ValueError):
            validator.validate(
                self.ir, result, body, profiles, costs,
                costs["original_amoeba_profile_binding"]["architecture_text"],
                20, None, evidence, facts,
            )

    def assert_materialized_facts_invalid_after(self, mutate) -> None:
        result = copy.deepcopy(self.result)
        facts = copy.deepcopy(self.materialized_facts)
        mutate(result, facts)
        with self.assertRaises(ValueError):
            validator.validate(
                self.ir, result, self.body, self.profiles, self.costs,
                self.costs["original_amoeba_profile_binding"]["architecture_text"],
                20, None, self.evidence, facts,
            )

    def assert_graph_fact_mismatch_after(self, mutate) -> None:
        result = copy.deepcopy(self.result)
        mutate(result)
        with self.assertRaisesRegex(ValueError, "independently extracted materialized graph facts"):
            validator.validate(
                self.ir, result, self.body, self.profiles, self.costs,
                self.costs["original_amoeba_profile_binding"]["architecture_text"],
                20, None, self.evidence, self.materialized_facts,
            )

    def test_accepts_actual_child_profiles_and_orientation_startup(self) -> None:
        report = self.validate_current()
        self.assertEqual(report["status"], "pass")
        self.assertEqual(report["original_parent_count"], 2)
        self.assertEqual(report["task_count"], 3)
        self.assertEqual(report["mapped_whole_program_cycles"], 55)
        split_parent = self.result["original_decisions"][0]
        duration_binding = split_parent["original_profile_duration_binding"]
        self.assertEqual(split_parent["original_profile_duration_cycles"], 8)
        self.assertEqual(duration_binding["full_parent_mapper_duration_cycles"], 15)
        self.assertEqual(duration_binding["f45_scheduler_duration_cycles"], 8)
        self.assertEqual(duration_binding["active_replicas"], 2)
        self.assertNotIn("original_profile_duration_binding", self.result["original_decisions"][1])
        costs = {row["task"]: row for row in self.result["task_costs"]}
        self.assertEqual(costs["A.replica.0"]["catalog_startup_cycles"], 17)
        self.assertEqual(costs["A.replica.1"]["catalog_startup_cycles"], 21)
        self.assertEqual(costs["A.replica.0"]["mapped_duration_cycles"], 25)
        self.assertEqual(costs["A.replica.1"]["mapped_duration_cycles"], 26)

    def test_rejects_forged_full_parent_mapper_duration_certificate(self) -> None:
        self.assert_expanded_invalid_after(lambda result, body, profiles, costs, evidence:
            result["original_decisions"][0]["original_profile_duration_binding"].__setitem__(
                "full_parent_mapper_duration_cycles", 16))

    def test_rejects_original_parent_mapper_II_above_runtime_ceiling(self) -> None:
        parent_profile = next(row for task in self.profiles["tasks"]
                              if task["task"] == "A" for row in task["profiles"]
                              if row["composed_cgra_shape"] == "1x2")
        parent_profile["compiled_ii"] = 21
        parent_profile["estimated_latency"] = (21 * (parent_profile["sample_trip_count"] - 1)
                                               + parent_profile["steps"])
        profile_path = Path(self.costs["original_amoeba_profile_binding"]["profile_file"])
        profile_path.write_text(json.dumps(self.profiles))
        with self.assertRaisesRegex(ValueError, "runtime control-memory ceiling"):
            self.validate_current()

    def test_rejects_forged_f45_duration_or_ceil_relation(self) -> None:
        def mutate_report_duration(result, body, profiles, costs, evidence):
            original = result["original_decisions"][0]
            original["original_profile_duration_cycles"] = 7
            original["original_profile_duration_binding"]["f45_scheduler_duration_cycles"] = 7
        self.assert_expanded_invalid_after(mutate_report_duration)

        result = copy.deepcopy(self.result)
        original = result["original_decisions"][0]
        original["original_profile_duration_cycles"] = 7
        original["original_profile_duration_binding"]["f45_scheduler_duration_cycles"] = 7
        ir = self.ir.replace("active_replicas = 2 : i64, duration = 8 : i64",
                             "active_replicas = 2 : i64, duration = 7 : i64", 1)
        with self.assertRaisesRegex(ValueError, "F45 duration/full mapper duration certificate"):
            validator.validate(
                ir, result, self.body, self.profiles, self.costs,
                self.costs["original_amoeba_profile_binding"]["architecture_text"],
                20, None, self.evidence, self.materialized_facts,
            )

    def test_rejects_forged_duration_binding_profile_fields(self) -> None:
        self.assert_expanded_invalid_after(lambda result, body, profiles, costs, evidence:
            result["original_decisions"][0]["original_profile_duration_binding"].__setitem__(
                "compiled_ii", 4))
        self.assert_expanded_invalid_after(lambda result, body, profiles, costs, evidence:
            result["original_decisions"][0]["original_profile_duration_binding"].pop(
                "rounding_rule"))

    def test_accepts_failed_shapes_only_in_explicit_attempt_inventory(self) -> None:
        profile_path = Path(self.evidence["records"][0]["profile_file"])
        child_profile = json.loads(profile_path.read_text())
        for task in child_profile["tasks"]:
            task["profiles"] = [row for row in task["profiles"]
                                if row["mapper_succeeded"]]
        for attempt in child_profile["candidate_attempts"]:
            if not attempt["mapper_succeeded"]:
                attempt["profile_created"] = False
        profile_path.write_text(json.dumps(child_profile))
        self.assertEqual(self.validate_current()["status"], "pass")

    def test_accepts_sparse_failed_parent_profile_rows(self) -> None:
        profile_path = Path(self.costs["original_amoeba_profile_binding"]["profile_file"])
        parent_profiles = json.loads(profile_path.read_text())
        task = next(row for row in parent_profiles["tasks"] if row["task"] == "A")
        task["profiles"] = [row for row in task["profiles"]
                            if row["composed_cgra_shape"] != "4x1"]
        attempt = next(row for row in parent_profiles["candidate_attempts"]
                       if row["task"] == "A" and row["shape"] == "4x1")
        attempt["profile_created"] = False
        profile_path.write_text(json.dumps(parent_profiles))
        self.profiles = parent_profiles
        self.assertEqual(self.validate_current()["status"], "pass")

    def test_rejects_missing_child_attempt(self) -> None:
        profile_path = Path(self.evidence["records"][0]["profile_file"])
        child_profile = json.loads(profile_path.read_text())
        child_profile["candidate_attempts"].pop()
        profile_path.write_text(json.dumps(child_profile))
        with self.assertRaises(ValueError):
            self.validate_current()

    def test_rejects_swapped_child_attempt_shape_indices(self) -> None:
        profile_path = Path(self.evidence["records"][0]["profile_file"])
        child_profile = json.loads(profile_path.read_text())
        attempts = {row["shape"]: row for row in child_profile["candidate_attempts"]
                    if row["task"] == "A.replica.0"}
        attempts["1x1"]["candidate_index_in_task"], attempts["1x2"]["candidate_index_in_task"] = (
            attempts["1x2"]["candidate_index_in_task"], attempts["1x1"]["candidate_index_in_task"])
        profile_path.write_text(json.dumps(child_profile))
        with self.assertRaises(ValueError):
            self.validate_current()

    def test_rejects_wrong_child_attempt_cgra_count(self) -> None:
        profile_path = Path(self.evidence["records"][0]["profile_file"])
        child_profile = json.loads(profile_path.read_text())
        attempt = next(row for row in child_profile["candidate_attempts"]
                       if row["task"] == "A.replica.0" and row["shape"] == "1x2")
        attempt["composed_cgra_count"] = 1
        profile_path.write_text(json.dumps(child_profile))
        with self.assertRaises(ValueError):
            self.validate_current()

    def test_rejects_forged_child_profile_created_flag(self) -> None:
        profile_path = Path(self.evidence["records"][0]["profile_file"])
        child_profile = json.loads(profile_path.read_text())
        attempt = next(row for row in child_profile["candidate_attempts"]
                       if row["task"] == "A.replica.0" and row["shape"] == "1x1")
        attempt["profile_created"] = False
        profile_path.write_text(json.dumps(child_profile))
        with self.assertRaises(ValueError):
            self.validate_current()

    def test_rejects_forged_original_shape_or_replica_ids(self) -> None:
        self.assert_expanded_invalid_after(lambda result, body, profiles, costs, evidence:
            result["original_decisions"][0]["replicas"][0].__setitem__("shape", "2x1"))
        self.assert_expanded_invalid_after(lambda result, body, profiles, costs, evidence:
            evidence["records"][0].__setitem__("replica_id", 1))

    def test_rejects_parent_and_replica_order_changes(self) -> None:
        self.assert_expanded_invalid_after(lambda result, body, profiles, costs, evidence:
            result["original_parent_dispatch_order"].reverse())
        self.assert_expanded_invalid_after(lambda result, body, profiles, costs, evidence:
            result["dispatch_order"].reverse())

    def test_rejects_forged_child_body_and_profile(self) -> None:
        body_path = Path(self.evidence["records"][0]["body_export_file"])
        child_body = json.loads(body_path.read_text())
        child_body["tasks"][0]["normalized_mapper_body"] = "forged body"
        body_path.write_text(json.dumps(child_body))
        with self.assertRaises(ValueError):
            self.validate_current()

    def test_rejects_profile_II_that_has_no_matching_trace_binding(self) -> None:
        profile_path = Path(self.evidence["records"][0]["profile_file"])
        child_profile = json.loads(profile_path.read_text())
        profile = next(row for task in child_profile["tasks"]
                       if task["task"] == "A.replica.0"
                       for row in task["profiles"]
                       if row["composed_cgra_shape"] == "1x2")
        profile["compiled_ii"] += 1
        profile["estimated_latency"] = profile["compiled_ii"] * (profile["sample_trip_count"] - 1) + profile["steps"]
        profile_path.write_text(json.dumps(child_profile))
        with self.assertRaises(ValueError):
            self.validate_current()

    def test_rejects_child_profile_above_runtime_control_memory_ceiling(self) -> None:
        profile_path = Path(self.evidence["records"][0]["profile_file"])
        child_profile = json.loads(profile_path.read_text())
        profile = next(row for task in child_profile["tasks"]
                       if task["task"] == "A.replica.0"
                       for row in task["profiles"]
                       if row["composed_cgra_shape"] == "1x2")
        profile["compiled_ii"] = 21
        profile["estimated_latency"] = (profile["compiled_ii"]
                                        * (profile["sample_trip_count"] - 1)
                                        + profile["steps"])
        profile_path.write_text(json.dumps(child_profile))
        with self.assertRaisesRegex(ValueError, "runtime control-memory ceiling"):
            self.validate_current()

    def test_rejects_missing_singleton_from_companion_body_export(self) -> None:
        body_path = Path(self.evidence["records"][0]["body_export_file"])
        child_body = json.loads(body_path.read_text())
        child_body["tasks"] = [row for row in child_body["tasks"] if row["task"] != "B"]
        child_body["task_count"] = len(child_body["tasks"])
        body_path.write_text(json.dumps(child_body))
        with self.assertRaisesRegex(ValueError, "materialized module task inventory"):
            self.validate_current()

    def test_rejects_extra_task_in_companion_body_export(self) -> None:
        body_path = Path(self.evidence["records"][0]["body_export_file"])
        child_body = json.loads(body_path.read_text())
        child_body["tasks"].append({"task": "unexpected.materialized.task"})
        child_body["task_count"] = len(child_body["tasks"])
        body_path.write_text(json.dumps(child_body))
        with self.assertRaisesRegex(ValueError, "materialized module task inventory"):
            self.validate_current()

    def test_rejects_partition_trip_startup_and_coverage_forgery(self) -> None:
        self.assert_expanded_invalid_after(lambda result, body, profiles, costs, evidence:
            result["replica_materialization"]["parent_partitions"][0]["replicas"][0].__setitem__("trip_count", 4))
        self.assert_expanded_invalid_after(lambda result, body, profiles, costs, evidence:
            result["task_costs"][0].__setitem__("catalog_startup_cycles", 999))
        self.assert_expanded_invalid_after(lambda result, body, profiles, costs, evidence:
            result["fixed_decision_trace"].__setitem__("iteration_domain_coverage_verified", True))

    def test_rejects_non_covering_source_partition(self) -> None:
        self.assert_expanded_invalid_after(lambda result, body, profiles, costs, evidence:
            result["replica_materialization"]["parent_partitions"][0]["replicas"][1]["partition_bounds"][0].__setitem__("lower", 4))

    def test_rejects_typed_edge_route_and_occupancy_forgery(self) -> None:
        self.assert_expanded_invalid_after(lambda result, body, profiles, costs, evidence:
            result["fixed_decision_trace"]["dependencies"][0].__setitem__("producer", "A"))
        self.assert_expanded_invalid_after(lambda result, body, profiles, costs, evidence:
            result["fixed_decision_trace"]["routes"][0]["intervals"][0].__setitem__("link_index", 0))
        self.assert_expanded_invalid_after(lambda result, body, profiles, costs, evidence:
            result["task_schedule"][1].__setitem__("occupied_cells", result["task_schedule"][0]["occupied_cells"]))

    def test_rejects_deleted_dependency_even_when_trace_counts_are_adjusted(self) -> None:
        def delete_edge(result):
            result["fixed_decision_trace"]["dependencies"].pop()
            result["replayed_communication_edges"] = 1
        self.assert_graph_fact_mismatch_after(delete_edge)

    def test_rejects_moved_dependency_endpoint_even_when_trace_counts_are_adjusted(self) -> None:
        def move_edge(result):
            result["fixed_decision_trace"]["dependencies"][1]["producer"] = "A.replica.0"
            result["replayed_communication_edges"] = 1
        self.assert_graph_fact_mismatch_after(move_edge)

    def test_rejects_materialized_task_source_trip_or_work_forgery(self) -> None:
        self.assert_materialized_facts_invalid_after(lambda result, facts:
            facts["tasks"][0].__setitem__("taskflow_trip_count", 4))
        self.assert_materialized_facts_invalid_after(lambda result, facts:
            facts["tasks"][0].__setitem__("source_iteration_work_count", 4))

    def test_rejects_materialized_dependency_inventory_forgery(self) -> None:
        self.assert_materialized_facts_invalid_after(lambda result, facts:
            facts["dependencies"].pop())

    def test_rejects_child_trip_count_not_equal_to_partition_volume(self) -> None:
        self.assert_expanded_invalid_after(lambda result, body, profiles, costs, evidence:
            result["replica_materialization"]["parent_partitions"][0]["replicas"][0]["partition_bounds"][0].__setitem__("upper", 2))

    def test_rejects_context_id_outside_six_contexts(self) -> None:
        ir = self.ir.replace("context_id = 0 : i32", "context_id = 6 : i32", 1)
        with self.assertRaises(ValueError):
            validator.validate(
                ir, self.result, self.body, self.profiles, self.costs,
                self.costs["original_amoeba_profile_binding"]["architecture_text"],
                20, None, self.evidence, self.materialized_facts,
            )

    def test_replica_evidence_requires_materialized_source_facts(self) -> None:
        with self.assertRaisesRegex(ValueError, "materialized source facts"):
            validator.validate(
                self.ir, self.result, self.body, self.profiles, self.costs,
                self.costs["original_amoeba_profile_binding"]["architecture_text"],
                20, None, self.evidence,
            )


if __name__ == "__main__":
    unittest.main()
