#!/usr/bin/env python3
"""Re-audit selected historical paths for v17 mechanism contrasts, no device.

Instruction/template counts and requested payload are static implementation facts.
No physical DDR counter, overlap duration or inferred timing is produced.
"""
import argparse,json,re
from collections import Counter
from pathlib import Path
from audit_program_implementation_v16 import identity,regions


def audit(record):
 plan=json.loads((Path(record['compiled'])/'plan.json').read_text())
 abi=json.loads((Path(record['compiled'])/'abi.json').read_text())
 path=Path(record['compiled'])/'hardware/air_project/npu.input.air.mlir';text=path.read_text()
 contributions=[];own=[];config=[];core_transactions=0
 for _,body,_ in regions(text,r'aie\.device\([^)]*\)(?:\s+@[\w.$]+)?\s*\{'):
  # One cyclic descriptor per each currently used physical core DMA direction/channel.
  core_bd={}
  for m in re.finditer(r'aie\.dma_start\((MM2S|S2MM),\s*(\d+),\s*\^([\w]+)',body):
   block=re.search(r'\^'+m[3]+r':[^\n]*\n(.*?)(?=\n\s*\^|\Z)',body[m.end():],re.S)
   if not block:continue
   bds=re.findall(r'aie\.dma_bd\(%(?!arg)[^\n]* len = (\d+)',block[1])
   if len(bds)==1:core_bd[(m[1],int(m[2]))]=int(bds[0])*4
  alloc={name:(tile,direction,int(ch)) for name,tile,direction,ch in re.findall(r'aie\.shim_dma_allocation @([\w.$]+)\((%[\w.$]+), (S2MM|MM2S), (\d+)\)',body)}
  flows=re.findall(r'aie\.flow\((%[\w.$]+), DMA : (\d+), (%[\w.$]+), DMA : (\d+)\)',body)
  for sm,seq,_ in regions(body,r'aie\.runtime_sequence @([\w.$]+)\([^\n]*\)\s*\{'):
   configs=re.findall(r'aiex\.configure @([\w.$]+)',seq);config+=configs
   if 'aiex.dma_configure_task_for' in seq:own.append(sm[1])
   for tm,task,end in regions(seq,r'(%[\w.$]+) = aiex\.dma_configure_task_for @([\w.$]+)\s*\{'):
    attrs=re.match(r'\s*\{([^}]*)\}',seq[end:]);attrs=attrs[1] if attrs else ''
    repeat=re.search(r'repeat_count = (\d+)',attrs);repeat=int(repeat[1])+1 if repeat else 1
    shim,direction,channel=alloc[tm[2]]
    if direction=='MM2S':matches=[int(dstch) for src,srcch,dst,dstch in flows if src==shim and int(srcch)==channel];core_direction='S2MM'
    else:matches=[int(srcch) for src,srcch,dst,dstch in flows if dst==shim and int(dstch)==channel];core_direction='MM2S'
    assert len(matches)==1
    bd_bytes=core_bd[(core_direction,matches[0])]
    for arg,length in re.findall(r'aie\.dma_bd\(%arg(\d+) : memref<[^>]+> offset = \d+ len = (\d+)',task):
     payload=int(length)*4*repeat;assert payload%bd_bytes==0
     count=payload//bd_bytes;core_transactions+=count
     contributions.append(dict(storage=abi['buffers'][int(arg)]['name'],direction=direction,shim_channel=channel,
       payload_bytes=payload,core_bd_bytes=bd_bytes,implied_core_transactions=count,
       justification='single matching shim/core flow; one cyclic core BD; complete requested payload divided by matching core-BD payload'))
 assert sum(c['payload_bytes'] for c in contributions)==plan['actual_dma_bytes']
 return dict(id=record['id'],source=identity(Path(record['prepared'])/'source.mlir'),plan=identity(Path(record['compiled'])/'plan.json'),final_aie=identity(path),
  graph_id=plan['program_graph_id'],body_fingerprint=plan['body_fingerprint'],plan_id=plan['plan_id'],strategy=plan['strategy'],
  external_BOs=[b['name'] for b in abi['buffers']],planned_runner_sync_calls=len(abi['buffers'])+len(abi['outputs']),
  plan_hardware_stages=len(plan['hardware_stages']),task_owning_sequences=own,configure_calls=config,
  runtime_bd_tasks=len(contributions),implied_core_transactions=core_transactions,transaction_contributions=contributions,
  requested_payload_bytes=plan['actual_dma_bytes'],transfer_summary=plan['transfer_summary'],
  local_storage_peak_bytes=max((s['allocated_bytes'] for s in plan['hardware_stages']),default=plan['resident_bytes']),
  local_staging_copy_bytes=plan['local_staging_copy_bytes'],logical_scalar_reads=plan['logical_scalar_reads'],logical_scalar_writes=plan['logical_scalar_writes'],
  readonly_retentions=plan['readonly_retentions'],logical_data=plan['program_graph']['logical_data'],
  communications=plan['program_graph']['communications'],capacity_bytes=plan['capacity_bytes'],
  overlap='Separate input/output physical channels and buffer locks permit intra-child streaming; measured overlap and shared DDR contention remain unknown. Child configurations serial.',
  core_transaction_scope='Exact for these inspected current one-core cyclic-BD paths; descriptor payload/BD accounting, not a hardware transaction counter.')


def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--root',type=Path,default=Path('/home/shiran/project/orbit-artifact/results/taskflow'));p.add_argument('--output',type=Path,required=True);a=p.parse_args()
 assert not a.output.exists();a.output.mkdir(parents=True)
 suite=json.loads((a.root/'mechanism-v16/registered-suite-r1/index.json').read_text())['cases'];auto=json.loads((a.root/'mechanism-program-v16/automatic-packages-r1/index.json').read_text())['cases'];fan=json.loads((a.root/'mechanism-program-v16/fanout-residency-control-r1/index.json').read_text())['cases']
 cases=[c for c in suite if c['id'] in ['gemm16k128n32','fanout8n64']]+auto+[fan[0]]
 records=[audit(c) for c in cases]
 (a.output/'inventory.json').write_text(json.dumps(dict(schema='orbit.data-organization-deltas.v17',source=identity(__file__),cases=records,device_submissions=0,
  scope='Static source/plan/actual core+shim mapping, no new measurements. Old v16 model is preserved.'),indent=2)+'\n')
 print(json.dumps(dict(status='audited',cases=len(records),device_submissions=0)))

if __name__=='__main__':main()
