#!/usr/bin/env python3
"""Independently validate a diagnostic original-AMOEBA fixed retiming trace.

This validator consumes source orchestrator evidence, actual mapper profile and
pre-mapper body exports, the selected-shape cost catalog, and the C++ retimer's
explicit network/dependency/route record. It is intentionally separate from
the normal mapper-replay validator: a passing result remains diagnostic and
does not certify mapper replay. Source coverage is accepted only when its
explicit evidence status agrees with the source-owned retimer trace.
"""

from __future__ import annotations

import argparse
from collections import Counter
import json
import math
from pathlib import Path
import re
import sys
from typing import Any

TOKEN = re.compile(
    r'\s*(?:((?:"(?:\\.|[^"\\])*"))|(-?[0-9]+)|'
    r'([A-Za-z_][A-Za-z0-9_.-]*)|([{}\[\],=:]))'
)
EXPECTED_SHAPES = {"1x1", "1x2", "2x1", "1x3", "3x1", "1x4", "4x1", "2x2"}
EXPECTED_SHAPE_ORDER = ("1x1", "1x2", "2x1", "1x3", "3x1", "2x2", "1x4", "4x1")
DIAGNOSTIC_II_SCHEMA = "per-cgra-2x2-ii-extrapolation-v1"
DIAGNOSTIC_OUTPUT_RULE = "min(lower_bound + softplus(logit), diagnostic_runtime_ii_ceiling)"
REPLICA_PROFILE_EVIDENCE_SCHEMA = "amoeba-original-replica-profile-evidence-v1"
REPLICA_MATERIALIZATION_SCHEMA = "amoeba-original-replica-materialization-v1"
F45_REPLICA_TIMING_POLICY = {
    "schema": "amoeba-original-f45-replica-scaling-v1",
    "duration_formula": "ceil(ceil(catalog_startup_cycles + compiled_ii * (source_macro_firings - 1)) / original_active_replicas)",
    "replica_duration_rule": "ceil-full-parent-mapped-duration-over-original-active-replicas-v1",
    "child_mapper_profiles_used": False,
    "status": "original-f45-scheduler-estimate",
}
PRODUCTION_SCHEDULER_POLICY = {
    "backend": "orbit-production",
    "dispatch_policy": "critical-path",
    "timing": "common-explicit-network",
}
MAX_CONTEXTS_PER_CGRA = 6


def _has_production_scheduler_reschedule(result: dict[str, Any]) -> bool:
    trace = result.get("fixed_decision_trace")
    fields = {"scheduler", "shared_scheduler_resource_only",
              "production_scheduler_decisions"}
    return any(fields.intersection(record)
               for record in (result, trace) if isinstance(record, dict))


def _validate_production_scheduler_contract(
        result: dict[str, Any], trace: dict[str, Any],
        explicit_f45_replica_mode: bool) -> dict[str, Any] | None:
    if not _has_production_scheduler_reschedule(result):
        return None
    if not explicit_f45_replica_mode:
        raise ValueError("production-scheduler rescheduling requires explicit original F45 replica timing policy")
    for label, record in (("result", result), ("fixed trace", trace)):
        if (record.get("scheduler") != PRODUCTION_SCHEDULER_POLICY
                or record.get("shared_scheduler_resource_only") is not True):
            raise ValueError(f"{label} omits or changes the production scheduler policy")
    result_decisions = result.get("production_scheduler_decisions")
    trace_decisions = trace.get("production_scheduler_decisions")
    expected_fields = {"dispatch_order", "task_schedule"}
    if (not isinstance(result_decisions, dict)
            or set(result_decisions) != expected_fields
            or not isinstance(trace_decisions, dict)
            or set(trace_decisions) != expected_fields
            or result_decisions != trace_decisions):
        raise ValueError("result and fixed trace production-scheduler decisions are missing or differ")
    dispatch = result_decisions.get("dispatch_order")
    schedule = result_decisions.get("task_schedule")
    if (not isinstance(dispatch, list)
            or not all(isinstance(task, str) and task for task in dispatch)
            or len(dispatch) != len(set(dispatch))
            or not isinstance(schedule, list)
            or any(not isinstance(row, dict) for row in schedule)):
        raise ValueError("production-scheduler dispatch or task schedule is malformed")
    if (result.get("dispatch_order") != dispatch
            or trace.get("dispatch_order") != dispatch
            or result.get("task_schedule") != schedule
            or trace.get("task_schedule") != schedule):
        raise ValueError("production-scheduler decisions differ from result/trace schedule fields")
    return result_decisions


def _validate_production_scheduler_task_cells(
        schedule: dict[str, Any], task: str, selected_rows: int,
        selected_cols: int, selected_count: int,
        active_replicas: int) -> list[dict[str, int]]:
    raw_cells = schedule.get("occupied_cells")
    if not isinstance(raw_cells, list) or not raw_cells:
        raise ValueError(f"{task}: production schedule omits occupied cells")
    grouped: dict[int, list[dict[str, int]]] = {}
    used_coordinates: set[tuple[int, int]] = set()
    for index, raw in enumerate(raw_cells):
        if not isinstance(raw, dict):
            raise ValueError(f"{task}: production schedule cell {index} is malformed")
        row = require_int(raw.get("row"), f"{task}.cell.row", 0)
        col = require_int(raw.get("col"), f"{task}.cell.col", 0)
        replica_id = require_int(raw.get("replica_id"), f"{task}.cell.replica_id", 0)
        context_id = require_int(raw.get("context_id"), f"{task}.cell.context_id", 0)
        if row >= 4 or col >= 4 or context_id >= MAX_CONTEXTS_PER_CGRA:
            raise ValueError(f"{task}: production schedule cell is outside the fabric or six-context capacity")
        if (row, col) in used_coordinates:
            raise ValueError(f"{task}: two replicas occupy the same production scheduler cell")
        used_coordinates.add((row, col))
        grouped.setdefault(replica_id, []).append({
            "row": row, "col": col, "replica_id": replica_id,
            "context_id": context_id,
        })
    if set(grouped) != set(range(active_replicas)):
        raise ValueError(f"{task}: production schedule changed the original active replica count")
    primary: tuple[int, int] | None = None
    for replica_id in range(active_replicas):
        cells = grouped[replica_id]
        coordinates = {(cell["row"], cell["col"]) for cell in cells}
        if len(coordinates) != selected_count:
            raise ValueError(f"{task}: production replica changed the selected CGRA count")
        row = min(cell["row"] for cell in cells)
        col = min(cell["col"] for cell in cells)
        expected = {
            (r, c)
            for r in range(row, row + selected_rows)
            for c in range(col, col + selected_cols)
        }
        if coordinates != expected:
            raise ValueError(f"{task}: production replica does not use the selected profile orientation")
        if row + selected_rows > 4 or col + selected_cols > 4:
            raise ValueError(f"{task}: production replica is outside the 4x4 fabric")
        if replica_id == 0:
            primary = (row, col)
    if primary is None:
        raise ValueError(f"{task}: production schedule omits replica zero")
    if (schedule.get("row"), schedule.get("col"),
            schedule.get("rows"), schedule.get("cols")) != (
                primary[0], primary[1], selected_rows, selected_cols):
        raise ValueError(f"{task}: production schedule summary differs from replica zero geometry")
    if ("active_replicas" in schedule
            and schedule.get("active_replicas") != active_replicas):
        raise ValueError(f"{task}: production schedule active replica count differs from original")
    if ("cgra_count" in schedule
            and schedule.get("cgra_count") != selected_count):
        raise ValueError(f"{task}: production schedule CGRA count differs from selected profile")
    if ("cgra_shape" in schedule
            and schedule.get("cgra_shape") != f"{selected_rows}x{selected_cols}"):
        raise ValueError(f"{task}: production schedule shape differs from selected profile")
    return [cell for replica_id in range(active_replicas)
            for cell in grouped[replica_id]]


def validate_diagnostic_ii_contract(metadata: dict[str, Any],
                                    binding: dict[str, Any],
                                    ensemble: dict[str, Any],
                                    runtime_architecture: str,
                                    runtime_ceiling: int) -> None:
    """Check the explicit experiment against the unchanged training bundle."""
    proof = metadata.get("diagnostic_override")
    if runtime_ceiling == 20:
        if proof is not None or binding.get("diagnostic_override") is not None:
            raise ValueError("default II20 validation cannot admit a diagnostic override")
        return
    keys = {
        "schema", "training_ii_ceiling", "runtime_ii_ceiling",
        "extrapolation_enabled", "formal", "output_rule",
        "training_architecture_exact_yaml_text", "runtime_architecture_exact_yaml_text",
    }
    if runtime_ceiling != 23 or not isinstance(proof, dict) or set(proof) != keys:
        raise ValueError("II23 validation requires the exact explicit diagnostic contract")
    training = ensemble.get("architecture", {}).get("exact_yaml_text")
    if (not isinstance(training, str)
            or proof.get("schema") != DIAGNOSTIC_II_SCHEMA
            or type(proof.get("training_ii_ceiling")) not in (int, float)
            or proof["training_ii_ceiling"] != 20
            or type(proof.get("runtime_ii_ceiling")) not in (int, float)
            or proof["runtime_ii_ceiling"] != 23
            or proof.get("extrapolation_enabled") is not True
            or proof.get("formal") is not False
            or proof.get("output_rule") != DIAGNOSTIC_OUTPUT_RULE
            or proof.get("training_architecture_exact_yaml_text") != training
            or proof.get("runtime_architecture_exact_yaml_text") != runtime_architecture
            or binding.get("diagnostic_override") != proof
            or metadata.get("diagnostic_only") is not True
            or metadata.get("formal") is not False
            or metadata.get("model_interval_max_ii") != 20
            or metadata.get("unsupported_prediction_policy")
            != "analytical-lower-bound-exceeds-diagnostic-runtime-ceiling-v1"):
        raise ValueError("II23 diagnostic metadata differs from the training/runtime binding")
    lines = list(re.finditer(r"(?m)^[ \t]*ctrl_mem_items: 20(?=\r?$)", training))
    if len(lines) != 1:
        raise ValueError("training architecture must contain exactly one whole ctrl_mem_items: 20 field")
    line = lines[0]
    expected = training[:line.start()] + line.group().replace("ctrl_mem_items: 20", "ctrl_mem_items: 23") + training[line.end():]
    if expected != runtime_architecture:
        raise ValueError("II23 runtime architecture changes fields beyond ctrl_mem_items")


def validate_diagnostic_direct_row(row: dict[str, Any], label: str) -> None:
    if (row.get("training_ceiling_ii") != 20 or row.get("runtime_ceiling_ii") != 23
            or type(row.get("training_ceiling_ii")) not in (int, float)
            or type(row.get("runtime_ceiling_ii")) not in (int, float)):
        raise ValueError(f"{label}: row omits the training/runtime ceilings")
    lower = row.get("analytical_lower_bound")
    if type(lower) not in (int, float) or not math.isfinite(lower) or lower < 0:
        raise ValueError(f"{label}: diagnostic lower bound is invalid")
    if row.get("support_status") == "unsupported":
        if (lower <= 23 or row.get("model_interval_max_ii") != 20
                or row.get("status") != "unsupported-model-domain"
                or row.get("unsupported_reason") != "analytical-lower-bound-exceeds-diagnostic-runtime-ceiling"
                or row.get("extrapolation_status") != "outside-diagnostic-runtime-domain"
                or "predicted_ii" in row):
            raise ValueError(f"{label}: unsupported row does not lie outside the runtime domain")
        return
    if row.get("support_status") != "supported" or lower > 23:
        raise ValueError(f"{label}: diagnostic row has an invalid support status")
    members = row.get("direct_ensemble_members")
    if not isinstance(members, list) or len(members) != 4:
        raise ValueError(f"{label}: diagnostic row requires four member predictions")
    values = []
    for member, seed in zip(members, (17, 41, 113, 239)):
        value = member.get("predicted_ii") if isinstance(member, dict) else None
        if (not isinstance(member, dict) or member.get("seed") != seed
                or type(value) not in (int, float) or not math.isfinite(value)
                or not lower <= value <= 23):
            raise ValueError(f"{label}: member prediction violates seed or runtime bounds")
        values.append(float(value))
    mean = math.fsum(values) / 4
    standard_deviation = math.sqrt(math.fsum((value - mean) ** 2 for value in values) / 4)
    status = "out-of-training-ceiling" if lower > 20 or any(value > 20 for value in values) else "within-training-ceiling"
    prediction, deviation = row.get("predicted_ii"), row.get("predicted_ii_std")
    if (type(prediction) not in (int, float) or type(deviation) not in (int, float)
            or not math.isfinite(prediction) or not math.isfinite(deviation)
            or not math.isclose(prediction, mean, rel_tol=0, abs_tol=1e-5)
            or not math.isclose(deviation, standard_deviation, rel_tol=0, abs_tol=1e-5)
            or row.get("extrapolation_status") != status):
        raise ValueError(f"{label}: diagnostic mean, deviation, or extrapolation label differs")


def validate_original_source_domain_facts(function: str, facts: dict[str, Any],
                                           bodies: dict[str, dict[str, Any]],
                                           bindings: dict[str, dict[str, Any]]) -> bool:
    """Compare source-owned macro firings with actual mapper body evidence."""
    if facts.get("function") != function:
        raise ValueError("source-domain fact function differs from the actual mapper body")
    rows = task_map(facts.get("tasks"), "source-domain facts", "task_name")
    if set(rows) != set(bodies) or set(rows) != set(bindings):
        raise ValueError("source-domain facts do not cover exactly the original mapper tasks")
    expanded = False
    for name, row in rows.items():
        binding = bindings[name]
        macro = require_int(row.get("effective_mapper_firing_count"), f"{name}.macro_firings", 1)
        work = require_int(row.get("source_iteration_work_count"), f"{name}.source_work", 1)
        extents = row.get("expanded_internal_extents", [])
        if (not isinstance(extents, list) or len(extents) > 1
                or any(type(extent) is not int or extent <= 0 for extent in extents)):
            raise ValueError(f"{name}: static internal expansion extents are invalid")
        multiplicity = math.prod(extents)
        if (row.get("source_iteration_domain_certified") is not True
                or row.get("source_iteration_domain_complete") is not True
                or row.get("source_iteration_domain_status") != "certified-complete"
                or row.get("trip_count_known") is not True
                or row.get("taskflow_trip_count") != macro
                or bodies[name].get("static_trip_count") != macro
                or binding.get("static_trip_count") != macro
                or binding.get("source_iteration_domain_status") != "certified-complete"
                or binding.get("source_iteration_domain_complete") is not True
                or binding.get("source_iteration_work_count") != work
                or macro * multiplicity != work or work > 2**63 - 1):
            raise ValueError(f"{name}: source work, static expansion and real mapper firing counts disagree")
        expanded |= multiplicity > 1
    return expanded


def _replica_profile_records(evidence: dict[str, Any], function: str,
                             parent_names: set[str]) -> tuple[dict[tuple[str, int], dict[str, Any]], str]:
    if evidence.get("schema") != REPLICA_PROFILE_EVIDENCE_SCHEMA:
        raise ValueError("replica profile evidence has an unsupported schema")
    raw = evidence.get("records")
    if not isinstance(raw, list) or not raw:
        raise ValueError("replica profile evidence must contain records")
    records: dict[tuple[str, int], dict[str, Any]] = {}
    names: set[str] = set()
    module: str | None = None
    required = {"parent_task", "replica_id", "materialized_task", "function",
                "materialized_module", "profile_file", "body_export_file"}
    for row in raw:
        if not isinstance(row, dict):
            raise ValueError("replica profile evidence row must be an object")
        if set(row) != required:
            raise ValueError("replica profile evidence row has missing or unexpected fields")
        parent = require_string(row.get("parent_task"), "replica evidence.parent_task")
        replica = require_int(row.get("replica_id"), "replica evidence.replica_id", 0)
        child = require_string(row.get("materialized_task"), "replica evidence.materialized_task")
        row_function = require_string(row.get("function"), "replica evidence.function")
        materialized = require_string(row.get("materialized_module"), "replica evidence.materialized_module")
        profile = require_string(row.get("profile_file"), "replica evidence.profile_file")
        body = require_string(row.get("body_export_file"), "replica evidence.body_export_file")
        if parent not in parent_names or row_function != function:
            raise ValueError("replica profile evidence names an unknown parent or function")
        if not Path(materialized).is_absolute() or not Path(materialized).is_file():
            raise ValueError("replica materialized_module must name an existing absolute file")
        if not Path(profile).is_absolute() or not Path(profile).is_file():
            raise ValueError("replica profile_file must name an existing absolute file")
        if not Path(body).is_absolute() or not Path(body).is_file():
            raise ValueError("replica body_export_file must name an existing absolute file")
        if module is None:
            module = materialized
        elif materialized != module:
            raise ValueError("replica profile records refer to multiple materialized modules")
        key = (parent, replica)
        if key in records or child in names or child in parent_names:
            raise ValueError("replica profile evidence duplicates a parent/id or child name")
        records[key] = row
        names.add(child)
    assert module is not None
    return records, module


def _partition_bounds(value: Any, label: str) -> list[tuple[int, int, int]]:
    if not isinstance(value, list) or not value:
        raise ValueError(f"{label} must be a nonempty array")
    bounds: list[tuple[int, int, int]] = []
    for axis, row in enumerate(value):
        if not isinstance(row, dict):
            raise ValueError(f"{label}[{axis}] must be an object")
        ordinal = require_int(row.get("ordinal"), f"{label}[{axis}].ordinal", 0)
        lower = require_int(row.get("lower"), f"{label}[{axis}].lower")
        upper = require_int(row.get("upper"), f"{label}[{axis}].upper")
        step = require_int(row.get("step"), f"{label}[{axis}].step", 1)
        if ordinal != axis or upper <= lower or step != 1:
            raise ValueError(f"{label}[{axis}] is not a normalized half-open unit-step counter interval")
        bounds.append((lower, upper, step))
    return bounds


def _bounds_volume(bounds: list[tuple[int, int, int]]) -> int:
    volume = 1
    for lower, upper, step in bounds:
        volume *= (upper - lower) // step
        if volume > 2**63 - 1:
            raise ValueError("source partition volume overflows signed 64-bit range")
    return volume


def _boxes_overlap(left: list[tuple[int, int, int]], right: list[tuple[int, int, int]]) -> bool:
    if len(left) != len(right):
        return True
    for (l0, l1, ls), (r0, r1, rs) in zip(left, right):
        if ls != rs or l1 <= r0 or r1 <= l0:
            return False
    return True


def _validate_partition_cover(parent: dict[str, Any], children: list[dict[str, Any]],
                              label: str) -> tuple[int, int]:
    domain = _partition_bounds(parent.get("original_domain"), f"{label}.original_domain")
    parent_work = require_int(parent.get("source_iteration_work_count"), f"{label}.source_iteration_work_count", 1)
    multiplicity = require_int(parent.get("source_iteration_multiplicity"), f"{label}.source_iteration_multiplicity", 1)
    extents = parent.get("expanded_internal_extents")
    if (not isinstance(extents, list)
            or any(type(item) is not int or item <= 0 for item in extents)
            or math.prod(extents) != multiplicity
            or _bounds_volume(domain) * multiplicity != parent_work):
        raise ValueError(f"{label}: parent source-domain multiplicity/work proof is inconsistent")
    child_bounds: list[list[tuple[int, int, int]]] = []
    child_work = 0
    for index, child in enumerate(children):
        bounds = _partition_bounds(child.get("partition_bounds"), f"{label}.replicas[{index}].partition_bounds")
        if len(bounds) != len(domain):
            raise ValueError(f"{label}: child source rank differs from the parent")
        partition_axis = require_int(child.get("partition_axis"), f"{label}.replica.partition_axis", 0)
        if partition_axis >= len(domain):
            raise ValueError(f"{label}: selected source partition axis is outside the original rank")
        for axis, (bound, whole) in enumerate(zip(bounds, domain)):
            lower, upper, step = bound
            source_lower, source_upper, source_step = whole
            if (step != source_step or lower < source_lower or upper > source_upper
                    or (lower - source_lower) % source_step or (upper - source_lower) % source_step):
                raise ValueError(f"{label}: child partition axis {axis} escapes or misaligns with source bounds")
            if axis != partition_axis and bound != whole:
                raise ValueError(f"{label}: child partition changes an axis other than the C++ selected counter")
        child_multiplicity = require_int(child.get("source_iteration_multiplicity"), f"{label}.replica.source_iteration_multiplicity", 1)
        child_extents = child.get("expanded_internal_extents")
        if child_multiplicity != multiplicity or child_extents != extents:
            raise ValueError(f"{label}: child static internal expansion differs from its parent proof")
        trip = require_int(child.get("trip_count"), f"{label}.child.trip_count", 1)
        work = require_int(child.get("source_iteration_work_count"), f"{label}.child.source_iteration_work_count", 1)
        if work != trip * multiplicity:
            raise ValueError(f"{label}: child trip count and source work disagree")
        if trip != _bounds_volume(bounds):
            raise ValueError(f"{label}: child trip count differs from its half-open partition volume")
        child_work += work
        child_bounds.append(bounds)
    if any(_boxes_overlap(a, b) for i, a in enumerate(child_bounds) for b in child_bounds[i + 1:]):
        raise ValueError(f"{label}: child source partitions overlap")
    if child_work != parent_work or sum(_bounds_volume(bounds) for bounds in child_bounds) != _bounds_volume(domain):
        raise ValueError(f"{label}: child source partitions do not exactly cover parent work")
    return parent_work, multiplicity


def _cells_by_replica(source: dict[str, Any], label: str) -> tuple[list[dict[str, Any]], dict[int, list[dict[str, Any]]]]:
    raw = source.get("placements")
    if not isinstance(raw, list) or not raw:
        raise ValueError(f"{label}: original scheduler placements are missing")
    all_cells: list[dict[str, Any]] = []
    grouped: dict[int, list[dict[str, Any]]] = {}
    coordinates: set[tuple[int, int]] = set()
    times: set[tuple[int, int, int]] = set()
    for index, row in enumerate(raw):
        if not isinstance(row, dict):
            raise ValueError(f"{label}: original scheduler placement {index} is malformed")
        context_id = require_int(row.get("context_id"), f"{label}.placement.context_id", 0)
        if context_id >= MAX_CONTEXTS_PER_CGRA:
            raise ValueError(f"{label}: original placement context id is outside the six-context CGRA")
        cell = {
            "row": require_int(row.get("row"), f"{label}.placement.row", 0),
            "col": require_int(row.get("col"), f"{label}.placement.col", 0),
            "replica_id": require_int(row.get("replica_id"), f"{label}.placement.replica_id", 0),
            "context_id": context_id,
        }
        coordinate = (cell["row"], cell["col"])
        if coordinate in coordinates:
            raise ValueError(f"{label}: original scheduler repeats a physical cell")
        coordinates.add(coordinate)
        start = require_int(row.get("scheduler_start_time"), f"{label}.placement.start", 0)
        end = require_int(row.get("scheduler_end_time"), f"{label}.placement.end", 1)
        duration = require_int(row.get("scheduler_duration"), f"{label}.placement.duration", 1)
        if end - start != duration:
            raise ValueError(f"{label}: original scheduler cell interval is inconsistent")
        times.add((start, end, duration))
        all_cells.append(cell)
        grouped.setdefault(cell["replica_id"], []).append(cell)
    if len(times) != 1:
        raise ValueError(f"{label}: original scheduler cell intervals disagree")
    start, end, duration = next(iter(times))
    if (source.get("scheduler_start_time"), source.get("scheduler_end_time")) != (start, end):
        raise ValueError(f"{label}: original scheduler summary differs from cell intervals")
    if end - start != duration:
        raise ValueError(f"{label}: original scheduler summary duration is invalid")
    return all_cells, grouped


def _original_replica_geometry(source: dict[str, Any], original: dict[str, Any],
                               label: str,
                               allow_omitted_singleton_replicas: bool = False) -> list[dict[str, Any]]:
    raw_shapes = source.get("replica_shapes")
    if not isinstance(raw_shapes, list) or not raw_shapes:
        raise ValueError(f"{label}: original scheduler replica shape inventory is missing")
    all_cells, grouped = _cells_by_replica(source, label)
    by_id: dict[int, dict[str, Any]] = {}
    for row in raw_shapes:
        if not isinstance(row, dict):
            raise ValueError(f"{label}: original scheduler replica shape is malformed")
        replica_id = require_int(row.get("replica_id"), f"{label}.shape.replica_id", 0)
        if replica_id in by_id:
            raise ValueError(f"{label}: original scheduler repeats a replica shape")
        shape = require_string(row.get("shape"), f"{label}.replica_shape")
        rows, cols = shape_dims(shape, f"{label}.replica_shape")
        if (row.get("placement_rows"), row.get("placement_cols")) != (rows, cols):
            raise ValueError(f"{label}: replica shape dimensions differ from its orientation")
        count = require_int(row.get("cgra_count"), f"{label}.replica.cgra_count", 1)
        if count != rows * cols:
            raise ValueError(f"{label}: replica CGRA count differs from its shape")
        base_row = require_int(row.get("row"), f"{label}.replica.row", 0)
        base_col = require_int(row.get("col"), f"{label}.replica.col", 0)
        if base_row + rows > 4 or base_col + cols > 4:
            raise ValueError(f"{label}: original replica rectangle is outside the fabric")
        cells = grouped.get(replica_id)
        expected_coordinates = {(r, c) for r in range(base_row, base_row + rows)
                                for c in range(base_col, base_col + cols)}
        if (not cells or {(cell["row"], cell["col"]) for cell in cells} != expected_coordinates
                or len(cells) != count):
            raise ValueError(f"{label}: original replica placements do not fill its recorded rectangle")
        by_id[replica_id] = {
            "replica_id": replica_id, "shape": shape, "cgra_count": count,
            "row": base_row, "col": base_col, "rows": rows, "cols": cols,
            "actual_cells": cells,
            "context_ids": [cell["context_id"] for cell in cells],
        }
    if set(by_id) != set(range(len(by_id))) or set(by_id) != set(grouped):
        raise ValueError(f"{label}: replica ids are not a complete zero-based set")
    active = require_int(source.get("active_replicas"), f"{label}.active_replicas", 1)
    selected_shape = require_string(source.get("composed_cgra_shape"), f"{label}.composed_cgra_shape")
    selected_rows, selected_cols = shape_dims(selected_shape, f"{label}.composed_cgra_shape")
    selected_count = require_int(source.get("composed_cgra_count"), f"{label}.composed_cgra_count", 1)
    if (active != len(by_id) or selected_count != selected_rows * selected_cols
            or any(replica["cgra_count"] != selected_count
                   or (replica["rows"], replica["cols"]) not in (
                       (selected_rows, selected_cols), (selected_cols, selected_rows))
                   for replica in by_id.values())):
        raise ValueError(f"{label}: original parent count/shape differs from its replica inventory")
    original_cells = original.get("actual_cells")
    if original_cells != all_cells:
        raise ValueError(f"{label}: retimer changed original placement order, ids, or context ids")
    if original.get("context_ids") != [cell["context_id"] for cell in all_cells]:
        raise ValueError(f"{label}: retimer changed original context-id order")
    replicas = [by_id[index] for index in sorted(by_id)]
    if original.get("replicas") != replicas:
        if not (allow_omitted_singleton_replicas and active == 1
                and "replicas" not in original):
            raise ValueError(f"{label}: retimer did not preserve every original replica shape/placement")
    if (original.get("active_replicas") != active
            or original.get("selected_cgra_count") != selected_count
            or original.get("selected_profile_shape") != selected_shape
            or original.get("dispatch_index") != source.get("dispatch_index")):
        raise ValueError(f"{label}: retimer changed original parent count, shape, or dispatch index")
    first = replicas[0]
    if (original.get("actual_placed_shape"), original.get("actual_placed_row"),
            original.get("actual_placed_col")) != (first["shape"], first["row"], first["col"]):
        raise ValueError(f"{label}: retimer changed the original first-replica placement summary")
    start, end = source["scheduler_start_time"], source["scheduler_end_time"]
    duration = end - start
    if (original.get("original_scheduler_start_internal"),
            original.get("original_scheduler_end_internal"),
            original.get("original_scheduler_duration_internal")) != (start, end, duration):
        raise ValueError(f"{label}: retimer changed the original scheduler interval")
    return replicas


def _validate_child_evidence(record: dict[str, Any], child_name: str,
                             expected_trip: int, placed_shape: str,
                             function: str) -> tuple[dict[str, Any], dict[str, Any], dict[str, Any]]:
    body_doc = json.loads(Path(record["body_export_file"]).read_text())
    profile_doc = json.loads(Path(record["profile_file"]).read_text())
    if (body_doc.get("format") != "amoeba-pre-mapper-task-bodies-v1"
            or profile_doc.get("format") != "amoeba-task-profile-v1"
            or body_doc.get("function") != function or profile_doc.get("function") != function):
        raise ValueError(f"{child_name}: child body/profile evidence schema or function is invalid")
    bodies = task_map(body_doc.get("tasks"), f"{child_name} body export")
    profiled = task_map(profile_doc.get("tasks"), f"{child_name} profile file")
    if child_name not in bodies or child_name not in profiled:
        raise ValueError(f"{child_name}: actual mapper body/profile evidence omits this child")
    body = bodies[child_name]
    trip = require_int(body.get("static_trip_count"), f"{child_name}.static_trip_count", 1)
    if trip != expected_trip:
        raise ValueError(f"{child_name}: body export trip count differs from the source partition proof")
    for key in ("task_signature", "counter_signature", "kernel_binding_signature", "normalized_mapper_body"):
        require_string(body.get(key), f"{child_name}.{key}")
    rows = profiled[child_name].get("profiles")
    if not isinstance(rows, list):
        raise ValueError(f"{child_name}: actual profile rows are missing")
    by_shape: dict[str, dict[str, Any]] = {}
    for row in rows:
        if not isinstance(row, dict):
            raise ValueError(f"{child_name}: actual profile row is malformed")
        shape = require_string(row.get("composed_cgra_shape"), f"{child_name}.profile.shape")
        r, c = shape_dims(shape, f"{child_name}.profile.{shape}")
        if (shape not in EXPECTED_SHAPES or shape in by_shape
                or row.get("composed_cgra_count") != r * c
                or type(row.get("mapper_succeeded")) is not bool):
            raise ValueError(f"{child_name}: actual profile shape inventory is invalid")
        if row["mapper_succeeded"]:
            for key in ("compiled_ii", "steps", "sample_trip_count", "materialized_operation_count", "estimated_latency"):
                require_int(row.get(key), f"{child_name}.{shape}.{key}", 1)
            if row["estimated_latency"] != row["compiled_ii"] * (row["sample_trip_count"] - 1) + row["steps"]:
                raise ValueError(f"{child_name}: actual mapper profile duration is inconsistent")
        by_shape[shape] = row
    selected = by_shape.get(placed_shape)
    if not isinstance(selected, dict) or selected.get("mapper_succeeded") is not True:
        raise ValueError(f"{child_name}: actual placed orientation did not map successfully")
    if selected.get("sample_trip_count") != expected_trip:
        raise ValueError(f"{child_name}: actual orientation profile trip count differs from source facts")
    return body, selected, profile_doc


def _validate_joined_profile_attempts(profile_doc: dict[str, Any], expected_names: set[str],
                                      label: str) -> tuple[dict[str, dict[str, Any]],
                                                           dict[str, dict[str, dict[str, Any]]],
                                                           dict[str, dict[str, dict[str, Any]]]]:
    """Join every canonical mapper attempt to its optional profile summary row."""
    if (profile_doc.get("task_count") != len(expected_names)
            or profile_doc.get("expected_candidate_count") != len(expected_names) * len(EXPECTED_SHAPE_ORDER)
            or profile_doc.get("completed_candidate_count") != len(expected_names) * len(EXPECTED_SHAPE_ORDER)):
        raise ValueError(f"{label}: task or completed-attempt counters differ from the expected inventory")
    tasks = task_map(profile_doc.get("tasks"), f"{label} tasks")
    if set(tasks) != expected_names:
        raise ValueError(f"{label}: profile summaries do not cover exactly the expected tasks")
    raw_attempts = profile_doc.get("candidate_attempts")
    if (not isinstance(raw_attempts, list)
            or len(raw_attempts) != len(expected_names) * len(EXPECTED_SHAPE_ORDER)):
        raise ValueError(f"{label}: candidate attempts do not cover the complete task/shape inventory")

    attempts_by_task: dict[str, dict[str, dict[str, Any]]] = {}
    for attempt in raw_attempts:
        if not isinstance(attempt, dict):
            raise ValueError(f"{label}: candidate attempt is malformed")
        task = require_string(attempt.get("task"), f"{label}.attempt.task")
        shape = require_string(attempt.get("shape"), f"{task}.attempt.shape")
        if task not in expected_names or shape not in EXPECTED_SHAPES:
            raise ValueError(f"{label}: candidate attempt names an unexpected task or shape")
        rows, cols = shape_dims(shape, f"{task}.attempt.{shape}")
        index = require_int(attempt.get("candidate_index_in_task"), f"{task}.{shape}.candidate_index_in_task", 1)
        count = require_int(attempt.get("composed_cgra_count"), f"{task}.{shape}.composed_cgra_count", 1)
        if (index > len(EXPECTED_SHAPE_ORDER)
                or EXPECTED_SHAPE_ORDER[index - 1] != shape
                or count != rows * cols
                or type(attempt.get("mapper_succeeded")) is not bool
                or type(attempt.get("profile_created")) is not bool):
            raise ValueError(f"{task}.{shape}: candidate index/count/result/profile-created facts are inconsistent")
        rows_by_shape = attempts_by_task.setdefault(task, {})
        if shape in rows_by_shape:
            raise ValueError(f"{task}: candidate attempts repeat a shape")
        rows_by_shape[shape] = attempt

    profiles_by_task: dict[str, dict[str, dict[str, Any]]] = {}
    for task in expected_names:
        attempts = attempts_by_task.get(task, {})
        if set(attempts) != EXPECTED_SHAPES:
            raise ValueError(f"{task}: explicit attempts omit one or more canonical shapes")
        raw_profiles = tasks[task].get("profiles")
        if not isinstance(raw_profiles, list):
            raise ValueError(f"{task}: profile summary rows are missing")
        profiles: dict[str, dict[str, Any]] = {}
        for row in raw_profiles:
            if not isinstance(row, dict):
                raise ValueError(f"{task}: profile summary row is malformed")
            shape = require_string(row.get("composed_cgra_shape"), f"{task}.profile.shape")
            if shape not in EXPECTED_SHAPES or shape in profiles:
                raise ValueError(f"{task}: profile summary repeats or uses an illegal shape")
            rows, cols = shape_dims(shape, f"{task}.profile.{shape}")
            if (require_int(row.get("composed_cgra_count"), f"{task}.{shape}.composed_cgra_count", 1) != rows * cols
                    or type(row.get("mapper_succeeded")) is not bool):
                raise ValueError(f"{task}.{shape}: profile summary count or mapper result is invalid")
            profiles[shape] = row
        for shape, attempt in attempts.items():
            row = profiles.get(shape)
            created = attempt["profile_created"]
            succeeded = attempt["mapper_succeeded"]
            if created != (row is not None):
                raise ValueError(f"{task}.{shape}: profile_created differs from profile summary row presence")
            if succeeded and not created:
                raise ValueError(f"{task}.{shape}: successful mapper attempt has no created profile row")
            if row is None:
                continue
            if row.get("mapper_succeeded") is not succeeded:
                raise ValueError(f"{task}.{shape}: attempt and profile summary mapper results differ")
            if succeeded:
                for key in ("compiled_ii", "steps", "sample_trip_count", "materialized_operation_count", "estimated_latency"):
                    require_int(row.get(key), f"{task}.{shape}.{key}", 1)
                if row["estimated_latency"] != row["compiled_ii"] * (row["sample_trip_count"] - 1) + row["steps"]:
                    raise ValueError(f"{task}.{shape}: successful profile summary duration is inconsistent")
            elif any(key in row for key in ("compiled_ii", "steps", "sample_trip_count", "materialized_operation_count", "estimated_latency")):
                raise ValueError(f"{task}.{shape}: failed attempt carries synthetic cost fields")
        profiles_by_task[task] = profiles
    return tasks, attempts_by_task, profiles_by_task


def _validate_materialized_task_facts(function: str, facts: dict[str, Any],
                                      expected: dict[str, dict[str, Any]]) -> tuple[dict[str, dict[str, Any]], list[dict[str, Any]]]:
    if (not isinstance(facts, dict)
            or facts.get("schema") != "amoeba-joint-task-graph-facts-v1"
            or facts.get("mode") != "fact_only"
            or facts.get("function") != function):
        raise ValueError("materialized source facts have the wrong C++ schema, mode, or function")
    tasks = task_map(facts.get("tasks"), "materialized source facts", "task_name")
    if set(tasks) != set(expected):
        raise ValueError("materialized source facts do not cover exactly the expanded task inventory")
    for name, row in tasks.items():
        if (row.get("source_iteration_domain_status") != "certified-complete"
                or row.get("source_iteration_domain_certified") is not True
                or row.get("source_iteration_domain_complete") is not True
                or row.get("trip_count_known") is not True):
            raise ValueError(f"{name}: materialized C++ source facts do not certify complete coverage")
        trip = require_int(row.get("taskflow_trip_count"), f"{name}.facts.taskflow_trip_count", 1)
        firings = require_int(row.get("effective_mapper_firing_count"), f"{name}.facts.effective_mapper_firing_count", 1)
        work = require_int(row.get("source_iteration_work_count"), f"{name}.facts.source_iteration_work_count", 1)
        extents = row.get("expanded_internal_extents")
        if (not isinstance(extents, list)
                or any(type(extent) is not int or extent <= 0 for extent in extents)
                or trip != firings or work != trip * math.prod(extents)
                or work > 2**63 - 1):
            raise ValueError(f"{name}: materialized source trip, work, or internal extents are inconsistent")
        expected_row = expected[name]
        for key, actual in (("trip_count", trip), ("source_iteration_work_count", work),
                            ("source_iteration_multiplicity", math.prod(extents)),
                            ("expanded_internal_extents", extents)):
            if key in expected_row and actual != expected_row[key]:
                raise ValueError(f"{name}: materialized source facts differ from the C++ partition/profile proof for {key}")
    dependencies = facts.get("dependencies")
    if not isinstance(dependencies, list):
        raise ValueError("materialized source facts omit their typed dependency inventory")
    return tasks, dependencies


def _region_tuple(value: Any, label: str) -> tuple[int, ...]:
    if value is None:
        return ()
    if not isinstance(value, list) or any(type(item) is not int for item in value):
        raise ValueError(f"{label} must be null or an integer array")
    return tuple(value)


def _fact_dependency_inventory(dependencies: list[dict[str, Any]]) -> Counter[tuple[Any, ...]]:
    inventory: Counter[tuple[Any, ...]] = Counter()
    for index, edge in enumerate(dependencies):
        if not isinstance(edge, dict):
            raise ValueError(f"materialized dependency {index} is malformed")
        source = require_string(edge.get("source_task"), f"facts.dependency[{index}].source_task")
        target = require_string(edge.get("target_task"), f"facts.dependency[{index}].target_task")
        kind = require_string(edge.get("kind"), f"facts.dependency[{index}].kind")
        origin = require_string(edge.get("origin"), f"facts.dependency[{index}].origin")
        scope = require_string(edge.get("scope"), f"facts.dependency[{index}].scope")
        producer_segment = require_string(edge.get("producer_segment"), f"facts.dependency[{index}].producer_segment")
        producer_index = require_int(edge.get("producer_index"), f"facts.dependency[{index}].producer_index", 0)
        consumer_segment = require_string(edge.get("consumer_segment"), f"facts.dependency[{index}].consumer_segment")
        consumer_index = require_int(edge.get("consumer_index"), f"facts.dependency[{index}].consumer_index", 0)
        payload_bits = edge.get("payload_bits")
        payload_bytes = edge.get("payload_bytes")
        if payload_bits is None:
            if payload_bytes is not None:
                raise ValueError(f"facts.dependency[{index}]: unknown payload has known byte count")
        else:
            payload_bits = require_int(payload_bits, f"facts.dependency[{index}].payload_bits", 0)
            payload_bytes = require_int(payload_bytes, f"facts.dependency[{index}].payload_bytes", 0)
            if payload_bytes != (payload_bits + 7) // 8:
                raise ValueError(f"facts.dependency[{index}]: payload bit and byte counts disagree")
        lower = _region_tuple(edge.get("region_lower"), f"facts.dependency[{index}].region_lower")
        upper = _region_tuple(edge.get("region_upper"), f"facts.dependency[{index}].region_upper")
        if len(lower) != len(upper):
            raise ValueError(f"facts.dependency[{index}]: transfer region ranks disagree")
        inventory[(source, target, kind, origin, scope, producer_segment, producer_index,
                   consumer_segment, consumer_index, payload_bits, lower, upper)] += 1
    return inventory


def _trace_dependency_inventory(dependencies: list[dict[str, Any]]) -> Counter[tuple[Any, ...]]:
    inventory: Counter[tuple[Any, ...]] = Counter()
    for index, edge in enumerate(dependencies):
        if not isinstance(edge, dict):
            raise ValueError(f"retimed dependency {index} is malformed")
        source = require_string(edge.get("producer"), f"trace.dependency[{index}].producer")
        target = require_string(edge.get("consumer"), f"trace.dependency[{index}].consumer")
        payload = edge.get("payload_bits")
        if payload is not None:
            payload = require_int(payload, f"trace.dependency[{index}].payload_bits", 0)
        if edge.get("payload_known") is not (payload is not None):
            raise ValueError(f"trace.dependency[{index}]: payload-known flag differs from its payload")
        lower = _region_tuple(edge.get("transfer_region_lower"), f"trace.dependency[{index}].transfer_region_lower")
        upper = _region_tuple(edge.get("transfer_region_upper"), f"trace.dependency[{index}].transfer_region_upper")
        if len(lower) != len(upper):
            raise ValueError(f"trace.dependency[{index}]: transfer region ranks disagree")
        inventory[(source, target, require_string(edge.get("kind"), f"trace.dependency[{index}].kind"),
                   require_string(edge.get("origin"), f"trace.dependency[{index}].origin"),
                   require_string(edge.get("scope"), f"trace.dependency[{index}].scope"),
                   require_string(edge.get("producer_segment"), f"trace.dependency[{index}].producer_segment"),
                   require_int(edge.get("producer_index"), f"trace.dependency[{index}].producer_index", 0),
                   require_string(edge.get("consumer_segment"), f"trace.dependency[{index}].consumer_segment"),
                   require_int(edge.get("consumer_index"), f"trace.dependency[{index}].consumer_index", 0),
                   payload, lower, upper)] += 1
    return inventory


def _validate_replica_profile_file_coverage(records: dict[tuple[str, int], dict[str, Any]],
                                           expected_expanded_names: set[str]) -> None:
    by_profile: dict[str, set[str]] = {}
    by_body: dict[str, set[str]] = {}
    for row in records.values():
        by_profile.setdefault(row["profile_file"], set()).add(row["materialized_task"])
        by_body.setdefault(row["body_export_file"], set()).add(row["materialized_task"])
    for path, expected_names in by_profile.items():
        document = json.loads(Path(path).read_text())
        _validate_joined_profile_attempts(document, expected_names, "child profile file")
    for path in by_body:
        document = json.loads(Path(path).read_text())
        tasks = task_map(document.get("tasks"), "replica body export tasks")
        if (document.get("task_count") != len(expected_expanded_names)
                or set(tasks) != expected_expanded_names):
            raise ValueError("child body export does not cover exactly the materialized module task inventory")


def validate_expanded_replica_trace(ir: str, result: dict[str, Any], body_proof: dict[str, Any],
                                    profiles: dict[str, Any], costs: dict[str, Any],
                                    evidence: dict[str, Any], network_text: str | None,
                                    diagnostic_ii_ceiling: int,
                                    source_domain_facts: dict[str, Any] | None,
                                    materialized_source_facts: dict[str, Any]) -> dict[str, Any]:
    if result.get("schema") != "amoeba-original-fixed-decision-retiming-v1" or result.get("valid") is not True:
        raise ValueError("retimed record is not a valid original fixed-decision result")
    if result.get("diagnostic_only") is not True or result.get("formal_go") is not False:
        raise ValueError("expanded fixed retiming must remain diagnostic with formal_go=false")
    trace = result.get("fixed_decision_trace")
    if not isinstance(trace, dict) or trace.get("schema") != "amoeba-fixed-decision-trace-v1":
        raise ValueError("expanded retimed result lacks its source-owned fixed_decision_trace")
    if (trace.get("candidate_id") != result.get("candidate_id")
            or trace.get("formal_go") is not False
            or result.get("body_equivalence_checked") is not True
            or trace.get("body_equivalence_checked") is not True
            or result.get("selected_profile_body_binding_verified") is not True):
        raise ValueError("expanded trace candidate/body/formal binding is invalid")
    if contains_key(result, "mapper_replay_verified") or contains_key(result, "joint_scheduling_replay_verified"):
        raise ValueError("diagnostic expanded retiming must not claim mapper replay")

    function = require_string(result.get("function"), "result.function")
    if body_proof.get("format") != "amoeba-pre-mapper-task-bodies-v1" or profiles.get("format") != "amoeba-task-profile-v1":
        raise ValueError("original body/profile input has an unsupported evidence schema")
    if body_proof.get("function") != function or profiles.get("function") != function or not contains_function_symbol(ir, function):
        raise ValueError("original retimer/body/profile function identity differs")
    graph_matches = re.findall(r'amoeba\.graph_variant_id\s*=\s*"([^"]*)"', ir)
    if len(graph_matches) > 1:
        raise ValueError("original MLIR has ambiguous graph-variant identities")
    expected_graph = (graph_matches[0] if graph_matches and graph_matches[0]
                      else "original-amoeba-full")
    graph_id = require_string(result.get("graph_variant_id"), "result.graph_variant_id")
    if graph_id != expected_graph or trace.get("graph_variant_id") != expected_graph:
        raise ValueError("expanded retimer graph identity differs from preserved source identity")

    source_dispatch = extract_attribute(ir, "amoeba.task_scheduler_dispatch_order")
    source_schedule = extract_attribute(ir, "amoeba.task_scheduler_task_schedule")
    source_summary = extract_attribute(ir, "task_orchestration_summary")
    source_unit = extract_attribute(ir, "amoeba.task_scheduler_time_unit")
    source_scale = extract_attribute(ir, "amoeba.task_scheduler_time_scale")
    if not isinstance(source_dispatch, list) or not all(isinstance(item, str) for item in source_dispatch):
        raise ValueError("original parent dispatch order is malformed")
    source_rows = task_map(source_schedule, "original parent schedule", "task_name")
    parent_names = set(source_rows)
    if set(source_dispatch) != parent_names or len(source_dispatch) != len(parent_names):
        raise ValueError("original parent schedule and dispatch coverage differ")
    if not isinstance(source_summary, dict) or source_summary.get("strategy") != "throughput-guided":
        raise ValueError("original scheduler strategy is not throughput-guided")
    if (result.get("original_parent_dispatch_order") != source_dispatch
            or result.get("original_pipeline_interval") != source_summary.get("pipeline_interval")
            or source_unit != "scaled-internal-placement-slots"
            or result.get("original_internal_time_unit") != source_unit
            or type(source_scale) is not int
            or result.get("original_internal_time_scale") != source_scale):
        raise ValueError("retimer changed original parent order, interval, or scheduler time contract")

    records, materialized_module = _replica_profile_records(evidence, function, parent_names)
    materialization = result.get("replica_materialization")
    if (not isinstance(materialization, dict)
            or materialization.get("schema") != REPLICA_MATERIALIZATION_SCHEMA
            or materialization.get("verified") is not True
            or materialization.get("materialized_module") != materialized_module):
        raise ValueError("retimer lacks a verified C++ source-partition proof for the evidence module")

    original_decisions = task_map(result.get("original_decisions"), "original decisions")
    if set(original_decisions) != parent_names:
        raise ValueError("original decisions do not preserve exactly the source parent inventory")
    body_rows = task_map(body_proof.get("tasks"), "original body proof")
    profile_rows = task_map(profiles.get("tasks"), "original task profiles")
    binding = costs.get("original_amoeba_profile_binding")
    metadata = costs.get("predictor_metadata")
    if (costs.get("schema") != "amoeba-task-shape-cost" or not isinstance(binding, dict)
            or not isinstance(metadata, dict)
            or binding.get("schema") != "amoeba-original-profile-body-binding-v1"
            or binding.get("candidate_id") != result.get("candidate_id")
            or binding.get("function") != function or binding.get("graph_variant_id") != graph_id
            or binding.get("current_ir_body_equivalence_verified") is not True
            or body_proof.get("format") != binding.get("body_export_format")
            or profiles.get("format") != binding.get("profile_file_format")):
        raise ValueError("original selected-shape catalog does not bind its parent body/profile inputs")
    if metadata.get("source_graph_id") != graph_id:
        raise ValueError("cost catalog graph provenance differs from the original graph")
    for key in ("architecture_path", "architecture_contract", "model", "model_schema", "feature_contract_id", "feature_extractor", "shape_protocol_id", "source_repository", "source_commit"):
        if not binding.get(key) or metadata.get(key) != binding.get(key):
            raise ValueError(f"cost catalog metadata and binding differ for {key}")
    architecture_text = require_string(binding.get("architecture_text"), "catalog architecture_text")
    architecture_path = Path(require_string(binding.get("architecture_path"), "catalog architecture_path"))
    if not architecture_path.is_file() or architecture_path.read_text() != architecture_text:
        raise ValueError("embedded architecture differs from its named source file")
    original_profile_path = Path(require_string(binding.get("profile_file"), "catalog profile_file"))
    if not original_profile_path.is_file() or json.loads(original_profile_path.read_text()) != profiles:
        raise ValueError("catalog parent profile path does not contain the supplied original evidence")
    ensemble_text = require_string(binding.get("ensemble_text"), "catalog ensemble_text")
    ensemble_path = Path(require_string(binding.get("ensemble_path"), "catalog ensemble_path"))
    if not ensemble_path.is_file() or ensemble_path.read_text() != ensemble_text:
        raise ValueError("embedded ensemble differs from its named source file")
    ensemble = json.loads(ensemble_text)
    direct_namespace = "orbit-per-cgra-2x2-direct-4member-v1"
    if binding.get("model_namespace") != direct_namespace:
        raise ValueError("expanded replicas require the original direct 2x2 model catalog")
    validate_diagnostic_ii_contract(metadata, binding, ensemble, architecture_text, diagnostic_ii_ceiling)
    members = ensemble.get("members")
    source_model = ensemble.get("source_model")
    bound_source_model = binding.get("source_model")
    feature_contract = ensemble.get("feature_contract")
    shape_protocol = ensemble.get("shape_protocol")
    candidate_metadata = bound_source_model.get("candidate_metadata") if isinstance(bound_source_model, dict) else None
    if (ensemble.get("schema") != "orbit-cgra-ii-per-cgra-2x2-direct-ensemble-cpp-v1"
            or ensemble.get("model_namespace") != direct_namespace
            or not isinstance(members, list) or len(members) != 4
            or [member.get("seed") for member in members if isinstance(member, dict)] != [17, 41, 113, 239]
            or not isinstance(source_model, dict) or not isinstance(bound_source_model, dict)
            or any(source_model.get(key) != bound_source_model.get(key) for key in ("repository", "commit", "branch"))
            or not isinstance(candidate_metadata, dict)
            or candidate_metadata.get("candidate_only") is not True
            or candidate_metadata.get("old_4x4_labels_reused") is not False
            or candidate_metadata.get("ensemble_member_count") != 4
            or candidate_metadata.get("feature_count") != 148
            or not isinstance(feature_contract, dict)
            or feature_contract.get("contract_id") != binding.get("feature_contract_id")
            or feature_contract.get("contract_id") != "cgra-ii-pre-mapper-features-148-2x2-per-cgra-v1"
            or not isinstance(shape_protocol, dict)
            or shape_protocol.get("protocol_id") != binding.get("shape_protocol_id")
            or shape_protocol.get("protocol_id") != "amoeba-static-rectangles-2x2-per-cgra-max4"
            or (diagnostic_ii_ceiling == 20
                and ensemble.get("architecture", {}).get("exact_yaml_text") != architecture_text)):
        raise ValueError("embedded direct model bundle provenance or shape protocol differs from the catalog")
    expanded_source_domain = False
    original_domain_facts_by_task: dict[str, dict[str, Any]] | None = None
    if diagnostic_ii_ceiling == 23:
        if source_domain_facts is None:
            raise ValueError("II23 validation requires original source-domain facts")
        expanded_source_domain = validate_original_source_domain_facts(
            function, source_domain_facts, body_rows,
            task_map(binding.get("tasks"), "original catalog body bindings"))
        original_domain_facts_by_task = task_map(
            source_domain_facts.get("tasks"), "original source-domain facts", "task_name")
    profile_binding_rows = task_map(binding.get("tasks"), "original catalog body bindings")
    if set(body_rows) != parent_names or set(profile_rows) != parent_names or set(profile_binding_rows) != parent_names:
        raise ValueError("original body/profile/catalog files do not cover exactly the parent tasks")
    if body_proof.get("task_count") != len(parent_names) or profiles.get("task_count") != len(parent_names):
        raise ValueError("original parent body/profile counts differ from the source task inventory")
    _, _, parent_profiles_by_shape = _validate_joined_profile_attempts(
        profiles, parent_names, "original parent profile file")

    raw_costs = costs.get("entries")
    if not isinstance(raw_costs, list) or len(raw_costs) != len(parent_names) * len(EXPECTED_SHAPES):
        raise ValueError("direct cost catalog does not cover every original parent/shape pair")
    costs_by_shape: dict[str, dict[tuple[int, int], dict[str, Any]]] = {}
    for entry in raw_costs:
        if not isinstance(entry, dict):
            raise ValueError("direct cost catalog entry is malformed")
        name = require_string(entry.get("task"), "direct cost task")
        tr = require_int(entry.get("mapper_tile_rows"), f"{name}.mapper_tile_rows", 2)
        tc = require_int(entry.get("mapper_tile_cols"), f"{name}.mapper_tile_cols", 2)
        if tr % 2 or tc % 2:
            raise ValueError(f"{name}: direct model tile dimensions are not 2x2-CGRA multiples")
        shape = (tr // 2, tc // 2)
        if f"{shape[0]}x{shape[1]}" not in EXPECTED_SHAPES:
            raise ValueError(f"{name}: direct model cost has an illegal orientation")
        shape_map = costs_by_shape.setdefault(name, {})
        if shape in shape_map:
            raise ValueError(f"{name}: direct catalog repeats an oriented shape")
        if diagnostic_ii_ceiling == 23:
            validate_diagnostic_direct_row(entry, f"{name}.{shape[0]}x{shape[1]}")
        shape_map[shape] = entry

    parent_geometry: dict[str, list[dict[str, Any]]] = {}
    parent_trip: dict[str, int] = {}
    parent_shape: dict[str, str] = {}
    parent_startup_by_shape: dict[str, dict[tuple[int, int], float]] = {}
    for index, name in enumerate(source_dispatch):
        source = source_rows[name]
        original = original_decisions[name]
        if source.get("dispatch_index") != index:
            raise ValueError(f"{name}: original source dispatch index changed")
        source_shape = require_string(source.get("composed_cgra_shape"), f"{name}.source_shape")
        shape_dims(source_shape, f"{name}.source_shape")
        replicas = _original_replica_geometry(source, original, name)
        parent_geometry[name] = replicas
        if original.get("task") != name:
            raise ValueError(f"{name}: parent decision has a different task identity")

        body = body_rows[name]
        source_profile = profile_rows[name]
        profile_binding = profile_binding_rows[name]
        trip = require_int(body.get("static_trip_count"), f"{name}.static_trip_count", 1)
        parent_trip[name] = trip
        parent_shape[name] = source_shape
        profiles_by_shape = parent_profiles_by_shape[name]
        selected = profiles_by_shape.get(source_shape)
        if not selected or selected.get("mapper_succeeded") is not True:
            raise ValueError(f"{name}: original selected parent profile did not map")
        for key in ("compiled_ii", "steps", "sample_trip_count", "materialized_operation_count", "estimated_latency"):
            require_int(selected.get(key), f"{name}.original.{key}", 1)
        if selected["compiled_ii"] > diagnostic_ii_ceiling:
            raise ValueError(f"{name}: original mapper II exceeds the runtime control-memory ceiling")
        full_profile_duration = selected["estimated_latency"]
        f45_profile_duration = require_int(source.get("duration"), f"{name}.f45_profile_duration", 1)
        if (selected["sample_trip_count"] != trip
                or selected["estimated_latency"] != selected["compiled_ii"] * (trip - 1) + selected["steps"]
                or source.get("duration_unit") != "profiled-cycles"):
            raise ValueError(f"{name}: original parent mapper profile/trip/latency binding differs")
        if len(replicas) > 1:
            duration_binding = original.get("original_profile_duration_binding")
            required_duration_binding = {
                "schema", "full_parent_mapper_duration_cycles",
                "f45_scheduler_duration_cycles", "active_replicas", "compiled_ii",
                "sample_trip_count", "steps", "materialized_operation_count",
                "rounding_rule", "status",
            }
            if not isinstance(duration_binding, dict) or set(duration_binding) != required_duration_binding:
                raise ValueError(f"{name}: split parent duration binding has the wrong exact schema")
            bound_full_duration = require_int(
                duration_binding.get("full_parent_mapper_duration_cycles"),
                f"{name}.duration_binding.full_parent_mapper_duration_cycles", 1)
            bound_f45_duration = require_int(
                duration_binding.get("f45_scheduler_duration_cycles"),
                f"{name}.duration_binding.f45_scheduler_duration_cycles", 1)
            bound_replicas = require_int(
                duration_binding.get("active_replicas"), f"{name}.duration_binding.active_replicas", 2)
            bound_ii = require_int(duration_binding.get("compiled_ii"),
                                   f"{name}.duration_binding.compiled_ii", 1)
            bound_trip = require_int(duration_binding.get("sample_trip_count"),
                                     f"{name}.duration_binding.sample_trip_count", 1)
            bound_steps = require_int(duration_binding.get("steps"),
                                      f"{name}.duration_binding.steps", 1)
            bound_operations = require_int(
                duration_binding.get("materialized_operation_count"),
                f"{name}.duration_binding.materialized_operation_count", 1)
            expected_f45_duration = (full_profile_duration + len(replicas) - 1) // len(replicas)
            if (duration_binding.get("schema") != "amoeba-original-f45-profile-duration-binding-v1"
                    or bound_full_duration != full_profile_duration
                    or bound_f45_duration != f45_profile_duration
                    or bound_replicas != len(replicas)
                    or bound_ii != selected["compiled_ii"]
                    or bound_trip != selected["sample_trip_count"]
                    or bound_steps != selected["steps"]
                    or bound_operations != selected["materialized_operation_count"]
                    or duration_binding.get("rounding_rule") != "ceil-full-parent-duration-over-original-active-replicas-v1"
                    or duration_binding.get("status") != "verified"
                    or f45_profile_duration != expected_f45_duration
                    or original.get("original_profile_duration_cycles") != f45_profile_duration):
                raise ValueError(f"{name}: split parent F45 duration/full mapper duration certificate is invalid")
        elif (f45_profile_duration != full_profile_duration
              or original.get("original_profile_duration_cycles") != full_profile_duration
              or "original_profile_duration_binding" in original):
            raise ValueError(f"{name}: original parent profile duration was changed")
        if (profile_binding.get("task") != name
                or profile_binding.get("static_trip_count") != trip
                or profile_binding.get("selected_cgra_shape") != source_shape
                or profile_binding.get("selected_cgra_count") != source.get("composed_cgra_count")):
            raise ValueError(f"{name}: original parent selected shape/body binding differs")
        for key in ("task_signature", "counter_signature", "kernel_binding_signature", "normalized_mapper_body"):
            if not isinstance(body.get(key), str) or not body[key] or profile_binding.get(key) != body[key]:
                raise ValueError(f"{name}: original parent body signature differs for {key}")
        if (profile_binding.get("compiled_ii") != selected["compiled_ii"]
                or profile_binding.get("steps") != selected["steps"]
                or profile_binding.get("sample_trip_count") != trip
                or profile_binding.get("materialized_operation_count") != selected["materialized_operation_count"]
                or profile_binding.get("estimated_latency") != selected["estimated_latency"]
                or profile_binding.get("mapper_succeeded") is not True):
            raise ValueError(f"{name}: original parent profile evidence differs from its catalog body binding")

        direct_predictions = profile_binding.get("direct_shape_predictions")
        if not isinstance(direct_predictions, list) or len(direct_predictions) != len(EXPECTED_SHAPES):
            raise ValueError(f"{name}: original model binding omits eight oriented predictions")
        predictions_by_shape: dict[tuple[int, int], dict[str, Any]] = {}
        for prediction in direct_predictions:
            if not isinstance(prediction, dict):
                raise ValueError(f"{name}: direct shape prediction is malformed")
            shape = (require_int(prediction.get("cgra_rows"), f"{name}.prediction.rows", 1),
                     require_int(prediction.get("cgra_cols"), f"{name}.prediction.cols", 1))
            if f"{shape[0]}x{shape[1]}" not in EXPECTED_SHAPES or shape in predictions_by_shape:
                raise ValueError(f"{name}: direct model predictions repeat or use an illegal shape")
            prediction_entry = costs_by_shape.get(name, {}).get(shape)
            if prediction_entry is None:
                raise ValueError(f"{name}: direct model catalog omits a predicted orientation")
            if (prediction.get("mapper_tile_rows") != prediction_entry.get("mapper_tile_rows")
                    or prediction.get("mapper_tile_cols") != prediction_entry.get("mapper_tile_cols")
                    or prediction.get("support_status") != prediction_entry.get("support_status")
                    or prediction.get("startup_cycles") != prediction_entry.get("startup_cycles")
                    or prediction.get("predicted_ii") != prediction_entry.get("predicted_ii")
                    or prediction.get("predicted_ii_std") != prediction_entry.get("predicted_ii_std")):
                raise ValueError(f"{name}: direct orientation prediction differs from its cost row")
            lower = prediction_entry.get("analytical_lower_bound")
            if type(lower) not in (int, float) or not math.isfinite(lower) or lower < 0:
                raise ValueError(f"{name}: direct orientation lower bound is invalid")
            if prediction_entry.get("support_status") == "supported":
                startup = prediction_entry.get("startup_cycles")
                if type(startup) not in (int, float) or not math.isfinite(startup) or startup <= 0:
                    raise ValueError(f"{name}: supported orientation has an invalid startup")
                values: list[float] = []
                prediction_members = prediction.get("direct_ensemble_members")
                cost_members = prediction_entry.get("direct_ensemble_members")
                seeds = (17, 41, 113, 239)
                if (not isinstance(prediction_members, list) or len(prediction_members) != 4
                        or not isinstance(cost_members, list) or len(cost_members) != 4):
                    raise ValueError(f"{name}: supported orientation lacks four-member model evidence")
                for member_index, seed in enumerate(seeds):
                    p_member, c_member = prediction_members[member_index], cost_members[member_index]
                    if (not isinstance(p_member, dict) or not isinstance(c_member, dict)
                            or p_member.get("member_index") != member_index
                            or c_member.get("member_index") != member_index
                            or p_member.get("seed") != seed or c_member.get("seed") != seed):
                        raise ValueError(f"{name}: direct ensemble member order or seed is invalid")
                    p_value = p_member.get("predicted_ii")
                    c_value = c_member.get("predicted_ii")
                    if (type(p_value) not in (int, float) or type(c_value) not in (int, float)
                            or not math.isfinite(p_value) or not math.isfinite(c_value)
                            or not math.isclose(p_value, c_value, rel_tol=0, abs_tol=1e-5)
                            or not lower <= p_value <= diagnostic_ii_ceiling):
                        raise ValueError(f"{name}: direct ensemble member violates model or runtime bounds")
                    values.append(float(p_value))
                mean = math.fsum(values) / 4
                deviation = math.sqrt(math.fsum((value - mean) ** 2 for value in values) / 4)
                pred_ii, pred_std = prediction_entry.get("predicted_ii"), prediction_entry.get("predicted_ii_std")
                if (type(pred_ii) not in (int, float) or type(pred_std) not in (int, float)
                        or not math.isfinite(pred_ii) or not math.isfinite(pred_std)
                        or not math.isclose(pred_ii, mean, rel_tol=0, abs_tol=1e-5)
                        or not math.isclose(pred_std, deviation, rel_tol=0, abs_tol=1e-5)):
                    raise ValueError(f"{name}: direct shape mean or deviation differs from member values")
            elif prediction_entry.get("support_status") != "unsupported":
                raise ValueError(f"{name}: direct orientation has an unknown support status")
            elif diagnostic_ii_ceiling == 23:
                validate_diagnostic_direct_row(prediction_entry, f"{name}.{shape[0]}x{shape[1]}")
            else:
                if (lower <= diagnostic_ii_ceiling
                        or prediction_entry.get("status") != "unsupported-model-domain"
                        or "predicted_ii" in prediction_entry):
                    raise ValueError(f"{name}: unsupported default-domain row is not fail-closed")
            predictions_by_shape[shape] = prediction_entry
        if set(predictions_by_shape) != {tuple(map(int, shape.split("x"))) for shape in EXPECTED_SHAPES}:
            raise ValueError(f"{name}: model binding does not cover all eight oriented shapes")
        parent_startup_by_shape[name] = {
            shape: float(entry["startup_cycles"])
            for shape, entry in predictions_by_shape.items()
            if entry.get("support_status") == "supported"
        }

    split_parents = {name for name, replicas in parent_geometry.items() if len(replicas) > 1}
    expected_record_ids = {(name, replica["replica_id"]) for name in split_parents
                           for replica in parent_geometry[name]}
    if set(records) != expected_record_ids:
        raise ValueError("replica profile evidence does not cover exactly every materialized parent/replica pair")
    materialized_partitions = task_map(materialization.get("parent_partitions"),
                                       "C++ replica materialization parent partitions", "parent_task")
    if set(materialized_partitions) != split_parents:
        raise ValueError("C++ source-partition report does not cover exactly the split parents")
    proof_children: dict[tuple[str, int], dict[str, Any]] = {}
    parent_source_work: dict[str, int] = {}
    parent_multiplicity: dict[str, int] = {}
    for parent in split_parents:
        proof = materialized_partitions[parent]
        if (proof.get("source_iteration_domain_status") != "certified-complete"
                or proof.get("source_iteration_domain_complete") is not True):
            raise ValueError(f"{parent}: C++ source partition is not certified complete")
        if original_domain_facts_by_task is not None:
            source_parent = original_domain_facts_by_task[parent]
            source_extents = source_parent.get("expanded_internal_extents")
            source_multiplicity = math.prod(source_extents)
            source_trip = require_int(source_parent.get("effective_mapper_firing_count"),
                                      f"{parent}.original_source_trip", 1)
            source_work = require_int(source_parent.get("source_iteration_work_count"),
                                      f"{parent}.original_source_work", 1)
            if (proof.get("source_iteration_work_count") != source_work
                    or proof.get("source_iteration_multiplicity") != source_multiplicity
                    or proof.get("expanded_internal_extents") != source_extents
                    or _bounds_volume(_partition_bounds(proof.get("original_domain"),
                                                        f"{parent}.original_domain")) != source_trip):
                raise ValueError(f"{parent}: materialization source-domain proof differs from original C++ facts")
        raw_children = proof.get("replicas")
        if not isinstance(raw_children, list) or len(raw_children) != len(parent_geometry[parent]):
            raise ValueError(f"{parent}: C++ source partition omits materialized children")
        if proof.get("original_replica_count") != len(parent_geometry[parent]):
            raise ValueError(f"{parent}: C++ source partition changed the original replica count")
        parent_source_work[parent], parent_multiplicity[parent] = _validate_partition_cover(proof, raw_children, parent)
        if parent_source_work[parent] != parent_trip[parent] * parent_multiplicity[parent]:
            raise ValueError(f"{parent}: C++ parent source work differs from the original parent macro trip count")
        child_ids: set[int] = set()
        for child in raw_children:
            if not isinstance(child, dict):
                raise ValueError(f"{parent}: C++ source partition child is malformed")
            replica_id = require_int(child.get("replica_id"), f"{parent}.partition.replica_id", 0)
            if replica_id in child_ids:
                raise ValueError(f"{parent}: C++ source partition repeats a replica id")
            child_ids.add(replica_id)
            key = (parent, replica_id)
            record = records.get(key)
            if record is None or child.get("materialized_task") != record.get("materialized_task"):
                raise ValueError(f"{parent}/{replica_id}: partition child identity differs from profile evidence")
            replica = parent_geometry[parent][replica_id]
            expected_cells = replica["actual_cells"]
            if (child.get("actual_placed_shape"), child.get("row"), child.get("col"),
                    child.get("rows"), child.get("cols"), child.get("actual_cells")) != (
                    replica["shape"], replica["row"], replica["col"], replica["rows"], replica["cols"], expected_cells):
                raise ValueError(f"{parent}/{replica_id}: C++ source proof changed the original placement")
            if (child.get("selected_profile_shape") != replica["shape"]
                    or child.get("selected_cgra_count") != replica["cgra_count"]
                    or child.get("context_ids") != replica["context_ids"]):
                raise ValueError(f"{parent}/{replica_id}: C++ source proof changed orientation, count, or context ids")
            if (child.get("source_iteration_domain_status") != "certified-complete"
                    or child.get("source_iteration_domain_complete") is not True):
                raise ValueError(f"{parent}/{replica_id}: child source domain is not certified complete")
            proof_children[key] = child
        if child_ids != set(range(len(parent_geometry[parent]))):
            raise ValueError(f"{parent}: C++ source partition replica ids are incomplete")

    expected_expanded_order: list[str] = []
    expanded_parent_for_task: dict[str, tuple[str, int | None]] = {}
    for parent in source_dispatch:
        if parent in split_parents:
            for replica in parent_geometry[parent]:
                record = records[(parent, replica["replica_id"])]
                child_name = require_string(record.get("materialized_task"), "replica evidence.materialized_task")
                expected_expanded_order.append(child_name)
                expanded_parent_for_task[child_name] = (parent, replica["replica_id"])
        else:
            expected_expanded_order.append(parent)
            expanded_parent_for_task[parent] = (parent, None)
    if result.get("dispatch_order") != expected_expanded_order or trace.get("dispatch_order") != expected_expanded_order:
        raise ValueError("expanded dispatch order does not preserve parent order and replica-id order")
    expanded_names = set(expected_expanded_order)
    _validate_replica_profile_file_coverage(records, expanded_names)
    expected_materialized_task_facts: dict[str, dict[str, Any]] = {}
    for task_name in expected_expanded_order:
        parent, replica_id = expanded_parent_for_task[task_name]
        if replica_id is None:
            expected_facts: dict[str, Any] = {"trip_count": parent_trip[parent]}
            if original_domain_facts_by_task is not None:
                source_parent = original_domain_facts_by_task[parent]
                expected_facts.update({
                    "source_iteration_work_count": source_parent["source_iteration_work_count"],
                    "source_iteration_multiplicity": math.prod(source_parent["expanded_internal_extents"]),
                    "expanded_internal_extents": source_parent["expanded_internal_extents"],
                })
        else:
            child = proof_children[(parent, replica_id)]
            expected_facts = {
                "trip_count": child["trip_count"],
                "source_iteration_work_count": child["source_iteration_work_count"],
                "source_iteration_multiplicity": child["source_iteration_multiplicity"],
                "expanded_internal_extents": child["expanded_internal_extents"],
            }
        expected_materialized_task_facts[task_name] = expected_facts
    _, materialized_fact_dependencies = _validate_materialized_task_facts(
        function, materialized_source_facts, expected_materialized_task_facts)

    coverage = (result.get("iteration_domain_coverage_status"),
                result.get("iteration_domain_coverage_verified"))
    trace_coverage = (trace.get("iteration_domain_coverage_status"),
                      trace.get("iteration_domain_coverage_verified"))
    admitted_coverage = {("pending", False), ("verified-unsharded-source-domain-v1", True)}
    if diagnostic_ii_ceiling == 23 and source_domain_facts is not None:
        required_status = ("verified-original-static-internal-source-domain-v1"
                          if expanded_source_domain else "verified-unsharded-source-domain-v1")
        admitted_coverage = {(required_status, True)}
    if coverage not in admitted_coverage or trace_coverage != coverage:
        raise ValueError("expanded whole-program coverage label is invalid or differs from source-domain facts")

    trace_bindings = task_map(trace.get("task_profile_bindings"), "expanded task profile bindings")
    task_costs = task_map(result.get("task_costs"), "expanded task costs")
    trace_schedule = task_map(trace.get("task_schedule"), "expanded fixed schedule")
    root_schedule = task_map(result.get("task_schedule"), "expanded result schedule")
    if any(set(rows) != expanded_names for rows in (trace_bindings, task_costs, trace_schedule, root_schedule)):
        raise ValueError("expanded costs, profile bindings, or schedules do not cover exactly the child task inventory")
    if result.get("original_internal_time_unit") != source_unit or trace.get("iteration_domain_coverage_status") != result.get("iteration_domain_coverage_status") or trace.get("iteration_domain_coverage_verified") != result.get("iteration_domain_coverage_verified"):
        raise ValueError("expanded trace coverage/time metadata differs from result metadata")

    # Check every actual child body, selected-orientation mapper row, source
    # partition, model startup, and duration independently of the C++ result.
    intervals: dict[str, tuple[int, int]] = {}
    cells_by_task: dict[str, set[tuple[int, int]]] = {}
    occupancy: dict[tuple[int, int], list[tuple[int, int, str]]] = {}
    for task_name in expected_expanded_order:
        parent, replica_id = expanded_parent_for_task[task_name]
        if replica_id is None:
            source = source_rows[parent]
            replica = parent_geometry[parent][0]
            record = None
            trip = parent_trip[parent]
            work = None
            multiplicity = None
            extents = None
            source_status = "certified-complete"
            # Singleton tasks use the actual original parent profile and its selected shape.
            actual_body = body_rows[parent]
            placed_shape = replica["shape"]
            selected_profile = next(row for row in profile_rows[parent]["profiles"]
                                    if row["composed_cgra_shape"] == placed_shape)
            body_record = {**actual_body}
        else:
            source = source_rows[parent]
            replica = parent_geometry[parent][replica_id]
            record = records[(parent, replica_id)]
            partition = proof_children[(parent, replica_id)]
            trip = require_int(partition.get("trip_count"), f"{task_name}.partition.trip_count", 1)
            work = require_int(partition.get("source_iteration_work_count"), f"{task_name}.partition.source_work", 1)
            multiplicity = parent_multiplicity[parent]
            parent_partition = materialized_partitions[parent]
            extents = parent_partition["expanded_internal_extents"]
            source_status = partition["source_iteration_domain_status"]
            placed_shape = replica["shape"]
            body_record, selected_profile, _ = _validate_child_evidence(record, task_name, trip, placed_shape, function)
        rows, cols = shape_dims(placed_shape, f"{task_name}.placed_shape")
        if (rows, cols) != (replica["rows"], replica["cols"]):
            raise ValueError(f"{task_name}: actual selected mapper orientation differs from original placement")
        compiled_ii = require_int(selected_profile.get("compiled_ii"), f"{task_name}.compiled_ii", 1)
        if compiled_ii > diagnostic_ii_ceiling:
            raise ValueError(f"{task_name}: mapper II exceeds the runtime control-memory ceiling")
        steps = require_int(selected_profile.get("steps"), f"{task_name}.steps", 1)
        sample_trip = require_int(selected_profile.get("sample_trip_count"), f"{task_name}.sample_trip_count", 1)
        operations = require_int(selected_profile.get("materialized_operation_count"), f"{task_name}.materialized_operation_count", 1)
        profile_duration = require_int(selected_profile.get("estimated_latency"), f"{task_name}.profile_duration", 1)
        if sample_trip != trip or profile_duration != compiled_ii * (trip - 1) + steps:
            raise ValueError(f"{task_name}: actual child mapper II/trip/steps do not prove profile duration")
        if replica_id is None:
            startup_entry = costs_by_shape[parent].get((rows, cols))
        else:
            startup_entry = costs_by_shape[parent].get((rows, cols))
        if not isinstance(startup_entry, dict) or startup_entry.get("support_status") != "supported":
            raise ValueError(f"{task_name}: original parent has no supported startup for the actual placed orientation")
        startup = startup_entry.get("startup_cycles")
        if type(startup) not in (int, float) or not math.isfinite(startup) or startup <= 0:
            raise ValueError(f"{task_name}: original-parent orientation startup is invalid")
        mapped_duration = math.ceil(startup + compiled_ii * (trip - 1))

        binding_row = trace_bindings[task_name]
        cost_row = task_costs[task_name]
        if (binding_row.get("task") != task_name or binding_row.get("parent_task") != parent
                or binding_row.get("replica_id") != replica_id
                or cost_row.get("task") != task_name or cost_row.get("parent_task") != parent
                or cost_row.get("replica_id") != replica_id):
            raise ValueError(f"{task_name}: expanded binding/cost parent or replica identity differs")
        if (binding_row.get("selected_profile_shape") != placed_shape
                or cost_row.get("selected_profile_shape") != placed_shape
                or binding_row.get("selected_cgra_count") != replica["cgra_count"]
                or cost_row.get("selected_cgra_count") != replica["cgra_count"]
                or cost_row.get("selected_cgra_shape") != placed_shape
                or binding_row.get("selected_mapper_tile_rows") != rows * 2
                or binding_row.get("selected_mapper_tile_cols") != cols * 2
                or cost_row.get("selected_mapper_tile_rows") != rows * 2
                or cost_row.get("selected_mapper_tile_cols") != cols * 2):
            raise ValueError(f"{task_name}: expanded profile/cost orientation differs from original parent placement")
        if (binding_row.get("static_trip_count") != trip
                or cost_row.get("trip_count") != trip
                or binding_row.get("compiled_ii") != compiled_ii
                or cost_row.get("profile_compiled_ii") != compiled_ii
                or binding_row.get("steps") != steps or cost_row.get("profile_steps") != steps
                or binding_row.get("sample_trip_count") != trip
                or cost_row.get("profile_sample_trip_count") != trip
                or binding_row.get("materialized_operation_count") != operations
                or cost_row.get("profile_materialized_operation_count") != operations
                or binding_row.get("profile_duration_cycles") != profile_duration
                or cost_row.get("original_profile_duration_cycles") != profile_duration
                or binding_row.get("catalog_startup_cycles") != startup
                or cost_row.get("catalog_startup_cycles") != startup
                or binding_row.get("mapped_duration_cycles") != mapped_duration
                or cost_row.get("mapped_duration_cycles") != mapped_duration
                or binding_row.get("mapper_succeeded") is not True
                or binding_row.get("current_ir_body_equivalence_verified") is not True):
            raise ValueError(f"{task_name}: real child profile/startup/duration binding differs")
        for key in ("task_signature", "counter_signature", "kernel_binding_signature", "normalized_mapper_body"):
            if binding_row.get(key) != body_record.get(key):
                raise ValueError(f"{task_name}: trace body export differs for {key}")
        if replica_id is not None:
            if (binding_row.get("materialized_task") != task_name
                    or binding_row.get("profile_file") != record.get("profile_file")
                    or binding_row.get("body_export_file") != record.get("body_export_file")):
                raise ValueError(f"{task_name}: trace body/profile paths differ from replica evidence manifest")
            source_fields = (
                cost_row.get("source_iteration_domain_status"),
                cost_row.get("source_iteration_domain_complete"),
                cost_row.get("source_iteration_multiplicity"),
                cost_row.get("source_iteration_work_count"),
                cost_row.get("expanded_internal_extents"),
            )
            binding_source_fields = (
                binding_row.get("source_iteration_domain_status"),
                binding_row.get("source_iteration_domain_complete"),
                binding_row.get("source_iteration_multiplicity"),
                binding_row.get("source_iteration_work_count"),
                binding_row.get("expanded_internal_extents"),
            )
            expected_source_fields = (source_status, True, multiplicity, work, extents)
            if (source_fields != expected_source_fields
                    or binding_source_fields != expected_source_fields):
                raise ValueError(f"{task_name}: retimed cost/profile binding differs from C++ source partition facts")
        schedule = trace_schedule[task_name]
        if root_schedule[task_name] != schedule:
            raise ValueError(f"{task_name}: result schedule differs from fixed trace schedule")
        start = require_int(schedule.get("start_cycle"), f"{task_name}.start_cycle", 0)
        end = require_int(schedule.get("end_cycle"), f"{task_name}.end_cycle", 1)
        if (schedule.get("row"), schedule.get("col"), schedule.get("rows"), schedule.get("cols")) != (
                replica["row"], replica["col"], replica["rows"], replica["cols"]):
            raise ValueError(f"{task_name}: expanded scheduler moved or reshaped original replica cells")
        if end - start != mapped_duration or schedule.get("duration_cycles") != mapped_duration:
            raise ValueError(f"{task_name}: scheduled duration is not actual startup plus II times trip-minus-one")
        if schedule.get("occupied_cells") != replica["actual_cells"]:
            raise ValueError(f"{task_name}: expanded scheduler changed occupied cells, replica ids, or contexts")
        occupied = {(cell["row"], cell["col"]) for cell in replica["actual_cells"]}
        intervals[task_name] = (start, end)
        cells_by_task[task_name] = occupied
        for cell in occupied:
            occupancy.setdefault(cell, []).append((start, end, task_name))

    if max(end for _, end in intervals.values()) != result.get("mapped_whole_program_cycles") or result.get("predicted_whole_program_cycles") != result.get("mapped_whole_program_cycles"):
        raise ValueError("expanded retimed makespan differs from task intervals")
    for rows in occupancy.values():
        rows.sort()
        if any(left[1] > right[0] for left, right in zip(rows, rows[1:])):
            raise ValueError("expanded tasks overlap on an original occupied CGRA")

    return _validate_expanded_communication_trace(
        result, trace, expected_expanded_order, intervals, cells_by_task,
        parse_inter_task_network(network_text if network_text is not None else architecture_text),
        architecture_text, graph_id, function, materialized_module,
        split_parents, len(records), source_dispatch,
        materialized_fact_dependencies)


def _validate_expanded_communication_trace(result: dict[str, Any], trace: dict[str, Any],
                                            dispatch: list[str], intervals: dict[str, tuple[int, int]],
                                            cells_by_task: dict[str, set[tuple[int, int]]],
                                            architecture: dict[str, Any], architecture_text: str,
                                            graph_id: str, function: str, materialized_module: str,
                                            split_parents: set[str], replica_count: int,
                                            parent_dispatch: list[str],
                                            materialized_fact_dependencies: list[dict[str, Any]]) -> dict[str, Any]:
    network_links = assert_network_matches_trace(architecture, trace.get("communication_contract"))
    dependencies = trace.get("dependencies")
    routes = trace.get("routes")
    if not isinstance(dependencies, list) or not isinstance(routes, list):
        raise ValueError("expanded fixed trace lacks typed dependencies or routes")
    if _trace_dependency_inventory(dependencies) != _fact_dependency_inventory(materialized_fact_dependencies):
        raise ValueError("expanded trace dependency inventory differs from independently extracted materialized graph facts")
    names = set(dispatch)
    edge_ids: set[int] = set()
    predecessor_pairs: set[tuple[str, str]] = set()
    data_edges: dict[tuple[str, str], list[dict[str, Any]]] = {}
    for edge in dependencies:
        if not isinstance(edge, dict):
            raise ValueError("expanded typed dependency is malformed")
        edge_id = require_int(edge.get("edge_index"), "dependency.edge_index", 0)
        producer = require_string(edge.get("producer"), "dependency.producer")
        consumer = require_string(edge.get("consumer"), "dependency.consumer")
        if (edge.get("edge_id") != f"edge-{edge_id}" or edge_id in edge_ids
                or producer not in names or consumer not in names or producer == consumer):
            raise ValueError("expanded typed dependency has a duplicate ID or invalid child endpoint")
        edge_ids.add(edge_id)
        if (edge.get("kind") not in ("value", "raw", "war", "waw", "control")
                or edge.get("origin") not in ("taskflow", "memory_order", "control")
                or edge.get("scope") not in ("tensor_wide", "tile_local")
                or edge.get("producer_segment") not in ("none", "done_reads", "done_writes", "value_outputs")
                or edge.get("consumer_segment") not in ("will_reads", "will_writes", "value_inputs", "control")):
            raise ValueError("expanded dependency semantics are malformed")
        require_int(edge.get("producer_index"), "dependency.producer_index", 0)
        require_int(edge.get("consumer_index"), "dependency.consumer_index", 0)
        lower, upper = edge.get("transfer_region_lower"), edge.get("transfer_region_upper")
        if not isinstance(lower, list) or not isinstance(upper, list) or len(lower) != len(upper) or any(type(x) is not int for x in lower + upper):
            raise ValueError("expanded typed dependency region is malformed")
        if edge.get("payload_known") is not (type(edge.get("payload_bits")) is int):
            raise ValueError("expanded dependency payload-known flag differs from payload")
        payload = edge.get("payload_bits")
        if payload is not None and (type(payload) is not int or payload < 0):
            raise ValueError("expanded dependency payload is invalid")
        if intervals[producer][1] > intervals[consumer][0]:
            raise ValueError("expanded task starts before a typed dependency is ready")
        pair = (producer, consumer)
        predecessor_pairs.add(pair)
        if edge["kind"] in ("raw", "value"):
            if payload is None:
                raise ValueError("expanded data dependency has unknown payload")
            data_edges.setdefault(pair, []).append(edge)
    if edge_ids != set(range(len(dependencies))):
        raise ValueError("expanded dependency IDs are not a contiguous inventory")
    dispatch_index = {name: index for index, name in enumerate(dispatch)}
    if any(dispatch_index[a] >= dispatch_index[b] for a, b in predecessor_pairs):
        raise ValueError("expanded dispatch order violates its source dependency graph")
    if result.get("replayed_communication_edges") != len(predecessor_pairs):
        raise ValueError("expanded predecessor-pair count differs from typed graph")

    route_pairs: set[tuple[str, str]] = set()
    route_ready: dict[tuple[str, str], int] = {}
    resource_intervals: dict[tuple[Any, ...], list[tuple[int, int]]] = {}
    for route in routes:
        if not isinstance(route, dict):
            raise ValueError("expanded route record is malformed")
        producer = require_string(route.get("producer"), "route.producer")
        consumer = require_string(route.get("consumer"), "route.consumer")
        pair = (producer, consumer)
        if route.get("route_id") != f"{producer}->{consumer}" or pair in route_pairs or pair not in data_edges:
            raise ValueError("expanded route is duplicated or has no child data dependency")
        route_pairs.add(pair)
        ready = require_int(route.get("ready_cycle"), "route.ready_cycle", 0)
        route_ready[pair] = ready
        edges = data_edges[pair]
        payload = sum(edge["payload_bits"] for edge in edges)
        if payload <= 0 or route.get("payload_bits") != payload or route.get("edge_indices") != [edge["edge_index"] for edge in edges]:
            raise ValueError("expanded route aggregation differs from its typed child edges")
        source = (require_int(route.get("source_row"), "route.source_row", 0), require_int(route.get("source_col"), "route.source_col", 0))
        destination = (require_int(route.get("destination_row"), "route.destination_row", 0), require_int(route.get("destination_col"), "route.destination_col", 0))
        if source not in cells_by_task[producer] or destination not in cells_by_task[consumer]:
            raise ValueError("expanded route endpoint is outside actual child placements")
        start = require_int(route.get("start_cycle"), "route.start_cycle", 0)
        transfer = require_int(route.get("transfer_cycles"), "route.transfer_cycles", 1)
        latency = require_int(route.get("path_latency_cycles"), "route.path_latency_cycles", 0)
        bandwidth = require_int(route.get("bottleneck_bandwidth_bits_per_cycle"), "route.bandwidth", 1)
        if (route.get("producer_finish_cycle") != intervals[producer][1]
                or route.get("consumer_start_cycle") != intervals[consumer][0]
                or start < intervals[producer][1] or ready > intervals[consumer][0]
                or ready != start + transfer):
            raise ValueError("expanded route producer/consumer interval is inconsistent")
        raw_intervals = route.get("intervals")
        if not isinstance(raw_intervals, list) or not raw_intervals:
            raise ValueError("expanded positive-payload route omits resource intervals")
        if source == destination:
            expected_transfer = (payload + architecture["local_bandwidth_bits_per_cycle"] - 1) // architecture["local_bandwidth_bits_per_cycle"]
            if (latency != 0 or bandwidth != architecture["local_bandwidth_bits_per_cycle"]
                    or transfer != expected_transfer or len(raw_intervals) != 1
                    or raw_intervals[0].get("resource_kind") != "local_channel"
                    or (raw_intervals[0].get("row"), raw_intervals[0].get("col")) != source):
                raise ValueError("expanded local route violates channel bandwidth/endpoint facts")
            resources = [("local_channel", source[0], source[1])]
        else:
            indices = []
            for item in raw_intervals:
                if not isinstance(item, dict) or item.get("resource_kind") != "network_link":
                    raise ValueError("expanded remote route contains a non-link resource")
                indices.append(require_int(item.get("link_index"), "route.link_index", 0))
            current = source
            path_latency = 0
            path_bandwidth: int | None = None
            visited = {current}
            for link_index in indices:
                if link_index >= len(network_links):
                    raise ValueError("expanded route references an unknown network link")
                link = network_links[link_index]
                link_source = (link["source_row"], link["source_col"])
                link_destination = (link["destination_row"], link["destination_col"])
                if link_source != current or link_destination in visited:
                    raise ValueError("expanded route path is discontinuous or cyclic")
                current = link_destination
                visited.add(current)
                path_latency += link["latency_cycles"]
                path_bandwidth = link["bandwidth_bits_per_cycle"] if path_bandwidth is None else min(path_bandwidth, link["bandwidth_bits_per_cycle"])
            if current != destination or path_bandwidth is None:
                raise ValueError("expanded route does not reach its child destination")
            expected_transfer = path_latency + (payload + path_bandwidth - 1) // path_bandwidth
            if latency != path_latency or bandwidth != path_bandwidth or transfer != expected_transfer:
                raise ValueError("expanded route payload/bandwidth/latency is inconsistent")
            resources = [("network_link", index) for index in indices]
        for item, resource in zip(raw_intervals, resources):
            begin = require_int(item.get("start_cycle"), "route.interval.start", 0)
            end = require_int(item.get("end_cycle"), "route.interval.end", 1)
            if (begin, end) != (start, ready):
                raise ValueError("expanded route resource interval differs from ready interval")
            resource_intervals.setdefault(resource, []).append((begin, end))
    expected_routes = {pair for pair, edges in data_edges.items() if sum(edge["payload_bits"] for edge in edges) > 0}
    if route_pairs != expected_routes:
        raise ValueError("expanded route set does not cover positive-payload child edge pairs")
    for task in dispatch:
        incoming = [pair for pair in predecessor_pairs if pair[1] == task]
        ready = max((route_ready[pair] if pair in route_ready else intervals[pair[0]][1]
                     for pair in incoming), default=0)
        schedule = next(row for row in trace["task_schedule"] if row.get("task") == task)
        if intervals[task][0] < ready or schedule.get("idle_cycles") != intervals[task][0] - ready:
            raise ValueError(f"{task}: expanded start/idle interval differs from predecessors")
    for resource, rows in resource_intervals.items():
        rows.sort()
        if any(left[1] > right[0] for left, right in zip(rows, rows[1:])):
            raise ValueError(f"expanded route resources overlap on {resource}")
    return {
        "schema": "orbit-original-amoeba-fixed-retiming-validation-v1",
        "status": "pass", "function": function, "graph_variant_id": graph_id,
        "candidate_id": result.get("candidate_id"), "task_count": len(dispatch),
        "original_parent_count": len(parent_dispatch), "replica_count": replica_count,
        "split_parent_count": len(split_parents), "dependency_count": len(dependencies),
        "routed_data_pairs": len(routes),
        "mapped_whole_program_cycles": result.get("mapped_whole_program_cycles"),
        "formal_go": False,
        "iteration_domain_coverage_status": result.get("iteration_domain_coverage_status"),
        "iteration_domain_coverage_verified": result.get("iteration_domain_coverage_verified"),
        "replica_materialization_verified": True,
        "materialized_source_facts_verified": True,
        "materialized_module": materialized_module,
    }


class AttributeParser:
    """Parse the MLIR string/integer/bool/array/dictionary attrs used here."""

    def __init__(self, raw: str):
        self.tokens: list[str] = []
        position = 0
        while position < len(raw):
            match = TOKEN.match(raw, position)
            if match is None:
                raise ValueError(f"unsupported MLIR attribute at offset {position}")
            self.tokens.append(next(part for part in match.groups() if part is not None))
            position = match.end()
        self.index = 0

    def take(self, expected: str | None = None) -> str:
        if self.index >= len(self.tokens):
            raise ValueError("unexpected end of MLIR attribute")
        token = self.tokens[self.index]
        self.index += 1
        if expected is not None and token != expected:
            raise ValueError(f"expected {expected!r}, found {token!r}")
        return token

    def parse(self) -> Any:
        token = self.take()
        if token == "{":
            result: dict[str, Any] = {}
            while self.index < len(self.tokens) and self.tokens[self.index] != "}":
                key = self.take()
                if key in result:
                    raise ValueError(f"duplicate MLIR dictionary key {key}")
                self.take("=")
                result[key] = self.parse()
                if self.index < len(self.tokens) and self.tokens[self.index] != "}":
                    self.take(",")
            self.take("}")
            return result
        if token == "[":
            result_list: list[Any] = []
            while self.index < len(self.tokens) and self.tokens[self.index] != "]":
                result_list.append(self.parse())
                if self.index < len(self.tokens) and self.tokens[self.index] != "]":
                    self.take(",")
            self.take("]")
            return result_list
        if token.startswith('"'):
            return json.loads(token)
        if re.fullmatch(r"-?[0-9]+", token):
            if self.index < len(self.tokens) and self.tokens[self.index] == ":":
                self.take(":")
                integer_type = self.take()
                if integer_type not in ("i1", "i8", "i16", "i32", "i64", "index"):
                    raise ValueError(f"unsupported MLIR integer type {integer_type}")
            return int(token)
        if token in ("true", "false"):
            return token == "true"
        raise ValueError(f"unsupported MLIR attribute value {token!r}")

    def document(self) -> Any:
        result = self.parse()
        if self.index != len(self.tokens):
            raise ValueError("MLIR attribute has trailing tokens")
        return result


def extract_attribute(ir: str, name: str) -> Any:
    matches = list(re.finditer(re.escape(name) + r"\s*=\s*", ir))
    if len(matches) != 1:
        raise ValueError(f"exactly one {name} attribute is required")
    begin = matches[0].end()
    depth = 0
    quoted = False
    escaped = False
    end = begin
    for end in range(begin, len(ir)):
        char = ir[end]
        if quoted:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                quoted = False
            continue
        if char == '"':
            quoted = True
        elif char in "[{":
            depth += 1
        elif char in "]}":
            if depth == 0:
                break
            depth -= 1
            if depth == 0:
                end += 1
                break
        elif depth == 0 and char in ",}":
            break
    raw = ir[begin:end].strip()
    if not raw:
        raise ValueError(f"{name} has an empty value")
    return AttributeParser(raw).document()


def require_int(value: Any, label: str, minimum: int | None = None) -> int:
    if type(value) is not int or (minimum is not None and value < minimum):
        raise ValueError(f"{label} must be an integer" + (f" >= {minimum}" if minimum is not None else ""))
    return value


def require_string(value: Any, label: str) -> str:
    if not isinstance(value, str) or not value:
        raise ValueError(f"{label} must be a nonempty string")
    return value


def task_map(rows: Any, label: str, task_key: str = "task") -> dict[str, dict[str, Any]]:
    if not isinstance(rows, list):
        raise ValueError(f"{label} must be an array")
    result: dict[str, dict[str, Any]] = {}
    for row in rows:
        if not isinstance(row, dict):
            raise ValueError(f"{label} row must be an object")
        name = require_string(row.get(task_key), f"{label}.{task_key}")
        if name in result:
            raise ValueError(f"{label} contains duplicate task {name}")
        result[name] = row
    return result


def contains_key(value: Any, key: str) -> bool:
    if isinstance(value, dict):
        return key in value or any(contains_key(child, key) for child in value.values())
    if isinstance(value, list):
        return any(contains_key(child, key) for child in value)
    return False


def contains_function_symbol(ir: str, function: str) -> bool:
    """Find a function in either pretty or generic MLIR assembly syntax."""
    if re.search(r"\bfunc\.func\s+@" + re.escape(function) + r"(?![A-Za-z0-9_.$])", ir):
        return True

    # Generic operation syntax spells the symbol in the operation's attribute
    # dictionary, e.g. `"func.func"() <{sym_name = "f", ...}> ({...})`.
    # Scan each function header's balanced attribute dictionary so the lookup
    # cannot accidentally match a similarly named attribute on another op.
    marker = re.compile(r'"func\.func"\s*\(\)\s*<\{')
    for match in marker.finditer(ir):
        begin = match.end()
        depth = 1
        quoted = False
        escaped = False
        end = begin
        for end in range(begin, len(ir)):
            char = ir[end]
            if quoted:
                if escaped:
                    escaped = False
                elif char == "\\":
                    escaped = True
                elif char == '"':
                    quoted = False
                continue
            if char == '"':
                quoted = True
            elif char == "{":
                depth += 1
            elif char == "}":
                depth -= 1
                if depth == 0:
                    break
        if depth != 0 or end + 1 >= len(ir) or ir[end + 1] != ">":
            continue
        attributes = ir[begin:end]
        symbol = re.search(r'\bsym_name\s*=\s*("(?:\\.|[^"\\])*")', attributes)
        if symbol and json.loads(symbol.group(1)) == function:
            return True
    return False


def shape_dims(value: Any, label: str) -> tuple[int, int]:
    text = require_string(value, label)
    match = re.fullmatch(r"([1-4])x([1-4])", text)
    if not match:
        raise ValueError(f"{label} is not a rectangular shape")
    rows, cols = int(match.group(1)), int(match.group(2))
    if rows * cols > 4:
        raise ValueError(f"{label} exceeds the four-CGRA cap")
    return rows, cols


def parse_inter_task_network(architecture_text: str) -> dict[str, Any]:
    """Parse the strict scalar/inline-link network section from embedded YAML."""
    lines = architecture_text.splitlines()
    starts = [index for index, line in enumerate(lines) if re.fullmatch(r"inter_task_network:\s*", line)]
    if len(starts) != 1:
        raise ValueError("embedded architecture must have one inter_task_network section")
    scalar: dict[str, int] = {}
    links: list[dict[str, int]] = []
    in_links = False
    for line in lines[starts[0] + 1 :]:
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        indent = len(line) - len(line.lstrip())
        if indent == 0:
            break
        if indent == 2 and not line.startswith("  -"):
            match = re.fullmatch(r"  ([a-z_]+):\s*([0-9]+)\s*", line)
            if match:
                key, value = match.group(1), int(match.group(2))
                if key in scalar:
                    raise ValueError(f"duplicate architecture network field {key}")
                scalar[key] = value
                in_links = False
            elif line == "  links:":
                in_links = True
            else:
                raise ValueError(f"unsupported architecture network line: {line}")
        elif indent == 4 and in_links:
            match = re.fullmatch(r"\s*-\s*\{(.*)\}\s*", line)
            if not match:
                raise ValueError("architecture network link must be an inline mapping")
            link: dict[str, int] = {}
            for field in match.group(1).split(","):
                pair = re.fullmatch(r"\s*([a-z_]+):\s*([0-9]+)\s*", field)
                if not pair:
                    raise ValueError(f"invalid architecture network link field {field!r}")
                key, value = pair.group(1), int(pair.group(2))
                if key in link:
                    raise ValueError(f"duplicate architecture link field {key}")
                link[key] = value
            if set(link) != {"src_row", "src_column", "dst_row", "dst_column", "latency_cycles", "bandwidth_bits_per_cycle"}:
                raise ValueError("architecture network link fields are incomplete")
            links.append(link)
        else:
            raise ValueError(f"unsupported indentation in architecture network: {line}")
    required = {"version", "rows", "columns", "local_bandwidth_bits_per_cycle"}
    if set(scalar) != required or not links:
        raise ValueError("architecture network contract is incomplete")
    if scalar["version"] != 1 or scalar["rows"] != 4 or scalar["columns"] != 4 or scalar["local_bandwidth_bits_per_cycle"] <= 0:
        raise ValueError("architecture network dimensions or version are unsupported")
    directed: set[tuple[int, int, int, int]] = set()
    for link in links:
        src = (link["src_row"], link["src_column"])
        dst = (link["dst_row"], link["dst_column"])
        if any(value < 0 or value >= 4 for value in (*src, *dst)) or src == dst:
            raise ValueError("architecture link endpoint is out of bounds")
        if link["latency_cycles"] <= 0 or link["bandwidth_bits_per_cycle"] <= 0:
            raise ValueError("architecture link latency and bandwidth must be positive")
        if (*src, *dst) in directed:
            raise ValueError("architecture network repeats a directed link")
        directed.add((*src, *dst))
    return {"version": scalar["version"], "rows": scalar["rows"], "columns": scalar["columns"],
            "local_bandwidth_bits_per_cycle": scalar["local_bandwidth_bits_per_cycle"], "links": links}


def assert_network_matches_trace(architecture: dict[str, Any], contract: Any) -> list[dict[str, int]]:
    if not isinstance(contract, dict) or contract.get("schema") != "inter-task-network-v1":
        raise ValueError("fixed trace has no supported communication contract")
    if contract.get("resource_interval_semantics") != "half-open-start-inclusive-end-exclusive":
        raise ValueError("fixed trace does not declare half-open resource intervals")
    for key in ("version", "rows", "columns", "local_bandwidth_bits_per_cycle"):
        if contract.get(key) != architecture[key]:
            raise ValueError(f"fixed trace network {key} differs from embedded architecture")
    raw_links = contract.get("links")
    if not isinstance(raw_links, list) or len(raw_links) != len(architecture["links"]):
        raise ValueError("fixed trace network link inventory differs from architecture")
    links: list[dict[str, int]] = []
    for index, (raw, source) in enumerate(zip(raw_links, architecture["links"])):
        if not isinstance(raw, dict):
            raise ValueError("fixed trace network link is not an object")
        expected = {"link_index": index, "source_row": source["src_row"],
                    "source_col": source["src_column"], "destination_row": source["dst_row"],
                    "destination_col": source["dst_column"], "latency_cycles": source["latency_cycles"],
                    "bandwidth_bits_per_cycle": source["bandwidth_bits_per_cycle"]}
        if raw != expected:
            raise ValueError(f"fixed trace network link {index} differs from architecture")
        links.append(expected)
    return links


def validate(ir: str, result: dict[str, Any], body_proof: dict[str, Any],
             profiles: dict[str, Any], costs: dict[str, Any],
             network_text: str | None = None,
             diagnostic_ii_ceiling: int = 20,
             source_domain_facts: dict[str, Any] | None = None,
             replica_profile_evidence: dict[str, Any] | None = None,
             materialized_source_facts: dict[str, Any] | None = None) -> dict[str, Any]:
    if (replica_profile_evidence is not None
            and _has_production_scheduler_reschedule(result)):
        raise ValueError("production-scheduler rescheduling does not support expanded child mode")
    if replica_profile_evidence is not None:
        if materialized_source_facts is None:
            raise ValueError("expanded replica validation requires independently extracted materialized source facts")
        return validate_expanded_replica_trace(
            ir, result, body_proof, profiles, costs, replica_profile_evidence,
            network_text, diagnostic_ii_ceiling, source_domain_facts,
            materialized_source_facts)
    if materialized_source_facts is not None:
        raise ValueError("materialized source facts require replica profile evidence")
    if result.get("schema") != "amoeba-original-fixed-decision-retiming-v1" or result.get("valid") is not True:
        raise ValueError("retimed record is not a valid original fixed-decision result")
    if result.get("diagnostic_only") is not True or result.get("formal_go") is not False:
        raise ValueError("fixed retiming must remain diagnostic with formal_go=false")
    coverage_pair = (
        result.get("iteration_domain_coverage_status"),
        result.get("iteration_domain_coverage_verified"),
    )
    admitted_coverage = {
        ("pending", False),
        ("verified-unsharded-source-domain-v1", True),
    }
    if diagnostic_ii_ceiling == 23 and source_domain_facts is not None:
        admitted_coverage.add(("verified-original-static-internal-source-domain-v1", True))
    if coverage_pair not in admitted_coverage:
        raise ValueError("iteration-domain coverage status/boolean is invalid or overstated")
    trace = result.get("fixed_decision_trace")
    if not isinstance(trace, dict) or trace.get("schema") != "amoeba-fixed-decision-trace-v1":
        raise ValueError("retimed result lacks the source-owned fixed_decision_trace")
    explicit_f45_replica_mode = (
        "replica_timing_policy" in result or "replica_timing_policy" in trace
    )
    if explicit_f45_replica_mode:
        result_policy = result.get("replica_timing_policy")
        trace_policy = trace.get("replica_timing_policy")
        if (not isinstance(result_policy, dict)
                or set(result_policy) != set(F45_REPLICA_TIMING_POLICY)
                or result_policy.get("child_mapper_profiles_used") is not False
                or result_policy != F45_REPLICA_TIMING_POLICY
                or not isinstance(trace_policy, dict)
                or set(trace_policy) != set(F45_REPLICA_TIMING_POLICY)
                or trace_policy.get("child_mapper_profiles_used") is not False
                or trace_policy != F45_REPLICA_TIMING_POLICY
                or trace_policy != result_policy):
            raise ValueError("explicit original F45 replica timing policy is missing, mismatched, or unsupported")
    production_scheduler_decisions = _validate_production_scheduler_contract(
        result, trace, explicit_f45_replica_mode)
    production_scheduler_mode = production_scheduler_decisions is not None
    if trace.get("candidate_id") != result.get("candidate_id"):
        raise ValueError("fixed trace candidate identity differs from retimed result")
    trace_coverage_pair = (
        trace.get("iteration_domain_coverage_status"),
        trace.get("iteration_domain_coverage_verified"),
    )
    if (
        trace.get("formal_go") is not False
        or trace_coverage_pair != coverage_pair
    ):
        raise ValueError("fixed trace overstates or disagrees with formal/iteration-domain evidence")
    if result.get("body_equivalence_checked") is not True or trace.get("body_equivalence_checked") is not True:
        raise ValueError("current-IR normalized-body equivalence was not certified")
    if result.get("selected_profile_body_binding_verified") is not True:
        raise ValueError("retimer did not certify selected profile/body binding")
    if contains_key(result, "mapper_replay_verified") or contains_key(result, "joint_scheduling_replay_verified"):
        raise ValueError("diagnostic retiming must not claim mapper_replay_verified")

    function = require_string(result.get("function"), "result.function")
    if body_proof.get("format") != "amoeba-pre-mapper-task-bodies-v1" or profiles.get("format") != "amoeba-task-profile-v1":
        raise ValueError("body or profile input has an unsupported evidence schema")
    if body_proof.get("function") != function or profiles.get("function") != function:
        raise ValueError("retimer, body export, and profile function identities differ")
    if not contains_function_symbol(ir, function):
        raise ValueError("original MLIR does not contain the profiled function symbol")
    graph_id = require_string(result.get("graph_variant_id"), "result.graph_variant_id")
    source_graph = None
    graph_matches = re.findall(r'amoeba\.graph_variant_id\s*=\s*"([^"]*)"', ir)
    if len(graph_matches) > 1:
        raise ValueError("original MLIR has ambiguous graph-variant identities")
    if graph_matches and graph_matches[0]:
        source_graph = graph_matches[0]
    expected_graph = source_graph or "original-amoeba-full"
    if graph_id != expected_graph or trace.get("graph_variant_id") != expected_graph:
        raise ValueError("retimer graph label differs from preserved/assigned original graph identity")

    source_dispatch = extract_attribute(ir, "amoeba.task_scheduler_dispatch_order")
    source_schedule = extract_attribute(ir, "amoeba.task_scheduler_task_schedule")
    source_summary = extract_attribute(ir, "task_orchestration_summary")
    source_unit = extract_attribute(ir, "amoeba.task_scheduler_time_unit")
    source_scale = extract_attribute(ir, "amoeba.task_scheduler_time_scale")
    if not isinstance(source_dispatch, list) or not all(isinstance(item, str) for item in source_dispatch):
        raise ValueError("original dispatch order is malformed")
    source_rows = task_map(source_schedule, "original scheduler schedule", "task_name")
    if set(source_dispatch) != set(source_rows) or len(source_dispatch) != len(source_rows):
        raise ValueError("original dispatch and scheduler records have different task coverage")
    if not isinstance(source_summary, dict) or source_summary.get("strategy") != "throughput-guided":
        raise ValueError("original scheduler strategy is not throughput-guided")
    if result.get("original_pipeline_interval") != source_summary.get("pipeline_interval"):
        raise ValueError("retimer pipeline interval differs from original scheduler summary")
    if source_unit != "scaled-internal-placement-slots" or result.get("original_internal_time_unit") != source_unit:
        raise ValueError("retimer time unit differs from original scheduler evidence")
    if type(source_scale) is not int or result.get("original_internal_time_scale") != source_scale:
        raise ValueError("retimer time scale differs from original scheduler evidence")
    task_names = set(source_rows)

    profile_binding = costs.get("original_amoeba_profile_binding")
    metadata = costs.get("predictor_metadata")
    if costs.get("schema") != "amoeba-task-shape-cost" or not isinstance(profile_binding, dict) or not isinstance(metadata, dict):
        raise ValueError("selected-shape cost catalog lacks original profile binding metadata")
    if profile_binding.get("schema") != "amoeba-original-profile-body-binding-v1" or profile_binding.get("candidate_id") != result.get("candidate_id"):
        raise ValueError("cost catalog profile binding schema/candidate differs")
    if profile_binding.get("function") != function or profile_binding.get("graph_variant_id") != graph_id:
        raise ValueError("cost catalog function or graph binding differs")
    if profile_binding.get("current_ir_body_equivalence_verified") is not True:
        raise ValueError("cost catalog does not certify exact current-IR body equivalence")
    if metadata.get("source_graph_id") != graph_id:
        raise ValueError("cost catalog graph provenance differs")
    if profile_binding.get("body_export_format") != body_proof.get("format") or profile_binding.get("profile_file_format") != profiles.get("format"):
        raise ValueError("cost catalog body/profile source formats differ")
    for key in ("architecture_path", "architecture_contract", "model", "model_schema", "feature_contract_id", "feature_extractor", "shape_protocol_id", "source_repository", "source_commit"):
        if not profile_binding.get(key) or metadata.get(key) != profile_binding.get(key):
            raise ValueError(f"cost catalog metadata and binding differ for {key}")
    architecture_text = profile_binding.get("architecture_text")
    if not isinstance(architecture_text, str) or not architecture_text:
        raise ValueError("cost catalog does not embed architecture source text")
    architecture_path = Path(profile_binding["architecture_path"])
    if not architecture_path.is_file() or architecture_path.read_text() != architecture_text:
        raise ValueError("embedded architecture text differs from its named source file")
    profile_path = Path(require_string(profile_binding.get("profile_file"), "cost binding.profile_file"))
    if not profile_path.is_file() or json.loads(profile_path.read_text()) != profiles:
        raise ValueError("cost profile path does not contain the supplied actual profile evidence")
    ensemble_text = require_string(profile_binding.get("ensemble_text"), "cost binding.ensemble_text")
    ensemble_path = Path(require_string(profile_binding.get("ensemble_path"), "cost binding.ensemble_path"))
    if not ensemble_path.is_file() or ensemble_path.read_text() != ensemble_text:
        raise ValueError("embedded model ensemble differs from its named source file")
    try:
        ensemble = json.loads(ensemble_text)
    except json.JSONDecodeError as error:
        raise ValueError(f"embedded model ensemble is invalid JSON: {error}") from error
    if ensemble.get("schema") != profile_binding.get("model_schema"):
        raise ValueError("embedded ensemble schema differs from catalog binding")
    direct_namespace = "orbit-per-cgra-2x2-direct-4member-v1"
    if profile_binding.get("model_namespace") == direct_namespace:
        validate_diagnostic_ii_contract(metadata, profile_binding, ensemble,
                                        architecture_text, diagnostic_ii_ceiling)
        members = ensemble.get("members")
        source_model = ensemble.get("source_model")
        bound_source_model = profile_binding.get("source_model")
        feature_contract = ensemble.get("feature_contract")
        shape_protocol = ensemble.get("shape_protocol")
        candidate_metadata = (
            bound_source_model.get("candidate_metadata")
            if isinstance(bound_source_model, dict)
            else None
        )
        if (
            ensemble.get("schema") != "orbit-cgra-ii-per-cgra-2x2-direct-ensemble-cpp-v1"
            or ensemble.get("model_namespace") != direct_namespace
            or not isinstance(members, list)
            or len(members) != 4
            or [member.get("seed") for member in members if isinstance(member, dict)] != [17, 41, 113, 239]
            or len([member for member in members if isinstance(member, dict)]) != 4
            or not isinstance(source_model, dict)
            or not isinstance(bound_source_model, dict)
            or source_model.get("repository") != bound_source_model.get("repository")
            or source_model.get("commit") != bound_source_model.get("commit")
            or source_model.get("branch") != bound_source_model.get("branch")
            or not isinstance(candidate_metadata, dict)
            or candidate_metadata.get("candidate_only") is not True
            or candidate_metadata.get("old_4x4_labels_reused") is not False
            or candidate_metadata.get("ensemble_member_count") != 4
            or candidate_metadata.get("feature_count") != 148
            or not isinstance(feature_contract, dict)
            or feature_contract.get("contract_id") != profile_binding.get("feature_contract_id")
            or feature_contract.get("contract_id") != "cgra-ii-pre-mapper-features-148-2x2-per-cgra-v1"
            or not isinstance(shape_protocol, dict)
            or shape_protocol.get("protocol_id") != profile_binding.get("shape_protocol_id")
            or shape_protocol.get("protocol_id") != "amoeba-static-rectangles-2x2-per-cgra-max4"
            or (diagnostic_ii_ceiling == 20
                and ensemble.get("architecture", {}).get("exact_yaml_text") != architecture_text)
        ):
            raise ValueError("embedded direct 2x2 ensemble provenance/schema differs from catalog binding")
    else:
        if diagnostic_ii_ceiling != 20:
            raise ValueError("II23 diagnostic validation requires the direct 2x2 model")
        if ensemble.get("quality_status") != "exploratory" or ensemble.get("production_ready") is not False:
            raise ValueError("embedded ensemble model status/schema differs from catalog binding")
        checkpoints = profile_binding.get("checkpoint_texts")
        checkpoint_directory = Path(require_string(profile_binding.get("checkpoint_directory"), "cost binding.checkpoint_directory"))
        checkpoint_sources = ensemble.get("checkpoints")
        if not isinstance(checkpoints, list) or len(checkpoints) != 3 or not isinstance(checkpoint_sources, dict) or len(checkpoint_sources) != 3:
            raise ValueError("embedded model must enumerate exactly three checkpoints")
        checkpoint_names: set[str] = set()
        for checkpoint in checkpoints:
            if not isinstance(checkpoint, dict):
                raise ValueError("embedded model checkpoint evidence is malformed")
            name = require_string(checkpoint.get("name"), "checkpoint.name")
            text = require_string(checkpoint.get("text"), f"checkpoint.{name}.text")
            source = checkpoint_sources.get(name)
            if name in checkpoint_names or not isinstance(source, dict):
                raise ValueError("embedded model checkpoint identity is missing or duplicated")
            relative_path = require_string(source.get("path"), f"checkpoint.{name}.path")
            source_path = Path(relative_path)
            if not source_path.is_absolute():
                source_path = checkpoint_directory / source_path
            if not source_path.is_file() or source_path.read_text() != text:
                raise ValueError(f"embedded checkpoint differs from named source file {name}")
            checkpoint_names.add(name)
        if checkpoint_names != {"baseline", "large-operation", "ranking"}:
            raise ValueError("embedded model checkpoint names differ from the formal ensemble")
    if profile_binding.get("model_namespace") == direct_namespace and network_text is None:
        raise ValueError("direct 2x2 validation requires the explicit inter-task network file")
    network_source_text = network_text if network_text is not None else architecture_text
    architecture = parse_inter_task_network(network_source_text)
    network_links = assert_network_matches_trace(architecture, trace.get("communication_contract"))

    body_rows = task_map(body_proof.get("tasks"), "body proof")
    profile_rows = task_map(profiles.get("tasks"), "task profiles")
    binding_rows = task_map(profile_binding.get("tasks"), "cost body binding")
    if diagnostic_ii_ceiling == 23:
        if source_domain_facts is None:
            raise ValueError("II23 validation requires source-owned current-domain fact evidence")
        expanded = validate_original_source_domain_facts(function, source_domain_facts,
                                                         body_rows, binding_rows)
        expected_status = ("verified-original-static-internal-source-domain-v1"
                           if expanded else "verified-unsharded-source-domain-v1")
        if coverage_pair != (expected_status, True):
            raise ValueError("II23 coverage label differs from the proved macro/static-internal domain")
    cost_entries = costs.get("entries")
    if not isinstance(cost_entries, list):
        raise ValueError("cost catalog entries must be an array")
    cost_by_task: dict[str, dict[str, Any]] = {}
    if profile_binding.get("model_namespace") == direct_namespace:
        if len(cost_entries) != len(binding_rows) * len(EXPECTED_SHAPES):
            raise ValueError("direct cost catalog does not cover every task/shape pair")
        costs_by_task_shape: dict[str, dict[tuple[int, int], dict[str, Any]]] = {}
        for entry in cost_entries:
            if not isinstance(entry, dict):
                raise ValueError("cost catalog entry must be an object")
            name = require_string(entry.get("task"), "cost entry task")
            if diagnostic_ii_ceiling == 23:
                validate_diagnostic_direct_row(entry, name)
            tile_rows = require_int(entry.get("mapper_tile_rows"), f"{name}.mapper_tile_rows", 1)
            tile_cols = require_int(entry.get("mapper_tile_cols"), f"{name}.mapper_tile_cols", 1)
            if tile_rows % 2 or tile_cols % 2:
                raise ValueError(f"{name}: direct per-CGRA mapper tile dimensions are not multiples of 2x2")
            physical_shape = (tile_rows // 2, tile_cols // 2)
            if f"{physical_shape[0]}x{physical_shape[1]}" not in EXPECTED_SHAPES:
                raise ValueError(f"{name}: direct cost row has an unsupported physical-CGRA shape")
            shape_rows = costs_by_task_shape.setdefault(name, {})
            if physical_shape in shape_rows:
                raise ValueError(f"{name}: direct catalog duplicates physical shape {physical_shape}")
            shape_rows[physical_shape] = entry
        expected_shapes = {tuple(map(int, shape.split("x"))) for shape in EXPECTED_SHAPES}
        for name, binding in binding_rows.items():
            selected_shape = require_string(binding.get("selected_cgra_shape"), f"{name}.selected_cgra_shape")
            rows, cols = shape_dims(selected_shape, f"{name}.selected_cgra_shape")
            direct_predictions = binding.get("direct_shape_predictions")
            if not isinstance(direct_predictions, list) or len(direct_predictions) != len(EXPECTED_SHAPES):
                raise ValueError(f"{name}: direct model binding omits full eight-shape predictions")
            prediction_shapes = {
                (require_int(row.get("cgra_rows"), f"{name}.prediction.rows", 1),
                 require_int(row.get("cgra_cols"), f"{name}.prediction.cols", 1))
                for row in direct_predictions if isinstance(row, dict)
            }
            if len(prediction_shapes) != len(EXPECTED_SHAPES) or prediction_shapes != expected_shapes:
                raise ValueError(f"{name}: direct model predictions do not cover all eight physical shapes")
            rows_by_shape = costs_by_task_shape.get(name, {})
            if set(rows_by_shape) != expected_shapes:
                raise ValueError(f"{name}: direct cost rows do not cover all eight physical shapes")
            selected_entry = rows_by_shape.get((rows, cols))
            if selected_entry is None:
                raise ValueError(f"{name}: selected source shape has no direct cost row")
            matching_prediction = next(
                row for row in direct_predictions
                if row.get("cgra_rows") == rows and row.get("cgra_cols") == cols
            )
            member_predictions = matching_prediction.get("direct_ensemble_members")
            if not isinstance(member_predictions, list) or len(member_predictions) != 4:
                raise ValueError(f"{name}: selected direct prediction omits four member outputs")
            member_values = []
            for member in member_predictions:
                value = member.get("predicted_ii") if isinstance(member, dict) else None
                if type(value) not in (int, float) or not math.isfinite(value):
                    raise ValueError(f"{name}: selected direct member output is malformed")
                member_values.append(float(value))
            member_mean = math.fsum(member_values) / 4.0
            if (
                selected_entry.get("mapper_tile_rows") != matching_prediction.get("mapper_tile_rows")
                or selected_entry.get("mapper_tile_cols") != matching_prediction.get("mapper_tile_cols")
                or not math.isclose(float(selected_entry.get("predicted_ii")), member_mean, rel_tol=0.0, abs_tol=1e-5)
                or selected_entry.get("predicted_ii_std") != matching_prediction.get("predicted_ii_std")
                or selected_entry.get("support_status") != matching_prediction.get("support_status")
                or selected_entry.get("startup_cycles") != matching_prediction.get("startup_cycles")
            ):
                raise ValueError(f"{name}: selected direct cost row differs from its four-member model prediction")
            cost_by_task[name] = selected_entry
    else:
        for entry in cost_entries:
            if not isinstance(entry, dict):
                raise ValueError("cost catalog entry must be an object")
            name = require_string(entry.get("task"), "cost entry task")
            if name in cost_by_task:
                raise ValueError(f"cost catalog duplicates task {name}")
            cost_by_task[name] = entry
    profile_bindings = task_map(trace.get("task_profile_bindings"), "fixed trace profile bindings")
    original_decisions = task_map(result.get("original_decisions"), "original decisions")
    root_costs = task_map(result.get("task_costs"), "retimed task costs")
    if any(set(rows) != task_names for rows in (body_rows, profile_rows, binding_rows, cost_by_task, profile_bindings, original_decisions, root_costs)):
        raise ValueError("body/profile/cost/decision evidence does not cover exactly the original tasks")
    if body_proof.get("task_count") != len(task_names):
        raise ValueError("static body proof task count differs from the current task inventory")
    joined_parent_profiles_by_shape: dict[str, dict[str, dict[str, Any]]] | None = None
    if "candidate_attempts" in profiles:
        _, _, joined_parent_profiles_by_shape = _validate_joined_profile_attempts(
            profiles, task_names, "original profile file")
    else:
        # Older II20 artifacts predate the explicit attempt inventory. Keep
        # that fully materialized format readable, but do not admit it for the
        # diagnostic II23 path where sparse failures need attempt evidence.
        profile_row_count = sum(len(row.get("profiles", [])) for row in profile_rows.values()
                                if isinstance(row.get("profiles"), list))
        if (diagnostic_ii_ceiling != 20
                or profiles.get("task_count") != len(task_names)
                or profiles.get("expected_candidate_count") != len(task_names) * len(EXPECTED_SHAPES)
                or profiles.get("completed_candidate_count") != profile_row_count
                or profile_row_count != len(task_names) * len(EXPECTED_SHAPES)):
            raise ValueError("original profile coverage requires complete legacy II20 rows or joined attempts")
    schedule_rows = task_map(trace.get("task_schedule"), "fixed trace schedule")
    root_schedule_rows = task_map(result.get("task_schedule"), "retimed task schedule")
    if set(schedule_rows) != task_names or set(root_schedule_rows) != task_names:
        raise ValueError("fixed trace schedule does not cover exactly the original tasks")
    output_dispatch = source_dispatch
    if production_scheduler_mode:
        output_dispatch = production_scheduler_decisions["dispatch_order"]
        if set(output_dispatch) != task_names or len(output_dispatch) != len(task_names):
            raise ValueError("production-scheduler dispatch does not cover exactly the original tasks")
    elif result.get("dispatch_order") != source_dispatch or trace.get("dispatch_order") != source_dispatch:
        raise ValueError("retimed dispatch order differs from original dispatch")

    legal_profile_shapes = EXPECTED_SHAPES
    schedule_intervals: dict[str, tuple[int, int]] = {}
    task_cells: dict[str, set[tuple[int, int]]] = {}
    occupancy: dict[tuple[int, int], list[tuple[int, int, str]]] = {}
    context_uses: dict[tuple[int, int], list[tuple[int, int, str]]] = {}
    expected_decision_keys = {"selected_profile_shape", "actual_placed_shape", "actual_placed_row", "actual_placed_col", "active_replicas", "selected_cgra_count", "dispatch_index", "actual_cells", "context_ids", "original_scheduler_start_internal", "original_scheduler_end_internal", "original_scheduler_duration_internal", "original_profile_duration_cycles"}

    for dispatch_index, name in enumerate(source_dispatch):
        source = source_rows[name]
        original = original_decisions[name]
        decision = source.get("dispatch_index")
        selected_shape = require_string(source.get("composed_cgra_shape"), f"{name}.selected_shape")
        selected_rows, selected_cols = shape_dims(selected_shape, f"{name}.selected_shape")
        selected_count = require_int(source.get("composed_cgra_count"), f"{name}.selected_count", 1)
        source_active_replicas = require_int(source.get("active_replicas"),
                                            f"{name}.active_replicas", 1)
        placements = source.get("placements")
        replica_shapes = source.get("replica_shapes")
        if (decision != dispatch_index or selected_count != selected_rows * selected_cols
                or (source_active_replicas != 1 and not explicit_f45_replica_mode)):
            raise ValueError(f"{name}: original scheduler dispatch/shape metadata is invalid")
        if (not isinstance(placements, list) or not placements
                or not isinstance(replica_shapes, list) or not replica_shapes
                or (not explicit_f45_replica_mode and len(replica_shapes) != 1)):
            raise ValueError(f"{name}: original scheduler cell/shape inventory is incomplete")
        if original.get("task") != name or not expected_decision_keys.issubset(original):
            raise ValueError(f"{name}: retimer omitted original decision evidence")
        actual_replicas: list[dict[str, Any]] | None = None
        if explicit_f45_replica_mode:
            actual_replicas = _original_replica_geometry(
                source, original, name, allow_omitted_singleton_replicas=True)
            primary_replica = actual_replicas[0]
            actual_shape = primary_replica["shape"]
            actual_rows, actual_cols = primary_replica["rows"], primary_replica["cols"]
            source_cells, _ = _cells_by_replica(source, name)
            primary_cells = primary_replica["actual_cells"]
            row_set = {cell["row"] for cell in primary_cells}
            col_set = {cell["col"] for cell in primary_cells}
        else:
            actual_shape = require_string(replica_shapes[0].get("shape"), f"{name}.actual_shape")
            actual_rows, actual_cols = shape_dims(actual_shape, f"{name}.actual_shape")
            if actual_rows * actual_cols != selected_count or (actual_rows, actual_cols) not in ((selected_rows, selected_cols), (selected_cols, selected_rows)):
                raise ValueError(f"{name}: actual orientation does not preserve selected area")
            source_cells = []
        source_cell_times = []
        for cell in placements:
            if not isinstance(cell, dict):
                raise ValueError(f"{name}: malformed original scheduler cell")
            if not explicit_f45_replica_mode:
                source_cells.append({"row": require_int(cell.get("row"), f"{name}.cell.row", 0),
                                     "col": require_int(cell.get("col"), f"{name}.cell.col", 0),
                                     "replica_id": require_int(cell.get("replica_id"), f"{name}.cell.replica", 0),
                                     "context_id": require_int(cell.get("context_id"), f"{name}.cell.context", 0)})
            source_cell_times.append((require_int(cell.get("scheduler_start_time"), f"{name}.cell.start", 0),
                                      require_int(cell.get("scheduler_end_time"), f"{name}.cell.end", 1),
                                      require_int(cell.get("scheduler_duration"), f"{name}.cell.duration", 1)))
        if not explicit_f45_replica_mode:
            if len(source_cells) != actual_rows * actual_cols or len({(c["row"], c["col"]) for c in source_cells}) != len(source_cells) or any(cell["replica_id"] != 0 for cell in source_cells):
                raise ValueError(f"{name}: original occupied cells do not fill the selected shape")
            source_cells.sort(key=lambda cell: (cell["row"], cell["col"]))
            row_set = {cell["row"] for cell in source_cells}
            col_set = {cell["col"] for cell in source_cells}
            if {(cell["row"], cell["col"]) for cell in source_cells} != {(row, col) for row in row_set for col in col_set}:
                raise ValueError(f"{name}: original occupied cells are not rectangular")
            replica_shape = replica_shapes[0]
            if (replica_shape.get("row"), replica_shape.get("col"), replica_shape.get("placement_rows"), replica_shape.get("placement_cols")) != (min(row_set), min(col_set), actual_rows, actual_cols):
                raise ValueError(f"{name}: original replica shape differs from its occupied cells")
        if len(set(source_cell_times)) != 1:
            raise ValueError(f"{name}: original cell scheduler intervals disagree")
        original_start, original_end, original_duration = source_cell_times[0]
        if source.get("scheduler_start_time") != original_start or source.get("scheduler_end_time") != original_end or original_end - original_start != original_duration:
            raise ValueError(f"{name}: original scheduler interval is inconsistent")
        expected_decision = {
            "task": name,
            "selected_profile_shape": selected_shape,
            "actual_placed_shape": actual_shape,
            "actual_placed_row": min(row_set),
            "actual_placed_col": min(col_set),
            "active_replicas": source_active_replicas,
            "selected_cgra_count": selected_count,
            "dispatch_index": dispatch_index,
            "actual_cells": source_cells,
            "context_ids": [cell["context_id"] for cell in source_cells],
            "original_scheduler_start_internal": original_start,
            "original_scheduler_end_internal": original_end,
            "original_scheduler_duration_internal": original_duration,
        }
        if explicit_f45_replica_mode and source_active_replicas > 1:
            expected_decision["replicas"] = actual_replicas
        if expected_decision["original_scheduler_end_internal"] - expected_decision["original_scheduler_start_internal"] != expected_decision["original_scheduler_duration_internal"]:
            raise ValueError(f"{name}: original scheduler interval is inconsistent")

        body = body_rows[name]
        body_binding = binding_rows[name]
        profile_binding_row = profile_bindings[name]
        profile_task = profile_rows[name]
        if body.get("task") != name or body_binding.get("task") != name or profile_binding_row.get("task") != name:
            raise ValueError(f"{name}: body/profile task identities disagree")
        trip = require_int(body.get("static_trip_count"), f"{name}.static_trip_count", 1)
        if joined_parent_profiles_by_shape is not None:
            by_shape = joined_parent_profiles_by_shape[name]
        else:
            profile_list = profile_task.get("profiles")
            if not isinstance(profile_list, list):
                raise ValueError(f"{name}: profile list is missing")
            by_shape: dict[str, dict[str, Any]] = {}
            for profile in profile_list:
                if not isinstance(profile, dict):
                    raise ValueError(f"{name}: profile row is malformed")
                shape = require_string(profile.get("composed_cgra_shape"), f"{name}.profile.shape")
                shape_rows, shape_cols = shape_dims(shape, f"{name}.profile.{shape}")
                if shape not in legal_profile_shapes or shape in by_shape or profile.get("composed_cgra_count") != shape_rows * shape_cols or type(profile.get("mapper_succeeded")) is not bool:
                    raise ValueError(f"{name}: profile shape coverage or success field is invalid")
                by_shape[shape] = profile
                if profile["mapper_succeeded"]:
                    for key in ("compiled_ii", "steps", "sample_trip_count", "materialized_operation_count", "estimated_latency"):
                        require_int(profile.get(key), f"{name}.{shape}.{key}", 1)
            if set(by_shape) != legal_profile_shapes:
                raise ValueError(f"{name}: original mapper profiles do not cover every legal <=4-CGRA rectangle")
        selected = by_shape.get(selected_shape)
        if not selected or selected.get("mapper_succeeded") is not True:
            raise ValueError(f"{name}: selected original profile is missing or failed")
        compiled_ii = require_int(selected.get("compiled_ii"), f"{name}.compiled_ii", 1)
        if compiled_ii > diagnostic_ii_ceiling:
            raise ValueError(f"{name}: mapper II exceeds the runtime control-memory ceiling")
        steps = require_int(selected.get("steps"), f"{name}.steps", 1)
        sample_trip = require_int(selected.get("sample_trip_count"), f"{name}.sample_trip_count", 1)
        materialized = require_int(selected.get("materialized_operation_count"), f"{name}.materialized_operation_count", 1)
        profile_cycles = require_int(selected.get("estimated_latency"), f"{name}.estimated_latency", 1)
        f45_profile_duration = (
            (profile_cycles + source_active_replicas - 1) // source_active_replicas
            if explicit_f45_replica_mode else profile_cycles
        )
        if (sample_trip != trip or profile_cycles != compiled_ii * (trip - 1) + steps
                or source.get("duration") != f45_profile_duration
                or source.get("duration_unit") != "profiled-cycles"):
            raise ValueError(f"{name}: selected profile sample trip/latency differs from static body proof")
        if body_binding.get("static_trip_count") != trip or body_binding.get("selected_cgra_shape") != selected_shape or body_binding.get("selected_cgra_count") != selected_count:
            raise ValueError(f"{name}: cost-catalog selection differs from original shape/trip")
        for key in ("task_signature", "counter_signature", "kernel_binding_signature", "normalized_mapper_body"):
            if not isinstance(body.get(key), str) or body_binding.get(key) != body.get(key) or profile_binding_row.get(key) != body.get(key):
                raise ValueError(f"{name}: exact exported mapper body binding differs for {key}")
        if body_binding.get("compiled_ii") != compiled_ii or body_binding.get("steps") != steps or body_binding.get("sample_trip_count") != trip or body_binding.get("materialized_operation_count") != materialized or body_binding.get("estimated_latency") != profile_cycles or body_binding.get("mapper_succeeded") is not True:
            raise ValueError(f"{name}: cost-catalog actual profile evidence differs")
        if profile_binding_row.get("static_trip_count") != trip or profile_binding_row.get("compiled_ii") != compiled_ii or profile_binding_row.get("steps") != steps or profile_binding_row.get("sample_trip_count") != trip or profile_binding_row.get("materialized_operation_count") != materialized or profile_binding_row.get("profile_duration_cycles") != f45_profile_duration or profile_binding_row.get("mapper_succeeded") is not True or profile_binding_row.get("current_ir_body_equivalence_verified") is not True:
            raise ValueError(f"{name}: retimed actual profile/body binding differs")
        if profile_binding_row.get("selected_profile_shape") != selected_shape or profile_binding_row.get("selected_cgra_count") != selected_count:
            raise ValueError(f"{name}: trace selected shape differs from source decision")
        expected_decision["original_profile_duration_cycles"] = f45_profile_duration
        if explicit_f45_replica_mode and source_active_replicas > 1:
            duration_binding = original.get("original_profile_duration_binding")
            if not isinstance(duration_binding, dict):
                raise ValueError(f"{name}: original F45 duration certificate is missing")
            for key in ("full_parent_mapper_duration_cycles", "f45_scheduler_duration_cycles",
                        "active_replicas", "compiled_ii", "sample_trip_count", "steps",
                        "materialized_operation_count"):
                require_int(duration_binding.get(key), f"{name}.duration_binding.{key}", 1)
            expected_decision["original_profile_duration_binding"] = {
                "schema": "amoeba-original-f45-profile-duration-binding-v1",
                "full_parent_mapper_duration_cycles": profile_cycles,
                "f45_scheduler_duration_cycles": f45_profile_duration,
                "active_replicas": source_active_replicas,
                "compiled_ii": compiled_ii,
                "sample_trip_count": sample_trip,
                "steps": steps,
                "materialized_operation_count": materialized,
                "rounding_rule": "ceil-full-parent-duration-over-original-active-replicas-v1",
                "status": "verified",
            }
        if original != expected_decision:
            raise ValueError(f"{name}: retimer did not preserve exact original decisions")

        cost = cost_by_task[name]
        mapped_cost = root_costs[name]
        if cost.get("support_status") != "supported" or cost.get("mapper_tile_rows") != body_binding.get("mapper_tile_rows") or cost.get("mapper_tile_cols") != body_binding.get("mapper_tile_cols"):
            raise ValueError(f"{name}: selected shape has no matching supported cost entry")
        startup = cost.get("startup_cycles")
        if type(startup) not in (int, float) or not math.isfinite(startup) or startup <= 0:
            raise ValueError(f"{name}: selected startup cost is invalid")
        full_parent_mapped_duration = math.ceil(startup + compiled_ii * (trip - 1))
        duration = (
            (full_parent_mapped_duration + source_active_replicas - 1) // source_active_replicas
            if explicit_f45_replica_mode else full_parent_mapped_duration
        )
        if (mapped_cost.get("task") != name or mapped_cost.get("trip_count") != trip or mapped_cost.get("profile_compiled_ii") != compiled_ii or mapped_cost.get("profile_steps") != steps or mapped_cost.get("profile_sample_trip_count") != trip or mapped_cost.get("profile_materialized_operation_count") != materialized or mapped_cost.get("original_profile_duration_cycles") != f45_profile_duration or mapped_cost.get("catalog_startup_cycles") != startup or mapped_cost.get("mapped_duration_cycles") != duration or profile_binding_row.get("catalog_startup_cycles") != startup or profile_binding_row.get("mapped_duration_cycles") != duration):
            raise ValueError(f"{name}: actual compiled-II/startup duration binding differs")
        if explicit_f45_replica_mode:
            for label, row in (("cost", mapped_cost), ("profile binding", profile_binding_row)):
                if (require_int(row.get("full_parent_mapped_duration_cycles"),
                                f"{name}.{label}.full_parent_mapped_duration_cycles", 1)
                        != full_parent_mapped_duration
                        or require_int(row.get("original_active_replicas"),
                                       f"{name}.{label}.original_active_replicas", 1)
                        != source_active_replicas
                        or row.get("replica_duration_rule")
                        != F45_REPLICA_TIMING_POLICY["replica_duration_rule"]):
                    raise ValueError(f"{name}: explicit F45 replica duration fields differ")
        elif any(key in row for row in (mapped_cost, profile_binding_row)
                 for key in ("full_parent_mapped_duration_cycles",
                             "original_active_replicas", "replica_duration_rule")):
            raise ValueError(f"{name}: F45 replica timing fields require the explicit policy")

        schedule = schedule_rows[name]
        root_schedule = root_schedule_rows[name]
        start = require_int(schedule.get("start_cycle"), f"{name}.start_cycle", 0)
        end = require_int(schedule.get("end_cycle"), f"{name}.end_cycle", 1)
        rows = require_int(schedule.get("rows"), f"{name}.rows", 1)
        cols = require_int(schedule.get("cols"), f"{name}.cols", 1)
        row = require_int(schedule.get("row"), f"{name}.row", 0)
        col = require_int(schedule.get("col"), f"{name}.col", 0)
        if end - start != duration or schedule.get("duration_cycles") != duration:
            raise ValueError(f"{name}: retimed schedule duration differs from the mapped duration")
        scheduled_cells = schedule.get("occupied_cells")
        if root_schedule != schedule:
            raise ValueError(f"{name}: result and fixed trace schedules differ")
        if production_scheduler_mode:
            cells_for_schedule = _validate_production_scheduler_task_cells(
                schedule, name, selected_rows, selected_cols, selected_count,
                source_active_replicas)
            output_cell_coords = {(cell["row"], cell["col"])
                                  for cell in cells_for_schedule}
            if len(output_cell_coords) != len(cells_for_schedule):
                raise ValueError(f"{name}: production schedule repeats an occupied cell")
            for cell in cells_for_schedule:
                context_uses.setdefault((cell["row"], cell["col"]), []).append(
                    (cell["context_id"], start, name))
            cells = output_cell_coords
        else:
            if (rows != actual_rows or cols != actual_cols
                    or row != min(row_set) or col != min(col_set)):
                raise ValueError(f"{name}: retimed schedule changes fixed geometry")
            if scheduled_cells != source_cells:
                raise ValueError(f"{name}: fixed trace schedule cells differ from original baseline")
            if row + rows > 4 or col + cols > 4:
                raise ValueError(f"{name}: retimed rectangle is outside 4x4 fabric")
            cells = {(cell["row"], cell["col"]) for cell in source_cells}
        schedule_intervals[name] = (start, end)
        task_cells[name] = cells
        for cell in cells:
            occupancy.setdefault(cell, []).append((start, end, name))

    if production_scheduler_mode:
        dispatch_index_by_task = {name: index for index, name in enumerate(output_dispatch)}
        for cell, uses in context_uses.items():
            if len(uses) > MAX_CONTEXTS_PER_CGRA:
                raise ValueError(f"production scheduler exceeds six contexts on CGRA {cell}")
            contexts = [context_id for context_id, _, _ in uses]
            if len(set(contexts)) != len(contexts):
                raise ValueError(f"production scheduler reuses a context on CGRA {cell}")
            ordered = sorted(uses, key=lambda item: (
                item[1], dispatch_index_by_task[item[2]]))
            if [item[0] for item in ordered] != list(range(len(ordered))):
                raise ValueError(f"production scheduler context ids are not coherent on CGRA {cell}")

    if max(end for _, end in schedule_intervals.values()) != result.get("mapped_whole_program_cycles") or result.get("predicted_whole_program_cycles") != result.get("mapped_whole_program_cycles"):
        raise ValueError("retimed makespan differs from task intervals")
    for intervals in occupancy.values():
        ordered = sorted(intervals)
        if any(left[1] > right[0] for left, right in zip(ordered, ordered[1:])):
            raise ValueError("two tasks overlap on an occupied CGRA")

    dependencies = trace.get("dependencies")
    routes = trace.get("routes")
    if not isinstance(dependencies, list) or not isinstance(routes, list):
        raise ValueError("fixed trace lacks typed dependencies or routes")
    edge_ids: set[int] = set()
    data_edges_by_pair: dict[tuple[str, str], list[dict[str, Any]]] = {}
    predecessor_pairs: set[tuple[str, str]] = set()
    for edge in dependencies:
        if not isinstance(edge, dict):
            raise ValueError("typed dependency is malformed")
        edge_id = require_int(edge.get("edge_index"), "dependency.edge_index", 0)
        producer, consumer = require_string(edge.get("producer"), "dependency.producer"), require_string(edge.get("consumer"), "dependency.consumer")
        kind = require_string(edge.get("kind"), "dependency.kind")
        origin = require_string(edge.get("origin"), "dependency.origin")
        scope = require_string(edge.get("scope"), "dependency.scope")
        if edge.get("edge_id") != f"edge-{edge_id}" or edge_id in edge_ids or producer not in task_names or consumer not in task_names or producer == consumer:
            raise ValueError("typed dependency has duplicate ID or invalid endpoints")
        edge_ids.add(edge_id)
        if kind not in ("value", "raw", "war", "waw", "control") or origin not in ("taskflow", "memory_order", "control") or scope not in ("tensor_wide", "tile_local"):
            raise ValueError("typed dependency semantic identity is invalid")
        if edge.get("producer_segment") not in ("none", "done_reads", "done_writes", "value_outputs") or edge.get("consumer_segment") not in ("will_reads", "will_writes", "value_inputs", "control"):
            raise ValueError("typed dependency segment identity is invalid")
        require_int(edge.get("producer_index"), "dependency.producer_index", 0)
        require_int(edge.get("consumer_index"), "dependency.consumer_index", 0)
        lower, upper = edge.get("transfer_region_lower"), edge.get("transfer_region_upper")
        if not isinstance(lower, list) or not isinstance(upper, list) or len(lower) != len(upper) or any(type(value) is not int for value in lower + upper):
            raise ValueError("typed dependency transfer region is malformed")
        if edge.get("payload_known") is not (type(edge.get("payload_bits")) is int):
            raise ValueError("typed dependency payload-known bit disagrees with payload")
        payload = edge.get("payload_bits")
        if payload is not None and (type(payload) is not int or payload < 0):
            raise ValueError("typed dependency payload is invalid")
        if schedule_intervals[producer][1] > schedule_intervals[consumer][0]:
            raise ValueError(f"dependency {producer}->{consumer} violates predecessor readiness")
        predecessor_pairs.add((producer, consumer))
        if kind in ("value", "raw"):
            if payload is None:
                raise ValueError("data dependency has an unknown payload")
            data_edges_by_pair.setdefault((producer, consumer), []).append(edge)
    if edge_ids != set(range(len(dependencies))):
        raise ValueError("typed dependency IDs are not a contiguous source-edge inventory")
    dispatch_index = {name: index for index, name in enumerate(output_dispatch)}
    if any(dispatch_index[producer] >= dispatch_index[consumer] for producer, consumer in predecessor_pairs):
        raise ValueError("original dispatch order is not predecessor-ready")
    if result.get("replayed_communication_edges") != len(predecessor_pairs):
        raise ValueError("retimer predecessor-pair count differs from typed dependency graph")

    route_pairs: set[tuple[str, str]] = set()
    route_ready: dict[tuple[str, str], int] = {}
    resource_intervals: dict[tuple[Any, ...], list[tuple[int, int]]] = {}
    for route in routes:
        if not isinstance(route, dict):
            raise ValueError("route record is malformed")
        producer, consumer = require_string(route.get("producer"), "route.producer"), require_string(route.get("consumer"), "route.consumer")
        pair = (producer, consumer)
        if route.get("route_id") != f"{producer}->{consumer}" or pair in route_pairs or pair not in data_edges_by_pair:
            raise ValueError("route is duplicated or has no data dependency")
        route_pairs.add(pair)
        route_ready[pair] = require_int(route.get("ready_cycle"), "route.ready_cycle", 0)
        edges = data_edges_by_pair[pair]
        payload = sum(edge["payload_bits"] for edge in edges)
        if payload <= 0 or route.get("payload_bits") != payload or route.get("edge_indices") != [edge["edge_index"] for edge in edges]:
            raise ValueError("route payload or edge aggregation differs from typed data edges")
        source = (require_int(route.get("source_row"), "route.source_row", 0), require_int(route.get("source_col"), "route.source_col", 0))
        destination = (require_int(route.get("destination_row"), "route.destination_row", 0), require_int(route.get("destination_col"), "route.destination_col", 0))
        if source not in task_cells[producer] or destination not in task_cells[consumer]:
            raise ValueError("route endpoint does not belong to fixed task cells")
        start = require_int(route.get("start_cycle"), "route.start_cycle", 0)
        ready = require_int(route.get("ready_cycle"), "route.ready_cycle", 0)
        transfer_cycles = require_int(route.get("transfer_cycles"), "route.transfer_cycles", 1)
        latency = require_int(route.get("path_latency_cycles"), "route.path_latency_cycles", 0)
        bandwidth = require_int(route.get("bottleneck_bandwidth_bits_per_cycle"), "route.bandwidth", 1)
        if route.get("producer_finish_cycle") != schedule_intervals[producer][1] or route.get("consumer_start_cycle") != schedule_intervals[consumer][0] or start < schedule_intervals[producer][1] or ready > schedule_intervals[consumer][0] or ready != start + transfer_cycles:
            raise ValueError("route producer/start/arrival intervals are inconsistent")
        intervals = route.get("intervals")
        if not isinstance(intervals, list) or not intervals:
            raise ValueError("positive-payload route has no resource intervals")
        if source == destination:
            expected_cycles = (payload + architecture["local_bandwidth_bits_per_cycle"] - 1) // architecture["local_bandwidth_bits_per_cycle"]
            if latency != 0 or bandwidth != architecture["local_bandwidth_bits_per_cycle"] or transfer_cycles != expected_cycles or len(intervals) != 1:
                raise ValueError("local-channel payload/bandwidth/latency contract is invalid")
            interval = intervals[0]
            if interval.get("resource_kind") != "local_channel" or (interval.get("row"), interval.get("col")) != source:
                raise ValueError("local route interval names the wrong channel")
            resource = ("local_channel", source[0], source[1])
        else:
            indices = [require_int(item.get("link_index"), "route interval link index", 0) for item in intervals if isinstance(item, dict) and item.get("resource_kind") == "network_link"]
            if len(indices) != len(intervals):
                raise ValueError("remote route contains a non-link resource")
            current = source
            path_latency = 0
            path_bandwidth: int | None = None
            visited = {current}
            for index in indices:
                if index >= len(network_links):
                    raise ValueError("route references an unknown network link")
                link = network_links[index]
                link_source = (link["source_row"], link["source_col"])
                link_destination = (link["destination_row"], link["destination_col"])
                if link_source != current or link_destination in visited:
                    raise ValueError("route link path is discontinuous or cyclic")
                current = link_destination
                visited.add(current)
                path_latency += link["latency_cycles"]
                path_bandwidth = link["bandwidth_bits_per_cycle"] if path_bandwidth is None else min(path_bandwidth, link["bandwidth_bits_per_cycle"])
            if current != destination or path_bandwidth is None:
                raise ValueError("route path does not reach destination")
            expected_cycles = path_latency + (payload + path_bandwidth - 1) // path_bandwidth
            if latency != path_latency or bandwidth != path_bandwidth or transfer_cycles != expected_cycles:
                raise ValueError("route payload/bandwidth/latency does not match its links")
            resource = None
        for interval in intervals:
            begin = require_int(interval.get("start_cycle"), "route interval start", 0)
            end = require_int(interval.get("end_cycle"), "route interval end", 1)
            if (begin, end) != (start, ready):
                raise ValueError("route resource interval differs from route arrival interval")
            if interval.get("resource_kind") == "network_link":
                resource = ("network_link", interval.get("link_index"))
            elif interval.get("resource_kind") == "local_channel":
                resource = ("local_channel", interval.get("row"), interval.get("col"))
            else:
                raise ValueError("unknown route resource kind")
            resource_intervals.setdefault(resource, []).append((begin, end))
    expected_route_pairs = {pair for pair, edges in data_edges_by_pair.items() if sum(edge["payload_bits"] for edge in edges) > 0}
    if route_pairs != expected_route_pairs:
        raise ValueError("positive-payload data edge aggregation and route inventory differ")
    for name in output_dispatch:
        incoming = [pair for pair in predecessor_pairs if pair[1] == name]
        dependency_ready = max(
            (route_ready[pair] if pair in route_ready else schedule_intervals[pair[0]][1] for pair in incoming),
            default=0,
        )
        schedule = schedule_rows[name]
        if schedule_intervals[name][0] < dependency_ready or schedule.get("idle_cycles") != schedule_intervals[name][0] - dependency_ready:
            raise ValueError(f"{name}: task start or idle interval differs from predecessor readiness")
    for resource, intervals in resource_intervals.items():
        ordered = sorted(intervals)
        if any(left[1] > right[0] for left, right in zip(ordered, ordered[1:])):
            raise ValueError(f"network resource intervals overlap on {resource}")

    summary = {
        "schema": "orbit-original-amoeba-fixed-retiming-validation-v1",
        "status": "pass",
        "function": function,
        "graph_variant_id": graph_id,
        "candidate_id": result.get("candidate_id"),
        "task_count": len(task_names),
        "dependency_count": len(dependencies),
        "routed_data_pairs": len(routes),
        "mapped_whole_program_cycles": result.get("mapped_whole_program_cycles"),
        "formal_go": False,
        "iteration_domain_coverage_status": result.get("iteration_domain_coverage_status"),
        "iteration_domain_coverage_verified": result.get("iteration_domain_coverage_verified"),
    }
    if production_scheduler_mode:
        summary["scheduler"] = dict(PRODUCTION_SCHEDULER_POLICY)
        summary["shared_scheduler_resource_only"] = True
    return summary


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--retimed", type=Path, required=True, help="C++ fixed-decision retiming JSON")
    parser.add_argument("--original-mlir", type=Path, required=True, help="original orchestrated MLIR")
    parser.add_argument("--profile-file", type=Path, required=True, help="actual original TaskProfiler profile JSON")
    parser.add_argument("--body-proof", type=Path, required=True, help="exact pre-mapper body export JSON")
    parser.add_argument("--cost-catalog", type=Path, required=True, help="selected-shape cost catalog JSON")
    parser.add_argument("--network-file", type=Path, help="explicit inter-task network YAML for architecture specs that keep network topology separate")
    parser.add_argument("--output", type=Path, help="optional validation-result JSON path")
    parser.add_argument("--diagnostic-ii-ceiling", type=int, choices=(20, 23), default=20)
    parser.add_argument("--source-domain-facts", type=Path,
                        help="fresh C++ source-domain fact report; required for II23")
    parser.add_argument("--replica-profile-evidence", type=Path,
                        help="C++ materialized-child profile evidence manifest")
    parser.add_argument("--materialized-source-facts", type=Path,
                        help="fresh fact-only graph/source report extracted from the materialized module")
    args = parser.parse_args()
    try:
        summary = validate(
            args.original_mlir.read_text(),
            json.loads(args.retimed.read_text()),
            json.loads(args.body_proof.read_text()),
            json.loads(args.profile_file.read_text()),
            json.loads(args.cost_catalog.read_text()),
            args.network_file.read_text() if args.network_file else None,
            args.diagnostic_ii_ceiling,
            json.loads(args.source_domain_facts.read_text()) if args.source_domain_facts else None,
            json.loads(args.replica_profile_evidence.read_text()) if args.replica_profile_evidence else None,
            json.loads(args.materialized_source_facts.read_text()) if args.materialized_source_facts else None,
        )
        encoded = json.dumps(summary, indent=2, sort_keys=True) + "\n"
        if args.output:
            args.output.parent.mkdir(parents=True, exist_ok=True)
            temporary = args.output.with_suffix(args.output.suffix + ".tmp")
            temporary.write_text(encoded)
            temporary.replace(args.output)
        else:
            print(encoded, end="")
        return 0
    except (OSError, json.JSONDecodeError, ValueError) as error:
        print(f"validation failed: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
