#!/usr/bin/env python3
"""Measure C++ source-certified all-unit inputs under the ablation protocol."""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import shutil
import sys

from neighborhood_replay import infer_function
from replay_cpp_global_top5 import invoke, write
import validate_embedded_native_trace as trace_validator

ROOT = Path(__file__).resolve().parents[1]


def measure(workload, entry, config_base, protocol, args):
    directory = args.output_root / workload
    directory.mkdir()
    original = Path(entry["canonical"])
    if not original.is_absolute():
        original = config_base / original
    canonical = directory / "canonical-input.mlir"
    shutil.copyfile(original, canonical)
    function = infer_function(canonical, entry.get("function"))
    result = {
        "schema": "orbit-input0-all-unit-native-v1", "workload": workload,
        "status": "incomplete", "shape_per_task": "1x1 CGRA",
        "ml_model_consumed": False, "baseline_cycles": None,
        "mapper_equality": "pending", "numeric": "pending",
        "independent_trace": "pending", "sram_gate": "pending",
        "formal_go": False, "canonical_input": str(canonical),
        "optimizer": str(args.optimizer), "architecture": str(args.architecture),
        "source_contract": str(args.source_contract_file),
        "protocol": str(args.protocol), "commands": {},
    }
    base_options = ["--verify-each", f"--architecture-spec={args.architecture}"]
    if args.inter_task_network:
        base_options.append(f"--joint-inter-task-network-spec={args.inter_task_network}")
        result["inter_task_network"] = str(args.inter_task_network)
        result["inter_task_network_text"] = args.inter_task_network.read_text()

    def run(label, input_path, flags, output_path):
        result["status"] = label + "_running"
        write(directory / "result.json", result)
        command = invoke([str(args.optimizer), str(input_path), *base_options,
                          *flags, "--mlir-print-op-generic", "-o", str(output_path)],
                         directory, label)
        result["commands"][label] = command
        if command["exit_code"]:
            result.update(status=label + "_failed", blocker=label + "_process_failed")
            write(directory / "result.json", result)
            return False
        return True

    search = protocol.get("search", {})
    active = search.get("active_transfer_arguments_by_workload", {}).get(
        workload, search.get("active_transfer_arguments", []))
    if active:
        proof_path = directory / "active-transfer-proof.json"
        prepared = directory / "active-transfer-input.mlir"
        if not run("active-transfer", canonical, [
                "--prove-static-active-transfer-shapes="
                f"function={function} arguments={','.join(map(str, active))} "
                f"report-output={proof_path}"], prepared):
            return result
        proof = json.loads(proof_path.read_text())
        if (search.get("active_transfer_require_proven", True) and
                (len(proof["proofs"]) != len(active) or
                 any(row.get("status") != "proven" for row in proof["proofs"]))):
            result.update(status="active-transfer_failed", blocker="required_active_transfer_unproven")
            write(directory / "result.json", result)
            return result
        result["active_transfer_proof"] = str(proof_path)
        canonical = prepared

    space = directory / "all-unit-space.jsonl"
    candidate = directory / "all-unit.mlir"
    mapped = directory / "mapped.mlir"
    native_root = directory / "native"
    native = native_root / "rank-0/native.mlir"
    native.parent.mkdir(parents=True)
    enumerate_flag = (
        f"--enumerate-analytical-task-candidates=function={function} output={space} "
        "factored-output=true max-cgras-per-task=1 graph-variant-id=identity")
    if not run("materialize", canonical, [enumerate_flag,
            f"--materialize-analytical-task-candidate=function={function} "
            f"candidates={space} candidate-id=candidate-0"], candidate):
        return result
    if not run("mapper", candidate, [
            f"--map-joint-scheduling-tasks=function={function} candidate-id=candidate-0 "
            f"all-unit-baseline=true mapping-cache-dir={args.mapping_cache}"], mapped):
        return result
    if not run("native", mapped, [
            "--orchestrate-tasks-on-accelerators="
            "orchestration-strategy=analytical-based-task-orchestration "
            "scheduling-mode=spatial-temporal dispatch-policy=fixed "
            "communication-mode=explicit exact-replay-timing=mapped"], native):
        return result

    manifest = json.loads(space.read_text().splitlines()[0])
    assert manifest["candidate_count"] == 1 and manifest["graph_variant_id"] == "identity"
    task_shapes = []
    for factor in manifest["factors"]:
        assert len(factor["shapes"]) == 1 and factor["shapes"][0]["cgra_count"] == 1
        task_shapes.append({"task": factor["task"], "trip_count": factor["trip_count"],
                            "shape": factor["shapes"][0]})
    trace = trace_validator.validate(native.read_text(),
        {"candidate_id": "candidate-0", "task_shapes": task_shapes}, "identity")
    write(directory / "independent-trace.json", trace)
    result.update(independent_trace=trace["status"], baseline_cycles=trace["native_cycles"],
                  mapper_equality="pass" if mapped.read_text().count(
                      "amoeba.mapper_replay_verified") == len(task_shapes) else "fail",
                  status="numeric_running")
    write(directory / "result.json", result)
    numeric = invoke([sys.executable, str(ROOT / "scripts/run_input0_numeric.py"),
        "--workloads", workload, "--stage", "shape-only", "--ranks", "0",
        "--native-root", str(native_root), "--output-root", str(directory / "numeric"),
        "--optimizer", str(args.optimizer), "--llvm-build", str(args.llvm_build),
        "--jobs", "1"], directory, "numeric")
    result["commands"]["numeric"] = numeric
    result["numeric"] = "pass" if numeric["exit_code"] == 0 else "fail"
    capacity = json.loads(args.sram_config.read_text())
    assert capacity["schema"] == "orbit-vectorcgra-sram-configuration-v1"
    result["sram_capacity_config"] = str(args.sram_config)
    if capacity["per_cgra_capacity_bytes"] is None:
        assert capacity["capacity_status"] == "pending"
        result.update(sram_blocker="target_sram_capacity_unestablished", sram_capacity_evaluated=False)
    else:
        gate = directory / "sram-gate.json"
        if run("sram", native, [
                "--verify-production-sram-native-capacity-gate="
                f"capacity-bytes-per-cgra={capacity['per_cgra_capacity_bytes']} "
                f"grid-rows={capacity['fabric_rows']} grid-columns={capacity['fabric_columns']} output={gate}"],
                "/dev/null"):
            evidence = json.loads(gate.read_text())
            result.update(sram_gate=evidence["status"], sram_evidence=str(gate))
        else:
            result.update(sram_gate="pending", sram_blocker="native_sram_evidence_process_failed")
    result["status"] = ("complete" if result["numeric"] == result["independent_trace"] ==
                        result["mapper_equality"] == "pass" else "validation_failed")
    write(directory / "result.json", result)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for flag in ("config", "protocol", "source-contract-file", "optimizer", "architecture",
                 "mapping-cache", "output-root", "llvm-build", "sram-config"):
        parser.add_argument("--" + flag, type=Path, required=True)
    parser.add_argument("--inter-task-network", type=Path)
    parser.add_argument("--workloads", nargs="+")
    args = parser.parse_args()
    for key, value in vars(args).items():
        if isinstance(value, Path):
            setattr(args, key, value.resolve())
    config = json.loads(args.config.read_text())
    protocol = json.loads(args.protocol.read_text())
    args.output_root.mkdir(parents=True, exist_ok=False)
    args.mapping_cache.mkdir(parents=True, exist_ok=True)
    rows = []
    for workload in args.workloads or list(config["workloads"]):
        rows.append(measure(workload, config["workloads"][workload], args.config.parent, protocol, args))
        write(args.output_root / "summary.json", rows)
        print(json.dumps({key: rows[-1].get(key) for key in
                          ("workload", "status", "baseline_cycles", "blocker")}), flush=True)
    return 0 if all(row["status"] == "complete" for row in rows) else 2


if __name__ == "__main__":
    raise SystemExit(main())
