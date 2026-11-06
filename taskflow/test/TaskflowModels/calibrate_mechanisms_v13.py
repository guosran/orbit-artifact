#!/usr/bin/env python3
"""Training-only mechanism API calibration; no program cost fitting or planning."""
import argparse
from collections import defaultdict
import hashlib
import json
import math
from pathlib import Path
import statistics
import numpy as np

SCHEMA='orbit.mechanism-cost-parameters.v13'


def sha(p):
    h=hashlib.sha256()
    with Path(p).open('rb') as f:
        for b in iter(lambda:f.read(1024*1024),b''):h.update(b)
    return h.hexdigest()

def read(p):return json.loads(Path(p).read_text())
def need(c,m):
    if not c:raise ValueError(m)
def identity(p):return dict(path=str(Path(p).resolve()),sha256=sha(p))
def save(p,v):p.write_text(json.dumps(v,indent=2,allow_nan=False)+'\n')

def nnls_two(samples,alpha_only=False):
    """Exact two-variable NNLS candidate enumeration on raw sequence API sums."""
    need(bool(samples) and all(type(s['count']) is int and s['count']>0 and type(s['bytes']) is int and s['bytes']>=0 and
         isinstance(s['api_ms'],(int,float)) and not isinstance(s['api_ms'],bool) for s in samples),'invalid sample types')
    y=np.array([s['api_ms'] for s in samples],dtype=np.float64)
    counts=np.array([s['count'] for s in samples],dtype=np.float64)
    sizes=np.array([s['bytes'] for s in samples],dtype=np.float64)
    need(len(y)>0 and np.isfinite(y).all() and (y>=0).all(),'invalid API duration')
    need(np.isfinite(counts).all() and (counts>0).all() and np.isfinite(sizes).all() and (sizes>=0).all(),'invalid mechanism features')
    per_call=y/counts
    noise=statistics.median(abs(v-statistics.median(per_call.tolist())) for v in per_call)
    if alpha_only:
        alpha=max(0.0,float(np.dot(counts,y)/np.dot(counts,counts)))
        residual=y-counts*alpha
        return dict(status='calibrated' if alpha>0 else 'uncalibrated',alpha_ms=alpha,beta_ms_per_byte=0.0,
            fit='one-parameter nonnegative least squares on actual start API sums',rank=1,
            residual_rmse_ms=float(np.sqrt(np.mean(residual**2))),squared_error_ms2=float(np.dot(residual,residual)),
            per_call_mad_ms=float(noise),beta_resolution='fixed zero; no byte-dependent submit claim')
    scale=max(float(np.max(sizes)),1.0)
    design=np.column_stack([counts,counts*sizes/scale])
    rank=int(np.linalg.matrix_rank(design))
    if rank<2:
        return dict(status='uncalibrated',reason='size-independent observations cannot identify two coefficients',rank=rank,
                    alpha_ms=None,beta_ms_per_byte=None,per_call_mad_ms=float(noise))
    candidates=[]
    unconstrained=np.linalg.lstsq(design,y,rcond=None)[0]
    if bool(np.all(unconstrained>=0)):candidates.append(('interior',unconstrained))
    candidates.extend([('beta=0',np.array([max(0.0,float(np.dot(design[:,0],y)/np.dot(design[:,0],design[:,0]))),0.0])),
        ('alpha=0',np.array([0.0,max(0.0,float(np.dot(design[:,1],y)/np.dot(design[:,1],design[:,1])))])),
        ('zero',np.zeros(2))])
    name,coef=min(candidates,key=lambda c:float(np.sum((design@c[1]-y)**2)))
    residual=design@coef-y;alpha,beta=float(coef[0]),float(coef[1]/scale)
    # Compare fitted byte signal with within-cell per-call noise, not total work variation.
    cells=defaultdict(list)
    for sample in samples:cells[(sample['bytes'],sample['count'])].append(sample['api_ms']/sample['count'])
    deviations=[abs(v-statistics.median(vs)) for vs in cells.values() for v in vs]
    within_noise=statistics.median(deviations)
    signal=beta*(float(np.max(sizes))-float(np.min(sizes)))
    return dict(status='calibrated' if alpha+beta>0 else 'uncalibrated',alpha_ms=alpha,beta_ms_per_byte=beta,
        fit='two-parameter nonnegative least squares; interior and both nonnegative boundary solutions enumerated',
        active_solution=name,rank=rank,scaled_design_condition=float(np.linalg.cond(design)),
        residual_rmse_ms=float(np.sqrt(np.mean(residual**2))),squared_error_ms2=float(np.dot(residual,residual)),
        per_call_mad_ms=float(noise),within_cell_per_call_mad_ms=float(within_noise),byte_signal_over_training_range_ms=signal,
        beta_resolution='unresolved-at-observed-noise' if beta==0 or signal<=2*within_noise else 'nonzero within this API/state experiment; not physical bandwidth')


def load_training(protocol_path,root):
    """Reject heldout run identity before opening any sample label file."""
    protocol_path=Path(protocol_path).resolve();root=Path(root).resolve();protocol=read(protocol_path)
    need(protocol['schema']=='orbit.mechanism.microbench-protocol.v13','wrong protocol schema')
    frozen=read(protocol_path.parent/'freeze.json')
    need(frozen['protocol_sha256']==sha(protocol_path),'frozen protocol SHA mismatch')
    run=read(root/'identity.json')
    need(run.get('split')=='training','training fitter refuses holdout or unspecified run identity')
    need(run['protocol_sha256']==sha(protocol_path)==sha(root/'protocol.json'),'run protocol differs')
    need(sha(root/'microbench-source.py')==run['microbench_sha256'],'microbench source snapshot differs')
    need(run['executor']==protocol['executor'],'executor binding differs')
    need(sha(protocol['executor']['path'])==protocol['executor']['sha256'],'frozen executor changed')
    for prefix in ('pyxrt','multilaunch'):
        need(sha(run[prefix+'_path'])==run[prefix+'_sha256'],'actual runtime source changed: '+prefix)
    memory_path=root/'memory-samples.json';program_path=root/'program-samples.json'
    memory=read(memory_path);groups=defaultdict(list);excluded=defaultdict(int)
    mechanisms=set(protocol['copy_paths'])|{'bo-sync-'+d for d in protocol['directions']}|{'timer-empty'}
    for index,s in enumerate(memory):
        need(s['split']=='training','mixed/heldout sample in training input')
        need(s['mechanism'] in mechanisms and s['state'] in protocol['states'],'undeclared mechanism/state')
        need(type(s['count']) is int and s['count'] in protocol['train']['counts'],'undeclared training count')
        if s['mechanism']!='timer-empty':need(s['bytes_per_call'] in protocol['train']['sizes_bytes'],'undeclared training byte size')
        need(type(s['repeat']) is int and 0<=s['repeat']<protocol['warmups']+protocol['repeats'],'undeclared repeat')
        need(s['warmup']==(s['repeat']<protocol['warmups']),'warmup differs from frozen protocol')
        events=s['api_events'];need(len(events)==s['count'],'API count mismatch')
        last=s['start_ns']
        for ordinal,e in enumerate(events):
            need(e['index']==ordinal and last<=e['start_ns']<=e['end_ns']<=s['end_ns'],'invalid API interval')
            need(e['elapsed_ns']==e['end_ns']-e['start_ns'],'API elapsed span differs');last=e['end_ns']
        api=sum(e['elapsed_ns'] for e in events)
        need(s['api_total_ns']==api and s['outer_sequence_ns']==s['end_ns']-s['start_ns']>=api,'API sum/outer wall mismatch')
        if s['warmup'] or s['mechanism']=='timer-empty':excluded[s['mechanism']]+=1;continue
        if s['mechanism'].startswith('bo-sync-'):
            direction=s['mechanism'][len('bo-sync-'):]
            for ordinal,event in enumerate(events):
                state=s['state'] if ordinal==0 else 'after-'+direction+'-sync'
                groups[(s['mechanism'],state)].append(dict(bytes=s['bytes_per_call'],count=1,api_ms=event['elapsed_ns']/1e6,
                    outer_ms=None,raw=dict(file=identity(memory_path),sample_index=index,api_index=ordinal)))
        else:
            groups[(s['mechanism'],s['state'])].append(dict(bytes=s['bytes_per_call'],count=s['count'],api_ms=api/1e6,
                outer_ms=s['outer_sequence_ns']/1e6,raw=dict(file=identity(memory_path),sample_index=index)))
    cases={c['name']:c for c in protocol['program_cases']}
    programs=read(program_path)
    for index,s in enumerate(programs):
        need(s['split']=='training' and cases[s['case']]['split']=='training','heldout program sequence in training file')
        need(s['count'] in protocol['train']['counts'] and len(s['calls'])==s['count'],'undeclared program count')
        need(s['warmup']==(s['repeat']<protocol['program_warmups']),'program warmup differs')
        starts=[];from_syncs=[];host_events=defaultdict(list)
        compiled=read(cases[s['case']]['compiled']);manifest=read(compiled['manifest'])
        need(sha(compiled['manifest'])==compiled['manifest_sha256'],'program manifest changed')
        for call in s['calls']:
            # Never use the program wall, wait or CPU duration as a fitting label.
            evidence=Path(call['evidence']).resolve()
            need(root in evidence.parents,'program evidence outside training run')
            actual=read(evidence)
            need(actual['passed'] is True and actual['events']==call['events'],'program API record differs from passing raw call')
            starts.extend(e for e in call['events'] if e['kind']=='actual_xrt_start')
            for event in call['events']:
                if event['kind']=='host_input_reset':
                    storage=manifest['storage'][event['storage']]
                    need(storage['role']=='input' and storage['bytes']==event['bytes'],'input reset native storage mismatch')
                    route='numpy-to-mapped-bo' if storage['realization']=='xrt-mapped-bo' else 'numpy-to-host'
                    host_events['program-host-input-reset.'+route].append(event)
                if event['kind']=='host_final_output_copy':
                    outputs=[v for v in manifest['storage'] if v['role']=='output']
                    need(len(outputs)==1 and outputs[0]['bytes']==event['bytes'],'final acquisition needs exact single native output')
                    route='mapped-bo-to-numpy' if outputs[0]['realization']=='xrt-mapped-bo' else 'host-to-numpy'
                    host_events['program-final-output-acquisition.'+route].append(event)
            for event in call['events']:
                if event['kind']!='actual_bo_sync' or 'FROM_DEVICE' not in event['direction']:continue
                region=manifest['regions'][event['region']]
                need(region['device']=='npu' and any(a['storage']==event['storage'] and a['role']=='output' for a in region['npu_abi']),'FROM sync lacks native device output ABI')
                waits=[e for e in call['events'] if e['kind']=='actual_xrt_wait' and e['region']==event['region']]
                need(len(waits)==1 and waits[0]['end_ns']<=event['start_ns']<=event['end_ns'],'FROM sync not after actual device completion')
                from_syncs.append(dict(bytes=manifest['storage'][event['storage']]['bytes'],api_ms=(event['end_ns']-event['start_ns'])/1e6))
        if s['warmup']:continue
        for mechanism,events in host_events.items():
            need(len({e['bytes'] for e in events})==1 and all(e['end_ns']>=e['start_ns'] for e in events),'inconsistent host mechanism byte sizes/intervals')
            groups[(mechanism,'prepared-hot')].append(dict(bytes=events[0]['bytes'],count=len(events),
                api_ms=sum(e['end_ns']-e['start_ns'] for e in events)/1e6,outer_ms=None,
                runtime_identity=manifest['execution_contract_identity'],raw=dict(file=identity(program_path),sample_index=index)))
        if from_syncs:
            need(len(from_syncs)==s['count'] and len({v['bytes'] for v in from_syncs})==1,'FROM calibration requires one equal-size output sync per call')
            groups[('actual-bo-sync-FROM_DEVICE','device-completed')].append(dict(bytes=from_syncs[0]['bytes'],count=len(from_syncs),
                api_ms=sum(v['api_ms'] for v in from_syncs),outer_ms=None,runtime_identity=manifest['execution_contract_identity'],raw=dict(file=identity(program_path),sample_index=index)))
        if starts:
            # Frozen training program cases full-NPU have one actual submit per call.
            need(len(starts)==s['count'],'submission calibration requires one actual start per program call')
            api=0
            for e in starts:
                need(e['end_ns']>=e['start_ns'],'negative start interval');api+=e['end_ns']-e['start_ns']
            groups[('actual-xrt-start','prepared-hot-bound-bo')].append(dict(bytes=0,count=len(starts),api_ms=api/1e6,
                outer_ms=None,runtime_identity=manifest['execution_contract_identity'],raw=dict(file=identity(program_path),sample_index=index)))
    return protocol,run,groups,dict(excluded)


def calibrate(protocol_path,root,bindings_path):
    protocol,run,groups,excluded=load_training(protocol_path,root)
    binding=read(bindings_path)
    need(binding['schema']=='orbit.mechanism.calibration-bindings.v13','wrong binding schema')
    need(binding['protocol_sha256']==sha(protocol_path),'binding protocol differs')
    parameters=[];diagnostics=[];seen=set()
    for b in binding['bindings']:
        key=(b['raw_mechanism'],b.get('raw_state',b['state']));need(key not in seen,'duplicate calibration binding');seen.add(key)
        if key[1]!=b['state']:
            need(key[1]=='after-TO_DEVICE-sync' and b['state']=='host-visible-after-sync' and
                 isinstance(b.get('state_equivalence'),str) and bool(b['state_equivalence']),
                 'unapproved raw/public state substitution')
        need(key in groups,'binding has no measured hot training samples')
        samples=groups[key];is_start=key[0]=='actual-xrt-start'
        need(b['mechanism'] in ('host.input_reset','host.output_copy','bo.sync_to_device','bo.sync_from_device','npu.submit'),'opaque/non-mechanism fitting forbidden')
        need((b['mechanism']=='npu.submit')==is_start,'submission binding must use actual start observations only')
        need(all(not s.get('runtime_identity') or s['runtime_identity']==b['runtime_identity'] for s in samples),'program mechanism runtime binding differs')
        fit=nnls_two(samples,is_start)
        diagnostic=dict(binding=b,fit=fit,samples=len(samples),raw=[s['raw'] for s in samples],
            outer_residual_ms=None if any(s['outer_ms'] is None for s in samples) else dict(minimum=min(s['outer_ms']-s['api_ms'] for s in samples),
                median=statistics.median(s['outer_ms']-s['api_ms'] for s in samples),maximum=max(s['outer_ms']-s['api_ms'] for s in samples)))
        diagnostics.append(diagnostic)
        if fit['status']!='calibrated':continue
        for field in ('path','resource','boundary','runtime_identity'):
            need(isinstance(b.get(field),str) and b[field],'missing exact consumer binding '+field)
        raw_manifest_sha=hashlib.sha256(json.dumps(diagnostic['raw'],sort_keys=True,separators=(',',':')).encode()).hexdigest()
        parameters.append(dict(mechanism=b['mechanism'],path=b['path'],state=b['state'],resource=b['resource'],
            boundary=b['boundary'],runtime_identity=b['runtime_identity'],alpha_ms=fit['alpha_ms'],beta_ms_per_byte=fit['beta_ms_per_byte'],
            min_bytes=min(s['bytes'] for s in samples),max_bytes=max(s['bytes'] for s in samples),
            min_count=min(s['count'] for s in samples),max_count=max(s['count'] for s in samples),
            provenance='training-only mechanism API nonnegative least squares',
            measurement_boundary=b['boundary'],
            measurement_scope='sum of actual start API spans only' if is_start else 'sum of timed API spans only; declared actual state; outer loop overhead excluded without subtraction',
            raw_manifest_sha256=raw_manifest_sha))
    need(parameters,'no calibratable mechanism bindings')
    model=dict(schema=SCHEMA,parameters=parameters,protocol_identity=identity(protocol_path),bindings_identity=identity(bindings_path),
        training_identity=identity(Path(root)/'identity.json'),calibrator=identity(__file__),
        formula='T_sequence=count*(alpha_ms+beta_ms_per_byte*bytes)',
        units=dict(duration='milliseconds',bytes='requested bytes per API call; not measured physical traffic'),
        scope=dict(wait='opaque and not fitted',cpu_call='opaque and not fitted',internal_npu_dma='static descriptions only; no fitted bandwidth',
            whole_program_prediction=None,extrapolation='count7 is a preregistered additive-law holdout, not measured-count interpolation',
            timer_overhead_subtracted=False,outer_sequence_fitted=False,program_wall_fitted=False,physical_ddr_measurement=False))
    return model,dict(schema='orbit.mechanism.calibration-report.v13',status='passed',diagnostics=diagnostics,
        excluded_warmup_and_timer_samples=excluded,holdout_labels_read=False,parameters=len(parameters),
        unbound_measurement_groups=[list(k) for k in sorted(set(groups)-seen)])


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--protocol',type=Path,required=True)
    parser.add_argument('--training-root',type=Path,required=True)
    parser.add_argument('--bindings',type=Path,required=True,help='frozen exact raw-mechanism/state to public consumer bindings; no state substitution')
    parser.add_argument('--output',type=Path,required=True,help='new directory')
    args=parser.parse_args();need(not args.output.exists(),'output must be new')
    model,report=calibrate(args.protocol,args.training_root,args.bindings)
    args.output.mkdir(parents=True);(args.output/'calibrator-source.py').write_bytes(Path(__file__).read_bytes())
    save(args.output/'parameters.json',model);save(args.output/'fit-report.json',report)
    save(args.output/'freeze.json',dict(schema='orbit.mechanism.parameter-freeze.v13',parameters=identity(args.output/'parameters.json'),
        report=identity(args.output/'fit-report.json'),protocol=identity(args.protocol),bindings=identity(args.bindings),
        training_identity=identity(args.training_root/'identity.json'),calibrator=identity(__file__),holdout_labels_read=False))
    print(json.dumps(dict(status='passed',parameters=len(model['parameters']),output=str(args.output))))


if __name__=='__main__':main()
