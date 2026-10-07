#!/usr/bin/env python3
"""Plan or score a deterministic, source-bound fusion/fission resource panel.

The protocol is deliberately small: one fixed graph transform per case, then
a deterministic round-robin source-shape proposal stream.  Every
score is a fresh R9 C++ search from the exact original canonical input, with
the required target supplied as the only previous-winner seed.  The search
budget is two candidates (canonical identity plus that target), so an invalid
seed stops before ordinary neighborhood expansion.  This launcher never
invokes native mapping or numeric replay.

Run without ``--mode score`` to write commands and compact proposal receipts
without launching the optimizer.  Use ``--continue`` with the same output
root to extend a 64-point prefix to 256; the saved prefix is checked for exact
continuity before any new work is scheduled.
"""
from __future__ import annotations

import argparse
import copy
import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
from typing import Any, Iterable, Mapping, Sequence


SCRIPT = Path(__file__).resolve()
SCRIPT_ROOT = SCRIPT.parents[1]
DEFAULT_RUNTIME = Path(
    "/tmp/orbit-input0-v60-memory-fusion-fission-r5-20261006/runtime-frozen-r6")
DEFAULT_PARENT_ROOT = Path("/tmp/orbit-ff-ablation-diagnosis-r9-20261007")
DEFAULT_CONFIG = DEFAULT_PARENT_ROOT / "workloads.json"
DEFAULT_LEGALITY = DEFAULT_PARENT_ROOT / "legality"
DEFAULT_CACHE_ROOT = Path(
    "/tmp/orbit-input0-v60-memory-fusion-fission-r5-20261006/"
    "cost-cache-original-ray-ii23-r9")
FISSION_STAGE = "full-joint-fission"
FUSION_STAGE = "full-joint"
SEARCH_SCHEMA = "orbit-neighborhood-search-v1"
RESOURCE_SHAPES = ((1, 1), (1, 2), (2, 1), (1, 3), (3, 1),
                   (1, 4), (2, 2), (4, 1))
OBJECTIVE_CAP = 4096

CASES: tuple[dict[str, Any], ...] = (
    {"id": "radar-sibling-4-5", "workload": "radar", "kind": "fusion",
     "legality_dir": "radar-sibling-4-5", "first": "Task_4", "second": "Task_5",
     "mode": "sibling", "fused_task": "Task_4.fuse.Task_5",
     "fixed_parent_shapes": {"Task_4": [1, 1], "Task_5": [1, 1]},
     "fixed_target_shapes": {"Task_4.fuse.Task_5": [1, 2]},
     "evidence_status": "typed-replay-legal"},
    {"id": "radar-pc-16-17", "workload": "radar", "kind": "fusion",
     "legality_dir": "radar-pc-16-17", "first": "Task_16", "second": "Task_17",
     "mode": "producer-consumer-retained", "fused_task": "Task_16.fuse.Task_17",
     "fixed_parent_shapes": {"Task_16": [1, 1], "Task_17": [1, 1]},
     "fixed_target_shapes": {"Task_16.fuse.Task_17": [1, 2]},
     "evidence_status": "typed-replay-legal"},
    {"id": "lu-fission-first", "workload": "lu", "kind": "fission",
     "legality_dir": "lu-fission-first", "task": "Task_0", "left_nodes": [0],
     "fixed_parent_shapes": {"Task_0": [2, 1]},
     "fixed_target_shapes": {"Task_0.split.0": [1, 1], "Task_0.split.1": [1, 1]},
     "evidence_status": "typed-replay-legal"},
    {"id": "harris-fission-first", "workload": "harris", "kind": "fission",
     "legality_dir": "harris-fission-first", "task": "Task_0", "left_nodes": [0],
     "fixed_parent_shapes": {"Task_0": [2, 1]},
     "fixed_target_shapes": {"Task_0.split.0": [1, 1], "Task_0.split.1": [1, 1]},
     "evidence_status": "typed-replay-legal"},
)


class HarnessError(RuntimeError):
    """A source, proposal, cap, or score receipt failed validation."""


def _write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + f".partial-{os.getpid()}")
    try:
        temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n",
                             encoding="utf-8")
        os.replace(temporary, path)
    finally:
        try:
            temporary.unlink()
        except FileNotFoundError:
            pass


def _read_json(path: Path, label: str) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
        raise HarnessError(f"{label} is unreadable: {path}: {error}") from error
    if not isinstance(value, dict):
        raise HarnessError(f"{label} must be an object: {path}")
    return value


def _read_jsonl(path: Path, label: str) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    try:
        for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if not line.strip():
                continue
            row = json.loads(line)
            if not isinstance(row, dict):
                raise HarnessError(f"{label} line {number} is not an object")
            rows.append(row)
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
        raise HarnessError(f"{label} is unreadable: {path}: {error}") from error
    return rows


def _load_module(name: str, path: Path) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise HarnessError(f"cannot dynamically load existing helper: {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def _helpers(runtime_root: Path) -> tuple[Any, Any, Any]:
    """Load both C++ support scripts from the frozen R9 runtime."""
    frozen_scripts = runtime_root / "scripts"
    if str(frozen_scripts) not in sys.path:
        sys.path.insert(0, str(frozen_scripts))
    control = _load_module(
        "r9_resource_controlled_probe_helpers",
        SCRIPT_ROOT / "scripts/run_fusion_fission_controlled_probes.py")
    # Resolve transitive helper imports against the frozen scripts directory.
    nr, replay = control._helpers(runtime_root)
    return control, nr, replay


def _load_workloads(path: Path) -> dict[str, dict[str, Any]]:
    root = _read_json(path, "R9 workload manifest")
    rows = root.get("workloads")
    if not isinstance(rows, list):
        raise HarnessError("R9 workload manifest workloads must be an array")
    result: dict[str, dict[str, Any]] = {}
    for row in rows:
        if not isinstance(row, dict) or not isinstance(row.get("workload"), str):
            raise HarnessError("R9 workload manifest contains a malformed workload")
        name = row["workload"]
        if name in result:
            raise HarnessError(f"R9 workload manifest repeats {name}")
        result[name] = dict(row)
    return result


def _source_rows(facts: Mapping[str, Any], field: str) -> list[dict[str, Any]]:
    rows = facts.get(field)
    if not isinstance(rows, list) or any(not isinstance(row, dict) for row in rows):
        raise HarnessError(f"source facts have no valid {field}")
    return rows


def _history_key(facts_or_row: Mapping[str, Any]) -> str:
    history = facts_or_row.get("action_history")
    if not isinstance(history, Mapping) or history.get("known") is not True:
        raise HarnessError("source record lacks authenticated typed action history")
    compact = {key: history.get(key) for key in
               ("initialShapes", "actions", "fissionActions")}
    return json.dumps(compact, sort_keys=True, separators=(",", ":"))


def _history_projection(history: Mapping[str, Any]) -> dict[str, Any]:
    return {key: history.get(key) for key in
            ("initialShapes", "actions", "fissionActions")}


def _stable_key(value: Any) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"))


def _facts_task_names(facts: Mapping[str, Any]) -> list[str]:
    rows = _source_rows(facts, "selected_shapes")
    names = [str(row.get("task", "")) for row in rows]
    if any(not name for name in names) or len(names) != len(set(names)):
        raise HarnessError("replay facts have duplicate or empty selected task names")
    return names


def _validate_replay_facts(facts: Mapping[str, Any], *, case: Mapping[str, Any],
                           function: str, expected_tasks: Sequence[str],
                           expected_fission: bool) -> None:
    if (facts.get("schema") != "orbit-joint-neighborhood-action-replay-facts-v1" or
            facts.get("status") != "complete" or facts.get("function") != function or
            facts.get("source_iteration_domain_verified") is not True or
            facts.get("native_mapping_run") is not False or
            facts.get("ranking_performed") is not False or
            facts.get("fission_source_replay_verified") is not expected_fission):
        raise HarnessError(f"{case['id']} replay facts do not prove the requested R9-only transform")
    names = _facts_task_names(facts)
    if names != list(expected_tasks):
        raise HarnessError(f"{case['id']} transformed task sequence differs from its frozen proof")
    if facts.get("actions_applied") != len(facts.get("action_path", [])):
        raise HarnessError(f"{case['id']} replay facts have an inconsistent action count")
    history = facts.get("action_history")
    if not isinstance(history, dict) or history.get("known") is not True:
        raise HarnessError(f"{case['id']} replay did not authenticate its typed action history")
def _validate_structural_proof(case: Mapping[str, Any], facts: Mapping[str, Any],
                               structural_actions: Sequence[Mapping[str, Any]]) -> None:
    history = facts.get("action_history", {})
    if case["kind"] == "fusion":
        expected_family = "sibling-fusion" if case["mode"] == "sibling" else "fusion"
        families = [row.get("family") for row in history.get("actions", [])
                    if isinstance(row, dict)]
        if families != [expected_family] or len(structural_actions) != 1:
            raise HarnessError(f"{case['id']} proof is not the frozen one-action fusion")
    else:
        rows = history.get("fissionActions", [])
        if (len(rows) != 1 or rows[0].get("family") != "fission" or
                rows[0].get("primitives", [{}])[0].get("firstTask") != case["task"] or
                rows[0].get("primitives", [{}])[0].get("leftNodes") != case["left_nodes"] or
                len(structural_actions) != 1 or structural_actions[0].get("family") != "fission"):
            raise HarnessError(f"{case['id']} proof is not the frozen source fission cut")


def _shape_menus(cost_catalog: Mapping[str, Any], source_task_ids: Sequence[str],
                 allowed_shapes: Sequence[Sequence[int]] = RESOURCE_SHAPES
                 ) -> dict[str, list[tuple[int, int]]]:
    entries = cost_catalog.get("entries")
    if not isinstance(entries, list):
        raise HarnessError("source model cost catalogue has no entries")
    menus: dict[str, set[tuple[int, int]]] = {task: set() for task in source_task_ids}
    for row in entries:
        if not isinstance(row, dict) or row.get("task") not in menus:
            continue
        if row.get("support_status") != "supported":
            continue
        mapper_rows, mapper_cols = row.get("mapper_tile_rows"), row.get("mapper_tile_cols")
        if (type(mapper_rows) is not int or type(mapper_cols) is not int or
                mapper_rows <= 0 or mapper_cols <= 0 or mapper_rows % 2 or mapper_cols % 2):
            continue
        shape = (mapper_rows // 2, mapper_cols // 2)
        if shape in {tuple(value) for value in allowed_shapes}:
            menus[row["task"]].add(shape)
    result: dict[str, list[tuple[int, int]]] = {}
    for task in source_task_ids:
        values = sorted(menus[task], key=lambda shape: (shape[0] * shape[1], *shape))
        if not values or values[0] != (1, 1):
            raise HarnessError(f"{task} lacks the minimum supported R9 1x1 shape")
        result[task] = values
    return result


def _combinations_round_robin(size: int, width: int) -> Iterable[tuple[int, ...]]:
    """Enumerate coordinate combinations by cyclic span to spread early points."""
    if width == 0:
        yield ()
        return
    if width > size:
        return
    if width == 1:
        for index in range(size):
            yield (index,)
        return
    seen: set[tuple[int, ...]] = set()
    # Increasing cyclic span covers nearby task slots first while each start
    # index takes part before the walk reaches long-range pairs/combinations.
    for span in range(1, size):
        for start in range(size):
            candidate = tuple(sorted((start + offset * span) % size
                                     for offset in range(width)))
            if len(candidate) == width and candidate not in seen:
                seen.add(candidate)
                yield candidate
    if len(seen) < _combination_count(size, width):
        for candidate in __import__("itertools").combinations(range(size), width):
            if candidate not in seen:
                yield candidate


def _combination_count(size: int, width: int) -> int:
    if width < 0 or width > size:
        return 0
    result = 1
    for offset in range(1, width + 1):
        result = result * (size - offset + 1) // offset
    return result


def _rank_vectors(cardinalities: Sequence[int], width: int, rank_sum: int
                  ) -> Iterable[tuple[int, ...]]:
    """Generate nonminimum choice ranks lazily at one BFS resource depth."""
    if width == 0:
        if rank_sum == 0:
            yield ()
        return
    if not cardinalities:
        return
    if width == 1:
        for rank in range(1, cardinalities[0]):
            if rank == rank_sum:
                yield (rank,)
        return
    first_max = cardinalities[0] - 1
    remaining = cardinalities[1:]
    for first in range(1, first_max + 1):
        for tail in _rank_vectors(remaining, width - 1, rank_sum - first):
            yield (first, *tail)


def _resource_walk(free_tasks: Sequence[str], menus: Mapping[str, Sequence[tuple[int, int]]],
                   *, point_count: int) -> Iterable[dict[str, tuple[int, int]]]:
    """Yield minimum first, then round-robin one-task moves, then BFS combinations.

    The generator uses O(number of task slots) working memory. It never
    constructs the full Cartesian product, which is important for Harris.
    """
    task_count = len(free_tasks)
    if task_count == 0:
        return
    minimum = {task: tuple(menus[task][0]) for task in free_tasks}
    yield dict(minimum)
    emitted = 1
    # First vary each task by its first alternative, then the second
    # alternative across all tasks, and so on. Every task is reached before
    # any pairwise resource combination is admitted.
    max_alternatives = max(len(menus[task]) - 1 for task in free_tasks)
    for rank in range(1, max_alternatives + 1):
        for task in free_tasks:
            if rank >= len(menus[task]):
                continue
            state = dict(minimum)
            state[task] = tuple(menus[task][rank])
            yield state
            emitted += 1
            if emitted >= point_count:
                return
    # Breadth-first by the number of changed tasks. For each shape-rank sum,
    # spread a rank tuple across task subsets in cyclic source-task order.
    for width in range(2, task_count + 1):
        rank_caps = [len(menus[task]) for task in free_tasks]
        min_sum, max_sum = width, sum(cap - 1 for cap in rank_caps)
        for rank_sum in range(min_sum, max_sum + 1):
            for subset in _combinations_round_robin(task_count, width):
                caps = [rank_caps[index] for index in subset]
                for ranks in _rank_vectors(caps, width, rank_sum):
                    state = dict(minimum)
                    for index, rank in zip(subset, ranks):
                        state[free_tasks[index]] = tuple(menus[free_tasks[index]][rank])
                    yield state
                    emitted += 1
                    if emitted >= point_count:
                        return


def _case_state_sequence(*, case: Mapping[str, Any], side: str,
                         base_task_ids: Sequence[str], transformed_task_ids: Sequence[str],
                         menus: Mapping[str, Sequence[tuple[int, int]]],
                         point_count: int) -> list[dict[str, Any]]:
    if side not in {"original", "transformed"}:
        raise HarnessError(f"unknown side: {side}")
    tasks = list(base_task_ids if side == "original" else transformed_task_ids)
    if not tasks or len(tasks) != len(set(tasks)):
        raise HarnessError(f"{case['id']} {side} has malformed task IDs")
    default_shapes: dict[str, tuple[int, int]] = {}
    for task in tasks:
        if task not in menus or not menus[task]:
            raise HarnessError(f"no source-bound supported shape menu for {task}")
        default_shapes[task] = tuple(menus[task][0])

    free_tasks = tasks
    states = list(_resource_walk(free_tasks, menus, point_count=point_count))
    if not states:
        raise HarnessError("resource proposal walk produced no points")
    keys = [_stable_key([(task, list(state[task])) for task in tasks]) for state in states]
    if len(keys) != len(set(keys)):
        raise HarnessError(f"{case['id']} {side} proposal walk contains duplicate resource cells")
    for index, state in enumerate(states):
        if any(state[task] not in menus[task] for task in tasks):
            raise HarnessError(f"{case['id']} {side} has a shape outside its exact source menu")
        changed = sum(state[task] != default_shapes[task] for task in tasks)
        if index == 0 and changed != 0:
            raise HarnessError("resource stream does not begin at the minimum supported shape assignment")
    return [{"point": index, "shapes": [
        {"task": task, "rows": state[task][0], "cols": state[task][1]}
        for task in tasks], "shape_map": {task: list(state[task]) for task in tasks}}
            for index, state in enumerate(states)]


def _shape_actions(control: Any, base_shapes: Mapping[str, Sequence[int]],
                   desired_shapes: Mapping[str, Sequence[int]],
                   task_order: Sequence[str]) -> list[dict[str, Any]]:
    actions = []
    for task in task_order:
        base = tuple(base_shapes[task])
        desired = tuple(desired_shapes[task])
        if base != desired:
            actions.append(control.shape_action(task, desired[0], desired[1]))
    return actions


def _actions_for_point(control: Any, case: Mapping[str, Any], side: str,
                       point: Mapping[str, Any], base_facts: Mapping[str, Any],
                       target_facts: Mapping[str, Any], structural_actions: Sequence[Mapping[str, Any]],
                       ) -> list[dict[str, Any]]:
    desired = {row["task"]: (row["rows"], row["cols"])
               for row in point["shapes"]}
    if side == "original":
        canonical_shapes = {row["task"]: (row["rows"], row["cols"])
                            for row in _source_rows(base_facts, "initial_shapes")}
        return _shape_actions(control, canonical_shapes, desired,
                              [row["task"] for row in point["shapes"]])
    structure = [dict(row) for row in structural_actions]
    # selected_shapes reflects the post-transform graph's actual current body
    # names; action_history.initialShapes intentionally remains the original
    # source-authenticated history and may still name the pre-transform parent.
    actual_baseline = {row["task"]: (row["rows"], row["cols"])
                       for row in _source_rows(target_facts, "selected_shapes")}
    return structure + _shape_actions(control, actual_baseline, desired,
                                      [row["task"] for row in point["shapes"]])


def _source_work_summary(facts: Mapping[str, Any], case: Mapping[str, Any],
                         side: str) -> dict[str, Any]:
    tasks = _source_rows(facts, "tasks")
    rows = []
    for row in tasks:
        rows.append({"task": row.get("task"), "complete": row.get("complete"),
                     "source_multiplicity": row.get("source_multiplicity"),
                     "represented_multiplicity": row.get("represented_multiplicity"),
                     "internal_multiplicity": row.get("internal_multiplicity"),
                     "current_source_work_count": row.get("current_source_work_count"),
                     "current_taskflow_firing_count": row.get("current_taskflow_firing_count")})
    semantics: dict[str, Any] = {
        "unit": "C++-authenticated per-task source-domain multiplicity/work witness",
        "per_task": rows,
    }
    if case["kind"] == "fission":
        parent = case["task"]
        children = [parent + ".split.0", parent + ".split.1"]
        semantics["fission_group"] = {
            "parent_task": parent if side == "original" else None,
            "child_tasks": children if side == "transformed" else [],
            "interpretation": (
                "fission children each retain the authenticated parent iteration extent; "
                "their source multiplicities are per-child witnesses and must not be summed "
                "as if they were disjoint invocation counts"),
            "source_replay_verified": facts.get("fission_source_replay_verified") is True,
        }
    return semantics


def _candidate_costs(selection: Mapping[str, Any], source_facts: Mapping[str, Any]
                     ) -> dict[str, Any]:
    score = selection.get("score_record")
    costs = selection.get("task_costs")
    schedule = selection.get("task_schedule")
    if not isinstance(costs, list) and isinstance(score, Mapping):
        costs = score.get("task_costs")
    if not isinstance(schedule, list) and isinstance(score, Mapping):
        schedule = score.get("task_schedule")
    if not isinstance(costs, list) or not isinstance(schedule, list):
        raise HarnessError("R9 selection has no source-owned task costs/schedule")
    source = {row["task"]: row for row in _source_rows(source_facts, "tasks")}
    placements = {row.get("task"): row for row in schedule if isinstance(row, dict)}
    result: dict[str, Any] = {}
    for row in costs:
        if not isinstance(row, dict) or not isinstance(row.get("task"), str):
            raise HarnessError("R9 task cost row is malformed")
        task = row["task"]
        placement = placements.get(task, {})
        domain = source.get(task, {})
        result[task] = {
            "mapper_tile_rows": row.get("mapper_tile_rows"),
            "mapper_tile_cols": row.get("mapper_tile_cols"),
            "cgra_rows": (row.get("mapper_tile_rows") // 2
                          if type(row.get("mapper_tile_rows")) is int else None),
            "cgra_cols": (row.get("mapper_tile_cols") // 2
                          if type(row.get("mapper_tile_cols")) is int else None),
            "predicted_ii": row.get("predicted_ii"),
            "startup_cycles": row.get("startup_cycles"),
            "predicted_duration": row.get("predicted_duration"),
            "schedule": {key: placement.get(key) for key in
                         ("row", "col", "start_cycle", "end_cycle")},
            "source_multiplicity": domain.get("source_multiplicity"),
            "represented_multiplicity": domain.get("represented_multiplicity"),
            "internal_multiplicity": domain.get("internal_multiplicity"),
            "current_source_work_count": domain.get("current_source_work_count"),
        }
    return {"predicted_whole_program_cycles": selection.get(
                "predicted_whole_program_cycles",
                score.get("predicted_whole_program_cycles") if isinstance(score, Mapping) else None),
            "objective": "predicted production scheduler makespan",
            "task_costs_by_body": result}


def _validate_search_receipt(*, nr: Any, search_dir: Path, summary: Mapping[str, Any],
                             canonical_facts: Mapping[str, Any],
                             target_facts: Mapping[str, Any], target_selection: Mapping[str, Any],
                             protocol: Mapping[str, Any], function: str, stage: str,
                             expected_target_shapes: Sequence[Mapping[str, Any]]) -> dict[str, Any]:
    top_path = nr.find_output_file(search_dir, ("top5.jsonl", "global-top5.jsonl"))
    rows = nr.read_jsonl(top_path)
    header = next((row for row in rows if row.get("record_type") == "header"), None)
    footer = next((row for row in reversed(rows) if row.get("record_type") == "footer"), None)
    selections = [row for row in rows if row.get("record_type") == "selection"]
    if not isinstance(header, dict) or not isinstance(footer, dict):
        raise HarnessError("R9 search output lacks its exact v1 header/footer receipt")
    source_pin = str(protocol.get("source_commit", ""))
    repository = str(protocol.get("source_git_repository", ""))
    for label, receipt in (("header", header), ("footer", footer), ("summary", summary)):
        if (receipt.get("schema") != SEARCH_SCHEMA or receipt.get("function") != function or
                receipt.get("stage") != stage or receipt.get("source_commit") != source_pin or
                receipt.get("source_repository") != repository or
                receipt.get("max_rounds") != 1 or receipt.get("max_candidates") != 2 or
                receipt.get("beam_width") != 1 or receipt.get("diversity_slots") != 1 or
                receipt.get("max_partition_factor") != 8):
            raise HarnessError(f"R9 {label} receipt differs from the exact 2-candidate diagnostic protocol")
    if (footer.get("status") != "best-found" or header.get("previous_winner_requested") is not True or
            summary.get("previous_winner_requested") is not True or
            header.get("unique_complete_candidates_scored") != 2 or
            footer.get("unique_complete_candidates_scored") != 2 or
            summary.get("unique_complete_candidates_scored") != 2 or
            len(selections) != 2):
        raise HarnessError("R9 receipt did not score exactly identity plus the required target")
    control_rows = nr.read_jsonl(search_dir / "controls.jsonl")
    controls = {row.get("control_role"): row for row in control_rows}
    if set(controls) != {"identity", "previous_stage_measured_winner"}:
        raise HarnessError("R9 controls do not contain exactly identity and required target")
    original_key = _history_key(canonical_facts)
    target_key = _history_key(target_facts)
    identity = controls["identity"]
    previous = controls["previous_stage_measured_winner"]
    if _history_key(identity) != original_key:
        raise HarnessError("canonical identity history does not match the independently replayed original")
    if _history_key(previous) != target_key:
        raise HarnessError("required target control history differs from the complete target replay")
    expected_shapes_key = _stable_key(list(expected_target_shapes))
    if _stable_key(previous.get("shapes")) != expected_shapes_key:
        raise HarnessError("R9 previous-winner control changed the requested target shapes")
    selection_keys = {_history_key(row) for row in selections}
    if selection_keys != {original_key, target_key}:
        raise HarnessError("R9 archive contains a hidden/ordinary candidate or omits one control")
    if len(_read_jsonl(search_dir / "archive.jsonl", "R9 search archive")) != 2:
        raise HarnessError("R9 archive contains a candidate beyond identity and target")
    if any(row.get("valid") is not True for row in selections):
        raise HarnessError("R9 score archive contains an invalid candidate")
    target_row = next(row for row in selections if _history_key(row) == target_key)
    identity_row = next(row for row in selections if _history_key(row) == original_key)
    if target_row.get("candidate_id") != previous.get("candidate_id"):
        raise HarnessError("target archive row is not the required previous-winner seed")
    if identity_row.get("control_roles") and "identity" not in identity_row["control_roles"]:
        raise HarnessError("identity rank row carries a conflicting control role")
    return {"schema": SEARCH_SCHEMA, "top5": str(top_path),
            "header": header, "footer": footer, "summary": dict(summary),
            "controls": {"identity": identity, "target": previous},
            "identity_selection": identity_row,
            "target_selection": target_row,
            "identity_costs": _candidate_costs(identity, canonical_facts),
            "target_costs": _candidate_costs(target_row, target_facts),
            "scored_candidate_count": 2,
            "ordinary_neighbors_evaluated": 0,
            "archive_candidate_histories": [original_key, target_key]}


def _count_failed_search_scores(search_dir: Path,
                                canonical_facts: Mapping[str, Any],
                                target_facts: Mapping[str, Any]) -> int | None:
    """Count only archived, valid controls after a failed bounded search."""
    archive_path = search_dir / "archive.jsonl"
    if not archive_path.is_file():
        return None
    rows = _read_jsonl(archive_path, "failed bounded search archive")
    identity_key = _history_key(canonical_facts)
    target_key = _history_key(target_facts)
    keys: list[str] = []
    for row in rows:
        if row.get("record_type") not in {"selection", "candidate"} or row.get("valid") is not True:
            return None
        key = _history_key(row)
        if key not in {identity_key, target_key}:
            return None
        keys.append(key)
    if not keys or len(keys) > 2 or len(keys) != len(set(keys)):
        return None
    return len(keys)


def _read_cache_header(template_path: Path) -> dict[str, Any]:
    template = _read_json(template_path, "original R9 cost-cache template")
    if template.get("schema") != "orbit-cgra-ii-ml-cache-v2" or not isinstance(
            template.get("entries"), list):
        raise HarnessError(f"R9 cache template has an unexpected schema: {template_path}")
    result = {key: value for key, value in template.items() if key != "entries"}
    result["entries"] = []
    return result


def _command_record(argv: Sequence[str], *, stdout: Path, stderr: Path) -> dict[str, Any]:
    return {"argv": [str(part) for part in argv], "stdout": str(stdout), "stderr": str(stderr)}


def _make_search_command(*, nr: Any, control: Any, workload: Mapping[str, Any],
                         protocol: Mapping[str, Any], protocol_path: Path,
                         source_contract: Path, cost_cache: Path, output_dir: Path,
                         previous_winner: Path, workload_name: str, stage: str,
                         checkpoint: Path) -> list[str]:
    optimizer = Path(workload["optimizer"])
    canonical = Path(workload["canonical"])
    architecture = Path(workload["architecture"])
    prepared = Path(workload["prepared_source_file"]) if stage == FISSION_STAGE else None
    fission_cap = int(workload["fission_cap"]) if stage == FISSION_STAGE else None
    command = nr.build_search_command(
        optimizer=optimizer, canonical=canonical, output_dir=output_dir,
        function=workload["function"], stage=stage, architecture=architecture,
        protocol=protocol, checkpoint=checkpoint, seed_manifest=None,
        previous_winner=None, parent_cost_file=Path(workload["parent_cost_file"]),
        model_cache=Path(workload["model_cache"]), cost_cache=cost_cache,
        max_rounds=1, max_candidates=2, beam_width=1, diversity_slots=1,
        resume=None, protocol_path=protocol_path, source_contract_file=source_contract,
        workload=workload_name,
        inter_task_network=Path(workload["inter_task_network"]),
        stage_initialization="independent", prepared_source_file=prepared,
        max_fission_actions_per_task=fission_cap)
    key = "--search-joint-neighborhood="
    indices = [index for index, value in enumerate(command) if value.startswith(key)]
    if len(indices) != 1:
        raise HarnessError("frozen R9 neighborhood helper built an ambiguous search command")
    command[indices[0]] += f" previous-winner={previous_winner}"
    control._assert_cxx_path_safe(Path(previous_winner), checkpoint, output_dir, cost_cache)
    if any("seed-manifest=" in part for part in command):
        raise HarnessError("resource harness must not use optional seed-manifest ingestion")
    return command


def _build_previous_winner(*, facts: Mapping[str, Any], case: Mapping[str, Any],
                           point: Mapping[str, Any], candidate_path: Path,
                           workload: Mapping[str, Any], protocol: Mapping[str, Any],
                           output_path: Path) -> dict[str, Any]:
    history = copy.deepcopy(facts["action_history"])
    shapes = copy.deepcopy(list(point["shapes"]))
    row = {
        "schema": SEARCH_SCHEMA,
        "record_type": "selection",
        "candidate_id": f"resource-{case['id']}-{point['point']:03d}",
        "candidate_path": str(candidate_path),
        "function": workload["function"],
        "source_repository": protocol.get("source_git_repository"),
        "source_commit": protocol.get("source_commit"),
        "best_found": True,
        "valid": True,
        "shapes": shapes,
        "action_history": history,
        "action_path": list(facts.get("action_path", [])),
    }
    _write_jsonl(output_path, [row])
    return row


def _write_jsonl(path: Path, rows: Sequence[Mapping[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("".join(json.dumps(row, sort_keys=True) + "\n" for row in rows),
                     encoding="utf-8")


def _atomic_command_run(control: Any, argv: Sequence[str], directory: Path,
                        label: str, cwd: Path) -> dict[str, Any]:
    directory.mkdir(parents=True, exist_ok=True)
    result = control._run_logged(argv, directory, label, cwd)
    return result


def _run_point(*, control: Any, nr: Any, case: Mapping[str, Any], side: str,
               point: Mapping[str, Any], actions: Sequence[Mapping[str, Any]],
               base_facts: Mapping[str, Any], target_proof_facts: Mapping[str, Any],
               canonical_facts: Mapping[str, Any], workload: Mapping[str, Any],
               protocol_data: Mapping[str, Any], protocol_path: Path,
               source_contract: Path, diagnostic_protocol_path: Path,
               diagnostic_protocol: Mapping[str, Any], cost_cache: Path,
               output_dir: Path, runtime_root: Path, execute: bool
               ) -> dict[str, Any]:
    case_dir = output_dir / "points" / f"{point['point']:03d}"
    replay_dir = case_dir / "typed-replay"
    search_dir = case_dir / "search"
    stage = FISSION_STAGE if case["kind"] == "fission" else FUSION_STAGE
    prepared = Path(workload["prepared_source_file"]) if stage == FISSION_STAGE else None
    optimizer = Path(workload["optimizer"])
    architecture = Path(workload["architecture"])
    candidate_path = replay_dir / "replay/candidate.mlir"
    replay_action = {"actions": [dict(row) for row in actions]}
    action_summary = control._action_document(
        Path(workload["canonical"]), workload["function"], stage,
        int(workload["max_partition_factor"]), replay_action["actions"],
        prepared_source=None, fission_cap=None)
    # The fission helper's exact prepared-source bytes are injected only for
    # score mode. Dry-run receipts stay compact and point to the pinned input.
    if prepared is not None:
        action_summary["preparedSourceInput"] = str(prepared)
        action_summary["maxFissionActionsPerTask"] = int(workload["fission_cap"])
    action_file = replay_dir / "actions.json"
    replay_option = (
        f"action-file={action_file} canonical-input={workload['canonical']} "
        f"candidate-input={workload['canonical']} function={workload['function']} "
        f"stage={stage} max-partition-factor={workload['max_partition_factor']} "
        f"output-dir={replay_dir / 'replay'}")
    if prepared is not None:
        replay_option += (f" prepared-source-file={prepared}"
                          f" max-fission-actions-per-task={workload['fission_cap']}")
    replay_command = [str(optimizer), str(workload["canonical"]), "--verify-each",
                      f"--architecture-spec={architecture}",
                      "--replay-joint-neighborhood-actions=" + replay_option,
                      "--mlir-print-op-generic", "-o", "/dev/null"]
    previous_path = case_dir / "required-target.jsonl"
    checkpoint = case_dir / "checkpoint.json"
    search_command = _make_search_command(
        nr=nr, control=control, workload=workload, protocol=diagnostic_protocol,
        protocol_path=diagnostic_protocol_path, source_contract=source_contract,
        cost_cache=cost_cache, output_dir=search_dir,
        previous_winner=previous_path, workload_name=case["workload"],
        stage=stage, checkpoint=checkpoint)
    point_key = _stable_key({"case": case["id"], "side": side,
                             "actions": list(actions), "shapes": point["shapes"]})
    result: dict[str, Any] = {
        "point": point["point"], "proposal_key": point_key,
        "shapes": point["shapes"], "typed_actions": list(actions),
        "action_document_preview": action_summary,
        "typed_replay_command": replay_command,
        "previous_winner_path": str(previous_path),
        "search_command": search_command,
        "score_protocol": str(diagnostic_protocol_path),
        "cost_cache": str(cost_cache),
        "status": "planned" if not execute else "pending",
        "ordinary_neighbors_allowed": False,
        "search_budget": {"max_candidates": 2, "max_rounds": 1,
                          "beam_width": 1, "diversity_slots": 1,
                          "required_previous_winner_only": True},
    }
    if not execute:
        return result

    replay_output = control._direct_replay(
        optimizer=optimizer, architecture=architecture,
        canonical=Path(workload["canonical"]), function=workload["function"],
        stage=stage, output_dir=replay_dir, action=replay_action,
        max_partition_factor=int(workload["max_partition_factor"]),
        artifact_root=runtime_root, prepared_source=prepared,
        fission_cap=int(workload["fission_cap"]) if prepared else None)
    target_facts, replay_receipt = replay_output
    expected_names = [row["task"] for row in point["shapes"]]
    _validate_replay_facts(target_facts, case=case,
                           function=workload["function"], expected_tasks=expected_names,
                           expected_fission=(side == "transformed" and
                                             case["kind"] == "fission"))
    actual_history = _history_projection(target_facts["action_history"])
    if side == "transformed":
        fixed_history = _history_projection(target_proof_facts["action_history"])
        expected_transform_history = {
            "initialShapes": fixed_history["initialShapes"],
            "actions": [*fixed_history["actions"], *[
                action for action in actions if action.get("family") == "shape"]],
            "fissionActions": fixed_history["fissionActions"],
        }
        # R9 replay output is authoritative for task ordering and shape records;
        # this check ensures the one source transform stayed frozen.
        if (actual_history["initialShapes"] != expected_transform_history["initialShapes"] or
                actual_history["fissionActions"] != expected_transform_history["fissionActions"] or
                actual_history["actions"][:len(fixed_history["actions"])] != fixed_history["actions"]):
            raise HarnessError(f"{case['id']} target replay changed the frozen transform history")
    elif actual_history["fissionActions"] or any(
            action.get("family") not in {"shape"} for action in actual_history["actions"]):
        raise HarnessError("original-side target contains a structural transformation")
    elif actual_history["initialShapes"] != _history_projection(
            canonical_facts["action_history"])["initialShapes"]:
        raise HarnessError("original-side target changed the authenticated canonical initial shapes")

    shape_map = {row["task"]: (row["rows"], row["cols"])
                 for row in target_facts.get("selected_shapes", [])}
    requested_map = {row["task"]: (row["rows"], row["cols"])
                     for row in point["shapes"]}
    if shape_map != requested_map:
        raise HarnessError("typed replay did not materialize the full requested shape assignment")
    target_row = {
        "schema": SEARCH_SCHEMA, "record_type": "selection",
        "candidate_id": f"resource-{case['id']}-{point['point']:03d}",
        "candidate_path": str(target_facts["candidate_path"]),
        "function": workload["function"],
        "source_repository": protocol_data.get("source_git_repository"),
        "source_commit": protocol_data.get("source_commit"),
        "best_found": True, "valid": True,
        "shapes": point["shapes"],
        "action_history": target_facts["action_history"],
        "action_path": target_facts["action_path"],
    }
    _write_jsonl(previous_path, [target_row])
    result["replay"] = {"facts_path": str(replay_dir / "replay/source-facts.json"),
                         "candidate_path": target_facts["candidate_path"],
                         "command": replay_receipt,
                         "source_work": _source_work_summary(target_facts, case, side),
                         "history_key": _history_key(target_facts)}
    search_command_receipt = _atomic_command_run(
        control, search_command, case_dir, "diagnostic-search", runtime_root)
    result["search_command_receipt"] = search_command_receipt
    if search_command_receipt.get("exit_code") != 0:
        stderr_path = Path(search_command_receipt["stderr"])
        stderr = stderr_path.read_text(encoding="utf-8", errors="replace") if stderr_path.exists() else ""
        failure = "required-target-seed-rejected-before-cost"
        if "incomplete or invalid amoeba.neura.fusion metadata" in stderr:
            failure = "fusion-seed-rejected-before-cost:incomplete-or-invalid-amoeba.neura.fusion-metadata"
        elif "incomplete or invalid sibling amoeba.neura.fusion metadata" in stderr:
            failure = "fusion-seed-rejected-before-cost:incomplete-or-invalid-sibling-amoeba.neura.fusion-metadata"
        observed_scores = _count_failed_search_scores(search_dir, canonical_facts, target_facts)
        result.update(status=failure, failure_stderr=str(stderr_path),
                      failure_text=stderr[-4000:], scored_objective_count=observed_scores,
                      score_count_known=observed_scores is not None,
                      conservative_score_budget_reserve=(0 if observed_scores is not None else 2),
                      target_costed=False, ordinary_neighbors_evaluated=0)
        return result
    summary_path = search_dir / "search-summary.json"
    summary = _read_json(summary_path, "R9 diagnostic search summary")
    receipt = _validate_search_receipt(
        nr=nr, search_dir=search_dir, summary=summary,
        canonical_facts=canonical_facts, target_facts=target_facts,
        target_selection=target_row, protocol=diagnostic_protocol,
        function=workload["function"], stage=stage,
        expected_target_shapes=point["shapes"])
    result.update(status="scored", scored_objective_count=receipt["scored_candidate_count"],
                  ordinary_neighbors_evaluated=receipt["ordinary_neighbors_evaluated"],
                  receipt=receipt,
                  target_selection=receipt["target_selection"],
                  source_work=_source_work_summary(target_facts, case, side),
                  target_costs=receipt["target_costs"],
                  identity_costs=receipt["identity_costs"])
    return result


def _compact_side_points(side_dir: Path, points: list[dict[str, Any]]) -> None:
    """Retain full artifacts for only this side's best scored target."""
    scored = [row for row in points if row.get("status") == "scored" and
              isinstance(row.get("target_costs"), Mapping)]
    best = min(scored, key=lambda row: (
        row["target_costs"].get("predicted_whole_program_cycles", float("inf")),
        row.get("point", 0))) if scored else None
    best_point = int(best["point"]) if best else None
    point_root = side_dir / "points"
    if point_root.is_dir():
        for directory in point_root.iterdir():
            if not directory.is_dir():
                continue
            keep = (best_point is not None and directory.name.isdigit() and
                    int(directory.name) == best_point)
            if not keep:
                shutil.rmtree(directory)
    for row in points:
        row["full_artifacts_retained"] = (row.get("point") == best_point)
    if best is not None and not (point_root / f"{best_point:03d}").is_dir():
        raise HarnessError("best scored R9 target snapshot disappeared during compact retention")


def _validate_transfer(case: Mapping[str, Any], menus: Mapping[str, Sequence[tuple[int, int]]]
                       ) -> dict[str, Any]:
    if case["kind"] == "fusion":
        parents = case["fixed_parent_shapes"]
        target = case["fixed_target_shapes"][case["fused_task"]]
        parent_area = sum(shape[0] * shape[1] for shape in parents.values())
        target_area = target[0] * target[1]
        if parent_area != target_area or parent_area != 2:
            raise HarnessError(f"{case['id']} fusion does not preserve its two-CGRA transfer")
        if tuple(target) not in RESOURCE_SHAPES:
            raise HarnessError(f"{case['id']} fused shape is outside the bound source shape family")
        return {"kind": "fusion", "parent_shapes": parents,
                "target_shape": {case["fused_task"]: target},
                "parent_cgras": parent_area, "target_cgras": target_area,
                "preserved": True}
    parent = tuple(case["fixed_parent_shapes"][case["task"]])
    child_total = sum(shape[0] * shape[1]
                      for shape in case["fixed_target_shapes"].values())
    if parent not in menus[case["task"]] or parent[0] * parent[1] != child_total:
        raise HarnessError(f"{case['id']} fission does not preserve the two-CGRA transfer")
    return {"kind": "fission", "parent_shape": {case["task"]: list(parent)},
            "child_shapes": case["fixed_target_shapes"],
            "parent_cgras": parent[0] * parent[1], "child_cgras": child_total,
            "preserved": True}


def _existing_fixed_transfer_cell(case: Mapping[str, Any]) -> dict[str, Any]:
    """Describe the already-scored fixed cell separately from retuning points."""
    if case["kind"] == "fusion":
        return {
            "status": "fixed-typed-transform-legal-but-R9-seed-cost-unavailable",
            "legality_witness": str(DEFAULT_LEGALITY / case["legality_dir"] /
                                     "replay/source-facts.json"),
            "new_objective_scores": 0,
            "reason": "R9 candidate-key extraction rejects fusion metadata before target cost",
        }
    search_dir = (DEFAULT_PARENT_ROOT / "fixed-probes-v3" /
                  f"fission-{case['workload']}" / "search")
    top_path = search_dir / "top5.jsonl"
    summary_path = search_dir / "search-summary.json"
    summary = _read_json(summary_path, f"{case['id']} existing fixed-cell summary")
    rows = _read_jsonl(top_path, f"{case['id']} existing fixed-cell archive")
    selections = [row for row in rows if row.get("record_type") == "selection"]
    desired = {
        "identity-1x1": {case["task"]: (1, 1)},
        "original-2x1": {case["task"]: (2, 1)},
        "fission-children-1x1": {
            case["task"] + ".split.0": (1, 1),
            case["task"] + ".split.1": (1, 1)},
    }
    cells: dict[str, Any] = {}
    for label, required in desired.items():
        matched = []
        for row in selections:
            shapes = {shape.get("task"): (shape.get("rows"), shape.get("cols"))
                      for shape in row.get("shapes", []) if isinstance(shape, dict)}
            if all(shapes.get(task) == shape for task, shape in required.items()):
                matched.append(row)
        if len(matched) != 1:
            raise HarnessError(f"{case['id']} fixed transfer cell lacks unique {label} score")
        row = matched[0]
        cells[label] = {"candidate_id": row.get("candidate_id"),
                        "action_history_key": _history_key(row),
                        "predicted_whole_program_cycles": row.get("predicted_whole_program_cycles"),
                        "shapes_for_fixed_tasks": [shape for shape in row.get("shapes", [])
                                                    if shape.get("task") in required or
                                                    ".split." in shape.get("task", "")]}
    if (summary.get("unique_complete_candidates_scored") != 3 or len(selections) != 3):
        raise HarnessError(f"{case['id']} existing fixed transfer search is not the exact 3-score receipt")
    return {"status": "previously-scored-fixed-transfer-control-cell",
            "receipt_path": str(top_path), "summary_path": str(summary_path),
            "source_commit": summary.get("source_commit"),
            "source_repository": summary.get("source_repository"),
            "existing_objective_scores": 3, "new_objective_scores": 0,
            "objective": "predicted production scheduler makespan",
            "cells": cells}


def _objective_maximum(point_count: int, included_cases: Sequence[Mapping[str, Any]]) -> int:
    if point_count < 2:
        raise HarnessError("each proposal side needs at least two points")
    per_case = 0
    for case in included_cases:
        per_case += (2 * point_count - 2) + (2 * point_count)
    return per_case


def _validate_prefix(old_prefix: Sequence[Mapping[str, Any]],
                     new_prefix: Sequence[Mapping[str, Any]], case_side: str) -> None:
    if len(new_prefix) < len(old_prefix):
        raise HarnessError(f"continuation shrinks the saved proposal prefix for {case_side}")
    for index, previous in enumerate(old_prefix):
        if _stable_key(previous) != _stable_key(new_prefix[index]):
            changed = [key for key in set(previous) | set(new_prefix[index])
                       if _stable_key(previous.get(key)) != _stable_key(new_prefix[index].get(key))]
            raise HarnessError(f"continuation changed proposal {index} fields {changed} for {case_side}")


def _select_cases(args: argparse.Namespace) -> list[dict[str, Any]]:
    names = set(args.cases or [case["id"] for case in CASES])
    unknown = names - {case["id"] for case in CASES}
    if unknown:
        raise HarnessError(f"unknown case IDs: {sorted(unknown)}")
    return [dict(case) for case in CASES if case["id"] in names]


def run(args: argparse.Namespace) -> int:
    runtime_root = args.runtime_root.resolve()
    config_path = args.config.resolve()
    legality_root = args.legality_root.resolve()
    output_root = args.output_root.resolve()
    if args.output_root.is_symlink():
        raise HarnessError("output root cannot be a symlink")
    cases = _select_cases(args)
    old_run: dict[str, Any] | None = None
    if output_root.exists():
        if not args.continue_run:
            raise HarnessError("output root exists; pass --continue to preserve and extend its prefix")
        old_run = _read_json(output_root / "run.json", "saved run receipt")
        if old_run.get("schema") != "orbit-fusion-fission-resource-ablation-v1":
            raise HarnessError("existing output root belongs to another run schema")
        if old_run.get("runtime_root") != str(runtime_root):
            raise HarnessError("continuation runtime root differs from its saved R9 binding")
    else:
        if args.continue_run:
            raise HarnessError("--continue requires an existing run root")
        output_root.mkdir(parents=True)

    control, nr, replay = _helpers(runtime_root)
    del replay  # Imported from the R9 runtime for provenance; this harness never maps.
    workload_rows = _load_workloads(config_path)
    protocol_path = Path(args.protocol).resolve() if args.protocol else None
    source_contract = Path(args.source_contract).resolve() if args.source_contract else None
    if protocol_path is None or source_contract is None:
        raise HarnessError("explicit frozen R9 protocol and source contract are required")
    protocol_source = _read_json(protocol_path, "frozen R9 protocol")
    source_pin = str(protocol_source.get("source_commit", ""))
    contract_info = control._source_contract_checks(protocol_path, source_pin)
    protocol_data = contract_info["protocol"]
    if protocol_data.get("stage_scheme") != FISSION_STAGE:
        raise HarnessError("frozen R9 protocol no longer binds full-joint-fission")
    if args.protocol and not source_contract.is_file():
        raise HarnessError(f"frozen R9 source contract is missing: {source_contract}")

    # Check every path against the manifest. No optimizer/build or native call
    # occurs in dry-run mode; score mode uses exactly these source-owned paths.
    required_top = {"schema": "orbit-amoeba-input0-neighborhood-v3"}
    if protocol_data.get("schema") != required_top["schema"]:
        raise HarnessError("frozen R9 protocol schema changed")
    declared_contract = str(protocol_data.get("source_contract_file", ""))
    if Path(declared_contract).name != source_contract.name or not source_contract.is_file():
        raise HarnessError("explicit frozen R9 source contract differs from the protocol declaration")
    if protocol_data.get("source_commit") != source_pin:
        raise HarnessError("R9 source pin differs inside the frozen protocol")
    protocol_shapes = protocol_data.get("search", {}).get("later_shapes")
    if (not isinstance(protocol_shapes, list) or
            {tuple(shape) for shape in protocol_shapes if isinstance(shape, list)} !=
            set(RESOURCE_SHAPES)):
        raise HarnessError("R9 protocol's exact later-shape family differs from the eight source choices")

    old_cases = old_run.get("cases", {}) if old_run else {}
    run_record: dict[str, Any] = {
        "schema": "orbit-fusion-fission-resource-ablation-v1",
        "status": "planning" if args.mode == "dry-run" else "running",
        "mode": args.mode, "runtime_root": str(runtime_root),
        "config": str(config_path), "legality_root": str(legality_root),
        "protocol": str(protocol_path), "source_contract": str(source_contract),
        "source_commit": source_pin, "output_root": str(output_root),
        "proposal_count": args.proposal_count,
        "proposal_algorithm": "minimum-first-round-robin-single-moves-then-breadth-first-task-combinations-v1",
        "shape_choices_cgra": [list(shape) for shape in RESOURCE_SHAPES],
        "objective_cap": OBJECTIVE_CAP,
        "prior_objective_scores": (int(old_run.get("prior_objective_scores", args.prior_objective_scores))
                                   if old_run else args.prior_objective_scores),
        "max_objective_scores_planned": _objective_maximum(args.proposal_count, cases),
        "native_mapper_invoked": False, "numeric_gate_invoked": False,
        "cases": copy.deepcopy(old_cases) if isinstance(old_cases, dict) else {},
    }
    prior_count = run_record["prior_objective_scores"]
    estimate = run_record["max_objective_scores_planned"]
    unselected_saved_scores = 0
    if args.continue_run and isinstance(old_cases, dict):
        selected_names = {case["id"] for case in cases}
        unselected_saved_scores = sum(
            int(point.get("scored_objective_count", point.get("objective_count", 0)) or 0)
            for case_id, case_record in old_cases.items() if case_id not in selected_names
            for side_record in case_record.get("side_results", {}).values()
            for point in side_record.get("points", []))
    if prior_count + unselected_saved_scores + estimate > args.max_total_objectives:
        raise HarnessError(
            f"planned objective cap exceeded: prior {prior_count} + saved unselected "
            f"scores {unselected_saved_scores} + selected-case maximum {estimate} "
            f"> total allowance {args.max_total_objectives}; select fewer cases or a shorter prefix")

    for case in cases:
        workload = workload_rows.get(case["workload"])
        if workload is None:
            raise HarnessError(f"R9 workload manifest omits {case['workload']}")
        if Path(workload.get("artifact_root", "")).resolve() != runtime_root:
            raise HarnessError(f"{case['id']} is not bound to the requested frozen R9 runtime")
        optimizer = Path(workload["optimizer"]).resolve()
        expected_optimizer = (runtime_root / ".work/control-variables-and-tiling-20261006/"
                              "mlir-amoeba-opt-memory-fusion-fission-r9-original-ray-ii23-"
                              "stable-features-20261006").resolve()
        if optimizer != expected_optimizer or not optimizer.is_file() or not os.access(optimizer, os.X_OK):
            raise HarnessError(f"{case['id']} optimizer differs from the exact R9 frozen binary")
        for field in ("canonical", "architecture", "parent_cost_file", "model_cache",
                      "prepared_source_file", "inter_task_network"):
            path = Path(workload[field])
            if not path.is_file():
                raise HarnessError(f"{case['id']} R9 input is missing: {path}")
        cost_catalog = _read_json(Path(workload["parent_cost_file"]), "source model cost catalogue")
        predictor = cost_catalog.get("predictor_metadata")
        source_task_ids = predictor.get("source_task_ids") if isinstance(predictor, dict) else None
        if not isinstance(source_task_ids, list) or any(not isinstance(task, str) for task in source_task_ids):
            raise HarnessError(f"{case['id']} source model has no exact canonical task order")
        original_menus = _shape_menus(cost_catalog, source_task_ids, protocol_shapes)
        transfer = _validate_transfer(case, original_menus)
        case_legality = legality_root / case["legality_dir"]
        transform_facts = _read_json(case_legality / "replay/source-facts.json",
                                     f"{case['id']} existing R9 typed replay facts")
        original_dir = legality_root / f"original-{case['workload']}"
        canonical_facts = _read_json(original_dir / "replay/source-facts.json",
                                     f"{case['id']} independent original canonical facts")
        function = str(workload["function"])
        if (canonical_facts.get("status") != "complete" or
                canonical_facts.get("function") != function or
                canonical_facts.get("source_iteration_domain_verified") is not True or
                canonical_facts.get("actions_applied") != 0 or
                canonical_facts.get("action_history", {}).get("actions") != [] or
                canonical_facts.get("action_history", {}).get("fissionActions") != []):
            raise HarnessError(f"{case['id']} canonical facts are not the independent no-transform replay")
        original_names = _facts_task_names(canonical_facts)
        if original_names != source_task_ids:
            raise HarnessError(f"{case['id']} canonical task order differs from source model metadata")
        target_names = _facts_task_names(transform_facts)
        _validate_replay_facts(transform_facts, case=case, function=function,
                               expected_tasks=target_names,
                               expected_fission=case["kind"] == "fission")
        structural_action_doc = _read_json(case_legality / "replay/actions.json",
                                           f"{case['id']} typed-action document")
        structural_actions = structural_action_doc.get("actions")
        if not isinstance(structural_actions, list) or not structural_actions:
            raise HarnessError(f"{case['id']} has no existing exact typed structural action")
        if case["kind"] == "fusion":
            target_names = [row["task"] for row in transform_facts["selected_shapes"]]
            if case["fused_task"] not in target_names:
                raise HarnessError(f"{case['id']} exact R9 replay lacks its fused task")
        else:
            if len(structural_actions) != 1 or structural_actions[0].get("family") != "fission":
                raise HarnessError(f"{case['id']} does not have one source-owned fission action")
        _validate_structural_proof(case, transform_facts, structural_actions)
        if case["kind"] == "fission":
            transformed_catalog_path = (DEFAULT_PARENT_ROOT / "fixed-probes-v3" /
                                       f"fission-{case['workload']}" / "search" /
                                       "costs-graph-catalogue-1.json")
            transformed_catalog = _read_json(
                transformed_catalog_path,
                f"{case['id']} existing frozen R9 transformed-shape catalogue")
            transformed_menus = _shape_menus(
                transformed_catalog, target_names, protocol_shapes)
            shape_menu_evidence = {
                "original": {"catalogue": str(Path(workload["parent_cost_file"])),
                             "graph": "original canonical"},
                "transformed": {"catalogue": str(transformed_catalog_path),
                                "graph": "existing fixed-probe fission body; scalar II recomputed per score"},
            }
        else:
            transformed_menus = {task: original_menus[task]
                                 for task in target_names if task in original_menus}
            transformed_menus[case["fused_task"]] = [tuple(shape) for shape in protocol_shapes]
            shape_menu_evidence = {
                "original": {"catalogue": str(Path(workload["parent_cost_file"])),
                             "graph": "original canonical"},
                "transformed": {"catalogue": None,
                                "graph": "typed fusion legality witness only; R9 seed extractor fails before cost",
                                "choices": "protocol choices only; not model-supported evidence"},
            }
        source_contract_path = Path(workload["source_contract"]).resolve()
        if source_contract_path != source_contract:
            raise HarnessError(f"{case['id']} source contract differs from the pinned R9 contract")
        if Path(workload["protocol"]).resolve() != protocol_path:
            raise HarnessError(f"{case['id']} protocol differs from the pinned R9 protocol")
        if int(workload["max_partition_factor"]) != int(contract_info["max_partition_factor"]):
            raise HarnessError(f"{case['id']} max partition factor differs from R9 protocol")
        if int(workload["fission_cap"]) != int(contract_info["fission_cap"]):
            raise HarnessError(f"{case['id']} fission cap differs from R9 protocol")

        case_root = output_root / case["id"]
        old_case = old_cases.get(case["id"], {}) if isinstance(old_cases, dict) else {}
        case_result: dict[str, Any] = {
            "case": case, "workload": case["workload"],
            "source_task_order": source_task_ids,
            "original_canonical_facts": str(original_dir / "replay/source-facts.json"),
            "transformation_facts": str(case_legality / "replay/source-facts.json"),
            "transformation_action_file": str(case_legality / "replay/actions.json"),
            "fixed_resource_transfer": transfer,
            "existing_fixed_transfer_cell": _existing_fixed_transfer_cell(case),
            "shape_menu_evidence": shape_menu_evidence,
            "resource_panel_principle": "both graphs begin with every task at minimum-supported 1x1; all tasks are free",
            "side_results": {},
        }
        for side in ("original", "transformed"):
            states = _case_state_sequence(
                case=case, side=side, base_task_ids=source_task_ids,
                transformed_task_ids=target_names,
                menus=original_menus if side == "original" else transformed_menus,
                point_count=args.proposal_count)
            side_dir = case_root / side
            cache_path = side_dir / "model-cost-cache.json"
            saved_side = old_case.get("side_results", {}).get(side, {}) if isinstance(old_case, dict) else {}
            saved_prefix = saved_side.get("proposal_prefix", []) if isinstance(saved_side, dict) else []
            proposals = []
            for point in states:
                actions = _actions_for_point(control, case, side, point,
                                             canonical_facts, transform_facts,
                                             structural_actions)
                key = _stable_key({"case": case["id"], "side": side,
                                   "typed_actions": actions, "shapes": point["shapes"]})
                proposals.append({"point": point["point"], "shapes": point["shapes"],
                                  "typed_actions": actions, "proposal_key": key})
            side_prefix = [{"proposal_key": row["proposal_key"], "shapes": row["shapes"],
                            "typed_actions": row["typed_actions"]} for row in proposals]
            _validate_prefix(saved_prefix, side_prefix, f"{case['id']}/{side}")
            if not cache_path.exists() or not args.continue_run:
                _write_json(cache_path, _read_cache_header(
                    DEFAULT_CACHE_ROOT / f"{case['workload']}-ml-cache.json"))
            diagnostic_dir = side_dir / "protocol"
            diagnostic_dir.mkdir(parents=True, exist_ok=True)
            diagnostic_protocol_path = diagnostic_dir / "diagnostic-common-protocol.json"
            if diagnostic_protocol_path.exists():
                diagnostic_protocol = _read_json(
                    diagnostic_protocol_path, "existing bounded R9 diagnostic protocol")
                search_budget = diagnostic_protocol.get("search", {})
                if (search_budget.get("max_rounds") != 1 or
                        search_budget.get("max_unique_complete_candidates_scored") != 2 or
                        search_budget.get("beam_width") != 1 or
                        search_budget.get("diversity_min_slots") != 1):
                    raise HarnessError("saved diagnostic protocol differs from the exact 2-candidate bound")
                budget_receipt = {
                    "diagnostic_only": True, "path": str(diagnostic_protocol_path),
                    "diagnostic_search_budget": search_budget,
                    "cxx_search_options": {"max_rounds": 1, "max_candidates": 2,
                                           "beam_width": 1, "diversity_slots": 1,
                                           "max_partition_factor": int(contract_info["max_partition_factor"])},
                    "scored_candidate_composition": {"identity": 1, "explicit_control_seeds": 1,
                                                      "total": 2},
                    "main_curve_budget_changed": False,
                }
            else:
                diagnostic_protocol_path, diagnostic_protocol, budget_receipt = \
                    control._write_diagnostic_protocol(protocol_data,
                                                       output_dir=diagnostic_dir,
                                                       candidate_budget=2)
            source_binding = control._source_binding(
                nr, protocol=diagnostic_protocol,
                protocol_path=diagnostic_protocol_path,
                canonical=Path(workload["canonical"]), optimizer=optimizer,
                architecture=Path(workload["architecture"]),
                model_cache=Path(workload["model_cache"]), cost_cache=cache_path,
                parent_cost_file=Path(workload["parent_cost_file"]),
                source_contract=source_contract,
                network=Path(workload["inter_task_network"]),
                prepared_source=(Path(workload["prepared_source_file"])
                                 if case["kind"] == "fission" else None),
                fission_cap=(int(workload["fission_cap"])
                             if case["kind"] == "fission" else None))
            source_binding_path = side_dir / "source-binding.json"
            _write_json(source_binding_path, source_binding)
            old_points = list(saved_side.get("points", [])) if isinstance(saved_side, dict) else []
            old_by_point = {row.get("point"): row for row in old_points
                            if isinstance(row, dict) and row.get("status") not in {"planned", "pending"}}
            side_points: list[dict[str, Any]] = []
            for proposal in proposals:
                if side == "original" and proposal["point"] == 0:
                    identity_placeholder = {
                        "point": 0, "proposal_key": proposal["proposal_key"],
                        "shapes": proposal["shapes"], "typed_actions": [],
                        "status": "identity-control-in-first-search",
                        "objective_count": 0,
                        "source_history": _history_key(canonical_facts),
                    }
                    side_points.append(identity_placeholder)
                    continue
                previous = old_by_point.get(proposal["point"])
                if previous:
                    if previous.get("proposal_key") != proposal["proposal_key"]:
                        raise HarnessError("saved R9 score point does not match the current exact proposal")
                    side_points.append(previous)
                    if previous.get("status", "").startswith("fusion-seed-rejected"):
                        # Preserve the source-gate failure and do not retry it or
                        # allow a later ordinary-neighbor score to slip through.
                        break
                    continue
                if args.mode == "score" and case["kind"] == "fusion" and not args.repeat_known_fusion_failures:
                    point_result = {
                        "point": proposal["point"], "proposal_key": proposal["proposal_key"],
                        "shapes": proposal["shapes"], "typed_actions": proposal["typed_actions"],
                        "status": "known-r9-pre-cost-fusion-seed-rejection",
                        "evidence": ("fixed-probes-v3 required previous-winner attempt; "
                                     "R9 extractor rejects incomplete fusion metadata before target cost"),
                        "scored_objective_count": 0,
                        "ordinary_neighbors_evaluated": 0,
                    }
                else:
                    point_result = _run_point(
                        control=control, nr=nr, case=case, side=side,
                        point={**proposal, "point": proposal["point"]},
                        actions=proposal["typed_actions"], base_facts=canonical_facts,
                        target_proof_facts=transform_facts,
                        canonical_facts=canonical_facts, workload=workload,
                        protocol_data=protocol_data, protocol_path=protocol_path,
                        source_contract=source_contract,
                        diagnostic_protocol_path=diagnostic_protocol_path,
                        diagnostic_protocol=diagnostic_protocol,
                        cost_cache=cache_path, output_dir=side_dir,
                        runtime_root=runtime_root, execute=args.mode == "score")
                if (side == "original" and proposal["point"] == 1 and
                        point_result.get("status") in {"scored", "planned"}):
                    identity_costs = point_result.get("identity_costs")
                    if identity_costs is None and point_result.get("receipt"):
                        identity_costs = point_result["receipt"].get("identity_costs")
                    if args.mode == "score":
                        side_points[0]["objective_count"] = 1
                        side_points[0]["objective_costs"] = identity_costs
                    else:
                        side_points[0]["planned_identity_score_count"] = 1
                    side_points[0]["source_history"] = _history_key(canonical_facts)
                side_points.append(point_result)
                if point_result.get("status", "").startswith("fusion-seed-rejected") or \
                        point_result.get("status") in {
                            "required-target-seed-rejected-before-cost",
                            "known-r9-pre-cost-fusion-seed-rejection"}:
                    break
            side_result = {
                "status": ("planned" if args.mode == "dry-run" else
                           "complete-prefix" if len(side_points) >= len(proposals) else "stopped-at-first-seed-failure"),
                "proposal_prefix_length": len(proposals),
                "proposal_prefix": side_prefix,
                "points": side_points,
                "protocol": str(diagnostic_protocol_path),
                "diagnostic_budget_receipt": budget_receipt,
                "source_binding": str(source_binding_path),
                "cost_cache": str(cache_path),
                "identity_rule": "compare identity to independent original-canonical replay facts",
                "ordinary_neighborhoods_evaluated": 0,
            }
            case_result["side_results"][side] = side_result
            if args.mode == "score":
                _compact_side_points(side_dir, side_points)
            _write_json(side_dir / "side.json", side_result)
        run_record["cases"][case["id"]] = case_result
        _write_json(case_root / "case.json", case_result)

    all_points = [point for case in run_record["cases"].values()
                  for side in case["side_results"].values()
                  for point in side.get("points", [])]
    unknown_score_count = sum(point.get("status") not in {"planned", "scored"} and
                              point.get("scored_objective_count") is None and
                              point.get("conservative_score_budget_reserve") is not None
                              for point in all_points)
    actual_new = sum(int(point.get("scored_objective_count", point.get("objective_count", 0)) or 0)
                     for point in all_points)
    reserved_unknown = sum(int(point.get("conservative_score_budget_reserve", 0) or 0)
                           for point in all_points)
    run_record["actual_new_objective_scores"] = None if unknown_score_count else actual_new
    run_record["conservative_new_objective_score_upper_bound"] = actual_new + reserved_unknown
    run_record["total_objective_scores_with_prior"] = (None if unknown_score_count else
                                                       prior_count + actual_new)
    run_record["status"] = "dry-run-planned" if args.mode == "dry-run" else "complete-or-prefix-stopped"
    _write_json(output_root / "run.json", run_record)
    _write_json(output_root / "summary.json", {
        "schema": run_record["schema"], "status": run_record["status"],
        "source_commit": source_pin, "proposal_count": args.proposal_count,
        "cases": {key: {"kind": value["case"]["kind"],
                         "transfer": value["fixed_resource_transfer"],
                         "sides": {side: {"status": result["status"],
                                          "points_planned": result["proposal_prefix_length"],
                                          "points_recorded": len(result["points"]),
                                          "objective_scores": sum(int(point.get(
                                              "scored_objective_count", point.get("objective_count", 0)) or 0)
                                              for point in result["points"])}
                                   for side, result in value["side_results"].items()}}
                  for key, value in run_record["cases"].items()},
        "planned_objective_max": estimate,
        "actual_new_objective_scores": None if unknown_score_count else actual_new,
        "conservative_new_objective_score_upper_bound": actual_new + reserved_unknown,
        "total_with_prior": None if unknown_score_count else prior_count + actual_new,
        "native_mapper_invoked": False, "numeric_gate_invoked": False,
    })
    return 0


def _self_test() -> None:
    toy_menus = {"Task_0": ((1, 1), (1, 2), (2, 1)),
                 "Task_1": ((1, 1), (1, 2), (2, 1)),
                 "Task_2": ((1, 1), (1, 2), (2, 1))}
    toy_tasks = list(toy_menus)
    values = list(_resource_walk(toy_tasks, toy_menus, point_count=16))
    assert values[0] == {task: (1, 1) for task in toy_tasks}
    assert values[1:4] == [
        {"Task_0": (1, 2), "Task_1": (1, 1), "Task_2": (1, 1)},
        {"Task_0": (1, 1), "Task_1": (1, 2), "Task_2": (1, 1)},
        {"Task_0": (1, 1), "Task_1": (1, 1), "Task_2": (1, 2)},
    ]
    assert values[:8] == list(_resource_walk(toy_tasks, toy_menus, point_count=8))
    assert values == list(_resource_walk(toy_tasks, toy_menus, point_count=16))
    assert all(sum(state[task] != (1, 1) for task in toy_tasks) == 2
               for state in values[7:])
    long_tasks = [f"Task_{index}" for index in range(25)]
    long_menus = {task: RESOURCE_SHAPES for task in long_tasks}
    prefix = list(_resource_walk(long_tasks, long_menus, point_count=64))
    assert len(prefix) == 64
    assert all(prefix[index][task] != (1, 1)
               for index, task in enumerate(long_tasks, 1))
    assert set(prefix[0]) == set(long_tasks)
    assert _objective_maximum(64, CASES) == 1016
    assert _objective_maximum(64, CASES[2:]) == 508
    assert _objective_maximum(256, CASES[2:]) == 2044
    assert _objective_maximum(256, CASES[2:]) + 12 <= OBJECTIVE_CAP
    assert _objective_maximum(256, CASES) == 4088
    assert _objective_maximum(256, CASES) + 12 > OBJECTIVE_CAP
    assert _validate_prefix([{"proposal_key": "a"}],
                            [{"proposal_key": "a"}, {"proposal_key": "b"}], "toy") is None
    try:
        _validate_prefix([{"proposal_key": "a"}], [{"proposal_key": "x"}], "toy")
    except HarnessError:
        pass
    else:
        raise AssertionError("continuation accepted a modified prefix")
    for case in CASES[:2]:
        parent_total = sum(rows * cols for rows, cols in
                           (tuple(shape) for shape in case["fixed_parent_shapes"].values()))
        target_total = sum(rows * cols for rows, cols in
                           (tuple(shape) for shape in case["fixed_target_shapes"].values()))
        assert parent_total == target_total == 2
    for case in CASES[2:]:
        parent_rows, parent_cols = case["fixed_parent_shapes"][case["task"]]
        child_total = sum(rows * cols for rows, cols in
                          (tuple(shape) for shape in case["fixed_target_shapes"].values()))
        assert parent_rows * parent_cols == child_total == 2
    for case in CASES[2:]:
        tasks = [f"Task_{index}" for index in range(9)]
        children = [task for task in tasks if task != case["task"]]
        children.extend((case["task"] + ".split.0", case["task"] + ".split.1"))
        menus = {task: RESOURCE_SHAPES for task in set(tasks + children)}
        original = _case_state_sequence(case=case, side="original",
                                        base_task_ids=tasks, transformed_task_ids=children,
                                        menus=menus, point_count=4)
        transformed = _case_state_sequence(case=case, side="transformed",
                                           base_task_ids=tasks, transformed_task_ids=children,
                                           menus=menus, point_count=4)
        assert original[0]["shape_map"] == {task: [1, 1] for task in tasks}
        assert transformed[0]["shape_map"] == {task: [1, 1] for task in children}
        assert len(original[1]["shape_map"]) == len(tasks)
        assert len(transformed[1]["shape_map"]) == len(children)


def _parse_args(argv: Sequence[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--runtime-root", type=Path, default=DEFAULT_RUNTIME)
    parser.add_argument("--config", type=Path, default=DEFAULT_CONFIG)
    parser.add_argument("--legality-root", type=Path, default=DEFAULT_LEGALITY)
    parser.add_argument("--protocol", type=Path,
                        default=Path("/home/x/shiran/project/orbit-artifact/.work/"
                                     "input0-neighborhood-2x2-v60-memory-fusion-fission-r5-20261006/"
                                     "protocol-bound-original-ray-ii23-r9-queue-v2.json"))
    parser.add_argument("--source-contract", type=Path,
                        default=DEFAULT_RUNTIME / ".work/control-variables-and-tiling-20261006/"
                                "source-model-contract-memory-fusion-fission-r9-original-ray-ii23-"
                                "stable-features-queue-v2-20261006.json")
    parser.add_argument("--output-root", type=Path, required=False,
                        default=Path("/tmp/orbit-ff-resource-ablation-r9-20261007"))
    parser.add_argument("--proposal-count", type=int, choices=(64, 256), default=64)
    parser.add_argument("--max-total-objectives", type=int, default=OBJECTIVE_CAP)
    parser.add_argument("--prior-objective-scores", type=int, default=12,
                        help="already-spent R9 scores from parent fixed/calibration ledger")
    parser.add_argument("--case", dest="cases", action="append", choices=[c["id"] for c in CASES])
    parser.add_argument("--mode", choices=("dry-run", "score"), default="dry-run")
    parser.add_argument("--continue", dest="continue_run", action="store_true",
                        help="verify the old prefix and add only its missing suffix")
    parser.add_argument("--repeat-known-fusion-failures", action="store_true",
                        help="reproduce previously observed fusion seed rejection; spends identity scores")
    parser.add_argument("--self-test", action="store_true")
    return parser.parse_args(argv)


def main(argv: Sequence[str] | None = None) -> int:
    args = _parse_args(argv)
    try:
        if args.self_test:
            _self_test()
            print("resource harness self-tests passed")
            return 0
        if args.prior_objective_scores < 0 or args.max_total_objectives <= 0:
            raise HarnessError("objective score budget values must be positive")
        return run(args)
    except (HarnessError, OSError, ValueError, KeyError, TypeError) as error:
        print(f"resource ablation harness failed: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
