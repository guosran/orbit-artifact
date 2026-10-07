#!/usr/bin/env python3
"""Losslessly archive completed comparison evidence; never touch a live cell."""
from __future__ import annotations

import argparse
import gzip
import hashlib
import json
import os
from pathlib import Path
import tempfile
import tarfile
import time
import zlib

import neighborhood_replay as replay
import run_sequential_comparison as comparison


JOURNAL_NAMES = (
    "search/action-attempts.jsonl",
    "search/budget-trace.jsonl",
    "search/action-frontiers.jsonl",
    "search/cross-phase-dedup-promotions.jsonl",
)
JOURNAL_MANIFEST = "journal-gzip-manifest.json"
JOURNAL_SCHEMA = "orbit-search-journal-gzip-v1"


def digest(stream):
    h = hashlib.sha256()
    for block in iter(lambda: stream.read(1024 * 1024), b""):
        h.update(block)
    return h.hexdigest()


def _sha_bytes(payload):
    return hashlib.sha256(payload).hexdigest()


def _cell_and_paths(path):
    path = Path(path)
    if path.name.endswith(".jsonl.gz"):
        raw = path.with_suffix("")
        compressed = path
    else:
        raw = path
        compressed = Path(str(path) + ".gz")
    cell = raw.parent.parent
    try:
        member = raw.relative_to(cell).as_posix()
    except ValueError as error:
        raise ValueError(f"journal path is not inside a search cell: {path}") from error
    if member not in JOURNAL_NAMES:
        raise ValueError(f"not a compactable search journal: {path}")
    return cell, raw, compressed, member


def _journal_manifest_row(cell, member):
    manifest_path = cell / JOURNAL_MANIFEST
    if not manifest_path.is_file():
        return None
    manifest = comparison.read(manifest_path)
    if manifest.get("schema") != JOURNAL_SCHEMA:
        raise ValueError(f"unknown journal gzip manifest schema: {manifest_path}")
    rows = [row for row in manifest.get("files", []) if row.get("path") == member]
    if len(rows) != 1:
        raise ValueError(f"journal manifest must contain exactly one row for {member}: {manifest_path}")
    row = rows[0]
    compressed_member = member + ".gz"
    if row.get("compressed_path") != compressed_member:
        raise ValueError(f"journal manifest gzip path mismatch for {member}: {manifest_path}")
    if (not isinstance(row.get("raw_size"), int) or row["raw_size"] < 0 or
            not isinstance(row.get("compressed_size"), int) or row["compressed_size"] < 0 or
            not isinstance(row.get("raw_sha256"), str) or len(row["raw_sha256"]) != 64 or
            not isinstance(row.get("compressed_sha256"), str) or len(row["compressed_sha256"]) != 64):
        raise ValueError(f"journal manifest has invalid size or SHA-256 fields: {manifest_path}")
    return row


def _verify_raw(payload, row, path):
    if len(payload) != row.get("raw_size") or _sha_bytes(payload) != row.get("raw_sha256"):
        raise ValueError(f"journal raw byte binding mismatch: {path}")


def _verify_compressed(payload, row, path):
    if (len(payload) != row.get("compressed_size") or
            _sha_bytes(payload) != row.get("compressed_sha256")):
        raise ValueError(f"journal gzip byte binding mismatch: {path}")


def read_journal_bytes(path):
    """Read exact journal bytes, preferring raw and validating the manifest binding."""
    cell, raw, compressed, member = _cell_and_paths(path)
    row = _journal_manifest_row(cell, member)
    if raw.is_file():
        payload = raw.read_bytes()
        if row is not None:
            _verify_raw(payload, row, raw)
        return payload
    if not compressed.is_file():
        raise FileNotFoundError(raw)
    if row is None:
        raise ValueError(f"journal gzip has no byte-binding manifest: {compressed}")
    packed = compressed.read_bytes()
    _verify_compressed(packed, row, compressed)
    try:
        payload = gzip.decompress(packed)
    except (OSError, EOFError, zlib.error) as error:
        raise ValueError(f"invalid journal gzip stream: {compressed}") from error
    _verify_raw(payload, row, raw)
    return payload


def read_journal(path):
    """Read JSONL records from raw or gzip storage with exact-byte validation."""
    payload = read_journal_bytes(path)
    return [json.loads(line) for line in payload.decode("utf-8").splitlines() if line.strip()]


def existing_journal_path(path):
    """Return the stored raw/gzip path, preserving raw-first read semantics."""
    _, raw, compressed, _ = _cell_and_paths(path)
    if raw.is_file():
        return raw
    if compressed.is_file():
        return compressed
    return raw


def _validate_existing_journal_manifest(cell):
    manifest_path = cell / JOURNAL_MANIFEST
    manifest = comparison.read(manifest_path)
    if manifest.get("schema") != JOURNAL_SCHEMA:
        raise ValueError(f"unknown journal gzip manifest schema: {manifest_path}")
    members = set()
    for row in manifest.get("files", []):
        member = row.get("path")
        if member not in JOURNAL_NAMES or member in members:
            raise ValueError(f"invalid or duplicate journal manifest member: {manifest_path}")
        _journal_manifest_row(cell, member)
        members.add(member)
        _, raw, compressed, _ = _cell_and_paths(cell / member)
        raw_exists, compressed_exists = raw.is_file(), compressed.is_file()
        if not raw_exists and not compressed_exists:
            raise ValueError(f"journal missing in both raw and gzip form: {raw}")
        if raw_exists:
            _verify_raw(raw.read_bytes(), row, raw)
        if compressed_exists:
            packed = compressed.read_bytes()
            _verify_compressed(packed, row, compressed)
            try:
                unpacked = gzip.decompress(packed)
            except (OSError, EOFError, zlib.error) as error:
                raise ValueError(f"invalid journal gzip stream: {compressed}") from error
            _verify_raw(unpacked, row, raw)
            if raw_exists and raw.read_bytes() != unpacked:
                raise ValueError(f"restored journal differs from gzip bytes: {raw}")
    return manifest


def _exclusive_json(path, value):
    """Create a manifest without replacing any prior evidence."""
    payload = (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()
    descriptor, temporary_name = tempfile.mkstemp(
        prefix=path.name + ".partial.", dir=path.parent)
    temporary = Path(temporary_name)
    try:
        with os.fdopen(descriptor, "wb") as output:
            output.write(payload)
            output.flush()
            os.fsync(output.fileno())
        os.link(temporary, path)
    finally:
        temporary.unlink(missing_ok=True)


def _compress_journals(cell):
    manifest_path = cell / JOURNAL_MANIFEST
    if manifest_path.exists():
        # Idempotent watcher calls validate existing evidence but never delete
        # a restored raw journal or rewrite the manifest.
        _validate_existing_journal_manifest(cell)
        return None

    raw_paths = []
    for member in JOURNAL_NAMES:
        _, raw, compressed, _ = _cell_and_paths(cell / member)
        if compressed.exists():
            raise FileExistsError(f"refusing to overwrite unmanifested journal gzip: {compressed}")
        if raw.is_file():
            try:
                raw.resolve().relative_to(cell.resolve())
            except ValueError as error:
                raise ValueError(f"journal path escapes its cell: {raw}") from error
            raw_paths.append((member, raw, compressed))
    if not raw_paths:
        return None

    started = time.monotonic()
    rows = []
    temporary_paths = []
    published_paths = []
    try:
        for member, raw, compressed in raw_paths:
            original = raw.read_bytes()
            fd, temporary_name = tempfile.mkstemp(
                prefix=compressed.name + ".partial.", dir=compressed.parent)
            temporary = Path(temporary_name)
            temporary_paths.append(temporary)
            with os.fdopen(fd, "wb") as output:
                with gzip.GzipFile(filename="", mode="wb", fileobj=output, mtime=0, compresslevel=6) as stream:
                    stream.write(original)
                output.flush()
                os.fsync(output.fileno())
            packed = temporary.read_bytes()
            unpacked = gzip.decompress(packed)
            if unpacked != original:
                raise ValueError(f"journal gzip round-trip mismatch: {raw}")
            row = {
                "path": member,
                "raw_size": len(original),
                "raw_sha256": _sha_bytes(original),
                "compressed_path": str(compressed.relative_to(cell)).replace(os.sep, "/"),
                "compressed_size": len(packed),
                "compressed_sha256": _sha_bytes(packed),
            }
            rows.append(row)

        manifest = {
            "schema": JOURNAL_SCHEMA,
            "files": rows,
            "original_bytes": sum(row["raw_size"] for row in rows),
            "compressed_bytes": sum(row["compressed_size"] for row in rows),
            "elapsed_seconds": time.monotonic() - started,
            "policy": (
                "only after all seven validation gates or explicit process-exit plus interruption audit; "
                "gzip mtime=0; exact raw and gzip SHA-256/size verified before manifest; "
                "plain journals removed only after manifest creation and re-verification; "
                "never applied to live cells"
            ),
        }

        # Hard-link publication is atomic and refuses to replace existing files.
        for (_, _, compressed), temporary in zip(raw_paths, temporary_paths):
            os.link(temporary, compressed)
            published_paths.append(compressed)
        _exclusive_json(manifest_path, manifest)
        _validate_existing_journal_manifest(cell)

        # Recheck the raw source immediately before unlink. A restored raw file
        # from a prior invocation is handled by the manifest path above and is
        # intentionally retained.
        for (_, raw, _), row in zip(raw_paths, rows):
            _verify_raw(raw.read_bytes(), row, raw)
        for _, raw, _ in raw_paths:
            raw.unlink()
        return manifest
    except Exception:
        # Preserve all plain sources. Remove only gzip paths this invocation
        # published if it failed before durable manifest creation.
        if not manifest_path.exists():
            for path in published_paths:
                path.unlink(missing_ok=True)
        raise
    finally:
        for path in temporary_paths:
            path.unlink(missing_ok=True)


def _create_auxiliary_archive(cell):
    archive = cell / "raw-auxiliary.tar.gz"
    manifest_path = cell / "raw-auxiliary-manifest.json"
    if archive.exists() or manifest_path.exists():
        if not archive.is_file() or not manifest_path.is_file():
            raise ValueError(f"auxiliary archive and manifest must both exist: {cell}")
        manifest = comparison.read(manifest_path)
        if manifest.get("schema") != "orbit-lossless-auxiliary-archive-v1":
            raise ValueError(f"unknown auxiliary archive manifest schema: {manifest_path}")
        return None, manifest

    started = time.monotonic()
    search = cell / "search"
    files = list(search.glob("costs-*.json"))
    files += [p for directory in ("spaces", "witnesses")
              for p in (search / directory).rglob("*") if p.is_file()]
    files += [p for name in ("archive.journal.jsonl", "archive.jsonl")
              if (p := search / name).is_file()]
    records = []
    for path in sorted(files):
        with path.open("rb") as stream:
            records.append({"path": str(path.relative_to(cell)), "size": path.stat().st_size,
                            "sha256": digest(stream)})
    partial = archive.with_suffix(".partial")
    if partial.exists():
        raise FileExistsError(f"refusing to overwrite partial auxiliary archive: {partial}")
    with tarfile.open(partial, "w:gz", compresslevel=3, dereference=True) as tar:
        for row in records:
            tar.add(cell / row["path"], arcname=row["path"], recursive=False)
    with tarfile.open(partial, "r:gz") as tar:
        for row in records:
            with tar.extractfile(row["path"]) as stream:
                if digest(stream) != row["sha256"]:
                    partial.unlink(missing_ok=True)
                    raise ValueError(f"archive content mismatch: {row['path']}")
    partial.replace(archive)
    manifest = {
        "schema": "orbit-lossless-auxiliary-archive-v1",
        "files": records,
        "original_bytes": sum(row["size"] for row in records),
        "archive_bytes": archive.stat().st_size,
        "elapsed_seconds": time.monotonic() - started,
        "policy": "after validated completion or explicit process-exit interruption audit; preserves exact bytes",
    }
    try:
        _exclusive_json(manifest_path, manifest)
    except Exception:
        archive.unlink(missing_ok=True)
        raise
    for row in records:
        (cell / row["path"]).unlink()
    return manifest, manifest


def _eligible(cell, allow_interrupted):
    if comparison.complete(cell):
        return True
    if not allow_interrupted:
        return False
    audit_path = cell / "interruption-audit.json"
    execution_path = cell / "execution.json"
    if not audit_path.is_file() or not execution_path.is_file():
        return False
    audit = comparison.read(audit_path)
    execution = comparison.read(execution_path)
    # execution.json is written by the coordinator only after wait()/join has
    # collected the compiler process exit status. The audit carries durable
    # lower/upper objective bounds for a forcibly stopped search.
    exited = (isinstance(execution.get("exit_code"), int) or
              (execution.get("process_exit_observed") is True and
               execution.get("cell_exit_code_not_retained") is True))
    return (exited and
            isinstance(audit.get("actual_objective_evaluations_lower_bound"), int) and
            isinstance(audit.get("actual_objective_evaluations_upper_bound"), int) and
            audit["actual_objective_evaluations_lower_bound"] <=
            audit["actual_objective_evaluations_upper_bound"])


def compact(cell, allow_interrupted=False):
    """Compact one proven-dead cell; return watcher-compatible work totals."""
    cell = Path(cell)
    if not _eligible(cell, allow_interrupted):
        return None
    started = time.monotonic()

    auxiliary_new, auxiliary = _create_auxiliary_archive(cell)
    journal_new = _compress_journals(cell)
    if auxiliary_new is None and journal_new is None:
        return None

    journal_original = journal_new["original_bytes"] if journal_new else 0
    journal_compressed = journal_new["compressed_bytes"] if journal_new else 0
    return {
        "original_bytes": auxiliary.get("original_bytes", 0) + journal_original,
        "archive_bytes": (cell / "raw-auxiliary.tar.gz").stat().st_size + journal_compressed,
        "elapsed_seconds": time.monotonic() - started,
        "auxiliary_manifest": str(cell / "raw-auxiliary-manifest.json"),
        "journal_manifest": str(cell / JOURNAL_MANIFEST) if journal_new else None,
    }


def _restore_journals(cell):
    manifest_path = cell / JOURNAL_MANIFEST
    if not manifest_path.is_file():
        return 0
    manifest = _validate_existing_journal_manifest(cell)
    restored = 0
    for row in manifest["files"]:
        _, raw, _, _ = _cell_and_paths(cell / row["path"])
        if raw.is_file():
            continue
        payload = read_journal_bytes(raw)
        raw.parent.mkdir(parents=True, exist_ok=True)
        partial = raw.with_name(raw.name + ".restore-partial")
        if partial.exists():
            raise FileExistsError(f"refusing to overwrite journal restore temporary: {partial}")
        with partial.open("xb") as output:
            output.write(payload)
            output.flush()
            os.fsync(output.fileno())
        _verify_raw(partial.read_bytes(), row, raw)
        partial.replace(raw)
        restored += 1
    return restored


def restore(cell):
    cell = Path(cell).resolve()
    if (cell / JOURNAL_MANIFEST).is_file():
        _validate_existing_journal_manifest(cell)
    manifest = comparison.read(cell / "raw-auxiliary-manifest.json")
    with tarfile.open(cell / "raw-auxiliary.tar.gz", "r:gz") as tar:
        for row in manifest["files"]:
            path = (cell / row["path"]).resolve()
            try:
                path.relative_to(cell)
            except ValueError:
                raise ValueError("archive path escapes cell")
            if path.exists():
                with path.open("rb") as stream:
                    if digest(stream) != row["sha256"]:
                        raise ValueError(f"existing bytes differ: {path}")
                continue
            path.parent.mkdir(parents=True, exist_ok=True)
            partial = path.with_suffix(path.suffix + ".partial")
            if partial.exists():
                raise FileExistsError(f"refusing to overwrite restore temporary: {partial}")
            with tar.extractfile(row["path"]) as source, partial.open("xb") as dest:
                for block in iter(lambda: source.read(1024 * 1024), b""):
                    dest.write(block)
            with partial.open("rb") as stream:
                if digest(stream) != row["sha256"]:
                    raise ValueError(f"restore mismatch: {path}")
            partial.replace(path)
    restored_journals = _restore_journals(cell)
    print(f"restored {len(manifest['files'])} exact-byte auxiliary files and "
          f"{restored_journals} exact-byte journals in {cell}")


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--results-root", type=Path)
    p.add_argument("--restore-cell", type=Path)
    p.add_argument("--compact-interrupted-provisional", action="store_true",
                   help="Requires a process-exit record and interruption audit; never reused as a completed primary cell")
    a = p.parse_args()
    if a.restore_cell:
        restore(a.restore_cell.resolve())
        return
    if not a.results_root:
        p.error("--results-root or --restore-cell is required")
    for cell in sorted(a.results_root.resolve().glob("*/*")):
        if not cell.is_dir():
            continue
        result = compact(cell, allow_interrupted=a.compact_interrupted_provisional)
        if result:
            print(json.dumps({"cell": str(cell), **{k: result[k] for k in
                  ("original_bytes", "archive_bytes", "elapsed_seconds")}}), flush=True)


if __name__ == "__main__":
    main()
