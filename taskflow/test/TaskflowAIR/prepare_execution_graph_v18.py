#!/usr/bin/env python3
"""Plain computed diamond and source-ordered references; no mapping/lowering.

X=A+1; B=X+2; C=X+X. Source has no artificial ordering-only barrier.
"""
import argparse,hashlib,json
from pathlib import Path
import numpy as np


def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def source(m,n):
 ty=f'memref<{m}x{n}xf32>';tasks=[]
 for name,input_name,output_name,constant in [('produce','A','X',1),('first','xd','B',2),('second','xd','C',None)]:
  token={'produce':'xd','first':'bd','second':'cd'}[name]
  arithmetic=('%bias=arith.constant '+str(constant)+'.0 : f32\n     %result=arith.addf %v,%bias : f32') if constant else '%result=arith.addf %v,%v : f32'
  tasks.append(f'''  %{token}=taskflow.task @{name} will_reads(%{input_name} : {ty}) will_writes(%{output_name} : {ty}) [original_read_memrefs(%{input_name} : {ty}),original_write_memrefs(%{output_name} : {ty})] : ({ty},{ty})->{ty} {{
  ^bb0(%in: {ty},%out: {ty}):
   affine.for %i=0 to {m} {{
    affine.for %j=0 to {n} {{
     %v=affine.load %in[%i,%j] : {ty}
     {arithmetic}
     affine.store %result,%out[%i,%j] : {ty}
    }}
   }}
   taskflow.yield done_writes(%out : {ty})
  }}''')
 return f'''module {{
 func.func @diamond(%A: {ty} {{orbit.role="input",orbit.name="A"}},%B: {ty} {{orbit.role="output",orbit.name="B"}},%C: {ty} {{orbit.role="output",orbit.name="C"}}) attributes {{orbit.noalias,llvm.emit_c_interface}} {{
  %X=memref.alloc() {{orbit.name="X"}} : {ty}
'''+ '\n'.join(tasks)+f'''
  memref.dealloc %X : {ty}
  return
 }}
}}
'''


def inputs_and_references(fixture,seed,repeat):
 assert fixture['kind']=='diamond'
 m,n=fixture['m'],fixture['n'];rng=np.random.default_rng(np.random.SeedSequence([seed,repeat,m,n]))
 a=rng.uniform(-.5,.5,(m,n)).astype(np.float32)
 # Round each real source operation; unrounded equations are independent views.
 x=(a.astype(np.float64)+1).astype(np.float32)
 b=(x.astype(np.float64)+2).astype(np.float32)
 c=(x.astype(np.float64)+x.astype(np.float64)).astype(np.float32)
 x64=a.astype(np.float64)+1
 return dict(A=a),dict(B=b,C=c),dict(B=x64+2,C=x64+x64)


def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--m',type=int,default=64);p.add_argument('--n',type=int,default=128);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
 assert a.m>0 and a.n>0;a.output.mkdir(parents=True,exist_ok=False)
 (a.output/'source.mlir').write_text(source(a.m,a.n));fixture=dict(kind='diamond',m=a.m,n=a.n,scalar_addsub=3*a.m*a.n,scalar_products=0)
 for seed in [11,23,47]:
  inputs,strict,exact=inputs_and_references(fixture,seed,0)
  np.savez(a.output/f'inputs-{seed}.npz',**inputs);np.savez(a.output/f'reference-{seed}.npz',**strict);np.savez(a.output/f'reference-f64-{seed}.npz',**exact)
 (a.output/'fixture.json').write_text(json.dumps(dict(schema='orbit.execution-graph.fixture.v18',fixture=fixture,source_sha256=sha(a.output/'source.mlir'),generator_sha256=sha(__file__),
  source_tasks=['produce','first','second'],source_dependencies=[[],[0],[0]],
  total_array_payload_bytes=16*a.m*a.n,source_decisions='computation only; no source mapping attributes; no ordering-only dependency',
  reference='strict f32 source-order intermediate rounding plus unrounded f64 equations'),indent=2)+'\n')
 print(json.dumps(dict(status='prepared',output=str(a.output),device_submissions=0)))

if __name__=='__main__':main()
