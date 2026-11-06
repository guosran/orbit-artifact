#!/usr/bin/env python3
"""Replay separately bound on/off trace derivatives through the existing runner.

No compilation, plan choice, timing model or numerical fallback. Root coordinates
all device use. This command locks /tmp/npu.lock itself; do not outer-lock it.
"""
import argparse
import ctypes
from collections import Counter
import hashlib
import json
from pathlib import Path
import sys
import time

SOURCE=Path(__file__).read_bytes()
SOURCE_SHA=hashlib.sha256(SOURCE).hexdigest()


def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def ident(p):return dict(path=str(Path(p).resolve()),sha256=sha(p))
def save(p,x):Path(p).parent.mkdir(parents=True,exist_ok=True);Path(p).write_text(json.dumps(x,indent=2,allow_nan=False)+'\n')
def need(c,m):
    if not c:raise ValueError(m)


def check_events(events):
    sync=[e for e in events if e['kind']=='actual_bo_sync']
    need([(e['buffer_index'],'TO_DEVICE' if 'TO_DEVICE' in e['direction'] else 'FROM_DEVICE') for e in sync]==
         [(0,'TO_DEVICE'),(1,'TO_DEVICE'),(2,'TO_DEVICE'),(1,'FROM_DEVICE'),(2,'FROM_DEVICE')], 'three-buffer sync ABI differs')
    starts=[i for i,e in enumerate(events) if e['kind']=='actual_xrt_start']
    waits=[i for i,e in enumerate(events) if e['kind']=='actual_xrt_wait']
    need(len(starts)==len(waits)==1 and starts[0]<waits[0], 'expected one successful original start/wait')
    for i,e in enumerate(events):
        if e['kind']=='actual_bo_sync':
            need(i<starts[0] if 'TO_DEVICE' in e['direction'] else i>waits[0], 'sync order differs from runner contract')


def observed_wait(original_wait,run,events,unwrap=lambda run:run):
    start=time.perf_counter_ns()
    try:
        value=original_wait(unwrap(run))
    except Exception as error:
        events.append(dict(kind='actual_xrt_wait_failed',start_ns=start,end_ns=time.perf_counter_ns(),
                           error_type=type(error).__name__,message=str(error)))
        raise
    events.append(dict(kind='actual_xrt_wait',start_ns=start,end_ns=time.perf_counter_ns()))
    return value


def self_test():
    events=[dict(kind='actual_bo_sync',buffer_index=i,direction='TO_DEVICE') for i in range(3)]
    events += [dict(kind='actual_xrt_start'),dict(kind='actual_xrt_wait')]
    events += [dict(kind='actual_bo_sync',buffer_index=i,direction='FROM_DEVICE') for i in (1,2)]
    check_events(events);checks=1
    for bad in (events[:-1],events[:3]+list(reversed(events[3:5]))+events[5:]):
        try:check_events(bad)
        except ValueError:checks+=1
        else:raise AssertionError('bad event sequence accepted')
    success=[]
    need(observed_wait(lambda x:x+1,1,success)==2 and success[0]['kind']=='actual_xrt_wait','successful wait incorrectly typed')
    checks+=1
    failure=[]
    def fail_wait(run):raise RuntimeError('CPU synthetic failed wait')
    try:observed_wait(fail_wait,None,failure)
    except RuntimeError:pass
    else:raise AssertionError('failed wait swallowed')
    need(len(failure)==1 and failure[0]['kind']=='actual_xrt_wait_failed','failed wait marked successful')
    checks+=1
    print(json.dumps(dict(status='passed',checks=checks,device_opened=False)))


def main():
    p=argparse.ArgumentParser(description=__doc__)
    for name in ('instrumentation','off-elf','on-elf','on-physical','inputs','reference','output'):
        p.add_argument('--'+name,type=Path)
    p.add_argument('--kernel');p.add_argument('--device-name',default='orbit_segment')
    p.add_argument('--input-name',default='A');p.add_argument('--output-name',default='C')
    p.add_argument('--warmups',type=int,default=2);p.add_argument('--repeats',type=int,default=3)
    p.add_argument('--validate-only',action='store_true');p.add_argument('--self-test',action='store_true')
    a=p.parse_args()
    if a.self_test:self_test();return
    need(all(getattr(a,n.replace('-','_')) for n in ('instrumentation','off-elf','on-elf','on-physical','inputs','reference','output')) and a.kernel,'all paths and --kernel required')
    need(a.warmups>=0 and a.repeats>0,'invalid repeat counts')
    record=json.loads(a.instrumentation.read_text());need(record['schema']=='orbit.device-transfer.trace-derivative.v15','unexpected instrumentation')
    for item in [record['source'],*record['derivatives'].values()]:need(sha(item['path'])==item['sha256'],'instrumentation source changed')
    bo=record['buffers'][0]
    need(bo.get('trace_argument')==2 and bo['trace_offset_bytes']==0 and bo['data_output_argument']==1,'requires separate three-buffer derivative')
    bound={name:ident(getattr(a,name.replace('-','_'))) for name in ('instrumentation','off-elf','on-elf','on-physical','inputs','reference')}
    import numpy as np
    with np.load(a.inputs,allow_pickle=False) as archive:input_array=archive[a.input_name].copy()
    with np.load(a.reference,allow_pickle=False) as archive:reference=archive[a.output_name].copy()
    need(input_array.dtype==reference.dtype==np.float32 and input_array.shape==reference.shape and
         input_array.nbytes==bo['logical_output_bytes'] and np.isfinite(input_array).all() and
         np.array_equal(input_array,reference),'requires exact finite identity-copy fixture')
    a.output=a.output.resolve();a.output.mkdir(parents=True,exist_ok=False)
    (a.output/'executor-source.py').write_bytes(SOURCE)
    save(a.output/'identity.json',dict(schema='orbit.device-transfer.trace-execution.v15',source_sha256=SOURCE_SHA,
        files=bound,kernel=a.kernel,device_opened=False,compilation=False,numerical_fallback=False,
        timing_scope='existing runner call including its three TO, submit/wait, two FROM; host setup/readback evidence outside wall',
        claims=dict(physical_bytes=False,trace_complete=False,device_duration=False)))
    if a.validate_only:
        save(a.output/'summary.json',dict(status='validated',device_submissions=0));return
    import fcntl
    import pyxrt
    import taskflow_npu_trace_v3 as observer
    from triton.backends.amd_triton_npu import multilaunch
    from triton.backends.amd_triton_npu.multilaunch import MultiLaunchRunner
    import aie.utils.trace.parse as parser
    events=[];runners={};owners=[];samples=[]
    with open('/tmp/npu.lock','w') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX)
        try:
            for mode,path in [('off',a.off_elf),('on',a.on_elf)]:
                runner=MultiLaunchRunner(str(path),a.kernel);runners[mode]=runner
                runner._xrt=observer.ObservedXRT(runner._xrt,events)
            bdfs={str(r.device.get_info(pyxrt.xrt_info_device.bdf)) for r in runners.values()}
            need(len(bdfs)==1,'runners use different devices')
            device=runners['off'].device
            arrays=[];buffers={};map_addresses=[];sizes=[input_array.nbytes,reference.nbytes,bo['trace_bo_bytes_both_controls']]
            for i,size in enumerate(sizes):
                raw=pyxrt.ext.bo(device,size);mapped=raw.map();owners.extend([raw,mapped])
                need(int(raw.size())==size,'actual BO extent differs')
                array=np.frombuffer(mapped,dtype=np.uint8 if i==2 else np.float32,count=size if i==2 else size//4)
                if i!=2:array=array.reshape(input_array.shape)
                address=ctypes.addressof(ctypes.c_char.from_buffer(mapped))
                need(address==int(array.ctypes.data),'array does not alias raw BO.map base')
                map_addresses.append(address)
                arrays.append(array);buffers[i]=observer.ObservedBO(raw,events,i)
            pointers=[dict(argument=i,address=int(x.ctypes.data),bo_map_address=map_addresses[i],offset_bytes=0,bytes=int(x.nbytes),actual_bo_bytes=int(buffers[i].raw.size())) for i,x in enumerate(arrays)]
            save(a.output/'preparation.json',dict(device_bdf=next(iter(bdfs)),pointers=pointers,
                runtime=ident(multilaunch.__file__),observer=ident(observer.__file__),pyxrt=ident(pyxrt.__file__),decoder=ident(parser.__file__),
                scope='two contexts, one shared three-BO set; no claim of cold device or pure configuration time'))
            original_wait=multilaunch._wait
            def wait(run):
                return observed_wait(original_wait,run,events,lambda item:item.raw if isinstance(item,observer.ObservedRun) else item)
            multilaunch._wait=wait
            try:
                for repeat in range(a.warmups+a.repeats):
                    for mode in (['off','on'] if repeat%2==0 else ['on','off']):
                        np.copyto(arrays[0],input_array);arrays[1].fill(np.nan);arrays[2].fill(0)
                        events.clear();start=time.perf_counter_ns()
                        values=runners[mode].run(arrays,bo_key='v15-copy-trace',bound_buffers=buffers,output_indices={1,2})
                        end=time.perf_counter_ns();check_events(events)
                        actual=values[1].copy();trace=values[2].copy().view(np.uint32)
                        need(np.isfinite(actual).all() and np.array_equal(actual,reference),'exact copy output failed')
                        need(all(int(x.ctypes.data)==pointers[i]['address'] for i,x in enumerate(arrays)),'bound pointer changed')
                        prefix=a.output/(mode+'-'+str(repeat));np.save(str(prefix)+'-output.npy',actual);np.save(str(prefix)+'-trace.npy',trace)
                        sample=dict(mode=mode,repeat=repeat,warmup=repeat<a.warmups,wall_ns=end-start,events=list(events),
                            output=ident(str(prefix)+'-output.npy'),trace=ident(str(prefix)+'-trace.npy'),exact_output=True,
                            sync_count=5,physical_bytes=None,device_duration_ns=None)
                        samples.append(sample);save(a.output/'samples.json',samples)
                        if mode=='on' and repeat==a.warmups+a.repeats-1:
                            try:
                                observer.decode(trace,a.on_physical,a.output/'trace',device_name=a.device_name)
                                decoded=json.loads((a.output/'trace/trace.cycles.json').read_text())
                                counts=Counter((str(e.get('name')),str(e.get('ph'))) for e in decoded)
                                save(a.output/'trace/event-inventory.json',dict(counts=[dict(name=k[0],phase=k[1],count=v) for k,v in sorted(counts.items())],
                                    raw_unit='device_cycles',intervals_derived=False,completeness='unproven; terminal events and trace drainage require independent audit'))
                            except Exception as error:
                                save(a.output/'trace/decode-failure.json',dict(message=str(error),raw_trace_preserved=True))
            finally:multilaunch._wait=original_wait
        except Exception as error:
            save(a.output/'failure.json',dict(message=str(error),events=list(events),samples=len(samples),numerical_fallback=False));raise
        finally:
            for runner in runners.values():runner.unload()
            owners.clear()
    for name,item in bound.items():need(sha(item['path'])==item['sha256'],'bound input changed during replay: '+name)
    save(a.output/'summary.json',dict(status='passed',calls=len(samples),all_outputs_exact=True,
        trace_complete=False,physical_bytes=None,device_duration_ns=None,fit_performed=False))


if __name__=='__main__':main()
