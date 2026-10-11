#!/usr/bin/env python3
"""Execute only the exact Root-authorized GCN64 mechanism command once."""
import fcntl
import hashlib
import json
import os
from pathlib import Path
import subprocess
import time
import sys
sys.path.insert(0,str(Path(__file__).resolve().parent / "diagnosis/python-deps"))
import ijson

import diagnosis_critical_positive_compute_v38_sharedlocal as sharedlocal

R = Path(__file__).resolve().parent
B = R / 'diagnosis/search-regression-repair-20261010'
P = B / 'critical-positive-compute-v38-prepared1'
AUTH = P / 'ROOT-gcn-full64-authorization-v2.json'
PLAN = P / 'gcn-full64-runner-binding-v2.json'


def sha(path):
    path = Path(path)
    before = path.stat()
    digest = hashlib.sha256()
    with path.open('rb') as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b''):
            digest.update(chunk)
    after = path.stat()
    assert (before.st_size, before.st_mtime_ns) == (after.st_size, after.st_mtime_ns), str(path)
    return digest.hexdigest()


def intact(hashes):
    for path, digest in hashes.items():
        assert sha(path) == digest, 'Changed input: ' + path


def main():
    AUTH_SHA = sha(AUTH); PLAN_SHA = sha(PLAN)
    auth = json.loads(AUTH.read_text())
    plan = json.loads(PLAN.read_text())
    assert auth['status'] == 'pass' and auth['scope'] == 'exact-independent-v38-gcn-full64-critical-positive-compute-mechanism-check'
    assert auth['argv'] == plan['argv'] and auth['output'] == plan['output']
    assert auth['input_sha256'] == plan['input_sha256']
    assert auth['runner_binding_sha256'] == PLAN_SHA and auth['objective_call_cap'] == 64
    assert auth['native_calls_authorized'] == auth['numeric_calls_authorized'] == 0
    assert auth['shared_admission_peak_gib'] == 9 and auth['admission_wait_seconds'] == 60
    assert plan['source_commit'] == '76345481683a2e199c0cad155de2acb51149f350'
    assert plan['budget_cap'] == 64 and plan['retained_communication_window'] is True and plan['critical_positive_compute'] is True
    assert plan['actual_policy'] == 'schedule-structure-critical-positive-compute-v38'
    assert plan['preregistration_sha256'] == sha(P / 'PREREGISTRATION.json') == 'e04d2d10e9b3ca63b4425d805a1f2c11fc2d8e17c662c81ccbdf980c9fcfc38a'
    assert ijson.__version__ == plan['validator_parser_version']
    unit = Path(plan['output'])
    unit.mkdir(parents=True, exist_ok=True)
    with (unit / '.v38-owner.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        assert not (unit / 'driver-binding.json').exists(), 'Prior unit preserved; no retry permitted'
        hashes = dict(plan['input_sha256'])
        for path in [Path(__file__).resolve(), Path(sharedlocal.__file__).resolve(), AUTH, PLAN]:
            hashes[str(path)] = sha(path)
        intact(hashes)
        binding = dict(schema='orbit-v38-authorized-mechanism-driver-v1', argv=plan['argv'],
            cwd=plan['cwd'], output=str(unit), driver_sha256=sha(__file__),
            root_authorization_sha256=AUTH_SHA, runner_binding_sha256=PLAN_SHA,
            source_commit=plan['source_commit'], optimizer_sha256=plan['optimizer_sha256'],
            source_hashes=hashes, objective_call_cap=64, native_call_cap=0, numeric_call_cap=0,
            actual_policy=plan['actual_policy'], paper_admission=False,
            resource_environment=plan['resource_environment'], stage_peak_gib=9,
            pid=os.getpid(), start=int(Path(f'/proc/{os.getpid()}/stat').read_text().rsplit(')', 1)[1].split()[19]))
        sharedlocal.write(unit / 'driver-binding.json', binding)
        leased = False
        try:
            sharedlocal.acquire(unit, 9)
            leased = True
            intact(hashes)
            sharedlocal.write(unit / 'worker-status.json', dict(status='search', pid=os.getpid(), epoch=time.time()))
            env = os.environ.copy()
            env.update(plan['resource_environment'])
            started = time.monotonic()
            with (unit / 'launch.stdout').open('wb') as stdout, (unit / 'launch.stderr').open('wb') as stderr:
                proc = subprocess.run(['/usr/bin/time', '-v', '-o', str(unit / 'usage.txt'),
                    *plan['argv']], cwd=plan['cwd'], env=env, stdout=stdout, stderr=stderr,
                    timeout=23400)
            sharedlocal.write(unit / 'launch-receipt.json', dict(binding={'argv': plan['argv'],
                'script_sha256':plan['wrapper_sha256']}, returncode=proc.returncode,
                wall_seconds=time.monotonic()-started, resource_environment=plan['resource_environment']))
            intact(hashes)
            assert proc.returncode == 0, 'Exact search command failed; preserved without retry'
            # Read only small receipt fields after the subprocess has closed all outputs.
            # Mechanism and semantic-edge audit is a separate, read-only step.
            with (unit / 'result.json').open('rb') as stream:
                status = next(ijson.items(stream, 'status'))
            assert status == 'completed'
            with (unit / 'result.json').open('rb') as stream:
                objective = next(ijson.items(stream, 'objective_evaluations'))
            assert objective == 64
            with (unit / 'result.json').open('rb') as stream:
                outputs = next(ijson.items(stream, 'artifact_hashes'))
            intact(outputs)
            files = [unit / n for n in ['result.json', 'launch-receipt.json', 'launch.stdout',
                'launch.stderr', 'usage.txt', 'driver-binding.json', 'admission.json']]
            sharedlocal.write(unit / 'search-completion.json', dict(status='search-completed-unverified',
                source_commit=plan['source_commit'], actual_policy=plan['actual_policy'],
                objective_calls=objective, native_calls=0, numeric_calls=0,
                root_authorization_sha256=AUTH_SHA, runner_binding_sha256=PLAN_SHA,
                inputs_pre_post_verified=True, driver_sha256=sha(__file__),
                artifact_hashes={**outputs, **{str(p):sha(p) for p in files}},
                mechanism_audit='pending', paper_admission=False, epoch=time.time()))
            sharedlocal.write(unit / 'worker-status.json', dict(status='search-completed-awaiting-mechanism-audit',
                objective_calls=objective, native_calls=0, numeric_calls=0, pid=os.getpid(), epoch=time.time()))
            print(json.dumps(dict(status='search-completed-unverified', output=str(unit), objective_calls=objective)), flush=True)
        except Exception as error:
            sharedlocal.write(unit / 'failure.json', dict(status='failed', error=str(error),
                no_retry=True, root_authorization_sha256=AUTH_SHA, epoch=time.time()))
            sharedlocal.write(unit / 'worker-status.json', dict(status='failed', error=str(error),
                no_retry=True, pid=os.getpid(), epoch=time.time()))
            raise
        finally:
            if leased:
                sharedlocal.release()


if __name__ == '__main__':
    main()
