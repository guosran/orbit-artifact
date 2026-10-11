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
manifest = json.loads(manifest_path.read_text())
for name, expected in manifest['files'].items():
    p = HERE / name
    assert p.is_file() and not p.is_symlink(), name
    assert digest(p) == expected['sha256'], name
    assert p.stat().st_size == expected['bytes'], name
    assert p.stat().st_size < 3 * 1024 * 1024, name
for history in manifest.get('history_manifests', []):
    previous_path = HERE / history['path']
    assert digest(previous_path) == history['sha256']
    previous = json.loads(previous_path.read_text())
    for name, expected in previous['files'].items():
        p = HERE / name
        if not p.is_file() or digest(p) != expected['sha256']:
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


actual_files = {str(p.relative_to(HERE)) for p in HERE.rglob('*') if p.is_file()}
assert actual_files == set(manifest['files']) | {'MANIFEST.json'}
for name, origin in manifest['source_file_origins'].items():
    if origin['byte_identical_capture']:
        assert digest(HERE / name) == origin['original_sha256'], name
    else:
        assert origin['byte_identical_capture'] is False and origin['derived_from'], name

assert protocol['pair_results_state'] == 'closed-matched-pair'
assert protocol['completed_pair_cells'] == ['replica', 'full']
assert protocol['pending_pair_cells'] == [] and protocol['matched_pair_complete']
assert protocol['completed_pair_objective_calls'] == 512
assert protocol['total_recorded_objective_calls_including_mechanism'] == 576
assert protocol['pair_native_evaluated'] == protocol['pair_numeric_validated'] == 10
assert protocol['extra_objective_native_numeric_calls'] == 0


def sealed_report(prefix, final_name='FINAL.json'):
    folder = HERE / prefix
    final = read(prefix + '/' + final_name)
    assert final['input_pre_post_verified'], prefix
    if 'report_sha256' in final:
        assert final['report_sha256'] == digest(folder / 'REPORT.json'), prefix
    if 'markdown_sha256' in final:
        assert final['markdown_sha256'] == digest(folder / 'REPORT.md'), prefix
    for host, expected in final.get('artifact_sha256', {}).items():
        assert digest(folder / Path(host).name) == expected, (prefix, host)
    for field in ('additional_objective_calls', 'additional_native_calls',
                  'additional_numeric_calls', 'extra_objective_calls',
                  'native_calls', 'numeric_calls', 'extra_calls'):
        if field in final:
            assert final[field] == 0, (prefix, field)
    return read(prefix + '/REPORT.json')


table = list(csv.DictReader((HERE / 'results.csv').open()))
assert [x['stage'] for x in table] == ['replica', 'fission']
expected_cycles = {'replica': [920639, 921040, 921039, 920954, 920954],
                   'full': [918724, 919123, 919123, 919124, 919124]}
for domain, stage in [('replica', 'replica'), ('full', 'fission')]:
    prefix = domain + '256'
    cycles = expected_cycles[domain]
    closed = sealed_report(prefix + '/closed-report')
    completion = read(prefix + '/captured/completion.json')
    native = read(prefix + '/captured/native_replay_result.json')
    outcome = read(prefix + '/captured/outcome-result.json')
    normalized = read(prefix + '/five-finalists.json')
    row = next(x for x in table if x['stage'] == stage)
    assert row['source_commit'] == S and row['objective_cap'] == row['actual_objective_calls'] == '256'
    assert row['status'] == completion['status'] == 'pass-targeted-diagnostic'
    assert row['native_cycles'] == str(min(cycles))
    assert row['native_evaluated'] == row['numeric_validated'] == '5'
    assert closed['source_commit'] == completion['source_commit'] == normalized['source_commit'] == S
    assert closed['policy'] == completion['policy'] == POLICY
    assert closed['native_optimizer_sha256'] == NATIVE and closed['stage'] == stage
    assert closed['objective_calls'] == completion['actual_objective_calls'] == normalized['objective_calls'] == 256
    assert completion['extra_objective_calls'] == closed['extra_objective_calls'] == 0
    assert closed['native_evaluated'] == completion['native_evaluated'] == normalized['native_evaluated'] == 5
    assert closed['numeric_validated'] == completion['numeric_validated'] == normalized['numeric_validated'] == 5
    assert closed['certified_scheduler_rejected'] == completion['certified_scheduler_rejected'] == normalized['certified_scheduler_rejected'] == 0
    assert completion['no_candidate_replacement'] and not completion['paper_admission'] and not completion['formal_admission']
    assert native['status'] == 'complete' and native['expected_ranks'] == native['passed_ranks'] == 5
    assert outcome['all_five_native_numeric_success'] and outcome['certified_scheduler_rejected'] == 0
    assert outcome['search_objective_calls'] == 256 and outcome['exact_original_rank_order'] == list(range(5))
    assert normalized['original_outcome_report_sha256'] == digest(HERE / prefix / 'captured/outcome-result.json')
    assert normalized['original_native_receipt_sha256'] == digest(HERE / prefix / 'captured/native_replay_result.json')
    for collection in (native['native_shortlist'], outcome['outcomes'], normalized['outcomes'], closed['original_exact_five_finalists']):
        assert [x['native_cycles'] for x in collection] == cycles
    assert closed['native_best_cycles'] == completion['native_cycles'] == normalized['best_cycles'] == min(cycles)
    for rank, entry in enumerate(normalized['outcomes']):
        assert entry['rank'] == rank and entry['candidate_id'] == native['native_shortlist'][rank]['candidate_id']
        assert entry['outcome'] == 'native-accepted' and entry['strict_numeric'] == 'pass'
        assert entry['mapper_integrity'] == entry['source_integrity'] == entry['native_trace'] == 'pass'
        assert entry['numeric_coverage_verified'] and entry['numeric_negative_chain_verified']
        numeric_path = HERE / prefix / f'numeric/rank-{rank}/result.json'
        raw = read(prefix + f'/numeric/rank-{rank}/result.json')
        seal = read(prefix + f'/numeric/rank-{rank}/numeric-process-seal.json')
        assert raw['status'] == seal['status'] == 'pass'
        assert raw['positive']['comparisons'] > 0 and raw['positive']['mismatches'] == 0
        assert seal['numeric_result_sha256'] == digest(numeric_path)
    native_seal = read(prefix + '/captured/native-process-seal.json')
    assert native_seal['status'] == 'pass'
    assert native_seal['native_receipt_sha256'] == digest(HERE / prefix / 'captured/native_replay_result.json')
    # Verify every completion artifact included in this portable subset. The
    # original large source audit remains an explicitly omitted host dependency.
    origins = manifest['source_file_origins']
    for host, expected in completion['artifact_hashes'].items():
        matches = [name for name, value in origins.items()
                   if value.get('capture_path') == host and value.get('original_sha256') == expected]
        if matches:
            assert all(digest(HERE / name) == expected for name in matches)
        else:
            assert host.endswith('/search-audit.json')
            assert manifest['original_host_evidence_sha256'][host] == expected

for domain in ['full', 'replica']:
    prefix = f'pair256/{domain}/prepared-v2/'
    pipeline = read(prefix + 'pipeline-binding.json')
    assert pipeline['source_commit'] == S and pipeline['optimizer_sha256'] == OPT
    assert pipeline['native_optimizer_sha256'] == NATIVE
    assert pipeline['driver_sha256'] == digest(HERE / 'pair256/captured-tools/diagnosis_critical_positive_compute_v38_gcn256_paired1_v2.py')
    assert digest(HERE / 'pair256/captured-tools' / Path(pipeline['search_auditor']).name) == pipeline['input_sha256'][pipeline['search_auditor']]
    assert pipeline['runner_binding_sha256']['gcn'] == digest(HERE / prefix / 'gcn-256-runner-binding.json')
    assert pipeline['mechanism64_final_sha256'] == digest(HERE / 'mechanism64/FINAL.json')

matched = sealed_report('matched-comparison')
assert matched['source_commit'] == S and matched['policy'] == POLICY
assert matched['full_minus_replica_native_cycles'] == 918724 - 920639 == -1915
assert [x['native_original_five'] for x in matched['rows']] == [expected_cycles['replica'], expected_cycles['full']]
assert all(x['objective_calls'] == 256 and x['native_evaluated'] == x['numeric_validated'] == 5 for x in matched['rows'])
assert not matched['paper_admission'] and not matched['formal_admission']
sealed_report('reports/source38-matched-path')
membership = sealed_report('reports/source38-matched-membership')
assert not membership['replica_winner_semantic_state_in_full_archive']
assert not membership['replica_winner_semantic_state_in_full_original_shortlist']
assert membership['first_absent_replica_typed_prefix'] == 5
counts = membership['six_reference_critical_task_shape_budget']
assert [counts['Task_' + str(n)]['paid'] for n in [9, 10, 11, 12, 23, 24]] == [5, 5, 5, 15, 5, 5]

family = sealed_report('reports/source38-action-family-budget')['source38']
assert family['source_commit'] == S and family['objective_calls'] == 256
assert family['canonical_calls'] == 1 and family['expansion_paid'] == 255
assert family['attempted'] == 201377 and family['zero'] == 201122
groups = family['action_families']
assert sum(x['attempted'] for x in groups.values()) == 201377
assert sum(x['paid'] for x in groups.values()) == 255
assert sum(x['zero'] for x in groups.values()) == 201122
fusion_groups = [groups[k] for k in ['fusion', 'fusion-plus-shape', 'fusion-plus-tiling', 'tiling-plus-fusion', 'sibling-fusion']]
assert sum(x['attempted'] for x in fusion_groups) == 110226
assert sum(x['materialized'] for x in fusion_groups) == sum(x['paid'] for x in fusion_groups) == 0
assert sum(x['pending_unattempted'] for x in fusion_groups) == 4122
assert groups['fission']['menu'] == groups['fission']['attempted'] == 0

perf = sealed_report('reports/source38-closed-pair-performance')
assert perf['source_commit'] == S
for row, wall, attempts, zero in zip(perf['rows'], [350.14, 3928.0], [4651, 201377], [4396, 201122]):
    assert row['search_wall_seconds'] == wall
    assert row['candidate_semantic_attempts'] == attempts and row['zero_debit_attempts'] == zero
    assert row['charged_candidate_attempts'] == 255 and row['bootstrap_objective_calls'] == 1
    assert row['objective_calls'] == 256

sealed_report('reports/source38-full-replica-native-difference')
sealed_report('reports/source38-full-replica-native-difference', 'EXPLANATION-FINAL.json')
native_summary = read('reports/source38-full-replica-native-difference/SUMMARY.json')
assert native_summary['source_commit'] == S and native_summary['full_minus_replica'] == -1915
assert native_summary['chain_difference'] == {'duration': -1916, 'transfer': 1, 'reservation_wait': 0, 'start_residual': 0}
assert native_summary['action_families']['full'] == {'shape': 17, 'replica': 1}
explanation = read('reports/source38-full-replica-native-difference/EXPLANATION.json')
assert not any(explanation['full_selected_history_has_' + x] for x in ['fusion', 'fission', 'tiling'])
assert explanation['full_replica_primitive'][0]['firstTask'] == 'Task_14'
assert explanation['full_replica_primitive'][0]['factor'] == 2

sealed_report('reports/source38-replica-original-five-predictor-rank')
predictor_summary = read('reports/source38-replica-original-five-predictor-rank/SUMMARY.json')
assert predictor_summary['original_five_only'] and not predictor_summary['archive_coverage_claim']
assert predictor_summary['predicted_top1_native_regret_cycles'] == 0
assert predictor_summary['extra_calls'] == 0
proposal = read('reports/first-fusion-negative-proof-cache-proposal/REPORT.json')
proposal_final = read('reports/first-fusion-negative-proof-cache-proposal/FINAL.json')
assert proposal['status'] == proposal_final['status'] == 'pass-readonly-proposal-unimplemented'
assert proposal['new_objective_calls'] == proposal['new_native_calls'] == proposal['new_numeric_calls'] == 0
assert not proposal['compile_or_experiment_run'] and not proposal['source_or_bound_inputs_modified']
assert proposal['observed_prefix']['potential_subsequent_prefix_reuses'] == 218
assert proposal['observed_prefix']['counts_are_not_cpu_savings_or_full256_frequency_estimates']
disk = read('reports/disk-admission-recovery/RECEIPT.json')
assert disk['script_sha256'] == digest(HERE / 'captured-readonly-tools/closed-v5/diagnosis_archive_closed_checkpoints_20261012.py')
viewer = (HERE / 'captured-readonly-tools/closed-v5/gcn_research_status.py').read_text()
assert 'abs(delta) <= 1' in viewer
assert manifest['export_added_objective_native_numeric_calls'] == 0
assert manifest['matched_quality_available'] and not manifest['paper_or_formal_admission']

print(json.dumps({'status': 'pass', 'files_verified': len(manifest['files']),
                  'history_manifests_verified': len(manifest['history_manifests']),
                  'mechanism_objective_calls': 64, 'matched_pair_objective_calls': 512,
                  'total_recorded_objective_calls': 576, 'native_evaluated': 10,
                  'numeric_validated': 10, 'replica_cycles': 920639, 'full_cycles': 918724,
                  'raw_full_minus_replica_cycles': -1915, 'paper_or_formal_admission': False,
                  'additional_objective_native_numeric_calls': 0}, indent=2))
