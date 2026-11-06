#!/usr/bin/env python3
"""CPU-only v14 protocol/timer/facade tests with an explicit fake device memory."""
import argparse
import builtins
import copy
import importlib.util
import json
from pathlib import Path
import sys
import tempfile
from types import SimpleNamespace
import numpy as np

ART=Path(__file__).resolve().parents[2]
SCRIPT=ART/'scripts/taskflow_sync_state_microbench_v14.py'
sys.path.insert(0,str(ART/'scripts'))
import taskflow_npu_trace_v3 as observer
spec=importlib.util.spec_from_file_location('bench',SCRIPT);bench=importlib.util.module_from_spec(spec);spec.loader.exec_module(bench)


class FakeBO:
    def __init__(self,host,broken_partial=False):self.host=host;self.device=np.full_like(host,np.nan);self.calls=[];self.broken_partial=broken_partial
    def size(self):return self.host.nbytes
    def sync(self,direction,*args):
        size,offset=(self.size(),0) if not args else args
        self.calls.append(dict(direction=direction,size=size,offset=offset,argument_count=1+len(args)))
        if self.broken_partial and args:return
        host=self.host.view(np.uint8).reshape(-1);device=self.device.view(np.uint8).reshape(-1)
        if 'TO_DEVICE' in str(direction):device[offset:offset+size]=host[offset:offset+size]
        else:host[offset:offset+size]=device[offset:offset+size]


class FakeRun:
    def __init__(self):self.args={}
    def set_arg(self,index,value):
        assert isinstance(value,FakeBO),'existing ObservedRun failed to unwrap facade to actual BO'
        self.args[index]=value
    def start(self):pass
    def wait(self):return 0


def prepared(broken_partial=False):
    arrays={i:np.zeros((4,64),np.float32) for i in range(3)};events=[]
    raw={i:FakeBO(v,broken_partial and i==0) for i,v in arrays.items()}
    item=SimpleNamespace(arrays=arrays,events=events,bos={i:observer.ObservedBO(b,events,i) for i,b in raw.items()},
        module=SimpleNamespace(_wait=lambda r:r.wait()),xrt=SimpleNamespace(xclBOSyncDirection=SimpleNamespace(XCL_BO_SYNC_BO_TO_DEVICE='TO_DEVICE',XCL_BO_SYNC_BO_FROM_DEVICE='FROM_DEVICE')))
    abi=[dict(argument=i,storage=i,role='input' if i<2 else 'output') for i in range(3)]
    item.manifest=dict(storage=[dict(index=i,name=n,role='input' if i<2 else 'output') for i,n in enumerate(('A','B','C'))],regions=[dict(npu_abi=abi,abi=abi)])
    class Runner:
        cached=None
        def run(self,arrays,bo_key,bound_buffers,output_indices):
            if self.cached is None:self.cached=dict(bound_buffers)
            else:assert all(self.cached[k] is v for k,v in bound_buffers.items()),'caller changed bound BO object under cached bo_key'
            for b in bound_buffers.values():b.sync('TO_DEVICE')
            run=observer.ObservedRun(FakeRun(),events)
            for i,b in bound_buffers.items():run.set_arg(i,b)
            run.start()
            # Deliberately synthetic device arithmetic confined to this CPU test.
            raw[2].device[:]=(raw[0].device+raw[1].device)*np.float32(2)+raw[1].device
            item.module._wait(run)
            bound_buffers[2].sync('FROM_DEVICE')
    item.runners={0:Runner()};return item,raw


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--protocol',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    a.output.mkdir(parents=True,exist_ok=False);checks=[]
    protocol,cells=bench.load_protocol(a.protocol,'exploration');assert len(cells)>0;checks.append('frozen exploration protocol validated without device')
    with tempfile.TemporaryDirectory() as tmp:
        tmp=Path(tmp)
        # Block XRT and triton imports through the actual validate-only main.
        original_import=builtins.__import__
        def guarded(name,*args,**kwargs):
            if name=='pyxrt' or name.startswith('triton'):raise AssertionError('runtime imported in validation')
            return original_import(name,*args,**kwargs)
        oldargv=sys.argv
        try:
            builtins.__import__=guarded;sys.argv=[str(SCRIPT),'--protocol',str(a.protocol),'--split','exploration','--validate-only','--output',str(tmp/'validate')];bench.main()
        finally:builtins.__import__=original_import;sys.argv=oldargv
        assert json.loads((tmp/'validate/identity.json').read_text())['device_opened'] is False;checks.append('validate-only main blocks all runtime imports')
        wrong_target=json.loads((tmp/'validate/runtime-fingerprint-before.json').read_text());wrong_target['target_id']='0'*64
        wrong_file=tmp/'wrong-target.json';wrong_file.write_text(json.dumps(wrong_target))
        wrong_protocol=copy.deepcopy(protocol);wrong_protocol['runtime_fingerprint']=dict(path=str(wrong_file),sha256=bench.sha(wrong_file))
        wrong_protocol_path=tmp/'wrong-target-protocol.json';wrong_protocol_path.write_text(json.dumps(wrong_protocol))
        try:
            sys.argv=[str(SCRIPT),'--protocol',str(wrong_protocol_path),'--split','exploration','--validate-only','--output',str(tmp/'bad-target-out')]
            try:bench.main()
            except ValueError as error:assert 'current runtime files/config/cpu platform differ' in str(error)
            else:raise AssertionError('mismatched frozen runtime target accepted')
        finally:sys.argv=oldargv
        assert not (tmp/'bad-target-out').exists()
        checks.append('coherently hashed wrong runtime fingerprint rejected before output/device creation')

        for field,value in [('offset_bytes',1),('size_bytes',10**9),('observer_mode','invented'),('direction','wrong')]:
            bad=copy.deepcopy(protocol);bad['cells'][0][field]=value;f=tmp/'invalid.json';f.write_text(json.dumps(bad))
            try:bench.load_protocol(f,'exploration')
            except ValueError:pass
            else:raise AssertionError('invalid protocol accepted: '+field)
        checks.append('invalid alignment/range/observer/direction rejected')
        for form in ('whole-implicit','whole-explicit','region-explicit'):
            cell=dict(invocation_form=form,size_bytes=256 if form=='region-explicit' else 1024,offset_bytes=256 if form=='region-explicit' else 0)
            for mode in ('minimal','detailed','batch'):
                bo=FakeBO(np.ones((4,64),np.float32));args=bench.sync_arguments(cell,'TO_DEVICE')
                result=bench.measure_calls(bo,args,3,mode,observer.ObservedBO)
                assert len(bo.calls)==3 and all(c['argument_count']==(1 if form=='whole-implicit' else 3) for c in bo.calls)
                assert (result['per_call_envelopes'] is None)==(mode=='batch')
                assert (result['detailed_inner_events'] is not None)==(mode=='detailed')
                if mode=='detailed':
                    for inner,outer in zip(result['detailed_inner_events'],result['per_call_envelopes']):assert outer['start_ns']<=inner['start_ns']<=inner['end_ns']<=outer['end_ns']
        checks.append('all three invocation forms preserve arguments in all observer modes')
        checks.append('detailed inner spans contained by outer envelopes; batch has no per-call claim')
        a_path=tmp/'inputs.npz';np.savez(a_path,A=np.full((4,64),.25,np.float32),B=np.full((4,64),.5,np.float32))
        case=dict(inputs=[str(a_path)])
        cell=dict(id='cpu-test',bo_bytes=1024,size_bytes=256,offset_bytes=256,direction='TO_DEVICE',invocation_form='region-explicit',observer_mode='minimal',
            sequence_count=1,state='before-device-read',dirty_offset_bytes=256,dirty_size_bytes=256)
        item,raw=prepared();result=bench.program_sample(cell,0,11,0,case,item,observer,tmp/'good')
        assert result['verification_runs'][0]['passed'] and len(raw[0].calls)==2
        assert [c['argument_count'] for c in raw[0].calls]==[1,3]
        assert any(e['kind']=='HostWrite' for e in result['actual_setup_events'])
        assert sum(e['kind']=='skipped_auto_to_A' for e in result['verification_runs'][0]['events'])==1
        checks.append('partial update verified via independent device buffer and auto-TO A suppressed')
        item,raw=prepared(True)
        try:bench.program_sample(cell,0,11,0,case,item,observer,tmp/'broken')
        except ValueError as error:assert 'partial-sync delivery' in str(error)
        else:raise AssertionError('broken partial sync masked by hidden full TO')
        checks.append('broken partial sync fails numerical verification instead of hidden auto-TO fallback')
        item,raw=prepared();cell['state']='after-device-read';result=bench.program_sample(cell,0,11,0,case,item,observer,tmp/'after')
        assert len(result['verification_runs'])==2 and result['actual_dirty_range'] is None
        assert not any(e['kind']=='HostWrite' for e in result['actual_setup_events'])
        checks.append('after-device-read keeps A readonly and verifies before/after actual mocked use')
        assert item.runners[0].cached[0] is item._v14_target_facade
        checks.append('same A facade object reused across dispatches under existing runner BO cache')
        class ByteBO:
            def __init__(self,device,size):self.buffer=bytearray(size);self.calls=[]
            def map(self):return self.buffer
            def size(self):return len(self.buffer)
            def sync(self,*args):self.calls.append(args)
        xrt=SimpleNamespace(ext=SimpleNamespace(bo=ByteBO),xclBOSyncDirection=SimpleNamespace(XCL_BO_SYNC_BO_TO_DEVICE='TO_DEVICE',XCL_BO_SYNC_BO_FROM_DEVICE='FROM_DEVICE'))
        for state in ('cpu-read-range','cpu-modified-range'):
            rawcell=dict(cell,state=state,bo_bytes=1024,size_bytes=256,offset_bytes=256,sequence_count=1)
            value=bench.standalone(rawcell,11,0,xrt,None,observer)
            kinds=[e['kind'] for e in value['setup']]
            assert kinds.index('untimed-prior-TO-before-host-range-action')<kinds.index('untimed-host-read-range' if state=='cpu-read-range' else 'untimed-host-write-range')
        checks.append('host-read and host-modified range setup follows an untimed prior whole TO')
    (a.output/'summary.json').write_text(json.dumps(dict(status='passed',checks=checks,count=len(checks),synthetic_device_memory=True,actual_device_submissions=0,source=bench.identity(SCRIPT)),indent=2)+'\n')
    print(json.dumps(dict(status='passed',checks=len(checks))))
if __name__=='__main__':main()
