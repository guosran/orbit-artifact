#!/usr/bin/env python3
"""Capture the exact source/model/replay payload for a public replay.

The contract is an exact serialized-byte binding.  It deliberately carries no
content hashes: source and model texts are embedded directly, while path
references are repository-relative or symbolic.  The original experiment
source identity remains ``a57376e...``; the published checkout's Git HEAD is
recorded separately.
"""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import subprocess
import sys
from typing import Any, Iterable, Mapping, Sequence

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL_SOURCE_COMMIT = "a57376e7043b1681e64e7169c5a8cb02eb192331"
MODEL_NAMESPACE = "formal-max4-nohash-v2-exploratory"
SCOPES = (
    "lib/Backend/Neura/Orchestration",
    "include/Backend/Neura/Orchestration",
    "lib/TaskflowDialect",
    "include/TaskflowDialect",
    "include/Backend/Neura/Conversion/TaskflowToNeura",
    "lib/Backend/Neura/Conversion/TaskflowToNeura",
    "lib/Backend/Neura/Transforms",
    "lib/Conversion/AffineToTaskflow",
    "thirdparty/neura/lib/NeuraDialect/Architecture",
    "thirdparty/neura/include/NeuraDialect/Architecture",
    "thirdparty/neura/lib/NeuraDialect/Transforms/Optimizations",
    "thirdparty/neura/include/NeuraDialect/Transforms/Optimizations",
)
EXPLICIT_SOURCE_FILES = (
    "include/Backend/Neura/NeuraBackendPasses.h",
    "include/Backend/Neura/NeuraBackendPasses.td",
)
REPLAY_FILES = (
    "scripts/neighborhood_replay.py",
    "scripts/run_neighborhood_stage_chain.py",
    "scripts/render_neighborhood_table.py",
    "scripts/replay_cpp_global_top5.py",
    "scripts/validate_embedded_native_trace.py",
    "scripts/run_input0_numeric.py",
    "scripts/run_input0_all_unit_baselines.py",
    "scripts/run_input0_original_amoeba_baselines.py",
    "scripts/validate_original_amoeba_fixed_retiming.py",
    "config/architectures/amoeba_4x4_vectorcgra_sram.json",
)
MODEL_FILES = ("ensemble.json", "baseline.json", "large-operation.json", "ranking.json")
DIRECT_2X2_SCHEMA = "orbit-cgra-ii-per-cgra-2x2-direct-ensemble-cpp-v1"


class ContractError(RuntimeError):
    """A fail-closed source-contract error."""


def _atomic_bytes(path: Path, payload: bytes) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() or path.is_symlink():
        if not path.is_file() or path.read_bytes() != payload:
            raise ContractError(f"refusing to overwrite mismatched existing file: {path}")
        return
    temporary = path.with_name(f".{path.name}.partial-{os.getpid()}")
    try:
        temporary.write_bytes(payload)
        os.replace(temporary, path)
    finally:
        try:
            temporary.unlink()
        except FileNotFoundError:
            pass


def _read_utf8(path: Path) -> str:
    try:
        return path.read_bytes().decode("utf-8")
    except (OSError, UnicodeDecodeError) as error:
        raise ContractError(f"cannot read UTF-8 payload {path}: {error}") from error


def _relative(root: Path, path: Path, label: str) -> str:
    try:
        return str(path.resolve().relative_to(root.resolve()))
    except ValueError as error:
        raise ContractError(f"{label} is outside its declared root: {path}") from error


def _source_paths(source_root: Path, source_list_path: Path) -> list[str]:
    if source_list_path.is_file():
        try:
            document = json.loads(_read_utf8(source_list_path))
        except json.JSONDecodeError as error:
            raise ContractError(f"source file list is not JSON: {source_list_path}: {error}") from error
        if isinstance(document, list):
            values = document
        elif isinstance(document, dict):
            values = None
            for key in ("files", "source_files", "paths"):
                if isinstance(document.get(key), list):
                    values = document[key]
                    break
            if values is None:
                raise ContractError("source file list has no files/source_files/paths array")
        else:
            raise ContractError("source file list must be an array or object")
        paths: list[str] = []
        for value in values:
            if isinstance(value, str):
                relative = value
            elif isinstance(value, dict) and isinstance(value.get("path"), str):
                relative = value["path"]
            else:
                raise ContractError("source file list contains a malformed path")
            candidate = Path(relative)
            if candidate.is_absolute() or ".." in candidate.parts:
                raise ContractError(f"source file list path is not relative: {relative}")
            path = (source_root / candidate).resolve()
            try:
                path.relative_to(source_root.resolve())
            except ValueError as error:
                raise ContractError(f"source file list escapes source root: {relative}") from error
            if not path.is_file():
                raise ContractError(f"source file list entry is missing: {relative}")
            paths.append(str(candidate))
        return sorted(set(paths))

    discovered: set[str] = set()
    for relative_scope in SCOPES:
        scope = source_root / relative_scope
        if not scope.exists():
            continue
        for path in scope.rglob("*"):
            if path.is_file() and path.suffix in {".cpp", ".h", ".td"}:
                discovered.add(_relative(source_root, path, "source file"))
    for relative in EXPLICIT_SOURCE_FILES:
        path = source_root / relative
        if path.is_file():
            discovered.add(relative)
    if not discovered:
        raise ContractError(f"no source payload files found below {source_root}")
    values = sorted(discovered)
    payload = {
        "schema": "orbit-neighborhood-source-file-list-v1",
        "files": values,
    }
    _atomic_bytes(source_list_path, (json.dumps(payload, indent=2) + "\n").encode())
    return values


def _model_payloads(model_root: Path) -> list[dict[str, str]]:
    ensemble_path = model_root / "ensemble.json"
    if not ensemble_path.is_file():
        raise ContractError(f"missing model ensemble: {ensemble_path}")
    ensemble_text = _read_utf8(ensemble_path)
    try:
        ensemble = json.loads(ensemble_text)
    except json.JSONDecodeError as error:
        raise ContractError(f"model ensemble is not JSON: {error}") from error
    if ensemble.get("schema") == DIRECT_2X2_SCHEMA:
        return [{"path": "ensemble.json", "text": ensemble_text}]
    checkpoints = ensemble.get("checkpoints")
    if not isinstance(checkpoints, dict):
        raise ContractError("model ensemble has no checkpoints object")
    paths = ["ensemble.json"]
    for name in ("baseline", "large-operation", "ranking"):
        record = checkpoints.get(name)
        if not isinstance(record, dict) or not isinstance(record.get("path"), str):
            raise ContractError(f"model checkpoint path missing: {name}")
        relative = Path(record["path"])
        if relative.is_absolute() or ".." in relative.parts:
            raise ContractError(f"model checkpoint path is not model-relative: {record['path']}")
        paths.append(str(relative))
    if set(paths) != set(MODEL_FILES):
        raise ContractError(f"model ensemble checkpoint set differs from {MODEL_FILES}: {paths}")
    result = []
    for relative in paths:
        path = (model_root / relative).resolve()
        try:
            path.relative_to(model_root.resolve())
        except ValueError as error:
            raise ContractError(f"model path escapes model root: {relative}") from error
        if not path.is_file():
            raise ContractError(f"model checkpoint missing: {path}")
        result.append({"path": relative, "text": _read_utf8(path)})
    return result


def _git_head(source_root: Path) -> str | None:
    process = subprocess.run(
        ["git", "-C", str(source_root), "rev-parse", "HEAD"],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        check=False,
    )
    if process.returncode == 0:
        value = process.stdout.strip()
        return value or None
    return None


def _git_dirty(source_root: Path) -> bool | None:
    process = subprocess.run(
        ["git", "-C", str(source_root), "status", "--porcelain", "--untracked-files=all"],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if process.returncode:
        return None
    return bool(process.stdout.strip())


def _portable_path(path: Path, artifact_root: Path, source_root: Path, build_root: Path) -> str:
    for base, token in (
        (artifact_root, "${ARTIFACT_ROOT}"),
        (source_root, "${ORBIT_SRC}"),
        (build_root, "${ORBIT_BUILD}"),
    ):
        try:
            return f"{token}/{path.resolve().relative_to(base.resolve())}"
        except ValueError:
            continue
    raise ContractError(
        "optimizer is outside artifact, source, and build roots; "
        "pass --build-root for a portable optimizer pin"
    )


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser()
    parser.add_argument("--artifact-root", type=Path, default=ROOT)
    parser.add_argument("--source-root", type=Path)
    parser.add_argument("--build-root", type=Path)
    parser.add_argument("--model-root", type=Path)
    parser.add_argument("--optimizer", type=Path)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--source-file-list", type=Path)
    parser.add_argument("--source-commit", help="cost/source namespace for this new cohort")
    parser.add_argument("--model-namespace")
    parser.add_argument("--sram-config", type=Path)
    parser.add_argument("--inter-task-network", type=Path)
    return parser


def _resolve(value: Path | None, env_name: str, fallback: Path, root: Path) -> Path:
    selected = value or os.environ.get(env_name) or fallback
    path = Path(selected)
    return (path if path.is_absolute() else root / path).resolve()


def main(argv: Sequence[str] | None = None) -> int:
    args = _parser().parse_args(argv)
    artifact_root = args.artifact_root.resolve()
    source_root = _resolve(args.source_root, "ORBIT_SRC", artifact_root / ".work/neura-facts-host-worker", artifact_root)
    build_root = _resolve(args.build_root, "ORBIT_BUILD", artifact_root / ".work/neura-facts-host-build", artifact_root)
    model_root = _resolve(args.model_root, "ORBIT_MODEL_ROOT", artifact_root / ".work/formal-model-nohash-v2-trained-rerun", artifact_root)
    optimizer = _resolve(args.optimizer, "ORBIT_OPTIMIZER", artifact_root / ".work/mainline-tools/mlir-amoeba-opt-v9-neighborhood", artifact_root)
    output = _resolve(args.output, "ORBIT_SOURCE_CONTRACT_OUTPUT", artifact_root / ".work/neighborhood-search-20261003/source-integration/source-model-contract-public.json", artifact_root)
    source_list = _resolve(args.source_file_list, "ORBIT_SOURCE_FILE_LIST", artifact_root / "reference/input0-neighborhood/source-file-list.json", artifact_root)
    if not source_root.is_dir():
        raise ContractError(f"source root does not exist: {source_root}")
    source_paths = _source_paths(source_root, source_list)
    source_payloads = [{"path": relative, "text": _read_utf8(source_root / relative)} for relative in source_paths]
    model_payloads = _model_payloads(model_root)
    replay_payloads = []
    replay_files = list(REPLAY_FILES)
    if args.sram_config:
        replay_files[-1] = _relative(artifact_root, args.sram_config, "SRAM configuration")
    if args.inter_task_network:
        replay_files.append(_relative(artifact_root, args.inter_task_network, "inter-task network configuration"))
    for relative in replay_files:
        path = artifact_root / relative
        if not path.is_file():
            raise ContractError(f"missing replay payload: {path}")
        replay_payloads.append({"path": relative, "text": _read_utf8(path)})
    try:
        source_list_public = str(source_list.resolve().relative_to(artifact_root.resolve()))
    except ValueError:
        source_list_public = "reference/input0-neighborhood/source-file-list.json"
    ensemble_metadata = json.loads(model_payloads[0]["text"])
    direct_2x2 = ensemble_metadata.get("schema") == DIRECT_2X2_SCHEMA
    model_namespace = args.model_namespace or ensemble_metadata.get("model_namespace")
    if direct_2x2 and not isinstance(model_namespace, str):
        raise ContractError("direct 2x2 ensemble must declare its model_namespace")
    if direct_2x2 and model_namespace != ensemble_metadata.get("model_namespace"):
        raise ContractError("model namespace differs from the direct 2x2 ensemble")
    body = {
        "schema": "orbit-neighborhood-exact-source-model-contract-v1",
        "source_commit": args.source_commit or (_git_head(source_root) if direct_2x2 else ORIGINAL_SOURCE_COMMIT),
        "published_source_commit": _git_head(source_root),
        "model_namespace": model_namespace or MODEL_NAMESPACE,
        "source_dirty": _git_dirty(source_root),
        "search_contract": "orbit-neighborhood-search-v1",
        "rewrite_contract": "orbit-joint-graph-rewrite-contract-v8",
        "immutable_optimizer_pin": _portable_path(optimizer, artifact_root, source_root, build_root),
        "identity_policy": "exact serialized source and model bytes, no SHA-256",
        "source_file_list": source_list_public,
        "sources": source_payloads,
        "model_payloads": model_payloads,
        "replay_payloads": replay_payloads,
    }
    payload = (json.dumps(body, separators=(",", ":")) + "\n").encode()
    _atomic_bytes(output, payload)
    print(json.dumps({"schema": body["schema"], "output": str(output), "source_files": len(source_payloads), "model_payloads": len(model_payloads), "replay_payloads": len(replay_payloads), "published_source_commit": body["published_source_commit"]}, indent=2))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except ContractError as error:
        print(f"write_neighborhood_source_contract.py: {error}", file=sys.stderr)
        raise SystemExit(1)
    except KeyboardInterrupt:
        raise SystemExit(130)
