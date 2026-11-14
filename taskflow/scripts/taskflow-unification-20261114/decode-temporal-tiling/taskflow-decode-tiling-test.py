#!/usr/bin/env python3
"""Compiler-only checks against a pinned actual full-decoder AIR emission."""
import argparse
import importlib.util
import json
from pathlib import Path
import tempfile

p = argparse.ArgumentParser()
p.add_argument('--original-dir', required=True, type=Path)
a = p.parse_args()
spec = importlib.util.spec_from_file_location(
    'decode_tiling', Path(__file__).with_name('taskflow-decode-tiling.py'))
adapter = importlib.util.module_from_spec(spec)
spec.loader.exec_module(adapter)
from air.ir import Context, Location, Module
from air.dialects import air, arith, scf, func, memref

source = (a.original_dir / 'source.air.mlir').read_text()
original_sha = adapter.digest(source.encode())
binding = adapter.source_binding(a.original_dir / 'source.air.mlir',
                                 a.original_dir / 'request.json', a.original_dir / 'emitted.json')
assert binding['layers'] == 36 and binding['vocab_waves'] == 25
request = json.loads((a.original_dir / 'request.json').read_text())
target = dict(target='npu2', columns=8, compute_row_start=2, compute_rows=4)
with Context(), Location.unknown():
    module = Module.parse(source)
    adapter.validate_full_qwen(module, request['length'])
    options = adapter.enumerate_loops(module)
weight = [choice for choice in options if choice['kind'] == 'temporal-tiling']
projection = [choice for choice in options if choice['kind'] == 'projection-kblock-temporal-tiling']
assert len(weight) == 4 and len(projection) == 2
assert all(choice['trip_counts'] == [8, 44] for choice in projection)

def ordered_events(operation, dynamic_count, env=None):
    """Independently execute the transformed loop bounds and event order."""
    env = {} if env is None else env
    def evaluate(value):
        if value in env:
            return env[value]
        fixed = adapter.integer(value)
        if fixed is not None:
            return fixed
        owner = value.owner
        name = getattr(owner, 'name', '')
        if name == 'arith.subi':
            return evaluate(owner.operands[0]) - evaluate(owner.operands[1])
        if name == 'arith.minsi':
            return min(evaluate(owner.operands[0]), evaluate(owner.operands[1]))
        values = adapter.finite_indices(value)
        if values and dynamic_count in values:
            return dynamic_count
        raise AssertionError('unexpected bound in actual transformed IR')
    if operation.name == 'scf.for':
        low, high, step = [evaluate(value) for value in operation.operands]
        result = []
        block = operation.regions[0].blocks[0]
        for value in range(low, high, step):
            nested = dict(env)
            nested[block.arguments[0]] = value
            for child in block.operations:
                result.extend(ordered_events(child.operation, dynamic_count, nested))
        return result
    if operation.name in ('air.channel.get', 'air.channel.put', 'func.call'):
        return [(operation.name,
                 tuple((name, str(operation.attributes[name])) for name in operation.attributes),
                 tuple(str(value.type) for value in operation.operands))]
    return []

for kind, choices, tiles in [('temporal-tiling', weight, (3, 5, 6, 10)),
                             ('projection-kblock-temporal-tiling', projection, (3, 5, 6, 9, 44))]:
    for choice in choices:
        for tile in tiles:
            text, proof = adapter.transform(source, choice['loop_ordinal'], tile, target, kind)
            assert adapter.verify_replay(source, text, choice['loop_ordinal'], tile, target, kind)
            assert text != source
            with Context(), Location.unknown():
                original = Module.parse(source)
                changed = Module.parse(text)
                before_loop = [op for op in adapter.walk(original.operation)
                               if op.name == 'scf.for'][choice['loop_ordinal']]
                after_loop = [op for op in adapter.walk(changed.operation)
                              if op.name == 'scf.for'][choice['loop_ordinal']]
                for count in proof.get('trip_counts', [600]):
                    assert ordered_events(before_loop, count) == ordered_events(after_loop, count)


def rejects(call):
    try:
        call()
    except ValueError:
        return
    raise AssertionError('unsupported transformation was accepted')

selected = projection[0]['loop_ordinal']
rejects(lambda: adapter.transform(source, selected, 0, target, 'projection-kblock-temporal-tiling'))
rejects(lambda: adapter.transform(source, selected, 45, target, 'projection-kblock-temporal-tiling'))
rejects(lambda: adapter.transform(source, 0, 3, target, 'projection-kblock-temporal-tiling'))
rejects(lambda: adapter.transform(source, weight[0]['loop_ordinal'], 7, target))
rejects(lambda: adapter.transform(source, selected, 3, dict(target, columns=1), 'projection-kblock-temporal-tiling'))
text, _ = adapter.transform(source, selected, 5, target, 'projection-kblock-temporal-tiling')
rejects(lambda: adapter.verify_replay(source, text.replace('air.channel @inW [4]', 'air.channel @inW [5]', 1),
                                    selected, 5, target, 'projection-kblock-temporal-tiling'))
# A source-bound receipt cannot be reused for changed input AIR.
with tempfile.TemporaryDirectory() as directory:
    changed = Path(directory) / 'changed.mlir'
    changed.write_text(source + '\n// changed source bytes\n')
    rejects(lambda: adapter.source_binding(changed, a.original_dir / 'request.json', a.original_dir / 'emitted.json'))
assert adapter.digest((a.original_dir / 'source.air.mlir').read_bytes()) == original_sha
print('full-Qwen AIR temporal weight/K-block tiling, tails, ABI and replay checks passed')
