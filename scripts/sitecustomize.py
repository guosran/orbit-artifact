"""Record subprocesses launched by pinned source Python audit drivers.

Activated only when ORBIT_COMMAND_LOG is set by the artifact runner.
"""
import datetime as dt
import json
import os
from pathlib import Path
import subprocess
import time

_original_run = subprocess.run


def _logged_run(*args, **kwargs):
    log = os.environ.get("ORBIT_COMMAND_LOG")
    argv = args[0] if args else kwargs.get("args")
    if not log or not isinstance(argv, (list, tuple)):
        return _original_run(*args, **kwargs)
    started = dt.datetime.now().astimezone().isoformat(timespec="seconds")
    stamp = "%d-%d" % (os.getpid(), time.time_ns())
    result = _original_run(*args, **kwargs)
    run_dir = Path(log).parent
    logs = run_dir / "logs"; logs.mkdir(exist_ok=True)
    stdout_path = logs / ("nested-%s.stdout.log" % stamp)
    stderr_path = logs / ("nested-%s.stderr.log" % stamp)
    stdout_path.write_text(result.stdout if isinstance(result.stdout, str) else "")
    stderr_path.write_text(result.stderr if isinstance(result.stderr, str) else "")
    row = {"argv": [str(x) for x in argv], "cwd": str(Path(kwargs.get("cwd") or os.getcwd()).resolve()),
           "start_time": started, "end_time": dt.datetime.now().astimezone().isoformat(timespec="seconds"),
           "exit_code": result.returncode,
           "stdout_log": str(stdout_path.relative_to(run_dir)),
           "stderr_log": str(stderr_path.relative_to(run_dir))}
    with open(log, "a") as stream:
        stream.write(json.dumps(row, sort_keys=True) + "\n")
    return result


if os.environ.get("ORBIT_COMMAND_LOG"):
    subprocess.run = _logged_run

