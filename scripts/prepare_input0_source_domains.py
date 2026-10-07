#!/usr/bin/env python3
"""Prepare source-owned input-0 MLIR and optional C++ task-cost catalogs.

All semantic transformations and proofs are performed by the supplied C++
optimizer. This driver only validates the source manifest, launches those
passes, and preserves their commands and diagnostics.
"""

from __future__ import annotations

import argparse
import concurrent.futures
import json
import os
import re
import subprocess
import sys
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable

WORKLOADS = ("llama", "lu", "gcn", "harris", "radar", "raytracing")
EXPECTED_TASK_COUNTS = {
    "llama": 9,
    "lu": 9,
    "gcn": 28,
    "harris": 24,
    "radar": 21,
    "raytracing": 27,
}

# Caller allocation extents are source-owned configuration. The argument
# indices refer to target arguments after scalar input 0.
CONTRACTS = {
    "llama": {
        "function": "_Z10llama_funciPA256_KiS1_S1_S1_S1_S1_S1_PA256_i",
        "shapes": (
            "512x256;256x256;256x256;256x256;256x256;256x256;"
            "256x256;512x256"
        ),
        "argument_dimensions": (
            "512,256", "256,256", "256,256", "256,256",
            "256,256", "256,256", "256,256", "512,256",
        ),
    },
    "lu": {
        "function": "_Z7lu_funciPA100_KiPS_PA100_iS4_S4_PiS5_S4_S5_",
        "shapes": "8x100;8;8x100;8x100;8x100;8;8;8x100;1",
        "argument_dimensions": (
            "8,100", "8", "8,100", "8,100", "8,100", "8", "8",
            "8,100", "1",
        ),
    },
    "gcn": {
        "function": "_Z8gcn_funciPA256_KiS1_S1_S1_PA16_S_S3_S3_S3_PA256_iPA256_S4_PA256_A16_iSA_SA_Pi",
        "shapes": (
            "256x256;256x256;256x256;256x256;256x16;16x16;16x16;16x16;"
            "4x256;4x256x256;3x256x16;12x256x16;3x256x16;16"
        ),
        "argument_dimensions": (
            "256,256", "256,256", "256,256", "256,256", "256,16",
            "16,16", "16,16", "16,16", "4,256", "4,256,256",
            "3,256,16", "12,256,16", "3,256,16", "16",
        ),
    },
    "harris": {
        "function": "_Z11harris_funciPA128_KiS1_S1_PA128_iS3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_S3_",
        "shapes": ";".join(["256x128"] * 27),
        "argument_dimensions": tuple(["256,128"] * 27),
    },
    "radar": {
        "function": "_Z10radar_funciPA256_KiS1_S1_S1_PA32_S_S3_PiS4_PA256_iS6_S6_S6_S6_S6_S4_S4_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S6_S4_",
        "shapes": (
            "32x256;32x256;256x256;256x256;16x32;16x32;32;32;32x256;"
            "32x256;32x256;32x256;32x256;32x256;256;256;32x256;32x256;"
            "16x256;16x256;16x256;16x256;16x256;16x256;16x256;16x256;"
            "16x256;16x256;16x256;256"
        ),
        "argument_dimensions": (
            "32,256", "32,256", "256,256", "256,256", "16,32", "16,32",
            "32", "32", "32,256", "32,256", "32,256", "32,256",
            "32,256", "32,256", "256", "256", "32,256", "32,256",
            "16,256", "16,256", "16,256", "16,256", "16,256", "16,256",
            "16,256", "16,256", "16,256", "16,256", "16,256", "256",
        ),
    },
    "raytracing": {
        "function": "_Z15raytracing_funciPKiS0_S0_S0_S0_S0_S0_S0_S0_S0_PiS1_S1_S1_S1_S1_S1_S1_S1_PA8_iS1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_",
        "shapes": (
            "8;8;8;8;8;8;8;4;4;4;1472;1472;1472;1472;1472;1472;1472;"
            "1472;1472;1472x8;1472;1472;1472;1472;1472;1472;1472;1472;"
            "1472;1472;1472;1472;1472;1472;1472;1472;1472;1472;1472;"
            "1472;1472;1472;1472;1472;1472"
        ),
        "argument_dimensions": tuple(
            ["8"] * 7 + ["4"] * 3 + ["1472"] * 9 + ["1472,8"] + ["1472"] * 25
        ),
    },
}

MODEL_SOURCE_REPOSITORY = "git@github.com:guosran/amoeba.git"
MODEL_SOURCE_COMMIT = "a57376e7043b1681e64e7169c5a8cb02eb192331"
MODEL_NAMESPACE = "formal-max4-nohash-v2-exploratory"
GRAPH_VARIANT_ID = "identity"
MAX_JOBS = 3


class PreparationError(RuntimeError):
    pass


class CommandFailure(PreparationError):
    def __init__(self, message: str, record: dict[str, Any]):
        super().__init__(message)
        self.record = record


@dataclass(frozen=True)
class Inputs:
    artifact_root: Path
    source_root: Path
    manifest_path: Path
    records: dict[str, dict[str, Any]]


def write_json(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    partial = path.with_name(path.name + ".partial")
    partial.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n")
    partial.replace(path)


def parse_jobs(value: str) -> int:
    try:
        jobs = int(value)
    except ValueError as exc:
        raise argparse.ArgumentTypeError("jobs must be an integer from 1 to 3") from exc
    if not 1 <= jobs <= MAX_JOBS:
        raise argparse.ArgumentTypeError("jobs must be an integer from 1 to 3")
    return jobs


def parse_ray_fission_split_at(value: str) -> int:
    try:
        split_at = int(value)
    except ValueError as exc:
        raise argparse.ArgumentTypeError(
            "Ray fission split-at must be an integer from 0 through 7"
        ) from exc
    if not 0 <= split_at <= 7:
        raise argparse.ArgumentTypeError(
            "Ray fission split-at must be an integer from 0 through 7"
        )
    return split_at


def path_under(root: Path, relative: str, label: str) -> Path:
    candidate = (root / relative).resolve()
    try:
        candidate.relative_to(root.resolve())
    except ValueError as exc:
        raise PreparationError(f"{label} escapes artifact root: {relative}") from exc
    if not candidate.is_file():
        raise PreparationError(f"{label} is missing: {candidate}")
    return candidate


def load_inputs(artifact_root: Path, workloads: Iterable[str]) -> Inputs:
    root = artifact_root.resolve()
    source_root = root / "reference/input0-source-domains"
    manifest_path = source_root / "manifest.json"
    if not manifest_path.is_file():
        raise PreparationError(f"source-domain manifest is missing: {manifest_path}")
    try:
        manifest = json.loads(manifest_path.read_text())
    except (OSError, json.JSONDecodeError) as exc:
        raise PreparationError(f"cannot read source-domain manifest: {exc}") from exc
    if manifest.get("schema") != "orbit-input0-complete-affine-source-inputs-v1":
        raise PreparationError("unsupported source-domain manifest schema")
    records_list = manifest.get("records")
    if not isinstance(records_list, list):
        raise PreparationError("manifest records must be a list")
    records: dict[str, dict[str, Any]] = {}
    for record in records_list:
        if not isinstance(record, dict) or record.get("workload") not in WORKLOADS:
            raise PreparationError("manifest contains an invalid workload record")
        workload = record["workload"]
        if workload in records:
            raise PreparationError(f"manifest repeats workload {workload}")
        records[workload] = record
    for workload in workloads:
        record = records.get(workload)
        if record is None:
            raise PreparationError(f"manifest has no record for {workload}")
        if record.get("fixed_input") != 0 or record.get("static_scalar_argument") != 0:
            raise PreparationError(f"{workload} is not the fixed input-0 source case")
        if not record.get("source_contains_complete_affine_domains"):
            raise PreparationError(f"{workload} is not marked as a complete affine source input")
        value = record.get("static_scalar_value")
        if not isinstance(value, int) or value <= 0:
            raise PreparationError(f"{workload} has an invalid source scalar bound")
        if not record.get("caller_evidence"):
            raise PreparationError(f"{workload} has no portable caller_evidence path")
        specialization = record.get("specialization_pass", "")
        function_marker = "--bind-static-scalar-argument=function="
        if function_marker not in specialization:
            raise PreparationError(f"{workload} manifest lacks its static-specialization command")
        source_function = specialization.split(function_marker, 1)[1].split()[0]
        if source_function != CONTRACTS.get(workload, {}).get("function"):
            raise PreparationError(f"{workload} caller contract does not match the source function")
        if f"argument=0 value={value}" not in specialization:
            raise PreparationError(f"{workload} static-specialization bound differs from the source manifest")
        input_path = path_under(source_root, record.get("input", ""), f"{workload} source input")
        path_under(source_root, record["caller_evidence"], f"{workload} caller evidence")
        correction = record.get("source_correction")
        if correction is not None:
            if not isinstance(correction, dict) or not correction.get("pass_name") or not correction.get("scope"):
                raise PreparationError(f"{workload} has malformed source-correction metadata")
            if correction.get("source"):
                path_under(source_root, correction["source"], f"{workload} source-correction source")
        input_text = input_path.read_text(errors="replace")
        expected_bound = f"amoeba.static_bound.arg.0 = {value} : i64"
        if expected_bound not in input_text:
            raise PreparationError(
                f"{workload} input lacks the source-owned static bound {value} on argument 0"
            )
        if workload not in CONTRACTS:
            raise PreparationError(f"no caller-shape contract is configured for {workload}")
        contract = CONTRACTS[workload]
        if len(contract["shapes"].split(";")) != len(contract["argument_dimensions"]):
            raise PreparationError(f"{workload} caller shape and argument contracts disagree")
    return Inputs(root, source_root.resolve(), manifest_path, records)


def parse_model(model_path: Path | None, required: bool) -> tuple[Path, Path] | None:
    if model_path is None:
        if required:
            raise PreparationError("--model is required with --cost-catalog")
        return None
    model = model_path.resolve()
    if model.is_dir():
        ensemble = model / "ensemble.json"
        checkpoints = model
    else:
        ensemble = model
        checkpoints = model.parent
    if not ensemble.is_file():
        raise PreparationError(f"model ensemble is missing: {ensemble}")
    if not checkpoints.is_dir():
        raise PreparationError(f"model checkpoint directory is missing: {checkpoints}")
    return ensemble, checkpoints


def make_bind_pipeline(function: str, dimensions: Iterable[str]) -> str:
    binds = []
    for argument, shape in enumerate(dimensions, start=1):
        binds.append(
            "bind-exact-memref-shape{function=" + function
            + " argument=" + str(argument)
            + " dimensions=" + shape + "}"
        )
    return "--pass-pipeline=builtin.module(" + ",".join(binds) + ")"


def optimizer_path(path: Path) -> Path:
    resolved = path.resolve()
    if not resolved.is_file():
        raise PreparationError(f"optimizer is missing: {resolved}")
    if not os.access(resolved, os.X_OK):
        raise PreparationError(f"optimizer is not executable: {resolved}")
    return resolved


def command_plan(
    optimizer: Path,
    architecture: Path,
    inputs: Inputs,
    workload: str,
    out: Path,
    model: tuple[Path, Path] | None,
    include_cost: bool,
    allow_unsupported_model_shapes: bool = False,
    ray_fission_split_at: int = 0,
    source_repository: str = MODEL_SOURCE_REPOSITORY,
    source_commit: str = MODEL_SOURCE_COMMIT,
    model_namespace: str = MODEL_NAMESPACE,
    diagnostic_ii_ceiling: int = 20,
    emit_fission_source: bool = False,
) -> dict[str, list[str]]:
    record = inputs.records[workload]
    contract = CONTRACTS[workload]
    function = contract["function"]
    source = path_under(inputs.source_root, record["input"], f"{workload} source input")
    caller = path_under(inputs.source_root, record["caller_evidence"], f"{workload} caller evidence")
    bound = str(record["static_scalar_value"])
    taskflow = out / "taskflow-affine.mlir"
    noalias = out / "taskflow-affine-noalias.mlir"
    shaped = out / "taskflow-affine-noalias-shaped.mlir"
    fissioned = out / "taskflow-fission.mlir"
    canonical = out / "canonical.mlir"
    noalias_proof = out / "caller-noalias-proof.json"
    facts = out / "facts.json"
    verifier_proof = out / "source-iteration-domain-proof.json"
    common = ["--verify-each", "--mlir-print-op-generic"]
    prep_pipeline = [
        "--construct-hyperblock-from-task",
        "--classify-task-and-counter",
        "--convert-taskflow-to-neura",
        "--cse",
        "--lower-affine",
        "--convert-scf-to-cf",
        "--convert-cf-to-llvm",
        "--assign-accelerator",
        "--lower-memref-to-neura",
        "--lower-arith-to-neura",
        "--lower-builtin-to-neura",
        "--lower-llvm-to-neura",
        "--promote-input-arg-to-const",
        "--fold-constant",
        "--canonicalize-return",
        "--canonicalize-live-in",
        "--leverage-predicated-value",
        "--transform-ctrl-to-data-flow",
        "--fold-constant",
        "--insert-data-mov",
        "--bind-source-iteration-domain",
    ]
    plan: dict[str, list[str]] = {
        "taskflow": [
            str(optimizer), str(source), *common,
            "--affine-loop-perfection", "--convert-affine-to-taskflow",
            "-o", str(taskflow),
        ],
        "caller-noalias": [
            str(optimizer), str(taskflow), "--verify-each", "--mlir-print-op-generic",
            "--import-input0-caller-noalias=" + " ".join((
                "target=" + function,
                "caller=main",
                "caller-evidence=" + str(caller),
                "static-bound=" + bound,
                "input0-only=true",
                "prepared-external-caller=true",
                "prepared-input=" + str(taskflow),
                "evidence-output=" + str(noalias_proof),
                "logical-shapes=" + contract["shapes"],
            )),
            "-o", str(noalias),
        ],
        "bind-caller-shapes": [
            str(optimizer), str(noalias), "--verify-each", "--mlir-print-op-generic",
            make_bind_pipeline(function, contract["argument_dimensions"]),
            "-o", str(shaped),
        ],
        "facts": [
            str(optimizer), str(canonical), "--verify-each",
            "--architecture-spec=" + str(architecture),
            "--extract-joint-task-graph-facts=" + " ".join((
                "function=" + function,
                "output=" + str(facts),
                "fact-only=true",
            )),
            "-o", os.devnull,
        ],
        "verify-source-domain": [
            str(optimizer), str(canonical), "--verify-each",
            "--architecture-spec=" + str(architecture),
            "--verify-source-iteration-domain-partitions=" + " ".join((
                "parent-module=" + str(canonical),
                "function=" + function,
            )),
            "-o", os.devnull,
        ],
    }
    normalize_input = shaped
    if workload == "raytracing" and ray_fission_split_at:
        plan["ray-fission"] = [
            str(optimizer), str(shaped),
            "--pass-pipeline=builtin.module(func.func(fission-ray-carried-reduction{split-at="
            + str(ray_fission_split_at) + "}))",
            *common, "-o", str(fissioned),
        ]
        normalize_input = fissioned
    if emit_fission_source:
        prepared = out / "pre-neura.mlir"
        plan["prepare-fission-source"] = [
            str(optimizer), str(normalize_input), *common,
            "--architecture-spec=" + str(architecture), *prep_pipeline[:2],
            "-o", str(prepared),
        ]
        normalize_input = prepared
        prep_pipeline = prep_pipeline[2:]
    plan["normalize"] = [
        str(optimizer), str(normalize_input), *common,
        "--architecture-spec=" + str(architecture), *prep_pipeline,
        "-o", str(canonical),
    ]
    ordered_keys = ["taskflow", "caller-noalias", "bind-caller-shapes"]
    if workload == "raytracing" and ray_fission_split_at:
        ordered_keys.append("ray-fission")
    if emit_fission_source:
        ordered_keys.append("prepare-fission-source")
    ordered_keys.extend(("normalize", "facts", "verify-source-domain"))
    plan = {key: plan[key] for key in ordered_keys}
    if include_cost:
        assert model is not None
        ensemble, checkpoint_dir = model
        stem = architecture.stem
        space = out / "candidate-space.jsonl"
        cost = out / "cost-catalog.json"
        cache = out / "ml-cache.json"
        plan["enumerate-candidate-space"] = [
            str(optimizer), str(canonical), "--verify-each",
            "--architecture-spec=" + str(architecture),
            "--enumerate-analytical-task-candidates=" + " ".join((
                "function=" + function,
                "output=" + str(space),
                "factored-output=true",
                "search-policy=complete-cartesian",
                "max-cgras-per-task=4",
                "graph-variant-id=" + GRAPH_VARIANT_ID,
            )),
            "-o", os.devnull,
        ]
        plan["predict-cost-catalog"] = [
            str(optimizer), str(canonical), "--verify-each",
            "--architecture-spec=" + str(architecture),
            "--predict-analytical-task-cost-catalog=" + " ".join((
                "function=" + function,
                "space-file=" + str(space),
                "ensemble-file=" + str(ensemble),
                "checkpoint-dir=" + str(checkpoint_dir),
                "architecture-contract=neura-architecture-v1:" + stem,
                "architecture-path=" + str(architecture),
                "source-git-repository=" + source_repository,
                "source-git-commit=" + source_commit,
                "graph-variant-id=" + GRAPH_VARIANT_ID,
                "model-namespace=" + model_namespace,
                "diagnostic-ii-ceiling=" + str(diagnostic_ii_ceiling),
                "cache=" + str(cache),
                "output=" + str(cost),
            )),
            "-o", os.devnull,
        ]
        if allow_unsupported_model_shapes:
            for index, argument in enumerate(plan["predict-cost-catalog"]):
                if argument.startswith("--predict-analytical-task-cost-catalog="):
                    plan["predict-cost-catalog"][index] += (
                        " allow-unsupported-above-model-ceiling=true"
                    )
    return plan


def invoke(argv: list[str], directory: Path, label: str) -> dict[str, Any]:
    steps_dir = directory / "steps"
    steps_dir.mkdir(parents=True, exist_ok=True)
    record_path = steps_dir / (label + ".command.json")
    stdout_path = steps_dir / (label + ".stdout.log")
    stderr_path = steps_dir / (label + ".stderr.log")
    record: dict[str, Any] = {
        "argv": argv,
        "started_unix": time.time(),
        "stdout_log": str(stdout_path),
        "stderr_log": str(stderr_path),
    }
    write_json(record_path, record)
    try:
        with stdout_path.open("w") as stdout, stderr_path.open("w") as stderr:
            result = subprocess.run(argv, stdout=stdout, stderr=stderr, check=False)
        record["exit_code"] = result.returncode
    except OSError as exc:
        record["launch_error"] = str(exc)
        record["exit_code"] = None
    record["ended_unix"] = time.time()
    write_json(record_path, record)
    if record["exit_code"] != 0:
        raise CommandFailure(
            f"{label} failed (exit {record['exit_code']}); see {stderr_path}", record
        )
    return record


def validate_facts(
    path: Path, workload: str, expected_task_count: int | None = None
) -> dict[str, Any]:
    try:
        facts = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError) as exc:
        raise PreparationError(f"cannot read C++ facts JSON: {exc}") from exc
    tasks = facts.get("tasks")
    expected = (
        expected_task_count
        if expected_task_count is not None
        else EXPECTED_TASK_COUNTS[workload]
    )
    if not isinstance(tasks, list) or len(tasks) != expected:
        raise PreparationError(
            f"{workload} facts have {len(tasks) if isinstance(tasks, list) else 'no'} tasks; expected {expected}"
        )
    incomplete = []
    for task in tasks:
        if (
            task.get("source_iteration_domain_status") != "certified-complete"
            or task.get("source_iteration_domain_certified") is not True
            or task.get("source_iteration_domain_complete") is not True
            or not isinstance(task.get("taskflow_trip_count"), int)
            or task["taskflow_trip_count"] <= 0
            or not isinstance(task.get("effective_mapper_firing_count"), int)
            or task["effective_mapper_firing_count"] <= 0
            or not isinstance(task.get("source_iteration_work_count"), int)
            or task["source_iteration_work_count"] <= 0
        ):
            incomplete.append(task.get("task_name", task.get("task_index", "?")))
    if incomplete:
        raise PreparationError(
            f"{workload} facts are not certified-complete for tasks: {incomplete}"
        )
    return facts


def validate_ray_fission_records(
    path: Path, facts: dict[str, Any], split_at: int
) -> dict[str, Any]:
    """Read and cross-check the fission attributes emitted by the C++ pass."""
    try:
        lines = path.read_text().splitlines()
    except OSError as exc:
        raise PreparationError(f"cannot read C++ fission output: {exc}") from exc

    emitted: list[dict[str, Any]] = []
    module_text = "\n".join(lines)
    for schema_match in re.finditer(
        r'amoeba\.fission\.schema\s*=\s*"([^"]+)"', module_text
    ):
        line_start = module_text.rfind("\n", 0, schema_match.start()) + 1
        line_end = module_text.find("\n", schema_match.start())
        if line_end < 0:
            line_end = len(module_text)
        line = module_text[line_start:line_end]
        schema_value = schema_match.group(1)
        op_start = module_text.rfind('"taskflow.task"', 0, line_start)
        if op_start < 0:
            raise PreparationError(
                "C++ fission provenance is not attached to a Taskflow task"
        )
        body_start = module_text.find("({", op_start)
        if body_start < 0 or body_start >= line_start:
            raise PreparationError(
                "C++ fission provenance is not attached to a Taskflow task body"
            )
        task_name_match = re.search(
            r'task_name\s*=\s*"([^"]+)"',
            module_text[op_start:body_start if body_start >= 0 else line_start],
        )
        source_match = re.search(
            r'amoeba\.fission\.source_task\s*=\s*"([^"]+)"', line
        )
        stage_match = re.search(
            r'amoeba\.fission\.stage\s*=\s*(-?\d+)\s*:\s*i64', line
        )
        interval_match = re.search(
            r'amoeba\.fission\.lane_interval\s*=\s*array<i64:\s*(-?\d+)\s*,\s*(-?\d+)\s*>',
            line,
        )
        parent_work_match = re.search(
            r'amoeba\.fission\.parent_source_work_count\s*=\s*(-?\d+)\s*:\s*i64',
            line,
        )
        stage_work_match = re.search(
            r'amoeba\.fission\.stage_source_work_count\s*=\s*(-?\d+)\s*:\s*i64',
            line,
        )
        state_match = re.search(
            r'amoeba\.fission\.state_link\s*=\s*"([^"]+)"', line
        )
        if not all((task_name_match, source_match, stage_match, interval_match,
                    parent_work_match, stage_work_match, state_match)):
            raise PreparationError(
                "C++ fission output has incomplete stage provenance attributes"
            )
        emitted.append({
            "task_name": task_name_match.group(1),
            "schema": schema_value,
            "source_task": source_match.group(1),
            "stage": int(stage_match.group(1)),
            "lane_interval": [int(interval_match.group(1)),
                              int(interval_match.group(2))],
            "parent_source_work_count": int(parent_work_match.group(1)),
            "stage_source_work_count": int(stage_work_match.group(1)),
            "state_link": state_match.group(1),
        })

    expected = [
        {"stage": 0, "task_name": "Task_13.fission.0", "interval": [0, split_at]},
        {"stage": 1, "task_name": "Task_13", "interval": [split_at, 8]},
    ]
    if len(emitted) != 2:
        raise PreparationError(
            f"C++ fission output has {len(emitted)} attributed stages; expected two"
        )
    by_stage = {record["stage"]: record for record in emitted}
    if set(by_stage) != {0, 1}:
        raise PreparationError("C++ fission output has duplicate or missing stages")

    tasks = facts.get("tasks", [])
    facts_by_name = {task.get("task_name"): task for task in tasks}
    if len(facts_by_name) != len(tasks):
        raise PreparationError("canonical facts contain duplicate task names")
    parent_work_counts = set()
    stages = []
    for expected_stage in expected:
        stage = by_stage[expected_stage["stage"]]
        if (
            stage["schema"] != "ray-carried-min-index-fission-v1"
            or stage["source_task"] != "Task_13"
            or stage["task_name"] != expected_stage["task_name"]
            or stage["lane_interval"] != expected_stage["interval"]
            or stage["stage_source_work_count"] <= 0
            or stage["state_link"] != "taskflow-raw:row-index,row-best"
        ):
            raise PreparationError(
                f"C++ fission stage {expected_stage['stage']} does not match the requested split"
            )
        fact = facts_by_name.get(stage["task_name"])
        if (
            fact is None
            or fact.get("source_iteration_work_count")
            != stage["stage_source_work_count"]
        ):
            raise PreparationError(
                f"C++ fission stage {stage['task_name']} work count disagrees with canonical facts"
            )
        parent_work_counts.add(stage["parent_source_work_count"])
        stages.append({
            "stage": stage["stage"],
            "task_name": stage["task_name"],
            "lane_interval": stage["lane_interval"],
            "source_work_count": stage["stage_source_work_count"],
            "state_link": stage["state_link"],
        })
    if (
        len(parent_work_counts) != 1
        or next(iter(parent_work_counts)) <= 0
        or sum(stage["source_work_count"] for stage in stages)
        != next(iter(parent_work_counts))
    ):
        raise PreparationError(
            "C++ fission stage work counts do not partition the parent source work"
        )
    return {
        "schema": "ray-carried-min-index-fission-v1",
        "source_task": "Task_13",
        "taskflow_fission_module": str(path.resolve()),
        "split_at": split_at,
        "source_work_count": next(iter(parent_work_counts)),
        "stages": stages,
        "provenance": (
            "attributes emitted by the C++ fission pass and cross-checked "
            "against canonical C++ facts"
        ),
    }


def prepare_one(
    workload: str,
    optimizer: Path,
    architecture: Path,
    inputs: Inputs,
    output_root: Path,
    model: tuple[Path, Path] | None,
    include_cost: bool,
    dry_run: bool,
    allow_unsupported_model_shapes: bool = False,
    ray_fission_split_at: int = 0,
    source_repository: str = MODEL_SOURCE_REPOSITORY,
    source_commit: str = MODEL_SOURCE_COMMIT,
    model_namespace: str = MODEL_NAMESPACE,
    diagnostic_ii_ceiling: int = 20,
    emit_fission_source: bool = False,
) -> dict[str, Any]:
    out = output_root / workload
    out.mkdir(parents=True, exist_ok=True)
    active_fission_split = ray_fission_split_at if workload == "raytracing" else 0
    expected_task_count = EXPECTED_TASK_COUNTS[workload] + (
        1 if active_fission_split else 0
    )
    plan = command_plan(optimizer, architecture, inputs, workload, out, model,
                        include_cost, allow_unsupported_model_shapes,
                        active_fission_split, source_repository, source_commit,
                        model_namespace, diagnostic_ii_ceiling, emit_fission_source)
    plan_path = out / "plan.json"
    plan_record = {
        "workload": workload,
        "function": CONTRACTS[workload]["function"],
        "expected_task_count": expected_task_count,
        "source_correction": inputs.records[workload].get("source_correction"),
        "input_state": "source manifest input is already statically bound; no Python body rewrite or rebinding is performed",
        "steps": plan,
        "dry_run": dry_run,
    }
    if active_fission_split:
        plan_record["ray_fission_split_at"] = active_fission_split
    write_json(plan_path, plan_record)
    if dry_run:
        return {
            "workload": workload,
            "status": "dry-run",
            "plan": str(plan_path),
            "ray_fission_split_at": active_fission_split,
        }

    summary: dict[str, Any] = {
        "workload": workload,
        "function": CONTRACTS[workload]["function"],
        "status": "running",
        "steps": [],
        "canonical": str(out / "canonical.mlir"),
        "facts": str(out / "facts.json"),
        "caller_noalias_proof": str(out / "caller-noalias-proof.json"),
        "ray_fission_split_at": active_fission_split,
        "runtime_ii_ceiling": diagnostic_ii_ceiling,
        "training_ii_ceiling": 20,
    }
    if emit_fission_source:
        summary["prepared_source_file"] = str(out / "pre-neura.mlir")
    source_correction = inputs.records[workload].get("source_correction")
    if source_correction is not None:
        summary["source_correction"] = source_correction
    write_json(out / "preparation.json", summary)
    try:
        labels = ["taskflow", "caller-noalias", "bind-caller-shapes"]
        if active_fission_split:
            labels.append("ray-fission")
        if emit_fission_source:
            labels.append("prepare-fission-source")
        labels.append("normalize")
        for label in labels:
            summary["steps"].append(invoke(plan[label], out, label))
        if not (out / "caller-noalias-proof.json").is_file():
            raise PreparationError("C++ caller noalias pass did not write its proof JSON")
        summary["steps"].append(invoke(plan["facts"], out, "facts"))
        facts = validate_facts(
            out / "facts.json", workload, expected_task_count
        )
        if active_fission_split:
            summary["ray_fission"] = validate_ray_fission_records(
                out / "taskflow-fission.mlir", facts, active_fission_split
            )
        summary["steps"].append(invoke(plan["verify-source-domain"], out, "verify-source-domain"))
        domain_proof = {
            "schema": "orbit-source-iteration-domain-verification-run-v1",
            "workload": workload,
            "function": CONTRACTS[workload]["function"],
            "status": "cpp-verifier-passed",
            "verifier": "verify-source-iteration-domain-partitions",
            "canonical_module": str(out / "canonical.mlir"),
            "complete_task_count": len(facts["tasks"]),
            "task_count": expected_task_count,
            "meaning": "C++ standalone source-domain verifier exited successfully against the canonical module.",
        }
        write_json(out / "source-iteration-domain-proof.json", domain_proof)
        summary["source_iteration_domain_proof"] = str(out / "source-iteration-domain-proof.json")
        summary["complete_task_count"] = len(facts["tasks"])
        if include_cost:
            for label in ("enumerate-candidate-space", "predict-cost-catalog"):
                try:
                    summary["steps"].append(invoke(plan[label], out, label))
                except PreparationError as exc:
                    summary["cost_catalog_error"] = str(exc)
                    summary["cost_catalog_status"] = "failed"
                    raise
            summary["cost_catalog"] = str(out / "cost-catalog.json")
            summary["cost_catalog_status"] = "ready"
        summary["status"] = "prepared"
    except PreparationError as exc:
        if isinstance(exc, CommandFailure):
            summary["steps"].append(exc.record)
        summary["status"] = "failed"
        summary["error"] = str(exc)
        write_json(out / "preparation.json", summary)
        return summary
    write_json(out / "preparation.json", summary)
    return summary


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--optimizer", type=Path, required=True,
                        help="Executable C++ mlir-amoeba-opt.")
    parser.add_argument("--artifact-root", type=Path, required=True,
                        help="Artifact containing reference/input0-source-domains/.")
    parser.add_argument("--architecture", type=Path, required=True,
                        help="Neura architecture YAML used by C++ passes.")
    parser.add_argument("--model", type=Path,
                        help="Formal model directory or ensemble.json; required for --cost-catalog.")
    parser.add_argument("--diagnostic-ii-ceiling", type=int, choices=(20, 23), default=20)
    parser.add_argument("--emit-fission-source", action="store_true",
                        help="Preserve the exact source-owned pre-Neura seam for S5 replay.")
    parser.add_argument("--source-repository")
    parser.add_argument("--source-commit")
    parser.add_argument("--model-namespace")
    parser.add_argument("--output-root", type=Path, required=True,
                        help="Fresh directory for canonical modules, facts, proofs, and logs.")
    parser.add_argument("--workloads", nargs="+", choices=WORKLOADS, default=list(WORKLOADS),
                        help="Workloads to prepare (default: all six).")
    parser.add_argument("--jobs", type=parse_jobs, default=1,
                        help="Concurrent workload processes, 1 through 3 (default: 1).")
    parser.add_argument("--cost-catalog", action="store_true",
                        help="Also enumerate C++ task-shape spaces and predict cost catalogs.")
    parser.add_argument("--allow-unsupported-model-shapes", action="store_true",
                        help="Keep C++-proved out-of-model shapes as explicit unsupported cost rows.")
    parser.add_argument(
        "--ray-fission-split-at", type=parse_ray_fission_split_at,
        default=0, metavar="N",
        help=("Opt in to source-owned Ray Task_13 lane fission at N "
              "(1 through 7); 0 disables it."),
    )
    parser.add_argument("--dry-run", action="store_true",
                        help="Validate inputs and write exact command plans without running C++ passes.")
    return parser


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    try:
        selected = list(dict.fromkeys(args.workloads))
        if args.ray_fission_split_at and "raytracing" not in selected:
            raise PreparationError(
                "--ray-fission-split-at requires raytracing in --workloads"
            )
        if args.diagnostic_ii_ceiling == 23 and selected != ["raytracing"]:
            raise PreparationError("II23 diagnostic source preparation must select only original Ray")
        inputs = load_inputs(args.artifact_root, selected)
        optimizer = optimizer_path(args.optimizer)
        architecture = args.architecture.resolve()
        if not architecture.is_file():
            raise PreparationError(f"architecture spec is missing: {architecture}")
        model = parse_model(args.model, args.cost_catalog)
        if model is not None:
            metadata = json.loads(model[0].read_text())
            if metadata.get("schema") == "orbit-cgra-ii-per-cgra-2x2-direct-ensemble-cpp-v1":
                if not args.source_repository or not args.source_commit:
                    raise PreparationError("direct 2x2 costs require explicit --source-repository and --source-commit")
                namespace = metadata.get("model_namespace")
                if not isinstance(namespace, str) or not namespace:
                    raise PreparationError("direct 2x2 model has no namespace")
                if args.model_namespace and args.model_namespace != namespace:
                    raise PreparationError("model namespace differs from the direct 2x2 ensemble")
                args.model_namespace = namespace
                training = metadata.get("architecture", {}).get("exact_yaml_text")
                if not isinstance(training, str):
                    raise PreparationError("direct 2x2 model has no exact training architecture")
                expected = training
                if args.diagnostic_ii_ceiling == 23:
                    if len(re.findall(r"(?m)^[ \t]*ctrl_mem_items: 20$", training)) != 1:
                        raise PreparationError("II23 requires exact control-memory20 training architecture")
                    expected = re.sub(r"(?m)^([ \t]*ctrl_mem_items: )20$", r"\g<1>23", training)
                if expected != architecture.read_text():
                    raise PreparationError("architecture bytes differ from the bound direct 2x2 runtime ceiling")
        args.source_repository = args.source_repository or MODEL_SOURCE_REPOSITORY
        args.source_commit = args.source_commit or MODEL_SOURCE_COMMIT
        args.model_namespace = args.model_namespace or MODEL_NAMESPACE
        output_root = args.output_root.resolve()
        forbidden = (inputs.artifact_root / "reference/input0-source-domains").resolve()
        try:
            output_root.relative_to(forbidden)
        except ValueError:
            pass
        else:
            raise PreparationError("output root must not overwrite source-domain inputs or caller evidence")
        output_root.mkdir(parents=True, exist_ok=True)
        for workload in selected:
            existing = output_root / workload
            if existing.exists() and any(existing.iterdir()):
                raise PreparationError(
                    f"workload output already exists and may contain stale artifacts: {existing}"
                )
        results: list[dict[str, Any]] = []
        if args.jobs == 1 or len(selected) == 1:
            results = [prepare_one(w, optimizer, architecture, inputs, output_root,
                                   model, args.cost_catalog, args.dry_run,
                                   args.allow_unsupported_model_shapes,
                                   args.ray_fission_split_at, args.source_repository,
                                   args.source_commit, args.model_namespace,
                                   args.diagnostic_ii_ceiling, args.emit_fission_source) for w in selected]
        else:
            with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
                futures = {
                pool.submit(prepare_one, w, optimizer, architecture, inputs, output_root,
                            model, args.cost_catalog, args.dry_run,
                            args.allow_unsupported_model_shapes,
                            args.ray_fission_split_at, args.source_repository,
                            args.source_commit, args.model_namespace,
                            args.diagnostic_ii_ceiling, args.emit_fission_source): w
                    for w in selected
                }
                for future in concurrent.futures.as_completed(futures):
                    workload = futures[future]
                    try:
                        results.append(future.result())
                    except Exception as exc:  # Keep sibling workload runs independent.
                        results.append({"workload": workload, "status": "failed", "error": str(exc)})
        results.sort(key=lambda record: selected.index(record["workload"]))
        all_succeeded = all(item["status"] in ("prepared", "dry-run") for item in results)
        run_status = "failed" if not all_succeeded else ("dry-run" if args.dry_run else "prepared")
        run_record = {
            "schema": "orbit-input0-source-domain-preparation-run-v1",
            "status": run_status,
            "artifact_root": str(inputs.artifact_root),
            "manifest": str(inputs.manifest_path),
            "optimizer": str(optimizer),
            "architecture": str(architecture),
            "cost_catalog_requested": args.cost_catalog,
            "allow_unsupported_model_shapes": args.allow_unsupported_model_shapes,
            "ray_fission_split_at": args.ray_fission_split_at,
            "dry_run": args.dry_run,
            "jobs": args.jobs,
            "workloads": results,
        }
        write_json(output_root / "run.json", run_record)
        print(json.dumps({
            "status": run_status,
            "record": str(output_root / "run.json"),
            "workloads": [
                {key: item[key] for key in (
                    "workload", "status", "complete_task_count", "error"
                ) if key in item}
                for item in results
            ],
        }, sort_keys=True))
        return 0 if run_status != "failed" else 1
    except PreparationError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
