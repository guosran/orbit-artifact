#!/usr/bin/env python3
"""Losslessly archive raw intermediates of explicitly validated 5+1 ablation cells."""
import argparse
import hashlib
import json
from pathlib import Path
import time

import compact_sequential_raw as storage


def require_six_gates(cell):
    result = json.loads((cell / "result.json").read_text())
    if result.get("numeric") != "pass" or result.get("search", {}).get("exit_code") != 0:
        raise ValueError("search/numeric gate incomplete")
    for block, selection_key, command, ranks in (
        ("native_top5", "top5", "numeric_top5_command", set(range(5))),
        ("native_controls", "controls", "numeric_controls_command", {5}),
    ):
        native, selections = result.get(block, {}), result.get(selection_key, [])
        records = native.get("records", [])
        if (native.get("status") != "native_replayed" or native.get("numeric") != "pass"
                or result.get(command, {}).get("exit_code") != 0
                or len(records) != len(ranks) or len(selections) != len(ranks)
                or {row.get("rank") for row in records} != ranks
                or {row.get("rank") for row in selections} != ranks):
            raise ValueError("expected five-shortlist/one-identity coverage is incomplete")
        selected = {row["rank"]: row for row in selections}
        if selection_key == "top5" and len({row["candidate_id"] for row in selections}) != 5:
            raise ValueError("shortlist IDs are not unique")
        if selection_key == "controls" and selections[0].get("control_role") != "identity":
            raise ValueError("expected identity control is absent")
        for row in records:
            if (row["candidate_id"] != selected[row["rank"]]["candidate_id"]
                    or row.get("control_role") != selected[row["rank"]].get("control_role")
                    or row.get("numeric_element_comparisons", 0) <= 0
                    or any(row.get(key) != value for key, value in (
                        ("status", "native_replayed"), ("numeric", "pass"),
                        ("mapper_equality", "pass"), ("independent_trace", "pass")))
                    or any(row.get(command_key, {}).get("exit_code") != 0
                           for command_key in ("mapper_command", "native_command"))):
                raise ValueError("native/numeric/mapper/trace evidence failed")
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--results-root", type=Path, required=True)
    parser.add_argument("--workloads", nargs="+", choices=("gcn", "harris", "llama", "lu", "radar"), required=True)
    parser.add_argument("--apply", action="store_true", help="Default only reports eligible cells")
    args = parser.parse_args()
    root = args.results_root.resolve()
    totals = []
    for workload in args.workloads:
        for result_path in sorted((root / workload).glob("*/result.json")):
            cell = result_path.parent
            try:
                require_six_gates(cell)
            except (OSError, ValueError) as error:
                print(json.dumps({"cell": str(cell), "status": "excluded", "reason": str(error)}), flush=True)
                continue
            if not args.apply:
                print(json.dumps({"cell": str(cell), "status": "eligible-six-gates-passed"}), flush=True)
                continue
            started = time.monotonic()
            payload = result_path.read_bytes()
            result_digest = hashlib.sha256(payload).hexdigest()
            record, existing = storage._create_auxiliary_archive(cell)
            require_six_gates(cell)
            if hashlib.sha256(result_path.read_bytes()).hexdigest() != result_digest:
                raise ValueError("validated result changed during archival")
            if record is None:
                continue
            overhead = {"schema": "orbit-completed-ablation-aux-cleanup-v1", "result_sha256": result_digest,
                "validation": "five shortlist plus one identity; six native/numeric/mapper/trace gates",
                "original_bytes": existing["original_bytes"], "archive_bytes": existing["archive_bytes"],
                "freed_bytes": existing["original_bytes"] - existing["archive_bytes"],
                "elapsed_seconds": time.monotonic() - started,
                "restore_command": f"python3 scripts/compact_sequential_raw.py --restore-cell {cell}",
                "compatibility": "final plans/results/traces/numeric files stay plain; raw auxiliary readers need explicit restore; Sequential seven-gate checks remain unchanged"}
            (cell / "completed-auxiliary-cleanup.json").write_text(json.dumps(overhead, indent=2) + "\n")
            totals.append(overhead)
            print(json.dumps({"cell": str(cell), **overhead}), flush=True)
    print(json.dumps({"mode": "apply" if args.apply else "preview", "archived_cells": len(totals),
        "freed_bytes": sum(row["freed_bytes"] for row in totals)}), flush=True)


if __name__ == "__main__":
    main()
