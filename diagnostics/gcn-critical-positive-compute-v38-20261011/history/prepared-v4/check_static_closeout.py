#!/usr/bin/env python3
"""Verify static snapshots and the prior closed-Replica package; no experiments."""
import hashlib
import json
from pathlib import Path
import runpy

HERE = Path(__file__).resolve().parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
manifest = json.loads((HERE / 'MANIFEST.prepared-v4.json').read_text())
for name, row in manifest['files'].items():
    path = HERE / name
    assert path.is_file() and not path.is_symlink()
    assert sha(path) == row['sha256'] and path.stat().st_size == row['bytes'], name
assert sha(HERE / 'MANIFEST.prepared-v3.json') == manifest['previous_prepared_manifest_sha256']
runpy.run_path(str(HERE / 'check_package.py'), run_name='__main__')
prefix = HERE / 'reports/source38-replica-original-five-predictor-rank'
report = json.loads((prefix / 'REPORT.json').read_text())
final = json.loads((prefix / 'FINAL.json').read_text())
summary = json.loads((prefix / 'SUMMARY.json').read_text())
for host, expected in final['artifact_sha256'].items():
    assert sha(prefix / Path(host).name) == expected
assert report['source_commit'] == manifest['source_commit']
assert report['input_pre_post_verified'] and final['input_pre_post_verified']
assert report['extra_calls'] == final['extra_calls'] == summary['extra_calls'] == 0
assert summary['original_five_only'] and not summary['archive_coverage_claim']
assert summary['predicted_top1_native_regret_cycles'] == 0
assert not manifest['final_full_capture_exporter_executed']
assert manifest['full_native_cycles'] is None and manifest['pending_pair_cells'] == ['full']
viewer = HERE / 'captured-readonly-tools/closeout-v4/gcn_research_status.py'
assert 'abs(delta) <= 1' in viewer.read_text()
print(json.dumps({'status': 'pass-static-preparation', 'files_verified': len(manifest['files']),
                  'predicted_top1_regret_within_original_five': 0,
                  'full_pending': True, 'final_capture_exporter_executed': False,
                  'additional_objective_native_numeric_calls': 0}, indent=2))
