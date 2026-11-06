#!/usr/bin/env python3
"""Plain all-copy reuse fixtures and numerical references; no plan decisions.

C++ mapping/search must materialize residency and tiling in candidate source.
"""
import argparse,hashlib,json
from pathlib import Path
import numpy as np


def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def source(kind,m,n):
 ty=f'memref<{m}x{n}xf32>'
 if kind=='broadcast':
  inp=f'memref<1x{n}xf32>'
  return f'''module {{
 func.func @broadcast(%A: {inp} {{orbit.role="input",orbit.name="A"}}, %C: {ty} {{orbit.role="output",orbit.name="C"}}) attributes {{orbit.noalias,llvm.emit_c_interface}} {{
  %done=taskflow.task @broadcast will_reads(%A : {inp}) will_writes(%C : {ty}) [original_read_memrefs(%A : {inp}),original_write_memrefs(%C : {ty})] : ({inp},{ty})->{ty} {{
  ^bb0(%a: {inp},%c: {ty}):
   affine.for %i=0 to {m} {{
    affine.for %j=0 to {n} {{
     %v=affine.load %a[0,%j] : {inp}
     affine.store %v,%c[%i,%j] : {ty}
    }}
   }}
   taskflow.yield done_writes(%c : {ty})
  }}
  return
 }}
}}
'''
 assert kind=='fanout'
 tasks=[]
 for name,input_name,output_name in [('produce','A','X'),('first','xd','B'),('second','xd','C')]:
  token={'produce':'xd','first':'bd','second':'cd'}[name]
  tasks.append(f'''  %{token}=taskflow.task @{name} will_reads(%{input_name} : {ty}) will_writes(%{output_name} : {ty}) [original_read_memrefs(%{input_name} : {ty}),original_write_memrefs(%{output_name} : {ty})] : ({ty},{ty})->{ty} {{
  ^bb0(%in: {ty},%out: {ty}):
   affine.for %i=0 to {m} {{
    affine.for %j=0 to {n} {{
     %v=affine.load %in[%i,%j] : {ty}
     affine.store %v,%out[%i,%j] : {ty}
    }}
   }}
   taskflow.yield done_writes(%out : {ty})
  }}''')
 return f'''module {{
 func.func @fanout(%A: {ty} {{orbit.role="input",orbit.name="A"}},%B: {ty} {{orbit.role="output",orbit.name="B"}},%C: {ty} {{orbit.role="output",orbit.name="C"}}) attributes {{orbit.noalias,llvm.emit_c_interface}} {{
  %X=memref.alloc() {{orbit.name="X"}} : {ty}
'''+ '\n'.join(tasks)+f'''
  memref.dealloc %X : {ty}
  return
 }}
}}
'''


def inputs_and_references(fixture,seed,repeat):
 kind,m,n=(fixture[x] for x in ['kind','m','n'])
 rng=np.random.default_rng(np.random.SeedSequence([seed,repeat,m,n]))
 if kind=='broadcast':
  a=rng.uniform(-.5,.5,(1,n)).astype(np.float32)
  value=np.broadcast_to(a,(m,n)).copy();strict=dict(C=value)
 else:
  assert kind=='fanout';a=rng.uniform(-.5,.5,(m,n)).astype(np.float32)
  strict=dict(B=a.copy(),C=a.copy())
 return dict(A=a),strict,{k:v.astype(np.float64) for k,v in strict.items()}


def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--kind',choices=['broadcast','fanout'],required=True)
 p.add_argument('--m',type=int,required=True);p.add_argument('--n',type=int,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
 assert a.m>0 and a.n>0;a.output.mkdir(parents=True,exist_ok=False)
 (a.output/'source.mlir').write_text(source(a.kind,a.m,a.n))
 fixture=dict(kind=a.kind,m=a.m,n=a.n,scalar_products=0,scalar_addsub=0)
 for seed in [11,23,47]:
  inputs,strict,exact=inputs_and_references(fixture,seed,0)
  np.savez(a.output/f'inputs-{seed}.npz',**inputs)
  np.savez(a.output/f'reference-{seed}.npz',**strict)
  np.savez(a.output/f'reference-f64-{seed}.npz',**exact)
 metadata=dict(schema='orbit.data-organization.fixture.v17',fixture=fixture,source_sha256=sha(a.output/'source.mlir'),generator_sha256=sha(__file__),
  reference='exact identity/broadcast f32 copies with separate f64 views; zero arithmetic',scope='plain computation only; C++ owns copy lifetime, tiling and placement',
  files={p.name:sha(p) for p in sorted(a.output.iterdir()) if p.is_file()})
 (a.output/'fixture.json').write_text(json.dumps(metadata,indent=2)+'\n')
 print(json.dumps(dict(status='prepared',output=str(a.output),device_submissions=0)))

if __name__=='__main__':main()
