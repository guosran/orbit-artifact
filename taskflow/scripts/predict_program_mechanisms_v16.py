#!/usr/bin/env python3
"""Native C++ frozen predictions; no measurement labels, fits or Python planner."""
import argparse,datetime,hashlib,json,pathlib,subprocess

def read(p):return json.loads(pathlib.Path(p).read_text())
def sha(p):return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
def ident(p):return {'path':str(pathlib.Path(p).resolve()),'sha256':sha(p)}
def write(p,v):pathlib.Path(p).write_text(json.dumps(v,indent=2)+'\n')
def main():
 p=argparse.ArgumentParser();p.add_argument('--features',type=pathlib.Path,required=True);p.add_argument('--model-root',type=pathlib.Path,required=True);p.add_argument('--tool',required=True);p.add_argument('--output',type=pathlib.Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
 index=read(a.features);model=read(a.model_root/'model.json');target=read(a.model_root/'target.json');rows=[]
 for c in index['cases']:
  d=a.output/c['id'];d.mkdir();compiled=pathlib.Path(c['compiled']);config=read(compiled/'target.json') if (compiled/'target.json').exists() else {};config.setdefault('generic_air',{}).update(cost_model=model,cost_target=target);write(d/'config.json',config)
  cmd=[a.tool,str(compiled/'transformed-taskflow.mlir'),'--generic-map','--target-config='+str(d/'config.json'),'--mapping-output='+str(d/'plan.json'),'--analysis-output='+str(d/'analysis.json'),'--program-timing-output='+str(d/'timing.json')];write(d/'command.json',cmd)
  r=subprocess.run(cmd,capture_output=True,text=True);(d/'export.log').write_text(r.stdout+r.stderr);assert r.returncode==0,(c['id'],r.stderr[-1500:])
  plan=read(d/'plan.json');original=read(compiled/'plan.json');assert plan['program_graph']==original['program_graph'] and plan['program_graph_id']==c['graph_id']
  timing=read(d/'timing.json');ms=timing['complete_invocation']['makespan_ms'];assert ms is not None and abs(ms-plan['estimated_ms'])<1e-12
  src=pathlib.Path(c['prepared']);case=(src.parent.name if src.name=='input' else src.name)
  artifact=read(compiled/'hardware/compile.json')
  rows.append(dict(case=case,case_id=c['id'],split=c['split'],graph_id=c['graph_id'],plan_id=original['plan_id'],priced_plan_id=plan['plan_id'],artifact_sha256=artifact['elf_sha256'],prediction_ns=ms*1e6,model_sha256=sha(a.model_root/'model.json'),timing=ident(d/'timing.json'),action_chain=c.get('action_chain',[]),candidate_id=c.get('candidate_id'),formula_contributions=timing['formula_contributions']))
  print(case,ms)
 write(a.output/'predictions.json',{'schema':'orbit.mechanism-program.predictions.v16','created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'model':ident(a.model_root/'model.json'),'tool':ident(a.tool),'features':ident(a.features),'rows':rows,'heldout_labels_read':False})
if __name__=='__main__':main()
