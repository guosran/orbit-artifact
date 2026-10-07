#!/usr/bin/env python3
"""Audit and report available cells without presenting an incomplete batch as final."""
import argparse
import csv
import importlib.util
import json
import math
from pathlib import Path

import compact_sequential_raw as storage
import run_sequential_comparison as comparison
import show_sequential_comparison as evidence
import summarize_sequential_comparison as summary
from sequential_validation_audit import require_complete_validation


def write_csv(path, rows):
    if not rows:
        return
    with path.open("w") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--results-root", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--render-plots", action="store_true")
    args = parser.parse_args()
    root, output = args.results_root.resolve(), args.output_dir.resolve()
    cells, status = [], []
    for workload in comparison.WORKLOADS:
        for method, _, _ in comparison.METHODS:
            cell = root / workload / method
            try:
                result = comparison.read(cell / "result.json")
                require_complete_validation(result)
            except (OSError, ValueError) as error:
                status.append({"workload": workload, "method": method,
                    "status": "unvalidated-excluded", "reason": str(error)})
                continue
            cells.append((workload, method))
            status.append({"workload": workload, "method": method, "status": "seven-gates-passed"})
    if not cells:
        raise ValueError("no completely validated cells")
    evidence.audit_bindings(root, cells=cells)
    checker_path = comparison.ROOT / "reference/sequential-comparison/check-sequential-search-contract.py"
    spec = importlib.util.spec_from_file_location("sequential_contract_check", checker_path)
    checker = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(checker)
    for workload, method in cells:
        if method != "joint":
            checker.check_sequential(root / workload / method / "search")
    rows = [summary.cell_summary(root / workload / method, workload, method) for workload, method in cells]
    by_cell = {(row["workload"], row["method"]): row for row in rows}
    main_rows, sensitivity, flat, index = [], [], [], []
    for workload in comparison.WORKLOADS:
        if (workload, "joint") in by_cell and (workload, "sequential-50") in by_cell:
            joint, sequential = (by_cell[(workload, method)] for method in ("joint", "sequential-50"))
            main_rows.append({"workload": workload, "joint_cycles": joint["final_native_cycles"],
                "sequential_cycles": sequential["final_native_cycles"],
                "sequential_over_joint": sequential["final_native_cycles"] / joint["final_native_cycles"],
                "joint_search_seconds": joint["search_wall_seconds"],
                "sequential_search_seconds": sequential["search_wall_seconds"],
                "joint_objective_calls": joint["objective_evaluations"],
                "sequential_objective_calls": sequential["objective_evaluations"],
                "joint_mapper_calls": joint["validation"]["actual_task_mapper_calls"],
                "sequential_mapper_calls": sequential["validation"]["actual_task_mapper_calls"]})
        if all((workload, f"sequential-{split}") in by_cell for split in (25, 50, 75)):
            sensitivity.append({"workload": workload, **{f"sequential_{split}_cycles":
                by_cell[(workload, f"sequential-{split}")]["final_native_cycles"] for split in (25, 50, 75)}})
    for row in rows:
        pred, validation, stats = row["prediction"], row["validation"], row["search_stats"]
        flat.append({"workload": row["workload"], "method": row["method"],
            "final_native_cycles": row["final_native_cycles"],
            "predicted_native_winner_cycles": row["predicted_winner_cycles"],
            "predicted_search_best": row["predicted_search_best"],
            "search_wall_seconds": row["search_wall_seconds"],
            "candidate_attempts": row["candidate_attempts"], "unique_legal_candidates": row["legal_candidates"],
            "canonical_duplicates": row["canonical_duplicates"],
            "objective_evaluations": row["objective_evaluations"], "objective_cache_hits": row["objective_cache_hits"],
            "predictor_feature_queries": pred["feature_queries"], "predictor_model_inferences": pred["model_inferences"],
            "predictor_cache_hits": pred["predictor_cache_hits"], "search_mapper_calls": pred["search_mapper_calls"],
            "validation_task_mapper_calls": validation["actual_task_mapper_calls"],
            "validation_program_evaluations": validation["native_program_evaluations"],
            "validation_wall_seconds": validation["wall_seconds_including_native_numeric"],
            "phase_a_objective_calls": stats["phase_evaluations"].get("A"),
            "phase_b_objective_calls": stats["phase_evaluations"].get("B"),
            "phase_a_wall_seconds": stats["phase_elapsed_seconds"].get("A"),
            "phase_b_wall_seconds": stats["phase_elapsed_seconds"].get("B"),
            "numeric_comparisons": validation["numeric_comparisons"]})
        cell = root / row["workload"] / row["method"]
        winner = row["winner"]
        rank_dir = cell / ("native-controls" if winner["control_role"] else "native-top5") / f"rank-{winner['rank']}"
        index.append({"workload": row["workload"], "method": row["method"], "winner": winner,
            "selected_native_evidence_files": [str(p) for p in sorted(rank_dir.rglob("*")) if p.is_file()],
            "result": str(cell / "result.json"), "statistics": str(cell / "search/search-summary.json"),
            "budget_trace": str(storage.existing_journal_path(cell / "search/budget-trace.jsonl")),
            "action_trace": str(storage.existing_journal_path(cell / "search/action-attempts.jsonl")),
            "frontiers": str(storage.existing_journal_path(cell / "search/action-frontiers.jsonl")),
            "raw_auxiliary_manifest": str(cell / "raw-auxiliary-manifest.json"),
            "journal_manifest": str(cell / "journal-gzip-manifest.json")})
    output.mkdir(parents=True, exist_ok=True)
    report = {"schema": "orbit-sequential-partial-audited-results-v1", "scope": "completed cells only",
        "complete_batch": len(cells) == 20, "validated_cells": len(cells), "expected_cells": 20,
        "main_split": "50/50", "ratio_direction": "Sequential native cycles / Joint native cycles; >1 favors Joint",
        "status": status, "main": main_rows, "sensitivity": sensitivity, "all_cells": rows,
        "budget_definition": "4096 complete-program scheduler-call cap per flow; fixed phase allowances; unused A allowance is not transferred",
        "source_bindings": "passed; same retained source/model/input/architecture/network/mapper contracts",
        "phase_action_freeze_budget_incumbent_checks": "passed for every completed Sequential cell",
        "validation": "five shortlist plus identity and search_anchor; all seven native/numeric/mapper-equality/independent-trace gates",
        "sensitivity_tuning_cost": "any best-of-three envelope costs three Sequential flow allowances; excluded from main table",
        "ray": "out-of-model-domain; no fission substitution", "sram": "pending", "formal_go": False}
    comparison.replay.atomic_write(output / "results.json", report)
    comparison.replay.atomic_write(output / "final-artifact-index.json", index)
    histories = []
    for row in rows:
        actions = row["winner"]["selection"].get("action_history", {}).get("actions", [])
        counts = {}
        for action in actions:
            family = action.get("family", "unknown")
            counts[family] = counts.get(family, 0) + 1
        histories.append({"workload": row["workload"], "method": row["method"],
            "native_cycles": row["final_native_cycles"], "native_winner_rank": row["winner"]["rank"],
            "control_role": row["winner"]["control_role"],
            "predicted_native_winner_cycles": row["predicted_winner_cycles"],
            "predicted_search_best": row["predicted_search_best"],
            "anchor_native_cycles": row["anchor_native_cycles"],
            "action_family_counts": counts, "winner_action_history": actions,
            "phase_evaluations": row["search_stats"]["phase_evaluations"],
            "stop_reason": row["search_stats"]["stop_reason"]})
    comparison.replay.atomic_write(output / "winner-search-differences.json", histories)
    sentences = [f"在已完成并通过统一真实 mapper 复评与数值检查的 {len(main_rows)} 个主比较程序上，"
        "我们比较了 Joint 与预先指定的 50% 图搜索/50% 资源搜索 Sequential。"]
    for row in main_rows:
        joint, sequential = row["joint_cycles"], row["sequential_cycles"]
        if sequential >= joint:
            sentences.append(f"Joint 在 {row['workload']} 上降低完整程序 cycles {100 * (1 - joint / sequential):.2f}%。")
        else:
            sentences.append(f"Sequential 在 {row['workload']} 上降低完整程序 cycles {100 * (1 - sequential / joint):.2f}%。")
    if main_rows:
        geometric_mean = math.exp(sum(math.log(row["sequential_over_joint"]) for row in main_rows) / len(main_rows))
        sentences.append(f"已完成子集的 Sequential/Joint cycles 几何平均为 {geometric_mean:.4f}；这是描述性统计。")
    sentences.append("两方法采用相同的 4096 次完整程序目标评估上限；实际消耗另列，图阶段提前停止的未用预算不转入资源阶段。"
        "这些结果描述给定搜索协议下的 best-found 方案，不构成全局最优性证明。阶段比例敏感性单独报告，主表不选择最优比例。"
        "每单元四核，最多两单元并行；实测搜索时间包含不同后台负载，不能解释为受控环境下的算法速度比。"
        "原始 Ray 因模型支持域限制排除，SRAM 容量契约仍为 pending。")
    if len(cells) != 20:
        sentences.append("未完成单元排除，当前子集不能替代完整五程序结论。")
    (output / "paper-conclusion-zh.md").write_text("".join(sentences) + "\n")
    write_csv(output / "main.csv", main_rows)
    write_csv(output / "all-cells.csv", flat)
    write_csv(output / "sensitivity.csv", sensitivity)
    text = ["# 已完成结果的审计分析", "", f"仅纳入 {len(cells)}/20 个通过全部七项验证的单元。主表固定 50%/50%。",
        "Sequential/Joint > 1 表示 Joint 更好；cycles 均为真实 mapper 复评后的完整程序 makespan。", "",
        "| 程序 | Joint cycles | Sequential cycles | Sequential/Joint | Joint / Seq 搜索秒 | Joint / Seq 目标调用 | Joint / Seq mapper 调用 |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: |"]
    for row in main_rows:
        text.append(f"| {row['workload']} | {row['joint_cycles']:,} | {row['sequential_cycles']:,} | {row['sequential_over_joint']:.4f} | {row['joint_search_seconds']:.1f} / {row['sequential_search_seconds']:.1f} | {row['joint_objective_calls']} / {row['sequential_objective_calls']} | {row['joint_mapper_calls']} / {row['sequential_mapper_calls']} |")
    text.extend(["", "## 阶段比例敏感性", "", "| 程序 | 25/75 cycles | 50/50 cycles（主结果） | 75/25 cycles |",
        "| --- | ---: | ---: | ---: |"])
    for row in sensitivity:
        text.append(f"| {row['workload']} | {row['sequential_25_cycles']:,} | {row['sequential_50_cycles']:,} | {row['sequential_75_cycles']:,} |")
    text.extend(["", "图中的曲线仅表示搜索预测目标；没有将预测值与最终真实 cycles 混用。搜索时间与验证时间分开记录。",
        "实际消耗可低于共同评估上限：阶段 A 提前停止时保留 beam 不再产生合法新候选，未使用预算不转给 B；这不是全图空间穷尽证明。",
        "未完成的 LU 比例和 Radar 全部排除，不能据此宣称五程序总体结论。原始 Ray 不在模型支持域；SRAM 容量契约仍为 pending。"])
    (output / "results.md").write_text("\n".join(text) + "\n")
    if args.render_plots:
        summary.plot(rows, root, output)
    print(json.dumps({"validated_cells": len(cells), "main": main_rows, "sensitivity": sensitivity, "output_dir": str(output)}, indent=2))


if __name__ == "__main__":
    main()
