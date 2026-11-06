#!/usr/bin/env python3
"""Compile and execute C++-issued static heterogeneous manifests.

No placement, partitioning, graph planning, scoring, or numerical computation is
performed here. CPU arithmetic is the compiled actual MLIR body; NPU dispatch
uses the installed MultiLaunchRunner with caller-owned mapped BOs.
"""
import argparse
import ctypes
import hashlib
import json
import os
import platform
from pathlib import Path
import shutil
import subprocess
import sys
import time

# Bind the source loaded by this process, independently of any later on-disk edit.
EXECUTOR_SOURCE_BYTES = Path(__file__).read_bytes()
EXECUTOR_SOURCE_SHA256 = hashlib.sha256(EXECUTOR_SOURCE_BYTES).hexdigest()


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def save(path, value):
    Path(path).write_text(json.dumps(value, indent=2) + '\n')


def resolve(base, path):
    value = Path(path)
    return value.resolve() if value.is_absolute() else (base / value).resolve()


def load_manifest(path):
    path = Path(path).resolve()
    value = json.loads(path.read_text())
    if value.get('schema') != 'orbit.heterogeneous.static.v13' or not value.get('id'):
        raise ValueError('expected identified native heterogeneous static v13 manifest')
    storages = value['storage']
    if [x['index'] for x in storages] != list(range(len(storages))):
        raise ValueError('storage indices must be unique and dense')
    names = set()
    for entry in storages:
        if entry['dtype'] != 'f32' or entry['realization'] not in ('numpy-host', 'xrt-mapped-bo'):
            raise ValueError('unsupported explicit storage realization/precision')
        if entry['name'] in names or not entry['shape'] or any(type(x) is not int or x <= 0 for x in entry['shape']):
            raise ValueError('invalid storage name/shape')
        names.add(entry['name'])
        nbytes = 4
        for dim in entry['shape']:
            nbytes *= dim
        if nbytes != entry['bytes']:
            raise ValueError('storage bytes disagree with native full-storage ABI')
    regions = value['regions']
    if not regions or [x['index'] for x in regions] != list(range(len(regions))):
        raise ValueError('execution-region indices must be unique and dense')
    for region in regions:
        if region['device'] not in ('cpu', 'npu') or not region['tasks']:
            raise ValueError('unsupported/empty execution region')
        abi = region.get('npu_abi', region['abi']) if region['device'] == 'npu' else region['abi']
        if [x['argument'] for x in abi] != list(range(len(abi))):
            raise ValueError('ABI argument indices must be complete and ordered')
        for binding in abi:
            storage = storages[binding['storage']]
            if binding['shape'] != storage['shape'] or binding['dtype'] != storage['dtype']:
                raise ValueError('cropped/reinterpreted storage ABI is unsupported')
            if region['device'] == 'npu' and storage['realization'] != 'xrt-mapped-bo':
                raise ValueError('NPU operands must explicitly bind mapped BO storage')
    events = value['region_events']
    for index, event in enumerate(events):
        if event['region'] not in range(len(regions)) or event['kind'] not in ('submit', 'complete', 'visible-to-device', 'visible-to-host'):
            raise ValueError('unsupported native region event')
        if any(type(d) is not int or d < 0 or d >= index for d in event['dependencies']):
            raise ValueError('native region events are not topologically ordered')
    return path, value


def validate_contract(manifest, llvm_build=None, runtime_module=None):
    contract = manifest.get('execution_contract')
    if not isinstance(contract, dict) or contract.get('schema') != 'orbit.heterogeneous.execution-contract.v13':
        raise ValueError('missing/unsupported native execution contract')
    identity = manifest.get('execution_contract_identity')
    if not isinstance(identity, str) or not identity:
        raise ValueError('execution contract has no native identity')
    if contract.get('executor_sha256') != EXECUTOR_SOURCE_SHA256:
        raise ValueError('execution contract does not bind the running executor source')
    files = contract.get('files')
    required = ('clang', 'mlir-opt', 'mlir-translate', 'multilaunch')
    if not isinstance(files, dict) or any(key not in files for key in required):
        raise ValueError('execution contract needs clang/mlir-opt/mlir-translate/multilaunch files')
    verified = {}
    for key, entry in files.items():
        if not isinstance(entry, dict) or not isinstance(entry.get('path'), str) or not isinstance(entry.get('sha256'), str):
            raise ValueError('execution contract files must be role:{path,sha256} records')
        path = Path(entry['path'])
        if not path.is_absolute() or not path.is_file() or digest(path) != entry['sha256']:
            raise ValueError('execution contract file is missing or changed: ' + str(key))
        verified[key] = dict(path=str(path), sha256=entry['sha256'])
    for field, role in (('clang_sha256','clang'), ('multilaunch_sha256','multilaunch')):
        if field in contract and contract[field] != files[role]['sha256']:
            raise ValueError('execution contract has contradictory ' + field)
    expected_flags = dict(dtype='f32', cpu_contraction='off', approximate_math=False)
    flags = manifest.get('numeric_contract', {})
    if any(flags.get(key) != value for key,value in expected_flags.items()):
        raise ValueError('execution requires the declared strict f32/no-contraction contract')
    declared_flags = contract.get('numeric_contract', expected_flags)
    if not isinstance(declared_flags,dict) or any(declared_flags.get(key) != value for key,value in expected_flags.items()):
        raise ValueError('execution contract numerical flags differ from actual compiler flags')
    if llvm_build is not None:
        for role in ('clang','mlir-opt','mlir-translate'):
            actual = llvm_build / 'bin' / role
            if not actual.is_file() or digest(actual) != files[role]['sha256']:
                raise ValueError('invoked LLVM tool differs from execution contract: ' + role)
    if runtime_module is not None and digest(runtime_module.__file__) != files['multilaunch']['sha256']:
        raise ValueError('imported NPU runner differs from execution contract')
    if 'machine' in contract:
        actual_machine = dict(system=platform.system(),machine=platform.machine(),release=platform.release(),node=platform.node())
        if not isinstance(contract['machine'],dict) or any(k not in actual_machine or actual_machine[k]!=v for k,v in contract['machine'].items()):
            raise ValueError('execution contract machine facts differ from this host')
    if 'target' in contract and contract['target'] != dict(cpu='host', npu='npu2'):
        raise ValueError('execution contract target differs from actual host/npu2 compilation')
    return dict(identity=identity,executor_sha256=EXECUTOR_SOURCE_SHA256,files=verified,
                numeric_flags=expected_flags,target=dict(cpu='host',npu='npu2'),
                imported_multilaunch_verified=runtime_module is not None)


def command(argv, directory, name):
    argv = [str(x) for x in argv]
    save(directory / (name + '.command.json'), argv)
    start = time.perf_counter_ns()
    with (directory / (name + '.log')).open('w') as log:
        result = subprocess.run(argv, stdout=log, stderr=subprocess.STDOUT)
    record = dict(argv=argv, returncode=result.returncode,
                  elapsed_ns=time.perf_counter_ns() - start)
    executable = shutil.which(argv[0])
    if executable and Path(executable).is_file():
        record['executable_sha256'] = digest(executable)
    save(directory / (name + '.result.json'), record)
    if result.returncode:
        raise RuntimeError('compiler failed: ' + str(directory / (name + '.log')))


def compile_manifest(path, output, llvm_build):
    path, manifest = load_manifest(path)
    contract_validation = validate_contract(manifest, llvm_build)
    output.mkdir(parents=True, exist_ok=False)
    base = path.parent
    records = []
    for region in manifest['regions']:
        directory = output / ('region-' + str(region['index']))
        directory.mkdir()
        common = dict(index=region['index'], device=region['device'],
                      function=region['function'], source_sha256=digest(resolve(base, region['source'])))
        if region['device'] == 'cpu':
            source = resolve(base, region['cpu_source'])
            llvm_mlir, llvm_ir, library = directory / 'llvm.mlir', directory / 'cpu.ll', directory / 'cpu.so'
            command([llvm_build / 'bin/mlir-opt', source, '--lower-affine', '--convert-scf-to-cf',
                     '--convert-math-to-llvm', '--convert-arith-to-llvm', '--finalize-memref-to-llvm',
                     '--convert-func-to-llvm', '--convert-cf-to-llvm', '--reconcile-unrealized-casts',
                     '-o', llvm_mlir], directory, 'llvm-lowering')
            command([llvm_build / 'bin/mlir-translate', '--mlir-to-llvmir', llvm_mlir, '-o', llvm_ir], directory, 'llvm-translate')
            command([llvm_build / 'bin/clang', '-O2', '-ffp-contract=off', '-shared', '-fPIC', llvm_ir,
                     '-lm', '-o', library], directory, 'shared-library')
            common.update(cpu_source=str(source), cpu_source_sha256=digest(source),
                          library=str(library), library_sha256=digest(library), llvm_ir_sha256=digest(llvm_ir))
        else:
            from taskflow_direct_air_execute import compile_air
            air = resolve(base, region.get('air', 'region-' + str(region['index']) + '/program.air.mlir'))
            abi = resolve(base, region.get('npu_abi_path', 'region-' + str(region['index']) + '/abi.json'))
            artifact = compile_air(air, directory / 'hardware', False, 4096, True)
            native_abi = json.loads(abi.read_text())
            bindings = region.get('npu_abi', region['abi'])
            if len(native_abi['buffers']) != len(bindings):
                raise ValueError('native NPU ABI needs explicit bindings including all internal scratch operands')
            for buffer, binding in zip(native_abi['buffers'], bindings):
                if buffer['shape'] != binding['shape'] or buffer['dtype'] != binding['dtype']:
                    raise ValueError('native NPU ABI differs from manifest binding')
            if artifact['argument_count'] < len(bindings):
                raise ValueError('NPU ELF has fewer ABI arguments than the native manifest')
            shutil.copy2(abi, directory / 'abi.json')
            common.update(artifact=artifact, air_sha256=digest(air), abi_sha256=digest(abi))
        records.append(common)
    result = dict(schema='orbit.heterogeneous.compiled.v13', manifest=str(path),
                  manifest_sha256=digest(path), plan_id=manifest['id'], regions=records,
                  executor_sha256=EXECUTOR_SOURCE_SHA256, numerical_fallback=False,
                  execution_contract_identity=manifest['execution_contract_identity'],
                  execution_contract_validation=contract_validation)
    save(output / 'compiled.json', result)
    return output / 'compiled.json'


def memref_type(rank):
    class MemRef(ctypes.Structure):
        _fields_ = [('allocated', ctypes.POINTER(ctypes.c_float)),
                    ('aligned', ctypes.POINTER(ctypes.c_float)), ('offset', ctypes.c_int64),
                    ('sizes', ctypes.c_int64 * rank), ('strides', ctypes.c_int64 * rank)]
    return MemRef


class Prepared:
    def __init__(self, compiled_path):
        import numpy as np
        self.np = np
        self.compiled_path = Path(compiled_path).resolve()
        self.compiled = json.loads(self.compiled_path.read_text())
        self.path, self.manifest = load_manifest(self.compiled['manifest'])
        if digest(self.path) != self.compiled['manifest_sha256'] or self.manifest['id'] != self.compiled['plan_id']:
            raise ValueError('native manifest differs from compiled binding')
        self.contract_validation = validate_contract(self.manifest)
        if self.compiled.get('execution_contract_identity') != self.manifest['execution_contract_identity']:
            raise ValueError('compiled artifact execution-contract identity differs from manifest')
        self.arrays, self.bos, self.owners, self.runners, self.functions = {}, {}, [], {}, {}
        self.events = []
        self.bo_map_addresses = {}
        self.abi_pointer_proof = []
        if len(self.compiled['regions']) != len(self.manifest['regions']):
            raise ValueError('compiled region coverage differs from manifest')
        needs_npu = any(s['realization'] == 'xrt-mapped-bo' for s in self.manifest['storage'])
        if needs_npu:
            import pyxrt
            from taskflow_npu_trace_v3 import ObservedBO, ObservedXRT
            from triton.backends.amd_triton_npu.multilaunch import MultiLaunchRunner
            from triton.backends.amd_triton_npu import multilaunch
            self.contract_validation = validate_contract(self.manifest, runtime_module=multilaunch)
            self.xrt, self.module = pyxrt, multilaunch
            self.runtime_identity = dict(source=str(multilaunch.__file__), sha256=digest(multilaunch.__file__))
            device = pyxrt.device(0)
            self.owners.append(device)
            self.runtime_identity['device_bdf'] = str(device.get_info(pyxrt.xrt_info_device.bdf))
        else:
            self.runtime_identity = dict(kind='cpu-only')
        used = {b['storage'] for r in self.manifest['regions'] for b in (r.get('npu_abi', r['abi']) if r['device']=='npu' else r['abi'])}
        self.compiled_internal_storages = [s['index'] for s in self.manifest['storage'] if s['index'] not in used]
        for storage in self.manifest['storage']:
            index = storage['index']
            if index not in used:
                continue
            if storage['realization'] == 'xrt-mapped-bo':
                raw = self.xrt.ext.bo(device, storage['bytes'])
                bo = ObservedBO(raw, self.events, index)
                mapped = raw.map()
                array = np.frombuffer(mapped, dtype=np.float32, count=storage['bytes']//4).reshape(storage['shape'])
                address = ctypes.addressof(ctypes.c_char.from_buffer(mapped))
                if int(array.ctypes.data) != address:
                    raise ValueError('mapped BO array does not alias the BO base address')
                self.bo_map_addresses[index] = address
                self.bos[index] = bo
                self.owners.extend([raw, mapped])
            else:
                array = np.empty(storage['shape'], dtype=np.float32)
            self.arrays[index] = array
        for region, compiled in zip(self.manifest['regions'], self.compiled['regions']):
            index = region['index']
            if any(region[k] != compiled[k] for k in ('index','device','function')):
                raise ValueError('compiled region identity differs from native manifest')
            if digest(resolve(self.path.parent,region['source'])) != compiled['source_sha256']:
                raise ValueError('actual child Taskflow source identity changed')
            bindings = region.get('npu_abi', region['abi']) if region['device']=='npu' else region['abi']
            for binding in bindings:
                storage = binding['storage']
                array = self.arrays[storage]
                mapped_address = self.bo_map_addresses.get(storage)
                if mapped_address is not None and mapped_address != int(array.ctypes.data):
                    raise ValueError('CPU/ABI array does not alias the declared BO mapping')
                self.abi_pointer_proof.append(dict(region=index,argument=binding['argument'],storage=storage,
                    copy=binding.get('copy'),array_address=int(array.ctypes.data),bo_map_address=mapped_address,
                    offset_bytes=0,shape=list(array.shape),strides_bytes=list(array.strides),
                    aliases_bo=(mapped_address==int(array.ctypes.data)) if mapped_address is not None else None))
            if region['device'] == 'cpu':
                if digest(compiled['cpu_source']) != compiled['cpu_source_sha256']:
                    raise ValueError('actual CPU extraction source identity changed')
                if digest(compiled['library']) != compiled['library_sha256']:
                    raise ValueError('CPU library identity changed')
                library = ctypes.CDLL(compiled['library'])
                fn = getattr(library, '_mlir_ciface_' + region['function'])
                types = [memref_type(len(b['shape'])) for b in region['abi']]
                fn.argtypes, fn.restype = [ctypes.POINTER(t) for t in types], None
                self.functions[index] = (library, fn, types)
            else:
                artifact = compiled['artifact']
                if digest(artifact['elf_path']) != artifact['elf_sha256']:
                    raise ValueError('NPU ELF identity changed')
                runner = MultiLaunchRunner(artifact['elf_path'], artifact['kernel_name'])
                if str(runner.device.get_info(self.xrt.xrt_info_device.bdf)) != self.runtime_identity['device_bdf']:
                    raise ValueError('bound BO and NPU runner name different physical devices')
                if digest(resolve(self.path.parent,region['air'])) != compiled['air_sha256'] or digest(resolve(self.path.parent,region['npu_abi_path'])) != compiled['abi_sha256']:
                    raise ValueError('native AIR/ABI identity changed')
                runner._xrt = ObservedXRT(runner._xrt, self.events)
                self.runners[index] = runner
        self.pointer_identity = {str(i): dict(address=int(a.ctypes.data), bytes=int(a.nbytes),
                                      realization=self.manifest['storage'][i]['realization'])
                                 for i, a in self.arrays.items()}

    def one(self, inputs, reference, directory, warmup):
        try:
            return self._one(inputs, reference, directory, warmup)
        except Exception as error:
            directory.mkdir(parents=True, exist_ok=True)
            save(directory/'failure.json',dict(status='execution_failed',message=str(error),
                 plan_id=self.manifest['id'], events=list(self.events), pointers=self.pointer_identity,
                 numerical_fallback=False))
            raise

    def _one(self, inputs, reference, directory, warmup):
        import numpy as np
        for i, storage in enumerate(self.manifest['storage']):
            if i in self.arrays and storage['role'] != 'input':
                self.arrays[i].fill(np.nan)
        self.events.clear()
        begin = time.perf_counter_ns()
        for i, storage in enumerate(self.manifest['storage']):
            if i in self.arrays and storage['role'] == 'input':
                source = inputs[storage['name']]
                if source.dtype != np.float32 or list(source.shape) != storage['shape']:
                    raise ValueError('input violates native storage ABI')
                start = time.perf_counter_ns()
                np.copyto(self.arrays[i], source, casting='no')
                self.events.append(dict(kind='host_input_reset', storage=i, bytes=storage['bytes'], start_ns=start, end_ns=time.perf_counter_ns()))
        region_calls = []
        for region in self.manifest['regions']:
            index = region['index']
            start, first_event = time.perf_counter_ns(), len(self.events)
            if region['device'] == 'cpu':
                library, function, types = self.functions[index]
                descriptors, descriptor_proof = [], []
                for binding, type_ in zip(region['abi'], types):
                    array = self.arrays[binding['storage']]
                    ptr = array.ctypes.data_as(ctypes.POINTER(ctypes.c_float))
                    descriptor_proof.append(dict(argument=binding['argument'],storage=binding['storage'],copy=binding.get('copy'),
                        allocated=int(array.ctypes.data),aligned=int(array.ctypes.data),offset=0,
                        sizes=list(array.shape),strides=[x//4 for x in array.strides]))
                    descriptors.append(type_(ptr, ptr, 0, (ctypes.c_int64*array.ndim)(*array.shape),
                                             (ctypes.c_int64*array.ndim)(*(x//4 for x in array.strides))))
                function(*(ctypes.byref(x) for x in descriptors))
                self.events.append(dict(kind='actual_cpu_library_call', region=index, abi_descriptors=descriptor_proof, start_ns=start, end_ns=time.perf_counter_ns()))
            else:
                bindings = region.get('npu_abi', region['abi'])
                arrays = [self.arrays[b['storage']] for b in bindings]
                buffers = {b['argument']: self.bos[b['storage']] for b in bindings}
                outputs = {b['argument'] for b in bindings if b['role'] == 'output'}
                original_wait = self.module._wait
                from taskflow_npu_trace_v3 import ObservedRun
                def wait(run):
                    t = time.perf_counter_ns()
                    try:
                        return original_wait(run.raw if isinstance(run, ObservedRun) else run)
                    finally:
                        self.events.append(dict(kind='actual_xrt_wait', start_ns=t, end_ns=time.perf_counter_ns()))
                self.module._wait = wait
                original_copyto, staging_copies = np.copyto, []
                def observed_copyto(*arguments, **keywords):
                    t=time.perf_counter_ns()
                    value=original_copyto(*arguments, **keywords)
                    staging_copies.append(dict(start_ns=t,end_ns=time.perf_counter_ns(),
                        bytes=int(getattr(arguments[0],'nbytes',0))))
                    return value
                np.copyto = observed_copyto
                try:
                    self.runners[index].run(arrays, bo_key='native-region-' + str(index),
                                            bound_buffers=buffers, output_indices=outputs)
                finally:
                    np.copyto = original_copyto
                    self.module._wait = original_wait
                self.events.append(dict(kind='runner_staging_observation',region=index,start_ns=time.perf_counter_ns(),end_ns=time.perf_counter_ns(),
                    numpy_copyto_calls=staging_copies,all_arguments_bound=True,
                    claim='no runner host staging memcpy observed; BO sync APIs are retained'))
                if staging_copies:
                    raise ValueError('bound-buffer dispatch unexpectedly staged host data')
            for event in self.events[first_event:]:
                event['region'] = index
                if event['kind'] == 'actual_bo_sync':
                    event['storage'] = event.pop('buffer_index')
                event_kind = {'actual_xrt_start':'submit', 'actual_xrt_wait':'complete'}.get(event['kind'])
                if event['kind']=='actual_bo_sync':
                    event_kind = 'visible-to-device' if 'TO_DEVICE' in event['direction'] else 'visible-to-host'
                matching=[]
                for eid, public in enumerate(self.manifest['region_events']):
                    if public['region']!=index:
                        continue
                    if event['kind']=='actual_cpu_library_call' and public['kind'] in ('submit','complete'):
                        matching.append(eid)
                    elif public['kind']==event_kind:
                        if event['kind']!='actual_bo_sync':
                            matching.append(eid)
                        else:
                            relevant=[b for b in region['abi'] if b['storage']==event['storage'] and
                                      b['role']==('input' if event_kind=='visible-to-device' else 'output')]
                            copies={b['copy'] for b in relevant if isinstance(b.get('copy'),int) and b['copy']>=0}
                            if copies.intersection(public['copies']):
                                matching.append(eid)
                event['public_region_event_ids']=matching
                if event['kind']=='actual_bo_sync' and not matching:
                    event['binding_scope']='conservative installed-runner sync; no additional logical copy or measured DDR claim'

            region_calls.append(dict(region=index, start_ns=start, end_ns=time.perf_counter_ns(),
                                     manifest_region_event_ids=[i for i,e in enumerate(self.manifest['region_events']) if e['region']==index]))
        copy_begin = time.perf_counter_ns()
        outputs = {s['name']: self.arrays[s['index']].copy() for s in self.manifest['storage'] if s['role']=='output'}
        self.events.append(dict(kind='host_final_output_copy', bytes=sum(a.nbytes for a in outputs.values()), start_ns=copy_begin, end_ns=time.perf_counter_ns()))
        end = time.perf_counter_ns()
        covered={i for e in self.events for i in e.get('public_region_event_ids',[])}
        if covered!=set(range(len(self.manifest['region_events']))):
            raise ValueError('native boundary event lacks an actual CPU/XRT API correspondence: '+str(sorted(set(range(len(self.manifest['region_events'])))-covered)))
        if set(outputs) != set(reference):
            raise ValueError('reference output interface differs from native manifest')
        checks = {}
        for name, actual in outputs.items():
            expected = reference[name]
            finite = bool(np.isfinite(actual).all() and np.isfinite(expected).all())
            checks[name] = dict(passed=finite and bool(np.allclose(actual, expected, atol=1e-5, rtol=1e-5)),
                                finite=finite, max_abs=float(np.max(np.abs(actual.astype('f8')-expected.astype('f8')))))
        # Check the CPU and every ELF have kept the compiler-selected physical
        # backing stable; this establishes address reuse, not device DDR bytes.
        if any(int(a.ctypes.data) != self.pointer_identity[str(i)]['address'] for i,a in self.arrays.items()):
            raise ValueError('static storage backing changed during execution')
        directory.mkdir(parents=True, exist_ok=False)
        np.savez(directory/'outputs.npz', **outputs)
        result = dict(warmup=warmup, wall_ms=(end-begin)/1e6, checks=checks,
                      passed=all(x['passed'] for x in checks.values()), events=list(self.events),
                      region_calls=region_calls, input_reset_in_timing=True, final_output_copy_in_timing=True,
                      timing_boundary='input reset + serial compiler-issued CPU/NPU regions, BO sync/submit/wait + final output copies; excludes preparation, poison, reference checks and evidence serialization')
        save(directory/'result.json', result)
        return result

    def close(self):
        for runner in self.runners.values():
            runner.unload()
        self.runners.clear()
        self.functions.clear()
        self.arrays.clear()
        self.bos.clear()
        self.owners.clear()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--manifest', type=Path)
    parser.add_argument('--compiled', type=Path)
    parser.add_argument('--cases', type=Path, help='static cases JSON: cases[{name,manifest|compiled,inputs:[],reference:[]}]')
    parser.add_argument('--inputs', type=Path, action='append', default=[])
    parser.add_argument('--reference', type=Path, action='append', default=[])
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--llvm-build', type=Path, default=Path(os.environ.get('LLVM_BUILD','/home/shiran/project/llvm-project/build')))
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument('--compile-only', action='store_true')
    mode.add_argument('--execute', action='store_true')
    parser.add_argument('--warmups', type=int, default=1)
    parser.add_argument('--iterations', type=int, default=3)
    args = parser.parse_args()
    args.output = args.output.resolve()
    args.output.mkdir(parents=True, exist_ok=False)
    (args.output/'executor-source.py').write_bytes(EXECUTOR_SOURCE_BYTES)
    save(args.output/'executor-identity.json',dict(sha256=EXECUTOR_SOURCE_SHA256,source='executor-source.py'))
    if args.compile_only:
        if not args.manifest or args.cases or args.compiled:
            parser.error('compile-only requires exactly one manifest')
        compile_manifest(args.manifest, args.output/'compiled', args.llvm_build)
        return 0
    rows = json.loads(args.cases.read_text())['cases'] if args.cases else [dict(name='program',manifest=str(args.manifest) if args.manifest else None,
                compiled=str(args.compiled) if args.compiled else None,inputs=[str(x) for x in args.inputs],reference=[str(x) for x in args.reference])]
    base = args.cases.resolve().parent if args.cases else Path.cwd()
    if args.cases:
        shutil.copy2(args.cases,args.output/'cases-input.json')
    normalized_cases=[]
    import numpy as np
    import fcntl
    prepared, data = [], []
    try:
        for row in rows:
            directory = args.output/row['name']
            directory.mkdir()
            compiled = resolve(base,row['compiled']) if row.get('compiled') else compile_manifest(resolve(base,row['manifest']), directory/'compiled',args.llvm_build)
            item = Prepared(compiled)
            prepared.append((row['name'],item,directory))
            normalized_cases.append(dict(name=row['name'],compiled=str(compiled),manifest=str(item.path),
                inputs=[str(resolve(base,x)) for x in row['inputs']],reference=[str(resolve(base,x)) for x in row['reference']]))
            if len(row['inputs']) != len(row['reference']) or not row['inputs']:
                raise ValueError('matching independently supplied input/reference archives required')
            data.append([(dict(np.load(resolve(base,i))),dict(np.load(resolve(base,r)))) for i,r in zip(row['inputs'],row['reference'])])
            save(directory/'preparation.json',dict(plan_id=item.manifest['id'], manifest_sha256=digest(item.path),
                  compiled_path=str(compiled), compiled_sha256=digest(compiled),
                  execution_executor_sha256=EXECUTOR_SOURCE_SHA256,
                  execution_contract_identity=item.manifest['execution_contract_identity'],
                  execution_contract_validation=item.contract_validation, pointers=item.pointer_identity,
                  abi_pointer_proof=item.abi_pointer_proof, runtime=item.runtime_identity,
                  compiled_internal_storages=item.compiled_internal_storages, internal_allocation_scope='compiled region body; no duplicate executor storage allocation'))
        save(args.output/'cases.json',dict(cases=normalized_cases))
        if len({len(x) for x in data})!=1 or args.warmups<0 or args.iterations<1:
            raise ValueError('interleaving requires equal seed counts and positive sample counts')
        results=[]
        with open('/tmp/npu.lock','w') as lock:
            fcntl.flock(lock,fcntl.LOCK_EX)
            for seed in range(len(data[0])):
                for repeat in range(args.warmups+args.iterations):
                    for index,(name,item,directory) in enumerate(prepared):
                        result=item.one(*data[index][seed],directory/('seed-'+str(seed))/('repeat-'+str(repeat)),repeat<args.warmups)
                        results.append(dict(case=name,seed_index=seed,repeat=repeat,**result))
        passed=all(x['passed'] for x in results)
        save(args.output/'summary.json',dict(status='passed' if passed else 'numeric_failed', samples=results,
              placement_source='C++ native manifest only', physical_ddr_measurement=False))
        return 0 if passed else 1
    finally:
        for _,item,_ in prepared:
            item.close()


if __name__ == '__main__':
    raise SystemExit(main())
