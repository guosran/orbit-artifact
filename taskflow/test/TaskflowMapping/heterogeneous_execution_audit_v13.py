#!/usr/bin/env python3
"""Independent offline v13 execution/model audit; no compilation or device calls."""
import argparse
from collections import defaultdict
import hashlib
import json
import math
from pathlib import Path
import statistics
import numpy as np
from heterogeneous_validation_v13 import numerical_metrics

_HASHES = {}
def sha(path):
    path=Path(path).resolve()
    if path not in _HASHES:
        h=hashlib.sha256()
        with path.open('rb') as stream:
            for block in iter(lambda:stream.read(1024*1024),b''):
                h.update(block)
        _HASHES[path]=h.hexdigest()
    return _HASHES[path]

def read(path):
    return json.loads(Path(path).read_text())

def path(base,value):
    p=Path(value)
    return p.resolve() if p.is_absolute() else (base/p).resolve()

def need(condition,message):
    if not condition:
        raise ValueError(message)

def identity(p):
    return dict(path=str(Path(p).resolve()),sha256=sha(p))

def distribution(values):
    return dict(n=len(values),minimum=min(values),median=statistics.median(values),maximum=max(values))

def interpolate(knots,key,value):
    """Analysis-only reproduction of frozen interpolation, never production selection."""
    points=sorted((k[key],k['ms']) for k in knots)
    need(len(points)>=2 and points[0][0]<=value<=points[-1][0], 'prediction outside measured interpolation domain')
    for x,y in points:
        if value==x:return y
    for (x0,y0),(x1,y1) in zip(points,points[1:]):
        if x0<value<x1:return y0+(y1-y0)*(value-x0)/(x1-x0)
    raise ValueError('invalid interpolation knots')

def audit(args):
    out=args.output.resolve();need(not out.exists(),'output already exists')
    root=args.execution_root.resolve();cases_path=args.cases.resolve()
    dataset_path=args.fixtures.resolve()/'manifest.json';dataset=read(dataset_path)
    need(dataset['split_status']=='frozen-before-timing-labels','unfrozen dataset')
    eligible={}
    for case in dataset['cases']:
        if case['split']!=args.split:continue
        need(case['model_label_eligible'],'capacity-negative cannot supply labels')
        for pair in case['arrays']:
            for key in ('inputs','reference'):
                p=path(dataset_path.parent,pair[key]['path'])
                need(sha(p)==pair[key]['sha256'],'frozen arrays changed')
            eligible[(pair['inputs']['sha256'],pair['reference']['sha256'])]=(case,pair)
    freeze_path=args.model_freeze.resolve()/'freeze.json';freeze=read(freeze_path)
    for key in ('model','dataset','training_audit','fitter'):
        record=freeze[key];need(sha(record['path'])==record['sha256'],'frozen dependency changed: '+key)
    model=read(freeze['model']['path'])
    need(model['schema']=='orbit.heterogeneous.region-cost.v13','wrong model schema')
    need(model['scope']['units']=='milliseconds' and model['scope']['physical_ddr_measurement'] is False and
         model['scope']['execution_clock_measurement'] is False and model['scope']['warmups_used'] is False,
         'model units/measurement scope differs')
    need(model['dataset_identity']['sha256']==sha(dataset_path),'model dataset differs')
    need(model['interpolation']['extrapolation'] is False and model['interpolation']['minimum_distinct_knots']==2,'model range contract differs')
    model_rows={(r['device'],r['task_count']):r for r in model['region_models']}
    need(set(model_rows)=={(d,n) for d in ('cpu','npu') for n in (1,2,3)},'missing/duplicate model device/count rows')
    executor=read(root/'executor-identity.json')
    need(sha(root/executor['source'])==executor['sha256'],'running executor snapshot changed')
    cases=read(cases_path)['cases'];need(len({c['name'] for c in cases})==len(cases),'duplicate case names')
    bound={};case_reports=[];file_ids=[]
    for row in cases:
        name=row['name'];need('/' not in name,'unsafe case name')
        pairs=[]
        need(len(row['inputs'])==len(row['reference'])>0,'input/reference count mismatch')
        for i,r in zip(row['inputs'],row['reference']):
            key=(sha(path(cases_path.parent,i)),sha(path(cases_path.parent,r)))
            need(key in eligible,'sample not in declared '+args.split+' split')
            pairs.append(eligible[key])
        compiled_path=path(cases_path.parent,row['compiled']);compiled=read(compiled_path)
        manifest_path=path(compiled_path.parent,compiled['manifest']);manifest=read(manifest_path)
        prep_path=root/name/'preparation.json';prep=read(prep_path)
        need(sha(compiled_path)==prep['compiled_sha256'] and sha(manifest_path)==compiled['manifest_sha256']==prep['manifest_sha256'],'compiled/native/preparation SHA mismatch')
        need(manifest['id']==compiled['plan_id']==prep['plan_id'],'plan id mismatch')
        need(manifest['program_family_key']==model['program_family_key'],'source family differs')
        contract=manifest['execution_contract'];validation=prep['execution_contract_validation']
        # C++ hashes the canonical compact sorted JSON value, not formatting of the external file.
        contract_sha=hashlib.sha256(json.dumps(contract,sort_keys=True,separators=(',',':')).encode()).hexdigest()
        need(contract_sha==manifest['execution_contract_identity']==model['execution_contract_identity']==prep['execution_contract_identity']==validation['identity'],'execution contract identity mismatch')
        need(contract['executor_sha256']==executor['sha256']==prep['execution_executor_sha256']==validation['executor_sha256'],'execution observer differs from contract')
        for role,record in contract['files'].items():
            need(sha(record['path'])==record['sha256'],'contract file changed: '+role)
            need(validation['files'][role]==record,'recorded contract validation differs')
        need(manifest['numeric_contract']==dict(dtype='f32',atol=1e-5,rtol=1e-5,cpu_contraction='off',approximate_math=False),'numeric contract differs')
        need(manifest['region_events']==manifest['graph']['region_events'],'exported lifecycle differs from parent graph')
        need(manifest['graph_id']==manifest['graph']['id'],'parent graph id mismatch')
        need(sorted(t for region in manifest['regions'] for t in region['tasks'])==[0,1,2],'task partition differs')
        need(len(compiled['regions'])==len(manifest['regions']),'compiled region count mismatch')
        used=set();abi_proofs={(p['region'],p['argument']):p for p in prep['abi_pointer_proof']}
        expected_proofs=0;npu_regions=0
        for region,record in zip(manifest['regions'],compiled['regions']):
            index=region['index'];need(index==record['index'] and region['device']==record['device'],'region executable binding mismatch')
            source=path(manifest_path.parent,region['source']);need(sha(source)==record['source_sha256'],'child source SHA mismatch')
            count=math.prod(pairs[0][0]['shape'])
            need(region['work_elements']==count*len(region['tasks']) and region['model_operations_supported'],'native source arithmetic work differs')
            abi=region['npu_abi'] if region['device']=='npu' else region['abi']
            for argument in abi:
                used.add(argument['storage']);expected_proofs+=1
                proof=abi_proofs[(index,argument['argument'])];pointer=prep['pointers'][str(argument['storage'])]
                need(proof['storage']==argument['storage'] and proof['copy']==argument['copy'],'ABI storage/copy witness differs')
                need(proof['array_address']==pointer['address'] and proof['offset_bytes']==0 and proof['shape']==argument['shape'],'ABI pointer/shape mismatch')
                strides=[4*math.prod(argument['shape'][j+1:]) for j in range(len(argument['shape']))]
                need(proof['strides_bytes']==strides,'ABI stride mismatch')
                if pointer['realization']=='xrt-mapped-bo':
                    need(proof['aliases_bo'] is True and proof['bo_map_address']==proof['array_address'],'mapped BO alias missing')
                else:need(proof['bo_map_address'] is None and proof['aliases_bo'] is None,'host storage falsely claims BO alias')
            if region['device']=='cpu':
                need(sha(record['library'])==record['library_sha256'],'CPU library changed')
                need(sha(record['cpu_source'])==record['cpu_source_sha256'],'CPU implementation source changed')
            else:
                npu_regions+=1
                need(sha(record['artifact']['elf_path'])==record['artifact']['elf_sha256'],'NPU ELF changed')
                need(sha(path(manifest_path.parent,region['air']))==record['air_sha256'],'AIR source changed')
                need(sha(path(manifest_path.parent,region['npu_abi_path']))==record['abi_sha256'],'NPU ABI changed')
        need(expected_proofs==len(abi_proofs)==len(prep['abi_pointer_proof']),'extra/missing ABI pointer proof')
        need(set(map(int,prep['pointers']))==used,'duplicate parent allocation for internal-only storage')
        intervals=[]
        for storage_index in used:
            pointer=prep['pointers'][str(storage_index)];storage=manifest['storage'][storage_index]
            need(pointer['bytes']==storage['bytes'] and pointer['address']%4==0,'parent storage size/alignment differs')
            intervals.append((pointer['address'],pointer['address']+pointer['bytes']))
        intervals.sort()
        need(all(a[1]<=b[0] for a,b in zip(intervals,intervals[1:])),'distinct noalias parent storages overlap')
        need(set(prep['compiled_internal_storages'])==set(range(len(manifest['storage'])))-used,'internal storage classification differs')
        if npu_regions:
            need(validation['imported_multilaunch_verified'] is True,'actual imported runner not verified')
            need(prep['runtime']['sha256']==contract['files']['multilaunch']['sha256'],'actual runner identity differs')
        bound[name]=(row,pairs,manifest,prep)
        file_ids.append(dict(case=name,compiled=identity(compiled_path),manifest=identity(manifest_path),preparation=identity(prep_path)))
        case_reports.append(dict(case=name,regions=len(manifest['regions']),npu_regions=npu_regions,
            mapped_bo_storages=sum(p['realization']=='xrt-mapped-bo' for p in prep['pointers'].values()),
            abi_pointer_bindings=len(abi_proofs),compiled_internal_storages=prep['compiled_internal_storages'],
            native_work=[dict(device=r['device'],task_count=len(r['tasks']),work_elements=r['work_elements']) for r in manifest['regions']]))
    summary=read(root/'summary.json');need(summary['status']=='passed','executor run failed')
    metrics=[];region_values=defaultdict(list);boundary_values=defaultdict(list);hot_case=defaultdict(list);observations=defaultdict(int);seen=set()
    for sample in summary['samples']:
        name=sample['case'];seed=sample['seed_index'];repeat=sample['repeat'];key=(name,seed,repeat)
        need(key not in seen,'duplicate sample');seen.add(key)
        row,pairs,manifest,prep=bound[name];case,pair=pairs[seed]
        p=root/name/f'seed-{seed}'/f'repeat-{repeat}'/'result.json';result=read(p)
        need(all(sample[k]==v for k,v in result.items()),'summary/raw sample mismatch')
        need(result['passed'] and result['input_reset_in_timing'] and result['final_output_copy_in_timing'],'sample failed or wrong boundary')
        inputs_path=path(dataset_path.parent,pair['inputs']['path']);ref_path=path(dataset_path.parent,pair['reference']['path']);actual_path=p.with_name('outputs.npz')
        with np.load(inputs_path,allow_pickle=False) as inp,np.load(ref_path,allow_pickle=False) as refs,np.load(actual_path,allow_pickle=False) as actual:
            need(set(actual.files)==set(refs.files)=={'C'},'wrong output names')
            expected=(2*(inp['A'].astype(np.float64)+inp['B'].astype(np.float64))+inp['B'].astype(np.float64)).astype(np.float32)
            need(np.array_equal(expected,refs['C']),'frozen reference formula mismatch')
            need(actual['C'].dtype==np.float32,'output dtype mismatch')
            metric=numerical_metrics(actual['C'],expected);need(metric['passed'],'independent numerical failure')
        events=result['events'];logical=manifest['region_events'];logical_times=defaultdict(list)
        calls=result['region_calls'];need([c['region'] for c in calls]==list(range(len(manifest['regions']))),'region call sequence differs')
        last_end=None;region_ms=[]
        for call,region in zip(calls,manifest['regions']):
            index=region['index'];need(call['end_ns']>=call['start_ns'] and (last_end is None or call['start_ns']>=last_end),'overlapping/invalid region interval');last_end=call['end_ns']
            need(call['manifest_region_event_ids']==[e['id'] for e in logical if e['region']==index],'region lifecycle ID list differs')
            ms=(call['end_ns']-call['start_ns'])/1e6;region_ms.append(ms)
            revents=[e for e in events if e.get('region')==index]
            for e in revents:
                need(call['start_ns']<=e['start_ns']<=e['end_ns']<=call['end_ns'],'API event outside composite region interval')
                observations[e['kind']]+=1
                for event_id in e.get('public_region_event_ids',[]):
                    le=logical[event_id];need(le['id']==event_id and le['region']==index,'invalid public lifecycle link')
                    kind=le['kind'];valid=False
                    if e['kind']=='actual_cpu_library_call':valid=kind in ('submit','complete')
                    if e['kind']=='actual_xrt_start':valid=kind=='submit'
                    if e['kind']=='actual_xrt_wait':valid=kind=='complete'
                    if e['kind']=='actual_bo_sync':
                        valid=(kind=='visible-to-device' and 'TO_DEVICE' in e['direction']) or (kind=='visible-to-host' and 'FROM_DEVICE' in e['direction'])
                        abi=region['npu_abi'];storage=e['storage']
                        need(any(a['storage']==storage and a['copy'] in le['copies'] for a in abi),'sync storage/copy not in linked public visibility event')
                    need(valid,'actual API kind does not implement linked lifecycle event')
                    logical_times[event_id].append(e['start_ns'] if kind=='submit' and e['kind']=='actual_cpu_library_call' else e['end_ns'])
            if region['device']=='cpu':
                ce=[e for e in revents if e['kind']=='actual_cpu_library_call'];need(len(ce)==1,'CPU library invocation count differs')
                need(len(ce[0]['abi_descriptors'])==len(region['abi']),'CPU descriptor count differs')
                for descriptor,argument in zip(ce[0]['abi_descriptors'],region['abi']):
                    pointer=prep['pointers'][str(argument['storage'])]
                    need(descriptor['argument']==argument['argument'] and descriptor['storage']==argument['storage'] and descriptor['copy']==argument['copy'],'actual CPU descriptor binding differs')
                    need(descriptor['allocated']==descriptor['aligned']==pointer['address'] and descriptor['offset']==0 and descriptor['sizes']==argument['shape'],'actual CPU pointer/shape differs')
                    need(descriptor['strides']==[math.prod(argument['shape'][j+1:]) for j in range(len(argument['shape']))],'CPU descriptor stride differs')
            else:
                stage=[e for e in revents if e['kind']=='runner_staging_observation'];need(len(stage)==1,'missing runner staging observation')
                need(stage[0]['numpy_copyto_calls']==[] and stage[0]['all_arguments_bound'] is True,'runner host staging observed')
                need(sum(e['kind']=='actual_xrt_start' for e in revents)==sum(e['kind']=='actual_xrt_wait' for e in revents)==1,'XRT start/wait count differs')
                for e in revents:
                    if e['kind']=='actual_bo_sync' and not e['public_region_event_ids']:
                        need('conservative installed-runner sync' in e.get('binding_scope',''),'unlinked sync lacks explicit conservative scope')
            if not result['warmup']:
                region_values[(region['device'],len(region['tasks']),region['work_elements'])].append((ms,p,actual_path))
        need(set(logical_times)==set(range(len(logical))),'missing actual lifecycle realization')
        for e in logical:
            need(all(d<e['id'] for d in e['dependencies']),'non-prior public lifecycle dependency')
            need(all(max(logical_times[d])<=max(logical_times[e['id']]) for d in e['dependencies']),'actual timing violates public lifecycle dependency')
        resets=[e for e in events if e['kind']=='host_input_reset'];copies=[e for e in events if e['kind']=='host_final_output_copy']
        need({e['storage'] for e in resets}=={s['index'] for s in manifest['storage'] if s['role']=='input'} and len(resets)==2 and len(copies)==1,'input/final copy count mismatch')
        boundary=result['wall_ms']-sum(region_ms);explicit=sum((e['end_ns']-e['start_ns'])/1e6 for e in resets+copies)
        need(boundary>=explicit-1e-9,'negative outer boundary residual')
        entry=dict(case=name,seed_index=seed,repeat=repeat,warmup=result['warmup'],result=identity(p),outputs=identity(actual_path),numerical=metric,wall_ms=result['wall_ms'],region_ms=region_ms,boundary_ms=boundary,explicit_input_and_output_copy_ms=explicit,other_outer_gaps_ms=boundary-explicit)
        metrics.append(entry)
        if not result['warmup']:
            byte_count=sum(s['bytes'] for s in manifest['storage'] if s['role'] in ('input','output'))
            boundary_values[byte_count].append((boundary,p,actual_path));hot_case[name].append(result['wall_ms'])
    recomputed=[]
    if args.split=='training':
        for (device,count),row in model_rows.items():
            keys=sorted(k for k in region_values if k[:2]==(device,count))
            need(len(keys)==len(row['knots'])>=2 and row['status']=='calibrated','model knot domain differs from raw training')
            for key,knot in zip(keys,row['knots']):
                values=region_values[key]
                need(key[2]==knot['work_elements'] and len(values)==knot['n'] and statistics.median(v[0] for v in values)==knot['ms'],'model regional median/count differs from raw measurements')
                bindings=sorted({(str(v[1]),sha(v[1]),sha(v[2])) for v in values})
                need(hashlib.sha256(json.dumps(bindings,separators=(',',':')).encode()).hexdigest()==knot['raw_sha256'],'regional raw provenance digest differs')
            recomputed.append(dict(device=device,task_count=count,knots=len(keys),passed=True))
        need(len(boundary_values)==len(model['boundary_model']['knots']),'boundary knot domain differs')
        for byte_count,knot in zip(sorted(boundary_values),model['boundary_model']['knots']):
            values=boundary_values[byte_count]
            need(byte_count==knot['bytes'] and len(values)==knot['n'] and statistics.median(v[0] for v in values)==knot['ms'],'model boundary median/count differs from raw')
            bindings=sorted({(str(v[1]),sha(v[1]),sha(v[2])) for v in values})
            need(hashlib.sha256(json.dumps(bindings,separators=(',',':')).encode()).hexdigest()==knot['raw_sha256'],'boundary raw provenance digest differs')
    report=dict(schema='orbit.heterogeneous.independent-validation.v13',status='passed',split=args.split,
        executor=identity(root/'executor-source.py'),cases_file=identity(cases_path),dataset=identity(dataset_path),model_freeze=identity(freeze_path),model=freeze['model'],
        sample_count=len(metrics),hot_samples=sum(not s['warmup'] for s in metrics),max_abs=max(s['numerical']['max_abs'] for s in metrics),
        region_model_rows_recomputed=recomputed,case_provenance=file_ids,cases=case_reports,samples=metrics,actual_api_event_counts=dict(observations),
        timing_summary=[dict(case=name,wall_ms=distribution(values)) for name,values in sorted(hot_case.items())],
        scope=dict(numeric_atol=1e-5,numeric_rtol=1e-5,units='milliseconds host monotonic wall',
            no_double_count='model boundary is whole wall minus all composite region walls, once; sync/start/wait remain inside regional labels',
            pointer_proof='recorded actual addresses/ctypes descriptors and BO mappings, not a physical memory traffic measurement',
            zero_runner_staging='observed numpy.copyto only inside bound existing runner; does not imply zero BO synchronization or zero DMA',
            physical_ddr_measurement=False,device_cycle_measurement=False,model_retuned=False,device_submissions=0))
    out.mkdir(parents=True);(out/'validator-source.py').write_bytes(Path(__file__).read_bytes());(out/'metrics-source.py').write_bytes(Path(__file__).with_name('heterogeneous_validation_v13.py').read_bytes())
    (out/'summary.json').write_text(json.dumps(report,indent=2,allow_nan=False)+'\n')
    print(json.dumps(dict(status='passed',samples=len(metrics),hot_samples=report['hot_samples'],max_abs=report['max_abs'],output=str(out))))


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--execution-root',type=Path,required=True)
    parser.add_argument('--cases',type=Path,required=True)
    parser.add_argument('--fixtures',type=Path,required=True)
    parser.add_argument('--model-freeze',type=Path,required=True)
    parser.add_argument('--split',choices=['training','holdout'],required=True)
    parser.add_argument('--output',type=Path,required=True)
    audit(parser.parse_args())

if __name__=='__main__':main()
