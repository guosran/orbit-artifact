#!/usr/bin/env python3
"""Fresh-process paired validation of the already frozen ORBIT winner."""
import argparse,hashlib,importlib.util,json,statistics,subprocess,sys,time
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--search',type=Path,required=True);p.add_argument('--domain',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--worker-order',choices=['AB','BA']);a=p.parse_args()
report=json.loads(a.search.read_text());request=json.loads(a.domain.read_text())['request_base'];selected=report['selected']
if not a.worker_order:
 a.output.mkdir(parents=True,exist_ok=False)
 identity=lambda path:dict(path=str(path),sha256=hashlib.sha256(path.read_bytes()).hexdigest())
 binding=dict(selected=selected,search=identity(a.search),domain=identity(a.domain),validator=identity(Path(__file__)))
 (a.output/'frozen-selection.json').write_text(json.dumps(binding,indent=2)+'\n')
 if selected['mode']=='original-persistent':
  (a.output/'summary.json').write_text(json.dumps(dict(selected=selected,baseline_selected=True,ratio=1.0,message='ORBIT retained baseline; no forced optimization win'),indent=2)+'\n');raise SystemExit(0)
 records=[]
 for index,order in enumerate(['AB','BA','AB']):
  directory=a.output/f'process-{index}';cmd=[sys.executable,__file__,'--search',str(a.search),'--domain',str(a.domain),'--output',str(directory),'--worker-order',order]
  with (a.output/f'process-{index}.stdout.log').open('w') as out,(a.output/f'process-{index}.stderr.log').open('w') as err:
   process=subprocess.run(['/usr/bin/time','-v','-o',str(a.output/f'process-{index}.resource.txt')]+cmd,stdout=out,stderr=err)
  if process.returncode:raise RuntimeError(f'heldout process {index} failed: {process.returncode}')
  records.append(json.loads((directory/'result.json').read_text()))
 a_ms=[r['modes']['A']['median_ms'] for r in records];b_ms=[r['modes']['B']['median_ms'] for r in records]
 ratios=[x/y for x,y in zip(a_ms,b_ms)]
 summary=dict(frozen_selection=binding,processes=records,all_bitexact=all(r['all_bitexact'] for r in records),
   original_median_ms=statistics.median(a_ms),selected_median_ms=statistics.median(b_ms),
   ratio_of_medians=statistics.median(a_ms)/statistics.median(b_ms),paired_ratios=ratios,
   median_paired_ratio=statistics.median(ratios),paired_ratio_range=[min(ratios),max(ratios)],
   scope='real Qwen L0 QKV only; no full-model speedup/admission claim',
   protocol='3 fresh processes AB/BA/AB, warm2/repeat9, exact original NPU output check')
 (a.output/'summary.json').write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps({k:v for k,v in summary.items() if k not in ['processes','frozen_selection']}),flush=True)
 raise SystemExit(0 if summary['all_bitexact'] else 3)
a.output.mkdir(parents=True,exist_ok=False)
s=importlib.util.spec_from_file_location('heldout_runtime',request['runtime_source']);m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
if m.identity(request['runtime_source'])['sha256']!=request['runtime_sha256']:raise ValueError('runtime source changed after search')
source=json.loads(Path(request['inputs']).read_text())
if m.identity(request['inputs'])!=request['inputs_manifest'] or m.identity(source['inputs']['path'])!=source['inputs']:raise ValueError('source input changed')
if m.identity(request['reference']['path'])!=request['reference']:raise ValueError('original NPU reference changed')
proof=report['selected_measurement']['physical_implementation']
if m.identity(proof['path'])!=proof:raise ValueError('selected implementation changed')
import numpy as np
import torch
from ml_dtypes import bfloat16
from filelock import FileLock
sys.path.insert(0,str(Path(request['triton_root'])/'examples/llm_q4nx'));import kernels
start=time.perf_counter_ns();raw=np.load(source['inputs']['path'],allow_pickle=False);x=raw['x_bits'].view(bfloat16);w=raw['w_bits'].view(bfloat16)
reference=np.load(request['reference']['path'],allow_pickle=False)['original-source-call']
xt=torch.from_numpy(raw['x_bits'].copy()).view(torch.bfloat16);wt=torch.from_numpy(raw['w_bits'].copy()).view(torch.bfloat16);common_prepare_ns=time.perf_counter_ns()-start
modes={}
with FileLock('/tmp/npu.lock',timeout=60):
 for mode in a.worker_order:
  runtime=None;lease=None;start=time.perf_counter_ns()
  if mode=='B':
   runtime=m.CompiledGemm(Path(proof['path']).parent,context_policy='persistent',max_host_bytes=request['capacity_bytes'],max_device_bytes=request['capacity_bytes']);lease=runtime.bind_weight(w,source['source_operator'])
  prepare_ns=time.perf_counter_ns()-start;samples=[]
  try:
   for index in range(11):
    start=time.perf_counter_ns()
    if mode=='A':output=kernels.triton_matmul(xt,wt,stage_key=source['source_operator']).detach().to(torch.float32).numpy().copy()
    else:output=runtime.run_bound(x,lease)
    ns=time.perf_counter_ns()-start
    samples.append(dict(index=index,warmup=index<2,wall_ns=ns,bitexact=bool(np.array_equal(output,reference)),max_abs_error=float(np.max(np.abs(output-reference))),event=runtime.events[-1] if runtime else None))
   values=[r['wall_ns']/1e6 for r in samples if not r['warmup']]
   modes[mode]=dict(prepare_ns=prepare_ns,cold_first_call_ns=samples[0]['wall_ns'],prepare_plus_first_call_ns=prepare_ns+samples[0]['wall_ns'],binding_events=runtime.binding_events if runtime else [],samples=samples,median_ms=statistics.median(values),range_ms=[min(values),max(values)])
  finally:
   if runtime:runtime.close()
   for chain in list(kernels._PROJ_CHAINS.values()):chain.close()
   kernels._PROJ_CHAINS.clear()
result=dict(order=a.worker_order,common_prepare_ns=common_prepare_ns,modes=modes,all_bitexact=all(v['bitexact'] for row in modes.values() for v in row['samples']))
(a.output/'result.json').write_text(json.dumps(result,indent=2)+'\n')
raise SystemExit(0 if result['all_bitexact'] else 3)
