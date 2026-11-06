#!/usr/bin/env python3
"""Run the original C++ generator and select preregistered structural actions.

No source rewrite, mapping plan, lowering or performance data is generated here.
"""
import argparse,json,pathlib,subprocess,hashlib,datetime

def read(p):return json.loads(pathlib.Path(p).read_text())
def sha(p):return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
def ident(p):return {'path':str(pathlib.Path(p).resolve()),'sha256':sha(p)}
def write(p,x):pathlib.Path(p).write_text(json.dumps(x,indent=2)+'\n')
def main():
 p=argparse.ArgumentParser();p.add_argument('--fixtures',type=pathlib.Path,required=True);p.add_argument('--tool',type=pathlib.Path,required=True);p.add_argument('--output',type=pathlib.Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False);records=[]
 cfg={'model_version':'v17-unpriced-candidate-validation','target_version':'v17-native-data-organization','generic_air':{'capacity_bytes':24576,'cost_model':{'schema':'orbit.direct-air.cost.v1','kind':'features-only'}},'native_auto_candidates':{'mode':'joint','max_tile_proposals':2,'exploration_slots':4},'search_preferences':{'m_alignment':1,'n_alignment':8,'k_alignment':1}}
 write(a.output/'config.json',cfg)
 for c in read(a.fixtures)['cases']:
  d=a.output/c['id'];d.mkdir();tile=c['n'] if c['kind']=='broadcast' else 64
  command=[str(a.tool),str(pathlib.Path(c['prepared'])/'source.mlir'),'--search','--backend=air','--residency=tiled-phase-local','--tile-m=1','--tile-n='+str(tile),'--tile-k=1','--target-config='+str(a.output/'config.json'),'--search-output='+str(d/'search'),'--max-rounds=1','--max-candidates=16','--beam-width=4'];write(d/'command.json',command)
  with (d/'search.log').open('w') as log:r=subprocess.run(command,stdout=log,stderr=subprocess.STDOUT)
  write(d/'result.json',{'returncode':r.returncode,'device_submissions':0});assert r.returncode==0,c['id']
  archive=read(d/'search/search.json')['archive'];action='mapping_retain-across-users_storage_0_reuse_0_panel_1' if c['kind']=='broadcast' else 'mapping_whole_program'
  left=next(x for x in archive if x['action_chain']==[] and x['status']=='uncalibrated');right=next(x for x in archive if x['action_chain']==[action] and x['status']=='uncalibrated')
  sides={}
  for side,row in [('baseline',left),('candidate',right)]:
   origin=d/'search/candidates'/row['candidate_id'];source=origin/'taskflow.mlir';assert sha(source)==row['candidate_id'];graph=read(origin/'program-graph.json')
   sides[side]={'candidate_id':row['candidate_id'],'parent':row['parent'],'action_chain':row['action_chain'],'source':ident(source),'graph':ident(origin/'program-graph.json'),'graph_id':graph['id'],'mapping':ident(origin/'mapping-result.json')}
  records.append(dict(c,pair_id=c['id'],change_class='readonly-copy-retention' if c['kind']=='broadcast' else 'intermediate-region-residency',**sides))
  print(c['id'],action,flush=True)
 write(a.output/'index.json',{'schema':'orbit.data-organization.generated-pairs.v17','created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'tool':ident(a.tool),'config':ident(a.output/'config.json'),'cases':records,'device_submissions':0,'selection':'fixed baseline and direct structural action from original C++ archive; unpriced, no labels inspected'})
if __name__=='__main__':main()
