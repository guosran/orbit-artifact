#!/usr/bin/env python3
"""Bounded prediction/native ranking audit of the sealed original five."""
from pathlib import Path
import hashlib,importlib.util,json,re,sys
sys.dont_write_bytecode=True
OUT=Path(__file__).resolve().parent;B=OUT.parent
PARSER=B/'v38-gcn-full-replica-native-difference-readonly-20261012/analyze.py'
PARSER_SHA='e2b43f1506b443f4ba63b6950208b8f610e94f542a9246a85be96673a6726d66'

def sha(p):
 h=hashlib.sha256()
 with Path(p).open('rb') as f:
  for b in iter(lambda:f.read(1<<20),b''):h.update(b)
 return h.hexdigest()

def main():
 assert not (OUT/'REPORT.json').exists()
 assert sha(PARSER)==PARSER_SHA
 spec=importlib.util.spec_from_file_location('sealed_native',PARSER);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
 m.bind(__file__);m.bind(OUT/'analyze.py','e83b9f27efd0b78582fbacf0f25c4be379bbf50d6ecfa079020fee14d95c3186');m.bind(OUT/'DEVELOPMENT_FAILURE.json');m.bind(PARSER,PARSER_SHA);m.bind(Path(m.parser.__file__),m.PARSER_SHA)
 cohort='critical-positive-compute-v38-replica256-continuation1'
 cell=m.load_cell(cohort,'replica')
 unit=Path(cell['search_root']);native=Path(cell['native_root'])
 completion=m.read(unit/'completion.json','7d90ccd5e9074f2a1485ec8aa07e3bfb928eefee911d73512a2ee6de744e1759')
 seal=m.read(native/'native-process-seal.json',completion['artifact_hashes'][str(native/'native-process-seal.json')])
 receipt=m.read(native/'native_replay_result.json',seal['native_receipt_sha256'])
 bound={**receipt['binding']['inputs'],**receipt['artifact_hashes'],**seal['artifact_hashes'],**completion['artifact_hashes']}
 rows=[]
 for row in sorted(receipt['native_shortlist'],key=lambda x:x['rank']):
  rank=native/f"native/rank-{row['rank']}"
  result=m.bound_read(rank/'result.json',bound)
  independently=m.bound_read(rank/'independent-trace.json',bound)
  assert result['candidate_id']==row['candidate_id'] and result['native_cycles']==row['native_cycles']
  assert independently['status']=='pass' and independently['native_cycles']==row['native_cycles']
  native_path=rank/'native.mlir';m.bind(native_path,bound[str(native_path)]);ir=native_path.read_text()
  trace=m.parser.AttributeParser(m.parser.extract_dictionary(ir,'joint_scheduling_actual_trace')).document()
  assert trace['candidate_id']==row['candidate_id']
  task=next(x for x in trace['task_schedule'] if x['task']=='Task_9')
  _,line_number,line=next(x for x in m.blocks(ir) if x[0]=='Task_9')
  shape=re.search(r'amoeba.selected_cgra_shape = "([^"]+)"',line)[1]
  ii_values=[int(x)for x in re.findall(r'compiled_ii = (\d+) : i32',line)]
  assert ii_values and len(set(ii_values))==1
  trip=int(re.search(r'amoeba.selected_trip_count = (\d+)',line)[1])
  duration=int(re.search(r'profile_info = \{duration = (\d+)',line)[1])
  assert duration==task['end_cycle']-task['start_cycle']
  score_path=unit/'search/replay'/f"{row['candidate_id']}-score.jsonl"
  m.bind(score_path,bound[str(score_path)])
  with score_path.open()as f:score=next(x for x in map(json.loads,f)if x.get('record_type')=='score')
  assert score['predicted_whole_program_cycles']==row['predicted_cycles']
  cost=next(x for x in score['task_costs']if x['task']=='Task_9')
  selection=m.bound_read(unit/'search/replay'/f"{row['candidate_id']}-shape.json",bound)
  chosen=next(x for x in selection['task_shapes']if x['task']=='Task_9')
  architecture=selection['architecture'];geometry=chosen['shape']
  assert geometry['cgra_shape']==shape and chosen['trip_count']==trip
  assert cost['mapper_tile_rows']==geometry['mapper_tile_rows']==geometry['rows']*architecture['per_cgra_tile_rows']
  assert cost['mapper_tile_cols']==geometry['mapper_tile_cols']==geometry['cols']*architecture['per_cgra_tile_cols']
  assert cost['trip_count']==trip and cost['startup_cycles']==duration-ii_values[0]*(trip-1)
  rows.append({'predicted_rank':row['rank'],'candidate_id':row['candidate_id'],
    'predicted_cycles':row['predicted_cycles'],'native_cycles':row['native_cycles'],
    'native_minus_predicted_cycles':row['native_cycles']-row['predicted_cycles'],
    'task9':{'shape':shape,'trip_count':trip,'startup_cycles':cost['startup_cycles'],
      'mapper_pe_tile_rows':cost['mapper_tile_rows'],'mapper_pe_tile_cols':cost['mapper_tile_cols'],
      'predicted_ii':cost['predicted_ii'],'native_ii':ii_values[0],
      'predicted_duration':cost['predicted_duration'],'native_duration':duration,
      'native_minus_predicted_duration':duration-cost['predicted_duration'],
      'native_start':task['start_cycle'],'native_end':task['end_cycle'],
      'original_native_file':str(native_path),'original_native_line':line_number}})
 assert [r['predicted_rank']for r in rows]==list(range(5))
 native_values=sorted(set(r['native_cycles']for r in rows))
 for r in rows:r['native_dense_rank']=native_values.index(r['native_cycles'])+1
 pairwise=[];concordant=discordant=ties=0
 for i,a in enumerate(rows):
  for b in rows[i+1:]:
   pd=b['predicted_cycles']-a['predicted_cycles'];nd=b['native_cycles']-a['native_cycles']
   if pd==0 or nd==0:ties+=1;continue
   if pd*nd>0:concordant+=1
   else:
    discordant+=1
    pairwise.append({'predicted_better':a['candidate_id'],'predicted_worse':b['candidate_id'],
                     'predicted_difference_worse_minus_better':pd,
                     'native_difference_worse_minus_better':nd})
 best_pred=min(rows,key=lambda x:(x['predicted_cycles'],x['predicted_rank']))
 best_native=min(rows,key=lambda x:(x['native_cycles'],x['predicted_rank']))
 regret=best_pred['native_cycles']-best_native['native_cycles']
 t9_invariant_fields=['shape','trip_count','startup_cycles','predicted_ii','native_ii','predicted_duration','native_duration']
 assert all(all(r['task9'][k]==rows[0]['task9'][k]for k in t9_invariant_fields)for r in rows)
 D=B/'v38-v37-gcn-replica-native-difference-readonly-20261012'
 ledger=m.read(D/'REPORT.json','786b2d65100843ea8f52eaf4c261daf2ca8c36ffdbc7a5b7705d8c6b16658487')
 ledger_final=m.read(D/'FINAL.json','3da62dab51048d87a6fbde7b11ee041d92ea02ed98fe09569c9e854ccffc2484')
 assert ledger_final['input_pre_post_verified'] and ledger_final['artifact_sha256'][str(D/'REPORT.json')]==m.INPUTS[str(D/'REPORT.json')]
 old=ledger['cells']['source37_replica'];new=ledger['cells']['source38_replica']
 assert old['canonical_inputs']==new['canonical_inputs'] and old['native_optimizer_sha256']==new['native_optimizer_sha256']
 a,b=old['tasks']['Task_9'],new['tasks']['Task_9']
 assert all(a[k]==b[k]for k in ['trip_count','startup_cycles'])
 assert all(b[k]==rows[0]['task9'][k]for k in t9_invariant_fields)
 # In these two winner histories Task9 has no structural primitive; its differing action is geometry.
 for c in [old,new]:
  assert all(not any(p.get('firstTask')=='Task_9' or p.get('secondTask')=='Task_9'for p in action['primitives'])for action in c['typed_actions'])
 cross={'scope':'Existing Source37/38 native winner task profiles; not another Source38 shortlist candidate.',
        'source37_task9':a,'source38_task9':b,
        'predicted_ii_delta':b['predicted_ii']-a['predicted_ii'],
        'native_ii_delta':b['native_ii']-a['native_ii'],
        'predicted_duration_delta':b['predicted_duration']-a['predicted_duration'],
        'native_duration_delta':b['native_duration']-a['native_duration'],
        'prediction_native_geometry_order_reversal':b['predicted_ii']<a['predicted_ii']and b['native_ii']>a['native_ii'],
        'observed_completion_chain_task9_delta':next(r['delta']for r in ledger['chain_term_changes']if r['canonical_lineage']=='Task_9'),
        'whole_completion_chain_delta':ledger['summary']['chain_difference'],
        'whole_native_cycle_delta':ledger['summary']['source38_minus_source37'],
        'isolated_task9_counterfactual':False}
 summary={'original_five_only':True,'predicted_best_candidate':best_pred['candidate_id'],
          'native_best_candidate':best_native['candidate_id'],'predicted_top1_native_regret_cycles':regret,
          'native_order':[r['candidate_id']for r in sorted(rows,key=lambda r:(r['native_cycles'],r['predicted_rank']))],
          'comparable_pairs':concordant+discordant,'concordant_pairs':concordant,'discordant_pairs':discordant,
          'pairs_with_prediction_or_native_tie':ties,'task9_identical_in_original_five':True,
          'task9_native_minus_prediction_duration_each':rows[0]['task9']['native_minus_predicted_duration'],
          'task9_cross_source_geometry_order_reversal':cross['prediction_native_geometry_order_reversal'],
          'task9_cross_source_native_duration_delta':cross['native_duration_delta'],
          'extra_calls':0,'paper_admission':False,'archive_coverage_claim':False}
 for path,digest in m.INPUTS.items():assert sha(path)==digest,('Input changed',path)
 report={'schema':'orbit-gcn-source38-replica-original-five-predictor-rank-readonly-v2',
         'status':'pass-bounded-sealed-five-prediction-native-comparison','source_commit':m.SOURCE,
         'summary':summary,'original_five':rows,'rank_inversions':pairwise,'task9_cross_source37_reference':cross,
         'interpretation':'Predicted top1 selects the best native result among these original five; the lower ranks have inversions. All five use identical Task9 shape/II/duration, so its profile does not explain within-shortlist order differences. The Task9 2x1 versus 1x3 ranking reversal is independently observed in prior sealed cross-policy winners, not a sixth Source38 finalist. No archive accuracy, omitted-state native quality, training overlap or model update is inferred.',
         'analysis_development_correction':str(OUT/'DEVELOPMENT_FAILURE.json'),
         'input_sha256':dict(m.INPUTS),'input_pre_post_verified':True,'extra_calls':0,
         'checkpoint_or_archive_read':False,'live_full_read':False,'paper_or_formal_admission':False}
 (OUT/'REPORT.json').write_text(json.dumps(report,indent=2)+'\n');(OUT/'SUMMARY.json').write_text(json.dumps(summary,indent=2)+'\n')
 lines=['# GCN Source38 Replica: original-five prediction ranking','',
        '| Prediction rank | Candidate | Predicted cycles | Native cycles | Native dense rank |',
        '|---:|---|---:|---:|---:|']
 for r in rows:lines.append(f"| {r['predicted_rank']} | {r['candidate_id']} | {r['predicted_cycles']:,} | {r['native_cycles']:,} | {r['native_dense_rank']} |")
 lines += ['',f"The prediction winner remains the native winner among the original five, with {regret} cycle selection regret. The lower candidates have {discordant} discordant pairs among {concordant+discordant} comparable pairs; one pair ties in both rankings. This statement covers only these five sealed native/numeric results.", '',
           'Every finalist uses Task9 at 1×3: predicted II 5.122213 and duration 2,053 versus native II 6 and duration 2,403 (400 iterations; startup 9). Its duration is underestimated by 350 cycles in each. Task9 therefore does not distinguish or explain the ordering inversions among these finalists.', '',
           'The already sealed Source37 winner uses Task9 at 2×1: predicted II 5.986164/duration 2,398 versus native II 5/duration 2,004. The recorded predictor favors 1×3 by 345 duration cycles, while the existing native labels favor 2×1 by 399. This is a geometry ordering reversal in the two existing winner profiles, with equal trip counts/startup and canonical inputs; it is not a new prediction or mapping.', '',
           'Task9 adds 399 cycles to the paired completing chain in the Source37→38 Replica ledger, while the whole schedule improves by 1,920. Other duration, transfer, reserved-channel and residual terms explain the remainder. It is an observed schedule accounting term, not a counterfactual replacement benefit. Source38 Full remains outside this report.', '',
           'All actually read files were hash-checked before and after. No new objective calls, prediction, mapping, numeric validation, model changes, archive/checkpoint scan, live Full read or paper edit occurred.', '']
 (OUT/'REPORT.md').write_text('\n'.join(lines))
 paths=[OUT/'REPORT.json',OUT/'REPORT.md',OUT/'SUMMARY.json',Path(__file__)]
 (OUT/'FINAL.json').write_text(json.dumps({'schema':'orbit-readonly-report-seal-v1','status':'sealed-independent-predictor-rank-audit',
    'artifact_sha256':{str(p):sha(p)for p in paths},'input_sha256':dict(m.INPUTS),'input_pre_post_verified':True,'extra_calls':0},indent=2)+'\n')
 print(json.dumps({'output':str(OUT),'report_sha256':sha(OUT/'REPORT.json'),'final_sha256':sha(OUT/'FINAL.json'),
                   'summary_sha256':sha(OUT/'SUMMARY.json'),'summary':summary,'input_count':len(m.INPUTS)}))
if __name__=='__main__':main()
