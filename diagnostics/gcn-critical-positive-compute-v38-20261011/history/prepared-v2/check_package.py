#!/usr/bin/env python3
"""Check captured Source38 evidence without running a compiler or experiment."""
import csv
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
S = '76345481683a2e199c0cad155de2acb51149f350'
OPT = '9996d1b97787242cea42d88511ce530bfa4cb523883705b0746a72a1ff17d7cc'
NATIVE = '80f11127c25360b591cbd705d3e7d25d3060ba90cf2978f8d5a56133cf58a761'
POLICY = 'schedule-structure-critical-positive-compute-v38'


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read(name):
    return json.loads((HERE / name).read_text())


manifest_path = HERE / 'MANIFEST.json'
if not manifest_path.exists():
    manifest_path = HERE / 'MANIFEST.prepared-v2.json'
manifest = json.loads(manifest_path.read_text())
for name, expected in manifest['files'].items():
    p = HERE / name
    assert p.is_file() and not p.is_symlink(), name
    assert digest(p) == expected['sha256'], name
    assert p.stat().st_size == expected['bytes'], name
if 'previous_prepared_manifest_sha256' in manifest:
    previous_path = HERE / 'MANIFEST.prepared-v1.json'
    assert digest(previous_path) == manifest['previous_prepared_manifest_sha256']
    previous = json.loads(previous_path.read_text())
    for name, expected in previous['files'].items():
        p = HERE / name
        if digest(p) != expected['sha256']:
            p = HERE / manifest['prepared_payload_aliases'][name]
        assert digest(p) == expected['sha256'], ('prepared-v1', name)
        assert p.stat().st_size == expected['bytes'], ('prepared-v1', name)

protocol = read('protocol.json')
assert protocol['actual_search_source_commit'] == S and protocol['actual_policy'] == POLICY
assert protocol['recorded_search_optimizer_sha256'] == OPT
assert protocol['native_source_commit'] == '9e7015c3bd4d44dd2ec37df6f02c09aaa0372e55'
assert protocol['recorded_native_optimizer_sha256'] == NATIVE
assert protocol['cost_namespace_is_not_compiler_source_identity']
assert protocol['mechanism64_objective_calls'] == 64
assert protocol['planned_objective_cap_per_pair_cell'] == 256
assert protocol['independent_canonical_starts'] and not protocol['free_incumbents_or_history_minima']
assert protocol['original_native_shortlist_size'] == 5 and protocol['numeric_validates_all_five']
assert not protocol['paper_admission'] and not protocol['formal_admission']
assert not protocol['fresh_machine_end_to_end_reproduction_tested']

proof = read('source/source-proof.json')
assert proof['new_commit'] == S and proof['base_commit'] == protocol['base_source_commit']
assert proof['policy'] == POLICY and proof['default'] is False
assert proof['objective_calls'] == proof['native_calls'] == proof['numeric_calls'] == 0
assert proof['diff_sha256'] == digest(HERE / 'source/source-draft.patch')
compiler = read('build/critical-positive-compute-compiler-binding.json')
native = read('build/critical-positive-compute-native-binding.json')
build = read('build/completion.json')
assert compiler['compiled_source_commit'] == S and compiler['optimizer_sha256'] == OPT
assert native['compatible_main_source_commit'] == S and native['optimizer_sha256'] == NATIVE
assert native['compiled_source_commit'] == protocol['native_source_commit']
assert build['status'] == 'pass' and build['source_commit'] == S and build['optimizer_sha256'] == OPT
assert build['actual_dependency_count'] == 596 and build['actual_resolved_link_input_count'] == 327
assert build['objective_calls'] == build['native_calls'] == build['numeric_calls'] == 0

report = read('mechanism64/REPORT.json')
final = read('mechanism64/FINAL.json')
assert final['status'] == report['status'] == 'pass'
assert final['input_pre_post_verified'] and final['mechanism_positive']
assert final['report_sha256'] == digest(HERE / 'mechanism64/REPORT.json')
assert final['markdown_sha256'] == digest(HERE / 'mechanism64/REPORT.md')
assert report['source_commit'] == S and report['optimizer_sha256'] == OPT and report['actual_policy'] == POLICY
assert report['objective_calls'] == 64 and report['native_calls'] == report['numeric_calls'] == 0
assert final['extra_objective_calls'] == final['native_calls'] == final['numeric_calls'] == 0
assert report['exact_semantic_attempts'] == 1885 and report['zero_debit_attempts'] == 1822
assert report['global_exact_edge_duplicates'] == 0 and report['independent_all_compute_groups'] == 'pass'
assert report['prepared_round_count'] == 20 and report['mechanism_positive']
assert report['reconstructed_parent_direction_count'] == report['changed_compute_target_count'] == 284
assert len(report['compute_tier_evidence']) == 284
assert len({(x['round'], x['parent_id']) for x in report['compute_tier_evidence']}) == 284
assert all(x['changed_target'] for x in report['compute_tier_evidence'])
paid = read('mechanism64/paid-guided-positive.json')
assert paid['evidence'] == report['first_tier_guided_paid'] and len(paid['evidence']) == 6
assert paid['report_sha256'] == digest(HERE / 'mechanism64/REPORT.json') and paid['no_native_quality_claim']
assert all(x['after'] - x['before'] == 1 for x in paid['evidence'])
summary = read('mechanism64/all-parent-audit-summary.json')
assert all(summary[k] == report[k] for k in summary)

for name, expected in read('inputs-reference.json')['files'].items():
    p = HERE / expected['relative_path']
    assert digest(p) == expected['sha256'] and p.stat().st_size == expected['bytes'], name

table = list(csv.DictReader((HERE / 'results.csv').open()))
assert [x['stage'] for x in table] == ['replica', 'fission']
for row in table:
    assert row['source_commit'] == S and row['objective_cap'] == '256'
    assert row['status'] == 'pending'
    assert not row['native_cycles'] and not row['actual_objective_calls']
    assert not row['native_evaluated'] and not row['numeric_validated']
for stage in ['full', 'replica']:
    prefix = f'pair256/{stage}/prepared-v2/'
    pipeline = read(prefix + 'pipeline-binding.json')
    assert pipeline['source_commit'] == S and pipeline['optimizer_sha256'] == OPT
    assert pipeline['native_optimizer_sha256'] == NATIVE
    assert pipeline['driver_sha256'] == digest(HERE / 'pair256/captured-tools/diagnosis_critical_positive_compute_v38_gcn256_paired1_v2.py')
    auditor_name = Path(pipeline['search_auditor']).name
    assert digest(HERE / 'pair256/captured-tools' / auditor_name) == pipeline['input_sha256'][pipeline['search_auditor']]
    runner_path = pipeline['runner_bindings']['gcn']
    assert pipeline['runner_binding_sha256']['gcn'] == digest(HERE / prefix / 'gcn-256-runner-binding.json')
    # This schema binds generated runner receipts separately from runtime inputs.
    assert runner_path.endswith(f'critical-positive-compute-v38-{stage}256-continuation1/prepared-v2/gcn-256-runner-binding.json')
    assert pipeline['mechanism64_final_sha256'] == digest(HERE / 'mechanism64/FINAL.json')

print(json.dumps({'status': 'pass', 'files_verified': len(manifest['files']),
                  'mechanism_objective_calls': 64, 'mechanism_native_numeric_calls': 0,
                  'independently_reconstructed_parent_rounds': 284, 'paid_first_tier_guided_shapes': 6,
                  'pending_pair_cells': ['replica', 'fission'],
                  'additional_objective_native_numeric_calls': 0}, indent=2))
