#!/usr/bin/env python3
"""Exploratory descriptive paired/session uncertainty; never fits a model."""
import argparse,itertools,json
from pathlib import Path
import numpy as np
from audit_execution_observations_tolerance_v18 import read,ident,save

def stats(values):
 x=np.asarray(list(values),float);return dict(n=len(x),mean=float(x.mean()),median=float(np.median(x)),p05=float(np.quantile(x,.05)),p95=float(np.quantile(x,.95)),negative_fraction=float(np.mean(x<0)),positive_fraction=float(np.mean(x>0)),raw=list(map(float,x)))
def bootstrap(groups,rng):
 # Hierarchical seed/block resampling is an exploratory diagnostic, not a
 # registered independent-sample experiment or protection against temporal drift.
 medians=[];means=[];groups=list(groups.values())
 for _ in range(5000):
  x=np.concatenate([rng.choice(groups[int(i)],size=len(groups[int(i)]),replace=True) for i in rng.integers(0,len(groups),size=len(groups))]);medians.append(np.median(x));means.append(np.mean(x))
 return dict(method='exploratory hierarchical seed then within-seed paired resampling, 5000 draws; no preregistered CI; serial observations may be dependent',median_p025_p975=list(map(float,np.quantile(medians,[.025,.975]))),mean_p025_p975=list(map(float,np.quantile(means,[.025,.975]))))
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--measurement',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();rows=[json.loads(l) for l in (a.measurement/'samples.jsonl').read_text().splitlines()];hot=[r for r in rows if not r['warmup']];ids=list(dict.fromkeys(r['case'] for r in rows));seeds=list(dict.fromkeys(r['seed'] for r in rows));rng=np.random.default_rng(20261105);data={i:{(r['seed'],r['repeat']):r['runner_wall_ns'] for r in hot if r['case']==i} for i in ids};positions={(r['case'],r['seed'],r['repeat']):n for n,r in enumerate(rows)};result=dict(schema='orbit.execution-observation.exploratory-uncertainty.v18',raw=ident(a.measurement/'samples.jsonl'),bootstrap_seed=20261105,not_preregistered=True,cases={},contrasts=[],scope='Descriptive/exploratory only. No significance, new acceptance threshold, fitted parameter or calibrated-ranking claim. Retain raw ordered data; polling and serial/order/session effects remain possible confounders.')
 for name in ids:result['cases'][name]=dict(all_hot_ns=stats(data[name].values()),per_seed_hot_ns={str(s):stats(v for (seed,repeat),v in data[name].items() if seed==s) for s in seeds})
 for left,right in itertools.combinations(ids,2):
  groups={s:np.array([data[right][k]-data[left][k] for k in data[left] if k[0]==s],float) for s in seeds};delta=np.concatenate(list(groups.values()));orders={}
  for side in ['candidate_before_baseline','candidate_after_baseline']:
   v=[data[right][k]-data[left][k] for k in data[left] if (positions[(right,*k)]<positions[(left,*k)])==(side=='candidate_before_baseline')];orders[side]=stats(v)
  result['contrasts'].append(dict(baseline=left,candidate=right,all_paired_delta_ns=stats(delta),per_seed_delta_ns={str(s):stats(v) for s,v in groups.items()},by_case_order=orders,bootstrap_ns=bootstrap(groups,rng)))
 save(a.output,result);print(json.dumps(dict(status='summarized',output=str(a.output))))
if __name__=='__main__':main()
