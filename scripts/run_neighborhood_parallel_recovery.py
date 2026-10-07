#!/usr/bin/env python3
"""Recover one workload using the frozen chain's stage and replay interfaces.

Workers own disjoint workload directories. Their progress records are separate
from the serial coordinator's record; the latter can reconcile finished stages
on its next invocation. Search, candidate selection and costs remain in C++.
"""
from __future__ import annotations

import argparse
from dataclasses import replace
from datetime import datetime, timezone
import fcntl
import json
import os
from pathlib import Path
import sys

import run_neighborhood_stage_chain as chain


def _jsonl(path: Path) -> list[dict]:
    records = []
    for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        if not line.strip():
            continue
        try:
            value = json.loads(line)
        except json.JSONDecodeError as error:
            raise ValueError("{}:{}: {}".format(path, line_number, error)) from error
        if not isinstance(value, dict):
            raise ValueError("{}:{}: expected a JSON object".format(path, line_number))
        records.append(value)
    return records


def _completed_search_shortlist(stage_dir: Path) -> bool:
    """Recognize a replayable C++ ledger before deciding to restart search."""
    search_dir = stage_dir / "search"
    if search_dir.is_symlink() or not search_dir.is_dir():
        return False
    top5 = next((search_dir / name for name in
                 ("global-top5.jsonl", "top5.jsonl", "native-top5.jsonl")
                 if (search_dir / name).is_file() and not (search_dir / name).is_symlink()), None)
    controls = search_dir / "controls.jsonl"
    if top5 is None or controls.is_symlink() or not controls.is_file():
        return False
    try:
        rows = _jsonl(top5)
        control_rows = _jsonl(controls)
    except (OSError, ValueError):
        return False
    selections = [row for row in rows if row.get("record_type") == "selection"]
    ranks = [row.get("rank") for row in selections]
    roles = {row.get("control_role", row.get("role")) for row in control_rows
             if row.get("record_type") == "control"}
    return (any(row.get("record_type") == "header" for row in rows) and
            any(row.get("record_type") == "footer" for row in rows) and
            len(selections) == 5 and set(ranks) == set(range(5)) and
            bool(roles & {"identity", "canonical_identity"}))


def _running_stage_commands(stage_dir: Path) -> list[Path]:
    """Find active search/native command markers without following symlinks."""
    active = []
    pending = [stage_dir]
    while pending:
        current = pending.pop()
        try:
            with os.scandir(current) as scan:
                entries = sorted(scan, key=lambda item: item.name)
        except OSError as error:
            raise chain.ChainError("cannot safely inspect stage commands under {}: {}".format(
                current, error)) from error
        for entry in entries:
            path = Path(entry.path)
            try:
                if entry.is_symlink():
                    continue
                if entry.is_dir(follow_symlinks=False):
                    # These are immutable copies of earlier attempts, not
                    # command records owned by the current stage execution.
                    if entry.name.startswith(("before-recovery-", "search-restart-evidence-")):
                        continue
                    pending.append(path)
                elif entry.is_file(follow_symlinks=False) and entry.name.endswith(".command.json"):
                    try:
                        value = json.loads(path.read_text(encoding="utf-8"))
                    except (OSError, json.JSONDecodeError) as error:
                        raise chain.ChainError("cannot verify command state {}: {}".format(
                            path, error)) from error
                    if not isinstance(value, dict):
                        raise chain.ChainError("cannot verify command state {}: expected JSON object".format(path))
                    if value.get("status") in {"running", "starting"}:
                        active.append(path)
            except OSError as error:
                raise chain.ChainError("cannot safely inspect {}: {}".format(path, error)) from error
    return active


def _remove_incomplete_search_path(path: Path, removed: list[dict], errors: list[dict]) -> None:
    """Remove one incomplete search entry without following symlinks."""
    try:
        if path.is_symlink():
            size = path.lstat().st_size
            path.unlink()
            removed.append({"path": str(path), "kind": "symlink", "bytes": size})
        elif path.is_dir():
            with os.scandir(path) as scan:
                children = sorted((Path(entry.path) for entry in scan), key=lambda item: item.name)
            for child in children:
                _remove_incomplete_search_path(child, removed, errors)
            path.rmdir()
            removed.append({"path": str(path), "kind": "directory", "bytes": 0})
        elif path.is_file():
            size = path.lstat().st_size
            path.unlink()
            removed.append({"path": str(path), "kind": "file", "bytes": size})
        else:
            errors.append({"path": str(path), "reason": "unsupported-filesystem-entry"})
    except OSError as error:
        errors.append({"path": str(path), "reason": "remove-failed: {}".format(error)})


def _archive_restart_evidence(stage_dir: Path, evidence_dir: Path) -> tuple[list[str], list[dict]]:
    """Preserve fixed-name search diagnostics before a retry can overwrite them."""
    archived = []
    errors = []
    try:
        evidence_dir.mkdir(parents=True, exist_ok=False)
    except OSError as error:
        return archived, [{"path": str(evidence_dir), "reason": "create-failed: {}".format(error)}]

    # The next search uses these fixed log names. Move the old streams so the
    # retry starts with fresh logs while the old command/result records remain
    # interpretable in the archive.
    moved_logs = {}
    for name in ("search.stdout.log", "search.stderr.log"):
        source = stage_dir / name
        if source.is_symlink():
            errors.append({"path": str(source), "reason": "symlink-not-followed"})
            continue
        if not source.is_file():
            continue
        destination = evidence_dir / name
        try:
            os.replace(str(source), str(destination))
            moved_logs[name] = destination
            archived.append(str(destination))
        except OSError as error:
            errors.append({"path": str(source), "reason": "move-failed: {}".format(error)})

    marker_names = (
        "search.command.json", "search-result.json", "result.json",
        "chain-binding.json", "source-binding.json", "checkpoint.json.binding.json")
    for name in marker_names:
        source = stage_dir / name
        if source.is_symlink():
            errors.append({"path": str(source), "reason": "symlink-not-followed"})
            continue
        if not source.is_file():
            continue
        destination = evidence_dir / name
        try:
            contents = source.read_text(encoding="utf-8")
            if name in {"search.command.json", "search-result.json"}:
                try:
                    value = json.loads(contents)
                except json.JSONDecodeError:
                    value = None
                if isinstance(value, dict):
                    for field in ("stdout", "stderr"):
                        old_path = Path(str(value.get(field, "")))
                        moved = moved_logs.get(old_path.name)
                        if moved is not None:
                            value[field] = str(moved)
                    contents = json.dumps(value, indent=2, sort_keys=True) + "\n"
            destination.write_text(contents, encoding="utf-8")
            archived.append(str(destination))
        except OSError as error:
            errors.append({"path": str(source), "reason": "copy-failed: {}".format(error)})
    return archived, errors


def _clear_incomplete_search(stage_dir: Path) -> dict | None:
    """Restart only when there is neither a checkpoint nor a finished shortlist."""
    checkpoint = stage_dir / "checkpoint.json"
    search_dir = stage_dir / "search"
    if checkpoint.exists() or checkpoint.is_symlink() or _completed_search_shortlist(stage_dir):
        return None
    if search_dir.is_symlink():
        raise chain.ChainError("incomplete search directory is a symlink; refusing restart cleanup")
    if not search_dir.is_dir():
        return None
    try:
        entries = sorted(search_dir.iterdir(), key=lambda path: path.name)
    except OSError as error:
        raise chain.ChainError("cannot inspect incomplete search directory: {}".format(error)) from error
    if not entries:
        return None
    active = _running_stage_commands(stage_dir)
    if active:
        raise chain.ChainError("cannot restart incomplete search while stage commands are active: {}".format(
            ", ".join(str(path) for path in active)))

    timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ")
    evidence_dir = stage_dir / "search-restart-evidence-{}-{}".format(timestamp, os.getpid())
    archived, archive_errors = _archive_restart_evidence(stage_dir, evidence_dir)
    removed = []
    errors = []
    if not archive_errors:
        for path in entries:
            _remove_incomplete_search_path(path, removed, errors)
    else:
        errors.extend(archive_errors)
    receipt_path = stage_dir / "search-restart-receipt-{}-{}.json".format(timestamp, os.getpid())
    preserved = [stage_dir / name for name in (
        "search.command.json", "search-result.json", "chain-binding.json",
        "source-binding.json", "checkpoint.json.binding.json", "result.json")]
    receipt = {
        "schema": "orbit-neighborhood-search-restart-cleanup-v1",
        "status": "cleared" if not errors else "blocked" if archive_errors else "partial",
        "reason": "no checkpoint and no complete C++ shortlist/control ledger",
        "stage_dir": str(stage_dir.resolve()),
        "search_dir": str(search_dir),
        "archived_evidence_dir": str(evidence_dir),
        "archived_evidence": archived,
        "archive_errors": archive_errors,
        "removed": removed,
        "removed_count": len(removed),
        "removed_bytes": sum(item["bytes"] for item in removed),
        "errors": errors,
        "preserved_stage_evidence": [str(path) for path in preserved if path.exists()],
        "created_utc": datetime.now(timezone.utc).isoformat(),
    }
    receipt["receipt"] = str(receipt_path)
    receipt["latest_receipt"] = str(stage_dir / "search-restart-receipt.json")
    chain.atomic_write(receipt_path, receipt)
    chain.atomic_write(stage_dir / "search-restart-receipt.json", receipt)
    if errors:
        raise chain.ChainError("incomplete search cleanup was partial; see {}".format(receipt_path))
    return receipt


def run(command_file: Path, workload: str, jobs: int,
        cleanup_search_temporaries: bool = True) -> int:
    command = json.loads(command_file.read_text(encoding="utf-8"))
    if not isinstance(command, list):
        raise chain.ChainError("chain command must be a JSON argv array")
    index = next((i for i, arg in enumerate(command)
                  if Path(str(arg)).name == "run_neighborhood_stage_chain.py"), None)
    if index is None:
        raise chain.ChainError("frozen chain script missing from argv")
    original, config_path = chain._parse_args(command[index + 1:])
    stages = chain.stage_order(original)
    options = replace(original, jobs=jobs)
    chain._validate_options(options)
    if workload not in original.workloads:
        raise chain.ChainError("workload is outside the frozen batch")
    config = chain.load_config(config_path)
    config["config_base"] = str(config_path.parent.resolve())
    base = config_path.parent.resolve()
    manifest = chain._ensure_contract_snapshot(
        original.output_root, chain._contract_specs(config, original, config_base=base))
    chain.validate_stage_inputs(config, original, config_base=base)
    independent = original.stage_initialization == "independent"
    entry = chain._merged_workload(config, workload)
    progress = original.output_root / "parallel" / workload / "progress.json"
    state = {"schema": "orbit-neighborhood-parallel-recovery-v1",
             "workload": workload, "jobs": jobs, "status": "running",
             "contract_manifest": str(manifest), "stages": {},
             "started_utc": chain.now(), "subprocess_timeout": None,
             "stage_initialization": original.stage_initialization,
             "cleanup_search_temporaries": cleanup_search_temporaries}
    state["stage_order"] = list(stages)
    chain.atomic_write(progress, state)
    previous = None
    failed = False
    for stage in stages[stages.index(original.start_stage):]:
        if independent:
            previous = None
        directory = original.output_root / workload / stage
        directory.mkdir(parents=True, exist_ok=True)
        record = state["stages"].setdefault(stage, {})
        if failed and not independent:
            record.update(status="blocked", reason="earlier stage failed")
            chain.atomic_write(progress, state)
            continue
        try:
            expected = chain.expected_binding(entry, workload, stage, original,
                                              config_base=base, contract_manifest=manifest)
            binding = directory / "chain-binding.json"
            if binding.exists() and not chain._stage_binding_matches(binding, expected):
                raise chain.ChainError("stage binding differs from frozen batch")
            if not binding.exists() and any((directory / name).exists()
                                            for name in ("result.json", "checkpoint.json", "search")):
                raise chain.ChainError("existing stage lacks its binding")
            chain.atomic_write(binding, expected)
            complete, result = chain._stage_complete(directory, expected)
            if complete:
                try:
                    chain.choose_measured_winner(result)
                except chain.ChainError as error:
                    # Native mapping can finish while the numeric launcher
                    # fails to start. Keep the C++ search and mapper cache,
                    # but retry validation instead of treating the stage as
                    # reusable and failing forever at winner selection.
                    record["existing_validation_incomplete"] = str(error)
                    complete = False
            if not complete:
                active_commands = _running_stage_commands(directory) if directory.exists() else []
                if active_commands:
                    raise chain.ChainError("stage commands are still active: {}".format(
                        ", ".join(str(path) for path in active_commands)))
                search_done = _completed_search_shortlist(directory)
                restart_receipt = None
                if not search_done and not (directory / "checkpoint.json").exists():
                    restart_receipt = _clear_incomplete_search(directory)
                    if restart_receipt is not None:
                        record["search_restart_cleanup"] = restart_receipt
                        chain.atomic_write(progress, state)
                resume = (directory / "checkpoint.json").is_file() and not search_done
                argv = chain._build_replay_command(
                    workload=workload, stage=stage, entry=entry, options=options,
                    config_base=base, stage_dir=directory, previous_winner=previous,
                    resume=resume, skip_search=search_done)
                argv.append("--cleanup-search-temporaries" if cleanup_search_temporaries
                            else "--no-cleanup-search-temporaries")
                label = chain._next_label(directory, "replay-parallel")
                command_record = chain._run_logged(argv, directory, label)
                record["command"] = command_record
                if command_record.get("exit_code") != 0:
                    raise chain.ChainError("replay process failed; see recorded stderr")
                result = chain.read_json(directory / "result.json")
                if result.get("status") != "native_replayed":
                    raise chain.ChainError("required native replay evidence is incomplete")
            previous = chain.write_winner(directory, result)
            result = dict(result)
            result["winner_path"] = str(previous)
            chain.atomic_write(directory / "result.json", result)
            record.update(status="reused" if complete else "complete",
                          result=str(directory / "result.json"),
                          actual_stage_cycles=result.get("actual_stage_cycles"),
                          winner_path=str(previous))
        except (chain.ChainError, OSError, ValueError) as error:
            record.update(status="failed", reason=f"{type(error).__name__}: {error}")
            failed = True
        state["updated_utc"] = chain.now()
        chain.atomic_write(progress, state)
    state.update(status="incomplete" if failed else "complete", ended_utc=chain.now())
    chain.atomic_write(progress, state)
    return 2 if failed else 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--chain-command-file", type=Path, required=True)
    parser.add_argument("--workload", choices=chain.WORKLOADS, required=True)
    parser.add_argument("--jobs", type=int, default=4)
    cleanup_group = parser.add_mutually_exclusive_group()
    cleanup_group.add_argument("--cleanup-search-temporaries",
                               dest="cleanup_search_temporaries", action="store_true",
                               help="remove unreferenced C++ search spill after successful search")
    cleanup_group.add_argument("--no-cleanup-search-temporaries",
                               dest="cleanup_search_temporaries", action="store_false",
                               help="retain search spill files")
    parser.set_defaults(cleanup_search_temporaries=True)
    args = parser.parse_args()
    try:
        command = json.loads(args.chain_command_file.read_text(encoding="utf-8"))
        index = next((i for i, value in enumerate(command)
                      if Path(str(value)).name == "run_neighborhood_stage_chain.py"), None)
        if index is None:
            raise chain.ChainError("frozen chain script missing from argv")
        options, _ = chain._parse_args(command[index + 1:])
        lock_dir = options.output_root / "parallel" / args.workload
        lock_dir.mkdir(parents=True, exist_ok=True)
        with (lock_dir / "recovery.lock").open("a+") as lock:
            fcntl.flock(lock.fileno(), fcntl.LOCK_EX)
            return run(args.chain_command_file, args.workload, args.jobs,
                       cleanup_search_temporaries=args.cleanup_search_temporaries)
    except (chain.ChainError, OSError, ValueError) as error:
        print(f"parallel recovery failed: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
