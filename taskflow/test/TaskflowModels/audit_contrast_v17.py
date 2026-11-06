#!/usr/bin/env python3
"""Independent freeze/paired/session audit for native contrast evidence adapters.

Does not own graphs, actions, planning or model configuration. --evaluate is the
only path that opens measurement JSONL. Adapter format is documented in main
module functions; all predictions and protocol/metric choices must be SHA-frozen.
"""
import argparse
from collections import defaultdict
import json
import math
from pathlib import Path
import statistics
from audit_mechanism_program_v16 import identity,verify,read,stats,quantile


def validate_predictions(predictions):
    rows={r['pair_id']:r for r in predictions['rows']}
    assert rows and len(rows)==len(predictions['rows'])
    for row in rows.values():
        assert row['orientation']=='candidate-minus-baseline'
        assert row['contrast_class'] and row['condition_id'] and row['covered_change']
        for side in ['baseline','candidate']:
            assert all(row[side][k] for k in ['graph_id','plan_id','artifact_sha256'])
        p=row['prediction_delta_ns']
        if p is None:assert row['unknown_reason']
        else:
            assert math.isfinite(p)
            assert row['common_work_policy'] in ['explicit-preserved-implementation','changed-implementation-coupled-contrast']
            assert row['implementation_evidence'],'same-source arithmetic alone cannot certify cost cancellation'
            for record in row['implementation_evidence']:verify(record)
    return rows

def run(manifest,evaluate):
    m=read(manifest);assert m['schema']=='orbit.contrast.audit-adapter.v17'
    for role in m['required_roles']:assert role in m['frozen']
    for record in m['frozen'].values():verify(record)
    predictions=read(verify(m['frozen']['predictions']));rows=validate_predictions(predictions)
    metric=read(verify(m['frozen']['metrics']))
    assert metric['orientation']=='candidate-minus-baseline'
    receipt=dict(status='passed',manifest=identity(manifest),frozen=m['frozen'],pair_ids=list(rows),holdout_labels_read=False,auditor=identity(__file__))
    if not evaluate:return receipt
    prior=read(verify(m['freeze_receipt']));assert prior['frozen']==m['frozen'] and prior['holdout_labels_read'] is False
    result=dict(status='passed',frozen=m['frozen'],freeze_receipt=m['freeze_receipt'],auditor=identity(__file__),sessions=[])
    for session in m['sessions']:
        assert session['freeze_receipt_sha256']==m['freeze_receipt']['sha256']
        assert session['model_sha256']==m['frozen']['model']['sha256'],'same-model validation cannot silently recalibrate'
        assert session['kind'] in ['unseen-pairs','same-model-new-session']
        protocol=read(verify(session['protocol']));groups=defaultdict(list);seen=set()
        for line in verify(session['samples']).read_text().splitlines():
            s=json.loads(line);row=rows[s['pair_id']];key=(s['pair_id'],s['seed'],s['repeat']);assert key not in seen;seen.add(key)
            assert s['condition_id']==row['condition_id']
            assert s['baseline']==row['baseline'] and s['candidate']==row['candidate'],'measured graph/plan/ELF differs from frozen predicted pair'
            assert s['warmup']==(s['repeat']<protocol['warmups'])
            assert all(math.isfinite(s[k]) and s[k]>=0 for k in ['baseline_ns','candidate_ns'])
            if not s['warmup']:groups[s['pair_id']].append(s)
        expected={(pair,seed,r) for pair in protocol['pair_ids'] for seed in protocol['seeds'] for r in range(protocol['warmups']+protocol['repeats'])};assert seen==expected
        reports=[]
        for pair,samples in sorted(groups.items()):
            row=rows[pair];values=[s['candidate_ns']-s['baseline_ns'] for s in samples];distribution=stats(values);med=distribution['median_ns'];p10,p90=quantile(values,.1),quantile(values,.9)
            seedmedians={str(seed):statistics.median(s['candidate_ns']-s['baseline_ns'] for s in samples if s['seed']==seed) for seed in protocol['seeds']}
            same_sign=all(v*med>0 for v in seedmedians.values())
            noise=max(metric['resolution_floor_ns'],p90-p10)
            resolved=abs(med)>noise and (same_sign or not metric['require_seed_sign_agreement'])
            prediction=row['prediction_delta_ns'];limit=max(metric['difference_absolute_floor_ns'],metric['difference_relative_fraction']*abs(med))
            error=None if prediction is None else abs(prediction-med)
            passed=resolved and prediction is not None and prediction*med>0 and error<=limit
            reports.append(dict(pair_id=pair,contrast_class=row['contrast_class'],prediction_delta_ns=prediction,observed_paired_delta=distribution,difference_of_cell_medians_ns=statistics.median(s['candidate_ns'] for s in samples)-statistics.median(s['baseline_ns'] for s in samples),per_seed_paired_medians_ns=seedmedians,paired_p10_ns=p10,paired_p90_ns=p90,measurement_noise_gate_ns=noise,measurement_resolved=resolved,seed_sign_agreement=same_sign,error_ns=error,error_limit_ns=limit,status='passed' if passed else ('unknown-prediction' if prediction is None else 'failed' if resolved else 'inconclusive'),baseline_distribution=stats([s['baseline_ns'] for s in samples]),candidate_distribution=stats([s['candidate_ns'] for s in samples])))
        classes={c for c in metric['required_classes']};class_result={c:dict(pairs=sum(r['contrast_class']==c for r in reports),resolved=sum(r['contrast_class']==c and r['measurement_resolved'] for r in reports),passed=sum(r['contrast_class']==c and r['status']=='passed' for r in reports)) for c in classes}
        ready=all(v['resolved']>=metric['min_resolved_pairs_per_class'] and v['passed']==v['resolved'] for v in class_result.values())
        result['sessions'].append(dict(id=session['id'],kind=session['kind'],samples=session['samples'],protocol=session['protocol'],pairs=reports,by_class=class_result,contrast_gate_passed=ready))
    result['contrast_gate_passed']=bool(result['sessions']) and all(s['contrast_gate_passed'] for s in result['sessions'])
    result['scope']='Raw paired distributions retained. Empirical quantiles are descriptive, not statistical confidence bounds; unresolved measurements never count as validated predictions. Full invocation duration may remain unknown.'
    return result

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--manifest',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--evaluate',action='store_true');a=p.parse_args();assert not a.output.exists();result=run(a.manifest,a.evaluate);a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(json.dumps(result,indent=2,allow_nan=False)+'\n');print(json.dumps(dict(status='passed',holdout_labels_read=a.evaluate,output=identity(a.output))))
if __name__=='__main__':main()
