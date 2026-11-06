#!/usr/bin/env python3
"""Prepare plain three-task CPU/NPU source and independent FP64 references.

This creates numerical fixtures only. It does not choose placements, execution
regions, transfers, resource mappings, search rankings or model parameters.
The default size split is a proposal until the experiment protocol is frozen.
"""
import argparse
import hashlib
import json
from pathlib import Path


def source_text(m, n):
    template = '''module {
  func.func @main(%A: memref<@Mx@Nxf32> {orbit.role = "input", orbit.name = "A"}, %B: memref<@Mx@Nxf32> {orbit.role = "input", orbit.name = "B"}, %C: memref<@Mx@Nxf32> {orbit.role = "output", orbit.name = "C"}) attributes {orbit.noalias, llvm.emit_c_interface} {
    %T = memref.alloc() {orbit.name = "T"} : memref<@Mx@Nxf32>
    %U = memref.alloc() {orbit.name = "U"} : memref<@Mx@Nxf32>
    %T_done = taskflow.task @add will_reads(%A, %B : memref<@Mx@Nxf32>, memref<@Mx@Nxf32>) will_writes(%T : memref<@Mx@Nxf32>) [original_read_memrefs(%A, %B : memref<@Mx@Nxf32>, memref<@Mx@Nxf32>), original_write_memrefs(%T : memref<@Mx@Nxf32>)] : (memref<@Mx@Nxf32>, memref<@Mx@Nxf32>, memref<@Mx@Nxf32>) -> memref<@Mx@Nxf32> {
    ^bb0(%a: memref<@Mx@Nxf32>, %b: memref<@Mx@Nxf32>, %t: memref<@Mx@Nxf32>):
      affine.for %i = 0 to @M {
        affine.for %j = 0 to @N {
          %x = affine.load %a[%i, %j] : memref<@Mx@Nxf32>
          %y = affine.load %b[%i, %j] : memref<@Mx@Nxf32>
          %sum = arith.addf %x, %y : f32
          affine.store %sum, %t[%i, %j] : memref<@Mx@Nxf32>
        }
      }
      taskflow.yield done_writes(%t : memref<@Mx@Nxf32>)
    }
    %U_done = taskflow.task @scale will_reads(%T_done : memref<@Mx@Nxf32>) will_writes(%U : memref<@Mx@Nxf32>) [original_read_memrefs(%T_done : memref<@Mx@Nxf32>), original_write_memrefs(%U : memref<@Mx@Nxf32>)] : (memref<@Mx@Nxf32>, memref<@Mx@Nxf32>) -> memref<@Mx@Nxf32> {
    ^bb0(%t: memref<@Mx@Nxf32>, %u: memref<@Mx@Nxf32>):
      %two = arith.constant 2.0 : f32
      affine.for %i = 0 to @M {
        affine.for %j = 0 to @N {
          %x = affine.load %t[%i, %j] : memref<@Mx@Nxf32>
          %scaled = arith.mulf %x, %two : f32
          affine.store %scaled, %u[%i, %j] : memref<@Mx@Nxf32>
        }
      }
      taskflow.yield done_writes(%u : memref<@Mx@Nxf32>)
    }
    %C_done = taskflow.task @add_reuse will_reads(%U_done, %B : memref<@Mx@Nxf32>, memref<@Mx@Nxf32>) will_writes(%C : memref<@Mx@Nxf32>) [original_read_memrefs(%U_done, %B : memref<@Mx@Nxf32>, memref<@Mx@Nxf32>), original_write_memrefs(%C : memref<@Mx@Nxf32>)] : (memref<@Mx@Nxf32>, memref<@Mx@Nxf32>, memref<@Mx@Nxf32>) -> memref<@Mx@Nxf32> {
    ^bb0(%u: memref<@Mx@Nxf32>, %b: memref<@Mx@Nxf32>, %c: memref<@Mx@Nxf32>):
      affine.for %i = 0 to @M {
        affine.for %j = 0 to @N {
          %x = affine.load %u[%i, %j] : memref<@Mx@Nxf32>
          %y = affine.load %b[%i, %j] : memref<@Mx@Nxf32>
          %sum = arith.addf %x, %y : f32
          affine.store %sum, %c[%i, %j] : memref<@Mx@Nxf32>
        }
      }
      taskflow.yield done_writes(%c : memref<@Mx@Nxf32>)
    }
    memref.dealloc %U : memref<@Mx@Nxf32>
    memref.dealloc %T : memref<@Mx@Nxf32>
    return
  }
}
'''
    return template.replace('@M', str(m)).replace('@N', str(n))


def shape(value):
    try:
        m, n = map(int, value.lower().split('x'))
        if m <= 0 or n <= 0:
            raise ValueError()
        return m, n
    except ValueError:
        raise argparse.ArgumentTypeError('shape must be positive MxN')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--train-shapes', type=shape, nargs='+', default=[(4,64),(16,64)])
    parser.add_argument('--holdout-shapes', type=shape, nargs='+', default=[(7,80),(9,96)])
    parser.add_argument('--capacity-rejection-shapes', type=shape, nargs='*', default=[(32,64)], help='source-valid negative fixtures, excluded from legal model holdouts')
    parser.add_argument('--freeze-protocol', action='store_true', help='freeze this static dataset before any timing labels')
    parser.add_argument('--seeds', type=int, nargs='+', default=[11,23,47])
    args = parser.parse_args()
    import numpy as np
    assert not set(args.train_shapes) & set(args.holdout_shapes), 'training/holdout shapes overlap'
    all_shapes=args.train_shapes+args.holdout_shapes+args.capacity_rejection_shapes
    assert len(set(all_shapes)) == len(all_shapes)
    assert len(set(args.seeds)) == len(args.seeds)
    out = args.output.resolve()
    out.mkdir(parents=True,exist_ok=False)
    digest = lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
    (out/'generator-source.py').write_bytes(Path(__file__).read_bytes())
    cases = []
    for split, shapes in [('training',args.train_shapes),('holdout',args.holdout_shapes),('capacity-rejection',args.capacity_rejection_shapes)]:
        for m,n in shapes:
            name = f'm{m}-n{n}'
            folder = out/name
            folder.mkdir()
            source = folder/'source.mlir'
            source.write_text(source_text(m,n))
            arrays = []
            for seed in args.seeds:
                rng = np.random.default_rng(seed)
                a = rng.uniform(-.75,.75,(m,n)).astype(np.float32)
                b = rng.uniform(-.75,.75,(m,n)).astype(np.float32)
                a.flat[::17]=0
                b.flat[::19]=0
                if m*n >= 4:
                    a.flat[:4]=[-.5,0,.25,-.75]
                    b.flat[:4]=[.5,-.25,0,.25]
                t = a.astype(np.float64)+b.astype(np.float64)
                u = 2*t
                c = u+b.astype(np.float64)
                inputs, reference, intermediate = folder/f'inputs-{seed}.npz',folder/f'reference-{seed}.npz',folder/f'intermediates-reference-{seed}.npz'
                np.savez(inputs,A=a,B=b)
                np.savez(reference,C=c.astype(np.float32))
                np.savez(intermediate,T=t.astype(np.float32),U=u.astype(np.float32))
                arrays.append(dict(seed=seed,**{kind:dict(path=str(path.relative_to(out)),sha256=digest(path)) for kind,path in [('inputs',inputs),('reference',reference),('intermediate_reference',intermediate)]}))
            cases.append(dict(name=name,split=split,shape=[m,n],source=dict(path=str(source.relative_to(out)),sha256=digest(source)),arrays=arrays,
                expected_source_facts=dict(tasks=['add','scale','add_reuse'],storage_roles=dict(A='input',B='input',C='output',T='temporary',U='temporary'),task_dependencies=[[],[0],[1]],immutable_b_users=[0,2],scalar_arithmetic_operations=3*m*n,declared_storage_bytes=20*m*n,external_argument_bytes=12*m*n),
                scope='source facts expected from fixture, not an emitted target plan or physical traffic ledger',model_label_eligible=split!='capacity-rejection',capacity_negative_scope='full three-task resident NPU region under the first materialized-pool contract; not an all-CPU or fundamental mapping impossibility' if split=='capacity-rejection' else None))
    manifest = dict(schema='orbit.heterogeneous.fixtures.v13',split_status='frozen-before-timing-labels' if args.freeze_protocol else 'proposal-not-frozen',source_program='T=A+B;U=2*T;C=U+B',generator=dict(path=str(Path(__file__).resolve()),snapshot='generator-source.py',sha256=digest(Path(__file__))),cases=cases,seeds=args.seeds,
        numerical_contract=dict(dtype='f32',atol=1e-5,rtol=1e-5,finite=True,reference='independent float64 original whole-program formula, cast to f32; intermediate arrays are reference-only'),
        timing_labels_present=False,holdout_measurement_policy='requires separately frozen experiment/model protocol before timing labels are collected',
        production_planning=False,device_submissions=0,
        static_protocol=dict(training_shapes=[list(s) for s in args.train_shapes],holdout_shapes=[list(s) for s in args.holdout_shapes],capacity_rejection_shapes=[list(s) for s in args.capacity_rejection_shapes],seeds=args.seeds,region_group_lengths=[1,2,3],
            comparison_families=['full-CPU','full-NPU-region','mixed-placement','split-NPU-regions'],
            placement_and_region_plans='native C++ only; exact unseen placement choices frozen separately before labels',
            first_npu_capability='resident-only actual extracted regions; existing 24576-byte local tensor payload policy',
            cost_model='device-specific composite region wall; do not fit compute and bytes as separable collinear terms',
            region_wall_includes=['region dispatch','required BO synchronization','compiled CPU call or XRT start/wait','return of final mapped BO views'],
            region_wall_excludes=['input reset','whole-program coordination outside region','final output materialization copy'],
            whole_program_boundary_copy='separately measured and charged once',
            data_route='actual bound_buffers on shared system BO; alias only when actual mapping and visibility prove it; NPU sync/XRT stay inside regional label',
            holdout_policy='static dimensions and placement-combination validation; no holdout timing used for fit or protocol retuning',
            old_models='CGRA and earlier NPU models unchanged; no historical timing labels silently reused'))
    (out/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    print(json.dumps(dict(status='prepared',cases=len(cases),seeds=len(args.seeds),split_status=manifest['split_status'])))


if __name__ == '__main__':
    main()
