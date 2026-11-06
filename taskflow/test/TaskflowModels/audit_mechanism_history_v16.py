#!/usr/bin/env python3
"""Read-only independent v15 arithmetic/raw-evidence audit; no fit or device calls."""
import argparse
from collections import defaultdict
import hashlib
import json
from pathlib import Path
import statistics
import numpy as np

def read(p): return json.loads(Path(p).read_text())
def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def ident(p): return {'path':str(Path(p).resolve()), 'sha256':sha(p)}
def verified(record):
    p=Path(record['path'])
    assert sha(p)==record['sha256'], f'changed evidence: {p}'
    return p

def audit(root):
    model=root/'model-freeze-r1/model.json'
    assert sha(model)=='cc02bfdf882f621fc0bc78f3d9b69a2d5c7c63978237e840cb78d000f124d9ab'
    m=read(model); row=m['rows'][0]
    assert row['entry_ns']==219391.94444444464 and row['byte_ns']==2.636321779281373
    for record in read(root/'model-freeze-r1/freeze.json')['files'].values(): verified(record)
    protocol=read(root/'holdout-r1/protocol.json'); cases={c['id']:c for c in protocol['cases']}
    groups=defaultdict(list); seen=set(); outputs=0; individual=0
    for line in (root/'holdout-r1/samples.jsonl').read_text().splitlines():
        s=json.loads(line); key=(s['case'],s['seed'],s['repeat'])
        assert key not in seen; seen.add(key)
        with np.load(verified(s['inputs']),allow_pickle=False) as z: a=z['A'].copy()
        with np.load(verified(s['outputs']),allow_pickle=False) as z: c=z['C'].copy()
        assert np.array_equal(a,c); outputs+=1
        events=s['events']; start=next(e for e in events if e['kind']=='actual_xrt_start'); wait=next(e for e in events if e['kind']=='actual_xrt_wait')
        assert s['dispatch_to_wait_end_ns']==wait['end_ns']-start['start_ns']
        if not s['warmup']: groups[s['case']].append(s['dispatch_to_wait_end_ns'])
    expected={(c,seed,r) for c in cases for seed in protocol['seeds'] for r in range(protocol['warmups']+protocol['repeats'])}
    assert seen==expected
    rows=[]
    for case,values in sorted(groups.items()):
        b=8*cases[case]['fixture']['elements']; prediction=row['entry_ns']+row['byte_ns']*b
        median=statistics.median(values); error=abs(prediction-median); threshold=max(300000,.25*median)
        individual+=sum(abs(prediction-v)<=max(300000,.25*v) for v in values)
        rows.append(dict(case=case,bytes=b,prediction_ns=prediction,median_ns=median,absolute_error_ns=error,relative_error=error/median,threshold_ns=threshold,passed=error<=threshold,all_hot_samples_ns=values))
    traces=[]
    for s in read(root/'trace-execution-r1/samples.json'):
        t=np.load(verified(s['trace']),allow_pickle=False)
        assert t.size==4096 and not np.count_nonzero(t)
        traces.append(dict(mode=s['mode'],repeat=s['repeat'],trace=s['trace'],words=int(t.size),nonzero_words=int(np.count_nonzero(t))))
    repeat_models=list((root/'clean-reproduction-r1').rglob('model.json'))
    repeat_model=next(p for p in repeat_models if sha(p)=='bd32130fa34afa58dd8c1cde61196d4c348b2eaa5f402e4fff8a118b80a81dfa')
    assert sha(repeat_model)!=sha(model)
    passed=sum(x['passed'] for x in rows); mape=100*statistics.mean(x['relative_error'] for x in rows)
    assert passed==8 and abs(mape-19.4409)<.0001 and individual==198 and outputs==297 and len(traces)==10
    return dict(schema='orbit.mechanism-history.independent.v16',status='passed',auditor=ident(__file__),model=ident(model),coefficients={'entry_ns':row['entry_ns'],'byte_ns':row['byte_ns']},heldout_cells=rows,passed_cells=passed,cell_count=len(rows),mape_percent=mape,exact_outputs=outputs,individual_passed=individual,individual_count=sum(map(len,groups.values())),trace_captures=traces,clean_repeat_model=ident(repeat_model),cross_session_same_model_validation=False,limitations=['Completion-envelope coefficients do not identify pure DMA, compute, launch or physical bandwidth.','Repeated calibration is a separate epoch, not frozen-model cross-session stability.','300 us absolute median gate does not justify finer candidate ranking.','v16 future heldout evidence is not read by this historical audit.'])

def main():
    p=argparse.ArgumentParser(description=__doc__); p.add_argument('--root',type=Path,required=True); p.add_argument('--output',type=Path,required=True); a=p.parse_args()
    assert not a.output.exists(), 'new output required'
    result=audit(a.root); a.output.mkdir(parents=True); (a.output/'summary.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ['status','passed_cells','mape_percent','exact_outputs','individual_passed']}))
if __name__=='__main__': main()
