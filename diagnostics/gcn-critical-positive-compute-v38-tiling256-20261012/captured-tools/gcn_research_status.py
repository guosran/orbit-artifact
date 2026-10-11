#!/usr/bin/env python3
"""Read small GCN research receipts; never start, score, or resume an experiment."""
import argparse
import datetime
import hashlib
import json
from pathlib import Path
import shutil
import time


BASE = Path(__file__).resolve().parent / "diagnosis/search-regression-repair-20261010"
COHORTS = (
    ("v37/Replica", "retained-communication-shape-window-v37-replica256-continuation1", "replica", "151cf509063bf93276665cea05fb71235f6dd123"),
    ("v37/Full", "retained-communication-shape-window-v37-full256-continuation1", "fission", "151cf509063bf93276665cea05fb71235f6dd123"),
    ("v38/Replica", "critical-positive-compute-v38-replica256-continuation1", "replica", "76345481683a2e199c0cad155de2acb51149f350"),
    ("v38/Tiling", "critical-positive-compute-v38-tiling256-continuation1", "tiling", "76345481683a2e199c0cad155de2acb51149f350"),
    ("v38/Full", "critical-positive-compute-v38-full256-continuation1", "fission", "76345481683a2e199c0cad155de2acb51149f350"),
)


def small_json(path):
    try:
        if path.stat().st_size > 8 * 1024 * 1024:
            return {}
        return json.loads(path.read_text())
    except (OSError, ValueError):
        return {}


def last_complete_record(path):
    try:
        with path.open("rb") as stream:
            stream.seek(0, 2)
            stream.seek(max(0, stream.tell() - 64 * 1024))
            lines = stream.read().splitlines()
        for line in reversed(lines):
            try:
                return json.loads(line)
            except (ValueError, UnicodeError):
                continue
    except OSError:
        pass
    return {}


def supervisor_alive(cohort):
    launch = small_json(cohort / "supervisor-launch.json")
    return process_alive(launch)


def process_alive(launch):
    try:
        stat = Path(f"/proc/{int(launch['pid'])}/stat").read_text()
        fields = stat.rsplit(")", 1)[1].split()
        start = launch.get("start", launch.get("process_start_ticks"))
        return start is not None and fields[0] != "Z" and fields[19] == str(start)
    except (OSError, ValueError, KeyError, IndexError):
        return False


def disk_admission_detail(cohort, status):
    if status not in {"search", "search-audit", "native", "numeric", "final-outcome-audit"}:
        return ""
    launch = small_json(cohort / "supervisor-launch.json")
    if not process_alive(launch):
        return ""
    try:
        pid = int(launch["pid"])
        children = Path(f"/proc/{pid}/task/{pid}/children").read_text().split()
        free_gib = shutil.disk_usage(BASE).free / 2**30
        if not children and free_gib < 50:
            return f"  尚无阶段子进程；磁盘可用 {free_gib:.2f} GiB，低于启动门槛 50 GiB"
    except (OSError, KeyError, ValueError):
        pass
    return ""


def mechanism_snapshot():
    cohort = BASE / "critical-positive-compute-v38-mechanism1"
    unit = cohort / "runs/b64/gcn/fission"
    report_path = cohort / "audit/REPORT.json"
    report = small_json(report_path)
    seal = small_json(cohort / "audit/FINAL.json")
    failure = small_json(unit / "failure.json")
    worker = small_json(unit / "worker-status.json")
    if report and seal:
        valid = (
            report.get("status") == seal.get("status") == "pass"
            and report.get("source_commit") == "76345481683a2e199c0cad155de2acb51149f350"
            and report.get("objective_calls") == 64
            and report.get("native_calls") == report.get("numeric_calls") == 0
            and hashlib.sha256(report_path.read_bytes()).hexdigest() == seal.get("report_sha256")
        )
        result = "机制审计通过" if valid else "查看机制报告"
        print(f"v38/64  {result}  calls={report.get('objective_calls')}"
              f"  changed targets={report.get('changed_compute_target_count')}"
              f"  paid critical shapes={len(report.get('first_tier_guided_paid', []))}"
              "  native cycles=未测量")
    elif failure:
        print(f"v38/64  失败  {failure.get('error', failure.get('status'))}")
    else:
        refresh = last_complete_record(unit / "search/frontier-refresh.jsonl")
        status = worker.get("status", "尚未启动")
        if worker and not process_alive(small_json(unit / "driver-binding.json")):
            status = "监督器已退出，等待审计" if small_json(unit / "search-completion.json") else "监督器已退出，查看记录"
        print(f"v38/64  {status}"
              f"  最近保存的 refresh: round={refresh.get('round', '?')}"
              f"  calls={refresh.get('evaluations', '?')}/64"
              "  native cycles=未测量")
    print(f"        {unit}")


def snapshot():
    print(datetime.datetime.now().astimezone().isoformat(timespec="seconds"))
    print(f"磁盘可用 {shutil.disk_usage(BASE).free / 2**30:.2f} GiB（阶段启动门槛 50 GiB）")
    verified_cycles = {}
    for label, cohort, stage, source in COHORTS:
        unit = BASE / cohort / "runs/b256/gcn" / stage
        completion = small_json(unit / "completion.json")
        failure = small_json(unit / "failure.json")
        worker = small_json(unit / "worker-status.json")
        if completion:
            verified = (
                completion.get("status") == "pass-targeted-diagnostic"
                and completion.get("source_commit") == source
                and completion.get("actual_objective_calls") == 256
                and completion.get("native_evaluated") == 5
                and completion.get("numeric_validated", 0)
                    + completion.get("certified_scheduler_rejected", 0) == 5
                and (not label.startswith("v38/") or (
                    completion.get("numeric_validated") == 5
                    and completion.get("certified_scheduler_rejected", 0) == 0
                ))
            )
            if verified:
                verified_cycles[label] = completion.get("native_cycles")
            status = "已封存" if verified else "查看 completion"
            print(f"{label:11} {status}  calls={completion.get('actual_objective_calls')}"
                  f"  native={completion.get('native_evaluated')}"
                  f"  numeric={completion.get('numeric_validated')}"
                  f"  rejected={completion.get('certified_scheduler_rejected', 0)}"
                  f"  cycles={completion.get('native_cycles')}")
        elif failure:
            print(f"{label:11} 失败  {failure.get('error', failure.get('status', '查看 failure.json'))}")
        else:
            refresh = last_complete_record(unit / "search/frontier-refresh.jsonl")
            prepared = any((BASE / cohort / version / "pipeline-binding.json").exists()
                           for version in ("prepared-v1", "prepared-v2"))
            status = worker.get("status", "准备完成，尚未启动" if prepared else "尚无 worker receipt")
            if worker and not supervisor_alive(BASE / cohort):
                status = "监督器已退出，尚无完成记录"
            admission_detail = disk_admission_detail(BASE / cohort, status)
            search_completion = small_json(unit / "search-completion.json")
            if (search_completion.get("source_commit") == source
                    and search_completion.get("objective_calls") == 256
                    and search_completion.get("status") == "search-completed-unverified"):
                print(f"{label:11} {status}  搜索已结束，calls=256/256  cycles=待 native 验证")
            else:
                print(f"{label:11} {status}"
                      f"  最近保存的 refresh: round={refresh.get('round', '?')}"
                      f"  calls={refresh.get('evaluations', '?')}/256"
                      "  cycles=待 native 验证")
            if admission_detail:
                print(admission_detail)
        print(f"        {unit}")
    for version in ("v37", "v38"):
        full, replica = verified_cycles.get(version + "/Full"), verified_cycles.get(version + "/Replica")
        if isinstance(full, int) and isinstance(replica, int):
            delta = full - replica
            trend = "按 1 cycle 口径持平" if abs(delta) <= 1 else ("Full 更快" if delta < 0 else "Full 回退")
            print(f"{version} 同版本 Full−Replica = {delta:+,} cycles（{trend}）")
    for left, right in (("Full", "Tiling"), ("Tiling", "Replica")):
        a, b = verified_cycles.get("v38/" + left), verified_cycles.get("v38/" + right)
        if isinstance(a, int) and isinstance(b, int):
            delta = a - b
            trend = "按 1 cycle 口径持平" if abs(delta) <= 1 else (f"{left} 更快" if delta < 0 else f"{left} 回退")
            print(f"v38 同版本 {left}−{right} = {delta:+,} cycles（{trend}）")
    mechanism_snapshot()
    print("此脚本仅显示 receipt 状态；运行中的 saved refresh 不是实时总调用数。", flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--watch", action="store_true")
    parser.add_argument("--interval", type=int, default=300, help="Watch seconds, minimum 60 (default 300)")
    args = parser.parse_args()
    if args.interval < 60:
        parser.error("--interval 必须至少 60 秒")
    try:
        while True:
            snapshot()
            if not args.watch:
                break
            time.sleep(args.interval)
    except KeyboardInterrupt:
        pass


if __name__ == "__main__":
    main()
