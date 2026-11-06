#!/usr/bin/env python3
"""Compile a C++-materialized public candidate, verify actual final AIE in C++.
No placement, candidate scoring or production graph decisions live here.
"""
import argparse,json,subprocess
from pathlib import Path
from audit_program_implementation_v16 import identity

def main():
 p=argparse.ArgumentParser(description=__doc__)
 p.add_argument('--plain-fixture',type=Path,required=True);p.add_argument('--candidate-source',type=Path,required=True)
 p.add_argument('--target-config',type=Path);p.add_argument('--tool',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
 a=p.parse_args();a.output=a.output.resolve()
 command=['python3',str(Path(__file__).with_name('compile_execution_graph_candidate_v18.py')),'--plain-fixture',str(a.plain_fixture.resolve()),'--candidate-source',str(a.candidate_source.resolve()),'--tool',str(a.tool.resolve()),'--output',str(a.output)]
 if a.target_config:command+=['--target-config',str(a.target_config.resolve())]
 subprocess.run(command,check=True)
 compiled=a.output/'compiled';final=compiled/'hardware/air_project/npu.input.air.mlir';generic=compiled/'final-aie.generic.mlir'
 convert=['air-opt',str(final),'--mlir-print-op-generic','-o',str(generic)]
 (compiled/'final-aie-extract.command.json').write_text(json.dumps(convert,indent=2)+'\n')
 with (compiled/'final-aie-extract.log').open('w') as log:subprocess.run(convert,check=True,stdout=log,stderr=subprocess.STDOUT)
 check=[str(a.tool.resolve()),str(compiled/'source.mlir'),'--check-aie='+str(generic),'--implementation-output='+str(compiled/'implementation-contract.json'),'--implementation-facts-output='+str(compiled/'implementation-facts.json')]
 if a.target_config:check+=['--target-config='+str(a.target_config.resolve())]
 (compiled/'implementation-check.command.json').write_text(json.dumps(check,indent=2)+'\n')
 with (compiled/'implementation-check.log').open('w') as log:subprocess.run(check,check=True,stdout=log,stderr=subprocess.STDOUT)
 (a.output/'v19-receipt.json').write_text(json.dumps(dict(schema='orbit.subgraph-execution.compilation.v19',tool=identity(a.tool),source=identity(a.candidate_source),final_aie=identity(final),generic_aie=identity(generic),contract=identity(compiled/'implementation-contract.json'),device_submissions=0),indent=2)+'\n')
 print(json.dumps(dict(status='compiled-and-checked',compiled=str(compiled),device_submissions=0)))
if __name__=='__main__':main()
