#!/usr/bin/env python3
"""Durable, single-core input-0 AMOEBA fixed-decision validation queue.

This driver consumes only current-body f45 mapper profiles. It replays the
original f45 throughput scheduler, then source-binds and validates that fixed
decision trace with a supplied immutable ORBIT compiler before running independent
trace and numeric checks. A failed workload is recorded and does not stop the
remaining queue. Mapper jobs are owned by the separate profile worker; when a
profile set is incomplete this process waits in five-minute intervals.
"""

from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
WORKLOADS = ("llama", "harris", "radar", "gcn", "lu", "raytracing")
ARCH_REL = Path("config/architectures/amoeba_4x4_cgra_2x2_context6.yaml")
NETWORK_REL = Path("config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml")
MODEL_REL = Path("reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json")
MODEL_NAMESPACE = "orbit-per-cgra-2x2-direct-4member-v1"
MODEL_REPOSITORY = "https://github.com/guosran/orbit.git"
MODEL_COMMIT = "6a1b6fcf6e155651e96b3b881565ad58fdf0c03e"
ORIGINAL_REPOSITORY = "https://github.com/ShangkunLi/neura"
ORIGINAL_COMMIT = "f45a0c5f4cc3163a016250fee865c19ec56f0fa0"
MIN_FREE_BYTES = 2 * 1024**3


def atomic_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.partial-{os.getpid()}")
    temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
    os.replace(temporary, path)


def read_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text())
    if not isinstance(value, dict):
        raise ValueError(f"expected JSON object: {path}")
    return value


def relative(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(ROOT.resolve()))
    except ValueError:
        return str(path)


class Queue:
    def __init__(self, args: argparse.Namespace):
        self.args = args
        self.root = ROOT
        self.post = ROOT / ".work/post-publication"
        self.results = args.results_root.resolve()
        self.queue_root = args.run_root.resolve()
        self.inputs = read_json(args.inputs)
        if self.inputs.get("schema") != "orbit-original-amoeba-current-profile-inputs-v1":
            raise ValueError("unsupported baseline input manifest")
        records = self.inputs.get("records")
        if not isinstance(records, dict) or any(name not in records for name in args.workloads):
            raise ValueError("baseline input manifest does not cover requested workloads")
        self.input_records = records
        self.queue_root.mkdir(parents=True, exist_ok=True)
        self.arch = args.architecture.resolve()
        self.network = args.network.resolve()
        self.model = args.ensemble.resolve()
        self.optimizer = args.optimizer.resolve()
        self.original_optimizer = args.original_optimizer.resolve()
        self.contract = args.source_contract.resolve()
        self.validator_source = ROOT / "scripts/validate_original_amoeba_fixed_retiming.py"
        self.numeric_runner = ROOT / "scripts/run_input0_numeric.py"
        self.llvm = args.llvm_build.resolve()
        self.references = args.reference_root.resolve()
        self.llama_harness = ROOT / "reference/input0-neighborhood/numeric/task0-task1-k2.runner.mlir"
        self.lock = self.queue_root / "queue.lock"
        self.started = time.time()
        self.queue_state: dict[str, Any] = {
            "schema": "orbit-original-amoeba-input0-native-queue-v2",
            "status": "running",
            "pid": os.getpid(),
            "cpu_affinity": [args.cpu],
            "input_index": 0,
            "architecture": relative(self.arch),
            "inter_task_network": relative(self.network),
            "model_namespace": MODEL_NAMESPACE,
            "training_ii_ceiling": 20,
            "runtime_ii_ceiling": args.diagnostic_ii_ceiling,
            "diagnostic_minimum_legal_profile_initialization":
                args.diagnostic_minimum_legal_profile_initialization,
            "workloads": list(args.workloads),
            "current_workload": None,
            "current_step": "initializing",
            "subprocess_timeout": None,
            "started_at": datetime.now(timezone.utc).isoformat(),
            "progress_directory": relative(self.results),
            "queue_log": relative(self.queue_root / "queue.log"),
        }

    def update_queue(self, **updates: Any) -> None:
        self.queue_state.update(updates)
        self.queue_state["updated_at"] = datetime.now(timezone.utc).isoformat()
        atomic_json(self.queue_root / "queue-state.json", self.queue_state)

    def progress_path(self, workload: str) -> Path:
        return self.results / workload / "progress.json"

    def update_progress(self, workload: str, step: str, status: str, reason: str, **extra: Any) -> None:
        record = {
            "schema": "orbit-original-amoeba-input0-progress-v1",
            "workload": workload,
            "input_index": 0,
            "input_id": "input0",
            "current_step": step,
            "status": status,
            "reason": reason[:1200],
            "architecture": relative(self.arch),
            "inter_task_network": relative(self.network),
            "model_namespace": MODEL_NAMESPACE,
            "formal_go": False,
            "updated_at": datetime.now(timezone.utc).isoformat(),
        }
        record.update(extra)
        atomic_json(self.progress_path(workload), record)
        self.update_queue(current_workload=workload, current_step=step, current_workload_status=status)

    def disk_check(self, workload: str, step: str) -> bool:
        free = shutil.disk_usage(self.root).free
        self.update_queue(last_disk_free_bytes=free)
        if free >= MIN_FREE_BYTES:
            return True
        self.fail(
            workload,
            step,
            f"free disk space {free} bytes is below the 2 GiB safety floor; queue did not delete or overwrite files",
            status="failed",
        )
        return False

    def log(self, message: str) -> None:
        stamp = datetime.now(timezone.utc).isoformat()
        line = f"{stamp} {message}\n"
        with (self.queue_root / "queue.log").open("a") as stream:
            stream.write(line)
            stream.flush()
        print(line, end="", flush=True)

    def run(self, workload: str, out: Path, step: str, argv: list[str]) -> None:
        if not self.disk_check(workload, step):
            raise StepFailed(step, "disk safety floor reached")
        command_path = out / f"{step}.command.json"
        stdout_path = out / f"{step}.stdout.log"
        stderr_path = out / f"{step}.stderr.log"
        taskset_argv = ["taskset", "--cpu-list", str(self.args.cpu), *map(str, argv)]
        command = {
            "schema": "orbit-original-amoeba-queue-command-v1",
            "workload": workload,
            "step": step,
            "argv": taskset_argv,
            "cwd": relative(self.root),
            "stdout": relative(stdout_path),
            "stderr": relative(stderr_path),
            "started_at": datetime.now(timezone.utc).isoformat(),
            "subprocess_timeout": None,
            "status": "running",
        }
        atomic_json(command_path, command)
        self.update_progress(workload, step, "running", f"{step} subprocess running on CPU {self.args.cpu}; no timeout", evidence_root=relative(out))
        self.log(f"{workload}: start {step}; argv recorded at {relative(command_path)}")
        began = time.monotonic()
        try:
            with stdout_path.open("w") as stdout, stderr_path.open("w") as stderr:
                completed = subprocess.run(taskset_argv, cwd=self.root, stdout=stdout, stderr=stderr)
            code = completed.returncode
            error = None
        except OSError as exc:
            code = None
            error = str(exc)
        command.update(
            status="finished" if code == 0 else "failed",
            exit_code=code,
            error=error,
            elapsed_seconds=round(time.monotonic() - began, 3),
            ended_at=datetime.now(timezone.utc).isoformat(),
        )
        atomic_json(command_path, command)
        if code != 0:
            diagnostic = self.tail(stderr_path) or self.tail(stdout_path) or error or f"exit code {code}"
            raise StepFailed(step, diagnostic, code)
        self.log(f"{workload}: passed {step} ({time.monotonic() - began:.1f}s)")

    @staticmethod
    def tail(path: Path, limit: int = 1400) -> str:
        try:
            text = path.read_text(errors="replace")
            lines = text.splitlines()
            for index, line in enumerate(lines):
                marker = ": error:"
                if marker in line:
                    # Keep the actionable compiler message only. The following
                    # note can dump the entire current MLIR operation, which is
                    # neither a useful status reason nor stable across builds.
                    message = line.split(marker, 1)[1].strip()
                    return message[:limit]
                if line.lstrip().startswith("error:"):
                    return line.lstrip()[len("error:"):].strip()[:limit]
            return text[-limit:].strip()
        except OSError:
            return ""

    def wait_for_profiles(self, workload: str) -> tuple[Path, Path, dict[str, Any]]:
        profile_root = self.root / self.input_records[workload]["profile_root"]
        profiles = self.profile_file(workload)
        state_path = profile_root / "run-state.json"
        while True:
            self.update_progress(
                workload,
                "waiting_for_fresh_mapper_profiles",
                "waiting",
                f"waiting for complete current-body f45 profiles in {relative(profile_root)}; recheck every {self.args.poll_seconds}s; no mapper timeout",
                profile_root=relative(profile_root),
            )
            if profiles.is_file():
                try:
                    data = read_json(profiles)
                except (OSError, json.JSONDecodeError, ValueError):
                    data = {}
                expected = data.get("expected_candidate_count")
                completed = data.get("completed_candidate_count")
                tasks = data.get("tasks")
                if (
                    type(expected) is int
                    and expected > 0
                    and completed == expected
                    and isinstance(tasks, list)
                    and tasks
                    and all(isinstance(task, dict) and isinstance(task.get("profiles"), list) for task in tasks)
                ):
                    state = {}
                    if state_path.is_file():
                        try:
                            state = read_json(state_path)
                        except Exception:
                            pass
                    source = self.root / self.input_records[workload]["profile_input"]
                    if not source.is_file():
                        source = None
                    if source is not None:
                        self.log(f"{workload}: fresh profiles complete {completed}/{expected}; input={relative(source)}")
                        return profile_root, source, data
                    reason = f"complete profiles exist but current prepared pending.mlir is missing under {relative(profile_root)}"
                    self.fail(workload, "profile_input_preflight", reason)
                    raise StepFailed("profile_input_preflight", reason)
            if state_path.is_file():
                try:
                    state = read_json(state_path)
                except Exception:
                    state = {}
                state_status = str(state.get("status", ""))
                if state_status.lower() in {"failed", "error", "cancelled", "aborted"}:
                    reason = str(state.get("reason", f"profile worker finished with status {state_status}"))
                    self.fail(workload, "fresh_mapper_profiles", reason)
                    raise StepFailed("fresh_mapper_profiles", reason)
            time.sleep(max(300, self.args.poll_seconds))

    def profile_file(self, workload: str) -> Path:
        record = self.input_records[workload]
        return self.root / record.get(
            "profile_file", str(Path(record["profile_root"]) / "task-profiles.json")
        )

    def replica_evidence_file(self, workload: str) -> Path | None:
        path = self.input_records[workload].get("replica_profile_evidence")
        if path is None:
            return None
        if not isinstance(path, str) or not path:
            raise StepFailed("replica_profile_preflight", "replica evidence must name a manifest file")
        return self.root / path

    def wait_for_replica_profiles(self, workload: str) -> Path | None:
        """Wait for actual profiles named by the C++ materialization manifest.

        This checks file readiness and identity. The source-owned retimer owns
        partition coverage, placement orientation and selected mapper costs.
        """
        path = self.replica_evidence_file(workload)
        if self.args.original_f45_replica_scaling:
            if path is not None:
                raise StepFailed("replica_profile_preflight", "original F45 scaling and actual child profile evidence are mutually exclusive")
            return None
        if path is None:
            return None
        while True:
            if path.is_file():
                try:
                    evidence = read_json(path)
                except (OSError, ValueError) as error:
                    raise StepFailed("replica_profile_preflight", str(error)) from error
                records = evidence.get("records")
                if (evidence.get("schema") != "amoeba-original-replica-profile-evidence-v1"
                        or not isinstance(records, list) or not records):
                    raise StepFailed("replica_profile_preflight", "replica evidence manifest schema or records are invalid")
                identities = set()
                ready = True
                for record in records:
                    if (not isinstance(record, dict)
                            or any(not isinstance(record.get(key), str) or not record[key]
                                   for key in ("parent_task", "materialized_task", "function", "materialized_module", "profile_file", "body_export_file"))
                            or type(record.get("replica_id")) is not int or record["replica_id"] < 0):
                        raise StepFailed("replica_profile_preflight", "replica evidence record identity or file pointers are invalid")
                    identity = (record["parent_task"], record["replica_id"])
                    if identity in identities:
                        raise StepFailed("replica_profile_preflight", "replica evidence duplicates a parent/replica identity")
                    identities.add(identity)
                    module = self.root / record["materialized_module"]
                    profile_file = self.root / record["profile_file"]
                    body_file = self.root / record["body_export_file"]
                    if not all(file.is_file() for file in (module, profile_file, body_file)):
                        ready = False
                        continue
                    profile = read_json(profile_file)
                    body = read_json(body_file)
                    expected = profile.get("expected_candidate_count")
                    if (type(expected) is not int or expected <= 0
                            or profile.get("completed_candidate_count") != expected):
                        ready = False
                        continue
                    child = record["materialized_task"]
                    if (profile.get("function") != record["function"]
                            or body.get("function") != record["function"]
                            or child not in {row.get("task") for row in profile.get("tasks", []) if isinstance(row, dict)}
                            or child not in {row.get("task") for row in body.get("tasks", []) if isinstance(row, dict)}):
                        raise StepFailed("replica_profile_preflight", "completed replica evidence does not contain its named child/function")
                if ready:
                    self.log(f"{workload}: actual replica evidence ready; {len(records)} named children; source/cost checks remain in C++")
                    return path
            state_path = path.parent / "run-state.json"
            if state_path.is_file():
                state = read_json(state_path)
                if state.get("status") in {"failed", "error", "cancelled", "aborted"}:
                    raise StepFailed("replica_mapper_profiles", str(state.get("reason") or "replica profile worker failed"))
            self.update_progress(
                workload, "waiting_for_replica_mapper_profiles", "waiting",
                f"waiting for actual source-certified child profiles in {relative(path)}; recheck every {self.args.poll_seconds}s; no mapper timeout",
                replica_profile_evidence=relative(path),
            )
            time.sleep(max(300, self.args.poll_seconds))

    def fail(self, workload: str, step: str, reason: str, status: str = "failed") -> None:
        out = self.queue_root / workload
        record = self.base_result(workload, out)
        record.update(status=status, failed_step=step, reason=reason[:3000], diagnostic_summary=reason[:3000])
        record["current_step"] = step
        atomic_json(self.results / workload / "result.json", record)
        self.update_progress(workload, step, status, reason, evidence_root=relative(out))
        self.log(f"{workload}: {status} at {step}: {reason[:400].replace(chr(10), ' ')}")

    def base_result(self, workload: str, out: Path) -> dict[str, Any]:
        return {
            "schema": "orbit-original-amoeba-input0-2x2-result-v1",
            "workload": workload,
            "input_index": 0,
            "input_id": "input0",
            "architecture": relative(self.arch),
            "inter_task_network": relative(self.network),
            "model_namespace": MODEL_NAMESPACE,
            "model_source": {
                "repository": "https://github.com/guosran/cgra-ii-predictor",
                "branch": "orbit-2x2-predictor",
                "commit": "3ade31806cb4c92e31888109f7c42b8a77e4cbce",
                "candidate_status": "candidate_pending_amoeba_benchmark_overlap_audit",
                "production_ready": False,
            },
            "original_compiler": {
                "repository": ORIGINAL_REPOSITORY,
                "branch": "hpca-eval",
                "commit": ORIGINAL_COMMIT,
                "optimizer": relative(self.original_optimizer),
            },
            "optimizer": relative(self.optimizer),
            "source_model_contract": relative(self.contract),
            "artifact_evidence_root": relative(out),
            "production_ready": False,
            "formal_go": False,
            "training_ii_ceiling": 20,
            "runtime_ii_ceiling": self.args.diagnostic_ii_ceiling,
            "model_extrapolation": self.args.diagnostic_ii_ceiling == 23,
            "replica_profile_evidence": self.input_records[workload].get("replica_profile_evidence"),
            "original_f45_replica_scaling": self.args.original_f45_replica_scaling,
            "diagnostic_minimum_legal_profile_initialization":
                self.args.diagnostic_minimum_legal_profile_initialization,
        }

    def caller_proof(self, workload: str) -> Path:
        path = self.root / self.input_records[workload]["caller_shape_proof"]
        if path.is_file():
            return path
        raise StepFailed("caller_proof_lookup", f"missing prepared caller/shape proof: {relative(path)}")

    def process(self, workload: str) -> None:
        result_path = self.results / workload / "result.json"
        progress_path = self.progress_path(workload)
        if result_path.is_file():
            try:
                existing = read_json(result_path)
                if (
                    existing.get("status") == "complete"
                    and existing.get("numeric") == "pass"
                    and existing.get("independent_trace") == "pass"
                    and existing.get("mapper_equality") == "pass"
                    and existing.get("input_index") == 0
                    and existing.get("input_id") == "input0"
                    and existing.get("model_namespace") == MODEL_NAMESPACE
                    and existing.get("architecture") == relative(self.arch)
                    and existing.get("inter_task_network") == relative(self.network)
                    and existing.get("optimizer") == relative(self.optimizer)
                    and existing.get("source_model_contract") == relative(self.contract)
                    and existing.get("original_compiler", {}).get("optimizer")
                    == relative(self.original_optimizer)
                    and existing.get("replica_profile_evidence")
                    == self.input_records[workload].get("replica_profile_evidence")
                    and existing.get("original_f45_replica_scaling", False)
                    == self.args.original_f45_replica_scaling
                    and type(existing.get("native_cycles")) is int
                    and existing["native_cycles"] > 0
                ):
                    self.log(f"{workload}: existing exact-binding result is fully accepted; skip")
                    return
                if existing.get("status") in {"failed", "unsupported_unproven"} and not self.args.retry_terminal:
                    self.log(f"{workload}: existing terminal {existing.get('status')} record retained; skip rerun")
                    return
            except Exception:
                pass
        out = self.queue_root / workload
        out.mkdir(parents=True, exist_ok=True)
        self.results.joinpath(workload).mkdir(parents=True, exist_ok=True)
        result = self.base_result(workload, out)
        result.update(status="running", current_step="waiting_for_fresh_mapper_profiles")
        atomic_json(result_path, result)
        self.update_progress(workload, "waiting_for_fresh_mapper_profiles", "waiting", "waiting for current-body f45 mapper profile completeness")
        profile_root, pending, profiles_data = self.wait_for_profiles(workload)
        replica_evidence = self.wait_for_replica_profiles(workload)
        profile_file = self.profile_file(workload)
        profile_function = profiles_data.get("function")
        if not isinstance(profile_function, str) or not profile_function:
            raise StepFailed("profile_preflight", "fresh task profiles have no function symbol")
        shape_proof_path = self.caller_proof(workload)
        shape_proof = read_json(shape_proof_path)
        function = shape_proof.get("target_function")
        static_bound = shape_proof.get("static_bound")
        logical_shapes = shape_proof.get("logical_shapes")
        if function != profile_function:
            raise StepFailed("profile_binding", f"caller proof target {function!r} differs from fresh profile function {profile_function!r}")
        if type(static_bound) is not int or not isinstance(logical_shapes, list) or not logical_shapes or not all(isinstance(item, str) for item in logical_shapes):
            raise StepFailed("caller_proof_preflight", "caller proof lacks static_bound or exact logical_shapes")
        caller_evidence = self.root / "reference/input0-source-domains/callers" / f"{workload}.mlir"
        if not caller_evidence.is_file():
            raise StepFailed("caller_evidence_lookup", f"missing caller evidence {relative(caller_evidence)}")

        # Do not silently overwrite an incomplete previous execution.
        if any(out.iterdir()):
            raise StepFailed("output_collision", f"evidence directory already contains files: {relative(out)}")

        body_proof = profile_root / "profile-body-proof.json"
        scheduled = out / "scheduled-original-f45.mlir"
        bound = out / "scheduled-source-bound.mlir"
        caller_bound = out / "caller-bound.mlir"
        imported_proof = out / "caller-noalias-proof.json"
        body_preflight = [
            str(self.original_optimizer), str(pending), "--verify-each",
            f"--architecture-spec={self.arch}",
            f"--verify-task-profiler-body-equivalence=output={body_proof}",
            "-o", os.devnull,
        ]
        self.run(workload, out, "body_equivalence_preflight", body_preflight)
        if not body_proof.is_file():
            raise StepFailed("body_equivalence_preflight", "original f45 verifier did not write a body proof")

        schedule_options = (
            "orchestration-strategy=throughput-guided scheduling-mode=spatial-temporal "
            "task-profile-json=" + str(profile_file)
        )
        if self.args.diagnostic_minimum_legal_profile_initialization:
            schedule_options += " diagnostic-minimum-legal-profile-initialization=true"
        schedule = [
            str(self.original_optimizer), str(pending), "--verify-each",
            f"--architecture-spec={self.arch}",
            "--orchestrate-task-on-cgra=" + schedule_options,
            "--mlir-print-op-generic", "-o", str(scheduled),
        ]
        self.run(workload, out, "original_f45_scheduler", schedule)

        bind_source = [
            str(self.optimizer), str(scheduled), "--verify-each",
            f"--architecture-spec={self.arch}",
            f"--joint-inter-task-network-spec={self.network}",
            "--bind-source-iteration-domain",
            "--mlir-print-op-generic", "-o", str(bound),
        ]
        self.run(workload, out, "source_domain_bind", bind_source)

        import_options = " ".join((
            f"target={function}",
            "caller=main",
            f"caller-evidence={caller_evidence}",
            f"static-bound={static_bound}",
            "input0-only=true",
            "prepared-external-caller=true",
            f"prepared-input={bound}",
            f"evidence-output={imported_proof}",
            "logical-shapes=" + ";".join(logical_shapes),
        ))
        importer = [
            str(self.optimizer), str(bound), "--verify-each",
            f"--architecture-spec={self.arch}",
            f"--joint-inter-task-network-spec={self.network}",
            f"--import-input0-caller-noalias={import_options}",
            "--mlir-print-op-generic", "-o", str(caller_bound),
        ]
        self.run(workload, out, "caller_noalias_shape_import", importer)

        active_arguments = self.input_records[workload].get("active_transfer_arguments", [])
        if active_arguments:
            if (not isinstance(active_arguments, list)
                    or any(type(index) is not int or index < 0 for index in active_arguments)
                    or len(set(active_arguments)) != len(active_arguments)):
                raise StepFailed("active_transfer_preflight", "active transfer arguments must be unique nonnegative integers")
            active_bound = out / "active-transfer-bound.mlir"
            active_proof = out / "active-transfer-proof.json"
            self.run(workload, out, "active_transfer_source_proof", [
                str(self.optimizer), str(caller_bound), "--verify-each",
                f"--architecture-spec={self.arch}",
                f"--joint-inter-task-network-spec={self.network}",
                "--prove-static-active-transfer-shapes="
                f"function={function} arguments={','.join(map(str, active_arguments))} "
                f"report-output={active_proof}",
                "--mlir-print-op-generic", "-o", str(active_bound),
            ])
            rows = read_json(active_proof).get("proofs", [])
            if (len(rows) != len(active_arguments)
                    or {row.get("argument") for row in rows} != set(active_arguments)
                    or any(row.get("status") != "proven" for row in rows)):
                raise StepFailed("active_transfer_source_proof", "required source-proved active transfer arguments remain unsupported")
            caller_bound = active_bound

        partition = [
            str(self.optimizer), str(caller_bound), "--verify-each",
            f"--architecture-spec={self.arch}",
            "--verify-source-iteration-domain-partitions=" + f"parent-module={bound} function={function}",
            "-o", os.devnull,
        ]
        self.run(workload, out, "source_partition_verification", partition)

        source_facts = out / "original-source-domain-facts.json"
        if self.args.diagnostic_ii_ceiling == 23:
            self.run(workload, out, "source_domain_facts", [
                str(self.optimizer), str(caller_bound), "--verify-each",
                f"--architecture-spec={self.arch}",
                f"--joint-inter-task-network-spec={self.network}",
                f"--extract-joint-task-graph-facts=function={function} output={source_facts} fact-only=true",
                "-o", os.devnull,
            ])

        adapter_catalog = out / "cost-catalog.json"
        adapter_ir = out / "adapter.mlir"
        adapter_options = " ".join((
            f"function={function}",
            f"body-export-file={body_proof}",
            f"profile-file={profile_file}",
            f"ensemble-file={self.model}",
            f"checkpoint-dir={self.model.parent}",
            f"architecture-contract={self.args.architecture_contract}",
            f"architecture-path={self.arch}",
            f"source-git-repository={MODEL_REPOSITORY}",
            f"source-git-commit={MODEL_COMMIT}",
            f"model-namespace={MODEL_NAMESPACE}",
            f"output={adapter_catalog}",
        ))
        if self.args.diagnostic_ii_ceiling == 23:
            adapter_options += " diagnostic-ii-ceiling=23"
        adapter = [
            str(self.optimizer), str(caller_bound), "--verify-each",
            f"--architecture-spec={self.arch}",
            f"--joint-inter-task-network-spec={self.network}",
            f"--adapt-original-amoeba-profile-costs={adapter_options}",
            "-o", str(adapter_ir),
        ]
        self.run(workload, out, "direct_model_cost_adapter", adapter)

        retimer_result = out / "retimer-result.json"
        retimed_ir = out / "retimed-native.mlir"
        replica_module = None
        if replica_evidence is not None:
            evidence_records = read_json(replica_evidence)["records"]
            modules = {record["materialized_module"] for record in evidence_records}
            if len(modules) != 1:
                raise StepFailed("replica_profile_preflight", "replica records must bind one complete materialized module")
            replica_module = self.root / next(iter(modules))
        retimer_options = " ".join((
            f"function={function}",
            f"parent-cost-file={adapter_catalog}",
            f"profile-body-export-file={body_proof}",
            f"output={retimer_result}",
        ))
        if self.args.diagnostic_ii_ceiling == 23:
            retimer_options += " diagnostic-ii-ceiling=23"
        if replica_evidence is not None:
            retimer_options += f" replica-profile-evidence-file={replica_evidence}"
        if self.args.original_f45_replica_scaling:
            retimer_options += " original-f45-replica-scaling=true"
        retimer = [
            str(self.optimizer), str(replica_module or caller_bound), "--verify-each",
            f"--architecture-spec={self.arch}",
            f"--joint-inter-task-network-spec={self.network}",
            f"--retime-original-amoeba-fixed-decisions={retimer_options}",
            "-o", str(retimed_ir),
        ]
        self.run(workload, out, "fixed_decision_retimer", retimer)

        materialized_facts = None
        if replica_module is not None:
            materialized_facts = out / "materialized-source-domain-facts.json"
            self.run(workload, out, "materialized_source_domain_facts", [
                str(self.optimizer), str(replica_module), "--verify-each",
                f"--architecture-spec={self.arch}",
                f"--joint-inter-task-network-spec={self.network}",
                "--extract-joint-task-graph-facts="
                f"function={function} output={materialized_facts} fact-only=true",
                "-o", os.devnull,
            ])

        validator = out / "tools/validate_original_amoeba_fixed_retiming.py"
        validator.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(self.validator_source, validator)
        validation = out / "trace-validation.json"
        validate = [
            sys.executable, str(validator),
            "--retimed", str(retimer_result),
            "--original-mlir", str(caller_bound),
            "--profile-file", str(profile_file),
            "--body-proof", str(body_proof),
            "--cost-catalog", str(adapter_catalog),
            "--network-file", str(self.network),
            "--output", str(validation),
        ]
        if self.args.diagnostic_ii_ceiling == 23:
            validate.extend(["--diagnostic-ii-ceiling", "23", "--source-domain-facts", str(source_facts)])
        if replica_evidence is not None:
            validate.extend(["--replica-profile-evidence", str(replica_evidence)])
            validate.extend(["--materialized-source-facts", str(materialized_facts)])
        self.run(workload, out, "independent_trace_validation", validate)
        trace = read_json(validation)
        if trace.get("status") != "pass" or trace.get("formal_go") is not False:
            raise StepFailed("independent_trace_validation", f"validator did not pass strict fixed-decision trace: {trace}")

        # Legalize an isolated host-validation copy. Keep the retimed IR and
        # all source/mapper/trace witnesses unchanged for their binding checks.
        numeric_native = out / "numeric-lower-affine.mlir"
        self.run(workload, out, "numeric_affine_legalization", [
            str(self.optimizer), str(retimed_ir), "--verify-each",
            "--lower-affine", "-o", str(numeric_native),
        ])
        native_view = out / "numeric-native-view"
        rank_dir = native_view / "rank-0"
        rank_dir.mkdir(parents=True, exist_ok=True)
        native_link = rank_dir / "native.mlir"
        if native_link.exists() or native_link.is_symlink():
            raise StepFailed("numeric_input_preparation", f"refusing to overwrite {native_link}")
        native_link.symlink_to(os.path.relpath(numeric_native, rank_dir))
        numeric_out = out / "numeric"
        numeric = [
            sys.executable, str(self.numeric_runner),
            "--workloads", workload,
            "--stage", "original-amoeba-fixed-retiming",
            "--ranks", "0",
            "--native-root", str(native_view),
            "--jobs", "1",
            "--artifact-root", str(self.root),
            "--output-root", str(numeric_out),
            "--optimizer", str(self.optimizer),
            "--llvm-build", str(self.llvm),
            "--reference-root", str(self.references),
        ]
        if workload == "llama":
            numeric.extend(["--llama-harness", str(self.llama_harness)])
        self.run(workload, out, "input0_numeric_gate", numeric)
        numeric_result_path = numeric_out / workload / "original-amoeba-fixed-retiming-rank-0/result.json"
        numeric_result = read_json(numeric_result_path)
        if numeric_result.get("status") != "pass" or numeric_result.get("mismatches") != 0:
            raise StepFailed("input0_numeric_gate", f"numeric gate did not pass: {numeric_result}")

        retimed = read_json(retimer_result)
        cycles = retimed.get("mapped_whole_program_cycles")
        if type(cycles) is not int or cycles <= 0:
            raise StepFailed("result_admission", "retimer did not report a positive integer mapped_whole_program_cycles")
        final = self.base_result(workload, out)
        final.update({
            "status": "complete",
            "native_cycles": cycles,
            "native_cycles_status": "pass",
            "native_cycles_semantics": "retimed fixed-decision schedule makespan; this validates the supplied original f45 shape/placement/order decisions using current-body selected f45 compiled II, source-certified trip counts, direct-2x2 cost catalog and explicit inter-task network; it is not a wall-clock measurement or an independently reproduced original full-flow cycle count",
            "retimed_result_scope": retimed.get("whole_program_result_scope"),
            "retimer_cycle_source": retimed.get("duration_source"),
            "mapper_equality": "pass",
            "numeric": "pass",
            "numeric_result": {
                "actual_nonzero": numeric_result.get("actual_nonzero"),
                "element_comparisons": numeric_result.get("element_comparisons"),
                "expected_nonzero": numeric_result.get("expected_nonzero"),
                "mismatches": numeric_result.get("mismatches"),
                "result_path": relative(numeric_result_path),
            },
            "independent_trace": "pass",
            "trace_result": {
                "dependency_count": trace.get("dependency_count"),
                "iteration_domain_coverage_status": trace.get("iteration_domain_coverage_status"),
                "path": relative(validation),
                "routed_data_pairs": trace.get("routed_data_pairs"),
                "task_count": trace.get("task_count"),
            },
            "iteration_domain_coverage_status": trace.get("iteration_domain_coverage_status"),
            "preserved_original_decisions": {
                "status": "pass",
                "selected_shape_placement_cells_and_order_equal": "independent trace validator",
                "task_count": trace.get("task_count"),
                "all_active_replicas_one": all(int(row.get("active_replicas", 0)) == 1 for row in retimed.get("original_decisions", [])),
                "dispatch_order": retimed.get("dispatch_order"),
                "original_parent_dispatch_order": retimed.get("original_parent_dispatch_order"),
            },
            "fresh_mapper_profiles": {
                "path": relative(profile_file),
                "expected": profiles_data.get("expected_candidate_count"),
                "completed": profiles_data.get("completed_candidate_count"),
                "successful": sum(
                    int(bool(profile.get("mapper_succeeded")))
                    for task in profiles_data.get("tasks", [])
                    for profile in task.get("profiles", [])
                ),
                "task_count": profiles_data.get("task_count"),
                "selected_profile_body_binding_count": len(retimed.get("task_costs", [])),
                "selected_shape_body_equality": retimed.get("body_equivalence_status"),
                "body_proof": relative(body_proof),
            },
            "original_f45_scheduler": {
                "status": "pass",
                "profile_input": relative(pending),
                "scheduled_output": relative(scheduled),
                "profile_file": relative(profile_file),
                "source_domain_bind": relative(bound),
                "caller_shape_binding": relative(caller_bound),
            },
            "source_partition_status": "pass",
            "retimer_status": "pass",
            "adapter_status": "pass",
            "formal_go": False,
            "production_ready": False,
        })
        if self.args.original_f45_replica_scaling:
            policy = retimed.get("replica_timing_policy")
            if not isinstance(policy, dict):
                raise StepFailed("result_admission", "explicit F45 replica scaling result omits its timing policy")
            final["replica_timing_policy"] = policy
        atomic_json(result_path, final)
        self.update_progress(
            workload,
            "complete",
            "complete",
            "fresh current-body f45 profiles, original scheduler, source-domain/caller proofs, direct adapter, fixed-decision retimer, independent trace and numeric gate passed",
            native_cycles=cycles,
            numeric="pass",
            independent_trace="pass",
            mapper_equality="pass",
            formal_go=False,
            result_path=relative(result_path),
        )
        self.log(f"{workload}: complete native_cycles={cycles}; numeric/trace/mapper equality pass; formal_go=false")

    def run_all(self) -> int:
        try:
            self.lock.parent.mkdir(parents=True, exist_ok=True)
            fd = os.open(self.lock, os.O_CREAT | os.O_EXCL | os.O_WRONLY, 0o644)
            os.write(fd, f"pid={os.getpid()}\nstarted={datetime.now(timezone.utc).isoformat()}\n".encode())
            os.close(fd)
        except FileExistsError:
            print(f"queue lock already exists: {self.lock}", file=sys.stderr)
            return 2
        atomic_json(self.queue_root / "queue-state.json", self.queue_state)
        try:
            preflight = [self.arch, self.network, self.model, self.optimizer, self.original_optimizer,
                         self.contract, self.validator_source, self.numeric_runner, self.llvm / "bin/mlir-opt",
                         self.llvm / "bin/mlir-runner"]
            missing = [relative(path) for path in preflight if not path.exists()]
            if missing:
                self.log("preflight missing: " + ", ".join(missing))
                self.update_queue(status="failed_preflight", reason="missing required pinned input/tool", missing=missing)
                return 2
            self.log(f"queue started pid={os.getpid()} cpu={self.args.cpu}; disk_free={shutil.disk_usage(self.root).free}; waits={max(300, self.args.poll_seconds)}s")
            for workload in self.args.workloads:
                self.update_queue(current_workload=workload, current_step="start")
                try:
                    self.process(workload)
                except StepFailed as exc:
                    # Most pipeline errors have already written an exact progress/result record.
                    # Ensure a result exists even for early profile/caller lookup failures.
                    path = self.results / workload / "result.json"
                    try:
                        existing = read_json(path)
                        if existing.get("status") not in ("failed", "unsupported_unproven"):
                            raise ValueError("not terminal")
                    except Exception:
                        self.fail(workload, exc.step, exc.reason, status=classify_failure(exc))
                    self.log(f"{workload}: isolated failure {exc.step}: {exc.reason[:500]}")
                except Exception as exc:
                    self.fail(workload, "queue_exception", f"{type(exc).__name__}: {exc}")
                    self.log(f"{workload}: isolated exception {type(exc).__name__}: {exc}")
            statuses = {}
            for workload in self.args.workloads:
                try:
                    statuses[workload] = read_json(self.results / workload / "result.json").get("status", "missing")
                except Exception:
                    statuses[workload] = "missing"
            final_status = ("complete" if all(value == "complete" for value in statuses.values())
                            else "finished_with_failures" if all(
                                value in {"complete", "unsupported_unproven", "failed"}
                                for value in statuses.values()) else "incomplete")
            self.update_queue(status=final_status, workload_statuses=statuses, ended_at=datetime.now(timezone.utc).isoformat(), elapsed_seconds=round(time.time() - self.started, 1))
            self.log(f"queue finished status={final_status} workloads={statuses}")
            return 0 if final_status == "complete" else 1
        finally:
            try:
                self.lock.unlink()
            except OSError:
                pass


class StepFailed(RuntimeError):
    def __init__(self, step: str, reason: str, exit_code: int | None = None):
        super().__init__(reason)
        self.step = step
        self.reason = reason
        self.exit_code = exit_code


def classify_failure(exc: StepFailed) -> str:
    diagnostic = exc.reason.lower()
    if any(token in diagnostic for token in (
        "no explicit single-replica source-domain binding",
        "source iteration-domain partition verification failed",
        "unproven source-domain coverage",
        "cannot prove source-domain partition",
    )):
        return "unsupported_unproven"
    return "failed"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--inputs", type=Path, required=True,
                        help="manifest of current-body profile/input/caller-proof paths")
    parser.add_argument("--run-root", type=Path, required=True,
                        help="new evidence and queue directory; use a separate root per parallel worker")
    parser.add_argument("--optimizer", type=Path, required=True)
    parser.add_argument("--original-optimizer", type=Path, required=True)
    parser.add_argument("--source-contract", type=Path, required=True)
    parser.add_argument("--results-root", type=Path,
                        default=ROOT / "results/input0-amoeba-full-2x2-direct")
    parser.add_argument("--architecture", type=Path, default=ROOT / ARCH_REL)
    parser.add_argument("--architecture-contract",
                        default="neura-architecture-v1:amoeba_4x4_cgra_2x2_context6")
    parser.add_argument("--network", type=Path, default=ROOT / NETWORK_REL)
    parser.add_argument("--ensemble", type=Path, default=ROOT / MODEL_REL)
    parser.add_argument("--diagnostic-ii-ceiling", type=int, choices=(20, 23), default=20,
                        help="explicit runtime ceiling; 23 uses the unchanged model weights beyond its training ceiling")
    parser.add_argument("--diagnostic-minimum-legal-profile-initialization", action="store_true",
                        help="opt in to the f45 scheduler extension when a task has no mapped single-CGRA profile")
    parser.add_argument("--original-f45-replica-scaling", action="store_true",
                        help="preserve the original F45 replica duration estimate with common mapper/native timing")
    parser.add_argument("--llvm-build", type=Path, required=True)
    parser.add_argument("--reference-root", type=Path, required=True)
    parser.add_argument("--cpu", type=int, default=10)
    parser.add_argument("--poll-seconds", type=int, default=300)
    parser.add_argument("--workloads", nargs="+", choices=WORKLOADS, default=list(WORKLOADS))
    parser.add_argument("--retry-terminal", action="store_true", help="re-run terminal failed/unsupported workload records")
    args = parser.parse_args()
    if args.diagnostic_ii_ceiling == 23 and args.results_root.resolve() == (ROOT / "results/input0-amoeba-full-2x2-direct").resolve():
        parser.error("II23 diagnostics require a separate --results-root")
    if args.diagnostic_minimum_legal_profile_initialization and args.diagnostic_ii_ceiling != 23:
        parser.error("minimum-legal-profile initialization requires the explicit II23 diagnostic")
    if args.poll_seconds < 300:
        parser.error("--poll-seconds must be at least 300 seconds")
    if args.cpu not in os.sched_getaffinity(0):
        parser.error(f"CPU {args.cpu} is not in this process's allowed affinity")
    if args.run_root.exists():
        parser.error("--run-root must be new; preserve previous execution evidence")
    contract = read_json(args.source_contract)
    pin = contract.get("immutable_optimizer_pin", "").replace("${ARTIFACT_ROOT}", str(ROOT))
    if Path(pin).resolve() != args.optimizer.resolve():
        parser.error("optimizer differs from the immutable source contract pin")
    return Queue(args).run_all()


if __name__ == "__main__":
    raise SystemExit(main())
