#!/usr/bin/env python3
"""Read-only v18 original-tolerance identity/numeric and paired observation audit.

Never opens a device, fits parameters, imports a runner, or uses saved references
as its numerical oracle. --freeze-only seals static plans before raw is read.
"""
import argparse, datetime, hashlib, itertools, json, re
from pathlib import Path
import numpy as np

def read(path): return json.loads(Path(path).read_text())
def sha(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def ident(path):
 p=Path(path).resolve(); return dict(path=str(p),sha256=sha(p),bytes=p.stat().st_size)
def verify(item):
 assert sha(item['path'])==item['sha256'], ('identity changed',item['path'])
 if 'bytes' in item: assert Path(item['path']).stat().st_size==item['bytes']
def save(path,value):
 path=Path(path); assert not path.exists(),path
 path.parent.mkdir(parents=True,exist_ok=True);path.write_text(json.dumps(value,indent=2,allow_nan=False)+'\n')
def distribution(values):
 a=np.asarray(list(values),dtype=np.float64);assert len(a)>0 and np.isfinite(a).all()
 return dict(n=len(a),min=float(a.min()),q25=float(np.quantile(a,.25)),median=float(np.median(a)),q75=float(np.quantile(a,.75)),max=float(a.max()),mean=float(a.mean()),std=float(a.std()),raw=list(map(float,a)))
def static(protocol_path,index_path):
 protocol=read(protocol_path);index=read(index_path);verify(index['source_index'])
 entries={e['name']:e for e in read(index['source_index']['path'])['entries']}
 assert len(protocol['cases'])==len(index['cases'])==4
 for key in ['fixture_generator','runner','observer','polling_observer','base_observer','installed_runtime','v18_wrapper']:verify(protocol[key])
 assert protocol['numerical_tolerance']==dict(strict_f32=dict(atol=1e-5,rtol=1e-5),unrounded_f64=dict(atol=1e-5,rtol=1e-5))
 cases={c['id']:c for c in protocol['cases']};sealed=[]
 for row in index['cases']:
  c=cases[row['id']];e=entries[row['id']];compiled=Path(row['compiled']);plan=read(compiled/'plan.json');g=read(compiled/'program-graph.json');searched=read(e['mapping_result'])['best_plan']
  for name in ['fixture','source','compile','elf','abi','plan','transformed','aie']:verify(c[name])
  assert c['source']['sha256']==e['source_sha256']==row['candidate_id']==sha(e['source'])
  assert c['plan']['sha256']==sha(compiled/'plan.json')
  assert g==read(e['graph_file'])==plan['program_graph']
  assert plan==searched,('full native plan mismatch',row['id'])
  assert plan['plan_id']==e['price_attached_plan_id']
  assert g['id']==e['graph_id']
  assert plan['direct_air_cost']['value_ms']==e['estimated_ms']==plan['estimated_ms']
  physical=read(row['physical_audit']);verify(physical['final_aie']);assert physical['final_aie']['sha256']==c['aie']['sha256']
  assert physical['plan_id']==plan['plan_id'] and physical['graph_id']==g['id']
  aietext=Path(c['aie']['path']).read_text()
  assert sorted(re.findall(r'aiex\.configure @([\w.]+)',aietext))==sorted(physical['configure_calls'])
  assert len(re.findall(r'aiex\.dma_configure_task_for\b',aietext))==physical['runtime_bd_tasks']
  assert len(re.findall(r'aiex\.run @',aietext))==len(physical['configure_calls'])
  fixture=read(c['fixture']['path']);assert fixture['fixture']['kind']=='diamond'
  text=Path(c['source']['path']).read_text()
  assert len(re.findall(r'\barith.addf\b',text))==3 and 'arith.mulf' not in text
  assert 'arith.constant 1.0' in text and 'arith.constant 2.0' in text
  abi=read(c['abi']['path']);assert set(abi['outputs'])=={'B','C'}
  sealed.append(dict(id=row['id'],source=c['source'],plan=c['plan'],aie=c['aie'],graph=ident(compiled/'program-graph.json'),graph_id=g['id'],plan_id=plan['plan_id'],prediction_ns=e['estimated_ms']*1e6,action_chain=e['action_chain'],model=plan['direct_air_cost']['model'],model_digest=plan['direct_air_cost']['model_digest'],physical_audit=ident(row['physical_audit'])))
 assert len({r['model_digest'] for r in sealed})==1
 return protocol,sealed

def evaluate(protocol,cases,measurement):
 measurement=Path(measurement);summary=read(measurement/'summary.json');assert summary['status']=='passed'
 rows=[json.loads(x) for x in (measurement/'samples.jsonl').read_text().splitlines()]
 expected=len(cases)*len(protocol['seeds'])*(protocol['warmups']+protocol['repeats'])
 assert len(rows)==summary['samples']==summary['actual_submissions']==expected
 bycase={r['id']:r for r in cases};pcases={c['id']:c for c in protocol['cases']};keys=set();inputs={};hot={k:{} for k in bycase};arrays=0;strictmax=0.;f64max=0.;bitwise_differences=0;max_ulp=0
 for row in rows:
  name,seed,repeat=row['case'],row['seed'],row['repeat'];key=(name,seed,repeat)
  assert key not in keys;keys.add(key);assert row['case_identity']==pcases[name]
  assert seed in protocol['seeds'] and 0<=repeat<protocol['warmups']+protocol['repeats']
  assert row['warmup']==(repeat<protocol['warmups'])
  for field in ['inputs','outputs','reference','reference_f64']:verify(row[field])
  fixture=read(pcases[name]['fixture']['path'])['fixture'];shape=(fixture['m'],fixture['n'])
  with np.load(row['inputs']['path'],allow_pickle=False) as z:
   assert set(z.files)=={'A'};a=z['A'].copy();assert a.shape==shape and a.dtype==np.float32 and np.isfinite(a).all()
  pairkey=(seed,repeat)
  if pairkey in inputs:assert np.array_equal(inputs[pairkey],a),('not same input',key)
  else:inputs[pairkey]=a
  # Independent equations and rounding at each source operation; no generator import.
  x=(a.astype(np.float64)+1.).astype(np.float32)
  strict={'B':(x.astype(np.float64)+2.).astype(np.float32),'C':(2.*x.astype(np.float64)).astype(np.float32)}
  exact={'B':a.astype(np.float64)+3.,'C':2.*(a.astype(np.float64)+1.)}
  with np.load(row['outputs']['path'],allow_pickle=False) as out,np.load(row['reference']['path'],allow_pickle=False) as ref,np.load(row['reference_f64']['path'],allow_pickle=False) as f64:
   assert set(out.files)==set(ref.files)==set(f64.files)=={'B','C'}
   for nameout in ['B','C']:
    actual=out[nameout];assert actual.shape==shape and actual.dtype==np.float32 and np.isfinite(actual).all()
    assert np.allclose(actual,strict[nameout],atol=1e-5,rtol=1e-5) and np.array_equal(ref[nameout],strict[nameout]),('source f32 tolerance or saved reference mismatch',key,nameout)
    bitwise_differences+=int(np.count_nonzero(actual!=strict[nameout]))
    # This diamond's B/C outputs are positive, so int32 bit distance is ULP distance.
    assert (actual>0).all() and (strict[nameout]>0).all()
    max_ulp=max(max_ulp,int(np.max(np.abs(actual.view(np.int32).astype(np.int64)-strict[nameout].view(np.int32).astype(np.int64)))))
    assert np.array_equal(f64[nameout],exact[nameout]) and np.allclose(actual,exact[nameout],atol=1e-5,rtol=1e-5)
    strictmax=max(strictmax,float(np.max(np.abs(actual.astype(np.float64)-strict[nameout]))));f64max=max(f64max,float(np.max(np.abs(actual.astype(np.float64)-exact[nameout]))));arrays+=1
  events=row['events'];assert sum(e['kind']=='actual_xrt_start' for e in events)==sum(e['kind']=='actual_xrt_wait' for e in events)==1
  assert all(e['start_ns']<=e['end_ns'] for e in events)
  start=next(e for e in events if e['kind']=='actual_xrt_start');wait=next(e for e in events if e['kind']=='actual_xrt_wait')
  assert start['start_ns']<=start['end_ns']<=wait['end_ns']
  assert row['dispatch_to_wait_end_ns']==wait['end_ns']-start['start_ns']
  abi=read(pcases[name]['abi']['path']);syncs=[e for e in events if e['kind']=='actual_bo_sync'];assert len(syncs)==len(abi['buffers'])+2
  assert row['sync_subtotal_ns']==sum(e['end_ns']-e['start_ns'] for e in syncs)
  assert row['runner_wall_ns']==row['dispatch_to_wait_end_ns']+row['sync_subtotal_ns']+row['other_runner_ns']
  assert min(row['runner_wall_ns'],row['other_runner_ns'],row['sync_subtotal_ns'])>=0
  if not row['warmup']:hot[row['case']][pairkey]=row['runner_wall_ns']
 expectedkeys=set(itertools.product(bycase,protocol['seeds'],range(protocol['warmups']+protocol['repeats'])));assert keys==expectedkeys
 records=[]
 for name in bycase:
  observed=distribution(hot[name].values());pred=bycase[name]['prediction_ns'];records.append(dict(id=name,prediction_ns=pred,runner_wall_ns=observed,relative_error_of_median=(pred-observed['median'])/observed['median']))
 contrasts=[]
 for left,right in itertools.combinations(bycase,2):
  assert hot[left].keys()==hot[right].keys()
  delta=[hot[right][k]-hot[left][k] for k in hot[left]];pred=bycase[right]['prediction_ns']-bycase[left]['prediction_ns'];stats=distribution(delta)
  contrasts.append(dict(baseline=left,candidate=right,predicted_delta_ns=pred,paired_runner_delta_ns=stats,absolute_delta_error_ns=pred-stats['median'],median_direction_agrees=bool(pred*stats['median']>0),scope='paired within one context-prepared session; no calibrated ranking claim'))
 return dict(status='passed',calls=len(rows),warm_calls=sum(r['warmup'] for r in rows),hot_calls=sum(not r['warmup'] for r in rows),output_arrays=arrays,strict_f32_max_abs_error=strictmax,source_f32_bitwise_different_elements=bitwise_differences,source_f32_max_ulp_error=max_ulp,numerical_contract=dict(source_f32=dict(atol=1e-5,rtol=1e-5),unrounded_f64=dict(atol=1e-5,rtol=1e-5),saved_reference_exact=True),unrounded_f64_max_abs_error=f64max,cases=records,paired_contrasts=contrasts,physical_device_duration_ns=None,scope='Host prepared-invocation wall time, not pure DMA/core or a cross-session validation; no fitting performed.')

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--protocol',type=Path,required=True);p.add_argument('--compiled-index',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--freeze-only',action='store_true');p.add_argument('--receipt',type=Path);p.add_argument('--measurement',type=Path);a=p.parse_args()
 protocol,cases=static(a.protocol,a.compiled_index)
 frozen=dict(schema='orbit.execution-observation.independent-tolerance.v18',auditor=ident(__file__),protocol=ident(a.protocol),compiled_index=ident(a.compiled_index),cases=cases)
 if a.freeze_only:
  frozen.update(mode='freeze-only',created_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),performance_read=False);save(a.output,frozen)
 else:
  assert a.receipt and a.measurement
  receipt=read(a.receipt)
  assert receipt['performance_read'] is False and receipt['mode']=='freeze-only'
  for key in ['auditor','protocol','compiled_index','cases']:assert receipt[key]==frozen[key],('freeze identity changed',key)
  result=evaluate(protocol,cases,a.measurement);result.update(schema=frozen['schema'],freeze_receipt=ident(a.receipt),protocol=frozen['protocol'],compiled_index=frozen['compiled_index'],auditor=ident(__file__),measurement=ident(a.measurement/'samples.jsonl'));save(a.output,result)
 print(json.dumps(dict(status='passed',mode='freeze-only' if a.freeze_only else 'evaluate',output=str(a.output))))
if __name__=='__main__':main()
