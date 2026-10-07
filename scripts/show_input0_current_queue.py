#!/usr/bin/env python3
"""Read the accepted original-source input0 queue without changing its runtime."""

from pathlib import Path

import show_input0_proof_repair_r4 as receipts


STAGES = (
    "shape-temporal",
    "shape-temporal-replica",
    "shape-temporal-replica-tiling",
    "full-joint",
    "full-joint-fission",
)
STATE = receipts.R / (
    ".work/post-publication/"
    "full-input0-memory-fusion-fission-r9-original-ray-ii23-queue-v2-runtime-20261006.json"
)


def common_amoeba_cycles(workload):
    result = receipts.read(
        receipts.R / "results/input0-amoeba-common-dfg-r5-20261006"
        / workload / "result.json"
    )
    cycles = result.get("native_cycles")
    if (
        result.get("schema") == "orbit-common-dfg-amoeba-baseline-result-v1"
        and result.get("workload") == workload
        and result.get("input_index") == 0
        and result.get("status") == "native_replayed"
        and all(result.get(key) == "pass" for key in ("mapper", "trace", "numeric"))
        and type(cycles) is int and cycles > 0
    ):
        return f"{cycles:,}"
    return "—"


def main():
    state = receipts.read(STATE)
    if not state:
        print(f"找不到有效队列状态：{STATE}")
        return 1
    print(
        "input0 原版输入完整重测：R9 queue-v2；"
        f"队列 {state.get('status', 'unknown')}；PID {state.get('pid', '—')}"
    )
    print("S1 shape+temporal；S2 +replica；S3 +tiling；S4 +fusion；S5 +fission。")
    print("每阶段独立从 canonical 搜索全部已开放维度；12 核上限；无 mapper 超时。")
    profile = receipts.r9_profile(state)
    if profile is None:
        print("输入/编译器/模型/架构绑定校验未通过；不展示本轮 cycles。")
        return 1

    baseline_rows = {}
    baseline_error = None
    try:
        queue = receipts.queue_validator()
        args = queue._arguments([])
        queue._fill_defaults(args)
        context = queue._freeze_context(args)
        baseline_rows = queue._verify_fixed1x1_state(state, context)["workloads"]
    except (OSError, ValueError, TypeError, KeyError, AttributeError, RuntimeError) as error:
        baseline_error = str(error)

    print("cycles 只展示已通过 native/trace/numeric 及绑定校验的结果；— 表示尚无合格结果。")
    print("AMOEBA 列读取已有共同 DFG 基线回放，保留原 F45 分配和 parent/N 计时。")
    print()
    print("| 程序 | 队列状态 | 固定1×1 | AMOEBA | S1 | S2 | S3 | S4 | S5 |")
    print("|---|---|---:|---:|---:|---:|---:|---:|---:|")
    for workload in receipts.R5_WORKLOADS:
        item = state.get("workloads", {}).get(workload, {})
        row = baseline_rows.get(workload, {})
        if row.get("status") == "unsupported-model-domain":
            baseline = "N/A"
        elif row.get("status") == "complete":
            baseline = f"{row['baseline_cycles']:,}"
        else:
            baseline = "—"
        stages = [receipts.accepted_r9_stage(workload, stage, profile) for stage in STAGES]
        cells = [workload, item.get("status", "unknown"), baseline,
                 common_amoeba_cycles(workload), *stages]
        print("| " + " | ".join(cells) + " |")
    print()
    if baseline_error:
        print(f"固定1×1证据校验未通过：{baseline_error}")
    elif baseline_rows.get("raytracing", {}).get("status") == "unsupported-model-domain":
        print("原版 Ray 固定1×1 N/A：Task13 的 II 下界 83 超出运行上限 23；未执行该基线 mapper。")
    print("Ray 搜索使用 II23 诊断配置；其余五程序 II20；训练/归一化仍为20；formal_go=false。")
    print("本查询只读结果；后台队列会自动接续 queued 程序，已启用临时文件清理。")
    print(f"状态文件：{STATE}")
    return 1 if baseline_error else 0


if __name__ == "__main__":
    raise SystemExit(main())
