#!/usr/bin/env python3
"""Report closed Source38 Tiling256 original exact-five outcomes; no experiment calls."""
import json,hashlib,re,sys,time
from pathlib import Path
from collections import Counter
sys.dont_write_bytecode=True
R=Path(__file__).resolve().parent
sys.path.insert(0,str(R/'diagnosis/python-deps'))
from diagnosis_directional_tiling_chain_audit import root_members
B=R/'diagnosis/search-regression-repair-20261010'
N=U=OUT=STAGE=None
def sha(p):
 h=hashlib.sha256()
 with Path(p).open('rb')as f:
  for block in iter(lambda:f.read(1<<20),b''):h.update(block)
 return h.hexdigest()
def read(p):return json.loads(Path(p).read_text())
def check(h):
 for p,d in h.items():assert sha(p)==d,p
def write(p,d):
 with p.open('x')as f:json.dump(d,f,indent=2);f.write('\n')
def usage(p):
 raw=p.read_text();m={}
 for key,pattern in [('wall','Elapsed \\(wall clock\\) time \\(h:mm:ss or m:ss\\): ([^\\n]+)'),('user_cpu_seconds','User time \\(seconds\\): ([0-9.]+)'),('system_cpu_seconds','System time \\(seconds\\): ([0-9.]+)'),('peak_rss_kib','Maximum resident set size \\(kbytes\\): ([0-9]+)'),('filesystem_output_blocks','File system outputs: ([0-9]+)')]:
  match=re.search(pattern,raw);assert match,(p,key);m[key]=match.group(1) if key=='wall' else float(match.group(1))
 return m
def replaced_structural_windows(p):
 """Read sealed open/close records; report displaced opportunities, not costs."""
 active=None;rows=[];generated=[];refresh=[];generated_events=0;digest=hashlib.sha256()
 with p.open('rb')as f:
  for line in f:
   digest.update(line)
   if not any(token in line for token in [b'"followup_window"',b'"generated_frontier"',b'"frontier_decision"']):continue
   event=json.loads(line)
   if event.get('record_type')=='generated_frontier':
    generated_events+=1
    for child in event['pruned']:generated.append(dict(round=event['round'],objective_calls=event['evaluations'],**child))
    continue
   if event.get('record_type')=='frontier_decision':
    refresh.append(dict(round=event['round'],objective_calls=event['evaluations'],pruned_new=event['pruned_new'],retained_new=event['retained_new']))
    continue
   if event.get('record_type')!='followup_window':continue
   if event['event']=='open':
    assert active is None,'Stacked followup window'
    active=event
   elif event['event']=='close':
    assert active and active['parent_key']==event['parent_key'],'Unpaired close'
    if 'retained communication direction replaces refresh structural window' in event['reason']:
     assert active['round']==event['round'] and event['charged']==0
     rows.append(dict(round=event['round'],parent_id=event['parent_id'],
      trigger_family=active['trigger_family'],related_targets=active['related_targets'],
      allowed_families=active['allowed_families'],charged_before_replacement=0,
      zero_debit_before_replacement=event['zero_debit'],reason=event['reason']))
    active=None
 return rows,digest.hexdigest(),dict(generated_frontier_events=generated_events,intraround_generated_prunes=generated,refresh_merge_prunes=refresh)
def main():
 assert not OUT.exists(),'Preserve old report'
 completion=read(U/'completion.json');assert completion['status']=='pass-targeted-diagnostic'
 assert completion['actual_objective_calls']==256 and completion['extra_objective_calls']==0 and completion['native_evaluated']==5
 check(completion['artifact_hashes'])
 audit=read(U/'search-audit.json');final=read(U/'mechanism-audit/FINAL.json')
 assert audit['status']==final['status']=='pass' and final['report_sha256']==sha(U/'mechanism-audit/REPORT.json')
 outcome_path=U/'outcome-audit/result.json';outcome=read(outcome_path);seal=read(U/'outcome-audit/outcome-process-seal.json')
 assert outcome['status']==seal['status']=='pass' and outcome['all_original_shortlist_outcomes_sealed'] is True
 assert seal['outcome_report_sha256']==sha(outcome_path)
 check(seal['input_sha256'])
 assert outcome['native_evaluated']==outcome['native_replayed']==outcome['numeric_validated']==5 and outcome['certified_scheduler_rejected']==0
 assert completion['source_commit']=='76345481683a2e199c0cad155de2acb51149f350'
 control_paths=[];records=[]
 for label,name in [('Replica','critical-positive-compute-v38-replica256-continuation1'),('Full','critical-positive-compute-v38-full256-continuation1')]:
  root=B/name/'closed-report';rp=root/'REPORT.json';fp=root/'FINAL.json';rr=read(rp);ff=read(fp)
  assert ff['status']=='pass' and ff['report_sha256']==sha(rp) and ff['input_pre_post_verified'] is True
  assert rr['status']=='verified-isolated-research' and rr['source_commit']==completion['source_commit']
  assert rr['objective_calls']==256 and rr['extra_objective_calls']==0
  assert rr['native_evaluated']==rr['numeric_validated']==5 and rr['certified_scheduler_rejected']==0
  assert rr['policy']==audit['policy'] and rr['native_optimizer_sha256']=='80f11127c25360b591cbd705d3e7d25d3060ba90cf2978f8d5a56133cf58a761'
  records.append(dict(stage='Source38 '+label,source_commit=rr['source_commit'],native_cycles=rr['native_best_cycles']))
  control_paths.extend([rp,fp])
 baselines=dict(records=records)
 best=outcome['best_validated_candidate'];best_cycles=best['native_cycles']
 inputs={str(Path(__file__).resolve()):sha(__file__)}
 for p in [U/'completion.json',U/'search-audit.json',U/'mechanism-audit/FINAL.json',outcome_path,U/'outcome-audit/outcome-process-seal.json',N/'supervisor-launch.json',*control_paths,N/'prepared-v1/ROOT-authorization.json',N/'prepared-v1/pipeline-binding.json',U/'usage.txt']:
  inputs[str(p)]=sha(p)
 valid={}
 archive=U/'search/archive.jsonl'
 with archive.open()as f:
  for line in f:
   row=json.loads(line)
   if row.get('valid'):valid[row['candidate_id']]=row
 assert len(valid)<=256
 inputs[str(archive)]=sha(archive)
 top=[];top_path=U/'search/top5.jsonl'
 with top_path.open()as f:
  for line in f:
   row=json.loads(line)
   if row.get('record_type')=='selection':top.append(row)
 assert [r['rank']for r in top]==list(range(5))
 inputs[str(top_path)]=sha(top_path)
 replaced,direction_sha,pruning=replaced_structural_windows(U/'search/directions.jsonl')
 inputs[str(U/'search/directions.jsonl')]=direction_sha
 windows=audit['retained_communication_windows'];selected={a['candidate_id']:dict(window_round=w['round'],window_parent=w['parent_id'],**a)for w in windows for a in w['selections'] if a['debit']}
 finalists=[]
 for raw in outcome['outcomes']:
  cid=raw['candidate_id'];v=valid[cid];chain=[];seen=set();cur=cid
  while cur in valid and cur not in seen:
   seen.add(cur)
   if cur in selected:chain.append(selected[cur])
   cur=valid[cur].get('parent_candidate_id')
  families=Counter(a['family']for a in v['action_history']['actions'])
  finalists.append(dict(rank=raw['rank'],candidate_id=cid,predicted_cycles=v['predicted_whole_program_cycles'],native_cycles=raw.get('native_cycles'),outcome=raw['outcome'],numeric=raw.get('strict_numeric'),history_families=dict(families),fission_action_count=len(v['action_history']['fissionActions']),action_history=v['action_history'],window_ancestors_in_recorded_parent_chain=chain,shapes=v['shapes']))
 window_targets=Counter(a['target']for w in windows for a in w['selections']);window_paid_targets=Counter(a['target']for w in windows for a in w['selections']if a['debit'])
 deltas=[dict(stage=b['stage'],source_commit=b['source_commit'],native_cycles=b['native_cycles'],delta_cycles=best_cycles-b['native_cycles'],speedup=b['native_cycles']/best_cycles)for b in baselines['records']]
 report=dict(schema='orbit-v38-gcn-tiling256-continued-research-report-v1',status='verified-isolated-research',source_commit=completion['source_commit'],native_optimizer_sha256='80f11127c25360b591cbd705d3e7d25d3060ba90cf2978f8d5a56133cf58a761',policy=audit['policy'],objective_calls=256,extra_objective_calls=0,native_evaluated=5,numeric_validated=outcome['numeric_validated'],certified_scheduler_rejected=outcome['certified_scheduler_rejected'],native_best_cycles=best_cycles,original_exact_five_finalists=finalists,same_source38_diagnostic_comparisons=deltas,stage=STAGE,feature_policy=audit['feature_policy'],canonical_task7_first_2x1=audit['canonical_task7_first_2x1'],communication_shape_window_count=len(windows),communication_shape_window_attempts=sum(len(w['selections'])for w in windows),communication_shape_window_paid=audit['retained_communication_shape_charges'],communication_shape_window_target_attempts=dict(window_targets),communication_shape_window_target_paid=dict(window_paid_targets),attempts_by_mode=audit['attempts_by_mode'],charges_by_mode=audit['charges_by_mode'],semantic_attempts=audit['exact_semantic_attempts'],zero_debit_attempts=audit['zero_debit_attempts'],semantic_edge_duplicates=audit['global_exact_edge_duplicates'],archive_predicted_minimum=min(v['predicted_whole_program_cycles']for v in valid.values()),finalist_predicted_minimum=min(v['predicted_cycles']for v in finalists),search_usage=usage(U/'usage.txt'),paper_admission=False,formal_admission=False,main_execution=False,limitation='Source38 Tiling, Full and Replica are matched independent canonical256 configurations. A separate three-domain join verifies that only output and cumulative domain differ. Recorded parent-chain window ancestry can differ from merged alternate typed lineages; native source replay validates the actual final typed history. No monotonicity or native benefit from fusion/fission is assumed.',input_sha256=inputs)
 report['critical_positive_compute']=True
 report['reconstructed_parent_direction_count']=audit['reconstructed_parent_direction_count']
 report['changed_compute_target_count']=audit['changed_compute_target_count']
 report['first_tier_guided_paid']=audit['first_tier_guided_paid']
 report['first_tier_guided_paid_targets']=dict(Counter(a['target']for a in audit['first_tier_guided_paid']))
 report['independent_all_compute_groups']=audit['independent_all_compute_groups']
 report['all_parent_direction_coverage']=audit['all_parent_direction_coverage']
 report['two_pruning_layers']=pruning
 report['replaced_structural_window_count']=len(replaced)
 report['replaced_structural_windows']=replaced
 report['replacement_interpretation']='Each listed newly opened structural window closed before any charged followup. Its ordinary/guided legal actions remained available. This records lost dedicated window service, not a measured counterfactual child cost or proof that the child would improve native cycles.'
 assert report['archive_predicted_minimum']==report['finalist_predicted_minimum'],'Archive predictor winner missing from final shortlist'
 check(inputs);OUT.mkdir()
 write(OUT/'REPORT.json',report)
 text=f"GCN Source38 {STAGE}256: {best_cycles:,} native cycles after the original five finalist checks, with {outcome['numeric_validated']} strict numerical validations.\n\n"
 text+='| Same-source38 reference | Native cycles | Tiling minus reference |\n|---|---:|---:|\n'
 for d in deltas:text+=f"| {d['stage']} | {d['native_cycles']:,} | {d['delta_cycles']:+,} |\n"
 text+=f"\nCritical-positive compute targets receive {len(audit['first_tier_guided_paid'])} guided paid shape attempts; independent reconstruction covers all {audit['reconstructed_parent_direction_count']} parent direction catalogues.\n"
 text+=f"\nCommunication-shape windows consumed {report['communication_shape_window_paid']} of 256 calls across {len(windows)} windows. The independent replay verifies all {report['semantic_attempts']} semantic attempts and the original 4-charge/64-zero window caps. All five original native outcomes are retained in the JSON.\n\n"
 text+=f"The generated frontier pruned {len(pruning['intraround_generated_prunes'])} children within rounds; refresh merges pruned {sum(len(r['pruned_new'])for r in pruning['refresh_merge_prunes'])} newly generated states. These are recorded separately.\n\n"
 text+=f"{len(replaced)} newly opened structural windows were replaced before charged followup. Their parent, family and target records are in the JSON; these are displaced dedicated opportunities, without a measured counterfactual native cost.\n\n"+report['limitation']+'\n'
 (OUT/'REPORT.md').write_text(text)
 write(OUT/'FINAL.json',dict(status='pass',report_sha256=sha(OUT/'REPORT.json'),markdown_sha256=sha(OUT/'REPORT.md'),input_pre_post_verified=True,additional_objective_calls=0,additional_native_calls=0,additional_numeric_calls=0,paper_admission=False,epoch=time.time()))
 print(json.dumps(dict(status=report['status'],native_best_cycles=best_cycles,deltas=deltas,report=str(OUT/'REPORT.json'))))
if __name__=='__main__':
 import argparse
 parser=argparse.ArgumentParser(description=__doc__)
 parser.add_argument('--stage',choices=['tiling'],default='tiling')
 args=parser.parse_args();STAGE=args.stage
 N=B/'critical-positive-compute-v38-tiling256-continuation1'
 U=N/'runs/b256/gcn'/STAGE;OUT=N/'closed-report';main()
