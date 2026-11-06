#!/usr/bin/env bash
# Fresh compiler replay, generation, or SHA-bound small-device replay.
set -euo pipefail
if [[ ${ORBIT_V18_CLEAN_ENTRY:-} != 1 ]]; then
  exec env -i HOME="$HOME" PATH=/usr/bin:/bin ORBIT_V18_CLEAN_ENTRY=1 \
    /bin/bash --noprofile --norc "$0" "$@"
fi
[[ $# -gt 0 ]] || { echo 'usage: run_taskflow_execution_graph_v18.sh cpu|generate|npu [options]' >&2; exit 2; }
mode=$1;shift
script_root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
artifact_root=$(cd "$script_root/../.." && pwd)
orbit_root=$(realpath "$artifact_root/../orbit")
aie_root=$(realpath "$artifact_root/../aie-toy")
output= protocol= core_build= air_build= core_tool= air_tool= config=
amoeba_tool="$artifact_root/builds/taskflow-v13/amoeba/tools/mlir-amoeba-opt/mlir-amoeba-opt"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output) output=$(realpath -m "$2"); shift 2;;
    --protocol) protocol=$(realpath "$2"); shift 2;;
    --core-build) core_build=$(realpath "$2"); shift 2;;
    --air-build) air_build=$(realpath "$2"); shift 2;;
    --core-tool) core_tool=$(realpath "$2"); shift 2;;
    --air-tool) air_tool=$(realpath "$2"); shift 2;;
    --config) config=$(realpath "$2"); shift 2;;
    --amoeba-tool) amoeba_tool=$(realpath "$2"); shift 2;;
    *) echo "Unknown argument: $1" >&2; exit 2;;
  esac
done
[[ -n "$output" && ! -e "$output" ]] || { echo '--output must name a new directory.' >&2; exit 2; }
if [[ "$mode" == cpu ]]; then
  [[ -n "$core_build" && -n "$air_build" ]] || { echo 'cpu requires --core-build and --air-build.' >&2; exit 2; }
  exec bash "$orbit_root/scripts/run-execution-graph-v18-cpu.sh" \
    "$core_build" "$air_build" "$output" "$amoeba_tool"
fi
[[ "$mode" == generate || "$mode" == npu ]] || { echo 'Modes: cpu, generate, npu' >&2; exit 2; }
if [[ "$mode" == npu ]]; then
  [[ -f "$protocol" ]] || { echo 'npu requires --protocol FROZEN.json.' >&2; exit 2; }
else
  [[ -x "$core_tool" && -x "$air_tool" && -f "$config" ]] || {
    echo 'generate requires --core-tool, --air-tool and --config.' >&2; exit 2;
  }
fi
source "$aie_root/scripts/env.sh"
cd "$orbit_root"
mkdir -p "$output"
cp "$script_root/run_taskflow_execution_graph_v18.sh" "$output/reproduction-source.sh"
record() {
  /usr/bin/python3 - "$output" "$@" <<'PY'
import json,subprocess,sys,time
from pathlib import Path
out=Path(sys.argv[1]);name=sys.argv[2];command=sys.argv[3:]
(out/(name+'.command.json')).write_text(json.dumps(command,indent=2)+'\n')
start=time.monotonic()
with (out/(name+'.stdout')).open('w') as stdout,(out/(name+'.stderr')).open('w') as stderr:
    p=subprocess.run(command,stdout=stdout,stderr=stderr)
(out/(name+'.result.json')).write_text(json.dumps({'exit_code':p.returncode,'elapsed_seconds':time.monotonic()-start},indent=2)+'\n')
raise SystemExit(p.returncode)
PY
}
if [[ "$mode" == npu ]]; then
  python - "$output" "$protocol" <<'PY'
import hashlib,json,sys
from pathlib import Path
p=Path(sys.argv[2]);Path(sys.argv[1],'frozen-protocol-input.json').write_text(json.dumps({'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'scope':'read-only replay; no model fitting, source mutation or protocol rewrite'},indent=2)+'\n')
PY
  # The SHA-validating observer acquires /tmp/npu.lock internally. No outer
  # flock is taken here, which would deadlock its independent lock acquisition.
  record observe timeout --signal=TERM --kill-after=10s 120s \
    python "$script_root/taskflow_execution_probe_tolerance_v18.py" \
    --protocol "$protocol" --output "$output/observation"
  python - "$output" "$protocol" <<'PY'
import hashlib,json,sys
from pathlib import Path
out=Path(sys.argv[1]);p=Path(sys.argv[2]);before=json.loads((out/'frozen-protocol-input.json').read_text())
assert before['sha256']==hashlib.sha256(p.read_bytes()).hexdigest()
(out/'result.json').write_text(json.dumps({'status':'PASS','mode':'npu','frozen_protocol_unchanged':True,'observer':'taskflow_execution_probe_tolerance_v18.py','scope':'complete prepared-call host observation and tolerance validation; no isolated DMA/core time'},indent=2)+'\n')
PY
  exit 0
fi
# Numerical/source fixture preparation only; all decisions remain in C++.
record prepare python "$artifact_root/taskflow/test/TaskflowAIR/prepare_execution_graph_v18.py" \
  --m 64 --n 128 --output "$output/plain-fixture"
record original-search /usr/bin/python3 "$orbit_root/test/TaskflowGeneric/execution_graph_search_v18.py" \
  --tool "$core_tool" --source "$output/plain-fixture/source.mlir" \
  --config "$config" --output "$output/search"
record compile-four python "$script_root/compile_execution_representatives_v18.py" \
  --index "$output/search/compile-representatives.json" --plain-fixture "$output/plain-fixture" \
  --tool "$air_tool" --output "$output/compiled"
python - "$output" "$script_root/taskflow_execution_probe_tolerance_v18.py" <<'PY'
import json,subprocess,sys
from pathlib import Path
out=Path(sys.argv[1]);index=json.loads((out/'compiled/index.json').read_text());command=[sys.executable,sys.argv[2]]
for case in index['cases']:command+=['--case',case['prepared'],case['compiled']]
command+=['--freeze',str(out/'protocol.json'),'--seeds','11','23','47','--warmups','2','--repeats','9','--poll-us','20']
(out/'freeze.command.json').write_text(json.dumps(command,indent=2)+'\n')
with (out/'freeze.stdout').open('w') as stdout,(out/'freeze.stderr').open('w') as stderr:
    p=subprocess.run(command,stdout=stdout,stderr=stderr)
(out/'freeze.result.json').write_text(json.dumps({'exit_code':p.returncode,'device_submissions':0},indent=2)+'\n')
raise SystemExit(p.returncode)
PY
printf '%s\n' '{"status":"PASS","mode":"generate","device_submissions":0,"scope":"fresh source -> original C++ search -> compile four -> SHA-bound tolerance protocol; no NPU execution"}' > "$output/result.json"
