#!/usr/bin/env python3
"""Check deterministic search and completed-result equivalence for ORBIT cells.

The checker consumes already-produced cell directories.  It does not launch a
compiler, mapper, scheduler, or experiment.
"""
from __future__ import annotations

import argparse
import gzip
import hashlib
import json
import os
import re
import sys
from pathlib import Path
from typing import Any, Iterable, Mapping, Sequence


CHECKER_SCHEMA = "orbit-sequential-runtime-equivalence-v1"
ACTION_BATCH_SIZE = 128
MAX_MISMATCH_EXAMPLES = 40

ALLOWED_DIFFERENCES = {
    "cell_output_paths": "Replace each cell output root with $CELL; retain the relative path.",
    "validated_input_paths": "Replace the exact per-workload input root with $INPUT/<workload> only after input trees and bound files match.",
    "pinned_build_role_paths": "Replace only executable and source-contract paths recorded and verified in each cell's comparison binding; pinned build identities are reported.",
    "wall_elapsed_timing": "Ignore explicit wall-clock timestamps, elapsed values, and attempt IDs embedded in output paths.",
    "additive_runtime_fields": "Allow candidate-only runtime_* telemetry; existing fields remain strict.",
    "sequential_optimization_telemetry": "Allow only the five explicitly listed typed-action replay and periodic checkpoint telemetry fields.",
    "checkpoint_write_period": "Allow the exact checkpoint_write_period field at search summary, top5 records, and result header/footer; the effective baseline default is one.",
    "accepted_parallel_cache_attribution": "Allow per-rank mapper-cache call attribution to move between parallel jobs; require strict aggregate totals and identical flattened audit rows.",
    "predictor_audit_time": "Ignore predictor-audit timing fields; predictor feature/query counts and cache entries remain strict.",
    "verified_numeric_runtime_paths": "Normalize only exact numeric-command argv entries after both scripts match their bound source-contract payload and each resource path resolves identically; artifact-root requires the identical .work resource root.",
}

_TIME_EXACT = {
    "elapsed", "elapsed_seconds", "elapsed_milliseconds", "elapsed_ms", "elapsed_s",
    "wall_time", "wall_seconds", "wall_time_seconds", "wall_elapsed_seconds",
    "wall_clock_seconds", "wall_clock_milliseconds",
    "started_unix", "ended_unix",
    "started_utc", "ended_utc", "started_at", "ended_at", "start_timestamp",
    "end_timestamp", "timestamp_utc",
    "runtime_materializer_active_refresh_milliseconds",
    "runtime_materializer_proof_cache_ir_print_milliseconds",
    "runtime_materializer_seed_proof_check_milliseconds",
}
_TIME_SUFFIXES = (
    "_elapsed_seconds", "_elapsed_milliseconds", "_elapsed_ms", "_wall_seconds",
    "_wall_time_seconds", "_wall_elapsed_seconds", "_wall_clock_seconds",
)
_ATTEMPT_ID = re.compile(r"(?<![A-Za-z0-9_-])attempt-[0-9]+(?:-[0-9]+)?(?![A-Za-z0-9_-])")
_SEQUENTIAL_TELEMETRY_FIELDS = {
    "typed_action_replay_cache_hits",
    "typed_action_replay_cache_misses",
    "typed_action_replay_skipped_steps",
    "periodic_checkpoint_windows",
    "skipped_periodic_checkpoint_writes",
}
_PARALLEL_MAPPER_ATTRIBUTION_FIELDS = {
    "actual_mapper_calls", "mapper_cache_hits", "mapper_cache_misses",
}
_INPUT_BINDING_ROLES = ("canonical", "parent_cost_file", "initial_predictor_cache")
_PIN_BINDING_ROLES = {"optimizer": "optimizer", "source_contract": "source_contract"}


class InputError(Exception):
    """A required input is missing or malformed."""


def _json_load(path: Path) -> Any:
    try:
        if path.name.endswith(".gz"):
            with gzip.open(path, "rt", encoding="utf-8") as stream:
                return json.load(stream)
        with path.open("r", encoding="utf-8") as stream:
            return json.load(stream)
    except (OSError, UnicodeError, json.JSONDecodeError) as exc:
        raise InputError(f"cannot read JSON {path}: {exc}") from exc


def _jsonl_load(path: Path) -> list[Any]:
    opener = gzip.open if path.name.endswith(".gz") else open
    rows: list[Any] = []
    try:
        with opener(path, "rt", encoding="utf-8") as stream:
            for line_number, line in enumerate(stream, 1):
                if not line.strip():
                    continue
                try:
                    rows.append(json.loads(line))
                except json.JSONDecodeError as exc:
                    raise InputError(f"invalid JSONL at {path}:{line_number}: {exc}") from exc
    except (OSError, UnicodeError) as exc:
        raise InputError(f"cannot read JSONL {path}: {exc}") from exc
    return rows


def _with_gzip(path: Path) -> list[Path]:
    return [path, Path(str(path) + ".gz")]


def _first_existing(paths: Iterable[Path]) -> Path | None:
    for path in paths:
        if path.is_file():
            return path
    return None


def _trace_path(
    cell_root: Path,
    search_dir: Path,
    configured: Any,
    default_names: Sequence[str],
    required: bool = True,
) -> Path | None:
    candidates: list[Path] = []
    if isinstance(configured, str) and configured:
        configured_path = Path(configured)
        if configured_path.is_absolute():
            candidates.extend(_with_gzip(configured_path))
            candidates.extend(_with_gzip(search_dir / configured_path.name))
        else:
            candidates.extend(_with_gzip(search_dir / configured_path))
            candidates.extend(_with_gzip(cell_root / configured_path))
    for name in default_names:
        candidates.extend(_with_gzip(search_dir / name))
        candidates.extend(_with_gzip(cell_root / name))
    found = _first_existing(candidates)
    if found is None and required:
        names = ", ".join(default_names)
        raise InputError(f"missing required search trace under {search_dir} (tried: {names})")
    return found


def _json_pointer(tokens: Sequence[Any]) -> str:
    def escape(token: Any) -> str:
        return str(token).replace("~", "~0").replace("/", "~1")
    return "/" + "/".join(escape(token) for token in tokens)


def _short(value: Any, limit: int = 320) -> Any:
    try:
        rendered = json.dumps(value, sort_keys=True, ensure_ascii=False, separators=(",", ":"))
    except (TypeError, ValueError):
        rendered = repr(value)
    if len(rendered) > limit:
        return rendered[: limit - 1] + "…"
    return value


def _normal_key(key: Any) -> str:
    text = str(key)
    text = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", text)
    return text.casefold().replace("-", "_")


def _is_timing_key(key: Any, tokens: Sequence[Any]) -> bool:
    normalized = _normal_key(key)
    if normalized in _TIME_EXACT or normalized.endswith(_TIME_SUFFIXES):
        return True
    if "wall_" in normalized and ("_seconds" in normalized or "_milliseconds" in normalized):
        return True
    ancestry = {_normal_key(token) for token in tokens[:-1] if isinstance(token, str)}
    predictor_context = any("predictor" in item or "audit" in item for item in ancestry)
    if predictor_context and any(mark in normalized for mark in ("elapsed", "wall_time", "wall_clock", "audit_time")):
        return True
    if predictor_context and normalized in {"query_seconds", "feature_extraction_ms", "audit_ms", "audit_seconds"}:
        return True
    return False


def _is_feature_query_counter(key: Any, tokens: Sequence[Any]) -> bool:
    normalized = _normal_key(key)
    joined = "_".join(_normal_key(token) for token in tokens if isinstance(token, str))
    if "feature_query" in normalized or "feature_queries" in normalized:
        return True
    if "predictor" in (normalized + "_" + joined) and ("query_count" in normalized or "query_calls" in normalized):
        return True
    return False


def _looks_like_path(value: str) -> bool:
    return "/" in value or "\\" in value or value.startswith((".", "~"))


def _is_path_key(key: Any) -> bool:
    normalized = _normal_key(key)
    return (
        normalized.endswith(("_path", "_file", "_root", "_directory", "_dir", "_evidence"))
        or normalized in {"path", "file", "source", "destination", "stderr", "stdout"}
    )


def _cell_aliases(root: Path, raw_argument: str) -> list[str]:
    aliases: list[str] = []
    relative_aliases: list[str] = []
    for base in (Path.cwd().resolve(), Path(__file__).resolve().parents[1]):
        try:
            relative_aliases.append(root.relative_to(base).as_posix())
        except ValueError:
            pass
    for value in (raw_argument, os.path.normpath(raw_argument), str(root), root.as_posix(), *relative_aliases):
        if value and value not in {".", "./", "/"}:
            normalized = value.replace("\\", "/").rstrip("/")
            if normalized and normalized not in aliases:
                aliases.append(normalized)
    return sorted(aliases, key=len, reverse=True)


def _replace_root(value: str, aliases: Sequence[str]) -> tuple[str, bool]:
    result = value.replace("\\", "/")
    changed = False
    for alias in aliases:
        escaped = re.escape(alias)
        pattern = re.compile(r"(?<![A-Za-z0-9_.-])" + escaped + r"(?=/|$)")
        result, substitutions = pattern.subn("$CELL", result)
        changed = changed or substitutions > 0
    return result, changed


def _sha256_file(path: Path) -> tuple[str, int]:
    digest = hashlib.sha256()
    size = 0
    with path.open("rb") as stream:
        while True:
            block = stream.read(1024 * 1024)
            if not block:
                break
            size += len(block)
            digest.update(block)
    return digest.hexdigest(), size


def _tree_manifest(root: Path) -> dict[str, dict[str, Any]] | None:
    if not root.is_dir():
        return None
    manifest: dict[str, dict[str, Any]] = {}
    root_resolved = root.resolve()
    for path in sorted(root.rglob("*")):
        if not path.is_file():
            continue
        resolved = path.resolve()
        try:
            resolved.relative_to(root_resolved)
        except ValueError:
            return None
        digest, size = _sha256_file(path)
        manifest[path.relative_to(root).as_posix()] = {"sha256": digest, "size": size}
    return manifest


def _manifest_sha256(manifest: Mapping[str, Mapping[str, Any]]) -> str:
    payload = json.dumps(manifest, sort_keys=True, separators=(",", ":"), ensure_ascii=False)
    return hashlib.sha256(payload.encode("utf-8")).hexdigest()


def _path_aliases(path: Path) -> dict[str, Path]:
    resolved = path.expanduser().resolve()
    aliases: dict[str, Path] = {str(resolved): resolved, resolved.as_posix(): resolved}
    for base in (Path.cwd().resolve(), Path(__file__).resolve().parents[1]):
        try:
            relative = resolved.relative_to(base).as_posix()
        except ValueError:
            continue
        aliases[relative] = resolved
    return aliases


def _replace_validated_input(
    value: str,
    aliases: Mapping[str, Path],
    workload: str,
    verified: bool,
) -> tuple[str, bool]:
    if not verified:
        return value.replace("\\", "/"), False
    result = value.replace("\\", "/")
    changed = False
    for alias, root in sorted(aliases.items(), key=lambda pair: len(pair[0]), reverse=True):
        normalized_alias = alias.replace("\\", "/").rstrip("/")
        if not normalized_alias:
            continue
        pattern = re.compile(r"(?<![A-Za-z0-9_.-])" + re.escape(normalized_alias) + r"(?=/|$)")

        def replace(match: re.Match[str]) -> str:
            nonlocal changed
            end = match.end()
            tail = result[end:]
            suffix_match = re.match(r"/?([^\s\"',;]+)", tail)
            suffix = suffix_match.group(1).lstrip("/") if suffix_match else ""
            if suffix in {"", "."}:
                target = root
            else:
                target = (root / suffix).resolve()
                try:
                    target.relative_to(root)
                except ValueError:
                    return match.group(0)
            if not target.exists():
                return match.group(0)
            changed = True
            return f"$INPUT/{workload}"

        result = pattern.sub(replace, result)
    return result, changed


def _replace_pin_paths(value: str, pins: Mapping[str, Sequence[str]]) -> tuple[str, bool]:
    result = value.replace("\\", "/")
    changed = False
    for role, aliases in pins.items():
        token = f"$PIN/{role}"
        for alias in sorted(set(aliases), key=len, reverse=True):
            normalized = alias.replace("\\", "/").rstrip("/")
            if not normalized:
                continue
            pattern = re.compile(
                r"(?<![A-Za-z0-9_.-])" + re.escape(normalized) + r"(?![A-Za-z0-9_.-])"
            )
            result, substitutions = pattern.subn(token, result)
            changed = changed or substitutions > 0
    return result, changed


def _is_native_rank_mapper_attribution(tokens: Sequence[Any]) -> bool:
    if not tokens or _normal_key(tokens[-1]) not in _PARALLEL_MAPPER_ATTRIBUTION_FIELDS:
        return False
    parts = list(tokens)
    if parts and parts[0] == "result.json":
        parts = parts[1:]
        return (
            len(parts) == 4
            and parts[0] in {"native_top5", "native_controls"}
            and parts[1] == "records"
            and isinstance(parts[2], int)
        )
    return (
        len(parts) == 5
        and parts[0] in {"native-top5", "native-controls"}
        and parts[1] == "results"
        and isinstance(parts[2], int)
        and parts[3] == "result"
    )


def _is_checkpoint_write_period_path(tokens: Sequence[Any]) -> bool:
    if not tokens or tokens[-1] != "checkpoint_write_period":
        return False
    if tokens[0] == "search":
        return (
            (len(tokens) == 3 and tokens[1] == "search-summary.json")
            or (len(tokens) == 4 and tokens[1] == "top5.jsonl" and isinstance(tokens[2], int))
        )
    return (
        len(tokens) == 3
        and tokens[0] == "result.json"
        and tokens[1] in {"search_header", "search_footer"}
    )


class DifferenceComparator:
    """Recursive JSON comparator with a deliberately small normalization allowlist."""

    def __init__(
        self,
        reference_root: Path,
        reference_arg: str,
        candidate_root: Path,
        candidate_arg: str,
        *,
        reference_input_root: Path | None = None,
        candidate_input_root: Path | None = None,
        workload: str | None = None,
        input_paths_verified: bool = False,
        reference_pins: Mapping[str, Sequence[str]] | None = None,
        candidate_pins: Mapping[str, Sequence[str]] | None = None,
        verified_numeric_paths: Mapping[tuple[Any, ...], Any] | None = None,
    ):
        self.reference_aliases = _cell_aliases(reference_root, reference_arg)
        self.candidate_aliases = _cell_aliases(candidate_root, candidate_arg)
        self.reference_input_aliases = _path_aliases(reference_input_root) if reference_input_root else {}
        self.candidate_input_aliases = _path_aliases(candidate_input_root) if candidate_input_root else {}
        self.workload = workload or "unknown"
        self.input_paths_verified = input_paths_verified
        self.reference_pins = dict(reference_pins or {})
        self.candidate_pins = dict(candidate_pins or {})
        self.verified_numeric_paths = dict(verified_numeric_paths or {})
        self.allowed_counts = {name: 0 for name in ALLOWED_DIFFERENCES}
        self.allowed_examples: dict[str, list[str]] = {name: [] for name in ALLOWED_DIFFERENCES}
        self.allowed_values: dict[str, list[dict[str, Any]]] = {name: [] for name in ALLOWED_DIFFERENCES}
        self.mismatches: list[dict[str, Any]] = []
        self.mismatch_count = 0

    def _allowed(self, category: str, tokens: Sequence[Any], values: dict[str, Any] | None = None) -> None:
        self.allowed_counts[category] += 1
        if len(self.allowed_examples[category]) < 12:
            self.allowed_examples[category].append(_json_pointer(tokens))
        if values is not None and len(self.allowed_values[category]) < 20:
            self.allowed_values[category].append({"path": _json_pointer(tokens), **values})

    def _mismatch(self, tokens: Sequence[Any], left: Any, right: Any, reason: str | None = None) -> None:
        self.mismatch_count += 1
        if len(self.mismatches) < MAX_MISMATCH_EXAMPLES:
            item = {
                "path": _json_pointer(tokens),
                "reference": _short(left),
                "candidate": _short(right),
            }
            if reason:
                item["reason"] = reason
            self.mismatches.append(item)

    def _normalize_string(self, left: str, right: str, key: Any, tokens: Sequence[Any]) -> tuple[str, str]:
        verified = self.verified_numeric_paths.get(tuple(tokens))
        if verified and (left, right) == (verified["reference"], verified["candidate"]):
            self._allowed("verified_numeric_runtime_paths", tokens, verified)
            return "$VERIFIED_NUMERIC_PATH", "$VERIFIED_NUMERIC_PATH"
        left_input, left_input_changed = _replace_validated_input(
            left, self.reference_input_aliases, self.workload, self.input_paths_verified,
        )
        right_input, right_input_changed = _replace_validated_input(
            right, self.candidate_input_aliases, self.workload, self.input_paths_verified,
        )
        if (left_input_changed or right_input_changed) and left_input == right_input:
            self._allowed("validated_input_paths", tokens)

        left_pin, left_pin_changed = _replace_pin_paths(left_input, self.reference_pins)
        right_pin, right_pin_changed = _replace_pin_paths(right_input, self.candidate_pins)
        if (left_pin_changed or right_pin_changed) and left_pin == right_pin:
            self._allowed("pinned_build_role_paths", tokens)

        left_cell, left_root_changed = _replace_root(left_pin, self.reference_aliases)
        right_cell, right_root_changed = _replace_root(right_pin, self.candidate_aliases)
        if (left_root_changed or right_root_changed) and left_cell == right_cell:
            self._allowed("cell_output_paths", tokens)

        left_attempt, left_attempt_changed = (left_cell, 0)
        right_attempt, right_attempt_changed = (right_cell, 0)
        if _looks_like_path(left_cell):
            left_attempt, left_attempt_changed = _ATTEMPT_ID.subn("attempt-<run>", left_cell)
        if _looks_like_path(right_cell):
            right_attempt, right_attempt_changed = _ATTEMPT_ID.subn("attempt-<run>", right_cell)
        if (left_attempt_changed or right_attempt_changed) and left_attempt == right_attempt:
            self._allowed("wall_elapsed_timing", tokens)
        return left_attempt, right_attempt

    def compare(self, reference: Any, candidate: Any, base_tokens: Sequence[Any]) -> None:
        self._compare(reference, candidate, list(base_tokens))

    def _compare(self, left: Any, right: Any, tokens: list[Any]) -> None:
        if isinstance(left, dict) and isinstance(right, dict):
            keys = sorted(set(left) | set(right), key=str)
            for key in keys:
                left_has, right_has = key in left, key in right
                child_tokens = tokens + [key]
                if _is_timing_key(key, child_tokens) and (not left_has or not right_has or left[key] != right[key]):
                    category = "predictor_audit_time" if "predictor" in "_".join(map(str, child_tokens)).casefold() or "audit" in "_".join(map(str, child_tokens)).casefold() else "wall_elapsed_timing"
                    self._allowed(category, child_tokens)
                    continue
                if str(key) in _SEQUENTIAL_TELEMETRY_FIELDS and (
                    not left_has or not right_has or left[key] != right[key]
                ):
                    self._allowed("sequential_optimization_telemetry", child_tokens)
                    continue
                if _is_checkpoint_write_period_path(child_tokens) and (
                    not left_has or not right_has or left[key] != right[key]
                ):
                    self._allowed("checkpoint_write_period", child_tokens, {
                        "reference": {
                            "present": left_has,
                            "recorded_value": left.get(key),
                            "effective_value": left.get(key, 1),
                        },
                        "candidate": {
                            "present": right_has,
                            "recorded_value": right.get(key),
                            "effective_value": right.get(key, 1),
                        },
                    })
                    continue
                if (
                    left_has and right_has and left[key] != right[key]
                    and _is_native_rank_mapper_attribution(child_tokens)
                ):
                    self._allowed("accepted_parallel_cache_attribution", child_tokens)
                    continue
                if not left_has:
                    if str(key).startswith("runtime_") and not _is_feature_query_counter(key, child_tokens):
                        self._allowed("additive_runtime_fields", child_tokens)
                        continue
                    self._mismatch(child_tokens, "<missing>", right[key], "field added")
                    continue
                if not right_has:
                    self._mismatch(child_tokens, left[key], "<missing>", "field removed")
                    continue
                self._compare(left[key], right[key], child_tokens)
            return
        if isinstance(left, list) and isinstance(right, list):
            if len(left) != len(right):
                self._mismatch(tokens + ["length"], len(left), len(right), "list length differs; list order is significant")
            for index in range(min(len(left), len(right))):
                self._compare(left[index], right[index], tokens + [index])
            return
        if isinstance(left, str) and isinstance(right, str):
            normalized_left, normalized_right = self._normalize_string(left, right, tokens[-1] if tokens else "", tokens)
            if normalized_left != normalized_right:
                self._mismatch(tokens, left, right)
            return
        if type(left) is not type(right) or left != right:
            self._mismatch(tokens, left, right)

    def summary(self) -> dict[str, Any]:
        return {
            "mismatch_count": self.mismatch_count,
            "mismatches": self.mismatches,
            "allowed_difference_counts": dict(self.allowed_counts),
            "allowed_difference_examples": dict(self.allowed_examples),
            "allowed_difference_values": dict(self.allowed_values),
        }


class CellArtifacts:
    def __init__(self, raw_root: str):
        self.raw_root = raw_root
        self.root = Path(raw_root).expanduser().resolve()
        if not self.root.exists() or not self.root.is_dir():
            raise InputError(f"cell directory does not exist: {raw_root}")
        self.bundle_root = self.root.parent.parent
        self.workload = self.root.parent.name
        self.binding_path = self.root / "comparison-binding.json"
        self.binding = _json_load(self.binding_path) if self.binding_path.is_file() else None
        if isinstance(self.binding, dict) and isinstance(self.binding.get("workload"), str):
            self.workload = self.binding["workload"]
        self.input_root = self.bundle_root / "inputs" / self.workload
        self.input_manifest = _tree_manifest(self.input_root)
        self.input_binding_errors: list[str] = []
        self.pin_aliases: dict[str, list[str]] = {}
        self.pin_roles: dict[str, dict[str, Any]] = {}
        self.pin_binding_errors: list[str] = []
        self._load_binding_roles()
        nested_search = self.root / "search"
        self.search_dir = nested_search if nested_search.is_dir() else self.root
        summary_path = _first_existing([
            self.search_dir / "search-summary.json",
            self.root / "search" / "search-summary.json",
            self.root / "search-summary.json",
        ])
        if summary_path is None:
            raise InputError(f"missing required search summary under {self.root}")
        self.paths: dict[str, str] = {"search_summary": str(summary_path)}
        self.summary = _json_load(summary_path)
        if not isinstance(self.summary, dict):
            raise InputError(f"search summary must be a JSON object: {summary_path}")
        self.traces: dict[str, list[Any]] = {}
        trace_specs = {
            "action_attempts": ("action_attempt_trace_file", ("action-attempts.jsonl", "action-attempts.jsonl.gz")),
            "action_frontiers": ("action_frontier_trace_file", ("action-frontiers.jsonl", "action-frontiers.jsonl.gz")),
            "budget_trace": ("budget_trace_file", ("budget-trace.jsonl", "budget-trace.jsonl.gz")),
        }
        for name, (summary_key, defaults) in trace_specs.items():
            path = _trace_path(self.root, self.search_dir, self.summary.get(summary_key), defaults)
            assert path is not None
            self.paths[name] = str(path)
            self.traces[name] = _jsonl_load(path)

        top5_path = _trace_path(
            self.root, self.search_dir, None,
            ("top5.jsonl", "global-top5.jsonl", "top5.jsonl.gz", "global-top5.jsonl.gz"),
        )
        controls_path = _trace_path(
            self.root, self.search_dir, None,
            ("controls.jsonl", "stage-controls.jsonl", "controls.jsonl.gz", "stage-controls.jsonl.gz"),
        )
        assert top5_path is not None and controls_path is not None
        self.paths["global_top5"] = str(top5_path)
        self.paths["stage_controls"] = str(controls_path)
        self.global_top5 = _jsonl_load(top5_path)
        self.stage_controls = _jsonl_load(controls_path)
        self.top5_selections = [row for row in self.global_top5 if isinstance(row, dict) and row.get("record_type") == "selection"]

        self.result_path = self.root / "result.json"
        self.result = _json_load(self.result_path) if self.result_path.is_file() else None
        self.comparison_summary_path = self.root / "comparison-summary.json"
        self.comparison_summary = _json_load(self.comparison_summary_path) if self.comparison_summary_path.is_file() else None
        self.predictor_cache_path = self.root / "predictor-cache.json"
        self.predictor_cache = _json_load(self.predictor_cache_path) if self.predictor_cache_path.is_file() else None
        self.mapper_ii_path = self.root / "mapper-ii-evidence.json"
        self.mapper_ii = _json_load(self.mapper_ii_path) if self.mapper_ii_path.is_file() else None

        self.native_results = self._ranked_json("native-top5", "native-top5")
        self.native_controls = self._ranked_json("native-controls", "native-controls")
        self.numeric_top5 = self._ranked_json("numeric/top5", "numeric-top5")
        self.numeric_controls = self._ranked_json("numeric/controls", "numeric-controls")
        self.mapper_call_audits = self._mapper_audits()
        self.mapping_cache_present, self.mapping_cache_entries, self.mapping_cache_errors = self._mapping_cache_entries()
        self.candidate_ir_entries = self._candidate_ir_entries()

    def _binding_file_path(self, raw_path: str) -> Path:
        path = Path(raw_path).expanduser()
        return path.resolve() if path.is_absolute() else (self.bundle_root / path).resolve()

    def _load_binding_roles(self) -> None:
        if self.binding is None:
            return
        if not isinstance(self.binding, dict):
            self.input_binding_errors.append("comparison-binding.json is not an object")
            self.pin_binding_errors.append("comparison-binding.json is not an object")
            return
        if self.binding.get("workload") not in {None, self.root.parent.name}:
            self.input_binding_errors.append(
                f"binding workload {self.binding.get('workload')!r} does not match cell parent {self.root.parent.name!r}"
            )

        content_binding = self.binding.get("content_binding", {})
        if not isinstance(content_binding, dict):
            content_binding = {}
            self.pin_binding_errors.append("content_binding is not an object")
            self.input_binding_errors.append("content_binding is not an object")

        # Validate every input-role record that the cell binding provides.
        top_inputs = self.binding.get("inputs", {})
        if not isinstance(top_inputs, dict):
            top_inputs = {}
            self.input_binding_errors.append("inputs is not an object")
        for role in _INPUT_BINDING_ROLES:
            record = content_binding.get(role)
            if record is None:
                continue
            if not isinstance(record, dict) or not isinstance(record.get("path"), str):
                self.input_binding_errors.append(f"content_binding.{role} is malformed")
                continue
            bound_path = self._binding_file_path(record["path"])
            try:
                relative = bound_path.relative_to(self.input_root.resolve())
            except ValueError:
                self.input_binding_errors.append(f"content_binding.{role} path is outside the per-workload input root")
                continue
            if not bound_path.is_file():
                self.input_binding_errors.append(f"content_binding.{role} file is missing: {record['path']}")
                continue
            if not isinstance(record.get("sha256"), str) or not isinstance(record.get("size"), int):
                self.input_binding_errors.append(f"content_binding.{role} lacks SHA-256 or size")
                continue
            actual_sha, actual_size = _sha256_file(bound_path)
            if actual_sha != record["sha256"] or actual_size != record["size"]:
                self.input_binding_errors.append(f"content_binding.{role} content does not match recorded SHA-256/size")
            # A top-level path role, when present, must identify the same file.
            top_role = top_inputs.get(role)
            if top_role is None and role == "initial_predictor_cache":
                top_role = top_inputs.get("cost_cache")
            if isinstance(top_role, str) and self._binding_file_path(top_role) != bound_path:
                self.input_binding_errors.append(f"inputs.{role} path disagrees with content_binding.{role}")

        # Pin paths are normalized only when the exact recorded file and its
        # content guard both verify locally.  No basename or field-name rule
        # can normalize an unbound compiler/model path.
        for binding_role, output_role in _PIN_BINDING_ROLES.items():
            record = content_binding.get(binding_role)
            if not isinstance(record, dict) or not isinstance(record.get("path"), str):
                continue
            raw_path = record["path"]
            pin_path = self._binding_file_path(raw_path)
            role_report: dict[str, Any] = {
                "path": raw_path,
                "sha256": record.get("sha256"),
                "size": record.get("size"),
                "verified": False,
            }
            top_path = self.binding.get(binding_role)
            if binding_role == "source_contract":
                top_path = self.binding.get("source_contract", self.binding.get("source_contract_file"))
            if isinstance(top_path, str) and self._binding_file_path(top_path) != pin_path:
                self.pin_binding_errors.append(f"top-level {binding_role} path disagrees with content_binding.{binding_role}")
            if not pin_path.is_file():
                self.pin_binding_errors.append(f"pinned {binding_role} file is missing: {raw_path}")
            elif not isinstance(record.get("sha256"), str) or not isinstance(record.get("size"), int):
                self.pin_binding_errors.append(f"content_binding.{binding_role} lacks SHA-256 or size")
            else:
                actual_sha, actual_size = _sha256_file(pin_path)
                role_report["verified"] = actual_sha == record["sha256"] and actual_size == record["size"]
                if not role_report["verified"]:
                    self.pin_binding_errors.append(f"pinned {binding_role} content does not match recorded SHA-256/size")
                else:
                    self.pin_aliases[output_role] = list(_path_aliases(pin_path).keys())
                    self.pin_aliases[output_role].append(raw_path)
            self.pin_roles[output_role] = role_report

    def input_binding_status(self) -> dict[str, Any]:
        return {
            "workload": self.workload,
            "root": str(self.input_root),
            "file_count": len(self.input_manifest) if self.input_manifest is not None else None,
            "tree_sha256": _manifest_sha256(self.input_manifest) if self.input_manifest is not None else None,
            "role_errors": list(self.input_binding_errors),
        }

    def _ranked_json(self, relative_root: str, label: str) -> list[dict[str, Any]]:
        directory = self.root / relative_root
        if not directory.is_dir():
            return []
        results: list[dict[str, Any]] = []
        for path in sorted(directory.rglob("result.json")):
            value = _json_load(path)
            if not isinstance(value, dict):
                raise InputError(f"result record must be a JSON object: {path}")
            match = re.search(r"rank-(\d+)", path.as_posix())
            rank = value.get("rank")
            if not isinstance(rank, int) and match:
                rank = int(match.group(1))
            if not isinstance(rank, int):
                raise InputError(f"cannot identify rank in {label} result: {path}")
            results.append({"rank": rank, "result": value})
        results.sort(key=lambda row: row["rank"])
        return results

    def _mapper_audits(self) -> list[dict[str, Any]]:
        audits: list[dict[str, Any]] = []
        for stage in ("native-top5", "native-controls"):
            directory = self.root / stage
            if not directory.is_dir():
                continue
            for path in sorted(directory.glob("rank-*/mapper-call-audit.json")):
                match = re.search(r"rank-(\d+)", path.parent.name)
                rank = int(match.group(1)) if match else -1
                audits.append({"stage": stage, "rank": rank, "audit": _json_load(path)})
        audits.sort(key=lambda row: (row["stage"], row["rank"]))
        return audits

    def _mapping_cache_entries(self) -> tuple[bool, list[dict[str, Any]], list[str]]:
        directory = self.root / "mapping-cache"
        if not directory.is_dir():
            return False, [], []
        entries: list[dict[str, Any]] = []
        errors: list[str] = []
        task_dirs = sorted(
            (path for path in directory.glob("task-*") if path.is_dir()),
            key=lambda path: path.name,
        )
        for task_dir in task_dirs:
            input_path = task_dir / "input.txt"
            mapped_path = task_dir / "mapped.mlir"
            if not input_path.is_file() or not mapped_path.is_file():
                errors.append(f"{task_dir.name} lacks input.txt or mapped.mlir")
                continue
            input_sha, input_size = _sha256_file(input_path)
            mapped_sha, mapped_size = _sha256_file(mapped_path)
            entries.append({
                "input_sha256": input_sha,
                "input_size": input_size,
                "mapped_sha256": mapped_sha,
                "mapped_size": mapped_size,
            })
        entries.sort(key=lambda row: (row["input_sha256"], row["mapped_sha256"], row["input_size"], row["mapped_size"]))
        return True, entries, errors

    def _candidate_ir_entries(self) -> list[dict[str, Any]] | None:
        directory = self.search_dir / "candidates"
        if not directory.is_dir():
            return None
        entries: list[dict[str, Any]] = []
        for path in sorted(directory.rglob("*.mlir")):
            digest, size = _sha256_file(path)
            entries.append({
                "path": path.relative_to(directory).as_posix(),
                "sha256": digest,
                "size": size,
            })
        return entries

    @property
    def has_numeric_evidence(self) -> bool:
        return bool(self.native_results or self.native_controls or self.numeric_top5 or self.numeric_controls)

    def counts(self) -> dict[str, Any]:
        attempts = len(self.traces["action_attempts"])
        chunk_sizes = [min(ACTION_BATCH_SIZE, attempts - start) for start in range(0, attempts, ACTION_BATCH_SIZE)]
        boundaries = list(range(ACTION_BATCH_SIZE, attempts + 1, ACTION_BATCH_SIZE))
        if attempts and (not boundaries or boundaries[-1] != attempts):
            boundaries.append(attempts)
        return {
            "action_attempts": attempts,
            "action_frontiers": len(self.traces["action_frontiers"]),
            "budget_events": len(self.traces["budget_trace"]),
            "global_top5_records": len(self.global_top5),
            "global_top5_selections": len(self.top5_selections),
            "stage_controls": len(self.stage_controls),
            "action_attempt_batch_size_128": chunk_sizes,
            "action_attempt_boundaries_after": boundaries,
            "native_top5_results": len(self.native_results),
            "native_control_results": len(self.native_controls),
            "numeric_top5_results": len(self.numeric_top5),
            "numeric_control_results": len(self.numeric_controls),
            "mapper_call_audits": len(self.mapper_call_audits),
            "has_completed_result": self.result is not None,
            "has_comparison_summary": self.comparison_summary is not None,
            "has_numeric_evidence": self.has_numeric_evidence,
            "has_predictor_cache": self.predictor_cache is not None,
            "has_mapper_ii_evidence": self.mapper_ii is not None,
            "mapping_cache_entries": len(self.mapping_cache_entries),
            "has_mapping_cache": self.mapping_cache_present,
            "candidate_ir_files": len(self.candidate_ir_entries) if self.candidate_ir_entries is not None else None,
        }


def _input_bindings_match(reference: CellArtifacts, candidate: CellArtifacts) -> bool:
    return (
        reference.workload == candidate.workload
        and reference.input_manifest is not None
        and candidate.input_manifest is not None
        and reference.input_manifest == candidate.input_manifest
        and not reference.input_binding_errors
        and not candidate.input_binding_errors
    )


def _flatten_mapper_audits(cell: CellArtifacts) -> list[Any]:
    rows: list[Any] = []
    for entry in cell.mapper_call_audits:
        audit = entry.get("audit")
        if isinstance(audit, list):
            raw_rows = audit
        elif audit is not None:
            raw_rows = [audit]
        else:
            raw_rows = []
        for row in raw_rows:
            if isinstance(row, dict):
                # candidate_id identifies which parallel job first acquired a
                # shared cache key; that ownership is reported separately.
                rows.append({key: value for key, value in row.items() if key != "candidate_id"})
            else:
                rows.append(row)
    return sorted(rows, key=lambda row: json.dumps(row, sort_keys=True, separators=(",", ":"), ensure_ascii=False))


def _mapper_audit_candidate_counts(cell: CellArtifacts) -> dict[str, int]:
    counts: dict[str, int] = {}
    for entry in cell.mapper_call_audits:
        audit = entry.get("audit")
        if not isinstance(audit, list):
            audit = [audit] if audit is not None else []
        for row in audit:
            if isinstance(row, dict) and isinstance(row.get("candidate_id"), str):
                candidate_id = row["candidate_id"]
                counts[candidate_id] = counts.get(candidate_id, 0) + 1
    return dict(sorted(counts.items()))


def _native_records(cell: CellArtifacts) -> list[dict[str, Any]]:
    records: list[dict[str, Any]] = []
    for stage, values in (("native-top5", cell.native_results), ("native-controls", cell.native_controls)):
        for row in values:
            records.append({"stage": stage, "rank": row["rank"], "result": row["result"]})
    return sorted(records, key=lambda row: (row["stage"], row["rank"]))


def _mapper_attribution_totals(cell: CellArtifacts) -> tuple[dict[str, int] | None, list[dict[str, Any]]]:
    records = _native_records(cell)
    if not records:
        return None, []
    totals = {field: 0 for field in sorted(_PARALLEL_MAPPER_ATTRIBUTION_FIELDS)}
    errors: list[dict[str, Any]] = []
    for index, record in enumerate(records):
        result = record["result"]
        for field in totals:
            value = result.get(field)
            if isinstance(value, bool) or not isinstance(value, int):
                errors.append({
                    "path": f"/{record['stage']}/rank-{record['rank']}/{field}",
                    "reason": "native result is missing an integer mapper-attribution counter",
                    "value": value if value is not None else "<missing>",
                })
            else:
                totals[field] += value
    return (totals if not errors else None), errors


def _parallel_attribution_report(reference: CellArtifacts, candidate: CellArtifacts) -> dict[str, Any]:
    reference_records = _native_records(reference)
    candidate_records = _native_records(candidate)
    reference_totals, reference_errors = _mapper_attribution_totals(reference)
    candidate_totals, candidate_errors = _mapper_attribution_totals(candidate)
    ref_by_key = {(row["stage"], row["rank"]): row["result"] for row in reference_records}
    cand_by_key = {(row["stage"], row["rank"]): row["result"] for row in candidate_records}
    per_rank: list[dict[str, Any]] = []
    for stage, rank in sorted(set(ref_by_key) | set(cand_by_key)):
        ref = ref_by_key.get((stage, rank), {})
        cand = cand_by_key.get((stage, rank), {})
        ref_fields = {field: ref.get(field) for field in sorted(_PARALLEL_MAPPER_ATTRIBUTION_FIELDS)}
        cand_fields = {field: cand.get(field) for field in sorted(_PARALLEL_MAPPER_ATTRIBUTION_FIELDS)}
        differences = [field for field in ref_fields if ref_fields[field] != cand_fields[field]]
        if differences:
            per_rank.append({
                "stage": stage,
                "rank": rank,
                "candidate_id": ref.get("candidate_id"),
                "reference": ref_fields,
                "candidate": cand_fields,
                "differing_fields": differences,
            })
    aggregate_equal = reference_totals is not None and reference_totals == candidate_totals
    ref_audit_candidates = _mapper_audit_candidate_counts(reference)
    cand_audit_candidates = _mapper_audit_candidate_counts(candidate)
    return {
        "accepted": aggregate_equal and len(reference_records) == 7 and len(candidate_records) == 7,
        "reference_record_count": len(reference_records),
        "candidate_record_count": len(candidate_records),
        "reference_totals": reference_totals,
        "candidate_totals": candidate_totals,
        "aggregate_totals_equal": aggregate_equal,
        "reference_counter_errors": reference_errors,
        "candidate_counter_errors": candidate_errors,
        "per_rank_differences": per_rank,
        "mapper_audit_candidate_id_counts": {
            "reference": ref_audit_candidates,
            "candidate": cand_audit_candidates,
            "differing_candidate_ids": sorted(
                key for key in set(ref_audit_candidates) | set(cand_audit_candidates)
                if ref_audit_candidates.get(key, 0) != cand_audit_candidates.get(key, 0)
            ),
        },
    }


def _check(name: str, status: str, ref_count: Any = None, cand_count: Any = None,
           mismatch_count: int = 0, mismatches: list[dict[str, Any]] | None = None,
           allowed: dict[str, Any] | None = None, note: str | None = None) -> dict[str, Any]:
    value: dict[str, Any] = {
        "name": name,
        "status": status,
        "reference_count": ref_count,
        "candidate_count": cand_count,
        "mismatch_count": mismatch_count,
        "mismatches": mismatches or [],
    }
    if allowed is not None:
        value["allowed_difference_counts"] = allowed
    if note:
        value["note"] = note
    return value


def verified_numeric_runtime_paths(reference_cell, candidate_cell):
    """Prove each runtime relocation before permitting its exact argv token."""
    permitted = {}
    if not reference_cell.binding or not candidate_cell.binding:
        return permitted
    for block in ("numeric_top5_command", "numeric_controls_command"):
        left = (reference_cell.result or {}).get(block, {}).get("argv", [])
        right = (candidate_cell.result or {}).get(block, {}).get("argv", [])
        if len(left) != len(right) or len(left) < 2:
            continue
        scripts = [Path(left[1]), Path(right[1])]
        if not all(p.is_file() for p in scripts):
            continue
        payloads = [p.read_bytes() for p in scripts]
        if payloads[0] != payloads[1]:
            continue
        authenticated = True
        for cell, payload in zip((reference_cell, candidate_cell), payloads):
            contract_path = cell.binding.get("source_contract")
            if not contract_path or not Path(contract_path).is_file():
                authenticated = False; break
            contract = _json_load(Path(contract_path))
            bound = next((r["text"].encode() for r in contract.get("replay_payloads", [])
                          if r["path"] == "scripts/run_input0_numeric.py"), None)
            if bound != payload:
                authenticated = False; break
        if not authenticated:
            continue
        script_digest = hashlib.sha256(payloads[0]).hexdigest()
        def permit(index, proof):
            if left[index] != right[index]:
                permitted[("result.json", block, "argv", index)] = {
                    "reference": left[index], "candidate": right[index],
                    "bound_numeric_script_sha256": script_digest, "proof": proof}
        permit(1, "numeric script exact bytes match both bound replay payloads")
        for index, value in enumerate(left[:-1]):
            if value not in {"--artifact-root", "--reference-root", "--llama-harness"} or right[index] != value:
                continue
            a, b = Path(left[index+1]), Path(right[index+1])
            if value == "--artifact-root":
                if a.is_dir() and b.is_dir() and (a / ".work").is_dir() and (a / ".work").resolve() == (b / ".work").resolve():
                    permit(index+1, "identical numeric script; .work resource root resolves to " + str((a / ".work").resolve()))
            elif a.exists() and b.exists() and a.resolve() == b.resolve():
                permit(index+1, "same resource resolves to " + str(a.resolve()))
    return permitted


def _compare_check(
    name: str,
    reference: Any,
    candidate: Any,
    base_tokens: Sequence[Any],
    reference_cell: CellArtifacts,
    candidate_cell: CellArtifacts,
) -> tuple[dict[str, Any], DifferenceComparator]:
    input_verified = _input_bindings_match(reference_cell, candidate_cell)
    comparator = DifferenceComparator(
        reference_cell.root, reference_cell.raw_root,
        candidate_cell.root, candidate_cell.raw_root,
        reference_input_root=reference_cell.input_root,
        candidate_input_root=candidate_cell.input_root,
        workload=reference_cell.workload if input_verified else candidate_cell.workload,
        input_paths_verified=input_verified,
        reference_pins=reference_cell.pin_aliases,
        candidate_pins=candidate_cell.pin_aliases,
        verified_numeric_paths=verified_numeric_runtime_paths(reference_cell, candidate_cell)
            if base_tokens == ["result.json"] else {},
    )
    comparator.compare(reference, candidate, base_tokens)
    status = "pass" if comparator.mismatch_count == 0 else "fail"
    return _check(
        name, status,
        len(reference) if isinstance(reference, (list, dict)) else None,
        len(candidate) if isinstance(candidate, (list, dict)) else None,
        comparator.mismatch_count, comparator.mismatches,
        comparator.allowed_counts,
    ), comparator


def _add_optional_check(
    checks: list[dict[str, Any]], comparators: list[DifferenceComparator], name: str,
    reference: Any, candidate: Any, base_tokens: Sequence[Any],
    reference_cell: CellArtifacts, candidate_cell: CellArtifacts, reference_label: str,
    candidate_label: str,
) -> None:
    if reference is None or candidate is None:
        if reference is None and candidate is None:
            note = "optional evidence absent from both cells"
        else:
            note = f"optional evidence is one-sided (reference={reference_label}, candidate={candidate_label}); skipped"
        checks.append(_check(name, "skipped", note=note))
        return
    item, comparator = _compare_check(name, reference, candidate, base_tokens, reference_cell, candidate_cell)
    checks.append(item)
    comparators.append(comparator)


def _validate_cardinality(
    cell: CellArtifacts, side: str, checks: list[dict[str, Any]],
) -> None:
    expected_roles = cell.summary.get("required_control_roles", ["identity", "search_anchor"])
    roles = [row.get("control_role") for row in cell.stage_controls if isinstance(row, dict)]
    selection_ranks = [row.get("rank") for row in cell.top5_selections]
    problems: list[dict[str, Any]] = []
    if len(cell.top5_selections) != 5:
        problems.append({"path": "/search/top5.jsonl/selection_count", "expected": 5, "actual": len(cell.top5_selections)})
    if selection_ranks != list(range(5)):
        problems.append({"path": "/search/top5.jsonl/selection_ranks", "expected": list(range(5)), "actual": selection_ranks})
    if len(cell.stage_controls) != 2:
        problems.append({"path": "/search/controls.jsonl/control_count", "expected": 2, "actual": len(cell.stage_controls)})
    if isinstance(expected_roles, list) and roles != expected_roles:
        problems.append({"path": "/search/controls.jsonl/control_roles", "expected": expected_roles, "actual": roles})
    checks.append(_check(
        f"{side}_shortlist_cardinality", "fail" if problems else "pass",
        {"top5": len(cell.top5_selections), "controls": len(cell.stage_controls)},
        {"expected_top5": 5, "expected_controls": 2},
        len(problems), problems,
    ))


def _merge_allowed(comparators: Sequence[DifferenceComparator]) -> dict[str, Any]:
    counts = {name: 0 for name in ALLOWED_DIFFERENCES}
    examples: dict[str, list[str]] = {name: [] for name in ALLOWED_DIFFERENCES}
    observed_values: dict[str, list[dict[str, Any]]] = {name: [] for name in ALLOWED_DIFFERENCES}
    for comparator in comparators:
        for name, count in comparator.allowed_counts.items():
            counts[name] += count
            for example in comparator.allowed_examples[name]:
                if len(examples[name]) < 20 and example not in examples[name]:
                    examples[name].append(example)
            for item in comparator.allowed_values[name]:
                if len(observed_values[name]) < 100:
                    observed_values[name].append(item)
    return {
        name: {
            "policy": policy,
            "observed_count": counts[name],
            "example_paths": examples[name],
            **({"observed_values": observed_values[name]} if name == "checkpoint_write_period" else {}),
        }
        for name, policy in ALLOWED_DIFFERENCES.items()
    }


def _run_comparison(reference: CellArtifacts, candidate: CellArtifacts) -> dict[str, Any]:
    checks: list[dict[str, Any]] = []
    comparators: list[DifferenceComparator] = []

    input_match = _input_bindings_match(reference, candidate)
    input_details = {
        "reference": reference.input_binding_status(),
        "candidate": candidate.input_binding_status(),
    }
    input_problems: list[dict[str, Any]] = []
    if reference.workload != candidate.workload:
        input_problems.append({"path": "/workload", "reference": reference.workload, "candidate": candidate.workload})
    if reference.input_manifest is None or candidate.input_manifest is None:
        input_problems.append({"path": "/inputs", "reason": "per-workload input tree is missing or contains an escaping symlink"})
    elif reference.input_manifest != candidate.input_manifest:
        input_problems.append({
            "path": "/inputs/tree_sha256",
            "reference": _manifest_sha256(reference.input_manifest),
            "candidate": _manifest_sha256(candidate.input_manifest),
            "reason": "input file names, sizes, or SHA-256 values differ",
        })
    input_problems.extend({"path": f"/reference/{index}", "reason": error} for index, error in enumerate(reference.input_binding_errors))
    input_problems.extend({"path": f"/candidate/{index}", "reason": error} for index, error in enumerate(candidate.input_binding_errors))
    checks.append(_check(
        "input_binding", "pass" if input_match else "fail",
        input_details["reference"], input_details["candidate"],
        len(input_problems), input_problems,
        note="input paths normalize only after this per-workload content binding passes",
    ))

    expected_pin_roles = {"optimizer", "source_contract"}
    binding_present = reference.binding is not None or candidate.binding is not None
    if binding_present:
        pin_problems: list[dict[str, Any]] = []
        for side, cell in (("reference", reference), ("candidate", candidate)):
            missing = sorted(expected_pin_roles - set(cell.pin_roles))
            if missing:
                pin_problems.append({"path": f"/{side}/roles", "missing": missing})
            pin_problems.extend({"path": f"/{side}/{index}", "reason": error} for index, error in enumerate(cell.pin_binding_errors))
            for role in sorted(expected_pin_roles & set(cell.pin_roles)):
                if not cell.pin_roles[role].get("verified"):
                    pin_problems.append({"path": f"/{side}/{role}", "reason": "recorded pin failed local SHA-256/size validation"})
        checks.append(_check(
            "pinned_build_bindings", "fail" if pin_problems else "pass",
            {side: sorted(cell.pin_roles) for side, cell in (("reference", reference), ("candidate", candidate))},
            sorted(expected_pin_roles), len(pin_problems), pin_problems,
            note="compiler and source-contract paths normalize only when their exact recorded pin roles verify",
        ))
    else:
        checks.append(_check("pinned_build_bindings", "skipped", note="no comparison-binding.json in either cell"))

    required_pairs = [
        ("search_summary", reference.summary, candidate.summary, ["search", "search-summary.json"]),
        ("action_attempts", reference.traces["action_attempts"], candidate.traces["action_attempts"], ["search", "action-attempts.jsonl"]),
        ("action_frontiers", reference.traces["action_frontiers"], candidate.traces["action_frontiers"], ["search", "action-frontiers.jsonl"]),
        ("budget_trace", reference.traces["budget_trace"], candidate.traces["budget_trace"], ["search", "budget-trace.jsonl"]),
        ("global_top5_records", reference.global_top5, candidate.global_top5, ["search", "top5.jsonl"]),
        ("stage_controls", reference.stage_controls, candidate.stage_controls, ["search", "controls.jsonl"]),
    ]
    for name, ref_value, cand_value, path in required_pairs:
        item, comparator = _compare_check(name, ref_value, cand_value, path, reference, candidate)
        checks.append(item)
        comparators.append(comparator)

    _validate_cardinality(reference, "reference", checks)
    _validate_cardinality(candidate, "candidate", checks)

    ref_batches = reference.counts()["action_attempt_batch_size_128"]
    cand_batches = candidate.counts()["action_attempt_batch_size_128"]
    boundaries_match = ref_batches == cand_batches
    checks.append(_check(
        "action_attempt_128_boundaries", "pass" if boundaries_match else "fail",
        ref_batches, cand_batches,
        0 if boundaries_match else 1,
        [] if boundaries_match else [{
            "path": "/search/action-attempts.jsonl/derived_batch_boundaries",
            "reference": ref_batches, "candidate": cand_batches,
            "reason": "attempt stream is partitioned into ordered 128-action chunks plus a final partial chunk",
        }],
    ))

    _add_optional_check(
        checks, comparators, "predictor_cache_entries", reference.predictor_cache,
        candidate.predictor_cache, ["predictor-cache.json"], reference, candidate,
        "present" if reference.predictor_cache is not None else "absent",
        "present" if candidate.predictor_cache is not None else "absent",
    )
    _add_optional_check(
        checks, comparators, "mapper_ii_evidence", reference.mapper_ii,
        candidate.mapper_ii, ["mapper-ii-evidence.json"], reference, candidate,
        "present" if reference.mapper_ii is not None else "absent",
        "present" if candidate.mapper_ii is not None else "absent",
    )
    _add_optional_check(
        checks, comparators, "comparison_summary_and_validation", reference.comparison_summary,
        candidate.comparison_summary, ["comparison-summary.json"], reference, candidate,
        "present" if reference.comparison_summary is not None else "absent",
        "present" if candidate.comparison_summary is not None else "absent",
    )

    # Compare completed summaries only when both sides have the same evidence level.
    if reference.result is not None and candidate.result is not None and reference.has_numeric_evidence == candidate.has_numeric_evidence:
        item, comparator = _compare_check(
            "completed_result_summary", reference.result, candidate.result,
            ["result.json"], reference, candidate,
        )
        checks.append(item)
        comparators.append(comparator)
    else:
        if reference.result is None and candidate.result is None:
            note = "no combined result.json in either cell"
        elif reference.has_numeric_evidence != candidate.has_numeric_evidence:
            note = "reference and candidate have different result-completion levels; compare shared search traces and rank-scoped evidence only"
        else:
            note = "combined result.json is one-sided"
        checks.append(_check("completed_result_summary", "skipped", note=note))

    numeric_specs = [
        ("native_top5_results", reference.native_results, candidate.native_results, ["native-top5", "results"]),
        ("native_control_results", reference.native_controls, candidate.native_controls, ["native-controls", "results"]),
        ("numeric_top5_results", reference.numeric_top5, candidate.numeric_top5, ["numeric", "top5", "results"]),
        ("numeric_control_results", reference.numeric_controls, candidate.numeric_controls, ["numeric", "controls", "results"]),
        ("mapper_call_audits", _flatten_mapper_audits(reference), _flatten_mapper_audits(candidate), ["mapper-call-audits", "flattened-semantic-rows"]),
    ]
    for name, ref_value, cand_value, base_path in numeric_specs:
        _add_optional_check(
            checks, comparators, name,
            ref_value if ref_value else None,
            cand_value if cand_value else None,
            base_path, reference, candidate,
            f"{len(ref_value)} records" if ref_value else "absent",
            f"{len(cand_value)} records" if cand_value else "absent",
        )

    if reference.candidate_ir_entries is None and candidate.candidate_ir_entries is None:
        checks.append(_check("materialized_candidate_ir", "skipped", note="search/candidates/*.mlir absent from both cells"))
    elif reference.candidate_ir_entries is None or candidate.candidate_ir_entries is None:
        checks.append(_check("materialized_candidate_ir", "fail", mismatch_count=1, mismatches=[{
            "path": "/search/candidates",
            "reference": "present" if reference.candidate_ir_entries is not None else "absent",
            "candidate": "present" if candidate.candidate_ir_entries is not None else "absent",
        }]))
    else:
        item, comparator = _compare_check(
            "materialized_candidate_ir", reference.candidate_ir_entries,
            candidate.candidate_ir_entries, ["search", "candidates"], reference, candidate,
        )
        checks.append(item)
        comparators.append(comparator)

    mapping_cache_has_native = bool(reference.native_results or reference.native_controls or candidate.native_results or candidate.native_controls)
    mapping_cache_problems: list[dict[str, Any]] = []
    if mapping_cache_has_native or reference.mapping_cache_present or candidate.mapping_cache_present:
        if not reference.mapping_cache_present or not candidate.mapping_cache_present:
            mapping_cache_problems.append({
                "path": "/mapping-cache",
                "reference": "present" if reference.mapping_cache_present else "absent",
                "candidate": "present" if candidate.mapping_cache_present else "absent",
            })
        mapping_cache_problems.extend({"path": f"/reference/{i}", "reason": error} for i, error in enumerate(reference.mapping_cache_errors))
        mapping_cache_problems.extend({"path": f"/candidate/{i}", "reason": error} for i, error in enumerate(candidate.mapping_cache_errors))
        if reference.mapping_cache_entries != candidate.mapping_cache_entries:
            mapping_cache_problems.append({
                "path": "/mapping-cache/input-and-output-sha256-multiset",
                "reference_count": len(reference.mapping_cache_entries),
                "candidate_count": len(candidate.mapping_cache_entries),
                "reason": "wrapper-input SHA-256 keys or corresponding mapped.mlir SHA-256 values differ",
            })
        mapping_status = "fail" if mapping_cache_problems else "pass"
        checks.append(_check(
            "mapper_cache_semantic_entries", mapping_status,
            len(reference.mapping_cache_entries), len(candidate.mapping_cache_entries),
            len(mapping_cache_problems), mapping_cache_problems,
            note="entries are sorted by full input.txt byte SHA-256; each mapped.mlir byte SHA-256 is compared for that exact key",
        ))
    else:
        checks.append(_check("mapper_cache_semantic_entries", "skipped", note="no native records or mapping-cache directory in either cell"))

    attribution = _parallel_attribution_report(reference, candidate)
    if attribution["reference_record_count"] == 0 and attribution["candidate_record_count"] == 0:
        checks.append(_check("parallel_mapper_aggregate_totals", "skipped", note="native result records absent from both cells"))
    else:
        aggregate_problems: list[dict[str, Any]] = []
        for side in ("reference", "candidate"):
            if attribution[f"{side}_record_count"] != 7:
                aggregate_problems.append({
                    "path": f"/{side}/native-record-count",
                    "expected": 7,
                    "actual": attribution[f"{side}_record_count"],
                })
            aggregate_problems.extend(attribution[f"{side}_counter_errors"])
        for side, cell in (("reference", reference), ("candidate", candidate)):
            if cell.mapping_cache_present and not cell.mapping_cache_errors:
                entries = len(cell.mapping_cache_entries)
                totals = attribution[f"{side}_totals"] or {}
                if totals.get("actual_mapper_calls") != entries:
                    aggregate_problems.append({
                        "path": f"/{side}/actual_mapper_calls-vs-mapping-cache-entries",
                        "actual_mapper_calls": totals.get("actual_mapper_calls"),
                        "mapping_cache_entries": entries,
                    })
                if totals.get("mapper_cache_misses") != entries:
                    aggregate_problems.append({
                        "path": f"/{side}/mapper_cache_misses-vs-mapping-cache-entries",
                        "mapper_cache_misses": totals.get("mapper_cache_misses"),
                        "mapping_cache_entries": entries,
                    })
            else:
                aggregate_problems.append({
                    "path": f"/{side}/mapping-cache",
                    "reason": "completed native results require readable mapper-cache input/output evidence",
                })
        if attribution["reference_totals"] != attribution["candidate_totals"]:
            aggregate_problems.append({
                "path": "/aggregate-mapper-attribution-totals",
                "reference": attribution["reference_totals"],
                "candidate": attribution["candidate_totals"],
                "reason": "mapper calls, cache hits, and cache misses must match in aggregate across five shortlist plus two control records",
            })
        checks.append(_check(
            "parallel_mapper_aggregate_totals", "fail" if aggregate_problems else "pass",
            attribution["reference_totals"], attribution["candidate_totals"],
            len(aggregate_problems), aggregate_problems,
            note="per-rank attribution may move across parallel jobs; these three totals remain strict",
        ))

    check_status = {item["name"]: item["status"] for item in checks}
    attribution["accepted"] = bool(
        attribution["accepted"]
        and check_status.get("mapper_cache_semantic_entries") == "pass"
        and check_status.get("mapper_call_audits") == "pass"
    )

    failed = any(item["status"] == "fail" for item in checks)
    ref_counts = reference.counts()
    cand_counts = candidate.counts()
    return {
        "schema": CHECKER_SCHEMA,
        "equivalent": not failed,
        "reference_cell": reference.raw_root,
        "candidate_cell": candidate.raw_root,
        "checks": checks,
        "counts": {"reference": ref_counts, "candidate": cand_counts},
        "permitted_differences": _merge_allowed(comparators),
        "input_binding": input_details,
        "pinned_build_roles": {
            "reference": reference.pin_roles,
            "candidate": candidate.pin_roles,
        },
        "accepted_parallel_cache_attribution": attribution,
        "mapper_cache_evidence": {
            "reference_present": reference.mapping_cache_present,
            "candidate_present": candidate.mapping_cache_present,
            "reference_entries": reference.mapping_cache_entries,
            "candidate_entries": candidate.mapping_cache_entries,
            "input_and_mapped_sha_multisets_equal": reference.mapping_cache_entries == candidate.mapping_cache_entries,
        },
        "materialized_candidate_ir": {
            "reference": reference.candidate_ir_entries,
            "candidate": candidate.candidate_ir_entries,
            "equal": reference.candidate_ir_entries == candidate.candidate_ir_entries,
        },
        "notes": [
            "JSON object key order is ignored; JSONL record order and list order are significant.",
            "Action batch boundaries are derived from the complete ordered action-attempt stream in 128-record chunks.",
            "When both cells include native or numeric evidence, rank, candidate ID, cycles, validation outcomes, and pass counts are compared; mapper call/cache counters are strict in aggregate across all seven native records.",
            "Mapper cache entries are compared by the complete input.txt byte SHA-256 key and mapped.mlir byte SHA-256 value, independent of parallel task-N registration order.",
            "Mapper-call-audit candidate IDs are reported as parallel ownership attribution; all other audit row fields remain strict across the flattened multiset.",
            "Predictor cache contents and feature/query counters are strict whenever predictor-cache.json is present on both sides.",
        ],
    }


def _write_output(path: str, value: Mapping[str, Any]) -> None:
    output = Path(path).expanduser()
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(value, indent=2, sort_keys=True, ensure_ascii=False) + "\n", encoding="utf-8")


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--reference-cell", required=True, help="directory containing the reference search cell")
    parser.add_argument("--candidate-cell", required=True, help="directory containing the optimized search cell")
    parser.add_argument("--output", required=True, help="path for the comparison JSON report")
    args = parser.parse_args(argv)

    try:
        reference = CellArtifacts(args.reference_cell)
        candidate = CellArtifacts(args.candidate_cell)
        report = _run_comparison(reference, candidate)
    except InputError as exc:
        report = {
            "schema": CHECKER_SCHEMA,
            "equivalent": False,
            "reference_cell": args.reference_cell,
            "candidate_cell": args.candidate_cell,
            "checks": [_check("input_validation", "fail", mismatch_count=1,
                               mismatches=[{"path": "/", "reason": str(exc)}])],
            "counts": {},
            "permitted_differences": _merge_allowed([]),
        }
    try:
        _write_output(args.output, report)
    except OSError as exc:
        print(f"cannot write report {args.output}: {exc}", file=sys.stderr)
        return 2

    print(json.dumps({
        "equivalent": report["equivalent"],
        "output": args.output,
        "failed_checks": [item["name"] for item in report["checks"] if item["status"] == "fail"],
    }, sort_keys=True))
    return 0 if report["equivalent"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
