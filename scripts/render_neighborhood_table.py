#!/usr/bin/env python3
"""Render machine and Markdown tables from neighborhood stage evidence.

This script is an evidence reducer.  Candidate ordering and the top-five
selection are read from the C++ records unchanged.  The only numeric
aggregation performed here is the protocol-defined actual stage value: the
minimum native whole-program cycle count among legal measured top-five and
control records.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any, Iterable, Mapping


STAGES = ("shape-only", "shape-temporal", "shape-temporal-replica",
          "shape-temporal-replica-tiling", "full-joint")


def atomic_write(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + ".partial")
    temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
    temporary.replace(path)


def read_stage(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text())
    if value.get("schema") != "orbit-neighborhood-stage-result-v1":
        raise ValueError(f"unexpected stage result schema in {path}: {value.get('schema')!r}")
    return value


def _native_cycles(value: Mapping[str, Any]) -> float | int | None:
    if (value.get("status") != "native_replayed" or
            value.get("mapper_equality") != "pass" or
            value.get("independent_trace") != "pass" or
            value.get("numeric") == "fail"):
        return None
    cycles = value.get("native_cycles")
    return cycles if isinstance(cycles, (int, float)) else None


def stage_row(result: Mapping[str, Any], *, s1: float | int | None,
              previous: float | int | None) -> dict[str, Any]:
    records = list(result.get("native_top5", {}).get("records", []))
    records += list(result.get("native_controls", {}).get("records", []))
    measured = [cycles for record in records if (cycles := _native_cycles(record)) is not None]
    actual = result.get("actual_stage_cycles")
    if actual is None and measured:
        actual = min(measured)
    predicted = [row.get("predicted_whole_program_cycles") for row in result.get("top5", [])]
    predicted = [value for value in predicted if isinstance(value, (int, float))]
    selected = result.get("top5", [])
    measured_order = sorted(
        [{"rank": record.get("rank"), "control_role": record.get("control_role"),
          "candidate_id": record.get("candidate_id"), "native_cycles": record.get("native_cycles")}
         for record in records if _native_cycles(record) is not None],
        key=lambda record: (record["native_cycles"], record.get("rank") or 0))
    transformations = []
    for row in selected:
        details = row.get("transformations", row.get("candidate_state", row.get("actions")))
        if details is None:
            details = {
                "shape": row.get("shape"),
                "replica": row.get("replica"),
                "tiling": row.get("tiling"),
                "fusion": row.get("fusion"),
            }
        transformations.append({"rank": row.get("rank"), "candidate_id": row.get("candidate_id"),
                               "graph_variant_id": row.get("graph_variant_id"),
                               "transformations": details})
    winner = next((record for record in records if _native_cycles(record) == actual), None)
    winner_source = next((row for row in [*selected, *result.get("controls", [])]
                          if winner and row.get("candidate_id") == winner.get("candidate_id")
                          and row.get("graph_variant_id") == winner.get("graph_variant_id")), None)

    def delta(value: float | int | None, baseline: float | int | None) -> float | int | None:
        if value is None or baseline is None:
            return None
        return value - baseline

    def percent(value: float | int | None, baseline: float | int | None) -> float | None:
        return None if value is None or baseline in (None, 0) else (value / baseline - 1) * 100

    footer = result.get("search_footer", {})
    rejects = footer.get("reject_reasons", result.get("reject_reasons", {}))
    return {
        "workload": result.get("workload"),
        "stage": result.get("stage"),
        "status": result.get("status"),
        "result_label": result.get("result_label", "best-found"),
        "exhaustive": result.get("exhaustive", False),
        "predicted_top5_cycles": predicted,
        "predicted_cxx_order": [
            {"rank": row.get("rank"), "candidate_id": row.get("candidate_id"),
             "predicted_cycles": row.get("predicted_whole_program_cycles")}
            for row in selected
        ],
        "measured_native_order": measured_order,
        "predicted_top5_candidate_ids": [row.get("candidate_id") for row in selected],
        "native_stage_cycles": actual,
        "relative_to_s1_cycles": delta(actual, s1),
        "relative_to_previous_stage_cycles": delta(actual, previous),
        "relative_to_s1_percent": percent(actual, s1),
        "relative_to_previous_stage_percent": percent(actual, previous),
        "actual_winner": winner,
        "actual_winner_source_selection": winner_source,
        "selected_transformations": transformations,
        "unique_complete_candidates_scored": footer.get(
            "unique_complete_candidates_scored", footer.get("scored_candidate_count")),
        "cache_hits": footer.get("cache_hits"),
        "cache_misses": footer.get("cache_misses"),
        "reject_reasons": rejects,
        "search_rounds": footer.get("rounds", footer.get("search_rounds")),
        "search_elapsed_seconds": footer.get("elapsed_seconds"),
        "stop_reason": result.get("stop_reason"),
        "native_top5_status": result.get("native_top5_status"),
        "native_failures": [
            {"rank": record.get("rank"), "candidate_id": record.get("candidate_id"),
             "status": record.get("status"), "blocker": record.get("blocker")}
            for record in result.get("native_top5", {}).get("records", [])
            if record.get("status") != "native_replayed"
        ],
        "native_untested": [
            {"rank": record.get("rank"), "candidate_id": record.get("candidate_id"),
             "status": record.get("status")}
            for record in result.get("native_top5", {}).get("records", [])
            if record.get("status") != "native_replayed"
        ],
        "numeric": result.get("numeric", "pending"),
        "trace": result.get("trace", "pending"),
        "sram": result.get("sram", "pending"),
        "controls": [
            {"role": record.get("control_role"), "candidate_id": record.get("candidate_id"),
             "status": record.get("status"), "native_cycles": record.get("native_cycles"),
             "numeric": record.get("numeric", "pending"),
             "trace": record.get("independent_trace", "pending"),
             "sram": record.get("sram_gate", "pending")}
            for record in result.get("native_controls", {}).get("records", [])
        ],
        "best_found": bool(result.get("best_found", True)),
    }


def render_markdown(rows: Iterable[Mapping[str, Any]]) -> str:
    fields = ["workload", "stage", "status", "predicted_top5_cycles",
              "native_stage_cycles", "relative_to_s1_cycles",
              "relative_to_previous_stage_cycles", "unique_complete_candidates_scored",
              "cache_hits", "cache_misses", "search_rounds", "search_elapsed_seconds",
              "stop_reason", "numeric", "trace", "sram"]
    lines = ["| " + " | ".join(fields) + " |",
             "| " + " | ".join("---" for _ in fields) + " |"]
    for row in rows:
        lines.append("| " + " | ".join(str(row.get(field, "")).replace("|", "\\|")
                                        for field in fields) + " |")
    lines.append("")
    lines.append("Native controls and transformation records are retained in the JSON machine table.")
    return "\n".join(lines) + "\n"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--stage-result", type=Path, action="append",
                        help="stage result.json; may be repeated")
    parser.add_argument("--results-root", type=Path,
                        help="directory containing <workload>/<stage>/result.json")
    parser.add_argument("--workloads", nargs="+", default=["llama", "lu", "harris", "radar", "gcn", "raytracing"])
    parser.add_argument("--stages", nargs="+", default=list(STAGES))
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args(argv)
    paths = list(args.stage_result or [])
    if args.results_root:
        paths += [args.results_root / workload / stage / "result.json"
                  for workload in args.workloads for stage in args.stages]
    if not paths:
        parser.error("provide --stage-result or --results-root")
    loaded: list[tuple[Path, dict[str, Any]]] = []
    for path in paths:
        if path.is_file():
            loaded.append((path, read_stage(path)))
    by_workload: dict[str, dict[str, dict[str, Any]]] = {}
    for _, value in loaded:
        by_workload.setdefault(str(value.get("workload")), {})[str(value.get("stage"))] = value
    rows: list[dict[str, Any]] = []
    for workload in sorted(by_workload):
        values = by_workload[workload]
        s1_result = values.get("shape-only")
        s1_cycles = None
        if s1_result:
            s1_records = list(s1_result.get("native_top5", {}).get("records", [])) + list(s1_result.get("native_controls", {}).get("records", []))
            s1_values = [cycles for record in s1_records if (cycles := _native_cycles(record)) is not None]
            s1_cycles = min(s1_values) if s1_values else s1_result.get("actual_stage_cycles")
        previous = None
        for stage in STAGES:
            value = values.get(stage)
            if value is None:
                continue
            row = stage_row(value, s1=s1_cycles, previous=previous)
            rows.append(row)
            if row.get("native_stage_cycles") is not None:
                previous = row["native_stage_cycles"]
    output = args.output_dir.resolve()
    atomic_write(output / "neighborhood-stage-table.json", {
        "schema": "orbit-neighborhood-stage-table-v1",
        "protocol": "orbit-amoeba-input0-neighborhood-v3",
        "rows": rows,
    })
    output.mkdir(parents=True, exist_ok=True)
    temporary = (output / "neighborhood-stage-table.md").with_name("neighborhood-stage-table.md.partial")
    temporary.write_text(render_markdown(rows))
    temporary.replace(output / "neighborhood-stage-table.md")
    print(f"rendered {len(rows)} neighborhood stage rows under {output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
