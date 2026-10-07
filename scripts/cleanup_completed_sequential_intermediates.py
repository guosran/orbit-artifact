#!/usr/bin/env python3
"""Remove redundant completed-run checkpoints after verified lossless compression."""
from __future__ import annotations

import argparse
import gzip
import hashlib
import json
import os
from pathlib import Path
import tempfile
import time

from sequential_validation_audit import require_complete_validation


NAMES = ("checkpoint.json", "checkpoint.json.binding.json")


def signature(path):
    state = path.stat()
    return state.st_dev, state.st_ino, state.st_size, state.st_mtime_ns


def digest(stream):
    value = hashlib.sha256()
    size = 0
    for block in iter(lambda: stream.read(1024 * 1024), b""):
        value.update(block)
        size += len(block)
    return size, value.hexdigest()


def compact_checkpoint(cell, apply=False):
    """Only completed seven-gate cells qualify; mutable or unbound files fail closed."""
    require_complete_validation(json.loads((cell / "result.json").read_text()))
    actions = []
    manifest = cell / "completed-checkpoint-cleanup.jsonl"
    for name in NAMES:
        source = cell / name
        if not source.exists():
            continue
        if source.is_symlink() or not source.is_file():
            raise ValueError(f"checkpoint must be a regular file: {source}")
        target = source.with_name(name + ".gz")
        if target.exists():
            raise FileExistsError(f"refusing to replace prior evidence: {target}")
        state = signature(source)
        if not apply:
            actions.append({"path": str(source), "raw_size": state[2], "action": "would-compress-and-unlink"})
            continue
        started = time.monotonic()
        descriptor, temporary_name = tempfile.mkstemp(prefix=name + ".gzip-partial-", dir=cell)
        temporary = Path(temporary_name)
        try:
            with source.open("rb") as incoming, os.fdopen(descriptor, "wb") as output:
                with gzip.GzipFile(filename="", fileobj=output, mode="wb", mtime=0, compresslevel=3) as packed:
                    for block in iter(lambda: incoming.read(1024 * 1024), b""):
                        packed.write(block)
                output.flush()
                os.fsync(output.fileno())
            with source.open("rb") as stream:
                raw = digest(stream)
            with gzip.open(temporary, "rb") as stream:
                restored = digest(stream)
            if restored != raw or signature(source) != state:
                raise ValueError(f"checkpoint changed or round-trip failed: {source}")
            with temporary.open("rb") as stream:
                compressed = digest(stream)
            os.link(temporary, target)
            row = {"schema": "orbit-completed-checkpoint-cleanup-v1", "path": name,
                "compressed_path": target.name, "raw_size": raw[0], "raw_sha256": raw[1],
                "compressed_size": compressed[0], "compressed_sha256": compressed[1],
                "freed_bytes": raw[0] - compressed[0], "time_unix": time.time(),
                "elapsed_seconds": time.monotonic() - started,
                "eligibility": "all seven native/numeric/mapper-equality/independent-trace gates passed",
                "policy": "retain final plans, traces, statistics, journals and cost archives; gzip round-trip verified; checkpoints are unnecessary for completed-run replay"}
            with manifest.open("a") as stream:
                stream.write(json.dumps(row, sort_keys=True) + "\n")
                stream.flush()
                os.fsync(stream.fileno())
            if signature(source) != state:
                raise ValueError(f"checkpoint changed before removal: {source}")
            require_complete_validation(json.loads((cell / "result.json").read_text()))
            source.unlink()
            actions.append(row)
        finally:
            temporary.unlink(missing_ok=True)
    return actions


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--results-root", type=Path, required=True)
    parser.add_argument("--apply", action="store_true", help="Default is a read-only size preview")
    args = parser.parse_args()
    totals = []
    for cell in sorted(args.results_root.resolve().glob("*/*")):
        if not (cell / "result.json").is_file():
            continue
        try:
            require_complete_validation(json.loads((cell / "result.json").read_text()))
        except (ValueError, OSError):
            continue
        actions = compact_checkpoint(cell, args.apply)
        totals.extend(actions)
        if actions:
            print(json.dumps({"cell": str(cell), "files": actions}), flush=True)
    print(json.dumps({"mode": "apply" if args.apply else "preview", "files": len(totals),
        "raw_bytes": sum(row["raw_size"] for row in totals),
        "freed_bytes": sum(row.get("freed_bytes", 0) for row in totals)}), flush=True)


if __name__ == "__main__":
    main()
