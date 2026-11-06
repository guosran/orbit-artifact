#!/usr/bin/env python3
"""Invoke native graph/feature/timing export and bind it to compiled plans."""
import argparse,json,pathlib,subprocess,hashlib

def sha(p):return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
def read(p):return json.loads(pathlib.Path(p).read_text())
def write(p,v):pathlib.Path(p).write_text(json.dumps(v,indent=2)+'\n')
def main():
 p=argparse.ArgumentParser();p.add_argument('--suite',type=pathlib.Path,required=True);p.add_argument('--automatic',type=pathlib.Path,required=True);p.add_argument('--tool',required=True);p.add_argument('--features-only',action='store_true');p.add_argument('--output',type=pathlib.Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
 cases=read(a.suite)['cases']+read(a.automatic)['cases'];records=[]
 for case in cases:
  c=pathlib.Path(case['compiled']);d=a.output/case['id'];d.mkdir();cfg=c/'target.json';config=read(cfg) if cfg.exists() else {};config.setdefault('generic_air',{})['cost_model']={'schema':'orbit.direct-air.cost.v1','kind':'features-only'};write(d/'config.json',config)
  cmd=[a.tool,str(c/'transformed-taskflow.mlir'),'--generic-map','--target-config='+str(d/'config.json'),'--mapping-output='+str(d/'plan.json'),'--analysis-output='+str(d/'analysis.json')];
  if not a.features_only:cmd.append('--program-timing-output='+str(d/'timing.json'));
  write(d/'command.json',cmd)
  r=subprocess.run(cmd,capture_output=True,text=True);(d/'export.log').write_text(r.stdout+r.stderr);assert r.returncode==0,(case['id'],r.stderr[-1500:])
  original=read(c/'plan.json');fresh=read(d/'plan.json');assert original['program_graph']==fresh['program_graph'],case['id']+' different evaluated graph from compiled'
  timing=read(d/'timing.json') if not a.features_only else {'graph_id':original['program_graph_id'],'features':fresh['direct_air_cost']['features'],'internal_timing':'not requested; native feature-only export'};
  if a.features_only:write(d/'timing.json',timing)
  assert timing['graph_id']==original['program_graph_id']
  features=timing['features'];write(d/'features.json',features)
  records.append(dict(case,features={'path':str(d/'features.json'),'sha256':sha(d/'features.json')},graph_id=timing['graph_id'],compiled_plan_id=original['plan_id'],evaluation_plan_id=fresh['plan_id'],timing={'path':str(d/'timing.json'),'sha256':sha(d/'timing.json')},evaluated_source={'path':str(c/'transformed-taskflow.mlir'),'sha256':sha(c/'transformed-taskflow.mlir')}))
  print(case['id'],[features['values'][k] for k in ['command_count','hardware_stage_count','dma_bytes','source_scalar_f32_operations']])
 write(a.output/'index.json',{'schema':'orbit.mechanism.features-index.v16','tool':{'path':a.tool,'sha256':sha(a.tool)},'cases':records,'graph_bridge':'full JSON graph equality with actual compiled native plan; feature counts from C++ only'})
if __name__=='__main__':main()
