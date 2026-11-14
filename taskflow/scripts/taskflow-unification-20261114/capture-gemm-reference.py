#!/usr/bin/env python3
"""Capture unchanged original NPU GEMM output for real source-bound operands."""
import argparse,hashlib,importlib.util,json,statistics,sys,time
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--inputs',type=Path,required=True);p.add_argument('--triton-root',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
import numpy as np
import torch
from ml_dtypes import bfloat16
from filelock import FileLock
source=json.loads(a.inputs.read_text())
def identity(path):
 path=Path(path);return dict(path=str(path),sha256=hashlib.sha256(path.read_bytes()).hexdigest())
if identity(source['inputs']['path'])!=source['inputs']:raise ValueError('captured input changed')
for row in source['source_files']:
 if identity(row['path'])!=row:raise ValueError('original source changed')
sys.path.insert(0,str(a.triton_root/'examples/llm_q4nx'));import kernels
raw=np.load(source['inputs']['path'],allow_pickle=False);xt=torch.from_numpy(raw['x_bits'].copy()).view(torch.bfloat16);wt=torch.from_numpy(raw['w_bits'].copy()).view(torch.bfloat16);samples=[]
with FileLock('/tmp/npu.lock',timeout=60):
 reference=kernels.triton_matmul(xt,wt).detach().to(torch.float32).numpy().copy()
 try:
  for i in range(5):
   start=time.perf_counter_ns();got=kernels.triton_matmul(xt,wt,stage_key=source['source_operator']).detach().to(torch.float32).numpy().copy();ns=time.perf_counter_ns()-start
   samples.append(dict(warmup=i<2,wall_ns=ns,bitexact=bool(np.array_equal(got.view(np.uint32),reference.view(np.uint32)))))
 finally:
  for chain in list(kernels._PROJ_CHAINS.values()):chain.close()
  kernels._PROJ_CHAINS.clear()
np.savez(a.output/'outputs.npz',**{'original-source-call':reference})
record=dict(inputs=identity(a.inputs),outputs=identity(a.output/'outputs.npz'),samples=samples,original_persistent_median_ms=statistics.median(v['wall_ns'] for v in samples if not v['warmup'])/1e6,all_bitexact=all(v['bitexact'] for v in samples),source_shape=source['shape'],scope='original reference of one actual Qwen L0 QKV source operator')
(a.output/'result.json').write_text(json.dumps(record,indent=2)+'\n');print(json.dumps(record),flush=True)
raise SystemExit(0 if record['all_bitexact'] else 3)
