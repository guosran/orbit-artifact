#!/usr/bin/env python3
"""Normal public source -> global physical ledger -> AIR waves -> AIE proof.

Numerical correctness only. Every configuration executes serially with one
unchanged set of actual device BOs. No search or performance comparison.
"""
import argparse
import fcntl
import importlib.util
import json
from pathlib import Path
import shutil
import sys

spec = importlib.util.spec_from_file_location('smoke_helpers', Path(__file__).with_name('run.py'))
h = importlib.util.module_from_spec(spec)
spec.loader.exec_module(h)


def compile_inputs(a):
    out = a.output.resolve()
    out.mkdir(parents=True, exist_ok=False)
    shutil.copy2(a.source, out / 'source.mlir')
    shutil.copy2(a.target, out / 'target.json')
    source, target = out / 'source.mlir', out / 'target.json'
    h.command(out, 'normal-public-lowering', [a.tool, source,
              '--target-config=' + str(target),
              '--lower-program-to-air=' + str(out / 'programs')])
    h.command(out, 'facts', [a.tool, source, '--normalize-taskflow-source',
              '--source-normalization-witness=' + str(out / 'normalization.json'),
              '--generic-analyze', '--analysis-output=' + str(out / 'facts.json'),
              '--emit-mlir=' + str(out / 'normalized.mlir')])
    facts = json.loads((out / 'facts.json').read_text())
    manifests = [json.loads(p.read_text()) for p in (out / 'programs').glob('*.json')]
    manifest = next(m for m in manifests if isinstance(m, dict) and 'wave_implementations' in m)
    indices = manifest['wave_implementations'][0]['abi_storage_indices']
    assert all(w['abi_storage_indices'] == indices for w in manifest['wave_implementations'])
    # This is the backend's fixed ABI, including real host-resident cut buffers.
    # Do not infer ABI membership from source roles or invent intermediate BOs.
    storages = manifest['program_graph']['source']['storages'] if isinstance(manifest['program_graph'].get('source'), dict) and 'storages' in manifest['program_graph']['source'] else facts['storages']
    buffers = [storages[i] for i in indices]
    h.save(out / 'abi.json', {'storage_indices': indices, 'buffers': [{k: s['id'] if k == 'name' else s[k]
                for k in ('name', 'shape', 'dtype', 'role')} for s in buffers]})
    files = sorted((out / 'programs').glob('wave*.air.mlir'),
                   key=lambda p: int(p.name.removeprefix('wave').split('.')[0]))
    if not files:
        raise RuntimeError('normal CLI did not produce executable AIR waves')
    direct = h.execute_module()
    bindings = []
    for index, air in enumerate(files):
        folder = out / f'wave-{index}'
        folder.mkdir()
        artifact = direct.compile_air(air, folder / 'hardware', omit_ping_pong=True)
        final = folder / 'hardware/air_project/npu.input.air.mlir'
        generic = folder / 'final-aie.generic.mlir'
        h.command(folder, 'extract-aie', ['air-opt', final, '--mlir-print-op-generic', '-o', generic])
        h.command(folder, 'check-aie', [a.tool, source, '--target-config=' + str(target),
                  '--check-placed-wave=' + str(index), '--check-aie=' + str(generic),
                  '--implementation-output=' + str(folder / 'aie-check.json')])
        bindings.append({'index': index, 'air': h.ident(air), 'final_aie': h.ident(generic),
                         'checker': h.ident(folder / 'aie-check.json'),
                         'elf': h.ident(Path(artifact['elf_path']))})
    h.save(out / 'compiled.json', {'status': 'compiled-and-independently-checked',
           'source': h.ident(source), 'target': h.ident(target), 'tool': h.ident(a.tool),
           'script': h.ident(Path(__file__)), 'waves': bindings,
           'global_program_files': [h.ident(p) for p in sorted((out / 'programs').iterdir()) if p.is_file() and p.suffix == '.json'],
           'device_submissions': 0, 'performance_claim': False})


def execute_inputs(a):
    import numpy as np
    from triton.backends.amd_triton_npu import multilaunch
    from triton.backends.amd_triton_npu.multilaunch import MultiLaunchRunner
    from taskflow_npu_trace_v3 import ObservedXRT, ObservedRun
    out = a.output.resolve()
    compiled = json.loads((out / 'compiled.json').read_text())
    for item in [compiled['source'], compiled['target'], *[w[k] for w in compiled['waves']
                 for k in ('air', 'final_aie', 'checker', 'elf')], *compiled['global_program_files']]:
        assert h.ident(Path(item['path'])) == item, ('binding changed', item)
    abi = json.loads((out / 'abi.json').read_text())['buffers']
    stateful = any(b['role'] == 'state' for b in abi)
    if stateful:
        assert len(abi) == 1 and abi[0]['role'] == 'state'
    calls = 3 if stateful else 1
    previous_wait = multilaunch._wait
    multilaunch._wait = lambda run: previous_wait(run.raw if isinstance(run, ObservedRun) else run)
    summaries = []
    try:
        with open('/tmp/npu.lock', 'w') as lock:
            fcntl.flock(lock, fcntl.LOCK_EX)
            for seed in (11, 23, 47):
                folder = out / f'seed-{seed}'
                folder.mkdir(exist_ok=False)
                x = np.random.default_rng(seed).uniform(-1, 1, abi[0]['shape']).astype('float32')
                arrays = [x.copy() if b['role'] in ('input', 'state') else
                          np.zeros(b['shape'], dtype='float32') for b in abi]
                expected = x.copy()
                h.save(folder / 'abi.json', abi)
                np.savez(folder / 'initial.npz', **{b['name']: v for b, v in zip(abi, arrays)})
                shared = None
                identities = None
                for call in range(calls):
                    expected = np.add(expected if stateful else x,
                                      expected if stateful else x, dtype=np.float32)
                    for wave in compiled['waves']:
                        index = wave['index']
                        artifact = json.loads((out / f'wave-{index}/hardware/compile.json').read_text())
                        events = []
                        runner = MultiLaunchRunner(artifact['elf_path'], artifact['kernel_name'])
                        runner._xrt = ObservedXRT(runner._xrt, events)
                        if shared is None:
                            # Allocate the full source-bound ABI once. Only real
                            # initialized inputs/state cross the host boundary;
                            # private cut BOs and overwritten outputs are not
                            # zeroed or synchronized TO_DEVICE from the host.
                            device_owner = runner.device
                            sizes = [array.nbytes for array in arrays]
                            bos = [runner._xrt.ext.bo(device_owner, size) for size in sizes]
                            shared = (sizes, bos)
                            for i, buffer in enumerate(abi):
                                if buffer['role'] not in ('input', 'state'):
                                    continue
                                destination = np.frombuffer(bos[i].map(), dtype=np.uint8, count=sizes[i])
                                np.copyto(destination, arrays[i].view(np.uint8).reshape(-1))
                                bos[i].sync(runner._xrt.xclBOSyncDirection.XCL_BO_SYNC_BO_TO_DEVICE)
                        # Existing BOs are independent of each wave's hw_context.
                        # An established cache with every index static prohibits
                        # host staging or zeroing between configurations/calls.
                        runner._bos['global-program'] = shared
                        for bo in shared[1]:
                            bo.events = events
                        outputs = {i for i,b in enumerate(abi) if b['role'] in ('output','state')}
                        final = index == len(compiled['waves']) - 1
                        actual = runner.run(arrays, bo_key='global-program',
                                            static_indices=tuple(range(len(arrays))),
                                            output_indices=outputs if final else set())
                        shared = runner._bos['global-program']
                        current = [id(b.raw if hasattr(b, 'raw') else b) for b in shared[1]]
                        if identities is None:
                            identities = current
                        assert current == identities, 'wave changed actual global BO identity'
                        submissions = sum(e.get('kind') == 'actual_xrt_start' for e in events)
                        assert submissions == 1, 'wave did not perform exactly one actual submission'
                        uploads = sum(e.get('kind') == 'actual_bo_sync' and 'TO_DEVICE' in e['direction'] for e in events)
                        assert uploads == (sum(b['role'] in ('input', 'state') for b in abi) if call == 0 and index == 0 else 0), 'unexpected host staging between waves/calls'
                        # The saved full trace is the authority for runtime calls.
                        h.save(folder / f'call-{call}-wave-{index}.trace.json', events)
                        if final:
                            for i in outputs:
                                value = actual[i].copy()
                                assert np.isfinite(value).all() and np.array_equal(value, expected)
                                np.savez(folder / f'call-{call}-output-{i}.npz', actual=value, reference=expected)
                        runner.unload()
                    summaries.append({'seed': seed, 'call': call,
                                      'wave_invocations': len(compiled['waves']),
                                      'same_global_bo_identity': True, 'max_abs': 0.0})
    finally:
        multilaunch._wait = previous_wait
    h.save(out / 'executed.json', {'status': 'passed', 'calls': summaries,
           'device_submissions': len(summaries) * len(compiled['waves']),
           'warmups': 0, 'performance_claim': False})


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--stage', choices=('compile', 'execute'), required=True)
    p.add_argument('--tool', type=Path, required=True)
    p.add_argument('--source', type=Path)
    p.add_argument('--target', type=Path)
    p.add_argument('--output', type=Path, required=True)
    a = p.parse_args()
    a.tool = a.tool.resolve()
    if a.stage == 'compile':
        if not a.source or not a.target:
            p.error('compile requires --source and --target')
        compile_inputs(a)
    else:
        h.execute_module()  # establish runtime script/module search path
        execute_inputs(a)


if __name__ == '__main__':
    main()
