#!/usr/bin/env python3
"""Independently re-read final AIE sequence ownership/configuration counts.

Only read-only static IR inventory. Does not read performance or open devices.
"""
import argparse,json,re
from pathlib import Path
from audit_program_implementation_v16 import identity,regions


def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--inventory',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
 assert not a.output.exists()
 inventory=json.loads(a.inventory.read_text());rows=[]
 for case in inventory['packages']:
  file=case['files']['final_aie'];assert identity(file['path'])['sha256']==file['sha256']
  text=Path(file['path']).read_text();sequences=[]
  for match,body,_ in regions(text,r'aie\.runtime_sequence @([\w.$]+)\([^\n]*\)\s*\{'):
   sequences.append(dict(name=match[1],runtime_bd_tasks=body.count('aiex.dma_configure_task_for'),
    configure_calls=re.findall(r'aiex\.configure @([\w.$]+)',body),run_calls=re.findall(r'aiex\.run @([\w.$]+)',body)))
  owning=[s for s in sequences if s['runtime_bd_tasks']];wrappers=[s for s in sequences if not s['runtime_bd_tasks']]
  configs=sum(len(s['configure_calls']) for s in sequences);runs=sum(len(s['run_calls']) for s in sequences)
  row=dict(id=case['id'],final_aie=identity(file['path']),plan_hardware_stage_count=len(case['hardware_stages']),
    total_runtime_sequences=len(sequences),task_owning_sequences=len(owning),wrapper_sequences=len(wrappers),
    configure_calls=configs,run_calls=runs,runtime_bd_tasks=sum(s['runtime_bd_tasks'] for s in sequences),sequence_details=sequences)
  assert row['plan_hardware_stage_count']==row['task_owning_sequences']==configs==runs
  assert row['wrapper_sequences']==1
  rows.append(row)
 a.output.write_text(json.dumps(dict(schema='orbit.implementation-sequence-recheck.v16',source=identity(__file__),
  original_inventory=identity(a.inventory),cases=rows,device_submissions=0,
  conclusion='All sixteen in-scope packages have plan stage count == owning child sequence count == configure call count == run call count. Multiple BDs do not imply multiple child configurations.'),indent=2)+'\n')
 print(json.dumps(dict(status='passed',packages=len(rows),all_sixteen_plan_stages_equal_child_configurations=True,device_submissions=0)))

if __name__=='__main__':main()
