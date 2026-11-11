#!/usr/bin/env python3
"""Read-only independent audits of C++ catalogues, decisions and work budgets."""
import argparse, collections, hashlib, json, math, zlib
from pathlib import Path


def read(path):return json.loads(Path(path).read_text())
def key(value):return json.dumps(value,sort_keys=True,separators=(',',':'))
def scalar(row):
 feedback=row.get('evaluation') or {};score_object=feedback.get('score') or {};score=score_object.get('value')
 return float(score) if isinstance(score,(float,int)) and math.isfinite(score) else None

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--matrix',type=Path,action='append',required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
 runs=[];plan_facts={};same_plan_checks=0;plan_mismatches=[];catalogue_sets=collections.defaultdict(list);reference_frontiers=[];curves=[]
 for matrix in a.matrix:
  for receipt in sorted(matrix.glob('*/run.json')):
   record=read(receipt);assert record['returncode']==0,receipt;condition=record['condition'];search=Path(record['search_directory']);report=read(search/'search.json');stats=report.get('stats',{});trace=report.get('trace',[])
   historical=condition.get('historical',False)
   if not historical:assert stats and trace,('missing accounting/trace',search)
   for coordinate in ['score_queries','raw_cost_provider_calls','internal_planner_calls','elapsed_ms']:
    values=[row[coordinate] for row in trace if coordinate in row];assert all(y>=x for x,y in zip(values,values[1:])),(coordinate,search)
   scores=[row['best_score'] for row in trace if isinstance(row.get('best_score'),(float,int))];assert all(y<=x+1e-12 for x,y in zip(scores,scores[1:])),search
   config=read(receipt.parent/'config.json');raw_limit=config['native_auto_candidates'].get('max_cost_provider_calls')
   if stats and raw_limit is not None and not historical:assert stats.get('budgeted_cost_provider_calls',stats.get('raw_cost_provider_calls',0))<=raw_limit,(stats,raw_limit)
   if stats and not historical and not stats.get('resumed_from_checkpoint',False) and 'raw_full_cost_provider_calls' in stats:
    unclassified=stats['raw_full_cost_provider_calls']-stats['budgeted_cost_provider_calls']-stats.get('checkpoint_revalidation_cost_provider_calls',0)
    assert unclassified==0,('unclassified complete cost-provider work',search,unclassified,stats)
   catalogue_path=search/'catalogue.json';catalogue=read(catalogue_path) if catalogue_path.exists() else None;configurations={}
   if catalogue:
    proposals=catalogue['proposals'];configurations={x['candidate_id']:x for x in proposals};ids={x['configuration_id'] for x in proposals};assert len(ids)==len(proposals),search
    catalogue_sets[(condition['program'],condition['tile_generator'])].append({'condition':condition,'catalogue_id':catalogue['catalogue_id'],'catalogue_complete':catalogue['catalogue_complete'],'configuration_ids':ids})
   best=None;priced=0;unknown=0;groupcounts=set();rows=[]
   for row in report['archive']:
    score=scalar(row)
    if score is None:
     diagnostics=(row.get('evaluation') or {}).get('diagnostics') or {};unpriced_plan=diagnostics.get('best_plan') or {}
     unknown+=row.get('status')=='uncalibrated' and diagnostics.get('status')=='uncalibrated' and unpriced_plan.get('analysis_status')=='supported' and bool(unpriced_plan.get('plan_id')) and bool(unpriced_plan.get('program_graph_id'))
     continue
    priced+=1;best=score if best is None else min(best,score);candidate=row['candidate_id'];path=search/'candidates'/row.get('search_key',candidate)/'mapping-result.json'
    if not path.exists():path=Path(row['evaluation']['evidence_path'])
    mapping=read(path);plan=mapping['best_plan'];assert plan['estimated_ms']==score
    graph=plan['program_graph']
    instance_limit=config['native_auto_candidates'].get('max_compute_instances')
    if instance_limit is not None and not historical:assert plan['phase_count']<=instance_limit,(path,plan['phase_count'],instance_limit)
    identity=(condition['program'],candidate)
    plan_bytes=key(plan).encode();graph_bytes=key(graph).encode()
    if identity in plan_facts:
     previous=plan_facts[identity]
     if zlib.decompress(previous['plan'])!=plan_bytes or zlib.decompress(previous['graph'])!=graph_bytes:plan_mismatches.append({'program':condition['program'],'candidate_id':candidate,'first':previous['path'],'second':str(path)})
     else:same_plan_checks+=1
    else:plan_facts[identity]={'plan':zlib.compress(plan_bytes),'graph':zlib.compress(graph_bytes),'path':str(path)}
    choices=plan['program_mapping_choices'];groups=choices.get('residency_groups',[])
    if not groups and choices.get('task_group'):groups=[{'tasks':choices['task_group'],'retained_storages':choices['retained_storages']}]
    groupcounts.add(len(groups));organization=key(choices);proposal=configurations.get(candidate,{})
    item={'configuration_id':proposal.get('configuration_id'),'candidate_id':candidate,'program_graph_id':plan['program_graph_id'],'program_graph_complete_sha256':hashlib.sha256(graph_bytes).hexdigest(),'score_ms':score,'tile_sizes':plan['tile_sizes'],'organization':organization,'group_count':len(groups),'peak_local_bytes':plan['resident_bytes'],'boundary_bytes':plan['actual_dma_bytes'],'deliveries':plan['transfer_count'],'configurations':len(plan['execution_groups']),'compute_instances':plan['phase_count'],'tile_provenance':proposal.get('derivation',{}).get('tile_provenance'),'source_path':str(path.parent/'taskflow.mlir'),'mapping_path':str(path)};rows.append(item)
   exclusions_path=search/'strategy-exclusions.json';exclusions=read(exclusions_path) if exclusions_path.exists() else []
   rejected_counts=collections.Counter(x.get('reason','unspecified') for x in catalogue.get('rejected',[])) if catalogue else {}
   tile_origins=collections.defaultdict(set)
   if catalogue:
    for proposal in catalogue['proposals']:
     provenance=proposal.get('derivation',{}).get('tile_provenance',{});tile_origins[key(provenance.get('tile_sizes',[]))].update(provenance.get('origins',[]))
   run={'condition':condition,'raw_work_telemetry_available':bool(stats),'catalogue_rejection_reason_counts':dict(rejected_counts),'tile_universe_origins':{k:sorted(v) for k,v in tile_origins.items()},'search_directory':str(search),'external_wall_seconds':record['external_wall_seconds'],'execution_condition':record.get('execution_condition','Preserved archive condition; no new timing claim'),'stats':stats,'best_score_ms':best,'priced_legal_archive_rows':priced,'valid_unknown_archive_rows':unknown,'evaluated_group_counts':sorted(groupcounts),'catalogue_id':catalogue.get('catalogue_id') if catalogue else None,'catalogue_complete':catalogue.get('catalogue_complete') if catalogue else None,'catalogue_legal_configuration_count':len(configurations),'admitted_canonical_candidate_ids':sorted(configurations),'strategy_exclusions':exclusions,'chosen_rows':rows};runs.append(run)
   if condition['strategy']=='catalogue':
    by_org=collections.defaultdict(list)
    for row in rows:by_org[row['organization']].append(row)
    for org,values in by_org.items():
     optimum=min(x['score_ms'] for x in values);reference_frontiers.append({'program':condition['program'],'tile_generator':condition['tile_generator'],'organization':json.loads(org),'scope':'Finite admitted/scored catalogue only; complete/truncated status retained','catalogue_complete':run['catalogue_complete'],'best_estimate_ms':optimum,'optimal_tile_diagnostic_tolerance_ms':1e-12,'exact_raw_minimum_tiles':[x['tile_sizes'] for x in values if x['score_ms']==optimum],'optimal_tiles':[x['tile_sizes'] for x in values if abs(x['score_ms']-optimum)<=1e-12],'rows':values})
   if trace:curves.append({'condition':condition,'trace':trace})
 comparisons=[]
 for (program,generator),values in catalogue_sets.items():
  complete=[x for x in values if x['catalogue_complete']];sets={tuple(sorted(x['configuration_ids'])) for x in complete};complete_ids={x['catalogue_id'] for x in complete}
  assert len(sets)<=1 and len(complete_ids)<=1,('complete catalogue identity or set differs across policies/budgets',program,generator)
  admitted=collections.defaultdict(list)
  for row in values:
   admitted_identity=hashlib.sha256(key([row['catalogue_id'],sorted(row['configuration_ids'])]).encode()).hexdigest();admitted[admitted_identity].append(row)
  groups=[]
  for identity,rows in admitted.items():
   groups.append({'actual_admitted_catalogue_id':identity,'generator_catalogue_id':rows[0]['catalogue_id'],'configuration_count':len(rows[0]['configuration_ids']),'all_runs_complete':all(x['catalogue_complete'] for x in rows),'same_bounded_admitted_range':True,'conditions':[x['condition'] for x in rows],'interpretation':'Exact same generator catalogue ID and admitted configuration set; permits bounded same-pool comparisons even when a scope/configuration bound prevents larger-universe completeness.'})
  comparisons.append({'program':program,'tile_generator':generator,'complete_runs':len(complete),'incomplete_runs':len(values)-len(complete),'complete_configuration_sets_and_ids_equal':len(sets)<=1 and len(complete_ids)<=1,'generator_catalogue_ids':sorted({x['catalogue_id'] for x in values}),'actual_admitted_pool_groups':groups,'different_actual_admitted_ids_are_not_same_pool':True})
 cross_generator=[]
 for program in sorted({x['condition']['program'] for x in runs}):
  references={x['condition']['tile_generator']:x for x in runs if x['condition']['program']==program and x['condition']['strategy']=='catalogue'}
  if not all(name in references for name in ['constraint','historical-halving']):continue
  left,right=references['constraint'],references['historical-halving']
  # Configuration IDs are generator-namespaced. Compare canonical materialized
  # source identities and checked graph identities, rather than pretending that
  # two distinct catalogue namespaces share literal configuration IDs.
  candidates_left=set(left['admitted_canonical_candidate_ids']);candidates_right=set(right['admitted_canonical_candidate_ids'])
  graphs_left={x['program_graph_id'] for x in left['chosen_rows']};graphs_right={x['program_graph_id'] for x in right['chosen_rows']}
  cross_generator.append({'program':program,'scope':'All admitted canonical configurations; checked graph sets below include priced rows only. Actual-AIE deduplication/execution evidence is separate. No strict-superset assumption under tile quota.','constraint_catalogue_complete':left['catalogue_complete'],'halving_catalogue_complete':right['catalogue_complete'],'canonical_candidate_counts':{'constraint':len(candidates_left),'halving':len(candidates_right),'intersection':len(candidates_left&candidates_right),'constraint_only':len(candidates_left-candidates_right),'halving_only':len(candidates_right-candidates_left)},'common_canonical_candidates':sorted(candidates_left&candidates_right),'constraint_only_canonical_candidates':sorted(candidates_left-candidates_right),'halving_only_canonical_candidates':sorted(candidates_right-candidates_left),'common_checked_graphs':sorted(graphs_left&graphs_right),'constraint_only_checked_graphs':sorted(graphs_left-graphs_right),'halving_only_checked_graphs':sorted(graphs_right-graphs_left),'constraint_is_strict_admitted_candidate_superset':bool(candidates_left>candidates_right),'constraint_best_estimate_ms':left['best_score_ms'],'halving_best_estimate_ms':right['best_score_ms']})
 prefix_groups=collections.defaultdict(list)
 for curve in curves:
  c=curve['condition']
  if c['strategy'] in ['strong-reuse-first','strong-tile-first','alternating','joint']:
   prefix_groups[(c['program'],c['tile_generator'],c['budget_kind'],c['budget'])].append(curve)
 equal_prefix=[]
 for group,values in prefix_groups.items():
  if len({x['condition']['strategy'] for x in values})!=4:continue
  for coordinate in ['raw_cost_provider_calls','elapsed_ms']:
   # A stopped policy supplies no hypothetical future observations. Restrict all
   # policies to the smallest actual final coordinate, then take last observed.
   cutoff=min(max(row[coordinate] for row in x['trace']) for x in values)
   observed=[]
   for curve in values:
    eligible=[x for x in curve['trace'] if x[coordinate]<=cutoff and isinstance(x.get('best_score'),(float,int))]
    last=eligible[-1] if eligible else None
    observed.append({'strategy':curve['condition']['strategy'],'best_score_ms':last['best_score'] if last else None,'observed_coordinate':last[coordinate] if last else None,'final_actual_coordinate':max(x[coordinate] for x in curve['trace'])})
   equal_prefix.append({'program':group[0],'tile_generator':group[1],'budget_kind':group[2],'budget':group[3],'coordinate':coordinate,'common_actual_prefix':cutoff,'policies':observed,'elapsed_interpretation':'Quiet serial only for wall-time-ms; count-budget elapsed remains descriptive under recorded load. Last observed at/before prefix only; no extrapolation.'})
 result={'schema':'orbit.data-reuse.search-independent-audit.v21','status':'passed' if not plan_mismatches else 'failed-same-configuration-plan-mismatch','runs':runs,'same_candidate_complete_plan_comparisons':same_plan_checks,'comparison_method':'Complete canonical JSON objects compared byte-for-byte after sorting dictionary keys only; arrays, values and every field retained. Compression changes storage only. No field normalization.','same_candidate_plan_mismatches':plan_mismatches,'same_pool_comparisons':comparisons,'reference_organization_tile_frontiers':reference_frontiers,'cross_generator_reference_set_comparisons':cross_generator,'curves':curves,'equal_actual_prefix_comparisons':equal_prefix,'device_submissions':0,'interpretation':'Catalogue-space, strategy decisions, work budgets and per-organization tiles are separate. No score predicts measured benefit or certifies real ranking. Frozen/truncated exclusions retained verbatim.'}
 (a.output/'report.json').write_text(json.dumps(result,indent=2,allow_nan=False)+'\n')
 # Standard static plotting: each curve uses the actual C++ cumulative ledger,
 # including construction time. No interpolation across unavailable decisions.
 import matplotlib;matplotlib.use('Agg')
 import matplotlib.pyplot as plt
 for program in sorted({x['condition']['program'] for x in curves}):
  for generator in sorted({x['condition']['tile_generator'] for x in curves}):
   for budget_kind,budget,condition_label in [('raw-complete-cost-provider-calls',64,'Count budget; elapsed descriptive under possible concurrent load'),('wall-time-ms',15000,'Quiet CPU window; serial timed runs'),('wall-time-ms',5000,'Quiet CPU window; serial timed runs')]:
    selected=[x for x in curves if x['condition']['program']==program and x['condition']['tile_generator']==generator and x['condition']['budget_kind']==budget_kind and x['condition']['budget']==budget]
    if not selected:continue
    fig,axes=plt.subplots(1,2,figsize=(11,4))
    for curve in selected:
     points=[x for x in curve['trace'] if isinstance(x.get('best_score'),(float,int))]
     for axis,coordinate,title in zip(axes,['raw_cost_provider_calls','elapsed_ms'],['Policy raw complete cost-provider calls','Elapsed ms, including catalogue construction']):
      axis.step([x[coordinate] for x in points],[x['best_score'] for x in points],where='post',label=curve['condition']['strategy']);axis.set_xlabel(title);axis.set_ylabel('Best C++ estimate (ms)');axis.grid(alpha=.2)
    references=[x['best_estimate_ms'] for x in reference_frontiers if x['program']==program and x['tile_generator']==generator]
    if references:
     for axis in axes:axis.axhline(min(references),linestyle='--',color='black',alpha=.5,label='Bounded catalogue reference')
    axes[1].legend(fontsize=8);fig.suptitle(program+' / '+generator+' / '+budget_kind+' '+str(budget)+'\n'+condition_label,fontsize=10);fig.tight_layout();fig.savefig(a.output/(program+'-'+generator+'-'+budget_kind+'-'+str(budget)+'-best-so-far.svg'));plt.close(fig)
 print(json.dumps({'status':result['status'],'runs':len(runs),'same_plan_checks':same_plan_checks,'mismatches':len(plan_mismatches),'device_submissions':0}))
 if plan_mismatches:raise SystemExit(1)

if __name__=='__main__':main()
