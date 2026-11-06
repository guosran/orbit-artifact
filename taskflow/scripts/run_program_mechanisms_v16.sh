#!/usr/bin/env bash
# Reversible compiler checks or explicit small NPU replay of SHA-bound packages.
set -euo pipefail
usage() {
  cat <<'EOF'
Usage: run_program_mechanisms_v16.sh --mode cpu|hardware --core-tool PATH \
  --protocol PATH --output NEW_DIRECTORY [--python PATH] [--model PATH]

cpu: public timing + existing direct-AIR contracts, then device-free package validation.
hardware: the same checks, then bounded NPU replay using the protocol's frozen polling.
The runner owns /tmp/npu.lock; do not wrap this entry in flock. No model fitting,
search expansion, or changes to the installed runtime. --model optionally records
an immutable parameter identity; its domain is not expanded for a new protocol.
Use explicit .venv Python when NumPy is required. All output directories must be new.
EOF
}
mode= core= protocol= output= model=
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
repo=$(cd "$script_dir/../.." && pwd)
aie=${AIE_TOY_ROOT:-$(dirname "$repo")/aie-toy}
python=${ORBIT_TEST_PYTHON:-$aie/.venv/bin/python}
while [[ $# -gt 0 ]]; do
  case $1 in --help|-h) usage; exit 0;; esac
  [[ $# -ge 2 ]] || { usage >&2; exit 2; }
  case $1 in
    --mode) mode=$2;; --core-tool) core=$2;; --protocol) protocol=$2;;
    --output) output=$2;; --python) python=$2;; --model) model=$2;;
    *) usage >&2; exit 2;;
  esac
  shift 2
done
[[ $mode == cpu || $mode == hardware ]] || { usage >&2; exit 2; }
[[ -x $core && -f $protocol && -n $output && ! -e $output ]] || { usage >&2; exit 2; }
[[ -z $model || -f $model ]] || { echo 'Missing explicit model' >&2; exit 2; }
core=$(realpath "$core");protocol=$(realpath "$protocol");output=$(realpath -m "$output")
[[ -z $model ]] || model=$(realpath "$model")
if [[ $mode == hardware ]]; then source "$aie/scripts/env.sh"; fi
cd "$repo"
"$python" - "$mode" "$core" "$protocol" "$output" "$script_dir" "$model" <<'PY'
import datetime,hashlib,json,pathlib,subprocess,sys,time
mode,core,protocol,out,scripts,model=sys.argv[1:];out=pathlib.Path(out);out.mkdir(parents=True,exist_ok=False);scripts=pathlib.Path(scripts);tool=pathlib.Path(core);root=pathlib.Path(core)
# Resolve source from the executable CMake cache, rather than hard-code a workspace.
cache=next(p/'CMakeCache.txt' for p in tool.parents if (p/'CMakeCache.txt').is_file())
source=next(x.split('=',1)[1] for x in cache.read_text().splitlines() if x.startswith('CMAKE_HOME_DIRECTORY:'))
source=pathlib.Path(source)
def sha(p):return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
def ident(p):return {'path':str(pathlib.Path(p).resolve()),'sha256':sha(p)}
def save(p,x):p.write_text(json.dumps(x,indent=2)+'\n')
def run(name,args,timeout=120):
    save(out/(name+'.command.json'),args);begin=time.perf_counter();utc=datetime.datetime.now(datetime.timezone.utc).isoformat()
    with (out/(name+'.log')).open('w') as log:
        try:r=subprocess.run(args,stdout=log,stderr=subprocess.STDOUT,timeout=timeout);rc=r.returncode
        except subprocess.TimeoutExpired:rc=124
    save(out/(name+'.result.json'),{'returncode':rc,'start_utc':utc,'end_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'elapsed_seconds':time.perf_counter()-begin})
    assert rc==0,name+' failed; logs and partial observations retained'
proto=json.loads(pathlib.Path(protocol).read_text());poll=proto['poll_us']
freeze={'created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'protocol':ident(protocol),'runner':ident(scripts/'taskflow_program_probe_v16.py'),'core_tool':ident(core),'mode':mode,'model':ident(model) if model else None,'poll_us':poll}
save(out/'invocation-freeze.json',freeze)
run('public-timing',[str(tool.parent/'taskflow-program-timing-test'),str(source/'test/TaskflowAIR/fixtures/heterogeneous.mlir')])
run('native-cost-contracts',[str(tool.parent/'taskflow-direct-air-cost-test'),str(source/'test/TaskflowGeneric/add.mlir')])
runner=[sys.executable,str(scripts/'taskflow_program_probe_v16.py'),'--protocol',protocol,'--poll-us',str(poll)]
run('package-validation',runner+['--validate-only','--output',str(out/'validated')])
if mode=='hardware':
    collector=[sys.executable,'-c','import sys,json;sys.path.insert(0,"taskflow/scripts");import collect_sync_target_v14 as c;print(json.dumps(c.collect_snapshot(),indent=2))']
    for name in ['before']:
        with (out/('runtime-'+name+'.json')).open('w') as f:subprocess.run(collector,stdout=f,check=True)
    run('measurement',runner+['--output',str(out/'measurement')],120)
    with (out/'runtime-after.json').open('w') as f:subprocess.run(collector,stdout=f,check=True)
    run('numerics',[sys.executable,str(scripts.parent/'test/TaskflowModels/audit_program_numerics_v16.py'),'--input',str(out/'measurement'),'--output',str(out/'independent-numerics.json')])
    assert (out/'runtime-before.json').read_bytes()==(out/'runtime-after.json').read_bytes()
if model:assert sha(model)==freeze['model']['sha256']
count=json.loads((out/'measurement/summary.json').read_text())['actual_submissions'] if mode=='hardware' else 0
save(out/'result.json',{'status':'passed','mode':mode,'device_submissions':count,'model_recalibrated':False,'search_executed':False,'scope':'compiler contracts plus explicit frozen-package replay; numerical/host observations only, no pure device time'})
print(json.dumps({'status':'passed','device_submissions':count,'output':str(out)}))
PY
