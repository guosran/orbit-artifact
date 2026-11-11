#!/usr/bin/env bash
# Frozen-tool CPU verification and serialized solver/native scaling. No NPU.
set -euo pipefail
[[ $# == 3 ]] || { echo 'usage: run-cpsat-v22-cpu.sh CORE_OFF_BUILD CPSAT_AIR_BUILD NEW_OUTPUT' >&2; exit 2; }
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
core=$(realpath "$1")
solver=$(realpath "$2")
out=$(realpath -m "$3")
[[ ! -e "$out" ]] || { echo 'Output must be new' >&2; exit 2; }
mkdir -p "$out"
core_tool="$core/tools/taskflow-opt/taskflow-opt"
solver_tool="$solver/tools/taskflow-opt/taskflow-cpsat-opt"
native_tool="$solver/tools/taskflow-opt/taskflow-opt"
python3 - "$core_tool" "$solver_tool" "$native_tool" "$out/provenance.json" "$root" <<'PY'
import hashlib,json,platform,subprocess,sys
from pathlib import Path
paths=[Path(p) for p in sys.argv[1:4]]
linked=subprocess.run(['ldd',str(paths[0])],capture_output=True,text=True,check=True).stdout
assert 'ortools' not in linked.lower()
Path(sys.argv[4]).write_text(json.dumps(dict(tools={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths},
    platform=platform.platform(),default_core_links=linked,hardware_executed=False,
    source_files={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in [Path(sys.argv[5])/'test/TaskflowGeneric/cpsat_search_contract.py',Path(sys.argv[5])/'test/TaskflowGeneric/cpsat_native_v22.py',Path(sys.argv[5])/'scripts/run-cpsat-v22-cpu.sh']}),indent=2)+'\n')
PY
printf '{"tasks":1,"tiles":1,"patterns":[{"tasks":[0],"tile":0,"cost_ns":1}]}' | "$core/tools/taskflow-opt/taskflow-cpsat-opt" > "$out/default-off.json"
python3 - "$out/default-off.json" <<'PY'
import json,sys
assert json.load(open(sys.argv[1]))['status']=='UNAVAILABLE'
PY
python3 "$root/test/TaskflowGeneric/cpsat_search_contract.py" --tool "$solver_tool" --output "$out/contracts.json"
python3 "$root/test/TaskflowGeneric/cpsat_native_v22.py" --tool "$native_tool" --output "$out/native-contracts"
# Intentionally sequential: do not build, compile AIR, run regressions or submit
# hardware while collecting these timings. Each JSONL row is flushed on return.
python3 "$root/test/TaskflowGeneric/cpsat_search_contract.py" --tool "$solver_tool" --benchmark cover --campaign-seconds 80 --output "$out/cover.jsonl"
python3 "$root/test/TaskflowGeneric/cpsat_search_contract.py" --tool "$solver_tool" --benchmark schedule --campaign-seconds 80 --output "$out/schedule.jsonl"
python3 "$root/test/TaskflowGeneric/cpsat_native_v22.py" --tool "$native_tool" --benchmark --output "$out/native-scaling"
python3 - "$out/provenance.json" "$root" <<'PY'
import hashlib,json,sys
from pathlib import Path
provenance=json.loads(Path(sys.argv[1]).read_text())
for p,digest in {**provenance['tools'],**provenance['source_files']}.items():
    assert hashlib.sha256(Path(p).read_bytes()).hexdigest()==digest,(p,'changed during campaign')
PY
