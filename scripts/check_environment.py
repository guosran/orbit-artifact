#!/usr/bin/env python3
"""Read-only probe apart from its declared JSON output."""
import argparse
import importlib.util
import json
import os
from pathlib import Path
import platform
import shutil
import subprocess
import sys

from common import ROOT, RESULTS, build_dir, git, lock, llvm_build, llvm_source, now, source, write_json


def version(argv):
    try:
        p = subprocess.run(argv, capture_output=True, text=True, timeout=10)
        return (p.stdout or p.stderr).splitlines()[0] if p.returncode == 0 else None
    except (OSError, IndexError, subprocess.TimeoutExpired):
        return None


def probe():
    required = {name: {"path": shutil.which(name), "version": version([name, "--version"])}
                for name in ("git", "cmake", "ninja", "clang", "clang++")}
    llvm = llvm_build()
    required["mlir-opt"] = {"path": str(llvm / "bin/mlir-opt"),
                            "version": version([str(llvm / "bin/mlir-opt"), "--version"])}
    required["mlir-runner"] = {"path": str(llvm / "bin/mlir-runner"),
                               "version": version([str(llvm / "bin/mlir-runner"), "--version"])}
    src = source()
    source_head = git(src, "rev-parse", "HEAD") if (src / ".git").exists() else None
    llvm_checkout = llvm.parent if (llvm.parent / ".git").exists() else llvm_source()
    llvm_head = git(llvm_checkout, "rev-parse", "HEAD") if (llvm_checkout / ".git").exists() else None
    optional = {}
    for name in ("torch", "torch_mlir"):
        try:
            found = importlib.util.find_spec(name) is not None
        except (ImportError, ValueError):
            found = False
        optional[name] = "available" if found else "optional_dependency_missing"
    mem_kib = None
    if Path("/proc/meminfo").exists():
        for line in Path("/proc/meminfo").read_text().splitlines():
            if line.startswith("MemTotal:"):
                mem_kib = int(line.split()[1]); break
    disk = shutil.disk_usage(ROOT)
    return {"schema": "orbit-environment-v1", "observed_at": now(),
            "os": platform.platform(), "hostname": platform.node(),
            "cpu_count": os.cpu_count(), "memory_kib": mem_kib,
            "disk_available_bytes": disk.free, "python": platform.python_version(),
            "required": required, "required_status": "available" if sys.version_info >= (3, 10) and all(x["version"] for x in required.values()) and llvm_head == lock()["llvm_mlir"]["commit"] else "missing_required_dependency",
            "optional": optional,
            "optional_dependency_state": "available" if all(x == "available" for x in optional.values()) else "optional_dependency_missing",
            "source_commit": source_head, "expected_source_commit": lock()["amoeba"]["commit"],
            "source_status": "pinned" if source_head == lock()["amoeba"]["commit"] else "missing_or_wrong_commit",
            "llvm_commit": llvm_head,
            "expected_llvm_commit": lock()["llvm_mlir"]["commit"],
            "amoeba_optimizer": str(build_dir() / "tools/mlir-amoeba-opt/mlir-amoeba-opt")}


if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("--output", type=Path, default=RESULTS / "environment.json")
    args = ap.parse_args()
    data = probe(); write_json(args.output, data)
    print(json.dumps(data, indent=2, sort_keys=True))
    raise SystemExit(0 if data["required_status"] == "available" else 1)
