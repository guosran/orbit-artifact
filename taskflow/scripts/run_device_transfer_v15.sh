#!/usr/bin/env bash
# Explicit frozen compiled packages are inputs; this entry never plans/compiles.
set -euo pipefail
usage() {
cat <<'EOF'
Usage: run_device_transfer_v15.sh --calibration-protocol P --holdout-protocol P \
  --bindings B --facts-calibration I --facts-holdout I --output NEW [options]
  --mode validate-only|all     Default validate-only; all opens NPU.
  --python PATH               Default ORBIT_TEST_PYTHON or aie-toy venv.
  --aie-env PATH              Default ORBIT_AIE_ENV or aie-toy/scripts/env.sh.

Requires existing compiled, SHA-bound native packages and actual C++ facts.
No historical result/model default, search, compiler build, or production Python
planning. all measures calibration, audits, fits and freezes before measuring
heldout, then independently validates. Both measurement commands own npu.lock.
The external timeout is120s per measurement subprocess, not an installed runtime
change. Full-program/physical DDR costs remain unknown.
EOF
}
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
repo=$(cd "$root/.." && pwd)
aie=${AIE_TOY_ROOT:-$(dirname "$repo")/aie-toy}
python=${ORBIT_TEST_PYTHON:-$aie/.venv/bin/python}
envfile=${ORBIT_AIE_ENV:-$aie/scripts/env.sh}
entry=$(realpath "${BASH_SOURCE[0]}")
mode=validate-only
cal= held= bindings= facts_c= facts_h= output=
while [[ $# -gt 0 ]]; do
  case $1 in --help|-h) usage; exit 0;; esac
  [[ $# -ge 2 ]] || { usage >&2; exit 2; }
  case $1 in
    --calibration-protocol) cal=$2;; --holdout-protocol) held=$2;;
    --bindings) bindings=$2;; --facts-calibration) facts_c=$2;; --facts-holdout) facts_h=$2;;
    --output) output=$2;; --mode) mode=$2;; --python) python=$2;; --aie-env) envfile=$2;;
    *) echo "Unknown option: $1" >&2; exit 2;;
  esac
  shift 2
done
[[ $mode == validate-only || $mode == all ]] || { usage >&2; exit 2; }
[[ -f $cal && -f $held && -f $bindings && -f $facts_c && -f $facts_h && -n $output && ! -e $output ]] || { usage >&2; exit 2; }
if [[ $mode == all ]]; then source "$envfile"; fi
cd "$repo"
"$python" - "$root" "$cal" "$held" "$bindings" "$facts_c" "$facts_h" "$output" "$mode" "$entry" <<'PY'
import datetime,hashlib,json,pathlib,shutil,subprocess,sys,time
root=pathlib.Path(sys.argv[1]);cal,held,bindings,fc,fh=map(lambda x:pathlib.Path(x).resolve(),sys.argv[2:7]);out=pathlib.Path(sys.argv[7]).resolve();mode=sys.argv[8];entry=pathlib.Path(sys.argv[9]).resolve()
assert not out.exists();out.mkdir(parents=True)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def identity(p):return {'path':str(p),'sha256':sha(p)}
def save(p,x):p.write_text(json.dumps(x,indent=2,sort_keys=True)+'\n')
def run(name,argv):
    start=time.perf_counter();utc=datetime.datetime.now(datetime.timezone.utc).isoformat()
    with (out/(name+'.log')).open('w') as log:r=subprocess.run(list(map(str,argv)),stdout=log,stderr=subprocess.STDOUT)
    save(out/(name+'.command.json'),{'argv':list(map(str,argv)),'returncode':r.returncode,'start_UTC':utc,'end_UTC':datetime.datetime.now(datetime.timezone.utc).isoformat(),'elapsed_wall_seconds':time.perf_counter()-start})
    assert r.returncode==0,f'{name} failed; retained log/result'
runner=root/'scripts/taskflow_device_transfer_microbench_v15.py';analyzer=root/'test/TaskflowModels/analyze_device_transfer_v15.py';fitter=root/'test/TaskflowModels/fit_device_transfer_v15.py';validator=root/'test/TaskflowMapping/validate_device_transfer_cost_v15.py'
assert json.loads(cal.read_text())['split']=='calibration' and json.loads(held.read_text())['split']=='holdout'
binding=json.loads(bindings.read_text());architectures=set()
for protofile,indexfile in [(cal,fc),(held,fh)]:
    proto=json.loads(protofile.read_text());index=json.loads(indexfile.read_text());cases={c['id']:c for c in proto['cases']}
    assert index['schema']=='orbit.device-transfer.facts-index.v15' and set(index['cases'])==set(cases)
    for name,witness in index['cases'].items():
        path=pathlib.Path(witness['path']);assert sha(path)==witness['sha256']
        facts=json.loads(path.read_text());case=cases[name];artifact=json.loads(pathlib.Path(case['artifact']['path']).read_text())
        assert all(facts['binding'][k]==binding[k] for k in ['runtime_identity','toolchain_identity','path_identity','observer_identity','condition_identity'])
        assert facts['binding']['artifact_sha256']==artifact['elf_sha256']
        assert facts['elements']==case['fixture']['elements'] and facts['tile_elements']==case['fixture']['chunk']
        assert facts['descriptor_bytes']==8*facts['elements'] and facts['runtime_descriptor_count']==2
        assert facts['implementation']=='identity-copy-f32' and case['fixture']['adds']==0
        architectures.add(facts['architecture_identity'])
assert len(architectures)==1

for name,p in [('calibration-protocol',cal),('holdout-protocol',held),('bindings',bindings),('facts-calibration',fc),('facts-holdout',fh)]:shutil.copyfile(p,out/(name+'.json'))
for p in [entry,runner,analyzer,fitter,validator]:shutil.copyfile(p,out/p.name)
save(out/'invocation.json',{'mode':mode,'inputs':{name:identity(p) for name,p in [('calibration_protocol',cal),('holdout_protocol',held),('bindings',bindings),('facts_calibration',fc),('facts_holdout',fh)]},'sources':{p.name:identity(p) for p in [entry,runner,analyzer,fitter,validator]},'device_execution_requested':mode=='all','no_compilation':True})
for name in ['device_transfer_cpu_v15.py','device_transfer_analysis_cpu_v15.py','device_transfer_cost_cpu_v15.py']:
    run(name,[sys.executable,root/'test/TaskflowModels'/name,'--output',out/('cpu-'+name[:-3])])
if mode=='validate-only':
    run('validate-calibration',[sys.executable,runner,'--protocol',cal,'--output',out/'calibration-validation','--validate-only'])
    run('validate-holdout',[sys.executable,runner,'--protocol',held,'--output',out/'holdout-validation','--validate-only'])
    save(out/'result.json',{'status':'passed','mode':mode,'device_submissions':0,'model_fit_executed':False,'holdout_measurement_executed':False})
else:
    def capture(name):
        code='import json,sys;sys.path.insert(0,sys.argv[1]);from collect_sync_target_v14 import collect_snapshot;open(sys.argv[2],"w").write(json.dumps(collect_snapshot(),indent=2,sort_keys=True))'
        run(name,[sys.executable,'-c',code,str(root/'scripts'),str(out/(name+'.json'))])
    capture('calibration-runtime-before')
    run('calibration',['timeout','--signal=TERM','--kill-after=10s','120s',sys.executable,runner,'--protocol',cal,'--output',out/'calibration'])
    capture('calibration-runtime-after')
    run('calibration-audit',[sys.executable,analyzer,'--input',out/'calibration','--output',out/'calibration-audit'])
    run('fit',[sys.executable,fitter,'fit','--protocol',cal,'--calibration-root',out/'calibration','--audit',out/'calibration-audit/summary.json','--bindings',bindings,'--facts',fc,'--runtime-before',out/'calibration-runtime-before.json','--runtime-after',out/'calibration-runtime-after.json','--output',out/'model'])
    frozen={str(p.relative_to(out/'model')):sha(p) for p in (out/'model').rglob('*') if p.is_file()}
    save(out/'gate-before-holdout.json',{'UTC':datetime.datetime.now(datetime.timezone.utc).isoformat(),'model_file_sha256':sha(out/'model/model.json'),'all_model_files':frozen,'holdout_labels_read':False})
    capture('holdout-runtime-before')
    run('holdout',['timeout','--signal=TERM','--kill-after=10s','120s',sys.executable,runner,'--protocol',held,'--output',out/'holdout'])
    capture('holdout-runtime-after')
    assert all(sha(out/'model'/p)==digest for p,digest in frozen.items()),'frozen model evidence changed'
    run('validation',[sys.executable,validator,'--calibration-root',out/'calibration','--holdout-root',out/'holdout','--model-root',out/'model','--facts-calibration',fc,'--facts-holdout',fh,'--runtime-before',out/'holdout-runtime-before.json','--runtime-after',out/'holdout-runtime-after.json','--holdout-gate',out/'gate-before-holdout.json','--output',out/'validation'])
    save(out/'result.json',{'status':'passed','mode':mode,'calibration_outputs':json.loads((out/'calibration/summary.json').read_text())['samples'],'holdout_outputs':json.loads((out/'holdout/summary.json').read_text())['samples'],'frozen_model_unchanged':True,'model_fit_executed':True,'holdout_measurement_executed':True,'measurement_accuracy':json.loads((out/'validation/summary.json').read_text())['heldout_passed_cells'],'whole_program_cost':None,'physical_traffic':None})
PY
