#!/usr/bin/env python3
"""Report module outcomes from generated results, never from reference prose."""
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from common import RESULTS, write_json

MODULES = ("semantic", "resource", "spatial", "temporal", "cost", "replay", "paper")


def status():
    modules = {}
    for module in MODULES:
        runs = sorted(p for p in RESULTS.iterdir() if p.is_dir() and module in p.name and (p / "run.json").exists())
        if not runs:
            modules[module] = {"verdict": "PENDING", "run": None}
            continue
        path = runs[-1]
        run = json.loads((path / "run.json").read_text())
        validation = json.loads((path / "validation.json").read_text()) if (path / "validation.json").exists() else None
        verdict = ("GO" if validation and validation.get("pass") is True and validation.get("scope", "full_module") == "full_module" else
                   "PARTIAL" if validation and validation.get("pass") is True else
                   "NO-GO" if run.get("status") == "completed" and validation and validation.get("pass") is False else
                   "PARTIAL")
        modules[module] = {"verdict": verdict, "run": str(path.relative_to(RESULTS.parent)),
                           "reason": validation.get("error") if validation else run.get("error")}
    full = "ORBIT FULL-SYSTEM ARTIFACT GO" if all(row["verdict"] == "GO" for row in modules.values()) else "ORBIT FULL-SYSTEM ARTIFACT PARTIAL"
    return {"schema": "orbit-system-status-v1", "full_system_verdict": full,
            "modules": modules}


if __name__ == "__main__":
    result = status(); write_json(RESULTS / "system_status.json", result)
    print(json.dumps(result, indent=2, sort_keys=True))
