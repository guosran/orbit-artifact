#!/usr/bin/env python3
"""Replay captured original-AMOEBA input-0 decisions through native retiming.

This driver consumes the original full-flow orchestration, archived mapper
profiles, and body exports. It does not invoke a mapper or modify the source
artifacts. For each workload it runs the C++ profile-cost adapter, the C++
fixed-decision retimer, the independent fixed-trace validator, and the
existing full-program input-0 numeric gate in sequence. Each workload gets an
isolated output directory and an atomic result record.

For Harris and Radar, ``--caller-shape-import-root`` can point at completed
C++ caller-allocation proof, exact memref-shape binding, adapter, retimer, and
validator outputs. The driver verifies that recorded chain and runs only the
numeric gate; it does not remap or rerun the adapter/retimer. The numeric copy
gets an isolated C++ ``lower-affine`` legalization because host lowering does
not accept ``affine.apply`` in these traces.

Retimed successes remain diagnostic: iteration-domain coverage is pending,
formal_go is false, and this script never writes mapper_replay_verified.
Current adapter/retimer rejection of multi-replica source schedules is
preserved with the actual compiler diagnostic; no allocator fallback or
duration division is applied.

There is deliberately no subprocess timeout and no retry loop. The caller can
constrain CPU affinity externally; this driver runs one workload at a time.
"""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time
from typing import Any, Sequence


APPLICATIONS = ("llama", "lu", "harris", "radar", "gcn", "raytracing")
DEFAULT_SOURCE_REPOSITORY = "git@github.com:guosran/amoeba.git"
DEFAULT_SOURCE_COMMIT = "a57376e7043b1681e64e7169c5a8cb02eb192331"
DEFAULT_ARCHITECTURE_CONTRACT = (
    "neura-architecture-v1:amoeba_4x4_full_mesh_context12"
)
DEFAULT_NUMERIC_STAGE = "original-amoeba-fixed-retiming"
ROOT = Path(__file__).resolve().parents[1]


def atomic_bytes(path: Path, payload: bytes) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.partial-{os.getpid()}")
    try:
        temporary.write_bytes(payload)
        os.replace(temporary, path)
    finally:
        try:
            temporary.unlink()
        except FileNotFoundError:
            pass


def atomic_json(path: Path, value: Any) -> None:
    atomic_bytes(path, (json.dumps(value, indent=2, sort_keys=True) + "\n").encode())


def atomic_text(path: Path, value: str) -> None:
    atomic_bytes(path, value.encode())


def atomic_symlink(target: Path, link_path: Path) -> None:
    link_path.parent.mkdir(parents=True, exist_ok=True)
    temporary = link_path.with_name(f".{link_path.name}.partial-{os.getpid()}")
    try:
        temporary.symlink_to(target)
        os.replace(temporary, link_path)
    finally:
        try:
            temporary.unlink()
        except FileNotFoundError:
            pass


def read_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text())
    if not isinstance(value, dict):
        raise ValueError(f"expected a JSON object in {path}")
    return value


def path_from(value: Path | None, *, base: Path, default: Path | None = None) -> Path | None:
    if value is None:
        value = default
    if value is None:
        return None
    return (value if value.is_absolute() else base / value).resolve()


def capture_byte_witnesses(
    entries: dict[str, Path], witness_root: Path
) -> dict[str, str]:
    """Save exact serialized bytes so later stages can check byte equality."""
    witness_root.mkdir(parents=True, exist_ok=False)
    witnesses: dict[str, str] = {}
    for name, source in entries.items():
        if not source.is_file():
            raise ValueError(f"cannot capture byte witness; missing input: {source}")
        suffix = source.suffix or ".bytes"
        witness = witness_root / f"{name}{suffix}"
        atomic_bytes(witness, source.read_bytes())
        witnesses[name] = str(witness)
    return witnesses


def byte_witnesses_match(entries: dict[str, Path], witnesses: dict[str, str]) -> bool:
    if set(entries) != set(witnesses):
        return False
    for name, source in entries.items():
        witness = Path(witnesses[name])
        if not source.is_file() or not witness.is_file():
            return False
        if source.read_bytes() != witness.read_bytes():
            return False
    return True


def active_replica_inventory(ir_path: Path) -> dict[str, int]:
    """Read active replica counts from each task's final orchestration attrs."""
    inventory: dict[str, int] = {}
    for line_number, line in enumerate(ir_path.read_text().splitlines(), 1):
        if "}) {active_replicas =" not in line:
            continue
        active = re.search(r"\}\) \{active_replicas = ([0-9]+) : i32", line)
        task = re.search(r'task_name = "([^"]+)"', line)
        if active is None or task is None:
            raise ValueError(
                f"{ir_path}:{line_number}: malformed task replica metadata"
            )
        name = task.group(1)
        if name in inventory:
            raise ValueError(f"{ir_path}:{line_number}: duplicate task {name}")
        inventory[name] = int(active.group(1))
    if not inventory:
        raise ValueError(f"no task active_replicas metadata found in {ir_path}")
    return inventory


def historical_pipeline_interval(ir_path: Path) -> int | None:
    match = re.search(
        r'task_orchestration_summary\s*=\s*\{[^}]*pipeline_interval\s*=\s*([0-9]+)\s*: i64',
        ir_path.read_text(),
    )
    return int(match.group(1)) if match else None


def path_has_spaces(paths: Sequence[Path | str]) -> bool:
    return any(any(char.isspace() for char in str(path)) for path in paths)


def diagnostic_excerpt(output: str, *, limit: int = 4096) -> str:
    """Keep actionable compiler errors in JSON while leaving full logs on disk."""
    errors = [line.strip() for line in output.splitlines() if re.search(r"\berror:", line)]
    if errors:
        excerpt = "\n".join(errors[:8])
    else:
        excerpt = "\n".join(line.strip() for line in output.splitlines()[-12:])
    if len(excerpt) > limit:
        excerpt = excerpt[: limit - 3] + "..."
    return excerpt


def pass_command(
    optimizer: Path,
    architecture: Path,
    input_ir: Path,
    pass_name: str,
    options: dict[str, str],
    output_ir: Path,
) -> list[str]:
    option_text = " ".join(f"{key}={value}" for key, value in options.items())
    return [
        str(optimizer),
        str(input_ir),
        "--verify-each",
        f"--architecture-spec={architecture}",
        f"--{pass_name}={option_text}",
        "-o",
        str(output_ir),
    ]


def adapter_options(
    *,
    function: str,
    body_proof: Path,
    profiles: Path,
    model_dir: Path,
    architecture: Path,
    architecture_contract: str,
    source_repository: str,
    source_commit: str,
    costs: Path,
) -> dict[str, str]:
    return {
        "function": function,
        "body-export-file": str(body_proof),
        "profile-file": str(profiles),
        "ensemble-file": str(model_dir / "ensemble.json"),
        "checkpoint-dir": str(model_dir),
        "architecture-contract": architecture_contract,
        "architecture-path": str(architecture),
        "source-git-repository": source_repository,
        "source-git-commit": source_commit,
        "output": str(costs),
    }


def retimer_options(function: str, costs: Path, body_proof: Path, result: Path) -> dict[str, str]:
    return {
        "function": function,
        "parent-cost-file": str(costs),
        "profile-body-export-file": str(body_proof),
        "output": str(result),
    }


def run_command(argv: list[str], log_path: Path, *, cwd: Path) -> dict[str, Any]:
    """Run once without a timeout; retain complete merged stdout/stderr."""
    began = time.monotonic()
    try:
        completed = subprocess.run(
            argv,
            cwd=cwd,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            check=False,
        )
    except OSError as error:
        diagnostic = str(error)
        atomic_text(log_path, diagnostic + "\n")
        return {
            "argv": argv,
            "elapsed_seconds": time.monotonic() - began,
            "exit_code": None,
            "log": str(log_path),
            "diagnostic": diagnostic,
        }

    output = completed.stdout or ""
    atomic_text(log_path, output)
    record: dict[str, Any] = {
        "argv": argv,
        "elapsed_seconds": time.monotonic() - began,
        "exit_code": completed.returncode,
        "log": str(log_path),
    }
    if completed.returncode != 0:
        # The per-stage log retains complete stdout/stderr, including any
        # operation dump. Keep result.json compact and surface the actual
        # compiler diagnostic line instead of a generic failure label.
        record["diagnostic"] = diagnostic_excerpt(output)
    return record


def verify_adapter_catalog(path: Path, task_count: int) -> tuple[bool, bool, str]:
    """Return (profile_success, body_equality, diagnostic) without upgrading GO."""
    if not path.is_file():
        return False, False, "C++ adapter did not publish its cost catalog"
    try:
        catalog = read_json(path)
    except (OSError, json.JSONDecodeError, ValueError) as error:
        return False, False, f"C++ adapter cost catalog is unreadable: {error}"
    binding = catalog.get("original_amoeba_profile_binding")
    metadata = catalog.get("predictor_metadata")
    tasks = binding.get("tasks") if isinstance(binding, dict) else None
    if not isinstance(tasks, list) or len(tasks) != task_count:
        return False, False, "C++ adapter catalog does not bind every original task"
    profile_success = all(row.get("mapper_succeeded") is True for row in tasks if isinstance(row, dict)) and all(
        isinstance(row, dict) for row in tasks
    )
    body_equality = (
        isinstance(binding, dict)
        and binding.get("current_ir_body_equivalence_verified") is True
        and isinstance(metadata, dict)
        and metadata.get("body_equivalence_checked") is True
    )
    if not profile_success:
        return False, body_equality, "one or more archived selected-shape mapper profiles lack explicit success"
    if not body_equality:
        return True, False, "C++ adapter catalog omitted normalized current-IR body equality"
    if metadata.get("iteration_domain_coverage_status") != "pending" or metadata.get(
        "iteration_domain_coverage_verified"
    ) is not False:
        return True, True, "C++ adapter catalog overstated iteration-domain coverage"
    return True, True, ""


def verify_adapter_exact_task_bindings(
    path: Path, expected_tasks: Sequence[str]
) -> tuple[bool, str]:
    """Require complete C++ task/body signatures for each saved profile binding."""
    try:
        catalog = read_json(path)
    except (OSError, json.JSONDecodeError, ValueError) as error:
        return False, f"C++ adapter signature catalog is unreadable: {error}"
    binding = catalog.get("original_amoeba_profile_binding")
    rows = binding.get("tasks") if isinstance(binding, dict) else None
    if not isinstance(binding, dict) or binding.get("schema") != "amoeba-original-profile-body-binding-v1":
        return False, "C++ adapter catalog lacks the original profile/body binding schema"
    if binding.get("current_ir_body_equivalence_verified") is not True:
        return False, "C++ adapter catalog did not verify current-IR body equivalence"
    if not isinstance(rows, list) or len(rows) != len(expected_tasks):
        return False, "C++ adapter catalog task count differs from the original schedule"
    names = [row.get("task") for row in rows if isinstance(row, dict)]
    if len(names) != len(rows) or names != list(expected_tasks):
        return False, "C++ adapter catalog task order/names differ from the original schedule"
    signature_fields = (
        "task_signature",
        "counter_signature",
        "kernel_binding_signature",
        "normalized_mapper_body",
    )
    for row in rows:
        if row.get("mapper_succeeded") is not True:
            return False, f"C++ adapter catalog lacks explicit mapper success for {row.get('task')}"
        missing = [field for field in signature_fields if not isinstance(row.get(field), str) or not row[field]]
        if missing:
            return False, f"C++ adapter catalog lacks exact signatures for {row.get('task')}: {', '.join(missing)}"
    return True, ""


def make_numeric_view(native_ir: Path, view_root: Path) -> Path:
    """Provide the exact retimed bytes at run_input0_numeric's rank-0 path."""
    rank_directory = view_root / "rank-0"
    rank_directory.mkdir(parents=True, exist_ok=False)
    alias = rank_directory / "native.mlir"
    relative_target = Path(os.path.relpath(native_ir, rank_directory))
    atomic_symlink(relative_target, alias)
    return view_root


def validator_command(
    python: Path,
    validator: Path,
    retimed_result: Path,
    original_ir: Path,
    profiles: Path,
    body_proof: Path,
    costs: Path,
    output: Path,
) -> list[str]:
    return [
        str(python),
        str(validator),
        "--retimed",
        str(retimed_result),
        "--original-mlir",
        str(original_ir),
        "--profile-file",
        str(profiles),
        "--body-proof",
        str(body_proof),
        "--cost-catalog",
        str(costs),
        "--output",
        str(output),
    ]


def numeric_command(
    *,
    python: Path,
    numeric_runner: Path,
    workload: str,
    artifact_root: Path,
    production_root: Path,
    output_root: Path,
    native_root: Path,
    optimizer: Path,
    llvm_build: Path,
    reference_root: Path,
    llama_harness: Path,
) -> list[str]:
    command = [
        str(python),
        str(numeric_runner),
        "--workloads",
        workload,
        "--stage",
        DEFAULT_NUMERIC_STAGE,
        "--ranks",
        "0",
        "--native-root",
        str(native_root),
        "--jobs",
        "1",
        "--artifact-root",
        str(artifact_root),
        "--output-root",
        str(output_root),
        "--production-root",
        str(production_root),
        "--optimizer",
        str(optimizer),
        "--llvm-build",
        str(llvm_build),
        "--reference-root",
        str(reference_root),
    ]
    if llama_harness.is_file():
        command.extend(("--llama-harness", str(llama_harness)))
    return command


def app_paths(input_root: Path, output_root: Path, app: str) -> dict[str, Path]:
    source = input_root / app
    target = output_root / app
    return {
        "source_root": source,
        "orchestrated_ir": source / "orchestrated.mlir",
        "body_proof": source / "static-body-proof.json",
        "profiles": source / "task-profiles.json",
        "result": target / "result.json",
        "target_root": target,
        "adapter_root": target / "adapter",
        "cost_catalog": target / "adapter" / "costs.json",
        "adapter_ir": target / "adapter" / "adapter.mlir",
        "retimed_root": target / "retimed",
        "retimed_ir": target / "retimed" / "native.mlir",
        "retimed_result": target / "retimed" / "result.json",
        "validation_root": target / "validation",
        "validation_result": target / "validation" / "result.json",
        "numeric_view": target / "numeric-input",
        "numeric_output": target / "numeric",
    }


def base_record(app: str, paths: dict[str, Path], artifact_root: Path) -> dict[str, Any]:
    original = paths["orchestrated_ir"]
    record: dict[str, Any] = {
        "schema": "orbit-original-amoeba-native-baseline-v1",
        "workload": app,
        "source_orchestration": str(original),
        "output_root": str(paths["target_root"]),
        "formal_go": False,
        "iteration_domain_coverage_status": "pending",
        "iteration_domain_coverage_verified": False,
        "mapper_replay_claim": "not_claimed",
        "archived_mapper_profile_success_status": "not_run",
        "profile_body_equality_status": "not_run",
        "fixed_retiming_status": "not_run",
        "independent_trace_status": "not_run",
        "numeric_status": "not_run",
        "commands": {},
        "cpp_diagnostics": [],
        "input_bindings": {
            "orchestrated_mlir": str(original),
            "body_proof": str(paths["body_proof"]),
            "task_profiles": str(paths["profiles"]),
            "comparison": "exact serialized byte equality",
        },
    }
    if original.is_file():
        inventory = active_replica_inventory(original)
        record["task_count"] = len(inventory)
        record["active_replica_counts"] = inventory
        record["multi_replica_tasks"] = {
            task: count for task, count in inventory.items() if count > 1
        }
        record["historical_pipeline_interval"] = {
            "value": historical_pipeline_interval(original),
            "unit": "original-throughput-profiled-cycles",
            "source": "task_orchestration_summary.pipeline_interval",
        }
    record["artifact_root"] = str(artifact_root)
    return record


def unsupported_replica_record(record: dict[str, Any], message: str) -> None:
    record.update(
        status="unsupported_unproven",
        original_replica_materialization_status="unsupported",
        unsupported_reason=(
            "the original schedule has active_replicas > 1, while this native "
            "baseline has no verified per-replica input-domain materialization"
        ),
        diagnostic_summary=message.strip(),
    )


def is_replica_support_diagnostic(message: str) -> bool:
    return (
        "original selected shape/profile/replica evidence is missing or unsupported"
        in message
        or "active_replicas is not 1; shard materialization is unsupported" in message
        or "shard materialization is unsupported" in message
    )


def check_final_cpp_result(path: Path) -> tuple[bool, bool, str]:
    if not path.is_file():
        return False, False, "C++ retimer did not publish its diagnostic result"
    try:
        result = read_json(path)
    except (OSError, json.JSONDecodeError, ValueError) as error:
        return False, False, f"C++ retimer result is unreadable: {error}"
    body_equal = (
        result.get("selected_profile_body_binding_verified") is True
        and result.get("body_equivalence_checked") is True
        and result.get("body_equivalence_status")
        == "verified-current-kernel-equals-exported-original-normalized-body"
    )
    safe_diagnostic_status = (
        result.get("formal_go") is False
        and result.get("iteration_domain_coverage_status") == "pending"
        and result.get("iteration_domain_coverage_verified") is False
        and result.get("diagnostic_only") is True
        and result.get("valid") is True
    )
    if any("mapper_replay_verified" in str(key) for key in result):
        return body_equal, False, "C++ retimer result contains a forbidden mapper replay claim"
    if not safe_diagnostic_status:
        return body_equal, False, "C++ retimer result has invalid or overstated diagnostic status"
    return body_equal, body_equal, "" if body_equal else "C++ retimer did not certify exact body equality"


def option_values(argument: str, prefix: str) -> dict[str, str]:
    if not argument.startswith(prefix):
        raise ValueError(f"expected command option {prefix!r}")
    values: dict[str, str] = {}
    for item in argument[len(prefix) :].split(" "):
        if not item:
            continue
        if "=" not in item:
            raise ValueError(f"malformed pass option token {item!r}")
        key, value = item.split("=", 1)
        values[key] = value
    return values


def exact_memref_bindings(argument: str) -> list[tuple[str, int, str]]:
    return [
        (function, int(index), dimensions)
        for function, index, dimensions in re.findall(
            r"bind-exact-memref-shape\{function=([^ ]+) argument=([0-9]+) dimensions=([^}]+)\}",
            argument,
        )
    ]


def verify_caller_shape_import(
    app: str,
    *,
    args: argparse.Namespace,
    paths: dict[str, Path],
) -> tuple[dict[str, Path], dict[str, Any], dict[str, Any], dict[str, Any], Path]:
    """Verify the completed C++ caller-proof/bind/adapter/retimer chain."""
    if app not in {"harris", "radar"}:
        raise ValueError("caller-shape imports are supported only for Harris and Radar")
    if args.caller_shape_import_root is None:
        raise ValueError("caller-shape import root is required for this workload")
    imported = args.caller_shape_import_root / app
    config = args.caller_shape_config_root / app
    source = paths["orchestrated_ir"]
    proof_path = imported / "caller-proof.json"
    shape_input = config / "caller-noalias-proof.json"
    shape_command_path = config / "caller-shapes.command.json"
    required = (
        source,
        paths["body_proof"],
        paths["profiles"],
        proof_path,
        shape_input,
        shape_command_path,
        imported / "after-import.mlir",
        imported / "orchestrated-with-caller-shapes.mlir",
        imported / "costs.json",
        imported / "retimed-native.mlir",
        imported / "retimed-result.json",
        imported / "validation.json",
    )
    missing = [str(path) for path in required if not path.is_file()]
    if missing:
        raise ValueError("caller-shape evidence is incomplete: " + ", ".join(missing))
    if path_has_spaces(
        (*required, args.caller_shape_import_root, args.caller_shape_config_root, args.caller_evidence_root)
    ):
        raise ValueError(f"{app}: caller-shape paths contain whitespace unsupported by the pass-option protocol")

    proof = read_json(proof_path)
    shape_proof = read_json(shape_input)
    if proof.get("schema") != "amoeba.input0-caller-noalias-proof-v2" or proof.get(
        "proof_mode"
    ) != "prepared-external-caller":
        raise ValueError(f"{app}: C++ caller proof has an unexpected schema or proof mode")
    ignored_config_fields = {
        "prepared_input_file_text",
        "prepared_input_path",
        "prepared_function_text",
    }
    if any(
        key not in proof or proof[key] != shape_proof[key]
        for key in shape_proof
        if key not in ignored_config_fields
    ):
        raise ValueError(f"{app}: imported C++ caller proof differs from the per-app shape config")
    function_proof = read_json(paths["body_proof"])
    function = function_proof.get("function")
    shapes = proof.get("logical_shapes")
    if (
        proof.get("target_function") != function
        or proof.get("prepared_input_path") != str(source)
        or proof.get("prepared_input_file_text", "").encode() != source.read_bytes()
        or proof.get("static_bound") != shape_proof.get("static_bound")
        or not isinstance(shapes, list)
        or not shapes
        or len(shapes) != len(shape_proof.get("logical_shapes", []))
    ):
        raise ValueError(f"{app}: caller proof is not bound to the exact original module and inputs")

    caller_path = Path(str(proof.get("caller_evidence_path", ""))).resolve()
    try:
        caller_relative = caller_path.relative_to(args.caller_evidence_root)
    except ValueError as error:
        raise ValueError(f"{app}: caller evidence lies outside --caller-evidence-root") from error
    caller_evidence = args.caller_evidence_root / caller_relative
    if (
        not caller_evidence.is_file()
        or caller_evidence.read_bytes() != proof.get("caller_evidence_file_text", "").encode()
    ):
        raise ValueError(f"{app}: source-owned caller evidence bytes differ from the C++ proof")

    logs = imported / "logs"
    command_paths = {
        "import": logs / "import.command.json",
        "bind": logs / "bind.command.json",
        "adapter": logs / "adapter.command.json",
        "retimer": logs / "retimer.command.json",
    }
    if any(not path.is_file() for path in command_paths.values()):
        raise ValueError(f"{app}: a required C++ stage command record is missing")
    commands = {name: read_json(path)["argv"] for name, path in command_paths.items()}
    for name, argv in commands.items():
        if not isinstance(argv, list) or len(argv) < 5 or argv[0] != str(args.optimizer):
            raise ValueError(f"{app}: recorded {name} command does not use the pinned optimizer")
    after_import = imported / "after-import.mlir"
    annotated = imported / "orchestrated-with-caller-shapes.mlir"
    import_values = option_values(
        commands["import"][3], "--import-input0-caller-noalias="
    )
    expected_import_values = {
        "target": function,
        "caller": proof.get("caller_function"),
        "caller-evidence": str(caller_path),
        "static-bound": str(proof.get("static_bound")),
        "input0-only": "true",
        "prepared-external-caller": "true",
        "prepared-input": str(source),
        "evidence-output": str(proof_path),
        "logical-shapes": ";".join(shapes),
    }
    if (
        commands["import"][1] != str(source)
        or commands["import"][-1] != str(after_import)
        or any(import_values.get(key) != value for key, value in expected_import_values.items())
    ):
        raise ValueError(f"{app}: C++ caller-allocation importer command is not bound to its proof inputs")

    shape_command = read_json(shape_command_path)
    config_bind_argv = shape_command.get("shapes", {}).get("argv", [])
    config_pipeline = next(
        (token.split("=", 1)[1] for token in config_bind_argv if token.startswith("--pass-pipeline=")),
        "",
    )
    actual_pipeline = next(
        (token.split("=", 1)[1] for token in commands["bind"] if token.startswith("--pass-pipeline=")),
        "",
    )
    expected_bindings = [
        (function, argument, dimensions.replace("x", ","))
        for argument, dimensions in enumerate(shapes, 1)
    ]
    if (
        not config_pipeline
        or exact_memref_bindings(config_pipeline) != expected_bindings
        or exact_memref_bindings(actual_pipeline) != expected_bindings
        or commands["bind"][1] != str(after_import)
        or commands["bind"][-1] != str(annotated)
    ):
        raise ValueError(f"{app}: bind-exact-memref-shape command differs from its exact caller proof")

    cost_catalog = imported / "costs.json"
    native_ir = imported / "retimed-native.mlir"
    retimer_result = imported / "retimed-result.json"
    adapter_values = option_values(
        next((token for token in commands["adapter"] if token.startswith("--adapt-original-amoeba-profile-costs=")), ""),
        "--adapt-original-amoeba-profile-costs=",
    )
    retimer_values = option_values(
        next((token for token in commands["retimer"] if token.startswith("--retime-original-amoeba-fixed-decisions=")), ""),
        "--retime-original-amoeba-fixed-decisions=",
    )
    if (
        commands["adapter"][1] != str(annotated)
        or adapter_values.get("body-export-file") != str(paths["body_proof"])
        or adapter_values.get("profile-file") != str(paths["profiles"])
        or adapter_values.get("output") != str(cost_catalog)
        or commands["retimer"][1] != str(annotated)
        or retimer_values.get("parent-cost-file") != str(cost_catalog)
        or retimer_values.get("profile-body-export-file") != str(paths["body_proof"])
        or retimer_values.get("output") != str(retimer_result)
        or commands["retimer"][-1] != str(native_ir)
    ):
        raise ValueError(f"{app}: adapter/retimer commands are not bound to the imported shape module")

    for name in ("import", "bind", "adapter", "retimer"):
        for suffix in ("stderr.log", "stdout.log"):
            log = logs / f"{name}.{suffix}"
            if not log.is_file() or re.search(r"\berror:", log.read_text(errors="replace")):
                raise ValueError(f"{app}: recorded C++ {name} stage log is missing or contains an error")

    task_count = function_proof.get("task_count")
    profile_success, body_equal, catalog_problem = verify_adapter_catalog(cost_catalog, task_count)
    original_inventory = active_replica_inventory(source)
    if any(count != 1 for count in original_inventory.values()):
        raise ValueError(f"{app}: caller-shape numeric replay does not support multi-replica tasks")
    signature_ok, signature_problem = verify_adapter_exact_task_bindings(
        cost_catalog, list(original_inventory)
    )
    catalog = read_json(cost_catalog)
    binding = catalog.get("original_amoeba_profile_binding", {})
    if (
        not profile_success
        or not body_equal
        or not signature_ok
        or binding.get("source_repository") != args.source_repository
        or binding.get("source_commit") != args.source_commit
        or binding.get("architecture_contract") != args.architecture_contract
    ):
        raise ValueError(
            f"{app}: C++ profile/body catalog failed: {catalog_problem or signature_problem}"
        )
    retimer_body_equal, retimer_safe, retimer_problem = check_final_cpp_result(retimer_result)
    final_result = read_json(retimer_result)
    if (
        not native_ir.is_file()
        or not retimer_safe
        or not retimer_body_equal
        or final_result.get("candidate_origin") != "original-amoeba-throughput-guided"
        or final_result.get("cost_catalog_namespace") != catalog.get("namespace")
    ):
        raise ValueError(f"{app}: caller-shape C++ fixed-retiming result failed: {retimer_problem}")
    validation_result = read_json(imported / "validation.json")
    if (
        validation_result.get("schema") != "orbit-original-amoeba-fixed-retiming-validation-v1"
        or validation_result.get("status") != "pass"
        or validation_result.get("formal_go") is not False
        or validation_result.get("iteration_domain_coverage_status") != "pending"
        or validation_result.get("function") != function
        or validation_result.get("task_count") != task_count
    ):
        raise ValueError(f"{app}: existing independent fixed-trace validator record is invalid")

    files = {
        "orchestrated_mlir": source,
        "body_proof": paths["body_proof"],
        "task_profiles": paths["profiles"],
        "caller_shape_config": shape_input,
        "caller_shape_command_config": shape_command_path,
        "caller_evidence": caller_evidence,
        "caller_proof": proof_path,
        "imported_ir": after_import,
        "shape_bound_ir": annotated,
        "cost_catalog": cost_catalog,
        "retimed_native_ir": native_ir,
        "retimed_result": retimer_result,
        "validation_result": imported / "validation.json",
    }
    files.update({f"{name}_command": path for name, path in command_paths.items()})
    return files, proof, catalog, final_result, native_ir


def resume_caller_shape_application(
    app: str,
    *,
    args: argparse.Namespace,
    input_root: Path,
    output_root: Path,
    numeric_runner: Path,
    production_root: Path,
    llvm_build: Path,
    reference_root: Path,
    llama_harness: Path,
) -> dict[str, Any]:
    paths = app_paths(input_root, output_root, app)
    record = read_json(paths["result"]) if paths["result"].is_file() else base_record(
        app, paths, args.artifact_root
    )
    imported_files, caller_proof, catalog, retimed_result, native_ir = verify_caller_shape_import(
        app, args=args, paths=paths
    )
    witness_entries = dict(imported_files)
    record["caller_shape_proof_status"] = "pass"
    record["caller_shape_binding_status"] = "pass"
    record["caller_shape_config_root"] = str(args.caller_shape_config_root)
    record["caller_shape_import_root"] = str(args.caller_shape_import_root)
    record["caller_evidence_root"] = str(args.caller_evidence_root)
    record["caller_proof_mode"] = caller_proof["proof_mode"]
    record["caller_logical_shapes"] = caller_proof["logical_shapes"]
    record["caller_shape_pass_chain"] = {
        "sequence": [
            "import-input0-caller-noalias",
            "bind-exact-memref-shape",
            "adapt-original-amoeba-profile-costs",
            "retime-original-amoeba-fixed-decisions",
        ],
        "commands": {
            name: read_json(imported_files[f"{name}_command"])["argv"]
            for name in ("import", "bind", "adapter", "retimer")
        },
        "verification": "exact per-app caller proof, shape config, command chain, C++ profile binding and fixed-trace report",
    }
    record["input_bindings"] = {
        name: str(path) for name, path in imported_files.items()
    }
    record["archived_mapper_profile_success_status"] = "pass"
    record["profile_body_equality_status"] = "pass"
    record["fixed_retiming_status"] = "pass"
    record["independent_trace_status"] = "pass"
    record["independent_trace_result"] = str(imported_files["validation_result"])
    record["mapped_whole_program_cycles"] = retimed_result.get("mapped_whole_program_cycles")
    record["retimed_whole_program_scope"] = retimed_result.get("whole_program_result_scope")
    record["reused_cpp_artifacts"] = {
        "profile_cost_catalog": str(imported_files["cost_catalog"]),
        "retimed_native_ir": str(native_ir),
        "retimer_result": str(imported_files["retimed_result"]),
        "caller_proof": str(imported_files["caller_proof"]),
        "shape_bound_ir": str(imported_files["shape_bound_ir"]),
        "verification": "C++ caller proof, exact memref bindings, archived profiles and fixed trace rechecked",
    }

    if paths["numeric_view"].exists() or paths["numeric_output"].exists():
        raise ValueError(f"cannot resume {app}: numeric output paths already exist")
    preparation_root = paths["target_root"] / "numeric-native-preparation"
    preparation_root.mkdir(parents=True, exist_ok=False)
    legalized_native = preparation_root / "retimed-native.mlir"
    legalization_command = [
        str(args.optimizer),
        str(native_ir),
        "--verify-each",
        "--lower-affine",
        "-o",
        str(legalized_native),
    ]
    legalization_record = run_command(
        legalization_command,
        preparation_root / "lower-affine.log",
        cwd=args.artifact_root,
    )
    record.setdefault("resume_commands", {})["numeric_affine_legalization"] = legalization_record
    if legalization_record["exit_code"] != 0 or not legalized_native.is_file():
        record.update(
            status="failed",
            numeric_status="not_run_affine_legalization_failed",
            diagnostic_summary=legalization_record.get(
                "diagnostic", "pinned optimizer affine legalization failed"
            ),
        )
        return record
    if re.search(r"\baffine\.apply\b", legalized_native.read_text()):
        record.update(
            status="failed",
            numeric_status="not_run_affine_legalization_incomplete",
            diagnostic_summary="pinned optimizer affine legalization left affine.apply in the native input",
        )
        return record
    witness_entries["numeric_native_legalized"] = legalized_native
    witness_root = paths["target_root"] / "caller-shape-byte-witnesses"
    witnesses = capture_byte_witnesses(witness_entries, witness_root)
    record["resume_byte_witnesses"] = witnesses
    record["numeric_native_source"] = str(legalized_native)
    record["numeric_affine_legalization_status"] = "pass"
    paths["numeric_view"].mkdir(parents=True, exist_ok=False)
    native_root = make_numeric_view(legalized_native, paths["numeric_view"])
    numeric_argv = numeric_command(
        python=Path(sys.executable).resolve(),
        numeric_runner=numeric_runner,
        workload=app,
        artifact_root=args.artifact_root,
        production_root=production_root,
        output_root=paths["numeric_output"],
        native_root=native_root,
        optimizer=args.optimizer,
        llvm_build=llvm_build,
        reference_root=reference_root,
        llama_harness=llama_harness,
    )
    numeric_record = run_command(
        numeric_argv,
        paths["numeric_output"] / "driver.log",
        cwd=args.artifact_root,
    )
    record.setdefault("resume_commands", {})["full_program_numeric_gate"] = numeric_record
    batch_path = paths["numeric_output"] / "latest-batch.json"
    if batch_path.is_file():
        batch = read_json(batch_path)
        rows = batch.get("records")
        if isinstance(rows, list) and len(rows) == 1 and isinstance(rows[0], dict):
            record["numeric_result"] = rows[0]
            record["numeric_status"] = rows[0].get("status", "incomplete")
        else:
            record["numeric_status"] = "incomplete"
            record["numeric_diagnostic"] = "numeric runner batch lacks exactly one workload result"
    else:
        record["numeric_status"] = "incomplete"
        record["numeric_diagnostic"] = numeric_record.get(
            "diagnostic", "numeric runner did not publish latest-batch.json"
        )
    record["resume_inputs_unchanged"] = byte_witnesses_match(witness_entries, witnesses)
    record["source_orchestration_unchanged"] = (
        Path(witnesses["orchestrated_mlir"]).read_bytes()
        == paths["orchestrated_ir"].read_bytes()
    )
    if not record["resume_inputs_unchanged"] or not record["source_orchestration_unchanged"]:
        record.update(status="failed", diagnostic_summary="caller-shape inputs changed during numeric validation")
    elif numeric_record["exit_code"] == 0 and record["numeric_status"] == "pass":
        record.update(
            status="diagnostic_validation_complete",
            diagnostic_summary=(
                "C++ caller allocation proof, exact shape binding, fixed trace, and input-0 numeric checks passed; "
                "formal GO remains false and domain coverage remains pending"
            ),
        )
    else:
        record.update(
            status="failed",
            diagnostic_summary=record.get("numeric_diagnostic", "full-program numeric check did not pass"),
        )
    return record


def resume_existing_application(
    app: str,
    *,
    args: argparse.Namespace,
    input_root: Path,
    output_root: Path,
    validator: Path,
    numeric_runner: Path,
    production_root: Path,
    llvm_build: Path,
    reference_root: Path,
    llama_harness: Path,
) -> dict[str, Any]:
    """Resume trace validation and numeric checking without rerunning C++ retiming."""
    if app in {"harris", "radar"} and args.caller_shape_import_root is not None:
        return resume_caller_shape_application(
            app,
            args=args,
            input_root=input_root,
            output_root=output_root,
            numeric_runner=numeric_runner,
            production_root=production_root,
            llvm_build=llvm_build,
            reference_root=reference_root,
            llama_harness=llama_harness,
        )
    paths = app_paths(input_root, output_root, app)
    record_path = paths["result"]
    if not record_path.is_file():
        raise ValueError(f"cannot resume {app}: prior result record is missing")
    record = read_json(record_path)
    expected = base_record(app, paths, args.artifact_root)
    if record.get("schema") != expected["schema"] or record.get("workload") != app:
        raise ValueError(f"cannot resume {app}: prior result schema/workload differs")
    record["input_bindings"] = expected["input_bindings"]

    summary = read_json(output_root / "run-summary.json")
    if summary.get("optimizer") != str(args.optimizer):
        raise ValueError("cannot resume: optimizer differs from the original run pin")

    proof = read_json(paths["body_proof"])
    task_count = proof.get("task_count")
    if type(task_count) is not int:
        raise ValueError(f"cannot resume {app}: body proof task count is invalid")
    profile_success, body_equality, catalog_problem = verify_adapter_catalog(
        paths["cost_catalog"], task_count
    )
    if not profile_success or not body_equality:
        raise ValueError(f"cannot resume {app}: saved C++ adapter catalog failed: {catalog_problem}")
    signature_ok, signature_problem = verify_adapter_exact_task_bindings(
        paths["cost_catalog"], list(record.get("active_replica_counts", {}))
    )
    if not signature_ok:
        raise ValueError(f"cannot resume {app}: saved C++ source/profile catalog failed: {signature_problem}")
    catalog = read_json(paths["cost_catalog"])
    binding = catalog["original_amoeba_profile_binding"]
    if (
        binding.get("source_repository") != args.source_repository
        or binding.get("source_commit") != args.source_commit
        or binding.get("architecture_contract") != args.architecture_contract
    ):
        raise ValueError(f"cannot resume {app}: C++ source/profile catalog provenance differs")
    retimer_body_equal, retimer_safe, retimer_problem = check_final_cpp_result(
        paths["retimed_result"]
    )
    if not paths["retimed_ir"].is_file() or not retimer_safe or not retimer_body_equal:
        raise ValueError(f"cannot resume {app}: saved C++ retimer output failed: {retimer_problem}")
    retimed_result = read_json(paths["retimed_result"])
    if (
        retimed_result.get("candidate_origin") != "original-amoeba-throughput-guided"
        or retimed_result.get("cost_catalog_namespace") != catalog.get("namespace")
    ):
        raise ValueError(f"cannot resume {app}: C++ retimer output is not bound to the saved original catalog")
    for log_path in (
        paths["adapter_root"] / "adapter.log",
        paths["retimed_root"] / "retimer.log",
    ):
        if not log_path.is_file():
            raise ValueError(f"cannot resume {app}: saved C++ stage log is missing: {log_path}")
        if re.search(r"\berror:", log_path.read_text(errors="replace")):
            raise ValueError(f"cannot resume {app}: saved C++ stage log contains an error: {log_path}")
    record["archived_mapper_profile_success_status"] = "pass"
    record["profile_body_equality_status"] = "pass"
    record["fixed_retiming_status"] = "pass"
    record["reused_cpp_artifacts"] = {
        "profile_cost_catalog": str(paths["cost_catalog"]),
        "retimed_native_ir": str(paths["retimed_ir"]),
        "retimer_result": str(paths["retimed_result"]),
        "verification": "source/profile exact bindings and C++ body equivalence rechecked",
    }

    resume_byte_witnesses = capture_byte_witnesses(
        {
            "orchestrated_mlir": paths["orchestrated_ir"],
            "body_proof": paths["body_proof"],
            "task_profiles": paths["profiles"],
            "adapter_cost_catalog": paths["cost_catalog"],
            "retimed_native_ir": paths["retimed_ir"],
            "retimed_result": paths["retimed_result"],
        },
        paths["target_root"] / "resume-byte-witnesses",
    )
    record["resume_byte_witnesses"] = resume_byte_witnesses

    # Keep the failed first validator attempt intact while writing this retry
    # to a disjoint directory. The native trace and C++ retimer are reused.
    resumed_paths = dict(paths)
    resumed_paths["validation_root"] = paths["target_root"] / "validation-resume"
    resumed_paths["validation_result"] = resumed_paths["validation_root"] / "result.json"
    if resumed_paths["validation_root"].exists():
        raise ValueError(f"cannot resume {app}: validation-resume output already exists")
    resumed_paths["validation_root"].mkdir(parents=True, exist_ok=False)
    trace_argv = validator_command(
        Path(sys.executable).resolve(),
        validator,
        paths["retimed_result"],
        paths["orchestrated_ir"],
        paths["profiles"],
        paths["body_proof"],
        paths["cost_catalog"],
        resumed_paths["validation_result"],
    )
    trace_record = run_command(
        trace_argv,
        resumed_paths["validation_root"] / "validator.log",
        cwd=args.artifact_root,
    )
    record.setdefault("resume_commands", {})[
        "independent_fixed_trace_validator"
    ] = trace_record
    record["resume_validation_root"] = str(resumed_paths["validation_root"])
    if trace_record["exit_code"] != 0:
        record["independent_trace_status"] = "fail"
        record.setdefault("resume_diagnostics", []).append(
            {"stage": "independent-fixed-trace-validation", **trace_record}
        )
        record.update(
            status="failed",
            diagnostic_summary=trace_record.get(
                "diagnostic", "independent trace validation failed"
            ),
            numeric_status="not_run_trace_failed",
        )
        record["resume_inputs_unchanged"] = byte_witnesses_match(
            {
                "orchestrated_mlir": paths["orchestrated_ir"],
                "body_proof": paths["body_proof"],
                "task_profiles": paths["profiles"],
                "adapter_cost_catalog": paths["cost_catalog"],
                "retimed_native_ir": paths["retimed_ir"],
                "retimed_result": paths["retimed_result"],
            },
            resume_byte_witnesses,
        )
        return record
    if not resumed_paths["validation_result"].is_file():
        record.update(
            status="failed",
            independent_trace_status="fail",
            numeric_status="not_run_trace_failed",
            diagnostic_summary="independent trace validator did not publish its result",
        )
        return record
    trace_result = read_json(resumed_paths["validation_result"])
    if trace_result.get("status") != "pass" or trace_result.get("formal_go") is not False or trace_result.get(
        "iteration_domain_coverage_status"
    ) != "pending":
        record.update(
            status="failed",
            independent_trace_status="fail",
            numeric_status="not_run_trace_failed",
            diagnostic_summary="independent trace result did not preserve diagnostic-only status",
        )
        return record
    record["independent_trace_status"] = "pass"
    record["independent_trace_result"] = str(resumed_paths["validation_result"])

    if record.get("multi_replica_tasks"):
        unsupported_replica_record(
            record,
            "C++ fixed-decision output exists, but this driver does not admit "
            "multi-replica execution without a verified shard/domain mapping",
        )
        record["fixed_retiming_status"] = "pass_diagnostic_only"
        record["numeric_status"] = "not_run_replica_domains_unproven"
        record["resume_inputs_unchanged"] = byte_witnesses_match(
            {
                "orchestrated_mlir": paths["orchestrated_ir"],
                "body_proof": paths["body_proof"],
                "task_profiles": paths["profiles"],
                "adapter_cost_catalog": paths["cost_catalog"],
                "retimed_native_ir": paths["retimed_ir"],
                "retimed_result": paths["retimed_result"],
            },
            resume_byte_witnesses,
        )
        return record

    if paths["numeric_view"].exists() or paths["numeric_output"].exists():
        raise ValueError(f"cannot resume {app}: numeric output paths already exist")
    paths["numeric_view"].mkdir(parents=True, exist_ok=False)
    native_root = make_numeric_view(paths["retimed_ir"], paths["numeric_view"])
    numeric_argv = numeric_command(
        python=Path(sys.executable).resolve(),
        numeric_runner=numeric_runner,
        workload=app,
        artifact_root=args.artifact_root,
        production_root=production_root,
        output_root=paths["numeric_output"],
        native_root=native_root,
        optimizer=args.optimizer,
        llvm_build=llvm_build,
        reference_root=reference_root,
        llama_harness=llama_harness,
    )
    numeric_record = run_command(
        numeric_argv,
        paths["numeric_output"] / "driver.log",
        cwd=args.artifact_root,
    )
    record.setdefault("resume_commands", {})["full_program_numeric_gate"] = numeric_record
    batch_path = paths["numeric_output"] / "latest-batch.json"
    if batch_path.is_file():
        batch = read_json(batch_path)
        rows = batch.get("records")
        if isinstance(rows, list) and len(rows) == 1 and isinstance(rows[0], dict):
            numeric_result = rows[0]
            record["numeric_result"] = numeric_result
            record["numeric_status"] = numeric_result.get("status", "incomplete")
        else:
            record["numeric_status"] = "incomplete"
            record["numeric_diagnostic"] = "numeric runner batch lacks exactly one workload result"
    else:
        record["numeric_status"] = "incomplete"
        record["numeric_diagnostic"] = numeric_record.get(
            "diagnostic", "numeric runner did not publish latest-batch.json"
        )
    if numeric_record["exit_code"] != 0 and record["numeric_status"] == "pass":
        record["numeric_status"] = "incomplete"
        record["numeric_diagnostic"] = "numeric runner returned nonzero despite a pass marker"

    record["resume_inputs_unchanged"] = byte_witnesses_match(
        {
            "orchestrated_mlir": paths["orchestrated_ir"],
            "body_proof": paths["body_proof"],
            "task_profiles": paths["profiles"],
            "adapter_cost_catalog": paths["cost_catalog"],
            "retimed_native_ir": paths["retimed_ir"],
            "retimed_result": paths["retimed_result"],
        },
        resume_byte_witnesses,
    )
    record["source_orchestration_unchanged"] = record["resume_inputs_unchanged"]
    if not record["resume_inputs_unchanged"]:
        record.update(status="failed", diagnostic_summary="source orchestrated.mlir changed during replay")
    elif record["numeric_status"] == "pass":
        record.update(
            status="diagnostic_validation_complete",
            diagnostic_summary=(
                "fixed original allocation/body trace and input-0 numeric checks passed; "
                "formal GO remains false and domain coverage remains pending"
            ),
        )
    else:
        record.update(
            status="failed",
            diagnostic_summary=record.get(
                "numeric_diagnostic", "full-program numeric check did not pass"
            ),
        )
    return record


def run_application(
    app: str,
    *,
    args: argparse.Namespace,
    input_root: Path,
    output_root: Path,
    model_dir: Path,
    architecture: Path,
    validator: Path,
    numeric_runner: Path,
    production_root: Path,
    llvm_build: Path,
    reference_root: Path,
    llama_harness: Path,
) -> dict[str, Any]:
    if (
        app in {"harris", "radar"}
        and args.caller_shape_import_root is not None
        and (args.caller_shape_import_root / app).is_dir()
    ):
        return resume_caller_shape_application(
            app,
            args=args,
            input_root=input_root,
            output_root=output_root,
            numeric_runner=numeric_runner,
            production_root=production_root,
            llvm_build=llvm_build,
            reference_root=reference_root,
            llama_harness=llama_harness,
        )
    if args.resume_existing:
        return resume_existing_application(
            app,
            args=args,
            input_root=input_root,
            output_root=output_root,
            validator=validator,
            numeric_runner=numeric_runner,
            production_root=production_root,
            llvm_build=llvm_build,
            reference_root=reference_root,
            llama_harness=llama_harness,
        )
    paths = app_paths(input_root, output_root, app)
    record = base_record(app, paths, args.artifact_root)
    required = (paths["orchestrated_ir"], paths["body_proof"], paths["profiles"])
    missing = [str(path) for path in required if not path.is_file()]
    if missing:
        record.update(status="failed", diagnostic_summary="missing original input evidence: " + ", ".join(missing))
        return record

    record["input_byte_witnesses"] = capture_byte_witnesses(
        {
            "orchestrated_mlir": paths["orchestrated_ir"],
            "body_proof": paths["body_proof"],
            "task_profiles": paths["profiles"],
        },
        paths["target_root"] / "input-byte-witnesses",
    )

    proof = read_json(paths["body_proof"])
    function = proof.get("function")
    proof_task_count = proof.get("task_count")
    if not isinstance(function, str) or not function or type(proof_task_count) is not int:
        record.update(status="failed", diagnostic_summary="body proof lacks a function name or task count")
        return record
    if proof_task_count != record["task_count"]:
        record.update(status="failed", diagnostic_summary="body proof task count differs from original orchestration")
        return record

    active = record["multi_replica_tasks"]
    if path_has_spaces(
        (
            paths["orchestrated_ir"],
            paths["body_proof"],
            paths["profiles"],
            model_dir,
            architecture,
            paths["cost_catalog"],
            paths["retimed_result"],
        )
    ):
        record.update(
            status="failed",
            diagnostic_summary=(
                "a runtime path contains whitespace; the registered MLIR pass "
                "option protocol uses space-delimited key=value pairs"
            ),
        )
        return record

    paths["adapter_root"].mkdir(parents=True, exist_ok=False)
    adapter_argv = pass_command(
        args.optimizer,
        architecture,
        paths["orchestrated_ir"],
        "adapt-original-amoeba-profile-costs",
        adapter_options(
            function=function,
            body_proof=paths["body_proof"],
            profiles=paths["profiles"],
            model_dir=model_dir,
            architecture=architecture,
            architecture_contract=args.architecture_contract,
            source_repository=args.source_repository,
            source_commit=args.source_commit,
            costs=paths["cost_catalog"],
        ),
        paths["adapter_ir"],
    )
    adapter_record = run_command(
        adapter_argv,
        paths["adapter_root"] / "adapter.log",
        cwd=args.artifact_root,
    )
    record["commands"]["profile_cost_adapter"] = adapter_record
    if adapter_record["exit_code"] != 0:
        diagnostic = str(adapter_record.get("diagnostic", ""))
        record["cpp_diagnostics"].append(
            {
                "stage": "adapt-original-amoeba-profile-costs",
                "exit_code": adapter_record["exit_code"],
                "text": diagnostic,
                "log": adapter_record["log"],
            }
        )
        if active and is_replica_support_diagnostic(diagnostic):
            unsupported_replica_record(record, diagnostic)
        else:
            record.update(status="failed", diagnostic_summary=diagnostic.strip())
        record["archived_mapper_profile_success_status"] = "not_established"
        record["profile_body_equality_status"] = "not_established"
        record["fixed_retiming_status"] = (
            "unsupported_adapter_rejected_replica"
            if record.get("status") == "unsupported_unproven"
            else "not_run_adapter_failed"
        )
        record["independent_trace_status"] = "not_run"
        record["numeric_status"] = "not_run"
        return record

    profile_success, body_equality, catalog_problem = verify_adapter_catalog(
        paths["cost_catalog"], proof_task_count
    )
    record["archived_mapper_profile_success_status"] = "pass" if profile_success else "fail"
    record["profile_body_equality_status"] = "pass" if body_equality else "fail"
    if catalog_problem:
        record.update(status="failed", diagnostic_summary=catalog_problem)
        record["fixed_retiming_status"] = "not_run_invalid_adapter_catalog"
        return record
    if active:
        # A newer adapter may accept the cost record while the native retimer
        # still cannot materialize the source's replica domains. Let the C++
        # retimer produce its diagnostic, but never treat this as an admitted
        # input-0 schedule.
        record["original_replica_materialization_status"] = "unsupported"

    paths["retimed_root"].mkdir(parents=True, exist_ok=False)
    retimer_argv = pass_command(
        args.optimizer,
        architecture,
        paths["orchestrated_ir"],
        "retime-original-amoeba-fixed-decisions",
        retimer_options(
            function,
            paths["cost_catalog"],
            paths["body_proof"],
            paths["retimed_result"],
        ),
        paths["retimed_ir"],
    )
    retimer_record = run_command(
        retimer_argv,
        paths["retimed_root"] / "retimer.log",
        cwd=args.artifact_root,
    )
    record["commands"]["fixed_decision_retimer"] = retimer_record
    if retimer_record["exit_code"] != 0:
        diagnostic = str(retimer_record.get("diagnostic", ""))
        record["cpp_diagnostics"].append(
            {
                "stage": "retime-original-amoeba-fixed-decisions",
                "exit_code": retimer_record["exit_code"],
                "text": diagnostic,
                "log": retimer_record["log"],
            }
        )
        if active and is_replica_support_diagnostic(diagnostic):
            unsupported_replica_record(record, diagnostic)
        else:
            record.update(status="failed", diagnostic_summary=diagnostic.strip())
        record["fixed_retiming_status"] = (
            "unsupported" if record.get("status") == "unsupported_unproven" else "fail"
        )
        record["independent_trace_status"] = "not_run"
        record["numeric_status"] = "not_run"
        return record

    if not paths["retimed_ir"].is_file():
        record.update(
            status="failed",
            fixed_retiming_status="fail",
            diagnostic_summary="C++ retimer returned success without writing retimed/native.mlir",
        )
        record["independent_trace_status"] = "not_run"
        record["numeric_status"] = "not_run"
        return record

    retimer_body_equal, retimer_safe, retimer_problem = check_final_cpp_result(
        paths["retimed_result"]
    )
    record["profile_body_equality_status"] = (
        "pass" if body_equality and retimer_body_equal else "fail"
    )
    record["fixed_retiming_status"] = "pass" if retimer_safe else "fail"
    cpp_result = read_json(paths["retimed_result"])
    record["mapped_whole_program_cycles"] = cpp_result.get("mapped_whole_program_cycles")
    record["retimed_whole_program_scope"] = cpp_result.get("whole_program_result_scope")
    record["iteration_domain_coverage_status"] = cpp_result.get(
        "iteration_domain_coverage_status", "pending"
    )
    record["iteration_domain_coverage_verified"] = cpp_result.get(
        "iteration_domain_coverage_verified", False
    )
    if not retimer_safe:
        record.update(status="failed", diagnostic_summary=retimer_problem)
        record["independent_trace_status"] = "not_run"
        record["numeric_status"] = "not_run"
        return record

    paths["validation_root"].mkdir(parents=True, exist_ok=False)
    trace_argv = validator_command(
        Path(sys.executable).resolve(),
        validator,
        paths["retimed_result"],
        paths["orchestrated_ir"],
        paths["profiles"],
        paths["body_proof"],
        paths["cost_catalog"],
        paths["validation_result"],
    )
    trace_record = run_command(
        trace_argv,
        paths["validation_root"] / "validator.log",
        cwd=args.artifact_root,
    )
    record["commands"]["independent_fixed_trace_validator"] = trace_record
    if trace_record["exit_code"] != 0:
        record["independent_trace_status"] = "fail"
        record["cpp_diagnostics"].append(
            {
                "stage": "independent-fixed-trace-validation",
                "exit_code": trace_record["exit_code"],
                "text": trace_record.get("diagnostic", ""),
                "log": trace_record["log"],
            }
        )
        record.update(status="failed", diagnostic_summary="independent trace validation failed")
        record["numeric_status"] = "not_run_trace_failed"
        return record
    if not paths["validation_result"].is_file():
        record.update(
            status="failed",
            independent_trace_status="fail",
            numeric_status="not_run_trace_failed",
            diagnostic_summary="independent trace validator did not publish its result",
        )
        return record
    trace_result = read_json(paths["validation_result"])
    if trace_result.get("status") != "pass" or trace_result.get("formal_go") is not False or trace_result.get(
        "iteration_domain_coverage_status"
    ) != "pending":
        record.update(
            status="failed",
            independent_trace_status="fail",
            numeric_status="not_run_trace_failed",
            diagnostic_summary="independent trace result did not preserve diagnostic-only status",
        )
        return record
    record["independent_trace_status"] = "pass"
    if active:
        # Do not run a one-input numeric check on unmaterialized replicas.
        unsupported_replica_record(
            record,
            "C++ fixed-decision output exists, but this driver does not admit "
            "multi-replica execution without a verified shard/domain mapping",
        )
        record["fixed_retiming_status"] = "pass_diagnostic_only"
        record["numeric_status"] = "not_run_replica_domains_unproven"
        return record

    paths["numeric_view"].mkdir(parents=True, exist_ok=False)
    native_root = make_numeric_view(paths["retimed_ir"], paths["numeric_view"])
    numeric_argv = numeric_command(
        python=Path(sys.executable).resolve(),
        numeric_runner=numeric_runner,
        workload=app,
        artifact_root=args.artifact_root,
        production_root=production_root,
        output_root=paths["numeric_output"],
        native_root=native_root,
        optimizer=args.optimizer,
        llvm_build=llvm_build,
        reference_root=reference_root,
        llama_harness=llama_harness,
    )
    numeric_record = run_command(
        numeric_argv,
        paths["numeric_output"] / "driver.log",
        cwd=args.artifact_root,
    )
    record["commands"]["full_program_numeric_gate"] = numeric_record
    batch_path = paths["numeric_output"] / "latest-batch.json"
    if batch_path.is_file():
        try:
            batch = read_json(batch_path)
            rows = batch.get("records")
            if isinstance(rows, list) and len(rows) == 1 and isinstance(rows[0], dict):
                numeric_result = rows[0]
                record["numeric_result"] = numeric_result
                record["numeric_status"] = numeric_result.get("status", "incomplete")
            else:
                record["numeric_status"] = "incomplete"
                record["numeric_diagnostic"] = "numeric runner batch lacks exactly one workload result"
        except (OSError, json.JSONDecodeError, ValueError) as error:
            record["numeric_status"] = "incomplete"
            record["numeric_diagnostic"] = str(error)
    else:
        record["numeric_status"] = "incomplete"
        record["numeric_diagnostic"] = numeric_record.get(
            "diagnostic", "numeric runner did not publish latest-batch.json"
        )
    if numeric_record["exit_code"] != 0 and record["numeric_status"] == "pass":
        record["numeric_status"] = "incomplete"
        record["numeric_diagnostic"] = "numeric runner returned nonzero despite a pass marker"

    record["source_orchestration_unchanged"] = byte_witnesses_match(
        {
            "orchestrated_mlir": paths["orchestrated_ir"],
            "body_proof": paths["body_proof"],
            "task_profiles": paths["profiles"],
        },
        record["input_byte_witnesses"],
    )
    if not record["source_orchestration_unchanged"]:
        record.update(status="failed", diagnostic_summary="source orchestrated.mlir changed during replay")
    elif record["numeric_status"] == "pass":
        record.update(
            status="diagnostic_validation_complete",
            diagnostic_summary=(
                "fixed original allocation/body trace and input-0 numeric checks passed; "
                "formal GO remains false and domain coverage remains pending"
            ),
        )
    else:
        record.update(
            status="failed",
            diagnostic_summary=record.get("numeric_diagnostic", "full-program numeric check did not pass"),
        )
    return record


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--optimizer", type=Path, required=True, help="pinned optimizer with both original-AMOEBA passes")
    parser.add_argument("--artifact-root", type=Path, default=ROOT, help="portable root containing captured input-0 evidence and runtime assets")
    parser.add_argument("--input-root", type=Path, help="original full-flow workload directory; defaults under artifact-root/results")
    parser.add_argument("--output-root", type=Path, help="new, non-existing output root; defaults under artifact-root/results")
    parser.add_argument("--model-dir", type=Path, help="formal model/checkpoint directory; defaults under artifact-root/.work")
    parser.add_argument("--architecture", type=Path, help="4x4 architecture specification; defaults under artifact-root/config")
    parser.add_argument("--architecture-contract", default=DEFAULT_ARCHITECTURE_CONTRACT)
    parser.add_argument("--source-repository", default=DEFAULT_SOURCE_REPOSITORY)
    parser.add_argument("--source-commit", default=DEFAULT_SOURCE_COMMIT)
    parser.add_argument("--trace-validator", type=Path, help="independent fixed-decision trace validator; defaults to scripts/validate_original_amoeba_fixed_retiming.py")
    parser.add_argument("--numeric-runner", type=Path, help="existing full-program numeric launcher; defaults to scripts/run_input0_numeric.py")
    parser.add_argument("--llvm-build", type=Path, help="LLVM build used by the numeric runner; defaults under artifact-root/.work")
    parser.add_argument("--reference-root", type=Path, help="numeric reference libraries; defaults under artifact-root/.work")
    parser.add_argument("--llama-harness", type=Path, help="independent LLaMA host harness; defaults to the existing numeric-runner location")
    parser.add_argument(
        "--caller-shape-import-root",
        type=Path,
        help="completed C++ caller-proof/bind/adapter/retimer outputs, with per-workload subdirectories",
    )
    parser.add_argument(
        "--caller-shape-config-root",
        type=Path,
        help="per-workload caller-noalias and exact memref shape proof/config files",
    )
    parser.add_argument(
        "--caller-evidence-root",
        type=Path,
        help="root of the existing input-0 host caller evidence files",
    )
    parser.add_argument("--apps", nargs="+", choices=APPLICATIONS, default=list(APPLICATIONS))
    parser.add_argument(
        "--resume-existing",
        action="store_true",
        help="reuse verified C++ adapter/retimer outputs and run only trace validation plus numeric checks",
    )
    parser.add_argument("--dry-run", action="store_true", help="print portable paths and planned commands without creating outputs or launching tools")
    return parser


def resolve_args(args: argparse.Namespace) -> argparse.Namespace:
    args.artifact_root = args.artifact_root.resolve()
    args.input_root = path_from(
        args.input_root,
        base=args.artifact_root,
        default=Path("results/input0-amoeba-full-correct-flow"),
    )
    args.output_root = path_from(
        args.output_root,
        base=args.artifact_root,
        default=Path("results/input0-original-amoeba-native-validation-v1"),
    )
    args.model_dir = path_from(
        args.model_dir,
        base=args.artifact_root,
        default=Path(".work/formal-model-nohash-v2-trained-rerun"),
    )
    args.architecture = path_from(
        args.architecture,
        base=args.artifact_root,
        default=Path("config/architectures/amoeba_4x4_full_mesh_context12.yaml"),
    )
    args.trace_validator = path_from(
        args.trace_validator,
        base=args.artifact_root,
        default=Path("scripts/validate_original_amoeba_fixed_retiming.py"),
    )
    args.numeric_runner = path_from(
        args.numeric_runner,
        base=args.artifact_root,
        default=Path("scripts/run_input0_numeric.py"),
    )
    args.llvm_build = path_from(
        args.llvm_build,
        base=args.artifact_root,
        default=Path(".work/llvm-build"),
    )
    args.reference_root = path_from(
        args.reference_root,
        base=args.artifact_root,
        default=Path(".work/selected-native-numeric-gate"),
    )
    args.llama_harness = path_from(
        args.llama_harness,
        base=args.artifact_root,
        default=Path(".work/cpp-gate-continuation-agent/source/replica-validation/task0-task1-k2.runner.mlir"),
    )
    args.caller_shape_import_root = path_from(
        args.caller_shape_import_root,
        base=args.artifact_root,
        default=Path(".work/caller-shape-import"),
    )
    args.caller_shape_config_root = path_from(
        args.caller_shape_config_root,
        base=args.artifact_root,
        default=Path(".work/post-publication/correct-domain-canonical-v1"),
    )
    args.caller_evidence_root = path_from(
        args.caller_evidence_root,
        base=args.artifact_root,
        default=Path("results/input0-cpp-mainline-20261001/input0-cpp-numeric-gates"),
    )
    args.optimizer = args.optimizer.resolve()
    return args


def make_plan(args: argparse.Namespace) -> dict[str, Any]:
    rows = []
    for app in args.apps:
        paths = app_paths(args.input_root, args.output_root, app)
        inventory: dict[str, int] = {}
        if paths["orchestrated_ir"].is_file():
            inventory = active_replica_inventory(paths["orchestrated_ir"])
        proof = read_json(paths["body_proof"]) if paths["body_proof"].is_file() else {}
        function = proof.get("function", "<missing>")
        rows.append(
            {
                "workload": app,
                "function": function,
                "source": str(paths["orchestrated_ir"]),
                "body_proof": str(paths["body_proof"]),
                "profiles": str(paths["profiles"]),
                "active_replica_counts": inventory,
                "multi_replica_tasks": {name: count for name, count in inventory.items() if count > 1},
                "adapter_costs": str(paths["cost_catalog"]),
                "retimed_ir": str(paths["retimed_ir"]),
                "retimed_result": str(paths["retimed_result"]),
                "trace_result": str(paths["validation_result"]),
                "numeric_native_root": str(paths["numeric_view"]),
                "status_record": str(paths["result"]),
            }
        )
    return {
        "schema": "orbit-original-amoeba-native-baseline-plan-v1",
        "artifact_root": str(args.artifact_root),
        "input_root": str(args.input_root),
        "output_root": str(args.output_root),
        "optimizer": str(args.optimizer),
        "trace_validator": str(args.trace_validator),
        "numeric_runner": str(args.numeric_runner),
        "architecture": str(args.architecture),
        "model_dir": str(args.model_dir),
        "llvm_build": str(args.llvm_build),
        "reference_root": str(args.reference_root),
        "resume_existing": args.resume_existing,
        "caller_shape_import_root": str(args.caller_shape_import_root),
        "caller_shape_config_root": str(args.caller_shape_config_root),
        "caller_evidence_root": str(args.caller_evidence_root),
        "apps": rows,
        "limits": {
            "mapper_launches": 0,
            "concurrent_workloads": 1,
            "subprocess_timeout": None,
            "retry_count": 0,
            "formal_go": False,
            "iteration_domain_coverage_status": "pending",
        },
    }


def main(argv: Sequence[str] | None = None) -> int:
    args = resolve_args(build_parser().parse_args(argv))
    plan = make_plan(args)
    if args.dry_run:
        print(json.dumps(plan, indent=2, sort_keys=True))
        return 0

    runtime_files = (
        args.optimizer,
        args.trace_validator,
        args.numeric_runner,
        args.architecture,
        args.model_dir / "ensemble.json",
        args.llvm_build / "bin/mlir-opt",
        args.llvm_build / "bin/mlir-runner",
        args.llvm_build / "lib/libmlir_runner_utils.so",
    )
    missing_runtime = [str(path) for path in runtime_files if not path.is_file()]
    if missing_runtime:
        raise SystemExit("missing required runtime files: " + ", ".join(missing_runtime))
    if not args.reference_root.is_dir():
        raise SystemExit(f"numeric reference root is missing: {args.reference_root}")
    if not args.output_root.parent.is_dir():
        args.output_root.parent.mkdir(parents=True, exist_ok=True)
    if args.output_root.exists() and not args.resume_existing:
        raise SystemExit(f"output root already exists; choose a new disjoint path: {args.output_root}")
    summary_path = args.output_root / "run-summary.json"
    if args.resume_existing:
        if not args.output_root.is_dir() or not summary_path.is_file():
            raise SystemExit("--resume-existing requires an existing output root and run-summary.json")
        summary = read_json(summary_path)
        if (
            summary.get("schema") != "orbit-original-amoeba-native-baseline-run-v1"
            or summary.get("optimizer") != str(args.optimizer)
            or summary.get("input_root") != str(args.input_root)
        ):
            raise SystemExit("--resume-existing run summary does not match optimizer or input root")
        summary["status"] = "running"
        summary["resumed_workloads"] = list(args.apps)
    else:
        args.output_root.mkdir(parents=True, exist_ok=False)
        summary = {
            "schema": "orbit-original-amoeba-native-baseline-run-v1",
            "status": "running",
            "artifact_root": str(args.artifact_root),
            "input_root": str(args.input_root),
            "optimizer": str(args.optimizer),
            "formal_go": False,
            "iteration_domain_coverage_status": "pending",
            "mapper_replay_claim": "not_claimed",
            "records": [],
        }
    atomic_json(summary_path, summary)

    for app in args.apps:
        paths = app_paths(args.input_root, args.output_root, app)
        if args.resume_existing:
            if not paths["target_root"].is_dir():
                raise SystemExit(f"--resume-existing output is missing for {app}: {paths['target_root']}")
        else:
            paths["target_root"].mkdir(parents=True, exist_ok=False)
        try:
            record = run_application(
                app,
                args=args,
                input_root=args.input_root,
                output_root=args.output_root,
                model_dir=args.model_dir,
                architecture=args.architecture,
                validator=args.trace_validator,
                numeric_runner=args.numeric_runner,
                production_root=args.input_root.parent,
                llvm_build=args.llvm_build,
                reference_root=args.reference_root,
                llama_harness=args.llama_harness,
            )
        except (OSError, ValueError, json.JSONDecodeError) as error:
            if args.resume_existing and paths["result"].is_file():
                record = read_json(paths["result"])
            else:
                record = base_record(app, paths, args.artifact_root)
            record.update(status="failed", diagnostic_summary=str(error))
        witnesses = record.get("input_byte_witnesses")
        if paths["orchestrated_ir"].is_file() and isinstance(witnesses, dict):
            record["source_orchestration_unchanged"] = byte_witnesses_match(
                {
                    "orchestrated_mlir": paths["orchestrated_ir"],
                    "body_proof": paths["body_proof"],
                    "task_profiles": paths["profiles"],
                },
                witnesses,
            )
            if not record["source_orchestration_unchanged"]:
                record.update(
                    status="failed",
                    diagnostic_summary="source orchestrated.mlir changed during replay",
                )
        atomic_json(paths["result"], record)
        summary_record = {
            "workload": app,
            "status": record.get("status"),
            "result": str(paths["result"]),
        }
        existing_index = next(
            (
                index
                for index, row in enumerate(summary["records"])
                if row.get("workload") == app
            ),
            None,
        )
        if existing_index is None:
            summary["records"].append(summary_record)
        else:
            summary["records"][existing_index] = summary_record
        atomic_json(summary_path, summary)
        print(f"{app}: {record.get('status')}", flush=True)

    acceptable = {"diagnostic_validation_complete", "unsupported_unproven"}
    had_failure = any(row.get("status") not in acceptable for row in summary["records"])
    had_unsupported = any(row.get("status") == "unsupported_unproven" for row in summary["records"])
    summary["status"] = "complete_with_unproven_replicas" if had_unsupported and not had_failure else (
        "diagnostic_validation_complete" if not had_failure else "incomplete"
    )
    summary["formal_go"] = False
    summary["iteration_domain_coverage_status"] = "pending"
    summary["all_requested_numeric_checks_passed"] = all(
        row.get("status") == "diagnostic_validation_complete" for row in summary["records"]
    )
    atomic_json(summary_path, summary)
    return 1 if had_failure or had_unsupported else 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except KeyboardInterrupt:
        raise SystemExit(130)
