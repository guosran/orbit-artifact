#!/usr/bin/env python3
"""Run the source-owned Joint/Sequential comparison with isolated caches.

This coordinator never generates, scores or ranks a candidate. It invokes
neighborhood_replay.py, which consumes the compiler's shortlist and controls.
"""
from __future__ import annotations

import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
import json
import hashlib
import os
from pathlib import Path
from queue import Queue, Empty
import shutil
import subprocess
import sys
import time

import neighborhood_replay as replay

ROOT = Path(__file__).resolve().parents[1]
WORKLOADS = ("gcn", "harris", "llama", "lu", "radar")
METHODS = (("joint", "joint", 50), ("sequential-50", "sequential", 50),
           ("sequential-25", "sequential", 25), ("sequential-75", "sequential", 75))
TRANSFER_METHOD = ("sequential-50-transfer", "sequential", 50)


def read(path):
    return json.loads(Path(path).read_text())


def file_binding(path):
    path = Path(path)
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return {"path": str(path), "sha256": digest.hexdigest(), "size": path.stat().st_size}


def write_exact(path, value):
    text = json.dumps(value, indent=2, sort_keys=True) + "\n"
    if path.exists():
        if path.read_text() != text:
            raise ValueError(f"binding differs; choose a fresh output namespace: {path}")
    else:
        replay.atomic_write(path, value)


def complete(cell):
    path = cell / "result.json"
    if not path.is_file():
        return False
    value = read(path)
    records = value.get("native_top5", {}).get("records", []) + value.get("native_controls", {}).get("records", [])
    return (len(value.get("top5", [])) == 5 and len(value.get("controls", [])) == 2
            and len(records) == 7 and all(
                row.get("status") == "native_replayed" and row.get("numeric") == "pass"
                and row.get("mapper_equality") == "pass" and row.get("independent_trace") == "pass"
                for row in records))


def make_protocol(template, budget, rounds, scoring_workers, round_score_quota=None,
                  search_stage="full-joint", budget_policy="fixed-split"):
    round_score_quota = round_score_quota or (budget + 7) // 8
    protocol = read(template)
    protocol["experiment_kind"] = "joint-versus-sequential"
    protocol["scope"] = "Five fixed input-0 programs: standalone Joint versus graph-then-resource Sequential; original Ray remains excluded"
    protocol["budget_profile"] = f"matched-objective-calls-{budget}-fixed-round-quota-{round_score_quota}"
    protocol["source_variant"] = "sequential-comparison-v4-objective-controlled"
    protocol["source_binding"] = "Exact serialized compiler/source/model witnesses plus SHA-256 content guards for executable, protocol, inputs and replay reuse; cost cache identity unchanged"
    protocol["search"].update(max_rounds=rounds, round_score_quota=round_score_quota,
        max_unique_complete_candidates_scored=budget, beam_width=16, diversity_min_slots=4)
    protocol["execution"]["scoring_workers"] = scoring_workers
    protocol["comparison_search_stage"] = search_stage
    protocol.pop("historical_native_winners", None)
    protocol["decision_flow_comparison"] = {
        "primary_graph_budget_percent": 50, "sensitivity_graph_budget_percent": [25, 75],
        "objective_budget_unit": "every complete-program production scheduler invocation, including rejected schedules and initialization",
        "stage_a_budget": "floor(total * graph_percent / 100), including identity",
        "stage_b_budget": "total - stage_a_allocation; unspent A allocation is not transferred",
        "round_controller": "identical fixed objective quota per expansion round; no independent phase depth cap; common max_rounds is a nonbinding safety ceiling; B continues cumulative registry menu index",
        "round_score_quota": round_score_quota, "round_safety_cap": rounds,
        "joint_max_rounds": rounds, "sequential_max_rounds_per_phase": rounds,
        "rounds_are_search_budget": False,
        "initial_candidate": "same canonical graph, supported-shape bootstrap, replica one; no inherited S1-S5 winner",
        "final_validation": "five C++ predicted shortlist records plus identity and search_anchor controls for both methods; Joint anchor is best legal result in first half-budget",
        "cache_policy": "identical immutable prepared canonical catalogs and initial predictor cache copied per cell; private transformed graph, objective and mapper caches; Sequential preserves caches within and across phases",
        "additional_costs": "common input preparation reported separately; every cell records initialization, legality/prediction queries, actual mapping and wall time",
        "seed_policy": "deterministic controller; one run per distinct configuration; no artificial repeated seeds",
        "temporal_policy": "production spatial-temporal scheduler, critical-path dispatch, explicit communication; no arbitrary start-time search",
        "speedup_direction": "Sequential native cycles / Joint native cycles",
        "ray_policy": "original Ray exclusion; no fission substitution",
    }
    if search_stage == "full-joint-fission":
        cap = protocol["search"].get("max_fission_actions_per_task")
        if not isinstance(cap, int) or isinstance(cap, bool) or cap <= 0:
            raise ValueError("fission comparison requires a bound positive per-task complete-cut cap")
        protocol["stage_scheme"] = search_stage
        if not any(row.get("name") == search_stage for row in protocol.get("stages", [])):
            protocol["stages"].append({"stage": 6, "name": search_stage,
                "dimensions": ["shape", "replica", "tiling", "fusion", "fission"], "dispatch": "critical-path"})
        protocol["source_variant"] = "sequential-fixed-trunk-fission-objective-controlled"
        protocol["experimental_fission_in_main_ablation"] = True
        protocol["decision_flow_comparison"].update(
            graph_actions_include_fission=True,
            typed_action_replay_memo_policy="disabled-until-exact-action-prefix-restoration-is-proven-v1",
            runtime_replay_cache=False,
            structural_resource_initialization="current legal shape else first supported formal shape; feasibility only, same rule for Joint structural candidates and phase A",
            freeze_policy="exact Neura structural typed prefix and separate source fissionActions; resource suffix may expand physical replicas")
    if budget_policy == "transfer-unused":
        protocol["experiment_kind"] = "sequential-budget-transfer-supplement"
        protocol["decision_flow_comparison"].update(
            sequential_budget_policy=budget_policy,
            sensitivity_graph_budget_percent=[],
            stage_b_budget="nominal B plus unused nominal A only on no-new-legal-candidates",
            comparison_role="separate supplementary variant; original fixed 50/50 main table unchanged")
    elif budget_policy != "fixed-split":
        raise ValueError("unknown sequential budget policy")
    return protocol


def method_protocol(common, flow):
    value = json.loads(json.dumps(common))
    design = value["decision_flow_comparison"]
    value["decision_flow_comparison"]["active_flow"] = flow
    return value


def prepare_inputs(config, output):
    source = read(config)
    entries = {}
    cache_seed_records = {}
    started = time.monotonic()
    for workload in (*WORKLOADS, "raytracing"):
        if workload not in source["workloads"]:
            continue
        entry = {**source.get("defaults", {}), **source["workloads"][workload]}
        dest = output / "inputs" / workload
        dest.mkdir(parents=True, exist_ok=True)
        paths = {}
        for key in ("canonical", "parent_cost_file", "cost_cache"):
            original = (config.parent / entry[key]).resolve()
            target = dest / original.name
            if target.exists() and target.read_bytes() != original.read_bytes():
                raise ValueError(f"input changed since binding: {original}")
            if not target.exists():
                shutil.copyfile(original, target)
            paths[key] = str(target)
        if entry.get("prepared_source_file"):
            original = (config.parent / entry["prepared_source_file"]).resolve()
            target = dest / "prepared-source.mlir"
            if target.exists() and target.read_bytes() != original.read_bytes():
                raise ValueError(f"prepared fission source changed since binding: {original}")
            if not target.exists():
                shutil.copyfile(original, target)
            paths["prepared_source_file"] = str(target)
        if entry.get("function"):
            paths["function"] = entry["function"]
        entries[workload] = paths
        catalog = read(paths["parent_cost_file"])
        meta = catalog.get("predictor_metadata", {})
        preparation_steps = []
        source_dir = (config.parent / entry["canonical"]).resolve().parent
        for command_path in sorted((source_dir / "steps").glob("*.command.json")):
            command = read(command_path)
            preparation_steps.append({"source_path": str(command_path), **command})
        cache_meta = meta.get("ml_cache", {})
        cache_seed_records[workload] = {
            "source_config": str(config), "canonical": paths["canonical"],
            "catalog_entries": len(catalog["entries"]),
            "input_contents": {key: file_binding(paths[key]) for key in ("canonical", "parent_cost_file", "cost_cache")},
            "prepared_prediction_cache_entries": len(read(paths["cost_cache"])["entries"]),
            "common_preparation_ml_cache": meta.get("ml_cache"),
            "common_preparation_steps": preparation_steps,
            "common_preparation_wall_seconds": sum(row.get("ended_unix", 0) - row.get("started_unix", 0) for row in preparation_steps),
            "common_preparation_direct_model_inferences": cache_meta.get("hits", 0) + cache_meta.get("misses", 0),
            "common_preparation_actual_mapper_calls": 0,
            "additional_training_or_calibration": False,
            "source_namespace": meta.get("source_commit"),
            "reuse_rule": "canonical witnesses and every prepared input byte shared identically across all flows; no transformed-graph warm cache",
        }
    write_exact(output / "input-binding.json", cache_seed_records)
    return entries, time.monotonic() - started


def run_cell(args, workload, method, entry, protocol, cpus):
    prelaunch_started = time.monotonic()
    label, flow, percent = method
    cell = args.output_root / workload / label
    cell.mkdir(parents=True, exist_ok=True)
    common_protocol = protocol
    protocol = cell / "protocol.json"
    write_exact(protocol, method_protocol(read(common_protocol), flow))
    method_rounds = read(protocol)["search"]["max_rounds"]
    search_stage = read(protocol).get("comparison_search_stage", "full-joint")
    if search_stage == "full-joint-fission" and not entry.get("prepared_source_file"):
        raise ValueError(f"fission comparison requires prepared source for {workload}")
    binding = {"workload": workload, "method": label, "decision_flow": flow,
        "graph_budget_percent": percent, "protocol": read(protocol),
        "inputs": entry, "optimizer": str(args.optimizer),
        "source_contract": str(args.source_contract_file), "cpus": cpus,
        "content_binding": {key: file_binding(value) for key, value in {
            "optimizer": args.optimizer, "source_contract": args.source_contract_file,
            "protocol": protocol, "common_protocol": common_protocol, "model": args.model, "architecture": args.architecture,
            "network": args.inter_task_network, "sram": args.sram_config,
            "canonical": entry["canonical"], "parent_cost_file": entry["parent_cost_file"],
            "initial_predictor_cache": entry["cost_cache"],
            "coordinator": ROOT / "scripts/run_sequential_comparison.py",
            "replay": ROOT / "scripts/neighborhood_replay.py",
            "native_replay": ROOT / "scripts/replay_cpp_global_top5.py",
            **({"prepared_source": entry["prepared_source_file"]} if search_stage == "full-joint-fission" else {})}.items()},
        "mapper_cache_policy": "fresh private cache per workload and method; retained only within this run"}
    write_exact(cell / "comparison-binding.json", binding)
    stored_search_binding = cell / "search-input-binding.json"
    if (cell / "search/global-top5.jsonl").is_file() or (cell / "result.json").is_file():
        if not stored_search_binding.is_file() or read(stored_search_binding) != binding:
            raise ValueError(f"unauthenticated saved search; choose a fresh namespace: {cell}")
    if complete(cell):
        return {"workload": workload, "method": label, "status": "already-validated"}
    # Replay retries retain the exact shortlist but start with an empty mapper
    # cache. Preserve earlier evidence/calls rather than hiding warm retry cost.
    if (cell / "native-top5").exists() or (cell / "native-controls").exists():
        attempts = cell / "validation-attempts"
        attempts.mkdir(exist_ok=True)
        archive = attempts / f"attempt-{len(list(attempts.iterdir())) + 1}"
        archive.mkdir()
        for name in ("native-top5", "native-controls", "mapping-cache", "result.json",
                     "execution.json", "coordinator.stdout.log", "coordinator.stderr.log"):
            path = cell / name
            if path.exists():
                path.rename(archive / name)
    predictor_cache = cell / "predictor-cache.json"
    if not predictor_cache.exists():
        shutil.copyfile(entry["cost_cache"], predictor_cache)
    argv = [sys.executable, str(ROOT / "scripts/neighborhood_replay.py"),
        "--workload", workload, "--stage", search_stage, "--decision-flow", flow,
        "--graph-budget-percent", str(percent), "--canonical", entry["canonical"],
        "--parent-cost-file", entry["parent_cost_file"], "--cost-cache", str(predictor_cache),
        "--model", str(args.model), "--optimizer", str(args.optimizer),
        "--architecture", str(args.architecture), "--protocol", str(protocol),
        "--source-contract-file", str(args.source_contract_file),
        "--inter-task-network", str(args.inter_task_network),
        "--sram-config", str(args.sram_config), "--mapping-cache", str(cell / "mapping-cache"),
        "--output-dir", str(cell), "--max-candidates", str(args.budget),
        "--max-rounds", str(method_rounds), "--beam-width", "16", "--diversity-slots", "4",
        "--jobs", str(args.cpus_per_worker)]
    if entry.get("function"):
        argv.extend(["--function", entry["function"]])
    if search_stage == "full-joint-fission":
        argv.extend(["--prepared-source-file", entry["prepared_source_file"],
                     "--stage-initialization", "independent"])
    # Search outputs are durable; a completed search can resume final replay
    # without acquiring a new search budget or a different shortlist.
    if (cell / "search/global-top5.jsonl").is_file():
        argv.append("--skip-search")
    elif (cell / "checkpoint.json").exists():
        raise ValueError(f"interrupted standalone search: inspect its saved binding before restart in a new namespace: {cell}")
    write_exact(stored_search_binding, binding)
    if cpus:
        argv = ["taskset", "-c", ",".join(map(str, cpus)), *argv]
    started = time.monotonic()
    initialization_seconds = started - prelaunch_started
    with (cell / "coordinator.stdout.log").open("a") as stdout, (cell / "coordinator.stderr.log").open("a") as stderr:
        process = subprocess.run(argv, cwd=ROOT, stdout=stdout, stderr=stderr)
    record = {"workload": workload, "method": label, "argv": argv,
        "exit_code": process.returncode, "elapsed_seconds": time.monotonic() - started,
        "coordinator_initialization_wall_seconds": initialization_seconds,
        "elapsed_cell_seconds_including_coordinator_initialization": time.monotonic() - prelaunch_started,
        "status": "validated" if complete(cell) else "incomplete"}
    replay.atomic_write(cell / "execution.json", record)
    print(json.dumps({k: v for k, v in record.items() if k != "argv"}), flush=True)
    return record


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for flag in ("config", "optimizer", "source-contract-file", "model", "architecture",
                 "inter-task-network", "sram-config", "output-root"):
        parser.add_argument("--" + flag, type=Path, required=True)
    parser.add_argument("--protocol-template", type=Path,
        default=ROOT / "reference/input0-neighborhood/protocol-2x2-direct-model-template.json")
    parser.add_argument("--budget", type=int, default=4096)
    parser.add_argument("--max-rounds", type=int,
        help="Common nonbinding safety ceiling; defaults to twice the objective allowance")
    parser.add_argument("--round-score-quota", type=int,
        help="Common fixed objective quota per expansion round; defaults to ceil(total allowance / 8)")
    parser.add_argument("--workers", type=int, default=3)
    parser.add_argument("--cpus-per-worker", type=int, default=4)
    parser.add_argument("--compact-completed", action="store_true",
        help="After validation, losslessly compact this cell before the lane starts its next search; storage overhead is recorded separately")
    parser.add_argument("--workloads", nargs="+", choices=WORKLOADS, default=list(WORKLOADS))
    parser.add_argument("--methods", nargs="+", choices=[m[0] for m in METHODS], default=[m[0] for m in METHODS])
    parser.add_argument("--search-stage", choices=("full-joint", "full-joint-fission"), default="full-joint")
    parser.add_argument("--sequential-budget-policy", choices=("fixed-split", "transfer-unused"), default="fixed-split")
    parser.add_argument("--lane-release-files", nargs="+", type=Path,
        help="Optional prior-run execution records; a lane starts only after its prior process has exited")
    args = parser.parse_args()
    args.max_rounds = args.max_rounds or 2 * args.budget
    args.round_score_quota = args.round_score_quota or (args.budget + 7) // 8
    if args.budget < 32 or args.max_rounds < 2 * args.budget or args.round_score_quota < 1 or args.workers * args.cpus_per_worker > 12:
        parser.error("budget >=32, nonbinding round cap >=2*budget, positive common quota, and at most twelve host CPUs required")
    for key, value in vars(args).items():
        if isinstance(value, Path):
            setattr(args, key, value.resolve())
    if args.lane_release_files and len(args.lane_release_files) != args.workers:
        parser.error("one release file is required per CPU lane")
    if args.lane_release_files:
        args.lane_release_files = [p.resolve() for p in args.lane_release_files]
        if len(set(args.lane_release_files)) != args.workers:
            parser.error("CPU lane release files must be distinct")
    args.output_root.mkdir(parents=True, exist_ok=True)
    protocol_path = args.output_root / "protocol.json"
    if args.sequential_budget_policy == "transfer-unused" and args.methods != ["sequential-50"]:
        parser.error("transfer-unused requires --methods sequential-50 in a separate output namespace")
    method_specs = [m for m in METHODS if m[0] in args.methods]
    if args.sequential_budget_policy == "transfer-unused":
        method_specs = [TRANSFER_METHOD]
    protocol = make_protocol(args.protocol_template, args.budget, args.max_rounds, args.cpus_per_worker,
                             args.round_score_quota, args.search_stage, args.sequential_budget_policy)
    protocol["execution"].update(workload_lanes=args.workers, cpus_per_lane=args.cpus_per_worker,
                                  max_host_cores=args.workers * args.cpus_per_worker)
    contract = read(args.source_contract_file)
    if contract["model_namespace"] != protocol["model_namespace"] or contract["source_commit"] != protocol["source_commit"]:
        raise ValueError("source/model contract does not match the common cost namespace")
    protocol.update(active=True, optimizer_pin=str(args.optimizer), source_contract_file=str(args.source_contract_file),
        project_source_commit=contract["published_source_commit"], source_dirty_build=contract["source_dirty"],
        canonical_program_pattern=str(args.output_root / "inputs/<workload>/canonical.mlir"),
        architecture=str(args.architecture), model_ensemble=str(args.model),
        inter_task_network_spec=str(args.inter_task_network), sram_capacity_config=str(args.sram_config))
    write_exact(protocol_path, protocol)
    entries, copy_time = prepare_inputs(args.config, args.output_root)
    replay.atomic_write(args.output_root / "coordinator-initialization.json", {
        "input_snapshot_seconds": copy_time,
        "description": "Shared exact input copies and provenance checks; per-cell binding and private seed-copy time is recorded in execution.json",
        "additional_predictor_calls": 0, "additional_mapper_calls": 0,
        "additional_training_or_calibration": False})
    available = sorted(os.sched_getaffinity(0))
    if len(available) < args.workers * args.cpus_per_worker:
        raise ValueError("insufficient CPU affinity for disjoint lanes")
    lanes = [available[i * args.cpus_per_worker:(i + 1) * args.cpus_per_worker] for i in range(args.workers)]
    write_exact(args.output_root / "experiment-plan.json", {
        "schema": "orbit-sequential-comparison-plan-v1", "budget": args.budget,
        "main_graph_budget_percent": 50, "sensitivity_graph_budget_percents": [25, 75],
        "joint_max_rounds": args.max_rounds,
        "sequential_max_rounds_per_phase": args.max_rounds,
        "common_round_score_quota": args.round_score_quota,
        "round_safety_cap": args.max_rounds,
        "round_limit_policy": "safety ceiling, not the search allowance or a phase depth allocation",
        "source_contract": str(args.source_contract_file), "cpu_lanes": lanes,
        "workloads": args.workloads, "methods": [m[0] for m in method_specs],
        "job_assignment": "shared FIFO of independent workload/method cells; each active cell owns one disjoint four-CPU lane",
        "lane_release_files": [str(p) for p in args.lane_release_files] if args.lane_release_files else [],
        "joint_result_reuse": False, "training_rerun": False,
        "completed_storage_policy": ("synchronous exact-byte auxiliary archive and journal gzip before next cell" if args.compact_completed else "plain evidence"),
        "input_reuse": "fixed v38 canonical sources/catalogs, equal per-cell cache seed",
        "coordinator_payloads": [{"path": str(ROOT / "scripts" / filename),
                                  "exact_bytes": (ROOT / "scripts" / filename).read_text()}
                                 for filename in (("run_sequential_comparison.py", "neighborhood_replay.py", "compact_sequential_raw.py")
                                                  if args.compact_completed else ("run_sequential_comparison.py", "neighborhood_replay.py"))],
    })
    jobs = Queue()
    for workload in args.workloads:
        for method in method_specs:
            jobs.put((workload, method))
    def run_lane(index):
        records = []
        if args.lane_release_files:
            guard = args.lane_release_files[index]
            wait_started = time.monotonic()
            while not guard.is_file():
                time.sleep(1)
            released = read(guard)
            if not isinstance(released.get("exit_code"), int):
                raise ValueError(f"CPU lane release has no completed process: {guard}")
            replay.atomic_write(args.output_root / "lane-releases" / f"lane-{index}.json",
                {"source_execution": released, "source_path": str(guard),
                 "wait_seconds": time.monotonic() - wait_started, "cpus": lanes[index]})
        while True:
            try:
                workload, method = jobs.get_nowait()
            except Empty:
                break
            record = run_cell(args, workload, method, entries[workload], protocol_path, lanes[index])
            if args.compact_completed and record["status"] in {"validated", "already-validated"}:
                # Import after coordinator initialization to avoid a module cycle.
                import compact_sequential_raw as storage
                cell = args.output_root / workload / method[0]
                overhead = storage.compact(cell)
                if overhead is not None:
                    replay.atomic_write(cell / "storage-overhead.json", overhead)
                    record["storage_compaction"] = overhead
                import spill_sequential_catalogues as spill
                import cleanup_completed_sequential_intermediates as checkpoint_storage
                record["archived_staged_catalogues_removed"] = spill.cleanup_archived(cell)
                record["completed_checkpoint_compaction"] = checkpoint_storage.compact_checkpoint(cell, apply=True)
            records.append(record)
            jobs.task_done()
        return records
    started = time.monotonic()
    results = []
    with ThreadPoolExecutor(max_workers=args.workers) as pool:
        for future in as_completed([pool.submit(run_lane, i) for i in range(args.workers)]):
            results.extend(future.result())
            replay.atomic_write(args.output_root / "batch.json", {"status": "running", "cells": results})
    value = {"status": "complete" if all(r["status"] in {"validated", "already-validated"} for r in results) else "incomplete",
             "cells": results, "input_snapshot_seconds": copy_time,
             "batch_wall_seconds": time.monotonic() - started}
    replay.atomic_write(args.output_root / "batch.json", value)
    return 0 if value["status"] == "complete" else 2


if __name__ == "__main__":
    raise SystemExit(main())
