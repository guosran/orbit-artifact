#!/usr/bin/env python3
"""Compile/check/measure one ORBIT-proposed tuple. This never selects tuples."""
import argparse,hashlib,importlib.util,json,os,signal,statistics,subprocess,sys,time
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--request',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--worker',action='store_true');a=p.parse_args()
request=json.loads(a.request.read_text());choice=request['candidate'];a.output.mkdir(parents=True,exist_ok=True)
def load_runtime():
 s=importlib.util.spec_from_file_location('candidate_runtime',request['runtime_source']);m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
 if m.identity(request['runtime_source'])['sha256']!=request['runtime_sha256']:raise ValueError('runtime source changed')
 if m.identity(__file__)['sha256']!=request['evaluator_sha256']:raise ValueError('evaluator source changed')
 return m
def save(name,value): (a.output/name).write_text(json.dumps(value,indent=2)+'\n')
def process(cmd,name,timeout):
 start=time.monotonic()
 with (a.output/(name+'.stdout.log')).open('w') as out,(a.output/(name+'.stderr.log')).open('w') as err:
  child=subprocess.Popen(['/usr/bin/time','-v','-o',str(a.output/(name+'.resource.txt'))]+cmd,stdout=out,stderr=err,start_new_session=True)
  try: code=child.wait(timeout=timeout);timed=False
  except subprocess.TimeoutExpired:
   timed=True;os.killpg(child.pid,signal.SIGTERM)
   try:code=child.wait(timeout=10)
   except subprocess.TimeoutExpired:os.killpg(child.pid,signal.SIGKILL);code=child.wait()
 return dict(command=cmd,returncode=code,timed_out=timed,seconds=time.monotonic()-start)
if a.worker:
 import numpy as np
 import torch
 from ml_dtypes import bfloat16
 from filelock import FileLock
 m=load_runtime();source=json.loads(Path(request['inputs']).read_text())
 if m.identity(request['inputs'])!=request['inputs_manifest'] or m.identity(source['inputs']['path'])!=source['inputs']:raise ValueError('captured source inputs changed')
 if m.identity(request['reference']['path'])!=request['reference']:raise ValueError('original NPU reference changed')
 for binding in source['source_files']:
  if m.identity(binding['path'])!=binding:raise ValueError('source binding changed')
 data=np.load(source['inputs']['path'],allow_pickle=False);x=data['x_bits'].view(bfloat16);w=data['w_bits'].view(bfloat16)
 reference=np.load(request['reference']['path'],allow_pickle=False)['original-source-call']
 xt=torch.from_numpy(data['x_bits'].copy()).view(torch.bfloat16);wt=torch.from_numpy(data['w_bits'].copy()).view(torch.bfloat16)
 sys.path.insert(0,str(Path(request['triton_root'])/'examples/llm_q4nx'));import kernels
 rows=[]
 with FileLock('/tmp/npu.lock',timeout=60):
  for mode in (['original-persistent'] if choice['mode']=='original-persistent' else ['original-persistent','generated-persistent']):
   runtime=None;lease=None;setup_start=time.perf_counter_ns()
   if mode=='generated-persistent':
    runtime=m.CompiledGemm(a.output/'compiled',context_policy='persistent',max_host_bytes=request['capacity_bytes'],max_device_bytes=request['capacity_bytes'])
    lease=runtime.bind_weight(w,source['source_operator'])
   setup_ns=time.perf_counter_ns()-setup_start;samples=[]
   try:
    for i in range(request.get('warmups',2)+request.get('repeats',9)):
     start=time.perf_counter_ns()
     if runtime: actual=runtime.run_bound(x,lease)
     else:actual=kernels.triton_matmul(xt,wt,stage_key=source['source_operator']).detach().to(torch.float32).numpy().copy()
     ns=time.perf_counter_ns()-start
     samples.append(dict(warmup=i<request.get('warmups',2),wall_ns=ns,bitexact=bool(np.array_equal(actual.view(np.uint32),reference.view(np.uint32))),max_abs_error=float(np.max(np.abs(actual-reference))),event=runtime.events[-1] if runtime else None))
   finally:
    if runtime:runtime.close()
    for chain in list(kernels._PROJ_CHAINS.values()):chain.close()
    kernels._PROJ_CHAINS.clear()
   rows.append(dict(mode=mode,setup_ns=setup_ns,samples=samples,median_ms=statistics.median(r['wall_ns'] for r in samples if not r['warmup'])/1e6))
 passed=all(sample['bitexact'] for row in rows for sample in row['samples'])
 save('measurement.json',dict(rows=rows,passed=passed,criterion='bitexact vs source-bound original NPU output',scope='one actual L0 QKV, not full Qwen'))
 raise SystemExit(0 if passed else 3)
result=dict(candidate=choice,feasible=False,feasibility_known=False,cost_ms=None,message='not evaluated',compile=None,measurement=None)
try:
 m=load_runtime()
 if choice['mode']=='generated':
  params=choice['parameters'];target=m.source_target_contract(Path(request['triton_root']))
  if params not in m.gemm_parameter_domain(params['m'],params['n'],params['k'],target):raise ValueError('tuple outside source-target domain')
  cmd=[sys.executable,request['runtime_source'],'--triton-root',request['triton_root'],'--output',str(a.output/'compiled'),'--compile']
  for key,value in params.items():cmd+=['--'+key.replace('_','-'),str(value)]
  result['compile']=process(cmd,'compile',request['compile_timeout_seconds'])
  if result['compile']['returncode']!=0 or result['compile']['timed_out']:
   result['message']='compile timeout/failure: unsupported or unknown, not semantic infeasibility';save('result.json',result);raise SystemExit(0)
  result['physical_implementation']=m.identity(a.output/'compiled/implementation.json')
 worker=[sys.executable,__file__,'--request',str(a.request),'--output',str(a.output),'--worker']
 result['measurement']=process(worker,'measure',request['measurement_timeout_seconds'])
 measured=a.output/'measurement.json'
 if measured.exists():
  proof=json.loads(measured.read_text());result['numerical']=proof
  if proof['passed']:
   result.update(feasible=True,feasibility_known=True,cost_ms=proof['rows'][-1]['median_ms'],message='compiled/physical checked and bitexact with original NPU for captured real input')
  else:result.update(feasibility_known=True,message='numerical mismatch with original NPU; rejected for this input')
 else:result['message']='measurement timeout/failure; cost and feasibility unknown'
except Exception as error:result['message']=str(error)
save('result.json',result)
print(json.dumps(dict(candidate=choice['id'],feasible=result['feasible'],cost_ms=result['cost_ms'],message=result['message'])),flush=True)
