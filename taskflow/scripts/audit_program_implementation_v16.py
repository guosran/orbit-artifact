#!/usr/bin/env python3
"""Read-only v16 implementation inventory; no runtime import or device access.

Extends v15 textual-path inventory to arbitrary current f32 multi-stage packages.
All instruction/IR counts are static sites, never measured cycles or DDR traffic.
"""
import argparse,hashlib,json,re,subprocess
from collections import Counter
from pathlib import Path


def identity(path):
 p=Path(path).resolve();return dict(path=str(p),sha256=hashlib.sha256(p.read_bytes()).hexdigest(),bytes=p.stat().st_size)


def balanced(text, start):
 assert text[start]=='{';depth=0;quote=False;escape=False
 for i in range(start,len(text)):
  ch=text[i]
  if quote:
   if escape:escape=False
   elif ch=='\\':escape=True
   elif ch=='"':quote=False
  elif ch=='"':quote=True
  elif ch=='{':depth+=1
  elif ch=='}':
   depth-=1
   if depth==0:return i+1
 raise ValueError('unclosed MLIR region')


def regions(text,pattern):
 for m in re.finditer(pattern,text):
  begin=m.end()-1;end=balanced(text,begin)
  yield m,text[begin+1:end-1],end


def inventory(case,out,objdump):
 root=Path(case['compiled']);project=root/'hardware/air_project'
 plan=json.loads((root/'plan.json').read_text());abi=json.loads((root/'abi.json').read_text())
 compile=json.loads((root/'hardware/compile.json').read_text());elf=identity(compile['elf_path'])
 assert elf['sha256']==compile['elf_sha256']
 source=identity(Path(case['prepared'])/'source.mlir')
 final=(project/'npu.input.air.mlir').read_text()
 if re.search(r'orbit\.program_graph = "([^"]+)"',final):
  assert re.search(r'orbit\.program_graph = "([^"]+)"',final)[1]==plan['program_graph_id']
 assert re.search(r'orbit\.mapping_plan = "([^"]+)"',final)[1]==plan['plan_id']
 devices=[];total_bytes=0;runtime_by_storage=Counter()
 for m,device,_ in regions(final,r'aie\.device\([^)]*\)(?:\s+@[\w.$]+)?\s*\{'):
  tiles={name:(int(c),int(r)) for name,c,r in re.findall(r'(%[\w.$]+) = aie\.tile\((\d+), (\d+)\)',device)}
  allocations={name:dict(tile=tile,direction=direction,channel=int(channel)) for name,tile,direction,channel in re.findall(r'aie\.shim_dma_allocation @([\w.$]+)\((%[\w.$]+), (S2MM|MM2S), (\d+)\)',device)}
  sequences=[]
  for sm,body,_ in regions(device,r'aie\.runtime_sequence @([\w.$]+)\([^\n]*\)\s*\{'):
   configs=[]
   for cm,task,end in regions(body,r'(%[\w.$]+) = aiex\.dma_configure_task_for @([\w.$]+)\s*\{'):
    tail=body[end:];am=re.match(r'\s*\{([^}]*)\}',tail);attrs=am[1] if am else ''
    repeat=re.search(r'repeat_count = (\d+)',attrs);repeat=int(repeat[1]) if repeat else 0
    descriptors=[]
    for bd in re.finditer(r'aie\.dma_bd\((%arg\d+) : memref<([^>]+)> offset = (\d+) len = (\d+)([^\n]*)',task):
     assert bd[2].endswith('xf32'), 'audit deliberately supports current f32 path only'
     arg=int(bd[1][4:]);length=int(bd[4]);storage=abi['buffers'][arg]['name']
     payload=4*length*(repeat+1)
     binding=allocations[cm[2]];direction='host_to_l1' if binding['direction']=='MM2S' else 'l1_to_host'
     runtime_by_storage[(storage,direction)]+=payload;total_bytes+=payload
     descriptors.append(dict(argument=arg,storage=storage,offset_elements=int(bd[3]),length_elements=length,
       repeat_count=repeat,descriptor_payload_bytes_per_invocation=payload,direction=direction,syntax=bd[0]))
    assert descriptors and not re.search(r'\b(?:scf|affine)\.for',body), 'dynamic runtime loop not handled'
    configs.append(dict(ssa=cm[1],allocation=cm[2],binding=allocations[cm[2]],issue_token='issue_token = true' in attrs,
      repeat_count=repeat,descriptors=descriptors,awaited=bool(re.search(r'aiex\.dma_await_task\([^)]*'+re.escape(cm[1])+r'(?:,|\))',body)),
      freed=bool(re.search(r'aiex\.dma_free_task\([^)]*'+re.escape(cm[1])+r'(?:,|\))',body))))
   sequences.append(dict(name=sm[1],tasks=configs,run_calls=re.findall(r'aiex\.run @([\w.$]+)',body),
     configure_calls=re.findall(r'aiex\.configure @([\w.$]+)',body),runtime_template_bytes=sum(b['descriptor_payload_bytes_per_invocation'] for c in configs for b in c['descriptors'])))
  devices.append(dict(declaration=m[0],tiles=tiles,core_tiles=re.findall(r'aie\.core\((%[\w.$]+)\)',device),
   memtile_tiles=[name for name,xy in tiles.items() if xy[1]==1],memtile_dma_ops=device.count('aie.memtile_dma'),
   flows=re.findall(r'aie\.flow\([^\n]+',device),shim_allocations=allocations,
   local_dma_bd_templates=re.findall(r'aie\.dma_bd\(%(?!arg)[^\n]+',device),
   dma_start_templates=re.findall(r'aie\.dma_start\((MM2S|S2MM),\s*(\d+)',device),
   lock_use_templates=len(re.findall(r'aie\.use_lock\(',device)),
   memref_load_templates=device.count('memref.load'),memref_store_templates=device.count('memref.store'),
   initializer_markers=re.findall(r'orbit\.initializer_task = "([^"]+)"',device),sequences=sequences))
 requested=Counter({(x['storage'],x['direction']):x['bytes'] for x in plan['transfer_summary']})
 assert runtime_by_storage==requested,(case['id'],runtime_by_storage,requested)
 assert total_bytes==plan['actual_dma_bytes']
 # Current wrapper invokes each task-owning runtime sequence exactly once.
 owning=[s['name'] for d in devices for s in d['sequences'] if s['tasks']]
 calls=[c for d in devices for s in d['sequences'] for c in s['run_calls']]
 assert Counter(owning)==Counter(calls), 'cannot assert exact descriptor invocation count'
 llvm=[]
 for path in sorted(project.glob('peano-opted*.ll')):
  text=path.read_text();llvm.append(dict(file=identity(path),scalar_fadd_sites=len(re.findall(r'\bfadd float\b',text)),
   scalar_fmul_sites=len(re.findall(r'\bfmul float\b',text)),vector_float_arithmetic_sites=len(re.findall(r'\b(?:fadd|fmul|fdiv|fsub) <',text)),
   fma_intrinsic_sites=len(re.findall(r'@llvm\.(?:fma|fmuladd)',text)),scalar_float_load_sites=len(re.findall(r'load float',text)),scalar_float_store_sites=len(re.findall(r'store float',text))))
 objects=[];caseout=out/case['id'];caseout.mkdir()
 for i,path in enumerate(sorted(project.glob('objects_*/*.o'))):
  command=[str(objdump),'-dr',str(path)]
  result=subprocess.run(command,capture_output=True,text=True,check=True)
  saved=caseout/f'object-{i}.disassembly.txt';saved.write_text(result.stdout)
  objects.append(dict(file=identity(path),disassembly=identity(saved),command=command,
   soft_float_multiply_relocation_sites=len(re.findall(r'R_AIE_\d+\s+__mulsf3',result.stdout)),
   soft_float_add_relocation_sites=len(re.findall(r'R_AIE_\d+\s+__addsf3',result.stdout)),
   vector_float_add_instruction_sites=len(re.findall(r'\bvadd\.f\b',result.stdout)),
   vector_float_mac_instruction_sites=len(re.findall(r'\bv(?:mac|mul)\.f\b',result.stdout)),
   acquire_instruction_sites=len(re.findall(r'\bacq\b',result.stdout)),release_instruction_sites=len(re.findall(r'\brel\b',result.stdout))))
 return dict(id=case['id'],split=case['split'],candidate_id=case.get('candidate_id'),action_chain=case.get('action_chain'),
  files={k:identity(p) for k,p in dict(source=Path(case['prepared'])/'source.mlir',plan=root/'plan.json',compile=root/'hardware/compile.json',
   transformed=root/'transformed-taskflow.mlir',air=root/'program.air.mlir',aie=project/'aie.input.air.mlir',final_aie=project/'npu.input.air.mlir',elf=Path(compile['elf_path'])).items()},
  graph_id=plan['program_graph_id'],plan_id=plan['plan_id'],body_fingerprint=plan['body_fingerprint'],
  task_implementations=plan['task_implementations'],hardware_stages=plan['hardware_stages'],transfer_summary=plan['transfer_summary'],
  readonly_retentions=plan['readonly_retentions'],fused_initializer_tasks=plan['fused_initializer_tasks'],
  program_mapping_choices=plan['program_mapping_choices'],logical_scalar_reads=plan['logical_scalar_reads'],logical_scalar_writes=plan['logical_scalar_writes'],
  local_staging_copy_bytes=plan['local_staging_copy_bytes'],runtime_descriptor_payload_bytes=total_bytes,plan_bytes_equal=True,
  devices=devices,optimized_llvm=llvm,objects=objects)


def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--index',type=Path,action='append',required=True)
 p.add_argument('--output',type=Path,required=True)
 p.add_argument('--objdump',type=Path,default=Path('/home/shiran/project/aie-toy/.venv/lib/python3.12/site-packages/llvm-aie/bin/llvm-objdump'));a=p.parse_args()
 a.output.mkdir(parents=True,exist_ok=False)
 cases=[c for index in a.index for c in json.loads(index.read_text())['cases']]
 assert len(set(c['id'] for c in cases))==len(cases)
 records=[inventory(c,a.output,a.objdump) for c in cases]
 report=dict(schema='orbit.program-implementation-audit.v16',observer=identity(__file__),objdump=identity(a.objdump),indices=[identity(x) for x in a.index],
  device_opened=False,device_submissions=0,builds=0,packages=records,
  scope='Static template/relocation inventory and exact current wrapper descriptor payload accounting. No silicon counters, dynamic instruction counts, device time, DDR bytes or overlap measurement.')
 (a.output/'inventory.json').write_text(json.dumps(report,indent=2)+'\n')
 print(json.dumps(dict(status='audited',packages=len(records),all_descriptor_bytes_match=True,device_submissions=0)))

if __name__=='__main__':main()
