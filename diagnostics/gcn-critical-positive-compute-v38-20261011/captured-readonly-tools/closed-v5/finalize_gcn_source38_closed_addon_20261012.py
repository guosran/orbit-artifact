#!/usr/bin/env python3
"""Close the Source38 evidence package; no compiler, search, or native calls."""
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


README = '''# GCN critical-positive compute research, Source38

This independent research addon closes the Source38 Replica/Full comparison. Both searches started independently from the canonical GCN program and used **256 objective calls**. Each original five-candidate native shortlist passed all five strict numeric validations.

| Search space | Calls | Best native cycles | Native / numeric validated |
|---|---:|---:|---:|
| Replica | 256 | 920639 | 5 / 5 |
| Full | 256 | 918724 | 5 / 5 |

The same-version difference, **Full − Replica = −1915 cycles**, is recorded in [results.csv](results.csv) and the [matched comparison](matched-comparison/REPORT.json). No free winner, warm start, candidate replacement or historical minimum entered either search. The separate 64-call mechanism diagnostic adds 64 calls, making **576 original objective calls** across these three runs; capture and audit add zero calls.

Source38 changes one compute-target ordering rule: known, supported positive shape opportunities on critical or terminal tasks enter the first tier. Weighted gain and lexical ties remain inside each tier. Shape parameters, legal actions, windows, beam, predictor and evaluator are unchanged by this patch. The [64-call audit](mechanism64/REPORT.json) reconstructed all 284 parent/round catalogues and observed six paid first-tier guided selections, without native or numeric calls.

The [native explanation](reports/source38-full-replica-native-difference/EXPLANATION.md) accounts for the actual completing-chain difference: task duration −1916, transfer +1, reservation wait and residual differences zero. Full selected 17 shape actions and replication of Task14 by two; its winner contains **no fusion, fission or tiling**. The selected geometry is feasible in the Replica space, so these schedules show a different search trajectory rather than direct fusion/fission benefit. [Membership evidence](reports/source38-matched-membership/REPORT.json) still finds the exact Replica winner absent from the Full archive and shortlist, with its first missing typed prefix at depth five. A better final result does not establish that every missed branch was repaired.

The [closed performance report](reports/source38-closed-pair-performance/REPORT.json) records Full search time 3928.00 seconds and 201377 attempts, including 201122 zero-debit attempts; Replica records 350.14 seconds and 4651 attempts, including 4396 zero-debit attempts. These parallel-host observations are not an isolated profile. Zero-debit attempts include legality failures and duplicates. GNU time filesystem outputs remain raw block accounting, not retained bytes or measured bandwidth. The [family audit](reports/source38-action-family-budget/REPORT.json) records 110226 fusion-related attempts with zero materialized/paid candidates; 4122 pending fusion-related entries were unattempted and cannot all be classified as illegal. The prepared fission menu contained zero cuts.

| Role | Public ORBIT commit | Recorded optimizer SHA-256 |
|---|---|---|
| Source38 search | `76345481683a2e199c0cad155de2acb51149f350` | `9996d1b97787242cea42d88511ce530bfa4cb523883705b0746a72a1ff17d7cc` |
| Frozen native mapper/scheduler | `9e7015c3bd4d44dd2ec37df6f02c09aaa0372e55` | `80f11127c25360b591cbd705d3e7d25d3060ba90cf2978f8d5a56133cf58a761` |

The public search pin is on [diagnostic/v38-critical-positive-compute](https://github.com/guosran/orbit/tree/76345481683a2e199c0cad155de2acb51149f350). [protocol.json](protocol.json) separates actual compiler identity from the captured `6a1b...` predictor/cost namespace. Source proof, patch, actual build dependencies/link/archive receipts, prepared-v1/v2 controls, original native/numeric receipts and independent reports are included. The four prepared manifests retain their exact historical payloads through explicit aliases under `history/`.

Shared canonical inputs are pinned by relative path and SHA in [inputs-reference.json](inputs-reference.json). The published [Source37 package](../gcn-research-resumed-20261011/README.md) remains unchanged, including Replica 922559, Full 931310 and its +8751 negative result. Cross-policy native references remain separate from the matched Source38 comparison. The [original-five predictor audit](reports/source38-replica-original-five-predictor-rank/SUMMARY.json) has zero Top1 regret within those five; it makes no full-archive accuracy claim. The [fusion proof-cache proposal](reports/first-fusion-negative-proof-cache-proposal/REPORT.json) is unimplemented and reports no measured speedup. The [disk-admission receipt](reports/disk-admission-recovery/RECEIPT.json) preserves the unchanged 50-GiB gate and verified lossless archival recovery; its compressed host archives are not bundled.

```sh
python3 diagnostics/gcn-critical-positive-compute-v38-20261011/check_package.py
```

The checker verifies packaged hashes, history, identities, budgets and sealed evidence without running an experiment. Absolute host paths in copied receipts record provenance; public source pins and the [build guide](../../docs/INPUT0_NEIGHBORHOOD_REPRODUCIBILITY.md) supply portable code/build context. ELF binaries, caches and large journals/checkpoints are omitted, and fresh-machine end-to-end reproduction has not been tested. This package makes no default, formal or paper admission. The four-program evaluation and Source37 package are unchanged; a separately prepared Tiling256 run is outside this closed pair.
'''


CHECK_TAIL = r'''
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
                   if value['capture_path'] == host and value['original_sha256'] == expected]
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
'''


def main():
    assert not (P / 'MANIFEST.json').exists()
    old = json.loads((P / 'MANIFEST.prepared-v4.json').read_text())
    for name, record in old['files'].items():
        assert sha(P / name) == record['sha256'] and (P / name).stat().st_size == record['bytes'], name
    preserve = ['README.md', 'protocol.json', 'results.csv', 'check_package.py', 'check_static_closeout.py']
    h = P / 'history/prepared-v4'
    assert not h.exists()
    h.mkdir(parents=True)
    for name in preserve:
        (h / name).write_bytes((P / name).read_bytes())
    # Keep the previously reviewed source/build/mechanism checks, then replace
    # the pending-pair section with checks of the closed captured subset.
    old_checker = (h / 'check_package.py').read_text()
    prefix = old_checker[:old_checker.index('table = list(csv.DictReader')]
    prefix = prefix.replace("manifest_path = HERE / 'MANIFEST.json'\nif not manifest_path.exists():\n    manifest_path = HERE / 'MANIFEST.prepared-v3.json'", "manifest_path = HERE / 'MANIFEST.json'")
    prefix = prefix.replace("        if digest(p) != expected['sha256']:", "        if not p.is_file() or digest(p) != expected['sha256']:")
    prefix = prefix.replace("    assert p.stat().st_size == expected['bytes'], name", "    assert p.stat().st_size == expected['bytes'], name\n    assert p.stat().st_size < 3 * 1024 * 1024, name")
    prefix += "\nactual_files = {str(p.relative_to(HERE)) for p in HERE.rglob('*') if p.is_file()}\nassert actual_files == set(manifest['files']) | {'MANIFEST.json'}\nfor name, origin in manifest['source_file_origins'].items():\n    assert origin['byte_identical_capture']\n    assert digest(HERE / name) == origin['original_sha256'], name\n"
    (P / 'check_package.py').write_text(prefix + CHECK_TAIL)
    (P / 'check_static_closeout.py').write_text('''#!/usr/bin/env python3
"""Check the closed package; the original prepared-v4 checker is in history/."""
from pathlib import Path
import runpy
runpy.run_path(str(Path(__file__).resolve().parent / 'check_package.py'), run_name='__main__')
''')
    (P / 'README.md').write_text(README)
    protocol = json.loads((h / 'protocol.json').read_text())
    protocol.update(schema='orbit-source38-research-package-protocol-v2-closed',
                    pair_results_state='closed-matched-pair', completed_pair_cells=['replica', 'full'],
                    pending_pair_cells=[], completed_pair_objective_calls=512, matched_pair_complete=True,
                    pair_native_evaluated=10, pair_numeric_validated=10,
                    total_recorded_objective_calls_including_mechanism=576,
                    extra_objective_native_numeric_calls=0, raw_full_minus_replica_cycles=-1915,
                    prepared_tiling256_included=False)
    write_json(P / 'protocol.json', protocol)
    (P / 'results.csv').write_text('workload,stage,source_commit,objective_cap,actual_objective_calls,status,native_cycles,native_evaluated,numeric_validated\n'
        'gcn,replica,76345481683a2e199c0cad155de2acb51149f350,256,256,pass-targeted-diagnostic,920639,5,5\n'
        'gcn,fission,76345481683a2e199c0cad155de2acb51149f350,256,256,pass-targeted-diagnostic,918724,5,5\n')
    origins = dict(old['source_file_origins'])
    host_evidence = dict(old['original_host_evidence_sha256'])
    capture_receipts = {}
    capture_dir = P / 'capture-provenance'
    capture_dir.mkdir()
    for name in ['full-closed-capture.json', 'closed-addenda-capture.json']:
        host = B / 'gcn-source38-addon-publication-prepared1' / name
        raw = host.read_bytes()
        assert len(raw) < 3 * 1024 * 1024
        (capture_dir / name).write_bytes(raw)
        assert sha(host) == sha(capture_dir / name)
        receipt = json.loads(raw)
        origins.update(receipt['source_file_origins'])
        host_evidence.update(receipt.get('original_host_evidence_sha256', receipt.get('input_sha256', {})))
        dest = 'capture-provenance/' + name
        origins[dest] = {'capture_path': str(host), 'original_sha256': sha(host),
                         'bytes': len(raw), 'byte_identical_capture': True,
                         'captured_absolute_paths_are_host_provenance': True}
        capture_receipts[name] = sha(host)
    # Retain original root-payload provenance under the historical aliases.
    for name in preserve:
        if name in origins:
            origins['history/prepared-v4/' + name] = origins.pop(name)
    generator_dest = P / 'captured-readonly-tools/closed-v5' / Path(__file__).name
    generator_dest.write_bytes(Path(__file__).read_bytes())
    origins[str(generator_dest.relative_to(P))] = {
        'capture_path': str(Path(__file__).resolve()), 'original_sha256': sha(generator_dest),
        'bytes': generator_dest.stat().st_size, 'byte_identical_capture': True,
        'captured_absolute_paths_are_host_provenance': True}
    # Resolve all four prior payload maps to current identical files or exact
    # preserved aliases. This keeps the historic manifests untouched.
    history = []
    all_paths = [x for x in P.rglob('*') if x.is_file()]
    by_hash = {}
    for path in all_paths:
        by_hash.setdefault(sha(path), []).append(str(path.relative_to(P)))
    for version in range(1, 5):
        name = f'MANIFEST.prepared-v{version}.json'
        previous = json.loads((P / name).read_text())
        aliases = {}
        for payload, expected in previous['files'].items():
            if not (P / payload).is_file() or sha(P / payload) != expected['sha256']:
                candidates = by_hash[expected['sha256']]
                selected = next(x for x in candidates if x.startswith('history/'))
                assert (P / selected).stat().st_size == expected['bytes']
                aliases[payload] = selected
        history.append({'path': name, 'sha256': sha(P / name), 'payload_aliases': aliases})
    files = {str(path.relative_to(P)): {'sha256': sha(path), 'bytes': path.stat().st_size}
             for path in sorted(P.rglob('*')) if path.is_file()}
    assert all(value['bytes'] < 3 * 1024 * 1024 for value in files.values())
    for name, origin in origins.items():
        assert files[name]['sha256'] == origin['original_sha256'], name
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
    current_viewer = 'captured-readonly-tools/closed-v5/gcn_research_status.py'
    manifest['host_tool_path_versions'][str(R / 'gcn_research_status.py')] = {
        'latest_capture_sha256': files[current_viewer]['sha256'],
        'latest_packaged_captures': [current_viewer],
        'older_packaged_captures': ['captured-readonly-tools/gcn_research_status.py',
                                  'captured-readonly-tools/closeout-v4/gcn_research_status.py'],
        'previous_capture_sha256': files['captured-readonly-tools/closeout-v4/gcn_research_status.py']['sha256']}
    write_json(P / 'MANIFEST.json', manifest)
    receipt = B / 'gcn-source38-addon-publication-prepared1/final-closed-v5-capture.json'
    assert not receipt.exists()
    write_json(receipt, {'schema': 'orbit-source38-addon-final-closeout-receipt-v1',
                        'manifest_sha256': sha(P / 'MANIFEST.json'), 'payload_files': len(files),
                        'payload_bytes': sum(x['bytes'] for x in files.values()),
                        'source_commit': protocol['actual_search_source_commit'],
                        'original_pair_calls': 512, 'original_mechanism_calls': 64,
                        'additional_objective_native_numeric_calls': 0,
                        'paper_or_formal_admission': False,
                        'source37_and_four_program_snapshot_modified': False})
    print(receipt.read_text())


if __name__ == '__main__':
    main()
