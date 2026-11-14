#!/usr/bin/env python3
"""Compile checked C++ source replicas/shapes; numerical validation only.

No graph decisions, search, synthetic speedup or custom compute kernels.
State runs share one actual XRT BO and upload initial state only once.
"""
import argparse
import fcntl
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys

LABELS = ('replica6-fission', 'shape2x2', 'state2x2')


def save(path, value):
    path.write_text(json.dumps(value, indent=2) + '\n')


def ident(path):
    return {'path': str(path.resolve()), 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()}


def command(folder, name, cmd):
    save(folder / (name + '.command.json'), list(map(str, cmd)))
    with (folder / (name + '.log')).open('w') as log:
        r = subprocess.run(list(map(str, cmd)), stdout=log, stderr=subprocess.STDOUT)
    save(folder / (name + '.returncode.json'), {'returncode': r.returncode})
    if r.returncode:
        raise RuntimeError(f'{name} failed; see {folder}')


def execute_module():
    path = Path('/home/shiran/project/orbit-artifact/taskflow/scripts/taskflow_direct_air_execute.py')
    sys.path.insert(0, str(path.parent))
    spec = importlib.util.spec_from_file_location('direct_air_executor', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def compile_inputs(a):
    out = a.output.resolve()
    out.mkdir(parents=True, exist_ok=False)
    direct = execute_module()
    for label in LABELS:
        folder = out / label
        folder.mkdir()
        for suffix in ('source.mlir', 'air.mlir', 'manifest.json', 'target.json'):
            shutil.copy2(a.input / (label + '.' + suffix), folder / suffix)
        source = folder / 'source.mlir'
        command(folder, 'facts', [a.tool, source, '--normalize-taskflow-source',
                '--source-normalization-witness=' + str(folder / 'normalization.json'),
                '--generic-analyze', '--analysis-output=' + str(folder / 'facts.json'),
                '--emit-mlir=' + str(folder / 'normalized.mlir')])
        facts = json.loads((folder / 'facts.json').read_text())
        buffers = [s for s in facts['storages'] if s['role'] in ('input', 'output', 'state')]
        save(folder / 'abi.json', {'buffers': [{'name': s['id'], **{k: s[k] for k in ('shape', 'dtype', 'role')}} for s in buffers],
                                  'outputs': [s['id'] for s in buffers if s['role'] in ('output', 'state')]})
        artifact = direct.compile_air(folder / 'air.mlir', folder / 'hardware', omit_ping_pong=True)
        final = folder / 'hardware/air_project/npu.input.air.mlir'
        generic = folder / 'final-aie.generic.mlir'
        command(folder, 'extract-aie', ['air-opt', final, '--mlir-print-op-generic', '-o', generic])
        command(folder, 'check-aie', [a.tool, source, '--target-config=' + str(folder / 'target.json'),
                '--check-aie=' + str(generic), '--implementation-output=' + str(folder / 'aie-check.json'),
                '--implementation-facts-output=' + str(folder / 'aie-facts.json'),
                '--analysis-output=' + str(folder / 'check-analysis.json')])
        save(folder / 'binding.json', {'source': ident(source), 'air': ident(folder / 'air.mlir'),
                'aie': ident(final), 'generic_aie': ident(generic), 'checker_receipt': ident(folder / 'aie-check.json'),
                'elf': ident(Path(artifact['elf_path'])), 'tool': ident(a.tool), 'script': ident(Path(__file__))})
    save(out / 'compiled.json', {'status': 'compiled-and-independently-checked', 'device_submissions': 0,
                                'physical_speedup_claim': False})


def persistent_state(folder, artifact, abi, seed):
    import numpy as np
    from triton.backends.amd_triton_npu import multilaunch
    from triton.backends.amd_triton_npu.multilaunch import MultiLaunchRunner
    from taskflow_npu_trace_v3 import ObservedXRT, ObservedRun
    assert len(abi['buffers']) == 1 and abi['buffers'][0]['role'] == 'state'
    state = np.random.default_rng(seed).uniform(-1, 1, abi['buffers'][0]['shape']).astype('float32')
    expected = state.copy()
    np.savez(folder / 'initial-state.npz', S=state)
    events = []
    runner = MultiLaunchRunner(artifact['elf_path'], artifact['kernel_name'])
    runner._xrt = ObservedXRT(runner._xrt, events)
    previous_wait = multilaunch._wait
    multilaunch._wait = lambda run: previous_wait(run.raw if isinstance(run, ObservedRun) else run)
    rows = []
    bo_identity = None
    try:
        for call in range(3):
            events.clear()
            expected = np.add(expected, expected, dtype=np.float32)
            # This flag controls host staging only. Device writes to this same
            # BO persist; the unchanged host initial-state array is never copied
            # back over them after call one.
            outputs = runner.run([state], bo_key='persistent-state', static_indices=(0,), output_indices={0})
            actual = outputs[0].copy()
            bo = runner._bos['persistent-state'][1][0]
            current_identity = id(bo.raw if hasattr(bo, 'raw') else bo)
            if bo_identity is None:
                bo_identity = current_identity
            assert current_identity == bo_identity, 'state BO changed between calls'
            passed = bool(np.isfinite(actual).all() and np.array_equal(actual, expected))
            np.savez(folder / f'call-{call+1}-output.npz', S=actual)
            np.savez(folder / f'call-{call+1}-reference.npz', S=expected)
            row = {'call': call + 1, 'passed': passed,
                   'max_abs': float(np.max(np.abs(actual - expected))),
                   'actual_bo_object_identity': current_identity,
                   'actual_events': list(events),
                   'submissions': sum(e['kind'] == 'actual_xrt_start' for e in events)}
            row['host_to_device_syncs'] = sum(e['kind'] == 'actual_bo_sync' and 'TO_DEVICE' in e['direction'] for e in events)
            assert row['host_to_device_syncs'] == (1 if call == 0 else 0)
            assert row['submissions'] == 1
            rows.append(row)
            save(folder / 'result.json', {'status': 'passed' if all(r['passed'] for r in rows) else 'failed',
                    'calls': rows, 'state_storage': 'one XRT BO reused across calls; not persistent AIE SRAM',
                    'host_initial_upload': 'first call only; later state remains in the same BO',
                    'physical_speedup_claim': False})
            if not passed:
                raise RuntimeError('persistent state numerical mismatch')
    finally:
        multilaunch._wait = previous_wait
        del runner


def execute_inputs(a):
    import numpy as np
    direct = execute_module()
    # Sole device-lock owner; no outer shell flock and no search/compile here.
    with open('/tmp/npu.lock', 'w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        for label in LABELS:
            folder = a.output.resolve() / label
            assert json.loads((folder / 'aie-check.json').read_text())['valid']
            binding = json.loads((folder / 'binding.json').read_text())
            for key, item in binding.items():
                if key in ('script', 'tool'):
                    continue
                assert ident(Path(item['path'])) == item, (key, 'binding changed')
            artifact = json.loads((folder / 'hardware/compile.json').read_text())
            abi = json.loads((folder / 'abi.json').read_text())
            for seed in (11, 23, 47):
                result_folder = folder / f'seed-{seed}'
                result_folder.mkdir(exist_ok=False)
                if label == 'state2x2':
                    persistent_state(result_folder, artifact, abi, seed)
                    continue
                x = np.random.default_rng(seed).uniform(-1, 1, (64, 64)).astype('float32')
                inputs = {b['name']: x for b in abi['buffers'] if b['role'] == 'input'}
                reference = {b['name']: np.add(x, x, dtype=np.float32) for b in abi['buffers'] if b['role'] == 'output'}
                np.savez(result_folder / 'inputs.npz', **inputs)
                np.savez(result_folder / 'reference.npz', **reference)
                result = direct.run_artifact(artifact, abi, inputs, reference, result_folder, 1, 1e-5, 1e-5, warmups=0)
                result['physical_speedup_claim'] = False
                result['validation_scope'] = 'one numerical launch; no performance comparison'
                save(result_folder / 'result.json', result)
                assert result['status'] == 'passed'
    submissions = 0
    for result_path in a.output.glob('*/seed-*/result.json'):
        record = json.loads(result_path.read_text())
        submissions += sum(r['submissions'] for r in record['calls']) if 'calls' in record else sum(record['actual_submissions'])
    save(a.output / 'executed.json', {'status': 'passed', 'device_submissions': submissions,
                'scope': '2 ordinary variants x3 seeds plus 3 persistent-state calls x3 seeds', 'physical_speedup_claim': False})


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--tool', type=Path, required=True)
    p.add_argument('--input', type=Path)
    p.add_argument('--output', type=Path, required=True)
    p.add_argument('--stage', choices=('compile', 'execute'), required=True)
    a = p.parse_args()
    a.output = a.output.resolve()
    a.tool = a.tool.resolve()
    if a.stage == 'compile':
        if not a.input:
            p.error('--input C++ emitted fixture directory is required for compilation')
        compile_inputs(a)
    else:
        execute_inputs(a)


if __name__ == '__main__':
    main()
