#!/usr/bin/env bash
# Safe to source: execution occurs only through main below.
mechanism_usage_v13() {
  cat <<'EOF'
Usage: run_mechanism_model_v13.sh validate-only|all NEW_OUTPUT --protocol P --bindings B [options]

Options: --python PYTHON --aie-env FILE --bench FILE --calibrator FILE --auditor FILE
Environment defaults: ORBIT_TEST_PYTHON, AIE_TOY_ROOT, ORBIT_AIE_ENV.

validate-only performs CPU protocol/filter regressions and validates both frozen
split invocations; it opens no device. all runs training, calibrates and freezes
parameter hashes, then measures holdout and invokes the independent auditor.
Existing compiled programs/ELFs/executor contracts are reused without rebuilding.
EOF
}
mechanism_main_v13() {
  set -euo pipefail
  if [[ ${1:-} == --help || ${1:-} == -h ]]; then mechanism_usage_v13; return 0; fi
  [[ $# -ge 2 ]] || { mechanism_usage_v13 >&2; return 2; }
  local mode=$1 output=$2; shift 2
  [[ $mode == validate-only || $mode == all ]] || { mechanism_usage_v13 >&2; return 2; }
  local root aie python envfile bench calibrator auditor protocol= bindings=
  root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
  aie=${AIE_TOY_ROOT:-/home/shiran/project/aie-toy}
  python=${ORBIT_TEST_PYTHON:-$aie/.venv/bin/python}
  envfile=${ORBIT_AIE_ENV:-$aie/scripts/env.sh}
  bench=$root/scripts/taskflow_mechanism_microbench_v13.py
  calibrator=$root/test/TaskflowModels/calibrate_mechanisms_v13.py
  auditor=$root/test/TaskflowMapping/audit_mechanisms_v13.py
  while [[ $# -gt 0 ]]; do
    [[ $# -ge 2 ]] || { echo 'Missing option value' >&2; return 2; }
    case $1 in
      --protocol) protocol=$2;; --bindings) bindings=$2;; --python) python=$2;;
      --aie-env) envfile=$2;; --bench) bench=$2;; --calibrator) calibrator=$2;; --auditor) auditor=$2;;
      *) echo "Unknown option: $1" >&2; return 2;;
    esac
    shift 2
  done
  [[ -f $protocol && -f $bindings && -f $bench && -f $calibrator ]] || { echo 'Existing protocol, bindings, bench and calibrator are required' >&2; return 2; }
  if [[ $mode == all ]]; then
    [[ -f $envfile && -f $auditor ]] || { echo 'all requires an existing AIE environment and independent auditor' >&2; return 2; }
    # The caller may provide another compatible installed environment.
    source "$envfile"
  fi
  output=$(realpath -m "$output")
  [[ ! -e $output ]] || { echo 'Output directory must be new' >&2; return 2; }
  protocol=$(realpath "$protocol"); bindings=$(realpath "$bindings")
  bench=$(realpath "$bench"); calibrator=$(realpath "$calibrator")
  mkdir -p "$output/input"
  cp "$protocol" "$output/input/protocol.json"
  [[ -f $(dirname "$protocol")/freeze.json ]] || { echo 'Frozen protocol requires sibling freeze.json' >&2; return 2; }
  cp "$(dirname "$protocol")/freeze.json" "$output/input/freeze.json"
  "$python" - "$output/input/protocol.json" "$output/input/freeze.json" <<'PYGATE'
import hashlib,json,pathlib,sys
protocol,freeze=map(pathlib.Path,sys.argv[1:])
expected=json.loads(freeze.read_text()).get('protocol_sha256')
if not expected or hashlib.sha256(protocol.read_bytes()).hexdigest()!=expected:
 raise RuntimeError('Frozen protocol SHA does not match copied protocol bytes')
PYGATE
  cp "$bindings" "$output/input/bindings.json"
  cp "${BASH_SOURCE[0]}" "$output/reproduction-source.sh"
  exec > >(tee "$output/reproduce.log") 2>&1
  local frozen_protocol=$output/input/protocol.json frozen_bindings=$output/input/bindings.json
  mechanism_step_v13() {
    local name=$1; shift
    "$python" - "$output" "$name" "$@" <<'PY'
import hashlib,json,pathlib,subprocess,sys,time
out=pathlib.Path(sys.argv[1]);name=sys.argv[2];argv=sys.argv[3:]
def sha(p):return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
record={'argv':argv,'files':{p:sha(p) for p in argv if pathlib.Path(p).is_file()}}
(out/(name+'.command.json')).write_text(json.dumps(record,indent=2)+'\n')
start=time.perf_counter_ns();result=subprocess.run(argv)
(out/(name+'.result.json')).write_text(json.dumps({'returncode':result.returncode,'elapsed_ns':time.perf_counter_ns()-start},indent=2)+'\n')
sys.exit(result.returncode)
PY
  }
  mechanism_step_v13 cpu-regression "$python" "$root/test/TaskflowModels/mechanism_microbench_cpu_v13.py" --bench "$bench" --protocol "$frozen_protocol" --output "$output/cpu-regression"
  mechanism_step_v13 validate-training "$python" "$bench" --protocol "$frozen_protocol" --split training --output "$output/validate-training" --validate-only
  mechanism_step_v13 validate-holdout "$python" "$bench" --protocol "$frozen_protocol" --split holdout --output "$output/validate-holdout" --validate-only
  if [[ $mode == validate-only ]]; then return 0; fi
  mechanism_step_v13 training "$python" "$bench" --protocol "$frozen_protocol" --split training --output "$output/training"
  mechanism_step_v13 fit "$python" "$calibrator" --protocol "$frozen_protocol" --training-root "$output/training" --bindings "$frozen_bindings" --output "$output/model"
  "$python" - "$output" <<'PY'
import datetime,hashlib,json,pathlib,sys
out=pathlib.Path(sys.argv[1]);model=out/'model'
files={str((model/n).resolve()):hashlib.sha256((model/n).read_bytes()).hexdigest() for n in ('parameters.json','fit-report.json','freeze.json')}
assert json.loads((model/'freeze.json').read_text())['holdout_labels_read'] is False
(out/'parameter-gate-before-holdout.json').write_text(json.dumps({'schema':'orbit.mechanism.reproduction-freeze.v13','created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'files':files,'holdout_measured':False},indent=2)+'\n')
PY
  mechanism_step_v13 holdout "$python" "$bench" --protocol "$frozen_protocol" --split holdout --output "$output/holdout"
  "$python" - "$output" <<'PY'
import hashlib,json,pathlib,sys
out=pathlib.Path(sys.argv[1]);gate=json.loads((out/'parameter-gate-before-holdout.json').read_text())
for name,expected in gate['files'].items():
 if hashlib.sha256(pathlib.Path(name).read_bytes()).hexdigest()!=expected:raise RuntimeError('Frozen model changed after heldout measurement: '+name)
PY
  mechanism_step_v13 audit "$python" "$auditor" --protocol "$frozen_protocol" --training-root "$output/training" --holdout-root "$output/holdout" --model-freeze "$output/model" --bindings "$frozen_bindings" --holdout-gate "$output/parameter-gate-before-holdout.json" --output "$output/audit"
}
if [[ ${BASH_SOURCE[0]} == "$0" ]]; then mechanism_main_v13 "$@"; fi
