#!/usr/bin/env python3
"""Prepared direct-AIR transfer fixture measurements, using the installed runner.

No compilation, production planning, model fitting, or inferred physical traffic.
The root process must apply an outer bounded subprocess timeout; this runner owns
/tmp/npu.lock, so callers must not take that lock around this command.
"""
import argparse
import fcntl
import hashlib
import importlib.util
import json
import re
from pathlib import Path
import shutil
import sys
import time
import numpy as np

SOURCE_BYTES=Path(__file__).read_bytes()
SOURCE_SHA=hashlib.sha256(SOURCE_BYTES).hexdigest()

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):return json.loads(Path(p).read_text())
def write(p,x):p.write_text(json.dumps(x,indent=2,sort_keys=True,allow_nan=False)+'\n')
def ident(p):return {'path':str(Path(p).resolve()),'sha256':sha(p)}
def verify(x):
    p=Path(x['path']);assert sha(p)==x['sha256'],f'changed evidence {p}'
    return p

def fixture_module():
    p=Path(__file__).resolve().parents[1]/'test/TaskflowAIR/prepare_device_transfer_v15.py'
    spec=importlib.util.spec_from_file_location('v15_fixture',p);module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    return module,p

def runtime_abi_proof(case,artifact,abi):
    """Prove logical runtime args independently of full-ELF min-three padding."""
    config=Path(artifact['elf_path']).parent/'air_project/full_elf_config.json'
    full=read(config)
    kernel,instance=artifact['kernel_name'].split(':',1)
    main=[k for k in full['xrt-kernels'] if k['name']==kernel]
    assert len(main)==1 and any(x['id']==instance for x in main[0]['instance'])
    assert len(main[0]['arguments'])==artifact['argument_count']
    assert all(x['type']=='char *' and x['name']=='arg_'+str(i) and int(x['offset'],16)==8*i for i,x in enumerate(main[0]['arguments'])), 'ELF pointer ABI metadata differs'
    assert artifact['argument_count'] in (2,3), 'only two logical args and optional minimum-three padding supported'
    physical=[Path(x['path']) for x in case['aie'] if Path(x['path']).name=='npu.input.air.mlir']
    assert len(physical)==1, 'one exact final npu.input.air.mlir identity required'
    text=physical[0].read_text()
    expected=[f"memref<1x{case['fixture']['elements']}xf32>"]*2
    signatures=[]
    for match in re.finditer(r'aie\.runtime_sequence @([\w.$]+)\((.*?)\)\s*\{',text,re.S):
        arguments=re.findall(r'(%[\w.$]+)\s*:\s*(memref<[^>]+>)',match[2])
        assert [t for _,t in arguments]==expected and len(arguments)==len(abi['buffers'])
        # Brace scanner ignores quoted strings, line comments, and block comments.
        start=match.end()-1;depth=0;quoted=False;escaped=False;line=False;block=0;end=None;j=start
        while j<len(text):
            ch=text[j];pair=text[j:j+2]
            if line:
                if ch=='\n':line=False
            elif block:
                if pair=='/*':block+=1;j+=1
                elif pair=='*/':block-=1;j+=1
            elif quoted:
                if escaped:escaped=False
                elif ch=='\\':escaped=True
                elif ch=='"':quoted=False
            elif pair=='//':line=True;j+=1
            elif pair=='/*':block=1;j+=1
            elif ch=='"':quoted=True
            elif ch=='{':depth+=1
            elif ch=='}':
                depth-=1
                if depth==0:end=j;break
            j+=1
        assert end is not None
        body=text[start+1:end]
        assert not re.search(r'%arg(?:[2-9]|[1-9][0-9]+)\b',body), 'undeclared extra runtime argument used'
        signatures.append({'name':match[1],'arguments':arguments})
    assert signatures and any(s['name']==instance for s in signatures)
    return {'logical_argument_count':2,'full_ELF_argument_count':artifact['argument_count'],
        'unused_ELF_minimum_padding_arguments':artifact['argument_count']-2,
        'scope':'full ELF metadata may carry minimum-three pointer slots; every actual runtime sequence has exactly two f32 memrefs and no third argument reference',
        'full_elf_config':ident(config),'final_runtime_ir':ident(physical[0]),'runtime_signatures':signatures}


def validate(protocol):
    assert protocol['schema']=='orbit.device-transfer.protocol.v15'
    assert protocol['observer'] in ('minimal','detailed')
    assert protocol['warmups']>=0 and protocol['repeats']>0 and len(set(protocol['seeds']))==len(protocol['seeds'])>0
    assert protocol['order']['policy']=='seed-repeat-alternating'
    assert len({c['id'] for c in protocol['cases']})==len(protocol['cases'])>0
    records=[]
    for c in protocol['cases']:
        f=c['fixture'];assert f['elements']>0 and f['chunk']>0 and f['elements']%f['chunk']==0 and f['chunk']%16==0 and f['adds'] in (0,4)
        artifact=read(verify(c['artifact']));assert artifact['status']=='compiled' and artifact['argument_count']>=2 and not artifact['bf16_emulation']
        assert sha(artifact['elf_path'])==artifact['elf_sha256']
        abi=read(verify(c['abi']));assert abi['outputs']==['C']
        assert abi['buffers']==[{'dtype':'f32','name':'A','role':'input','shape':[1,f['elements']]},{'dtype':'f32','name':'C','role':'output','shape':[1,f['elements']]}]
        for key in ('source','plan'):verify(c[key])
        plan=read(c['plan']['path'])
        transfers=plan['transfer_summary']
        assert sorted((t['storage'],t['direction'],t['bytes'],t['count']) for t in transfers)==[('A','host_to_l1',4*f['elements'],f['elements']//f['chunk']),('C','l1_to_host',4*f['elements'],f['elements']//f['chunk'])]
        assert plan['actual_dma_bytes']==8*f['elements']
        assert c['aie'], 'actual physical IR identity is required'
        for x in c['aie']:verify(x)
        runtime_abi_proof(c,artifact,abi)
        records.append((c,artifact,abi))
    return records

def numeric(actual,strict,exact):
    def metrics(ref):
        a=actual.astype(np.float64);ref=ref.astype(np.float64);d=a-ref
        assert a.shape==ref.shape and np.isfinite(a).all() and np.isfinite(ref).all()
        return {'passed':bool(np.all(abs(d)<=1e-5+1e-5*abs(ref))), 'max_abs':float(np.max(abs(d))),
                'relative_floor_1e-6':float(np.max(abs(d)/np.maximum(abs(ref),1e-6))),
                'normalized_l2':float(np.linalg.norm(d)/max(np.linalg.norm(ref),1e-30))}
    return {'strict_f32_source_order':metrics(strict),'unrounded_f64':metrics(exact)}

def selected_wait(multilaunch):
    fn=multilaunch._wait_nogil
    return {'module':getattr(fn,'__module__',None),'qualname':getattr(fn,'__qualname__',None),
        'poll_interval_seconds':getattr(multilaunch,'_POLL_INTERVAL',None),
        'scope':'actual selected function after wait, not inferred from available source branches'}

def execute(protocol,records,out):
    # Delayed imports make validation strictly CPU/device-import-free.
    from triton.backends.amd_triton_npu import multilaunch
    from triton.backends.amd_triton_npu.multilaunch import MultiLaunchRunner
    from taskflow_npu_trace_v3 import ObservedBO,ObservedRun
    fixture,fixturepath=fixture_module()
    events=[]
    class MinimalBO(ObservedBO):
        def sync(self,direction,*args,**kwargs):
            begin=time.perf_counter_ns();value=self.raw.sync(direction,*args,**kwargs);end=time.perf_counter_ns()
            events.append({'kind':'actual_bo_sync','direction':str(direction),'buffer_index':self.index,
                'start_ns':begin,'end_ns':end,'observation_boundary':'minimal-sync-call'})
            return value
    class XRT:
        def __init__(self,raw):self.raw=raw;self.ext=self;self.next_bo=0
        def __getattr__(self,key):return getattr(self.raw,key)
        def bo(self,*args,**kwargs):
            cls=MinimalBO if protocol['observer']=='minimal' else ObservedBO
            b=cls(self.raw.ext.bo(*args,**kwargs),events,self.next_bo);self.next_bo+=1;return b
        def run(self,*args,**kwargs):return ObservedRun(self.raw.run(*args,**kwargs),events)
    original_wait=multilaunch._wait
    def wait(run):
        begin=time.perf_counter_ns()
        try:value=original_wait(run.raw if isinstance(run,ObservedRun) else run)
        except BaseException as error:
            events.append({'kind':'actual_xrt_wait_failed','start_ns':begin,'end_ns':time.perf_counter_ns(),'error':repr(error)})
            raise
        events.append({'kind':'actual_xrt_wait','start_ns':begin,'end_ns':time.perf_counter_ns()});return value
    runners=[];samples=0;worst=0.;start_loop=time.perf_counter_ns()
    try:
        for c,artifact,abi in records:
            begin=time.perf_counter_ns();runner=MultiLaunchRunner(artifact['elf_path'],artifact['kernel_name']);runner._xrt=XRT(runner._xrt)
            assert getattr(runner,'_runtime','xrt')=='xrt','only actual XRT path supported'
            arrays=[];bos={};proof=[]
            for index,b in enumerate(abi['buffers']):
                size=4*c['fixture']['elements'];bo=runner._xrt.ext.bo(runner.device,size)
                assert bo.size()==size
                arr=np.frombuffer(bo.map(),dtype=np.float32,count=c['fixture']['elements']).reshape(b['shape'])
                arrays.append(arr);bos[index]=bo
                proof.append({'argument':index,'name':b['name'],'shape':b['shape'],'bytes':size,'actual_bo_extent':bo.size(),
                    'array_address':arr.ctypes.data,'mapped_address':np.frombuffer(bo.map(),dtype=np.uint8).ctypes.data})
                assert proof[-1]['array_address']==proof[-1]['mapped_address']
            runners.append({'case':c,'artifact':artifact,'abi':abi,'runner':runner,'arrays':arrays,'bos':bos})
            write(out/('preparation-'+c['id']+'.json'),{'load_and_BO_preparation_ns':time.perf_counter_ns()-begin,'bound_pointer_proof':proof,'active_contexts_after_preparation':len(runners),'successful_constructor':True,'runtime_abi_proof':runtime_abi_proof(c,artifact,abi)})
        write(out/'runtime.json',{'installed_runner':ident(multilaunch.__file__),'observer':ident(Path(__file__).with_name('taskflow_npu_trace_v3.py')),
            'fixture_generator':ident(fixturepath),'python':sys.version,'numpy':np.__version__,'active_contexts':len(runners),
            'bound_buffer_policy':'two stable caller-owned ext.bo objects per case; ordinary implicit BO sync retained',
            'staging_scope':'pointer aliases plus hashed installed bound-buffer source path; no physical memcpy counter',
            'timeout':'external root-owned subprocess bound; installed wait unchanged'})
        multilaunch._wait=wait
        with (out/'samples.jsonl').open('w') as log:
            for seed_index,seed in enumerate(protocol['seeds']):
                for repeat in range(protocol['warmups']+protocol['repeats']):
                    order=runners if (seed_index+repeat+protocol['order'].get('seed',0))%2==0 else list(reversed(runners))
                    for prepared in order:
                        c=prepared['case'];a,output=prepared['arrays'];f=c['fixture'];case_dir=out/c['id']/f'seed-{seed}'/f'repeat-{repeat}';case_dir.mkdir(parents=True)
                        value=fixture.input_values(1,f['elements'],seed,repeat);strict,exact=fixture.references(value,f['adds'])
                        np.copyto(a,value);output.fill(np.nan)
                        np.savez(case_dir/'inputs.npz',A=value);np.savez(case_dir/'reference.npz',C=strict);np.savez(case_dir/'reference-f64.npz',C=exact)
                        write(out/'attempt-in-progress.json',{'case':c['id'],'seed':seed,'repeat':repeat,'status':'before-timed-run','timeout_scope':'outer subprocess; no evidence I/O during runner wall'})
                        events.clear();begin=time.perf_counter_ns()
                        try:
                            result=prepared['runner'].run(prepared['arrays'],bo_key='v15-bound',output_indices={1},bound_buffers=prepared['bos'])
                        except BaseException as error:
                            write(out/'failure.json',{'case':c['id'],'seed':seed,'repeat':repeat,'error':repr(error),'events':events});raise
                        end=time.perf_counter_ns()
                        # Snapshot after the runner timer; numerical validation and I/O excluded.
                        actual=result[1].copy();checks=numeric(actual,strict,exact)
                        assert np.shares_memory(result[1],output),'bound output must preserve mapped BO view'
                        starts=[e for e in events if e['kind']=='actual_xrt_start'];waits=[e for e in events if e['kind']=='actual_xrt_wait'];syncs=[e for e in events if e['kind']=='actual_bo_sync']
                        assert len(starts)==len(waits)==1 and len(syncs)==3
                        assert [e['buffer_index'] for e in syncs]==[0,1,1]
                        assert 'TO_DEVICE' in syncs[0]['direction'] and 'TO_DEVICE' in syncs[1]['direction'] and 'FROM_DEVICE' in syncs[2]['direction']
                        assert starts[0]['end_ns']<=waits[0]['start_ns']<=waits[0]['end_ns']<=syncs[2]['start_ns']
                        np.savez(case_dir/'outputs.npz',C=actual)
                        sample={'case':c['id'],'observer':protocol['observer'],'seed':seed,'repeat':repeat,'warmup':repeat<protocol['warmups'],
                            'runner_wall_ns':end-begin,'dispatch_to_wait_end_ns':waits[0]['end_ns']-starts[0]['start_ns'],
                            'events':list(events),'selected_wait_backend':selected_wait(multilaunch),'checks':checks,
                            'inputs':ident(case_dir/'inputs.npz'),'reference':ident(case_dir/'reference.npz'),'reference_f64':ident(case_dir/'reference-f64.npz'),'outputs':ident(case_dir/'outputs.npz'),
                            'case_identity_sha256':hashlib.sha256(json.dumps(c,sort_keys=True,separators=(',',':')).encode()).hexdigest(),
                            'scope':'dispatch-to-wait includes device compute/DMA/stalls/runtime polling and host overhead; not device transfer time; no measured physical traffic'}
                        write(case_dir/'sample.json',sample);log.write(json.dumps(sample,separators=(',',':'))+'\n');log.flush()
                        samples+=1;worst=max(worst,checks['unrounded_f64']['max_abs'])
                        assert all(x['passed'] for x in checks.values()),'independent numerical failure'
                        (out/'attempt-in-progress.json').unlink()
                        print(json.dumps({'case':c['id'],'seed':seed,'repeat':repeat,'runner_wall_ns':end-begin,'passed':True}),flush=True)
    finally:
        multilaunch._wait=original_wait
        for p in runners:p['runner'].unload()
    write(out/'summary.json',{'schema':'orbit.device-transfer.measurement.v15','status':'passed','samples':samples,'actual_submissions':samples,'max_abs_f64':worst,
        'full_profile_loop_boundary':'includes constructors, BO preparation, input/reference generation, numerical validation and evidence I/O; distinct from per-run timers',
        'full_profile_loop_ns':time.perf_counter_ns()-start_loop,'numeric_tolerance':{'atol':1e-5,'rtol':1e-5},'active_contexts':len(runners),
        'device_transfer_latency_ns':None,'physical_bytes':None,'source_sha256':SOURCE_SHA})

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--protocol',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--validate-only',action='store_true');a=p.parse_args()
    assert not a.output.exists(),'NEW output required'
    protocol=read(a.protocol);records=validate(protocol);a.output.mkdir(parents=True)
    (a.output/'runner-source.py').write_bytes(SOURCE_BYTES);shutil.copyfile(a.protocol,a.output/'protocol.json')
    write(a.output/'identity.json',{'schema':'orbit.device-transfer.identity.v15','protocol':ident(a.protocol),'source_sha256':SOURCE_SHA,'device_open_requested':not a.validate_only,'successful_constructors_recorded_in':'preparation-CASE.json','cases':[c for c,_,_ in records]})
    if a.validate_only:
        write(a.output/'summary.json',{'status':'validated','cases':len(records),'device_submissions':0});return
    with open('/tmp/npu.lock','w') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX);execute(protocol,records,a.output)

if __name__=='__main__':main()
