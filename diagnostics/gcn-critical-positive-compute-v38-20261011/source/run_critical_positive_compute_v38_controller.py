#!/usr/bin/env python3
"""Isolated critical-positive compute direction tier; Source37 is unchanged when off."""
import argparse,json,sys,subprocess,shutil
from pathlib import Path
from types import SimpleNamespace
ROOT=Path(__file__).resolve().parents[1];OLD=ROOT.parent/'orbit-exact-study';ART=ROOT.parent/'orbit-artifact'
sys.path.insert(0,str(OLD/'oracle'));import enumerate as E
sys.path.insert(0,str(OLD/'validation'));import replay as R
sys.path.insert(0,str(OLD/'search_diagnosis'));from run_restricted import source_contract,quote_option,jsonl,shortlist_path
sys.path.insert(0,str(ART/'scripts'));from neighborhood_replay import normalize_selection

def graph_signature(actions):
 return json.dumps([{k:v for k,v in x.items() if k!='label'} for x in actions],sort_keys=True,separators=(',',':'))
def main():
 p=argparse.ArgumentParser();p.add_argument('--case',type=Path,required=True);p.add_argument('--domain',type=Path);p.add_argument('--oracle',type=Path);p.add_argument('--optimizer',type=Path,required=True);p.add_argument('--source',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--flow',choices=['joint','sequential','legacy','alternating'],default='joint');p.add_argument('--percent',type=int,choices=[50,75],default=50);p.add_argument('--budget',type=int,required=True);p.add_argument('--fair-pending',action='store_true');p.add_argument('--rounds',type=int,default=20);p.add_argument('--workers',type=int,default=1);p.add_argument('--timeout',type=int,default=1800);p.add_argument('--native-shortlist',action='store_true');p.add_argument('--mapping-cache',type=Path);p.add_argument('--smoke-unmatched-oracle',action='store_true',help='Diagnostic only: permit old binary oracle, do not claim matching exact costs')
 p.add_argument('--beam',type=int,default=16);p.add_argument('--diversity',type=int,default=4);p.add_argument('--quota-scale',type=int,choices=[1,2],default=1);p.add_argument('--feature-policy',choices=['all','shape-only','fusion-off','fission-off','structural-off','cumulative-fixed','cumulative-shape','cumulative-replica','cumulative-tiling','cumulative-fusion'],default='all');p.add_argument('--shape-enumeration-order',choices=['ascending','descending'],default='ascending');p.add_argument('--bootstrap-supported-shapes',action=argparse.BooleanOptionalAction,default=None)
 p.add_argument('--refresh-frontier',action='store_true');p.add_argument('--diagnostic-path',type=Path);p.add_argument('--diagnostic-continue',action='store_true');p.add_argument('--seed-manifest',type=Path);p.add_argument('--cache-from',type=Path)
 p.add_argument('--parent-progress',action=argparse.BooleanOptionalAction,default=False)
 p.add_argument('--directional-search',action=argparse.BooleanOptionalAction,default=False)
 p.add_argument('--retained-communication-window',action=argparse.BooleanOptionalAction,default=False)
 p.add_argument('--critical-positive-compute',action=argparse.BooleanOptionalAction,default=False)
 p.add_argument('--checkpoint-actions',type=int,default=128)
 a=p.parse_args();out=a.output.resolve();out.mkdir(parents=True,exist_ok=True);case=json.loads(a.case.read_text());fission_cap=case.get('max_fission_actions_per_task',64);oracle=a.oracle.resolve() if a.oracle else None;optimizer=a.optimizer.resolve();source=a.source.resolve()
 if a.checkpoint_actions<=0:raise ValueError('invalid checkpoint interval')
 if a.retained_communication_window and not a.directional_search:raise ValueError('retained communication window requires directional search')
 if a.critical_positive_compute and not (a.directional_search and a.retained_communication_window):raise ValueError('critical positive compute requires retained communication directional search')
 directional_policy=('schedule-structure-critical-positive-compute-v38' if a.critical_positive_compute else 'schedule-structure-retained-communication-shape-window-v37' if a.retained_communication_window else 'schedule-structure-window-axis-tie-v35')
 if a.domain and not oracle:raise ValueError('finite-domain comparison requires matching oracle')
 if a.diversity<=0 or a.diversity>a.beam:raise ValueError('invalid beam/diversity')
 bootstrap=(not a.domain) if a.bootstrap_supported_shapes is None else a.bootstrap_supported_shapes
 binding=json.loads((oracle/'binding.json').read_text()) if oracle else {}
 identity=json.loads((oracle/'graphs/identity/graph.json').read_text()) if oracle else {}
 if oracle and not a.smoke_unmatched_oracle and binding['optimizer_sha256']!=E.file_hash(optimizer):raise ValueError('oracle and controller optimizer bytes differ')
 if a.domain and identity.get('status')!='ready':raise ValueError('identity unavailable')
 parent_cost=identity.get('cost') if identity.get('status')=='ready' else None
 model=ART/'reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json';arch=ART/'config/architectures/amoeba_4x4_cgra_2x2_context6.yaml';network=ART/'config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml'
 contract=source_contract(source,optimizer,model);E.write_json(out/'source-contract.json',contract)
 inputs=[a.case,optimizer,Path(case['canonical']),Path(__file__)]
 if parent_cost:inputs.append(Path(parent_cost))
 if 'prepared_source' in case:inputs.append(Path(case['prepared_source']))
 if a.domain:inputs.append(a.domain)
 bound={'files':{str(f.resolve()):E.file_hash(f) for f in inputs},'source_commit':contract['compiler_source_commit'],'flow':a.flow,'graph_budget_percent':a.percent,'budget':a.budget,'fair_pending':a.fair_pending,'rounds':a.rounds,'workers':a.workers,'same_version_oracle':bool(oracle and not a.smoke_unmatched_oracle),'beam':a.beam,'diversity':a.diversity,'round_quota_scale':a.quota_scale,'feature_policy':a.feature_policy,'shape_enumeration_order':a.shape_enumeration_order,'bootstrap_supported_shapes':bootstrap,'refresh_frontier':a.refresh_frontier,'diagnostic_path':str(a.diagnostic_path) if a.diagnostic_path else None,'diagnostic_continue':a.diagnostic_continue,'seed_manifest':str(a.seed_manifest) if a.seed_manifest else None}
 bound['checkpoint_actions']=a.checkpoint_actions
 bound['parent_progress']=a.parent_progress
 if a.directional_search:
  bound.update(directional_search=True,directional_policy=directional_policy,paper_admission=False)
 if a.retained_communication_window:bound['retained_communication_window']=True
 if a.critical_positive_compute:bound['critical_positive_compute']=True
 if (a.parent_progress or a.directional_search) and (a.flow!='joint' or not a.refresh_frontier or a.workers!=1):raise ValueError('parent progress requires Joint refresh and one scoring worker')
 if a.domain or a.oracle or a.seed_manifest or a.diagnostic_path or a.diagnostic_continue:raise ValueError('parent progress comparison cannot use oracle targets or seeds')
 if a.parent_progress and not a.fair_pending:raise ValueError('parent progress requires fair pending retention')
 if a.directional_search and not (a.parent_progress and a.fair_pending):raise ValueError('directional search requires semantic parent progress and fair pending')
 R.exact_binding(out/'binding.json',bound)
 if (out/'result.json').exists():
  prior=json.loads((out/'result.json').read_text())
  if not prior.get('artifact_hashes') or any(not Path(f).is_file() or E.file_hash(Path(f))!=h for f,h in prior['artifact_hashes'].items()):raise ValueError('completed receipt lacks intact output hashes')
  print((out/'result.json').read_text());return
 if (out/'search').exists():raise ValueError('prior unfinished output preserved: choose fresh namespace')
 protocol={'schema':'orbit-repair-production-controller-v1','source_git_repository':E.REPOSITORY,'source_commit':E.MODEL_COMMIT,'search':{'max_rounds':a.rounds,'max_unique_complete_candidates_scored':a.budget,'beam_width':a.beam,'diversity_min_slots':a.diversity,'round_quota_scale':a.quota_scale,'feature_policy':a.feature_policy,'shape_enumeration_order':a.shape_enumeration_order,'max_partition_factor':4,'max_fission_actions_per_task':fission_cap},'decision_flow':a.flow,'graph_budget_percent':a.percent,'fair_pending_retention':a.fair_pending,'objective':'predicted-production-makespan','original_adaptive_round_quota':True}
 protocol['stage_scheme']='full-joint-fission' if 'prepared_source' in case else case.get('stage','full-joint');protocol['inter_task_network_spec']=str(network)
 if bootstrap:protocol['search']['supported_shape_bootstrap_policy']='minimum-area-supported-model-shape-v1'
 protocol.update(refresh_frontier=a.refresh_frontier,oracle_assisted_diagnostic=bool(a.diagnostic_path or a.seed_manifest))
 protocol['checkpoint_actions']=a.checkpoint_actions
 protocol['search']['parent_progress']=a.parent_progress
 protocol['search']['paper_admission']=False
 if a.directional_search:
  protocol['paper_admission']=False
  protocol['search'].update(directional_search=True,directional_policy=directional_policy)
 if a.retained_communication_window:protocol['search']['retained_communication_window']=True
 if a.critical_positive_compute:protocol['search']['critical_positive_compute']=True
 if a.parent_progress:protocol['search']['parent_progress_policy']='semantic-parent-family-ordered-suffix-v1'
 E.write_json(out/'protocol.json',protocol)
 opts={'output-dir':out/'search','function':case['function'],'stage':case.get('stage','full-joint'),'decision-flow':a.flow,'graph-budget-percent':a.percent,'architecture-path':arch,'source-repository':E.REPOSITORY,'source-commit':E.MODEL_COMMIT,'model':model,'model-namespace':'orbit-per-cgra-2x2-direct-4member-v1','cache':out/'ml-cache.json','protocol':out/'protocol.json','source-contract-file':out/'source-contract.json','max-rounds':a.rounds,'max-candidates':a.budget,'beam-width':a.beam,'diversity-slots':a.diversity,'round-quota-scale':a.quota_scale,'feature-policy':a.feature_policy,'shape-enumeration-order':a.shape_enumeration_order,'bootstrap-supported-shapes':str(bootstrap).lower(),'scoring-workers':a.workers,'max-partition-factor':4,'require-source-iteration-domain':'true','fair-pending-retention':str(a.fair_pending).lower()}
 if a.refresh_frontier:opts['refresh-frontier']='true'
 opts['parent-progress']=str(a.parent_progress).lower()
 if a.directional_search:opts['directional-search']='true'
 if a.retained_communication_window:opts['retained-communication-window']='true'
 if a.critical_positive_compute:opts['critical-positive-compute']='true'
 opts['checkpoint-actions']=a.checkpoint_actions
 if a.diagnostic_path:opts.update({'diagnostic-path':a.diagnostic_path.resolve(),'diagnostic-continue':str(a.diagnostic_continue).lower()})
 if a.seed_manifest:opts['seed-manifest']=a.seed_manifest.resolve()
 if a.cache_from:shutil.copy2(a.cache_from,out/'ml-cache.json')
 if parent_cost:opts['parent-cost-file']=parent_cost
 if a.domain:opts['finite-domain-file']=a.domain.resolve()
 if 'prepared_source' in case:opts.update({'prepared-source-file':case['prepared_source'],'max-fission-actions-per-task':fission_cap,'stage':'full-joint-fission'})
 cmd=[str(optimizer),case['canonical'],'--verify-each',f'--architecture-spec={arch}',f'--joint-inter-task-network-spec={network}','--search-joint-neighborhood='+' '.join(f'{k}={quote_option(v)}' for k,v in opts.items()),'-o','/dev/null']
 E.run(cmd,out/'run',timeout=a.timeout)
 summary=json.loads((out/'search/search-summary.json').read_text());archive=jsonl(out/'search/archive.jsonl');trace=jsonl(out/'search/budget-trace.jsonl')
 assert len(trace)==summary['production_scheduler_calls']<=a.budget
 assert [r['cumulative_evaluations'] for r in trace]==list(range(1,len(trace)+1))
 oracle_rows=json.loads((oracle/'results.json').read_text()) if oracle and (oracle/'results.json').exists() else [];lookup={(r['transformation'],r['shapes']):r for r in oracle_rows};variants={graph_signature(v['actions']):v['id'] for v in case.get('variants',[])}
 normalized=[];mismatches=[]
 for r in archive:
  if not r.get('valid'):continue
  history=r['action_history']
  if not history.get('known'):history=next((x['action_history'] for x in trace if x['candidate_id']==r['candidate_id']),history)
  actions=list(history.get('fissionActions',[]))+[x for x in history.get('actions',[]) if x['family'] not in ('shape','replica')]
  variant=variants.get(graph_signature(actions));shapes={x['task']:[x['rows'],x['cols']] for x in r['shapes']};expected=lookup.get((variant,E.canonical(shapes)));cost=r.get('predicted_whole_program_cycles',r.get('score_cycles'))
  normalized.append({'candidate_id':r['candidate_id'],'transformation':variant,'shapes':shapes,'cycles':cost,'oracle_key':expected['key'] if expected else None})
  if a.domain and (expected is None or expected['predicted_cycles']!=cost):mismatches.append(normalized[-1])
 if mismatches and not a.smoke_unmatched_oracle:raise ValueError(f'{len(mismatches)} archive exact-domain/objective mismatches')
 selections=[normalize_selection(r) for r in jsonl(shortlist_path(out/'search')) if r.get('record_type')=='selection'];native=[]
 if a.native_shortlist:
  cache=(a.mapping_cache or out/'mapping-cache').resolve();cache.mkdir(parents=True,exist_ok=True);R.exact_binding(cache/'controller-compiler-binding.json',{'optimizer_sha256':E.file_hash(optimizer),'architecture_sha256':E.file_hash(arch)});module=R.load_replay(180)
  if 'prepared_source' in case:
   prepared=Path(case['prepared_source']).resolve();source_binding={'schema':'orbit-neighborhood-source-binding-v1','canonical_program':str(Path(case['canonical']).resolve()),'optimizer':str(optimizer),'architecture':str(arch.resolve()),'protocol_schema':protocol['schema'],'source_commit':protocol['source_commit'],'source_contract_file':str((out/'source-contract.json').resolve()),'stage_initialization':'independent','prepared_source_file':str(prepared),'prepared_source_exact_text':prepared.read_text(),'prepared_source_size_bytes':prepared.stat().st_size,'max_fission_actions_per_task':fission_cap,'inter_task_network':str(network),'inter_task_network_text':network.read_text()}
   E.write_json(out/'source-binding.json',source_binding)
  for selection in selections:
   args=SimpleNamespace(output_dir=out/'native',manifest=Path(selection['candidate_manifest']),graph_manifests=None,optimizer=optimizer,architecture=arch,inter_task_network=network,mapping_cache=cache,reuse_mapped_root=None,audit_mapper_calls=False,sram_config=ART/'config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json',stage=opts['stage'])
   if 'prepared_source' in case:
    args.canonical=Path(case['canonical']).resolve();args.prepared_source_file=prepared;args.source_binding_file=out/'source-binding.json';args.max_fission_actions_per_task=fission_cap;args.max_partition_factor=4;args.function=case['function'];args.protocol=out/'protocol.json';args.source_contract_file=out/'source-contract.json'
   receipt=module.replay(selection,args)
   if receipt.get('status')=='native_replayed' and (receipt.get('independent_trace')!='pass' or receipt.get('mapper_equality')!='pass'):raise ValueError('native replay lacks independent trace/equality validation')
   native.append(receipt)
 # Report actual objective debits separately from authenticated semantic states.
 semantic=[]
 for row in trace:
  history=row['action_history'];actions=list(history.get('fissionActions',[]))+[x for x in history.get('actions',[]) if x['family']!='shape']
  semantic.append(E.canonical({'canonical':history.get('canonicalFactKey'),'initial':history.get('initialShapes'),'actions':actions,'shapes':sorted(row['shapes'],key=lambda x:x['task'])}))
 files=[out/'search/search-summary.json',out/'search/archive.jsonl',out/'search/budget-trace.jsonl',shortlist_path(out/'search'),out/'search/diagnostics/family-funnel.jsonl',out/'protocol.json',out/'source-contract.json',out/'run.command.json']
 files += [Path(x['mapper_replay_path']) for x in selections]
 files += [out/'search/checkpoint.json',out/'search/checkpoint.json.binding.json']
 if a.parent_progress:files.append(out/'search/parent-progress.jsonl')
 if a.directional_search:files.append(out/'search/directions.jsonl')
 result={'status':'completed','binding':bound,'summary':summary,'archive_normalized':normalized,'oracle_mismatches':mismatches,'native_shortlist':native,'objective_evaluations':len(trace),'distinct_authenticated_configurations':len(set(semantic)),'repeated_authenticated_configurations':len(semantic)-len(set(semantic)),'objective_trace':str(out/'search/budget-trace.jsonl'),'family_funnel':str(out/'search/diagnostics/family-funnel.jsonl'),'artifact_hashes':{str(f.resolve()):E.file_hash(f) for f in files}}
 E.write_json(out/'result.json.pending',result);(out/'result.json.pending').replace(out/'result.json');print(a.flow,a.percent,a.budget,len(trace),len(normalized),len(mismatches),flush=True)
if __name__=='__main__':main()
