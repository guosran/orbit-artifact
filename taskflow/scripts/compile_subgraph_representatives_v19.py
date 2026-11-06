#!/usr/bin/env python3
"""Compile checked original C++ candidates. No production planning in Python."""
import argparse,hashlib,json,subprocess,sys
from pathlib import Path
from audit_program_implementation_v16 import identity

def main():
 p=argparse.ArgumentParser(description=__doc__)
 for key in ['index','plain-fixture','tool','output']:p.add_argument('--'+key,type=Path,required=True)
 a=p.parse_args();a.output=a.output.resolve();a.output.mkdir(parents=True,exist_ok=False)
 snapshot=a.output/'source-index-used.json';snapshot.write_bytes(a.index.read_bytes());entries=json.loads(snapshot.read_text())['entries']
 tool=a.output/'taskflow-opt-used';tool.write_bytes(a.tool.read_bytes());tool.chmod(0o755);rows=[]
 sources=a.output/'wrapper-sources';sources.mkdir()
 for name in ['compile_subgraph_representatives_v19.py','compile_subgraph_candidate_v19.py','run_taskflow_execution_graph_v18_case.sh']:(sources/name).write_bytes(Path(__file__).with_name(name).read_bytes())
 def write():
  (a.output/'index.json').write_text(json.dumps(dict(schema='orbit.subgraph-execution.compiled.v19',tool=identity(tool),source_index=identity(snapshot),source_index_origin=identity(a.index),cases=rows,device_submissions=0),indent=2)+'\n')
 for entry in entries:
  assert identity(entry['source'])['sha256']==entry['source_sha256'];name=entry['name'];dest=a.output/name
  fixture=entry.get('plain_fixture',str(a.plain_fixture))
  cmd=[sys.executable,str(Path(__file__).with_name('compile_subgraph_candidate_v19.py')),'--plain-fixture',fixture,'--candidate-source',entry['source'],'--target-config',entry['config'],'--tool',str(tool),'--output',str(dest)]
  (a.output/(name+'.command.json')).write_text(json.dumps(cmd,indent=2)+'\n')
  with (a.output/(name+'.log')).open('w') as log:r=subprocess.run(cmd,stdout=log,stderr=subprocess.STDOUT)
  row=dict(id=name,prepared=str(dest/'input'),compiled=str(dest/'compiled'),candidate_id=entry['source_sha256'],action_chain=entry['action_chain'],returncode=r.returncode);rows.append(row);write()
  if r.returncode:raise SystemExit(r.returncode)
  compiled=dest/'compiled';graph=json.loads((compiled/'program-graph.json').read_text());plan=json.loads((compiled/'plan.json').read_text())
  searched=json.loads(Path(entry['graph_file']).read_text());searched_plan=json.loads(Path(entry['mapping_result']).read_text())['best_plan']
  receipt=dict(source=identity(entry['source']),tool=identity(tool),full_graph_equal=graph==searched,full_plan_equal=plan==searched_plan,graph_id=plan['program_graph_id'],plan_id=plan['plan_id'],searched_graph=identity(entry['graph_file']),compiled_graph=identity(compiled/'program-graph.json'))
  (dest/'identity-receipt.json').write_text(json.dumps(receipt,indent=2)+'\n');assert receipt['full_graph_equal'] and receipt['full_plan_equal'],name+' source/graph/plan mismatch'
  row['identity_receipt']=str(dest/'identity-receipt.json');write()
 print(json.dumps(dict(status='compiled',cases=len(rows),device_submissions=0)))
if __name__=='__main__':main()
