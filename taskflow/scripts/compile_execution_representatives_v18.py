#!/usr/bin/env python3
"""Compile original-search source representatives and bind identical full graphs."""
import argparse,json,subprocess,sys
from pathlib import Path
from audit_program_implementation_v16 import identity
from audit_data_organization_deltas_v17 import audit


def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--index',type=Path,required=True);p.add_argument('--plain-fixture',type=Path,required=True);p.add_argument('--tool',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
 source_index_snapshot=a.output/'source-index-used.json';source_index_snapshot.write_bytes(a.index.read_bytes())
 source_index=identity(source_index_snapshot);source_index_origin=dict(source_index,path=str(a.index.resolve()))
 original=json.loads(source_index_snapshot.read_text());rows=[];tool=identity(a.tool)
 wrapper_sources=a.output/'compiler-wrapper-sources';wrapper_sources.mkdir();compiler_wrappers=[]
 for path in [Path(__file__),Path(__file__).with_name('compile_execution_graph_candidate_v18.py'),Path(__file__).with_name('run_taskflow_execution_graph_v18_case.sh')]:
  saved=wrapper_sources/path.name;saved.write_bytes(path.read_bytes());compiler_wrappers.append(identity(saved))
 for entry in original['entries']:
  name=entry['name'];dest=a.output/name
  assert identity(entry['source'])['sha256']==entry['source_sha256']
  cmd=[sys.executable,str(Path(__file__).with_name('compile_execution_graph_candidate_v18.py')),'--plain-fixture',str(a.plain_fixture),'--candidate-source',entry['source'],'--target-config',entry['config'],'--tool',str(a.tool),'--output',str(dest)]
  (a.output/(name+'.command.json')).write_text(json.dumps(cmd,indent=2)+'\n')
  with (a.output/(name+'.log')).open('w') as log:r=subprocess.run(cmd,stdout=log,stderr=subprocess.STDOUT)
  row=dict(id=name,prepared=str(dest/'input'),compiled=str(dest/'compiled'),candidate_id=entry['source_sha256'],action_chain=entry['action_chain'],returncode=r.returncode)
  rows.append(row);(a.output/'index.json').write_text(json.dumps(dict(schema='orbit.execution-graph.compiled-representatives.v18',tool=tool,source_index=source_index,source_index_origin=source_index_origin,compiler_wrapper_sources=compiler_wrappers,cases=rows,device_submissions=0),indent=2)+'\n')
  if r.returncode:raise SystemExit(r.returncode)
  compiled=dest/'compiled';plan=json.loads((compiled/'plan.json').read_text());graph=json.loads((compiled/'program-graph.json').read_text());searched=json.loads(Path(entry['graph_file']).read_text());searched_plan=json.loads(Path(entry['mapping_result']).read_text())['best_plan']
  receipt=dict(source=identity(entry['source']),tool=tool,searched_graph=identity(entry['graph_file']),compiled_graph=identity(compiled/'program-graph.json'),full_program_graph_equal=graph==searched,searched_price_plan_id=entry['price_attached_plan_id'],compiled_plan_id=plan['plan_id'],literal_plan_id_equal=plan['plan_id']==entry['price_attached_plan_id'],native_full_plan_equal=plan==searched_plan,execution_fingerprint=entry['execution_fingerprint'],body_fingerprint=plan['body_fingerprint'])
  (dest/'identity-receipt.json').write_text(json.dumps(receipt,indent=2)+'\n');assert receipt['full_program_graph_equal'],name+' full ProgramGraph mismatch'
  physical=audit(row);(dest/'physical-audit.json').write_text(json.dumps(physical,indent=2)+'\n');row['identity_receipt']=str(dest/'identity-receipt.json');row['physical_audit']=str(dest/'physical-audit.json')
  assert identity(a.tool)==tool,'tool changed during compilation'
 (a.output/'index.json').write_text(json.dumps(dict(schema='orbit.execution-graph.compiled-representatives.v18',tool=tool,source_index=source_index,source_index_origin=source_index_origin,compiler_wrapper_sources=compiler_wrappers,cases=rows,device_submissions=0),indent=2)+'\n');print(json.dumps(dict(status='compiled',cases=len(rows),device_submissions=0)))

if __name__=='__main__':main()
