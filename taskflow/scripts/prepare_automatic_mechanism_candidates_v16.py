#!/usr/bin/env python3
"""Package existing native search candidates without modifying their MLIR bodies."""
import argparse,hashlib,json,pathlib,shutil,subprocess

def main():
 p=argparse.ArgumentParser();p.add_argument('--search',type=pathlib.Path,required=True);p.add_argument('--fixture',type=pathlib.Path,required=True);p.add_argument('--output',type=pathlib.Path,required=True);p.add_argument('--tool',required=True);a=p.parse_args()
 a.output.mkdir(parents=True,exist_ok=False)
 read=lambda p:json.loads(pathlib.Path(p).read_text())
 write=lambda p,v:pathlib.Path(p).write_text(json.dumps(v,indent=2)+'\n')
 sha=lambda p:hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
 archive=read(a.search/'search.json')['archive'];records=[]
 actions=['auto_tiles_4_8_16','auto_tiles_4_32_16','mapping_retain-across-users_storage_1_reuse_0_panel_1']
 for i,action in enumerate(actions):
  row=next(r for r in archive if r['action_chain']==[action] and r['status']=='uncalibrated')
  cid=row['candidate_id'];origin=a.search/'candidates'/cid;d=a.output/f'auto{i+1}';inp=d/'input';inp.mkdir(parents=True)
  source=origin/'taskflow.mlir';assert sha(source)==cid
  shutil.copyfile(source,inp/'source.mlir')
  for npz in a.fixture.glob('*.npz'):shutil.copyfile(npz,inp/npz.name)
  fixture=read(a.fixture/'fixture.json');fixture['source_sha256']=sha(inp/'source.mlir');fixture['native_search_candidate']=cid;fixture['action_chain']=row['action_chain'];write(inp/'fixture.json',fixture)
  config={'generic_air':{'cost_model':{'schema':'orbit.direct-air.cost.v1','kind':'features-only'}}};write(inp/'config.json',config)
  cmd=['bash',str(pathlib.Path(__file__).with_name('run_taskflow_direct_air_v6_case.sh')),'--compile-only','--runtime-transfer-audit','--distribute-initialization','--tool',a.tool,'--input',str(inp),'--output',str(d/'compiled'),'--target-config',str(inp/'config.json')]
  write(d/'compile.command.json',cmd)
  with (d/'compile.log').open('w') as log:r=subprocess.run(cmd,stdout=log,stderr=subprocess.STDOUT)
  write(d/'compile.result.json',{'returncode':r.returncode,'device_submissions':0});assert r.returncode==0
  native=read(d/'compiled/plan.json');expected=read(origin/'program-graph.json');assert native['program_graph']==expected,'actual compiler graph differs from searched graph'
  write(d/'graph-identity-bridge.json',{'status':'passed','candidate_id':cid,'action_chain':row['action_chain'],'graph_id':expected['id'],'compiled_graph_id':native['program_graph_id'],'searched_graph':{'path':str(origin/'program-graph.json'),'sha256':sha(origin/'program-graph.json')},'compiled_plan':{'path':str(d/'compiled/plan.json'),'sha256':sha(d/'compiled/plan.json')},'source_unchanged':sha(source)==sha(d/'compiled/source.mlir')})
  records.append({'id':f'auto{i+1}','split':'holdout','prepared':str(inp),'compiled':str(d/'compiled'),'candidate_id':cid,'action_chain':row['action_chain'],'graph_id':expected['id']})
 write(a.output/'index.json',{'schema':'orbit.native-automatic.validation.v16','cases':records,'device_submissions':0,'selection':'fixed two tilings and B retention from original C++ one-round automatic generator; no performance labels inspected'})
 print(json.dumps(records,indent=2))
if __name__=='__main__':main()
