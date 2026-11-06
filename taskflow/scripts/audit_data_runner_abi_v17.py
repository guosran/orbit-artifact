#!/usr/bin/env python3
"""Static ABI and unchanged bound-runner boundary inventory; opens no device."""
import argparse,ast,json,re
from pathlib import Path
from audit_program_implementation_v16 import identity,regions


def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--index',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
 a.output.mkdir(parents=True,exist_ok=False)
 runtime=Path('/home/shiran/project/aie-toy/.venv/lib/python3.12/site-packages/triton/backends/amd_triton_npu/multilaunch.py')
 tree=ast.parse(runtime.read_text());cls=next(n for n in tree.body if isinstance(n,ast.ClassDef) and n.name=='MultiLaunchRunner')
 method=next(n for n in cls.body if isinstance(n,ast.FunctionDef) and n.name=='run')
 segment=ast.get_source_segment(runtime.read_text(),method)
 assert 'if i in bound:' in segment and 'results[idx] = a' in segment
 assert len(re.findall(r'\brun\.start\(',segment))==1 and len(re.findall(r'\b_wait\(run\)',segment))==1
 (a.output/'installed-bound-runner-source.py').write_text(segment+'\n')
 rows=[]
 for case in json.loads(a.index.read_text())['cases']:
  root=Path(case['compiled']);abi=json.loads((root/'abi.json').read_text());compile=json.loads((root/'hardware/compile.json').read_text())
  project=root/'hardware/air_project';full=json.loads((project/'full_elf_config.json').read_text());kernel,instance=compile['kernel_name'].split(':',1)
  main=next(k for k in full['xrt-kernels'] if k['name']==kernel)
  assert any(x['id']==instance for x in main['instance'])
  argc=len(abi['buffers']);assert len(main['arguments'])==compile['argument_count']==max(3,argc)
  assert all(arg['type']=='char *' and arg['name']==f'arg_{i}' and int(arg['offset'],16)==8*i for i,arg in enumerate(main['arguments']))
  text=(project/'npu.input.air.mlir').read_text();sequences=[]
  expected=[f'memref<{"x".join(map(str,b["shape"]))}xf32>' for b in abi['buffers']]
  for m,body,_ in regions(text,r'aie\.runtime_sequence @([\w.$]+)\(([^\n]*)\)\s*\{'):
   types=re.findall(r'%arg\d+: (memref<[^>]+>)',m[2]);assert types==expected,(case['id'],m[1],types,expected)
   used=[int(x) for x in re.findall(r'%arg(\d+)\b',body)]
   assert all(x<argc for x in used)
   for run in re.findall(r'aiex\.run @[^\n]+',body):assert len(re.findall(r'%arg\d+\b',run.split(':')[0]))==argc
   sequences.append(dict(name=m[1],logical_argument_types=types,used_argument_indices=sorted(set(used))))
  input_bytes=sum(4*int_product(b['shape']) for b in abi['buffers'] if b['role']=='input')
  poisoned_bytes=sum(4*int_product(b['shape']) for b in abi['buffers'] if b['role']!='input')
  out_bytes=sum(4*int_product(b['shape']) for b in abi['buffers'] if b['role']=='output')
  rows.append(dict(id=case['id'],abi=identity(root/'abi.json'),elf=identity(compile['elf_path']),full_elf_config=identity(project/'full_elf_config.json'),final_aie=identity(project/'npu.input.air.mlir'),
   logical_BO_count=argc,BO_names=[b['name'] for b in abi['buffers']],ELF_pointer_metadata_count=len(main['arguments']),unused_minimum_pointer_padding=len(main['arguments'])-argc,
   runtime_sequences=sequences,host_calls_per_invocation=dict(TO_sync=argc,FROM_sync=len(abi['outputs']),xrt_run_constructor=1,set_arg=argc,start=1,successful_wait=1,
    extra_staging_memcpy=0,runner_BO_allocation=0),
   outside_runner_timer=dict(mapped_input_reset_bytes=input_bytes,output_and_temporary_poison_bytes=poisoned_bytes,output_snapshot_copy_bytes=out_bytes,
    fixture_generation_reference_generation_and_npz_IO='excluded',context_and_BO_preparation='excluded'),
   scope='Host API count/source-path proof. No physical cache/DDR byte or pure DMA-time claim. Actual records must confirm counts and alias pointers.'))
 report=dict(schema='orbit.data-organization.runner-abi-audit.v17',source=identity(__file__),runtime=identity(runtime),
  v16_runner=identity(Path(__file__).with_name('taskflow_program_probe_v16.py')),v17_adapter=identity(Path(__file__).with_name('taskflow_data_probe_v17.py')),
  index=identity(a.index),packages=rows,device_submissions=0)
 (a.output/'inventory.json').write_text(json.dumps(report,indent=2)+'\n')
 print(json.dumps(dict(status='passed',packages=len(rows),device_submissions=0)))


def int_product(shape):
 value=1
 for x in shape:value*=x
 return value

if __name__=='__main__':main()
