#!/usr/bin/env python3
"""Prepare fresh source-domain and numeric inputs for the v19 reproduction.

This entrypoint deliberately does not install the historical template bundle.
It asks the tracked C++ source-domain preparer to regenerate canonical MLIR,
proofs, task-shape spaces, model costs, and ML caches from the complete affine
inputs, then builds the independent host reference libraries.
"""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import shutil
import stat
import subprocess
import sys
from typing import Any, Sequence

ROOT = Path(__file__).resolve().parents[1]
WORKLOADS = ("llama", "lu", "gcn", "harris", "radar", "raytracing")
MODEL_FILES = ("ensemble.json", "baseline.json", "large-operation.json", "ranking.json")
REFERENCE_SPECS = (
    ("gcn", "gcn_reference.cpp", "libgcn_reference.so"),
    ("harris", "harris_reference.cpp", "libharris_reference.so"),
    ("llama", "llama_nonuniform_reference.cpp", "libllama_nonuniform_reference.so"),
    ("lu", "lu_reference.cpp", "liblu_reference.so"),
    ("radar", "radar_reference.cpp", "libradar_reference.so"),
    ("raytracing", "raytracing_reference.cpp", "libraytracing_reference.so"),
)
LLAMA_HARNESS_RELATIVE = Path(
    "reference/input0-neighborhood/numeric/task0-task1-k2.runner.mlir"
)
REPLAY_LLAMA_HARNESS_RELATIVE = Path(
    ".work/cpp-gate-continuation-agent/source/replica-validation/task0-task1-k2.runner.mlir"
)
NUMERIC_LIBRARY_RELATIVE = Path(".work/selected-native-numeric-gate")


class PreparationError(RuntimeError):
    """A fail-closed preparation error."""


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + f".partial-{os.getpid()}")
    try:
        temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
        os.replace(temporary, path)
    finally:
        try:
            temporary.unlink()
        except FileNotFoundError:
            pass


def resolve_path(value: Path | None, env_name: str, fallback: Path, root: Path) -> Path:
    selected = value or os.environ.get(env_name) or fallback
    path = Path(selected)
    return (path if path.is_absolute() else root / path).resolve()


def validate_model_bundle(model_root: Path) -> Path:
    ensemble_path = model_root / "ensemble.json"
    if not ensemble_path.is_file():
        raise PreparationError(
            f"missing portable model bundle at {model_root}; expected {', '.join(MODEL_FILES)}"
        )
    try:
        ensemble = json.loads(ensemble_path.read_text())
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
        raise PreparationError(f"cannot read model ensemble {ensemble_path}: {error}") from error
    if ensemble.get("schema") == "orbit-cgra-ii-per-cgra-2x2-direct-ensemble-cpp-v1":
        if (not isinstance(ensemble.get("members"), list) or len(ensemble["members"]) != 4
                or not isinstance(ensemble.get("feature_contract", {}).get("feature_names"), list)
                or len(ensemble["feature_contract"]["feature_names"]) != 148
                or not isinstance(ensemble.get("architecture", {}).get("exact_yaml_text"), str)
                or not ensemble["architecture"]["exact_yaml_text"]
                or not isinstance(ensemble.get("model_namespace"), str)):
            raise PreparationError("direct 2x2 portable ensemble has an incomplete contract")
        return ensemble_path
    checkpoints = ensemble.get("checkpoints")
    if not isinstance(checkpoints, dict) or set(checkpoints) != {
        "baseline", "large-operation", "ranking"
    }:
        raise PreparationError("model ensemble must name baseline, large-operation, and ranking")
    expected = set(MODEL_FILES) - {"ensemble.json"}
    found: set[str] = set()
    for name, record in checkpoints.items():
        if not isinstance(record, dict) or not isinstance(record.get("path"), str):
            raise PreparationError(f"model checkpoint has no relative path: {name}")
        relative = Path(record["path"])
        if relative.as_posix() != f"{name}.json":
            raise PreparationError(f"model checkpoint binding is unexpected for {name}: {record['path']}")
        if relative.is_absolute() or ".." in relative.parts:
            raise PreparationError(f"model checkpoint path escapes the bundle: {record['path']}")
        if relative.name not in expected:
            raise PreparationError(f"unexpected model checkpoint: {record['path']}")
        checkpoint = (model_root / relative).resolve()
        try:
            checkpoint.relative_to(model_root.resolve())
        except ValueError as error:
            raise PreparationError(f"model checkpoint escapes the bundle: {record['path']}") from error
        if not checkpoint.is_file():
            raise PreparationError(f"missing model checkpoint: {checkpoint}")
        found.add(relative.name)
    if found != expected:
        raise PreparationError(f"model checkpoint set differs from {sorted(expected)}")
    for name in MODEL_FILES:
        if not (model_root / name).is_file():
            raise PreparationError(f"model bundle is incomplete: {model_root / name}")
    return ensemble_path


def copy_exact_once(source: Path, destination: Path) -> None:
    """Install a runtime copy only if absent or already byte-identical."""
    payload = source.read_bytes()
    destination.parent.mkdir(parents=True, exist_ok=True)
    if destination.exists() or destination.is_symlink():
        if destination.is_symlink() or not destination.is_file() or destination.read_bytes() != payload:
            raise PreparationError(
                f"refusing to replace a different existing runtime harness: {destination}"
            )
        return
    temporary = destination.with_name(destination.name + f".partial-{os.getpid()}")
    try:
        temporary.write_bytes(payload)
        os.replace(temporary, destination)
    finally:
        try:
            temporary.unlink()
        except FileNotFoundError:
            pass


def build_reference_libraries(
    artifact_root: Path, amoeba_test_root: Path, compiler: str, *, dry_run: bool
) -> list[str]:
    numeric_root = artifact_root / "reference/input0-neighborhood/numeric"
    runtime_header = numeric_root / "input0_reference_runtime.h"
    if not runtime_header.is_file():
        raise PreparationError(f"missing numeric runtime header: {runtime_header}")
    for directory in (amoeba_test_root / "Evaluation",):
        if not directory.is_dir():
            raise PreparationError(f"missing independent reference source tree: {directory}")
    for _, source_name, _ in REFERENCE_SPECS:
        source = numeric_root / source_name
        if not source.is_file():
            raise PreparationError(f"missing numeric wrapper: {source}")

    output_root = artifact_root / NUMERIC_LIBRARY_RELATIVE
    if dry_run:
        return [str(output_root / library_name) for _, _, library_name in REFERENCE_SPECS]
    output_root.mkdir(parents=True, exist_ok=True)
    built: list[str] = []
    for _, source_name, library_name in REFERENCE_SPECS:
        source = numeric_root / source_name
        destination = output_root / library_name
        temporary = output_root / f".{library_name}.build-{os.getpid()}"
        command = [
            compiler,
            "-std=c++17",
            "-O2",
            "-fPIC",
            "-shared",
            "-I",
            str(amoeba_test_root),
            "-I",
            str(numeric_root),
            str(source),
            "-o",
            str(temporary),
        ]
        try:
            process = subprocess.run(command, text=True, capture_output=True, check=False)
            if process.returncode:
                detail = process.stderr.strip() or process.stdout.strip()
                raise PreparationError(f"reference build failed for {source_name}: {detail}")
            if not temporary.is_file():
                raise PreparationError(f"reference compiler produced no library: {temporary}")
            os.chmod(temporary, stat.S_IMODE(temporary.stat().st_mode))
            os.replace(temporary, destination)
            built.append(str(destination.relative_to(artifact_root)))
        finally:
            try:
                temporary.unlink()
            except FileNotFoundError:
                pass
    return built


def make_chain_config(output_root: Path, workloads: Sequence[str], model_ensemble: Path) -> Path:
    # All generated program/cost paths are relative to this config file. The
    # chain launcher resolves them from the config directory on every machine.
    config = {
        "schema": "orbit-amoeba-input0-neighborhood-chain-config-v1",
        "defaults": {"model_cache": os.path.relpath(model_ensemble, output_root)},
        "workloads": {
            workload: {
                "canonical": f"{workload}/canonical.mlir",
                "parent_cost_file": f"{workload}/cost-catalog.json",
                "cost_cache": f"{workload}/ml-cache.json",
            }
            for workload in workloads
        },
    }
    path = output_root / "input0-chain.json"
    write_json(path, config)
    return path


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--artifact-root", type=Path, default=ROOT)
    parser.add_argument("--optimizer", type=Path)
    parser.add_argument("--architecture", type=Path)
    parser.add_argument("--model-root", type=Path)
    parser.add_argument("--source-repository")
    parser.add_argument("--source-commit")
    parser.add_argument("--model-namespace")
    parser.add_argument("--output-root", type=Path)
    parser.add_argument("--amoeba-test-root", type=Path)
    parser.add_argument("--llama-harness", type=Path)
    parser.add_argument("--workloads", nargs="+", choices=WORKLOADS, default=list(WORKLOADS))
    parser.add_argument("--ray-fission-split-at", type=int, choices=range(8), default=0,
                        help="separate Ray supplement only; zero leaves the original graph")
    parser.add_argument("--jobs", type=int, default=1)
    parser.add_argument("--cxx", default=os.environ.get("CXX"))
    parser.add_argument("--dry-run", action="store_true",
                        help="write source-domain pass plans and skip C++/reference builds")
    parser.add_argument("--skip-reference-build", action="store_true")
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    args = _parser().parse_args(argv)
    root = args.artifact_root.resolve()
    if args.jobs < 1 or args.jobs > 3:
        raise PreparationError("--jobs must be from 1 to 3")
    workloads = list(dict.fromkeys(args.workloads))
    if args.ray_fission_split_at and workloads != ["raytracing"]:
        raise PreparationError("fission reproduction must use a separate Ray-only output")
    model_root = resolve_path(
        args.model_root, "ORBIT_MODEL_ROOT", root / "reference/input0-neighborhood/models", root
    )
    model_ensemble = validate_model_bundle(model_root)
    model_metadata = json.loads(model_ensemble.read_text())
    if model_metadata.get("schema") == "orbit-cgra-ii-per-cgra-2x2-direct-ensemble-cpp-v1":
        if not args.source_repository or not args.source_commit:
            raise PreparationError("direct 2x2 preparation requires explicit --source-repository and --source-commit")
        if args.model_namespace and args.model_namespace != model_metadata["model_namespace"]:
            raise PreparationError("model namespace differs from the direct 2x2 ensemble")
        args.model_namespace = model_metadata["model_namespace"]
    optimizer = resolve_path(
        args.optimizer, "ORBIT_OPTIMIZER",
        root / ".work/mainline-tools/mlir-amoeba-opt", root
    )
    if not optimizer.is_file() or not os.access(optimizer, os.X_OK):
        raise PreparationError(f"optimizer is missing or not executable: {optimizer}")
    architecture = resolve_path(
        args.architecture, "ORBIT_ARCHITECTURE",
        root / "config/architectures/amoeba_4x4_full_mesh_context12.yaml", root
    )
    if not architecture.is_file():
        raise PreparationError(f"architecture spec is missing: {architecture}")
    if (model_metadata.get("schema") == "orbit-cgra-ii-per-cgra-2x2-direct-ensemble-cpp-v1"
            and model_metadata["architecture"]["exact_yaml_text"] != architecture.read_text()):
        raise PreparationError("architecture bytes differ from the direct 2x2 model")
    output_root = resolve_path(
        args.output_root, "ORBIT_SOURCE_DOMAIN_OUTPUT",
        root / ".work/input0-neighborhood-v19/source-domain-prep", root
    )
    amoeba_test_root = resolve_path(
        args.amoeba_test_root, "AMOEBA_TEST_ROOT",
        root / "reference/input0-neighborhood/reference-source", root
    )
    harness = resolve_path(
        args.llama_harness, "ORBIT_LLAMA_HOST_HARNESS",
        root / LLAMA_HARNESS_RELATIVE, root
    )
    if not harness.is_file():
        raise PreparationError(f"missing portable LLaMA host harness: {harness}")

    source_prep = root / "scripts/prepare_input0_source_domains.py"
    if not source_prep.is_file():
        raise PreparationError(f"tracked source-domain preparer is missing: {source_prep}")
    command = [
        sys.executable,
        str(source_prep),
        "--artifact-root", str(root),
        "--optimizer", str(optimizer),
        "--architecture", str(architecture),
        "--model", str(model_root),
        "--output-root", str(output_root),
        "--workloads", *workloads,
        "--jobs", str(args.jobs),
        "--cost-catalog",
        "--allow-unsupported-model-shapes",
    ]
    for name in ("source_repository", "source_commit", "model_namespace"):
        value = getattr(args, name)
        if value:
            command.extend(("--" + name.replace("_", "-"), value))
    if args.ray_fission_split_at:
        command.extend(("--ray-fission-split-at", str(args.ray_fission_split_at)))
    if args.dry_run:
        command.append("--dry-run")
    process = subprocess.run(command, check=False)
    if process.returncode:
        raise PreparationError(
            f"source-domain preparation failed with exit code {process.returncode}"
        )

    chain_config = make_chain_config(output_root, workloads, model_ensemble)
    compiler = args.cxx or shutil.which("g++") or shutil.which("clang++")
    if not args.dry_run and not args.skip_reference_build and not compiler:
        raise PreparationError("no g++ or clang++ found; pass --cxx or --skip-reference-build")
    libraries = build_reference_libraries(
        root, amoeba_test_root, compiler or "c++", dry_run=args.dry_run or args.skip_reference_build
    )
    runtime_harness = root / REPLAY_LLAMA_HARNESS_RELATIVE
    if not args.dry_run:
        copy_exact_once(harness, runtime_harness)
    record = {
        "schema": "orbit-input0-neighborhood-v19-preparation-v1",
        "status": "dry-run" if args.dry_run else "prepared",
        "artifact_root": str(root),
        "source_domain_output": str(output_root),
        "chain_config": str(chain_config),
        "model_root": str(model_root),
        "model_ensemble": str(model_ensemble),
        "optimizer": str(optimizer),
        "architecture": str(architecture),
        "workloads": workloads,
        "ray_fission_split_at": args.ray_fission_split_at,
        "cost_catalog_generation_planned": bool(args.dry_run),
        "cost_catalogs_regenerated": not args.dry_run,
        "allow_unsupported_model_shapes": True,
        "numeric_reference_libraries": libraries,
        "numeric_reference_libraries_built": not args.dry_run and not args.skip_reference_build,
        "llama_harness_source": str(harness),
        "llama_harness_runtime_copy": str(runtime_harness),
        "llama_harness_installed": not args.dry_run,
        "reference_build_skipped": bool(args.dry_run or args.skip_reference_build),
    }
    write_json(output_root / "preparation.json", record)
    print(json.dumps(record, indent=2))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (PreparationError, OSError, ValueError) as error:
        print(f"prepare_input0_neighborhood_reproduction.py: {error}", file=sys.stderr)
        raise SystemExit(1)
    except KeyboardInterrupt:
        raise SystemExit(130)
