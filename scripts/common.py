"""Shared paths, source pinning, and command logging for the artifact."""
import datetime as dt
import json
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
WORK = ROOT / ".work"
RESULTS = ROOT / "results"


def now():
    return dt.datetime.now(dt.timezone.utc).astimezone().isoformat(timespec="seconds")


def lock():
    result = {}
    section = None
    for raw in (ROOT / "config/sources.lock").read_text().splitlines():
        line = raw.split("#", 1)[0].rstrip()
        if not line:
            continue
        if not line.startswith(" ") and line.endswith(":"):
            section = line[:-1]
            if section in result:
                raise ValueError("duplicate lock section: " + section)
            result[section] = {}
        elif line.startswith("  ") and section and ": " in line:
            key, value = line.strip().split(": ", 1)
            if key in result[section]:
                raise ValueError("duplicate lock key: " + key)
            result[section][key] = value.strip("'\"")
        else:
            raise ValueError("invalid lock line: " + raw)
    for name in ("amoeba", "neura", "cgra_ii_predictor", "llvm_mlir"):
        if name not in result or not all(k in result[name] for k in ("repository", "commit")):
            raise ValueError("incomplete lock section: " + name)
        if len(result[name]["commit"]) != 40:
            raise ValueError("invalid commit in " + name)
    return result


def source():
    return Path(os.environ.get("ORBIT_SOURCE_DIR", str(WORK / "amoeba"))).expanduser().resolve()


def llvm_build():
    return Path(os.environ.get("ORBIT_LLVM_BUILD", str(WORK / "llvm-project/build"))).expanduser().resolve()


def build_dir():
    return Path(os.environ.get("ORBIT_BUILD_DIR", str(WORK / "build"))).expanduser().resolve()


def git(cwd, *args):
    return subprocess.check_output(["git", "-C", str(cwd), *args], text=True).strip()


def require_source_clean(path=None):
    path = path or source()
    if not path.is_dir():
        raise ValueError("source checkout missing: " + str(path))
    if git(path, "rev-parse", "HEAD") != lock()["amoeba"]["commit"]:
        raise ValueError("wrong AMOEBA source commit: " + git(path, "rev-parse", "HEAD"))
    if git(path, "status", "--porcelain", "--ignore-submodules=none"):
        raise ValueError("AMOEBA source is dirty: " + str(path))
    for name, rel in (("neura", "thirdparty/neura"),
                      ("cgra_ii_predictor", "thirdparty/cgra-ii-predictor")):
        sub = path / rel
        if not sub.is_dir() or git(sub, "rev-parse", "HEAD") != lock()[name]["commit"]:
            raise ValueError("missing or wrong pinned submodule: " + rel)
        if git(sub, "status", "--porcelain", "--ignore-submodules=all"):
            raise ValueError("dirty pinned submodule: " + rel)
    return path


def write_json(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n")


def run_command(argv, cwd, run_dir, label, check=True, env=None):
    """Execute argv exactly once and append an auditable command record."""
    logs = run_dir / "logs"
    logs.mkdir(parents=True, exist_ok=True)
    index = sum(1 for _ in (run_dir / "commands.jsonl").open()) if (run_dir / "commands.jsonl").exists() else 0
    out = logs / ("%03d-%s.stdout.log" % (index, label))
    err = logs / ("%03d-%s.stderr.log" % (index, label))
    started = now()
    with out.open("w") as stdout, err.open("w") as stderr:
        process = subprocess.run([str(x) for x in argv], cwd=str(cwd), stdout=stdout, stderr=stderr, env=env)
    record = {"argv": [str(x) for x in argv], "cwd": str(cwd), "start_time": started,
              "end_time": now(), "exit_code": process.returncode,
              "stdout_log": str(out.relative_to(run_dir)),
              "stderr_log": str(err.relative_to(run_dir))}
    with (run_dir / "commands.jsonl").open("a") as stream:
        stream.write(json.dumps(record, sort_keys=True) + "\n")
    if check and process.returncode:
        raise RuntimeError("command failed (%s): %s; see %s" %
                           (process.returncode, label, err))
    return record


def python():
    if sys.version_info < (3, 10):
        raise RuntimeError("Python >=3.10 required; set ORBIT_PYTHON")
    return sys.executable
