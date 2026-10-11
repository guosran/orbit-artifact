#!/usr/bin/env python3
"""Verify a closed Tiling addon and its immutable published pair references."""
import csv
import hashlib
import io
import json
from pathlib import Path

SOURCE = '76345481683a2e199c0cad155de2acb51149f350'
POLICY = 'schedule-structure-critical-positive-compute-v38'
OPT = '9996d1b97787242cea42d88511ce530bfa4cb523883705b0746a72a1ff17d7cc'
NATIVE = '80f11127c25360b591cbd705d3e7d25d3060ba90cf2978f8d5a56133cf58a761'
PAIR_MANIFEST_SHA = '0ffb8d38dee0924914ff5adf0b9a568806cb38a7013af24ed601319d1734b53d'
PAIR_COMMIT = '832b9379453520b4e35a60328574932dd7c854cb'
LIMIT = 3 * 1024 * 1024


def digest(raw):
    return hashlib.sha256(raw).hexdigest()


def verify_evidence(read, prior):
    """Both readers return exact small bytes; no host experiment is executed."""
    j = lambda name: json.loads(read(name))
    pj = lambda name: json.loads(prior(name))

    def seal(prefix):
        report = j(prefix + '/REPORT.json')
        final = j(prefix + '/FINAL.json')
        assert final['input_pre_post_verified'], prefix
        if 'report_sha256' in final:
            assert final['report_sha256'] == digest(read(prefix + '/REPORT.json'))
        else:
            entries = final['artifact_sha256']
            assert any(Path(path).name == 'REPORT.json' and expected == digest(read(prefix + '/REPORT.json'))
                       for path, expected in entries.items())
        if 'markdown_sha256' in final:
            assert final['markdown_sha256'] == digest(read(prefix + '/REPORT.md'))
        for host, expected in final.get('artifact_sha256', {}).items():
            assert digest(read(prefix + '/' + Path(host).name)) == expected, host
        for field in ('additional_objective_calls', 'additional_native_calls',
                      'additional_numeric_calls', 'extra_calls'):
            if field in final:
                assert final[field] == 0, (prefix, field)
        return report

    proof = pj('source/source-proof.json')
    assert proof['new_commit'] == SOURCE and proof['policy'] == POLICY
    native_binding = pj('build/critical-positive-compute-native-binding.json')
    compiler_binding = pj('build/critical-positive-compute-compiler-binding.json')
    assert compiler_binding['compiled_source_commit'] == SOURCE
    assert compiler_binding['optimizer_sha256'] == OPT
    assert native_binding['optimizer_sha256'] == NATIVE
    assert native_binding['compiled_source_commit'] == '9e7015c3bd4d44dd2ec37df6f02c09aaa0372e55'

    domain = j('prepared/SOURCE-DOMAIN.json')
    prereg = j('prepared/PREREGISTRATION.json')
    runner = j('prepared/gcn-256-runner-binding.json')
    pipeline = j('prepared/pipeline-binding.json')
    assert domain['source_commit'] == prereg['source_commit'] == runner['source_commit'] == pipeline['source_commit'] == SOURCE
    assert domain['cpp_sha256'] == proof['new_cpp_sha256']
    assert domain['level'] == 3 and domain['runtime_filter_unchanged']
    assert domain['forbidden_action_family'] == 'fission' and domain['forbidden_parent_fission']
    assert domain['primitive_required_levels'] == {'lineage_replacement_lineage_reset': 1, 'replica': 2, 'tile': 3, 'k_tile': 3, 'fusion': 4, 'sibling_fusion': 4, 'unknown': 5}
    assert 'if (!parent.actionHistory.fissionActions.empty())' in domain['exact_filter_cpp']
    assert '(action.family == "lineage-replacement" && kind == "lineage-reset") ? 1' in domain['exact_filter_cpp']
    assert domain['source_changes'] == domain['free_candidates'] == 0
    assert runner['optimizer_sha256'] == pipeline['optimizer_sha256'] == OPT
    assert pipeline['native_optimizer_sha256'] == prereg['native_optimizer_sha256'] == NATIVE
    assert runner['actual_policy'] == prereg['actual_policy'] == POLICY
    assert runner['feature_policy'] == pipeline['feature_policy'] == prereg['feature_policy'] == 'cumulative-tiling'
    assert runner['budget_cap'] == prereg['objective_cap_per_case'] == 256
    assert runner['independent_start'] and runner['imported_incumbent'] is None and runner['injected_candidates'] == 0
    assert prereg['required_native_mapped'] == prereg['required_strict_numeric'] == 5
    assert prereg['refusal_certificates_allowed'] is False
    assert pipeline['runner_binding_sha256']['gcn'] == digest(read('prepared/gcn-256-runner-binding.json'))
    assert pipeline['matched_controls_sha256'] == digest(read('prepared/MATCHED-CONTROLS.json'))
    assert pipeline['outcome_protocol_sha256'] == digest(read('prepared/exact5-outcome-protocol.json'))
    assert pipeline['driver_sha256'] == digest(read('captured-tools/diagnosis_critical_positive_compute_v38_gcn_tiling2561.py'))
    assert pipeline['input_sha256'][pipeline['search_auditor']] == digest(read('captured-tools/audit_critical_positive_compute_v38_gcn_tiling2561.py'))
    for domain_name in ['replica', 'full']:
        reference = pj(f'pair256/{domain_name}/prepared-v2/gcn-256-runner-binding.json')
        assert reference['source_commit'] == SOURCE and reference['optimizer_sha256'] == OPT
        assert len(reference['argv']) == len(runner['argv'])
        output = runner['argv'].index('--output') + 1
        feature = runner['argv'].index('--feature-policy') + 1
        differences = [n for n, (a, b) in enumerate(zip(reference['argv'], runner['argv'])) if a != b]
        assert differences == sorted([output, feature])
        assert runner['resource_environment'] == reference['resource_environment']
        assert runner['predictor_cache_input'] == reference['predictor_cache_input']
        for path, expected in reference['input_sha256'].items():
            if path in runner['input_sha256']:
                assert runner['input_sha256'][path] == expected

    closed = seal('tiling256/closed-report')
    assert j('tiling256/closed-report/FINAL.json')['status'] == 'pass'
    completion = j('tiling256/captured/completion.json')
    native = j('tiling256/captured/native_replay_result.json')
    native_seal = j('tiling256/captured/native-process-seal.json')
    outcome = j('tiling256/captured/outcome-result.json')
    outcome_seal = j('tiling256/captured/outcome-process-seal.json')
    assert closed['source_commit'] == completion['source_commit'] == SOURCE
    assert closed['policy'] == completion['policy'] == POLICY
    assert closed['feature_policy'] == completion['feature_policy'] == 'cumulative-tiling'
    assert closed['stage'] == completion['stage'] == 'tiling'
    assert completion['status'] == 'pass-targeted-diagnostic'
    assert completion['budget'] == completion['actual_objective_calls'] == closed['objective_calls'] == 256
    assert completion['extra_objective_calls'] == closed['extra_objective_calls'] == 0
    assert completion['native_evaluated'] == completion['numeric_validated'] == closed['native_evaluated'] == closed['numeric_validated'] == 5
    assert closed['native_optimizer_sha256'] == NATIVE
    assert completion['certified_scheduler_rejected'] == closed['certified_scheduler_rejected'] == 0
    assert completion['no_candidate_replacement']
    assert native['status'] == 'complete' and native['expected_ranks'] == native['passed_ranks'] == 5
    assert native['binding']['replay_compiler_sha256'] == NATIVE
    assert native['binding']['search_compiler_sha256'] == OPT
    assert native['binding']['search_identity_unchanged'] and native['binding']['selected_ranks'] == list(range(5))
    assert native_seal['status'] == outcome_seal['status'] == 'pass'
    assert native_seal['native_receipt_sha256'] == digest(read('tiling256/captured/native_replay_result.json'))
    assert outcome_seal['outcome_report_sha256'] == digest(read('tiling256/captured/outcome-result.json'))
    assert outcome['status'] == 'pass' and outcome['all_five_native_numeric_success']
    assert outcome['search_objective_calls'] == 256 and outcome['certified_scheduler_rejected'] == 0
    assert outcome['exact_original_rank_order'] == list(range(5))
    rows = outcome['outcomes']
    assert [row['rank'] for row in rows] == list(range(5))
    cycles = [row['native_cycles'] for row in rows]
    assert all(type(value) is int and value > 0 for value in cycles)
    assert cycles == [x['native_cycles'] for x in native['native_shortlist']]
    assert cycles == [x['native_cycles'] for x in closed['original_exact_five_finalists']]
    assert min(cycles) == closed['native_best_cycles'] == completion['native_cycles']
    for rank, row in enumerate(rows):
        numeric_path = f'tiling256/numeric/rank-{rank}/result.json'
        numeric = j(numeric_path)
        numeric_seal = j(f'tiling256/numeric/rank-{rank}/numeric-process-seal.json')
        assert row['outcome'] == 'native-accepted' and row['strict_numeric'] == 'pass'
        assert row['mapper_integrity'] == row['source_integrity'] == row['native_trace'] == 'pass'
        assert row['numeric_coverage_verified'] and row['numeric_negative_chain_verified']
        assert numeric['status'] == numeric_seal['status'] == 'pass'
        assert numeric['positive']['comparisons'] > 0 and numeric['positive']['mismatches'] == 0
        assert numeric_seal['numeric_result_sha256'] == digest(read(numeric_path))
    source_audit_path = next(path for path in completion['artifact_hashes'] if path.endswith('/search-audit.json'))
    assert completion['artifact_hashes'][source_audit_path] == closed['input_sha256'][source_audit_path]

    triple = seal('three-domain-comparison')
    assert j('three-domain-comparison/FINAL.json')['status'] == 'pass'
    assert triple['schema'] == 'orbit-v38-gcn-matched-replica-tiling-full-comparison-v1'
    assert triple['source_commit'] == SOURCE and triple['policy'] == POLICY
    assert [row['stage'] for row in triple['rows']] == ['replica', 'tiling', 'full']
    expected = {'replica': pj('replica256/five-finalists.json')['outcomes'],
                'tiling': rows, 'full': pj('full256/five-finalists.json')['outcomes']}
    best = {}
    for row in triple['rows']:
        values = [x['native_cycles'] for x in expected[row['stage']]]
        assert row['original_exact_five_native'] == values
        assert row['native_cycles'] == min(values) and type(row['native_cycles']) is int
        assert row['objective_calls'] == 256 and row['extra_objective_calls'] == 0
        assert row['native_evaluated'] == row['numeric_validated'] == 5
        assert row['source_commit'] == SOURCE and row['certified_scheduler_rejected'] == 0
        best[row['stage']] = row['native_cycles']
    differences = {'tiling_minus_replica': best['tiling'] - best['replica'],
                   'full_minus_tiling': best['full'] - best['tiling'],
                   'full_minus_replica': best['full'] - best['replica']}
    assert triple['raw_native_cycle_differences'] == differences
    assert triple['practical_tie_tolerance_cycles'] == 1
    assert triple['full_regresses_from_tiling_by_more_than_one_cycle'] == (differences['full_minus_tiling'] > 1)
    assert not triple['paper_admission'] and not triple['formal_admission'] and not triple['main_execution']

    support = seal('reports/materializer-support-boundary')
    assert support['schema'] == 'orbit-v38-gcn-materializer-legality-readonly-v1'
    assert support['source_commit'] == SOURCE
    for field in ('additional_objective_calls', 'additional_native_calls', 'additional_numeric_calls'):
        assert support[field] == 0
    headroom = j('reports/disk-headroom/RECEIPT.json')
    assert digest(read('reports/disk-headroom/RECEIPT.json')) == '4791d73238e366f519c14e9c97a15cc188d0a751e15b9d8a86ebcc5b8b4fd25e'
    assert headroom['status'] == 'pass' and headroom['extra_objective_native_numeric_calls'] == 0
    assert headroom['script_sha256'] == digest(read('captured-tools/diagnosis_archive_closed_checkpoints_20261012_v2.py'))
    assert headroom['script_sha256'] == 'f931537b9b297145ba509ecdb51165020344cd03303f990ccb55ff5ca2c31d88'
    return {'source_commit': SOURCE, 'tiling_original_five': cycles,
            'native_cycles': best, 'raw_native_cycle_differences': differences,
            'new_tiling_original_objective_calls': 256,
            'previous_pair_original_objective_calls': 512,
            'three_domain_original_objective_calls': 768,
            'new_tiling_native_evaluated': 5, 'new_tiling_numeric_validated': 5,
            'additional_objective_native_numeric_calls': 0,
            'paper_or_formal_or_default_admission': False}


def main():
    here = Path(__file__).resolve().parent
    manifest = json.loads((here / 'MANIFEST.json').read_text())
    assert manifest['status'] == 'closed-isolated-research'
    assert manifest['published_pair_commit'] == PAIR_COMMIT
    assert manifest['published_pair_manifest_sha256'] == PAIR_MANIFEST_SHA
    for name, expected in manifest['files'].items():
        path = here / name
        assert path.is_file() and not path.is_symlink() and path.stat().st_size < LIMIT
        assert digest(path.read_bytes()) == expected['sha256'] and path.stat().st_size == expected['bytes']
    assert {str(p.relative_to(here)) for p in here.rglob('*') if p.is_file()} == set(manifest['files']) | {'MANIFEST.json'}
    pair = (here / manifest['published_pair_relative_path']).resolve()
    pair_raw = (pair / 'MANIFEST.json').read_bytes()
    assert digest(pair_raw) == PAIR_MANIFEST_SHA
    prior_manifest = json.loads(pair_raw)

    def prior(name):
        raw = (pair / name).read_bytes()
        expected = prior_manifest['files'][name]
        assert digest(raw) == expected['sha256'] and len(raw) == expected['bytes']
        return raw

    summary = verify_evidence(lambda name: (here / name).read_bytes(), prior)
    assert summary == json.loads((here / 'SUMMARY.json').read_text())
    protocol = json.loads((here / 'protocol.json').read_text())
    assert protocol['source_commit'] == SOURCE and protocol['stage'] == 'tiling'
    assert protocol['feature_policy'] == 'cumulative-tiling'
    assert protocol['recorded_optimizer_sha256'] == OPT and protocol['recorded_native_optimizer_sha256'] == NATIVE
    assert protocol['new_tiling_original_objective_calls'] == 256
    assert protocol['previous_pair_original_calls'] == 512 and protocol['three_domain_logical_calls'] == 768
    assert protocol['old_mechanism64_calls_separate'] == 64 and protocol['original_shortlist_size'] == 5
    assert protocol['strict_numeric_validates_all_five'] and protocol['free_winners'] == 0
    assert not protocol['warm_start'] and not protocol['candidate_replacement']
    assert protocol['additional_objective_native_numeric_calls'] == 0
    assert not protocol['paper_or_formal_or_default_admission']
    table = list(csv.DictReader(io.StringIO((here / 'results.csv').read_text())))
    assert [row['stage'] for row in table] == ['replica', 'tiling', 'full']
    for row in table:
        assert row['source_commit'] == SOURCE and row['objective_calls'] == '256'
        assert int(row['native_cycles']) == summary['native_cycles'][row['stage']]
        assert row['native_evaluated'] == row['numeric_validated'] == '5'
    assert manifest['additional_objective_native_numeric_calls'] == 0
    print(json.dumps(dict(status='pass', files_verified=len(manifest['files']), **summary), indent=2))


if __name__ == '__main__':
    main()
