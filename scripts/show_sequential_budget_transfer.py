#!/usr/bin/env python3
"""Query once and export the separately labelled unused-budget supplement."""
import argparse
import csv
import hashlib
import importlib.util
from pathlib import Path

import compact_sequential_raw as journals
import run_sequential_comparison as comparison
import show_sequential_comparison as evidence
import summarize_sequential_comparison as summary
from sequential_validation_audit import require_complete_validation


def audit_supplement_bindings(main_root, root, cells):
    """Verify the existing pre-run bindings, without inventing a launch sidecar.

    The supplemental coordinator records per-cell inputs and its frozen source
    contract, but does not write the main batch's validation sidecar. Its queue
    binds the runtime manifest before launch. That manifest binds the contract,
    whose exact replay payloads bind validation scripts. Native harness/tool
    dependencies retain the main batch's original pre-run byte bindings.
    """
    protocol = comparison.read(root / "protocol.json")
    if (protocol.get("experiment_kind") != "sequential-budget-transfer-supplement"
            or protocol["decision_flow_comparison"].get("sequential_budget_policy") != "transfer-unused"):
        raise ValueError("derived supplemental binding audit requires the explicit transfer protocol")
    if (root / "validation-payload-binding.json").is_file():
        # New cohorts bind all native dependencies before either batch starts.
        binding = comparison.read(root / "validation-payload-binding.json")
        evidence.audit_bindings(root, cells, validation_binding=binding)
        return binding
    queue = comparison.read(root / "queue-binding.json")
    plan = comparison.read(root / "experiment-plan.json")
    contract_path = Path(plan["source_contract"])
    runtime = contract_path.parent
    manifest_path = runtime / "budget-transfer-runtime.json"
    if str(manifest_path) not in {r["path"] for r in queue["runtime_bindings"]}:
        raise ValueError("supplement queue did not bind its frozen runtime manifest")
    for row in queue["runtime_bindings"]:
        if comparison.file_binding(row["path"]) != row:
            raise ValueError("supplement runtime byte binding changed: " + row["path"])
    manifest = comparison.read(manifest_path)
    if manifest.get("schema") != "orbit-sequential-budget-transfer-runtime-v1":
        raise ValueError("unknown supplemental runtime binding schema")
    runtime_rows = {row["path"]: row for row in manifest["runtime_bindings"]}
    if str(contract_path) not in runtime_rows:
        raise ValueError("supplement runtime did not bind its source contract")
    for row in runtime_rows.values():
        if comparison.file_binding(row["path"]) != row:
            raise ValueError("frozen supplemental payload changed: " + row["path"])
    contract = comparison.read(contract_path)
    files = {}
    for row in contract["replay_payloads"]:
        payload = row["text"].encode()
        bound = {"path": str(runtime / row["path"]), "size": len(payload),
                 "sha256": hashlib.sha256(payload).hexdigest()}
        if comparison.file_binding(bound["path"]) != bound:
            raise ValueError("validation script differs from frozen source contract: " + bound["path"])
        files[row["path"]] = bound
    for row in plan["coordinator_payloads"]:
        payload = row["exact_bytes"].encode()
        bound = {"path": row["path"], "size": len(payload),
                 "sha256": hashlib.sha256(payload).hexdigest()}
        if comparison.file_binding(bound["path"]) != bound:
            raise ValueError("supplement coordinator differs from recorded launch payload: " + bound["path"])
        files[bound["path"]] = bound
    main_binding = comparison.read(main_root / "validation-payload-binding.json")
    if manifest["base_contract"] != main_binding["source_contract"]:
        raise ValueError("supplement did not inherit the main bound validation contract")
    main_contract = comparison.read(main_binding["source_contract"]["path"])
    inherited_payloads = {r["path"] for r in main_contract["replay_payloads"]}
    for role, row in main_binding["files"].items():
        if role not in inherited_payloads:
            files[role] = row
    binding = {"schema": "orbit-sequential-transfer-derived-validation-binding-v1",
        "policy": "post-run audit derived from pre-run queue/runtime/cell source bindings and main native-tool bindings; no retrospective pre-launch sidecar",
        "source_contract": runtime_rows[str(contract_path)], "files": files}
    for workload, method in cells:
        cell = root / workload / method
        if comparison.read(cell / "comparison-binding.json") != comparison.read(cell / "search-input-binding.json"):
            raise ValueError("supplement comparison/search input bindings differ")
        bound = comparison.read(cell / "comparison-binding.json")["content_binding"]["source_contract"]
        if bound != binding["source_contract"]:
            raise ValueError("supplement cell used a different frozen source contract")
    evidence.audit_bindings(root, cells, validation_binding=binding)
    return binding


def audit_matched_inputs(main_root, root):
    evidence.audit_bindings(main_root, [(w, m) for w in ("gcn", "lu") for m in ("joint", "sequential-50")])
    audits = []
    for workload in ("gcn", "lu"):
        bindings = [comparison.read(base / workload / method / "comparison-binding.json")
                    for base, method in ((main_root, "joint"), (main_root, "sequential-50"), (root, "sequential-50-transfer"))]
        roles = ["canonical", "parent_cost_file", "initial_predictor_cache", "model", "architecture", "network", "sram"]
        if bindings[0]["protocol"].get("comparison_search_stage") == "full-joint-fission":
            roles += ["prepared_source", "optimizer", "source_contract"]
        for role in roles:
            identities = {(b["content_binding"][role]["sha256"], b["content_binding"][role]["size"]) for b in bindings}
            if len(identities) != 1:
                raise ValueError(f"supplement/main input contract mismatch: {workload}/{role}")
        search_fields = ("max_unique_complete_candidates_scored", "max_rounds", "round_score_quota", "beam_width", "diversity_min_slots", "max_partition_factor")
        for key in search_fields:
            if len({b["protocol"]["search"][key] for b in bindings}) != 1:
                raise ValueError(f"supplement/main search parameter mismatch: {workload}/{key}")
        for key in ("fabric", "scoring", "source_iteration_domain", "model_namespace"):
            if any(b["protocol"][key] != bindings[0]["protocol"][key] for b in bindings[1:]):
                raise ValueError(f"supplement/main production contract mismatch: {workload}/{key}")
        if bindings[0]["protocol"]["search"]["max_unique_complete_candidates_scored"] != 4096:
            raise ValueError("this supplemental report requires the matched 4096 allowance")
        contracts = [comparison.read(b["source_contract"]) for b in bindings]
        for c in contracts[1:]:
            if c["model_payloads"] != contracts[0]["model_payloads"] or c["source_commit"] != contracts[0]["source_commit"]:
                raise ValueError("supplement changed the predictor/model cost namespace")
        old = {r["path"]: r["text"] for r in contracts[0]["sources"]}
        fixed = {r["path"]: r["text"] for r in contracts[1]["sources"]}
        new = {r["path"]: r["text"] for r in contracts[2]["sources"]}
        changed = sorted(p for p in set(old) | set(new) if old.get(p) != new.get(p))
        if old != fixed or changed not in ([], ["lib/Backend/Neura/Orchestration/JointScheduling/JointNeighborhoodSearchPass.cpp"]):
            raise ValueError("mapper, materializer, registry or production scheduler source changed")
        if not changed and len({b["content_binding"]["optimizer"]["sha256"] for b in bindings}) != 1:
            raise ValueError("identical source requires the same immutable optimizer pin")
        audits.append({"workload": workload, "identical_bound_input_roles": roles,
            "identical_search_fields": list(search_fields), "changed_compiler_sources": changed,
            "model_payloads_identical": True, "main_fixed_split_source_identical": True,
            "source_change": ("same compiler; opt-in unused-budget policy" if not changed else "opt-in unused-budget option; independent32-call default-mode equivalence and source patch review recorded")})
    return audits


def audit_extension(fixed, transfer, main_root, root):
    workload = fixed["workload"]
    fixed_cell = main_root / workload / "sequential-50"
    transfer_cell = root / workload / "sequential-50-transfer"
    old_trace = journals.read_journal(fixed_cell / "search/budget-trace.jsonl")
    new_trace = journals.read_journal(transfer_cell / "search/budget-trace.jsonl")
    fields = ("candidate_id", "cumulative_evaluations", "incumbent_cycles", "phase",
              "scheduler_invoked", "score_cycles", "status")
    if len(new_trace) < len(old_trace) or any(
            any(a[k] != b[k] for k in fields) for a, b in zip(old_trace, new_trace)):
        raise ValueError("budget transfer changed the original objective trajectory: " + workload)
    raw = [comparison.read(c / "result.json") for c in (fixed_cell, transfer_cell)]
    anchors = [next(s for s in r["controls"] if s["control_role"] == "search_anchor") for r in raw]
    anchor_fields = ("action_history", "shapes", "predicted_whole_program_cycles",
                     "replayed_communication_edges", "task_costs")
    if any(anchors[0][k] != anchors[1][k] for k in anchor_fields):
        raise ValueError("budget transfer changed the phase-A incumbent: " + workload)
    old_stats, new_stats = fixed["search_stats"], transfer["search_stats"]
    for key in ("phase_evaluations", "phase_candidate_attempts", "phase_action_counts", "phase_objective_cache_hits"):
        if old_stats[key]["A"] != new_stats[key]["A"]:
            raise ValueError("budget transfer changed phase-A counters: " + workload + "/" + key)
    if fixed["anchor_native_cycles"] != transfer["anchor_native_cycles"]:
        raise ValueError("phase-A native control changed: " + workload)
    prefix = old_stats["frozen_action_prefix_length"]
    selections = [r["winner"]["selection"] for r in (fixed, transfer)]
    if (new_stats["frozen_action_prefix_length"] != prefix or any(
            s["action_history"]["actions"][:prefix] != anchors[0]["action_history"]["actions"]
            for s in selections)):
        raise ValueError("supplement winner changed the frozen graph prefix: " + workload)
    if any(s["action_history"].get("fissionActions", []) !=
           anchors[0]["action_history"].get("fissionActions", []) for s in selections):
        raise ValueError("supplement winner changed frozen source fission: " + workload)
    shapes = [{s["task"]: (s["rows"], s["cols"]) for s in selection["shapes"]} for selection in selections]
    changes = [{"task": task, "fixed_rows_cols": shapes[0].get(task),
                "transfer_rows_cols": shapes[1].get(task)}
               for task in sorted(shapes[0].keys() | shapes[1].keys())
               if shapes[0].get(task) != shapes[1].get(task)]
    return {"workload": workload, "original_objective_prefix_identical": True,
        "original_prefix_evaluations": len(old_trace), "compared_trajectory_fields": list(fields),
        "phase_a_incumbent_and_counters_identical": True,
        "phase_a_anchor_native_cycles": fixed["anchor_native_cycles"],
        "frozen_action_prefix_length": prefix, "winner_structural_prefix_identical": True,
        "additional_phase_b_calls": len(new_trace) - len(old_trace),
        "predicted_winner_cycles_fixed": fixed["predicted_winner_cycles"],
        "predicted_winner_cycles_transfer": transfer["predicted_winner_cycles"],
        "winner_resource_changes": changes,
        "fixed_winner_actions": selections[0]["action_history"]["actions"],
        "transfer_winner_actions": selections[1]["action_history"]["actions"]}


def show(root, main_root, output):
    state = root / "supplement-state.json"
    if not state.exists():
        print("剩余预算转交补充实验尚未启动。")
        return 0
    status = comparison.read(state)
    print("独立补充基线 sequential-50-transfer：" + status["status"])
    if status["status"] != "complete":
        if status["status"] == "failed":
            print(status["error"])
            return 2
        print("主表仍使用固定 50/50；本命令只查询一次。")
        return 0
    cells = [(w, "sequential-50-transfer") for w in ("gcn", "lu")]
    binding_audit = audit_supplement_bindings(main_root, root, cells)
    fairness = audit_matched_inputs(main_root, root)
    checker_path = comparison.ROOT / "reference/sequential-comparison/check-sequential-search-contract.py"
    spec = importlib.util.spec_from_file_location("transfer_search_contract", checker_path)
    checker = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(checker)
    rows, native_rows, extensions = [], [], []
    for workload, method in cells:
        cell = root / workload / method
        checker.check_sequential(cell / "search")
        transfer = summary.cell_summary(cell, workload, method)
        joint = summary.cell_summary(main_root / workload / "joint", workload, "joint")
        fixed = summary.cell_summary(main_root / workload / "sequential-50", workload, "sequential-50")
        extensions.append(audit_extension(fixed, transfer, main_root, root))
        rows += [joint, fixed, transfer]
        s = transfer["search_stats"]
        native_rows.append({"workload": workload, "joint_cycles": joint["final_native_cycles"],
            "fixed_50_50_cycles": fixed["final_native_cycles"],
            "transfer_cycles": transfer["final_native_cycles"],
            "transfer_over_joint": transfer["final_native_cycles"] / joint["final_native_cycles"],
            "transfer_over_fixed": transfer["final_native_cycles"] / fixed["final_native_cycles"],
            "transfer_search_seconds": transfer["search_wall_seconds"],
            "transfer_objective_evaluations": transfer["objective_evaluations"],
            "transferred_evaluations": s["transferred_evaluation_count"],
            "phase_a_evaluations": s["phase_evaluations"]["A"],
            "phase_b_evaluations": s["phase_evaluations"]["B"],
            "transfer_mapper_calls": transfer["validation"]["actual_task_mapper_calls"]})
    supplemental_rows = [r for r in rows if r["method"] == "sequential-50-transfer"]
    extra_costs = {
        "complete_supplement_objective_evaluations": sum(r["objective_evaluations"] for r in supplemental_rows),
        "complete_supplement_predictor_feature_queries": sum(r["prediction"]["feature_queries"] for r in supplemental_rows),
        "complete_supplement_predictor_model_inferences": sum(r["prediction"]["model_inferences"] for r in supplemental_rows),
        "complete_supplement_actual_mapper_calls": sum(r["validation"]["actual_task_mapper_calls"] for r in supplemental_rows),
        "complete_supplement_native_program_evaluations": sum(r["validation"]["native_program_evaluations"] for r in supplemental_rows),
        "complete_supplement_search_seconds_sum": sum(r["search_wall_seconds"] for r in supplemental_rows),
        "coordinator_initialization": comparison.read(root / "coordinator-initialization.json"),
        "supplement_batch": comparison.read(root / "batch.json"),
        "prior_smoke_build_and_proof_costs": str(main_root / "diagnostic-extra-costs.json"
            if (main_root / "diagnostic-extra-costs.json").is_file() else
            main_root.parents[1] / "diagnostics/sequential-comparison-4096-fast2-host/diagnostic-extra-costs.json")}
    output.mkdir(parents=True, exist_ok=True)
    comparison.replay.atomic_write(output / "results.json", {
        "schema": "orbit-sequential-transfer-supplement-v1", "role": "separate supplementary variant",
        "original_fixed_50_50_main_table_unchanged": True, "total_objective_allowance": 4096,
        "matched_contract_audit": fairness,
        "validation_binding_audit": binding_audit,
        "native_summary": native_rows, "all_cells": rows,
        "budget_extension_audit": extensions, "additional_costs": extra_costs,
        "additional_tuning_cost": "both supplemental searches, initialization, predictions and mapper validation are additional to the original20 cells",
        "wall_time_caveat": "recorded background machine load differs; observations do not establish controlled efficiency",
        "speedup_direction": "Sequential transfer cycles / Joint cycles"})
    with (output / "results.csv").open("w") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(native_rows[0]))
        writer.writeheader(); writer.writerows(native_rows)
    flat = []
    for r in rows:
        s, p, v = r["search_stats"], r["prediction"], r["validation"]
        flat.append({"workload": r["workload"], "method": r["method"],
            "final_native_cycles": r["final_native_cycles"], "predicted_native_winner_cycles": r["predicted_winner_cycles"],
            "search_wall_seconds": r["search_wall_seconds"], "candidate_attempts": r["candidate_attempts"],
            "unique_legal_candidates": r["legal_candidates"], "canonical_duplicates": r["canonical_duplicates"],
            "objective_evaluations": r["objective_evaluations"], "objective_cache_hits": r["objective_cache_hits"],
            "predictor_feature_queries": p["feature_queries"], "predictor_model_inferences": p["model_inferences"],
            "predictor_cache_hits": p["predictor_cache_hits"], "predictor_cache_queries": p["predictor_cache_queries"],
            "search_mapper_calls": p["search_mapper_calls"], "validation_mapper_calls": v["actual_task_mapper_calls"],
            "validation_program_evaluations": v["native_program_evaluations"],
            "validation_wall_seconds": v["wall_seconds_including_native_numeric"],
            "phase_a_calls": s["phase_evaluations"].get("A"), "phase_b_calls": s["phase_evaluations"].get("B"),
            "phase_a_seconds": s["phase_elapsed_seconds"].get("A"), "phase_b_seconds": s["phase_elapsed_seconds"].get("B"),
            "initial_feasibility_queries": r["initialization"]["initial_resource_feasibility_query_count"],
            "graph_resource_legality_queries": s["resource_legality_queries"],
            "numeric_comparisons": v["numeric_comparisons"]})
    with (output / "all-cells.csv").open("w") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(flat[0]))
        writer.writeheader(); writer.writerows(flat)
    comparison.replay.atomic_write(output / "budget-extension-audit.json", extensions)
    comparison.replay.atomic_write(output / "additional-costs.json", extra_costs)
    lines = ["补充变体：A 仅在 no-new-legal-candidates 时转交未用额度，总上限4096。原主表固定50/50不变。", "",
        "| 程序 | Joint cycles | 固定50/50 cycles | 转交 cycles | 转交/Joint | A+B评估 | 转交额度 | 搜索秒 | mapper调用 |",
        "|---|---:|---:|---:|---:|---:|---:|---:|---:|"]
    for r in native_rows:
        lines.append(f"| {r['workload']} | {r['joint_cycles']} | {r['fixed_50_50_cycles']} | {r['transfer_cycles']} | {r['transfer_over_joint']:.6f} | {r['phase_a_evaluations']}+{r['phase_b_evaluations']} | {r['transferred_evaluations']} | {r['transfer_search_seconds']:.3f} | {r['transfer_mapper_calls']} |")
    lines += ["", "Cycles 为同样5+2方案的真实mapper复评最小值；曲线为预测完整程序makespan，另列。运行时间受后台负载影响。"]
    (output / "results.md").write_text("\n".join(lines) + "\n")
    plot(rows, root, main_root, output)
    index = []
    for workload, method in cells:
        cell = root / workload / method
        require_complete_validation(comparison.read(cell / "result.json"))
        index.append({"workload": workload, "method": method, "result": str(cell / "result.json"),
            "search_statistics": str(cell / "search/search-summary.json"),
            "budget_trace": str(journals.existing_journal_path(cell / "search/budget-trace.jsonl")),
            "raw_manifest": str(cell / "raw-auxiliary-manifest.json"),
            "native_artifacts": [str(p) for sub in ("native-top5", "native-controls") for p in sorted((cell / sub).rglob("*")) if p.is_file()]})
    comparison.replay.atomic_write(output / "final-artifact-index.json", index)
    print((output / "results.md").read_text())
    print("补充统计与曲线：" + str(output))
    return 0


def plot(rows, root, main_root, output):
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    colors = {"joint": "#2155a5", "sequential-50": "#c54c21", "sequential-50-transfer": "#27884e"}
    for kind, xkey in (("evaluations", "cumulative_evaluations"), ("wall-time", "elapsed_seconds")):
        fig, axes = plt.subplots(1, 2, figsize=(9, 3.8))
        for ax, workload in zip(axes, ("gcn", "lu")):
            # Draw the original shorter prefix last so its overlapping curve
            # remains visible; endpoint dots mark each actual budget usage.
            for r in sorted(rows, key=lambda r: r["method"] == "sequential-50"):
                if r["workload"] != workload:
                    continue
                cell_root = root if r["method"] == "sequential-50-transfer" else main_root
                points = journals.read_journal(cell_root / workload / r["method"] / "search/budget-trace.jsonl")
                points = [p for p in points if p.get("incumbent_cycles") is not None]
                ax.step([p[xkey] for p in points], [p["incumbent_cycles"] for p in points],
                        where="post", label=r["method"], color=colors[r["method"]],
                        linestyle="--" if r["method"] == "sequential-50" else "-")
                ax.plot(points[-1][xkey], points[-1]["incumbent_cycles"], "o", color=colors[r["method"]], markersize=4)
            ax.set_title(workload.upper()); ax.set_xlabel("Objective evaluations" if kind == "evaluations" else "Search wall time (s)")
            ax.set_ylabel("Predicted full-program makespan (cycles)"); ax.grid(alpha=.25)
            ax.legend(fontsize=8)
        fig.tight_layout()
        for extension in ("png", "pdf", "svg"):
            fig.savefig(output / f"convergence-{kind}.{extension}", dpi=180)
        plt.close(fig)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--results-root", type=Path, default=comparison.ROOT / "results/sequential-budget-transfer-4096")
    parser.add_argument("--main-results-root", type=Path, default=comparison.ROOT / "results/sequential-comparison-4096-fast2-host")
    parser.add_argument("--output-dir", type=Path, default=comparison.ROOT / "diagnostics/sequential-budget-transfer-4096")
    args = parser.parse_args()
    return show(args.results_root.resolve(), args.main_results_root.resolve(), args.output_dir.resolve())


if __name__ == "__main__":
    raise SystemExit(main())
