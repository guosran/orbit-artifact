#!/usr/bin/env python3
"""Independent read-only historical RAW-only copy shape-control audit, no fitting."""
import argparse,itertools,json,re
from pathlib import Path
import numpy as np
from audit_execution_observations_tolerance_v18 import read,ident,verify,save,distribution

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--protocol',type=Path,required=True);p.add_argument('--measurement',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();protocol=read(a.protocol);summary=read(a.measurement/'summary.json');assert summary['status']=='passed'
 assert protocol['numerical_tolerance']==dict(atol=1e-5,rtol=1e-5)
 for key in ['base_observer','fixture_generator','installed_runtime','observer','polling_observer','runner','shape_control_wrapper']:verify(protocol[key])
 cases={c['id']:c for c in protocol['cases']};assert len(cases)==2;bindings=[]
 for name,c in cases.items():
  for item in ['fixture','source','compile','elf','abi','plan','transformed','aie']:verify(c[item])
  f=read(c['fixture']['path'])['fixture'];assert f['kind']=='fanout' and f['scalar_products']==f['scalar_addsub']==0
  text=Path(c['source']['path']).read_text();assert len(re.findall(r'affine\.load',text))==len(re.findall(r'affine\.store',text))==3 and 'arith.' not in text
  plan=read(c['plan']['path']);g=plan['program_graph'];aie=Path(c['aie']['path']).read_text();configs=len(re.findall(r'aiex\.configure @',aie));assert configs==len(g['execution_groups'])
  assert len(re.findall(r'aiex\.run @',aie))==configs
  bindings.append(dict(id=name,graph_id=g['id'],plan_id=plan['plan_id'],body_fingerprint=plan['body_fingerprint'],plan=c['plan'],source=c['source'],aie=c['aie'],group_count=configs,requested_bytes=plan['actual_dma_bytes'],prediction_ns=plan['direct_air_cost']['value_ms']*1e6,model=plan['direct_air_cost']['model']))
 assert bindings[0]['body_fingerprint']==bindings[1]['body_fingerprint'] and bindings[0]['model']==bindings[1]['model']
 assert {b['group_count'] for b in bindings}=={48,6} and bindings[0]['requested_bytes']==bindings[1]['requested_bytes']
 rows=[json.loads(l) for l in (a.measurement/'samples.jsonl').read_text().splitlines()];assert len(rows)==summary['samples']==summary['actual_submissions']==2*len(protocol['seeds'])*(protocol['warmups']+protocol['repeats'])
 seen=set();inputs={};hot={name:{} for name in cases};maxabs=0.;arrays=0;bitwise=0
 for r in rows:
  key=(r['case'],r['seed'],r['repeat']);assert key not in seen;seen.add(key);assert r['case_identity']==cases[r['case']] and r['warmup']==(r['repeat']<protocol['warmups'])
  for name in ['inputs','outputs','reference','reference_f64']:verify(r[name])
  with np.load(r['inputs']['path'],allow_pickle=False) as z:assert set(z.files)=={'A'};v=z['A'].copy();assert v.dtype==np.float32 and np.isfinite(v).all()
  k=(r['seed'],r['repeat'])
  if k in inputs:assert np.array_equal(v,inputs[k])
  else:inputs[k]=v
  with np.load(r['outputs']['path'],allow_pickle=False) as actual,np.load(r['reference']['path'],allow_pickle=False) as ref,np.load(r['reference_f64']['path'],allow_pickle=False) as f64:
   assert set(actual.files)==set(ref.files)==set(f64.files)=={'B','C'}
   for name in ['B','C']:
    x=actual[name];assert x.shape==v.shape and x.dtype==np.float32 and np.isfinite(x).all()
    assert np.array_equal(ref[name],v) and np.array_equal(f64[name],v.astype(np.float64))
    assert np.allclose(x,v,atol=1e-5,rtol=1e-5);maxabs=max(maxabs,float(np.abs(x.astype(np.float64)-v).max()));bitwise+=int(np.count_nonzero(x!=v));arrays+=1
  ev=r['events'];start=[e for e in ev if e['kind']=='actual_xrt_start'];wait=[e for e in ev if e['kind']=='actual_xrt_wait'];sync=[e for e in ev if e['kind']=='actual_bo_sync'];assert len(start)==len(wait)==1 and len(sync)==6
  assert r['dispatch_to_wait_end_ns']==wait[0]['end_ns']-start[0]['start_ns'] and r['sync_subtotal_ns']==sum(e['end_ns']-e['start_ns'] for e in sync)
  assert r['runner_wall_ns']==r['dispatch_to_wait_end_ns']+r['sync_subtotal_ns']+r['other_runner_ns'] and r['other_runner_ns']>=0
  if not r['warmup']:hot[r['case']][k]=r['runner_wall_ns']
 assert seen==set(itertools.product(cases,protocol['seeds'],range(protocol['warmups']+protocol['repeats'])))
 first,second=list(cases);assert hot[first].keys()==hot[second].keys();delta=[hot[second][k]-hot[first][k] for k in hot[first]]
 result=dict(schema='orbit.execution-shape-control.independent.v18',auditor=ident(__file__),protocol=ident(a.protocol),measurement=ident(a.measurement/'samples.jsonl'),status='passed',calls=len(rows),warm_calls=sum(r['warmup'] for r in rows),hot_calls=sum(not r['warmup'] for r in rows),output_arrays=arrays,source_f32_max_abs_error=maxabs,source_f32_bitwise_different_elements=bitwise,bindings=bindings,cases=[dict(id=k,runner_wall_ns=distribution(v.values())) for k,v in hot.items()],contrast=dict(baseline=first,candidate=second,predicted_delta_ns=bindings[1]['prediction_ns']-bindings[0]['prediction_ns'],paired_runner_delta_ns=distribution(delta)),scope='Historical RAW-only E768 all-copy source, same inputs/ABI/traffic; shape grouping 48 to 6 configurations. Separate from computed diamond. Prepared host wall observations, not isolated physical configuration latency. No fitting or independent pre-observation receipt claimed.')
 save(a.output,result);print(json.dumps(dict(status='passed',calls=len(rows),arrays=arrays)))
if __name__=='__main__':main()
