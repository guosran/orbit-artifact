#!/usr/bin/env python3
"""Run the frozen C++ v21 experiment matrix; Python makes no candidate decisions."""
import argparse, copy, hashlib, json, shutil, subprocess, time, os
from pathlib import Path


def read(path):return json.loads(Path(path).read_text())
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def save(path,value):Path(path).write_text(json.dumps(value,indent=2,allow_nan=False)+'\n')


def main():
 p=argparse.ArgumentParser(description=__doc__)
 for key in ['tool','config','protocol','output']:p.add_argument('--'+key,type=Path,required=True)
 p.add_argument('--kind',choices=['all','evaluation','wall','catalogue','historical'],default='all')
 p.add_argument('--program',action='append');p.add_argument('--strategy',action='append');p.add_argument('--budget',type=int,action='append');p.add_argument('--tile-generator',action='append')
 p.add_argument('--prepare-only',action='store_true');p.add_argument('--continue-existing',action='store_true')
 p.add_argument('--wall-window-confirmed',action='store_true',help='Coordinator has announced no concurrent builds/regressions/timed jobs for this serial wall run.')
 p.add_argument('--execution-condition',default='Nonexclusive CPU: evaluation-counted runs may overlap builds/regressions; elapsed curves are descriptive.')
 a=p.parse_args();a.output.mkdir(parents=True,exist_ok=a.continue_existing)
 protocol=read(a.protocol);bindings=read(a.protocol.parent/'source-and-budget-bindings.json');base=read(a.config)
 assert base['generic_air']['cost_model']==protocol['model'],'cost model/provenance differs from frozen protocol'
 assert base['generic_air'].get('capacity_bytes')==protocol['capacity_bytes'],'target payload budget differs from frozen protocol'
 assert bindings['protocol_sha256']==sha(a.protocol)
 snapshot=a.output/'taskflow-opt-used';identity={'original':str(a.tool.resolve()),'sha256':sha(a.tool),'protocol':str(a.protocol.resolve()),'protocol_sha256':sha(a.protocol),'bindings_sha256':sha(a.protocol.parent/'source-and-budget-bindings.json'),'base_configuration_sha256':sha(a.config)}
 if snapshot.exists():assert sha(snapshot)==identity['sha256'] and read(a.output/'identity.json')==identity
 else:shutil.copy2(a.tool,snapshot);save(a.output/'identity.json',identity)
 programs={x['name']:x for x in protocol['programs']};runs=[]
 if a.kind in ['all','evaluation','wall']:
  runs += [dict(x) for x in protocol['runs'] if a.kind=='all' or (a.kind=='wall')==(x['budget_kind']=='wall-time-ms')]
 if a.kind in ['all','historical']:runs += [dict(x,tile_generator='historical-halving',historical=True,budget_kind='historical-score-queries-unmatched') for x in protocol['historical_runs']]
 if a.kind in ['all','catalogue']:runs += [dict(x,strategy='catalogue',budget_kind='offline-reference',budget=8192) for x in protocol['shared_catalogue_reference_runs']]
 runs=[x for x in runs if (not a.program or x['program'] in a.program) and (not a.strategy or x['strategy'] in a.strategy) and (not a.budget or x['budget'] in a.budget) and (not a.tile_generator or x['tile_generator'] in a.tile_generator)]
 assert runs,'empty selected matrix'
 if not a.prepare_only and any(x['budget_kind']=='wall-time-ms' for x in runs):assert a.wall_window_confirmed,'timed wall runs require the coordinator-confirmed quiet CPU window'
 prepared=[]
 for run in runs:
  name='-'.join([run['program'],run['tile_generator'],run['strategy'],run['budget_kind'],str(run['budget'])]);out=a.output/name
  fixture=programs[run['program']];source=Path(fixture['source']);assert sha(source)==fixture['source_sha256']
  config=copy.deepcopy(base);auto=config.setdefault('native_auto_candidates',{})
  auto.update(mode='joint',algorithm=run['strategy'],exploration_slots=0)
  if not run.get('historical'):
   auto.update(per_round_evaluation_quota=run['strategy']!='catalogue',tile_generator=run['tile_generator'],stage_rounds=protocol['search']['stage_rounds'],max_joint_proposals=64,max_joint_tiles=protocol['search']['max_tiles'],max_tile_proposals=protocol['search']['max_tiles'],max_scope_sets=protocol['search']['max_scope_sets'],max_catalogue_configurations=protocol['search']['max_catalogue_configurations'],max_generation_attempts=protocol['search']['max_generation_attempts'],max_generator_planner_calls=protocol['search']['max_generator_planner_calls'],max_internal_planner_calls=protocol['search']['max_internal_planner_calls'],max_compute_instances=protocol['search']['max_compute_instances'])
  else:
   auto.update(max_joint_proposals=32,max_joint_tiles=4,max_tile_proposals=4)
   for key in ['tile_generator','stage_rounds','max_scope_sets','max_catalogue_configurations','max_generation_attempts','max_generator_planner_calls','tile_constraints','max_compute_instances']:auto.pop(key,None)
   auto['max_internal_planner_calls']=protocol['search']['max_internal_planner_calls']
  auto.pop('max_wall_time_ms',None)
  if run['budget_kind']=='wall-time-ms':auto.update(max_wall_time_ms=run['budget'],max_cost_provider_calls=protocol['search']['max_cost_provider_calls_wall'])
  elif run.get('historical'):auto.pop('max_cost_provider_calls',None)
  else:auto['max_cost_provider_calls']=run['budget']
  tile=bindings['initial_source_tiles'][run['program']]
  cmd=[str(snapshot.resolve()),str(source.resolve()),'--search','--backend=air','--max-rounds='+str(protocol['search']['rounds']),'--max-candidates='+str(run['budget'] if run.get('historical') else protocol['search']['max_candidates']),'--beam-width='+str(protocol['search']['beam_width']),'--tile-m='+str(tile[0]),'--tile-n='+str(tile[1]),'--tile-k='+str(tile[2]),'--target-config='+str((out/'config.json').resolve()),'--search-output='+str((out/'search').resolve())]
  if out.exists():
   assert a.continue_existing and read(out/'config.json')==config and read(out/'command.json')==cmd
  else:out.mkdir();save(out/'config.json',config);save(out/'command.json',cmd);save(out/'condition.json',run)
  prepared.append((run,out,cmd))
 save(a.output/'matrix-selection.json',{'runs':[x[0] for x in prepared],'count':len(prepared),'prepare_only':a.prepare_only,'scope':'All scope/tile/materialization/legal/cost/parent choices are made by production C++.'})
 if a.prepare_only:print(json.dumps({'status':'prepared','runs':len(prepared),'device_submissions':0}));return
 index=[]
 for run,out,cmd in prepared:
  receipt=out/'run.json'
  if receipt.exists():
   old=read(receipt);assert old['returncode']==0,'failed prior run preserved; choose a fresh output root';index.append(old);continue
  load_before=list(os.getloadavg());started=time.monotonic();r=subprocess.run(cmd,text=True,capture_output=True);elapsed=time.monotonic()-started;load_after=list(os.getloadavg())
  (out/'stdout.txt').write_text(r.stdout);(out/'stderr.txt').write_text(r.stderr)
  record={'condition':run,'command':cmd,'returncode':r.returncode,'external_wall_seconds':elapsed,'load_average_before':load_before,'load_average_after':load_after,'execution_condition':('Coordinator-confirmed quiet CPU window; serial timed run.' if run['budget_kind']=='wall-time-ms' else a.execution_condition),'search_directory':str((out/'search').resolve())};save(receipt,record);index.append(record)
  print(json.dumps({'condition':run,'returncode':r.returncode,'elapsed_seconds':elapsed}),flush=True)
  if r.returncode:raise RuntimeError('C++ search failed; all original stdout/stderr/config preserved at '+str(out))
 save(a.output/'index.json',{'status':'passed','runs':index,'tool_sha256':identity['sha256'],'protocol_sha256':identity['protocol_sha256'],'device_submissions':0})

if __name__=='__main__':main()
