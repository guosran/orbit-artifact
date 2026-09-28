#!/usr/bin/env python3
import argparse
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from modules.long_run import resume_plan

if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("run_directory", type=Path)
    args = ap.parse_args()
    result = resume_plan(args.run_directory)
    print(json.dumps(result, indent=2, sort_keys=True))

