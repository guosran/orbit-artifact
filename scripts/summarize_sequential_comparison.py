#!/usr/bin/env python3
"""Export audited mapper results and separate prediction convergence curves."""
from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path

import collect_neighborhood_mapper_ii as mapper_ii
import compact_sequential_raw as journal_storage
import neighborhood_replay as replay
import run_sequential_comparison as comparison
from sequential_validation_audit import require_complete_validation
from sequential_budget_audit import expected_phase_budgets


def read_jsonl(path):
    return journal_storage.read_journal(path)


def prediction_accounting(cell):
    records = []
    for path in sorted((cell / "search").rglob("*.json")):
        if "catalogue" not in path.name and "catalog" not in path.name:
            continue
        try:
            value = comparison.read(path)
        except (UnicodeDecodeError, json.JSONDecodeError):
            continue
        if not isinstance(value, dict) or not isinstance(value.get("entries"), list):
            continue
        cache = value.get("predictor_metadata", {}).get("ml_cache")
        if not isinstance(cache, dict):
            continue
        records.append({"catalog": str(path), "entries": len(value["entries"]), **cache})
    manifest_path = cell / "raw-auxiliary-manifest.json"
    manifest = comparison.read(manifest_path) if manifest_path.is_file() else {}
    archived_catalogs = [{"catalog": str(cell / row["path"]),
        "archive": str(cell / "raw-auxiliary.tar.gz"), "archive_member": row["path"],
        "sha256": row["sha256"], "size": row["size"], "status": "archived-exact-bytes"}
        for row in manifest.get("files", [])
        if Path(row["path"]).name.startswith("costs-") and row["path"].endswith(".json")]
    raw_catalog_evidence = archived_catalogs or [
        {"catalog": str(path), **comparison.file_binding(path), "status": "live"}
        for path in sorted((cell / "search").glob("costs-*.json"))]
    log = (cell / "search.stderr.log").read_text()
    audits = [json.loads(line.split('[ORBIT-PREDICTOR-AUDIT] ', 1)[1])
              for line in log.splitlines() if line.startswith('[ORBIT-PREDICTOR-AUDIT] ')]
    if (records or raw_catalog_evidence) and not audits:
        raise ValueError(f"missing predictor invocation audit: {cell}")
    by_phase = {}
    for row in audits:
        values = by_phase.setdefault(row["phase"], {})
        for key in ("feature_queries", "unsupported_queries", "prediction_requests",
                    "model_inference_calls", "ensemble_member_predictions", "cache_hits", "cache_misses", "elapsed_seconds"):
            values[key] = values.get(key, 0) + row[key]
    return {"catalogs": records, "raw_catalog_evidence": raw_catalog_evidence,
        "auxiliary_manifest": str(manifest_path) if manifest else None,
        "by_phase": by_phase, "invocations": audits,
        "predictor_invocations": len(audits),
        "feature_queries": sum(row["feature_queries"] for row in audits),
        "unsupported_queries": sum(row["unsupported_queries"] for row in audits),
        "prediction_requests": sum(row["prediction_requests"] for row in audits),
        "predictor_wall_seconds": sum(row["elapsed_seconds"] for row in audits),
        "predictor_cache_queries": sum(row["cache_hits"] + row["cache_misses"] for row in audits),
        "predictor_cache_hits": sum(row["cache_hits"] for row in audits),
        "model_inferences": sum(row["model_inference_calls"] for row in audits),
        "ensemble_member_predictions": sum(row["ensemble_member_predictions"] for row in audits),
        "search_mapper_calls": 0,
        "query_definition": "direct ensemble re-computes every supported query before cache equality validation, including hits; prepared canonical catalogue costs are recorded separately; per-invocation audit also records failed/partial calls"}


def initialization_accounting(cell, workload, search):
    # The existing bootstrap predates the new search counters. Reconstruct its
    # exact feasibility-only catalogue reads from the immutable input rows;
    # keep these separately labelled instead of altering historical counters.
    catalog = comparison.read(cell.parents[1] / "inputs" / workload / "cost-catalog.json")
    entries = catalog["entries"]
    by_shape = {(r["task"], r["mapper_tile_rows"] // 2, r["mapper_tile_cols"] // 2): r for r in entries}
    tasks = list(dict.fromkeys(r["task"] for r in entries))
    queries, chosen = [], []
    def lookup(task, rows, cols):
        row = by_shape[(task, rows, cols)]
        supported = row.get("status") != "unsupported-model-domain"
        queries.append({"task": task, "rows": rows, "cols": cols, "supported": supported})
        return supported
    for task in tasks:
        rows, cols = 1, 1
        if not lookup(task, 1, 1):
            for rows, cols in ((1,1),(1,2),(2,1),(1,3),(3,1),(1,4),(2,2),(4,1)):
                if lookup(task, rows, cols): break
            else: raise ValueError(f"unsupported canonical task: {workload}/{task}")
        chosen.append({"task": task, "rows": rows, "cols": cols})
    if chosen != search["canonical_actual_identity_shapes"]:
        raise ValueError(f"bootstrap reconstruction differs from actual initial shapes: {cell}")
    return {"initial_resource_feasibility_queries": queries,
        "initial_resource_feasibility_query_count": len(queries),
        "initial_resource_policy": "existing minimum-area-supported-model-shape-v1; exact source-order table reads reconstructed and checked against emitted identity",
        "canonical_model_domain_frontend_queries": len(entries),
        "canonical_model_domain_model_inferences": 0,
        "wall_time": "included in search wall time and initial phase elapsed time",
        "additional_training_or_calibration": False}


def final_mapper_accounting(cell, result):
    audits = []
    for block, directory in (("native_top5", "native-top5"), ("native_controls", "native-controls")):
        expected = {int(row["rank"]) for row in result[block]["records"]}
        paths = list((cell / directory).glob("rank-*/mapper-call-audit.json"))
        if {int(path.parent.name.split("-")[1]) for path in paths} != expected:
            raise ValueError(f"mapper audit rank coverage mismatch: {cell}/{directory}")
        for row in result[block]["records"]:
            selected = next(item for item in result["top5"] + result["controls"]
                            if item["rank"] == row["rank"] and item["candidate_id"] == row["candidate_id"])
            path = cell / directory / f"rank-{row['rank']}" / "mapper-call-audit.json"
            calls = comparison.read(path)
            if len(calls) != row["actual_mapper_calls"] or any(
                    call["candidate_id"] != selected["shape_candidate_id"] for call in calls):
                raise ValueError(f"mapper pre-call audit differs from selected candidate or count: {path}")
            if not isinstance(row.get("numeric_element_comparisons"), int) or row["numeric_element_comparisons"] <= 0:
                raise ValueError(f"missing actual numerical comparisons: {path.parent}")
            audits.append({"rank": row["rank"], "candidate_id": row["candidate_id"],
                           "path": str(path), "calls": len(calls)})
    return {"audits": audits, "actual_task_mapper_calls": sum(row["calls"] for row in audits)}


def cell_summary(cell, workload, method):
    if not comparison.complete(cell):
        raise ValueError(f"not completely validated: {cell}")
    result = comparison.read(cell / "result.json")
    require_complete_validation(result)
    search = comparison.read(cell / "search/search-summary.json")
    protocol = comparison.read(cell.parents[1] / "protocol.json")
    cap = protocol["search"]["max_unique_complete_candidates_scored"]
    flow = "joint" if method == "joint" else "sequential"
    percent = 50 if flow == "joint" else int(method.split("-")[1])
    design = protocol["decision_flow_comparison"]
    policy = design.get("sequential_budget_policy", "fixed-split")
    supplemental = method == "sequential-50-transfer"
    if supplemental != (policy == "transfer-unused"):
        raise ValueError(f"supplemental budget policy/label mismatch: {cell}")
    if supplemental and protocol.get("experiment_kind") != "sequential-budget-transfer-supplement":
        raise ValueError(f"transfer experiment must use its own supplemental protocol: {cell}")
    expected = ({"joint": cap} if flow == "joint" else
                expected_phase_budgets(search, cap, percent, policy))
    expected_rounds = design["joint_max_rounds"] if flow == "joint" else design["sequential_max_rounds_per_phase"]
    counts = search["phase_evaluations"]
    if (search["decision_flow"] != flow or search["graph_budget_percent"] != percent
            or search["max_rounds"] != expected_rounds
            or search.get("round_score_quota") != design["round_score_quota"]
            or search["objective_budget"] != cap or search["max_candidates"] != cap
            or search["phase_budgets"] != expected or set(counts) != set(expected)
            or any(counts[p] > expected[p] for p in expected)
            or sum(counts.values()) != search["production_scheduler_calls"]
            or search["production_scheduler_calls"] > cap):
        raise ValueError(f"objective budget/split contract mismatch: {cell}")
    if flow == "sequential":
        frontiers = read_jsonl(cell / "search/action-frontiers.jsonl")
        for phase in ("A", "B"):
            actual = sum(row["phase"] == phase for row in frontiers)
            if search[f"phase_{phase.lower()}_rounds_completed"] != actual:
                raise ValueError(f"phase round count differs from actual frontiers: {cell}")
    final_mapper = final_mapper_accounting(cell, result)
    records = result["native_top5"]["records"] + result["native_controls"]["records"]
    winner = min(records, key=lambda record: record["native_cycles"])
    search_record = result["search"]
    selections = result["top5"] + result["controls"]
    selected_winner = next(row for row in selections if row["rank"] == winner["rank"] and row["candidate_id"] == winner["candidate_id"])
    anchor = next(row for row in result["native_controls"]["records"] if row["control_role"] == "search_anchor")
    if winner["native_cycles"] > anchor["native_cycles"]:
        raise ValueError(f"native incumbent regressed: {cell}")
    predictor = prediction_accounting(cell)
    initialization = initialization_accounting(cell, workload, search)
    mapper_ii.collect(cell)
    prior_mapper_calls = 0
    execution = comparison.read(cell / "execution.json")
    prior_query_lower_bound, prior_cache_hits = 0, 0
    prior_queries_exact = True
    for rank_result in (cell / "validation-attempts").rglob("rank-*/result.json"):
        old = comparison.read(rank_result)
        if "mapper_cache_hits" in old and "mapper_cache_misses" in old:
            prior_query_lower_bound += old["mapper_cache_hits"] + old["mapper_cache_misses"]
            prior_cache_hits += old["mapper_cache_hits"]
        else:
            prior_query_lower_bound += old.get("actual_mapper_calls", 0)
            prior_queries_exact = False
    current_task_queries = sum(row["mapper_cache_hits"] + row["mapper_cache_misses"] for row in records)
    for audit in (cell / "validation-attempts").rglob("mapper-call-audit.json"):
        prior_mapper_calls += len(comparison.read(audit))
    value = {"workload": workload, "method": method,
        "sequential_budget_policy": policy if flow == "sequential" else None,
        "final_native_cycles": winner["native_cycles"],
        "predicted_winner_cycles": selected_winner["predicted_whole_program_cycles"],
        "predicted_search_best": min(row["predicted_whole_program_cycles"] for row in selections),
        "search_wall_seconds": search_record["ended_unix"] - search_record["started_unix"],
        "storage_compaction": comparison.read(cell / "storage-overhead.json") if (cell / "storage-overhead.json").is_file() else None,
        "coordinator_initialization_wall_seconds": execution.get("coordinator_initialization_wall_seconds"),
        "elapsed_cell_seconds_including_coordinator_initialization": execution.get("elapsed_cell_seconds_including_coordinator_initialization"),
        "objective_evaluations": search["production_scheduler_calls"],
        "objective_cache_hits": search["objective_cache_hits"],
        "candidate_attempts": search.get("candidate_attempts"),
        "legal_candidates": search.get("unique_valid_candidates"),
        "canonical_duplicates": search.get("reject_reasons", {}).get("canonical_duplicate", 0),
        "catalogue_lookup_hits": search.get("cache_hits"),
        "catalogue_lookup_misses": search.get("cache_misses"),
        "search_stats": search, "prediction": predictor,
        "initialization": initialization,
        "task_cost_catalogue_queries_including_bootstrap": search["cache_hits"] + search["cache_misses"] + initialization["initial_resource_feasibility_query_count"],
        "validation": {"shortlist_records": 5, "control_records": 2,
            "mapper_processes": len(records),
            "actual_task_mapper_calls": prior_mapper_calls + final_mapper["actual_task_mapper_calls"],
            "final_mapper_audits": final_mapper["audits"],
            "wall_seconds_including_native_numeric": comparison.read(cell / "execution.json")["elapsed_seconds"] - (search_record["ended_unix"] - search_record["started_unix"]),
            "prior_validation_attempt_mapper_calls": prior_mapper_calls,
            "mapper_cache_hits_lower_bound": prior_cache_hits + sum(row["mapper_cache_hits"] for row in records),
            "current_attempt_mapper_task_queries": current_task_queries,
            "prior_attempt_mapper_task_queries_lower_bound": prior_query_lower_bound,
            "mapper_task_queries": current_task_queries + prior_query_lower_bound if prior_queries_exact else None,
            "mapper_task_queries_lower_bound": current_task_queries + prior_query_lower_bound,
            "mapper_task_queries_are_exact": prior_queries_exact,
            "native_program_evaluations": len(records),
            "numeric_comparisons": sum(row.get("numeric_element_comparisons", 0) for row in records),
            "numeric": result["numeric"], "partition_coverage": "compiler-verified",
            "dependency_and_resource_trace": "pass", "mapper_equality": "pass",
            "sram": result.get("sram", "pending")},
        "winner": {"candidate_id": winner["candidate_id"], "rank": winner["rank"],
            "control_role": winner.get("control_role"),
            "selection": selected_winner, "native_evidence": winner},
        "anchor_native_cycles": anchor["native_cycles"],
        "source_result": str(cell / "result.json")}
    replay.atomic_write(cell / "comparison-summary.json", value)
    return value


def plot(rows, root, output):
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    colors = {"joint": "#2155a5", "sequential-50": "#c54c21", "sequential-25": "#27884e", "sequential-75": "#8b4ca8"}
    workloads = [workload for workload in comparison.WORKLOADS
                 if any(row["workload"] == workload for row in rows)]
    if not workloads:
        raise ValueError("no completed cells to plot")
    for axis_kind in ("evaluations", "wall-time"):
        fig, axes = plt.subplots(1, len(workloads), figsize=(3.8 * len(workloads), 3.8), squeeze=False)
        for ax, workload in zip(axes[0], workloads):
            for row in rows:
                if row["workload"] != workload:
                    continue
                path = root / workload / row["method"] / "search/budget-trace.jsonl"
                stored_path = journal_storage.existing_journal_path(path)
                if not stored_path.is_file():
                    raise ValueError(f"missing convergence evidence: {path} or {path}.gz")
                points = read_jsonl(path)
                xkey = "cumulative_evaluations" if axis_kind == "evaluations" else "elapsed_seconds"
                values = [(p[xkey], p["incumbent_cycles"]) for p in points if p.get("incumbent_cycles") is not None]
                ax.step([p[0] for p in values], [p[1] for p in values], where="post",
                        label=row["method"], color=colors[row["method"]], linewidth=1.4)
                transition = next((p for p in points if p.get("phase") == "B"), None)
                if transition:
                    ax.axvline(transition[xkey], color=colors[row["method"]], linewidth=.5, alpha=.4)
            ax.set_title(workload.upper())
            ax.set_xlabel("Complete-program objective calls" if axis_kind == "evaluations" else "Search wall time (s)")
            ax.ticklabel_format(axis="y", style="sci", scilimits=(0, 0))
            ax.grid(alpha=.2)
        axes[0][0].set_ylabel("Best predicted makespan (cycles)")
        axes[0][0].legend(fontsize=8)
        fig.tight_layout()
        for suffix in ("png", "pdf", "svg"):
            fig.savefig(output / f"convergence-{axis_kind}.{suffix}", dpi=180)
        plt.close(fig)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--results-root", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--render-plots", action="store_true")
    args = parser.parse_args()
    rows = [cell_summary(args.results_root / workload / method[0], workload, method[0])
            for workload in comparison.WORKLOADS for method in comparison.METHODS]
    args.output_dir.mkdir(parents=True, exist_ok=True)
    main_rows = []
    for workload in comparison.WORKLOADS:
        joint = next(r for r in rows if r["workload"] == workload and r["method"] == "joint")
        sequential = next(r for r in rows if r["workload"] == workload and r["method"] == "sequential-50")
        main_rows.append({"workload": workload, "joint_cycles": joint["final_native_cycles"],
            "sequential_cycles": sequential["final_native_cycles"],
            "sequential_over_joint": sequential["final_native_cycles"] / joint["final_native_cycles"],
            "joint_search_seconds": joint["search_wall_seconds"], "sequential_search_seconds": sequential["search_wall_seconds"],
            "joint_objective_calls": joint["objective_evaluations"], "sequential_objective_calls": sequential["objective_evaluations"],
            "joint_mapper_calls": joint["validation"]["actual_task_mapper_calls"],
            "sequential_mapper_calls": sequential["validation"]["actual_task_mapper_calls"]})
    report = {"schema": "orbit-sequential-comparison-results-v1", "primary_split": "50/50",
        "speedup": "Sequential native cycles / Joint native cycles; >1 favors Joint",
        "main": main_rows, "all_cells": rows,
        "raytracing": {"cycles": None, "status": "out-of-model-domain", "fission_substituted": False},
        "sensitivity_tuning_cost": "three complete Sequential searches per program; any best-ratio envelope costs 3x one Sequential search allowance",
        "common_preparation": comparison.read(args.results_root / "input-binding.json"),
        "execution": comparison.read(args.results_root / "batch.json"),
        "formal_go": False, "sram": "pending"}
    replay.atomic_write(args.output_dir / "results.json", report)
    with (args.output_dir / "main.csv").open("w") as file:
        writer = csv.DictWriter(file, fieldnames=list(main_rows[0]))
        writer.writeheader(); writer.writerows(main_rows)
    flat = []
    for row in rows:
        stats, pred, validation = row["search_stats"], row["prediction"], row["validation"]
        phase_calls, phase_time = stats["phase_evaluations"], stats["phase_elapsed_seconds"]
        flat.append({"workload": row["workload"], "method": row["method"],
            "final_native_cycles": row["final_native_cycles"],
            "predicted_native_winner_cycles": row["predicted_winner_cycles"],
            "search_wall_seconds": row["search_wall_seconds"],
            "candidate_attempts": row["candidate_attempts"], "unique_legal_candidates": row["legal_candidates"],
            "canonical_duplicates": row["canonical_duplicates"],
            "objective_evaluations": row["objective_evaluations"], "objective_cache_hits": row["objective_cache_hits"],
            "predictor_feature_queries": pred["feature_queries"], "predictor_model_inferences": pred["model_inferences"],
            "predictor_cache_hits": pred["predictor_cache_hits"],
            "search_mapper_calls": 0, "validation_task_mapper_calls": validation["actual_task_mapper_calls"],
            "validation_program_evaluations": validation["native_program_evaluations"],
            "validation_wall_seconds": validation["wall_seconds_including_native_numeric"],
            "phase_a_objective_calls": phase_calls.get("A"), "phase_b_objective_calls": phase_calls.get("B"),
            "phase_a_wall_seconds": phase_time.get("A"), "phase_b_wall_seconds": phase_time.get("B"),
            "numeric_comparisons": validation["numeric_comparisons"]})
    with (args.output_dir / "all-cells.csv").open("w") as file:
        writer = csv.DictWriter(file, fieldnames=list(flat[0]))
        writer.writeheader(); writer.writerows(flat)
    sensitivity = [{"workload": workload, **{f"sequential_{split}_cycles": next(
        row["final_native_cycles"] for row in rows if row["workload"] == workload and row["method"] == f"sequential-{split}")
        for split in (25, 50, 75)}} for workload in comparison.WORKLOADS]
    with (args.output_dir / "sensitivity.csv").open("w") as file:
        writer = csv.DictWriter(file, fieldnames=list(sensitivity[0]))
        writer.writeheader(); writer.writerows(sensitivity)
    text = ["# Joint versus Sequential", "", ">1 in Sequential/Joint favors Joint. Main ratio is preselected 50/50.", "",
        "| Program | Joint cycles | Sequential cycles | Sequential/Joint | Joint search s | Sequential search s | Joint / Seq objective calls | Joint / Seq mapper calls |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |"]
    for r in main_rows:
        text.append(f"| {r['workload']} | {r['joint_cycles']:,} | {r['sequential_cycles']:,} | {r['sequential_over_joint']:.4f} | {r['joint_search_seconds']:.2f} | {r['sequential_search_seconds']:.2f} | {r['joint_objective_calls']} / {r['sequential_objective_calls']} | {r['joint_mapper_calls']} / {r['sequential_mapper_calls']} |")
    text.extend(["| Ray | N/A | N/A | N/A | — | — | — | — |", "", "## Split sensitivity", "",
        "| Program | 25/75 cycles | 50/50 cycles (main) | 75/25 cycles |", "| --- | ---: | ---: | ---: |"])
    for workload in comparison.WORKLOADS:
        cycles = [next(r["final_native_cycles"] for r in rows if r["workload"] == workload and r["method"] == f"sequential-{split}") for split in (25, 50, 75)]
        text.append(f"| {workload} | {cycles[0]:,} | {cycles[1]:,} | {cycles[2]:,} |")
    (args.output_dir / "results.md").write_text("\n".join(text) + "\n")
    if args.render_plots:
        plot(rows, args.results_root, args.output_dir)
    print(json.dumps({"main": main_rows, "output": str(args.output_dir)}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
