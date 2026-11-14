#!/usr/bin/env python3
"""Freeze an actual ORBIT choice; validate pristine/selected/control policies."""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import statistics
import subprocess
import sys
import time

p = argparse.ArgumentParser(description=__doc__)
p.add_argument('--search', type=Path, required=True)
p.add_argument('--domain', type=Path, required=True)
p.add_argument('--output', type=Path, required=True)
p.add_argument('--worker-order', choices=['ABC', 'BCA', 'CAB'])
a = p.parse_args()
report = json.loads(a.search.read_text())
request = json.loads(a.domain.read_text())['request_base']
selected = report['selected']

def identity(path):
    path = Path(path)
    return dict(path=str(path), sha256=hashlib.sha256(path.read_bytes()).hexdigest())

def save(path, value):
    path.write_text(json.dumps(value, indent=2) + '\n')

if not a.worker_order:
    a.output.mkdir(parents=True, exist_ok=False)
    binding = dict(selected=selected, search=identity(a.search),
                   domain=identity(a.domain), validator=identity(__file__))
    save(a.output / 'frozen-selection.json', binding)
    records = []
    for index, order in enumerate(['ABC', 'BCA', 'CAB']):
        directory = a.output / f'process-{index}'
        cmd = [sys.executable, __file__, '--search', str(a.search),
               '--domain', str(a.domain), '--output', str(directory),
               '--worker-order', order]
        with (a.output / f'process-{index}.stdout.log').open('w') as out, \
             (a.output / f'process-{index}.stderr.log').open('w') as err:
            result = subprocess.run(['/usr/bin/time', '-v', '-o',
                str(a.output / f'process-{index}.resource.txt')] + cmd,
                stdout=out, stderr=err)
        if result.returncode:
            raise RuntimeError(f'process {index} failed: {result.returncode}')
        records.append(json.loads((directory / 'result.json').read_text()))
    medians = {mode: statistics.median(r['modes'][mode]['median_ms']
                                     for r in records) for mode in 'ABC'}
    ratios = [r['modes']['A']['median_ms'] / r['modes']['B']['median_ms']
              for r in records]
    control_ratios = [r['modes']['C']['median_ms'] / r['modes']['B']['median_ms']
                      for r in records]
    summary = dict(frozen_selection=binding, processes=records,
        policy_labels=dict(A='pristine original no-stage_key function',
            B='actual ORBIT selected invocation/kernel policy',
            C='controlled original persistent-chain policy'),
        all_bitexact=all(r['all_bitexact'] for r in records), median_ms=medians,
        ratio_of_medians=medians['A']/medians['B'], paired_ratios=ratios,
        controlled_ratio_of_medians=medians['C']/medians['B'],
        controlled_paired_ratios=control_ratios,
        protocol='3 fresh processes ABC/BCA/CAB; warm2/repeat9 per policy',
        scope='one real source L0 QKV; not whole-Qwen graph or TTFT')
    save(a.output / 'summary.json', summary)
    print(json.dumps({k:v for k,v in summary.items()
                      if k not in ['processes','frozen_selection']}), flush=True)
    raise SystemExit(0 if summary['all_bitexact'] else 3)

a.output.mkdir(parents=True, exist_ok=False)
spec = importlib.util.spec_from_file_location('validation_runtime', request['runtime_source'])
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)
if m.identity(request['runtime_source'])['sha256'] != request['runtime_sha256']:
    raise ValueError('runtime changed after search')
source = json.loads(Path(request['inputs']).read_text())
for path, expected in [(request['inputs'], request['inputs_manifest']),
                       (source['inputs']['path'], source['inputs']),
                       (request['reference']['path'], request['reference'])]:
    if m.identity(path) != expected:
        raise ValueError(f'input binding changed: {path}')
for binding in source['source_files']:
    if m.identity(binding['path']) != binding:
        raise ValueError('original source changed')
proof = report['selected_measurement'].get('physical_implementation')
if selected['mode'] == 'generated' and (not proof or m.identity(proof['path']) != proof):
    raise ValueError('selected physical implementation changed')
import numpy as np
import torch
from ml_dtypes import bfloat16
from filelock import FileLock
sys.path.insert(0, str(Path(request['triton_root'])/'examples/llm_q4nx'))
import kernels
start = time.perf_counter_ns()
raw = np.load(source['inputs']['path'], allow_pickle=False)
x = raw['x_bits'].view(bfloat16)
w = raw['w_bits'].view(bfloat16)
reference = np.load(request['reference']['path'], allow_pickle=False)['original-source-call']
xt = torch.from_numpy(raw['x_bits'].copy()).view(torch.bfloat16)
wt = torch.from_numpy(raw['w_bits'].copy()).view(torch.bfloat16)
common_prepare_ns = time.perf_counter_ns()-start
modes = {}
with FileLock('/tmp/npu.lock', timeout=600):
    for label in a.worker_order:
        mode = selected['mode'] if label == 'B' else (
            'original-source-call' if label == 'A' else 'original-persistent')
        runtime = None
        lease = None
        start = time.perf_counter_ns()
        if mode == 'generated':
            runtime = m.CompiledGemm(Path(proof['path']).parent,
                context_policy='persistent', max_host_bytes=request['capacity_bytes'],
                max_device_bytes=request['capacity_bytes'])
            lease = runtime.bind_weight(w, source['source_operator'])
        setup_ns = time.perf_counter_ns()-start
        samples = []
        try:
            for index in range(11):
                start = time.perf_counter_ns()
                if runtime:
                    output = runtime.run_bound(x, lease)
                else:
                    kwargs = {} if mode == 'original-source-call' else dict(stage_key=source['source_operator'])
                    output = kernels.triton_matmul(xt, wt, **kwargs).detach().to(torch.float32).numpy().copy()
                elapsed = time.perf_counter_ns()-start
                samples.append(dict(index=index, warmup=index<2, wall_ns=elapsed,
                    bitexact=bool(np.array_equal(output.view(np.uint32), reference.view(np.uint32))),
                    max_abs_error=float(np.max(np.abs(output-reference))),
                    event=runtime.events[-1] if runtime else None))
            times = [r['wall_ns']/1e6 for r in samples if not r['warmup']]
            modes[label] = dict(policy=mode, setup_ns=setup_ns,
                cold_first_call_ns=samples[0]['wall_ns'],
                prepare_plus_first_call_ns=setup_ns+samples[0]['wall_ns'],
                binding_events=runtime.binding_events if runtime else [], samples=samples,
                median_ms=statistics.median(times), range_ms=[min(times), max(times)])
        finally:
            if runtime:
                runtime.close()
            for chain in list(kernels._PROJ_CHAINS.values()):
                chain.close()
            kernels._PROJ_CHAINS.clear()
result = dict(order=a.worker_order, common_prepare_ns=common_prepare_ns,
              modes=modes, all_bitexact=all(s['bitexact'] for r in modes.values() for s in r['samples']))
save(a.output / 'result.json', result)
raise SystemExit(0 if result['all_bitexact'] else 3)
