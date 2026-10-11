#!/usr/bin/env python3
"""Bounded, zero-scoring source review; proposes one unimplemented fast path."""
import collections
import hashlib
import json
import subprocess
import time
from pathlib import Path

R = Path('/home/shiran/project/orbit-repair-study')
B = R / 'diagnosis/search-regression-repair-20261010'
OUT = B / 'v38-gcn-fusion-prefix-proof-cache-readonly-20261012'
REL = Path('lib/Backend/Neura/Orchestration/JointScheduling')
SOURCES = {
    '37': (R / 'directional-old-parent-communication-shape-window-source',
           '151cf509063bf93276665cea05fb71235f6dd123'),
    '38': (R / 'directional-critical-positive-compute-source',
           '76345481683a2e199c0cad155de2acb51149f350'),
}
JOURNAL = B / ('retained-communication-shape-window-v37-mechanism1/'
               'runs/b64/gcn/fission/search/diagnostics/family-funnel.jsonl')
LIMIT = 8 * 1024 * 1024


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def dump(path, value):
    assert not path.exists(), path
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')


def bounded_prefix():
    st = JOURNAL.stat()
    with JOURNAL.open('rb') as stream:
        prefix = stream.read(LIMIT)
    complete = prefix[:prefix.rfind(b'\n') + 1]
    return prefix, complete, {
        'inode': st.st_ino, 'bytes': st.st_size, 'mtime_ns': st.st_mtime_ns,
        'read_bytes': len(prefix), 'prefix_sha256': hashlib.sha256(prefix).hexdigest(),
        'complete_line_bytes': len(complete),
        'complete_line_sha256': hashlib.sha256(complete).hexdigest(),
    }


def main():
    assert not OUT.exists(), 'Fresh receipt only; never overwrite a bound report'
    inputs = [Path(__file__).resolve()]
    for directory in ('v37-gcn-materializer-legality-readonly-20261011-retry1',
                      'v37-gcn-closed-pair-performance-readonly-20261011'):
        inputs.extend(B / directory / name for name in ('REPORT.json', 'FINAL.json'))
    inputs.append(B / 'v37-gcn-materializer-legality-readonly-20261011-retry1' /
                  'CANONICAL-TASK-EVIDENCE.json')
    for source, _ in SOURCES.values():
        inputs.extend(source / REL / name for name in
                      ('JointNeighborhoodActions.cpp',
                       'MaterializeNeuraJointRewritePass.cpp',
                       'JointNeighborhoodSearchPass.cpp'))
    before = {str(path): sha(path) for path in inputs}
    source_verification = {}
    for version, (source, commit) in SOURCES.items():
        actual = subprocess.check_output(['git', '-C', str(source), 'rev-parse', 'HEAD'],
                                         text=True).strip()
        assert actual == commit
        assert not subprocess.check_output(['git', '-C', str(source), 'status',
                                            '--porcelain'], text=True).strip()
        blobs = {}
        for name in ('JointNeighborhoodActions.cpp',
                     'MaterializeNeuraJointRewritePass.cpp',
                     'JointNeighborhoodSearchPass.cpp'):
            rel = str(REL / name)
            raw = subprocess.check_output(['git', '-C', str(source), 'show', commit + ':' + rel])
            digest = hashlib.sha256(raw).hexdigest()
            assert digest == before[str(source / rel)]
            blobs[name] = digest
        source_verification[version] = {'commit': commit, 'git_clean': True,
                                        'actual_git_blob_sha256': blobs}
    for name in ('JointNeighborhoodActions.cpp', 'MaterializeNeuraJointRewritePass.cpp'):
        assert source_verification['37']['actual_git_blob_sha256'][name] == \
            source_verification['38']['actual_git_blob_sha256'][name]

    old_legality = json.loads(inputs[1].read_text())
    perf = json.loads((B / 'v37-gcn-closed-pair-performance-readonly-20261011/REPORT.json').read_text())
    prefix, complete, bounded = bounded_prefix()
    assert bounded['prefix_sha256'] == old_legality['bounded_failed_attempts']['prefix_sha256']
    attempts = [json.loads(line) for line in complete.splitlines()]
    attempts = [row for row in attempts if row.get('record_type') == 'candidate_attempt']
    assert len(attempts) == 1919
    groups = collections.defaultdict(list)
    family_counts = collections.Counter()
    reasons = collections.Counter()
    for row in attempts:
        action = row['action']
        primitives = action.get('primitives', [])
        if not primitives or primitives[0]['kind'] != 'fusion' or \
                action['family'] not in ('fusion', 'fusion-plus-shape', 'fusion-plus-tiling'):
            continue
        reasons[row['result']['reject_reason']] += 1
        if row['result']['reject_reason'] != \
                'source_owned_materializer_rejected:post-Neura fusion requires a single-use intermediate state':
            continue
        assert row['typed_action_history']['known']
        assert not row['result']['materialized'] and row['result']['scheduler_calls'] == 0
        key = json.dumps([row['round'], row['parent_id'], action['canonicalReset'],
                          primitives[0], row['typed_action_history']], sort_keys=True)
        family_counts[action['family']] += 1
        groups[key].append({
            'round': row['round'], 'parent_id': row['parent_id'],
            'candidate_id': row['candidate_id'], 'family': action['family'],
            'first_primitive': primitives[0],
            'reject_reason': row['result']['reject_reason'],
            'scheduler_calls': row['result']['scheduler_calls'],
            'canonical_reset': action['canonicalReset'],
            'typed_history_sha256': hashlib.sha256(json.dumps(
                row['typed_action_history'], sort_keys=True).encode()).hexdigest(),
        })
    repeated = [rows for rows in groups.values() if len(rows) > 1]
    result = {
        'schema': 'orbit-source38-fusion-prefix-proof-cache-readonly-v1',
        'status': 'pass-readonly-proposal-unimplemented',
        'source_validation': source_verification,
        'input_sha256': before,
        'bounded_closed_journal': {'path': str(JOURNAL), **bounded},
        'observed_prefix': {
            'complete_candidate_attempts': len(attempts),
            'first_fusion_rejection_counts': dict(reasons),
            'single_use_failures': sum(map(len, groups.values())),
            'single_use_failure_families': dict(family_counts),
            'parent_round_typed_history_primitive_signatures': len(groups),
            'repeated_signatures': len(repeated),
            'potential_subsequent_prefix_reuses': sum(len(rows) - 1 for rows in groups.values()),
            'all_selected_failures_have_zero_scheduler_calls': True,
            'counts_are_not_cpu_savings_or_full256_frequency_estimates': True,
            'runtime_cache_requires_exact_ir_proof_beyond_this_trace_signature': True,
        },
        'single_candidate': {
            'name': 'Negative proof memo for the first producer-consumer fusion primitive',
            'insertion_boundary': ('runMaterializer, after original option parsing and all caller preflights; '
                                   'only first primitive, supported producer-consumer-retained/forwarded modes'),
            'source_locations': {
                'enumerated_pure_and_composite_prefixes': 'JointNeighborhoodActions.cpp:1647-1707',
                'whole_action_guards_and_trial_clone': 'JointNeighborhoodActions.cpp:1814-1867',
                'primitive_target_lineage_and_dispatch': 'JointNeighborhoodActions.cpp:1868-1927',
                'original_pass_option_parse_capture_dispatch': 'JointNeighborhoodActions.cpp:470-521',
                'read_only_single_use_failure_prefix': 'MaterializeNeuraJointRewritePass.cpp:3163-3223',
                'failure_precedes_rewrite': 'MaterializeNeuraJointRewritePass.cpp:4594-4603,4696-4716',
                'attempt_reject_and_original_accounting': 'JointNeighborhoodSearchPass.cpp:3271-3320,3436-3469',
            },
            'proof_admission': [
                'Only admit the structured single-use rejection: mode/names/one-block ordering/channel exclusivity/exactly one RAW edge checks already passed, then producer result or consumer input has use count other than one.',
                'Use the source-owned pure prefix helper, or authenticate its result against the ordinary source pass on the first miss; never memoize a generic empirical materializer-rejected string.',
                'Cache exact original reason and captured diagnostic, including its source location context. Unknown proof, malformed options, other failures or changed input fall back to the unmodified path.',
                'Call-site must establish the exact same IR at materializer entry and original verification route. A task-name pair, graph facts key or prior candidate success is insufficient.',
            ],
            'ir_fields_read_by_this_prefix': [
                'All task_name matches module-wide; unique producer/consumer operations.',
                'Producer and consumer identity, block identity and operation ordering.',
                'Consumer willReads operand list; defining TaskflowChannel chain, source operand and each intermediate SSA use list.',
                'Producer doneWrites results, exact matching RAW edge count and producer/consumer intermediate SSA use counts.',
                'Operation/module locations for exact diagnostic text; pass mode and nonempty target option checks.',
            ],
            'shape_placement_dependency': {
                'external_shapes_vector_read': False,
                'native_placement_schedule_or_predicted_cost_read': False,
                'reason': 'Source prefix and runMaterializer fusion branch receive no shapes vector, placement or cost. The action shape suffix executes only after all primitives succeed.',
                'replica_and_tiling_dependence': 'These change names, SSA edges/use lists, channels and block order, so any different IR revision invalidates the memo even if endpoints retain names.',
                'ir_attributes': 'Conservative key includes all IR attributes and locations, including shape/replica/active-transfer/source proof metadata at the actual post-suspension entry view. Do not infer that external shape independence permits arbitrary attribute omission.',
                'effects': 'The admitted single-use failure is before intervening-effects analysis. Full ordered IR still belongs to the key; failures from later effect/alias/counter/body checks are excluded.',
            },
            'required_key': [
                'Materializer source/version and exact compiler closure; route/verifier settings and dialect environment.',
                'Exact materializer-entry IR content/revision proof, all attributes/locations, SSA operands/use graph, ordered blocks/operations and bodies. Compute once per authenticated immutable parent/view, not by task names or a fresh full serialization for each attempt.',
                'Resolved effective canonical/source proof view and typed action-history identity; source-domain/active-transfer suspension route and function selection.',
                'Canonical-reset flag, selected function, max partition factor, normalized first primitive including retained versus forwarded mode and both targets.',
                'Conservative parent shapes vector can be included initially; its omission requires the documented code proof. Composite suffix is not prefix identity, but original whole-action suffix guards must still execute before lookup.',
            ],
            'excluded_paths': [
                'Sibling fusion, later fusion following successful tiling, fission/withdrawal/replay, canonical resets with different entry IR, generic pass or verifier failures.',
                'Any clone/option/source-domain/active-transfer/lineage error must retain its original precedence; no lookup before those original checks.',
                'Any successful primitive or IR edit requires a new view token; no reuse solely because graph topology or task names appear unchanged.',
            ],
            'physical_work_saved_on_hit': 'Only the source pass manager invocation and repeated fusion prefix analysis at the existing dispatch boundary.',
            'physical_work_not_claimed_saved': 'Existing child/action-canonical/private-trial clones, outer proof/lineage checks, attempt enumeration, sidecar/checkpoint serialization, scheduler calls and prediction.',
            'unchanged_on_hit': [
                'Same menu entries and order, candidate serial/ID/path, attempted edge commit, parent-progress cursor and exact original reject reason/diagnostic.',
                'Same attempted/rejected/archive/family funnel event and all ordinary/guided/window feedback; zero debit, zero cap, reserve, refresh, beam/archive/shortlist unchanged.',
                'Do not set the existing cost-cache_reused event flag for this internal legality memo, as that would change the old event semantics.',
            ],
        },
        'independent_validation_required_before_adoption': [
            'New isolated implementation/source/build; do not modify Source38 inputs. First compare source-owned pure-prefix proof against baseline pass on identical verified IR, preserving exact reason/diagnostic and no mutation.',
            'Replay all actual pending selections and prove complete semantic event equality: parent typed state/action/parameters/candidate ID, original rejection, materialization/unique/duplicate bits, paid versus zero, feedback, queue cursor/remaining, window scope/counters, refresh and beam/archive/shortlist.',
            'Include pure/composite same first primitive but different suffix guards, retained/forwarded distinction, transformed intermediate IR, missing/duplicate names, opposite block order, channels, multi-use values, malformed proof/options and locations.',
            'Compare canonical independent 64 then relevant 256 full trajectories, not only paid projections or final cycles; additional calls count as diagnostic budget. Run original exact5 native/numeric comparison only after trajectory equivalence.',
            'Failure-only hits must never reach the scheduler or predictor; all original zero-debit records remain. Report actual timing separately; prefix counts are merely bounded eligibility observations.',
        ],
        'closed_performance_reference': {
            'report': str(B / 'v37-gcn-closed-pair-performance-readonly-20261011/REPORT.json'),
            'full_attempts': 165627, 'full_zero': 165372, 'full_wall_seconds': 3312.20,
            'full_objective_calls': 256,
            'phase_instrumentation_available': False,
            'not_a_runtime_speedup_prediction': True,
        },
        'new_objective_calls': 0, 'new_native_calls': 0, 'new_numeric_calls': 0,
        'compile_or_experiment_run': False, 'source_or_bound_inputs_modified': False,
        'live_journal_or_checkpoint_read': False,
        'epoch': time.time(),
    }
    after = {str(path): sha(path) for path in inputs}
    assert before == after
    prefix_after, _, bounded_after = bounded_prefix()
    assert prefix_after == prefix and bounded_after == bounded
    OUT.mkdir()
    dump(OUT / 'BOUNDED-REPEATED-PREFIXES.json', {
        'schema': 'orbit-bounded-first-fusion-repeat-witness-v1',
        'potential_repeats_not_implemented_cache_hits': True,
        'source_journal': str(JOURNAL), **bounded, 'groups': repeated,
    })
    dump(OUT / 'REPORT.json', result)
    dump(OUT / 'FINAL.json', {
        'schema': 'orbit-source38-fusion-prefix-proof-cache-readonly-final-v1',
        'status': 'pass-readonly-proposal-unimplemented',
        'input_sha256': before,
        'artifact_sha256': {str(OUT / name): sha(OUT / name) for name in
                           ('REPORT.json', 'BOUNDED-REPEATED-PREFIXES.json')},
        'bounded_prefix_pre_post_verified': True,
        'new_objective_calls': 0, 'new_native_calls': 0, 'new_numeric_calls': 0,
        'runtime_admission': False, 'epoch': time.time(),
    })
    print(json.dumps({'root': str(OUT), 'report_sha256': sha(OUT / 'REPORT.json'),
                      'final_sha256': sha(OUT / 'FINAL.json'),
                      'single_use_failures': sum(map(len, groups.values())),
                      'potential_prefix_reuses': sum(len(rows)-1 for rows in groups.values()),
                      'new_objective_calls': 0}, indent=2))


if __name__ == '__main__':
    main()
