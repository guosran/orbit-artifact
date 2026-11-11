#!/usr/bin/env python3
"""Arithmetic inputs and independent numerical oracles, never production plans."""
import argparse
import hashlib
import json
from pathlib import Path

import numpy as np

PROGRAMS = {
    'interleaved': dict(inputs=['A', 'D'], outputs=['O', 'H'], steps=[
        ('X', 'add', ['A'], 1.), ('V', 'mul', ['D'], 2.),
        ('Y', 'add', ['X', 'A'], None), ('Z', 'sub', ['X'], 1.),
        ('O', 'add', ['Y', 'Z'], None), ('H', 'add', ['V'], 3.)]),
    'shared-input': dict(inputs=['A', 'D'], outputs=['O', 'U'], steps=[
        ('Y', 'add', ['A'], 1.), ('U', 'add', ['D'], 3.),
        ('Z', 'mul', ['A'], 2.), ('O', 'add', ['Y', 'Z'], None)]),
    'coupling': dict(inputs=['A', 'D'], outputs=['O', 'H'], steps=[
        ('X', 'add', ['A'], 1.), ('V', 'mul', ['D'], 2.),
        ('Y', 'mul', ['X'], 2.), ('Z', 'add', ['Y', 'A'], None),
        ('R', 'sub', ['X'], 1.), ('O', 'add', ['Z', 'R'], None),
        ('H', 'add', ['V'], 3.)]),
}


def inputs_and_references(fixture, seed, repeat):
    m, n = fixture['m'], fixture['n']
    rng = np.random.default_rng(np.random.SeedSequence([seed, repeat, m, n]))
    inputs = {key: rng.uniform(-.5, .5, (m, n)).astype(np.float32)
              for key in fixture['inputs']}
    strict = dict(inputs)
    exact = {key: value.astype(np.float64) for key, value in inputs.items()}
    for out, op, ins, constant in fixture['steps']:
        function = {'add': np.add, 'mul': np.multiply, 'sub': np.subtract}[op]
        strict[out] = function(strict[ins[0]].astype(np.float64),
                               float(constant) if constant is not None
                               else strict[ins[1]].astype(np.float64)).astype(np.float32)
        exact[out] = function(exact[ins[0]], float(constant) if constant is not None
                              else exact[ins[1]])
    return inputs, {key: strict[key] for key in fixture['outputs']}, {
        key: exact[key] for key in fixture['outputs']}


def source(fixture, permuted=False):
    m, n = fixture['m'], fixture['n']
    ty = f'memref<{m}x{n}xf32>'
    args = ','.join(f'%{key}: {ty} {{orbit.role="{role}",orbit.name="{key}"}}'
                    for role in ['input', 'output']
                    for key in fixture[role+'s'])
    lines = ['module {', f' func.func @data_reuse(%s) attributes {{orbit.noalias,llvm.emit_c_interface}} {{' % args]
    temporaries = [s[0] for s in fixture['steps'] if s[0] not in fixture['outputs']]
    lines += [f'  %{key}=memref.alloc() {{orbit.name="{key}"}} : {ty}' for key in temporaries]
    values = {key: '%'+key for key in fixture['inputs']}
    steps = list(fixture['steps'])
    if permuted:
        # Independent task moves; arithmetic/data edges are identical.
        steps.insert(0, steps.pop(1))
    for out, op, ins, constant in steps:
        reads = ','.join(values[key] for key in ins)
        types = ','.join([ty]*len(ins))
        bodyargs = ','.join(f'%r{i}: {ty}' for i in range(len(ins)))
        lines += [f'  %done_{out}=taskflow.task @write_{out} will_reads({reads} : {types}) will_writes(%{out} : {ty}) [original_read_memrefs({reads} : {types}),original_write_memrefs(%{out} : {ty})] : ({types},{ty})->{ty} {{',
                  f'  ^bb0({bodyargs},%dst: {ty}):',
                  f'   affine.for %i=0 to {m} {{', f'    affine.for %j=0 to {n} {{']
        lines += [f'     %v{i}=affine.load %r{i}[%i,%j] : {ty}' for i in range(len(ins))]
        if constant is not None:
            lines += [f'     %c=arith.constant {constant:.6f} : f32']
        rhs = '%c' if constant is not None else '%v1'
        lines += [f'     %v=arith.{op}f %v0,{rhs} : f32',
                  f'     affine.store %v,%dst[%i,%j] : {ty}', '    }', '   }',
                  f'   taskflow.yield done_writes(%dst : {ty})', '  }']
        values[out] = '%done_'+out
    lines += [f'  memref.dealloc %{key} : {ty}' for key in temporaries]
    return '\n'.join(lines+['  return', ' }', '}'])+'\n'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--kind', choices=PROGRAMS, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=False)
    fixture = dict(PROGRAMS[args.kind], kind=args.kind,
                   m=23 if args.kind == 'coupling' else 17,
                   n=152 if args.kind == 'coupling' else 136)
    for name, permuted in [('source.mlir', False), ('permuted.mlir', True)]:
        (args.output/name).write_text(source(fixture, permuted))
    for seed in [11, 23, 47]:
        inputs, strict, exact = inputs_and_references(fixture, seed, 0)
        for prefix, arrays in [('inputs', inputs), ('reference', strict), ('reference-f64', exact)]:
            np.savez(args.output/f'{prefix}-{seed}.npz', **arrays)
    sha = lambda path: hashlib.sha256(Path(path).read_bytes()).hexdigest()
    (args.output/'fixture.json').write_text(json.dumps(dict(
        schema='orbit.data-reuse.fixture.v21', fixture=fixture,
        source_sha256=sha(args.output/'source.mlir'), generator_sha256=sha(__file__),
        reference='Source-rounded FP32 and unrounded FP64; finite atol=rtol=1e-5',
        decisions='Computation only; C++ owns candidate discovery, legality, mapping and scoring'), indent=2)+'\n')
    print(json.dumps(dict(status='prepared', output=str(args.output), device_submissions=0)))


if __name__ == '__main__':
    main()
