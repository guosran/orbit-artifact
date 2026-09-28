#!/usr/bin/env python3
"""Derive compact result records from fresh source-owned machine output."""
import argparse
from collections import Counter
import json
from pathlib import Path

from common import write_json


def collect(run_dir):
    raw = run_dir / "raw"
    manifest = json.loads((raw / "joint_variant_space.json").read_text())
    witnesses = json.loads((raw / "witness_replay.json").read_text())
    numeric = json.loads((raw / "host_numeric.json").read_text())
    candidates = (json.loads((raw / "smoke_candidates.json").read_text())["candidates"]
                  if (raw / "smoke_candidates.json").exists() else manifest["candidates"])
    candidate_ids = [c["graph_id"] for c in candidates]
    witness_ids = [r["graph_id"] for r in witnesses["records"]]
    numeric_ids = [r["graph_id"] for r in numeric["records"]]
    if len(candidate_ids) != len(set(candidate_ids)):
        raise ValueError("duplicate graph IDs in manifest")
    if set(candidate_ids) != set(witness_ids) or set(numeric_ids) != set(witness_ids):
        raise ValueError("candidate, witness, and numeric graph ID sets differ")
    with (run_dir / "graph_inventory.jsonl").open("w") as stream:
        for c in candidates:
            row = {key: c[key] for key in ("graph_id", "tile_sizes", "k_policy",
                                           "reduction_topology", "fusion", "mode_tags",
                                           "completion_join_materialized", "numeric_reduction_materialized")}
            row["witness_executable"] = c["witness"]["executable"]
            row["witness_pipeline"] = c["witness"]["pass_pipeline"]
            stream.write(json.dumps(row, sort_keys=True) + "\n")
    k_modes = Counter(("none" if c["tile_sizes"]["BK"] == 8 else
                       "sequential" if c["k_policy"] == "sequential" else
                       "parallel_" + c["reduction_topology"]) for c in candidates)
    fusion_modes = Counter(c["fusion"]["producer_consumer"] for c in candidates)
    rejection_reasons = Counter(r["reason_code"] for r in manifest["rejections"])
    actions = manifest["statistics"]["action_attempts"]
    semantic = {"schema": "orbit-semantic-summary-v1", "attempted_actions": actions,
                "unique_semantic_graphs": len(candidates),
                "deduplication_ratio": round(1 - len(candidates) / actions, 8),
                "graph_ids": candidate_ids,
                "materialized_witnesses": sum(c["witness"]["executable"] for c in candidates),
                "mlir_verified": sum(r["verifier_pass"] for r in witnesses["records"]),
                "graph_fact_matches": sum(r["facts_match"] for r in witnesses["records"]),
                "k_mode_counts": dict(k_modes), "fusion_mode_counts": dict(fusion_modes),
                "rejection_count": len(manifest["rejections"]),
                "rejection_reasons": dict(rejection_reasons),
                "transition_count": len(manifest["transitions"]),
                "composition_order_counts": composition_counts(manifest),
                "coverage": coverage(manifest)}
    write_json(run_dir / "semantic_summary.json", semantic)
    runs = numeric["candidate_case_comparisons"]
    elements = numeric["case_count"] * sum(sum(r["element_checks_per_case"].values())
                                            for r in numeric["records"])
    execution = {"schema": "orbit-execution-summary-v1", "host_execution_runs": runs,
                 "input_cases": numeric["case_count"], "element_comparisons": elements,
                 "numeric_mismatches": sum(r["element_mismatches"] for r in numeric["records"]),
                 "all_pass": numeric["all_pass"], "graph_ids": numeric_ids,
                 "task_write_snapshots": numeric["case_count"] * sum(
                     r["task_writes_observed"] for r in numeric["records"])}
    write_json(run_dir / "execution_summary.json", execution)
    write_json(run_dir / "negative_control.json", {
        "schema": "orbit-negative-control-v1",
        "injected_mismatches": 1,
        "detected_mismatches": numeric["negative_control_mismatches"],
        "method": "one expected final-D element perturbed before host JIT comparison",
        "source_script": "tools/orbit_joint_host_numeric_audit.py"})
    return semantic, execution


def composition_counts(manifest):
    transitions = manifest["transitions"]
    by_result = {}
    for row in transitions:
        by_result.setdefault(row["result_graph_id"], []).append(row)
    counts = Counter()
    for row in transitions:
        action = row["action"]["kind"]
        parents = by_result.get(row["source_graph_id"], [])
        for parent in parents:
            previous = parent["action"]["kind"]
            if previous.startswith("Tile") and action.startswith("Fuse"):
                counts["tile_to_fuse"] += 1
            if previous.startswith("Fuse") and action.startswith("Tile"):
                counts["fuse_to_tile"] += 1
    counts["commutative_duplicate_transitions"] = sum(
        bool(t.get("duplicate_state")) for t in transitions)
    return dict(counts)


def coverage(manifest):
    cs = manifest["candidates"]
    rows = manifest["transitions"]
    order = composition_counts(manifest)
    return {
        "identity": any(c["tile_sizes"] == {"BM": 8, "BN": 8, "BK": 8} and
                        c["fusion"]["producer_consumer"] == "none" for c in cs),
        "m_tiling": any(c["tile_sizes"]["BM"] < 8 for c in cs),
        "n_tiling": any(c["tile_sizes"]["BN"] < 8 for c in cs),
        "mn_tiling": any(c["tile_sizes"]["BM"] < 8 and c["tile_sizes"]["BN"] < 8 for c in cs),
        "sequential_k": any(c["tile_sizes"]["BK"] < 8 and c["k_policy"] == "sequential" for c in cs),
        "parallel_linear": any(c["tile_sizes"]["BK"] < 8 and c["reduction_topology"] == "linear" for c in cs),
        "parallel_tree": any(c["tile_sizes"]["BK"] < 8 and c["reduction_topology"] == "balanced_tree" for c in cs),
        "whole_fusion": any(c["fusion"]["producer_consumer"] == "whole" for c in cs),
        "tile_local_fusion": any(c["fusion"]["producer_consumer"] == "tile_local" for c in cs),
        "reduction_consumer_fusion": any(c["fusion"]["reduction_consumer"] for c in cs),
        "tile_to_fuse": order.get("tile_to_fuse", 0) > 0,
        "fuse_to_tile": order.get("fuse_to_tile", 0) > 0,
        "commutative_order_equivalence": order.get("commutative_duplicate_transitions", 0) > 0,
        "rejected_illegal_compositions": bool(manifest["rejections"]),
        "completion_join_sync_only": all(not c["numeric_reduction_materialized"] or
                                         c["completion_join_materialized"] for c in cs
                                         if c["tile_sizes"]["BM"] < 8 or c["tile_sizes"]["BN"] < 8)}


if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("run_dir", type=Path)
    args = ap.parse_args(); collect(args.run_dir)
