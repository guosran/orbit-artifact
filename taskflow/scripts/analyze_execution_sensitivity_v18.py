#!/usr/bin/env python3
"""Re-evaluate an original C++ candidate archive under declared parameter changes.

No planner or score formula is implemented in Python. Every graph and time is
produced by taskflow-opt using its public mechanism model and resource scheduler.
"""
import argparse,hashlib,json,subprocess,csv
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor

def read(p):return json.loads(Path(p).read_text())
def write(p,v):p.write_text(json.dumps(v,indent=2,allow_nan=False)+'\n')
def identity(p):return {'path':str(Path(p).resolve()),'sha256':hashlib.sha256(Path(p).read_bytes()).hexdigest()}
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--search-root',type=Path,required=True);p.add_argument('--config',type=Path,required=True);p.add_argument('--tool',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--jobs',type=int,default=4);a=p.parse_args();assert 1<=a.jobs<=8;a.output.mkdir(parents=True,exist_ok=False);before=identity(a.tool);archive=read(a.search_root/'search.json')['archive'];rows=[]
 for row in archive:
  source=a.search_root/'candidates'/row['candidate_id']/'taskflow.mlir';graph=a.search_root/'candidates'/row['candidate_id']/'program-graph.json'
  if row['status'] in ['passed','uncalibrated'] and source.exists() and graph.exists():rows.append((row,source,read(graph)))
 assert rows;summary=[];csvrows=[]
 variations=[('reference',None,1.0)]+[(key.replace('.','-')+'-x'+str(factor),key,factor) for key in ['configuration.startup','communication.bandwidth','compute.memory_access'] for factor in [.25,4.0]]
 for name,key,factor in variations:
  out=a.output/name;out.mkdir();cfg=read(a.config)
  if key:cfg['generic_air']['cost_model']['parameters'][key]['value']*=factor
  write(out/'config.json',cfg);scores=[];unknown=[]
  def evaluate(entry):
   row,source,expected=entry
   dest=out/row['candidate_id'];dest.mkdir();cmd=[str(a.tool.resolve()),str(source.resolve()),'--generic-map','--target-config='+str((out/'config.json').resolve()),'--mapping-output='+str((dest/'plan.json').resolve()),'--program-timing-output='+str((dest/'timing.json').resolve())]
   with (dest/'output.log').open('w') as log:status=subprocess.run(cmd,stdout=log,stderr=subprocess.STDOUT).returncode
   write(dest/'command.json',cmd);assert status==0,(name,row['candidate_id']);plan=read(dest/'plan.json');assert plan['program_graph']==expected,'parameter changes must not change the searched graph';value=plan['estimated_ms'];cost=plan.get('direct_air_cost',{})
   return {'candidate_id':row['candidate_id'],'action_chain':row['action_chain'],'score_ms':value,'model_status':cost.get('status'),'graph_id':plan['program_graph_id'],'plan':identity(dest/'plan.json'),'timing':identity(dest/'timing.json')}
  with ThreadPoolExecutor(max_workers=a.jobs) as pool:
   evaluated=list(pool.map(evaluate,rows))
  for entry in evaluated:
   (scores if entry['score_ms'] is not None else unknown).append(entry);csvrows.append({'variation':name,'parameter':key or 'none','factor':factor,'candidate_id':entry['candidate_id'],'actions':' -> '.join(entry['action_chain']),'score_ms':entry['score_ms'],'status':entry['model_status']})
  scores.sort(key=lambda v:(v['score_ms'],v['candidate_id']));best=scores[0]['score_ms'] if scores else None;winners=[v['candidate_id'] for v in scores if abs(v['score_ms']-best)<=1e-12]
  record={'variation':name,'parameter':key,'factor':factor,'ranking':scores,'unknown':unknown,'best_score_ms':best,'tied_best_candidates':winners};write(out/'ranking.json',record);summary.append(record);print(name,'best',best,'ties',len(winners),flush=True)
 assert identity(a.tool)==before,'tool changed during sensitivity evaluation'
 baseline=set(summary[0]['tied_best_candidates']);report={'schema':'orbit.execution-sensitivity.v18','status':'passed','tool':before,'archive':identity(a.search_root/'search.json'),'base_config':identity(a.config),'legal_candidates':len(rows),'variations':summary,'reference_winner_survives_all':all(bool(baseline.intersection(v['tied_best_candidates'])) for v in summary),'scope':'C++ re-evaluation of the same candidate execution graphs, assumed parameter sensitivity, no hardware measurement and no fitted labels.'};write(a.output/'summary.json',report)
 with (a.output/'scores.csv').open('w') as f:w=csv.DictWriter(f,fieldnames=list(csvrows[0]));w.writeheader();w.writerows(csvrows)
if __name__=='__main__':main()
