#!/usr/bin/env bash
# Source-safe; no measurements, imports, or environment changes until main.
sync_state_usage_v14() {
  cat <<'EOF'
Usage: run_sync_state_v14.sh --protocol P --new-output NEW --model-script FILE [options]
Options:
  --mode validate-only|all   Default validate-only; all opens the NPU.
  --python FILE             Default ORBIT_TEST_PYTHON or aie-toy/.venv/bin/python.
  --aie-env FILE            Default ORBIT_AIE_ENV or aie-toy/scripts/env.sh.
  --cpu-test-protocol FILE  Optional earlier exploration protocol for its CPU suite.

No search or compilation. Reuses frozen existing program packages and executor.
all measures calibration micro/actual-runner sites, fits once, freezes all model
files, measures both heldout sets, verifies unchanged model, then audits.
Sequence/whole-program timing is not fit. Existing v13 outputs are untouched. Do not wrap all in an outer NPU flock:
the microbench locks internally; this entry locks only program sequences.
EOF
}
sync_state_main_v14() {
  set -euo pipefail
  local protocol= output= model= mode=validate-only cpu_protocol=
  local root repo aie python envfile sourcefile
  sourcefile=$(realpath "${BASH_SOURCE[0]}")
  root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
  repo=$(cd "$root/.." && pwd)
  aie=${AIE_TOY_ROOT:-/home/shiran/project/aie-toy}
  python=${ORBIT_TEST_PYTHON:-$aie/.venv/bin/python}
  envfile=${ORBIT_AIE_ENV:-$aie/scripts/env.sh}
  while [[ $# -gt 0 ]]; do
    case $1 in --help|-h) sync_state_usage_v14; return 0;; esac
    [[ $# -ge 2 ]] || { echo 'Missing option value' >&2; return 2; }
    case $1 in
      --protocol) protocol=$2;; --new-output) output=$2;; --model-script) model=$2;;
      --cpu-test-protocol) cpu_protocol=$2;; --mode) mode=$2;; --python) python=$2;; --aie-env) envfile=$2;;
      *) echo "Unknown option: $1" >&2; return 2;;
    esac
    shift 2
  done
  [[ $mode == validate-only || $mode == all ]] || { echo 'Invalid mode' >&2; return 2; }
  [[ -f $protocol && -n $output && -f $model ]] || { sync_state_usage_v14 >&2; return 2; }
  protocol=$(realpath "$protocol"); model=$(realpath "$model"); output=$(realpath -m "$output")
  [[ ! -e $output ]] || { echo 'Output must be new' >&2; return 2; }
  if [[ $mode == all ]]; then
    [[ -f $envfile ]] || { echo 'Existing AIE environment required' >&2; return 2; }
    source "$envfile"
  fi
  # Runtime fingerprint explicitly includes cwd/config search candidates.
  cd "$repo"
  mkdir -p "$output/input"
  cp "$protocol" "$output/input/protocol.json"
  if [[ -f $(dirname "$protocol")/freeze.json ]]; then
    cp "$(dirname "$protocol")/freeze.json" "$output/input/freeze.json"
  fi
  cp "$sourcefile" "$output/reproduction-source.sh"
  "$python" - "$output" "$protocol" "$model" "$mode" <<'PY'
import hashlib,json,os,pathlib,sys
out,protocol,model,mode=sys.argv[1:]
def sha(p):return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
files={p:sha(p) for p in (protocol,model)}
freeze=pathlib.Path(protocol).parent/'freeze.json'
if freeze.is_file():
 data=json.loads(freeze.read_text());expected=data.get('protocol_sha256',data.get('sha256'))
 if not expected or sha(protocol)!=expected:raise RuntimeError('Protocol freeze SHA missing/mismatch')
 if 'protocol_sha256' in data and 'sha256' in data and data['protocol_sha256']!=data['sha256']:raise RuntimeError('Conflicting protocol freeze hashes')
elif mode=='all':raise RuntimeError('all requires sibling protocol freeze.json')
record=dict(schema='orbit.sync-state.reproduction.v14',mode=mode,files=files,cwd=os.getcwd(),
 environment={k:os.environ.get(k) for k in ('LD_LIBRARY_PATH','LD_PRELOAD','PYTHONPATH','XRT_INI_PATH','XRT_INI_DIR')},
 model_script_source=pathlib.Path(model).read_text(),existing_packages_reused=True,search=False,compilation=False)
(pathlib.Path(out)/'entry-identity.json').write_text(json.dumps(record,indent=2)+'\n')
PY
  sync_state_step_v14() {
    local name=$1; shift
    "$python" - "$output" "$name" "$@" <<'PY'
import hashlib,json,pathlib,subprocess,sys,time
out=pathlib.Path(sys.argv[1]);name=sys.argv[2];argv=sys.argv[3:]
record=dict(argv=argv,files={p:hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest() for p in argv if pathlib.Path(p).is_file()})
(out/(name+'.command.json')).write_text(json.dumps(record,indent=2)+'\n')
start=time.perf_counter_ns()
with (out/(name+'.log')).open('w') as log:result=subprocess.run(argv,stdout=log,stderr=subprocess.STDOUT)
(out/(name+'.exit.json')).write_text(json.dumps(dict(returncode=result.returncode,elapsed_ns=time.perf_counter_ns()-start),indent=2)+'\n')
if result.returncode:print('Failed '+name+'; see '+str(out/(name+'.log')),file=sys.stderr)
sys.exit(result.returncode)
PY
  }
  local p=$output/input/protocol.json micro=$root/scripts/taskflow_sync_state_microbench_v14.py sequence=$root/scripts/taskflow_sync_program_sequence_v14.py
  if [[ -n $cpu_protocol ]]; then
    sync_state_step_v14 micro-cpu "$python" "$root/test/TaskflowModels/sync_state_microbench_v14.py" --protocol "$(realpath "$cpu_protocol")" --output "$output/micro-cpu"
  fi
  sync_state_step_v14 sequence-cpu "$python" "$sequence" --self-test
  sync_state_step_v14 analysis-cpu "$python" "$root/test/TaskflowModels/sync_state_analysis_v14.py" --output "$output/analysis-cpu"
  for split in calibration holdout; do
    sync_state_step_v14 "validate-micro-$split" "$python" "$micro" --protocol "$p" --split "$split" --output "$output/validate-micro-$split" --validate-only
    sync_state_step_v14 "validate-program-$split" "$python" "$sequence" --protocol "$p" --split "$split" --output "$output/validate-program-$split" --validate-only
  done
  if [[ $mode == validate-only ]]; then return 0; fi
  sync_state_step_v14 micro-calibration "$python" "$micro" --protocol "$p" --split calibration --output "$output/micro-calibration"
  sync_state_step_v14 program-calibration flock -x /tmp/npu.lock "$python" "$sequence" --protocol "$p" --split calibration --output "$output/program-calibration"
  sync_state_step_v14 fit "$python" "$model" fit --protocol "$p" --calibration-root "$output/micro-calibration" --program-calibration-root "$output/program-calibration" --output "$output/model"
  "$python" - "$output" <<'PY'
import datetime,hashlib,json,pathlib,sys
out=pathlib.Path(sys.argv[1]);model=out/'model'
files={str(p.resolve()):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(model.rglob('*')) if p.is_file()}
if not files:raise RuntimeError('Fit produced no model files')
gate=dict(schema='orbit.sync-state.model-gate.v14',created_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),files=files,holdout_measured=False)
(out/'model-gate-before-holdout.json').write_text(json.dumps(gate,indent=2)+'\n')
PY
  sync_state_step_v14 micro-holdout "$python" "$micro" --protocol "$p" --split holdout --output "$output/micro-holdout"
  sync_state_step_v14 program-holdout flock -x /tmp/npu.lock "$python" "$sequence" --protocol "$p" --split holdout --output "$output/program-holdout"
  "$python" - "$output/model-gate-before-holdout.json" <<'PY'
import hashlib,json,pathlib,sys
gate=pathlib.Path(sys.argv[1]);files=json.loads(gate.read_text())['files']
current={str(p.resolve()) for p in (gate.parent/'model').rglob('*') if p.is_file()}
if current!=set(files):raise RuntimeError('Model file set changed after holdout')
for path,expected in files.items():
 if hashlib.sha256(pathlib.Path(path).read_bytes()).hexdigest()!=expected:raise RuntimeError('Model changed after holdout: '+path)
PY
  sync_state_step_v14 audit "$python" "$model" audit --protocol "$p" --calibration-root "$output/micro-calibration" --program-calibration-root "$output/program-calibration" --holdout-root "$output/micro-holdout" --program-holdout-root "$output/program-holdout" --model-root "$output/model" --holdout-gate "$output/model-gate-before-holdout.json" --output "$output/audit"
}
if [[ ${BASH_SOURCE[0]} == "$0" ]]; then sync_state_main_v14 "$@"; fi
