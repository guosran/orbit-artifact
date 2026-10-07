#!/usr/bin/env python3
"""Relocate only write-once catalogues certified by a durable checkpoint."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import time


def sha(path):
    value = hashlib.sha256()
    with Path(path).open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            value.update(block)
    return value.hexdigest()


def relocate(cell, staging_root):
    cell, staging_root = Path(cell), Path(staging_root)
    checkpoint = cell / "checkpoint.json"
    if (not checkpoint.is_file() or (cell / "raw-auxiliary-manifest.json").exists()
            or (cell / "search/global-top5.jsonl").exists()):
        return 0
    started = time.monotonic()
    state = json.loads(checkpoint.read_text())
    search = cell / "search"
    target_dir = staging_root / cell.parent.name / cell.name
    target_dir.mkdir(parents=True, exist_ok=True)
    journal = cell / "catalogue-relocation.jsonl"
    count = 0
    for row in state.get("graph_cost_catalogues", []):
        if (cell / "search/global-top5.jsonl").exists():
            break
        path = Path(row["path"])
        # Preserve every source path string. Do not relocate the mutable
        # predictor cache, bootstrap, uncommitted catalogue or any MLIR.
        if (path.parent != search or not path.name.startswith("costs-graph-catalogue-")
                or path.suffix != ".json"):
            raise ValueError("checkpoint catalogue is outside its private search: " + str(path))
        if path.is_symlink() or not path.is_file():
            continue
        before = path.stat()
        target = target_dir / path.name
        temporary = target.with_name(target.name + ".copy-partial")
        link = path.with_name(path.name + ".spill-link")
        if target.exists() or temporary.exists() or link.exists():
            raise FileExistsError("refusing to replace existing relocation evidence: " + str(target))
        try:
            shutil.copyfile(path, temporary)
            with temporary.open("rb") as stream:
                os.fsync(stream.fileno())
            original_sha = sha(path)
            if sha(temporary) != original_sha:
                raise ValueError("catalogue relocation byte mismatch: " + str(path))
            after = path.stat()
            if (before.st_ino, before.st_size, before.st_mtime_ns) != (after.st_ino, after.st_size, after.st_mtime_ns):
                raise ValueError("certified write-once catalogue changed during relocation: " + str(path))
            os.link(temporary, target)
            # Durable relocation evidence precedes replacement of the raw file.
            record = {"source": str(path), "target": str(target), "sha256": original_sha,
                      "bytes": before.st_size, "checkpoint_mtime_ns": checkpoint.stat().st_mtime_ns,
                      "policy": "durable graph_cost_catalogues entry; write-once source; exact verified bytes; original path retained"}
            with journal.open("a") as output:
                output.write(json.dumps(record, sort_keys=True) + "\n")
                output.flush()
                os.fsync(output.fileno())
            link.symlink_to(target)
            os.replace(link, path)
            if sha(path) != original_sha:
                raise ValueError("relocated catalogue read-back mismatch: " + str(path))
            count += 1
        finally:
            temporary.unlink(missing_ok=True)
            link.unlink(missing_ok=True)
    if count:
        with (cell / "catalogue-relocation-overhead.jsonl").open("a") as output:
            output.write(json.dumps({"catalogues": count, "elapsed_seconds": time.monotonic() - started}) + "\n")
    return count


def cleanup_archived(cell):
    """Remove only our staged copies after the original bytes were archived."""
    cell = Path(cell)
    journal, manifest = cell / "catalogue-relocation.jsonl", cell / "raw-auxiliary-manifest.json"
    if not journal.is_file() or not manifest.is_file():
        return 0
    archived = {row["path"]: row for row in json.loads(manifest.read_text())["files"]}
    removed = 0
    for line in journal.read_text().splitlines():
        row = json.loads(line)
        source, target = Path(row["source"]), Path(row["target"])
        relative = str(source.relative_to(cell))
        entry = archived.get(relative)
        if source.exists() or entry is None or entry["sha256"] != row["sha256"]:
            raise ValueError("relocated file lacks completed exact archive evidence: " + str(source))
        if target.exists():
            if sha(target) != row["sha256"]:
                raise ValueError("staged catalogue changed: " + str(target))
            target.unlink()
            removed += 1
    return removed
