#!/usr/bin/env python3
"""Independent CPU evidence audit of frozen v14 API-only sync models.

Does not import the fitter, re-estimate parameters, or attribute residuals to DMA.
"""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import numpy as np


def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def load(p): return json.loads(Path(p).read_text())
def identify(p): return {'path':str(Path(p).resolve()),'sha256':sha(p)}
def verify(x):
    p=Path(x['path']); assert sha(p)==x['sha256'], f'changed evidence: {p}'
    return p

def statistics(a):
    a=np.asarray(a,dtype=float); m=float(np.median(a))
    return {'n':len(a),'median_ns':m,'mad_ns':float(np.median(abs(a-m))),
            'p5_ns':float(np.percentile(a,5)),'p95_ns':float(np.percentile(a,95)), 'max_ns':float(max(a)),
            'above_median_plus_6mad':int(np.sum(a>m+6*max(1,float(np.median(abs(a-m))))))}

def identity(root,protocol,split,program=False):
    root=Path(root);i=load(root/'identity.json')
    assert i['split']==split and i['protocol']['sha256']==sha(protocol)
    assert sha(root/'protocol.json')==sha(protocol)
    before=load(root/'runtime-fingerprint-before.json')
    assert before==load(root/'runtime-fingerprint-after.json')
    assert before['target_id']==i['runtime_target_id']
    assert before==load(verify(load(protocol)['runtime_fingerprint']))
    assert sha(root/('sequence-source.py' if program else 'microbench-source.py'))==i['source_sha256']
    assert load(root/'summary.json')['status']=='passed'
    return i

def assess(predicted,actual,abs_floor,fraction):
    err=abs(float(predicted)-float(actual));limit=max(abs_floor,fraction*actual)
    return {'prediction_ns':float(predicted),'actual_median_ns':float(actual),
            'signed_error_ns':float(predicted-actual),'absolute_error_ns':err,
            'relative_error':err/actual if actual else None,
            'acceptance_limit_ns':float(limit),'measurement_accuracy_passed':err<=limit}

def matching_row(model,i,program,**tags):
    source=i['source_sha256'];observer=i['observer']['sha256'] if program else source
    matches=[]
    for row in model['rows']:
        d=row['domain'];c=model['conditions'][d['condition_identity']]
        if all(d.get(k)==v for k,v in tags.items()) and d['runtime_identity']==i['runtime_target_id'] and d['observer_identity']==observer:
            assert c['source_sha256']==source
            assert c['allocation_scope']==('reused-prepared-bound-bo' if program else 'fresh-ext-bo-per-sample')
            assert c['prepared_context_count']==(len(i['cases']) if program else len(i['program_input_identities']))
            if program: assert c['executor_sha256']==i['executor']['sha256']
            digest=hashlib.sha256(json.dumps(c,sort_keys=True,separators=(',',':')).encode()).hexdigest()
            assert digest==d['condition_identity']
            matches.append(row)
    assert len(matches)==1, 'exact runtime, condition, source and observation domain must match once'
    return matches[0]

def micro(root,protocol,split,model):
    i=identity(root,protocol,split);registered={c['id']:c for c in load(protocol)['cells'] if c['split']==split}
    groups={};ood={}; seen=set();samples=0
    for line in (Path(root)/'samples-index.jsonl').read_text().splitlines():
        rec=json.loads(line);p=verify(rec['sample']);s=load(p);c=s['cell']
        assert s['split']==split and c==registered[s['cell_id']]
        key=(s['cell_id'],s['seed'],s['repeat']);assert key not in seen;seen.add(key)
        assert s['unit']=='ns'
        if s['warmup']: continue
        samples+=1
        primary=c['direction']=='TO_DEVICE' and c['observer_mode']=='batch' and c['state']=='unchanged-repeat' and c['program_case'] is None
        if not primary:
            g=ood.setdefault(c['id'],{'cell':c,'prediction':None,'reason':'prespecified observer/state diagnostic outside primary model','values':[],'seeds':{}})
            g['values'].append(s['outer_sequence_ns'])
            g['seeds'].setdefault(str(s['seed']),[]).append(s['outer_sequence_ns'])
            continue
        assert [x['kind'] for x in s['setup']]==['new-ext-bo-map-initialize','untimed-prior-sync']
        assert all(x['state_before']=='after-TO_DEVICE-sync' and x['dirty_range'] is None for x in s['state_transitions'])
        assert len(s['state_transitions'])==c['sequence_count']==s['actual_api_call_count']
        assert s['actual_sync_extent']=={'offset':c['offset_bytes'],'bytes':c['size_bytes'],'implicit_uses_verified_whole_bo':c['invocation_form']=='whole-implicit'}
        assert s['bo']['actual_size']==c['bo_bytes']
        assert s['outer_sequence_ns']==s['end_ns']-s['start_ns']>0
        g=groups.setdefault(c['id'],{'cell':c,'values':[],'seeds':{}})
        g['values'].append(s['outer_sequence_ns']);g['seeds'].setdefault(str(s['seed']),[]).append(s['outer_sequence_ns'])
    reports=[]
    for g in groups.values():
        c=g['cell'];a=statistics(g['values'])
        assert set(map(int,g['seeds']))==set(load(protocol)['seeds'])
        assert all(len(v)==c['repeats'] for v in g['seeds'].values())
        row=matching_row(model,i,False,site='prebound-contiguous-sync-loop',argument_ordinal=-1,call_form=c['invocation_form'],observer_boundary='batch-outer',direction='TO_DEVICE')
        d=row['domain'];assert d['min_bytes']<=c['size_bytes']<=d['max_bytes'] and d['min_count']<=c['sequence_count']<=d['max_count']
        assert c['size_bytes']%64==c['offset_bytes']%64==0
        pred=row['entry_ns']+c['sequence_count']*(row['call_ns']+row['cacheline_ns']*(c['size_bytes']//64))
        reports.append({'cell':c,'statistics':a,'seed_statistics':{k:statistics(v) for k,v in g['seeds'].items()},
            'count_exceeds_calibration_max16':c['sequence_count']>16,**assess(pred,a['median_ns'],500,.15)})
    assert len(reports)==36
    diagnostics=[{k:v for k,v in g.items() if k not in ('values','seeds')}|{'outer_statistics':statistics(g['values']),'seed_outer_statistics':{k:statistics(v) for k,v in g['seeds'].items()}} for g in ood.values()]
    return {'identity':identify(Path(root)/'identity.json'),'raw_samples_hot':samples,'cells':reports,'unpriced_diagnostic_cells':diagnostics}

def program(root,protocol,split,model):
    i=identity(root,protocol,split,True);cases={c['name']:c for c in i['cases']}
    for case in cases.values():
        prep=load(Path(root)/'preparation'/(case['name']+'.json'))
        for ptr in prep['abi_pointer_proof']:
            assert ptr['aliases_bo'] and ptr['array_address']==ptr['bo_map_address'] and ptr['offset_bytes']==0
        for key in ('compiled','manifest'): verify(prep[key])
        for elf in prep['elf']: verify(elf)
    refs={};counts=0;worst=0.;seqgroups={};sitegroups={};alloutputs=[]
    for s in load(Path(root)/'program-sequences.json'):
        assert s['split']==split and len(s['calls'])==s['count']
        assert not s['fit_outer_sequence'] and not s['fit_one_wall']
        case=cases[s['case']]
        seeds=load(protocol)['seeds'];idx=seeds.index(s['seed'])
        ck=(s['case'],s['seed'])
        if ck not in refs:
            with np.load(verify(case['inputs'][idx])) as z: source={k:z[k].astype(np.float64) for k in z.files}
            assert set(source)=={'A','B'}
            exact=(source['A']+source['B'])*2+source['B']
            with np.load(verify(case['reference'][idx])) as z:
                assert set(z.files)=={'C'}
                assert np.allclose(z['C'],exact,rtol=1e-5,atol=1e-5)
            refs[ck]=exact
        observed=predicted=0.
        for call in s['calls']:
            raw=load(verify(call['raw_result']));output=verify(call['raw_outputs'])
            with np.load(output) as z:
                assert set(z.files)=={'C'}
                actual=z['C'].astype(np.float64);ref=refs[ck]
                assert actual.shape==ref.shape and np.isfinite(actual).all()
                delta=actual-ref;maxabs=float(np.max(abs(delta)))
                assert np.all(abs(delta)<=1e-5+1e-5*abs(ref)), 'independent numerical failure'
                counts+=1;worst=max(worst,maxabs)
                alloutputs.append({'output':call['raw_outputs'],'max_abs_f64':maxabs,
                    'relative_floor_1e-6':float(np.max(abs(delta)/np.maximum(abs(ref),1e-6))),
                    'normalized_l2':float(np.linalg.norm(delta)/max(np.linalg.norm(ref),1e-30))})
            ev=raw['events'];sync=call['sync_api_sites']
            assert [(x['argument_ordinal'],x['direction']) for x in sync]==[(0,'TO_DEVICE'),(1,'TO_DEVICE'),(2,'TO_DEVICE'),(2,'FROM_DEVICE')]
            assert sum(e['kind']=='actual_xrt_start' for e in ev)==sum(e['kind']=='actual_xrt_wait' for e in ev)==1
            staging=[e for e in ev if e['kind']=='runner_staging_observation']
            assert len(staging)==1 and staging[0]['numpy_copyto_calls']==[] and staging[0]['all_arguments_bound']
            wait=next(e for e in ev if e['kind']=='actual_xrt_wait')
            reset={e['storage'] for e in ev if e['kind']=='host_input_reset'};assert reset=={0,1}
            for e in sync:
                assert e['invocation_form']=='implicit-full-buffer' and e['observation_boundary']=='detailed-compatibility'
                actual_event=ev[e['event_index']]
                assert actual_event['kind']=='actual_bo_sync' and actual_event['start_ns']==e['start_ns'] and actual_event['end_ns']==e['end_ns']
                assert e['elapsed_ns']==e['end_ns']-e['start_ns']>0
                assert e['requested_bo_size']==e['actual_bo_extent'] and e['requested_offset_bytes']==0
                if e['direction']=='FROM_DEVICE':assert e['start_ns']>=wait['end_ns']
                else: assert e['end_ns']<=wait['start_ns']
                row=matching_row(model,i,True,site=e['site'],argument_ordinal=e['argument_ordinal'],call_form='whole-implicit',observer_boundary='detailed-compatibility',direction=e['direction'])
                d=row['domain'];assert d['min_bytes']<=e['actual_bo_extent']<=d['max_bytes']
                assert row['entry_ns']==row['cacheline_ns']==0 and d['min_count']==d['max_count']==1
                predicted+=row['call_ns'];observed+=e['elapsed_ns']
                if not s['warmup']:
                    sk=(e['site'],e['argument_ordinal'],e['direction'],s['case'],s['count'])
                    g=sitegroups.setdefault(sk,{'site':e['site'],'argument_ordinal':e['argument_ordinal'],'direction':e['direction'],'case':s['case'],'sequence_count':s['count'],'values':[],'prediction_ns':row['call_ns']})
                    g['values'].append(e['elapsed_ns'])
        if not s['warmup']:
            k=(s['case'],s['count']);g=seqgroups.setdefault(k,{'case':s['case'],'count':s['count'],'values':[],'seeds':{},'prediction_ns':predicted})
            assert g['prediction_ns']==predicted
            g['values'].append(observed);g['seeds'].setdefault(str(s['seed']),[]).append(observed)
    reports=[]
    for g in seqgroups.values():
        a=statistics(g['values']);reports.append({k:v for k,v in g.items() if k not in ('values','seeds')}|{'statistics':a,'seed_statistics':{k:statistics(v) for k,v in g['seeds'].items()},**assess(g['prediction_ns'],a['median_ns'],2000,.20)})
    sites=[]
    for g in sitegroups.values():
        a=statistics(g['values']);sites.append({k:v for k,v in g.items() if k!='values'}|{'statistics':a,'absolute_error_ns':abs(g['prediction_ns']-a['median_ns'])})
    return {'identity':identify(Path(root)/'identity.json'),'numerical_outputs':counts,'max_abs_f64':worst,'outputs':alloutputs,'sequence_subtotal_cells':reports,'individual_site_cells':sites,
        'composition_scope':'sum of exactly four actual sync spans per call; no wall/wait/compute residual attributed to transfer'}

def calibration_optimality(model,micro_report,program_report):
    """Independent convex KKT check, not a second fitted production model."""
    reports=[]
    for row in model['rows']:
        d=row['domain']
        if row['formula']=='batch-entry-plus-cachelines':
            cells=[c for c in micro_report['cells'] if c['cell']['invocation_form']==d['call_form']]
            x=np.asarray([[1,c['cell']['sequence_count'],c['cell']['sequence_count']*c['cell']['size_bytes']/64] for c in cells],float)
            y=np.asarray([c['statistics']['median_ns'] for c in cells])
            b=np.asarray([row['entry_ns'],row['call_ns'],row['cacheline_ns']])
            scale=np.linalg.norm(x,axis=0);z=x/scale
            assert np.linalg.matrix_rank(z)==3
            gradient=z.T@(x@b-y)
            tolerance=1e-7*max(1,float(np.linalg.norm(y)))
            for j in range(3):
                if b[j]>1e-9:assert abs(gradient[j])<=tolerance,'nonzero coefficient fails independent NNLS stationarity'
                else:assert gradient[j]>=-tolerance,'zero coefficient fails independent NNLS inequality'
            reports.append({'form':d['call_form'],'kkt_gradient_scaled':gradient.tolist(),'rank':3,'condition':float(np.linalg.cond(z)),'passed':True})
        else:
            cells=[c for c in program_report['individual_site_cells'] if c['site']==d['site'] and c['argument_ordinal']==d['argument_ordinal'] and c['direction']==d['direction']]
            assert len(cells)==4
            median=float(np.median([c['statistics']['median_ns'] for c in cells]))
            assert median==row['call_ns']
            reports.append({'site':d['site'],'argument_ordinal':d['argument_ordinal'],'independent_equal_cell_median_ns':median,'passed':True})
    return reports


def main():
    p=argparse.ArgumentParser(description=__doc__)
    for n in ('protocol','calibration-root','program-calibration-root','holdout-root','program-holdout-root','model-root','output'):p.add_argument('--'+n,required=True)
    p.add_argument('--holdout-gate');a=p.parse_args();out=Path(a.output);assert not out.exists()
    mr=Path(a.model_root);freeze=load(mr/'freeze.json')
    for x in freeze['files'].values():verify(x)
    model=load(mr/'model.json');assert model['schema']=='orbit.sync-api.model.v14' and len(model['rows'])==7 and model['units']=='ns'
    for row in model['rows']:
        assert all(np.isfinite(row[k]) and row[k]>=0 for k in ('entry_ns','call_ns','cacheline_ns'))
    if a.holdout_gate:
        gate=load(a.holdout_gate)
        # Gate formats are producer-specific; retain and hash the full immutable receipt.
        assert sha(mr/'model.json') in json.dumps(gate), 'gate must bind exact parameter bytes'
    result={'schema':'orbit.sync-api.independent-validation.v14','structural_and_numerical_status':'passed',
        'model':identify(mr/'model.json'),'freeze':identify(mr/'freeze.json'),
        'calibration_micro':micro(a.calibration_root,a.protocol,'calibration',model),
        'calibration_program':program(a.program_calibration_root,a.protocol,'calibration',model),
        'holdout_micro':micro(a.holdout_root,a.protocol,'holdout',model),
        'holdout_program':program(a.program_holdout_root,a.protocol,'holdout',model)}
    result['independent_training_optimality']=calibration_optimality(model,result['calibration_micro'],result['calibration_program'])
    for key,field in [('holdout_micro','cells'),('holdout_program','sequence_subtotal_cells')]:
        cells=result[key][field];result[key]['measurement_accuracy_pass_fraction']=sum(c['measurement_accuracy_passed'] for c in cells)/len(cells)
        result[key]['measurement_accuracy_passed_cells']=sum(c['measurement_accuracy_passed'] for c in cells)
        result[key]['measurement_accuracy_total_cells']=len(cells)
    result['limitations']=['Measurement-accuracy failure is separate from structural/numerical audit status.',
        'Count23 exceeds maximum calibration count16: predeclared analytical count assumption is tested, not interpolated.',
        'No physical traffic, DDR bandwidth, full program cost, or speedup claim.',
        'Old v13 API scopes/forms and primary batch boundary differ; coefficients are not apples-to-apples physical baselines.',
        'Dirty and other observer cells remain unpriced OOD diagnostics; no holdout refit.']
    out.mkdir(parents=True);(out/'summary.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n');shutil.copyfile(__file__,out/'auditor-source.py')
    print(json.dumps({'status':'passed','summary':identify(out/'summary.json'),'holdout_micro_pass_fraction':result['holdout_micro']['measurement_accuracy_pass_fraction'],'holdout_program_pass_fraction':result['holdout_program']['measurement_accuracy_pass_fraction']}))

if __name__=='__main__': main()
