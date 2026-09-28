"""Cross-layer result and provenance contracts; no synthetic measurements."""
import json
from urllib.parse import quote

EVIDENCE_CLASSES = {"analytical_estimate", "predictor_estimate", "native_mapper_replay",
                    "rtl_cycle_measurement", "host_semantic_execution"}
STATUSES = {"accepted", "semantic_rejected", "backend_unsupported", "artifact_missing",
            "measurement_censored", "execution_failed", "not_selected", "selected"}
PAPER_ELIGIBILITY = {"current_reproducible"}
EXACT_ORACLE_MAX_ACTIVITIES = 8


def _atom(value):
    return quote(json.dumps(value, sort_keys=True, separators=(",", ":")), safe="")


def layered_ids(candidate):
    """Readable composite IDs. Semantic identity is owned by source C++ passes."""
    semantic = candidate["semantic_graph_id"]
    resource = "resource:" + semantic + ":" + _atom({k: candidate[k] for k in
        ("shape", "physical_cgras", "replicas", "shards", "mapped_dfg_ids")})
    spatial = "spatial:" + resource + ":" + _atom({k: candidate[k] for k in
        ("placement", "routes", "resource_allocation")})
    temporal = "temporal:" + spatial + ":" + _atom({k: candidate[k] for k in
        ("activities", "timed_reservations")})
    replay = "replay:" + temporal + ":" + _atom({k: candidate[k] for k in
        ("replay_protocol", "backend", "replay_run_id", "evidence_class", "cost")})
    return {"semantic_graph_id": semantic, "resource_candidate_id": resource,
            "spatial_candidate_id": spatial, "temporal_schedule_id": temporal,
            "replay_id": replay}


def validate_candidate(row):
    if row["evidence_class"] not in EVIDENCE_CLASSES:
        raise ValueError("unknown evidence class")
    if row["status"] not in STATUSES:
        raise ValueError("unknown candidate status")
    for field in ("semantic_legal", "backend_legal", "artifact_available", "measurement_available"):
        if type(row[field]) is not bool:
            raise ValueError("capability field must be boolean: " + field)
    if row["status"] == "semantic_rejected" and row["semantic_legal"]:
        raise ValueError("semantic rejection conflicts with semantic legality")
    if row["status"] == "backend_unsupported" and (not row["semantic_legal"] or row["backend_legal"]):
        raise ValueError("backend unsupported must remain semantically legal")
    if row["status"] in {"artifact_missing", "measurement_censored", "execution_failed"} and row["measurement_available"]:
        raise ValueError("failed or censored measurement cannot be available")
    cost = row.get("cost")
    if row["status"] in {"artifact_missing", "measurement_censored", "execution_failed", "backend_unsupported", "semantic_rejected"}:
        if cost is not None:
            raise ValueError("unavailable or censored cost must be null")
    if cost is not None:
        if type(cost.get("value")) not in (int, float) or cost["value"] < 0:
            raise ValueError("invalid numeric cost")
        if cost.get("source") != row["evidence_class"]:
            raise ValueError("cost source differs from evidence class")
        if not cost.get("unit"):
            raise ValueError("cost unit missing")
    if row.get("fabric_capacity") != 16 or row.get("fabric_rows") != 4 or row.get("fabric_cols") != 4:
        raise ValueError("resource-budget mismatch: expected 4x4 CGRA fabric")
    if row.get("max_cgras_per_task") != 4:
        raise ValueError("per-task CGRA limit must be recorded separately as four")
    if row["physical_cgras"] > row["max_cgras_per_task"] or row["physical_cgras"] < 1:
        raise ValueError("shape exceeds per-task physical CGRA limit")
    if row["occupied_cgras"] > row["fabric_capacity"]:
        raise ValueError("allocation exceeds fabric capacity")
    if any(not str(x).startswith("tile:") for x in row["logical_tile_ids"]):
        raise ValueError("logical tile IDs require tile namespace")
    if any(not str(x).startswith("replica:") for x in row["replica_ids"]):
        raise ValueError("replica IDs require replica namespace")
    if set(row["logical_tile_ids"]) & set(row["replica_ids"]):
        raise ValueError("logical tile ID equals replica ID")
    if (row["replicas"] != len(row["replica_ids"]) or
            row["replicas"] != len(row["shards"]) or
            row["replicas"] != len(row["mapped_dfg_ids"])):
        raise ValueError("replica, shard, and mapped DFG instance counts differ")
    if {shard.get("replica_id") for shard in row["shards"]} != set(row["replica_ids"]):
        raise ValueError("execution shard replica IDs differ")
    if row.get("replication_generated_tile_local_edges"):
        raise ValueError("replication cannot generate tile-local dependency edges")
    if row.get("replica_dfg_complete") is not True:
        raise ValueError("each replica must copy the complete task DFG")
    if row.get("scheduler_policy") == "exact" and len(row["activities"]) > EXACT_ORACLE_MAX_ACTIVITIES:
        raise ValueError("exact oracle exceeds supported small-graph scope")
    ids = layered_ids(row)
    for name, value in ids.items():
        if row.get(name) != value:
            raise ValueError("layered identity mismatch: " + name)
    if row["status"] == "selected" and row.get("selected_replay_id") != ids["replay_id"]:
        raise ValueError("selected-candidate replay identity mismatch")
    return True


def rank_candidates(rows):
    """Return finite eligible candidates only, with deterministic ties."""
    for row in rows:
        validate_candidate(row)
    eligible = [r for r in rows if r["status"] in {"accepted", "selected"} and
                r["measurement_available"] and r.get("cost") is not None]
    return sorted(eligible, key=lambda r: (r["cost"]["value"], r["resource_candidate_id"],
                                           r["spatial_candidate_id"], r["temporal_schedule_id"]))


def matched_for_paper(baseline, optimized):
    for row in (baseline, optimized):
        if row.get("comparability") not in PAPER_ELIGIBILITY:
            raise ValueError("historical or incomparable result cannot enter paper table")
        if row.get("run_complete") is not True:
            raise ValueError("incomplete long run cannot enter paper table")
        validate_candidate(row)
    keys = ("workload_id", "source_commit", "architecture_id", "fabric_capacity",
            "max_cgras_per_task", "replay_protocol", "backend", "evidence_class")
    for key in keys:
        if baseline.get(key) != optimized.get(key):
            raise ValueError("matched baseline differs in " + key)
    if baseline.get("case_role") != "baseline" or optimized.get("case_role") != "optimized":
        raise ValueError("missing matched baseline or optimized case")
    return True
