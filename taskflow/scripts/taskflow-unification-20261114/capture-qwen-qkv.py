#!/usr/bin/env python3
"""Capture the real L0 QKV input at a CPU-norm placement; never opens NPU."""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import sys
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--triton-root',type=Path,required=True)
p.add_argument('--model',type=Path,required=True)
p.add_argument('--output',type=Path,required=True)
p.add_argument('--prompt',default='785,6722,315,9625,374')
a=p.parse_args()
a.output.mkdir(parents=True,exist_ok=False)
root=a.triton_root.resolve(strict=True)
sys.path.insert(0,str(root/'examples/qwen25_3b_q4nx'))
import config
sys.path.insert(0,config._SHARED)
import numpy as np
import torch
from ml_dtypes import bfloat16
from qwen25_prefill import Qwen25Prefill
import llama_prefill
config._add_air_paths()
import qwen25_3b_q4_weights as weights
source=weights.open_weight_source(str(a.model.absolute()))
prompt=[int(v) for v in a.prompt.split(',')]
# Match original prefill's BF16 embedding storage, then float32 gather and RMS.
embedding=source.bf16('model.embed_tokens.weight')[prompt].astype(bfloat16)
x=torch.from_numpy(embedding.view(np.uint16)).view(torch.bfloat16).to(torch.float32)
normal=source.layer_rms(0)[0]
model=Qwen25Prefill(backend='cpu',n_layers=1,max_seq=len(prompt))
h=model._rms_norm(x,torch.from_numpy(normal),config.RMS_EPS)
x_bits=h.to(torch.bfloat16).contiguous().view(torch.uint16).numpy().copy()
parts=[torch.from_numpy(np.ascontiguousarray(weights.host_weights.transpose_bf16(
    source.proj_fp(0,key))).view(np.uint16)).view(torch.bfloat16) for key in ('q','k','v')]
w_bits=torch.cat(parts,dim=1).contiguous().view(torch.uint16).numpy().copy()
np.savez(a.output/'inputs.npz',x_bits=x_bits,w_bits=w_bits)
def identity(path):
 path=Path(path).resolve(strict=True)
 return dict(path=str(path),sha256=hashlib.sha256(path.read_bytes()).hexdigest())
record=dict(schema='orbit.qwen-source-gemm-input.v1',source_operator='prefill.L0.qkv',
 prompt=prompt,source_prefix='original BF16 embedding gather and original CPU RMSNorm; stop before QKV GEMM/bias',
 shape=dict(M=x_bits.shape[0],K=x_bits.shape[1],N=w_bits.shape[1]),
 inputs=identity(a.output/'inputs.npz'),capture=identity(__file__),
 source_files=[identity(root/'examples/llm_q4nx'/name) for name in ('llama_prefill.py','qwen25_prefill.py','kernels.py')],
 weight_reader=identity(weights.__file__),model=dict(path=str(a.model.resolve()),bytes=a.model.stat().st_size),
 device_opened=False,scope='one actual Qwen source operator; not complete inference')
(a.output/'inputs.json').write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps(record),flush=True)
