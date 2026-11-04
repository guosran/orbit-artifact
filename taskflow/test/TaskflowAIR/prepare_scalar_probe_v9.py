#!/usr/bin/env python3
"""Same access/loop/FP32 fixture, differing only in runtime add vs multiply."""
import argparse
import json
from pathlib import Path
import numpy as np
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--output',type=Path,required=True)
p.add_argument('--elements',type=int,default=1024)
a=p.parse_args()
if a.elements<=0:p.error('positive extent required')
a.output.mkdir(parents=True,exist_ok=False)
for op in ['addf','mulf']:
 d=a.output/op;d.mkdir()
 text=f'''module {{
  func.func @probe(%A: memref<1x{a.elements}xf32> {{orbit.role = "input", orbit.name = "A"}}, %B: memref<1x{a.elements}xf32> {{orbit.role = "input", orbit.name = "B"}}, %C: memref<1x{a.elements}xf32> {{orbit.role = "output", orbit.name = "C"}}) attributes {{orbit.noalias, llvm.emit_c_interface}} {{
    %done = taskflow.task @elementwise will_reads(%A, %B : memref<1x{a.elements}xf32>, memref<1x{a.elements}xf32>) will_writes(%C : memref<1x{a.elements}xf32>) [original_read_memrefs(%A, %B : memref<1x{a.elements}xf32>, memref<1x{a.elements}xf32>), original_write_memrefs(%C : memref<1x{a.elements}xf32>)] : (memref<1x{a.elements}xf32>, memref<1x{a.elements}xf32>, memref<1x{a.elements}xf32>) -> memref<1x{a.elements}xf32> {{
    ^bb0(%a: memref<1x{a.elements}xf32>, %b: memref<1x{a.elements}xf32>, %c: memref<1x{a.elements}xf32>):
      affine.for %i = 0 to 1 {{
        affine.for %j = 0 to {a.elements} {{
          %x = affine.load %a[%i, %j] : memref<1x{a.elements}xf32>
          %y = affine.load %b[%i, %j] : memref<1x{a.elements}xf32>
          %z = arith.{op} %x, %y : f32
          affine.store %z, %c[%i, %j] : memref<1x{a.elements}xf32>
        }}
      }}
      taskflow.yield done_writes(%c : memref<1x{a.elements}xf32>)
    }}
    return
  }}
}}
'''
 (d/'source.mlir').write_text(text)
 for seed in [11,23,47]:
  rng=np.random.default_rng(seed)
  x=rng.uniform(-.5,.5,(1,a.elements)).astype(np.float32);y=rng.uniform(-.5,.5,x.shape).astype(np.float32)
  x.flat[0]=y.flat[0]=0
  z=x.astype(np.float64)+y.astype(np.float64) if op=='addf' else x.astype(np.float64)*y.astype(np.float64)
  np.savez(d/f'inputs-{seed}.npz',A=x,B=y);np.savez(d/f'reference-{seed}.npz',C=z.astype(np.float32))
 (d/'target.json').write_text(json.dumps({'generic_air':{'tile_sizes':[1,a.elements]}})+'\n')
