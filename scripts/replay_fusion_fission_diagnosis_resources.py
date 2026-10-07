#!/usr/bin/env python3
"""Native-check the best nonidentity target of each frozen R9 resource prefix.

Canonical identity is separately eligible as the best prediction. This script
also checks a worse predicted target when identity wins, to expose that limited
ranking comparison; it does not certify the best native result of the prefix.
"""
from __future__ import annotations
import argparse
import importlib.util
import json
from pathlib import Path
import sys


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--panel-root", type=Path, required=True)
    ap.add_argument("--config", type=Path, required=True)
    ap.add_argument("--mapping-cache", type=Path, required=True)
    ap.add_argument("--llvm-build", type=Path, default=Path("/home/x/shiran/llvm-project/build"))
    args = ap.parse_args()
    run = json.loads((args.panel_root / "run.json").read_text())
    if run["schema"] != "orbit-fusion-fission-resource-ablation-v1" or run["actual_new_objective_scores"] != 254:
        raise ValueError("expected one complete 64-point R9 paired panel, 254 actual C++ objectives")
    if len(run["cases"]) != 1:
        raise ValueError("each invocation owns exactly one independent panel")
    workload_rows = {x["workload"]: x for x in json.loads(args.config.read_text())["workloads"]}
    case_id, case = next(iter(run["cases"].items()))
    w = workload_rows[case["workload"]]
    runtime = Path(run["runtime_root"])
    sys.path.insert(0, str(runtime / "scripts"))
    path = Path(__file__).resolve().parent / "run_fusion_fission_controlled_probes.py"
    spec = importlib.util.spec_from_file_location("r9_resource_native_helper", path)
    control = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = control
    spec.loader.exec_module(control)
    nr, replay = control._helpers(runtime)
    records = []
    for side, receipt in case["side_results"].items():
        if receipt["status"] != "complete-prefix" or len(receipt["points"]) != 64:
            raise ValueError("incomplete resource prefix")
        targets = [p for p in receipt["points"] if p.get("status") == "scored"]
        best = min(targets, key=lambda p: (p["target_costs"]["predicted_whole_program_cycles"], p["point"]))
        point = args.panel_root / case_id / side / "points" / f"{best['point']:03d}"
        selection = nr.normalize_selection(best["target_selection"])
        summary, command, numeric = control._native_and_numeric(
            nr=nr, replay=replay, candidate_selections=[selection], identity_control=None,
            pair_controls=[], artifact_root=runtime, optimizer=Path(w["optimizer"]),
            llvm_build=args.llvm_build, reference_root=runtime / ".work/selected-native-numeric-gate",
            architecture=Path(w["architecture"]), network=Path(w["inter_task_network"]),
            sram_config=runtime / "config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json",
            mapping_cache=args.mapping_cache, stage="full-joint-fission", workload=case["workload"],
            canonical=Path(w["canonical"]), function=w["function"], protocol_path=Path(receipt["protocol"]),
            source_contract=Path(w["source_contract"]), source_binding=Path(receipt["source_binding"]),
            prepared_source=Path(w["prepared_source_file"]), max_partition_factor=8,
            fission_cap=64, output_dir=point)
        records.append({"side": side, "point": best["point"], "selection_rule": "best predicted nonidentity target; identity remains separately eligible",
                        "native_summary": summary, "numeric_command": command, "numeric": numeric})
    control._write_json(args.panel_root / "native-resources.json", {"schema": "orbit-r9-resource-native-v1", "case": case_id,
        "native_scheduler_objectives": len(records), "exhaustive_native_prefix": False, "records": records})
    print(json.dumps({"case": case_id, "status": "complete", "records": len(records)}))


if __name__ == "__main__":
    main()
