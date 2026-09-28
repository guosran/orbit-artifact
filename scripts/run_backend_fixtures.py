#!/usr/bin/env python3
"""Reproduce source-backed small backend fixtures without full-system claims."""
import argparse
from collections import Counter
import math
import json
import os
from pathlib import Path
import re
import sys
import time

from check_environment import probe
from common import RESULTS, ROOT, build_dir, git, llvm_build, now, require_source_clean, run_command, write_json
from run_semantic_closure import new_run_directory, strip_legacy_file_hash_fields


def records(path):
    return [json.loads(line) for line in path.read_text().splitlines() if line]


def strip_jsonl(path):
    path.write_text("".join(json.dumps(strip_legacy_file_hash_fields(row), sort_keys=True) + "\n"
                            for row in records(path)))


def strip_mlir_identity(path):
    content = path.read_text()
    content = re.sub(r',?\s*[A-Za-z0-9_.]*sha256\s*=\s*"[^"]*"', "", content)
    path.write_text(content)


def opt_run(opt, fixture, flags, run_dir, name, output):
    return run_command([opt, fixture, *flags, "-o", output], fixture.parent, run_dir, name)


def enumerate_shapes(src, opt, run_dir, fixture_name, cap, network=False):
    fixture = src / "test/multi-cgra/taskflow/joint-scheduling" / fixture_name
    arch = src / "test/archspec" / ("architecture_4x4_network.yaml" if network else "architecture_4x4.yaml")
    manifest = run_dir / "raw" / (fixture.stem + ".candidates.jsonl")
    opt_run(opt, fixture, ["--enumerate-analytical-task-candidates=output=%s max-cgras-per-task=%d" % (manifest, cap),
                           "--architecture-spec=" + str(arch)], run_dir, "shape-enumeration", "/dev/null")
    rows = records(manifest)
    if rows[0].get("record_type") != "header" or rows[-1].get("record_type") != "footer":
        raise ValueError("shape candidate manifest incomplete")
    return fixture, arch, manifest, rows


def resource(src, opt, run_dir):
    fixture, arch, manifest, rows = enumerate_shapes(src, opt, run_dir,
        "enumerate-complete-shapes.mlir", 4)
    candidates = [r for r in rows if r.get("record_type") == "candidate"]
    if len(candidates) != rows[-1]["candidate_count"] or len(candidates) != 8:
        raise ValueError("4x4 fixture must enumerate eight shapes at per-task cap four")
    header = rows[0]
    if (header["architecture"]["grid_rows"], header["architecture"]["grid_cols"]) != (4, 4):
        raise ValueError("wrong physical CGRA fabric")
    inventory = run_dir / "resource_candidates.jsonl"
    with inventory.open("w") as stream:
        for c in candidates:
            shape = c["task_shapes"][0]["shape"]
            if shape["cgra_count"] > 4:
                raise ValueError("per-task shape exceeds four physical CGRAs")
            item = {"schema": "orbit-resource-fixture-v1", "workload_id": "complete-shapes-fixture",
                    "semantic_graph_id": "fixture:complete-shapes", "source_candidate_id": c["candidate_id"],
                    "resource_candidate_id": "resource:fixture:complete-shapes:" + c["candidate_id"],
                    "logical_task_id": "A", "logical_tile_id": "tile:whole-A",
                    "replica_id": "replica:0", "replica_count": 1,
                    "execution_shard": "whole task domain", "mapped_dfg_instance_count": 1,
                    "mapper_visible_task_body": str(fixture.relative_to(src)),
                    "shape": shape, "physical_cgras": shape["cgra_count"],
                    "fabric_capacity": 16, "max_cgras_per_task": 4,
                    "resource_feasible": True, "task_duration_source": "not measured",
                    "evidence_class": "analytical_estimate", "cost": None,
                    "semantic_legal": True, "backend_legal": True, "artifact_available": True,
                    "measurement_available": False, "status": "not_selected"}
            stream.write(json.dumps(item, sort_keys=True) + "\n")
    strip_jsonl(manifest)
    summary = {"schema": "orbit-resource-fixture-summary-v1", "candidate_count": len(candidates),
               "shape_counts_by_cgras": dict(Counter(str(c["task_shapes"][0]["shape"]["cgra_count"]) for c in candidates)),
               "fabric": {"rows": 4, "cols": 4, "physical_cgras": 16, "mapper_pe_tile": "4x4 per CGRA"},
               "max_cgras_per_task": 4, "replication_source_supported": False,
               "scope": "one-task shape fixture; no replica enumeration"}
    write_json(run_dir / "resource_summary.json", summary)
    return summary


def _parse_tasks(text):
    tasks = []
    for line in text.splitlines():
        match = re.search(r'taskflow\.task @([A-Za-z0-9_]+)', line)
        if not match:
            continue
        positions = re.findall(r'col = (\d+) : i32, context_id = (\d+) : i32, row = (\d+) : i32', line)
        shape = re.search(r'amoeba\.selected_cgra_shape = "([^"]+)"', line)
        tasks.append({"task": match[1], "shape": shape[1] if shape else None,
                      "occupied_cgras": [{"row": int(r), "col": int(c), "context_id": int(t)}
                                         for c, t, r in positions]})
    return tasks


def spatial(src, opt, run_dir):
    fixture, arch, manifest, rows = enumerate_shapes(src, opt, run_dir,
        "materialize-static-shapes.mlir", 2)
    materialized = run_dir / "raw/materialized.mlir"
    orchestrated = run_dir / "raw/orchestrated.mlir"
    opt_run(opt, fixture, ["--materialize-analytical-task-candidate=candidates=%s candidate-id=candidate-6" % manifest,
                           "--architecture-spec=" + str(arch)], run_dir, "materialize-selected", materialized)
    opt_run(opt, materialized, ["--orchestrate-tasks-on-accelerators=orchestration-strategy=analytical-based-task-orchestration scheduling-mode=spatial",
                                "--neura-architecture-spec=" + str(arch)], run_dir, "spatial-placement", orchestrated)
    text = orchestrated.read_text(); tasks = _parse_tasks(text)
    if len(tasks) != 2 or not all(t["occupied_cgras"] for t in tasks):
        raise ValueError("spatial placement not visible in source output")
    channel, network_arch, channel_manifest, _ = enumerate_shapes(src, opt, run_dir,
        "score-scheduler-makespan.mlir", 1, network=True)
    channel_materialized = run_dir / "raw/channel-materialized.mlir"
    channel_orchestrated = run_dir / "raw/channel-orchestrated.mlir"
    opt_run(opt, channel, ["--materialize-analytical-task-candidate=candidates=%s candidate-id=candidate-0" % channel_manifest,
                           "--architecture-spec=" + str(network_arch)], run_dir, "materialize-channel", channel_materialized)
    opt_run(opt, channel_materialized, ["--orchestrate-tasks-on-accelerators=orchestration-strategy=analytical-based-task-orchestration scheduling-mode=spatial-temporal communication-mode=explicit",
                                        "--neura-architecture-spec=" + str(network_arch)], run_dir, "route-channel", channel_orchestrated)
    channel_text = channel_orchestrated.read_text()
    payloads = [int(x) for x in re.findall(r'payload_bits = (\d+) : i64', channel_text)]
    links = re.findall(r'end_cycle = (\d+) : i64, resource_kind = "([^"]+)", row = (\d+) : i32, start_cycle = (\d+) : i64', channel_text)
    if not payloads or payloads[0] != 32 or not links:
        raise ValueError("canonical channel edge did not produce 32-bit routed payload")
    summary = {"schema": "orbit-spatial-fixture-summary-v1", "fabric_capacity": 16,
               "max_cgras_per_task": 2, "selected_source_candidate_id": "candidate-6",
               "placements": tasks, "channel_placements": _parse_tasks(channel_text),
               "communication": {"source": "source TaskEdgeContract channel edge",
                                 "payload_bits": payloads[0], "route_link_reservations": [
                                     {"end_cycle": int(end), "resource_kind": kind,
                                      "row": int(row), "start_cycle": int(start)}
                                     for end, kind, row, start in links]},
               "scope": "fixture placement and one local-channel route; no halo/tensor-wide matrix"}
    write_json(run_dir / "spatial_summary.json", summary)
    for path in (manifest, channel_manifest): strip_jsonl(path)
    for path in (materialized, orchestrated, channel_materialized, channel_orchestrated): strip_mlir_identity(path)
    return summary


def temporal(src, opt, run_dir):
    fixture = src / "test/multi-cgra/taskflow/joint-scheduling/scheduler-release-events.mlir"
    arch = src / "test/archspec/architecture.yaml"
    output = run_dir / "raw/release-events.mlir"
    opt_run(opt, fixture, ["--orchestrate-tasks-on-accelerators=orchestration-strategy=analytical-based-task-orchestration scheduling-mode=spatial-temporal",
                           "--neura-architecture-spec=" + str(arch)], run_dir, "release-event-schedule", output)
    text = output.read_text()
    match = re.search(r'joint_scheduling_predicted_makespan = (\d+) : i64', text)
    if not match or int(match[1]) != 1000005:
        raise ValueError("source scheduler missed independent-task resource release")
    summary = {"schema": "orbit-temporal-fixture-summary-v1", "source_policy": "analytical-critical-priority-spatial-temporal",
               "makespan_cycles": int(match[1]), "tasks": _parse_tasks(text),
               "exact_oracle_scope": None, "beam_width": None,
               "ready_set_trace_available": False,
               "scope": "resource release event fixture; policy matrix unavailable"}
    write_json(run_dir / "temporal_summary.json", summary)
    strip_mlir_identity(output)
    return summary


def cost(src, opt, run_dir):
    _, _, manifest, rows = enumerate_shapes(src, opt, run_dir,
        "score-scheduler-makespan.mlir", 1, network=True)
    candidates = [r for r in rows if r.get("record_type") == "candidate"]
    if len(candidates) != 1:
        raise ValueError("cost fixture candidate count changed")
    tasks = {entry["task"] for entry in candidates[0]["task_shapes"]}
    if tasks != {"A", "B"}:
        raise ValueError("cost fixture task identity changed")
    # Artifact fixture model only: the source-owned score pass requires file
    # hash bindings and cannot be invoked by this no-file-hash artifact.
    durations = {"A": 5, "B": 5}
    channel_scores = [{"candidate_id": candidates[0]["candidate_id"], "evidence_class": "analytical_estimate",
               "model": "fixed-five-cycle-channel-fixture", "cost": {"value": sum(durations.values()),
               "unit": "cycles", "source": "analytical_estimate"}, "status": "selected"}]
    _, _, shape_manifest, shape_rows = enumerate_shapes(src, opt, run_dir,
        "materialize-static-shapes.mlir", 2)
    shape_candidates = [r for r in shape_rows if r.get("record_type") == "candidate"]
    shape_scores = []
    for row in shape_candidates:
        task_costs = {task["task"]: math.ceil(10 / task["shape"]["cgra_count"])
                      for task in row["task_shapes"]}
        shape_scores.append({"candidate_id": row["candidate_id"],
                             "predicted_parallel_makespan_cycles": max(task_costs.values()),
                             "task_duration_cycles": task_costs,
                             "evidence_class": "analytical_estimate"})
    shape_scores.sort(key=lambda r: (r["predicted_parallel_makespan_cycles"], r["candidate_id"]))
    summary = {"schema": "orbit-cost-fixture-summary-v1", "candidate_count": len(shape_scores),
               "selected_source_candidate_id": shape_scores[0]["candidate_id"],
               "estimated_makespan_cycles": shape_scores[0]["predicted_parallel_makespan_cycles"],
               "shape_scores": shape_scores, "channel_fixture_scores": channel_scores,
               "channel_fixture_makespan_cycles": 10,
               "ranking_tie_break": "candidate_id ascending",
               "model": "fixture task duration = ceil(10 / physical CGRAs); independent tasks overlap",
               "source_score_pass_executed": False,
               "scope": "artifact analytical fixture; production score pass requires file-hash contract"}
    write_json(run_dir / "cost_summary.json", summary)
    strip_jsonl(manifest); strip_jsonl(shape_manifest)
    return summary


STAGES = {"resource": resource, "spatial": spatial, "temporal": temporal, "cost": cost}


def run(module):
    src = require_source_clean(); opt = build_dir() / "tools/mlir-amoeba-opt/mlir-amoeba-opt"
    if not opt.is_file():
        raise ValueError("built AMOEBA optimizer missing")
    run_dir = new_run_directory(module)
    (run_dir / "raw").mkdir()
    environment = probe(); write_json(run_dir / "environment.json", environment)
    record = {"schema": "orbit-system-module-run-v1", "module": module,
              "artifact_git_commit": git(ROOT, "rev-parse", "HEAD"),
              "amoeba_git_commit": git(src, "rev-parse", "HEAD"),
              "start_time": now(), "end_time": None, "status": "incomplete",
              "scope": "fixture_only", "output_paths": {}}
    write_json(run_dir / "run.json", record)
    started = time.monotonic()
    try:
        result = STAGES[module](src, opt, run_dir)
        record["status"] = "completed"
        write_json(run_dir / "validation.json", {"schema": "orbit-module-validation-v1",
                    "pass": True, "scope": "fixture_only", "module": module,
                    "reason": result["scope"]})
    except BaseException as error:
        record["error"] = str(error)
        write_json(run_dir / "validation.json", {"schema": "orbit-module-validation-v1",
                    "pass": False, "scope": "fixture_only", "module": module,
                    "error": str(error)})
        raise
    finally:
        record["end_time"] = now(); record["wall_clock_seconds"] = round(time.monotonic() - started, 3)
        record["output_paths"] = {p.name: p.name for p in run_dir.iterdir() if p.is_file()}
        write_json(run_dir / "run.json", record)
        print("run directory:", run_dir, file=sys.stderr)
    return run_dir


if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("module", choices=sorted(STAGES))
    args = ap.parse_args()
    try:
        print(run(args.module))
    except Exception as error:
        print("backend fixture failed:", error, file=sys.stderr)
        sys.exit(1)
