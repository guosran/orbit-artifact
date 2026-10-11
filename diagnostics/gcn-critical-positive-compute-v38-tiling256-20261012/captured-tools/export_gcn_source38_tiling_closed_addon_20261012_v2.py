#!/usr/bin/env python3
"""Capture already-closed Source38 Tiling evidence after explicit Root review.

This exporter never launches an experiment or modifies a published package.
All metadata/validation gates run before a fresh output directory is created.
"""
import argparse
import hashlib
import json
import sys
from pathlib import Path

sys.dont_write_bytecode = True
from check_gcn_source38_tiling_capture_20261012_v2 import (
    LIMIT, PAIR_COMMIT, PAIR_MANIFEST_SHA, SOURCE, verify_evidence,
)

R = Path(__file__).resolve().parent
PACKAGE_NAME = 'gcn-critical-positive-compute-v38-tiling256-20261012'
PREPARED_FILES = ('SOURCE-DOMAIN.json', 'PREREGISTRATION.json', 'MATCHED-CONTROLS.json',
                  'pipeline-binding.json', 'gcn-256-runner-binding.json',
                  'exact5-outcome-protocol.json', 'ROOT-authorization.json', 'PREPARED-SUMMARY.json')


def read_small(path):
    path = Path(path)
    if not path.is_file() or path.is_symlink() or path.stat().st_size >= LIMIT:
        raise ValueError('Missing, symlinked, or large input: ' + str(path))
    raw = path.read_bytes()
    if len(raw) >= LIMIT:
        raise ValueError('Input grew beyond the portable capture limit: ' + str(path))
    return raw


def sha(raw):
    return hashlib.sha256(raw).hexdigest()


def encode(value):
    return (json.dumps(value, indent=2, sort_keys=True) + '\n').encode()


def collect(root, triple, support):
    """Collect small closed files only; no journal/checkpoint/source-audit read."""
    unit = root / 'runs/b256/gcn/tiling'
    native = root / 'native/b256/gcn/tiling'
    numeric = root / 'numeric/b256/gcn/tiling'
    copies = [(root / 'prepared-v1' / name, 'prepared/' + name) for name in PREPARED_FILES]
    copies += [(unit / name, 'tiling256/captured/' + name)
               for name in ('completion.json', 'search-completion.json', 'driver-binding.json', 'protocol.json', 'usage.txt')]
    copies += [(unit / 'outcome-audit/result.json', 'tiling256/captured/outcome-result.json'),
               (unit / 'outcome-audit/outcome-process-seal.json', 'tiling256/captured/outcome-process-seal.json')]
    copies += [(native / name, 'tiling256/captured/' + name)
               for name in ('native_replay_result.json', 'native-process-seal.json')]
    copies += [(numeric / f'rank-{rank}' / name, f'tiling256/numeric/rank-{rank}/' + name)
               for rank in range(5) for name in ('result.json', 'numeric-process-seal.json')]
    for folder, prefix in [(root / 'closed-report', 'tiling256/closed-report'),
                           (triple, 'three-domain-comparison'),
                           (support, 'reports/materializer-support-boundary'),
                           (R / 'diagnosis/search-regression-repair-20261010/v38-gcn-tiling-single-process-io-readonly-20261012', 'reports/single-process-io-snapshot'),
                           (R / 'diagnosis/search-regression-repair-20261010/v38-gcn-checkpoint-trace-rewrite-readonly-20261012', 'reports/checkpoint-history-rewrite-proposal')]:
        final = json.loads(read_small(folder / 'FINAL.json'))
        copies += [(folder / name, prefix + '/' + name) for name in ('REPORT.json', 'FINAL.json')]
        if (folder / 'REPORT.md').is_file():
            copies.append((folder / 'REPORT.md', prefix + '/REPORT.md'))
        if 'script_path' in final:
            copies.append((Path(final['script_path']), prefix + '/' + Path(final['script_path']).name))
        for host in final.get('artifact_sha256', {}):
            # Every actual output bound by the small report seal is preserved;
            # giant host dependencies belong to input_sha256, not this subset.
            copies.append((Path(host), prefix + '/' + Path(host).name))
        if (folder / 'SUMMARY.json').is_file():
            copies.append((folder / 'SUMMARY.json', prefix + '/SUMMARY.json'))
    copies += [(R / name, 'captured-tools/' + name) for name in (
        'diagnosis_critical_positive_compute_v38_gcn_tiling2561.py',
        'audit_critical_positive_compute_v38_gcn_tiling2561.py',
        'diagnosis_critical_positive_compute_v38_gcn_tiling2561_report.py',
        'diagnosis_critical_positive_compute_v38_gcn_triple2561_report.py',
        'gcn_research_status.py',
        'diagnosis_archive_closed_checkpoints_20261012_v2.py')]
    copies.append((R / 'diagnosis_v38_gcn_process_io_once_20261012.py',
                   'reports/single-process-io-snapshot/diagnosis_v38_gcn_process_io_once_20261012.py'))
    copies += [(R / name, 'history/prepared-v1/' + name) for name in (
        'export_gcn_source38_tiling_closed_addon_20261012.py',
        'check_gcn_source38_tiling_capture_20261012.py')]
    copies += [(R / 'diagnosis/search-regression-repair-20261010/gcn-source38-tiling-addon-capture-prepared1' / name,
                'history/prepared-v1/' + name) for name in ('PLAN.json', 'SCRIPT_PREPARED.json')]
    copies.append((R / 'diagnosis/search-regression-repair-20261010/gcn-tiling256-disk-headroom-20261012/RECEIPT.json',
                   'reports/disk-headroom/RECEIPT.json'))
    result, origins = {}, {}
    for host, dest in copies:
        raw = read_small(host)
        if dest in result:
            assert result[dest] == raw, ('Colliding captured filenames', dest)
            continue
        result[dest] = raw
        origins[dest] = dict(capture_path=str(host.resolve()), original_sha256=sha(raw),
                             bytes=len(raw), byte_identical_capture=True,
                             captured_absolute_paths_are_host_provenance=True)
    return result, origins


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--tiling-root', type=Path, required=True)
    parser.add_argument('--triple-report-dir', type=Path, required=True)
    parser.add_argument('--support-report-dir', type=Path, required=True)
    parser.add_argument('--published-pair-package', type=Path, required=True)
    parser.add_argument('--package', type=Path, required=True)
    parser.add_argument('--root-authorization', type=Path, required=True)
    parser.add_argument('--root-authorization-sha256', required=True)
    parser.add_argument('--receipt', type=Path, required=True)
    args = parser.parse_args()
    args.tiling_root = args.tiling_root.resolve()
    args.triple_report_dir = args.triple_report_dir.resolve()
    args.support_report_dir = args.support_report_dir.resolve()
    args.published_pair_package = args.published_pair_package.resolve()
    args.package = args.package.resolve()
    authorization_raw = read_small(args.root_authorization)
    assert sha(authorization_raw) == args.root_authorization_sha256
    authorization = json.loads(authorization_raw)
    assert authorization['schema'] == 'orbit-source38-tiling-addon-capture-runtime-authorization-v1'
    assert authorization['status'] == 'approved-capture-only'
    assert authorization['source_commit'] == SOURCE
    assert authorization['script_sha256'] == sha(read_small(__file__))
    checker_path = R / 'check_gcn_source38_tiling_capture_20261012_v2.py'
    assert authorization['checker_sha256'] == sha(read_small(checker_path))
    for field, actual in [('tiling_root', args.tiling_root), ('triple_report_dir', args.triple_report_dir),
                          ('support_report_dir', args.support_report_dir), ('package', args.package),
                          ('published_pair_package', args.published_pair_package), ('receipt', args.receipt.resolve())]:
        assert Path(authorization[field]).resolve() == actual, field
    assert authorization['additional_objective_native_numeric_calls'] == 0
    assert authorization['published_pair_manifest_sha256'] == PAIR_MANIFEST_SHA
    assert authorization['published_pair_commit'] == PAIR_COMMIT
    assert args.package.name == PACKAGE_NAME and not args.package.exists()
    assert args.package != args.published_pair_package and not args.receipt.exists()
    prior_manifest_raw = read_small(args.published_pair_package / 'MANIFEST.json')
    assert sha(prior_manifest_raw) == PAIR_MANIFEST_SHA
    prior_manifest = json.loads(prior_manifest_raw)
    prior_reads = {}

    def prior(name):
        raw = read_small(args.published_pair_package / name)
        expected = prior_manifest['files'][name]
        assert sha(raw) == expected['sha256'] and len(raw) == expected['bytes']
        prior_reads[name] = expected
        return raw

    data, origins = collect(args.tiling_root, args.triple_report_dir, args.support_report_dir)
    summary = verify_evidence(lambda name: data[name], prior)
    assert summary['new_tiling_original_objective_calls'] == 256
    original_inputs = {value['capture_path']: value['original_sha256'] for value in origins.values()}
    original_inputs[str(args.published_pair_package / 'MANIFEST.json')] = PAIR_MANIFEST_SHA
    original_inputs[str(checker_path)] = sha(read_small(checker_path))
    original_inputs[str(Path(__file__).resolve())] = sha(read_small(__file__))
    # Root must approve the exact bytes actually captured, including the latest
    # unbound status viewer. A stale or altered path cannot silently pass.
    for path, expected in original_inputs.items():
        assert authorization['input_sha256'][path] == expected, path
        assert sha(read_small(path)) == expected, path
    completion = json.loads(data['tiling256/captured/completion.json'])
    closed = json.loads(data['tiling256/closed-report/REPORT.json'])
    for path, expected in completion['artifact_hashes'].items():
        if path in original_inputs:
            assert original_inputs[path] == expected
        else:
            assert path.endswith('/search-audit.json') and closed['input_sha256'][path] == expected
    data['check_package.py'] = read_small(checker_path)
    data['captured-tools/' + Path(__file__).name] = read_small(__file__)
    data['capture-provenance/ROOT-authorization.json'] = authorization_raw
    data['SUMMARY.json'] = encode(summary)
    data['references.json'] = encode({
        'published_pair_commit': PAIR_COMMIT, 'published_pair_manifest_sha256': PAIR_MANIFEST_SHA,
        'published_pair_relative_path': '../gcn-critical-positive-compute-v38-20261011',
        'referenced_payloads': prior_reads, 'prior_search_native_numeric_repeated': False})
    data['protocol.json'] = encode({
        'schema': 'orbit-source38-tiling-closed-artifact-protocol-v1', 'source_commit': SOURCE,
        'recorded_optimizer_sha256': '9996d1b97787242cea42d88511ce530bfa4cb523883705b0746a72a1ff17d7cc',
        'recorded_native_optimizer_sha256': '80f11127c25360b591cbd705d3e7d25d3060ba90cf2978f8d5a56133cf58a761',
        'stage': 'tiling', 'feature_policy': 'cumulative-tiling',
        'new_tiling_original_objective_calls': 256, 'previous_pair_original_calls': 512,
        'three_domain_logical_calls': 768, 'old_mechanism64_calls_separate': 64,
        'original_shortlist_size': 5, 'strict_numeric_validates_all_five': True,
        'free_winners': 0, 'warm_start': False, 'candidate_replacement': False,
        'additional_objective_native_numeric_calls': 0,
        'paper_or_formal_or_default_admission': False,
        'large_engine_audit_is_external_closed_report_input_hash_provenance': True})
    table = 'workload,stage,source_commit,objective_calls,native_cycles,native_evaluated,numeric_validated\n'
    for stage in ['replica', 'tiling', 'full']:
        table += f"gcn,{stage},{SOURCE},256,{summary['native_cycles'][stage]},5,5\n"
    data['results.csv'] = table.encode()
    delta = summary['raw_native_cycle_differences']
    data['README.md'] = (
        '# Source38 GCN Tiling comparison\n\n'
        'This independent addon captures the closed canonical Tiling256 run and '
        'the three-domain Source38 comparison. It references the unchanged published '
        f'Full/Replica package at `{PAIR_COMMIT}`. No previous search, native or numeric '
        'run was repeated for capture.\n\n'
        f"Replica / Tiling / Full cycles: **{summary['native_cycles']['replica']} / "
        f"{summary['native_cycles']['tiling']} / {summary['native_cycles']['full']}**. "
        f"Raw differences: Tiling−Replica {delta['tiling_minus_replica']:+d}, "
        f"Full−Tiling {delta['full_minus_tiling']:+d}, Full−Replica {delta['full_minus_replica']:+d}. "
        'Absolute differences of at most one cycle are interpreted as ties; raw integers remain intact.\n\n'
        'Each domain independently started from the canonical program with 256 objective calls, '
        'five original native finalists and five strict numeric validations. The three-domain '
        'total is 768 original calls, including 512 from the existing pair and 256 from Tiling. '
        'The earlier 64-call mechanism diagnostic is separate. Capture adds zero calls.\n\n'
        'Only output and cumulative legal domain differ in the verified search argv. '
        'The same Source38 optimizer, predictor inputs and frozen native mapper/scheduler '
        'are retained. The materializer support-boundary report separates unsupported '
        'preconditions, first failures and untested partitionability; it does not count '
        'an earlier tiling failure as proof that fusion itself is illegal. Native improvements '
        'alone do not establish fusion/fission benefit or repair every missing branch.\n\n'
        'The separate one-process I/O snapshot and checkpoint/history rewrite dossier '
        'are observational source evidence. The rewrite proposal is unimplemented: '
        'no CPU share, per-file I/O share or measured speedup is claimed. Capture adds '
        'zero process samples and preserves the old prepared scripts.\n\n'
        'The small disk-headroom receipt preserves the original 50-GiB gate and verified '
        'lossless archival of a closed negative-run checkpoint; its gzip bytes are not bundled.\n\n'
        'Run `python3 diagnostics/' + PACKAGE_NAME + '/check_package.py` from the artifact root. '
        'The checker verifies the sealed small receipts and immutable relative references. '
        'Large engine audits remain external hash-bound provenance; host absolute paths '
        'inside receipts are historical locations. ELF files, caches and large journals '
        'are omitted. Fresh-machine end-to-end reproduction has not been tested. '
        'No default, formal, main or paper admission is asserted.\n').encode()
    assert all(len(raw) < LIMIT for raw in data.values())
    assert sha(read_small(args.published_pair_package / 'MANIFEST.json')) == PAIR_MANIFEST_SHA
    # All reads and authorization/closure checks pass before the first write.
    args.package.mkdir(parents=True)
    for name, raw in data.items():
        path = args.package / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(raw)
    for path, expected in original_inputs.items():
        assert sha(read_small(path)) == expected, path
    manifest = {
        'schema': 'orbit-source38-tiling-addon-manifest-v1', 'status': 'closed-isolated-research',
        'source_commit': SOURCE, 'published_pair_commit': PAIR_COMMIT,
        'published_pair_manifest_sha256': PAIR_MANIFEST_SHA,
        'published_pair_relative_path': '../gcn-critical-positive-compute-v38-20261011',
        'files': {name: {'sha256': sha(raw), 'bytes': len(raw)} for name, raw in sorted(data.items())},
        'source_file_origins': origins, 'original_host_input_sha256': original_inputs,
        'root_authorization_sha256': sha(authorization_raw),
        'new_original_objective_calls': 256, 'previous_pair_original_calls': 512,
        'additional_process_samples_by_capture': 0, 'performance_optimization_implemented': False,
        'additional_objective_native_numeric_calls': 0,
        'paper_or_formal_or_default_admission': False,
        'large_engine_audit_bytes_read_or_copied': False,
        'source37_or_published_source38_pair_or_four_workload_data_modified': False}
    (args.package / 'MANIFEST.json').write_bytes(encode(manifest))
    args.receipt.parent.mkdir(parents=True, exist_ok=True)
    args.receipt.write_bytes(encode({
        'schema': 'orbit-source38-tiling-addon-capture-receipt-v1',
        'status': 'captured-closed-evidence', 'manifest_sha256': sha(encode(manifest)),
        'source_commit': SOURCE, 'payload_files': len(data),
        'payload_bytes': sum(len(raw) for raw in data.values()),
        'additional_objective_native_numeric_calls': 0,
        'native_cycles': summary['native_cycles'],
        'raw_native_cycle_differences': summary['raw_native_cycle_differences']}))
    print(args.receipt.read_text())


if __name__ == '__main__':
    main()
