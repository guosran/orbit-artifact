#!/usr/bin/env python3
"""Bounded direct-AIR packet-trace experiment using the installed XRT runner.

This is an instrumented derivative of compiler AIR, never a production plan.
The output BO is extended equally for on/off controls. No clock conversion or
full-program coverage is inferred from packet activity.
"""
import argparse
import fcntl
import hashlib
import json
import os
import re
from pathlib import Path
import shutil
import subprocess
import time


def save(p, x):
    p.write_text(json.dumps(x, indent=2)+'\n')


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def main():
    p=argparse.ArgumentParser(description=__doc__)
    for name in ['air','abi','inputs','reference','output']:
        p.add_argument('--'+name,type=Path,required=True)
    p.add_argument('--trace-bytes',type=int,default=1048576)
    p.add_argument('--iterations',type=int,default=5)
    p.add_argument('--mark-core-window',action='store_true',help='diagnostic derivative: bracket the single herd with EVENT0/1 in both controls')
    a=p.parse_args()
    if a.trace_bytes<=0 or a.trace_bytes%4 or a.iterations<1:
        p.error('positive word-aligned trace buffer and iterations required')
    out=a.output.resolve();out.mkdir(parents=True,exist_ok=False)
    import numpy as np
    from taskflow_ffn_profile import metrics
    from taskflow_npu_trace_v3 import decode
    from triton.backends.amd_triton_npu.multilaunch import MultiLaunchRunner
    abi=json.loads(a.abi.read_text());last=len(abi['buffers'])-1
    if abi['outputs'] != [abi['buffers'][last]['name']] or any(b['dtype']!='f32' for b in abi['buffers']):
        raise ValueError('trace experiment requires one last-argument FP32 output')
    inp=dict(np.load(a.inputs));ref=dict(np.load(a.reference));arrays=[]
    for b in abi['buffers']:
        x=inp.get(b['name'],np.zeros(b['shape'],dtype=np.float32))
        if x.dtype!=np.float32 or list(x.shape)!=b['shape']:raise ValueError('ABI mismatch')
        arrays.append(np.ascontiguousarray(x))
    count=arrays[last].size;logical_shape=arrays[last].shape
    arrays[last]=np.zeros(count+a.trace_bytes//4,dtype=np.float32)
    save(out/'identity.json',dict(inputs={str(x.resolve()):sha(x) for x in [a.air,a.abi,a.inputs,a.reference,Path(__file__)]},
        scope='one instrumented derivative; compute core events and packet routing only; neither DDR byte counter nor full FFN timeline',
        output_logical_shape=logical_shape,trace_offset=count*4,trace_bytes=a.trace_bytes,
        output_padding_both_controls_bytes=a.trace_bytes,markers='none; completion of kernel output is not proof of complete trace'))
    text=a.air.read_text()
    if a.mark_core_window:
        if text.count('"air.herd"(')!=1 or text.count('"air.herd_terminator"()')!=1:
            raise ValueError('marked trace needs exactly one herd')
        text,n=re.subn(r'("air.herd"[^\n]*\n[^\n]*\n)',r'\1          aie.event(0)\n',text,count=1)
        if n!=1:raise ValueError('cannot locate single herd entry')
        text=text.replace('          "air.herd_terminator"()', '          aie.event(1)\n          "air.herd_terminator"()')
    (out/'diagnostic.air.mlir').write_text(text)
    save(out/'instrumentation.json',dict(marked=a.mark_core_window,source_sha256=sha(a.air),diagnostic_sha256=sha(out/'diagnostic.air.mlir'),
        scope='same optional core-entry/exit marker instructions in both controls; diagnostic only, no production Taskflow/plan mutation'))
    compiled={}
    for mode,size in [('off',0),('on',a.trace_bytes)]:
        d=out/mode;d.mkdir();shutil.copy2(out/'diagnostic.air.mlir',d/'input.air.mlir')
        cmd=[shutil.which('aircc') or 'aircc','--device=npu2','--no-xchesscc','--no-xbridge','--output-format=elf',
            '--elf-name='+str(d/'program.elf'),'--peano='+os.environ['PEANO_INSTALL_DIR'],
            '--stack-size=4096','--omit-ping-pong-transform=all']
        if size:cmd+=['--trace-size='+str(size),'--trace-offset='+str(count*4)]
        cmd.append(str(d/'input.air.mlir'));save(d/'command.json',cmd)
        begin=time.perf_counter();r=subprocess.run(cmd,cwd=d,stdout=(d/'compile.log').open('w'),stderr=subprocess.STDOUT)
        save(d/'compile.json',dict(returncode=r.returncode,seconds=time.perf_counter()-begin))
        if r.returncode:return 1
        config=json.loads((d/'air_project/full_elf_config.json').read_text())
        k=next(x for x in config['xrt-kernels'] if x['name']=='main')
        compiled[mode]=dict(elf=str(d/'program.elf'),kernel='main:'+str(k['instance'][0]['id']),elf_sha256=sha(d/'program.elf'))
    save(out/'compiled-identities.json',compiled)
    samples=[];runners={}
    with open('/tmp/npu.lock','w') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX)
        try:
            for mode,x in compiled.items():runners[mode]=MultiLaunchRunner(x['elf'],x['kernel'])
            for repeat in range(a.iterations+2):
                for mode in (['off','on'] if repeat%2==0 else ['on','off']):
                    arrays[last].fill(0)
                    begin=time.perf_counter_ns()
                    values=runners[mode].run(arrays,bo_key='trace',output_indices={last})[last]
                    wall=(time.perf_counter_ns()-begin)/1e6
                    actual=values[:count].reshape(logical_shape).copy()
                    check=metrics(actual,ref[abi['outputs'][0]])
                    samples.append(dict(mode=mode,repeat=repeat,warmup=repeat<2,wall_ms=wall,check=check))
                    np.save(out/f'{mode}-output-{repeat}.npy',actual)
                    if mode=='on' and repeat==a.iterations+1:
                        raw=values[count:].view(np.uint32).copy()
                        physical=out/mode/'air_project/npu.input.air.mlir'
                        if not physical.exists():physical=out/mode/'air_project/aie.mlir'
                        if not physical.exists():
                            choices=list((out/mode/'air_project').glob('aie*.mlir'))
                            physical=max(choices,key=lambda x:x.stat().st_size)
                        try:
                            manifest=decode(raw,physical,out/'trace',device_name='orbit_segment')
                            events=json.loads((out/'trace/trace.cycles.json').read_text())
                            markers={name:[e for e in events if e.get('name')==name and e.get('ph')=='B'] for name in ['INSTR_EVENT_0','INSTR_EVENT_1']}
                            save(out/'trace/marker-audit.json',dict(markers=markers,expected_pairs=1,
                                ordered_single_pair=all(len(v)==1 for v in markers.values()) and markers['INSTR_EVENT_0'][0]['ts']<markers['INSTR_EVENT_1'][0]['ts'],
                                overflow_counter_available=False,scope='only bracketed core interval; configuration/shim/device/complete FFN outside coverage'))
                        
                        except Exception as e:
                            (out/'trace').mkdir(exist_ok=True);np.save(out/'trace/raw-failed-decode.npy',raw)
                            save(out/'trace/decode-failure.json',dict(error=str(e),physical=str(physical)))
                    save(out/'samples.json',samples)
                    print(json.dumps(samples[-1]),flush=True)
        except Exception as e:
            save(out/'failure.json',dict(type=type(e).__name__,message=str(e),samples=samples));raise
        finally:
            for r in runners.values():r.unload()
    med={m:float(np.median([s['wall_ms'] for s in samples if s['mode']==m and not s['warmup']])) for m in compiled}
    save(out/'summary.json',dict(status='passed' if all(s['check']['passed'] for s in samples) else 'numeric_failed',medians_ms=med,
        trace_on_over_off=med['on']/med['off'],scope='total packet trace/placement/host perturbation; no isolated trace cost or physical DDR counter',
        completeness='unproven: no explicit source entry/exit markers or overflow counter; finite packet window only'))
    return 0 if all(s['check']['passed'] for s in samples) else 1

if __name__=='__main__':raise SystemExit(main())
