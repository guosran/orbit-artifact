#!/usr/bin/env python3
"""Validate the native C++ joint/sequential search contract artifacts."""

import argparse
import json
import hashlib
import sys
import tarfile
from pathlib import Path

SCRIPTS = Path(__file__).resolve().parents[2] / "scripts"
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))
import compact_sequential_raw as journal_storage
from sequential_budget_audit import expected_phase_budgets


def read_json(path):
    return json.loads(path.read_text())


def read_jsonl(path):
    path = Path(path)
    member = path.relative_to(path.parent.parent).as_posix()
    if member in journal_storage.JOURNAL_NAMES:
        compressed = Path(str(path) + ".gz")
        if path.is_file() or compressed.is_file():
            return journal_storage.read_journal(path)
    if path.is_file():
        payload = path.read_bytes()
    else:
        cell = path.parent.parent
        manifest = read_json(cell / "raw-auxiliary-manifest.json")
        member = str(path.relative_to(cell))
        descriptor = next(row for row in manifest["files"] if row["path"] == member)
        with tarfile.open(cell / "raw-auxiliary.tar.gz", "r:gz") as archive:
            payload = archive.extractfile(member).read()
        require(len(payload) == descriptor["size"] and
                hashlib.sha256(payload).hexdigest() == descriptor["sha256"],
                "archived contract evidence byte binding mismatch")
    return [json.loads(line) for line in payload.decode().splitlines() if line]


def require(condition, message):
    if not condition:
        raise SystemExit(message)


def check_cross_phase_promotions(root, summary, frozen, require_promotion, frozen_fission=None):
    promotion_count = summary.get("cross_phase_dedup_promotions")
    require(isinstance(promotion_count, int) and promotion_count >= 0,
            "summary must report the cross-phase promotion count")
    trace_name = summary.get("cross_phase_dedup_promotion_trace_file")
    require(trace_name == "cross-phase-dedup-promotions.jsonl",
            "summary must name the cross-phase promotion trace")
    events = read_jsonl(root / trace_name)
    require(len(events) == promotion_count,
            "cross-phase promotion count does not match its trace")
    if require_promotion:
        require(bool(events), "expected at least one cross-phase promotion")

    if not events:
        return

    archive = {row.get("candidate_id"): row
               for row in read_jsonl(root / "archive.jsonl")}
    retained_ids = {row.get("candidate_id") for row in read_jsonl(root / "top5.jsonl")
                    if row.get("record_type") == "selection"}
    retained_ids.update(row.get("candidate_id") for row in read_jsonl(root / "controls.jsonl"))
    for event in events:
        require(event.get("schema") == "orbit-cross-phase-dedup-promotion-v1" and
                event.get("phase") == "B",
                "promotion trace contains an unknown event")
        require(event.get("candidate_key") and
                event.get("objective_reused") is True and
                event.get("production_scheduler_invoked") is False and
                event.get("frontier_queued_once") is True,
                "promotion must reuse the cached objective and queue B once")
        source_history = event.get("source_primary_history", {})
        target_history = event.get("target_primary_history", {})
        source_actions = source_history.get("actions", [])
        target_actions = target_history.get("actions", [])
        require(target_history.get("known") is True and
                target_actions[:len(frozen)] == frozen and
                len(target_actions) >= len(frozen),
                "promoted primary history must authenticate the frozen A prefix")
        require(target_history.get("fissionActions", []) == (frozen_fission or []),
                "promoted B history changed the frozen source-fission decisions")
        require(all(action.get("family") in {"shape", "replica"}
                    for action in target_actions[len(frozen):]),
                "promoted B history may add only resource actions")
        require(source_history != target_history,
                "promotion must replace an incompatible source history")
        require(event.get("candidate_key") and
                event.get("source_candidate_id") == event.get("archive_candidate_id"),
                "promotion must retain the source archive row identity")
        require(event.get("target_state_id") == event.get("archive_candidate_id") and
                event.get("target_attempt_id") != event.get("target_state_id"),
                "promoted frontier must use the retained archive identity")
        row = archive.get(event.get("archive_candidate_id"))
        require(row is not None and
                row.get("candidate_key") == event.get("candidate_key") and
                row.get("action_history") == target_history,
                "archive row must retain the promoted B history under the same key")
        require(row.get("action_path") == event.get("target_primary_path"),
                "archive primary path must follow the promoted B representative")
        source_path = event.get("source_primary_path", [])
        if source_path != event.get("target_primary_path"):
            require(source_path in row.get("alternate_action_paths", []),
                    "promotion must retain the original primary path as audit history")
        require(row.get("predicted_whole_program_cycles") ==
                event.get("score_cycles"),
                "promotion must retain the cached production score")
        require(row.get("cost_catalogue_path") ==
                event.get("objective_cost_catalogue_path"),
                "promotion must preserve the cached objective provenance")
        choices = row.get("task_choices", [])
        require([choice.get("task") for choice in choices] ==
                event.get("target_task_names"),
                "promoted cached choices must use the target module vocabulary")
        retained_at_promotion = event.get("target_snapshot_retained")
        final_path = row.get("candidate_path")
        if event.get("archive_candidate_id") in retained_ids:
            require(retained_at_promotion is True and
                    final_path == event.get("target_candidate_path") and final_path,
                    "a final retained promoted row must use the authenticated B snapshot")
        elif retained_at_promotion:
            require(not final_path or final_path == event.get("target_candidate_path"),
                    "later pruning may clear the B snapshot, but may not replace it with an A module")
        else:
            require(not event.get("target_candidate_path") and not final_path,
                    "an unretained promotion must not leave a stale module path")
        source_names = event.get("source_task_names", [])
        target_names = event.get("target_task_names", [])
        require(len(source_names) == len(target_names),
                "promotion must preserve task count while rebinding names")
        if source_names != target_names:
            require(event.get("module_exact_bytes_equal") is not True,
                    "different task vocabularies cannot claim byte-identical modules")
        require(isinstance(event.get("control_roles_preserved"), list) and
                row.get("control_roles") == event.get("control_roles_preserved") and
                row.get("control_role_provenance") ==
                event.get("control_role_provenance") and
                event.get("control_role_provenance_preserved") is True,
                "promotion must preserve immutable control-role provenance")


def check_sequential(root, require_promotion=False):
    summary = read_json(root / "search-summary.json")
    require(summary.get("decision_flow") == "sequential",
            "summary must declare decision_flow=sequential")
    require(summary.get("stage") in {"full-joint", "full-joint-fission"},
            "sequential search must use a complete joint action space")

    budget = summary.get("objective_budget")
    budgets = summary.get("phase_budgets", {})
    evaluations = summary.get("phase_evaluations", {})
    require(isinstance(budget, int) and budget > 0,
            "summary must declare a positive objective budget")
    require(set(budgets) == {"A", "B"}, "phase budgets must include A and B")
    require(set(evaluations) == {"A", "B"},
            "phase evaluations must include A and B")
    try:
        expected = expected_phase_budgets(summary, budget, summary["graph_budget_percent"],
                                         summary.get("sequential_budget_policy", "fixed-split"))
    except (ValueError, KeyError) as exc:
        raise SystemExit(str(exc))
    require(budgets == expected, "phase allowances violate the declared allocation policy")
    require(sum(budgets.values()) == budget,
            "phase allowances must sum to the shared budget")
    require(all(evaluations[p] <= budgets[p] for p in ("A", "B")),
            "a phase exceeded its fixed allowance")
    require(sum(evaluations.values()) <= budget,
            "combined phases exceeded the shared budget")
    require(summary.get("production_scheduler_calls") == sum(evaluations.values()),
            "every objective evaluation must be one production scheduler call")
    require(summary.get("actual_mapper_search_calls") == 0,
            "search must not invoke the legacy mapper")

    controls = read_jsonl(root / "controls.jsonl")
    roles = {row.get("control_role"): row for row in controls}
    require(set(roles) == {"identity", "search_anchor"},
            "standalone sequential controls must be identity and search_anchor")
    anchor_history = roles["search_anchor"].get("action_history", {})
    require(anchor_history.get("known") is True,
            "phase-A anchor history must be authenticated")
    frozen = anchor_history.get("actions", [])
    frozen_fission = anchor_history.get("fissionActions", [])
    require(all(action.get("family") == "fission" for action in frozen_fission),
            "frozen source-fission history contains a different action family")
    if summary.get("stage") == "full-joint-fission":
        require(summary.get("frozen_fission_actions") == frozen_fission,
                "summary must authenticate the exact frozen source-fission actions")
    require(roles["search_anchor"].get("candidate_id") ==
            summary.get("phase_a_anchor_candidate_id"),
            "summary anchor ID must match the native search_anchor control")
    check_cross_phase_promotions(root, summary, frozen, require_promotion, frozen_fission)

    top = read_jsonl(root / "top5.jsonl")
    selections = [row for row in top if row.get("record_type") == "selection"]
    require(len(selections) <= 5, "native shortlist may contain at most five rows")
    for row in selections:
        history = row.get("action_history", {})
        actions = history.get("actions", [])
        require(history.get("known") is True and len(actions) >= len(frozen),
                "every final shortlist history must contain the authenticated A prefix")
        require(actions[:len(frozen)] == frozen,
                "a final shortlist candidate changed the frozen A history")
        require(history.get("fissionActions", []) == frozen_fission,
                "a final shortlist candidate changed the frozen source-fission decisions")
        require(all(action.get("family") in {"shape", "replica"}
                    for action in actions[len(frozen):]),
                "B history may add only shape and replica resource actions")

    events = read_jsonl(root / "action-attempts.jsonl")
    per_phase = {phase: [event for event in events
                         if event.get("phase") == phase]
                 for phase in ("A", "B")}
    counts = summary.get("phase_action_counts", {})
    for phase in ("A", "B"):
        require(counts.get(phase, {}).get("attempts") == len(per_phase[phase]),
                f"phase {phase} action attempt count does not match its trace")
    candidate_attempts = summary.get("phase_candidate_attempts", {})
    require(candidate_attempts.get("A") == len(per_phase["A"]) + 1 and
            candidate_attempts.get("B") == len(per_phase["B"]),
            "candidate attempt counts must include the initial identity exactly once")
    require(summary.get("candidate_attempts") == len(events) + 1,
            "total candidate attempts must include every action and initial identity")

    for event in per_phase["A"]:
        action = event.get("action", {})
        require(action.get("family") not in {"shape", "replica"},
                "phase A must not search pure shape or replica actions")
        require(not action.get("shapeTask") and
                action.get("shapeRows", 0) == 0 and
                action.get("shapeCols", 0) == 0,
                "phase A must project shape choices out of graph actions")
        require(all(primitive.get("kind") not in {"replica", "replication"}
                    for primitive in action.get("primitives", [])),
                "phase A action contains a replica primitive")

    for event in per_phase["B"]:
        action = event.get("action", {})
        require(action.get("family") in {"shape", "replica", "lineage-replacement"},
                "phase B attempted a structural graph action")
        if event.get("accepted"):
            require(event.get("frozen_prefix_verified") is True,
                    "accepted phase B action did not retain the authenticated A prefix")

    traces = read_jsonl(root / "budget-trace.jsonl")
    require(len(traces) == sum(evaluations.values()),
            "budget trace must contain every production scheduler invocation")
    previous = 0
    previous_elapsed = -1.0
    for event in traces:
        require(event.get("phase") in {"A", "B"},
                "budget trace contains an unknown phase")
        require(event.get("cumulative_evaluations") == previous + 1,
                "cumulative objective evaluation count is not contiguous")
        require(event.get("scheduler_invoked") is True,
                "budget trace entry must correspond to a scheduler invocation")
        elapsed = event.get("elapsed_seconds")
        require(isinstance(elapsed, (int, float)) and elapsed >= previous_elapsed,
                "stage elapsed time must include initialization and be monotonic")
        require("incumbent_cycles" in event,
                "budget trace must record the running incumbent")
        previous = event["cumulative_evaluations"]
        previous_elapsed = elapsed

    frontiers = read_jsonl(root / "action-frontiers.jsonl")
    require(summary.get("round_score_quota", 0) > 0,
            "comparison must bind a common fixed frontier objective quota")
    require(summary.get("global_rounds_completed") == len(frontiers) and
            len(frontiers) <= summary.get("max_rounds", 0),
            "combined phases exceeded the global frontier safety cap")
    require({row.get("phase") for row in frontiers} == {"A", "B"},
            "action frontier trace must cover both phases")
    for phase in ("A", "B"):
        rows = [row for row in frontiers if row["phase"] == phase]
        require(summary[f"phase_{phase.lower()}_rounds_completed"] == len(rows),
                f"phase {phase} round count must match actual enumerated frontiers")
        require([row["phase_round"] for row in rows] == list(range(len(rows))),
                f"phase {phase} round indices must be contiguous")
    for row in frontiers:
        offset = summary["phase_a_rounds_completed"] if row["phase"] == "B" else 0
        require(row["global_action_menu_round"] == row["phase_round"] + offset,
                "B must continue the cumulative action menu rather than reset the seed menu")
    require(all("filtered_shape" in row and "filtered_replica" in row and
                "filtered_graph" in row for row in frontiers),
            "frontier trace must account for filtered action classes")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("sequential_output", type=Path)
    parser.add_argument("--require-cross-phase-promotion", action="store_true",
                        help="require the fixture to exercise an A-to-B promotion")
    args = parser.parse_args()
    check_sequential(args.sequential_output, args.require_cross_phase_promotion)
    print("sequential search contract passed")


if __name__ == "__main__":
    main()
