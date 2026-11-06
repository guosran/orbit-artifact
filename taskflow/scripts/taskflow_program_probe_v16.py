#!/usr/bin/env python3
"""Replay frozen native C++ direct-AIR packages; no planning/fitting or fallback.

Freeze: --case INPUT COMPILED (repeat) --freeze NEW.json
Run: --protocol FROZEN.json --output NEW --poll-us 20 [--validate-only]
NPU runner owns /tmp/npu.lock. Root must apply an outer subprocess timeout.
"""
import argparse
import fcntl
import importlib.util
import json
from pathlib import Path
import sys
import time
import numpy as np
from taskflow_device_transfer_microbench_v15 import ident, read, write, verify, sha, numeric
from taskflow_completion_probe_v16 import polling_wait


def fixture_module():
    path=Path(__file__).resolve().parents[1]/'test/TaskflowAIR/prepare_mechanism_v16.py'
    spec=importlib.util.spec_from_file_location('v16_fixture',path)
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module,path


def freeze(cases, output, seeds, warmups, repeats, poll_us):
    assert not output.exists()
    records=[]
    for src,compiled in cases:
        src,compiled=Path(src).resolve(),Path(compiled).resolve()
        meta=read(compiled/'hardware/compile.json')
        records.append(dict(id=src.parent.name if src.name=='input' else src.name,fixture=ident(src/'fixture.json'),source=ident(src/'source.mlir'),
            compile=ident(compiled/'hardware/compile.json'),elf=ident(meta['elf_path']),
            abi=ident(compiled/'abi.json'),plan=ident(compiled/'plan.json'),
            transformed=ident(compiled/'transformed-taskflow.mlir'),
            aie=ident(compiled/'hardware/air_project/npu.input.air.mlir')))
    output.parent.mkdir(parents=True,exist_ok=True)
    write(output,dict(schema='orbit.program-probe.protocol.v16',cases=records,seeds=seeds,
        warmups=warmups,repeats=repeats,order='seed-repeat-alternating',
        fixture_generator=ident(fixture_module()[1]),runner=ident(__file__),
        base_observer=ident(Path(__file__).with_name('taskflow_device_transfer_microbench_v15.py')),
        poll_us=poll_us, observer=ident(Path(__file__).with_name('taskflow_npu_trace_v3.py')),
        polling_observer=ident(Path(__file__).with_name('taskflow_completion_probe_v16.py')),
        installed_runtime=ident(Path(sys.prefix)/f'lib/python{sys.version_info.major}.{sys.version_info.minor}/site-packages/triton/backends/amd_triton_npu/multilaunch.py'),
        observation_scope='one prepared invocation runner wall; context/BO preparation and reference/evidence work excluded',
        numerical_tolerance=dict(atol=1e-5,rtol=1e-5)))


def validate(protocol):
    assert protocol['schema']=='orbit.program-probe.protocol.v16'
    assert protocol['order']=='seed-repeat-alternating'
    assert len({c['id'] for c in protocol['cases']})==len(protocol['cases'])>0
    assert protocol['repeats']>0 and protocol['warmups']>=0 and protocol['seeds']
    verify(protocol['runner']);verify(protocol['fixture_generator'])
    for key in ['observer','polling_observer','installed_runtime','base_observer']:verify(protocol[key])
    assert protocol['poll_us']>=0
    for c in protocol['cases']:
        for k in ['fixture','source','compile','elf','abi','plan','transformed','aie']:verify(c[k])
        meta=read(c['compile']['path']);abi=read(c['abi']['path'])
        assert meta['status']=='compiled' and not meta['bf16_emulation']
        assert sha(meta['elf_path'])==c['elf']['sha256']==meta['elf_sha256']
        assert read(c['fixture']['path'])['source_sha256']==c['source']['sha256']
        assert all(b['dtype']=='f32' for b in abi['buffers'])
        assert len(abi['buffers'])<=meta['argument_count']
        assert set(abi['outputs'])=={b['name'] for b in abi['buffers'] if b['role']=='output'}


def execute(protocol,out,poll_us):
    from triton.backends.amd_triton_npu import multilaunch
    from triton.backends.amd_triton_npu.multilaunch import MultiLaunchRunner
    from taskflow_npu_trace_v3 import ObservedBO,ObservedRun
    module,path=fixture_module()
    events=[];polls=[];runners=[]
    class BO(ObservedBO):
        def sync(self,direction,*args,**kwargs):
            begin=time.perf_counter_ns();value=self.raw.sync(direction,*args,**kwargs);end=time.perf_counter_ns()
            events.append(dict(kind='actual_bo_sync',direction=str(direction),buffer_index=self.index,start_ns=begin,end_ns=end));return value
    class XRT:
        def __init__(self,raw):self.raw=raw;self.ext=self;self.next_bo=0
        def __getattr__(self,key):return getattr(self.raw,key)
        def bo(self,*args,**kwargs):
            b=BO(self.raw.ext.bo(*args,**kwargs),events,self.next_bo);self.next_bo+=1;return b
        def run(self,*args,**kwargs):return ObservedRun(self.raw.run(*args,**kwargs),events)
    old_wait,old_backend,old_interval=multilaunch._wait,multilaunch._wait_nogil,multilaunch._POLL_INTERVAL
    def wait(run):
        begin=time.perf_counter_ns()
        try:polling_wait(run.raw if isinstance(run,ObservedRun) else run,poll_us/1e6,polls)
        finally:events.append(dict(kind='actual_xrt_wait',start_ns=begin,end_ns=time.perf_counter_ns()))
    multilaunch._wait=wait
    samples=0
    try:
        for c in protocol['cases']:
            meta=read(c['compile']['path']);abi=read(c['abi']['path']);begin=time.perf_counter_ns()
            runner=MultiLaunchRunner(meta['elf_path'],meta['kernel_name']);runner._xrt=XRT(runner._xrt)
            assert getattr(runner,'_runtime','xrt')=='xrt'
            arrays=[];bos={};proof=[]
            for i,b in enumerate(abi['buffers']):
                size=int(np.prod(b['shape']))*4;bo=runner._xrt.ext.bo(runner.device,size)
                array=np.frombuffer(bo.map(),dtype=np.float32,count=size//4).reshape(b['shape'])
                assert size==bo.size()
                arrays.append(array);bos[i]=bo
                proof.append(dict(name=b['name'],bytes=size,array_address=array.ctypes.data,
                    mapped_address=np.frombuffer(bo.map(),dtype=np.uint8).ctypes.data))
                assert proof[-1]['array_address']==proof[-1]['mapped_address']
            runners.append(dict(case=c,runner=runner,abi=abi,arrays=arrays,bos=bos))
            write(out/('preparation-'+c['id']+'.json'),dict(context_and_bo_preparation_ns=time.perf_counter_ns()-begin,
                pointer_alias_proof=proof,active_contexts_after_preparation=len(runners)))
        write(out/'runtime.json',dict(installed_runner=ident(multilaunch.__file__),fixture_generator=ident(path),python=sys.version,
            numpy=np.__version__,active_contexts=len(runners),poll_us=poll_us,
            wait='instrumented explicit state polling, condition differs from v15',
            clock='host perf_counter_ns only; no device clock conversion',
            preparation_excluded=True))
        with (out/'samples.jsonl').open('w') as log:
            for si,seed in enumerate(protocol['seeds']):
                for repeat in range(protocol['warmups']+protocol['repeats']):
                    order=runners if (si+repeat)%2==0 else list(reversed(runners))
                    for p in order:
                        c=p['case'];fixture=read(c['fixture']['path'])['fixture']
                        inputs,strict,exact=module.inputs_and_references(fixture,seed,repeat)
                        directory=out/c['id']/f'seed-{seed}'/f'repeat-{repeat}';directory.mkdir(parents=True)
                        for b,arr in zip(p['abi']['buffers'],p['arrays']):
                            if b['role']=='input':np.copyto(arr,inputs[b['name']])
                            else:arr.fill(np.nan)
                        np.savez(directory/'inputs.npz',**inputs);np.savez(directory/'reference.npz',**strict)
                        np.savez(directory/'reference-f64.npz',**exact)
                        write(out/'attempt-in-progress.json',dict(case=c['id'],seed=seed,repeat=repeat))
                        events.clear();polls.clear();begin=time.perf_counter_ns()
                        outputs=p['runner'].run(p['arrays'],bo_key='v16-bound',bound_buffers=p['bos'],
                            output_indices={i for i,b in enumerate(p['abi']['buffers']) if b['role']=='output'})
                        end=time.perf_counter_ns()
                        actual={b['name']:outputs[i].copy() for i,b in enumerate(p['abi']['buffers']) if b['role']=='output'}
                        checks={name:numeric(value,strict[name],exact[name]) for name,value in actual.items()}
                        starts=[e for e in events if e['kind']=='actual_xrt_start'];waits=[e for e in events if e['kind']=='actual_xrt_wait']
                        assert len(starts)==len(waits)==len(polls)==1
                        syncs=[e for e in events if e['kind']=='actual_bo_sync']
                        assert len(syncs)==len(p['abi']['buffers'])+len(actual)
                        np.savez(directory/'outputs.npz',**actual)
                        sample=dict(case=c['id'],seed=seed,repeat=repeat,warmup=repeat<protocol['warmups'],
                            runner_wall_ns=end-begin,dispatch_to_wait_end_ns=waits[0]['end_ns']-starts[0]['start_ns'],
                            sync_subtotal_ns=sum(e['end_ns']-e['start_ns'] for e in syncs),events=list(events),polling=polls[0],
                            checks=checks,inputs=ident(directory/'inputs.npz'),outputs=ident(directory/'outputs.npz'),
                            reference=ident(directory/'reference.npz'),reference_f64=ident(directory/'reference-f64.npz'),case_identity=c)
                        sample['other_runner_ns']=sample['runner_wall_ns']-sample['dispatch_to_wait_end_ns']-sample['sync_subtotal_ns']
                        assert sample['other_runner_ns']>=0
                        write(directory/'sample.json',sample);log.write(json.dumps(sample,allow_nan=False)+'\n');log.flush()
                        samples+=1
                        assert all(check['passed'] for value in checks.values() for check in value.values()),'numerical validation failed'
                        (out/'attempt-in-progress.json').unlink()
                        print(json.dumps(dict(case=c['id'],seed=seed,repeat=repeat,runner_wall_ns=end-begin,passed=True)),flush=True)
    except BaseException as error:
        write(out/'failure.json',dict(error=repr(error),events=events,polling=polls,samples_completed=samples));raise
    finally:
        multilaunch._wait,multilaunch._wait_nogil,multilaunch._POLL_INTERVAL=old_wait,old_backend,old_interval
        for p in runners:p['runner'].unload()
    write(out/'summary.json',dict(schema='orbit.program-probe.result.v16',status='passed',samples=samples,actual_submissions=samples,
        device_duration_ns=None,physical_dma_bytes=None,condition='bound BO, all contexts prepared, explicit instrumented polling'))


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--case',nargs=2,action='append');p.add_argument('--freeze',type=Path)
    p.add_argument('--protocol',type=Path);p.add_argument('--output',type=Path)
    p.add_argument('--seeds',nargs='+',type=int,default=[11,23,47]);p.add_argument('--warmups',type=int,default=2)
    p.add_argument('--repeats',type=int,default=9);p.add_argument('--poll-us',type=float)
    p.add_argument('--validate-only',action='store_true');a=p.parse_args()
    if a.freeze:
        assert a.case and not a.protocol
        freeze(a.case,a.freeze,a.seeds,a.warmups,a.repeats,20 if a.poll_us is None else a.poll_us);validate(read(a.freeze));return
    assert a.protocol and a.output and not a.output.exists()
    protocol=read(a.protocol);validate(protocol)
    a.poll_us=protocol['poll_us'] if a.poll_us is None else a.poll_us
    assert a.poll_us==protocol['poll_us'], 'poll condition differs from frozen protocol'
    a.output.mkdir(parents=True)
    write(a.output/'protocol.json',protocol)
    write(a.output/'identity.json',dict(protocol=ident(a.protocol),runner=ident(__file__),poll_us=a.poll_us,
        device_open_requested=not a.validate_only))
    if a.validate_only:
        write(a.output/'summary.json',dict(status='validated',cases=len(protocol['cases']),device_submissions=0));return
    with open('/tmp/npu.lock','w') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX);execute(protocol,a.output,a.poll_us)

if __name__=='__main__':main()
