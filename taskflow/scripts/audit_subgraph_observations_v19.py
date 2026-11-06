#!/usr/bin/env python3
"""Read-only independent numeric/identity and frozen paired timing audit. No fit/device."""
import argparse,hashlib,itertools,json
from pathlib import Path
import numpy as np

def read(p):return json.loads(Path(p).read_text())
def verify(v):
 p=Path(v['path']);assert hashlib.sha256(p.read_bytes()).hexdigest()==v['sha256'],str(p)
 if 'bytes' in v:assert p.stat().st_size==v['bytes']
def dist(xs):
 a=np.asarray(xs,dtype=np.float64);assert len(a)>0 and np.isfinite(a).all()
 return dict(n=len(a),mean=float(np.mean(a)),median=float(np.median(a)),p05=float(np.quantile(a,.05)),p95=float(np.quantile(a,.95)),min=float(a.min()),max=float(a.max()),std=float(a.std()),raw=a.tolist())
def oracle(a,kind):
 af=a.astype(np.float64);u=(af+1).astype(np.float32);x=(u.astype(np.float64)*2).astype(np.float32);y=(x.astype(np.float64)+3).astype(np.float32);z=(x.astype(np.float64)-1).astype(np.float32)
 if kind=='subgraphs-v19':v=(y.astype(np.float64)+z.astype(np.float64)).astype(np.float32);w=(v.astype(np.float64)*.5).astype(np.float32);o=(w.astype(np.float64)+y.astype(np.float64)).astype(np.float32);exact=4*af+8
 else:o=(y.astype(np.float64)+z.astype(np.float64)).astype(np.float32);exact=4*af+6
 return dict(Z=z,O=o),dict(Z=2*af+1,O=exact)
def session(p,protocol):
 rows=[json.loads(x) for x in (p/'samples.jsonl').read_text().splitlines()];summary=read(p/'summary.json');cases={c['id']:c for c in protocol['cases']};expected=set(itertools.product(cases,protocol['seeds'],range(protocol['warmups']+protocol['repeats'])));seen=set();hot={k:{} for k in cases};sub={k:{} for k in cases};sync={k:[] for k in cases};poll={k:[] for k in cases};arrays=0;maxerror=0.;inputs={}
 assert read(p/'protocol.json')==protocol and summary['status']=='passed' and summary['actual_submissions']==len(expected)==len(rows)
 for row in rows:
  key=(row['case'],row['seed'],row['repeat']);assert key in expected and key not in seen;seen.add(key);c=cases[row['case']];assert row['case_identity']==c
  for field in ['inputs','outputs','reference','reference_f64']:verify(row[field])
  fixture=read(c['fixture']['path'])['fixture'];shape=(fixture['m'],fixture['n']);pair=(row['seed'],row['repeat']);assert row['warmup']==(row['repeat']<protocol['warmups'])
  with np.load(row['inputs']['path'],allow_pickle=False) as f:a=f['A'].copy();assert f.files==['A']
  assert a.shape==shape and a.dtype==np.float32 and np.isfinite(a).all()
  if pair in inputs:assert np.array_equal(a,inputs[pair])
  else:inputs[pair]=a
  strict,exact=oracle(a,fixture['kind'])
  with np.load(row['outputs']['path'],allow_pickle=False) as output,np.load(row['reference']['path'],allow_pickle=False) as reference,np.load(row['reference_f64']['path'],allow_pickle=False) as reference64:
   assert set(output.files)==set(reference.files)==set(reference64.files)=={'Z','O'}
   for name in output.files:
    actual=output[name];assert actual.shape==shape and actual.dtype==np.float32 and np.isfinite(actual).all()
    assert np.array_equal(reference[name],strict[name]) and np.array_equal(reference64[name],exact[name])
    assert np.allclose(actual,strict[name],atol=1e-5,rtol=1e-5) and np.allclose(actual,exact[name],atol=1e-5,rtol=1e-5)
    arrays+=1;maxerror=max(maxerror,float(np.max(np.abs(actual.astype(np.float64)-strict[name]))))
  events=row['events'];starts=[e for e in events if e['kind']=='actual_xrt_start'];waits=[e for e in events if e['kind']=='actual_xrt_wait'];assert len(starts)==len(waits)==1
  assert starts[0]['start_ns']<=starts[0]['end_ns']<=waits[0]['end_ns'];assert row['dispatch_to_wait_end_ns']==waits[0]['end_ns']-starts[0]['start_ns']
  syncs=[e for e in events if e['kind']=='actual_bo_sync'];assert len(syncs)==len(read(c['abi']['path'])['buffers'])+2
  assert row['sync_subtotal_ns']==sum(e['end_ns']-e['start_ns'] for e in syncs)
  assert row['runner_wall_ns']==row['dispatch_to_wait_end_ns']+row['sync_subtotal_ns']+row['other_runner_ns']
  if not row['warmup']:
   hot[row['case']][pair]=row['runner_wall_ns']/1e6;sub[row['case']][pair]=row['dispatch_to_wait_end_ns']/1e6;sync[row['case']].append(row['sync_subtotal_ns']/1e6)
   bracket=row['polling'].get('visibility_bracket_ns')
   if bracket is not None:poll[row['case']].append(bracket/1e6)
 assert seen==expected
 casesstats={name:dict(wall_ms=dist(list(values.values())),submit_to_completion_observation_ms=dist(list(sub[name].values())),sync_ms=dist(sync[name]),visibility_bracket_ms=dist(poll[name]) if poll[name] else None) for name,values in hot.items()}
 rng=np.random.default_rng(1901);pairs=[]
 for name in cases:
  if name in ['baseline','five_baseline']:continue
  base='five_baseline' if name.startswith('five_') else 'baseline';keys=sorted(hot[name]);assert keys==sorted(hot[base]);d=np.array([hot[name][k]-hot[base][k] for k in keys]);pred=cases[name]['frozen_prediction']['ms']-cases[base]['frozen_prediction']['ms'];boot=np.median(rng.choice(d,(10000,len(d)),replace=True),axis=1);ci=list(map(float,np.quantile(boot,[.025,.975])));resolved=ci[0]>0 or ci[1]<0
  pairs.append(dict(candidate=name,baseline=base,predicted_delta_ms=pred,observed_delta_ms=dist(d),median_bootstrap95_ms=ci,bootstrap_scope='Descriptive paired resampling conditional on this new-process session; not independent-day stability.',sign_resolved=resolved,sign_agreement=bool(np.sign(pred)==np.sign(np.median(d))),difference_error_ms=float(np.median(d)-pred),ordering_supported_this_session=bool(resolved and np.sign(pred)==np.sign(np.median(d)))))
 comparisons=[]
 for left,right in itertools.combinations(cases,2):
  if left.startswith('five_')!=right.startswith('five_'):continue
  keys=sorted(hot[left]);d=np.array([hot[right][k]-hot[left][k] for k in keys]);pred=cases[right]['frozen_prediction']['ms']-cases[left]['frozen_prediction']['ms'];boot=np.median(rng.choice(d,(10000,len(d)),replace=True),axis=1);ci=list(map(float,np.quantile(boot,[.025,.975])));resolved=ci[0]>0 or ci[1]<0
  comparisons.append(dict(left=left,right=right,predicted_delta_ms=pred,observed_delta_ms=dist(d),median_bootstrap95_ms=ci,sign_resolved=resolved,sign_agreement=bool(np.sign(pred)==np.sign(np.median(d))),ordering_supported_this_session=bool(resolved and np.sign(pred)==np.sign(np.median(d)))))
 return dict(status='passed',session=str(p.resolve()),samples=len(rows),outputs=arrays,max_abs_error_f32=maxerror,cases=casesstats,pairs=pairs,comparisons=comparisons)
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--protocol',type=Path,required=True);p.add_argument('--session',action='append',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False);protocol=read(a.protocol)
 for field in ['fixture_generator','runner','observer','polling_observer','installed_runtime','base_observer','v19_wrapper']:verify(protocol[field])
 for c in protocol['cases']:
  for field in ['fixture','source','compile','elf','abi','plan','transformed','aie','implementation_contract','program_graph','target_configuration','actual_facts']:verify(c[field])
  assert read(c['implementation_contract']['path'])['valid'] is True;plan=read(c['plan']['path']);assert plan['estimated_ms']==c['frozen_prediction']['ms'];assert plan['program_graph']==read(c['program_graph']['path'])
 results=[session(x,protocol) for x in a.session];cross=[]
 for c in protocol['cases']:
  meds=[r['cases'][c['id']]['wall_ms']['median'] for r in results];cross.append(dict(case=c['id'],median_ms=meds,range_ms=max(meds)-min(meds),relative_range=(max(meds)-min(meds))/min(meds)))
 result=dict(schema='orbit.subgraph-observation.audit.v19',status='passed',total_submissions=sum(r['samples'] for r in results),total_output_arrays=sum(r['outputs'] for r in results),frozen_protocol=str(a.protocol.resolve()),sessions=results,cross_session=cross,scope='No refit. Host invocation observations only; descriptor-requested byte counts are static. Pure DMA/core duration, physical DDR byte traffic and real overlap remain unidentified.')
 (a.output/'report.json').write_text(json.dumps(result,indent=2,allow_nan=False)+'\n')
 print(json.dumps(dict(status='passed',submissions=result['total_submissions'],outputs=result['total_output_arrays'],pairs=[[(p['candidate'],p['predicted_delta_ms'],p['observed_delta_ms']['median'],p['median_bootstrap95_ms'],p['ordering_supported_this_session']) for p in r['pairs']] for r in results]),indent=2))
if __name__=='__main__':main()
