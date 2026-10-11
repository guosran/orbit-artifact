#!/usr/bin/env python3
"""Bind omitted large-audit hashes to original sealed closed-report inputs."""
import hashlib
import json
from pathlib import Path

R = Path('/home/shiran/project/orbit-repair-study')
B = R / 'diagnosis/search-regression-repair-20261010'
P = Path('/home/shiran/project/orbit-artifact/diagnostics/gcn-critical-positive-compute-v38-20261011')


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def put(path, value):
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')


def main():
    manifest = json.loads((P / 'MANIFEST.json').read_text())
    assert sha(P / 'MANIFEST.json') == 'b8f12985317475eab049c6ea49bed34e037bc830a89ba52b0f7ddaaa3a57cf7d'
    for name, record in manifest['files'].items():
        assert sha(P / name) == record['sha256'] and (P / name).stat().st_size == record['bytes']
    history = P / 'history/closed-v5-candidate1'
    assert not history.exists()
    history.mkdir(parents=True)
    for name in ['MANIFEST.json', 'check_package.py']:
        (history / name).write_bytes((P / name).read_bytes())
    checker = P / 'check_package.py'
    raw = checker.read_text()
    old = "assert manifest['original_host_evidence_sha256'][host] == expected"
    assert raw.count(old) == 1
    checker.write_text(raw.replace(old, "assert closed['input_sha256'][host] == expected"))
    put(history / 'CHECKER_INTERFACE_FAILURE.json', {
        'schema': 'orbit-portable-package-checker-development-failure-v1',
        'exception': 'KeyError: omitted Replica search-audit host path was not in the capture map',
        'cause': 'A captured-byte provenance map is not the complete original engine-input closure.',
        'repair': 'For the sole omitted search-audit artifact, require its completion hash to equal the original sealed closed-report input hash; do not claim raw audit bytes were rechecked here.',
        'original_manifest_sha256': sha(history / 'MANIFEST.json'),
        'original_checker_sha256': sha(history / 'check_package.py'),
        'additional_objective_native_numeric_calls': 0,
        'frozen_source_reports_or_experiments_modified': False})
    manifest['history_manifests'].append({
        'path': 'history/closed-v5-candidate1/MANIFEST.json',
        'sha256': sha(history / 'MANIFEST.json'),
        'payload_aliases': {'check_package.py': 'history/closed-v5-candidate1/check_package.py'}})
    script_copy = P / 'captured-readonly-tools/closed-v5' / Path(__file__).name
    script_copy.write_bytes(Path(__file__).read_bytes())
    manifest['source_file_origins'][str(script_copy.relative_to(P))] = {
        'capture_path': str(Path(__file__).resolve()), 'original_sha256': sha(script_copy),
        'bytes': script_copy.stat().st_size, 'byte_identical_capture': True,
        'captured_absolute_paths_are_host_provenance': True}
    manifest['omitted_large_search_audit_check_scope'] = 'Original completion SHA equals the captured independently sealed closed-report input SHA; raw large audit bytes are not bundled or rehashed by the portable checker.'
    manifest['files'] = {str(path.relative_to(P)): {'sha256': sha(path), 'bytes': path.stat().st_size}
                         for path in sorted(P.rglob('*')) if path.is_file() and path != P / 'MANIFEST.json'}
    assert all(x['bytes'] < 3 * 1024 * 1024 for x in manifest['files'].values())
    put(P / 'MANIFEST.json', manifest)
    receipt = B / 'gcn-source38-addon-publication-prepared1/final-closed-v5-checker-bridge.json'
    assert not receipt.exists()
    put(receipt, {'schema': 'orbit-source38-addon-checker-bridge-closeout-v1',
                  'manifest_sha256': sha(P / 'MANIFEST.json'),
                  'payload_files': len(manifest['files']),
                  'payload_bytes': sum(x['bytes'] for x in manifest['files'].values()),
                  'additional_objective_native_numeric_calls': 0,
                  'previous_manifest_and_checker_preserved': True,
                  'original_native_and_numeric_counts': 10,
                  'paper_or_formal_admission': False})
    print(receipt.read_text())


if __name__ == '__main__':
    main()
