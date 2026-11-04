"""JSON artifact IO only; no mapping or cost decisions."""
from __future__ import annotations

# Experiments live in orbit-artifact; compiler sources/builds are external.
import sys as _path_sys
from pathlib import Path as _Path
_path_sys.path.insert(0, str(_Path(__file__).resolve().parents[1] / 'python'))
from taskflow_paths import (ARTIFACT_ROOT, ARTIFACT_REPO, ORBIT_SRC, ORBIT_BUILD_ROOT,
    CORE_BUILD, AIR_BUILD, AMOEBA_BUILD, RESULTS_ROOT, test_path)
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = ARTIFACT_ROOT



def load(path):
    return json.loads(Path(path).read_text())


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def identity(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, separators=(',', ':'), allow_nan=False).encode()).hexdigest()


def write(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile('w', dir=path.parent, delete=False) as stream:
        json.dump(value, stream, indent=2, sort_keys=True, allow_nan=False)
        stream.write('\n')
        temporary = stream.name
    os.replace(temporary, path)
