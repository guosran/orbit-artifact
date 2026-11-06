#!/usr/bin/env python3
"""Post-freeze descriptive error analysis; no fitting or device access."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import numpy as np


def read(p):return json.loads(Path(p).read_text())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def ident(p):return {'path':str(Path(p).resolve()),'sha256':sha(p)}
def stat(v):
    x=np.asarray(v,float);m=float(np.median(x));mad=float(np.median(abs(x-m)))
    return {'n':len(x),'median_ns':m,'mad_ns':mad,'p5_ns':float(np.percentile(x,5)),
            'p95_ns':float(np.percentile(x,95)),'max_ns':float(max(x)),
            'above_median_plus_6mad':int(np.sum(x>m+6*max(1,mad)))}
def errors(rows):
    return {'cells':len(rows),'passed_cells':sum(r['measurement_accuracy_passed'] for r in rows),
        'median_absolute_error_ns':float(np.median([r['absolute_error_ns'] for r in rows])),
        'max_absolute_error_ns':float(max(r['absolute_error_ns'] for r in rows)),
        'mean_absolute_percentage_error':float(np.mean([r['relative_error'] for r in rows])),
        'max_relative_error':float(max(r['relative_error'] for r in rows))}

def main():
    p=argparse.ArgumentParser(description=__doc__)
    for key in ('audit','model-root','v13-parameters','output'):p.add_argument('--'+key,required=True)
    a=p.parse_args();out=Path(a.output);assert not out.exists()
    audit=read(a.audit);mr=Path(a.model_root);model=read(mr/'model.json');fit=read(mr/'fit-report.json')
    assert audit['model']['sha256']==sha(mr/'model.json') and audit['structural_and_numerical_status']=='passed'
    frozen=read(mr/'freeze.json')
    for x in frozen['files'].values():assert sha(x['path'])==x['sha256']
    batch=audit['holdout_micro']['cells'];program=audit['holdout_program']['sequence_subtotal_cells']
    result={'schema':'orbit.sync-api.postfreeze-error-analysis.v14','refit':False,
        'sources':{'audit':ident(a.audit),'model':ident(mr/'model.json'),'fit_report':ident(mr/'fit-report.json'),'v13_parameters':ident(a.v13_parameters)},
        'batch_overall':errors(batch),'batch_by_form':{},'program_subtotal_overall':errors(program),
        'failed_batch_cells':[r for r in batch if not r['measurement_accuracy_passed']],
        'numerical_outputs':audit['holdout_program']['numerical_outputs'],'max_abs_f64':audit['holdout_program']['max_abs_f64'],
        'program_per_api_seed_groups':[],'batch_seed_errors':[],
        'parameter_stability_training_only':[{k:v for k,v in r.items() if k!='cells'} for r in fit['rows']],
        'ood_diagnostics':audit['holdout_micro']['unpriced_diagnostic_cells']}
    for form in ('whole-implicit','whole-explicit','region-explicit'):
        result['batch_by_form'][form]=errors([r for r in batch if r['cell']['invocation_form']==form])
    for cell in batch:
        for seed,s in cell['seed_statistics'].items():
            actual=s['median_ns'];pred=cell['prediction_ns'];result['batch_seed_errors'].append({'cell':cell['cell'],'seed':seed,'statistics':s,'prediction_ns':pred,'signed_error_ns':pred-actual,'absolute_error_ns':abs(pred-actual),'relative_error':abs(pred-actual)/actual})
    root=Path(audit['holdout_program']['identity']['path']).parent
    raw=read(root/'program-sequences.json');groups={};subtotal={}
    for s in raw:
        if s['warmup']:continue
        for call in s['calls']:
            for e in call['sync_api_sites']:
                k=(e['site'],e['argument_ordinal'],e['direction'],e['requested_bo_size'],s['count'],s['seed'])
                groups.setdefault(k,[]).append(e['elapsed_ns'])
    for (site,ordinal,direction,size,count,seed),values in groups.items():
        rows=[r for r in model['rows'] if r['domain']['site']==site and r['domain']['argument_ordinal']==ordinal and r['domain']['direction']==direction]
        assert len(rows)==1
        row=rows[0];s=stat(values);pred=row['call_ns']
        result['program_per_api_seed_groups'].append({'site':site,'argument_ordinal':ordinal,'direction':direction,
            'bytes':size,'sequence_count':count,'seed':seed,'statistics':s,'prediction_ns':pred,
            'signed_error_ns':pred-s['median_ns'],'absolute_error_ns':abs(pred-s['median_ns']),
            'relative_error':abs(pred-s['median_ns'])/s['median_ns']})
    old=[r for r in read(a.v13_parameters)['parameters'] if r['mechanism']=='bo.sync_to_device' and r['state']=='after-TO_DEVICE-sync']
    assert len(old)==1;old=old[0];math=[]
    for cell in batch:
        c=cell['cell'];pred=c['sequence_count']*(old['alpha_ms']+old['beta_ms_per_byte']*c['size_bytes'])*1e6
        actual=cell['actual_median_ns'];math.append({'cell':c,'old_formula_counterfactual_ns':pred,
            'new_observed_batch_median_ns':actual,'absolute_difference_ns':abs(pred-actual),
            'relative_difference':abs(pred-actual)/actual,'inside_old_byte_bounds':old['min_bytes']<=c['size_bytes']<=old['max_bytes'],
            'comparable':False})
    result['v13_math_only_counterfactual']={'parameter':old,'cells':math,
        'comparison_status':'incomparable measurement boundaries and contexts; arithmetic illustration only',
        'reasons':['v13 fits individual three-argument API envelopes; v14 primary is outer counted-loop wall time.',
            'v14 whole-implicit uses one argument; region-explicit uses actual subranges.',
            'v13 retained long interruption inflates repeated-TO raw least-squares mean; v14 fits equal cell medians.',
            'Runtime/condition/observer domains are separately bound; no backward same-path claim.'],
        'physical_interpretation':None}
    result['limitations']=['All coefficients and observations retained; no outlier deletion, holdout refit, or threshold retuning.',
        'Cacheline coefficient describes observed loop/API work, not physical DDR bandwidth.',
        'Sequence entry combines wrapper/timer/loop transient; individual first-call attribution is not separated.',
        'Program per-API discrepancies may cancel in the matched subtotal; subtotal accuracy is not proof of every API accuracy.',
        'Count23 validates a predeclared count assumption beyond training16; dirty-state diagnostics remain OOD.',
        'No full-program latency, CPU-call, compute, wait, or physical-traffic cost is inferred.']
    out.mkdir(parents=True);(out/'summary.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n');shutil.copyfile(__file__,out/'analysis-source.py')
    print(json.dumps({'status':'passed','summary':ident(out/'summary.json'),'batch':result['batch_overall'],'program':result['program_subtotal_overall']}))

if __name__=='__main__':main()
