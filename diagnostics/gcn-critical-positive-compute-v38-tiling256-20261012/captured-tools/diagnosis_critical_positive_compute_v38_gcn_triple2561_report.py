#!/usr/bin/env python3
"""Join three closed same-source independent canonical256 research domains; zero calls."""
import hashlib,json,time
from pathlib import Path
R=Path(__file__).resolve().parent
B=R/'diagnosis/search-regression-repair-20261010'
OUT=B/'critical-positive-compute-v38-triple-comparison1'
SOURCE='76345481683a2e199c0cad155de2acb51149f350'
POLICY='schedule-structure-critical-positive-compute-v38'
OPT='9996d1b97787242cea42d88511ce530bfa4cb523883705b0746a72a1ff17d7cc'
NATIVE='80f11127c25360b591cbd705d3e7d25d3060ba90cf2978f8d5a56133cf58a761'
def sha(p):
 h=hashlib.sha256()
 with Path(p).open('rb') as f:
  for x in iter(lambda:f.read(1<<20),b''):h.update(x)
 return h.hexdigest()
def read(p):return json.loads(Path(p).read_text())
def main():
 assert not OUT.exists(),'Preserve closed comparison'
 inputs={str(Path(__file__).resolve()):sha(__file__)};rows=[];runners=[]
 specs=[('replica','cumulative-replica','critical-positive-compute-v38-replica256-continuation1','prepared-v2'),('tiling','cumulative-tiling','critical-positive-compute-v38-tiling256-continuation1','prepared-v1'),('full','all','critical-positive-compute-v38-full256-continuation1','prepared-v2')]
 for stage,feature,name,prepared in specs:
  n=B/name;rp=n/'closed-report/REPORT.json';fp=n/'closed-report/FINAL.json';rr=read(rp);ff=read(fp)
  assert ff['status']=='pass' and ff['report_sha256']==sha(rp) and ff['input_pre_post_verified'] is True
  assert rr['status']=='verified-isolated-research' and rr['source_commit']==SOURCE and rr['policy']==POLICY
  assert rr['native_optimizer_sha256']==NATIVE and rr['feature_policy']==feature
  assert rr['objective_calls']==256 and rr['extra_objective_calls']==0
  assert rr['native_evaluated']==rr['numeric_validated']==5 and rr['certified_scheduler_rejected']==0
  finalists=rr['original_exact_five_finalists'];assert [x['rank']for x in finalists]==list(range(5))
  assert min(x['native_cycles']for x in finalists)==rr['native_best_cycles']
  runnerpath=n/prepared/'gcn-256-runner-binding.json';pp=n/prepared/'pipeline-binding.json';run=read(runnerpath);pipeline=read(pp)
  assert pipeline['source_commit']==run['source_commit']==SOURCE and pipeline['runner_binding_sha256']['gcn']==sha(runnerpath)
  assert run['optimizer_sha256']==OPT and run['actual_policy']==POLICY
  assert run['budget_cap']==256 and run['independent_start'] is True and run['imported_incumbent'] is None and run['injected_candidates']==0
  assert run['argv'][run['argv'].index('--feature-policy')+1]==feature
  runners.append(run)
  row=dict(stage=stage,feature_policy=feature,source_commit=SOURCE,native_cycles=rr['native_best_cycles'],original_exact_five_native=[x['native_cycles']for x in finalists],original_exact_five_predicted=[x['predicted_cycles']for x in finalists],objective_calls=256,extra_objective_calls=0,native_evaluated=5,numeric_validated=5,certified_scheduler_rejected=0,search_usage=rr['search_usage'],first_tier_guided_paid_targets=rr['first_tier_guided_paid_targets'],semantic_attempts=rr['semantic_attempts'],zero_debit_attempts=rr['zero_debit_attempts'],communication_shape_window_paid=rr['communication_shape_window_paid'],replaced_structural_window_count=rr['replaced_structural_window_count'],report=str(rp))
  rows.append(row)
  for p in [rp,fp,runnerpath,pp]:inputs[str(p)]=sha(p)
 argvchecks=[];a=runners[0]
 for b in runners[1:]:
  assert len(a['argv'])==len(b['argv'])
  differences=[i for i,(x,y)in enumerate(zip(a['argv'],b['argv']))if x!=y]
  assert differences==sorted([a['argv'].index('--output')+1,a['argv'].index('--feature-policy')+1])
  assert a['resource_environment']==b['resource_environment'] and a['predictor_cache_input']==b['predictor_cache_input']
  for p,h in a['input_sha256'].items():
   if p in b['input_sha256']:assert b['input_sha256'][p]==h,p
  argvchecks.append(dict(domain=b['argv'][b['argv'].index('--feature-policy')+1],difference_indices=differences))
 cycles={r['stage']:r['native_cycles']for r in rows};deltas=dict(tiling_minus_replica=cycles['tiling']-cycles['replica'],full_minus_tiling=cycles['full']-cycles['tiling'],full_minus_replica=cycles['full']-cycles['replica'])
 report=dict(schema='orbit-v38-gcn-matched-replica-tiling-full-comparison-v1',status='verified-isolated-research',source_commit=SOURCE,policy=POLICY,rows=rows,raw_native_cycle_differences=deltas,full_regresses_from_tiling_by_more_than_one_cycle=deltas['full_minus_tiling']>1,practical_tie_tolerance_cycles=1,exact_argv_difference_checks=argvchecks,additional_objective_calls=0,additional_native_calls=0,additional_numeric_calls=0,paper_admission=False,formal_admission=False,main_execution=False,limitations=['Only the cumulative legal domain and output path differ between the three independent canonical starts.','Native cycles and every original finalist outcome retain exact integers; the one-cycle tolerance does not alter recorded values.','Full can select a state feasible in a smaller domain. Native improvement alone cannot establish fusion or fission usefulness.','Source35/37 values belong to different search policies and are excluded from this same-source join.'],input_sha256=inputs)
 for p,h in inputs.items():assert sha(p)==h,p
 OUT.mkdir()
 for name,obj in [('REPORT.json',report)]:
  with (OUT/name).open('x') as f:json.dump(obj,f,indent=2);f.write('\n')
 text='| Source38 domain | Native cycles | Objective calls | Original native/numeric finalists |\n|---|---:|---:|---:|\n'
 for row in rows:text+=f"| {row['stage']} | {row['native_cycles']:,} | 256 | 5 / 5 |\n"
 text+=f"\nFull minus Tiling: {deltas['full_minus_tiling']:+,} cycles. Full minus Replica: {deltas['full_minus_replica']:+,} cycles.\n\n"
 text+='\n\n'.join(report['limitations'])+'\n';(OUT/'REPORT.md').write_text(text)
 with (OUT/'FINAL.json').open('x')as f:json.dump(dict(status='pass',report_sha256=sha(OUT/'REPORT.json'),markdown_sha256=sha(OUT/'REPORT.md'),child_report_seals_verified=True,input_pre_post_verified=True,additional_objective_calls=0,additional_native_calls=0,additional_numeric_calls=0,epoch=time.time()),f,indent=2);f.write('\n')
 print(json.dumps(dict(status=report['status'],native_cycles=cycles,raw_native_cycle_differences=deltas,report=str(OUT/'REPORT.json'))))
if __name__=='__main__':main()
