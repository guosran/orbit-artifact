#!/usr/bin/env python3
"""CPU-only v15 fixture and existing-runner observer contract tests."""
import argparse
import importlib.util
import json
from pathlib import Path
import sys
import tempfile
import types
import numpy as np


def module(p,name):
    s=importlib.util.spec_from_file_location(name,p);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--output',type=Path,required=True);a=parser.parse_args();assert not a.output.exists()
    taskflow=Path(__file__).resolve().parents[2];scripts=taskflow/'scripts';sys.path.insert(0,str(scripts))
    fixture=module(taskflow/'test/TaskflowAIR/prepare_device_transfer_v15.py','fixture_v15')
    bench=module(scripts/'taskflow_device_transfer_microbench_v15.py','bench_v15');checks=[]
    # Same arithmetic source across chunk configurations; complete input dependence.
    assert fixture.source(1,2048,0)==fixture.source(1,2048,0);checks.append('segmentation-does-not-alter-source')
    v=fixture.input_values(1,64,11,0);w=fixture.input_values(1,64,11,1);assert not np.array_equal(v,w);checks.append('per-repeat-input-update')
    s,e=fixture.references(v,0);assert np.array_equal(s,v) and np.array_equal(e,v.astype('f8'));checks.append('copy-exact-reference')
    s,e=fixture.references(v,4);independent=v.copy()
    for c in (.03125,.0625,-.015625,.0078125):independent=np.add(independent,np.float32(c),dtype=np.float32)
    assert np.array_equal(s,independent);checks.append('four-add-f32-source-order')
    class BO:
        def __init__(self,device,size):self.data=bytearray(size);self.device=bytearray(size)
        def size(self):return len(self.data)
        def map(self):return memoryview(self.data)
        def sync(self,direction,*args,**kwargs):
            if direction=='TO_DEVICE':self.device[:]=self.data
            else:self.data[:]=self.device
    class RawRun:
        def __init__(self,kernel):self.args={};self.kernel=kernel
        def set_arg(self,i,bo):self.args[i]=bo
        def start(self):
            x=np.frombuffer(self.args[0].device,dtype=np.float32).copy()
            if self.kernel=='adds':
                for c in (.03125,.0625,-.015625,.0078125):x=np.add(x,np.float32(c),dtype=np.float32)
            self.args[1].device[:]=x.tobytes()
    class XRT:
        def __init__(self):self.ext=self
        def bo(self,*args):return BO(*args)
        def run(self,kernel):return RawRun(kernel)
        xclBOSyncDirection=types.SimpleNamespace(XCL_BO_SYNC_BO_TO_DEVICE='TO_DEVICE',XCL_BO_SYNC_BO_FROM_DEVICE='FROM_DEVICE')
    ml=types.ModuleType('triton.backends.amd_triton_npu.multilaunch');ml.__file__=__file__;ml._wait_nogil=None;ml._POLL_INTERVAL=.0002
    def fakewait(run):ml._wait_nogil=fakewait
    ml._wait=fakewait
    class Runner:
        def __init__(self,elf,kernel):self._runtime='xrt';self._xrt=XRT();self.device=object();self.kernel=kernel.split(':')[-1];self.bound=None
        def run(self,arrays,bo_key,output_indices,bound_buffers):
            if self.bound is None:self.bound=dict(bound_buffers)
            else:assert all(self.bound[k] is bound_buffers[k] for k in self.bound)
            for bo in bound_buffers.values():bo.sync('TO_DEVICE')
            run=self._xrt.run(self.kernel)
            for i,bo in bound_buffers.items():run.set_arg(i,bo)
            run.start();ml._wait(run);bound_buffers[1].sync('FROM_DEVICE');return {1:arrays[1]}
        def unload(self):pass
    ml.MultiLaunchRunner=Runner
    for name in ('triton','triton.backends','triton.backends.amd_triton_npu'):
        sys.modules[name]=types.ModuleType(name);sys.modules[name].__path__=[]
    sys.modules['triton.backends.amd_triton_npu.multilaunch']=ml;sys.modules['triton.backends.amd_triton_npu'].multilaunch=ml
    with tempfile.TemporaryDirectory() as td:
        root=Path(td);records=[];cases=[]
        for adds in (0,4):
            d=root/str(adds);d.mkdir();(d/'source.mlir').write_text(fixture.source(1,64,adds));(d/'plan.json').write_text(json.dumps({'actual_dma_bytes':512,'transfer_summary':[{'storage':'A','direction':'host_to_l1','bytes':256,'count':4},{'storage':'C','direction':'l1_to_host','bytes':256,'count':4}]}));
            (d/'air_project').mkdir();physical=d/'air_project/npu.input.air.mlir';kernel='adds' if adds else 'copy';physical.write_text(f'aie.runtime_sequence @{kernel}(%arg0: memref<1x64xf32>, %arg1: memref<1x64xf32>) {{\n // no third runtime argument\n}}\n');
            (d/'air_project/full_elf_config.json').write_text(json.dumps({'xrt-kernels':[{'name':'main','instance':[{'id':kernel}],'arguments':[{'name':'arg_'+str(i),'type':'char *','offset':hex(i*8)} for i in range(3)]}]}));(d/'program.elf').write_bytes(b'CPU MOCK NOT ELF')
            abi={'buffers':[{'name':'A','role':'input','dtype':'f32','shape':[1,64]},{'name':'C','role':'output','dtype':'f32','shape':[1,64]}],'outputs':['C']};(d/'abi.json').write_text(json.dumps(abi))
            artifact={'status':'compiled','argument_count':3,'bf16_emulation':False,'elf_path':str(d/'program.elf'),'elf_sha256':bench.sha(d/'program.elf'),'kernel_name':'main:'+kernel};(d/'compile.json').write_text(json.dumps(artifact))
            cases.append({'id':str(adds),'fixture':{'elements':64,'chunk':16,'adds':adds},'artifact':bench.ident(d/'compile.json'),'abi':bench.ident(d/'abi.json'),'source':bench.ident(d/'source.mlir'),'plan':bench.ident(d/'plan.json'),'aie':[bench.ident(physical)]})
        protocol={'schema':'orbit.device-transfer.protocol.v15','observer':'minimal','warmups':1,'repeats':2,'seeds':[11,23],'order':{'policy':'seed-repeat-alternating','seed':0},'cases':cases}
        records=bench.validate(protocol);checks.append('three-ELF-pointers-with-two-runtime-arguments-proof')
        broken=json.loads(json.dumps(protocol));badpath=root/'0/air_project/npu.input.air.mlir';saved=badpath.read_text();badpath.write_text(saved.replace('// no third runtime argument','aie.dma_bd(%arg2 : memref<1x64xf32>)'));broken['cases'][0]['aie']=[bench.ident(badpath)]
        try:bench.validate(broken)
        except AssertionError:checks.append('undeclared-third-runtime-argument-rejected')
        else:raise AssertionError('accepted used extra argument')
        badpath.write_text(saved)
        for mode in ('minimal','detailed'):
            protocol['observer']=mode;out=root/mode;out.mkdir();bench.execute(protocol,records,out)
            summary=json.load(open(out/'summary.json'));assert summary['samples']==12 and summary['max_abs_f64']<=1e-6
            samples=[json.loads(line) for line in (out/'samples.jsonl').read_text().splitlines()]
            assert all(len(x['events'])==5 and x['dispatch_to_wait_end_ns']>0 and x['checks']['strict_f32_source_order']['max_abs']==0 for x in samples)
            checks.append(mode+'-fake-device-bound-BO-actual-API-and-output-contract')
        (root/'0/source.mlir').write_text('TAMPER')
        try:bench.validate(protocol)
        except AssertionError:checks.append('source-tamper-rejected')
        else:raise AssertionError('accepted altered source')
    a.output.mkdir(parents=True);(a.output/'summary.json').write_text(json.dumps({'status':'passed','checks':checks,'count':len(checks),'actual_device_submissions':0,'scope':'synthetic CPU runner test, no compiled NPU artifacts or hardware claims'},indent=2)+'\n')
    print(json.dumps({'status':'passed','checks':len(checks)}))

if __name__=='__main__':main()
