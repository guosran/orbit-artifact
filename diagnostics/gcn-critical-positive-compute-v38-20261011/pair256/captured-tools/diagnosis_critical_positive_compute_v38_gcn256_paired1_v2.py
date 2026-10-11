#!/usr/bin/env python3
"""One canonical Source38 Full/Replica256 research search and original exact5 validation; frozen Root binding required."""
import argparse
import fcntl
import hashlib
import json
import os
from pathlib import Path
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent / "diagnosis/python-deps"))
import shutil
import time

from diagnosis_run import R, O, PY, read, run
from diagnosis_admission import inventory, process_table, GIB
import diagnosis_host_admission as host
from diagnosis_seal import seal_native_process, seal_numeric_process
import diagnosis_directional_ablation as original
import diagnosis_v35_main256_outcome_support_draft3_20261011 as native_support
import diagnosis_exact_shortlist_candidate_outcome_audit_20261011 as outcome
import diagnosis_exact_shortlist_candidate_outcome_seal_20261011 as postclose
from diagnosis_directional_tiling_chain_audit import root_members

SOURCE = '76345481683a2e199c0cad155de2acb51149f350'
OPTIMIZER = '9996d1b97787242cea42d88511ce530bfa4cb523883705b0746a72a1ff17d7cc'
POLICY = 'schedule-structure-critical-positive-compute-v38'
NATIVE = '80f11127c25360b591cbd705d3e7d25d3060ba90cf2978f8d5a56133cf58a761'
ENVIRONMENT = dict(OMP_NUM_THREADS='1', OPENBLAS_NUM_THREADS='1', MKL_NUM_THREADS='1',
    MALLOC_ARENA_MAX='2', MALLOC_TRIM_THRESHOLD_='131072', MALLOC_MMAP_THRESHOLD_='131072')


def require(ok, message):
    if not ok:
        raise ValueError(message)


def sha(path):
    path = Path(path)
    before = path.stat()
    digest = hashlib.sha256()
    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1 << 20), b''):
            digest.update(block)
    after = path.stat()
    require((before.st_size, before.st_mtime_ns) == (after.st_size, after.st_mtime_ns),
        'Input changed during hash: ' + str(path))
    return digest.hexdigest()


def intact(hashes):
    for path, digest in hashes.items():
        require(sha(path) == digest, 'Changed input: ' + path)


def write(path, value, exclusive=False):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    if exclusive:
        with path.open('x') as stream:
            json.dump(value, stream, indent=2); stream.write('\n')
    else:
        pending = path.with_name(path.name + f'.{os.getpid()}.pending')
        pending.write_text(json.dumps(value, indent=2) + '\n')
        pending.replace(path)


def acquire(directory, workload, peak):
    """Hold the whole-worker reservation through final post-close evidence."""
    while True:
        with (O/'.study-admission.lock').open('a') as lock:
            fcntl.flock(lock, fcntl.LOCK_EX)
            state = inventory()
            require(not any(x['unit'] == str(directory) for x in state['workers']), 'Unit already owned')
            decision = host.decision(state, peak)
            disk = shutil.disk_usage(O).free
            if decision['admitted'] and disk >= 50 * GIB:
                table = process_table()
                leases = [dict(pid=x['pid'], start=x['start'], suite=x['suite'],
                    cell=x['cell'], unit=x['unit']) for x in state['workers']]
                leases.append(dict(pid=os.getpid(), start=table[os.getpid()]['start'],
                    suite='source38-paired256-targeted', cell=[256, workload, directory.name], unit=str(directory)))
                write(O/'admission_leases.json', leases)
                host.register(os.getpid(), table[os.getpid()]['start'], peak)
                write(directory/'admission.json', dict(status='admitted', host_decision=decision,
                    minimum_disk_bytes=50*GIB, actual_free_disk_bytes=disk,
                    whole_worker_peak_gib=peak, pid=os.getpid(), pid_start=table[os.getpid()]['start'], epoch=time.time()))
                return
            write(directory/'worker-status.json', dict(status='waiting-for-shared-admission',
                host_decision=decision, minimum_disk_bytes=50*GIB, actual_free_disk_bytes=disk,
                reservation_gib=peak, wait_seconds=60, pid=os.getpid(), epoch=time.time()))
        time.sleep(60)


def release():
    with (O/'.study-admission.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        table = process_table()
        leases = read(O/'admission_leases.json')
        write(O/'admission_leases.json', [x for x in leases if x['pid'] != os.getpid() and
            x['pid'] in table and table[x['pid']]['start'] == x['start']])


def execute(prepared_path, auth_path, auth_sha, workload, stage, certificate_values):
    feature_policy = {'fission': 'all', 'replica': 'cumulative-replica'}[stage]
    label = {'fission': 'full', 'replica': 'replica'}[stage]
    os.environ.update(ENVIRONMENT)
    prepared = read(prepared_path)
    auth = read(auth_path)
    require(sha(auth_path) == auth_sha and auth['status'] == 'pass' and
        auth['scope'] == f'source38-independent-gcn-{label}256-exact5-continuation', 'Root authorization differs')
    require(auth['prepared_sha256'] == sha(prepared_path) and
        auth['driver_sha256'] == prepared['driver_sha256'] == sha(__file__), 'Prepared driver differs')
    require(prepared['source_commit'] == auth['source_commit'] == SOURCE and
        prepared['optimizer_sha256'] == OPTIMIZER and prepared['native_optimizer_sha256'] == NATIVE and
        workload in prepared['workloads'] and workload in auth['authorized_workloads'], 'Source/workload differs')
    require(auth['objective_cap_per_case'] == 256 and auth['native_attempts_per_case'] == 5 and
        auth['numeric_all_accepted_authorized'] is True and auth['formal_or_main_execution_authorized'] is False, 'Diagnostic scope differs')
    require(auth['research_resumption_sha256'] == prepared['research_resumption_sha256'] ==
        sha(R/'diagnosis/search-regression-repair-20261010/GCN_RESEARCH_RESUMED_20261011.json') ==
        '408653bedf8a2758f10c2d24edfb16c63ca3a9e9a404d0815c4f21b054ada6d8', 'Latest continued-research authorization changed')
    gate_root = R/'diagnosis/search-regression-repair-20261010/critical-positive-compute-v38-mechanism1/audit'
    gate = read(gate_root/'FINAL.json')
    gate_report = read(gate_root/'REPORT.json')
    require(gate['status']=='pass' and gate['mechanism_positive'] is True and
        gate['source_commit']==SOURCE and gate['extra_objective_calls']==gate['native_calls']==gate['numeric_calls']==0 and
        gate['report_sha256']==sha(gate_root/'REPORT.json') and gate['markdown_sha256']==sha(gate_root/'REPORT.md') and gate_report['mechanism_positive'] is True and
        gate_report['objective_calls']==64 and gate_report['source_commit']==SOURCE and
        prepared['mechanism64_final_sha256']==sha(gate_root/'FINAL.json') and
        prepared['mechanism64_report_sha256']==sha(gate_root/'REPORT.json'), 'Sealed Source38-64 mechanism gate differs')
    require(prepared['stage']==stage and auth['stage']==stage and prepared['feature_policy']==feature_policy,
        'Prepared stage/feature-policy differs')
    intact(gate_report['input_sha256'])
    require(not certificate_values and not auth.get('certificates',{}).get(workload,{}), 'No refusal certificates authorized in this exact5 research pair')
    certs = native_support.certificates(certificate_values)
    require({str(rank): str(path) for rank, path in certs.items()} == auth.get('certificates', {}).get(workload, {}),
        'Rejection certificates were not explicitly authorized')
    inputs = dict(prepared['input_sha256'])
    inputs.update(auth['input_sha256'])
    inputs[str(Path(prepared_path).resolve())] = sha(prepared_path)
    inputs[str(Path(auth_path).resolve())] = auth_sha
    intact(inputs)
    runner_path = Path(prepared['runner_bindings'][workload])
    runner = read(runner_path)
    require(prepared['runner_binding_sha256'][workload] == sha(runner_path) and
        runner['budget_cap'] == 256 and runner['source_commit'] == SOURCE and
        runner['optimizer_sha256'] == OPTIMIZER and runner['actual_policy'] == POLICY and
        runner['feature_policy'] == feature_policy and runner['critical_positive_compute'] is True and runner['independent_start'] is True and
        runner['imported_incumbent'] is None and runner['injected_candidates'] == 0,
        'Canonical Full256 runner differs')
    directory = Path(runner['output']).resolve()
    root = Path(prepared['execution_root']).resolve()
    require(directory == root/'runs/b256'/workload/stage, 'Runner output differs')
    native, numeric = root/'native/b256'/workload/stage, root/'numeric/b256'/workload/stage
    require(not directory.exists() and not native.exists() and not numeric.exists(),
        'Never retry, overwrite, or import an existing paid experiment')
    protocol = Path(prepared['outcome_protocol'])
    require(sha(protocol) == prepared['outcome_protocol_sha256'], 'Outcome protocol differs')
    protocol_body = read(protocol)
    require(protocol_body['search_source_commit'] == SOURCE and
        protocol_body['search_optimizer_sha256'] == OPTIMIZER and
        protocol_body['native_optimizer_sha256'] == NATIVE, 'Outcome source identities differ')
    auditor = Path(prepared['search_auditor'])
    audit_argv = prepared['search_audit_commands'][workload]
    require(Path(audit_argv[1]).resolve() == auditor.resolve() and
        audit_argv == [str(PY), str(auditor), '--search-root', str(directory), '--workload', workload,
            '--budget', '256', '--output', str(directory/'search-audit.json')], 'Search auditor command differs')
    nbpath = Path(prepared['native_binding'])
    nb = read(nbpath)
    require(nb['compatible_main_source_commit'] == SOURCE and
        nb['optimizer_sha256'] == NATIVE and sha(nb['optimizer']) == NATIVE, 'Frozen evaluator bridge differs')
    require(auth['argv'] == runner['argv'] and auth['output'] == str(directory), 'Exact authorized search command differs')
    directory.mkdir(parents=True)
    with (directory/'.v38-continuation-owner.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        leased = False
        try:
            write(directory/'driver-binding.json', dict(schema='orbit-source38-paired256-diagnostic-driver-v1',
                group='source38-targeted-diagnostic', workload=workload, stage=stage, feature_policy=feature_policy, budget_cap=256,
                driver_sha256=sha(__file__), root_authorization_sha256=auth_sha,
                runner_binding_sha256=sha(runner_path), argv=runner['argv'], output=str(directory), source_commit=SOURCE,
                objective_call_cap=256,
                optimizer_sha256=OPTIMIZER, actual_policy=POLICY, source_hashes=inputs,
                retained_communication_window=True, critical_positive_compute=True, independent_start=True, imported_incumbent=None,
                injected_candidates=0, extra_objective_calls=0, resource_environment=ENVIRONMENT,
                paper_admission=False, formal_admission=False, pid=os.getpid()), exclusive=True)
            acquire(directory, workload, prepared['whole_worker_peak_gib'][workload])
            leased = True
            intact(inputs)
            write(directory/'worker-status.json', dict(status='search', pid=os.getpid(), epoch=time.time()))
            run(runner['argv'], directory)
            result = root_members(directory/'result.json', {'status', 'objective_evaluations', 'artifact_hashes'})
            require(result['status'] == 'completed' and result['objective_evaluations'] == 256,
                'Independent Full256 did not complete its exact objective budget')
            intact(result['artifact_hashes'])
            write(directory/'search-completion.json', dict(status='search-completed-unverified',
                source_commit=SOURCE, actual_policy=POLICY, objective_calls=256, native_calls=0, numeric_calls=0,
                root_authorization_sha256=auth_sha, runner_binding_sha256=sha(runner_path),
                inputs_pre_post_verified=True, driver_sha256=sha(__file__),
                artifact_hashes={**result['artifact_hashes'], **{str(directory/name): sha(directory/name)
                    for name in ('result.json', 'launch-receipt.json', 'launch.stdout', 'launch.stderr',
                                 'usage.txt', 'driver-binding.json', 'admission.json')}},
                mechanism_audit='pending', paper_admission=False, epoch=time.time()), exclusive=True)
            write(directory/'worker-status.json', dict(status='search-audit', pid=os.getpid()))
            run(audit_argv, directory/'search-audit-launch')
            audit = read(directory/'search-audit.json')
            require(audit['status'] == 'pass' and audit['source_commit'] == SOURCE and
                audit['policy'] == POLICY and audit['objective_calls'] == 256 and
                audit['workload'] == workload, 'Source38 search/mechanism/domain audit failed')
            write(directory/'worker-status.json', dict(status='native', pid=os.getpid()))
            native_argv = [PY, R/'search/replay_completed.py', '--search-root', directory,
                '--case', R/'full_prepared-v4'/workload/'case.json', '--optimizer', nb['optimizer'],
                '--source', nb['source'], '--output', native, '--mapping-cache', O/'mapper-cache-v5',
                '--compiler-binding', nbpath]
            try:
                run(native_argv, native)
            except RuntimeError:
                require(read(native/'launch-receipt.json')['returncode'] == 1,
                    'Native crash/timeout is not a normal scheduler refusal')
            accepted = native_support.native_accepted_ranks(native)
            require(accepted==list(range(5)), 'All original five native ranks must map; preserve any refusal without replacement')
            if len(accepted) == 5:
                seal_native_process(native)
            write(directory/'worker-status.json', dict(status='numeric', pid=os.getpid(),
                native_evaluated=5, native_accepted=len(accepted), original_rank_list=accepted))
            from concurrent.futures import ThreadPoolExecutor
            def validate_rank(rank):
                output = numeric/f'rank-{rank}'
                run([PY, R/'validation/verify_full_native.py', '--workload', workload,
                    '--native-root', native/'native', '--rank', rank,
                    '--optimizer', nb['optimizer'], '--output', output,
                    '--negative-certificate', Path(prepared['negative_certificate'])], output)
                seal_numeric_process(output)
            # Distinct rank namespaces and unchanged command semantics; at most
            # two independent numeric validators within the whole 9 GiB lease.
            with ThreadPoolExecutor(max_workers=2) as pool:
                futures = [pool.submit(validate_rank, rank) for rank in accepted]
                for future in futures: future.result()
            write(directory/'worker-status.json', dict(status='final-outcome-audit', pid=os.getpid()))
            outcome_dir = directory/'outcome-audit'
            outcome_argv = [PY, Path(outcome.__file__).resolve(), '--search-root', directory,
                '--native-root', native, '--numeric-root', numeric, '--workload', workload, '--stage', stage,
                '--protocol', protocol, '--output', outcome_dir/'result.json', '--require-complete']
            for rank, path in sorted(certs.items()):
                outcome_argv.extend(['--reject-certificate', f'{rank}={path}'])
            run(outcome_argv, outcome_dir)
            postclose.seal(outcome_dir/'result.json')
            normalized = read(outcome_dir/'result.json')
            require(normalized['status'] == 'pass' and normalized['native_evaluated'] == 5 and
                normalized['search_objective_calls'] == 256 and normalized['numeric_validated']==5 and
                normalized['certified_scheduler_rejected']==0, 'Original five native and strict numeric outcomes remain unverified')
            intact(inputs)
            artifacts = [directory/'search-completion.json', directory/'search-audit.json',
                directory/'driver-binding.json', outcome_dir/'result.json', outcome_dir/'outcome-process-seal.json',
                *[numeric/f'rank-{rank}/numeric-process-seal.json' for rank in accepted]]
            if len(accepted) == 5:
                artifacts.append(native/'native-process-seal.json')
            write(directory/'completion.json', dict(status='pass-targeted-diagnostic', workload=workload,
                stage=stage, feature_policy=feature_policy, source_commit=SOURCE, policy=POLICY, budget=256,
                actual_objective_calls=256, extra_objective_calls=0, native_evaluated=5,
                numeric_validated=normalized['numeric_validated'],
                certified_scheduler_rejected=normalized['certified_scheduler_rejected'],
                native_cycles=normalized['best_validated_candidate']['native_cycles'],
                original_native_receipt_status=normalized['original_native_receipt_status'],
                original_native_launcher_returncode=normalized['original_native_launcher_returncode'],
                original_receipts_preserved=True, no_candidate_replacement=True,
                artifact_hashes={str(path): sha(path) for path in artifacts}, driver_sha256=sha(__file__),
                prepared_sha256=sha(prepared_path), root_authorization_sha256=auth_sha,
                paper_admission=False, formal_admission=False, main_execution=False,
                completed_epoch=time.time()), exclusive=True)
            write(directory/'worker-status.json', dict(status='pass-targeted-diagnostic', pid=os.getpid()))
        except Exception as error:
            if not (directory/'failure.json').exists():
                write(directory/'failure.json', dict(status='failed-preserved-targeted-diagnostic',
                    error=str(error), no_retry=True, root_authorization_sha256=auth_sha,
                    paper_admission=False, formal_admission=False, epoch=time.time()), exclusive=True)
            write(directory/'worker-status.json', dict(status='failed', pid=os.getpid(), error=str(error)))
            raise
        finally:
            if leased:
                release()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--prepared', type=Path, required=True)
    parser.add_argument('--root-authorization', type=Path, required=True)
    parser.add_argument('--root-authorization-sha256', required=True)
    parser.add_argument('--workload', choices=['gcn'], required=True)
    parser.add_argument('--stage', choices=['fission', 'replica'], required=True)
    args = parser.parse_args()
    execute(args.prepared, args.root_authorization, args.root_authorization_sha256,
        args.workload, args.stage, [])


if __name__ == '__main__':
    main()
