"""Per-case durable execution for future native and full-workload runs."""
import json
import os
from pathlib import Path
import subprocess
import time


def _write(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    temp = path.with_suffix(path.suffix + ".tmp")
    temp.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n")
    temp.replace(path)


def resume_plan(run_dir):
    plan_path = run_dir / "plan.json"
    if not plan_path.is_file():
        raise ValueError("long-run plan missing")
    plan = json.loads(plan_path.read_text())
    if plan.get("schema") != "orbit-long-run-plan-v1" or not isinstance(plan.get("cases"), list):
        raise ValueError("invalid long-run plan")
    ids = [case["id"] for case in plan["cases"]]
    if len(ids) != len(set(ids)) or any("/" in value or value.startswith(".") for value in ids):
        raise ValueError("invalid or duplicate case ID")
    completed = skipped = 0
    for case in plan["cases"]:
        path = run_dir / "cases" / (case["id"] + ".json")
        previous = json.loads(path.read_text()) if path.exists() else None
        if previous and previous.get("status") == "completed" and previous.get("exit_code") == 0:
            skipped += 1
            continue
        if previous and previous.get("status") == "running":
            pid = previous.get("pid")
            try:
                if pid:
                    os.kill(pid, 0)
                    raise ValueError("case still running: " + case["id"])
            except ProcessLookupError:
                pass
        argv = case["argv"]
        if not isinstance(argv, list) or not argv or not all(isinstance(x, str) for x in argv):
            raise ValueError("case argv must preserve string argument boundaries")
        cwd = Path(case["cwd"])
        if not cwd.is_dir():
            raise ValueError("case cwd missing: " + str(cwd))
        logs = run_dir / "logs"; logs.mkdir(exist_ok=True)
        out_path = logs / (case["id"] + ".stdout.log")
        err_path = logs / (case["id"] + ".stderr.log")
        record = {"schema": "orbit-long-run-case-v1", "id": case["id"], "argv": argv,
                  "cwd": str(cwd), "status": "incomplete", "start_time": time.time(),
                  "end_time": None, "pid": None, "exit_code": None,
                  "stdout_log": str(out_path.relative_to(run_dir)),
                  "stderr_log": str(err_path.relative_to(run_dir)),
                  "evidence_class": case["evidence_class"]}
        _write(path, record)
        with out_path.open("w") as out, err_path.open("w") as err:
            process = subprocess.Popen(argv, cwd=str(cwd), stdout=out, stderr=err)
            record["pid"] = process.pid
            record["status"] = "running"
            _write(path, record)
            try:
                exit_code = process.wait()
            except KeyboardInterrupt:
                record["status"] = "incomplete"
                _write(path, record)
                raise
        record["end_time"] = time.time()
        record["exit_code"] = exit_code
        record["status"] = "completed" if exit_code == 0 else "execution_failed"
        _write(path, record)
        if exit_code:
            raise RuntimeError("long-run case failed: " + case["id"])
        completed += 1
    status = {"schema": "orbit-long-run-status-v1", "planned_cases": len(ids),
              "completed_this_invocation": completed, "skipped_completed": skipped,
              "run_complete": completed + skipped == len(ids)}
    _write(run_dir / "long_run_status.json", status)
    return status

