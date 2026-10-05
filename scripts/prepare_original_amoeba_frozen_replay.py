#!/usr/bin/env python3
"""Hydrate archived original-AMOEBA input/profile evidence for the native queue.

This utility copies only archived text evidence. It never invokes a compiler,
mapper, scheduler, retimer, or numeric runner. The resulting ``inputs.json``
points to the freshly hydrated input, mapper-profile, and caller-proof files
using paths relative to the selected artifact root.
"""

from __future__ import annotations

import argparse
import gzip
import json
import os
import sys
from pathlib import Path
from typing import Any


REPOSITORY_ROOT = Path(__file__).resolve().parents[1]
WORKLOADS = ("gcn", "harris", "llama", "lu", "radar")
SHAPES = ("1x1", "1x2", "2x1", "1x3", "3x1", "2x2", "1x4", "4x1")
MANIFEST_SCHEMA = "orbit-original-amoeba-frozen-evidence-manifest-v1"
ARCHIVE_SCHEMA = "orbit-original-amoeba-frozen-text-evidence-v1"
QUEUE_SCHEMA = "orbit-original-amoeba-current-profile-inputs-v1"


class PreparationError(ValueError):
    """Raised when frozen evidence cannot be safely hydrated."""


def _required_int(value: Any, label: str, minimum: int = 0) -> int:
    if type(value) is not int or value < minimum:
        raise PreparationError(f"{label} must be an integer >= {minimum}")
    return value


def _archive_key(value: Any, label: str) -> str:
    if (not isinstance(value, str) or not value or "\x00" in value
            or "\\" in value or value.startswith("/") or ":" in value.split("/", 1)[0]):
        raise PreparationError(f"{label} is not a safe relative archive path")
    parts = value.split("/")
    if any(part in ("", ".", "..") for part in parts):
        raise PreparationError(f"{label} contains an unsafe path component")
    return value


def _relative_to_root(path: Path, root: Path, label: str) -> str:
    try:
        return path.resolve().relative_to(root.resolve()).as_posix()
    except ValueError as error:
        raise PreparationError(f"{label} is outside the artifact root") from error


def _read_json(path: Path, label: str) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, json.JSONDecodeError) as error:
        raise PreparationError(f"cannot read {label}: {error}") from error
    if not isinstance(value, dict):
        raise PreparationError(f"{label} must contain a JSON object")
    return value


def _load_archive(bundle_root: Path) -> tuple[dict[str, Any], dict[str, str]]:
    manifest_path = bundle_root / "manifest.json"
    archive_path = bundle_root / "evidence.json.gz"
    if not manifest_path.is_file() or not archive_path.is_file():
        raise PreparationError("bundle-root must contain manifest.json and evidence.json.gz")
    manifest = _read_json(manifest_path, "frozen bundle manifest")
    if manifest.get("schema") != MANIFEST_SCHEMA:
        raise PreparationError("unsupported frozen evidence manifest schema")
    if (type(manifest.get("input_index")) is not int or manifest["input_index"] != 0
            or manifest.get("formal_go") is not False):
        raise PreparationError("frozen bundle manifest must bind input_index=0 and formal_go=false")
    if manifest.get("hashes_used") is not False:
        raise PreparationError("frozen bundle must state hashes_used=false")

    try:
        with gzip.open(archive_path, "rt", encoding="utf-8", newline="") as stream:
            archive = json.load(stream)
    except (OSError, UnicodeError, gzip.BadGzipFile, json.JSONDecodeError) as error:
        raise PreparationError(f"cannot read frozen gzip evidence: {error}") from error
    if not isinstance(archive, dict) or archive.get("schema") != ARCHIVE_SCHEMA:
        raise PreparationError("unsupported frozen text-evidence archive schema")
    if (type(archive.get("input_index")) is not int or archive["input_index"] != 0
            or archive.get("formal_go") is not False):
        raise PreparationError("frozen evidence archive must bind input_index=0 and formal_go=false")

    source_rows = manifest.get("source_files")
    if not isinstance(source_rows, list) or not source_rows:
        raise PreparationError("manifest source_files must be a nonempty array")
    declared_sizes: dict[str, int] = {}
    for index, row in enumerate(source_rows):
        if not isinstance(row, dict) or set(row) != {"path", "bytes"}:
            raise PreparationError(f"manifest source_files[{index}] must contain exactly path and bytes")
        key = _archive_key(row.get("path"), f"source_files[{index}].path")
        size = _required_int(row.get("bytes"), f"source_files[{index}].bytes")
        if key in declared_sizes:
            raise PreparationError(f"manifest repeats source path {key}")
        declared_sizes[key] = size

    archive_rows = archive.get("files")
    if not isinstance(archive_rows, list) or not archive_rows:
        raise PreparationError("archive files must be a nonempty array")
    texts: dict[str, str] = {}
    for index, row in enumerate(archive_rows):
        if not isinstance(row, dict) or set(row) != {"path", "text"}:
            raise PreparationError(f"archive files[{index}] must contain exactly path and text")
        key = _archive_key(row.get("path"), f"archive files[{index}].path")
        text = row.get("text")
        if not isinstance(text, str):
            raise PreparationError(f"archive files[{index}].text must be a string")
        if key in texts:
            raise PreparationError(f"archive repeats source path {key}")
        encoded_size = len(text.encode("utf-8"))
        if key not in declared_sizes or declared_sizes[key] != encoded_size:
            raise PreparationError(f"archive text byte count differs from manifest for {key}")
        texts[key] = text
    if set(texts) != set(declared_sizes):
        missing = sorted(set(declared_sizes) - set(texts))
        extra = sorted(set(texts) - set(declared_sizes))
        raise PreparationError(f"archive and manifest source inventories differ (missing={missing[:3]}, extra={extra[:3]})")
    return manifest, texts


def _validate_profiles(profile_text: str, workload: str) -> tuple[int, int]:
    try:
        profile_doc = json.loads(profile_text)
    except json.JSONDecodeError as error:
        raise PreparationError(f"{workload}: archived task profiles are invalid JSON: {error}") from error
    if not isinstance(profile_doc, dict) or profile_doc.get("format") != "amoeba-task-profile-v1":
        raise PreparationError(f"{workload}: archived profile file has an unsupported schema")
    task_count = _required_int(profile_doc.get("task_count"), f"{workload}.task_count", 1)
    expected = task_count * len(SHAPES)
    if (_required_int(profile_doc.get("expected_candidate_count"),
                      f"{workload}.expected_candidate_count", 1) != expected
            or _required_int(profile_doc.get("completed_candidate_count"),
                             f"{workload}.completed_candidate_count", 1) != expected):
        raise PreparationError(f"{workload}: archived mapper candidate counts are not complete at 8 per task")
    raw_tasks = profile_doc.get("tasks")
    if not isinstance(raw_tasks, list) or len(raw_tasks) != task_count:
        raise PreparationError(f"{workload}: profile task inventory differs from task_count")
    tasks: dict[str, dict[str, Any]] = {}
    for index, row in enumerate(raw_tasks):
        if not isinstance(row, dict) or not isinstance(row.get("task"), str) or not row["task"]:
            raise PreparationError(f"{workload}: profile task row {index} is malformed")
        if row["task"] in tasks or not isinstance(row.get("profiles"), list):
            raise PreparationError(f"{workload}: profile task names must be unique with profile arrays")
        tasks[row["task"]] = row

    attempt_doc = profile_doc.get("candidate_attempts")
    if attempt_doc is None:
        row_count = 0
        for task, task_row in tasks.items():
            rows = task_row["profiles"]
            if len(rows) != len(SHAPES):
                raise PreparationError(f"{workload}.{task}: expected all eight original shape profile rows")
            seen: set[str] = set()
            for profile in rows:
                if not isinstance(profile, dict):
                    raise PreparationError(f"{workload}.{task}: malformed mapper profile row")
                shape = profile.get("composed_cgra_shape")
                if shape not in SHAPES or shape in seen:
                    raise PreparationError(f"{workload}.{task}: mapper profiles repeat or omit a legal shape")
                rows_n, cols_n = map(int, shape.split("x"))
                if (type(profile.get("composed_cgra_count")) is not int
                        or profile["composed_cgra_count"] != rows_n * cols_n
                        or type(profile.get("mapper_succeeded")) is not bool):
                    raise PreparationError(f"{workload}.{task}.{shape}: mapper row count or status is malformed")
                seen.add(shape)
                row_count += 1
            if seen != set(SHAPES):
                raise PreparationError(f"{workload}.{task}: mapper profile rows do not cover all eight shapes")
        if row_count != expected:
            raise PreparationError(f"{workload}: mapper profile row count differs from task_count * 8")
    else:
        if not isinstance(attempt_doc, list) or len(attempt_doc) != expected:
            raise PreparationError(f"{workload}: candidate attempts do not cover all eight shapes per task")
        attempts: dict[str, dict[str, dict[str, Any]]] = {}
        for index, attempt in enumerate(attempt_doc):
            if not isinstance(attempt, dict):
                raise PreparationError(f"{workload}: malformed candidate attempt {index}")
            task = attempt.get("task")
            shape = attempt.get("shape")
            candidate_index = attempt.get("candidate_index_in_task")
            if not isinstance(task, str) or task not in tasks or shape not in SHAPES:
                raise PreparationError(f"{workload}: candidate attempt names an unknown task or shape")
            rows_n, cols_n = map(int, shape.split("x"))
            if (type(candidate_index) is not int or candidate_index < 1
                    or candidate_index > len(SHAPES)
                    or SHAPES[candidate_index - 1] != shape
                    or type(attempt.get("composed_cgra_count")) is not int
                    or attempt["composed_cgra_count"] != rows_n * cols_n
                    or type(attempt.get("mapper_succeeded")) is not bool
                    or type(attempt.get("profile_created")) is not bool):
                raise PreparationError(f"{workload}.{task}.{shape}: candidate attempt fields are inconsistent")
            by_shape = attempts.setdefault(task, {})
            if shape in by_shape:
                raise PreparationError(f"{workload}.{task}: duplicate candidate attempt for {shape}")
            by_shape[shape] = attempt
        if set(attempts) != set(tasks) or any(set(rows) != set(SHAPES) for rows in attempts.values()):
            raise PreparationError(f"{workload}: candidate attempts do not form the exact task/shape inventory")
        for task, task_row in tasks.items():
            profiles_by_shape: dict[str, dict[str, Any]] = {}
            for profile in task_row["profiles"]:
                if not isinstance(profile, dict):
                    raise PreparationError(f"{workload}.{task}: malformed mapper profile row")
                shape = profile.get("composed_cgra_shape")
                if shape not in SHAPES or shape in profiles_by_shape:
                    raise PreparationError(f"{workload}.{task}: duplicate or unsupported profile shape")
                rows_n, cols_n = map(int, shape.split("x"))
                if (type(profile.get("composed_cgra_count")) is not int
                        or profile["composed_cgra_count"] != rows_n * cols_n
                        or type(profile.get("mapper_succeeded")) is not bool):
                    raise PreparationError(f"{workload}.{task}.{shape}: mapper row count or status is malformed")
                profiles_by_shape[shape] = profile
            for shape, attempt in attempts[task].items():
                profile = profiles_by_shape.get(shape)
                if attempt["profile_created"] != (profile is not None):
                    raise PreparationError(f"{workload}.{task}.{shape}: profile_created differs from profile row presence")
                if attempt["mapper_succeeded"] and profile is None:
                    raise PreparationError(f"{workload}.{task}.{shape}: successful attempt has no profile row")
                if profile is not None and profile["mapper_succeeded"] is not attempt["mapper_succeeded"]:
                    raise PreparationError(f"{workload}.{task}.{shape}: profile success differs from its attempt")
    return task_count, expected


def _write_text(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as stream:
        stream.write(text)


def _atomic_json(path: Path, value: dict[str, Any]) -> None:
    temporary = path.with_name(f".{path.name}.partial-{os.getpid()}")
    with temporary.open("w", encoding="utf-8", newline="") as stream:
        json.dump(value, stream, ensure_ascii=False, indent=2, sort_keys=True)
        stream.write("\n")
    os.replace(temporary, path)


def prepare(args: argparse.Namespace) -> dict[str, Any]:
    artifact_root = args.artifact_root.resolve()
    if not artifact_root.is_dir():
        raise PreparationError("artifact-root must be an existing directory")
    output_root = args.output_root
    if not output_root.is_absolute():
        output_root = artifact_root / output_root
    output_root = output_root.resolve()
    relative_output = _relative_to_root(output_root, artifact_root, "output-root")
    if not relative_output or output_root == artifact_root:
        raise PreparationError("output-root must be a new directory below artifact-root")
    if output_root.exists() or output_root.is_symlink():
        raise PreparationError("output-root already exists; refusing to overwrite it")
    if len(set(args.workloads)) != len(args.workloads):
        raise PreparationError("workloads contains a duplicate name")

    manifest, evidence = _load_archive(args.bundle_root.resolve())
    replay_inputs = manifest.get("replay_inputs")
    if not isinstance(replay_inputs, dict) or set(replay_inputs) != set(WORKLOADS):
        raise PreparationError("manifest replay_inputs must cover exactly the supported workloads")
    normalized_inputs: dict[str, dict[str, str]] = {}
    for workload in WORKLOADS:
        row = replay_inputs[workload]
        expected_keys = {"profile_input", "profile_file", "caller_shape_proof"}
        if workload == "gcn":
            expected_keys.add("active_transfer_arguments")
        if not isinstance(row, dict) or set(row) != expected_keys:
            raise PreparationError(f"replay_inputs.{workload} has missing or unexpected fields")
        normalized: dict[str, str] = {}
        for field in ("profile_input", "profile_file", "caller_shape_proof"):
            key = _archive_key(row.get(field), f"replay_inputs.{workload}.{field}")
            if key not in evidence:
                raise PreparationError(f"replay_inputs.{workload}.{field} names no archived file")
            normalized[field] = key
        if (Path(normalized["profile_input"]).name != "pending.mlir"
                or Path(normalized["profile_file"]).name != "task-profiles.json"
                or len(set(normalized.values())) != 3):
            raise PreparationError(f"replay_inputs.{workload} does not identify three distinct pending/profile/caller files")
        if workload == "gcn":
            active = row.get("active_transfer_arguments")
            if (not isinstance(active, list)
                    or any(type(value) is not int for value in active)
                    or active != list(range(1, 13))):
                raise PreparationError("replay_inputs.gcn active_transfer_arguments must be exactly 1 through 12")
        normalized_inputs[workload] = normalized

    profile_summaries: dict[str, dict[str, int]] = {}
    for workload in args.workloads:
        selected = normalized_inputs[workload]
        pending_text = evidence[selected["profile_input"]]
        profile_text = evidence[selected["profile_file"]]
        caller_text = evidence[selected["caller_shape_proof"]]
        if not pending_text.strip():
            raise PreparationError(f"{workload}: archived pending input is empty")
        try:
            caller_doc = json.loads(caller_text)
        except json.JSONDecodeError as error:
            raise PreparationError(f"{workload}: archived caller proof is invalid JSON: {error}") from error
        if not isinstance(caller_doc, dict):
            raise PreparationError(f"{workload}: archived caller proof must be a JSON object")
        task_count, expected_candidates = _validate_profiles(profile_text, workload)
        profile_summaries[workload] = {
            "task_count": task_count,
            "expected_candidate_count": expected_candidates,
            "archived_profile_reused": True,
        }

    try:
        output_root.mkdir(parents=True, exist_ok=False)
    except FileExistsError as error:
        raise PreparationError("output-root appeared during preparation; refusing to overwrite it") from error
    except OSError as error:
        raise PreparationError(f"cannot create output-root: {error}") from error

    queue_records: dict[str, dict[str, Any]] = {}
    for workload in args.workloads:
        selected = normalized_inputs[workload]
        workload_root = output_root / workload
        pending_path = workload_root / "pending.mlir"
        profile_path = workload_root / "task-profiles.json"
        caller_path = workload_root / "caller-shape-proof.json"
        _write_text(pending_path, evidence[selected["profile_input"]])
        _write_text(profile_path, evidence[selected["profile_file"]])
        _write_text(caller_path, evidence[selected["caller_shape_proof"]])
        queue_records[workload] = {
            "profile_root": _relative_to_root(workload_root, artifact_root, f"{workload}.profile_root"),
            "profile_input": _relative_to_root(pending_path, artifact_root, f"{workload}.profile_input"),
            "profile_file": _relative_to_root(profile_path, artifact_root, f"{workload}.profile_file"),
            "caller_shape_proof": _relative_to_root(caller_path, artifact_root,
                                                    f"{workload}.caller_shape_proof"),
        }
        if workload == "gcn":
            queue_records[workload]["active_transfer_arguments"] = list(range(1, 13))

    preparation = {
        "schema": "orbit-original-amoeba-frozen-replay-preparation-v1",
        "status": "prepared",
        "input_index": 0,
        "formal_go": False,
        "mapper_profiles": {
            "origin": "archived-actual-original-parent-profiles",
            "reused": True,
            "new_mapper_runs": False,
            "workloads": profile_summaries,
        },
        "fresh_validation_required": {
            "cpp_source_and_current_body_binding": True,
            "caller_shape_and_active_transfer_proofs": True,
            "fixed_retirement_and_independent_trace": True,
            "numeric_gate": True,
        },
        "hashes_used": False,
    }
    _atomic_json(output_root / "preparation.json", preparation)
    inputs = {"schema": QUEUE_SCHEMA, "records": queue_records}
    _atomic_json(output_root / "inputs.json", inputs)
    return {
        "output_root": relative_output,
        "inputs": _relative_to_root(output_root / "inputs.json", artifact_root, "inputs.json"),
        "workloads": list(args.workloads),
        "task_counts": {name: row["task_count"] for name, row in profile_summaries.items()},
        "archived_mapper_profiles_reused": True,
        "hashes_used": False,
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--bundle-root", type=Path, required=True,
                        help="directory containing manifest.json and evidence.json.gz")
    parser.add_argument("--artifact-root", type=Path, default=REPOSITORY_ROOT,
                        help="artifact repository root (default: this checkout)")
    parser.add_argument("--output-root", type=Path, required=True,
                        help="new output directory below artifact-root")
    parser.add_argument("--workloads", nargs="+", choices=WORKLOADS,
                        default=list(WORKLOADS),
                        help="workloads to hydrate (default: gcn harris llama lu radar)")
    args = parser.parse_args(argv)
    try:
        summary = prepare(args)
    except (PreparationError, OSError, UnicodeError) as error:
        print(f"prepare_original_amoeba_frozen_replay: {error}", file=sys.stderr)
        return 2
    print(json.dumps(summary, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
