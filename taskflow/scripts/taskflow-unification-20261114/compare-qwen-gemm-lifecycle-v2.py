#!/usr/bin/env python3
"""Compare one source-bound Qwen GEMM; no complete-inference speedup claim."""
import argparse
import ast
import hashlib
import importlib.util
import json
from pathlib import Path
import statistics
import sys
import time
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--triton-root',type=Path,required=True)
p.add_argument('--runtime-source',type=Path,required=True)
p.add_argument('--artifact',type=Path,required=True)
p.add_argument('--inputs',type=Path,required=True,help='capture inputs.json')
p.add_argument('--output',type=Path,required=True)
p.add_argument('--capacity-bytes',type=int,required=True)
p.add_argument('--warmups',type=int,default=1)
p.add_argument('--repeats',type=int,default=3)
a=p.parse_args()
if a.warmups<1 or a.repeats<3: raise ValueError('require warmup and at least 3 samples')
a.output.mkdir(parents=True,exist_ok=False)
spec=importlib.util.spec_from_file_location('new_gemm',a.runtime_source)
gemm=importlib.util.module_from_spec(spec);spec.loader.exec_module(gemm)
inputs=json.loads(a.inputs.read_text())
if gemm.identity(inputs['inputs']['path'])!=inputs['inputs']: raise ValueError('source inputs changed')
for row in inputs['source_files']:
 if gemm.identity(row['path'])!=row: raise ValueError('capture source changed')
record=json.loads((a.artifact/'implementation.json').read_text())
if record['shape']!=inputs['shape']: raise ValueError('compiled source shape differs')
# Old artifacts may come from the build copy with an unrelated RMSNorm patch.
# Require the compiled GEMM source function itself to match the original source.
original=a.triton_root/'examples/llm_q4nx/kernels.py'
def matmul_ast(path):
 tree=ast.parse(Path(path).read_text())
 fn=next(n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name=='_matmul_kernel')
 return hashlib.sha256(ast.dump(fn,include_attributes=False).encode()).hexdigest()
if matmul_ast(record['source']['path'])!=matmul_ast(original): raise ValueError('compiled GEMM source differs from original')
sys.path.insert(0,str(original.parent))
import numpy as np
import torch
from ml_dtypes import bfloat16
from filelock import FileLock
import kernels
raw=np.load(inputs['inputs']['path'],allow_pickle=False)
x=raw['x_bits'].view(bfloat16);w=raw['w_bits'].view(bfloat16)
xt=torch.from_numpy(raw['x_bits'].copy()).view(torch.bfloat16)
wt=torch.from_numpy(raw['w_bits'].copy()).view(torch.bfloat16)
reference=x.astype(np.float32)@w.astype(np.float32)
rows=[]
original_output=None
captured_outputs={}
def phase_probe(callback):
 # Separate diagnostic dispatch: tracing overhead is excluded from the timing
 # samples. Trace Python boundaries around unchanged native calls.
 import inspect
 from triton.backends.amd_triton_npu.multilaunch import MultiLaunchRunner
 code=MultiLaunchRunner.run.__code__
 lines,start=inspect.getsourcelines(MultiLaunchRunner.run)
 boundaries={name:start+next(i for i,line in enumerate(lines) if text in line)
  for name,text in [('stage','first_call ='),('submit','run = xrt.run('),
                    ('wait','_wait(run)'),('readback','results = {}')]}
 phases={}; state={'phase':'allocation_and_input_staging','time':0}
 def trace(frame,event,arg):
  if frame.f_code is not code: return None
  now=time.perf_counter_ns()
  if state['time']:
   phases[state['phase']]=phases.get(state['phase'],0)+now-state['time']
  state['time']=now
  if event=='line':
   line=frame.f_lineno
   state['phase']=('output_readback_and_host_view' if line>=boundaries['readback'] else
       'device_wait' if line>=boundaries['wait'] else
       'run_create_bind_and_submit' if line>=boundaries['submit'] else
       'allocation_and_input_staging')
  return trace
 old=sys.gettrace()
 try:
  sys.settrace(trace)
  callback()
 finally: sys.settrace(old)
 return dict(phases_ns=phases,timing_sample=False,
   method='Python line-boundary tracing around unchanged MultiLaunchRunner.run',
   unsupported=None if phases else 'original non-chain launch has no MultiLaunchRunner boundary')
with FileLock('/tmp/npu.lock',timeout=600):
 for mode in ('original-source-call','original-persistent-policy','release-after-call','persistent'):
  runtime=None
  setup_start=time.perf_counter_ns()
  if mode in ('release-after-call','persistent'):
   runtime=gemm.CompiledGemm(a.artifact,context_policy=mode,
       max_host_bytes=a.capacity_bytes,max_device_bytes=a.capacity_bytes)
   if mode=='persistent': lease=runtime.bind_weight(w,inputs['source_operator'])
  setup_ns=time.perf_counter_ns()-setup_start
  samples=[]
  try:
   for index in range(a.warmups+a.repeats):
    start=time.perf_counter_ns()
    if mode.startswith('original'):
     kw={} if mode=='original-source-call' else dict(stage_key=inputs['source_operator'])
     output=kernels.triton_matmul(xt,wt,**kw).detach().to(torch.float32).numpy().copy()
    elif mode=='persistent': output=runtime.run_bound(x,lease)
    else: output=runtime.run(x,w,inputs['source_operator'])
    elapsed=time.perf_counter_ns()-start
    if original_output is None:
     if mode!='original-source-call': raise RuntimeError('original source baseline must run first')
     original_output=output.copy()
    original_check=dict(bitexact=bool(np.array_equal(output.view(np.uint32),original_output.view(np.uint32))),
        max_abs_error=float(np.max(np.abs(output-original_output))))
    captured_outputs[mode]=output.copy()
    check=dict(allclose=bool(np.allclose(output,reference,rtol=5e-3,atol=1e-2)),
        max_abs_error=float(np.max(np.abs(output-reference))),
        relative_l2=float(np.linalg.norm(output-reference)/max(np.linalg.norm(reference),1e-30)))
    row=dict(index=index,warmup=index<a.warmups,wall_ns=elapsed,numerical=check,vs_original_npu=original_check,
        runtime_event=runtime.events[-1] if runtime else None)
    samples.append(row)
    print(json.dumps(dict(mode=mode,**row)),flush=True)
   if mode.startswith('original'):
    def probe():
     return kernels.triton_matmul(xt,wt,**({} if mode=='original-source-call' else dict(stage_key=inputs['source_operator'])))
   elif mode=='persistent':
    def probe(): return runtime.run_bound(x,lease)
   else:
    def probe(): return runtime.run(x,w,inputs['source_operator'])
   diagnostic=phase_probe(probe)
   rows.append(dict(mode=mode,setup_ns=setup_ns,samples=samples,phase_probe=diagnostic,
       median_wall_ns=statistics.median(v['wall_ns'] for v in samples if not v['warmup']),
       cold_first_call_ns=samples[0]['wall_ns'],prepare_plus_first_call_ns=setup_ns+samples[0]['wall_ns'],
       binding_events=runtime.binding_events if runtime else []))
  finally:
   if runtime: runtime.close()
   for chain in list(kernels._PROJ_CHAINS.values()): chain.close()
   kernels._PROJ_CHAINS.clear()
result=dict(schema='orbit.qwen-gemm-lifecycle-comparison.v1',rows=rows,
 source_inputs=gemm.identity(a.inputs),runtime=gemm.identity(a.runtime_source),
 implementation=gemm.identity(a.artifact/'implementation.json'),original_kernel=gemm.identity(original),
 original_gemm_ast_sha256=matmul_ast(original),capacity_bytes=a.capacity_bytes,
 scope='one actual Qwen L0 QKV operator; no whole-Qwen timing/admission claim',
 numerical_contract='BF16 inputs and original FP32 reduction; diagnostic allclose rtol=.005 atol=.01, does not replace full-graph numerical gates',
 sram_residency_claim=False)
np.savez(a.output/'outputs.npz',reference_cpu=reference,**captured_outputs)
result['outputs']=gemm.identity(a.output/'outputs.npz')
result['matches_original_npu']=all(sample['vs_original_npu']['bitexact'] for row in rows for sample in row['samples'])
(a.output/'result.json').write_text(json.dumps(result,indent=2)+'\n')
