#!/usr/bin/env python3
"""Capture a CPU-only BO-sync target identity and bind a separate observed probe.

No device is opened. Probe branch observations describe that invocation only;
this collector does not infer DDR traffic, cache completion, or past runtime state.
"""
import argparse
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import platform
import subprocess


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def canonical(value):
    return json.dumps(value, sort_keys=True, separators=(',', ':')).encode()


def config_snapshot():
    keys = ('XRT_INI_PATH', 'XRT_INI_DIR', 'XRT_LOG_LEVEL', 'XRT_EMULATION_MODE', 'XILINX_XRT')
    paths = {Path.cwd() / 'xrt.ini', Path.home() / 'xrt.ini'}
    if os.environ.get('XRT_INI_PATH'):
        paths.add(Path(os.environ['XRT_INI_PATH']).expanduser())
    if os.environ.get('XRT_INI_DIR'):
        paths.add(Path(os.environ['XRT_INI_DIR']).expanduser() / 'xrt.ini')
    return dict(cwd=str(Path.cwd()), environment={k: os.environ.get(k) for k in keys},
                candidate_files=[dict(path=str(p.resolve()), exists=p.is_file(),
                                      sha256=sha(p) if p.is_file() else None) for p in sorted(paths)],
                selected_config_file_observed=False)


def collect_snapshot():
    """Stable CPU-only current identity; no probe paths, timings, or device import."""
    config = config_snapshot()
    base = Path('/usr/lib/x86_64-linux-gnu')
    files = {}
    for pattern in ('libxrt_core*.so.2.21.75', 'libxrt_driver_xdna.so.2.21.75'):
        for path in sorted(base.glob(pattern)):
            files[str(path.resolve())] = sha(path)
    candidates = list(Path('/usr/lib/python3/dist-packages').glob('pyxrt.*.so'))
    if len(candidates) != 1:
        raise RuntimeError('Expected exactly one installed pyxrt extension')
    pyxrt = str(candidates[0].resolve())
    files[pyxrt] = sha(pyxrt)
    module = Path('/lib/modules') / os.uname().release / 'kernel/drivers/accel/amdxdna/amdxdna.ko.zst'
    files[str(module)] = sha(module)
    srcversion = Path('/sys/module/amdxdna/srcversion').read_text().strip()
    packages = subprocess.check_output(['dpkg-query', '-W', '-f=${Package}=${Version}\n',
                                       'python3-xrt', 'libxrt2', 'libxrt-npu2', 'libxrt-dev'], text=True).splitlines()
    cpu = {}
    for line in Path('/proc/cpuinfo').read_text().split('\n\n')[0].splitlines():
        if ':' in line:
            key, value = (s.strip() for s in line.split(':', 1))
            if key in ('vendor_id', 'cpu family', 'model', 'model name', 'stepping', 'microcode', 'clflush size', 'cache_alignment'):
                cpu[key] = value
    runtime = dict(machine=platform.machine(), kernel_release=os.uname().release,
                   loaded_module_srcversion=srcversion, packages=packages, cpu=cpu,
                   module_correspondence='file srcversion matched sysfs; not a live kernel-memory hash')
    target = dict(schema='orbit.sync-target.v14', files=files, runtime=runtime, config=config)
    target['target_id'] = hashlib.sha256(canonical(target)).hexdigest()
    return target


def collect(probe):
    freeze = json.loads((probe / 'freeze.json').read_text())
    for name, expected in freeze['files'].items():
        if sha(name) != expected:
            raise RuntimeError('Probe-bound file changed: ' + name)
    target = collect_snapshot()
    original = freeze['config']
    original['candidate_files'] = [{k: v for k, v in x.items() if k != 'snapshot'}
                                   for x in original['candidate_files']]
    if original != target['config']:
        raise RuntimeError('Current cwd/config differs from observed probe')
    if (target['runtime']['loaded_module_srcversion'] != freeze['loaded_module_srcversion'] or
            target['runtime']['kernel_release'] != freeze['kernel_release']):
        raise RuntimeError('Running kernel/module identity differs from probe')
    evidence = {}
    for name in ('gdb.merged.log', 'strace.log', 'freeze.json', 'probe-gdb.json', 'probe-strace.json'):
        path = probe / name
        if not path.is_file():
            raise RuntimeError('Required completed probe evidence missing: ' + str(path))
        evidence[str(path)] = sha(path)
    return target, dict(schema='orbit.sync-target-observation.v14', target_id=target['target_id'],
                        files=evidence, scope='separate new-process probe; not historical v13 state',
                        observer_file=dict(path=str(Path(__file__).resolve()), sha256=sha(__file__)))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--probe-root', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    target, observation = collect(args.probe_root.resolve())
    args.output.mkdir(parents=True, exist_ok=False)
    for name, value in (('target-fingerprint.json', target), ('observation-binding.json', observation)):
        (args.output / name).write_text(json.dumps(value, indent=2) + '\n')
    print(json.dumps(dict(status='captured', target_id=target['target_id'], device_opened=False,
                          target=str(args.output / 'target-fingerprint.json'))))


if __name__ == '__main__':
    main()
