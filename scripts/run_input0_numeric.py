#!/usr/bin/env python3
"""Run the compiler-owned input-0 host numeric gate.

This launcher only sequences the optimizer, MLIR lowering, and independent
reference library.  It does not rank or rewrite candidates.  The script is
kept in ``scripts`` so the prepared compatibility shim can discover it from a
clean artifact checkout.
"""
from __future__ import annotations

import argparse
from concurrent.futures import ThreadPoolExecutor
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time
from typing import Any, Iterable, Sequence

ROOT = Path(__file__).resolve().parents[1]


def _atomic_bytes(path: Path, payload: bytes) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.partial-{os.getpid()}")
    try:
        temporary.write_bytes(payload)
        os.replace(temporary, path)
    finally:
        try:
            temporary.unlink()
        except FileNotFoundError:
            pass


def _write_json(path: Path, value: Any) -> None:
    _atomic_bytes(path, (json.dumps(value, indent=2) + "\n").encode())


def _as_path(value: Path | None, *, base: Path) -> Path | None:
    if value is None:
        return None
    return (value if value.is_absolute() else base / value).resolve()


def _reference_name(workload: str) -> str:
    return "libllama_nonuniform_reference.so" if workload == "llama" else f"lib{workload}_reference.so"


def _first_existing(paths: Iterable[Path]) -> Path:
    for path in paths:
        if path.is_file():
            return path
    # Keep a useful path in the durable record when all candidates are absent.
    return next(iter(paths))


def _check(
    workload: str,
    stage: str,
    rank: int,
    negative: bool,
    *,
    root: Path,
    output_root: Path,
    production_root: Path,
    llvm: Path,
    libs: Path,
    optimizer: Path,
    native_root: Path | None,
    llama_harness: Path,
    raytracing_source: Path | None,
) -> dict[str, Any]:
    source = production_root / "production-scheduler-global-replays" / workload / stage / "native" / f"rank-{rank}" / "native.mlir"
    if native_root is not None:
        source = native_root / f"rank-{rank}" / "native.mlir"
    scope = "mapped-native"
    if workload == "raytracing" and not source.exists():
        candidates = []
        if raytracing_source is not None:
            candidates.append(raytracing_source)
        candidates.extend(
            [
                root / ".work/input0-source-owned-once-mainline-v1/prepared/raytracing/identified-prepared-shaped.mlir",
            ]
        )
        source = _first_existing(candidates)
        scope = "prepared-source-diagnostic"

    label = f"{stage}-rank-{rank}" + ("-negative-control" if negative else "")
    out = output_root / workload / label
    out.mkdir(parents=True, exist_ok=True)
    independent_reference = libs / _reference_name(workload)
    record: dict[str, Any] = dict(
        schema="orbit-input0-cpp-host-numeric-gate-v1",
        workload=workload,
        source=str(source),
        scope=scope,
        stage=stage,
        rank=rank,
        commands=[],
        negative_control=negative,
        expected_mismatches=1 if negative else 0,
        independent_reference=str(independent_reference),
        compiler_owned_fixture_and_execution=True,
        stage_admission="not_claimed",
    )
    environment = os.environ.copy()
    if negative:
        environment["ORBIT_NUMERIC_NEGATIVE_CONTROL"] = "1"
    else:
        environment.pop("ORBIT_NUMERIC_NEGATIVE_CONTROL", None)

    host_option = f"--lower-joint-taskflow-to-host-scf=input0-numeric-program={workload}"
    if workload == "llama":
        if not llama_harness.is_file():
            record.update(status="incomplete", blocker=f"missing LLaMA host harness: {llama_harness}")
            _write_json(out / "result.json", record)
            return record
        record["independent_reference"] = str(libs / "libllama_nonuniform_reference.so")
        record["host_harness"] = str(llama_harness)
        host_option = f"--lower-joint-taskflow-to-host-scf=host-harness={llama_harness}"

    commands = [
        (
            "host",
            [
                str(optimizer),
                str(source),
                "--verify-each",
                host_option,
                "-o",
                str(out / "host.mlir"),
            ],
        ),
        (
            "llvm",
            [
                str(llvm / "bin/mlir-opt"),
                str(out / "host.mlir"),
                "--verify-each",
                "--convert-scf-to-cf",
                "--convert-cf-to-llvm",
                "--convert-arith-to-llvm",
                "--finalize-memref-to-llvm",
                "--convert-func-to-llvm",
                "--reconcile-unrealized-casts",
                "-o",
                str(out / "llvm.mlir"),
            ],
        ),
        (
            "run",
            [
                str(llvm / "bin/mlir-runner"),
                str(out / "llvm.mlir"),
                "-e",
                "main",
                "-entry-point-result=i64",
                "-O2",
                "-shared-libs",
                str(llvm / "lib/libmlir_runner_utils.so"),
                "-shared-libs",
                str(independent_reference),
            ],
        ),
    ]
    for step, argv in commands:
        began = time.monotonic()
        command_record = dict(step=step, argv=argv)
        try:
            with (out / f"{step}.stdout.log").open("w") as stdout, (out / f"{step}.stderr.log").open("w") as stderr:
                process = subprocess.run(argv, stdout=stdout, stderr=stderr, env=environment)
        except OSError as error:
            command_record.update(elapsed_seconds=time.monotonic() - began, exit_code=None, error=str(error))
            record["commands"].append(command_record)
            record.update(status="incomplete", blocker=f"{step} could not start")
            break
        command_record.update(elapsed_seconds=time.monotonic() - began, exit_code=process.returncode)
        record["commands"].append(command_record)
        # mlir-runner reports the entrypoint value separately from its process
        # status. Even a previously printed numeric marker cannot admit a
        # failed process.
        if process.returncode:
            record.update(status="incomplete", blocker=f"{step} failed")
            break
    else:
        stderr_path = out / "run.stderr.log"
        text = stderr_path.read_text() if stderr_path.is_file() else ""
        match = re.search(
            r"ORBIT_NUMERIC_RESULT mismatches=(\d+) comparisons=(\d+) actual_nonzero=(\d+) expected_nonzero=(\d+)",
            text,
        )
        if not match:
            record.update(status="incomplete", blocker="independent reference result missing")
        else:
            record.update(
                zip(
                    ("mismatches", "element_comparisons", "actual_nonzero", "expected_nonzero"),
                    map(int, match.groups()),
                )
            )
            expected = 1 if negative else 0
            record["status"] = "pass" if record["mismatches"] == expected and record["element_comparisons"] > 0 else "fail"
    _write_json(out / "result.json", record)
    print(workload, label, record.get("status"), record.get("mismatches", record.get("blocker")), flush=True)
    return record


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser()
    parser.add_argument("--workloads", nargs="+", default=["lu", "gcn", "harris", "radar", "raytracing"])
    parser.add_argument("--stage", default="shape-temporal")
    parser.add_argument("--ranks", nargs="+", type=int, default=[0])
    parser.add_argument("--negative-control", action="store_true")
    parser.add_argument("--native-root", type=Path)
    parser.add_argument("--jobs", type=int, default=3)
    parser.add_argument("--artifact-root", type=Path, default=ROOT)
    parser.add_argument("--output-root", type=Path)
    parser.add_argument("--production-root", type=Path)
    parser.add_argument("--llvm-build", type=Path)
    parser.add_argument("--reference-root", "--libs", dest="reference_root", type=Path)
    parser.add_argument("--optimizer", type=Path)
    parser.add_argument("--llama-harness", type=Path)
    parser.add_argument("--raytracing-source", type=Path)
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    args = _parser().parse_args(argv)
    if args.jobs < 1:
        raise SystemExit("--jobs must be positive")
    root = args.artifact_root.resolve()
    output_root = (args.output_root or root / "results/input0-cpp-numeric-gates").resolve()
    production_root = (args.production_root or root / "results/input0-cpp-mainline-20261001").resolve()
    llvm = (args.llvm_build or os.environ.get("ORBIT_LLVM_BUILD") or root / ".work/llvm-build")
    llvm = Path(llvm).resolve()
    libs = (args.reference_root or root / ".work/selected-native-numeric-gate").resolve()
    optimizer = (args.optimizer or root / ".work/mainline-tools/mlir-amoeba-opt").resolve()
    native_root = _as_path(args.native_root, base=root)
    llama_harness = (args.llama_harness or root / ".work/cpp-gate-continuation-agent/source/replica-validation/task0-task1-k2.runner.mlir").resolve()
    raytracing_source = _as_path(args.raytracing_source, base=root)

    items = [
        (workload, args.stage, rank, args.negative_control)
        for workload in args.workloads
        for rank in args.ranks
    ]
    def run(item: tuple[str, str, int, bool]) -> dict[str, Any]:
        return _check(
            *item,
            root=root,
            output_root=output_root,
            production_root=production_root,
            llvm=llvm,
            libs=libs,
            optimizer=optimizer,
            native_root=native_root,
            llama_harness=llama_harness,
            raytracing_source=raytracing_source,
        )

    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        records = list(pool.map(run, items))
    _write_json(
        output_root / "latest-batch.json",
        dict(schema="orbit-input0-cpp-host-numeric-batch-v1", records=records, production_ready=False),
    )
    failed = any(record.get("status") != "pass" for record in records)
    return 1 if failed else 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except KeyboardInterrupt:
        raise SystemExit(130)
