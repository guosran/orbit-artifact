#!/usr/bin/env python3
"""Explain the already sealed same-version native ledger; no new execution."""
import hashlib,json
from pathlib import Path
OUT=Path(__file__).resolve().parent;B=OUT.parent;INPUTS={}

def sha(p):
 h=hashlib.sha256()
 with Path(p).open('rb')as f:
  for b in iter(lambda:f.read(1<<20),b''):h.update(b)
 return h.hexdigest()

def read(p,expected):
 assert sha(p)==expected,(p,expected);INPUTS[str(p)]=expected
 return json.loads(p.read_text())

def main():
 assert not (OUT/'EXPLANATION.json').exists()
 INPUTS[str(Path(__file__))]=sha(__file__)
 r=read(OUT/'REPORT.json','8fbc6af8766db6c79591130ea52d70de9ba651c868958a72178b686b46d9a98e')
 seal=read(OUT/'FINAL.json','1013632357b62d1c5cf153441c5ba49238925a76d9dd24c64c5b2b4b04e0ba47')
 assert seal['input_pre_post_verified'] and seal['artifact_sha256'][str(OUT/'REPORT.json')]==INPUTS[str(OUT/'REPORT.json')]
 M=B/'critical-positive-compute-v38-matched-comparison1'
 matched=read(M/'REPORT.json','e1ee402f092387edad3bd8ed581578525de5f44123051307fd4ec0bee64e6312')
 mseal=read(M/'FINAL.json','93725c8bbbf9fbfce15668208c7628277dca8747e577e42f37fb7c5c2ef83f57')
 assert mseal['status']=='pass' and mseal['input_pre_post_verified'] and mseal['report_sha256']==INPUTS[str(M/'REPORT.json')]
 assert matched['full_minus_replica_native_cycles']==r['summary']['full_minus_replica']==-1915
 T=B/'v38-gcn-matched-membership-addendum-readonly-20261012'
 trace=read(T/'REPORT.json','1fb8b3950caf09a688231a0b24888fe145ec07c04bb93a14a410356b1bd7a2b8')
 tseal=read(T/'FINAL.json','0f50ca880d5f5dbce411ab5e23f8c7306b81fd36960d0e3739bc3c66ca614353')
 assert tseal['status']=='pass'and tseal['input_pre_post_verified']and tseal['report_sha256']==INPUTS[str(T/'REPORT.json')]
 assert trace['source_commit']==matched['source_commit']==r['summary']['source_commit']
 assert trace['additional_objective_calls']==trace['additional_native_calls']==trace['additional_numeric_calls']==0
 cells=r['cells'];rep,full=cells['replica'],cells['full']
 assert full['winner']['candidate_id']=='neighborhood-201371' and full['winner']['rank']==0
 assert full['winner']['native_cycles']==918724 and rep['winner']['native_cycles']==920639
 assert full['action_families']=={'shape':17,'replica':1}
 assert rep['action_families']=={'shape':17,'replica':2}
 assert not any(a['family']in['fusion','fission','tiling'] for a in full['typed_actions'])
 all_payloads_bandwidth_match=True
 for a,b in zip(rep['latest_route_completion_chain'],full['latest_route_completion_chain']):
  assert (a['route']is None)==(b['route']is None)
  if a['route']:
   assert all(a['route'][k]==b['route'][k]for k in ['payload_bits','bottleneck_bandwidth_bits_per_cycle'])
   assert b['transfer']-a['transfer']==b['path_latency']-a['path_latency']
 deltas={row['canonical_lineage']:row['delta']['duration']for row in r['paired_chain_term_changes']if row['delta']['duration']}
 assert deltas=={'Task_9':-798,'Task_15':-399,'Task_21':-399,'Task_22':-399,'Task_26':79}
 assert r['summary']['chain_difference']=={'duration':-1916,'transfer':1,'reservation_wait':0,'start_residual':0}
 key_tasks=['Task_9','Task_10','Task_11','Task_12','Task_23','Task_24','Task_18']
 key_native={name:{label:{k:cell['tasks'][name][k]for k in ['shape','native_ii','trip_count','startup_cycles','native_duration']}
                   for label,cell in cells.items()}for name in key_tasks}
 for name in key_tasks:
  if name!='Task_9':assert key_native[name]['replica']==key_native[name]['full']
 branch={'closed_source':str(T/'REPORT.json'),'replica_winner_semantic_state_in_full_archive':trace['replica_winner_semantic_state_in_full_archive'],
         'first_absent_replica_typed_prefix':trace['first_absent_replica_typed_prefix'],
         'semantic_scope':'The cited independent trace matches exact ordered graph/lineage/kernel-body hashes and task shapes, excluding candidate/graph IDs. This explanation imports its sealed result; it does not rescan archive/checkpoint.',
         'interpretation':'Full does not reproduce the entire Replica winner state but selects a different better native combination. Exact Replica prefix loss and better final native result can coexist.'}
 explanation={'schema':'orbit-gcn-source38-native-ledger-explanation-v1','status':'pass-sealed-same-source-native-explanation',
      'summary':r['summary'],'key_task_native_profiles':key_native,'nonzero_completion_chain_duration_deltas':deltas,
      'all_paired_chain_payloads_and_bandwidths_match':all_payloads_bandwidth_match,
      'net_transfer_difference_entirely_original_path_latency':True,
      'full_selected_history_has_fusion':False,'full_selected_history_has_fission':False,'full_selected_history_has_tiling':False,
      'full_replica_primitive':[p for a in full['typed_actions']for p in a['primitives']if p['kind']=='replica'],
      'replica_replica_primitives':[p for a in rep['typed_actions']for p in a['primitives']if p['kind']=='replica'],
      'sealed_semantic_branch_reference':branch,
      'limitation':'The selected Full history is feasible in Replica space. Its winning schedule does not directly demonstrate fusion/fission benefit. A space change changes the search trajectory; these two completed schedules do not isolate the causal contribution of each geometry or structural action. Source37 is a separate cross-version policy reference.',
      'input_sha256':dict(INPUTS),'input_pre_post_verified':True,'extra_calls':0,'paper_admission':False}
 for p,d in INPUTS.items():assert sha(p)==d,('Input changed',p)
 (OUT/'EXPLANATION.json').write_text(json.dumps(explanation,indent=2)+'\n')
 lines=['# Source38 GCN: matched Full and Replica native explanation','',
 'Full rank 0 / candidate 201371 completes in 918,724 cycles; Replica rank 0 / candidate 4645 completes in 920,639. Each original five-rank native/numeric chain is sealed at 256 actual objective calls. Source38, canonical inputs and native optimizer match.', '',
 '| Completing-chain task | Replica shape / native II | Full shape / native II | Duration change |','|---|---|---|---:|']
 for row in r['paired_chain_term_changes']:
  if not row['delta']['duration']:continue
  a,b=row['replica_task_cost'],row['full_task_cost']
  lines.append(f"| {row['canonical_lineage']} | {a['shape']} / {a['native_ii']} | {b['shape']} / {b['native_ii']} | {row['delta']['duration']:+,} |")
 lines += ['', 'Exact observed difference: −798 −399 −399 −399 +79 +1 = −1,915 cycles. Startup terms and trip counts agree in each paired task. The +1 transfer difference is +2 route latency into Task21 and −1 into Task23; paired payloads and bandwidths agree. Reservation wait and non-route start residual do not change. Path latency is already included in transfer.', '',
 'Among the six reference tasks, Task9 improves from 1×3 / II6 / 2,403 cycles to 2×2 / II4 / 1,605. Task10/11/23/24 remain 2×2 / II4 / 1,605 in both winners; Task12 remains 1×3 / II6 / 2,403. Task18 is also 2×2 / II4 / 1,605 in both. All seven have 400 iterations and startup9.', '',
 'Full has 17 shape actions and one Task14 replica (factor2). Replica has 17 shape actions and replicas for Task14 (factor4) and Task20 (factor2). Full has 29 native tasks; Replica has 32. The Full winner uses no fusion, fission or tiling action. Its final state is therefore within Replica’s available space; the result demonstrates a different search trajectory and selected geometry combination, not a direct fusion/fission gain.', '',
 'The original completing-producer chains match after authenticated replica aliases. Task9, Task15, Task21 and Task22 shorten that chain; Task26 becomes slower (1×2/II4 → 1×3/II5), offsetting 79 cycles. This is measured schedule accounting from original mapped durations and scheduling traces, not an isolated replacement experiment.', '',
 'The closed semantic trace independently reports that Replica’s complete winner is absent from Full’s archive, with its first absent typed prefix at step5. Full still finds a different better combination. Candidate IDs are not treated as portable state identities, and this report does not reread the large archive or checkpoint.', '',
 'Actual charged shape attempts for Task9/10/11/12/23/24 are Full 5/5/5/15/5/5 versus Replica 4/4/4/4/4/4. These are attempts across recorded parents, not distinct shapes or legal opportunities. Source37’s earlier failure remains a cross-version compute-tier reference, separate from this same-Source38 comparison.', '',
 'The immutable REPORT/FINAL retain the original native receipts, typed histories, task CSVs, routes and closed-funnel allocation. This explanation has a separate pre/post input hash seal. No new scoring, mapping, numeric execution, model changes or paper modification occurred.', '']
 (OUT/'EXPLANATION.md').write_text('\n'.join(lines))
 (OUT/'EXPLANATION-FINAL.json').write_text(json.dumps({'schema':'orbit-readonly-report-seal-v1','status':'sealed-independent-native-explanation',
     'artifact_sha256':{str(p):sha(p)for p in [OUT/'EXPLANATION.json',OUT/'EXPLANATION.md',Path(__file__)]},
     'input_sha256':dict(INPUTS),'input_pre_post_verified':True,'extra_calls':0},indent=2)+'\n')
 print(json.dumps({'explanation_sha256':sha(OUT/'EXPLANATION.json'),'markdown_sha256':sha(OUT/'EXPLANATION.md'),
                   'final_sha256':sha(OUT/'EXPLANATION-FINAL.json'),'input_count':len(INPUTS),'duration_deltas':deltas,'total_delta':-1915}))
if __name__=='__main__':main()
