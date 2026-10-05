#!/usr/bin/env python3
"""Show measured input-0 ORBIT stages and aligned baseline cycles."""

from __future__ import annotations

import json
from pathlib import Path
import re


ROOT = Path(__file__).resolve().parents[1]
WORKLOADS = ("gcn", "harris", "llama", "lu", "radar", "raytracing")
STAGES = (
    "shape-only",
    "shape-temporal",
    "shape-temporal-replica",
    "shape-temporal-replica-tiling",
    "full-joint",
)
MODEL_NAMESPACE = "orbit-per-cgra-2x2-direct-4member-v1"
ARCHITECTURE = "config/architectures/amoeba_4x4_cgra_2x2_context6.yaml"
DIAGNOSTIC_ARCHITECTURE = "config/architectures/amoeba_4x4_cgra_2x2_context6_ctrlmem23_diagnostic.yaml"
NETWORK = "config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml"


def read_json(path: Path) -> dict | None:
    if not path.is_file():
        return None
    try:
        value = json.loads(path.read_text())
    except (OSError, ValueError):
        return None
    return value if isinstance(value, dict) else None


def cycles(value: object) -> str:
    return f"{value:,}" if isinstance(value, int) and not isinstance(value, bool) and value > 0 else "—"


def orbit_cycles(workload: str, stage: str, cohort: str = "input0-neighborhood-2x2-v38") -> str:
    result = read_json(ROOT / "results" / cohort / workload / stage / "result.json")
    if result is None:
        frozen = read_json(ROOT / "diagnostics" / f"{cohort}-frozen" / "neighborhood-final-results.json")
        if not frozen or frozen.get("schema") != "orbit-neighborhood-final-results-v1":
            return "—"
        provenance = frozen.get("provenance") or {}
        if (provenance.get("model_namespace") != MODEL_NAMESPACE or
                provenance.get("architecture") != ARCHITECTURE or
                provenance.get("inter_task_network") != NETWORK):
            return "—"
        result = next((row for row in frozen.get("rows", []) if
                       row.get("workload") == workload and row.get("stage") == stage), None)
    if not result or result.get("numeric") != "pass" or result.get("trace") != "pass":
        return "—"
    return cycles(result.get("actual_stage_cycles"))


def all_unit_cycles(rows: dict, workload: str) -> str:
    result = rows.get(workload)
    if not result or any(result.get(key) != "pass" for key in
                         ("mapper_equality", "numeric", "independent_trace")):
        return "—"
    return cycles(result.get("baseline_cycles"))


def amoeba_cycles(workload: str) -> str:
    result = read_json(ROOT / "results/input0-amoeba-full-2x2-direct" / workload / "result.json")
    if result is None:
        frozen = read_json(ROOT / "reference/input0-neighborhood/evidence/2x2-original-amoeba-baselines.json") or {}
        result = next((row for row in frozen.get("rows", []) if row.get("workload") == workload), None)
    if not result or result.get("status") != "complete":
        return "—"
    if result.get("input_index") != 0 or result.get("input_id") != "input0":
        return "—"
    if result.get("model_namespace") != MODEL_NAMESPACE:
        return "—"
    if result.get("architecture") != ARCHITECTURE or result.get("inter_task_network") != NETWORK:
        return "—"
    if any(result.get(key) != "pass" for key in
           ("mapper_equality", "numeric", "independent_trace")):
        return "—"
    return cycles(result.get("native_cycles"))


def progress_reason(progress: dict) -> str:
    reason = str(progress.get("reason") or progress.get("error") or "")
    if progress.get("status") in ("failed", "unsupported", "unsupported_unproven", "incomplete"):
        evidence = progress.get("evidence_root")
        step = progress.get("current_step") or progress.get("step")
        if isinstance(evidence, str) and isinstance(step, str) and re.fullmatch(r"[A-Za-z0-9_-]+", step):
            log = ROOT / evidence / f"{step}.stderr.log"
            try:
                log.resolve().relative_to(ROOT.resolve())
                with log.open(errors="replace") as stream:
                    consumed = 0
                    for line in stream:
                        consumed += len(line)
                        if "error:" in line:
                            reason = line.split("error:", 1)[1].strip()
                            break
                        if consumed > 1024 * 1024:
                            break
            except (OSError, ValueError):
                pass
    if "error:" in reason:
        reason = reason.split("error:", 1)[1].splitlines()[0]
    if any(token in reason for token in ("scheduler_start_time =", "replica_shapes =", "see current operation")):
        return "步骤未通过；完整诊断保留在该步骤的 stderr.log"
    return " ".join(reason.split())[:300]


def amoeba_progress(workload: str) -> str:
    """Keep task profiling separate from validated whole-program timing."""
    if workload == "raytracing" and ray_ii23_progress():
        return "II≤20 的历史 mapper 失败；当前 II=23 实验进度见下方补充"
    details = []
    progress = read_json(ROOT / "results/input0-amoeba-full-2x2-direct" / workload / "progress.json")
    result = read_json(ROOT / "results/input0-amoeba-full-2x2-direct" / workload / "result.json") or {}
    profile = None
    profile_path = (result.get("fresh_mapper_profiles") or {}).get("path")
    if not profile_path and progress and isinstance(progress.get("profile_root"), str):
        profile_path = progress["profile_root"] + "/task-profiles.json"
    if isinstance(profile_path, str):
        candidate = ROOT / profile_path
        try:
            candidate.resolve().relative_to(ROOT.resolve())
            profile = read_json(candidate)
        except ValueError:
            pass
    if not profile:
        profile = (read_json(ROOT / f".work/post-publication/amoeba-input0-{workload}-2x2-v41-reprofile/task-profiles.json") or
                   read_json(ROOT / f".work/post-publication/amoeba-input0-{workload}-2x2-v40-reprofile/task-profiles.json"))
    if profile:
        done = profile.get("completed_candidate_count")
        total = profile.get("expected_candidate_count")
        if isinstance(done, int) and isinstance(total, int):
            details.append(f"task/shape mapper {done}/{total}")
    if not progress:
        progress = read_json(ROOT / f".work/post-publication/amoeba-input0-{workload}-2x2-v41-direct-baseline/progress.json")
    if not progress:
        progress = read_json(ROOT / f".work/post-publication/amoeba-input0-{workload}-2x2-v41-reprofile/progress.json")
    if amoeba_cycles(workload) != "—":
        details.append("整程序 cycles 已通过验证")
    elif progress:
        step = progress.get("current_step") or progress.get("step") or "整程序验证"
        status = progress.get("status") or "pending"
        details.append(f"当前步骤 {step} ({status})")
        reason = progress_reason(progress)
        if reason:
            details.append("原因：" + reason)
    else:
        details.append("整程序 cycles 尚未通过验证")
    if amoeba_cycles(workload) == "—":
        retimer = read_json(ROOT / f".work/post-publication/amoeba-input0-{workload}-2x2-v41-direct-baseline/retimer-result.json")
        if retimer and retimer.get("cost_catalog_namespace") == MODEL_NAMESPACE:
            estimate = cycles(retimer.get("mapped_whole_program_cycles"))
            if estimate != "—":
                details.append(f"retimer 计时预估 {estimate} cycles（未通过完整验证）")
    return "；".join(details)


def ray_ii23_progress() -> str | None:
    directory = ROOT / "results/input0-amoeba-ii23-diagnostic/raytracing"
    result = read_json(directory / "result.json")
    progress = read_json(directory / "progress.json")
    if result is None and progress is None:
        result = read_json(ROOT / "reference/input0-neighborhood/evidence/2x2-ii23-ray-diagnostic.json")
    if not result and not progress:
        return None
    result = result or {}
    progress = progress or {}
    accepted = (
        result.get("status") == "complete"
        and result.get("input_index") == 0 and result.get("input_id") == "input0"
        and result.get("runtime_ii_ceiling") == 23
        and result.get("training_ii_ceiling") == 20
        and result.get("model_extrapolation") is True
        and result.get("formal_go") is False
        and result.get("model_namespace") == MODEL_NAMESPACE
        and result.get("architecture") == DIAGNOSTIC_ARCHITECTURE
        and result.get("inter_task_network") == NETWORK
        and all(result.get(key) == "pass" for key in ("mapper_equality", "numeric", "independent_trace"))
    )
    details = ["Ray II=23 补充（模型训练上限仍为20）：整程序 cycles="
               + (cycles(result.get("native_cycles")) if accepted else "—")]
    profiles = result.get("fresh_mapper_profiles") or progress.get("fresh_mapper_profiles") or {}
    done, total = profiles.get("completed"), profiles.get("expected")
    if type(done) is int and type(total) is int:
        details.append(f"mapper {done}/{total}")
    if not accepted:
        details.append("当前步骤 " + str(progress.get("current_step") or result.get("failed_step") or "整程序验证"))
        reason = progress_reason(progress) or str(result.get("reason") or "")
        if reason:
            details.append(reason[:300])
    return "；".join(details)


def main() -> None:
    supplement = read_json(ROOT / "reference/input0-neighborhood/evidence/2x2-supplemental-baselines.json") or {}
    all_unit = supplement.get("all_unit") or {}
    rows = {row["workload"]: row for row in all_unit.get("rows", [])
            if isinstance(row, dict) and isinstance(row.get("workload"), str)}
    headings = ("程序", "固定1x1", "AMOEBA", "S1", "S2", "S3", "S4", "S5")
    print(" ".join(f"{name:>15}" for name in headings))
    for workload in WORKLOADS:
        stage_values = (["超域"] * 5 if workload == "raytracing" else
                        [orbit_cycles(workload, stage) for stage in STAGES])
        values = (workload, all_unit_cycles(rows, workload), amoeba_cycles(workload), *stage_values)
        print(" ".join(f"{value:>15}" for value in values))
    print("单位：整程序 native cycles；— 表示尚无通过验证的 cycles；主表保留 II≤20 配置，Ray 的 II=23 补充单列。")
    fission = [orbit_cycles("raytracing", stage, "input0-ray-fission-2x2-v38") for stage in STAGES]
    print("Ray fission 补充：" + "；".join(f"S{i + 1}={value}" for i, value in enumerate(fission)))
    print("AMOEBA cycles 保留原调度决定，使用相同通信网络验证计时；原调度内部 slot 数单独保存。")
    print("AMOEBA input-0 进度（mapper profile 数量不等于整程序 cycles）：")
    for workload in WORKLOADS:
        print(f"  {workload}: {amoeba_progress(workload)}")
    ray_diagnostic = ray_ii23_progress()
    if ray_diagnostic:
        print(ray_diagnostic)


if __name__ == "__main__":
    main()
