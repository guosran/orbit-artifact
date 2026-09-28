"""Compare source-owned rewrite manifests without changing their counters.

The C++ pass publishes accepted and rejected records in separate arrays.
Reconstruct their chronological FIFO traversal and check every source record.
"""
from collections import Counter, defaultdict, deque
import json


LEDGER_SCHEMA = "orbit-action-ledger-v1"
def action_key(row):
    return (row["input_semantic_graph_id"], row["action_name"],
            json.dumps(row["action_parameters"], sort_keys=True),
            row["rewrite_depth"], row["legality_result"],
            row["rejection_reason"], row["output_semantic_graph_id"],
            row["canonicalized_to_existing_graph"])


def semantic_action_key(row):
    """Identity of an action on a canonical input, independent of traversal."""
    return action_key(row)[:3]


def _normalized_action(action):
    return {"kind": action["kind"],
            **({"tile_size": action["tile_size"]} if action.get("tile_size") is not None else {})}


def _bucket_key(graph_id, depth, action):
    return graph_id, depth, action["kind"], action.get("tile_size")


def _fusion_mode(candidate):
    if candidate is None:
        return "unavailable_in_manifest"
    fusion = candidate["fusion"]
    if fusion.get("reduction_consumer"):
        return "reduction_consumer"
    if fusion.get("sequential_last"):
        return "sequential_last"
    return fusion["producer_consumer"]


def ledger(manifest, protocol):
    if manifest.get("complete") is not True:
        raise ValueError("incomplete enumeration manifest")
    candidates = {candidate["graph_id"]: candidate for candidate in manifest["candidates"]}
    records = manifest["transitions"] + manifest["rejections"]
    statistics = manifest["statistics"]
    if len(records) != statistics["action_attempts"]:
        raise ValueError("action records do not match source counter")
    roots = [candidate for candidate in manifest["candidates"]
             if not candidate["witness"]["actions"]]
    if len(roots) != 1:
        raise ValueError("expected exactly one root candidate")
    root_id = roots[0]["graph_id"]
    buckets = defaultdict(deque)
    for record in records:
        buckets[_bucket_key(record["source_graph_id"], record["depth"], record["action"])].append(record)
    queue = deque([(root_id, 0, True, [])])
    seen_best = {root_id: True}
    rows = []
    while queue:
        graph_id, depth, witness_available, history = queue.popleft()
        if depth >= statistics["max_depth"]:
            continue
        candidate = candidates.get(graph_id)
        for catalog_action in manifest["action_catalog"]:
            key = _bucket_key(graph_id, depth + 1, catalog_action)
            if not buckets[key]:
                raise ValueError("missing action record for queue expansion: " + str(key))
            record = buckets[key].popleft()
            action = record["action"]
            output_id = record.get("result_graph_id")
            duplicate = output_id in seen_best if record["accepted"] else False
            if bool(record.get("duplicate_state", False)) != duplicate:
                raise ValueError("duplicate-state marker disagrees with queue reconstruction")
            row = {
                "schema": LEDGER_SCHEMA,
                "protocol": protocol,
                "record_provenance": "chronology_reconstructed_from_source_manifest_buckets",
                "input_semantic_graph_id": graph_id,
                "input_witness_available": witness_available,
                "action_name": action["kind"],
                "action_parameters": {"tile_size": action["tile_size"]} if action.get("tile_size") is not None else {},
                "rewrite_order": [_normalized_action(item) for item in history],
                "rewrite_depth": record["depth"],
                "attempt_index": len(rows),
                "legality_result": "accepted" if record["accepted"] else "rejected",
                "rejection_reason": record.get("reason_code"),
                "output_semantic_graph_id": output_id,
                "canonicalized_to_existing_graph": duplicate,
                "materialization_result": "not_part_of_attempt_count",
                "input_k_mode": candidate["k_policy"] if candidate else "unavailable_in_manifest",
                "input_fusion_mode": _fusion_mode(candidate),
            }
            rows.append(row)
            if not record["accepted"]:
                continue
            next_history = history + [action]
            next_executable = witness_available and action["executable"]
            if not duplicate or (next_executable and not seen_best[output_id]):
                seen_best[output_id] = next_executable
                queue.append((output_id, depth + 1, next_executable, next_history))
    if any(buckets.values()):
        raise ValueError("unconsumed source action records")
    if len(rows) != statistics["action_attempts"] or len(seen_best) != statistics["unique_graph_states"]:
        raise ValueError("queue reconstruction disagrees with source statistics")
    if any(seen_best[candidate_id] != candidate["witness"]["executable"]
           for candidate_id, candidate in candidates.items()):
        raise ValueError("reconstructed witness preference differs from candidates")
    return rows


def _counter(rows, field):
    return dict(sorted(Counter(row[field] if row[field] is not None else "unknown"
                               for row in rows).items(), key=lambda item: str(item[0])))


def groups(rows):
    return {field: _counter(rows, field) for field in (
        "action_name", "input_k_mode", "input_fusion_mode", "rewrite_depth",
        "legality_result", "rejection_reason", "input_witness_available",
        "input_semantic_graph_id", "output_semantic_graph_id",
        "canonicalized_to_existing_graph", "materialization_result")}


def compare(old, current, old_manifest, current_manifest):
    old_counts = Counter(action_key(row) for row in old)
    new_counts = Counter(action_key(row) for row in current)
    added = new_counts - old_counts
    removed = old_counts - new_counts
    old_input_counts = Counter(row["input_semantic_graph_id"] for row in old)
    new_input_counts = Counter(row["input_semantic_graph_id"] for row in current)
    old_missing = {c["graph_id"] for c in old_manifest["candidates"]
                   if not c["witness"]["executable"]}
    extra_by_input = {key: new_input_counts[key] - old_input_counts[key]
                      for key in sorted(set(old_input_counts) | set(new_input_counts))
                      if new_input_counts[key] != old_input_counts[key]}
    added_rows = []
    current_by_key = defaultdict(list)
    for row in current:
        current_by_key[action_key(row)].append(row)
    for key, count in added.items():
        # Extra rows are later queue visits to already recorded input/actions.
        # Keep the added visit's witness lineage, not the first occurrence.
        added_rows.extend(current_by_key[key][-count:])
    old_unique = {semantic_action_key(row) for row in old}
    new_unique = {semantic_action_key(row) for row in current}
    return {
        "schema": "orbit-action-count-diff-v1",
        "old_attempts": len(old), "current_attempts": len(current),
        "added_record_occurrences": sum(added.values()),
        "removed_record_occurrences": sum(removed.values()),
        "old_unique_input_action_pairs": len(old_unique),
        "current_unique_input_action_pairs": len(new_unique),
        "new_input_action_pairs": len(new_unique - old_unique),
        "old_unique_graph_ids": len({c["graph_id"] for c in old_manifest["candidates"]}),
        "current_unique_graph_ids": len({c["graph_id"] for c in current_manifest["candidates"]}),
        "candidate_graph_id_sets_equal":
            {c["graph_id"] for c in old_manifest["candidates"]} ==
            {c["graph_id"] for c in current_manifest["candidates"]},
        "old_missing_witness_ids": sorted(old_missing),
        "extra_by_input_graph": extra_by_input,
        "extra_inputs_equal_old_missing_witnesses": set(extra_by_input) == old_missing,
        "all_extra_actions_on_existing_input_action_pairs": all(
            semantic_action_key(row) in old_unique for row in added_rows),
        "added_groups": groups(added_rows),
        "old_groups": groups(old), "current_groups": groups(current),
        "difference_classes": [
            {"class": "accepted_existing_output", "old": sum(
                bool(row.get("duplicate_state")) for row in old_manifest["transitions"]),
             "current": sum(bool(row.get("duplicate_state")) for row in current_manifest["transitions"]),
             "delta": sum(bool(row.get("duplicate_state")) for row in current_manifest["transitions"]) -
                      sum(bool(row.get("duplicate_state")) for row in old_manifest["transitions"])},
            {"class": "deterministic_rejection", "old": old_manifest["statistics"]["rejected_transitions"],
             "current": current_manifest["statistics"]["rejected_transitions"],
             "delta": current_manifest["statistics"]["rejected_transitions"] - old_manifest["statistics"]["rejected_transitions"]},
        ],
    }


def same_current_run(left, right):
    """Compare stable C++ output, excluding timing and source file identity."""
    fields = ("action_catalog", "candidate_graph_ids", "transitions", "rejections")
    return all(left[field] == right[field] for field in fields)
