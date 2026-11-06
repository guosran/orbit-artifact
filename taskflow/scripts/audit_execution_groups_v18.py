#!/usr/bin/env python3
"""Read final AIE/LLVM/ABI evidence; no compiler or device is opened."""
import argparse,json,re
from pathlib import Path
from audit_program_implementation_v16 import identity
from audit_data_organization_deltas_v17 import audit


def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--index',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False);rows=[]
 for case in json.loads(a.index.read_text())['cases']:
  d=Path(case['compiled']);t=(d/'hardware/air_project/npu.input.air.mlir').read_text();ll=list((d/'hardware/air_project').glob('peano-opted*.ll'));physical=audit(case)
  row=dict(id=case['id'],physical=physical,source=identity(Path(case['prepared'])/'source.mlir'),final_aie=identity(d/'hardware/air_project/npu.input.air.mlir'),llvm=[identity(x) for x in ll],aie_static_addf=len(re.findall(r'\barith.addf\b',t)),llvm_template_ops={op:sum(len(re.findall(r'\b'+op+r'\b',x.read_text())) for x in ll) for op in ['fadd','fmul','load','store']},llvm_vector_float_ops=sum(len(re.findall(r'\b(?:fadd|fmul)\b[^\n]*<\d+ x float>',x.read_text())) for x in ll),x_local_view_buffers=re.findall(r'memref.reinterpret_cast (%[\w.]+)[^\n]*orbit.storage = "X"',t),actual_aie_buffer_payload_total_across_devices=sum(int(n)*4 for n in re.findall(r'aie.buffer[^\n]*memref<(\d+)xf32',t)),stack_sizes=re.findall(r'stack_size = (\d+)',t),output_awaits=len(re.findall(r'aiex.dma_await_task',t)))
  if len(physical['configure_calls'])==1 and 'X' not in physical['external_BOs']:
   assert len(row['x_local_view_buffers'])==3 and len(set(row['x_local_view_buffers']))==1
   assert row['aie_static_addf']==3 and row['llvm_template_ops']['fmul']==0 and row['llvm_vector_float_ops']==0
  rows.append(row)
 result=dict(schema='orbit.execution-group.implementation-audit.v18',observer=identity(__file__),source_index=identity(a.index),cases=rows,device_submissions=0,scope='Static templates, complete requested descriptor payload and cyclic-BD mapping. Not dynamic instruction, hardware transaction, clock or overlap measurement.')
 (a.output/'inventory.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(dict(status='audited',cases=len(rows),device_submissions=0)))

if __name__=='__main__':main()
