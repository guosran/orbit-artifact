#!/usr/bin/env python3
"""Protocol-driven sync state/boundary measurements. No model or planner.

Only explicit invocation opens a device. --validate-only is stdlib-only. Existing
compiled NPU programs are replayed through the installed runner; no new kernel,
runtime, source transformation, or CPU numerical fallback is generated.
"""
import argparse
import fcntl
import hashlib
import importlib.util
import json
import random
from pathlib import Path
import sys
import time

SOURCE_BYTES=Path(__file__).read_bytes()
SOURCE_SHA256=hashlib.sha256(SOURCE_BYTES).hexdigest()
MODES={'minimal','detailed','batch'}
FORMS={'whole-implicit','whole-explicit','region-explicit'}
STATES={'first-initialized','unchanged-repeat','cpu-modified-range','cpu-read-range','before-device-read','after-device-read'}


def sha(p):
    h=hashlib.sha256()
    with Path(p).open('rb') as stream:
        for b in iter(lambda:stream.read(1024*1024),b''):h.update(b)
    return h.hexdigest()

def save(p,v):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(v,indent=2,allow_nan=False)+'\n')
def need(c,m):
    if not c:raise ValueError(m)
def identity(p):return dict(path=str(Path(p).resolve()),sha256=sha(p))


def load_protocol(path,split):
    path=Path(path).resolve();p=json.loads(path.read_text())
    need(p['schema']=='orbit.sync-state.protocol.v14','unsupported protocol schema')
    need(split in ('exploration','calibration','holdout'),'unsupported split')
    for role in ('observer','executor'):
        r=p[role];need(Path(r['path']).is_absolute() and sha(r['path'])==r['sha256'],'changed frozen '+role)
    need(p['seeds'] and len(set(p['seeds']))==len(p['seeds']) and all(type(s) is int for s in p['seeds']),'invalid seed registry')
    cases={c['name']:c for c in p.get('program_cases',[])}
    need(len(cases)==len(p.get('program_cases',[])),'duplicate program case')
    names=set()
    for c in p['cells']:
        need(c['id'] not in names,'duplicate cell id');names.add(c['id'])
        need(c['split'] in ('exploration','calibration','holdout'),'invalid cell split')
        need(c['invocation_form'] in FORMS and c['observer_mode'] in MODES and c['state'] in STATES,'unsupported form/observer/state')
        need(c['direction'] in ('TO_DEVICE','FROM_DEVICE'),'invalid sync direction')
        for k in ('bo_bytes','size_bytes','sequence_count','repeats'):
            need(type(c[k]) is int and c[k]>0,'positive integer required: '+k)
        need(type(c['warmups']) is int and c['warmups']>=0,'invalid warmups')
        need(type(c['offset_bytes']) is int and c['offset_bytes']>=0 and c['offset_bytes']+c['size_bytes']<=c['bo_bytes'],'sync range outside BO')
        need(c['offset_bytes']%64==0 and c['size_bytes']%64==0,'sync range requires protocol 64-byte alignment')
        if c['invocation_form']!='region-explicit':need(c['offset_bytes']==0 and c['size_bytes']==c['bo_bytes'],'whole invocation must cover whole BO')
        if c['state'] in ('cpu-modified-range','cpu-read-range','before-device-read'):
            need(type(c['dirty_offset_bytes']) is int and type(c['dirty_size_bytes']) is int and c['dirty_offset_bytes']>=0 and c['dirty_size_bytes']>0 and c['dirty_offset_bytes']+c['dirty_size_bytes']<=c['bo_bytes'],'invalid host dirty range')
            need(c['dirty_offset_bytes']%64==0 and c['dirty_size_bytes']%64==0,'dirty range requires protocol alignment')
        if c.get('program_case'):
            need(c['program_case'] in cases and c.get('target_storage','A')=='A','unsupported program target')
            need(len(cases[c['program_case']]['inputs'])==len(cases[c['program_case']]['reference'])==len(p['seeds']),'program seed archives differ')
            compiled=json.loads(Path(cases[c['program_case']]['compiled']).read_text());manifest=json.loads(Path(compiled['manifest']).read_text())
            need(sha(compiled['manifest'])==compiled['manifest_sha256'],'compiled native manifest changed')
            need(len(manifest['regions'])==1 and manifest['regions'][0]['device']=='npu' and len(manifest['regions'][0]['tasks'])==3,'requires existing full three-task single NPU region')
            target=next(v for v in manifest['storage'] if v['name']=='A')
            need(target['role']=='input' and target['bytes']==c['bo_bytes'],'target input A BO size differs')
            need(not(c['state']=='cpu-modified-range' and c['direction']=='FROM_DEVICE'),'CPU dirty device-delivery verification requires TO_DEVICE')
        else:need(c['state'] not in ('before-device-read','after-device-read'),'device-use state needs actual compiled program')
    cells=[c for c in p['cells'] if c['split']==split]
    need(cells,'split has no cells')
    # Split filtering precedes every runtime import, construction and measurement.
    return p,cells


def sync_arguments(cell,direction):
    return (direction,) if cell['invocation_form']=='whole-implicit' else (direction,cell['size_bytes'],cell['offset_bytes'])


def measure_calls(raw,arguments,count,mode,observed_class=None):
    """Same prebound callable/positional tuple; precise inner and outer scopes."""
    events=[]
    target=observed_class(raw,events,0) if mode=='detailed' else raw
    operation=target.sync  # Hoisted once, outside all measured clocks.
    per_call=[None]*count if mode!='batch' else None
    begin=time.perf_counter_ns()
    if mode=='batch':
        for _ in range(count):operation(*arguments)
    else:
        for index in range(count):
            start=time.perf_counter_ns();operation(*arguments);end=time.perf_counter_ns()
            per_call[index]=(start,end)  # Recording outside the per-call envelope.
    end=time.perf_counter_ns()
    need(mode!='detailed' or len(events)==count,'detailed observer event count differs')
    return dict(start_ns=begin,end_ns=end,outer_sequence_ns=end-begin,
        per_call_envelopes=None if per_call is None else [dict(index=i,start_ns=a,end_ns=b,elapsed_ns=b-a) for i,(a,b) in enumerate(per_call)],
        detailed_inner_events=events if mode=='detailed' else None,
        actual_api_call_count=count,api_argument_count=len(arguments),
        callable_policy='prebound sync method and prebuilt positional arguments; no kwargs; lookup outside clocks',
        boundaries=dict(minimal='timer immediately around prebound raw sync(*args); record assignment after end timer',
            detailed='outer envelope around exact frozen ObservedBO.sync; inner event includes its original enum-string/forwarding work; outer additionally includes append/return',
            batch='one timer around Python loop plus raw sync calls; no per-call durations or API-only sum inferred'),
        physical_transfer_count=None,physical_bytes=None)


def state_journal(cell,count,baseline):
    records=[]
    for i in range(count):
        before=baseline if i==0 else 'after-'+cell['direction']+'-sync'
        records.append(dict(api_index=i,state_before=before,state_after='after-'+cell['direction']+'-sync',
            sync_range=dict(offset=cell['offset_bytes'],bytes=cell['size_bytes']),
            dirty_range=dict(offset=cell.get('dirty_offset_bytes',0),bytes=cell.get('dirty_size_bytes',0)) if i==0 and cell['state']=='cpu-modified-range' else None,
            meaning='operational event history only; not a physical cache/DRAM state'))
    return records


def empty_controls(protocol):
    records=[]
    noop=lambda:None
    enum=protocol['_enum_control']
    for name in protocol.get('empty_controls',[]):
        for repeat in range(max(c['warmups']+c['repeats'] for c in protocol['cells'])):
            if name=='timer-pair':
                start=time.perf_counter_ns();end=time.perf_counter_ns()
            elif name=='noop-prebound-call':
                start=time.perf_counter_ns();noop();end=time.perf_counter_ns()
            elif name=='enum-str-conversion':
                start=time.perf_counter_ns();str(enum);end=time.perf_counter_ns()
            else:raise ValueError('unknown empty control')
            records.append(dict(control=name,repeat=repeat,start_ns=start,end_ns=end,elapsed_ns=end-start,
                enum_direction='TO_DEVICE' if name=='enum-str-conversion' else None,
                scope='control selection outside clock; diagnostic only, no automatic subtraction'))
    return records


def import_file(path,name):
    path=Path(path).resolve();sys.path.insert(0,str(path.parent))
    spec=importlib.util.spec_from_file_location(name,path);module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module


def standalone(cell,seed,repeat,xrt,device,observer):
    import numpy as np
    setup_start=time.perf_counter_ns();bo=xrt.ext.bo(device,cell['bo_bytes']);mapping=bo.map();array=np.frombuffer(mapping,dtype=np.uint8,count=cell['bo_bytes'])
    array.fill((seed+repeat)%251);actual_size=int(bo.size());need(actual_size==cell['bo_bytes'],'BO size differs from requested before timing');setup_end=time.perf_counter_ns()
    direction=getattr(xrt.xclBOSyncDirection,'XCL_BO_SYNC_BO_'+cell['direction'])
    setup=[dict(kind='new-ext-bo-map-initialize',start_ns=setup_start,end_ns=setup_end,bytes=cell['bo_bytes'])]
    # Fresh BO per sample is intentional; initialization is excluded from clocks.
    baseline='initialized-host-written'
    if cell['state']=='unchanged-repeat':
        t=time.perf_counter_ns();bo.sync(*sync_arguments(cell,direction));setup.append(dict(kind='untimed-prior-sync',start_ns=t,end_ns=time.perf_counter_ns(),argument_count=len(sync_arguments(cell,direction))))
        baseline='after-'+cell['direction']+'-sync'
    if cell['state'] in ('cpu-read-range','cpu-modified-range'):
        t=time.perf_counter_ns();bo.sync(xrt.xclBOSyncDirection.XCL_BO_SYNC_BO_TO_DEVICE)
        setup.append(dict(kind='untimed-prior-TO-before-host-range-action',start_ns=t,end_ns=time.perf_counter_ns(),argument_count=1,bytes=cell['bo_bytes']))
    if cell['state']=='cpu-read-range':
        start=cell['dirty_offset_bytes'];end=start+cell['dirty_size_bytes'];t=time.perf_counter_ns();checksum=int(array[start:end].sum(dtype=np.uint64))
        setup.append(dict(kind='untimed-host-read-range',start_ns=t,end_ns=time.perf_counter_ns(),offset=start,bytes=end-start,checksum=checksum));baseline='host-read-range'
    if cell['state']=='cpu-modified-range':
        start=cell['dirty_offset_bytes'];end=start+cell['dirty_size_bytes'];t=time.perf_counter_ns();array[start:end].fill((seed+repeat+73)%251)
        setup.append(dict(kind='untimed-host-write-range',start_ns=t,end_ns=time.perf_counter_ns(),offset=start,bytes=end-start));baseline='host-modified-range'
    result=measure_calls(bo,sync_arguments(cell,direction),cell['sequence_count'],cell['observer_mode'],observer.ObservedBO)
    result.update(setup=setup,state_transitions=state_journal(cell,cell['sequence_count'],baseline),
        bo=dict(type='pyxrt.ext.bo',requested_bytes=cell['bo_bytes'],actual_size=actual_size,mapped_address=int(array.ctypes.data)),
        actual_sync_extent=dict(offset=cell['offset_bytes'],bytes=cell['size_bytes'],implicit_uses_verified_whole_bo=cell['invocation_form']=='whole-implicit'),
        content_scope='no independent device producer or numeric-content claim for standalone FROM_DEVICE')
    return result


def dispatch(prepared,target_storage,device_truth,expected_b,directory,reason):
    """Run actual existing ELF with target A auto-TO explicitly suppressed."""
    import numpy as np
    observer=prepared._v14_observer;events=prepared.events;events.clear()
    raw=prepared.bos[target_storage].raw
    class PriorSyncFacade(observer.ObservedBO):
        def sync(self,direction,*args,**kwargs):
            if 'TO_DEVICE' in str(direction):
                t=time.perf_counter_ns();events.append(dict(kind='skipped_auto_to_A',start_ns=t,end_ns=t,
                    storage=target_storage,reason='explicit sync and frozen device-truth baseline own A visibility; no hidden full TO allowed',actual_api_call=False));return None
            return super().sync(direction,*args,**kwargs)
    if not hasattr(prepared,'_v14_target_facade'):
        prepared._v14_target_facade=PriorSyncFacade(raw,events,target_storage)
    facade=prepared._v14_target_facade
    need(facade.raw is raw and facade.events is events,'cached target facade binding changed')
    region=prepared.manifest['regions'][0];abi=region['npu_abi'];arrays=[prepared.arrays[a['storage']] for a in abi]
    buffers={a['argument']:facade if a['storage']==target_storage else prepared.bos[a['storage']] for a in abi}
    original_wait=prepared.module._wait
    def wait(run):
        begin=time.perf_counter_ns()
        try:return original_wait(run.raw if isinstance(run,observer.ObservedRun) else run)
        finally:events.append(dict(kind='actual_xrt_wait',start_ns=begin,end_ns=time.perf_counter_ns()))
    original_copy=np.copyto;staging=[]
    def copy(*args,**kwargs):
        staging.append(int(getattr(args[0],'nbytes',0)));return original_copy(*args,**kwargs)
    prepared.module._wait=wait;np.copyto=copy
    try:prepared.runners[0].run(arrays,bo_key='v14-readonly-A',bound_buffers=buffers,output_indices={a['argument'] for a in abi if a['role']=='output'})
    finally:prepared.module._wait=original_wait;np.copyto=original_copy
    need(not staging,'existing bound runner unexpectedly staged host data')
    need(sum(e['kind']=='skipped_auto_to_A' for e in events)==1,'target A auto-TO was not intercepted exactly once')
    for event in events:
        event['region']=0
        if 'buffer_index' in event:event['storage']=event.pop('buffer_index')
    expected=(2*(device_truth.astype(np.float64)+expected_b.astype(np.float64))+expected_b.astype(np.float64)).astype(np.float32)
    output_storage=next(s['index'] for s in prepared.manifest['storage'] if s['role']=='output');actual=prepared.arrays[output_storage].copy()
    delta=np.abs(actual.astype(np.float64)-expected.astype(np.float64));passed=bool(np.isfinite(actual).all() and np.all(delta<=1e-5+1e-5*np.abs(expected)))
    directory.mkdir(parents=True,exist_ok=False);np.savez(directory/'outputs.npz',C=actual);np.savez(directory/'reference.npz',C=expected)
    record=dict(reason=reason,passed=passed,max_abs=float(delta.max()),events=list(events),runner_staging_copy_count=len(staging),
        target_auto_to_skipped=True,target_A_device_truth='explicit baseline plus measured TO range updates only; auto runner TO A suppressed',
        outputs=identity(directory/'outputs.npz'),reference=identity(directory/'reference.npz'))
    save(directory/'result.json',record);need(passed,'actual NPU partial-sync delivery validation failed')
    return record


def program_sample(cell,seed_index,seed,repeat,case,prepared,observer,directory):
    import numpy as np
    prepared._v14_observer=observer
    target=next(s['index'] for s in prepared.manifest['storage'] if s['name']=='A');raw=prepared.bos[target].raw
    with np.load(case['inputs'][seed_index],allow_pickle=False) as source:
        original_a=source['A'].copy();b=source['B'].copy()
        for s in prepared.manifest['storage']:
            if s['index'] in prepared.arrays:
                if s['role']=='input':np.copyto(prepared.arrays[s['index']],source[s['name']],casting='no')
                else:prepared.arrays[s['index']].fill(np.nan)
    # Establish real device baseline, outside target timing, before partial updates.
    setup_start=time.perf_counter_ns();raw.sync(prepared.xrt.xclBOSyncDirection.XCL_BO_SYNC_BO_TO_DEVICE);setup_end=time.perf_counter_ns()
    setup_events=[dict(kind='ExplicitBaselineSync',direction='TO_DEVICE',start_ns=setup_start,end_ns=setup_end,argument_count=1,bytes=cell['bo_bytes'])]
    need(int(raw.size())==cell['bo_bytes'],'target BO size differs before measurement')
    device_truth=original_a.copy();host_shadow=original_a.copy();runs=[]
    if cell['state']=='after-device-read':
        runs.append(dispatch(prepared,target,device_truth,b,directory/'prior-device-read','prior-device-read'))
        setup_events.append(dict(kind='DeviceReadComplete',storage=target,readonly=True,actual_waits=[e for e in runs[-1]['events'] if e['kind']=='actual_xrt_wait']))
    if cell['state'] in ('cpu-modified-range','before-device-read'):
        byte_view=prepared.arrays[target].reshape(-1);first=cell['dirty_offset_bytes']//4;count=cell['dirty_size_bytes']//4
        write_start=time.perf_counter_ns();byte_view[first:first+count]=np.float32(.125+(seed%17)*.015625)
        host_shadow.reshape(-1)[first:first+count]=np.float32(.125+(seed%17)*.015625)
        setup_events.append(dict(kind='HostWrite',storage=target,start_ns=write_start,end_ns=time.perf_counter_ns(),offset_bytes=cell['dirty_offset_bytes'],size_bytes=cell['dirty_size_bytes']))
    direction=getattr(prepared.xrt.xclBOSyncDirection,'XCL_BO_SYNC_BO_'+cell['direction'])
    # Prepare the independent expected-device shadow before timing; do not touch
    # target host A after sync or after readonly device use to construct a reference.
    if cell['direction']=='TO_DEVICE':
        first=cell['offset_bytes']//4;count=cell['size_bytes']//4
        device_truth.reshape(-1)[first:first+count]=host_shadow.reshape(-1)[first:first+count]
    measured=measure_calls(raw,sync_arguments(cell,direction),cell['sequence_count'],cell['observer_mode'],observer.ObservedBO)
    runs.append(dispatch(prepared,target,device_truth,b,directory/'verification','after-measured-sync'))
    mapped_address=getattr(prepared,'bo_map_addresses',{target:int(prepared.arrays[target].ctypes.data)})[target]
    need(mapped_address==int(prepared.arrays[target].ctypes.data),'target A array does not alias caller BO mapping')
    measured.update(actual_setup_events=setup_events,actual_dirty_range=None if cell['state']=='after-device-read' else dict(offset_bytes=cell['dirty_offset_bytes'],size_bytes=cell['dirty_size_bytes']),
        state_transitions=state_journal(cell,cell['sequence_count'],cell['state']),verification_runs=runs,
        baseline_sync=dict(direction='TO_DEVICE',invocation_form='whole-implicit',bytes=cell['bo_bytes'],scope='explicit actual baseline sync outside timing'),
        target=dict(storage=target,readonly_input=True,array_address=int(prepared.arrays[target].ctypes.data),bo_map_address=int(mapped_address),aliases_bo=True),
        no_hidden_full_target_to_after_partial=True)
    return measured


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--protocol',type=Path,required=True);p.add_argument('--split',choices=['exploration','calibration','holdout'],required=True)
    p.add_argument('--output',type=Path,required=True);p.add_argument('--validate-only',action='store_true');a=p.parse_args()
    protocol,cells=load_protocol(a.protocol,a.split)
    helper_path=Path(__file__).with_name('collect_sync_target_v14.py')
    helper=import_file(helper_path,'v14_sync_target_collector')
    before=helper.collect_snapshot()
    expected=before
    if protocol.get('runtime_fingerprint'):
        binding=protocol['runtime_fingerprint']
        need(sha(binding['path'])==binding['sha256'],'frozen runtime fingerprint file changed')
        expected=json.loads(Path(binding['path']).read_text())
        need(before==expected,'current runtime files/config/cpu platform differ from frozen target')
    evidence_binding=protocol.get('api_path_evidence')
    if evidence_binding:
        need(sha(evidence_binding['path'])==evidence_binding['sha256'],'API path observation receipt changed')
        evidence=json.loads(Path(evidence_binding['path']).read_text())
        need(evidence['target_id']==expected['target_id'],'separate observed probe targets a different runtime fingerprint')
        for file,digest in evidence['files'].items():need(sha(file)==digest,'API path observation bytes changed')
    a.output=a.output.resolve();need(not a.output.exists(),'output must be new');a.output.mkdir(parents=True)
    save(a.output/'runtime-fingerprint-before.json',before)
    (a.output/'protocol.json').write_bytes(a.protocol.read_bytes());(a.output/'microbench-source.py').write_bytes(SOURCE_BYTES)
    metadata=dict(schema='orbit.sync-state.identity.v14',split=a.split,protocol=identity(a.protocol),source_sha256=SOURCE_SHA256,
        observer=protocol['observer'],executor=protocol['executor'],runtime_collector=identity(helper_path),
        runtime_target_id=before['target_id'],runtime_fingerprint_binding=protocol.get('runtime_fingerprint'),api_path_evidence=evidence_binding,cells=[c['id'] for c in cells],device_opened=False)
    save(a.output/'identity.json',metadata)
    if a.validate_only:
        after=helper.collect_snapshot();need(after==before,'target changed during CPU validation');save(a.output/'runtime-fingerprint-after.json',after)
        save(a.output/'summary.json',dict(status='validated',device_submissions=0,cells=len(cells)));return
    import pyxrt
    import numpy as np
    sys.path.insert(0,str(Path(protocol['observer']['path']).parent))
    observer=__import__('taskflow_npu_trace_v3')
    need(Path(observer.__file__).resolve()==Path(protocol['observer']['path']).resolve() and sha(observer.__file__)==protocol['observer']['sha256'],'canonical observer module differs')
    executor=import_file(protocol['executor']['path'],'v14_frozen_executor')
    need(executor.EXECUTOR_SOURCE_SHA256==protocol['executor']['sha256'],'loaded executor bytes differ')
    from triton.backends.amd_triton_npu import multilaunch
    program_inputs={}
    for c in protocol.get('program_cases',[]):
        if not any(v.get('program_case')==c['name'] for v in cells):continue
        compiled=json.loads(Path(c['compiled']).read_text())
        paths=[c['compiled'],compiled['manifest'],*c['inputs'],*c['reference']]
        program_inputs[c['name']]=[identity(v) for v in paths]
    metadata.update(program_input_identities=program_inputs,device_opened=True,pyxrt=identity(pyxrt.__file__),numpy_version=np.__version__,
        installed_runner=identity(multilaunch.__file__),python=sys.version,clock='perf_counter_ns/CLOCK_MONOTONIC',
        observation_policy='same frozen ObservedBO class identity as existing ObservedRun.set_arg; no replacement runtime');save(a.output/'identity.json',metadata)
    completed=0;submissions=0;prepared={};cases={c['name']:c for c in protocol.get('program_cases',[])}
    schedule=[]
    for seed_index,seed in enumerate(protocol['seeds']):
        for repeat in range(max(c['warmups']+c['repeats'] for c in cells)):
            active=[c for c in cells if repeat<c['warmups']+c['repeats']]
            random.Random(protocol['order']['seed']+seed*1000003+repeat).shuffle(active)
            schedule.append(dict(seed=seed,seed_index=seed_index,repeat=repeat,cells=[c['id'] for c in active]))
    save(a.output/'schedule.json',schedule)
    cell_by_id={c['id']:c for c in cells}
    try:
        with open('/tmp/npu.lock','w') as lock:
            fcntl.flock(lock,fcntl.LOCK_EX);device=pyxrt.device(0)
            metadata['device_bdf']=str(device.get_info(pyxrt.xrt_info_device.bdf));save(a.output/'identity.json',metadata)
            control_protocol=dict(protocol,_enum_control=pyxrt.xclBOSyncDirection.XCL_BO_SYNC_BO_TO_DEVICE)
            controls=empty_controls(control_protocol)
            save(a.output/'empty-controls.json',controls)
            for order in schedule:
                seed_index,seed,repeat=order['seed_index'],order['seed'],order['repeat']
                for cell_id in order['cells']:
                    cell=cell_by_id[cell_id]
                    if cell.get('program_case') and cell['program_case'] not in prepared:
                        prep_start=time.perf_counter_ns();item=executor.Prepared(cases[cell['program_case']]['compiled']);prep_end=time.perf_counter_ns()
                        prepared[cell['program_case']]=item
                        save(a.output/'program-preparation'/ (cell['program_case']+'.json'),dict(compiled=identity(item.compiled_path),manifest=identity(item.path),
                            runtime=item.runtime_identity,pointers=item.pointer_identity,abi_pointer_proof=item.abi_pointer_proof,
                            start_ns=prep_start,end_ns=prep_end,scope='cold preparation outside sync measurement; constructor/import/hash work not isolated',
                            sources=[identity(Path(item.path).parent/r['source']) for r in item.manifest['regions']],
                            elf=[identity(r['artifact']['elf_path']) for r in item.compiled['regions']]))
                    directory=a.output/'samples'/cell['id']/f'seed-{seed}'/f'repeat-{repeat}'
                    if cell.get('program_case'):
                        result=program_sample(cell,seed_index,seed,repeat,cases[cell['program_case']],prepared[cell['program_case']],observer,directory)
                    else:result=standalone(cell,seed,repeat,pyxrt,device,observer)
                    result.update(cell_id=cell['id'],cell=cell,split=a.split,seed=seed,seed_index=seed_index,repeat=repeat,warmup=repeat<cell['warmups'],unit='ns')
                    save(directory/'sample.json',result)
                    count=sum(e['kind']=='actual_xrt_start' for r in result.get('verification_runs',[]) for e in r['events'])
                    submissions+=count;completed+=1
                    with (a.output/'samples-index.jsonl').open('a') as stream:
                        stream.write(json.dumps(dict(cell_id=cell['id'],seed=seed,repeat=repeat,sample=identity(directory/'sample.json')))+'\n')
                save(a.output/'checkpoint.json',dict(completed_samples=completed,actual_npu_submissions=submissions,last_completed_round=order))
        after=helper.collect_snapshot();need(after==before,'runtime files/config/cpu platform changed during measurements');save(a.output/'runtime-fingerprint-after.json',after)
        save(a.output/'summary.json',dict(status='passed',samples=completed,actual_npu_submissions=submissions,physical_transfer_count=None,
            physical_bandwidth_measured=False,model_fitted=False,timing_claim='host API envelopes and sequence walls only; exact observer/form/state keys retained'))
    except Exception as error:
        save(a.output/'failure.json',dict(status='failed',message=str(error),completed_samples=completed,no_fallback=True));raise
    finally:
        for item in prepared.values():item.close()

if __name__=='__main__':main()
