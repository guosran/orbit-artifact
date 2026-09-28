#!/usr/bin/env python3
"""Remove only generated result directories after confirming their schema."""
import json
import shutil
from common import RESULTS

for path in RESULTS.iterdir():
    if not path.is_dir():
        continue
    record = path / "run.json"
    if not record.exists():
        raise SystemExit("refusing to remove unrecognized directory: " + str(path))
    data = json.loads(record.read_text())
    if (data.get("artifact_schema_version") != "orbit-semantic-artifact-v1" and
            data.get("schema") != "orbit-system-module-run-v1"):
        raise SystemExit("refusing to remove foreign results: " + str(path))
    shutil.rmtree(path)
    print("removed", path)
