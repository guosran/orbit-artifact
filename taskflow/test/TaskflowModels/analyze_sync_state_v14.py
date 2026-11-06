#!/usr/bin/env python3
"""Independent v14 sync normalization/distribution audit, without model fitting."""
import argparse
from collections import defaultdict
import hashlib
import json
import math
from pathlib import Path
import statistics
import numpy as np

KNOWN_WRITE_SOURCE='1aeff9590a827f93b8b35ed2cf3c22847801dbaad1f49d58cfcdeaf86daef607'

def sha(p):
    h=hashlib.sha256()
    with Path(p).open('rb') as f:
        for b in iter(lambda:f.read(1024*1024),b''):h.update(b)
    return h.hexdigest()
def read(p):return json.loads(Path(p).read_text())
def save(p,v):p.write_text(json.dumps(v,indent=2,allow_nan=False)+'\n')
def need(c,m):
    if not c:raise ValueError(m)
def ident(p):return dict(path=str(Path(p).resolve()),sha256=sha(p))
def stats(values):
    a=np.asarray(values,dtype=np.float64);need(a.size>0 and np.isfinite(a).all(),'empty/nonfinite distribution')
    median=float(np.median(a));mad=float(np.median(abs(a-median)))
    return dict(n=len(a),minimum_ns=float(a.min()),median_ns=median,mean_ns=float(a.mean()),mad_ns=mad,
        p5_ns=float(np.percentile(a,5)),p95_ns=float(np.percentile(a,95)),p99_ns=float(np.percentile(a,99)),maximum_ns=float(a.max()),
        samples_over_10x_median=int((a>10*median).sum()) if median>0 else None,samples_over_median_plus_10mad=int((a>median+10*mad).sum()) if mad else None,
        largest_sample_fraction_of_sum=float(a.max()/a.sum()) if a.sum()>0 else None)

def metrics(actual,reference):
    a=actual.astype(np.float64);r=np.asarray(reference,dtype=np.float64);d=abs(a-r);mask=abs(r)>=1e-6
    finite=bool(np.isfinite(a).all() and np.isfinite(r).all())
    return dict(passed=finite and bool(np.all(d<=1e-5+1e-5*abs(r))),max_abs=float(d.max()),
        normalized_l2=float(np.linalg.norm(d)/max(np.linalg.norm(r),1e-300)),
        max_relative_reference_ge_1e_6=float((d[mask]/abs(r[mask])).max()) if mask.any() else None,
        near_zero_max_abs=float(d[~mask].max()) if (~mask).any() else None)


def prefix_events(s,bo):
    """Observed intervals and source-bound declarations; never infer cache state."""
    c=s['cell'];events=[]
    def add(kind,offset=0,size=None,**details):
        events.append(dict(kind=kind,range=dict(bo=bo,generation=0,offset=offset,bytes=c['bo_bytes'] if size is None else size),**details))
    if s.get('verification_runs'):
        add('HostWrite',provenance='source-bound initial input reset in frozen benchmark, before recorded baseline; no invented timestamp')
        for event in s['actual_setup_events']:
            if event['kind']=='ExplicitBaselineSync':
                op='baseline-sync';add('SyncBegin',operation=op,direction='TO_DEVICE',timestamp_ns=event['start_ns'],provenance='observed baseline API envelope')
                add('SyncComplete',operation=op,direction='TO_DEVICE',timestamp_ns=event['end_ns'],provenance='successful API return; not independent physical-completion measurement')
            elif event['kind']=='HostWrite':
                add('HostWrite',event['offset_bytes'],event['size_bytes'],start_ns=event['start_ns'],end_ns=event['end_ns'],provenance='observed host write range')
            elif event['kind']=='DeviceReadComplete':
                prior=next(r for r in s['verification_runs'] if r['reason']=='prior-device-read')
                starts=[e for e in prior['events'] if e['kind']=='actual_xrt_start'];waits=[e for e in prior['events'] if e['kind']=='actual_xrt_wait']
                need(len(starts)==len(waits)==1,'readonly device-use evidence missing')
                access=[dict(range=dict(bo=bo,generation=0,offset=0,bytes=c['bo_bytes']),read=True,write=False)]
                add('DeviceSubmit',operation='prior-readonly-A',accesses=access,timestamp_ns=starts[0]['start_ns'],provenance='actual submitted original kernel; A input ABI declared read-only')
                add('WaitSuccess',operation='prior-readonly-A',timestamp_ns=waits[0]['end_ns'],provenance='actual successful wait and independent complete output verification')
    else:
        for event in s['setup']:
            kind=event['kind']
            if kind=='new-ext-bo-map-initialize':
                add('HostWrite',start_ns=event['start_ns'],end_ns=event['end_ns'],provenance='source-bound host fill inside composite BO/map/init interval; not isolated fill timing')
            elif kind.startswith('untimed-prior'):
                direction='TO_DEVICE' if kind=='untimed-prior-TO-before-host-range-action' else c['direction']
                offset=0 if kind=='untimed-prior-TO-before-host-range-action' else c['offset_bytes']
                size=c['bo_bytes'] if kind=='untimed-prior-TO-before-host-range-action' else c['size_bytes']
                op='setup-sync-'+str(len(events));add('SyncBegin',offset,size,operation=op,direction=direction,timestamp_ns=event['start_ns'],provenance='observed untimed primer')
                add('SyncComplete',offset,size,operation=op,direction=direction,timestamp_ns=event['end_ns'],provenance='successful primer API return')
            elif kind in ('untimed-host-read-range','untimed-host-write-range'):
                add('HostRead' if kind=='untimed-host-read-range' else 'HostWrite',event['offset'],event['bytes'],start_ns=event['start_ns'],end_ns=event['end_ns'],provenance='observed host range action')
    return events


def initial_signature(events,cell):
    """Descriptive prefix classification only; authoritative state queries are C++."""
    last=events[-1];kind=last['kind']
    if kind=='HostWrite':
        any_sync=any(e['kind']=='SyncComplete' for e in events[:-1]);label='host-write-range-after-sync' if any_sync else 'initial-host-write'
        q0,q1=cell['offset_bytes'],cell['offset_bytes']+cell['size_bytes'];w0,w1=last['range']['offset'],last['range']['offset']+last['range']['bytes']
        overlap=max(0,min(q1,w1)-max(q0,w0));coverage='full' if overlap==cell['size_bytes'] else 'partial' if overlap else 'none'
    elif kind=='HostRead':label='host-read-range-after-sync';coverage='none'
    elif kind=='WaitSuccess':label='after-device-read-complete';coverage='none'
    elif kind=='SyncComplete':label='post-'+last['direction']+'-no-access';coverage='none'
    else:label='unknown-prefix';coverage='unknown'
    return label,coverage


def independently_check_program(s,case,source_sha):
    need(source_sha==KNOWN_WRITE_SOURCE,'unknown write-pattern source; independent reference rule must be explicitly reviewed')
    c=s['cell'];seed_index=s['seed_index'];seed=s['seed'];checks=[]
    with np.load(case['inputs'][seed_index],allow_pickle=False) as inp,np.load(case['reference'][seed_index],allow_pickle=False) as ref:
        original_a=inp['A'].copy();b=inp['B'].copy();shadow=original_a.copy()
        initial_f64=2*(original_a.astype(np.float64)+b.astype(np.float64))+b.astype(np.float64)
        need(np.array_equal(initial_f64.astype(np.float32),ref['C']),'original saved reference differs from independent formula')
        writes=[e for e in s['actual_setup_events'] if e['kind']=='HostWrite']
        if any(e['kind']=='DeviceReadComplete' for e in s['actual_setup_events']):need(not writes,'readonly after-device-use sample has a host write')
        for event in writes:
            start=event['offset_bytes']//4;count=event['size_bytes']//4
            shadow.reshape(-1)[start:start+count]=np.float32(.125+(seed%17)*.015625)
        device=original_a.copy()
        if c['direction']=='TO_DEVICE':
            start=c['offset_bytes']//4;count=c['size_bytes']//4;device.reshape(-1)[start:start+count]=shadow.reshape(-1)[start:start+count]
        for run in s['verification_runs']:
            for key in ('outputs','reference'):need(sha(run[key]['path'])==run[key]['sha256'],'program output/reference archive changed')
            events=run['events'];need(run['runner_staging_copy_count']==0 and run['target_auto_to_skipped'] is True,'hidden staging or target full TO')
            need(sum(e['kind']=='skipped_auto_to_A' for e in events)==1,'target autoTO not intercepted exactly once')
            need(not any(e['kind']=='actual_bo_sync' and e.get('storage')==s['target']['storage'] and 'TO_DEVICE' in e['direction'] for e in events),'hidden real target TO masks partial test')
            need(sum(e['kind']=='actual_xrt_start' for e in events)==sum(e['kind']=='actual_xrt_wait' for e in events)==1,'missing actual submit/wait')
            a=original_a if run['reason']=='prior-device-read' else device
            expected_f64=2*(a.astype(np.float64)+b.astype(np.float64))+b.astype(np.float64)
            with np.load(run['outputs']['path'],allow_pickle=False) as output,np.load(run['reference']['path'],allow_pickle=False) as saved_ref:
                need(set(output.files)==set(saved_ref.files)=={'C'} and output['C'].dtype==np.float32,'program output ABI/dtype differs')
                need(np.array_equal(saved_ref['C'],expected_f64.astype(np.float32)),'stored modified reference differs from reconstructed source inputs+declared writes')
                rounded=metrics(output['C'],expected_f64.astype(np.float32));unrounded=metrics(output['C'],expected_f64)
                need(rounded['passed'] and unrounded['passed'],'independent program numerical failure')
                checks.append(dict(reason=run['reason'],output=run['outputs'],reference=run['reference'],f32_contract=rounded,f64_unrounded=unrounded,
                    reference_scope='f64 original source formula; declared HostWrite range and frozen seed scalar rule reconstructed independently, never read target A to manufacture expected values'))
    return checks


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--input',type=Path,required=True);parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--v13-audit',type=Path,help='optional v13 audit summary for scope-only historical compatibility check')
    a=parser.parse_args();root=a.input.resolve();out=a.output.resolve();need(not out.exists(),'output must be new')
    metadata=read(root/'identity.json');protocol=read(root/'protocol.json');summary=read(root/'summary.json')
    need(summary['status']=='passed','incomplete/failed measurement run')
    need(sha(root/'protocol.json')==metadata['protocol']['sha256'] and sha(root/'microbench-source.py')==metadata['source_sha256'],'protocol/source identity mismatch')
    before=read(root/'runtime-fingerprint-before.json');after=read(root/'runtime-fingerprint-after.json');need(before==after and before['target_id']==metadata['runtime_target_id'],'runtime fingerprint changed')
    cells={c['id']:c for c in protocol['cells'] if c['id'] in metadata['cells']};need(len(cells)==len(metadata['cells']),'missing/duplicate measured cell')
    cases={c['name']:c for c in protocol.get('program_cases',[])}
    for role in ('observer','executor','runtime_collector'):need(sha(metadata[role]['path'])==metadata[role]['sha256'],'bound helper/executor changed')
    for records in metadata.get('program_input_identities',{}).values():
        for record in records:need(sha(record['path'])==record['sha256'],'bound program package/data changed')
    preparations={}
    for case_name in {c['program_case'] for c in cells.values() if c.get('program_case')}:
        p=root/'program-preparation'/(case_name+'.json');record=read(p)
        for field in ('compiled','manifest'):
            need(sha(record[field]['path'])==record[field]['sha256'],'program preparation identity changed')
        for field in ('sources','elf'):
            for bound in record[field]:need(sha(bound['path'])==bound['sha256'],'compiled source/ELF changed')
        preparations[case_name]=record
    expected={(c['id'],seed,repeat) for c in cells.values() for seed in protocol['seeds'] for repeat in range(c['warmups']+c['repeats'])}
    out.mkdir(parents=True);(out/'analyzer-source.py').write_bytes(Path(__file__).read_bytes())
    groups=defaultdict(list);seed_repeat=defaultdict(dict);paired=defaultdict(dict);seen=set();numeric=[];streams=0;actual_submissions=0
    observations_path=out/'normalized-observations.jsonl';stream_path=out/'operation-streams.jsonl';sample_index=[]
    with observations_path.open('w') as observations,stream_path.open('w') as operations:
        for line in (root/'samples-index.jsonl').read_text().splitlines():
            index=json.loads(line);need(sha(index['sample']['path'])==index['sample']['sha256'],'raw sample hash mismatch');s=read(index['sample']['path']);c=s['cell']
            key=(s['cell_id'],s['seed'],s['repeat']);need(key in expected and key not in seen,'extra/duplicate sample');seen.add(key)
            need(c==cells[s['cell_id']] and s['warmup']==(s['repeat']<c['warmups']) and s['unit']=='ns','raw sample differs from frozen cell/split')
            need(s['actual_api_call_count']==c['sequence_count'] and s['api_argument_count']==(1 if c['invocation_form']=='whole-implicit' else 3),'actual API count/form mismatch')
            need(s['outer_sequence_ns']==s['end_ns']-s['start_ns']>=0,'invalid sequence interval')
            sample_key=':'.join(map(str,key));bo='sample-local-A' if c.get('program_case') else 'sample-local-standalone';prefix=prefix_events(s,bo);initial,coverage=initial_signature(prefix,c)
            allocation_scope='reused-prepared-program' if c.get('program_case') else 'fresh-BO-per-sample'
            prefix_geometry=[dict(kind=e['kind'],offset=e['range']['offset'],bytes=e['range']['bytes'],direction=e.get('direction'),
                accesses=[dict(offset=v['range']['offset'],bytes=v['range']['bytes'],read=v['read'],write=v['write']) for v in e.get('accesses',[])]) for e in prefix]
            geometry_id=hashlib.sha256(json.dumps(prefix_geometry,sort_keys=True,separators=(',',':')).encode()).hexdigest()
            loaded_context_count=sum(r['end_ns']<=s['start_ns'] for r in preparations.values())
            last_write=next((e['range'] for e in reversed(prefix) if e['kind']=='HostWrite'),None)
            last_read=next((e['range'] for e in reversed(prefix) if e['kind']=='HostRead'),None)
            if s.get('verification_runs'):
                preparation=preparations[c['program_case']]
                need(preparation['pointers'][str(s['target']['storage'])]['address']==s['target']['array_address'],'actual target differs from prepared BO pointer')
                checks=independently_check_program(s,cases[c['program_case']],metadata['source_sha256']);numeric.append(dict(sample_key=sample_key,warmup=s['warmup'],checks=checks))
                actual_submissions+=len(checks);need(s['target']['aliases_bo'] and s['target']['array_address']==s['target']['bo_map_address'],'target BO alias missing')
            else:need(s['bo']['actual_size']==c['bo_bytes'],'actual BO size mismatch')
            # Event ID is order only. No invented per-call timing in batch mode.
            events=list(prefix);queries=[];mode=c['observer_mode'];envelopes=s['per_call_envelopes'];inner=s['detailed_inner_events']
            need((envelopes is None)==(mode=='batch') and (inner is not None)==(mode=='detailed'),'boundary records do not match observer mode')
            if envelopes is not None:need(len(envelopes)==c['sequence_count'],'missing per-call envelope')
            if inner is not None:need(len(inner)==c['sequence_count'],'missing detailed inner event')
            values=defaultdict(list)
            for api in range(c['sequence_count']):
                envelope=None if envelopes is None else envelopes[api]
                if envelope:need(s['start_ns']<=envelope['start_ns']<=envelope['end_ns']<=s['end_ns'] and envelope['elapsed_ns']==envelope['end_ns']-envelope['start_ns'],'bad call envelope')
                context=initial if api==0 else 'post-'+c['direction']+'-no-access'
                dirty=coverage if api==0 else 'none';operation='measured-sync-'+str(api)
                begin_id=len(events)+1
                events.append(dict(kind='SyncBegin',range=dict(bo=bo,generation=0,offset=c['offset_bytes'],bytes=c['size_bytes']),direction=c['direction'],operation=operation,timestamp_ns=None if envelope is None else envelope['start_ns'],provenance='recorded invocation order; API envelope timestamp, not C-entry time'))
                query_context=dict(call_form='implicit-full-buffer' if c['invocation_form']=='whole-implicit' else 'explicit-range',
                    observation_boundary={'minimal':'minimal-api','detailed':'detailed-compatibility','batch':'batch-outer'}[mode],
                    runtime_identity=metadata['runtime_target_id'],observer_identity=metadata['observer']['sha256'] if mode=='detailed' else metadata['source_sha256'])
                queries.append(dict(before_event=begin_id,api_index=api,range=dict(bo=bo,generation=0,offset=c['offset_bytes'],bytes=c['size_bytes']),context=query_context,
                    raw_invocation_form=c['invocation_form'],measurement_available=mode!='batch',descriptive_prefix=context))
                events.append(dict(kind='SyncComplete',range=dict(bo=bo,generation=0,offset=c['offset_bytes'],bytes=c['size_bytes']),direction=c['direction'],operation=operation,timestamp_ns=None if envelope is None else envelope['end_ns'],provenance='successful returned API; no separate physical completion clock'))
                boundary_values=[]
                if envelope:boundary_values.append(('minimal-api-envelope' if mode=='minimal' else 'detailed-outer-envelope',envelope['elapsed_ns']))
                if inner is not None:
                    e=inner[api];need(envelope['start_ns']<=e['start_ns']<=e['end_ns']<=envelope['end_ns'],'detailed inner outside envelope')
                    boundary_values.append(('detailed-inner-compatibility',e['end_ns']-e['start_ns']))
                for boundary,duration in boundary_values:
                    record=dict(sample_key=sample_key,api_index=api,boundary=boundary,direction=c['direction'],invocation_form=c['invocation_form'],observer_mode=mode,allocation_scope=allocation_scope,prefix_geometry_id=geometry_id,loaded_program_context_count=loaded_context_count,
                        bo_bytes=c['bo_bytes'],size_bytes=c['size_bytes'],offset_bytes=c['offset_bytes'],sequence_count=c['sequence_count'],prefix=context,
                        host_write_coverage=dirty,initial_prefix=initial,seed=s['seed'],repeat=s['repeat'],warmup=s['warmup'],duration_ns=duration)
                    observations.write(json.dumps(record,separators=(',',':'))+'\n');values[boundary].append(duration)
                    if not s['warmup']:
                        group=tuple(record[k] for k in ('boundary','direction','invocation_form','observer_mode','bo_bytes','size_bytes','offset_bytes','sequence_count','initial_prefix','prefix','host_write_coverage','api_index','allocation_scope','prefix_geometry_id','loaded_program_context_count'))
                        groups[group].append((duration,s['seed'],s['repeat'],sample_key))
            for i,e in enumerate(events):e['id']=i+1
            stream=dict(schema='orbit.sync-observation.stream.v14',sample_key=sample_key,registration=dict(bo=bo,generation=0,total_bytes=c['bo_bytes'],copies=[]),
                scope='sample-local replay view; source-bound initialization is labeled, no assertion of a fresh physical BO for reused program A',events=events,queries=queries,
                raw_sample=index['sample'],bo_bytes=c['bo_bytes'],target_alias=s.get('target'),allocation_scope=allocation_scope,
                prefix_geometry=prefix_geometry,prefix_geometry_id=geometry_id,last_host_write_range=last_write,last_host_read_range=last_read,loaded_program_context_count=loaded_context_count)
            operations.write(json.dumps(stream,separators=(',',':'))+'\n');streams+=1
            if not s['warmup']:
                outer_boundary=mode+'-sequence-outer';group=(outer_boundary,c['direction'],c['invocation_form'],mode,c['bo_bytes'],c['size_bytes'],c['offset_bytes'],c['sequence_count'],initial,'mixed-prefix-sequence' if c['sequence_count']>1 else initial,coverage,None,allocation_scope,geometry_id,loaded_context_count)
                groups[group].append((s['outer_sequence_ns'],s['seed'],s['repeat'],sample_key))
                compare=(c['direction'],c['invocation_form'],c['bo_bytes'],c['size_bytes'],c['offset_bytes'],c['sequence_count'],initial,coverage,allocation_scope,geometry_id,loaded_context_count,s['seed'],s['repeat'])
                paired[compare][mode]=dict(sample_key=sample_key,outer_ns=s['outer_sequence_ns'],per_call_sum={b:sum(v) for b,v in values.items()})
            sample_index.append(dict(sample_key=sample_key,raw=index['sample'],initial_prefix=initial,host_write_coverage=coverage))
    need(seen==expected,'missing frozen matrix samples');need(len(seen)==summary['samples'] and actual_submissions==summary['actual_npu_submissions'],'summary counts differ from actual saved samples/submissions')
    group_names=('boundary','direction','invocation_form','observer_mode','bo_bytes','size_bytes','offset_bytes','sequence_count','initial_prefix','prefix','host_write_coverage','api_index','allocation_scope','prefix_geometry_id','loaded_program_context_count')
    rows=[]
    for key,values in sorted(groups.items(),key=lambda kv:str(kv[0])):
        row=dict(zip(group_names,key));row['distribution']=stats([v[0] for v in values]);row['by_seed']=[dict(seed=seed,**stats([v[0] for v in values if v[1]==seed])) for seed in sorted({v[1] for v in values})]
        row['by_repeat']=[dict(repeat=rep,**stats([v[0] for v in values if v[2]==rep])) for rep in sorted({v[2] for v in values})]
        row['largest_samples']=[dict(duration_ns=v[0],sample_key=v[3]) for v in sorted(values,reverse=True)[:3]];rows.append(row)
    pairs=defaultdict(list)
    for key,modes in paired.items():
        if not all(m in modes for m in ('minimal','detailed','batch')):continue
        detail=modes['detailed'];minimal=modes['minimal'];batch=modes['batch']
        values=dict(detailed_outer_minus_minimal_outer=detail['outer_ns']-minimal['outer_ns'],
            detailed_inner_sum_minus_minimal_api_sum=detail['per_call_sum']['detailed-inner-compatibility']-minimal['per_call_sum']['minimal-api-envelope'],
            detailed_outer_minus_detailed_inner_sum=detail['outer_ns']-detail['per_call_sum']['detailed-inner-compatibility'],
            minimal_outer_minus_minimal_api_sum=minimal['outer_ns']-minimal['per_call_sum']['minimal-api-envelope'],
            batch_outer_minus_minimal_outer=batch['outer_ns']-minimal['outer_ns'])
        for name,value in values.items():pairs[key[:-2]+(name,)].append(value)
    pair_rows=[dict(zip(('direction','invocation_form','bo_bytes','size_bytes','offset_bytes','sequence_count','initial_prefix','host_write_coverage','allocation_scope','prefix_geometry_id','loaded_program_context_count','comparison'),key),distribution=stats(v)) for key,v in sorted(pairs.items(),key=lambda kv:str(kv[0]))]
    controls=read(root/'empty-controls.json');control_groups=defaultdict(list)
    for e in controls:need(e['elapsed_ns']==e['end_ns']-e['start_ns']>=0,'empty-control timing mismatch');control_groups[e['control']].append(e['elapsed_ns'])
    max32=max((check['f32_contract']['max_abs'] for n in numeric for check in n['checks']),default=0)
    max64=max((check['f64_unrounded']['max_abs'] for n in numeric for check in n['checks']),default=0)
    history=None
    if a.v13_audit:
        old=read(a.v13_audit);history=dict(source=ident(a.v13_audit),scope='incomparable unless invocation form, observer boundary, operational prefix and runtime target ALL match; v13 lacks this exact target/config proof',
            v13_source_scope=old.get('status_scope'),direct_old_coefficients_reused=False)
    report=dict(schema='orbit.sync-state.analysis.v14',status='passed',status_scope='independent raw/provenance/numerical audit and descriptive statistics, not model acceptance',
        input=ident(root/'identity.json'),protocol=ident(root/'protocol.json'),benchmark_source=ident(root/'microbench-source.py'),runtime_target_id=metadata['runtime_target_id'],
        program_preparations={k:ident(root/'program-preparation'/(k+'.json')) for k in preparations},sample_count=len(seen),actual_npu_submissions=actual_submissions,verification_outputs=sum(len(n['checks']) for n in numeric),max_abs_f32_reference=max32,max_abs_unrounded_f64_reference=max64,
        normalized_observations=ident(observations_path),operation_streams=ident(stream_path),groups=rows,boundary_comparisons=pair_rows,
        empty_controls=[dict(control=k,distribution=stats(v)) for k,v in sorted(control_groups.items())],numerical=numeric,sample_index=sample_index,historical_comparison=history,
        scope=dict(model_fitted=False,outliers_removed=False,physical_bandwidth=False,device_submissions_by_analyzer=0,
            query_authority='exported source/observed ordered operations for C++ SyncState; descriptive prefix strings here are not a Python production state planner',
            overhead='signed controlled boundary differences and residuals, never subtracted as physical API/DDR cost',
            batch='outer loop only, no invented per-call times; each ordered successful return can still be replayed without timestamps'))
    save(out/'summary.json',report);print(json.dumps(dict(status='passed',samples=len(seen),outputs=report['verification_outputs'],groups=len(rows),max_abs_f64=max64)))
if __name__=='__main__':main()
