#!/usr/bin/env python3
"""Run a frozen matched cohort after an existing host experiment exits.

Candidate search and native validation are delegated to the common coordinator.
The queue waits on a process descriptor, without polling experiment results.
"""
import argparse
import ctypes
import errno
import json
import os
from pathlib import Path
import select
import subprocess
import threading
import time

import neighborhood_replay as replay
import run_sequential_comparison as comparison
import show_sequential_comparison as evidence
import spill_sequential_catalogues as spill
from sequential_validation_audit import require_complete_validation


def wait_for_host_process(pid, required_command):
    if not pid:
        return {'wait_seconds': 0, 'reason': 'no prior process'}
    started = time.monotonic()
    path = Path(f'/proc/{pid}/cmdline')
    try:
        command = path.read_bytes().replace(b'\0', b' ').decode()
    except FileNotFoundError:
        return {'wait_seconds': 0, 'reason': 'prior process already exited', 'pid': pid}
    if required_command not in command:
        raise ValueError('prior PID no longer identifies the bound queue')
    libc = ctypes.CDLL(None, use_errno=True)
    descriptor = (libc.pidfd_open(ctypes.c_int(pid), ctypes.c_uint(0))
                  if hasattr(libc, 'pidfd_open') else
                  libc.syscall(ctypes.c_long(434), ctypes.c_int(pid), ctypes.c_uint(0)))
    if descriptor < 0:
        if ctypes.get_errno() == errno.ESRCH:
            return {'wait_seconds': time.monotonic() - started, 'reason': 'prior process exited', 'pid': pid}
        raise OSError(ctypes.get_errno(), 'pidfd_open')
    try:
        select.select([descriptor], [], [])
    finally:
        os.close(descriptor)
    return {'wait_seconds': time.monotonic() - started, 'pid': pid,
            'mechanism': 'blocking Linux pidfd; no result polling', 'command': command}


def verify_files(rows):
    for row in rows:
        if comparison.file_binding(row['path']) != row:
            raise ValueError('frozen queue payload changed: ' + row['path'])


def run_phase(phase, environment, staging, supervisor_pid):
    root = Path(phase['output_root'])
    status_path = root / 'parallel-process.json'
    status = {'supervisor_pid': supervisor_pid, 'status': 'starting',
              'started_unix': time.time(), 'argv': phase['argv']}
    replay.atomic_write(status_path, status)
    stop = threading.Event()
    errors = []

    def relocate_catalogues():
        stamps = {}
        while not stop.is_set():
            for checkpoint in root.glob('*/*/checkpoint.json'):
                cell = checkpoint.parent
                if (cell / 'raw-auxiliary-manifest.json').exists():
                    continue
                try:
                    stamp = checkpoint.stat().st_mtime_ns
                    if stamps.get(str(checkpoint)) == stamp:
                        continue
                    spill.relocate(cell, staging)
                    stamps[str(checkpoint)] = stamp
                except FileNotFoundError:
                    # The completed-cell compactor can finish between the
                    # checkpoint discovery and the storage operation.
                    if not (cell / 'raw-auxiliary-manifest.json').exists():
                        errors.append({'cell': str(cell), 'error': 'live checkpoint disappeared'})
                except Exception as error:
                    errors.append({'cell': str(cell), 'error': str(error), 'time_unix': time.time()})
                    replay.atomic_write(root / 'storage-errors.json', errors)
            stop.wait(20)

    with (root / 'coordinator.log').open('a') as log:
        process = subprocess.Popen(phase['argv'], cwd=phase['cwd'], env=environment,
            stdin=subprocess.DEVNULL, stdout=log, stderr=subprocess.STDOUT)
        status.update(status='running', coordinator_pid=process.pid)
        replay.atomic_write(status_path, status)
        if phase['role'] == 'supplement':
            replay.atomic_write(root / 'supplement-state.json', status)
        thread = threading.Thread(target=relocate_catalogues, daemon=True)
        thread.start()
        try:
            code = process.wait()
        finally:
            stop.set()
            thread.join()
    status.update(status='exited' if code == 0 else 'failed', exit_code=code, ended_unix=time.time())
    replay.atomic_write(status_path, status)
    if code:
        raise ValueError('coordinator exited: ' + str(root) + '; code=' + str(code))
    batch = comparison.read(root / 'batch.json')
    if batch.get('status') != 'complete' or len(batch.get('cells', [])) != phase['expected_cells']:
        raise ValueError('coordinator did not commit a complete batch')
    cells = [(w, m) for w in phase['workloads'] for m in phase['methods']]
    for workload, method in cells:
        cell = root / workload / method
        require_complete_validation(comparison.read(cell / 'result.json'))
        spill.cleanup_archived(cell)
    evidence.audit_bindings(root, cells)
    if phase['role'] == 'supplement':
        replay.atomic_write(root / 'supplement-state.json', {**status, 'status': 'complete'})
    return {**status, 'storage_errors': errors}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--manifest', type=Path, required=True)
    args = parser.parse_args()
    manifest_path = args.manifest.resolve()
    manifest = comparison.read(manifest_path)
    if manifest.get('schema') != 'orbit-sequential-fixed-fission-queue-v1':
        raise ValueError('unknown queue schema')
    state_path = Path(manifest['state_path'])
    supervisor_pid = os.getpid()
    state = {'status': 'checking', 'supervisor_pid': supervisor_pid, 'started_unix': time.time(),
             'manifest': comparison.file_binding(manifest_path), 'completed_phases': []}
    replay.atomic_write(state_path, state)
    try:
        verify_files(manifest['runtime_bindings'])
        acceptance = comparison.read(manifest['acceptance_file'])
        if acceptance.get('status') != 'accepted' or acceptance.get('optimizer') != manifest['optimizer']:
            raise ValueError('this optimizer has no accepted end-to-end smoke record')
        state.update(status='waiting-prior-process-exit', prior_pid=manifest['prior_pid'],
                     wait_mechanism='blocking Linux pidfd; no result polling')
        replay.atomic_write(state_path, state)
        released = wait_for_host_process(manifest['prior_pid'], manifest['prior_command_match'])
        # A prior failed coordinator must not leave orphan optimizers using
        # the same host. Inspect once at the release boundary.
        for path in Path('/proc').glob('[0-9]*/cmdline'):
            try:
                words = path.read_bytes().split(b'\0')
            except (OSError, ProcessLookupError):
                continue
            if words and words[0].decode(errors='replace') in manifest.get('prior_optimizer_paths', []):
                raise ValueError('prior optimizer still active after coordinator exit: ' + str(path))
        verify_files(manifest['runtime_bindings'])
        state.update(status='running', prior_release=released)
        replay.atomic_write(state_path, state)
        environment = dict(os.environ, **manifest['environment'])
        for phase in manifest['phases']:
            status = run_phase(phase, environment, Path(manifest['staging_root']), supervisor_pid)
            state['completed_phases'].append({'role': phase['role'], **status})
            replay.atomic_write(state_path, state)
        report = subprocess.run(manifest['report_argv'], cwd=manifest['artifact_root'], env=environment,
                                capture_output=True, text=True)
        Path(manifest['report_log']).write_text(report.stdout + report.stderr)
        replay.atomic_write(Path(manifest['report_log']).with_suffix('.json'), {'argv': manifest['report_argv'],
            'exit_code': report.returncode, 'stdout': report.stdout, 'stderr': report.stderr})
        if report.returncode:
            raise ValueError('final evidence report failed; see ' + manifest['report_log'])
        state.update(status='complete', ended_unix=time.time())
        replay.atomic_write(state_path, state)
    except Exception as error:
        state.update(status='failed', error=str(error), ended_unix=time.time())
        replay.atomic_write(state_path, state)
        supplement = next(p for p in manifest['phases'] if p['role'] == 'supplement')
        replay.atomic_write(Path(supplement['output_root']) / 'supplement-state.json',
                            {'status': 'failed', 'error': str(error)})
        raise


if __name__ == '__main__':
    main()
