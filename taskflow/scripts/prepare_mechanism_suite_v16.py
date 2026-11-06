#!/usr/bin/env python3
"""Prepare/compile predeclared v16 mechanisms, without opening the NPU."""
import argparse,json,subprocess,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
CASES=[
 ('train','copy2048c128','copy',1,32,2048,0,[1,128]),
 ('train','copy8192c128','copy',1,32,8192,0,[1,128]),
 ('train','copy8192c512','copy',1,32,8192,0,[1,512]),
 ('train','add32-e8192c512','elementwise',1,32,8192,32,[1,512]),
 ('train','gemm8k32n16','gemm',8,32,16,0,[4,16,16]),
 ('train','gemm16k64n16','gemm',16,64,16,0,[8,16,16]),
 ('train','gemm16k128n32','gemm',16,128,32,0,[4,16,16]),
 ('train','fanout8n64','fanout',8,32,64,0,[4,32]),
 ('holdout','copy3072c256','copy',1,32,3072,0,[1,256]),
 ('holdout','copy12288c1024','copy',1,32,12288,0,[1,1024]),
 ('holdout','add16-e12288c512','elementwise',1,32,12288,16,[1,512]),
 ('holdout','gemm12k96n24','gemm',12,96,24,0,[4,8,16]),
 ('holdout','fanout16n96','fanout',16,32,96,0,[4,32])]

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
 p.add_argument('--tool',type=Path,required=True);p.add_argument('--reuse',type=Path)
 a=p.parse_args();a.output=a.output.resolve();a.output.mkdir(parents=True,exist_ok=False)
 records=[]
 for split,name,kind,m,k,n,adds,tile in CASES:
  prepared=a.output/split/name/'input';compiled=a.output/split/name/'compiled'
  reuse_names={'gemm8k32n16':'gemm-m8k32n16','gemm16k64n16':'gemm-m16k64n16','fanout8n64':'fanout-m8n64'}
  if a.reuse and name in reuse_names:
   old=reuse_names[name];prepared=(a.reuse/'prepared-r1'/old).resolve();compiled=(a.reuse/'compiled-r2'/old).resolve()
  else:
   command=[sys.executable,str(ROOT/'taskflow/test/TaskflowAIR/prepare_mechanism_v16.py'),'--kind',kind,'--m',str(m),'--k',str(k),'--n',str(n),'--adds',str(adds),'--tile',*map(str,tile),'--output',str(prepared)]
   subprocess.run(command,check=True)
   command=['bash',str(ROOT/'taskflow/scripts/run_taskflow_direct_air_v6_case.sh'),'--compile-only','--runtime-transfer-audit','--tool',str(a.tool.resolve()),'--target-config',str(prepared/'config.json'),'--input',str(prepared),'--output',str(compiled)]
   if kind=='gemm':command+=['--distribute-initialization']
   subprocess.run(command,check=True)
  records.append(dict(split=split,id=name,prepared=str(prepared),compiled=str(compiled)))
  (a.output/'index.json').write_text(json.dumps(dict(schema='orbit.mechanism.prepared-suite.v16',device_submissions=0,cases=records),indent=2)+'\n')
  print(json.dumps(dict(id=name,status='compiled',split=split)),flush=True)

if __name__=='__main__':main()
