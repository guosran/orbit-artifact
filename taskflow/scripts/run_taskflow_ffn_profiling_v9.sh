#!/usr/bin/env bash
# Fresh experiment workflow. Native C++ owns all feature plans; holdout
# execution is guarded by the existing fitter output and immutable identities.
set -euo pipefail
usage() {
  cat <<'EOF'
usage: run_taskflow_ffn_profiling_v9.sh cpu|all NEW_OUTPUT_DIRECTORY [--phase PHASE --previous PREVIOUS_DIRECTORY]

cpu: isolated fresh compiler/regression build and CPU profiler/fitter tests.
all: cpu, prepare+compile M1/M3/M5/M8 complete stage mains and packed controls,
     then training → native features → fit/freeze → holdout → independent audit.
Phases: training, collect, freeze, holdout, audit. Late phases require --previous
pointing to a directory produced by the preceding phase; each output is new.
Environment: ORBIT_SRC, LLVM_BUILD, AIE_TOY_ROOT, ORBIT_TEST_PYTHON,
             ORBIT_BUILD_ROOT (default NEW_OUTPUT_DIRECTORY/build).
No existing results, old binary or fitted model is a default input.
EOF
}
if [[ ${1:-} == --help || ${1:-} == -h ]]; then usage; exit 0; fi
[[ $# -ge 2 && ( "$1" == cpu || "$1" == all ) ]] || { usage >&2; exit 2; }
mode=$1
out=$(realpath -m "$2")
shift 2
phase=all
previous=
while [[ $# -gt 0 ]]; do
  case "$1" in
    --phase) phase=$2; shift 2;;
    --previous) previous=$(realpath "$2"); shift 2;;
    *) usage >&2; exit 2;;
  esac
done
[[ "$phase" != train ]] || phase=training
[[ "$phase" != fit ]] || phase=freeze
case "$phase" in all|cpu|training|collect|freeze|holdout|audit) ;; *) usage >&2; exit 2;; esac
if [[ "$phase" == collect || "$phase" == freeze || "$phase" == holdout || "$phase" == audit ]]; then
  [[ -n "$previous" && -f "$previous/workflow-state.json" ]] || { echo 'Late phase needs explicit previous workflow-state.json.' >&2; exit 2; }
else
  [[ -z "$previous" ]] || { echo '--previous is only used by late phases.' >&2; exit 2; }
fi
if [[ "$mode" == cpu ]]; then
  [[ "$phase" == all || "$phase" == cpu ]] || { echo 'cpu mode cannot execute hardware/late phases.' >&2; exit 2; }
  phase=cpu
fi
[[ ! -e "$out" && "$out" != *[[:space:]]* ]] || { echo 'Use a new output directory without whitespace.' >&2; exit 2; }
export ORBIT_BUILD_ROOT=${ORBIT_BUILD_ROOT:-$out/build}
source "$(dirname "${BASH_SOURCE[0]}")/taskflow_paths.sh"
export AIE_TOY_ROOT=${AIE_TOY_ROOT:-$ARTIFACT_REPO/../aie-toy}
[[ -f "$AIE_TOY_ROOT/scripts/env.sh" ]] || { echo 'Missing existing AIE runtime environment.' >&2; exit 2; }
source "$AIE_TOY_ROOT/scripts/env.sh"
python_bin=$ORBIT_TEST_PYTHON
[[ -x "$python_bin" && -d "$ORBIT_SRC" ]] || { echo 'Missing configured Python or core source.' >&2; exit 2; }
mkdir -p "$out"
exec > >(tee "$out/reproduce.log") 2>&1
cd "$ARTIFACT_ROOT"
cp "scripts/run_taskflow_ffn_profiling_v9.sh" "$out/reproduction-source.sh"
"$python_bin" python/taskflow_paths.py > "$out/paths.json"
git -C "$ORBIT_SRC" rev-parse HEAD > "$out/core-revision.txt"
git -C "$ORBIT_SRC" status --short > "$out/core-worktree.txt"
git -C "$ARTIFACT_REPO" rev-parse HEAD > "$out/artifact-revision.txt"
git -C "$ARTIFACT_REPO" status --short > "$out/artifact-worktree.txt"

# Phase state points to explicit fresh-run artifacts; never a historical default.
package=$out
collection=
frozen=
holdout=
if [[ -n "$previous" ]]; then
  cp "$previous/workflow-state.json" "$out/previous-workflow-state.json"
  field() { "$python_bin" - "$previous/workflow-state.json" "$1" <<'PYFIELD'
import json,sys
print(json.load(open(sys.argv[1])).get(sys.argv[2]) or '')
PYFIELD
  }
  package=$(field package)
  collection=$(field collection)
  frozen=$(field frozen)
  holdout=$(field holdout)
  "$python_bin" - "$previous/workflow-state.json" "$phase" <<'PYPREVIOUS'
import hashlib,json,sys
from pathlib import Path
s=json.load(open(sys.argv[1]))
expected={'collect':'training-audited','freeze':'collected','holdout':'frozen','audit':'holdout-executed'}[sys.argv[2]]
if s.get('schema')!='orbit.ffn.workflow.v1' or s.get('phase')!=expected:
 raise SystemExit('previous workflow phase does not satisfy transition: '+expected)
if s.get('frozen'):
 p=Path(s['frozen'])/'freeze.json'
 if hashlib.sha256(p.read_bytes()).hexdigest()!=s['freeze_sha256']:raise SystemExit('frozen model identity changed')
PYPREVIOUS
fi
state() {
  "$python_bin" - "$out" "$1" "$package" "$collection" "$frozen" "$holdout" "$mode" <<'PYSTATE'
import hashlib,json,sys
from pathlib import Path
out=Path(sys.argv[1]);history=out/'phase-history';history.mkdir(exist_ok=True)
value=dict(schema='orbit.ffn.workflow.v1',phase=sys.argv[2],package=sys.argv[3],collection=sys.argv[4] or None,frozen=sys.argv[5] or None,holdout=sys.argv[6] or None)
if value['frozen']:
 p=Path(value['frozen'])/'freeze.json';value['freeze_sha256']=hashlib.sha256(p.read_bytes()).hexdigest()
text=json.dumps(value,indent=2)+'\n'
p=history/(value['phase']+'.json')
if p.exists():raise SystemExit('phase evidence exists: '+str(p))
p.write_text(text);(out/'workflow-state.json').write_text(text)
scope_path=out/'scope.json'
scope=json.loads(scope_path.read_text()) if scope_path.exists() else dict(mode=sys.argv[7],cpu_regression=False,model_fit=False,holdout_execution=False,native_feature_collection=False,independent_holdout_audit=False,planned_pipeline=['CPU regressions','prepare/compile','training and independent audit','native features','fit/freeze','heldout execution','independent heldout audit/score'])
for phase,key in [('collected','native_feature_collection'),('frozen','model_fit'),('holdout-executed','holdout_execution'),('audited','independent_holdout_audit')]:
 if value['phase']==phase:scope[key]=True
scope['execution_scope']='booleans describe completed work in this output directory; inherited package/freeze paths are in workflow-state.json'
scope['latest_completed_phase']=value['phase']
scope_path.write_text(json.dumps(scope,indent=2)+'\n')
PYSTATE
}
collect_phase() {
  collection=$out/native-features
  "$python_bin" scripts/taskflow_ffn_workflow_v9.py collect --package "$package" \
    --audit "$package/training-independent-audit" --tool "$package/frozen-tools/taskflow-opt" --output "$collection"
  state collected
}
freeze_phase() {
  [[ -n "$collection" ]] || { echo 'Missing collected native features.' >&2; exit 2; }
  frozen=$out/frozen-model
  "$python_bin" scripts/taskflow_ffn_workflow_v9.py freeze --collection "$collection" --output "$frozen"
  state frozen
}
holdout_phase() {
  [[ -n "$frozen" ]] || { echo 'Missing frozen model.' >&2; exit 2; }
  "$python_bin" scripts/taskflow_ffn_workflow_v9.py check-freeze --frozen "$frozen" > "$out/holdout-precheck.json"
  holdout=$out
  "$python_bin" "$package/frozen-tools/taskflow_ffn_profile.py" --cases "$package/cases-m3.json" \
    --iterations 1 --warmups 1 --observer detailed --output "$holdout/profile-m3-holdout"
  "$python_bin" "$package/frozen-tools/taskflow_ffn_profile.py" --cases "$package/cases-controls-holdout.json" \
    --iterations 10 --warmups 2 --observer detailed --output "$holdout/profile-controls-holdout"
  "$python_bin" scripts/taskflow_ffn_workflow_v9.py check-freeze --frozen "$frozen" > "$out/holdout-postcheck.json"
  state holdout-executed
}
audit_phase() {
  [[ -n "$holdout" && -n "$frozen" ]] || { echo 'Missing holdout/frozen identity.' >&2; exit 2; }
  "$python_bin" test/TaskflowAIR/audit_profile_v9.py --root "$holdout" \
    --profile profile-m3-holdout --profile profile-controls-holdout --output "$out/holdout-independent-audit"
  "$python_bin" scripts/taskflow_ffn_workflow_v9.py score --frozen "$frozen" \
    --audit "$out/holdout-independent-audit" --holdout "$holdout" --output "$out/holdout-score"
  state audited
}
case "$phase" in
  collect) collect_phase; exit 0;;
  freeze) freeze_phase; exit 0;;
  holdout) holdout_phase; exit 0;;
  audit) audit_phase; exit 0;;
esac

# This CPU mode does not open a device. The called regression owns all build
# configuration and honors ORBIT_BUILD_ROOT/LLVM_BUILD/ORBIT_SRC overrides.
bash scripts/run_taskflow_data_organization_v8.sh cpu "$out/cpu-regression"
"$python_bin" test/TaskflowAIR/profiling_v9.py --output "$out/profiler-cpu-mocks"
"$python_bin" test/TaskflowModels/direct_air_fit_v9.py > "$out/fitter-cpu-tests.log" 2>&1
# The older parent entry does not build the new direct-AIR cost checker.
# Build all six Core checker binaries before the standard Core/Amoeba/AIR suite;
# its AIR section includes mixed FP32 and physical stream-capacity regressions.
cmake --build "$CORE_BUILD" --target taskflow-generic-mapping-test \
  taskflow-tiled-mapping-test taskflow-program-mapping-test \
  taskflow-program-partition-test taskflow-data-organization-test \
  taskflow-direct-air-cost-test -j2
"$python_bin" "$ORBIT_SRC/test/run_core_regressions.py" \
  --tool "$CORE_BUILD/tools/taskflow-opt/taskflow-opt" \
  --amoeba-tool "$AMOEBA_BUILD/tools/mlir-amoeba-opt/mlir-amoeba-opt" \
  --air-tool "$AIR_BUILD/tools/taskflow-opt/taskflow-opt" \
  --air-opt "$(command -v air-opt)" --output "$out/compiler-regressions-v9"
"$python_bin" test/TaskflowAIR/reproduction_v9.py --output "$out/workflow-cpu-mocks"

mkdir "$out/frozen-tools"
cp -p "$AIR_BUILD/tools/taskflow-opt/taskflow-opt" "$out/frozen-tools/taskflow-opt"
cp scripts/taskflow_ffn_profile.py "$out/frozen-tools/taskflow_ffn_profile.py"
sha256sum "$out/frozen-tools/taskflow-opt" "$out/frozen-tools/taskflow_ffn_profile.py" > "$out/frozen-tools/identities.sha256"
ldd "$out/frozen-tools/taskflow-opt" > "$out/frozen-tools/linked-libraries.txt"
"$python_bin" - "$out" "$mode" <<'PY'
import json,sys
from pathlib import Path
out=Path(sys.argv[1])
(out/'scope.json').write_text(json.dumps(dict(mode=sys.argv[2],cpu_regression=True,mixed_compiler_gate=True,holdout_execution=False,model_fit=False,native_feature_collection=False,independent_holdout_audit=False,search=False,optimization=False,planned_pipeline=['prepare/compile fresh stage mains and packed controls','training and independent audit','native features','existing fitter using training labels only','freeze','heldout execution','independent heldout audit/score']),indent=2)+'\n')
PY
if [[ "$phase" == cpu ]]; then state cpu-validated; exit 0; fi

tool=$out/frozen-tools/taskflow-opt
printf '%s\n' '{"generic_air":{"tile_sizes":[8,64,64]}}' > "$out/target.json"
for m in 1 3 5 8; do
  OPENBLAS_NUM_THREADS=1 "$python_bin" test/TaskflowAIR/prepare_ffn_stages_v7.py \
    --m "$m" --seeds 11 23 47 --output "$out/inputs/m$m"
  for stage in gate up activation down full; do
    bash scripts/run_taskflow_direct_air_v6_case.sh --compile-only \
      --input "$out/inputs/m$m/$stage" --output "$out/baseline/m$m/$stage" \
      --tool "$tool" --target-config "$out/target.json" \
      --distribute-initialization --approx-exp --runtime-transfer-audit
    "$python_bin" test/TaskflowAIR/audit_storage_v6.py "$out/baseline/m$m/$stage/hardware" \
      --plan "$out/baseline/m$m/$stage/plan.json" --output "$out/baseline/m$m/$stage/storage-audit.json"
  done
done
"$python_bin" test/TaskflowAIR/prepare_profile_controls_v9.py \
  --packed-two-input --output "$out/controls-input"
for input in "$out"/controls-input/{train,holdout}-*; do
  name=$(basename "$input")
  bash scripts/run_taskflow_direct_air_v6_case.sh --compile-only \
    --input "$input" --output "$out/controls-compiled/$name" --tool "$tool" \
    --target-config "$input/target.json" --runtime-transfer-audit
  "$python_bin" test/TaskflowAIR/audit_storage_v6.py "$out/controls-compiled/$name/hardware" \
    --plan "$out/controls-compiled/$name/plan.json" --output "$out/controls-compiled/$name/storage-audit.json"
done

# This only materializes explicit fixture invocation lists from existing ABIs.
# C++ has already selected/checked every hardware plan. It makes no mapping or
# scheduling decision. Only explicit W_* fixture weights are declared static;
# this is existing system BO reuse, never a privileged production data class or
# AIE SRAM retention. Other input arrays are staged each call, as measured.
"$python_bin" - "$out" <<'PY'
import hashlib,json,sys
from pathlib import Path
out=Path(sys.argv[1])
def case(name,compiled,inputs,seeds):
    abi=json.loads((compiled/'abi.json').read_text())
    return dict(name=name,hardware=str(compiled/'hardware'),abi=str(compiled/'abi.json'),
        static_indices=[i for i,b in enumerate(abi['buffers']) if b['role']=='input' and b['name'].startswith('W_')],
        intermediate_indices=[i for i,b in enumerate(abi['buffers']) if b['role']=='temporary'],
        inputs=[str(inputs/f'inputs-{seed}.npz') for seed in seeds],
        reference=[str(inputs/f'reference-{seed}.npz') for seed in seeds],
        prepared_state='fixture explicitly declares W_* inputs immutable within one seed/context; only weight system BOs reused; other inputs staged every call; no AIE SRAM residency claim')
for m in [1,3,5,8]:
    seeds=[11,23,47] if m==3 else [11]
    rows=[case(f'm{m}-{stage}',out/f'baseline/m{m}/{stage}',out/f'inputs/m{m}/{stage}',seeds) for stage in ['gate','up','activation','down','full']]
    (out/f'cases-m{m}.json').write_text(json.dumps(rows,indent=2)+'\n')
manifest=json.loads((out/'controls-input/manifest.json').read_text())
for split in ['train','holdout']:
    rows=[case(row['name'],out/'controls-compiled'/row['name'],out/'controls-input'/row['name'],[11,23,47]) for row in manifest['cases'] if row['split']==split]
    (out/f'cases-controls-{split}.json').write_text(json.dumps(rows,indent=2)+'\n')
(out/'prepared-packages.json').write_text(json.dumps(dict(ffn_shapes=[1,3,5,8],stage_programs=20,control_programs=12,holdouts_compiled_not_executed=['M3','controls17x80'],ABI_state_policy='explicit fixture W_* names with role=input static; role=temporary scratch; other inputs restaged; per-seed context, no static output'),indent=2)+'\n')
PY

# Separate runner invocations preserve each snapshot's actual observed context,
# selected wait backend, raw outputs, host timeline and evidence-I/O boundary.
for m in 1 5 8; do
  "$python_bin" "$out/frozen-tools/taskflow_ffn_profile.py" --cases "$out/cases-m$m.json" \
    --iterations 2 --warmups 1 --observer detailed --output "$out/profile-m$m-training"
done
"$python_bin" "$out/frozen-tools/taskflow_ffn_profile.py" --cases "$out/cases-controls-train.json" \
  --iterations 10 --warmups 2 --observer detailed --output "$out/profile-controls-training"
"$python_bin" test/TaskflowAIR/audit_profile_v9.py --root "$out" \
  --profile profile-m1-training --profile profile-m5-training --profile profile-m8-training \
  --profile profile-controls-training --output "$out/training-independent-audit"
state training-audited
if [[ "$phase" == training ]]; then
  printf 'Training complete; holdout execution remains gated: %s\n' "$out"
  exit 0
fi
collect_phase
freeze_phase
holdout_phase
audit_phase
printf 'Fresh scalar workflow completed: %s\n' "$out"
