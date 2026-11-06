#!/usr/bin/env python3
"""Reproduce numerical input → original C++ search → actual AIR/AIE → freeze.

Python selects mechanistic coverage from already checked C++ candidates. It does
not construct mappings, decide legality, price plans, or choose search parents.
"""
import argparse,json,subprocess,sys
from pathlib import Path

def main():
 p=argparse.ArgumentParser(description=__doc__)
 for key in ['core-tool','air-tool','config','output']:p.add_argument('--'+key,type=Path,required=True)
 a=p.parse_args();a.output=a.output.resolve();a.output.mkdir(parents=True,exist_ok=False);scripts=Path(__file__).resolve().parent;orbit=scripts.parents[1].parent/'orbit';allentries=[]
 def run(name,command):
  (a.output/(name+'.command.json')).write_text(json.dumps(list(map(str,command)),indent=2)+'\n')
  with (a.output/(name+'.log')).open('w') as log:r=subprocess.run(list(map(str,command)),stdout=log,stderr=subprocess.STDOUT)
  (a.output/(name+'.result.json')).write_text(json.dumps(dict(returncode=r.returncode,device_submissions=0))+'\n');assert r.returncode==0,name
 for kind,prefix,budget,beam in [('subgraphs-v19','',48,2),('partial-subgraph-v19','five_',32,1)]:
  fixture=a.output/('fixture-'+kind);search=a.output/('search-'+kind)
  run('prepare-'+kind,[sys.executable,scripts.parent/'test/TaskflowAIR/prepare_subgraph_execution_v19.py','--kind',kind,'--output',fixture])
  run('search-'+kind,['/usr/bin/python3',orbit/'test/TaskflowGeneric/subgraph_search_v19.py','--tool',a.core_tool,'--source',fixture/'source.mlir','--config',a.config,'--output',search,'--tile-m','4','--tile-n','136','--max-candidates',budget,'--beam-width',beam])
  es=json.loads((search/'checked-candidates.json').read_text())['entries'];base=next(e for e in es if e['round']==0)
  def first(pred):return min((e for e in es if pred(e)),key=lambda e:(e['estimated_ms'],e['source_sha256']))
  def outside_task_reader(e):
   if len(e['residency_scopes'])!=1:return False
   scope=e['residency_scopes'][0];graph=json.loads(Path(e['graph_file']).read_text());ids={d['storage']:d['id'] for d in graph['logical_data']}
   return any(access['read'] and access['storage']==ids[storage] for storage in scope['boundary_exports'] for i,task in enumerate(graph['source']['tasks']) if i not in scope['tasks'] for access in task['accesses'])
  chosen=[('baseline',base),('mixed_boundary',first(lambda e:e['tile_sizes']==base['tile_sizes'] and len(e['residency_scopes'])==1 and len(e['residency_scopes'][0]['tasks'])==2 and outside_task_reader(e)))]
  if not prefix:
   taskcount=len(json.loads(Path(base['mapping_result']).read_text())['best_plan']['tasks'])
   chosen += [('internal_only',first(lambda e:e['tile_sizes']==base['tile_sizes'] and len(e['residency_scopes'])==1 and len(e['residency_scopes'][0]['tasks'])==2 and not e['residency_scopes'][0]['boundary_exports'] and min(e['residency_scopes'][0]['tasks'])>0 and max(e['residency_scopes'][0]['tasks'])<taskcount-1)),('two_groups',first(lambda e:e['tile_sizes']==base['tile_sizes'] and len(e['residency_scopes'])==2)),('tiling_composed',first(lambda e:bool(e['residency_scopes']) and e['tile_sizes'][0]>base['tile_sizes'][0]))]
  if not prefix:
   output_ids={d['storage'] for d in json.loads(Path(base['graph_file']).read_text())['logical_data'] if d['role']=='output'}
   eligible=[e for e in es if e['tile_sizes']==base['tile_sizes'] and len(e['residency_scopes'])==1 and output_ids.intersection(e['residency_scopes'][0]['retained_storages'])]
   assert eligible,'final public search must propose retained output with internal consumption and final export'
   chosen += [('output_role_boundary',min(eligible,key=lambda e:(e['estimated_ms'],e['source_sha256'])))]
  allentries += [dict(e,name=prefix+name,plain_fixture=str(fixture)) for name,e in chosen]
 index=a.output/'representatives.json';index.write_text(json.dumps(dict(entries=allentries),indent=2)+'\n');compiled=a.output/'compiled'
 run('compile',[sys.executable,scripts/'compile_subgraph_representatives_v19.py','--index',index,'--plain-fixture',a.output/'fixture-subgraphs-v19','--tool',a.air_tool,'--output',compiled])
 cases=json.loads((compiled/'index.json').read_text())['cases'];args=[]
 for c in cases:args += ['--case',c['prepared'],c['compiled']]
 run('freeze',[sys.executable,scripts/'taskflow_subgraph_probe_v19.py','--freeze',a.output/'freeze/protocol.json','--seeds','11','23','47','--warmups','2','--repeats','9','--poll-us','20',*args])
 (a.output/'result.json').write_text(json.dumps(dict(status='passed',cases=len(cases),device_submissions=0,scope='Actual C++ original two-round score-driven search, source-bound compilation, generic final-AIE checks and prospective protocol; no device observations'),indent=2)+'\n')
 print(json.dumps(dict(status='passed',output=str(a.output),cases=len(cases),device_submissions=0)))
if __name__=='__main__':main()
