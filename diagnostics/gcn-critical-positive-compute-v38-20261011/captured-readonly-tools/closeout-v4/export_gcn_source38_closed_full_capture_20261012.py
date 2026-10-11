#!/usr/bin/env python3
"""Capture existing sealed Source38 Full evidence; never execute an experiment.

This is a provenance exporter, not a fresh-machine search reproduction driver.
It performs no reads of either pair unit unless explicitly invoked after closure.
"""
import argparse
import hashlib
import json
from pathlib import Path

SOURCE = '76345481683a2e199c0cad155de2acb51149f350'
POLICY = 'schedule-structure-critical-positive-compute-v38'
NATIVE = '80f11127c25360b591cbd705d3e7d25d3060ba90cf2978f8d5a56133cf58a761'
CAPTURE_LIMIT = 3 * 1024 * 1024


def read(path):
    path = Path(path)
    raw = path.read_bytes()
    if len(raw) >= CAPTURE_LIMIT:
        raise ValueError('Large input must remain external provenance: ' + str(path))
    return raw


def sha(raw):
    return hashlib.sha256(raw).hexdigest()


def load(path):
    return json.loads(read(path))


def validate(root, stage):
    root = Path(root).resolve()
    unit = root / f'runs/b256/gcn/{stage}'
    native = root / f'native/b256/gcn/{stage}'
    numeric = root / f'numeric/b256/gcn/{stage}'
    completion = load(unit / 'completion.json')
    report = load(root / 'closed-report/REPORT.json')
    final = load(root / 'closed-report/FINAL.json')
    outcome = load(unit / 'outcome-audit/result.json')
    native_result = load(native / 'native_replay_result.json')
    if not (completion['status'] == 'pass-targeted-diagnostic'
            and completion['source_commit'] == report['source_commit'] == SOURCE
            and completion['policy'] == report['policy'] == POLICY
            and completion['stage'] == report['stage'] == stage
            and report['native_optimizer_sha256'] == NATIVE
            and completion['budget'] == completion['actual_objective_calls'] == 256
            and report['objective_calls'] == 256
            and completion['extra_objective_calls'] == 0
            and completion['native_evaluated'] == completion['numeric_validated'] == 5
            and completion['certified_scheduler_rejected'] == 0):
        raise ValueError('Expected existing Source38 exact256/five-native/five-numeric closure')
    if final['status'] != 'pass' or not final['input_pre_post_verified'] or \
            final['report_sha256'] != sha(read(root / 'closed-report/REPORT.json')):
        raise ValueError('Closed report lacks its original independent seal')
    if any(final[name] != 0 for name in
           ('additional_objective_calls', 'additional_native_calls', 'additional_numeric_calls')):
        raise ValueError('Exporter accepts only zero-additional-call sealed reports')
    if not (native_result['status'] == 'complete'
            and native_result['expected_ranks'] == native_result['passed_ranks'] == 5
            and outcome['all_five_native_numeric_success']
            and outcome['search_objective_calls'] == 256
            and outcome['certified_scheduler_rejected'] == 0):
        raise ValueError('Original exact five outcomes are not complete')
    native_seal = load(native / 'native-process-seal.json')
    outcome_seal = load(unit / 'outcome-audit/outcome-process-seal.json')
    if not (native_seal['status'] == outcome_seal['status'] == 'pass'
            and native_seal['native_receipt_sha256'] == sha(read(native / 'native_replay_result.json'))
            and outcome_seal['outcome_report_sha256'] == sha(read(unit / 'outcome-audit/result.json'))):
        raise ValueError('Original native/outcome process seals differ')
    rows = outcome['outcomes']
    if [row['rank'] for row in rows] != list(range(5)):
        raise ValueError('Original rank order differs')
    if [row['native_cycles'] for row in rows] != \
            [row['native_cycles'] for row in native_result['native_shortlist']]:
        raise ValueError('Native and normalized original five differ')
    for rank, row in enumerate(rows):
        result_path = numeric / f'rank-{rank}/result.json'
        result = load(result_path)
        seal = load(numeric / f'rank-{rank}/numeric-process-seal.json')
        if not (row['outcome'] == 'native-accepted' and row['strict_numeric'] == 'pass'
                and row['numeric_coverage_verified'] and row['numeric_negative_chain_verified']
                and result['status'] == seal['status'] == 'pass'
                and result['positive']['comparisons'] > 0
                and result['positive']['mismatches'] == 0
                and seal['numeric_result_sha256'] == sha(read(result_path))):
            raise ValueError('Original strict numeric outcome differs: ' + str(rank))
    cycles = min(row['native_cycles'] for row in rows)
    if completion['native_cycles'] != report['native_best_cycles'] or cycles != completion['native_cycles']:
        raise ValueError('Best cycles are not derived from the original five')
    paths = [(root / 'closed-report' / name, 'closed-report/' + name)
             for name in ('REPORT.json', 'REPORT.md', 'FINAL.json')]
    paths += [(unit / name, 'captured/' + name) for name in
              ('completion.json', 'search-completion.json', 'driver-binding.json', 'protocol.json', 'usage.txt')]
    paths += [(unit / 'outcome-audit' / name, 'captured/outcome-' + name)
              for name in ('result.json', 'outcome-process-seal.json')]
    paths += [(native / name, 'captured/' + name) for name in
              ('native_replay_result.json', 'native-process-seal.json')]
    paths += [(root / 'prepared-v2/ROOT-authorization.json', 'captured/ROOT-authorization.json')]
    paths += [(numeric / f'rank-{rank}' / name, f'numeric/rank-{rank}/' + name)
              for rank in range(5) for name in ('result.json', 'numeric-process-seal.json')]
    for path, _ in paths:
        recorded = completion['artifact_hashes'].get(str(path))
        if recorded is not None and sha(read(path)) != recorded:
            raise ValueError('Small captured artifact differs from original completion: ' + str(path))
    evidence = {
        'schema': 'orbit-source38-closed-exact-five-normalized-v1',
        'source_commit': SOURCE, 'objective_calls': 256,
        'native_evaluated': 5, 'numeric_validated': 5,
        'certified_scheduler_rejected': 0, 'best_cycles': cycles,
        'original_outcome_report_sha256': sha(read(unit / 'outcome-audit/result.json')),
        'original_native_receipt_sha256': sha(read(native / 'native_replay_result.json')),
        'outcomes': [{key: row[key] for key in
                     ('rank', 'candidate_id', 'native_cycles', 'outcome', 'mapper_integrity',
                      'source_integrity', 'native_trace', 'strict_numeric',
                      'numeric_coverage_verified', 'numeric_negative_chain_verified')}
                     for row in rows],
    }
    return paths, evidence


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--full-root', type=Path, required=True)
    parser.add_argument('--replica-root', type=Path, required=True)
    parser.add_argument('--package', type=Path, required=True)
    parser.add_argument('--receipt', type=Path, required=True)
    args = parser.parse_args()
    # All reads and both original seals must pass before any new package write.
    paths, full = validate(args.full_root, 'fission')
    _, replica = validate(args.replica_root, 'replica')
    if (args.package / 'full256').exists() or args.receipt.exists():
        raise ValueError('Fresh append only; preserve previous package/receipt')
    rows = [(path, name, read(path)) for path, name in paths]
    originals = {str(path.resolve()): sha(raw) for path, _, raw in rows}
    for path, _, raw in rows:
        if sha(read(path)) != sha(raw):
            raise ValueError('Original closed file changed before capture: ' + str(path))
    for _, name, raw in rows:
        dest = args.package / 'full256' / name
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_bytes(raw)
    (args.package / 'full256/five-finalists.json').write_text(
        json.dumps(full, indent=2, sort_keys=True) + '\n')
    receipt = {
        'schema': 'orbit-source38-closed-full-capture-v1',
        'source_commit': SOURCE, 'original_host_evidence_sha256': originals,
        'source_file_origins': {
            'full256/' + name: {'capture_path': str(path.resolve()),
                               'original_sha256': sha(raw), 'bytes': len(raw),
                               'byte_identical_capture': True,
                               'captured_absolute_paths_are_host_provenance': True}
            for path, name, raw in rows},
        'full_cycles': full['best_cycles'], 'replica_cycles': replica['best_cycles'],
        'raw_full_minus_replica_cycles': full['best_cycles'] - replica['best_cycles'],
        'original_pair_objective_calls': 512,
        'additional_objective_native_numeric_calls': 0,
        'source_or_bound_experiment_modified': False,
        'huge_search_audit_or_journal_read_or_copied': False,
        'independent_engine_admission_is_external_closed_report_provenance': True,
    }
    args.receipt.parent.mkdir(parents=True, exist_ok=True)
    args.receipt.write_text(json.dumps(receipt, indent=2, sort_keys=True) + '\n')
    print(json.dumps({'status': 'captured-existing-closed-pair', 'receipt': str(args.receipt),
                      'receipt_sha256': sha(read(args.receipt)),
                      'additional_objective_native_numeric_calls': 0}, indent=2))


if __name__ == '__main__':
    main()
