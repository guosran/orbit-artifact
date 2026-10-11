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
    manifest_path = HERE / 'MANIFEST.prepared-v3.json'
manifest = json.loads(manifest_path.read_text())
for name, expected in manifest['files'].items():
    p = HERE / name
    assert p.is_file() and not p.is_symlink(), name
    assert digest(p) == expected['sha256'], name
    assert p.stat().st_size == expected['bytes'], name
for history in manifest.get('history_manifests', []):
    previous_path = HERE / history['path']
    assert digest(previous_path) == history['sha256']
    previous = json.loads(previous_path.read_text())
    for name, expected in previous['files'].items():
        p = HERE / name
        if digest(p) != expected['sha256']:
            p = HERE / history['payload_aliases'][name]
        assert digest(p) == expected['sha256'], (history['path'], name)
        assert p.stat().st_size == expected['bytes'], (history['path'], name)

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
    if row['stage'] == 'fission':
        assert row['status'] == 'pending'
        assert not row['native_cycles'] and not row['actual_objective_calls']
        assert not row['native_evaluated'] and not row['numeric_validated']
    else:
        assert row['status'] == 'pass-targeted-diagnostic'
        assert row['actual_objective_calls'] == '256' and row['native_cycles'] == '920639'
        assert row['native_evaluated'] == row['numeric_validated'] == '5'
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

assert protocol['pair_results_state'] == 'replica-closed-full-pending'
assert protocol['completed_pair_cells'] == ['replica'] and protocol['pending_pair_cells'] == ['full']
assert protocol['completed_pair_objective_calls'] == 256 and not protocol['matched_pair_complete']
closed = read('replica256/closed-report/REPORT.json')
closed_final = read('replica256/closed-report/FINAL.json')
completion = read('replica256/captured/completion.json')
native = read('replica256/captured/native_replay_result.json')
outcome = read('replica256/captured/outcome-result.json')
normalized = read('replica256/five-finalists.json')
assert closed_final['report_sha256'] == digest(HERE / 'replica256/closed-report/REPORT.json')
assert closed_final['status'] == 'pass' and closed_final['input_pre_post_verified']
assert closed['source_commit'] == S and closed['policy'] == POLICY
assert closed['native_optimizer_sha256'] == NATIVE
assert closed['objective_calls'] == completion['actual_objective_calls'] == 256
assert completion['source_commit'] == S and completion['status'] == 'pass-targeted-diagnostic'
assert closed['native_evaluated'] == completion['native_evaluated'] == 5
assert closed['numeric_validated'] == completion['numeric_validated'] == 5
assert closed['certified_scheduler_rejected'] == completion['certified_scheduler_rejected'] == 0
assert closed['reconstructed_parent_direction_count'] == 303
assert len(closed['first_tier_guided_paid']) == 23
assert native['status'] == 'complete' and native['expected_ranks'] == native['passed_ranks'] == 5
assert outcome['all_five_native_numeric_success'] and outcome['certified_scheduler_rejected'] == 0
assert normalized['original_outcome_report_sha256'] == digest(HERE / 'replica256/captured/outcome-result.json')
assert normalized['original_native_receipt_sha256'] == digest(HERE / 'replica256/captured/native_replay_result.json')
cycles = [920639, 921040, 921039, 920954, 920954]
assert [x['native_cycles'] for x in native['native_shortlist']] == cycles
assert [x['native_cycles'] for x in outcome['outcomes']] == cycles
assert [x['native_cycles'] for x in normalized['outcomes']] == cycles
assert closed['native_best_cycles'] == completion['native_cycles'] == normalized['best_cycles'] == min(cycles)
for rank, row in enumerate(normalized['outcomes']):
    assert row['rank'] == rank and row['candidate_id'] == native['native_shortlist'][rank]['candidate_id']
    assert row['outcome'] == 'native-accepted' and row['strict_numeric'] == 'pass'
    assert row['mapper_integrity'] == row['source_integrity'] == row['native_trace'] == 'pass'
    assert row['numeric_coverage_verified'] and row['numeric_negative_chain_verified']
    raw_numeric = read(f'replica256/numeric/rank-{rank}/result.json')
    seal = read(f'replica256/numeric/rank-{rank}/numeric-process-seal.json')
    assert raw_numeric['status'] == seal['status'] == 'pass'
    assert raw_numeric['positive']['comparisons'] > 0 and raw_numeric['positive']['mismatches'] == 0
    assert seal['numeric_result_sha256'] == digest(HERE / f'replica256/numeric/rank-{rank}/result.json')
native_seal = read('replica256/captured/native-process-seal.json')
assert native_seal['status'] == 'pass'
assert native_seal['native_receipt_sha256'] == digest(HERE / 'replica256/captured/native_replay_result.json')
proposal = read('reports/first-fusion-negative-proof-cache-proposal/REPORT.json')
proposal_final = read('reports/first-fusion-negative-proof-cache-proposal/FINAL.json')
assert proposal['status'] == proposal_final['status'] == 'pass-readonly-proposal-unimplemented'
assert proposal['new_objective_calls'] == proposal['new_native_calls'] == proposal['new_numeric_calls'] == 0
assert not proposal['compile_or_experiment_run'] and not proposal['source_or_bound_inputs_modified']
assert proposal['observed_prefix']['potential_subsequent_prefix_reuses'] == 218
assert proposal['observed_prefix']['counts_are_not_cpu_savings_or_full256_frequency_estimates']

print(json.dumps({'status': 'pass', 'files_verified': len(manifest['files']),
                  'mechanism_objective_calls': 64, 'mechanism_native_numeric_calls': 0,
                  'independently_reconstructed_parent_rounds': 284, 'paid_first_tier_guided_shapes': 6,
                  'closed_pair_cells': ['replica'], 'pending_pair_cells': ['fission'],
                  'verified_pair_objective_calls': 256, 'native_evaluated': 5, 'numeric_validated': 5,
                  'native_cycles': 920639, 'matched_quality_available': False,
                  'additional_objective_native_numeric_calls': 0}, indent=2))
