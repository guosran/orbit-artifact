#!/usr/bin/env python3
"""Run the pinned production passes and generated Taskflow host execution."""
import argparse
import datetime as dt
import json
import os
from pathlib import Path
import re
import resource
import shutil
import subprocess
import sys
import time

from check_environment import probe
from collect_results import collect
from common import (RESULTS, ROOT, build_dir, git, lock, llvm_build, now,
                    require_source_clean, run_command, source, write_json)
from generate_tables import generate
from validate_results import validate


def select_smoke(manifest):
    candidates = manifest["candidates"]
    checks = {
        "identity": lambda c: all(c["tile_sizes"][k] == 8 for k in ("BM", "BN", "BK")) and c["fusion"]["producer_consumer"] == "none",
        "mn_tiled": lambda c: c["tile_sizes"]["BM"] < 8 and c["tile_sizes"]["BN"] < 8 and c["tile_sizes"]["BK"] == 8 and c["fusion"]["producer_consumer"] == "none",
        "sequential_k": lambda c: c["tile_sizes"]["BK"] < 8 and c["k_policy"] == "sequential" and c["fusion"]["producer_consumer"] == "none",
        "parallel_k": lambda c: c["tile_sizes"]["BK"] < 8 and c["k_policy"] == "parallel" and c["reduction_topology"] == "linear" and not c["fusion"]["reduction_consumer"],
        "tile_local_fusion": lambda c: c["fusion"]["producer_consumer"] == "tile_local",
        "reduction_consumer_fusion": lambda c: c["fusion"]["reduction_consumer"],
    }
    selected = []
    for label, predicate in checks.items():
        match = next((c for c in candidates if predicate(c)), None)
        if match is None:
            raise ValueError("smoke graph missing: " + label)
        selected.append(match)
    return selected


def new_run_directory(mode):
    stamp = dt.datetime.now().astimezone().strftime("%Y-%m-%dT%H%M%S%z")
    base = RESULTS / (stamp + "-" + mode)
    path = base
    suffix = 1
    while path.exists():
        path = Path(str(base) + "-" + str(suffix))
        suffix += 1
    path.mkdir(parents=True)
    return path


def strip_legacy_file_hash_fields(value):
    """Source pass emits legacy fields; artifact does not retain or use them."""
    if isinstance(value, dict):
        return {k: strip_legacy_file_hash_fields(v) for k, v in value.items()
                if "sha256" not in k.lower()}
    if isinstance(value, list):
        return [strip_legacy_file_hash_fields(v) for v in value]
    return value


def summary_tests(run_dir, env, src, build, llvm, child_env):
    tests = {"optional_skipped": 6 if env["optional_dependency_state"] == "optional_dependency_missing" else 0,
             "optional_state": env["optional_dependency_state"]}
    test_files = sorted((src / "tools").glob("test_*.py"))
    python_argv = [sys.executable, "-m", "pytest", "-q", "-p", "no:cacheprovider", *map(str, test_files)]
    test_env = child_env.copy(); test_env["PYTEST_DISABLE_PLUGIN_AUTOLOAD"] = "1"
    py = run_command(python_argv, src, run_dir, "focused-python", check=False, env=test_env)
    output = (run_dir / py["stdout_log"]).read_text() + (run_dir / py["stderr_log"]).read_text()
    matched = re.search(r"(\d+) passed", output)
    tests["python_passed"] = int(matched.group(1)) if matched else 0
    tests["python_exit_code"] = py["exit_code"]
    lit = run_command([str(llvm / "bin/llvm-lit"), "-sv", "-j", "1", "--filter",
                       "(host-lowering|orbit-joint-standalone-passes)", str(build / "test")],
                      src, run_dir, "focused-lit", check=False)
    output = (run_dir / lit["stdout_log"]).read_text() + (run_dir / lit["stderr_log"]).read_text()
    match = re.search(r"Passed\s*:\s*(\d+)", output)
    tests["lit_passed"] = int(match.group(1)) if match else 0
    tests["lit_exit_code"] = lit["exit_code"]
    write_json(run_dir / "test_summary.json", tests)
    if py["exit_code"] or lit["exit_code"] or tests["python_passed"] != 114 or tests["lit_passed"] != 2:
        raise ValueError("focused test counts differ: " + str(tests))


def run(mode):
    src = require_source_clean()
    build = build_dir(); llvm = llvm_build()
    opt = build / "tools/mlir-amoeba-opt/mlir-amoeba-opt"
    for path in (opt, llvm / "bin/mlir-opt", llvm / "bin/mlir-runner",
                 llvm / "lib/libmlir_runner_utils.so"):
        if not path.is_file():
            raise ValueError("missing built tool: " + str(path))
    run_dir = new_run_directory(mode)
    (run_dir / "raw").mkdir(parents=True)
    env = probe(); write_json(run_dir / "environment.json", env)
    if env["required_status"] != "available" or env["source_status"] != "pinned":
        raise ValueError("doctor found missing required dependency or wrong source")
    artifact_commit = git(ROOT, "rev-parse", "HEAD") if (ROOT / ".git/HEAD").exists() and subprocess.run(["git", "-C", str(ROOT), "rev-parse", "HEAD"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0 else None
    started = time.monotonic()
    run_record = {"artifact_schema_version": "orbit-semantic-artifact-v1", "artifact_git_commit": artifact_commit,
                  "amoeba_git_commit": git(src, "rev-parse", "HEAD"), "start_time": now(),
                  "end_time": None, "hostname": env["hostname"], "command": ["./artifact.sh", "smoke" if mode == "smoke" else "reproduce", *([] if mode == "smoke" else ["semantic"])],
                  "status": "incomplete", "completed_stage": "initialization",
                  "optional_dependency_state": env["optional_dependency_state"],
                  "output_paths": {}, "wall_clock_seconds": None, "peak_memory_kib": None}
    write_json(run_dir / "run.json", run_record)
    child_env = os.environ.copy()
    child_env["ORBIT_COMMAND_LOG"] = str(run_dir / "commands.jsonl")
    child_env["PYTHONPATH"] = str(ROOT / "scripts") + os.pathsep + str(src / "tools") + os.pathsep + child_env.get("PYTHONPATH", "")
    child_env["PYTHONDONTWRITEBYTECODE"] = "1"
    canonical = src / "test/multi-cgra/taskflow/joint-scheduling/orbit_joint_pipeline_8x8_i32.mlir"
    try:
        manifest_path = run_dir / "raw/joint_variant_space.json"
        run_command([opt, canonical, "--verify-each",
                     "--enumerate-joint-semantic-rewrites=output=%s max-depth=8 max-actions=50000 tile-factor=0" % manifest_path,
                     "-o", "/dev/null"], src, run_dir, "enumerate", env=child_env)
        manifest = json.loads(manifest_path.read_text())
        if manifest.get("complete") is not True:
            raise ValueError("enumeration manifest incomplete")
        run_record["completed_stage"] = "enumeration"; write_json(run_dir / "run.json", run_record)
        chosen_path = manifest_path
        if mode == "smoke":
            selected = select_smoke(manifest)
            subset = {"schema": manifest["schema"], "complete": True,
                      "candidates": selected}
            chosen_path = run_dir / "raw/smoke_candidates.json"
            write_json(chosen_path, subset)
        witness = run_dir / "raw/witness_replay.json"
        run_command([sys.executable, src / "tools/orbit_joint_witness_audit.py",
                     "--source", canonical, "--manifest", chosen_path,
                     "--amoeba-opt", opt, "--output", witness],
                    src, run_dir, "witness-replay", env=child_env)
        run_record["completed_stage"] = "witness"; write_json(run_dir / "run.json", run_record)
        numeric = run_dir / "raw/host_numeric.json"
        run_command([sys.executable, src / "tools/orbit_joint_host_numeric_audit.py",
                     "--source", canonical, "--manifest", chosen_path,
                     "--amoeba-opt", opt, "--mlir-opt", llvm / "bin/mlir-opt",
                     "--runner", llvm / "bin/mlir-runner",
                     "--runner-utils", llvm / "lib/libmlir_runner_utils.so",
                     "--output", numeric], src, run_dir, "host-numeric", env=child_env)
        run_record["completed_stage"] = "numeric"; write_json(run_dir / "run.json", run_record)
        for result_path in (manifest_path, chosen_path):
            write_json(result_path, strip_legacy_file_hash_fields(json.loads(result_path.read_text())))
        if mode == "semantic":
            summary_tests(run_dir, env, src, build, llvm, child_env)
            run_record["completed_stage"] = "numeric"
        else:
            write_json(run_dir / "test_summary.json", {"optional_skipped": 6 if env["optional_dependency_state"] == "optional_dependency_missing" else 0,
                                                       "python_passed": "not run", "lit_passed": "not run"})
        collect(run_dir)
        run_record["status"] = "completed"
    except BaseException as error:
        run_record["status"] = "incomplete"
        run_record["error"] = str(error)
        raise
    finally:
        run_record["end_time"] = now()
        run_record["wall_clock_seconds"] = round(time.monotonic() - started, 3)
        run_record["peak_memory_kib"] = resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss
        run_record["output_paths"] = {name: name for name in ("environment.json", "commands.jsonl",
                                     "semantic_summary.json", "graph_inventory.jsonl",
                                     "execution_summary.json", "negative_control.json", "test_summary.json")
                                     if (run_dir / name).exists()}
        write_json(run_dir / "run.json", run_record)
        if (run_dir / "semantic_summary.json").exists():
            generate(run_dir)
        print("run directory:", run_dir, file=sys.stderr)
    try:
        result = validate(run_dir, require_full=mode == "semantic")
        write_json(run_dir / "validation.json", result)
    except Exception as error:
        write_json(run_dir / "validation.json", {"schema": "orbit-validation-v1", "pass": False,
                                                  "error": str(error)})
        raise
    return run_dir


if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("--mode", choices=("smoke", "semantic"), required=True)
    args = ap.parse_args()
    try:
        print(run(args.mode))
    except Exception as error:
        print("artifact reproduction failed:", error, file=sys.stderr)
        sys.exit(1)
