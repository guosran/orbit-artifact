#!/usr/bin/env python3
"""Fail closed on missing output, schema drift, or first frozen invariant mismatch."""
import argparse
import json
from pathlib import Path
import sys

from common import RESULTS, ROOT, write_json


def check_schema(data, schema_path):
    """Validate the required JSON Schema subset without a package dependency."""
    schema = json.loads(schema_path.read_text())
    if not isinstance(data, dict):
        raise ValueError("schema root must be an object: " + schema_path.name)
    for key in schema["required"]:
        if key not in data:
            raise ValueError("schema missing field %s: %s" % (key, schema_path.name))
    types = {"string": str, "integer": int, "object": dict, "array": list, "null": type(None)}
    for key, rule in schema["properties"].items():
        if key not in data:
            continue
        value = data[key]
        if "const" in rule and value != rule["const"]:
            raise ValueError("schema constant mismatch: " + key)
        if "enum" in rule and value not in rule["enum"]:
            raise ValueError("schema enum mismatch: " + key)
        if "type" in rule:
            allowed = rule["type"] if isinstance(rule["type"], list) else [rule["type"]]
            if not any(type(value) is types[name] for name in allowed):
                raise ValueError("schema type mismatch: " + key)
        if isinstance(value, str) and (len(value) < rule.get("minLength", 0) or len(value) > rule.get("maxLength", 10**9)):
            raise ValueError("schema length mismatch: " + key)
        if isinstance(value, int) and "minimum" in rule and value < rule["minimum"]:
            raise ValueError("schema minimum mismatch: " + key)


def latest_run():
    paths = sorted(p for p in RESULTS.iterdir() if p.is_dir() and (p / "run.json").exists())
    if not paths:
        raise ValueError("no run results found")
    return paths[-1]


def validate(path, require_full=True):
    required = ("run.json", "environment.json", "commands.jsonl", "semantic_summary.json",
                "graph_inventory.jsonl", "execution_summary.json", "negative_control.json")
    for name in required:
        if not (path / name).is_file() or (path / name).stat().st_size == 0:
            raise ValueError("missing required result: " + name)
    run = json.loads((path / "run.json").read_text())
    semantic = json.loads((path / "semantic_summary.json").read_text())
    execution = json.loads((path / "execution_summary.json").read_text())
    negative = json.loads((path / "negative_control.json").read_text())
    environment = json.loads((path / "environment.json").read_text())
    check_schema(run, ROOT / "schemas/run_result.schema.json")
    check_schema(semantic, ROOT / "schemas/semantic_summary.schema.json")
    if run.get("status") != "completed" or run.get("completed_stage") != "numeric":
        raise ValueError("run is incomplete; cannot promote to pass")
    if run.get("artifact_schema_version") != "orbit-semantic-artifact-v1":
        raise ValueError("unsupported run schema")
    if environment.get("source_commit") != run.get("amoeba_git_commit"):
        raise ValueError("environment source commit differs from run")
    for key in (() if not require_full else ("identity", "m_tiling", "n_tiling", "mn_tiling", "sequential_k",
                "parallel_linear", "parallel_tree", "whole_fusion", "tile_local_fusion",
                "reduction_consumer_fusion", "tile_to_fuse", "fuse_to_tile",
                "commutative_order_equivalence", "rejected_illegal_compositions")):
        if semantic["coverage"].get(key) is not True:
            raise ValueError("missing coverage: " + key)
    ids = [json.loads(line)["graph_id"] for line in (path / "graph_inventory.jsonl").read_text().splitlines()]
    if ids != semantic["graph_ids"] or ids != execution["graph_ids"]:
        raise ValueError("graph inventory IDs differ from summaries")
    reference = json.loads((ROOT / "reference/semantic_closure_summary.json").read_text())
    if require_full and ids != reference["graph_ids"]:
        first = next((i for i, pair in enumerate(zip(ids, reference["graph_ids"])) if pair[0] != pair[1]),
                     min(len(ids), len(reference["graph_ids"])))
        raise ValueError("graph ID mismatch at index %d" % first)
    expected = json.loads((ROOT / "config/expected_semantic_closure.json").read_text())
    actual = {**semantic, **execution,
              "negative_control_injected_mismatches": negative.get("injected_mismatches"),
              "negative_control_detected_mismatches": negative.get("detected_mismatches")}
    for key in ("attempted_actions", "unique_semantic_graphs", "materialized_witnesses",
                "mlir_verified", "graph_fact_matches", "host_execution_runs",
                "element_comparisons", "numeric_mismatches",
                "negative_control_injected_mismatches", "negative_control_detected_mismatches"):
        if require_full and actual.get(key) != expected[key]:
            raise ValueError("%s: expected %s, observed %s" % (key, expected[key], actual.get(key)))
    return {"schema": "orbit-validation-v1", "pass": True,
            "checked_run": str(path), "checked_invariants": list(expected)}


def validate_module(path):
    run = json.loads((path / "run.json").read_text())
    if run.get("schema") != "orbit-system-module-run-v1" or run.get("status") != "completed":
        raise ValueError("module run is incomplete")
    if not (path / "commands.jsonl").is_file() or not (path / "commands.jsonl").read_text().strip():
        raise ValueError("module command log missing")
    module = run["module"]
    summary = json.loads((path / (module + "_summary.json")).read_text())
    if module == "resource":
        rows = [json.loads(line) for line in (path / "resource_candidates.jsonl").read_text().splitlines()]
        if summary["candidate_count"] != 8 or len(rows) != 8 or summary["fabric"]["physical_cgras"] != 16:
            raise ValueError("resource fixture shape count or fabric differs")
        if any(r["physical_cgras"] > 4 or r["logical_tile_id"] == r["replica_id"] for r in rows):
            raise ValueError("resource fixture violates shape or tile/replica contract")
    elif module == "spatial":
        if len(summary["placements"]) != 2 or summary["communication"]["payload_bits"] != 32:
            raise ValueError("spatial fixture placement or payload differs")
        if not summary["communication"]["route_link_reservations"]:
            raise ValueError("spatial route reservation missing")
    elif module == "temporal":
        if summary["makespan_cycles"] != 1000005 or len(summary["tasks"]) != 2:
            raise ValueError("temporal release-event fixture differs")
    elif module == "cost":
        scores = summary["shape_scores"]
        if len(scores) != 9 or scores[0]["candidate_id"] != summary["selected_source_candidate_id"]:
            raise ValueError("analytical fixture ranking differs")
        if scores != sorted(scores, key=lambda row: (row["predicted_parallel_makespan_cycles"], row["candidate_id"])):
            raise ValueError("analytical fixture tie-breaking differs")
        if summary["channel_fixture_makespan_cycles"] != 10 or summary["source_score_pass_executed"]:
            raise ValueError("analytical fixture evidence classification differs")
    else:
        raise ValueError("unknown module result: " + module)
    return {"schema": "orbit-module-validation-v1", "pass": True, "scope": "fixture_only",
            "module": module, "reason": summary["scope"]}


def main():
    ap = argparse.ArgumentParser(); ap.add_argument("run_dir", nargs="?", type=Path)
    args = ap.parse_args(); path = args.run_dir or latest_run()
    try:
        run = json.loads((path / "run.json").read_text())
        result = (validate_module(path) if run.get("schema") == "orbit-system-module-run-v1" else
                  validate(path, require_full="semantic" in path.name))
    except (KeyError, ValueError, OSError, json.JSONDecodeError) as error:
        result = {"schema": "orbit-validation-v1", "pass": False, "error": str(error)}
    write_json(path / "validation.json", result)
    print(json.dumps(result, indent=2, sort_keys=True))
    return 0 if result["pass"] else 1


if __name__ == "__main__":
    sys.exit(main())
