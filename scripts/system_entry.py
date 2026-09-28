#!/usr/bin/env python3
"""Fail-closed full-system command dispatch while adapters are audited."""
import json
import sys

from system_status import status
from run_backend_fixtures import run as run_fixture


def main(argv):
    if len(argv) != 3:
        raise ValueError("expected mode and module")
    mode, module = argv[1:]
    current = status()
    if mode == "reproduce" and module in ("resource", "spatial", "temporal", "cost"):
        print(run_fixture(module))
        return 0
    if mode == "smoke" and module == "scheduler":
        print(run_fixture("temporal"))
        return 0
    if mode == "smoke" and module == "backend":
        for part in ("resource", "spatial", "cost"):
            print(run_fixture(part))
        print(json.dumps({"schema": "orbit-module-gate-v1", "status": "partial",
                          "reason": "selected native replay unavailable under pinned source without file-hash contract"}, indent=2))
        return 2
    required = {"core": ["semantic", "resource", "spatial", "temporal", "cost", "replay"],
                "paper": ["semantic", "resource", "spatial", "temporal", "cost", "replay", "paper"],
                "full": ["semantic", "resource", "spatial", "temporal", "cost", "replay", "paper"]}
    if module in required:
        missing = [name for name in required[module] if current["modules"][name]["verdict"] != "GO"]
        print(json.dumps({"schema": "orbit-module-gate-v1", "command": [mode, module],
                          "status": "pending_current_protocol_reproduction",
                          "missing_go_modules": missing}, indent=2))
        return 2
    print(json.dumps({"schema": "orbit-module-gate-v1", "command": [mode, module],
                      "status": "pending_current_protocol_reproduction",
                      "reason": "production source adapter and current-protocol evidence not yet validated"}, indent=2))
    return 2


if __name__ == "__main__":
    try:
        sys.exit(main(sys.argv))
    except ValueError as error:
        print(str(error), file=sys.stderr)
        sys.exit(2)
