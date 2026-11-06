#!/usr/bin/env python3
"""Independent offline mechanism validation; opaque wait/CPU costs remain null."""
import argparse
from collections import defaultdict
import hashlib
import json
import math
from pathlib import Path
import statistics
import numpy as np
from heterogeneous_validation_v13 import numerical_metrics

_CACHE={}
def sha(p):
    p=Path(p).resolve()
    if p not in _CACHE:
        h=hashlib.sha256()
        with p.open('rb') as f:
            for b in iter(lambda:f.read(1024*1024),b''):h.update(b)
        _CACHE[p]=h.hexdigest()
    return _CACHE[p]
def read(p):return json.loads(Path(p).read_text())
def need(c,m):
    if not c:raise ValueError(m)
def identity(p):return dict(path=str(Path(p).resolve()),sha256=sha(p))
def stats(v):return dict(n=len(v),minimum=min(v),median=statistics.median(v),maximum=max(v))


def scan(root,protocol,split):
    root=Path(root).resolve();run=read(root/'identity.json')
    need(run['split']==split and run['protocol_sha256']==protocol['_sha'],'run split/protocol mismatch')
    need(sha(root/'protocol.json')==protocol['_sha'] and sha(root/'microbench-source.py')==run['microbench_sha256'],'protocol/script snapshot changed')
    for prefix in ('pyxrt','multilaunch'):
        need(sha(run[prefix+'_path'])==run[prefix+'_sha256'],'runtime binary/source changed')
    need(run['executor']==protocol['executor'] and sha(run['executor']['path'])==run['executor']['sha256'],'execution observer changed')
    records=[];outer=[];numeric=[];programs=[];static=[]
    declarations=protocol['train' if split=='training' else 'holdout']
    memory_path=root/'memory-samples.json'
    for i,s in enumerate(read(memory_path)):
        need(s['split']==split and s['count'] in declarations['counts'],'sample split/count mismatch')
        need(s['state'] in protocol['states'] and s['warmup']==(s['repeat']<protocol['warmups']),'state/warmup mismatch')
        need(s.get('unit')=='ns','memory timer unit must be explicit ns')
        need(s['bytes_per_call'] in declarations['sizes_bytes'] or s['mechanism']=='timer-empty','undeclared size')
        need(len(s['api_events'])==s['count'],'actual API count mismatch')
        last=s['start_ns'];duration=0
        for ordinal,e in enumerate(s['api_events']):
            need(e['index']==ordinal and last<=e['start_ns']<=e['end_ns']<=s['end_ns'],'invalid API interval')
            need(e['elapsed_ns']==e['end_ns']-e['start_ns'],'API duration differs');last=e['end_ns'];duration+=e['elapsed_ns']
        need(duration==s['api_total_ns'] and s['outer_sequence_ns']==s['end_ns']-s['start_ns']>=duration,'outer/API accounting mismatch')
        if s['warmup']:continue
        outer.append(dict(mechanism=s['mechanism'],state=s['state'],bytes=s['bytes_per_call'],count=s['count'],
            api_ms=duration/1e6,outer_ms=s['outer_sequence_ns']/1e6,unattributed_outer_ms=(s['outer_sequence_ns']-duration)/1e6))
        if s['mechanism'].startswith('bo-sync-'):
            direction=s['mechanism'][len('bo-sync-'):]
            for ordinal,e in enumerate(s['api_events']):
                state=s['state'] if ordinal==0 else 'after-'+direction+'-sync'
                records.append(dict(raw_mechanism=s['mechanism'],state=state,bytes=s['bytes_per_call'],count=1,api_ms=e['elapsed_ns']/1e6,raw=dict(file=identity(memory_path),sample_index=i,api_index=ordinal)))
        elif s['mechanism']!='timer-empty':
            records.append(dict(raw_mechanism=s['mechanism'],state=s['state'],bytes=s['bytes_per_call'],count=s['count'],api_ms=duration/1e6,raw=dict(file=identity(memory_path),sample_index=i)))
    preparation={r['case']:r for r in read(root/'program-preparation.json')}
    cases={c['name']:c for c in protocol['program_cases']}
    sequence_path=root/'program-samples.json'
    source_records={}
    for i,s in enumerate(read(sequence_path)):
        case=cases[s['case']];need(case['split']==split==s['split'],'program split mismatch')
        need(s['count'] in declarations['counts'] and len(s['calls'])==s['count'],'program API repetition mismatch')
        need(s['warmup']==(s['repeat']<protocol['program_warmups']),'program warmup mismatch')
        prep=preparation[s['case']];compiled_path=Path(case['compiled']);compiled=read(compiled_path);manifest=read(compiled['manifest'])
        need(sha(compiled_path)==prep['compiled_sha256'] and sha(compiled['manifest'])==compiled['manifest_sha256'],'program compile/native identity mismatch')
        need(prep['plan_id']==compiled['plan_id']==manifest['id'],'plan identity mismatch')
        need([sha(p) for p in case['inputs']]==prep['input_sha256'] and [sha(p) for p in case['reference']]==prep['reference_sha256'],'program data changed')
        need(len(prep['trials'])==protocol['prepare_repeats'],'preparation trial count mismatch')
        for trial in prep['trials']:need(trial['elapsed_ns']==trial['end_ns']-trial['start_ns']>=0,'invalid preparation wall')
        source_records[s['case']]=dict(case=s['case'],compiled=identity(compiled_path),manifest=identity(compiled['manifest']),
            program_family_key=manifest['program_family_key'],execution_contract_identity=manifest['execution_contract_identity'])
        for region,executable in zip(manifest['regions'],compiled['regions']):
            child=Path(compiled['manifest']).parent/region['source'];need(sha(child)==executable['source_sha256'],'child source changed')
            if region['device']=='cpu':need(sha(executable['library'])==executable['library_sha256'],'CPU shared object changed')
            else:
                need(sha(executable['artifact']['elf_path'])==executable['artifact']['elf_sha256'],'ELF changed')
                native_path=Path(compiled['manifest']).parent/region['source'];native_path=native_path.with_name('plan.json');native=read(native_path)
                need(native['actual_dma_bytes']==sum(t['bytes'] for t in native['transfers']) and native['transfer_count']==len(native['transfers']),'static native DMA descriptor mismatch')
                need(native['resident_bytes']<=native['capacity_bytes'],'native local payload budget exceeded')
                key=(s['case'],region['index'])
                if key not in {(r['case'],r['region']) for r in static}:
                    static.append(dict(case=s['case'],region=region['index'],plan=identity(native_path),
                        static_dma_bytes=native['actual_dma_bytes'],static_transfer_count=native['transfer_count'],resident_payload_bytes=native['resident_bytes'],
                        scope='checked static native descriptor bytes/counts, not measured physical DDR traffic or internal DMA duration'))
        mechanisms=defaultdict(list);subcalls=[]
        with np.load(case['inputs'][s['seed_index']],allow_pickle=False) as inp,np.load(case['reference'][s['seed_index']],allow_pickle=False) as ref:
            expected=(2*(inp['A'].astype(np.float64)+inp['B'].astype(np.float64))+inp['B'].astype(np.float64)).astype(np.float32)
            need(np.array_equal(expected,ref['C']),'independent frozen reference mismatch')
            for call_index,call in enumerate(s['calls']):
                evidence=Path(call['evidence']).resolve();need(root in evidence.parents,'evidence outside run')
                actual=read(evidence);need(actual['passed'] is True and actual['events']==call['events'] and actual['wall_ms']==call['wall_ms'],'raw call/API mismatch')
                with np.load(evidence.with_name('outputs.npz'),allow_pickle=False) as output:
                    need(set(output.files)=={'C'} and output['C'].dtype==np.float32,'output ABI/dtype differs')
                    metric=numerical_metrics(output['C'],expected);need(metric['passed'],'independent numerical failure')
                numeric.append(dict(case=s['case'],seed_index=s['seed_index'],count=s['count'],repeat=s['repeat'],call=call_index,warmup=s['warmup'],outputs=identity(evidence.with_name('outputs.npz')),**metric))
                by_kind=defaultdict(float);states={v['index']:'host-written' for v in manifest['storage']}
                component_calls=[]
                for e in call['events']:
                    need(e['start_ns']<=e['end_ns'],'negative program API event')
                    elapsed=(e['end_ns']-e['start_ns'])/1e6;by_kind[e['kind']]+=elapsed
                    mechanism=None;raw=None;state=None;byte_count=0;route=None
                    if e['kind']=='host_input_reset':
                        v=manifest['storage'][e['storage']];need(v['role']=='input' and v['bytes']==e['bytes'],'reset native byte mismatch')
                        route='numpy-to-mapped-bo' if v['realization']=='xrt-mapped-bo' else 'numpy-to-host';state='prepared-hot';mechanism='host.input_reset'
                        raw='program-host-input-reset.'+route;byte_count=e['bytes'];states[e['storage']]='host-written'
                    elif e['kind']=='host_final_output_copy':
                        outputs=[v for v in manifest['storage'] if v['role']=='output'];need(len(outputs)==1 and outputs[0]['bytes']==e['bytes'],'output acquisition native bytes mismatch')
                        route='mapped-bo-to-numpy' if outputs[0]['realization']=='xrt-mapped-bo' else 'host-to-numpy';state='prepared-hot';mechanism='host.output_copy'
                        raw='program-final-output-acquisition.'+route;byte_count=e['bytes']
                    elif e['kind']=='actual_xrt_start':
                        raw='actual-xrt-start';state='prepared-hot-bound-bo';mechanism='npu.submit';route='pyxrt.run.start'
                    elif e['kind']=='actual_xrt_wait':
                        for a in manifest['regions'][e['region']]['npu_abi']:
                            if a['role']=='output':states[a['storage']]='device-completed'
                    elif e['kind']=='actual_cpu_library_call':
                        for a in manifest['regions'][e['region']]['abi']:
                            pointer=prep['pointers'][str(a['storage'])]
                            descriptor=e['abi_descriptors'][a['argument']]
                            need(descriptor['allocated']==descriptor['aligned']==pointer['address'],'CPU descriptor no longer points to prepared storage')
                            if a['role']=='output':states[a['storage']]='host-written'
                    elif e['kind']=='actual_bo_sync':
                        v=manifest['storage'][e['storage']];byte_count=v['bytes'];state=states[e['storage']]
                        if 'FROM_DEVICE' in e['direction']:
                            need(state=='device-completed','FROM sync lacks device-produced state')
                            raw='actual-bo-sync-FROM_DEVICE';mechanism='bo.sync_from_device';route='pyxrt.bo.sync.FROM_DEVICE'
                            states[e['storage']]='device-completed-host-visible'
                        else:
                            raw='bo-sync-TO_DEVICE';mechanism='bo.sync_to_device';route='pyxrt.bo.sync.TO_DEVICE'
                            if not e['public_region_event_ids']:
                                need('conservative installed-runner sync' in e.get('binding_scope',''),'runtime-only output sync lacks declared scope')
                            states[e['storage']]='host-visible-after-sync'
                    if raw:
                        # Standalone host-written sync TO may validate the same declared host-written API state; other states remain separate.
                        component_calls.append(dict(raw_mechanism=raw,mechanism=mechanism,path=route,state=state,bytes=byte_count,count=1,api_ms=elapsed))
                        if e['kind']!='actual_bo_sync' or 'FROM_DEVICE' in e['direction']:
                            mechanisms[(raw,state,byte_count)].append(elapsed)
                region_total=sum((c['end_ns']-c['start_ns'])/1e6 for c in call['region_calls'])
                need(actual['wall_ms']>=region_total-1e-9,'negative whole-call region residual')
                subcalls.append(dict(evidence=identity(evidence),wall_ms=actual['wall_ms'],actual_api_totals_ms=dict(by_kind),components=component_calls,
                    full_prediction_ms=None,opaque_cpu_call_ms=by_kind['actual_cpu_library_call'],opaque_wait_ms=by_kind['actual_xrt_wait'],
                    note='API components only; never add them on top of composite region cost or assign uncovered residual to DMA'))
        need(abs(s['program_wall_sum_ns']-sum(c['wall_ms'] for c in s['calls'])*1e6)<1e-6,'program wall aggregation differs')
        need(s['outer_sequence_ns']>=s['program_wall_sum_ns'],'program outer sequence shorter than calls')
        if not s['warmup']:
            for (raw,state,b),durations in mechanisms.items():
                records.append(dict(raw_mechanism=raw,state=state,bytes=b,count=len(durations),api_ms=sum(durations),raw=dict(file=identity(sequence_path),sample_index=i)))
            programs.append(dict(case=s['case'],seed_index=s['seed_index'],count=s['count'],repeat=s['repeat'],calls=subcalls,
                serialization_and_outer_residual_ms=(s['outer_sequence_ns']-s['program_wall_sum_ns'])/1e6))
    return dict(records=records,outer=outer,numeric=numeric,programs=programs,static=static,program_sources=list(source_records.values()),identity=identity(root/'identity.json'))


def main():
    p=argparse.ArgumentParser(description=__doc__)
    for flag in ('protocol','training-root','model-freeze','bindings','output'):p.add_argument('--'+flag,type=Path,required=True)
    p.add_argument('--holdout-root',type=Path)
    p.add_argument('--training-only',action='store_true')
    p.add_argument('--holdout-gate',type=Path,help='optional premeasurement receipt binding the frozen parameter/report/receipt hashes')
    p.add_argument('--public-plans',type=Path,help='new C++ metadata reexports with binding-results.json; no new hardware identity implied')
    a=p.parse_args();need(not a.output.exists(),'output must be new')
    protocol=read(a.protocol);protocol['_sha']=sha(a.protocol)
    need(read(a.protocol.parent/'freeze.json')['protocol_sha256']==protocol['_sha'],'protocol freeze differs')
    freeze=read(a.model_freeze/'freeze.json')
    for field in ('parameters','report','protocol','bindings','training_identity','calibrator'):
        need(sha(freeze[field]['path'])==freeze[field]['sha256'],'parameter freeze dependency changed: '+field)
    need(freeze['protocol']['sha256']==protocol['_sha'] and freeze['bindings']['sha256']==sha(a.bindings),'supplied protocol/bindings differ from fit freeze')
    gate=None
    if a.holdout_gate:
        gate=read(a.holdout_gate)
        need(gate['holdout_measured'] is False,'gate was not a premeasurement receipt')
        for file,digest in gate['files'].items():need(sha(file)==digest,'pre-heldout parameter gate changed')
        need(str((a.model_freeze/'parameters.json').resolve()) in gate['files'],'gate does not bind these parameters')
    model=read(a.model_freeze/'parameters.json');need(sha(a.model_freeze/'parameters.json')==freeze['parameters']['sha256'],'parameter file differs')
    need(model['schema']=='orbit.mechanism-cost-parameters.v13','wrong model schema')
    need(model['scope']['whole_program_prediction'] is None and model['scope']['program_wall_fitted'] is False and model['scope']['outer_sequence_fitted'] is False,'fitter exceeded mechanism scope')
    binding=read(a.bindings);parameter_map={}
    for b in binding['bindings']:
        matches=[r for r in model['parameters'] if all(r[k]==b[k] for k in ('mechanism','path','state','resource','boundary','runtime_identity'))]
        need(len(matches)<=1,'ambiguous parameter binding')
        if matches:
            r=matches[0];need(r['measurement_boundary']==r['boundary'],'measurement boundary mismatch')
            need(all(math.isfinite(r[k]) and r[k]>=0 for k in ('alpha_ms','beta_ms_per_byte')),'negative/nonfinite model coefficients')
            need(r['mechanism'] not in ('npu.wait','cpu.call'),'opaque mechanism has fitted parameters')
            parameter_map[(b['raw_mechanism'],b.get('raw_state',b['state']))]=r
            if b.get('raw_state',b['state'])!=b['state']:
                need(b.get('raw_state')=='after-TO_DEVICE-sync' and b['state']=='host-visible-after-sync' and bool(b.get('state_equivalence')),'unproved state substitution')
                parameter_map[(b['raw_mechanism'],b['state'])]=r
    need(bool(a.holdout_root)!=a.training_only,'choose holdout-root or explicit training-only')
    train=scan(a.training_root,protocol,'training');held=scan(a.holdout_root,protocol,'holdout') if a.holdout_root else None
    # Independently solve the two-dimensional quadratic using scalar normal sums,
    # not the calibrator's numpy least-squares implementation.
    parameter_checks=[]
    for b in binding['bindings']:
        r=parameter_map.get((b['raw_mechanism'],b.get('raw_state',b['state'])))
        if r is None:continue
        ss=[v for v in train['records'] if v['raw_mechanism']==b['raw_mechanism'] and v['state']==b.get('raw_state',b['state'])]
        need(bool(ss),'parameter has no raw training records')
        need(min(v['bytes'] for v in ss)==r['min_bytes'] and max(v['bytes'] for v in ss)==r['max_bytes'],'parameter byte domain mismatch')
        need(min(v['count'] for v in ss)==r['min_count'] and max(v['count'] for v in ss)==r['max_count'],'parameter count domain mismatch')
        scale=max(max(v['bytes'] for v in ss),1)
        x=[v['count'] for v in ss];z=[v['count']*v['bytes']/scale for v in ss];y=[v['api_ms'] for v in ss]
        aa=sum(q*q for q in x);ab=sum(q*w for q,w in zip(x,z));bb=sum(w*w for w in z)
        ay=sum(q*t for q,t in zip(x,y));by=sum(w*t for w,t in zip(z,y))
        candidates=[(max(0.0,ay/aa),0.0)]
        if b['mechanism']!='npu.submit':
            need(bb>0 and aa*bb-ab*ab>0,'two-coefficient fit not identifiable')
            candidates.extend([(0.0,max(0.0,by/bb)),(0.0,0.0)])
            determinant=aa*bb-ab*ab
            alpha=(ay*bb-by*ab)/determinant;gamma=(by*aa-ay*ab)/determinant
            if alpha>=0 and gamma>=0:candidates.append((alpha,gamma))
        alpha,gamma=min(candidates,key=lambda c:sum((c[0]*q+c[1]*w-t)**2 for q,w,t in zip(x,z,y)))
        need(math.isclose(alpha,r['alpha_ms'],rel_tol=1e-10,abs_tol=1e-12) and math.isclose(gamma/scale,r['beta_ms_per_byte'],rel_tol=1e-10,abs_tol=1e-16),'frozen NNLS parameters do not match independent optimum')
        raw=[v['raw'] for v in ss]
        need(hashlib.sha256(json.dumps(raw,sort_keys=True,separators=(',',':')).encode()).hexdigest()==r['raw_manifest_sha256'],'parameter raw manifest digest differs')
        parameter_checks.append(dict(mechanism=r['mechanism'],path=r['path'],state=r['state'],n=len(ss),independent_alpha_ms=alpha,independent_beta_ms_per_byte=gamma/scale,passed=True))
    comparisons=[];unpriced=[]
    for split,data in [('training',train)]+([('holdout',held)] if held else []):
        cells=defaultdict(list)
        for s in data['records']:cells[(s['raw_mechanism'],s['state'],s['bytes'],s['count'])].append(s['api_ms'])
        for (raw,state,byte_count,count),values in sorted(cells.items()):
            r=parameter_map.get((raw,state))
            if r is None or not r['min_bytes']<=byte_count<=r['max_bytes']:
                unpriced.append(dict(split=split,raw_mechanism=raw,state=state,bytes=byte_count,count=count,n=len(values),reason='no exact-state/path parameter or outside measured byte range'));continue
            prediction=count*(r['alpha_ms']+r['beta_ms_per_byte']*byte_count);actual=statistics.median(values)
            comparisons.append(dict(split=split,raw_mechanism=raw,state=state,bytes=byte_count,count=count,n=len(values),
                predicted_api_sum_ms=prediction,actual_api_sum_ms=actual,absolute_error_ms=abs(prediction-actual),relative_error=abs(prediction-actual)/actual if actual else None,
                count_outside_training_range=count<r['min_count'] or count>r['max_count'],actual_distribution_ms=stats(values)))
        for sequence in data['outer']:
            mechanism=sequence['mechanism'];count=sequence['count'];parts=[]
            if mechanism.startswith('bo-sync-'):
                direction=mechanism[len('bo-sync-'):]
                parts=[(sequence['state'],1)]+([('after-'+direction+'-sync',count-1)] if count>1 else [])
            elif mechanism!='timer-empty':parts=[(sequence['state'],count)]
            prediction=0.0;missing=[]
            for state,n in parts:
                r=parameter_map.get((mechanism,state))
                if r and r['min_bytes']<=sequence['bytes']<=r['max_bytes']:
                    prediction+=n*(r['alpha_ms']+r['beta_ms_per_byte']*sequence['bytes'])
                else:missing.append(dict(state=state,count=n))
            sequence.update(predicted_api_sum_ms=None if missing or not parts else prediction,unpriced_state_parts=missing,
                model_scope='API sums only; first sync and same-buffer subsequent sync states remain distinct')
        for sequence in data['programs']:
            for call in sequence['calls']:
                subtotal=0;unpriced_components=[];actual_matched=0
                for component in call['components']:
                    r=parameter_map.get((component['raw_mechanism'],component['state']))
                    if r and r['min_bytes']<=component['bytes']<=r['max_bytes']:
                        subtotal+=r['alpha_ms']+r['beta_ms_per_byte']*component['bytes'];actual_matched+=component['api_ms']
                    else:unpriced_components.append(component)
                call.update(predicted_matched_api_subtotal_ms=subtotal,actual_matched_api_subtotal_ms=actual_matched,
                    unpriced_components=unpriced_components,full_prediction_ms=None,ranking_allowed=False)
    hold_errors=[r['relative_error'] for r in comparisons if r['split']=='holdout' and r['relative_error'] is not None]
    public_bridge=[]
    if a.public_plans:
        root=a.public_plans.resolve();bindings=read(root/'binding-results.json')
        records_by_case={r['case']:r for r in train['program_sources']+([] if held is None else held['program_sources'])}
        native_views={}
        for binding_record in bindings:
            name=binding_record['name'];need(name in records_by_case,'public plan has no matching measured program')
            compiled=read(binding_record['original_compiled']);old_path=Path(compiled['manifest']);old=read(old_path)
            new_path=root/name/'manifest.json';new=read(new_path)
            need(new['id']==old['id']==binding_record['plan_id'] and new['graph_id']==old['graph_id']==binding_record['graph_id'],'metadata reexport changed parent graph/plan')
            need(sha(old_path.parent/'taskflow.mlir')==sha(new_path.parent/'taskflow.mlir'),'reexported actual Taskflow bytes differ')
            need(len(old['regions'])==len(new['regions']),'metadata reexport region count differs')
            for previous,current in zip(old['regions'],new['regions']):
                for field in ('source','cpu_source','air'):
                    if field in previous:
                        need(field in current and sha(old_path.parent/previous[field])==sha(new_path.parent/current[field]),'reexported child implementation differs')
            facts=new['mechanism_facts'];cost=new['mechanism_cost']
            need(facts['program_graph_id']==new['graph_id'] and facts['id']==cost['facts_id']==binding_record['mechanism_facts_id'],'public fact/graph identity differs')
            need(cost['complete_ms'] is None and binding_record['complete_ms'] is None,'incomplete model must not emit full cost')
            need(facts['runtime']['identity']==new['execution_contract_identity'] and facts['runtime']['output_poisoned'] is True,'public runtime/poison contract differs')
            need(len(facts['items'])==len(cost['items']),'public cost/fact item count differs')
            known=0.0
            for item,priced in zip(facts['items'],cost['items']):
                need(item['id']==priced['item'],'public cost item association differs')
                matches=[r for r in model['parameters'] if all(r[k]==item[k] for k in ('mechanism','path','state','resource','boundary')) and r['runtime_identity']==facts['runtime']['identity'] and r['min_bytes']<=item['bytes']<=r['max_bytes']]
                if item['descriptive_only']:
                    need(priced['duration_ms'] is None and priced['status']=='included-in-composite' and item['covered_by']>=0,'descriptive child payload charged twice')
                elif matches:
                    need(len(matches)==1,'ambiguous public parameter match')
                    prediction=matches[0]['alpha_ms']+matches[0]['beta_ms_per_byte']*item['bytes']
                    need(priced['status']=='calibrated-api-model' and math.isclose(priced['duration_ms'],prediction,rel_tol=1e-12,abs_tol=1e-15),'C++ parameter evaluation differs')
                    known+=prediction
                else:need(priced['duration_ms'] is None,'unpriced public fact silently charged')
            need(math.isclose(known,cost['known_subtotal_ms'],rel_tol=1e-12,abs_tol=1e-15) and math.isclose(known,binding_record['predicted_known_subtotal_ms'],rel_tol=1e-12,abs_tol=1e-15),'public known subtotal differs')
            native_views[name]=(new,facts,cost)
        for split,data in [('training',train)]+([('holdout',held)] if held else []):
            for sequence in data['programs']:
                new,facts,cost=native_views[sequence['case']]
                for call in sequence['calls']:
                    actual=read(call['evidence']['path']);matched=[];observed=0.0;used=set()
                    state_at_event={};epochs={v['index']:'host-written' for v in new['storage']}
                    for event_index,event in enumerate(actual['events']):
                        if event['kind']=='actual_bo_sync':
                            state_at_event[event_index]=epochs[event['storage']]
                            epochs[event['storage']]='device-completed-host-visible' if 'FROM_DEVICE' in event['direction'] else 'host-visible-after-sync'
                        if event['kind'] in ('actual_xrt_wait','actual_cpu_library_call'):
                            region=new['regions'][event['region']]
                            for argument in region.get('npu_abi',region['abi']):
                                if argument['role']=='output':epochs[argument['storage']]='device-completed' if event['kind']=='actual_xrt_wait' else 'host-written'
                    for item,priced in zip(facts['items'],cost['items']):
                        if priced['duration_ms'] is None:continue
                        kind={'host.input_reset':'host_input_reset','host.output_copy':'host_final_output_copy','bo.sync_to_device':'actual_bo_sync','bo.sync_from_device':'actual_bo_sync','npu.submit':'actual_xrt_start'}[item['mechanism']]
                        candidates=[]
                        for index,e in enumerate(actual['events']):
                            if e['kind']!=kind:continue
                            if item['region']>=0 and e.get('region')!=item['region']:continue
                            if kind in ('host_input_reset','actual_bo_sync') and e.get('storage')!=item['storage']:continue
                            if item['mechanism']=='bo.sync_to_device' and 'TO_DEVICE' not in e['direction']:continue
                            if item['mechanism']=='bo.sync_from_device' and 'FROM_DEVICE' not in e['direction']:continue
                            candidates.append((index,e))
                        need(len(candidates)==1,'public calibrated fact lacks unique actual API witness')
                        index,e=candidates[0];need(index not in used,'one actual API charged by multiple public facts');used.add(index)
                        if kind=='actual_bo_sync':need(state_at_event[index]==item['state'],'public sync state disagrees with actual host-write/device-completion/same-buffer sync chronology')
                        if item['region_events']:need(set(item['region_events'])<=set(e['public_region_event_ids']),'public lifecycle fact differs from actual API')
                        if item['runtime_only']:need(not e['public_region_event_ids'] and 'conservative installed-runner sync' in e.get('binding_scope',''),'runtime-only sync mislabeled as logical copy')
                        duration=(e['end_ns']-e['start_ns'])/1e6;observed+=duration
                        matched.append(dict(item=item['id'],event_index=index,mechanism=item['mechanism'],storage=item['storage'],region=item['region'],predicted_ms=priced['duration_ms'],actual_ms=duration))
                    public_bridge.append(dict(split=split,case=sequence['case'],evidence=call['evidence'],metadata_manifest=identity(root/sequence['case']/'manifest.json'),
                        original_compiled=records_by_case[sequence['case']]['compiled'],scope='new C++ metadata over byte-identical existing compiled implementation; no new-binary execution claim',
                        predicted_known_subtotal_ms=cost['known_subtotal_ms'],actual_exact_matched_api_subtotal_ms=observed,full_prediction_ms=None,matched_items=matched))
    report=dict(schema='orbit.mechanism.independent-validation.v13',status='passed',
        status_scope='structural/provenance/numerical audit completed; not an accuracy acceptance',
        numerical_and_provenance_status='passed',model_accuracy_status='heldout-prediction-misses-recorded' if held else 'not-yet-validated',
        accuracy_acceptance_threshold=None,accuracy_passed=None,
        holdout_gate=identity(a.holdout_gate) if a.holdout_gate else None,protocol=identity(a.protocol),freeze=identity(a.model_freeze/'freeze.json'),
        parameters=identity(a.model_freeze/'parameters.json'),independent_parameter_checks=parameter_checks,training=train,holdout=held,api_prediction_comparisons=comparisons,unpriced_cells=unpriced,
        public_cpp_composition_bridge=public_bridge,heldout_api_mape=sum(hold_errors)/len(hold_errors) if hold_errors else None,heldout_api_max_relative_error=max(hold_errors) if hold_errors else None,
        scope=dict(numerical_atol=1e-5,numerical_rtol=1e-5,units='host monotonic milliseconds',model_retuned=False,
            full_program_prediction=None,program_ranking=None,wait='opaque compute+DMA+stall/runtime and not fitted',cpu_call='opaque and not fitted',
            physical_ddr_measurement=False,native_dma='static descriptors only, not calibrated timing',outer_residual='reported, never allocated numerically to DMA/compute',device_submissions=0))
    a.output.mkdir(parents=True);(a.output/'auditor-source.py').write_bytes(Path(__file__).read_bytes())
    (a.output/'summary.json').write_text(json.dumps(report,indent=2,allow_nan=False)+'\n')
    print(json.dumps(dict(status='passed',training_outputs=len(train['numeric']),holdout_outputs=len(held['numeric']) if held else 0,heldout_api_cells=sum(r['split']=='holdout' for r in comparisons))))
if __name__=='__main__':main()
