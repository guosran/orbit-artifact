#!/usr/bin/env python3
"""Verify this captured research package without executing any experiment."""
import csv
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
manifest_path = HERE / 'MANIFEST.json'
if not manifest_path.exists():
    manifest_path = HERE / 'MANIFEST.prepared-v2.json'
manifest = json.loads(manifest_path.read_text())
for name, expected in manifest['files'].items():
    p = HERE / name
    assert p.is_file(), name
    content = p.read_bytes()
    assert hashlib.sha256(content).hexdigest() == expected['sha256'], name
    assert len(content) == expected['bytes'], name
protocol = json.loads((HERE / 'protocol.json').read_text())
source = '151cf509063bf93276665cea05fb71235f6dd123'
assert protocol['actual_search_source_commit'] == source
assert protocol['objective_cap_per_cell'] == 256
assert protocol['cost_namespace_is_not_compiler_source_identity']
assert protocol['native_source_commit'] == '9e7015c3bd4d44dd2ec37df6f02c09aaa0372e55'
assert protocol['recorded_native_optimizer_sha256'] == '80f11127c25360b591cbd705d3e7d25d3060ba90cf2978f8d5a56133cf58a761'
assert not protocol['history_minimum_or_free_incumbent_injection']
assert not protocol['fresh_machine_end_to_end_reproduction_tested']
table = list(csv.DictReader((HERE / 'results.csv').open()))
assert [row['stage'] for row in table] == ['replica', 'fission']
for row in table:
    assert row['source_commit'] == source and row['objective_cap'] == '256'
    if row['status'] == 'pending':
        assert not row['native_cycles'] and not row['actual_objective_calls']
        assert not row['native_evaluated'] and not row['numeric_validated']
        continue
    assert row['status'] == 'verified-isolated-research'
    relative = 'replica256' if row['stage'] == 'replica' else 'full256'
    evidence = json.loads((HERE / relative / 'five-finalists.json').read_text())
    assert evidence['source_commit'] == source and evidence['actual_objective_calls'] == 256
    assert evidence['extra_objective_calls'] == 0 and evidence['no_candidate_replacement']
    assert evidence['original_rank_order'] == list(range(5))
    assert evidence['native_evaluated'] == evidence['numeric_validated'] == 5
    assert evidence['best_native_cycles'] == int(row['native_cycles'])
    assert evidence['best_native_cycles'] == min(x['native_cycles'] for x in evidence['rows'])
    for rank, outcome in enumerate(evidence['rows']):
        assert outcome['rank'] == rank and outcome['outcome'] == 'native-accepted'
        assert outcome['strict_numeric'] == outcome['mapper_integrity'] == outcome['source_integrity'] == outcome['native_trace'] == 'pass'
        assert outcome['numeric_positive']['comparisons'] > 0 and outcome['numeric_positive']['mismatches'] == 0
        assert outcome['numeric_coverage_verified'] and outcome['numeric_negative_chain_verified']
    assert not evidence['paper_admission'] and not evidence['four_program_evaluation_modified']
historical = json.loads((HERE / 'historical-source35-gcn.json').read_text())
assert historical['source_commit'] != source
assert historical['full_minus_replica'] == 5156
assert [x['native_cycles'] for x in historical['original_stages']] == [1698761, 923357, 921765, 926921, 926921, 926921]
print(json.dumps({'status': 'pass', 'files_verified': len(manifest['files']),
                  'verified_cells': [row['stage'] for row in table if row['status'] != 'pending'],
                  'pending_cells': [row['stage'] for row in table if row['status'] == 'pending'],
                  'new_objective_native_numeric_calls': 0}, indent=2))
