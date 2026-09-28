#!/usr/bin/env python3
"""Check the gate before creating semantic-closure-v0.1.1; never tag itself."""
import json
from pathlib import Path
import sys

from common import ROOT, git, lock
from reconciliation_gates import require_patch_tag_ready
from validate_results import validate


def check(path):
    path = path.resolve()
    run = json.loads((path / "run.json").read_text())
    expected = json.loads((ROOT / "config/expected_semantic_closure.json").read_text())
    expected["source_commit"] = lock()["amoeba"]["commit"]
    old_tag_commit = git(ROOT, "rev-parse", "semantic-closure-v0.1^{}")
    validation = validate(path, require_full=True)
    return require_patch_tag_ready(run, validation, expected, old_tag_commit)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("usage: check_semantic_release.py <fresh-full-run-directory>", file=sys.stderr)
        sys.exit(2)
    try:
        check(Path(sys.argv[1]))
    except Exception as error:
        print("semantic patch release gate failed:", error, file=sys.stderr)
        sys.exit(1)
    print("semantic patch release gate passed")
