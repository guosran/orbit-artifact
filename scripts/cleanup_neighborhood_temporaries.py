#!/usr/bin/env python3
"""Remove unreferenced ORBIT neighborhood search spill after C++ search.

The cleanup boundary is deliberately after a successful C++ process and after
the source-owned shortlist and control rows have been written.  Replay inputs
named by those rows, graph manifests, checkpoints, final results, and files
outside the stage's ``search`` directory are retained.
"""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import re
from typing import Any, Iterable, Mapping


ROOT = Path(__file__).resolve().parents[1]
RECEIPT_SCHEMA = "orbit-neighborhood-temporary-cleanup-v1"
TOP5_NAMES = ("global-top5.jsonl", "top5.jsonl", "native-top5.jsonl")
PROTECTED_SEARCH_FILES = {
    *TOP5_NAMES,
    "controls.jsonl",
    "graph-manifests.json",
    "search-output.mlir",
}
_COST_FILE = re.compile(r"^costs-.+\.json$")
_ARCHIVE_FILE = re.compile(r"^archive.*\.jsonl(?:\.gz)?$")


class CleanupRefused(RuntimeError):
    """Cleanup cannot prove that deleting auxiliary spill is safe."""


def _atomic_write(path: Path, value: Mapping[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + ".partial")
    temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n",
                         encoding="utf-8")
    temporary.replace(path)


def _read_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise CleanupRefused(f"{path} must contain a JSON object")
    return value


def _read_jsonl(path: Path) -> list[dict[str, Any]]:
    try:
        lines = path.read_text(encoding="utf-8").splitlines()
    except OSError as error:
        raise CleanupRefused(f"cannot read {path}: {error}") from error
    records: list[dict[str, Any]] = []
    for number, line in enumerate(lines, 1):
        if not line.strip():
            continue
        try:
            value = json.loads(line)
        except json.JSONDecodeError as error:
            raise CleanupRefused(f"{path}:{number}: invalid JSON: {error}") from error
        if not isinstance(value, dict):
            raise CleanupRefused(f"{path}:{number}: expected a JSON object")
        records.append(value)
    return records


def _successful_search(stage_dir: Path) -> tuple[dict[str, Any], dict[str, Any]]:
    command_path = stage_dir / "search.command.json"
    result_path = stage_dir / "search-result.json"
    if command_path.is_symlink() or result_path.is_symlink():
        raise CleanupRefused("search command/result marker is a symlink")
    if not command_path.is_file() or not result_path.is_file():
        raise CleanupRefused("search has no durable finished command and result records")
    command = _read_json(command_path)
    result = _read_json(result_path)
    if command.get("status") != "finished" or command.get("exit_code") != 0:
        raise CleanupRefused("C++ search command is still running or did not exit successfully")
    if result.get("status") != "finished" or result.get("exit_code") != 0:
        raise CleanupRefused("C++ search result does not confirm successful completion")
    return command, result


def _reference_strings(value: Any) -> Iterable[str]:
    """Yield path-valued fields from selection/control rows recursively."""
    if isinstance(value, Mapping):
        for key, child in value.items():
            key_text = str(key).lower()
            is_path_field = (key_text in {"path", "paths", "manifest"} or
                             key_text.endswith(("_path", "_paths", "_file", "_files", "_manifest")) or
                             "manifest_file" in key_text)
            if is_path_field:
                if isinstance(child, str) and child:
                    yield child
                elif isinstance(child, (list, tuple)):
                    for item in child:
                        if isinstance(item, str) and item:
                            yield item
            yield from _reference_strings(child)
    elif isinstance(value, (list, tuple)):
        for child in value:
            yield from _reference_strings(child)


def _resolve_reference(raw_path: str, search_dir: Path, stage_dir: Path) -> Path | None:
    path = Path(raw_path).expanduser()
    if path.is_absolute():
        candidates = [path]
    else:
        candidates = [ROOT / path, stage_dir / path, search_dir / path]
    for candidate in candidates:
        try:
            if candidate.exists() or candidate.is_symlink():
                return candidate.resolve(strict=False)
        except OSError:
            continue
    return None


def _first_path(row: Mapping[str, Any], keys: tuple[str, ...]) -> str | None:
    for key in keys:
        value = row.get(key)
        if isinstance(value, str) and value:
            return value
        if isinstance(value, (list, tuple)):
            first = next((item for item in value if isinstance(item, str) and item), None)
            if first:
                return first
    return None


def _validate_replay_inputs(rows: Iterable[Mapping[str, Any]],
                            search_dir: Path, stage_dir: Path) -> None:
    groups = (
        ("candidate_path", "mapper_replay_path", "mapper_replay_paths"),
        ("score_file_path", "score_file", "score_file_paths"),
        ("shape_manifest_file", "candidate_manifest", "shape_manifest_paths"),
    )
    for row in rows:
        for group in groups:
            raw_path = _first_path(row, group)
            if raw_path is None:
                raise CleanupRefused(f"{row.get('candidate_id', row.get('control_role', 'row'))} lacks {group[0]}")
            resolved = _resolve_reference(raw_path, search_dir, stage_dir)
            if resolved is None or not resolved.is_file():
                raise CleanupRefused(f"replay input is missing: {raw_path}")


def _inside(path: Path, root: Path) -> bool:
    try:
        path.relative_to(root)
        return True
    except ValueError:
        return False


def _target_category(path: Path, search_dir: Path) -> str | None:
    relative = path.relative_to(search_dir)
    if any(part in {"spaces", "witnesses"} for part in relative.parts[:-1]):
        return "space-or-witness-tree"
    if len(relative.parts) >= 2 and relative.parts[0] == "candidates" and path.suffix == ".mlir":
        return "unselected-candidate-module"
    if len(relative.parts) >= 2 and relative.parts[0] == "replay":
        if path.name.endswith("-score.jsonl"):
            return "unselected-score-record"
        if path.name.endswith("-shape.json"):
            return "unselected-shape-manifest"
    if _COST_FILE.match(path.name):
        return "cost-catalogue-spill"
    if _ARCHIVE_FILE.match(path.name):
        return "search-archive-spill"
    return None


def _walk_regular_files(root: Path) -> Iterable[Path]:
    """Walk without following symlinks, yielding regular files only."""
    try:
        with os.scandir(root) as scan:
            entries = sorted(scan, key=lambda entry: entry.name)
    except OSError:
        return
    for entry in entries:
        path = Path(entry.path)
        try:
            if entry.is_symlink():
                continue
            if entry.is_dir(follow_symlinks=False):
                yield from _walk_regular_files(path)
            elif entry.is_file(follow_symlinks=False):
                yield path
        except OSError:
            continue


def _walk_symlinks(root: Path) -> Iterable[Path]:
    """Find symlinks without opening their targets."""
    try:
        with os.scandir(root) as scan:
            entries = sorted(scan, key=lambda entry: entry.name)
    except OSError:
        return
    for entry in entries:
        path = Path(entry.path)
        try:
            if entry.is_symlink():
                yield path
            elif entry.is_dir(follow_symlinks=False):
                yield from _walk_symlinks(path)
        except OSError:
            continue


def _write_receipt(stage_dir: Path, receipt: dict[str, Any]) -> dict[str, Any]:
    if stage_dir.is_symlink():
        receipt["receipt"] = None
        receipt["receipt_error"] = "stage directory is a symlink; receipt was not written"
        return receipt
    timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ")
    receipt_path = stage_dir / f"temporary-cleanup-receipt-{timestamp}-{os.getpid()}.json"
    receipt["receipt"] = str(receipt_path)
    receipt["latest_receipt"] = str(stage_dir / "temporary-cleanup-receipt.json")
    _atomic_write(receipt_path, receipt)
    _atomic_write(stage_dir / "temporary-cleanup-receipt.json", receipt)
    return receipt


def cleanup_search_temporaries(stage_dir: Path, *, enabled: bool = True) -> dict[str, Any]:
    """Delete only known, unreferenced C++ spill and persist a receipt.

    The function refuses the entire operation unless C++ completion and both
    replay ledgers can be validated.  It never follows or removes symlinks.
    """
    stage_dir = Path(stage_dir).absolute()
    search_dir = stage_dir / "search"
    receipt: dict[str, Any] = {
        "schema": RECEIPT_SCHEMA,
        "phase": "post-search-pre-native-replay",
        "stage_dir": str(stage_dir),
        "search_dir": str(search_dir),
        "status": "disabled" if not enabled else "pending",
        "deleted": [],
        "retained": [],
        "skipped": [],
        "deleted_count": 0,
        "deleted_bytes": 0,
        "created_utc": datetime.now(timezone.utc).isoformat(),
    }
    if not enabled:
        return _write_receipt(stage_dir, receipt)

    try:
        if stage_dir.is_symlink() or search_dir.is_symlink():
            raise CleanupRefused("stage or search directory is a symlink")
        if not stage_dir.is_dir() or not search_dir.is_dir():
            raise CleanupRefused("stage or search directory is missing")
        command, result = _successful_search(stage_dir)
        top5_path = next((search_dir / name for name in TOP5_NAMES
                          if (search_dir / name).is_file() and not (search_dir / name).is_symlink()), None)
        controls_path = search_dir / "controls.jsonl"
        if top5_path is None or controls_path.is_symlink() or not controls_path.is_file():
            raise CleanupRefused("C++ shortlist or controls ledger is missing")
        top5 = _read_jsonl(top5_path)
        controls = _read_jsonl(controls_path)
        selections = [row for row in top5 if row.get("record_type") == "selection"]
        headers = [row for row in top5 if row.get("record_type") == "header"]
        footers = [row for row in top5 if row.get("record_type") == "footer"]
        control_rows = [row for row in controls if row.get("record_type") == "control"]
        ranks = [row.get("rank") for row in selections]
        if len(selections) != 5 or set(ranks) != set(range(5)):
            raise CleanupRefused("shortlist does not contain exactly C++ ranks 0 through 4")
        if not headers or not footers or not control_rows:
            raise CleanupRefused("shortlist header/footer or control rows are incomplete")
        _validate_replay_inputs((*selections, *control_rows), search_dir, stage_dir)

        resolved_root = search_dir.resolve(strict=True)
        referenced: set[Path] = set()
        for row in (*selections, *control_rows):
            for raw_path in _reference_strings(row):
                resolved = _resolve_reference(raw_path, search_dir, stage_dir)
                if resolved is not None and _inside(resolved, resolved_root):
                    referenced.add(resolved)
        referenced.add(top5_path.resolve(strict=True))
        referenced.add(controls_path.resolve(strict=True))
        for name in PROTECTED_SEARCH_FILES:
            path = search_dir / name
            if path.exists() and not path.is_symlink():
                referenced.add(path.resolve(strict=True))

        planned: list[tuple[Path, str]] = []
        receipt["skipped"].extend({"path": str(path), "reason": "symlink-not-followed"}
                                  for path in _walk_symlinks(search_dir))
        for path in _walk_regular_files(search_dir):
            try:
                resolved = path.resolve(strict=True)
            except OSError:
                receipt["skipped"].append({"path": str(path), "reason": "cannot-resolve-safely"})
                continue
            category = _target_category(path, search_dir)
            if category is None:
                continue
            if _inside(resolved, resolved_root) and resolved in referenced:
                receipt["retained"].append({"path": str(path), "reason": "referenced-by-shortlist-or-control"})
                continue
            planned.append((path, category))

        for path, category in planned:
            try:
                size = path.lstat().st_size
                path.unlink()
                receipt["deleted"].append({"path": str(path), "category": category,
                                           "bytes": size})
                receipt["deleted_bytes"] += size
            except OSError as error:
                receipt["skipped"].append({"path": str(path), "reason": f"unlink-failed: {error}"})
        # Empty auxiliary directories can be removed after regular files have
        # been handled. Directory symlinks and directories with any surviving
        # entries are retained.
        for name in ("spaces", "witnesses"):
            directory = search_dir / name
            if directory.is_symlink() or not directory.is_dir():
                continue
            for current, dirs, files in os.walk(directory, topdown=False, followlinks=False):
                current_path = Path(current)
                try:
                    current_path.rmdir()
                except OSError:
                    pass
        receipt.update(status="cleaned" if receipt["deleted"] else "no-temporaries",
                       command_status=command.get("status"),
                       search_exit_code=result.get("exit_code"),
                       shortlist=str(top5_path), controls=str(controls_path),
                       retained_count=len(receipt["retained"]), skipped_count=len(receipt["skipped"]))
    except (CleanupRefused, OSError, ValueError, json.JSONDecodeError) as error:
        receipt.update(status="refused", reason=f"{type(error).__name__}: {error}")

    receipt["deleted_count"] = len(receipt["deleted"])
    receipt["retained_count"] = len(receipt["retained"])
    receipt["skipped_count"] = len(receipt["skipped"])
    return _write_receipt(stage_dir, receipt)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--stage-dir", type=Path, required=True,
                        help="stage directory containing search/ and successful search records")
    cleanup_group = parser.add_mutually_exclusive_group()
    cleanup_group.add_argument("--cleanup", dest="cleanup", action="store_true",
                               help="enable spill cleanup")
    cleanup_group.add_argument("--no-cleanup", dest="cleanup", action="store_false",
                               help="disable spill cleanup")
    parser.set_defaults(cleanup=True)
    args = parser.parse_args(argv)
    receipt = cleanup_search_temporaries(args.stage_dir, enabled=args.cleanup)
    print(json.dumps(receipt, sort_keys=True))
    return 0 if receipt.get("status") in {"cleaned", "no-temporaries", "disabled"} else 2


if __name__ == "__main__":
    raise SystemExit(main())
