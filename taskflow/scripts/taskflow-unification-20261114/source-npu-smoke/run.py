#!/usr/bin/env python3
"""Public source rewrites -> common search -> actual AIR/AIE -> NPU smoke.

Python orchestrates compiler commands and independent CPU references only.
The configured theoretical costs select contracts; they prove no speedup.
Compile and execute are separate explicit stages for the shared device lane.
"""
import argparse
import fcntl
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys


def save(path, value):
    path.write_text(json.dumps(value, indent=2) + "\n")


def identity(path):
    return {"path": str(path.resolve()),
            "sha256": hashlib.sha256(path.read_bytes()).hexdigest()}


def run(out, name, command):
    save(out / (name + ".command.json"), [str(x) for x in command])
    with (out / (name + ".log")).open("w") as log:
        result = subprocess.run([str(x) for x in command], stdout=log,
                                stderr=subprocess.STDOUT)
    save(out / (name + ".result.json"), {"returncode": result.returncode})
    if result.returncode:
        raise RuntimeError(f"{name} failed; see {out / (name + '.log')}")


def prepare(args):
    import numpy as np
    out = args.output.resolve()
    out.mkdir(parents=True, exist_ok=False)
    shutil.copy2(Path(__file__).with_name("pointwise64.mlir"), out / "original.mlir")
    save(out / "provenance.json", {
        "schema": "orbit.public-source-npu-smoke.v34", "tool": identity(args.tool),
        "driver": identity(Path(__file__)), "device_submissions": 0,
        "physical_speedup_claim": False, "selection_cost": "uncalibrated theoretical"})
    target = {"generic_air": {
        "capacity_bytes": 24576,
        "capabilities": {"tile_alignment": [1, 1, 1],
                         "implementations": [{"kind": "scalar", "lanes": 1}]},
        "theoretical": {"launch_ms": .1, "per_scalar_operation_ms": .000001,
                        "per_transfer_byte_ms": .0000001}}}
    save(out / "target.json", target)
    automatic = dict(target)
    automatic["source_auto_candidates"] = {
        "function": "pointwise", "rows": 1, "cols": 1,
        "max_fission_actions": 8, "tile_page_slots": 8,
        "max_residency_proposals": 8, "max_residency_groups": 4,
        "tiling": True, "fusion": True, "fission": True, "replica": True,
        "mapping": True, "task_tiling": True}
    save(out / "search-target.json", automatic)
    pipelines = {
        "fused": ("original", "taskflow-fuse{first-task=double second-task=square "
                  "fusion-kind=producer-consumer}"),
        "fissioned": ("original", "fission-task{task-name=double left-nodes=0:1}"),
        "tiled": ("original", "tile-task{task-name=double axis=0 factor=2}")}
    for name, (parent, pipeline) in pipelines.items():
        run(out, name, [args.tool, out / f"{parent}.mlir",
            f"--source-pass-pipeline=builtin.module(func.func({pipeline}))",
            f"--emit-mlir={out / (name + '.mlir')}"])
    for seed in (11, 23, 47):
        rng = np.random.default_rng(seed)
        x = rng.uniform(-1, 1, (64, 64)).astype(np.float32)
        # Independent expression uses CPU NumPy; no candidate output or IR
        # metadata supplies its numerical values.
        doubled = np.add(x, x, dtype=np.float32)
        y = np.multiply(doubled, doubled, dtype=np.float32)
        np.savez(out / f"inputs-{seed}.npz", X=x)
        np.savez(out / f"reference-{seed}.npz", Y=y)
    for name in ("original", "fused", "fissioned", "tiled"):
        case = out / name
        case.mkdir()
        # Validate each requested structural form independently, even when
        # the common search later selects the same canonical graph for two
        # different starting forms.
        run(case, "normalize-start", [args.tool, out / f"{name}.mlir",
            "--normalize-taskflow-source",
            f"--source-normalization-witness={case / 'start-normalization.json'}",
            f"--emit-mlir={case / 'start.normalized.mlir'}"])
        run(case, "lower-start", [args.tool, case / "start.normalized.mlir",
            "--lower-to-air", f"--target-config={out / 'target.json'}",
            f"--air-output={case / 'start.air.mlir'}"])
        run(case, "check-start-air", [args.tool, case / "start.normalized.mlir",
            f"--target-config={out / 'target.json'}",
            f"--check-air={case / 'start.air.mlir'}"])
        run(case, "search", [args.tool, out / f"{name}.mlir", "--search",
            "--backend=air", f"--target-config={out / 'search-target.json'}",
            f"--search-output={case / 'search'}", "--max-rounds=2",
            "--max-candidates=24", "--beam-width=2"])
        report = json.loads((case / "search/search.json").read_text())
        if not report.get("has_best") or report.get("physical_execution"):
            raise RuntimeError("source search did not produce a nonphysical contract selection")
        source = case / "search/best.normalized.mlir"
        flags = [f"--target-config={out / 'target.json'}"]
        run(case, "lower", [args.tool, source, "--lower-to-air", *flags,
            f"--air-output={case / 'program.air.mlir'}",
            f"--analysis-output={case / 'facts.json'}",
            f"--mapping-output={case / 'plan.json'}"])
        run(case, "check-air", [args.tool, source, *flags,
                               f"--check-air={case / 'program.air.mlir'}"])
        facts = json.loads((case / "facts.json").read_text())
        plan = json.loads((case / "plan.json").read_text())
        air_input = case / "program.air.mlir"
        if any(stage.get("legalize_channels", False)
               for stage in plan.get("hardware_stages", [])):
            # Follow the compiler plan's recorded standard-conversion step.
            # Actual channel allocation/legalization remains in C++.
            converted = case / "channelized.generic.air.mlir"
            air_input = case / "pinned.generic.air.mlir"
            run(case, "standard-channel-conversion", ["air-opt",
                case / "program.air.mlir", "--air-dma-to-channel",
                "--canonicalize", "--mlir-print-op-generic", "-o", converted])
            run(case, "native-channel-legalization", [args.tool, source, *flags,
                f"--legalize-air-channels={converted}", f"--air-output={air_input}"])
            run(case, "check-channels", [args.tool, source, *flags,
                f"--check-air-channels={air_input}"])
        host = {entry["storage_index"] for entry in plan["host_buffers"]}
        buffers = [s for s in facts["storages"] if s["role"] != "temporary"]
        buffers += [s for i, s in enumerate(facts["storages"])
                    if s["role"] == "temporary" and i in host]
        save(case / "abi.json", {
            "buffers": [{key: s[key] for key in ("shape", "dtype", "role")} |
                        {"name": s["id"]} for s in buffers],
            "outputs": [s["id"] for s in buffers if s["role"] == "output"]})
        save(case / "source-air-binding.json", {
            "source": identity(source), "air": identity(air_input),
            "replay": identity(case / "search/replay.json"),
            "plan": identity(case / "plan.json"), "device_submissions": 0})
    save(out / "prepared.json", {"status": "AIR checked; AIE compilation pending",
                                 "physical_speedup_claim": False})


def executor(args):
    # The existing executor imports its trace sibling lazily during launch.
    sys.path.insert(0, str(args.executor.resolve().parent))
    spec = importlib.util.spec_from_file_location("direct_air_executor", args.executor)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def compile_cases(args):
    execute = executor(args)
    for name in args.cases:
        case = args.output.resolve() / name
        bound = json.loads((case / "source-air-binding.json").read_text())
        for item in bound.values():
            if isinstance(item, dict) and "sha256" in item and identity(Path(item["path"])) != item:
                raise RuntimeError("prepared source/AIR/replay/plan binding changed")
        air_input = Path(bound["air"]["path"])
        artifact = execute.compile_air(air_input, case / "hardware",
                                       omit_ping_pong=True)
        check_case(args, case, artifact, air_input)


def check_case(args, case, artifact, air_input):
    final_aie = case / "hardware/air_project/npu.input.air.mlir"
    generic_aie = case / "final-aie.generic.mlir"
    run(case, "extract-final-aie", ["air-opt", final_aie,
        "--mlir-print-op-generic", "-o", generic_aie])
    run(case, "check-aie", [args.tool, case / "search/best.normalized.mlir",
        f"--target-config={args.output.resolve() / 'target.json'}",
        f"--check-aie={generic_aie}",
        f"--implementation-output={case / 'aie-check.json'}"])
    save(case / "compiled-binding.json", {
        "source": identity(case / "search/best.normalized.mlir"),
        "air": identity(air_input),
        "aie": identity(final_aie), "generic_aie": identity(generic_aie),
        "elf": identity(Path(artifact["elf_path"])),
        "checker": identity(case / "aie-check.json"), "device_submissions": 0})


def check_cases(args):
    for name in args.cases:
        case = args.output.resolve() / name
        bound = json.loads((case / "source-air-binding.json").read_text())
        artifact = json.loads((case / "hardware/compile.json").read_text())
        check_case(args, case, artifact, Path(bound["air"]["path"]))


def execute_cases(args):
    import numpy as np
    execute = executor(args)
    # This executor is the sole device-lock owner; compilation and analysis
    # never hold the lock or launch the NPU.
    with open("/tmp/npu.lock", "w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        for name in args.cases:
            case = args.output.resolve() / name
            receipt = json.loads((case / "aie-check.json").read_text())
            if not receipt.get("valid"):
                raise RuntimeError("independent AIE checker did not accept candidate")
            bound = json.loads((case / "compiled-binding.json").read_text())
            for item in bound.values():
                if isinstance(item, dict) and "sha256" in item:
                    if identity(Path(item["path"])) != item:
                        raise RuntimeError("compiled source/AIE/ELF/checker binding changed")
            artifact = json.loads((case / "hardware/compile.json").read_text())
            abi = json.loads((case / "abi.json").read_text())
            for seed in (11, 23, 47):
                folder = case / f"board-seed-{seed}"
                folder.mkdir(exist_ok=False)
                save(folder / "reference-provenance.json", {
                    "inputs": identity(args.output / f"inputs-{seed}.npz"),
                    "reference": identity(args.output / f"reference-{seed}.npz"),
                    "independent_reference": "CPU NumPy expression (X+X)*(X+X)"})
                result = execute.run_artifact(artifact, abi,
                    dict(np.load(args.output / f"inputs-{seed}.npz")),
                    dict(np.load(args.output / f"reference-{seed}.npz")),
                    folder, 1, 1e-5, 1e-5, warmups=0)
                result["validation_scope"] = "one numerical correctness launch per seed; no performance comparison"
                result["physical_speedup_claim"] = False
                save(folder / "result.json", result)
                if result["status"] != "passed":
                    raise RuntimeError("NPU numerical validation failed")


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--tool", type=Path, required=True)
    p.add_argument("--output", type=Path, required=True)
    p.add_argument("--stage", choices=("prepare", "compile", "check", "execute"), default="prepare")
    p.add_argument("--cases", nargs="+", choices=("original", "fused", "fissioned", "tiled"),
                   default=["original", "fused", "fissioned", "tiled"])
    p.add_argument("--executor", type=Path, default=Path(
        "/home/shiran/project/orbit-artifact/taskflow/scripts/taskflow_direct_air_execute.py"))
    args = p.parse_args()
    args.tool = args.tool.resolve()
    args.output = args.output.resolve()
    {"prepare": prepare, "compile": compile_cases, "check": check_cases, "execute": execute_cases}[args.stage](args)


if __name__ == "__main__":
    main()
