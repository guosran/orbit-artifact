#!/usr/bin/env python3
"""Rebuild the pinned action manifest twice and compare old machine evidence."""
import argparse
import json
from pathlib import Path
import subprocess
import sys

from action_reconciliation import compare, groups, ledger, same_current_run
from common import ROOT, build_dir, git, lock, now, require_source_clean, run_command, write_json

OLD_COMMIT = "7111e8d772fc18f564654f576f7854e63a5c788a"


def without_source_file_bindings(value):
    if isinstance(value, dict):
        return {key: without_source_file_bindings(item) for key, item in value.items()
                if "sha256" not in key.lower() and key not in ("canonical_source_id", "source_identity")}
    if isinstance(value, list):
        return [without_source_file_bindings(item) for item in value]
    return value


def write_ledger(path, rows):
    with path.open("w") as output:
        for row in rows:
            output.write(json.dumps(row, sort_keys=True) + "\n")


def run(old_manifest_path, output):
    if output.exists():
        raise ValueError("output already exists; use a new empty result directory: " + str(output))
    old = json.loads(old_manifest_path.read_text())
    src = require_source_clean()
    opt = build_dir() / "tools/mlir-amoeba-opt/mlir-amoeba-opt"
    fixture = src / "test/multi-cgra/taskflow/joint-scheduling/orbit_joint_pipeline_8x8_i32.mlir"
    if not opt.is_file() or not fixture.is_file():
        raise ValueError("pinned C++ optimizer or canonical fixture missing")
    output.mkdir(parents=True)
    (output / "raw").mkdir()
    record = {"schema": "orbit-action-reconciliation-run-v1", "status": "incomplete",
              "start_time": now(), "end_time": None, "old_protocol_commit": OLD_COMMIT,
              "old_manifest_input": str(old_manifest_path),
              "current_protocol_commit": git(src, "rev-parse", "HEAD"),
              "artifact_git_commit": git(ROOT, "rev-parse", "HEAD")}
    write_json(output / "run.json", record)
    try:
        if record["current_protocol_commit"] != lock()["amoeba"]["commit"]:
            raise ValueError("current source differs from pinned lock")
        if old.get("complete") is not True or old["statistics"]["action_attempts"] != 5280:
            raise ValueError("old raw manifest is incomplete or not the 5280 protocol")
        if old["function"] != "gemm_then_add_8x8_i32" or old["statistics"]["max_depth"] != 8:
            raise ValueError("unexpected old protocol input or depth")
        current = []
        for number in (1, 2):
            path = output / "raw" / ("current_%d.json" % number)
            run_command([opt, fixture, "--verify-each",
                         "--enumerate-joint-semantic-rewrites=output=%s max-depth=8 max-actions=50000 tile-factor=0" % path,
                         "-o", "/dev/null"], src, output, "enumerate-%d" % number)
            raw = json.loads(path.read_text())
            if raw.get("complete") is not True:
                raise ValueError("current enumerator published incomplete manifest")
            current.append(raw)
            write_json(path, without_source_file_bindings(raw))
        fields = ("function", "dimensions", "dtype", "layout", "arithmetic_semantics",
                  "tile_factor", "tile_factor_filter", "enumerated_tile_factors")
        comparability = {field: old[field] == current[0][field] for field in fields}
        fixture_relative = "test/multi-cgra/taskflow/joint-scheduling/orbit_joint_pipeline_8x8_i32.mlir"
        old_fixture = subprocess.check_output(["git", "-C", str(src), "show", OLD_COMMIT + ":" + fixture_relative])
        comparability.update({
            "tracked_source_fixture_equal": old_fixture == fixture.read_bytes(),
            "action_registry_equal_without_executability": [
                (a["kind"], a.get("tile_size"), a["pass"]) for a in old["action_catalog"]] == [
                (a["kind"], a.get("tile_size"), a["pass"]) for a in current[0]["action_catalog"]],
            "max_depth_equal": old["statistics"]["max_depth"] == current[0]["statistics"]["max_depth"],
            "max_actions_equal": old["statistics"]["max_actions"] == current[0]["statistics"]["max_actions"],
        })
        if not all(comparability.values()):
            raise ValueError("old and current protocol inputs differ: " + str(comparability))
        old_rows = ledger(old, "old_7111e8d")
        current_rows = ledger(current[0], "current_a57376e")
        rerun_rows = ledger(current[1], "current_a57376e")
        stable = same_current_run(current[0], current[1]) and current_rows == rerun_rows
        write_ledger(output / "old_protocol_actions.jsonl", old_rows)
        write_ledger(output / "current_protocol_actions.jsonl", current_rows)
        write_ledger(output / "current_protocol_rerun_actions.jsonl", rerun_rows)
        diff = compare(old_rows, current_rows, old, current[0])
        diff["input_comparability"] = comparability
        diff["deterministic_current_rerun"] = stable
        write_json(output / "action_count_diff.json", diff)
        frozen = json.loads((ROOT / "config/expected_semantic_closure.json").read_text())
        count_matches_frozen = current[0]["statistics"]["action_attempts"] == frozen["attempted_actions"]
        summary = {
            "schema": "orbit-action-count-summary-v1",
            "old_protocol": {"commit": OLD_COMMIT, "statistics": old["statistics"],
                             "groups": groups(old_rows), "witnesses_executable": sum(
                                 c["witness"]["executable"] for c in old["candidates"])},
            "current_protocol": {"commit": record["current_protocol_commit"],
                                 "statistics": current[0]["statistics"],
                                 "groups": groups(current_rows), "witnesses_executable": sum(
                                     c["witness"]["executable"] for c in current[0]["candidates"])},
            "current_rerun": {"statistics": current[1]["statistics"],
                              "groups": groups(rerun_rows), "ledger_equal": stable},
            "reconciliation_verdict": "PARTIAL",
            "contract_verdict": "PENDING_FULL_REPRODUCTION" if count_matches_frozen else "NO-GO",
            "contract_reason": "640 extra queue visits repeat existing canonical input/action pairs; historical 5280 also includes witness-upgrade revisits",
        }
        write_json(output / "action_count_summary.json", summary)
        if not stable:
            raise ValueError("current action ledger is nondeterministic across clean reruns")
        record["status"] = "completed"
    except BaseException as error:
        record["error"] = str(error)
        raise
    finally:
        record["end_time"] = now()
        write_json(output / "run.json", record)
    return output


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--old-manifest", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    try:
        print(run(args.old_manifest.resolve(), args.output.resolve()))
    except Exception as error:
        print("action reconciliation failed:", error, file=sys.stderr)
        sys.exit(1)
