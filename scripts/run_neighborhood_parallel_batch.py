#!/usr/bin/env python3
"""Run disjoint workload chains with a bounded CPU budget and durable records.

Candidate generation, scoring, ranking and resume remain in the existing C++
pass and frozen replay launcher. Each lane owns distinct workload directories.
"""
from __future__ import annotations

import argparse
from concurrent.futures import ThreadPoolExecutor
import json
import os
from pathlib import Path
import subprocess
import sys
import threading

import run_neighborhood_stage_chain as chain


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--chain-command-file", type=Path, required=True)
    parser.add_argument("--workers", type=int, default=3)
    parser.add_argument("--cpus-per-worker", type=int, default=4)
    parser.add_argument("--jobs-per-worker", type=int, default=4)
    args = parser.parse_args()
    if min(args.workers, args.cpus_per_worker, args.jobs_per_worker) < 1:
        parser.error("worker, CPU and mapper job counts must be positive")
    if args.workers * args.cpus_per_worker > 12:
        parser.error("combined CPU budget exceeds twelve")
    if args.jobs_per_worker > args.cpus_per_worker:
        parser.error("mapper jobs must fit the worker CPU budget")
    command_file = args.chain_command_file.resolve()
    command = json.loads(command_file.read_text())
    if not isinstance(command, list):
        raise chain.ChainError("chain command must be a JSON argv array")
    index = next((i for i, value in enumerate(command)
                  if Path(str(value)).name == "run_neighborhood_stage_chain.py"), None)
    if index is None:
        raise chain.ChainError("chain command does not invoke the stage launcher")
    options, config_path = chain._parse_args(command[index + 1:])
    chain._validate_options(options)
    config = chain.load_config(config_path)
    config["config_base"] = str(config_path.parent.resolve())
    chain.validate_stage_inputs(config, options, config_base=config_path.parent.resolve())
    manifest = chain._ensure_contract_snapshot(
        options.output_root, chain._contract_specs(
            config, options, config_base=config_path.parent.resolve()))
    available = sorted(os.sched_getaffinity(0))
    lane_count = min(args.workers, len(options.workloads))
    required = lane_count * args.cpus_per_worker
    if len(available) < required:
        raise chain.ChainError(f"need {required} available CPUs; have {len(available)}")
    directory = options.output_root / "parallel"
    directory.mkdir(parents=True, exist_ok=True)
    record_path = directory / "batch.json"
    lock = threading.Lock()
    record = {"schema": "orbit-neighborhood-parallel-batch-v1",
              "status": "running", "started_utc": chain.now(),
              "contract_manifest": str(manifest), "cpu_budget": required,
              "jobs_per_worker": args.jobs_per_worker, "subprocess_timeout": None,
              "stage_initialization": options.stage_initialization,
              "stage_order": list(chain.stage_order(options)),
              "lanes": {}, "workloads": {}}
    chain.atomic_write(record_path, record)

    def lane(number: int) -> bool:
        cpus = available[number * args.cpus_per_worker:(number + 1) * args.cpus_per_worker]
        workloads = options.workloads[number::lane_count]
        with lock:
            record["lanes"][str(number)] = {"cpus": cpus, "workloads": list(workloads)}
            chain.atomic_write(record_path, record)
        succeeded = True
        for workload in workloads:
            worker_dir = directory / workload
            worker_dir.mkdir(parents=True, exist_ok=True)
            argv = ["taskset", "--cpu-list", ",".join(map(str, cpus)), sys.executable,
                    str(chain.ROOT / "scripts/run_neighborhood_parallel_recovery.py"),
                    "--chain-command-file", str(command_file), "--workload", workload,
                    "--jobs", str(args.jobs_per_worker)]
            with lock:
                entry = {"status": "running", "argv": argv, "started_utc": chain.now()}
                record["workloads"][workload] = entry
                chain.atomic_write(record_path, record)
            label = chain._next_label(worker_dir, "batch-worker")
            try:
                with (worker_dir / f"{label}.stdout.log").open("w") as stdout, \
                        (worker_dir / f"{label}.stderr.log").open("w") as stderr:
                    process = subprocess.Popen(argv, cwd=chain.ROOT, stdout=stdout, stderr=stderr)
                    with lock:
                        entry["pid"] = process.pid
                        chain.atomic_write(record_path, record)
                    code = process.wait()
            except OSError as error:
                code = 127
                with lock:
                    entry["error"] = f"{type(error).__name__}: {error}"
            with lock:
                entry.update(status="complete" if code == 0 else "failed", exit_code=code,
                             ended_utc=chain.now())
                chain.atomic_write(record_path, record)
            succeeded &= code == 0
        return succeeded

    with ThreadPoolExecutor(max_workers=lane_count) as pool:
        outcomes = list(pool.map(lane, range(lane_count)))
    record.update(status="complete" if all(outcomes) else "incomplete", ended_utc=chain.now())
    chain.atomic_write(record_path, record)
    return 0 if all(outcomes) else 2


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (chain.ChainError, OSError, ValueError) as error:
        print(f"parallel batch failed: {error}", file=sys.stderr)
        raise SystemExit(2)
