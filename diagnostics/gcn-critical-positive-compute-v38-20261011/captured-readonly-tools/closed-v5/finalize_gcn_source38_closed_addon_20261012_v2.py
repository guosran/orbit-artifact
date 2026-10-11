#!/usr/bin/env python3
"""Complete the uncommitted closeout after recognizing derived-origin records."""
import hashlib
import json
from pathlib import Path

R = Path('/home/shiran/project/orbit-repair-study')
B = R / 'diagnosis/search-regression-repair-20261010'
P = Path('/home/shiran/project/orbit-artifact/diagnostics/gcn-critical-positive-compute-v38-20261011')


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def write_json(p, value):
    p.write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')


def main():
    assert not (P / 'MANIFEST.json').exists()
    old = json.loads((P / 'MANIFEST.prepared-v4.json').read_text())
    preserve = ['README.md', 'protocol.json', 'results.csv', 'check_package.py', 'check_static_closeout.py']
    for name, row in old['files'].items():
        path = P / ('history/prepared-v4/' + name if name in preserve else name)
        assert sha(path) == row['sha256'] and path.stat().st_size == row['bytes'], name
    failure = P / 'capture-provenance/final-closeout-v1-schema-failure.json'
    assert not failure.exists()
    write_json(failure, {'schema': 'orbit-package-closeout-development-failure-v1',
                        'script_sha256': sha(R / 'finalize_gcn_source38_closed_addon_20261012.py'),
                        'exception': "KeyError: original_sha256 at origin validation",
                        'cause': 'Prior manifest also has derived origin records, distinct from byte-identical captures.',
                        'prior_manifest_sha256': sha(P / 'MANIFEST.prepared-v4.json'),
                        'manifest_created': False, 'published': False,
                        'additional_objective_native_numeric_calls': 0,
                        'frozen_inputs_or_previous_manifests_modified': False})
    checker = P / 'check_package.py'
    raw = checker.read_text()
    raw = raw.replace("    assert origin['byte_identical_capture']\n    assert digest(HERE / name) == origin['original_sha256'], name",
                      "    if origin['byte_identical_capture']:\n        assert digest(HERE / name) == origin['original_sha256'], name\n    else:\n        assert origin['byte_identical_capture'] is False and origin['derived_from'], name")
    raw = raw.replace("if value['capture_path'] == host and value['original_sha256'] == expected]",
                      "if value.get('capture_path') == host and value.get('original_sha256') == expected]")
    checker.write_text(raw)
    origins = dict(old['source_file_origins'])
    host_evidence = dict(old['original_host_evidence_sha256'])
    capture_receipts = {}
    for name in ['full-closed-capture.json', 'closed-addenda-capture.json']:
        host = B / 'gcn-source38-addon-publication-prepared1' / name
        dest = P / 'capture-provenance' / name
        assert sha(host) == sha(dest)
        receipt = json.loads(dest.read_text())
        origins.update(receipt['source_file_origins'])
        host_evidence.update(receipt.get('original_host_evidence_sha256', receipt.get('input_sha256', {})))
        origins[str(dest.relative_to(P))] = {
            'capture_path': str(host), 'original_sha256': sha(dest), 'bytes': dest.stat().st_size,
            'byte_identical_capture': True, 'captured_absolute_paths_are_host_provenance': True}
        capture_receipts[name] = sha(dest)
    for name in preserve:
        if name in origins:
            origins['history/prepared-v4/' + name] = origins.pop(name)
    for filename in ['finalize_gcn_source38_closed_addon_20261012.py', Path(__file__).name]:
        host = R / filename
        dest = P / 'captured-readonly-tools/closed-v5' / filename
        if dest.exists():
            assert sha(dest) == sha(host)
        else:
            dest.write_bytes(host.read_bytes())
        origins[str(dest.relative_to(P))] = {
            'capture_path': str(host), 'original_sha256': sha(dest), 'bytes': dest.stat().st_size,
            'byte_identical_capture': True, 'captured_absolute_paths_are_host_provenance': True}
    by_hash = {}
    for path in P.rglob('*'):
        if path.is_file():
            by_hash.setdefault(sha(path), []).append(str(path.relative_to(P)))
    history = []
    for version in range(1, 5):
        name = f'MANIFEST.prepared-v{version}.json'
        previous = json.loads((P / name).read_text())
        aliases = {}
        for payload, expected in previous['files'].items():
            if not (P / payload).is_file() or sha(P / payload) != expected['sha256']:
                selected = next(x for x in by_hash[expected['sha256']] if x.startswith('history/'))
                assert (P / selected).stat().st_size == expected['bytes']
                aliases[payload] = selected
        history.append({'path': name, 'sha256': sha(P / name), 'payload_aliases': aliases})
    files = {str(path.relative_to(P)): {'sha256': sha(path), 'bytes': path.stat().st_size}
             for path in sorted(P.rglob('*')) if path.is_file()}
    assert all(x['bytes'] < 3 * 1024 * 1024 for x in files.values())
    for name, origin in origins.items():
        if origin['byte_identical_capture']:
            assert files[name]['sha256'] == origin['original_sha256'], name
        else:
            assert origin['byte_identical_capture'] is False and origin['derived_from'], name
    manifest = dict(old)
    manifest.update(schema='orbit-source38-research-addon-manifest-v5-closed',
                    status='verified-isolated-research-closed-pair', files=files,
                    source_file_origins=origins, original_host_evidence_sha256=host_evidence,
                    history_manifests=history, captured_closed_receipts_sha256=capture_receipts,
                    previous_prepared_manifest_sha256=sha(P / 'MANIFEST.prepared-v4.json'),
                    verified_pair_cells=['replica', 'full'], pending_pair_cells=[],
                    completed_pair_objective_calls=512, total_recorded_objective_calls=576,
                    pair_native_evaluated=10, pair_numeric_validated=10,
                    full_native_cycles=918724, replica_native_cycles=920639,
                    raw_full_minus_replica_cycles=-1915, matched_quality_available=True,
                    final_full_capture_exporter_executed=True, prepared_tiling256_included=False,
                    complete_host_closure_bundled=False, paper_or_formal_admission=False,
                    large_search_audits_are_external_hash_bound_provenance=True)
    viewer = 'captured-readonly-tools/closed-v5/gcn_research_status.py'
    manifest['host_tool_path_versions'][str(R / 'gcn_research_status.py')] = {
        'latest_capture_sha256': files[viewer]['sha256'], 'latest_packaged_captures': [viewer],
        'older_packaged_captures': ['captured-readonly-tools/gcn_research_status.py',
                                  'captured-readonly-tools/closeout-v4/gcn_research_status.py'],
        'previous_capture_sha256': files['captured-readonly-tools/closeout-v4/gcn_research_status.py']['sha256']}
    write_json(P / 'MANIFEST.json', manifest)
    receipt = B / 'gcn-source38-addon-publication-prepared1/final-closed-v5-capture.json'
    assert not receipt.exists()
    write_json(receipt, {'schema': 'orbit-source38-addon-final-closeout-receipt-v2',
                        'manifest_sha256': sha(P / 'MANIFEST.json'), 'payload_files': len(files),
                        'payload_bytes': sum(x['bytes'] for x in files.values()),
                        'source_commit': manifest['source_commit'],
                        'original_pair_calls': 512, 'original_mechanism_calls': 64,
                        'additional_objective_native_numeric_calls': 0,
                        'paper_or_formal_admission': False,
                        'source37_and_four_program_snapshot_modified': False})
    print(receipt.read_text())


if __name__ == '__main__':
    main()
