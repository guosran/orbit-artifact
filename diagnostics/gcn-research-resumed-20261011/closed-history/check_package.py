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


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


for name, expected in manifest['files'].items():
    p = HERE / name
    assert p.is_file(), name
    content = p.read_bytes()
    assert hashlib.sha256(content).hexdigest() == expected['sha256'], name
    assert len(content) == expected['bytes'], name
if manifest_path.name == 'MANIFEST.json':
    assert manifest['status'] == 'closed-verified-negative-research'
    assert manifest['full_minus_replica_native_cycles'] == 8751
    assert not manifest['paper_or_formal_admission'] and not manifest['four_program_snapshot_modified']
    assert manifest['export_added_objective_native_numeric_calls'] == 0
    # Older partial manifests retain their pending state and exact payload bytes.
    for version in [1, 2]:
        prior = json.loads((HERE / f'MANIFEST.prepared-v{version}.json').read_text())
        for name, expected in prior['files'].items():
            p = HERE / name
            if digest(p) != expected['sha256']:
                p = HERE / manifest['prepared_payload_aliases'][name]
            assert digest(p) == expected['sha256'], (version, name)
            assert p.stat().st_size == expected['bytes'], (version, name)
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
        numeric = HERE / relative / 'numeric' / f'rank-{rank}' / 'result.json'
        assert digest(numeric) == outcome['source_numeric_result_sha256']
        raw_numeric = json.loads(numeric.read_text())
        assert raw_numeric['status'] == 'pass' and raw_numeric['positive'] == outcome['numeric_positive']
    assert not evidence['paper_admission'] and not evidence['four_program_evaluation_modified']
if all(row['status'] != 'pending' for row in table):
    assert protocol['verified_cells'] == ['replica', 'fission']
    assert protocol['actual_objective_calls_total'] == 512
    matched_path = HERE / 'matched-comparison' / 'REPORT.json'
    matched = json.loads(matched_path.read_text())
    seal = json.loads((HERE / 'matched-comparison' / 'FINAL.json').read_text())
    assert seal['report_sha256'] == digest(matched_path) and seal['child_report_seals_verified']
    assert matched['status'] == 'verified-isolated-research' and matched['source_commit'] == source
    assert matched['full_minus_replica_native_cycles'] == 8751
    assert [r['native_cycles'] for r in matched['rows']] == [922559, 931310]
    assert not matched['paper_admission'] and not matched['formal_admission']
    for relative, row in zip(['replica256', 'full256'], matched['rows']):
        assert row['objective_calls'] == 256 and row['native_evaluated'] == row['numeric_validated'] == 5
        report_path = HERE / relative / 'closed-report' / 'REPORT.json'
        seal = json.loads((HERE / relative / 'closed-report' / 'FINAL.json').read_text())
        assert seal['report_sha256'] == digest(report_path) and seal['input_pre_post_verified']
        native = json.loads((HERE / relative / 'captured' / 'native_replay_result.json').read_text())
        outcomes = json.loads((HERE / relative / 'captured' / 'outcome-result.json').read_text())
        normalized = json.loads((HERE / relative / 'five-finalists.json').read_text())
        assert native['status'] == 'complete' and native['expected_ranks'] == native['passed_ranks'] == 5
        assert outcomes['all_five_native_numeric_success'] and outcomes['certified_scheduler_rejected'] == 0
        assert [r['native_cycles'] for r in native['native_shortlist']] == [r['native_cycles'] for r in normalized['rows']]
        assert [r['native_cycles'] for r in outcomes['outcomes']] == [r['native_cycles'] for r in normalized['rows']]
historical = json.loads((HERE / 'historical-source35-gcn.json').read_text())
assert historical['source_commit'] != source
assert historical['full_minus_replica'] == 5156
assert [x['native_cycles'] for x in historical['original_stages']] == [1698761, 923357, 921765, 926921, 926921, 926921]
print(json.dumps({'status': 'pass', 'files_verified': len(manifest['files']),
                  'verified_cells': [row['stage'] for row in table if row['status'] != 'pending'],
                  'pending_cells': [row['stage'] for row in table if row['status'] == 'pending'],
                  'new_objective_native_numeric_calls': 0}, indent=2))
