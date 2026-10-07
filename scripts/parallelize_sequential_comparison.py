#!/usr/bin/env python3
"""Add a second four-CPU lane, retaining the already-running first cell."""
import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
from collections import deque
import importlib.util
import json
import os
from pathlib import Path
import sys
import threading
import time
from types import SimpleNamespace


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--results-root", type=Path, required=True)
    parser.add_argument("--runtime-root", type=Path, required=True)
    parser.add_argument("--staging-root", type=Path, required=True)
    options = parser.parse_args()
    root, runtime, staging = (p.resolve() for p in
        (options.results_root, options.runtime_root, options.staging_root))
    sys.path.insert(0, str(runtime / "scripts"))
    spec = importlib.util.spec_from_file_location("bound_comparison", runtime / "scripts/run_sequential_comparison.py")
    comparison = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(comparison)
    import compact_sequential_raw as storage
    import spill_sequential_catalogues as spill
    from sequential_validation_audit import require_complete_validation
    write = comparison.replay.atomic_write
    launch = comparison.read(root / "launch.json")
    old_process = comparison.read(root / "batch-process.json")
    scaling = comparison.read(root / "runtime-parallelism.json")
    if scaling["cpu_lanes"] != [[0, 1, 2, 3], [4, 5, 6, 7]]:
        raise ValueError("runtime lanes must be disjoint four-core lanes")
    os.sched_setaffinity(0, set(range(8)))
    argv = launch["argv"]
    def value(flag):
        return argv[argv.index("--" + flag) + 1]
    args = SimpleNamespace(output_root=root, cpus_per_worker=4,
        budget=int(value("budget")), max_rounds=int(value("max-rounds")),
        round_score_quota=int(value("round-score-quota")))
    for flag in ("config", "optimizer", "source-contract-file", "model", "architecture",
                 "inter-task-network", "sram-config"):
        setattr(args, flag.replace("-", "_"), Path(value(flag)))
    if (args.budget, args.max_rounds, args.round_score_quota) != (4096, 8192, 512):
        raise ValueError("matched search allowance/configuration changed")
    protocol = root / "protocol.json"
    if comparison.read(protocol)["execution"]["scoring_workers"] != 4:
        raise ValueError("per-cell scoring workers must remain four")
    source = comparison.read(args.config)
    seeds = comparison.read(root / "input-binding.json")
    entries = {}
    for workload in comparison.WORKLOADS:
        entry = {**source.get("defaults", {}), **source["workloads"][workload]}
        entries[workload] = {key: row["path"] for key, row in seeds[workload]["input_contents"].items()}
        if entry.get("function"):
            entries[workload]["function"] = entry["function"]
        for row in seeds[workload]["input_contents"].values():
            if comparison.file_binding(row["path"]) != row:
                raise ValueError("shared input bytes changed")
    guard = root / "gcn/sequential-50/protocol.json"
    guard_text = scaling["handoff_guard_text"]
    stop_spill = threading.Event()
    storage_errors = []
    def spill_loop():
        checkpoint_stamps = {}
        while not stop_spill.is_set():
            for checkpoint in root.glob("*/*/checkpoint.json"):
                cell = checkpoint.parent
                if (cell / "raw-auxiliary-manifest.json").exists():
                    continue
                stamp = checkpoint.stat().st_mtime_ns
                if checkpoint_stamps.get(str(checkpoint)) == stamp:
                    continue
                try:
                    moved = spill.relocate(cell, staging)
                    checkpoint_stamps[str(checkpoint)] = stamp
                    if moved:
                        print(json.dumps({"storage_relocated_catalogues": moved, "cell": str(cell)}), flush=True)
                except Exception as error:
                    storage_errors.append({"cell": str(cell), "error": str(error), "unix": time.time()})
                    write(root / "runtime-storage-errors.json", storage_errors)
            stop_spill.wait(20)
    storage_thread = threading.Thread(target=spill_loop, daemon=True)
    storage_thread.start()
    reserved = ("gcn", comparison.METHODS[1])
    jobs = deque((w, m) for w in comparison.WORKLOADS for m in comparison.METHODS
                 if (w, m[0]) not in {("gcn", "joint"), ("gcn", "sequential-50"), ("harris", "joint")})
    condition = threading.Condition()
    handoff_done = False
    records = []
    record_lock = threading.Lock()
    def commit(record):
        with record_lock:
            records.append(record)
            write(root / "batch.json", {"status": "running", "cells": list(records),
                "runtime_parallelism": str(root / "runtime-parallelism.json")})
    def compact(cell, record):
        overhead = storage.compact(cell)
        if overhead is not None:
            write(cell / "storage-overhead.json", overhead)
            record["storage_compaction"] = overhead
        removed = spill.cleanup_archived(cell)
        if removed:
            record["staged_catalogues_cleaned"] = removed
    def adopt_original():
        nonlocal handoff_done
        # Wait for the old coordinator to commit the complete current cell,
        # compact it, then hit our owned fail-closed next-cell handoff guard.
        while (Path("/proc") / str(old_process["coordinator_pid"])).exists():
            time.sleep(2)
        cell = root / "gcn/joint"
        if not comparison.complete(cell):
            raise ValueError("original live search exited before all seven validation gates; no automatic restart")
        require_complete_validation(comparison.read(cell / "result.json"))
        record = comparison.read(cell / "execution.json")
        if record.get("exit_code") != 0:
            raise ValueError("original replay did not exit successfully")
        if guard.read_text() != guard_text:
            raise ValueError("handoff guard was modified by another process")
        guard.unlink()
        compact(cell, record)
        write(root / "runtime-handoff-complete.json", {
            "old_coordinator_process": comparison.read(root / "batch-process.json"),
            "retained_cell": "gcn/joint", "retained_execution": record,
            "additional_objective_evaluations": 0, "additional_mapper_calls": 0,
            "guard_policy": "owned next-cell protocol guard stopped coordination before any second search; the live first search was not interrupted"})
        commit(record)
        with condition:
            jobs.appendleft(reserved)
            handoff_done = True
            condition.notify_all()
    def next_job():
        with condition:
            while not jobs and not handoff_done:
                condition.wait()
            return jobs.popleft() if jobs else None
    def lane(index):
        cpus = scaling["cpu_lanes"][index]
        if index == 0:
            try:
                adopt_original()
            except Exception:
                with condition:
                    nonlocal handoff_done
                    handoff_done = True
                    condition.notify_all()
                raise
        else:
            run("harris", comparison.METHODS[0], cpus)
        while True:
            item = next_job()
            if item is None:
                return
            run(item[0], item[1], cpus)
    def run(workload, method, cpus):
        record = comparison.run_cell(args, workload, method, entries[workload], protocol, cpus)
        cell = root / workload / method[0]
        if record["status"] not in {"validated", "already-validated"}:
            commit(record)
            return
        require_complete_validation(comparison.read(cell / "result.json"))
        compact(cell, record)
        commit(record)
    errors = []
    started = time.time()
    try:
        with ThreadPoolExecutor(max_workers=2) as pool:
            for future in as_completed([pool.submit(lane, index) for index in (0, 1)]):
                try:
                    future.result()
                except Exception as error:
                    errors.append(str(error))
                    write(root / "runtime-parallel-errors.json", errors)
    finally:
        stop_spill.set()
        storage_thread.join()
    complete = not errors and len(records) == 20 and all(
        row["status"] in {"validated", "already-validated"} for row in records)
    write(root / "batch.json", {"status": "complete" if complete else "incomplete", "cells": records,
        "batch_wall_seconds": time.time() - old_process["started_unix"],
        "parallel_interval_wall_seconds": time.time() - started,
        "runtime_parallelism": str(root / "runtime-parallelism.json"), "errors": errors,
        "input_snapshot_seconds": comparison.read(root / "coordinator-initialization.json")["input_snapshot_seconds"]})
    return 0 if complete else 2


if __name__ == "__main__":
    raise SystemExit(main())
