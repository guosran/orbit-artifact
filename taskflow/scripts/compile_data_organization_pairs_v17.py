#!/usr/bin/env python3
"""Compile C++-selected pairs, verify identical searched/lowered graphs, freeze replay.

No plan is generated in Python and no NPU runtime is opened. Original compiler and
measurement wrappers are invoked in separate processes, with new output paths.
"""
import argparse,json,subprocess,sys
from pathlib import Path
from audit_program_implementation_v16 import identity


def write(path,value):path.write_text(json.dumps(value,indent=2)+'\n')


def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--index',type=Path,required=True)
 p.add_argument('--tool',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
 a.output=a.output.resolve();a.output.mkdir(parents=True,exist_ok=False);source=json.loads(a.index.read_text())
 result=dict(schema='orbit.data-organization.compiled-pairs.v17',source_index=identity(a.index),tool=identity(a.tool),compiler_wrapper=identity(Path(__file__).with_name('compile_data_organization_candidate_v17.py')),
  pair_compiler=identity(__file__),cases=[],device_submissions=0)
 flat=[]
 for pair in source['cases']:
  compiled={k:v for k,v in pair.items() if k not in ['baseline','candidate']}
  for side in ['baseline','candidate']:
   selection=pair[side]
   for key in ['source','graph','mapping']:
    assert identity(selection[key]['path'])['sha256']==selection[key]['sha256']
   identifier=pair['id']+'-'+side;out=a.output/identifier
   command=[sys.executable,str(Path(__file__).with_name('compile_data_organization_candidate_v17.py')),'--plain-fixture',pair['prepared'],'--candidate-source',selection['source']['path'],'--tool',str(a.tool.resolve()),'--output',str(out)]
   (a.output/(identifier+'.command.json')).write_text(json.dumps(command,indent=2)+'\n')
   with (a.output/(identifier+'.log')).open('w') as log:subprocess.run(command,stdout=log,stderr=subprocess.STDOUT,check=True)
   plan=json.loads((out/'compiled/plan.json').read_text());searched=json.loads(Path(selection['graph']['path']).read_text())
   receipt=dict(same_full_graph=plan['program_graph']==searched,compiled_graph_id=plan['program_graph_id'],searched_graph_id=selection['graph_id'],
    searched_graph=identity(selection['graph']['path']),compiled_plan=identity(out/'compiled/plan.json'),candidate_source=identity(out/'input/source.mlir'),
    body_fingerprint=plan['body_fingerprint'])
   write(out/'graph-equality.json',receipt)
   assert receipt['same_full_graph'] and plan['program_graph_id']==selection['graph_id'],'searched/lowered graph mismatch'
   row=dict(selection,prepared=str(out/'input'),compiled=str(out/'compiled'),graph_equality=identity(out/'graph-equality.json'))
   compiled[side]=row
   flat.append(dict(row,id=identifier,pair_id=pair['pair_id'],role=side,kind=pair['kind'],split=pair['split']))
  assert json.loads((Path(compiled['baseline']['compiled'])/'plan.json').read_text())['body_fingerprint']==json.loads((Path(compiled['candidate']['compiled'])/'plan.json').read_text())['body_fingerprint']
  protocol=a.output/(pair['id']+'-protocol.json')
  command=[sys.executable,str(Path(__file__).with_name('taskflow_data_probe_v17.py')),'--freeze',str(protocol),'--poll-us','20','--seeds','11','23','47','--warmups','3','--repeats','15']
  for side in ['baseline','candidate']:command+=['--case',compiled[side]['prepared'],compiled[side]['compiled']]
  subprocess.run(command,check=True)
  subprocess.run([sys.executable,str(Path(__file__).with_name('taskflow_data_probe_v17.py')),'--protocol',str(protocol),'--output',str(a.output/(pair['id']+'-cpu-validation')),'--validate-only'],check=True)
  compiled['protocol']=identity(protocol);result['cases'].append(compiled)
  write(a.output/'index.json',result);write(a.output/'flat-index.json',dict(schema='orbit.data-organization.compiled-flat.v17',cases=flat,device_submissions=0))
  print(json.dumps(dict(pair=pair['id'],split=pair['split'],compiled_graphs_equal=True,protocol=str(protocol),device_submissions=0)),flush=True)
 assert identity(a.tool)['sha256']==result['tool']['sha256'],'compiler changed during suite'
 print(json.dumps(dict(status='compiled',pairs=len(result['cases']),packages=len(flat),device_submissions=0)),flush=True)

if __name__=='__main__':main()
