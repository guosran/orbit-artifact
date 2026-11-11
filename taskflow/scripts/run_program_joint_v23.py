#!/usr/bin/env python3
"""Source-bound joint solver, final AIE checks and opt-in serialized NPU trials."""
import argparse,hashlib,json,shutil,subprocess,sys,time
from pathlib import Path

def save(path,value):path.write_text(json.dumps(value,indent=2)+'\n')
def numeric(case,session):
 import numpy as np
 from taskflow_direct_air_execute import run_artifact
 abi=json.loads((case/'search/abi.json').read_text());artifact=json.loads((case/'hardware/compile.json').read_text());fixture=json.loads((case/'fixture.json').read_text());out=case/f'run-{session}';out.mkdir(exist_ok=False);rng=np.random.default_rng(20261111+session)
 inputs={name:rng.uniform(-1,1,fixture['shape']).astype(np.float32) for name in fixture['inputs']}
 def evaluate(dtype):
  values={name:x.astype(dtype) for name,x in inputs.items()}
  for name,kind,args,constant in fixture['steps']:
   rhs=values[args[1]] if len(args)>1 else dtype(constant)
   values[name]=(values[args[0]]+rhs if kind=='add' else values[args[0]]*rhs).astype(dtype)
  return {name:values[name] for name in fixture['outputs']}
 fp32=evaluate(np.float32);fp64=evaluate(np.float64);np.savez(out/'inputs.npz',**inputs);np.savez(out/'reference-fp32.npz',**fp32);np.savez(out/'reference-fp64.npz',**fp64)
 r=run_artifact(artifact,abi,inputs,fp32,out,iterations=6,atol=1e-5,rtol=1e-5,warmups=2);maximum=0
 for path in out.glob('outputs-*.npz'):
  values=np.load(path)
  for name in fp64:
   maximum=max(maximum,float(np.max(np.abs(values[name].astype(np.float64)-fp64[name]))));assert np.isfinite(values[name]).all() and np.allclose(values[name],fp64[name],atol=1e-5,rtol=1e-5)
 r['fp64_max_abs']=maximum;save(out/'result.json',r);assert r['status']=='passed';print(json.dumps(dict(status=r['status'],calls=len(r['samples']),median_ms=r['median_ms'],fp64_max_abs=maximum)))

def main():
 p=argparse.ArgumentParser();p.add_argument('--compiler',type=Path);p.add_argument('--output',type=Path);p.add_argument('--inputs',type=Path,default=Path(__file__).resolve().parents[1]/'evidence/program-joint-v23/inputs');p.add_argument('--execute',action='store_true');p.add_argument('--run-case',type=Path);p.add_argument('--session',type=int,default=1);a=p.parse_args()
 if a.run_case:numeric(a.run_case,a.session);return
 if not a.compiler or not a.output:p.error('--compiler and --output required')
 from taskflow_direct_air_execute import compile_air
 a.output.mkdir(parents=True,exist_ok=False);records=[];save(a.output/'provenance.json',dict(compiler=str(a.compiler),compiler_sha256=hashlib.sha256(a.compiler.read_bytes()).hexdigest(),script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),atol=1e-5,rtol=1e-5,hardware_execute=a.execute))
 for fixture in sorted(a.inputs.iterdir()):
  if not fixture.is_dir():continue
  case=a.output/fixture.name;case.mkdir();[shutil.copy2(fixture/name,case/name) for name in ['source.mlir','target.json','fixture.json']];cmd=[str(a.compiler),str(case/'source.mlir'),'--target-config='+str(case/'target.json'),'--joint-program-search='+str(case/'search'),'--joint-lower-air'];save(case/'lower-command.json',cmd);started=time.perf_counter();r=subprocess.run(cmd,capture_output=True,text=True,timeout=30);(case/'lower.log').write_text(r.stdout+r.stderr);assert r.returncode==0,r.stderr
  solution=json.loads((case/'search/solution.json').read_text());domain=json.loads((case/'search/domain.json').read_text());record=dict(name=fixture.name,lower_ms=(time.perf_counter()-started)*1000,solver_status=solution['status'],model_makespan_ns=solution['makespan_ns'],solve_ms=solution['solve_ms'],selected_chunk=domain['variants'][solution['variant']]['chunk'],groups=len(solution['groups']),configurations=len(solution['configuration_start_ns']));assert solution['status']=='OPTIMAL',solution['message']
  compile_air(case/'search/program.air.mlir',case/'hardware',stack_size=8192,omit_ping_pong=True)
  subprocess.run(['air-opt',str(case/'hardware/air_project/npu.input.air.mlir'),'--mlir-print-op-generic','-o',str(case/'final-aie.generic.mlir')],check=True,timeout=30)
  cmd=[str(a.compiler),str(case/'source.mlir'),'--target-config='+str(case/'target.json'),'--joint-program-plan='+str(case/'search/solution.json'),'--check-joint-aie='+str(case/'final-aie.generic.mlir'),'--implementation-output='+str(case/'aie-check.json')];save(case/'check-command.json',cmd);r=subprocess.run(cmd,capture_output=True,text=True,timeout=30);(case/'check.log').write_text(r.stdout+r.stderr);assert r.returncode==0,r.stderr;record['final_aie_valid']=json.loads((case/'aie-check.json').read_text())['valid'];records.append(record);save(a.output/'summary.json',records);print(json.dumps(record),flush=True)
 if a.execute:
  for session in [1,2]:
   for record in records:
    case=a.output/record['name'];cmd=['timeout','60','flock','-w','10','/tmp/npu.lock',sys.executable,str(Path(__file__).resolve()),'--run-case',str(case),'--session',str(session)];save(case/f'run-{session}-command.json',cmd);r=subprocess.run(cmd,capture_output=True,text=True);(case/f'run-{session}.log').write_text(r.stdout+r.stderr);assert r.returncode==0,(case,r.stderr);print(record['name'],session,r.stdout.strip(),flush=True)
  for record in records:record['runs']=[json.loads((a.output/record['name']/f'run-{s}/result.json').read_text()) for s in [1,2]]
  save(a.output/'summary.json',records)
if __name__=='__main__':main()
