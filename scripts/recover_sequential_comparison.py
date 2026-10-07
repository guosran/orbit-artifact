#!/usr/bin/env python3
"""Retain validated results and restart only disk-interrupted cells in two CPU lanes."""
import argparse
from collections import deque
from concurrent.futures import ThreadPoolExecutor, as_completed
import importlib.util
import json
import os
from pathlib import Path
import shutil
import sys
import threading
import time
from types import SimpleNamespace


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--results-root", type=Path, required=True)
    parser.add_argument("--runtime-root", type=Path, required=True)
    parser.add_argument("--staging-root", type=Path, required=True)
    args_cli = parser.parse_args()
    root, runtime, staging = (p.resolve() for p in
        (args_cli.results_root, args_cli.runtime_root, args_cli.staging_root))
    artifact = Path(__file__).resolve().parents[1]
    if shutil.disk_usage(root).free < 6 * 1024**3:
        raise ValueError("free at least 6 GiB before restarting interrupted searches")
    if not (root / "runtime-disk-failure-audit.json").is_file():
        raise ValueError("recovery requires a recorded disk failure and observed process exit")
    for proc in Path("/proc").glob("[0-9]*"):
        try:
            command = (proc / "cmdline").read_bytes().replace(b"\0", b" ").decode(errors="replace")
        except OSError:
            continue
        if (str(root) in command and any(name in command for name in
                ("neighborhood_replay.py", "mlir-amoeba-opt", "parallelize_sequential_comparison.py"))):
            raise ValueError("an earlier search/coordinator is still alive: " + proc.name)
    sys.path.insert(0, str(runtime / "scripts"))
    spec = importlib.util.spec_from_file_location("retained_comparison", runtime / "scripts/run_sequential_comparison.py")
    comparison = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(comparison)
    import compact_sequential_raw as storage
    import spill_sequential_catalogues as spill
    from sequential_validation_audit import require_complete_validation
    checkpoint_spec = importlib.util.spec_from_file_location("completed_checkpoint_cleanup",
        artifact / "scripts/cleanup_completed_sequential_intermediates.py")
    checkpoint_cleanup = importlib.util.module_from_spec(checkpoint_spec)
    checkpoint_spec.loader.exec_module(checkpoint_cleanup)
    write = comparison.replay.atomic_write
    launch = comparison.read(root / "launch.json")
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
        raise ValueError("matched objective budget and expansion parameters changed")
    protocol = root / "protocol.json"
    if comparison.read(protocol)["execution"]["scoring_workers"] != 4:
        raise ValueError("per-cell scorer parallelism changed")
    os.sched_setaffinity(0, set(range(8)))
    seeds = comparison.read(root / "input-binding.json")
    config = comparison.read(args.config)
    entries = {}
    for workload in comparison.WORKLOADS:
        source = {**config.get("defaults", {}), **config["workloads"][workload]}
        entries[workload] = {key: row["path"] for key, row in seeds[workload]["input_contents"].items()}
        if source.get("function"):
            entries[workload]["function"] = source["function"]
        for row in seeds[workload]["input_contents"].values():
            if comparison.file_binding(row["path"]) != row:
                raise ValueError("shared seed bytes changed")
    baseline_binding = comparison.read(root / "gcn/joint/comparison-binding.json")["content_binding"]
    for key, path in (("optimizer", args.optimizer), ("source_contract", args.source_contract_file),
                      ("model", args.model), ("architecture", args.architecture),
                      ("network", args.inter_task_network), ("sram", args.sram_config)):
        if comparison.file_binding(path) != baseline_binding[key]:
            raise ValueError("retained and recovered cost/model/mapper contract differ: " + key)
    retained, jobs, relocated = [], deque(), []
    for workload in comparison.WORKLOADS:
        for method in comparison.METHODS:
            cell = root / workload / method[0]
            if comparison.complete(cell):
                require_complete_validation(comparison.read(cell / "result.json"))
                record = comparison.read(cell / "execution.json")
                if record.get("exit_code") != 0:
                    raise ValueError("validated retained cell has an unsuccessful execution record")
                retained.append(record)
                continue
            if cell.exists():
                number = 1
                destination = cell.with_name(f"{method[0]}-enospc-attempt-{number}")
                while destination.exists():
                    number += 1
                    destination = cell.with_name(f"{method[0]}-enospc-attempt-{number}")
                moved = {"workload": workload, "method": method[0], "original_path": str(cell),
                    "retained_path": str(destination), "reason": "disk-interrupted and excluded",
                    "budget_audit": str(destination / "interruption-audit.json"),
                    "policy": "renamed with exact bytes retained; fresh per-flow predictor/mapper caches; no Sequential checkpoint resume"}
                # Staging cleanup authenticates original absolute source paths,
                # so it must finish before the containing directory is renamed.
                overhead = storage.compact(cell, allow_interrupted=True)
                if overhead:
                    write(cell / "storage-overhead.json", overhead)
                    spill.cleanup_archived(cell)
                    moved["excluded_attempt_storage_compaction"] = overhead
                with (root / "enospc-attempt-relocation.jsonl").open("a") as journal:
                    journal.write(json.dumps({**moved, "time_unix": time.time(), "status": "prepared"}) + "\n")
                    journal.flush()
                    os.fsync(journal.fileno())
                cell.rename(destination)
                relocated.append(moved)
            jobs.append((workload, method))
    manifest = {"schema": "orbit-sequential-enospc-recovery-v1", "started_unix": time.time(),
        "cpu_lanes": [[0, 1, 2, 3], [4, 5, 6, 7]], "retained_cells": len(retained),
        "restarted_cells": [[w, m[0]] for w, m in jobs], "relocated_attempts": relocated,
        "excluded_attempt_costs": str(root / "enospc-extra-search-costs.json"),
        "source_snapshot_manifest": str(runtime / "source-bound-payloads.json"),
        "runtime_bindings": [comparison.file_binding(path) for path in (
            Path(__file__).resolve(), artifact / "scripts/cleanup_completed_sequential_intermediates.py")],
        "policy": "same frozen optimizer and replay payload, inputs, private initial caches, 4096 cap and prescribed split; retained successful cells never searched or mapped again"}
    write(root / "runtime-recovery.json", manifest)
    lock, stopped, stop_spill = threading.Lock(), threading.Event(), threading.Event()
    records, errors, storage_errors = list(retained), [], []
    def commit():
        write(root / "batch.json", {"status": "running", "cells": list(records),
            "runtime_recovery": str(root / "runtime-recovery.json")})
    def spill_loop():
        stamps = {}
        while not stop_spill.is_set():
            for checkpoint in root.glob("*/*/checkpoint.json"):
                cell = checkpoint.parent
                if "-enospc-attempt-" in cell.name or (cell / "raw-auxiliary-manifest.json").exists():
                    continue
                try:
                    stamp = checkpoint.stat().st_mtime_ns
                    if stamps.get(str(checkpoint)) == stamp:
                        continue
                    moved = spill.relocate(cell, staging)
                    stamps[str(checkpoint)] = stamp
                    if moved:
                        print(json.dumps({"cell": str(cell), "storage_relocated_catalogues": moved}), flush=True)
                except Exception as error:
                    storage_errors.append({"cell": str(cell), "error": str(error), "time_unix": time.time()})
                    write(root / "recovery-storage-errors.json", storage_errors)
            stop_spill.wait(20)
    storage_thread = threading.Thread(target=spill_loop, daemon=True)
    storage_thread.start()
    def lane(index):
        while not stopped.is_set():
            with lock:
                if not jobs:
                    return
                workload, method = jobs.popleft()
            record = comparison.run_cell(args, workload, method, entries[workload], protocol,
                                         manifest["cpu_lanes"][index])
            cell = root / workload / method[0]
            if record["status"] != "validated":
                with lock:
                    records.append(record)
                    commit()
                stopped.set()
                return
            require_complete_validation(comparison.read(cell / "result.json"))
            overhead = storage.compact(cell)
            if overhead:
                write(cell / "storage-overhead.json", overhead)
                record["storage_compaction"] = overhead
            spill.cleanup_archived(cell)
            checkpoint_actions = checkpoint_cleanup.compact_checkpoint(cell, apply=True)
            record["checkpoint_compaction_freed_bytes"] = sum(row["freed_bytes"] for row in checkpoint_actions)
            with lock:
                records.append(record)
                commit()
    with lock:
        commit()
    try:
        with ThreadPoolExecutor(max_workers=2) as pool:
            for future in as_completed([pool.submit(lane, index) for index in (0, 1)]):
                try:
                    future.result()
                except Exception as error:
                    stopped.set()
                    errors.append(str(error))
                    write(root / "recovery-errors.json", errors)
    finally:
        stop_spill.set()
        storage_thread.join()
    complete = not errors and len(records) == 20 and all(row["status"] == "validated" for row in records)
    write(root / "batch.json", {"status": "complete" if complete else "incomplete", "cells": records,
        "recovery_wall_seconds": time.time() - manifest["started_unix"],
        "runtime_recovery": str(root / "runtime-recovery.json"), "errors": errors,
        "excluded_interrupted_attempts": relocated})
    return 0 if complete else 2


if __name__ == "__main__":
    raise SystemExit(main())
