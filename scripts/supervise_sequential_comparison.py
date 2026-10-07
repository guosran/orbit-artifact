#!/usr/bin/env python3
"""Record a detached comparison's process lifetime without polling results."""
import argparse
import json
import os
from pathlib import Path
import subprocess
import time

import neighborhood_replay as replay


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--launch-file", type=Path, required=True)
    args = parser.parse_args()
    launch = json.loads(args.launch_file.read_text())
    status_path = Path(launch.get("process_status_file", args.launch_file.parent / "batch-process.json"))
    environment = os.environ.copy()
    environment.update(launch.get("environment", {}))
    record = {"supervisor_pid": os.getpid(), "started_unix": time.time(),
              "argv": launch["argv"], "status": "starting"}
    replay.atomic_write(status_path, record)
    with Path(launch["log"]).open("a") as output:
        process = subprocess.Popen(launch["argv"], cwd=launch["cwd"],
                                   env=environment, stdin=subprocess.DEVNULL,
                                   stdout=output, stderr=subprocess.STDOUT)
        record.update(coordinator_pid=process.pid, status="running")
        replay.atomic_write(status_path, record)
        code = process.wait()
    record.update(exit_code=code, ended_unix=time.time(),
                  status="exited" if code == 0 else "failed")
    replay.atomic_write(status_path, record)
    return 0 if code == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
