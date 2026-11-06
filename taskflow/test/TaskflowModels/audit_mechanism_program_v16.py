#!/usr/bin/env python3
"""Independent frozen prediction audit. Reads measurements only with --evaluate.

Manifest is an evidence adapter, not a production graph/model. `frozen` lists
SHA-bound files including model, protocol, predictions, source/toolchain and
conditions. `predictions` points to rows with case, graph_id, plan_id,
artifact_sha256, prediction_ns (nullable), optional action_chain/unknown_reason.
`sessions` list protocol-bound raw JSONL (case/seed/repeat/warmup/duration_ns,
plus the three identity fields); each session has model_sha256, kind, samples,
freeze_receipt_sha256. Kinds: unseen-plan, same-model-new-session, recalibrated.
The separate freeze-only receipt must precede measurements; --evaluate never
creates it. Hash/receipt ordering is evidence, not trusted wall-clock inference.
"""
import argparse
from collections import defaultdict
import hashlib
import itertools
import json
import math
from pathlib import Path
import statistics

def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p): return json.loads(Path(p).read_text())
def identity(p): return {'path':str(Path(p).resolve()),'sha256':sha(p)}
def verify(record):
    p=Path(record['path']); assert sha(p)==record['sha256'],f'changed evidence {p}'
    return p

def quantile(values,q):
    v=sorted(values); x=(len(v)-1)*q; i=int(x)
    return v[i]+(v[min(i+1,len(v)-1)]-v[i])*(x-i)

def stats(values):
    assert values and all(math.isfinite(x) for x in values)
    med=statistics.median(values)
    return dict(n=len(values),median_ns=med,mad_ns=statistics.median(abs(x-med) for x in values),p5_ns=quantile(values,.05),p95_ns=quantile(values,.95),min_ns=min(values),max_ns=max(values),raw_ns=values)

def audit(manifest,evaluate):
    m=read(manifest)
    assert m['schema']=='orbit.mechanism-program.audit-manifest.v16'
    assert m['frozen'] and set(m['required_roles'])<=set(m['frozen'])
    for record in m['frozen'].values(): verify(record)
    assert m['predictions']==m['frozen']['predictions']
    predictions=read(verify(m['predictions']))
    rows=predictions['rows']; bycase={r['case']:r for r in rows}; assert len(rows)==len(bycase)
    for row in rows:
        assert all(row[k] for k in ['graph_id','plan_id','artifact_sha256'])
        p=row['prediction_ns']; assert p is None or math.isfinite(p) and p>=0
        if p is None: assert row.get('unknown_reason')
    receipt=dict(schema='orbit.mechanism-program.freeze-audit.v16',status='passed',manifest=identity(manifest),frozen=m['frozen'],predicted_cases=list(bycase),holdout_labels_read=False,auditor=identity(__file__))
    if not evaluate: return receipt
    prior=read(verify(m['freeze_receipt']))
    assert prior['holdout_labels_read'] is False and prior['frozen']==m['frozen'] and prior['status']=='passed'
    result=dict(schema='orbit.mechanism-program.independent.v16',freeze_receipt=m['freeze_receipt'],auditor=identity(__file__),sessions=[],search_ready=False)
    all_resolved=True
    for session in m['sessions']:
        assert session['freeze_receipt_sha256']==m['freeze_receipt']['sha256']
        assert session['kind'] in ['unseen-plan','same-model-new-session','recalibrated']
        if session['kind']!='recalibrated': assert session['model_sha256']==m['frozen']['model']['sha256']
        else: assert session['model_sha256']!=m['frozen']['model']['sha256']
        groups=defaultdict(list); paired=defaultdict(dict); seen=set()
        for line in verify(session['samples']).read_text().splitlines():
            s=json.loads(line); r=bycase[s['case']]; key=(s['case'],s['seed'],s['repeat'])
            assert key not in seen; seen.add(key)
            for k in ['graph_id','plan_id','artifact_sha256']: assert s[k]==r[k],f'{k} mismatch for {s["case"]}'
            duration=s['duration_ns']; assert math.isfinite(duration) and duration>=0
            if not s['warmup']:
                groups[s['case']].append(duration); paired[(s['seed'],s['repeat'])][s['case']]=duration
        assert set(groups)==set(session['cases'])
        cells=[]
        for case,values in sorted(groups.items()):
            st=stats(values); prediction=bycase[case]['prediction_ns']; error=None if prediction is None else abs(prediction-st['median_ns'])
            limit=max(m['acceptance']['absolute_floor_ns'],m['acceptance']['relative_fraction']*st['median_ns'])
            cells.append(dict(case=case,prediction_ns=prediction,distribution=st,absolute_error_ns=error,relative_error=None if error is None or st['median_ns']==0 else error/st['median_ns'],threshold_ns=limit,passed=None if error is None else error<=limit,action_chain=bycase[case].get('action_chain')))
        contrasts=[]
        for left,right in itertools.combinations(sorted(groups),2):
            values=[v[right]-v[left] for v in paired.values() if left in v and right in v]
            if not values: continue
            st=stats(values); lp,rp=bycase[left]['prediction_ns'],bycase[right]['prediction_ns']; pd=None if lp is None or rp is None else rp-lp
            delta_error=None if pd is None else abs(pd-st['median_ns'])
            interval_excludes_zero=st['p5_ns']>0 or st['p95_ns']<0
            supported=pd is not None and interval_excludes_zero and pd*st['median_ns']>0 and delta_error<abs(pd)
            all_resolved &= supported
            contrasts.append(dict(left=left,right=right,predicted_right_minus_left_ns=pd,paired_observation=st,delta_error_ns=delta_error,empirical_90percent_range_excludes_zero=interval_excludes_zero,ranking_supported=supported,scope='Empirical paired range is descriptive, not a statistical confidence interval.'))
        relative=[r['relative_error'] for r in cells if r['relative_error'] is not None]
        result['sessions'].append(dict(id=session['id'],kind=session['kind'],model_sha256=session['model_sha256'],samples=session['samples'],cells=cells,mape_percent=None if not relative else 100*statistics.mean(relative),contrasts=contrasts,unknown_cases=[r['case'] for r in cells if r['prediction_ns'] is None]))
    # Readiness requires complete candidate costs and independently observed useful
    # differences; it is never inferred from passing a coarse absolute cell gate.
    result['ranking_all_observed_pairs_supported']=all_resolved and any(s['contrasts'] for s in result['sessions'])
    result['search_ready']=False
    result['search_readiness_reason']='Independent reviewer must additionally verify automatic candidate provenance, legal lowering, calibrated domain and optimization-relevant gain; this audit never authorizes search by cell accuracy alone.'
    return result

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--manifest',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--evaluate',action='store_true');a=p.parse_args()
    assert not a.output.exists(),'NEW output required'
    result=audit(a.manifest,a.evaluate);a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(json.dumps(result,indent=2,allow_nan=False)+'\n')
    print(json.dumps({'status':'passed','output':identity(a.output),'holdout_labels_read':a.evaluate}))
if __name__=='__main__':main()
