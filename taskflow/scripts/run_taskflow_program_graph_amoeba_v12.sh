#!/usr/bin/env bash
# Orchestration only: original C++ search/backend owns mapping and decisions.
set -euo pipefail
if [[ ${1:-} == --help ]]; then
  echo 'usage: run_taskflow_program_graph_amoeba_v12.sh prepare|cpu|compile-only|all NEW_OUTPUT'
  echo 'ORBIT_AMOEBA_GRAPH_CONFIG optionally overrides native default-shape/legacy-differential choices.'
  echo 'Tools: ORBIT_GRAPH_CORE_TOOL ORBIT_GRAPH_AMOEBA_TOOL ORBIT_GRAPH_AIR_TOOL; ORBIT_CGRA_MODELS optional.'
  echo 'No builds. Only all submits NPU work; invoke it only as authorized hardware coordinator.'
  exit 0
fi
[[ $# == 2 && ( $1 == prepare || $1 == cpu || $1 == compile-only || $1 == all ) ]] || exit 2
mode=$1
out=$(realpath -m "$2")
[[ ! -e $out ]] || { echo 'Output must be new.' >&2; exit 2; }
source "$(dirname "${BASH_SOURCE[0]}")/taskflow_paths.sh"
export AIE_TOY_ROOT=${AIE_TOY_ROOT:-$ARTIFACT_REPO/../aie-toy}
source "$AIE_TOY_ROOT/scripts/env.sh"
py=${ORBIT_TEST_PYTHON:-python3}
core=${ORBIT_GRAPH_CORE_TOOL:-$CORE_BUILD/tools/taskflow-opt/taskflow-opt}
amoeba=${ORBIT_GRAPH_AMOEBA_TOOL:-$AMOEBA_BUILD/tools/mlir-amoeba-opt/mlir-amoeba-opt}
air=${ORBIT_GRAPH_AIR_TOOL:-$AIR_BUILD/tools/taskflow-opt/taskflow-opt}
architecture=${ORBIT_CGRA_ARCHITECTURE:-$ORBIT_SRC/test/multi-cgra/taskflow/joint-scheduling/mapper-arch-4x4.yaml}
models=${ORBIT_CGRA_MODELS:-$ARTIFACT_REPO/reference/input0-neighborhood/models}
mkdir -p "$out"
cp "${BASH_SOURCE[0]}" "$out/reproduction-source.sh"
record() {
  "$py" - "$out" "$@" <<'PY'
import json,subprocess,sys,time
from pathlib import Path
from datetime import datetime,timezone
out=Path(sys.argv[1]);name=sys.argv[2];command=sys.argv[3:]
(out/(name+'.command.json')).write_text(json.dumps(command,indent=2)+'\n')
utc=datetime.now(timezone.utc).isoformat();start=time.perf_counter()
with (out/(name+'.log')).open('w') as log: result=subprocess.run(command,stdout=log,stderr=subprocess.STDOUT)
(out/(name+'.result.json')).write_text(json.dumps(dict(returncode=result.returncode,utc_start=utc,utc_end=datetime.now(timezone.utc).isoformat(),elapsed_wall_seconds=time.perf_counter()-start,device_submissions=None if name=='profile' else 0,scope='subprocess wall; profile submissions recovered from completed samples, failures retain partial checkpoints'),indent=2)+'\n')
raise SystemExit(result.returncode)
PY
}
record prepare "$py" "$ARTIFACT_ROOT/test/TaskflowAIR/prepare_program_graph_amoeba_v12.py" --output "$out/prepared"
if [[ $mode == prepare ]]; then
  echo '{"status":"prepared","compiler_executed":false,"hardware_executed":false}' > "$out/result.json"
  exit 0
fi
if [[ -n ${ORBIT_AMOEBA_GRAPH_CONFIG:-} ]]; then
  cp "$ORBIT_AMOEBA_GRAPH_CONFIG" "$out/target-config.json"
else
  echo '{"amoeba":{"default_shape":[1,1],"legacy_differential":true}}' > "$out/target-config.json"
fi
cp "$ORBIT_SRC/test/TaskflowAmoeba/program_graph_v12.py" "$out/compiler-test-source.py"
"$py" - "$out" "$core" "$amoeba" "$models" "$architecture" <<'PY'
import hashlib,json,sys
from pathlib import Path
out=Path(sys.argv[1]);paths=[Path(sys.argv[2]),Path(sys.argv[3]),Path(sys.argv[5]),out/'target-config.json',out/'compiler-test-source.py']+[Path(sys.argv[4])/n for n in ['ensemble.json','baseline.json','large-operation.json','ranking.json']]
(out/'input-identities.json').write_text(json.dumps({str(p.resolve()):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths},indent=2)+'\n')
PY
record compiler "$py" "$out/compiler-test-source.py" --tool "$amoeba" --core-tool "$core" \
  --config "$out/target-config.json" --architecture "$architecture" --models "$models" --source "$out/prepared/source.mlir" --output "$out/compiler"
record legacy-model-contract "$py" "$ARTIFACT_ROOT/test/TaskflowMapping/compute_contract_v8.py" \
  --tool "$amoeba" --models "$models" --output "$out/legacy-model-contract"
if [[ $mode == compile-only || $mode == all ]]; then
  record compile-air bash "$ARTIFACT_ROOT/scripts/run_taskflow_direct_air_v6_case.sh" --compile-only \
    --tool "$air" --input "$out/prepared" --output "$out/compiled-air" --runtime-transfer-audit
  record storage-air "$py" "$ARTIFACT_ROOT/test/TaskflowAIR/audit_storage_v6.py" \
    "$out/compiled-air/hardware" --plan "$out/compiled-air/plan.json" --output "$out/compiled-air/storage-audit.json"
  record graph-air "$air" "$out/prepared/source.mlir" --generic-map \
    "--program-graph-output=$out/compiled-air/program-graph.json" "--program-graph-dot=$out/compiled-air/program-graph.dot"
  record graph-air-audit "$py" "$ARTIFACT_ROOT/test/TaskflowAIR/audit_program_graph_v11.py" \
    --graph "$out/compiled-air/program-graph.json" --plan "$out/compiled-air/plan.json" \
    --air "$out/compiled-air/program.air.mlir" --output "$out/compiled-air/graph-audit.json"
  "$py" - "$out" <<'PYBRIDGE'
import hashlib,json,sys
from pathlib import Path
out=Path(sys.argv[1]);facts=json.loads((out/'compiler/analysis.json').read_text());plan=json.loads((out/'compiled-air/plan.json').read_text())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert plan['body_fingerprint']==facts['body_fingerprint']
assert sha(out/'prepared/source.mlir')==sha(out/'compiled-air/source.mlir')
(out/'same-source-backend-bridge.json').write_text(json.dumps(dict(status='passed',source_sha256=sha(out/'prepared/source.mlir'),body_fingerprint=facts['body_fingerprint'],air_graph_id=plan['program_graph_id'],scope='Exact same original source/body across Core analysis and AIR; backend target/graph IDs remain distinct'),indent=2)+'\n')
PYBRIDGE
fi
if [[ $mode == all ]]; then
  cp "$ARTIFACT_ROOT/scripts/taskflow_ffn_profile.py" "$out/profiler-executed.py"
  "$py" - "$out" <<'PY'
import hashlib,json,sys
from pathlib import Path
out=Path(sys.argv[1]);p=out/'compiled-air';abi=json.loads((p/'abi.json').read_text())
case=dict(name='same-source-air',hardware=str(p/'hardware'),abi=str(p/'abi.json'),static_indices=[],intermediate_indices=[i for i,b in enumerate(abi['buffers']) if b['role']=='temporary'],inputs=[str(out/f'prepared/inputs-{s}.npz') for s in [11,23,47]],reference=[str(out/f'prepared/reference-{s}.npz') for s in [11,23,47]])
(out/'profile-cases.json').write_text(json.dumps([case],indent=2)+'\n')
paths=[p/'hardware/program.elf',p/'abi.json',p/'source.mlir',p/'plan.json',p/'program.air.mlir',out/'profiler-executed.py']
(out/'device-input-identities.json').write_text(json.dumps({str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths},indent=2)+'\n')
PY
  record profile "$py" "$out/profiler-executed.py" --cases "$out/profile-cases.json" --observer detailed \
    --warmups 2 --iterations 5 --output "$out/profile-same-source"
  record numerical-audit "$py" "$ARTIFACT_ROOT/test/TaskflowAIR/audit_profile_v9.py" \
    --root "$out" --profile profile-same-source --output "$out/independent-numerical-audit"
fi
"$py" - "$out" "$mode" <<'PY'
import hashlib,json,sys
from pathlib import Path
out=Path(sys.argv[1]);hardware=sys.argv[2]=='all'
count=sum(len(r['samples']) for r in json.loads((out/'profile-same-source/results.json').read_text())['results']) if hardware else 0
(out/'result.json').write_text(json.dumps(dict(status='passed',mode=sys.argv[2],hardware_executed=hardware,device_submissions=count,model_training=False,entry_sha256=hashlib.sha256((out/'reproduction-source.sh').read_bytes()).hexdigest(),scope='Native original-driver ProgramGraph Amoeba model/mapper/scheduler; independent original model golden; optional same-source AIR compile/device validation. CGRA timings remain cycles estimates, not hardware measurements'),indent=2)+'\n')
PY
