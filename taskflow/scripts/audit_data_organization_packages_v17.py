#!/usr/bin/env python3
"""Audit already compiled C++ data-organization candidates, without a device."""
import argparse,json
from pathlib import Path
from audit_data_organization_deltas_v17 import audit
from audit_program_implementation_v16 import identity
import audit_data_organization_deltas_v17 as helper


def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--index',type=Path,action='append',required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
 a.output.mkdir(parents=True,exist_ok=False)
 records=[c for index in a.index for c in json.loads(index.read_text())['cases']]
 assert len({c['id'] for c in records})==len(records)
 rows=[audit(c) for c in records]
 for row,case in zip(rows,records):
  row['native_hardware_stage_list_length']=row['plan_hardware_stages']
  row['normalized_hardware_stage_count']=1 if row['strategy']=='single-herd-resident' else row['plan_hardware_stages']
  fixture=Path(case['prepared'])/'fixture.json'
  if fixture.is_file():row['fixture']=json.loads(fixture.read_text())['fixture']
  for key in ['candidate_id','action_chain','parent_id','family','split','role','pair_id']:
   if key in case:row[key]=case[key]
 result=dict(schema='orbit.data-organization.implementation-audit.v17',source=identity(__file__),helper_source=identity(helper.__file__),indices=[identity(x) for x in a.index],cases=rows,
  device_submissions=0,scope='Existing checked plan and final-AIE correspondence only. Requested payload and inferred cyclic-BD counts; no physical byte/cycle/overlap measurements.')
 (a.output/'inventory.json').write_text(json.dumps(result,indent=2)+'\n')
 lines=['# Actual data-organization implementations','',
 '| Candidate | Strategy | Requested bytes | Local peak | Native stage list | Normalized stages | Runtime BD tasks | Implied core transactions | Child configs | Bound BOs | Runner syncs |',
 '| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- | ---: |']
 for row in rows:
  values=[row['id'],row['strategy'],row['requested_payload_bytes'],row['local_storage_peak_bytes'],row['native_hardware_stage_list_length'],row['normalized_hardware_stage_count'],row['runtime_bd_tasks'],row['implied_core_transactions'],len(row['configure_calls']),','.join(row['external_BOs']),row['planned_runner_sync_calls']]
  lines.append('| '+' | '.join(map(str,values))+' |')
 lines+=['','Native stage-list length is the raw plan field; normalized stage count uses the existing GenericCostFeatures convention (one for single-herd-resident). Actual child configurations are independently counted from wrapper calls. All byte totals are requested implementation payload and equal the checked plan. Core transaction counts are inferred from actual unique shim/core flows, cyclic core BD sizes and full descriptor payloads. They are not independent extra bytes or hardware counters. Configurations are actual wrapper configure calls, not inferred from BD count. Sync counts follow the unchanged bound-runner contract, excluding constructor/BO preparation.','',
 'All child configurations run serially. Separate input/output channels and buffer locks can permit internal streaming, but measured overlap/resource-contention rates remain unknown. `inventory.json` preserves actual allocation/copy regions, versions, lifetime choices and per-flow contributions.','']
 (a.output/'REPORT.md').write_text('\n'.join(lines))
 print(json.dumps(dict(status='audited',packages=len(rows),device_submissions=0)))

if __name__=='__main__':main()
