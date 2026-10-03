#!/usr/bin/env python3
"""Install the portable input-0 neighborhood reproduction bundle.

The source bundle is supplied by the publication tree under
``reference/input0-neighborhood/templates``.  This helper only substitutes the
five run-time roots, installs files atomically, verifies the serialized model
and ML cache contract, installs the numeric compatibility shim, and optionally
builds the six independent reference libraries.
"""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import re
import shutil
import stat
import subprocess
import sys
from typing import Any, Mapping, Sequence

ROOT = Path(__file__).resolve().parents[1]
TOKENS = (
    "${ARTIFACT_ROOT}",
    "${ORBIT_SRC}",
    "${ORBIT_BUILD}",
    "${LLVM_BUILD}",
    "${LLVM_SOURCE}",
    "${AMOEBA_TEST_ROOT}",
)
UNRESOLVED_TOKEN = re.compile(rb"\$\{[A-Za-z_][A-Za-z0-9_]*\}")
MODEL_FILES = ("ensemble.json", "baseline.json", "large-operation.json", "ranking.json")
REFERENCE_SPECS = (
    ("gcn", "gcn_reference.cpp", "libgcn_reference.so"),
    ("harris", "harris_reference.cpp", "libharris_reference.so"),
    ("llama", "llama_nonuniform_reference.cpp", "libllama_nonuniform_reference.so"),
    ("lu", "lu_reference.cpp", "liblu_reference.so"),
    ("radar", "radar_reference.cpp", "libradar_reference.so"),
    ("raytracing", "raytracing_reference.cpp", "libraytracing_reference.so"),
)
SHIM = '''#!/usr/bin/env python3
"""Compatibility entrypoint for the frozen neighborhood replay script."""
from pathlib import Path
import runpy
import sys

ROOT = Path(__file__).resolve().parents[2]
SCRIPT = ROOT / "scripts" / "run_input0_numeric.py"
if not SCRIPT.is_file():
    raise SystemExit(f"missing tracked numeric runner: {SCRIPT}")
sys.argv[0] = str(SCRIPT)
runpy.run_path(str(SCRIPT), run_name="__main__")
'''.encode()


class PreparationError(RuntimeError):
    """A fail-closed preparation error."""


def _atomic_install(destination: Path, payload: bytes, *, mode: int | None = None) -> bool:
    """Install bytes only when the destination is absent or byte-identical."""
    destination.parent.mkdir(parents=True, exist_ok=True)
    if destination.exists() or destination.is_symlink():
        # A symlink can redirect an apparently harmless byte-equality check to
        # an unrelated path.  Keep the public namespace regular-file-only and
        # fail closed even when a symlink currently resolves inside the root.
        if destination.is_symlink() or not destination.is_file() or destination.read_bytes() != payload:
            raise PreparationError(f"refusing to overwrite mismatched existing file: {destination}")
        if mode is not None:
            os.chmod(destination, mode)
        return False
    temporary = destination.with_name(f".{destination.name}.partial-{os.getpid()}")
    try:
        temporary.write_bytes(payload)
        if mode is not None:
            os.chmod(temporary, mode)
        os.replace(temporary, destination)
    finally:
        try:
            temporary.unlink()
        except FileNotFoundError:
            pass
    return True


def _substitute(payload: bytes, values: Mapping[str, str]) -> bytes:
    for token in TOKENS:
        payload = payload.replace(token.encode(), values[token].encode())
    return payload


def _safe_destination(root: Path, relative: Path) -> Path:
    if relative.is_absolute() or ".." in relative.parts:
        raise PreparationError(f"template path escapes artifact root: {relative}")
    # Resolve only the parent so an existing final symlink is still visible to
    # the regular-file/fail-closed checks in ``_atomic_install``.
    candidate = root / relative
    try:
        candidate.parent.resolve().relative_to(root.resolve())
    except ValueError as error:
        raise PreparationError(f"template path escapes artifact root: {relative}") from error
    return candidate


def _bundle_manifest(template_root: Path) -> tuple[set[str], set[str]] | None:
    """Return declared payload and publication-metadata paths, if present."""
    manifest_path = template_root.parent / "bundle-manifest.json"
    if not manifest_path.is_file():
        return None
    try:
        document = json.loads(manifest_path.read_bytes().decode("utf-8"))
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
        raise PreparationError(f"cannot parse template bundle manifest: {manifest_path}: {error}") from error
    values = document.get("files") if isinstance(document, dict) else None
    if not isinstance(values, list) or not values or not all(isinstance(value, str) for value in values):
        raise PreparationError(f"template bundle manifest has no non-empty files list: {manifest_path}")
    declared: set[str] = set()
    for value in values:
        relative = Path(value)
        if relative.is_absolute() or ".." in relative.parts:
            raise PreparationError(f"template bundle manifest path escapes root: {value}")
        declared.add(str(relative))
    if len(declared) != len(values):
        raise PreparationError(f"template bundle manifest contains duplicate paths: {manifest_path}")
    metadata: set[str] = set()
    for key in ("profile", "chain"):
        value = document.get(key)
        if value is None:
            continue
        if not isinstance(value, str):
            raise PreparationError(f"template bundle manifest {key} path is not a string")
        relative = Path(value)
        if relative.is_absolute() or ".." in relative.parts:
            raise PreparationError(f"template bundle manifest {key} path escapes root: {value}")
        metadata.add(str(relative))
    if declared & metadata:
        raise PreparationError("template bundle manifest payload and metadata paths overlap")
    return declared, metadata


def _install_templates(template_root: Path, artifact_root: Path, values: Mapping[str, str]) -> list[str]:
    if not template_root.is_dir():
        raise PreparationError(f"template directory does not exist: {template_root}")
    manifest = _bundle_manifest(template_root)
    declared_paths = None if manifest is None else manifest[0] | manifest[1]
    # Preflight every destination before writing any file.  A publication
    # bundle must fail closed as a unit: discovering one stale or conflicting
    # destination halfway through installation must not leave a partial
    # bundle behind.
    pending: list[tuple[Path, bytes, int, str]] = []
    sources = [source for source in sorted(template_root.rglob("*")) if source.is_file() or source.is_symlink()]
    actual_paths = {str(source.relative_to(template_root)) for source in sources}
    if declared_paths is not None:
        missing = sorted(declared_paths - actual_paths)
        extra = sorted(actual_paths - declared_paths)
        if missing or extra:
            detail = []
            if missing:
                detail.append("missing=" + ",".join(missing[:8]))
            if extra:
                detail.append("unexpected=" + ",".join(extra[:8]))
            raise PreparationError("template bundle manifest does not match template tree: " + "; ".join(detail))
    for source in sources:
        if source.is_dir():
            continue
        if source.is_symlink() or not source.is_file():
            raise PreparationError(f"template entry is not a regular file: {source}")
        relative = source.relative_to(template_root)
        destination = _safe_destination(artifact_root, relative)
        mode = stat.S_IMODE(source.stat().st_mode)
        source_payload = source.read_bytes()
        if source_payload.startswith(b"ML\xefR"):
            raise PreparationError(f"MLIR bytecode requires C++ text export before path substitution: {relative}")
        payload = _substitute(source_payload, values)
        unresolved = sorted({match.decode("ascii") for match in UNRESOLVED_TOKEN.findall(payload)})
        if unresolved:
            raise PreparationError(
                f"unresolved template token(s) in {source}: {', '.join(unresolved)}"
            )
        if destination.exists() or destination.is_symlink():
            if not destination.is_file() or destination.read_bytes() != payload:
                raise PreparationError(f"refusing to overwrite mismatched existing file: {destination}")
        pending.append((destination, payload, mode, str(relative)))
    if not pending:
        raise PreparationError(f"template directory is empty: {template_root}")
    for destination, payload, mode, _ in pending:
        _atomic_install(destination, payload, mode=mode)
    return [relative for _, _, _, relative in pending]


def _model_cache_paths(artifact_root: Path) -> tuple[Path, dict[str, Path], Path]:
    model_root = artifact_root / ".work/formal-model-nohash-v2-trained-rerun"
    models = {name: model_root / name for name in MODEL_FILES}
    cache = artifact_root / ".work/input0-task-ml-cache.json"
    return model_root, models, cache


def _verify_model_cache(artifact_root: Path) -> None:
    """Verify model inputs and, when present, their runtime cache binding."""
    model_root, models, cache_path = _model_cache_paths(artifact_root)
    if not any(path.is_file() for path in [*models.values(), cache_path]):
        return
    missing = [str(path) for path in models.values() if not path.is_file()]
    if missing:
        raise PreparationError("model bundle is incomplete: " + ", ".join(missing))
    try:
        ensemble_text = models["ensemble.json"].read_text()
        ensemble = json.loads(ensemble_text)
        cache = json.loads(cache_path.read_text()) if cache_path.is_file() else None
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
        raise PreparationError(f"cannot parse model inputs: {error}") from error
    checkpoints = ensemble.get("checkpoints")
    if not isinstance(checkpoints, dict):
        raise PreparationError("model ensemble lacks checkpoints")
    by_name = None
    if cache is not None:
        resource = cache.get("resource_contract")
        if not isinstance(resource, dict) or resource.get("ensemble_text") != ensemble_text:
            raise PreparationError("ML cache ensemble_text differs from installed ensemble.json")
        raw = resource.get("checkpoint_texts")
        if not isinstance(raw, list):
            raise PreparationError("ML cache checkpoint resource contract is not a list")
        by_name = {}
        for item in raw:
            if not isinstance(item, dict) or not isinstance(item.get("name"), str) or not isinstance(item.get("text"), str):
                raise PreparationError("malformed ML cache checkpoint resource contract")
            by_name[item["name"]] = item["text"]
        if set(by_name) != set(checkpoints):
            raise PreparationError("ML cache checkpoint names differ from ensemble checkpoints")
    for name, record in checkpoints.items():
        if not isinstance(record, dict) or not isinstance(record.get("path"), str):
            raise PreparationError(f"ensemble checkpoint path missing: {name}")
        checkpoint_path = (model_root / record["path"]).resolve()
        try:
            checkpoint_path.relative_to(model_root.resolve())
        except ValueError as error:
            raise PreparationError(f"checkpoint path escapes model root: {record['path']}") from error
        if not checkpoint_path.is_file():
            raise PreparationError(f"checkpoint file missing: {checkpoint_path}")
        if by_name is not None and by_name[name] != checkpoint_path.read_text():
            raise PreparationError(f"ML cache checkpoint text differs from {checkpoint_path.name}")


def _build_reference_libraries(artifact_root: Path, amoeba_test_root: Path, compiler: str) -> list[str]:
    numeric_root = artifact_root / "reference/input0-neighborhood/numeric"
    header = numeric_root / "input0_reference_runtime.h"
    if not header.is_file():
        raise PreparationError(f"missing numeric runtime header: {header}")
    output_root = artifact_root / ".work/selected-native-numeric-gate"
    output_root.mkdir(parents=True, exist_ok=True)
    built: list[str] = []
    for _, source_name, library_name in REFERENCE_SPECS:
        source = numeric_root / source_name
        if not source.is_file():
            raise PreparationError(f"missing numeric reference source: {source}")
        destination = output_root / library_name
        temporary = output_root / f".{library_name}.build-{os.getpid()}"
        try:
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
            process = subprocess.run(command, text=True, capture_output=True)
            if process.returncode:
                detail = process.stderr.strip() or process.stdout.strip()
                raise PreparationError(f"reference build failed for {source_name}: {detail}")
            if not temporary.is_file():
                raise PreparationError(f"reference compiler produced no library: {temporary}")
            payload = temporary.read_bytes()
            _atomic_install(destination, payload, mode=stat.S_IMODE(temporary.stat().st_mode))
            built.append(str(destination.relative_to(artifact_root)))
        finally:
            try:
                temporary.unlink()
            except FileNotFoundError:
                pass
    return built


def _install_numeric_shim(artifact_root: Path) -> str:
    destination = artifact_root / ".work/selected-native-numeric-gate/run_input0_numeric.py"
    _atomic_install(destination, SHIM, mode=0o755)
    return str(destination.relative_to(artifact_root))


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser()
    parser.add_argument("--artifact-root", type=Path, default=ROOT)
    parser.add_argument("--template-root", type=Path)
    parser.add_argument("--source-root", type=Path)
    parser.add_argument("--build-root", type=Path)
    parser.add_argument("--llvm-build", type=Path)
    parser.add_argument("--llvm-source", type=Path)
    parser.add_argument("--amoeba-test-root", type=Path)
    parser.add_argument("--cxx", default=os.environ.get("CXX"))
    parser.add_argument("--prepare-only", action="store_true")
    parser.add_argument("--skip-reference-build", action="store_true")
    return parser


def _resolved(value: Path | None, env_name: str, fallback: Path, *, root: Path) -> Path:
    selected = value or os.environ.get(env_name) or fallback
    selected_path = Path(selected)
    return (selected_path if selected_path.is_absolute() else root / selected_path).resolve()


def main(argv: Sequence[str] | None = None) -> int:
    args = _parser().parse_args(argv)
    artifact_root = args.artifact_root.resolve()
    template_root = (args.template_root or artifact_root / "reference/input0-neighborhood/templates").resolve()
    source_root = _resolved(args.source_root, "ORBIT_SRC", artifact_root / ".work/neura-facts-host-worker", root=artifact_root)
    build_root = _resolved(args.build_root, "ORBIT_BUILD", artifact_root / ".work/neura-facts-host-build", root=artifact_root)
    llvm_build = _resolved(args.llvm_build, "ORBIT_LLVM_BUILD", artifact_root / ".work/llvm-build", root=artifact_root)
    llvm_source = _resolved(args.llvm_source, "ORBIT_LLVM_SOURCE", llvm_build.parent, root=artifact_root)
    amoeba_test_root = _resolved(args.amoeba_test_root, "AMOEBA_TEST_ROOT", artifact_root / "reference/input0-neighborhood/reference-source", root=artifact_root)
    values = {
        "${ARTIFACT_ROOT}": str(artifact_root),
        "${ORBIT_SRC}": str(source_root),
        "${ORBIT_BUILD}": str(build_root),
        "${LLVM_BUILD}": str(llvm_build),
        "${LLVM_SOURCE}": str(llvm_source),
        "${AMOEBA_TEST_ROOT}": str(amoeba_test_root),
    }
    installed_all = _install_templates(template_root, artifact_root, values)
    manifest = _bundle_manifest(template_root)
    if manifest is None:
        installed = installed_all
        installed_metadata: list[str] = []
    else:
        payload_paths, metadata_paths = manifest
        installed = [relative for relative in installed_all if relative in payload_paths]
        installed_metadata = [relative for relative in installed_all if relative in metadata_paths]
    payload_bytes = sum((artifact_root / relative).stat().st_size for relative in installed)
    metadata_bytes = sum((artifact_root / relative).stat().st_size for relative in installed_metadata)
    _verify_model_cache(artifact_root)
    (artifact_root / ".work/input0-task-mapping-cache").mkdir(parents=True, exist_ok=True)
    shim = _install_numeric_shim(artifact_root)
    libraries: list[str] = []
    if not args.prepare_only and not args.skip_reference_build:
        # Prefer the system GNU compiler for the default fixture build.  The
        # reference kernels use signed 32-bit arithmetic, so matching the
        # published host fixture matters.  An explicit ``--cxx``/``CXX``
        # value still has full precedence for reproducibility.
        compiler = args.cxx or shutil.which("g++") or shutil.which("clang++")
        if not compiler:
            raise PreparationError("no g++ or clang++ compiler found; use --skip-reference-build")
        libraries = _build_reference_libraries(artifact_root, amoeba_test_root, compiler)
    report = {
        "schema": "orbit-input0-neighborhood-portability-preparation-v1",
        "artifact_root": str(artifact_root),
        "template_root": str(template_root),
        "installed": installed,
        "installed_metadata": installed_metadata,
        "template_file_count": len(installed),
        "metadata_file_count": len(installed_metadata),
        "template_bytes": payload_bytes,
        "metadata_bytes": metadata_bytes,
        "numeric_shim": shim,
        "reference_libraries": libraries,
        "model_payloads_verified": True,
        "model_cache_verified": (artifact_root / ".work/input0-task-ml-cache.json").is_file(),
        "reference_build_skipped": bool(args.prepare_only or args.skip_reference_build),
    }
    print(json.dumps(report, indent=2))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except PreparationError as error:
        print(f"prepare_input0_neighborhood_reproduction.py: {error}", file=sys.stderr)
        raise SystemExit(1)
    except KeyboardInterrupt:
        raise SystemExit(130)
