#!/usr/bin/env python3
"""Source-bound temporal tiling inside the original full-Qwen AIR decoder.

This initial adapter strip-mines projection weight-distribution loops. It does
not change Q4 tensor block sizes, kernel arithmetic, placement or host launches.
The ordered channel get/put sequence, allocation lifetimes and five-BO ABI are
preserved. Compilation/routing and board validation remain separate stages.
"""
import argparse
import hashlib
import json
import math
from pathlib import Path


def digest(data):
    return hashlib.sha256(data).hexdigest()


def canonical(value):
    return json.dumps(value, sort_keys=True, separators=(',', ':'), allow_nan=False).encode()


def walk(operation):
    yield operation
    for region in operation.regions:
        for block in region.blocks:
            for child in block.operations:
                yield from walk(child.operation)


def integer(value):
    from air.ir import IntegerAttr
    owner = value.owner
    if getattr(owner, 'name', '') != 'arith.constant' or 'value' not in owner.attributes:
        return None
    try:
        return IntegerAttr(owner.attributes['value']).value
    except (ValueError, TypeError):
        return None


def abi(module):
    result = []
    for op in module.body.operations:
        op = op.operation
        if op.name in ('func.func', 'air.channel'):
            result.append(dict(operation=op.name,
                               attributes={name: str(op.attributes[name]) for name in op.attributes}))
    return result


def eligible(loop):
    """Prove a repeated fixed projection DMA event sequence, not a recurrence."""
    if loop.name != 'scf.for' or len(loop.operands) != 3 or len(loop.results):
        return None
    block = loop.regions[0].blocks[0]
    if len(block.arguments) != 1 or list(block.arguments[0].uses):
        return None
    low, high, step = map(integer, loop.operands)
    if low != 0 or step != 1 or high is None or high < 3:
        return None
    allowed = {'arith.constant', 'memref.alloc', 'memref.dealloc',
               'air.channel.get', 'air.channel.put', 'scf.yield'}
    operations = [op.operation for op in block.operations]
    if any(op.name not in allowed or len(op.regions) or len(op.results) > 1
           for op in operations):
        return None
    events = []
    for op in operations:
        if op.name.startswith('air.channel.'):
            if 'chan_name' not in op.attributes:
                return None
            events.append((op.name, str(op.attributes['chan_name'])))
    # The existing source's projection W fanout: one fixed bundle per pass.
    # Restrict this first adapter to the known source-level communication ABI.
    gets = [name for kind, name in events if kind == 'air.channel.get']
    puts = [name for kind, name in events if kind == 'air.channel.put']
    if gets != ['@inW'] or not puts or any(name != '@wL2ToL1' for name in puts):
        return None
    return dict(iterations=high, ordered_events=events,
                projection_weight_distribution=True)


def finite_indices(value, active=None):
    """Finite source bounds through the builder's switches, not annotations."""
    active = set() if active is None else active
    if value in active:
        return None
    active = active | {value}
    fixed = integer(value)
    if fixed is not None:
        return {fixed}
    owner = value.owner
    name = getattr(owner, 'name', '')
    if name == 'affine.apply' and str(owner.attributes['map']) == 'affine_map<()[s0] -> (s0)>' and len(owner.operands) == 1:
        return finite_indices(owner.operands[0], active)
    if name in ('arith.muli', 'arith.addi'):
        left, right = [finite_indices(v, active) for v in owner.operands]
        if left is None or right is None or len(left) * len(right) > 256:
            return None
        values = {a * b if name == 'arith.muli' else a + b for a in left for b in right}
        return values if all(-(1 << 63) <= v < (1 << 63) for v in values) else None
    if name == 'scf.index_switch':
        position = next(i for i, result in enumerate(owner.results) if result == value)
        result = set()
        for region in owner.regions:
            if len(region.blocks) != 1:
                return None
            term = list(region.blocks[0].operations)[-1].operation
            if term.name != 'scf.yield' or position >= len(term.operands):
                return None
            values = finite_indices(term.operands[position], active)
            if values is None:
                return None
            result.update(values)
        return result if len(result) <= 256 else None
    return None


def projection_kloop(loop):
    if loop.name != 'scf.for' or len(loop.operands) != 3 or len(loop.results):
        return None
    block = loop.regions[0].blocks[0]
    if len(block.arguments) != 1 or list(block.arguments[0].uses):
        return None
    if integer(loop.operands[0]) != 0 or integer(loop.operands[2]) != 1:
        return None
    counts = finite_indices(loop.operands[1])
    if not counts or min(counts) < 1 or max(counts) > (1 << 63) - 2:
        return None
    allowed = {'arith.constant', 'affine.apply', 'memref.alloc', 'memref.dealloc',
               'air.channel.get', 'func.call', 'scf.yield'}
    operations = [child.operation for child in block.operations]
    if any(op.name not in allowed or len(op.regions) for op in operations):
        return None
    calls = [op for op in operations if op.name == 'func.call']
    channels = [str(op.attributes['chan_name']) for op in operations if op.name == 'air.channel.get']
    if len(calls) != 1 or str(calls[0].attributes['callee']) != '@proj_qmm_acc256' or channels != ['@inX', '@wL2ToL1']:
        return None
    if [str(value.type) for value in calls[0].operands] != [
            'memref<256xbf16, 2 : i32>', 'memref<2560xbf16, 2 : i32>',
            'memref<32xf32, 2 : i32>']:
        return None
    accumulation = calls[0].operands[2]
    siblings = [op.operation for op in loop.block.operations]
    at = siblings.index(loop)
    def has_call(sequence, symbol):
        return any(op.name == 'func.call' and str(op.attributes['callee']) == symbol
                   and any(v == accumulation for v in op.operands) for op in sequence)
    if not has_call(siblings[:at], '@proj_qmm_zero') or not has_call(siblings[at+1:], '@proj_qmm_flush_row'):
        return None
    return dict(trip_counts=sorted(counts), k_elements_per_iteration=256,
                accumulator_scope='outside transformed loop; original zero and flush retained',
                ordered_events=[('air.channel.get', '@inX'), ('air.channel.get', '@wL2ToL1'),
                                ('func.call', '@proj_qmm_acc256')])


def stripmine_projection_k(module, ordinal, tile):
    from air.ir import InsertionPoint, IndexType
    from air.dialects import arith, scf
    loops = [op for op in walk(module.operation) if op.name == 'scf.for']
    if type(ordinal) is not int or not 0 <= ordinal < len(loops):
        raise ValueError('projection loop ordinal is absent')
    loop = loops[ordinal]
    facts = projection_kloop(loop)
    if not facts or type(tile) is not int or not 2 <= tile <= max(facts['trip_counts']):
        raise ValueError('unproved projection K loop or tile outside the source domain')
    with InsertionPoint(loop):
        width = arith.ConstantOp(IndexType.get(), tile).result
        outer = scf.ForOp(loop.operands[0], loop.operands[1], width)
    with InsertionPoint(outer.body):
        remaining = arith.SubIOp(loop.operands[1], outer.induction_variable).result
        bounded = arith.MinSIOp(width, remaining).result
        inner = loop.clone()
        inner.operands[1] = bounded
        scf.YieldOp([])
    loop.erase()
    if not module.operation.verify():
        raise ValueError('projection K temporal tiling failed AIR verification')
    facts.update(loop_ordinal=ordinal, tile_k_blocks=tile, tile_k_elements=tile * 256,
                 proof='same channel/accumulate order; unchanged external accumulator; exact source-derived bounded tails')
    return facts


def enumerate_loops(module):
    result = []
    for ordinal, loop in enumerate(op for op in walk(module.operation) if op.name == 'scf.for'):
        facts = eligible(loop)
        if facts:
            facts['kind'] = 'temporal-tiling'
            extent = facts['iterations']
            divisors = set()
            for value in range(2, math.isqrt(extent) + 1):
                if extent % value == 0:
                    divisors.update((value, extent // value))
            facts.update(loop_ordinal=ordinal, tile_sizes=sorted(divisors - {extent}),
                         domain='all nontrivial exact divisors of source trip count',
                         arithmetic_reordering=False, tensor_block_tiling=False)
            result.append(facts)
        projection = projection_kloop(loop)
        if projection:
            projection.update(kind='projection-kblock-temporal-tiling', loop_ordinal=ordinal,
                              tile_size_min=2, tile_size_max=max(projection['trip_counts']),
                              domain='all integer K-block group sizes within the source bound; bounded tails')
            result.append(projection)
    return result


def validate_target(module, target):
    from air.ir import IntegerAttr
    required = {'target', 'columns', 'compute_row_start', 'compute_rows'}
    if set(target) != required or target['target'] != 'npu2':
        raise ValueError('require an explicit npu2 compute-array contract')
    if any(type(target[key]) is not int for key in required - {'target'}):
        raise ValueError('target geometry must contain integers')
    if target['columns'] <= 0 or target['compute_rows'] <= 0 or target['compute_row_start'] < 0:
        raise ValueError('target geometry is invalid')
    for op in walk(module.operation):
        if op.name != 'air.herd':
            continue
        if 'x_loc' not in op.attributes or 'y_loc' not in op.attributes:
            raise ValueError('source herd lacks actual placement')
        x = IntegerAttr(op.attributes['x_loc']).value
        y = IntegerAttr(op.attributes['y_loc']).value
        sizes = [integer(value) for value in op.opview.sizes]
        if len(sizes) != 2 or any(value is None or value <= 0 for value in sizes):
            raise ValueError('source herd has unknown shape')
        if not (0 <= x and x + sizes[0] <= target['columns'] and
                target['compute_row_start'] <= y and
                y + sizes[1] <= target['compute_row_start'] + target['compute_rows']):
            raise ValueError('source herd lies outside the configured target')


def stripmine(module, ordinal, tile):
    from air.ir import InsertionPoint, IndexType
    from air.dialects import arith, scf
    loops = [op for op in walk(module.operation) if op.name == 'scf.for']
    if type(ordinal) is not int or not 0 <= ordinal < len(loops):
        raise ValueError('loop ordinal is not present in the bound AIR source')
    loop = loops[ordinal]
    facts = eligible(loop)
    if not facts or type(tile) is not int or not 2 <= tile < facts['iterations'] or facts['iterations'] % tile:
        raise ValueError('unsupported projection temporal tile or unproved loop')
    extent = facts['iterations']
    # Clone the complete original loop to preserve internal SSA and memrefs.
    # No original induction value is used; changing its private repetition
    # bounds cannot change addresses, packet destinations or arithmetic.
    with InsertionPoint(loop):
        tile_value = arith.ConstantOp(IndexType.get(), tile).result
        outer_value = arith.ConstantOp(IndexType.get(), extent // tile).result
        outer = scf.ForOp(loop.operands[0], outer_value, loop.operands[2])
    with InsertionPoint(outer.body):
        inner = loop.clone()
        inner.operands[1] = tile_value
        scf.YieldOp([])
    loop.erase()
    if not module.operation.verify():
        raise ValueError('strip-mined AIR failed verification')
    return dict(loop_ordinal=ordinal, source_iterations=extent,
                outer_iterations=extent // tile, inner_iterations=tile,
                total_iterations=(extent // tile) * tile,
                ordered_events_per_iteration=facts['ordered_events'],
                proof='unused IV; no iterargs/results; identical cloned fixed-event body; exact trip product')


def source_binding(source, request, emitted):
    source = Path(source).resolve(strict=True)
    request = json.loads(Path(request).read_text())
    emitted = json.loads(Path(emitted).read_text())
    builder = Path(request['source']['path']).resolve(strict=True)
    source_hash = digest(source.read_bytes())
    if (request.get('layers'), request.get('vocab_waves')) != (36, 25):
        raise ValueError('require the complete original Qwen decoder and LM head')
    if digest(builder.read_bytes()) != request['source']['sha256']:
        raise ValueError('bound original decoder builder changed')
    if emitted['source_air']['sha256'] != source_hash:
        raise ValueError('AIR source differs from the actual emitted receipt')
    return dict(source_air_sha256=source_hash, builder_sha256=request['source']['sha256'],
                request_sha256=digest(canonical(request)), emitted_sha256=digest(canonical(emitted)),
                layers=36, vocab_waves=25)


def transform(source_text, loop_ordinal, tile, target, kind="temporal-tiling"):
    from air.ir import Context, Location, Module
    from air.dialects import air, arith, scf, func, memref  # register original dialects
    with Context(), Location.unknown():
        module = Module.parse(source_text)
        if not module.operation.verify():
            raise ValueError('original AIR verification failed')
        validate_target(module, target)
        before = abi(module)
        if kind == 'temporal-tiling':
            proof = stripmine(module, loop_ordinal, tile)
        elif kind == 'projection-kblock-temporal-tiling':
            proof = stripmine_projection_k(module, loop_ordinal, tile)
        else:
            raise ValueError('unsupported decode transformation: ' + kind)
        if abi(module) != before:
            raise ValueError('transformation changed channel declarations or function ABI')
        validate_target(module, target)
        return str(module), proof


def verify_replay(source_text, candidate_text, loop_ordinal, tile, target, kind):
    from air.ir import Context, Location, Module
    from air.dialects import air, arith, scf, func, memref
    expected, _ = transform(source_text, loop_ordinal, tile, target, kind)
    with Context(), Location.unknown():
        candidate = Module.parse(candidate_text)
        if not candidate.operation.verify() or str(candidate) != expected:
            raise ValueError('claimed AIR differs from deterministic original-source replay')
    return True


def validate_full_qwen(module, length):
    functions = [op.operation for op in module.body.operations
                 if op.operation.name == 'func.func' and
                 str(op.operation.attributes['sym_name']) == '"q4nx_decode"']
    if len(functions) != 1 or len(functions[0].regions[0].blocks) != 1:
        raise ValueError('full Qwen entry point is absent or ambiguous')
    function = functions[0]
    expected = [2048, 983040000, 246272, 158208, 144 * length * 128]
    if [str(value.type) for value in function.regions[0].blocks[0].arguments] != [
            f'memref<{extent}xbf16>' for extent in expected]:
        raise ValueError('original full-model five-BO interface changed')
    roots = [op.operation for op in function.regions[0].blocks[0].operations
             if op.operation.name == 'scf.for']
    if len(roots) != 1 or list(map(integer, roots[0].operands)) != [0, 61, 1]:
        raise ValueError('require the actual complete 36 decoder + 25 LM waves')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', required=True, type=Path)
    parser.add_argument('--request', required=True, type=Path)
    parser.add_argument('--emitted', required=True, type=Path)
    parser.add_argument('--target-contract', required=True, type=Path)
    parser.add_argument('--output', required=True, type=Path)
    parser.add_argument('--loop-ordinal', type=int)
    parser.add_argument('--tile-size', type=int)
    parser.add_argument('--kind', default='temporal-tiling')
    args = parser.parse_args()
    if args.kind not in ('temporal-tiling', 'projection-kblock-temporal-tiling'):
        raise ValueError('unsupported decode transform requires a separate ABI/dataflow proof: ' + args.kind)
    if (args.loop_ordinal is None) != (args.tile_size is None):
        raise ValueError('loop ordinal and tile size must be supplied together')
    binding = source_binding(args.source, args.request, args.emitted)
    target = json.loads(args.target_contract.read_text())
    text = args.source.read_text()
    from air.ir import Context, Location, Module
    from air.dialects import air, arith, scf, func, memref
    with Context(), Location.unknown():
        module = Module.parse(text)
        validate_target(module, target)
        request = json.loads(args.request.read_text())
        validate_full_qwen(module, request['length'])
        loops = enumerate_loops(module)
    report = dict(schema='orbit.taskflow.decode-temporal-tiling.v1', source_binding=binding,
                  target=target, target_id=digest(canonical(target)), loops=loops,
                  unsupported=['tensor-block-tiling', 'fusion', 'fission', 'replica', 'shape'],
                  compiled=False, executed=False, physical_hardware_measurement=False)
    transformed = None
    if args.loop_ordinal is not None:
        transformed, proof = transform(text, args.loop_ordinal, args.tile_size, target, args.kind)
        report.update(action=dict(kind=args.kind, loop_ordinal=args.loop_ordinal, tile_size=args.tile_size),
                      proof=proof, output_air_sha256=digest(transformed.encode()))
        # Independent deterministic replay starts from the bound original,
        # never from annotations on the claimed transformed program.
        verify_replay(text, transformed, args.loop_ordinal, args.tile_size, target, args.kind)
    args.output.mkdir(parents=True, exist_ok=False)
    if transformed is not None:
        (args.output / 'transformed.air.mlir').write_text(transformed)
    (args.output / 'report.json').write_text(json.dumps(report, indent=2) + '\n')


if __name__ == '__main__':
    main()
