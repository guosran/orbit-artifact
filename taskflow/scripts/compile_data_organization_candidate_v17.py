#!/usr/bin/env python3
"""Bind C++-materialized source to fixture references and invoke existing compiler.

No Python mapping/lowering/planning. Both source bodies are analyzed by C++; their
fingerprints must agree before preserving the candidate and invoking the original
compile-only direct-AIR entry. Output is new and failures stay in place.
"""
import argparse,json,shutil,subprocess
from pathlib import Path
from audit_program_implementation_v16 import identity


def main():
 p=argparse.ArgumentParser(description=__doc__)
 p.add_argument('--plain-fixture',type=Path,required=True);p.add_argument('--candidate-source',type=Path,required=True)
 p.add_argument('--tool',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
 a.output=a.output.resolve();a.output.mkdir(parents=True,exist_ok=False)
 records={}
 for name,source in [('plain',a.plain_fixture/'source.mlir'),('candidate',a.candidate_source)]:
  facts=a.output/(name+'-facts.json');command=[str(a.tool.resolve()),str(source.resolve()),'--generic-analyze','--analysis-output='+str(facts)]
  (a.output/(name+'-analysis-command.json')).write_text(json.dumps(command,indent=2)+'\n')
  with (a.output/(name+'-analysis.log')).open('w') as log:subprocess.run(command,stdout=log,stderr=subprocess.STDOUT,check=True)
  records[name]=json.loads(facts.read_text())
 assert records['plain']['body_fingerprint']==records['candidate']['body_fingerprint'],'candidate changed computation body'
 prepared=a.output/'input';prepared.mkdir()
 for path in a.plain_fixture.glob('*.npz'):shutil.copy2(path,prepared/path.name)
 shutil.copy2(a.candidate_source,prepared/'source.mlir')
 metadata=json.loads((a.plain_fixture/'fixture.json').read_text());metadata['source_sha256']=identity(prepared/'source.mlir')['sha256']
 metadata['candidate_provenance']=dict(plain_source=identity(a.plain_fixture/'source.mlir'),candidate_source=identity(a.candidate_source),tool=identity(a.tool),body_fingerprint=records['plain']['body_fingerprint'])
 (prepared/'fixture.json').write_text(json.dumps(metadata,indent=2)+'\n')
 command=['bash',str(Path(__file__).with_name('run_taskflow_direct_air_v6_case.sh')),'--compile-only','--runtime-transfer-audit','--tool',str(a.tool.resolve()),'--input',str(prepared),'--output',str(a.output/'compiled')]
 (a.output/'compile-command.json').write_text(json.dumps(command,indent=2)+'\n')
 subprocess.run(command,check=True)
 (a.output/'binding.json').write_text(json.dumps(dict(schema='orbit.data-organization.candidate-binding.v17',source=identity(__file__),device_submissions=0,
  plain_fixture=str(a.plain_fixture.resolve()),candidate_source=identity(a.candidate_source),prepared=str(prepared),compiled=str(a.output/'compiled'),
  body_fingerprint=records['plain']['body_fingerprint']),indent=2)+'\n')
 print(json.dumps(dict(status='compiled',prepared=str(prepared),compiled=str(a.output/'compiled'),device_submissions=0)))

if __name__=='__main__':main()
