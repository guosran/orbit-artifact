#!/usr/bin/env python3
"""Audit captured fusion/fission search funnels without mutating evidence."""

from __future__ import annotations

import argparse
import collections
import gzip
import json
from pathlib import Path
from typing import Any, Iterable


WORKLOADS = ("llama", "lu", "harris", "radar", "gcn", "raytracing")
STAGES = {
    "S3": "shape-temporal-replica-tiling",
    "S4": "full-joint",
    "S5": "full-joint-fission",
}
FUSION_PRIMITIVES = {"fusion", "sibling-fusion"}
FUSION_FAMILIES = {"fusion", "sibling-fusion"}
FISSION_PRIMITIVES = {"fission"}
FISSION_FAMILIES = {"fission"}
CO_TILING_FAMILIES = {
    "producer-consumer-co-tiling",
    "producer-consumer-co-k-tiling",
}
CO_TILING_PRIMITIVES = {"tile", "k-tile", "k_tiling", "k-tiling"}
FAMILY_NAMES = ("fusion", "co_tiling", "fission")


def load_json(path: Path) -> Any:
    return json.loads(path.read_text())


def load_jsonl(path: Path) -> list[dict[str, Any]]:
    return [json.loads(line) for line in path.read_text().splitlines() if line.strip()]


def read_if_present(path: Path) -> Any | None:
    return load_json(path) if path.is_file() else None


def load_checkpoint(stage_dir: Path) -> tuple[dict[str, Any] | None, str | None]:
    """Prefer the live JSON checkpoint, then its retained gzip snapshot."""
    plain = stage_dir / "checkpoint.json"
    compressed = stage_dir / "checkpoint.json.gz"
    if plain.is_file():
        return load_json(plain), plain.name
    if compressed.is_file():
        with gzip.open(compressed, "rt", encoding="utf-8") as stream:
            return json.load(stream), compressed.name
    return None, None


def cleanup_receipt_summary(stage_dir: Path) -> dict[str, Any]:
    path = stage_dir / "temporary-cleanup-receipt.json"
    if not path.is_file():
        return {"status": "unknown_cleanup_receipt_missing", "source": None}
    receipt = load_json(path)
    deleted = receipt.get("deleted", []) if isinstance(receipt, dict) else []
    archive_deleted = [
        {"path_basename": Path(item.get("path", "")).name, "bytes": item.get("bytes"), "category": item.get("category")}
        for item in deleted
        if isinstance(item, dict) and Path(item.get("path", "")).name == "archive.journal.jsonl"
    ]
    return {
        "status": receipt.get("status"),
        "phase": receipt.get("phase"),
        "search_exit_code": receipt.get("search_exit_code"),
        "deleted_count": receipt.get("deleted_count"),
        "archive_journal_deleted_entries": archive_deleted,
        "archive_journal_deleted_count": len(archive_deleted),
        "source": path.name,
    }


def first(mapping: dict[str, Any], *keys: str, default: Any = None) -> Any:
    for key in keys:
        if key in mapping and mapping[key] is not None:
            return mapping[key]
    return default


def history(candidate: dict[str, Any] | None) -> dict[str, Any]:
    if not candidate:
        return {}
    value = first(candidate, "action_history", "actionHistory", default={})
    return value if isinstance(value, dict) else {}


def ordinary_actions(candidate: dict[str, Any] | None) -> list[dict[str, Any]]:
    actions = first(history(candidate), "actions", default=[])
    return actions if isinstance(actions, list) else []


def typed_fissions(candidate: dict[str, Any] | None) -> list[Any]:
    actions = first(history(candidate), "fissionActions", "fission_actions", default=[])
    return actions if isinstance(actions, list) else []


def action_family(action: dict[str, Any]) -> str:
    value = first(action, "family", "action_family", "actionFamily", default="unknown")
    return str(value).strip().lower().replace("_", "-")


def primitive_kinds(action: dict[str, Any]) -> list[str]:
    primitives = first(action, "primitives", "typed_primitives", "typedPrimitives", default=[])
    if not isinstance(primitives, list):
        return []
    kinds: list[str] = []
    for primitive in primitives:
        if not isinstance(primitive, dict):
            continue
        value = first(primitive, "kind", "primitive_kind", "primitiveKind", default=None)
        if value is not None:
            kinds.append(str(value).strip().lower().replace("_", "-"))
    return kinds


def classify_action(action: dict[str, Any]) -> set[str]:
    """Return semantic action classes using typed primitive kinds first.

    Co-tiling family names intentionally do not imply fusion. Combined actions
    count as fusion only when their typed primitive list contains a fusion
    primitive (or their exact family is the dedicated fusion family).
    """
    family = action_family(action)
    kinds = set(primitive_kinds(action))
    result: set[str] = set()

    if kinds & FUSION_PRIMITIVES or family in FUSION_FAMILIES:
        result.add("fusion")
    if kinds & FISSION_PRIMITIVES or family in FISSION_FAMILIES:
        result.add("fission")
    if family in CO_TILING_FAMILIES and kinds and kinds <= CO_TILING_PRIMITIVES:
        result.add("co_tiling")
    return result


def family_presence(candidate: dict[str, Any] | None) -> dict[str, bool]:
    actions = ordinary_actions(candidate)
    classes = set().union(*(classify_action(action) for action in actions)) if actions else set()
    return {
        "fusion": "fusion" in classes,
        "co_tiling": "co_tiling" in classes,
        "fission": "fission" in classes or bool(typed_fissions(candidate)),
    }


def count_dict(values: Iterable[str]) -> dict[str, int]:
    return dict(sorted(collections.Counter(values).items()))


def candidate_compact(candidate: dict[str, Any], index: int | None = None) -> dict[str, Any]:
    actions = ordinary_actions(candidate)
    action_rows = []
    all_classes: set[str] = set()
    for action in actions:
        classes = sorted(classify_action(action))
        all_classes.update(classes)
        action_rows.append({
            "family": action_family(action),
            "label": first(action, "label", default=None),
            "primitive_kinds": primitive_kinds(action),
            "semantic_classes": classes,
        })
    typed = typed_fissions(candidate)
    if typed:
        all_classes.add("fission")
    return {
        "candidate_id": first(candidate, "candidate_id", "candidateId", default=None),
        "rank": first(candidate, "rank", "global_rank", "globalRank", default=index),
        "round": first(candidate, "round", default=None),
        "predicted_whole_program_cycles": first(
            candidate, "predicted_whole_program_cycles", "predictedWholeProgramCycles", "predicted_cycles", default=None
        ),
        "ordinary_action_families": count_dict(action_family(action) for action in actions),
        "ordinary_primitive_kinds": count_dict(kind for action in actions for kind in primitive_kinds(action)),
        "ordinary_action_count": len(actions),
        "typed_fissionActions_count": len(typed),
        "typed_fissionActions": typed,
        "semantic_family_presence": {name: name in all_classes for name in FAMILY_NAMES},
        "ordinary_actions": action_rows,
    }


def status_value(value: Any, status: str, **extra: Any) -> dict[str, Any]:
    return {"value": value, "status": status, **extra}


def identity_parent_indices(checkpoint: dict[str, Any]) -> list[int]:
    beam = checkpoint.get("beam", [])
    if not isinstance(beam, list):
        return []
    return [
        i for i, candidate in enumerate(beam)
        if isinstance(candidate, dict)
        and first(candidate, "candidate_id", "candidateId") == "neighborhood-0"
        and not ordinary_actions(candidate)
        and not typed_fissions(candidate)
    ]


def captured_menu(checkpoint: dict[str, Any] | None) -> dict[str, Any]:
    if not checkpoint:
        return {"status": "unknown_checkpoint_missing", "entry_count": None, "family_counts": None}
    queue = checkpoint.get("pending_neighbors", [])
    if not isinstance(queue, list):
        return {"status": "unknown_pending_menu_malformed", "entry_count": None, "family_counts": None}
    cursor = first(checkpoint, "pending_action_cursor", "pendingActionCursor", default=None)
    parents = identity_parent_indices(checkpoint)
    if not parents:
        return {
            "status": "unknown_identity_parent_not_in_checkpoint_beam",
            "entry_count": None,
            "pending_queue_entry_count": len(queue),
            "pending_action_cursor": cursor,
        }
    parent_set = set(parents)
    rows = [
        (i, row) for i, row in enumerate(queue)
        if isinstance(row, dict) and first(row, "parent", "parent_index", "parentIndex") in parent_set
    ]
    family_counts: collections.Counter[str] = collections.Counter()
    kind_counts: collections.Counter[str] = collections.Counter()
    class_counts: collections.Counter[str] = collections.Counter()
    before = collections.Counter()
    after = collections.Counter()
    class_before = collections.Counter()
    class_after = collections.Counter()
    family_kind_counts: dict[str, collections.Counter[str]] = collections.defaultdict(collections.Counter)
    for index, row in rows:
        action = first(row, "action", default={})
        action = action if isinstance(action, dict) else {}
        fam = action_family(action)
        kinds = primitive_kinds(action)
        classes = classify_action(action)
        family_counts[fam] += 1
        kind_counts.update(kinds)
        family_kind_counts[fam].update(kinds)
        class_counts.update(classes)
        if isinstance(cursor, int):
            target = before if index < cursor else after
            target[fam] += 1
            class_target = class_before if index < cursor else class_after
            class_target.update(classes)
    return {
        "status": "captured_pending_menu_snapshot",
        "identity_parent_indices": parents,
        "pending_queue_entry_count": len(queue),
        "entry_count": len(rows),
        "pending_action_cursor": cursor,
        "family_counts": dict(sorted(family_counts.items())),
        "primitive_kind_counts": dict(sorted(kind_counts.items())),
        "family_primitive_kind_counts": {
            family: dict(sorted(kinds.items())) for family, kinds in sorted(family_kind_counts.items())
        },
        "semantic_action_class_counts": dict(sorted(class_counts.items())),
        "semantic_action_class_counts_before_cursor": dict(sorted(class_before.items())),
        "semantic_action_class_counts_at_or_after_cursor": dict(sorted(class_after.items())),
        "identity_parent_family_rows_before_cursor": dict(sorted(before.items())),
        "identity_parent_family_rows_at_or_after_cursor": dict(sorted(after.items())),
        "interpretation": "Captured pending-neighbor rows for the canonical identity parent. Cursor position locates action slots only; it does not prove materialization, scoring, or candidate outcome.",
    }


def load_census(census_root: Path, workload: str) -> dict[str, Any]:
    path = census_root / workload / "cut-census.json"
    if not path.is_file():
        return {
            "value": None,
            "status": "unknown_census_missing",
            "source": f"{workload}/cut-census.json",
        }
    data = load_json(path)
    tasks = data.get("tasks", [])
    counts = [task.get("legal_cut_count") for task in tasks if isinstance(task, dict)]
    if any(not isinstance(n, int) for n in counts):
        total = None
        state = "unknown_census_counts_incomplete"
    else:
        total = sum(counts)
        state = "exact"
    return {
        "value": total,
        "status": state,
        "source": f"{workload}/cut-census.json",
        "schema": data.get("schema"),
        "census_status": data.get("status"),
        "mapper_invoked": data.get("mapper_invoked"),
        "nonzero_tasks": [
            {"task": task.get("task"), "legal_cut_count": task.get("legal_cut_count"), "status": task.get("status")}
            for task in tasks if isinstance(task, dict) and task.get("legal_cut_count", 0)
        ],
    }


def find_funnel_log_paths(stage_dir: Path) -> tuple[list[Path], list[Path]]:
    if not stage_dir.is_dir():
        return [], []
    jsonl_paths = sorted(stage_dir.rglob("family-funnel.jsonl"))
    summary_paths = sorted(
        path for path in stage_dir.rglob("family-funnel-summary*.json")
        if path.is_file()
    )
    return jsonl_paths, summary_paths


def deep_lookup(mapping: dict[str, Any], keys: tuple[str, ...]) -> tuple[Any, str | None]:
    """Find the first named metric in nested new-log summary shapes."""
    wanted = {key.lower().replace("-", "_") for key in keys}
    stack: list[tuple[Any, str]] = [(mapping, "")]
    while stack:
        value, pointer = stack.pop()
        if isinstance(value, dict):
            for key, child in value.items():
                normalized = str(key).lower().replace("-", "_")
                child_pointer = f"{pointer}/{key}"
                if normalized in wanted:
                    return child, child_pointer
                stack.append((child, child_pointer))
        elif isinstance(value, list):
            for index, child in enumerate(value):
                stack.append((child, f"{pointer}/{index}"))
    return None, None


def normalize_metric_from_summary(summary: dict[str, Any], keys: tuple[str, ...], name: str) -> dict[str, Any]:
    value, pointer = deep_lookup(summary, keys)
    if value is None:
        return status_value(None, "unknown_not_emitted", source_pointer=None)
    if isinstance(value, (int, float)):
        return status_value(value, "logged_exact", source_pointer=pointer)
    return status_value(value, "logged_source_value", source_pointer=pointer)


def compact_round_family_row(row: dict[str, Any], source_path: str, line_number: int) -> dict[str, Any]:
    metric_names = {key for aliases in METRIC_KEYS.values() for key in aliases}
    compact = {
        "record_type": first(row, "record_type", "row_type", default=None),
        "round": row.get("round"),
        "action_family": first(row, "action_family", "actionFamily", "family", default=None),
        "current_edge_semantics": first(row, "current_edge_semantics", "currentEdgeSemantics", default=None),
        "source_ref": {"file": source_path, "line": line_number},
        "binding": row.get("binding"),
    }
    for key in metric_names | {"reject_reasons"}:
        if key in row and key != "pending_unattempted":
            compact[key] = row[key]
    pending = first(row, "pending_unattempted", default=None)
    if isinstance(pending, list):
        compact["pending_unattempted_count"] = len(pending)
    elif pending is not None:
        compact["pending_unattempted_count"] = pending
    signatures = first(row, "pending_unattempted_action_signatures", default=[])
    if isinstance(signatures, list):
        compact["pending_unattempted_action_signature_count"] = len(signatures)
        compact["pending_unattempted_action_signatures_sample"] = signatures[:5]
    return compact


def compact_typed_path_presence_row(row: dict[str, Any], source_path: str, line_number: int) -> dict[str, Any]:
    compact = {
        "record_type": first(row, "record_type", "row_type", default=None),
        "round": row.get("round"),
        "family": first(row, "family", "action_family", "actionFamily", default=None),
        "source_ref": {"file": source_path, "line": line_number},
    }
    for key in ("scored", "beam", "archive", "top5", "global_ranks", "best"):
        if key in row:
            compact[key] = row[key]
    for key in ("scored_candidate_ids", "beam_candidate_ids", "archive_candidate_ids"):
        ids = row.get(key)
        if isinstance(ids, list):
            compact[f"{key}_count"] = len(ids)
            compact[f"{key}_sample"] = ids[:20]
    top_candidates = row.get("top5_candidates")
    if isinstance(top_candidates, list):
        compact["top5_candidates"] = top_candidates[:5]
    return compact


METRIC_KEYS = {
    "menu_generated": ("menu", "menu_count", "menu_rows"),
    "generated_complete_candidates": ("generated", "generated_candidates", "generated_candidate_count"),
    "attempted": ("attempted", "attempt_count", "attempts"),
    "successful_materializations": ("materialized", "materialized_count", "apply"),
    "materializer_rejects": ("reject", "rejected", "reject_count"),
    "cost_preparation_attempted": ("cost_preparation_attempted",),
    "fresh_cost_prepared": ("fresh_cost_prepared",),
    "fresh_cost_scored": ("fresh_cost_scored", "fresh_cost", "cost"),
    "cache_reused": ("cache", "cache_reused", "cached_cost_reused"),
    "unique": ("unique", "unique_candidates", "unique_count"),
    "duplicates": ("duplicate", "duplicates", "duplicate_count"),
    "scheduler_calls": ("scheduler_calls", "scheduler_call_count", "production_scheduler_calls"),
    "scheduler_pass": ("scheduler_pass",),
    "scheduler_reject": ("scheduler_reject",),
    "archive": ("archive", "archive_count", "archived"),
    "pending_unattempted": ("pending_unattempted", "pending_remaining", "pending_count", "remaining_pending"),
}


def summarize_new_logs(stage_dir: Path) -> dict[str, Any] | None:
    event_paths, summary_paths = find_funnel_log_paths(stage_dir)
    if not event_paths and not summary_paths:
        return None
    rows: list[dict[str, Any]] = []
    row_sources: list[tuple[str, int, dict[str, Any]]] = []
    for path in event_paths:
        try:
            for line_number, line in enumerate(path.read_text().splitlines(), start=1):
                if not line.strip():
                    continue
                row = json.loads(line)
                if isinstance(row, dict):
                    rows.append(row)
                    row_sources.append((str(path), line_number, row))
        except (OSError, json.JSONDecodeError):
            continue
    summaries: list[tuple[Path, dict[str, Any]]] = []
    for path in summary_paths:
        try:
            data = load_json(path)
        except (OSError, json.JSONDecodeError):
            continue
        if isinstance(data, dict):
            summaries.append((path, data))

    by_family: dict[str, dict[str, Any]] = {}
    summary_families: set[str] = set()
    path_presence_by_family: dict[str, dict[str, Any]] = {}
    round_path_presence_rows: dict[str, list[dict[str, Any]]] = collections.defaultdict(list)
    for path, summary in summaries:
        raw_families = first(
            summary,
            "current_edge_by_family",
            "currentEdgeByFamily",
            "families",
            "family_counters",
            "familyCounters",
            default=None,
        )
        if isinstance(raw_families, dict):
            for family, counters in raw_families.items():
                if isinstance(counters, dict):
                    family_key = str(family).lower().replace("_", "-")
                    target = by_family.setdefault(family_key, {})
                    target.update(counters)
                    target.setdefault("_summary_path", str(path))
                    summary_families.add(family_key)
        raw_presence = first(
            summary,
            "typed_path_presence_by_family",
            "typedPathPresenceByFamily",
            "path_presence_by_family",
            "pathPresenceByFamily",
            default=None,
        )
        if isinstance(raw_presence, dict):
            for family, presence in raw_presence.items():
                if isinstance(presence, dict):
                    target = path_presence_by_family.setdefault(str(family).lower().replace("_", "-"), {})
                    target.update(presence)
                    target.setdefault("_summary_path", str(path))
    # Aggregate rows are also accepted directly in JSONL. Event rows remain
    # available below, but are never confused with whole-path candidate counts.
    round_rows: dict[str, list[dict[str, Any]]] = collections.defaultdict(list)
    for row in rows:
        row_type = str(first(row, "record_type", "row_type", "kind", default="")).lower().replace("_", "-")
        family = first(row, "action_family", "actionFamily", "family", default=None)
        counters = first(row, "current_edge_counters", "currentEdgeCounters", "counters", default=None)
        if family is not None and not isinstance(counters, dict) and "round-family" in row_type:
            counters = row
        if family is not None and isinstance(counters, dict) and "round-family" in row_type:
            round_rows[str(family).lower().replace("_", "-")].append(counters)
        if family is not None and "typed-path-presence" in row_type:
            round_path_presence_rows[str(family).lower().replace("_", "-")].append(row)

    for family_key, family_rows in round_rows.items():
        if family_key in summary_families:
            continue
        aggregate: dict[str, Any] = {"_event_log_path": str(event_paths[0]) if event_paths else None}
        additive_keys = {key for keys in METRIC_KEYS.values() for key in keys}
        for row in family_rows:
            for key, value in row.items():
                if key in additive_keys and isinstance(value, (int, float)):
                    aggregate[key] = aggregate.get(key, 0) + value
                elif key == "reject_reasons" and isinstance(value, dict):
                    reasons = aggregate.setdefault(key, {})
                    for reason, count in value.items():
                        if isinstance(count, (int, float)):
                            reasons[reason] = reasons.get(reason, 0) + count
                elif key in {"pending_unattempted", "pending_unattempted_action_signatures"}:
                    aggregate[key] = value
        by_family[family_key] = aggregate

    attempt_event_metrics: dict[str, collections.Counter[str]] = collections.defaultdict(collections.Counter)
    attempt_reject_reasons: dict[str, collections.Counter[str]] = collections.defaultdict(collections.Counter)
    event_index: dict[str, dict[str, Any]] = {}
    for source_path, line_number, row in row_sources:
        row_type = str(first(row, "record_type", "row_type", "kind", default="")).lower().replace("_", "-")
        family = first(row, "action_family", "actionFamily", "family", default=None)
        if family is None:
            continue
        family_key = str(family).lower().replace("_", "-")
        if "candidate-attempt" not in row_type:
            continue
        result = row.get("result") if isinstance(row.get("result"), dict) else {}
        index = event_index.setdefault(family_key, {
            "candidate_attempt_rows": 0,
            "source_files": [],
            "source_line_first": line_number,
            "source_line_last": line_number,
            "source_line_samples": [],
            "candidate_ids_sample": [],
            "primitive_kind_counts": collections.Counter(),
            "result_flag_counts": collections.Counter(),
        })
        index["candidate_attempt_rows"] += 1
        if source_path not in index["source_files"]:
            index["source_files"].append(source_path)
        index["source_line_first"] = min(index["source_line_first"], line_number)
        index["source_line_last"] = max(index["source_line_last"], line_number)
        if len(index["source_line_samples"]) < 20:
            index["source_line_samples"].append(line_number)
        candidate_id = first(row, "candidate_id", "candidateId", default=None)
        if candidate_id is not None and len(index["candidate_ids_sample"]) < 20:
            index["candidate_ids_sample"].append(candidate_id)
        kinds = first(row, "typed_primitive_kinds", "typedPrimitiveKinds", "primitive_kinds", default=[])
        if isinstance(kinds, list):
            index["primitive_kind_counts"].update(str(kind) for kind in kinds)
        for metric in (
            "attempted", "materialized", "unique", "duplicate", "fresh_cost_prepared",
            "cache_reused", "scheduler_calls", "scheduler_pass", "scheduler_reject", "archive",
        ):
            value = result.get(metric)
            if isinstance(value, bool):
                attempt_event_metrics[family_key][metric] += int(value)
                index["result_flag_counts"][f"{metric}={str(value).lower()}"] += 1
            elif isinstance(value, (int, float)):
                attempt_event_metrics[family_key][metric] += value
        reject_reason = first(result, "reject_reason", "rejectReason", default=None)
        if reject_reason:
            attempt_event_metrics[family_key]["reject"] += 1
            attempt_reject_reasons[family_key][str(reject_reason)] += 1
    for family_key, counters in attempt_event_metrics.items():
        if family_key in summary_families or family_key in round_rows:
            continue
        source_counters = dict(counters)
        if attempt_reject_reasons[family_key]:
            source_counters["reject_reasons"] = dict(attempt_reject_reasons[family_key])
        source_counters["_event_log_path"] = event_paths[0] if event_paths else None
        by_family[family_key] = source_counters

    event_counts: collections.Counter[str] = collections.Counter()
    event_values: dict[str, collections.Counter[str]] = collections.defaultdict(collections.Counter)
    for source_path, line_number, row in row_sources:
        row_type = str(first(row, "record_type", "row_type", "kind", default="")).lower().replace("_", "-")
        if "candidate-attempt" not in row_type:
            continue
        family = first(row, "action_family", "actionFamily", "family", default=None)
        if family is None:
            continue
        family_key = str(family).lower().replace("_", "-")
        result = row.get("result") if isinstance(row.get("result"), dict) else {}
        reject_reason = first(result, "reject_reason", "rejectReason", default=None)
        status = "reject" if reject_reason else (
            "materialized" if result.get("materialized") is True else str(first(row, "status", default="attempted"))
        )
        status = status.lower().replace("-", "_")
        event_counts[family_key] += 1
        event_values[family_key][status] += 1

    normalized: dict[str, Any] = {}
    for family, counters in by_family.items():
        metrics = {}
        for name, aliases in METRIC_KEYS.items():
            value, pointer = deep_lookup(counters, aliases)
            if value is None:
                metrics[name] = status_value(None, "unknown_not_emitted", source_pointer=None)
            else:
                metrics[name] = status_value(value, "logged_exact", source_pointer=pointer)
        normalized[family] = {
            "current_edge_metrics": metrics,
            "source_counters": counters,
            "source_paths": {key[1:]: counters[key] for key in ("_summary_path", "_event_log_path") if key in counters},
        }
    normalized_presence = {
        family: {
            "scored": presence.get("scored"),
            "scored_candidate_ids": presence.get("scored_candidate_ids"),
            "beam": presence.get("beam"),
            "beam_candidate_ids": presence.get("beam_candidate_ids"),
            "archive": presence.get("archive"),
            "archive_candidate_ids": presence.get("archive_candidate_ids"),
            "top5": presence.get("top5"),
            "top5_candidates": presence.get("top5_candidates"),
            "global_ranks": presence.get("global_ranks"),
            "best": presence.get("best"),
            "source_path": presence.get("_summary_path"),
            "source_fields": sorted(key for key in presence if not key.startswith("_")),
        }
        for family, presence in path_presence_by_family.items()
    }
    for family_key, path_rows in round_path_presence_rows.items():
        normalized_presence.setdefault(family_key, {})
        normalized_presence[family_key]["round_rows"] = path_rows
    return {
        "status": "new_family_funnel_logs_found",
        "event_log_paths": [str(path) for path in event_paths],
        "summary_paths": [str(path) for path in summary_paths],
        "event_row_count": len(rows),
        "event_row_counts_by_family": dict(sorted(event_counts.items())),
        "event_status_counts_by_family": {family: dict(sorted(counts.items())) for family, counts in sorted(event_values.items())},
        "candidate_attempt_event_index_by_family": {
            family: {
                **index,
                "primitive_kind_counts": dict(sorted(index["primitive_kind_counts"].items())),
                "result_flag_counts": dict(sorted(index["result_flag_counts"].items())),
            }
            for family, index in sorted(event_index.items())
        },
        "round_path_presence_rows_by_family": {
            family: [
                compact_typed_path_presence_row(row, source_path, line_number)
                for source_path, line_number, row in row_sources
                if "typed-path-presence" in str(first(row, "record_type", "row_type", "kind", default="")).lower().replace("_", "-")
                and str(first(row, "family", "action_family", "actionFamily", default="")).lower().replace("_", "-") == family
            ]
            for family in sorted(round_path_presence_rows)
        },
        "current_edge_by_family": normalized,
        "path_presence": {
            "status": "exact_logged_nonadditive_path_presence" if normalized_presence else "unknown_not_emitted",
            "semantics": next((first(summary, "path_presence_semantics", "pathPresenceSemantics", default=None) for _, summary in summaries if first(summary, "path_presence_semantics", "pathPresenceSemantics", default=None)), None),
            "by_family": normalized_presence,
        },
        "raw_round_family_rows": [
            compact_round_family_row(row, source_path, line_number)
            for source_path, line_number, row in row_sources
            if "round-family" in str(first(row, "record_type", "row_type", "kind", default="")).lower().replace("_", "-")
        ],
    }


def presence_counts(candidates: list[dict[str, Any]]) -> dict[str, Any]:
    out: dict[str, Any] = {}
    for family in FAMILY_NAMES:
        matches = [candidate for candidate in candidates if family_presence(candidate).get(family)]
        out[family] = {
            "candidate_count": len(matches),
            "candidate_ids": [first(c, "candidate_id", "candidateId", default=None) for c in matches],
        }
    return out


def family_funnel(
    family: str,
    stage_label: str,
    census: dict[str, Any],
    menu: dict[str, Any],
    checkpoint: dict[str, Any] | None,
    candidates: list[dict[str, Any]],
    top5_native: list[dict[str, Any]],
    controls: list[dict[str, Any]],
    selected_id: Any,
    selected_candidate_source: dict[str, Any] | None,
    logged: dict[str, Any] | None,
    workload: str,
    stage_name: str,
    checkpoint_filename: str | None = None,
) -> dict[str, Any]:
    if family == "fission" and stage_label != "S5":
        legal = status_value(None, "not_applicable_stage_has_no_fission_dimension")
    elif family == "fission":
        legal = census
    else:
        legal = status_value(None, "unknown_no_family_specific_source_census")

    raw_family = "fission" if family == "fission" else (
        "producer-consumer-co-tiling" if family == "co_tiling" else "fusion"
    )
    menu_count = menu.get("semantic_action_class_counts", {}).get(family, 0)
    if menu.get("status") == "captured_pending_menu_snapshot":
        menu_snapshot = status_value(
            menu_count,
            "captured_pending_menu_rows",
            source=f"{workload}/{stage_name}/{checkpoint_filename or 'checkpoint.json[.gz]'}:/pending_neighbors",
            cursor=menu.get("pending_action_cursor"),
            rows_before_cursor=menu.get("semantic_action_class_counts_before_cursor", {}).get(family, 0),
            rows_at_or_after_cursor=menu.get("semantic_action_class_counts_at_or_after_cursor", {}).get(family, 0),
        )
    else:
        menu_snapshot = status_value(None, menu.get("status", "unknown_menu"))

    raw_family_stats = (logged or {}).get("current_edge_by_family", {})
    logged_family = raw_family_stats.get(raw_family)
    # Current-edge action counters are additive across exact typed fusion
    # action families. Path-presence counters below are non-additive.
    edge_family_keys = {
        "fusion": {"fusion", "sibling-fusion", "fusion-plus-shape", "fusion-plus-tiling", "tiling-plus-fusion"},
        "co_tiling": {"producer-consumer-co-tiling", "producer-consumer-co-k-tiling", "co-tiling", "co-tiling-k"},
        "fission": {"fission"},
    }[family]
    if logged:
        matching = [value for key, value in raw_family_stats.items() if key in edge_family_keys]
        if matching:
            merged_metrics = {}
            for metric in METRIC_KEYS:
                vals = [entry["current_edge_metrics"][metric].get("value") for entry in matching]
                if all(isinstance(value, (int, float)) for value in vals):
                    merged_metrics[metric] = status_value(sum(vals), "logged_exact_family_sum")
                else:
                    merged_metrics[metric] = status_value(None, "unknown_incomplete_family_rows")
            logged_family = {"current_edge_metrics": merged_metrics, "source_families": matching}

    stage_metrics = {}
    for name in (
        "menu_generated", "generated_complete_candidates", "attempted", "successful_materializations",
        "materializer_rejects", "cost_preparation_attempted", "fresh_cost_prepared", "fresh_cost_scored",
        "cache_reused", "unique", "duplicates", "scheduler_calls", "scheduler_pass", "scheduler_reject",
        "archive", "pending_unattempted",
    ):
        if logged_family:
            stage_metrics[name] = logged_family["current_edge_metrics"].get(name, status_value(None, "unknown_not_emitted"))
        elif name == "menu_generated":
            stage_metrics[name] = status_value(None, "unknown_historical_total_not_retained")
        else:
            stage_metrics[name] = status_value(None, "unknown_r9_per_family_event_log_absent")

    beam = checkpoint.get("beam", []) if checkpoint else []
    beam = beam if isinstance(beam, list) else []
    beam_hits = [candidate for candidate in beam if family_presence(candidate).get(family)]
    top_hits = [candidate for candidate in candidates if family_presence(candidate).get(family)]
    family_native = [record for record in top5_native if first(record, "candidate_id", "candidateId", default=None) in {first(c, "candidate_id", "candidateId", default=None) for c in top_hits}]
    selected_candidate = selected_candidate_source or next(
        (candidate for candidate in candidates if first(candidate, "candidate_id", "candidateId", default=None) == selected_id),
        None,
    )
    selected_control = next(
        (record for record in controls if first(record, "candidate_id", "candidateId", default=None) == selected_id),
        None,
    )
    presence_by_family = (logged or {}).get("path_presence", {}).get("by_family", {})
    accepted_presence_keys = {
        "fusion": {"fusion", "sibling-fusion", "fusion-plus-shape", "fusion-plus-tiling", "tiling-plus-fusion"},
        "co_tiling": {"producer-consumer-co-tiling", "producer-consumer-co-k-tiling", "co-tiling", "co_tiling"},
        "fission": {"fission"},
    }[family]
    matching_presence = [entry for key, entry in presence_by_family.items() if key in accepted_presence_keys]

    def logged_presence_count(count_key: str, ids_key: str) -> dict[str, Any]:
        if not matching_presence:
            return status_value(None, "unknown_r9_family_archive_not_captured")
        ids = sorted({value for entry in matching_presence for value in (entry.get(ids_key) or [])})
        values = [entry.get(count_key) for entry in matching_presence]
        if len(values) == 1 and isinstance(values[0], (int, float)):
            return status_value(values[0], "logged_exact_nonadditive_presence", candidate_ids=ids)
        if ids:
            return status_value(len(ids), "derived_unique_candidate_ids", candidate_ids=ids)
        return status_value(None, "unknown_nonadditive_counts_without_candidate_ids")
    logged_top5 = next((entry for entry in matching_presence if entry.get("top5_candidates") is not None), None)
    new_log_refs = []
    if logged:
        for key in ("event_log_paths", "summary_paths"):
            for path in logged.get(key, []):
                path_text = Path(path).as_posix()
                marker = f"{workload}/{stage_name}/"
                relative = path_text.split(marker, 1)[1] if marker in path_text else path_text
                new_log_refs.append({"file": f"{workload}/{stage_name}/{relative}", "json_pointer": "/", "purpose": f"new {key.replace('_paths', '').replace('_', ' ')} evidence"})
    return {
        "family": family,
        "legal_action_census": legal,
        "captured_pending_menu_snapshot": menu_snapshot,
        "funnel_counts": stage_metrics,
        "dedup_and_beam": {
            "family_specific_duplicate_disposition": status_value(None, "unknown_r9_per_family_history_absent"),
            "final_checkpoint_beam_path_presence": status_value(
                len(beam_hits), "exact_checkpoint_snapshot", candidate_ids=[first(c, "candidate_id", "candidateId") for c in beam_hits]
            ),
        },
        "global_search_top5": {
            "candidate_count": len(top_hits),
            "candidate_ids": [first(candidate, "candidate_id", "candidateId", default=None) for candidate in top_hits],
            "source": f"{workload}/{stage_name}/result.json:/top5",
        },
        "native_global_top5": {
            "candidate_count": len(family_native),
            "records": family_native,
            "note": "Native top-five candidates are reported separately from native controls.",
        },
        "native_top5_numeric_and_trace": {
            "numeric_pass_count": sum(record.get("numeric") == "pass" for record in family_native),
            "independent_trace_pass_count": sum(record.get("independent_trace") == "pass" for record in family_native),
        },
        "native_controls": {
            "selected_control_contains_family": family_presence(selected_candidate).get(family) if selected_candidate and selected_control else None,
            "selected_control_candidate_id": first(selected_control or {}, "candidate_id", "candidateId", default=None),
            "candidate_count_all_controls": len(controls),
            "kept_out_of_global_top5_count": len(controls),
        },
        "final_selected": {
            "candidate_id": selected_id,
            "contains_family": family_presence(selected_candidate).get(family) if selected_candidate else None,
            "source": f"{workload}/{stage_name}/previous-winner.jsonl:line 1" if selected_id is not None else None,
            "native_top5_record": next((record for record in family_native if first(record, "candidate_id", "candidateId") == selected_id), None),
            "native_control_record": selected_control,
        },
        "path_presence_counts": {
            "scored_candidates": logged_presence_count("scored", "scored_candidate_ids"),
            "beam_entries_logged": logged_presence_count("beam", "beam_candidate_ids"),
            "checkpoint_final_beam_entries": status_value(len(beam_hits), "exact_checkpoint_beam_snapshot", candidate_ids=[first(c, "candidate_id", "candidateId") for c in beam_hits]),
            "archive_entries": logged_presence_count("archive", "archive_candidate_ids"),
            "global_top5": status_value(len(top_hits), "exact_result_top5_snapshot", candidate_ids=[first(c, "candidate_id", "candidateId") for c in top_hits]),
            "logged_global_ranks": [entry.get("global_ranks") for entry in matching_presence if entry.get("global_ranks") is not None],
            "logged_top5_candidates": logged_top5.get("top5_candidates") if logged_top5 else None,
            "logged_best": logged_top5.get("best") if logged_top5 else None,
        },
        "new_event_log_family_metrics": logged_family,
        "source_refs": [
            {"file": f"{workload}/{stage_name}/result.json", "json_pointer": "/top5", "purpose": "typed global search top-five paths"},
            {"file": f"{workload}/{stage_name}/search/search-summary.json", "json_pointer": "/reject_reasons and /stop_reason", "purpose": "aggregate search counts; rejection reasons remain family agnostic"},
            {"file": f"{workload}/{stage_name}/{checkpoint_filename or 'checkpoint.json[.gz]'}", "json_pointer": "/pending_neighbors and /pending_action_cursor", "purpose": "captured pending menu and cursor"},
            {"file": f"{workload}/{stage_name}/temporary-cleanup-receipt.json", "json_pointer": "/deleted", "purpose": "cleanup status and archive journal deletion evidence"},
            {"file": f"{workload}/{stage_name}/previous-winner.jsonl", "json_pointer": "/candidate_id and /action_history", "purpose": "final selected path"},
            {"file": f"{workload}/{stage_name}/native-top5/summary.json", "json_pointer": "/records", "purpose": "native global top-five mapper/numeric/trace results"},
            {"file": f"{workload}/{stage_name}/native-controls/summary.json", "json_pointer": "/records", "purpose": "separate controls"},
        ] + ([{"file": census["source"], "json_pointer": "/tasks/*/legal_cut_count", "purpose": "source-owned legal fission cut census"}] if family == "fission" and stage_label == "S5" else []) + new_log_refs,
    }


def compact_native_record(record: dict[str, Any], role: str, index: int) -> dict[str, Any]:
    command = record.get("mapper_command") or record.get("native_command") or {}
    argv = command.get("argv", []) if isinstance(command, dict) else []
    return {
        "candidate_id": first(record, "candidate_id", "candidateId", default=None),
        "rank": first(record, "rank", "global_rank", "globalRank", default=index),
        "record_role": role,
        "status": record.get("status"),
        "native_cycles": record.get("native_cycles"),
        "predicted_cycles": record.get("predicted_cycles"),
        "mapper_equality": record.get("mapper_equality"),
        "numeric": record.get("numeric"),
        "independent_trace": record.get("independent_trace"),
        "numeric_command_exit_code": record.get("numeric_command_exit_code"),
        "numeric_evidence": record.get("numeric_evidence"),
        "mapped_mlir": argv[-1] if argv else None,
    }


def build_stage(
    results_root: Path,
    census_root: Path,
    workload: str,
    stage_label: str,
) -> dict[str, Any]:
    stage_name = STAGES[stage_label]
    stage_dir = results_root / workload / stage_name
    result_path = stage_dir / "result.json"
    result = read_if_present(result_path) or {}
    search_summary_path = stage_dir / "search" / "search-summary.json"
    search_summary = read_if_present(search_summary_path) or {}
    checkpoint, checkpoint_filename = load_checkpoint(stage_dir)
    top5_path = stage_dir / "search" / "top5.jsonl"
    top5_jsonl = load_jsonl(top5_path) if top5_path.is_file() else []
    candidates = result.get("top5", []) if isinstance(result.get("top5", []), list) else []
    if not candidates:
        candidates = [row for row in top5_jsonl if first(row, "record_type") in (None, "top5")]
    candidates = [candidate for candidate in candidates if isinstance(candidate, dict)]

    top5_summary_path = stage_dir / "native-top5" / "summary.json"
    control_summary_path = stage_dir / "native-controls" / "summary.json"
    top5_summary = read_if_present(top5_summary_path) or {}
    control_summary = read_if_present(control_summary_path) or {}
    native_top5 = [compact_native_record(record, "native_global_top5", i) for i, record in enumerate(top5_summary.get("records", []))]
    controls = [compact_native_record(record, "native_control", i) for i, record in enumerate(control_summary.get("records", []))]

    previous_path = stage_dir / "previous-winner.jsonl"
    previous_rows = load_jsonl(previous_path) if previous_path.is_file() else []
    previous = previous_rows[0] if previous_rows else None
    selected_id = first(previous or {}, "candidate_id", "candidateId", default=None)
    menu = captured_menu(checkpoint)
    census = load_census(census_root, workload)
    new_logs = summarize_new_logs(stage_dir)
    families = {
        family: family_funnel(
            family,
            stage_label,
            census,
            menu,
            checkpoint,
            candidates,
            native_top5,
            controls,
            selected_id,
            previous,
            new_logs,
            workload,
            stage_name,
            checkpoint_filename,
        )
        for family in FAMILY_NAMES
    }
    search_header = result.get("search_header") if isinstance(result.get("search_header"), dict) else {}
    search_footer = result.get("search_footer") if isinstance(result.get("search_footer"), dict) else {}
    search_fields = (
        "stage", "max_candidates", "max_rounds", "beam_width", "diversity_slots",
        "unique_complete_candidates_scored", "unique_scored_candidates", "unique_valid_candidates",
        "rounds_completed", "rounds", "stop_reason", "production_scheduler_calls",
        "rejected_or_duplicate_candidates", "reject_reasons", "native_shortlist_count",
        "native_top5_required", "previous_winner_requested", "status",
    )
    checkpoint_cursor = first(checkpoint or {}, "pending_action_cursor", "pendingActionCursor", default=None)
    archive_local_path = stage_dir / "search" / "archive.journal.jsonl"
    return {
        "stage_label": stage_label,
        "stage_name": stage_name,
        "stage_directory": f"{workload}/{stage_name}",
        "result_status": result.get("status"),
        "actual_stage_cycles": result.get("actual_stage_cycles"),
        "actual_stage_cycle_source": result.get("actual_stage_cycle_source"),
        "search": {
            "header": {key: search_header[key] for key in search_fields if key in search_header},
            "footer": {key: search_footer[key] for key in search_fields if key in search_footer},
            "summary": {
                key: search_summary.get(key)
                for key in (
                    "stage", "max_candidates", "max_rounds", "beam_width", "diversity_slots",
                    "unique_complete_candidates_scored", "unique_scored_candidates", "rounds_completed",
                    "rounds", "stop_reason", "production_scheduler_calls", "rejected_or_duplicate_candidates",
                    "reject_reasons", "native_shortlist_count", "native_top5_required", "status",
                ) if key in search_summary
            },
            "checkpoint": {
                "source": f"{workload}/{stage_name}/{checkpoint_filename}" if checkpoint_filename else None,
                "round": first(checkpoint or {}, "round", default=None),
                "stop_reason": first(checkpoint or {}, "stop_reason", default=None),
                "scored_candidates": first(checkpoint or {}, "scored_candidates", default=None),
                "duplicate_candidates": first(checkpoint or {}, "duplicate_candidates", default=None),
                "rejected_candidates": first(checkpoint or {}, "rejected_candidates", default=None),
                "production_scheduler_calls": first(checkpoint or {}, "production_scheduler_calls", default=None),
                "pending_action_cursor": checkpoint_cursor,
                "pending_neighbor_count": len((checkpoint or {}).get("pending_neighbors", [])),
                "generated_snapshot_count": len((checkpoint or {}).get("generated", [])),
                "beam_snapshot_count": len((checkpoint or {}).get("beam", [])),
                "archive_count": first(checkpoint or {}, "archive_count", default=None),
                "archive_journal_bytes": first(checkpoint or {}, "archive_journal_bytes", default=None),
                "archive_journal_reference": first(checkpoint or {}, "archive_journal_path", default=None),
                "archive_journal_captured_at_stage_relative_path": archive_local_path.is_file(),
            },
            "cleanup_receipt": cleanup_receipt_summary(stage_dir),
            "captured_identity_parent_action_menu": menu,
            "archive_note": "Aggregate rejection and duplicate counters are family agnostic and are not attributed to fusion, co-tiling, or fission.",
        },
        "global_search_top5": {
            "count": len(candidates),
            "candidates": [candidate_compact(candidate, i) for i, candidate in enumerate(candidates)],
            "path_presence_counts": presence_counts(candidates),
            "source": f"{workload}/{stage_name}/result.json:/top5",
        },
        "native_global_top5": {
            "summary_source": f"{workload}/{stage_name}/native-top5/summary.json:/records",
            "record_count": len(native_top5),
            "records": native_top5,
            "mapper_success_count": sum(r.get("status") == "native_replayed" and r.get("mapper_equality") == "pass" for r in native_top5),
            "numeric_pass_count": sum(r.get("numeric") == "pass" for r in native_top5),
            "independent_trace_pass_count": sum(r.get("independent_trace") == "pass" for r in native_top5),
        },
        "native_controls": {
            "summary_source": f"{workload}/{stage_name}/native-controls/summary.json:/records",
            "record_count": len(controls),
            "records": controls,
            "mapper_success_count": sum(r.get("status") == "native_replayed" and r.get("mapper_equality") == "pass" for r in controls),
            "numeric_pass_count": sum(r.get("numeric") == "pass" for r in controls),
            "independent_trace_pass_count": sum(r.get("independent_trace") == "pass" for r in controls),
        },
        "selected": {
            "candidate_id_from_previous_winner": selected_id,
            "source": f"{workload}/{stage_name}/previous-winner.jsonl:line 1" if previous else None,
            "present_in_global_search_top5": selected_id in {first(c, "candidate_id", "candidateId") for c in candidates} if selected_id else False,
            "matches_native_top5_record": selected_id in {r.get("candidate_id") for r in native_top5} if selected_id else False,
            "matches_native_control_record": selected_id in {r.get("candidate_id") for r in controls} if selected_id else False,
            "ordinary_action_families": candidate_compact(previous).get("ordinary_action_families") if previous else None,
            "typed_fissionActions_count": len(typed_fissions(previous)) if previous else None,
            "native_cycle_record": next((r for r in native_top5 + controls if r.get("candidate_id") == selected_id), None),
        },
        "families": families,
        "new_family_funnel_logs": new_logs,
        "evidence_files": {
            "result": f"{workload}/{stage_name}/result.json",
            "search_summary": f"{workload}/{stage_name}/search/search-summary.json",
            "search_top5_jsonl": f"{workload}/{stage_name}/search/top5.jsonl",
            "checkpoint": f"{workload}/{stage_name}/{checkpoint_filename or 'checkpoint.json[.gz]'}",
            "cleanup_receipt": f"{workload}/{stage_name}/temporary-cleanup-receipt.json",
            "previous_winner": f"{workload}/{stage_name}/previous-winner.jsonl",
            "native_top5": f"{workload}/{stage_name}/native-top5/summary.json",
            "native_controls": f"{workload}/{stage_name}/native-controls/summary.json",
            "fission_census": f"{workload}/cut-census.json",
        },
    }


def build_audit(results_root: Path, census_root: Path, audit_label: str | None = None) -> dict[str, Any]:
    workloads: dict[str, Any] = {}
    for workload in WORKLOADS:
        workloads[workload] = {
            label: build_stage(results_root, census_root, workload, label)
            for label in ("S4", "S5")
        }
    return {
        "schema": "orbit-fusion-fission-search-funnel-audit-v2",
        "status": "read-only evidence audit",
        "audit_label": audit_label or results_root.name,
        "results_root": str(results_root.resolve()),
        "census_root": str(census_root.resolve()),
        "binding_portability": "Input paths identify the captured evidence. This audit does not certify that the local runtime binding is reusable from a clean clone.",
        "workloads": workloads,
        "global_findings": summarize_findings(workloads),
    }


def summarize_findings(workloads: dict[str, Any]) -> dict[str, Any]:
    finding: dict[str, Any] = {
        "workload_count": len(workloads),
        "stages_per_workload": ["S4", "S5"],
        "fusion_top5_candidate_counts": {},
        "co_tiling_top5_candidate_counts": {},
        "s5_typed_fission_top5_candidate_counts": {},
        "selected_cycles_equal_s4_s5": {},
    }
    for workload, stages in workloads.items():
        finding["fusion_top5_candidate_counts"][workload] = {
            stage: data["families"]["fusion"]["global_search_top5"]["candidate_count"]
            for stage, data in stages.items()
        }
        finding["co_tiling_top5_candidate_counts"][workload] = {
            stage: data["families"]["co_tiling"]["global_search_top5"]["candidate_count"]
            for stage, data in stages.items()
        }
        finding["s5_typed_fission_top5_candidate_counts"][workload] = stages["S5"]["families"]["fission"]["global_search_top5"]["candidate_count"]
        finding["selected_cycles_equal_s4_s5"][workload] = (
            stages["S4"]["selected"].get("native_cycle_record", {}).get("native_cycles")
            == stages["S5"]["selected"].get("native_cycle_record", {}).get("native_cycles")
            if stages["S4"]["selected"].get("native_cycle_record") and stages["S5"]["selected"].get("native_cycle_record")
            else None
        )
    return finding


def render_report(audit: dict[str, Any]) -> str:
    workloads = audit["workloads"]
    checkpoint_sources = collections.Counter(
        Path(stage["search"]["checkpoint"].get("source") or "missing").name
        for stages in workloads.values() for stage in stages.values()
    )
    archive_journal_deleted_stages = sum(
        bool(stage["search"].get("cleanup_receipt", {}).get("archive_journal_deleted_count"))
        for stages in workloads.values() for stage in stages.values()
    )
    checkpoint_source_text = ", ".join(f"{count} `{name}`" for name, count in sorted(checkpoint_sources.items()))
    native_rows = [stage["native_global_top5"] for stages in workloads.values() for stage in stages.values()]
    native_record_count = sum(row.get("record_count", 0) for row in native_rows)
    native_mapper_pass = sum(row.get("mapper_success_count", 0) for row in native_rows)
    native_numeric_pass = sum(row.get("numeric_pass_count", 0) for row in native_rows)
    native_trace_pass = sum(row.get("independent_trace_pass_count", 0) for row in native_rows)
    cycle_comparisons = [value for value in audit["global_findings"]["selected_cycles_equal_s4_s5"].values() if value is not None]
    equal_cycle_count = sum(value is True for value in cycle_comparisons)
    lines = [
        f"# {audit.get('audit_label', 'Captured')} fusion and fission funnel audit",
        "",
        f"Results root: `{audit['results_root']}`",
        f"Census root: `{audit['census_root']}`",
        "",
        audit["binding_portability"],
        "",
        "## Findings",
        "",
        "All six workloads are audited in S4 and S5. Typed primitive kinds drive fusion classification: a candidate counts as fusion when its action path contains a `fusion` or `sibling-fusion` primitive (or the corresponding exact dedicated family). Co-tiling families are counted separately only when their primitive kinds are tile/k-tile. A family-name substring alone never establishes fusion.",
        "",
        "When the captured run has no family event journal, legal fission counts come from the source-owned cut census. The checkpoint preserves a final identity-parent pending-menu snapshot and action cursor, but those menu rows and cursor positions do not establish attempt, materialization, or scoring outcomes. Aggregate rejects and duplicates remain family agnostic. Those funnel stages are `unknown` unless a family-funnel log provides exact counters.",
        "",
        f"Checkpoint inputs: {checkpoint_source_text}. Cleanup receipts record deletion of the archive journal in {archive_journal_deleted_stages} stage(s); those receipts and checkpoint source paths are included in `audit.json`.",
        "",
        f"Across the captured S4/S5 cells, the native global top-five records show {native_mapper_pass}/{native_record_count} mapper passes, {native_numeric_pass}/{native_record_count} numeric passes, and {native_trace_pass}/{native_record_count} independent trace passes. Selected S4/S5 cycles match for {equal_cycle_count}/{len(cycle_comparisons)} workloads with both selected measurements available.",
        "",
        "Native global top-five records and controls are reported in separate fields. Final selection comes from `previous-winner.jsonl`; it is not inferred from the minimum cycle across controls.",
        "",
        "## Per-workload evidence",
        "",
        "| Program | Stage | Search scores / stop | Fusion top5 | Co-tiling top5 | Fission legal cuts / final pending menu rows (before/after cursor) / top5 | Selected cycles | Root menu cursor |",
        "|---|---|---:|---:|---:|---|---:|---:|",
    ]
    for workload, stages in workloads.items():
        for stage_label in ("S4", "S5"):
            stage = stages[stage_label]
            scores = stage["search"]["summary"].get("unique_complete_candidates_scored")
            stop = stage["search"]["summary"].get("stop_reason")
            menu = stage["search"]["captured_identity_parent_action_menu"]
            fission_menu = stage["families"]["fission"]["captured_pending_menu_snapshot"]
            fission_census = stage["families"]["fission"]["legal_action_census"]
            menu_count = fission_menu.get("value") if stage_label == "S5" and isinstance(fission_menu.get("value"), int) else None
            before = fission_menu.get("rows_before_cursor") if stage_label == "S5" else None
            after = fission_menu.get("rows_at_or_after_cursor") if stage_label == "S5" else None
            legal_cuts = fission_census.get("value") if stage_label == "S5" else None
            fission_top5 = stage["families"]["fission"]["global_search_top5"]["candidate_count"]
            cursor = menu.get("pending_action_cursor")
            selected_cycles = (stage.get("selected", {}).get("native_cycle_record") or {}).get("native_cycles")
            lines.append(
                f"| {workload} | {stage_label} | {scores if scores is not None else 'unknown'} / {stop or 'unknown'} | "
                f"{stage['families']['fusion']['global_search_top5']['candidate_count']}/5 | "
                f"{stage['families']['co_tiling']['global_search_top5']['candidate_count']}/5 | "
                f"{legal_cuts if legal_cuts is not None else '—'} / "
                f"{menu_count if stage_label == 'S5' and menu_count is not None else '—'} "
                f"({before if before is not None else '—'}/{after if after is not None else '—'}) / {fission_top5}/5 | "
                f"{selected_cycles if selected_cycles is not None else 'unknown'} | {cursor if cursor is not None else 'unknown'} |"
            )
    lines.extend([
        "",
        "## R9 classification correction",
        "",
        "Harris S4 has zero fusion candidates in the saved global top five. Its 20 recorded actions across those five candidates have family `producer-consumer-co-tiling` and primitive kinds `tile` only. The earlier R9 prose table marked these five candidates as fusion because it treated the co-tiling family name as a fusion action; this corrected audit removes that classification.",
        "",
        "S5 fission path presence uses `action_history.fissionActions` separately from ordinary `action_history.actions`. An empty typed-fission history in top five is not evidence that no legal source cut existed; consult the exact source census and funnel status for each workload. Menu rows before or after the checkpoint cursor are action slots only, not proof of an attempt outcome.",
        "",
        "See `audit.json` for each top-five action, typed fission history, menu row/cursor counts, native top-five and controls, selected candidate, per-family funnel statuses, and exact source-file references.",
    ])
    return "\n".join(lines) + "\n"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--results-root", type=Path, required=True, help="Captured results root containing <workload>/<stage>/")
    parser.add_argument("--census-root", type=Path, required=True, help="Source cut census root containing <workload>/cut-census.json")
    parser.add_argument("--output-root", type=Path, required=True, help="Directory for audit.json and report.md")
    parser.add_argument("--audit-label", default=None, help="Short label for this evidence set; defaults to the results-root basename")
    args = parser.parse_args(argv)
    audit = build_audit(args.results_root, args.census_root, args.audit_label)
    args.output_root.mkdir(parents=True, exist_ok=True)
    (args.output_root / "audit.json").write_text(json.dumps(audit, indent=2, sort_keys=True) + "\n")
    (args.output_root / "report.md").write_text(render_report(audit))
    print(f"wrote {args.output_root / 'audit.json'}")
    print(f"wrote {args.output_root / 'report.md'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
