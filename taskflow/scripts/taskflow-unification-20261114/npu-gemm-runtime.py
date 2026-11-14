#!/usr/bin/env python3
"""Real device GEMM tiling producer; construction never opens the NPU.

Output cores partition one GEMM. They are not independent whole-GEMM replicas.
The device grid is submitted once, without a host tile loop.
"""
import argparse
import hashlib
import importlib.util
import json
import math
import os
import re
from pathlib import Path


def identity(p):
    p = Path(p).resolve(strict=True)
    return dict(path=str(p), sha256=hashlib.sha256(p.read_bytes()).hexdigest())


def load_kernels(root):
    p = root / 'examples/llm_q4nx/kernels.py'
    spec = importlib.util.spec_from_file_location('orbit_gemm_kernels', p)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def source_target_contract(root):
    """Read the pinned kernel's declared target/schedule bounds without imports."""
    import ast
    source = Path(root)/'examples/llm_q4nx/kernels.py'
    values = {}
    for node in ast.parse(source.read_text()).body:
        if not isinstance(node, ast.Assign):
            continue
        try:
            value = ast.literal_eval(node.value)
        except (ValueError, TypeError):
            continue
        for target in node.targets:
            if isinstance(target, ast.Name):
                values[target.id] = value
            elif isinstance(target, ast.Tuple) and isinstance(value, tuple):
                for name, item in zip(target.elts, value):
                    if isinstance(name, ast.Name):
                        values[name.id] = item
    required = ('AIE_COLS', 'AIE_ROWS', 'L1', 'BLOCK_M', 'MAX_L1_NUMEL')
    if any(type(values.get(name)) is not int or values[name] <= 0 for name in required):
        raise ValueError('pinned source target declarations missing or invalid')
    return dict(source=identity(source), columns=values['AIE_COLS'],
        rows=values['AIE_ROWS'], minimum_l1=values['L1'],
        minimum_block_m=values['BLOCK_M'], max_l1_output_elements=values['MAX_L1_NUMEL'],
        pack=[8,8,8], minimum_block_k=16, weight_dma_max_words=2**20,
        pack_provenance='AIE2P BF16 MAC packing used by generate_matmul_transform',
        status='necessary source/target bounds only; compilation and physical validation still required')


def gemm_parameter_domain(m, n, k, target):
    """Yield every parameter tuple in the declared finite lowering domain.

    Power-of-two blocks follow this kernel's tl.arange contract, not an ORBIT
    factor whitelist. L1 divisors, K subdivisions, replicas and physical offsets
    are derived from the source shape and target constraints. No 18-entry list.
    """
    if min(m,n,k) <= 0:
        raise ValueError('nonpositive source extent')
    def powers(lower, upper):
        value = 1
        while value < lower:
            value *= 2
        while value <= upper:
            yield value
            value *= 2
    def divisors(value, alignment):
        return [d for d in range(alignment,value+1,alignment) if value%d == 0]
    cols, rows, floor = target['columns'], target['rows'], target['minimum_l1']
    area = target['max_l1_output_elements']
    for replicas in range(1,cols+1):
        if n % replicas:
            continue
        for bm in powers(target['minimum_block_m'], (area//floor)*cols//replicas):
            for bn in powers(floor, (area//floor)*rows):
                padded_n = math.ceil((n//replicas)/bn)*bn
                for l1m in divisors(bm, floor):
                    for l1n in divisors(bn, floor):
                        width, height = bm//l1m, bn//l1n
                        if (width*replicas > cols or height > rows or
                                l1m*l1n > area):
                            continue
                        for l2k in powers(target['minimum_block_k'], k):
                            if k % l2k or l2k*padded_n > target['weight_dma_max_words']:
                                continue
                            for l1k in divisors(l2k,target['pack'][2]):
                                for x in range(cols-width*replicas+1):
                                    for y in range(2,2+rows-height+1):
                                        yield dict(m=m,n=n,k=k,bm=bm,bn=bn,
                                            l1m=l1m,l1n=l1n,l2k=l2k,l1k=l1k,
                                            replicas=replicas,column_offset=x,row_offset=y)


def make_chain(root, output, m, n, k, bm=128, bn=256, l1m=64,
               l1n=64, l2k=64, l1k=64):
    """Build an unopened original-kernel chain with an independently generated schedule.

    Runtime callers pass padded BF16 A/B and FP32 C, retain B with
    static_indices={1}, and keep the original chain.run BO identity contract.
    """
    if min(m, n, k, bm, bn, l1m, l1n, l2k, l1k) <= 0:
        raise ValueError('nonpositive extent')
    if bm % l1m or bn % l1n or k % l2k or l2k % l1k:
        raise ValueError('tiles must divide device blocks and exact reduction')
    if bm // l1m > 8 or bn // l1n > 4 or l1m * l1n > 8192:
        raise ValueError('herd or per-core DMA extent exceeds NPU2 contract')
    if l2k * n > 2**20:
        raise ValueError('weight DMA stride exceeds existing 2^20-word bound')
    import torch
    from triton.backends.amd_triton_npu.multilaunch import NPUChain
    from triton.backends.amd_triton_npu.matmul_transform import generate_matmul_transform
    kernel = load_kernels(root)
    mp, np_ = math.ceil(m / bm) * bm, math.ceil(n / bn) * bn
    if l2k * np_ > 2**20:
        raise ValueError('padded weight DMA stride exceeds 2^20 words')
    stride = kernel.unaliased_stride(k)
    script = output / 'schedule.mlir'
    script.write_text(generate_matmul_transform(l1_m=l1m, l1_n=l1n,
        l2_k=l2k, l1_k=l1k, contract_input_type='bf16', k_loop=True))
    chain = NPUChain('orbit_qwen_gemm', air_project_path=str(output / 'air_project'))
    chain.add(kernel._matmul_kernel, grid=(mp // bm, np_ // bn),
        arg_map={0: 0, 1: 1, 2: 2},
        args=(torch.empty((mp, stride), dtype=torch.bfloat16),
              torch.empty((k, np_), dtype=torch.bfloat16),
              torch.empty((mp, np_), dtype=torch.float32), stride, np_, np_),
        constexprs=dict(K=k, BLOCK_M=bm, BLOCK_N=bn, BLOCK_K=l2k),
        transform_script=str(script))
    contract = dict(schema='orbit.qwen-npu-gemm-implementation.v1',
        source=identity(root / 'examples/llm_q4nx/kernels.py'), source_symbol='_matmul_kernel',
        producer=identity(__file__), shape=dict(M=m, N=n, K=k),
        padded_shape=dict(M=mp, N=np_, K=k, A_stride=stride),
        tiling=dict(L2_M=bm, L2_N=bn, L2_K=l2k, L1_M=l1m, L1_N=l1n, L1_K=l1k),
        resource=dict(device='npu2', compute_herd_shape=[bm // l1m, bn // l1n],
            parallel_output_core_partitions=(bm // l1m)*(bn // l1n),
            task_instance_replicas=1, exclusive_device_invocation=True,
            placement='aircc places the actual emitted herd; compiled artifact is authoritative'),
        abi=[dict(index=0, dtype='bf16', shape=[mp,stride], access='read'),
             dict(index=1, dtype='bf16', shape=[k,np_], access='read'),
             dict(index=2, dtype='f32', shape=[mp,np_], access='write')],
        numerical_contract='original BF16-input Triton dot, FP32 accumulation; ordered L1 K tiles; device validation required for equivalence',
        residence=dict(weight_static_indices=[1], requires_same_weight_identity=True),
        unsupported=dict(independent_gemm_replication='no independent concurrent kernel queues/BOs implemented',
                         arbitrary_core_placement='current aircc owns herd placement'),
        schedule=identity(script), device_loaded=False)
    return chain, contract


def lower(chain):
    from triton.backends.amd_triton_npu.multilaunch import MultiLaunchBuilder
    builder = MultiLaunchBuilder(chain.name, air_project_path=chain.air_project_path)
    for kernel, grid, argmap, script, args, constexprs, sizes in chain._specs:
        builder.add_op(chain._capture_ttshared(kernel, grid, args, constexprs),
            grid, argmap, transform_script=script, actual_sizes=sizes)
    return builder


def replicated_air(builder, replicas, bm, bn, l1m, l1n, column_offset=0, row_offset=2):
    """Disjoint output-N instances inside one launch and one device segment.

    The source has no dependency between instance bodies. AIR dependency lowering
    establishes each instance's internal DMA/compute ordering. Explicit physical
    x_loc/y_loc annotations reserve disjoint core rectangles, not host threads.
    """
    if replicas < 2 or len(builder.ops) != 1:
        raise ValueError('this lowering requires equal N shards and one source operation')
    from triton.backends.amd_triton_npu import stitching
    text = builder.ops[0].air_text
    start = text.index('air.segment ')
    opening = text.index('{', start)
    depth, end = 1, opening + 1
    while depth:
        depth += (text[end] == '{') - (text[end] == '}')
        end += 1
    body = text[opening + 1:end - 1]
    signature = text[start:opening]
    assignments = re.findall(r'(%[A-Za-z0-9_]+)=(%[A-Za-z0-9_]+)', signature)
    if len(assignments) != 5:
        raise ValueError('original kernel segment ABI changed')
    originals = [a for a, _ in assignments]
    bodies, maps = [], []
    for r in range(replicas):
        prefix = f'replica{r}'
        branch = stitching._rename_all(body, prefix, set())
        target = ['%pm', '%pn', f'%b{r}', '%a', f'%c{r}']
        for old, new in zip(originals, target):
            renamed = '%' + prefix + '_' + old[1:]
            branch = re.sub(re.escape(renamed) + r'(?![A-Za-z0-9_])', new, branch)
        # The three prologue/compute/epilogue herds of one instance share cores.
        branch = re.sub(r'attributes \{(prologue_herd|compute_herd|epilogue_herd)\}',
            lambda m: 'attributes {' + m.group(1) +
                f', x_loc = {column_offset+r*(bm//l1m)} : i64, y_loc = {row_offset} : i64' + '}', branch)
        bodies.append(branch)
        maps += [stitching._rename_all(x, prefix, set()) for x in stitching._extract_affine_maps(text)]
    # Launch bounds are read from the original producer, not inferred from names.
    launch = re.search(r'air.launch.*?in \((.*?)\) args', text).group(1)
    extent_names = re.findall(r'=%([A-Za-z0-9_]+)', launch)
    constants = dict(re.findall(r'%([A-Za-z0-9_]+) = arith.constant (\d+) : index', text))
    gx, gy, gz = [int(constants[n]) for n in extent_names]
    argument_types = ['memref<*xbf16>'] + [t for _ in range(replicas)
        for t in ('memref<*xbf16>', 'memref<*xf32>')]
    signature = ', '.join(f'%arg{i}: {t}' for i,t in enumerate(argument_types))
    launch_names = ['la'] + [name for r in range(replicas) for name in (f'lb{r}',f'lc{r}')]
    launch_arguments = ', '.join(f'%{name}=%arg{i}' for i,name in enumerate(launch_names))
    segment_arguments = ', '.join(['%pm=%pm0','%pn=%pn0','%a=%la'] +
        [f'%{kind}{r}=%l{kind}{r}' for r in range(replicas) for kind in ('b','c')])
    return '\n'.join(maps) + f"""
module {{
  func.func @orbit_qwen_gemm_replicated({signature}) {{
    %gx = arith.constant {gx} : index
    %gy = arith.constant {gy} : index
    %gz = arith.constant {gz} : index
    air.launch (%pm0, %pn0, %pz0) in (%sx=%gx, %sy=%gy, %sz=%gz)
      args({launch_arguments}) : {', '.join(argument_types)} {{
      air.segment @replicated args({segment_arguments})
          : index, index, {', '.join(argument_types)} {{
{''.join(bodies)}
      }}
    }}
    return
  }}
}}
"""


def compiler_evidence(output):
    paths = sorted((output / 'air_project').glob('aie.*.mlir'))
    cores = set()
    for path in paths:
        cores.update(tuple(map(int, pair)) for pair in
            re.findall(r'%core_(\d+)_(\d+) = aie.core', path.read_text()))
    placed = sorted((output / 'air_project').glob('placed.*.mlir'))
    return dict(aie_sources=[identity(p) for p in paths],
                placed_sources=[identity(p) for p in placed],
                actual_core_coordinates=[list(c) for c in sorted(cores)])


class GemmWeightBinding:
    """An opaque lease for an owned BF16 snapshot, not a mutable source view."""
    def __init__(self, owner, generation, key):
        self._owner, self._generation, self._key = owner, generation, key


class CompiledGemm:
    """Execute unchanged BF16 GEMM with an explicit DDR lifetime contract.

    Persistent calls use bind_weight() once and then run_bound(). Binding copies
    the source into runtime-owned immutable padded shards, so changing a source
    array cannot silently change a cached static BO. Capacity bounds cover the
    arrays and requested operand BOs; opaque XRT/firmware allocations are not
    claimed to be included. No SRAM residency is claimed.
    """
    def __init__(self, artifact, *, context_policy='release-after-call',
                 max_host_bytes=None, max_device_bytes=None,
                 _runner_factory=None):
        if context_policy not in ('release-after-call', 'persistent'):
            raise ValueError('unknown GEMM context policy')
        if context_policy == 'persistent' and (
                type(max_host_bytes) is not int or max_host_bytes <= 0 or
                type(max_device_bytes) is not int or max_device_bytes <= 0):
            raise ValueError('persistent GEMM needs explicit positive host/device capacities')
        self.directory = Path(artifact).resolve()
        self.record = json.loads((self.directory/'implementation.json').read_text())
        for field in ('source_air', 'compiled_binary'):
            expected = self.record[field]
            if identity(expected['path']) != expected:
                raise ValueError('artifact hash mismatch: ' + field)
        self.context_policy = context_policy
        self.max_host_bytes, self.max_device_bytes = max_host_bytes, max_device_bytes
        self.runner = None
        self._runner_factory = _runner_factory
        self._owner, self._generation = object(), 0
        self.weights, self.events, self.binding_events = {}, [], []
        self.host_bytes = self.device_bytes = 0

    def _dimensions(self):
        shape, pad = self.record['shape'], self.record['padded_shape']
        m, n, k = (shape[v] for v in ('M', 'N', 'K'))
        replicas = self.record['resource']['task_instance_replicas']
        if (min(m, n, k, replicas) <= 0 or n % replicas or
                pad['M'] < m or pad['N'] < n//replicas or pad['A_stride'] < k):
            raise ValueError('invalid compiled GEMM padding or partition')
        return m, n, k, replicas, pad

    def bind_weight(self, w, stage_key):
        import numpy as np
        from ml_dtypes import bfloat16
        import time
        start = time.perf_counter_ns()
        m, n, k, replicas, pad = self._dimensions()
        w = np.asarray(w)
        if w.shape != (k, n) or w.dtype != np.dtype(bfloat16):
            raise ValueError('weight must match compiled BF16 source shape')
        key = str(stage_key)
        if not key or key in self.weights:
            raise ValueError('stage already bound; reuse its lease or close before rebinding')
        byte_count = (pad['M']*pad['A_stride']*2 + replicas*(
            k*pad['N']*2 + pad['M']*pad['N']*4))
        if (self.max_host_bytes is not None and
                self.host_bytes + byte_count + w.nbytes > self.max_host_bytes):
            raise MemoryError('GEMM host residence including binding snapshot exceeds capacity')
        if (self.max_device_bytes is not None and
                self.device_bytes + byte_count > self.max_device_bytes):
            raise MemoryError('GEMM operand BO residence exceeds declared capacity')
        # Hash and pack only at the explicit snapshot boundary, outside a warm
        # request. The caller records this setup separately for cold comparisons.
        snapshot = np.array(w, copy=True, order="C")
        digest = hashlib.sha256(snapshot.view(np.uint8)).hexdigest()
        inputs = [np.zeros((pad['M'], pad['A_stride']), dtype=bfloat16)]
        outputs = set()
        for r in range(replicas):
            b = np.zeros((k, pad['N']), dtype=bfloat16)
            b[:, :n//replicas] = snapshot[:, r*(n//replicas):(r+1)*(n//replicas)]
            b.flags.writeable = False
            inputs += [b, np.empty((pad['M'], pad['N']), dtype=np.float32)]
            outputs.add(len(inputs)-1)
        handle = GemmWeightBinding(self._owner, self._generation, key)
        self.weights[key] = dict(handle=handle, inputs=inputs, outputs=outputs,
                                 bytes=byte_count, source_sha256=digest,
                                 dispatched=False)
        self.host_bytes += byte_count
        self.device_bytes += byte_count
        self.binding_events.append(dict(stage=key, source_sha256=digest,
            wall_ns=time.perf_counter_ns()-start, operand_bytes=byte_count,
            peak_host_bytes=self.host_bytes + snapshot.nbytes,
            device_allocation='reserved until first dispatch'))
        return handle

    def run(self, x, w, stage_key):
        if self.context_policy == 'persistent':
            raise ValueError('persistent GEMM requires explicit bind_weight/run_bound lease')
        import time
        start = time.perf_counter_ns()
        handle = self.bind_weight(w, stage_key)
        result = self.run_bound(x, handle)
        elapsed = time.perf_counter_ns()-start
        event = self.events[-1]
        setup = elapsed-event['wall_ns']
        event['host_prepare_ns'] += setup
        event['weight_binding_and_wrapper_ns'] = setup
        event['wall_ns'] = elapsed
        return result

    def run_bound(self, x, handle):
        import numpy as np
        from ml_dtypes import bfloat16
        import time
        start = time.perf_counter_ns()
        if (not isinstance(handle, GemmWeightBinding) or
                handle._owner is not self._owner or
                handle._generation != self._generation or
                handle._key not in self.weights or
                self.weights[handle._key]['handle'] is not handle):
            raise ValueError('foreign, forged or closed weight lease')
        m, n, k, replicas, pad = self._dimensions()
        x = np.asarray(x)
        if x.shape != (m, k) or x.dtype != np.dtype(bfloat16):
            if self.context_policy == 'release-after-call':
                self.close()
            raise ValueError('activation must match compiled BF16 source shape')
        binding = self.weights[handle._key]
        first_dispatch = not binding['dispatched']
        try:
            if self.runner is None:
                factory = self._runner_factory
                if factory is None:
                    from triton.backends.amd_triton_npu.multilaunch import MultiLaunchRunner
                    factory = MultiLaunchRunner
                self.runner = factory(self.record['compiled_binary']['path'],
                                      self.record['kernel_name'])
            opened = time.perf_counter_ns()
            inputs, outputs = binding['inputs'], binding['outputs']
            inputs[0].fill(0)
            inputs[0][:m, :k] = x
            prepared = time.perf_counter_ns()
            got = self.runner.run(inputs, bo_key=handle._key,
                static_indices=set(range(1, len(inputs), 2)),
                intermediate_indices=outputs, output_indices=outputs)
            completed = time.perf_counter_ns()
            result = np.concatenate([
                got[i].reshape(pad['M'], pad['N'])[:m, :n//replicas]
                for i in sorted(outputs)], axis=1).copy()
            assembled = time.perf_counter_ns()
            binding['dispatched'] = True
            held_host, held_device = self.host_bytes, self.device_bytes
            allocated_device = sum(v['bytes'] for v in self.weights.values()
                                   if v['dispatched'])
            if self.context_policy == 'release-after-call':
                self.close()
            end = time.perf_counter_ns()
        except BaseException:
            self.close()
            raise
        event = dict(wall_ns=end-start, device_open_ns=opened-start,
            host_prepare_ns=prepared-opened,
            native_inclusive_service_ns=completed-prepared,
            host_assemble_ns=assembled-completed, release_ns=end-assembled,
            replicas=replicas, first_dispatch=first_dispatch,
            weight_upload_expected=first_dispatch,
            context_policy=self.context_policy, storage='device-ddr-bo',
            sram_residency_claim=False, held_host_bytes=held_host,
            reserved_operand_bo_bytes=held_device,
            live_operand_bo_bytes=allocated_device if self.runner else 0,
            weight_source_sha256=binding['source_sha256'])
        assert event['wall_ns'] == sum(event[q] for q in (
            'device_open_ns', 'host_prepare_ns', 'native_inclusive_service_ns',
            'host_assemble_ns', 'release_ns'))
        self.events.append(event)
        return result

    def close(self):
        try:
            if self.runner is not None:
                self.runner.unload()
        finally:
            self.runner = None
            self.weights.clear()
            self.host_bytes = self.device_bytes = 0
            self._generation += 1

    def __enter__(self):
        return self

    def __exit__(self, *unused):
        self.close()


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--triton-root', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    for key, val in [('m',5),('n',2560),('k',2048),('bm',128),('bn',256),
                     ('l1m',64),('l1n',64),('l2k',64),('l1k',64)]:
        ap.add_argument('--'+key, type=int, default=val)
    ap.add_argument('--compile', action='store_true')
    ap.add_argument('--replicas', type=int, default=1)
    ap.add_argument('--column-offset', type=int, default=0)
    ap.add_argument('--row-offset', type=int, default=2)
    ap.add_argument('--enumerate-domain', action='store_true')
    a = ap.parse_args()
    a.output = a.output.resolve()
    a.output.mkdir(parents=True, exist_ok=False)
    target = source_target_contract(a.triton_root)
    if a.enumerate_domain:
        count = 0
        with (a.output/'domain.jsonl').open('w') as stream:
            for parameters in gemm_parameter_domain(a.m,a.n,a.k,target):
                stream.write(json.dumps(parameters,sort_keys=True)+'\n')
                count += 1
        (a.output/'domain.json').write_text(json.dumps(dict(target=target,
            source_shape=dict(M=a.m,N=a.n,K=a.k),candidates=count,
            compiled=False,device_loaded=False),indent=2)+'\n')
        print(json.dumps(dict(candidates=count,output=str(a.output),compiled=False)))
        return
    if a.replicas <= 0 or a.n % a.replicas:
        raise ValueError('replicated N shards must be equal')
    if (a.column_offset < 0 or a.column_offset + a.replicas * (a.bm // a.l1m) > target['columns'] or
            a.row_offset < 2 or a.row_offset + a.bn//a.l1n > 2+target['rows']):
        raise ValueError('replicated herds exceed physical column capacity')
    chain, record = make_chain(a.triton_root.resolve(), a.output,
        a.m,a.n//a.replicas,a.k,a.bm,a.bn,a.l1m,a.l1n,a.l2k,a.l1k)
    builder = lower(chain)
    air = a.output / 'source.air.mlir'
    air.write_text(builder.build_module_text() if a.replicas == 1 else
        replicated_air(builder, a.replicas, a.bm, a.bn, a.l1m, a.l1n, a.column_offset, a.row_offset))
    if a.replicas == 1:
        air.write_text(re.sub(r'attributes \{(prologue_herd|compute_herd|epilogue_herd)\}',
            lambda m: 'attributes {'+m.group(1)+f', x_loc = {a.column_offset} : i64, y_loc = {a.row_offset} : i64'+'}', air.read_text()))
    record['target_domain'] = target
    record['resource']['column_offset'] = a.column_offset
    record['resource']['row_offset'] = a.row_offset
    if a.replicas > 1:
        record['shape']['N'] = a.n
        record['resource']['task_instance_replicas'] = a.replicas
        record['resource']['parallel_output_core_partitions'] *= a.replicas
        record['resource']['instance_rectangles'] = [dict(x=a.column_offset+r*(a.bm//a.l1m), y=a.row_offset, width=a.bm//a.l1m, height=a.bn//a.l1n) for r in range(a.replicas)]
        record['resource']['replica_semantics'] = 'independent equal N-shard GEMM task instances; disjoint weights/results, shared read-only A'
        record['abi'] += [dict(record['abi'][j], index=2*r+j) for r in range(1,a.replicas) for j in (1,2)]
        record['residence']['weight_static_indices'] = list(range(1,2*a.replicas+1,2))
        record['host_boundary'] = dict(weight_partition=f'{a.replicas} equal contiguous N shards, padded separately', output_assembly='concatenate shard results along N; measurable host copy', activation='one read-only shared A BO')
        record['unsupported'].pop('independent_gemm_replication')
    for index, op in enumerate(builder.ops):
        (a.output / f'op{index}.air.mlir').write_text(op.air_text)
    record['source_air'] = identity(air)
    record['actual_air_herds'] = [s.strip() for s in air.read_text().splitlines() if 'air.herd' in s]
    record['actual_abi'] = builder.combined_arg_types() if a.replicas == 1 else ['memref<*xbf16>'] + ['memref<*xbf16>','memref<*xf32>']*a.replicas
    if a.compile:
        os.chdir(a.output)
        from triton.backends.amd_triton_npu.driver import _aircc_compile
        result = _aircc_compile(str(air), 'elf', 'npu2', str(a.output/'air_project'))
        binary, name = result['elf_path'], result['elf_kernel_name']
        record['compiled_binary'], record['kernel_name'] = identity(binary), name
        record['physical_evidence'] = compiler_evidence(a.output)
        expected = {(a.column_offset+r*(a.bm//a.l1m)+x, a.row_offset+y) for r in range(a.replicas) for x in range(a.bm//a.l1m) for y in range(a.bn//a.l1n)}
        observed = {tuple(c) for c in record['physical_evidence']['actual_core_coordinates']}
        if observed != expected:
            raise ValueError(f'compiled physical placement differs: {observed} vs {expected}')
    (a.output / 'implementation.json').write_text(json.dumps(record,indent=2)+'\n')
    print(json.dumps(dict(output=str(a.output),compiled=a.compile,herds=record['actual_air_herds'])))


if __name__ == '__main__':
    main()
