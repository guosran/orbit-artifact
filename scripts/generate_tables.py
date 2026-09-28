#!/usr/bin/env python3
"""Render Markdown exclusively from machine-readable run output."""
import argparse
import json
from pathlib import Path

from common import write_json
from validate_results import latest_run


def table(rows):
    return "| Metric | Observed |\n|---|---:|\n" + "\n".join(
        "| %s | %s |" % (key, value) for key, value in rows) + "\n"


def generate(path):
    run = json.loads((path / "run.json").read_text())
    if run.get("schema") == "orbit-system-module-run-v1":
        return generate_module(path, run["module"])
    semantic = json.loads((path / "semantic_summary.json").read_text())
    execution = json.loads((path / "execution_summary.json").read_text())
    negative = json.loads((path / "negative_control.json").read_text())
    environment = json.loads((path / "environment.json").read_text())
    dest = path / "tables"; dest.mkdir(exist_ok=True)
    rows = [("Action attempts", semantic["attempted_actions"]),
            ("Unique semantic graphs", semantic["unique_semantic_graphs"]),
            ("Deduplication ratio", "%.2f%%" % (100 * semantic["deduplication_ratio"])),
            ("Rejected actions", semantic["rejection_count"])]
    rows += [("K mode: " + k, v) for k, v in sorted(semantic["k_mode_counts"].items())]
    rows += [("Fusion: " + k, v) for k, v in sorted(semantic["fusion_mode_counts"].items())]
    rows += [("Composition: " + k, v) for k, v in sorted(semantic["composition_order_counts"].items())]
    rows += [("Rejection: " + k, v) for k, v in sorted(semantic["rejection_reasons"].items())]
    (dest / "semantic_space.md").write_text("# Semantic space\n\n" + table(rows))
    (dest / "correctness.md").write_text("# Correctness\n\n" + table([
        ("Materialized witnesses", semantic["materialized_witnesses"]),
        ("MLIR verifier passes", semantic["mlir_verified"]),
        ("Exact graph fact matches", semantic["graph_fact_matches"]),
        ("Host executions", execution["host_execution_runs"]),
        ("Element comparisons", execution["element_comparisons"]),
        ("Numeric mismatches", execution["numeric_mismatches"]),
        ("Negative control injected", negative["injected_mismatches"]),
        ("Negative control detected", negative["detected_mismatches"])]))
    tests = json.loads((path / "test_summary.json").read_text()) if (path / "test_summary.json").exists() else {}
    (dest / "test_summary.md").write_text("# Environment and tests\n\n" + table([
        ("Required dependencies", environment["required_status"]),
        ("Optional dependencies", environment["optional_dependency_state"]),
        ("Focused Python tests", tests.get("python_passed", "not run")),
        ("Focused lit tests", tests.get("lit_passed", "not run")),
        ("Skipped optional tests", tests.get("optional_skipped", "not run")),
        ("Wall clock seconds", run.get("wall_clock_seconds", "incomplete")),
        ("Peak memory KiB", run.get("peak_memory_kib", "unavailable"))]))


def generate_module(path, module):
    summary = json.loads((path / (module + "_summary.json")).read_text())
    rows = [(key.replace("_", " "), value) for key, value in summary.items()
            if key not in ("schema", "scope", "shape_scores", "channel_fixture_scores",
                           "placements", "channel_placements", "communication", "tasks")
            and not isinstance(value, (dict, list))]
    if module == "resource":
        rows += [("shapes using %s CGRAs" % count, value)
                 for count, value in sorted(summary["shape_counts_by_cgras"].items())]
    if module == "spatial":
        rows += [("placed tasks", len(summary["placements"])),
                 ("channel payload bits", summary["communication"]["payload_bits"]),
                 ("link reservations", len(summary["communication"]["route_link_reservations"]))]
    if module == "cost":
        rows += [("rank %d: %s" % (i, row["candidate_id"]), row["predicted_parallel_makespan_cycles"])
                 for i, row in enumerate(summary["shape_scores"])]
    dest = path / "tables"; dest.mkdir(exist_ok=True)
    (dest / (module + ".md")).write_text("# %s fixture (partial module evidence)\n\n" % module.title() + table(rows))


if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("run_dir", nargs="?", type=Path)
    args = ap.parse_args(); generate(args.run_dir or latest_run())
