#!/usr/bin/env bash
# Read/compile orchestration only. Native C++ owns graphs/search/schedules.
set -euo pipefail
if [[ ${1:-} == --help ]]; then
  echo 'usage: run_taskflow_program_graph_v11.sh prepare|cpu|compile-only|hardware|all NEW_OUTPUT_DIRECTORY'
  echo 'prepare/cpu/compile-only never submit NPU work; hardware/all are for the authorized hardware coordinator.'
  echo 'Overrides: ORBIT_SRC ORBIT_BUILD_ROOT ORBIT_GRAPH_CORE_TOOL ORBIT_GRAPH_AIR_TOOL AIE_TOY_ROOT ORBIT_TEST_PYTHON'
  exit 0
fi
[[ $# == 2 && ( $1 == prepare || $1 == cpu || $1 == compile-only || $1 == hardware || $1 == all ) ]] || { echo 'expected prepare|cpu|compile-only|hardware|all NEWDIR' >&2; exit 2; }
mode=$1
out=$(realpath -m "$2")
[[ ! -e $out ]] || { echo 'Output must be new.' >&2; exit 2; }
source "$(dirname "${BASH_SOURCE[0]}")/taskflow_paths.sh"
export AIE_TOY_ROOT=${AIE_TOY_ROOT:-$ARTIFACT_REPO/../aie-toy}
source "$AIE_TOY_ROOT/scripts/env.sh"
py=${ORBIT_TEST_PYTHON:-python3}
core_tool=${ORBIT_GRAPH_CORE_TOOL:-$CORE_BUILD/tools/taskflow-opt/taskflow-opt}
air_tool=${ORBIT_GRAPH_AIR_TOOL:-$AIR_BUILD/tools/taskflow-opt/taskflow-opt}
mkdir -p "$out"
cp "${BASH_SOURCE[0]}" "$out/reproduction-source.sh"
"$py" "$ARTIFACT_ROOT/python/taskflow_paths.py" > "$out/paths.json"
record() {
  "$py" - "$out" "$@" <<'PY'
import hashlib,json,subprocess,sys,time
from pathlib import Path
from datetime import datetime,timezone
out=Path(sys.argv[1]);name=sys.argv[2];cmd=sys.argv[3:]
(out/(name+'.command.json')).write_text(json.dumps(cmd,indent=2)+'\n')
start=datetime.now(timezone.utc).isoformat();begin=time.perf_counter()
with (out/(name+'.log')).open('w') as log:r=subprocess.run(cmd,stdout=log,stderr=subprocess.STDOUT)
(out/(name+'.result.json')).write_text(json.dumps(dict(returncode=r.returncode,utc_start=start,utc_end=datetime.now(timezone.utc).isoformat(),elapsed_wall_seconds=time.perf_counter()-begin,device_submissions=None if name=='profile' else 0,submission_scope='profile count recovered from completed samples in final result; partial failure retains profiler checkpoints' if name=='profile' else 'no NPU submission'),indent=2)+'\n')
if r.returncode:raise SystemExit(r.returncode)
PY
}
record prepare "$py" "$ARTIFACT_ROOT/test/TaskflowAIR/prepare_program_graph_v11.py" --output "$out/prepared"
if [[ $mode == prepare ]]; then
  echo '{"status":"prepared","compiler_executed":false,"hardware_executed":false}' > "$out/result.json"
  exit 0
fi
[[ -x $core_tool && -x $(dirname "$core_tool")/taskflow-program-graph-test ]] || { echo 'Build Core taskflow-opt and taskflow-program-graph-test first, or set ORBIT_GRAPH_CORE_TOOL.' >&2; exit 2; }
tool=$core_tool
flags=()
if [[ $mode == compile-only || $mode == hardware || $mode == all ]]; then
  [[ -x $air_tool ]] || { echo 'Build AIR tool first, or set ORBIT_GRAPH_AIR_TOOL.' >&2; exit 2; }
  tool=$air_tool
  flags+=(--air)
fi
"$py" - "$out" "$core_tool" "$(dirname "$core_tool")/taskflow-program-graph-test" "$tool" <<'PYTOOLS'
import hashlib,json,sys
from pathlib import Path
out=Path(sys.argv[1]);paths=[Path(p).resolve() for p in sys.argv[2:]]
(out/'tool-identities.json').write_text(json.dumps({str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths},indent=2)+'\n')
PYTOOLS
record cpu "$py" "$ORBIT_SRC/test/TaskflowAIR/program_graph_v11.py" --tool "$tool" \
  --checker "$(dirname "$core_tool")/taskflow-program-graph-test" --source "$out/prepared/gemm-scale/source.mlir" --output "$out/cpu" "${flags[@]}"
for policy in phase-local retain-across-users shared-sram-retain separate-locals-retain separate-locals-phase; do
  record "fanout-$policy" "$core_tool" "$out/prepared/fanout/source.mlir" --program-graph \
    "--target-config=$out/prepared/fanout/$policy.config.json" \
    "--program-graph-output=$out/fanout-$policy.graph.json" "--program-graph-dot=$out/fanout-$policy.graph.dot" \
    "--mapping-output=$out/fanout-$policy.plan.json"
  record "fanout-$policy-audit" "$py" "$ARTIFACT_ROOT/test/TaskflowAIR/audit_program_graph_v11.py" \
    --graph "$out/fanout-$policy.graph.json" --fixture "$out/prepared/fanout" --case fanout --negative-tests --output "$out/fanout-$policy.audit.json"
done
"$py" - "$out" <<'PYTOPOLOGY'
import json,sys
from pathlib import Path
out=Path(sys.argv[1]);names=['shared-sram-retain','separate-locals-retain','separate-locals-phase']
rows={n:json.loads((out/f'fanout-{n}.audit.json').read_text()) for n in names}
assert len({r['source_body_fingerprint'] for r in rows.values()})==1
assert [rows[n]['planned_transfer_bytes'] for n in names]==[64,192,256]
assert all(r['data_edges']==3 and r['order_edges']==1 and r['submission_count']==0 for r in rows.values())
(out/'fanout-topology-comparison.json').write_text(json.dumps(dict(status='passed',rows=rows,scope='Same source, synthetic architectures and costs; planned copy bytes, no measured traffic'),indent=2)+'\n')
PYTOPOLOGY
for policy in phase retain; do
  audit_flags=()
  if [[ $mode == compile-only || $mode == hardware || $mode == all ]]; then audit_flags+=(--air "$out/cpu/$policy/program.air.mlir"); fi
  record "gemm-$policy-audit" "$py" "$ARTIFACT_ROOT/test/TaskflowAIR/audit_program_graph_v11.py" \
    --graph "$out/cpu/$policy/program-graph.json" --plan "$out/cpu/$policy/plan.json" --fixture "$out/prepared/gemm-scale" \
    --case gemm-scale --output "$out/gemm-$policy.audit.json" "${audit_flags[@]}"
done
if [[ $mode == compile-only || $mode == hardware || $mode == all ]]; then
  # Sources are materialized by the native compiler, never patched by Python.
  for policy in phase retain combined; do
    mkdir "$out/input-$policy"
    if [[ $policy == combined ]]; then
      cid=$("$py" -c 'import json,sys;print(json.load(open(sys.argv[1]))["combined_candidate"])' "$out/cpu/summary.json")
      cp "$out/cpu/search/candidates/$cid/taskflow.mlir" "$out/input-$policy/source.mlir"
      cp "$out/cpu/search-config.json" "$out/$policy.config.json"
      expected_graph="$out/cpu/search/candidates/$cid/program-graph.json"
    else
      cp "$out/cpu/$policy/transformed.mlir" "$out/input-$policy/source.mlir"
      echo '{}' > "$out/$policy.config.json"
      expected_graph="$out/cpu/$policy/program-graph.json"
    fi
    cp "$out/prepared/gemm-scale/"*.npz "$out/input-$policy/"
    record "compile-$policy" bash "$ARTIFACT_ROOT/scripts/run_taskflow_direct_air_v6_case.sh" \
      --compile-only --input "$out/input-$policy" --output "$out/compiled-$policy" --tool "$air_tool" \
      --target-config "$out/$policy.config.json" --distribute-initialization --runtime-transfer-audit
    record "graph-$policy" "$air_tool" "$out/compiled-$policy/source.mlir" --generic-map --air-distribute-initialization \
      "--target-config=$out/$policy.config.json" "--program-graph-output=$out/compiled-$policy/program-graph.json" \
      "--program-graph-dot=$out/compiled-$policy/program-graph.dot"
    "$py" - "$out" "$policy" "$expected_graph" <<'PYBRIDGE'
import hashlib,json,sys
from pathlib import Path
out=Path(sys.argv[1]);policy=sys.argv[2];expected=Path(sys.argv[3]);compiled=out/('compiled-'+policy)
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
native=json.loads((compiled/'plan.json').read_text());graph=json.loads(expected.read_text())
if native['program_graph']!=graph or native['program_graph_id']!=graph['id']:raise SystemExit('Compiled graph differs from original native candidate: '+policy)
(compiled/'graph-semantic-bridge.json').write_text(json.dumps(dict(status='passed',expected_graph=dict(path=str(expected),sha256=sha(expected)),actual_plan=dict(path=str(compiled/'plan.json'),sha256=sha(compiled/'plan.json')),graph_id=graph['id'],source_sha256=sha(compiled/'source.mlir'),scope='Exact common graph identity and full JSON equality; original compiler materialized source reused, no Python plan'),indent=2)+'\n')
PYBRIDGE
    record "compiled-graph-$policy-audit" "$py" "$ARTIFACT_ROOT/test/TaskflowAIR/audit_program_graph_v11.py" \
      --graph "$out/compiled-$policy/program-graph.json" --plan "$out/compiled-$policy/plan.json" \
      --fixture "$out/prepared/gemm-scale" --air "$out/compiled-$policy/program.air.mlir" \
      --case gemm-scale --output "$out/compiled-$policy/graph-audit.json"
    record "storage-$policy" "$py" "$ARTIFACT_ROOT/test/TaskflowAIR/audit_storage_v6.py" \
      "$out/compiled-$policy/hardware" --plan "$out/compiled-$policy/plan.json" --output "$out/compiled-$policy/storage-audit.json"
  done
fi
if [[ $mode == hardware || $mode == all ]]; then
  # Existing profiler, unchanged algorithms/runtime; fixture inputs staged per
  # call, temporary BOs by ABI role. Coordinator alone invokes these modes.
  cp "$ARTIFACT_ROOT/scripts/taskflow_ffn_profile.py" "$out/profiler-executed.py"
  "$py" - "$out" <<'PYCASES'
import hashlib,json,sys
from pathlib import Path
out=Path(sys.argv[1]);cases=[];artifacts={}
for name in ['phase','retain','combined']:
 package=out/('compiled-'+name);abi=json.loads((package/'abi.json').read_text());inputs=out/'prepared/gemm-scale'
 cases.append(dict(name=name,hardware=str(package/'hardware'),abi=str(package/'abi.json'),static_indices=[],intermediate_indices=[i for i,b in enumerate(abi['buffers']) if b['role']=='temporary'],inputs=[str(inputs/f'inputs-{s}.npz') for s in [11,23,47]],reference=[str(inputs/f'reference-{s}.npz') for s in [11,23,47]]))
 for path in [package/'hardware/program.elf',package/'hardware/input.air.mlir',package/'plan.json',package/'abi.json',package/'source.mlir',package/'program-graph.json']:
  artifacts[str(path)]=hashlib.sha256(path.read_bytes()).hexdigest()
(out/'profile-cases.json').write_text(json.dumps(cases,indent=2)+'\n')
(out/'profile-input-identities.json').write_text(json.dumps(dict(files=artifacts,seeds=[11,23,47],warmups=2,hot=5,observer='detailed',submission_scope='complete GEMM-scale per sample; alternating forward/reverse existing profiler order',source='native compiler original phase/retention and combined search candidate; no CPU arithmetic fallback'),indent=2)+'\n')
PYCASES
  record profile "$py" "$out/profiler-executed.py" --cases "$out/profile-cases.json" \
    --observer detailed --warmups 2 --iterations 5 --output "$out/profile-program-graph"
  record raw-numerical-audit "$py" "$ARTIFACT_ROOT/test/TaskflowAIR/audit_profile_v9.py" \
    --root "$out" --profile profile-program-graph --output "$out/independent-numerical-audit"
fi
"$py" - "$out" "$mode" "$tool" <<'PY'
import hashlib,json,sys
from pathlib import Path
out=Path(sys.argv[1]);tool=Path(sys.argv[3]);files={str(p.relative_to(out)):hashlib.sha256(p.read_bytes()).hexdigest() for p in out.glob('*.sh')}
hardware=sys.argv[2] in ['hardware','all']
count=sum(len(r['samples']) for r in json.loads((out/'profile-program-graph/results.json').read_text())['results']) if hardware else 0
(out/'result.json').write_text(json.dumps(dict(status='passed',mode=sys.argv[2],compiler_executed=True,hardware_executed=sys.argv[2] in ['hardware','all'],device_submissions=count,submission_count_source='completed profiler samples, one whole-program invocation per sample' if hardware else 'CPU/compile-only has no submission',tool=dict(path=str(tool),sha256=hashlib.sha256(tool.read_bytes()).hexdigest()),sources=files,scope='CPU graph/search/resume; optional compile of three complete variants; hardware/all independently audit three seeds x seven calls x three complete programs, no calibrated latency claim'),indent=2)+'\n')
PY
