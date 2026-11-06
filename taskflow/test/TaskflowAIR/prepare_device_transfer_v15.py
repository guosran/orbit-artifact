#!/usr/bin/env python3
"""Numerical/MLIR fixture only; tile planning remains native C++."""
import argparse
import hashlib
import json
from pathlib import Path
import numpy as np

CONSTANTS=(.03125,.0625,-.015625,.0078125)

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def source(rows,columns,adds):
    ty=f'memref<{rows}x{columns}xf32>'
    constants='\n'.join(f'      %c{k} = arith.constant {x:.10f} : f32' for k,x in enumerate(CONSTANTS[:adds]))
    ops='\n'.join(f'          %v{k} = arith.addf '+('%x' if k==0 else f'%v{k-1}')+f', %c{k} : f32' for k in range(adds))
    value=f'%v{adds-1}' if adds else '%x'
    return f'''module {{
  func.func @main(%A: {ty} {{orbit.role = "input", orbit.name = "A"}}, %C: {ty} {{orbit.role = "output", orbit.name = "C"}}) attributes {{orbit.noalias, llvm.emit_c_interface}} {{
    %done = taskflow.task @copy will_reads(%A : {ty}) will_writes(%C : {ty}) [original_read_memrefs(%A : {ty}), original_write_memrefs(%C : {ty})] : ({ty}, {ty}) -> {ty} {{
    ^bb0(%a: {ty}, %c: {ty}):
{constants}
      affine.for %i = 0 to {rows} {{
        affine.for %j = 0 to {columns} {{
          %x = affine.load %a[%i, %j] : {ty}
{ops}
          affine.store {value}, %c[%i, %j] : {ty}
        }}
      }}
      taskflow.yield done_writes(%c : {ty})
    }}
    return
  }}
}}
'''

def input_values(rows,columns,seed,repeat):
    # Every block and element varies; callers regenerate outside timed intervals.
    rng=np.random.default_rng(np.random.SeedSequence([seed,repeat,rows,columns]))
    return np.ascontiguousarray(rng.uniform(-.5,.5,(rows,columns)).astype(np.float32)+np.arange(rows,dtype=np.float32)[:,None]*np.float32(.03125))

def references(a,adds):
    exact=a.astype(np.float64);strict=a.copy()
    for c in CONSTANTS[:adds]:
        exact=exact+float(c)
        strict=(strict.astype(np.float64)+float(np.float32(c))).astype(np.float32)
    return strict,exact

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--elements',type=int,required=True);p.add_argument('--chunk',type=int,required=True);p.add_argument('--adds',type=int,choices=(0,4),default=0);p.add_argument('--output',type=Path,required=True)
    a=p.parse_args();assert a.elements>0 and a.chunk>0 and a.chunk%16==0 and a.elements%a.chunk==0
    a.rows=1;a.columns=a.elements
    assert not a.output.exists();a.output.mkdir(parents=True)
    (a.output/'source.mlir').write_text(source(a.rows,a.columns,a.adds))
    (a.output/'config.json').write_text(json.dumps({'generic_air':{'tile_sizes':[1,a.chunk]}},indent=2)+'\n')
    files={}
    for seed in (11,23,47):
        value=input_values(a.rows,a.columns,seed,0);strict,exact=references(value,a.adds)
        np.savez(a.output/f'inputs-{seed}.npz',A=value)
        np.savez(a.output/f'reference-{seed}.npz',C=strict)
        np.savez(a.output/f'reference-f64-{seed}.npz',C=exact)
    for f in a.output.iterdir():files[f.name]=sha(f)
    (a.output/'fixture.json').write_text(json.dumps({'schema':'orbit.device-transfer.fixture.v15','fixture':{'elements':a.elements,'chunk':a.chunk,'adds':a.adds},'input_bytes':4*a.rows*a.columns,'output_bytes':4*a.rows*a.columns,'expected_float_adds':a.adds*a.rows*a.columns,'configured_tile':[1,a.chunk],'scope':'source fixture facts only; native plan must independently establish physical DMA stages and sizes','files':files,'generator_sha256':sha(__file__)},indent=2)+'\n')

if __name__=='__main__':main()
