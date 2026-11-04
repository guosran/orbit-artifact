#!/usr/bin/env python3
"""Reproduction orchestration only; native compiler owns plans and rankings."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
ROOT=Path(__file__).resolve().parents[1]
def load(p):return json.loads(Path(p).read_text())
def save(p,v):Path(p).write_text(json.dumps(v,indent=2)+'\n')
def bound(p):
 p=Path(p);return dict(path=str(p),sha256=hashlib.sha256(p.read_bytes()).hexdigest())
def verify(v):
 p=Path(v['path']);assert bound(p)==v,'frozen input changed';return p

def run(directory,name,argv):
 argv=list(map(str,argv));save(directory/(name+'.command.json'),argv)
 with (directory/(name+'.stdout')).open('w') as stdout,(directory/(name+'.stderr')).open('w') as stderr:
  result=subprocess.run(argv,stdout=stdout,stderr=stderr)
 save(directory/(name+'.result.json'),dict(returncode=result.returncode))
 if result.returncode:raise RuntimeError(name+' failed; preserved command/stdout/stderr')

def controls(predictions,output):
 prediction=load(predictions);record=load(verify(prediction['predictive_search']))
 tool=verify(record['tool']);source=verify(record['source']);config=load(verify(record['config']))
 output.mkdir(parents=True,exist_ok=False)
 for mode in ['tiling-only','implementation-residency']:
  directory=output/mode;directory.mkdir();derived=json.loads(json.dumps(config));derived['native_auto_candidates']['mode']=mode
  save(directory/'config.json',derived)
  save(directory/'inputs.json',dict(mode=mode,source=bound(source),tool=bound(tool),config=bound(directory/'config.json'),frozen_prediction=bound(predictions),common_controls={k:record[k] for k in ['root_tile','max_rounds','max_candidates','beam_width']},scope='only search mode changed; equal ceilings, not equal actual work'))
  tiles=record['root_tile']
  run(directory,'native-search',[tool,source,'--search','--backend=air','--air-distribute-initialization',f'--tile-m={tiles[0]}',f'--tile-n={tiles[1]}',f'--tile-k={tiles[2]}',f'--target-config={directory}/config.json',f'--search-output={directory}/search',f'--max-rounds={record["max_rounds"]}',f'--max-candidates={record["max_candidates"]}',f'--beam-width={record["beam_width"]}'])

def run_profile(command):
 argv=load(command)
 if not isinstance(argv,list) or not argv or any(not isinstance(x,str) for x in argv):raise ValueError('profile command must be an argv list')
 run(command.parent,'profile-execution',argv)

def ffn(selection,output):
 freeze=load(selection/'selection-freeze.json');selected=load(verify(freeze['selected']))
 joint=[r for r in selected if r['cell']['name']=='joint'];assert len(joint)==1
 request=joint[0];plan=load(verify(request['plan']));tiles=plan['tile_sizes']
 proposal=load(verify(freeze['proposal']));tool=verify(proposal['tool'])
 output.mkdir(parents=True,exist_ok=False)
 run(output,'prepare',[sys.executable,ROOT/'test/TaskflowAIR/prepare_v6.py','--case','ffn','--m','5','--k','2048','--n','11008','--seeds','11','23','47','--output',output/'inputs'])
 rows=[]
 for name,tile in [('baseline',[8,64,64]),('selected',tiles)]:
  config=dict(generic_air=dict(tile_sizes=tile,capacity_bytes=24576,cost_model=dict(schema='orbit.direct-air.cost.v1',kind='features-only')))
  save(output/(name+'.json'),config)
  run(output,'compile-'+name,['bash',ROOT/'scripts/run_taskflow_direct_air_v6_case.sh','--compile-only','--diagnostic','--input',output/'inputs','--output',output/name,'--tool',tool,'--target-config',output/(name+'.json'),'--approx-exp','--distribute-initialization','--implementation','scalar-product-vector-add-f32','--vector-lanes','8','--runtime-transfer-audit'])
  run(output,'storage-'+name,[sys.executable,ROOT/'test/TaskflowAIR/audit_storage_v6.py',output/name/'hardware','--plan',output/name/'plan.json','--output',output/name/'storage-audit.json'])
  actual=load(output/name/'plan.json');assert actual['tile_sizes']==tile and actual['program_mapping_choices']['data_organization']=='phase-local'
  abi=load(output/name/'abi.json')
  rows.append(dict(name=name,hardware=str(output/name/'hardware'),abi=str(output/name/'abi.json'),static_indices=[],intermediate_indices=[i for i,b in enumerate(abi['buffers']) if b['role']=='temporary'],inputs=[str(output/'inputs'/f'inputs-{seed}.npz') for seed in [11,23,47]],reference=[str(output/'inputs'/f'reference-{seed}.npz') for seed in [11,23,47]]))
 save(output/'cases.json',rows)
 command=[sys.executable,str(ROOT/'scripts/taskflow_ffn_profile.py'),'--cases',str(output/'cases.json'),'--observer','detailed','--warmups','1','--iterations','1','--output',str(output/'profile-ffn')]
 save(output/'profile-command.json',command)
 save(output/'inputs.json',dict(selection=bound(selection/'selection-freeze.json'),joint_plan=bound(verify(request['plan'])),tool=bound(tool),cases=bound(output/'cases.json'),profile_command=bound(output/'profile-command.json'),scope='full M5 D2048 I11008; selected joint tiles only transferred to a new graph, no extrapolated prediction; both phase-local mixed8; all inputs staged each call; 3 seeds one warm/one hot'))
 run_profile(output/'profile-command.json')
 run(output,'independent-audit',[sys.executable,ROOT/'test/TaskflowAIR/audit_profile_v9.py','--root',output,'--profile','profile-ffn','--output',output/'independent-audit'])

def main():
 parser=argparse.ArgumentParser(description=__doc__);sub=parser.add_subparsers(dest='phase',required=True)
 p=sub.add_parser('controls');p.add_argument('--predictions',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
 p=sub.add_parser('run-profile');p.add_argument('--command',type=Path,required=True)
 p=sub.add_parser('ffn');p.add_argument('--selection',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
 a=parser.parse_args()
 if a.phase=='controls':controls(a.predictions.resolve(),a.output.resolve())
 elif a.phase=='run-profile':run_profile(a.command.resolve())
 else:ffn(a.selection.resolve(),a.output.resolve())
if __name__=='__main__':main()
