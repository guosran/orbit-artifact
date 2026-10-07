#!/usr/bin/env python3
"""Wait for the main batch's process exit, then run the separate GCN/LU supplement.

Waiting uses a Linux process descriptor; it never polls experiment results.
Search, shortlist selection and all validation run through the existing replay
coordinator in the independently frozen supplemental runtime.
"""
import argparse
import ctypes
import errno
import importlib.util
import json
import os
from pathlib import Path
import select
import subprocess
import sys
import threading
import time

import run_sequential_comparison as comparison
from sequential_validation_audit import require_complete_validation
import show_sequential_comparison as main_audit
import cleanup_completed_sequential_intermediates as checkpoint_cleanup


def wait_supervisor(root, status_path, write):
    process = comparison.read(status_path)
    if process.get("status") == "running":
        pid = process["supervisor_pid"]
        command_path = Path(f"/proc/{pid}/cmdline")
        if command_path.exists():
            command = command_path.read_bytes().replace(b"\0", b" ").decode()
            if "supervise_sequential_comparison.py" not in command or str(root) not in command:
                raise ValueError("main supervisor PID no longer identifies this batch")
            libc = ctypes.CDLL(None, use_errno=True)
            if hasattr(libc, "pidfd_open"):
                descriptor = libc.pidfd_open(ctypes.c_int(pid), ctypes.c_uint(0))
            elif os.uname().machine == "x86_64":
                descriptor = libc.syscall(ctypes.c_long(434), ctypes.c_int(pid), ctypes.c_uint(0))
            else:
                raise ValueError("pidfd_open unavailable; start supplement after main completion")
            if descriptor < 0 and ctypes.get_errno() != errno.ESRCH:
                raise OSError(ctypes.get_errno(), "pidfd_open")
            if descriptor >= 0:
                write({"status": "waiting-main-process-exit", "supervisor_pid": pid,
                       "main_status": process, "wait_mechanism": "blocking Linux pidfd; no result polling"})
                try:
                    select.select([descriptor], [], [])
                finally:
                    os.close(descriptor)
    ended = comparison.read(status_path)
    if ended.get("status") != "exited" or ended.get("exit_code") != 0:
        raise ValueError("main supervisor did not record successful completion; supplement not launched")
    batch = comparison.read(root / "batch.json")
    if batch.get("status") != "complete" or len(batch.get("cells", [])) != 20:
        raise ValueError("main batch incomplete; supplement not launched")
    for workload in comparison.WORKLOADS:
        for method, _, _ in comparison.METHODS:
            require_complete_validation(comparison.read(root / workload / method / "result.json"))
    main_audit.audit_bindings(root)
    return ended


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--main-results-root", type=Path, required=True)
    parser.add_argument("--runtime-root", type=Path, required=True)
    parser.add_argument("--output-root", type=Path, required=True)
    parser.add_argument("--staging-root", type=Path, required=True)
    args = parser.parse_args()
    main_root, runtime, output, staging = (p.resolve() for p in
        (args.main_results_root, args.runtime_root, args.output_root, args.staging_root))
    output.mkdir(parents=True, exist_ok=True)
    if (output / "protocol.json").exists():
        raise ValueError("choose a fresh supplemental output namespace")
    write = comparison.replay.atomic_write
    state_path = output / "supplement-state.json"
    def state(value):
        write(state_path, {"updated_unix": time.time(), **value})
    own_bindings = [comparison.file_binding(Path(__file__).resolve()),
                    comparison.file_binding(runtime / "budget-transfer-runtime.json"),
                    comparison.file_binding(runtime / "build-provenance.json")]
    write(output / "queue-binding.json", {"schema": "orbit-sequential-transfer-queue-v1",
        "main_results_root": str(main_root), "runtime_bindings": own_bindings,
        "requested_workloads": ["gcn", "lu"], "method": "sequential-50-transfer",
        "total_objective_cap": 4096, "cores": 8, "lanes": 2, "cores_per_lane": 4,
        "main_table_unchanged": True, "cache_policy": "fresh private predictor seed and mapper cache; A/B share within flow"})
    try:
        ended = wait_supervisor(main_root, main_root / "parallel-process.json", state)
        for row in own_bindings:
            if comparison.file_binding(row["path"]) != row:
                raise ValueError("supplement runtime changed while queued")
        launch = comparison.read(main_root / "launch.json")
        original = launch["argv"]
        def arg(flag):
            return original[original.index("--" + flag) + 1]
        command = [sys.executable, "-u", str(runtime / "scripts/run_sequential_comparison.py")]
        for flag in ("config", "model", "architecture", "inter-task-network", "sram-config"):
            command.extend(["--" + flag, arg(flag)])
        command.extend(["--optimizer", str(runtime / "bin/mlir-amoeba-opt"),
            "--source-contract-file", str(runtime / "source-model-contract.json"),
            "--output-root", str(output), "--budget", "4096", "--max-rounds", "8192",
            "--round-score-quota", "512", "--workers", "2", "--cpus-per-worker", "4",
            "--workloads", "gcn", "lu", "--methods", "sequential-50-transfer", "--compact-completed"])
        # Load the exact storage helpers copied into this supplemental runtime.
        def load(name):
            spec = importlib.util.spec_from_file_location("transfer_" + name, runtime / "scripts" / (name + ".py"))
            module = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(module)
            return module
        spill = load("spill_sequential_catalogues")
        stop = threading.Event()
        storage_errors = []
        def spill_loop():
            stamps = {}
            while not stop.is_set():
                for checkpoint in output.glob("*/*/checkpoint.json"):
                    cell = checkpoint.parent
                    if (cell / "raw-auxiliary-manifest.json").exists():
                        continue
                    try:
                        stamp = checkpoint.stat().st_mtime_ns
                        if stamps.get(str(checkpoint)) == stamp:
                            continue
                        spill.relocate(cell, staging)
                        stamps[str(checkpoint)] = stamp
                    except Exception as error:
                        storage_errors.append({"cell": str(cell), "error": str(error), "time_unix": time.time()})
                        write(output / "storage-errors.json", storage_errors)
                stop.wait(20)
        thread = threading.Thread(target=spill_loop, daemon=True)
        started = time.time()
        environment = dict(os.environ, ORBIT_LLVM_BUILD=launch["environment"]["ORBIT_LLVM_BUILD"])
        with (output / "coordinator.log").open("w") as log:
            process = subprocess.Popen(command, cwd=comparison.ROOT, env=environment,
                stdin=subprocess.DEVNULL, stdout=log, stderr=subprocess.STDOUT)
            write(output / "supplement-launch.json", {"argv": command, "environment": {
                "ORBIT_LLVM_BUILD": environment["ORBIT_LLVM_BUILD"]}, "main_exit": ended,
                "coordinator_pid": process.pid, "started_unix": started})
            state({"status": "running", "coordinator_pid": process.pid, "started_unix": started})
            thread.start()
            try:
                code = process.wait()
            finally:
                stop.set()
                thread.join()
        if code:
            raise ValueError("supplement coordinator exited with code " + str(code))
        for workload in ("gcn", "lu"):
            cell = output / workload / "sequential-50-transfer"
            require_complete_validation(comparison.read(cell / "result.json"))
            spill.cleanup_archived(cell)
            checkpoint_cleanup.compact_checkpoint(cell, apply=True)
        state({"status": "complete", "exit_code": 0, "wall_seconds": time.time() - started,
               "storage_errors": storage_errors})
        return 0
    except Exception as error:
        state({"status": "failed", "error": str(error)})
        raise


if __name__ == "__main__":
    raise SystemExit(main())
