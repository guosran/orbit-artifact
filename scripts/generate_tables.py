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
    semantic = json.loads((path / "semantic_summary.json").read_text())
    execution = json.loads((path / "execution_summary.json").read_text())
    negative = json.loads((path / "negative_control.json").read_text())
    environment = json.loads((path / "environment.json").read_text())
    run = json.loads((path / "run.json").read_text())
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


if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("run_dir", nargs="?", type=Path)
    args = ap.parse_args(); generate(args.run_dir or latest_run())

