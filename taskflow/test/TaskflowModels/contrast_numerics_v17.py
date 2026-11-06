#!/usr/bin/env python3
"""Training-only numerical solver for already bound implementation contrasts.

This is not a production model/planner. Input is an evidence adapter with
split='train', feature_names, rows (pair_id, split='train', feature_delta,
observations=[{seed,repeat,delta_ns}]), and evidence SHA records. Feature deltas
and labels use the same right-minus-left orientation. Coefficients are
nonnegative implementation-envelope prices; the design itself can be signed.
No intercept is inserted and rank-deficient columns are never silently dropped.
No heldout path or label is opened. Output is audit/parameter-candidate evidence,
not a new production configuration schema.
"""
import argparse
import hashlib
import itertools
import json
from pathlib import Path
import numpy as np

def read(p):return json.loads(Path(p).read_text())
def identity(p):return dict(path=str(Path(p).resolve()),sha256=hashlib.sha256(Path(p).read_bytes()).hexdigest())
def verify(r):
    assert identity(r['path'])['sha256']==r['sha256'],f'changed evidence {r["path"]}'

def solve(x,y):
    x=np.asarray(x,float);y=np.asarray(y,float)
    assert x.ndim==2 and y.shape==(x.shape[0],) and 0<x.shape[1]<=8
    assert np.isfinite(x).all() and np.isfinite(y).all()
    scale=np.linalg.norm(x,axis=0)
    assert np.all(scale>0),'unidentified feature: zero training column'
    z=x/scale;rank=int(np.linalg.matrix_rank(z))
    assert rank==x.shape[1],f'unidentified design: rank {rank} < {x.shape[1]}; collapse covered mechanisms or return unknown'
    choices=[]
    for mask in itertools.product([False,True],repeat=x.shape[1]):
        cols=np.flatnonzero(mask);b=np.zeros(x.shape[1])
        if len(cols):
            v=np.linalg.lstsq(z[:,cols],y,rcond=None)[0]
            if np.min(v)<-1e-9:continue
            b[cols]=np.maximum(v,0)
        choices.append((float(np.sum((z@b-y)**2)),b))
    loss,scaled=min(choices,key=lambda p:p[0]);coeff=scaled/scale;gradient=z.T@(z@scaled-y)
    tolerance=1e-7*max(1,float(np.linalg.norm(y)))
    assert all(abs(g)<=tolerance if b>1e-9 else g>=-tolerance for b,g in zip(scaled,gradient)),'nonnegative optimum KKT failure'
    return coeff,dict(rank=rank,normalized_condition=float(np.linalg.cond(z)),squared_error_ns2=loss,scaled_gradient=gradient.tolist(),column_norms=scale.tolist())

def calibrate(path):
    data=read(path);assert data['split']=='train','training-only adapter required before opening evidence'
    names=data['feature_names'];assert names and len(set(names))==len(names)
    assert data['rows'] and len({r['pair_id'] for r in data['rows']})==len(data['rows'])
    for r in data['rows']:assert r['split']=='train','mixed/heldout row prohibited'
    for record in data['evidence']:verify(record)
    x=[];y=[];seen=set();seedset=None
    for row in data['rows']:
        assert len(row['feature_delta'])==len(names)
        observations=row['observations'];assert observations
        for o in observations:
            key=(row['pair_id'],o['seed'],o['repeat']);assert key not in seen;seen.add(key)
            assert np.isfinite(o['delta_ns'])
        seeds={o['seed'] for o in observations}
        if seedset is None:seedset=seeds
        assert seeds==seedset,'seed coverage differs between training pairs'
        x.append(row['feature_delta']);y.append(float(np.median([o['delta_ns'] for o in observations])))
    coeff,diagnostic=solve(x,y);seedfits={}
    for seed in sorted(seedset):
        sy=[float(np.median([o['delta_ns'] for o in row['observations'] if o['seed']==seed])) for row in data['rows']]
        b,d=solve(x,sy);seedfits[str(seed)]=dict(coefficients_ns=b.tolist(),diagnostic=d)
    cells=[]
    for i,row in enumerate(data['rows']):
        prediction=float(np.array(x[i])@coeff);values=[o['delta_ns'] for o in row['observations']]
        cells.append(dict(pair_id=row['pair_id'],feature_delta=x[i],prediction_delta_ns=prediction,median_observed_delta_ns=y[i],absolute_error_ns=abs(prediction-y[i]),raw_paired_delta_ns=values,p10_ns=float(np.percentile(values,10)),p90_ns=float(np.percentile(values,90))))
    loo=[]
    for i,row in enumerate(data['rows']):
        kept=[j for j in range(len(x)) if j!=i]
        try:
            b,d=solve([x[j] for j in kept],[y[j] for j in kept]);prediction=float(np.array(x[i])@b)
            loo.append(dict(pair_id=row['pair_id'],status='identified',prediction_delta_ns=prediction,error_ns=prediction-y[i]))
        except AssertionError as error:loo.append(dict(pair_id=row['pair_id'],status='unknown',reason=str(error)))
    return dict(status='passed',scope='Training-only parameter candidate and identifiability diagnostics; no heldout validation or production planning.',adapter=identity(path),auditor=identity(__file__),holdout_labels_read=False,feature_names=names,coefficients_ns=coeff.tolist(),diagnostic=diagnostic,per_seed_fits=seedfits,training_pairs=cells,leave_one_training_pair_out=loo,limitations=['Nonnegative numerical identification does not prove causal mechanism separation.','Same-source arithmetic does not certify common implementation cost cancellation.','Empirical paired percentiles and per-seed fits are not confidence bounds.'])

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--training-adapter',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();assert not a.output.exists(),'NEW output required';result=calibrate(a.training_adapter);a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(json.dumps(result,indent=2,allow_nan=False)+'\n');print(json.dumps(dict(status='passed',coefficients_ns=result['coefficients_ns'],condition=result['diagnostic']['normalized_condition'],holdout_labels_read=False)))
if __name__=='__main__':main()
