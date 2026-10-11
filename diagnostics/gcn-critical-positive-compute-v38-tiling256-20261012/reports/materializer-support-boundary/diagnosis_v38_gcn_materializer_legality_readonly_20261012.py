#!/usr/bin/env python3
"""Read frozen source and small closed evidence; never invoke a compiler/solver."""
import argparse
import collections
import hashlib
import json
from pathlib import Path
import re
import subprocess
import time

R = Path('/home/shiran/project/orbit-repair-study')
B = R / 'diagnosis/search-regression-repair-20261010'
S = R / 'directional-critical-positive-compute-source'
COMMIT = '76345481683a2e199c0cad155de2acb51149f350'
BASE = '151cf509063bf93276665cea05fb71235f6dd123'
CPP = 'lib/Backend/Neura/Orchestration/JointScheduling/'
FISSION = 'lib/Backend/Neura/Transforms/Optimizations/FissionTaskPass.cpp'
HEADER = 'include/Backend/Neura/Orchestration/JointScheduling/TaskGraphRewriteLegality.h'
DEFAULT_OUT = B / 'v38-gcn-materializer-legality-readonly-20261012'
INPUTS = {}
MAX_SMALL_BYTES = 4 * 1024 * 1024


def sha(data):
    return hashlib.sha256(data).hexdigest()


def read(path, expected=None):
    path = Path(path).absolute()
    assert path.stat().st_size <= MAX_SMALL_BYTES, path
    data = path.read_bytes()
    digest = sha(data)
    assert expected is None or digest == expected, (path, digest, expected)
    assert str(path) not in INPUTS or INPUTS[str(path)] == digest, path
    INPUTS[str(path)] = digest
    return data


def obj(path, expected=None):
    return json.loads(read(path, expected))


def verify_artifacts(seal):
    for path, digest in seal['artifact_sha256'].items():
        read(path, digest)


def textual_tasks(path):
    """Observe generic IR operands/results/op names, not MLIR legality."""
    text = read(path).decode()
    matches = list(re.finditer(
        r'^([^\n]*)"taskflow.task"\(([^\n]*?)\) <\{([^\n]*)task_name = "([^"]+)"[^\n]*',
        text, re.M))
    rows = []
    for ordinal, match in enumerate(matches):
        lead, operands, attrs, name = match.groups()
        ins = [int(x) for x in re.search(
            r'operandSegmentSizes = array<i32: ([^>]+)>', attrs).group(1).split(',')]
        outs = [int(x) for x in re.search(
            r'resultSegmentSizes = array<i32: ([^>]+)>', attrs).group(1).split(',')]
        values = [x.strip() for x in operands.split(',')]
        assert len(ins) == 5 and len(outs) == 3 and sum(ins) == len(values)
        groups, cursor = [], 0
        for count in ins:
            groups.append(values[cursor:cursor + count])
            cursor += count
        binding = re.search(r'(%[^\s:]+)(?::([0-9]+))?\s*=\s*$', lead)
        assert binding
        end = matches[ordinal + 1].start() if ordinal + 1 < len(matches) else len(text)
        chunk = text[match.start():end]
        rows.append(dict(
            name=name, ordinal=ordinal, line=text.count('\n', 0, match.start()) + 1,
            operand_segment_sizes=ins, result_segment_sizes=outs,
            operand_groups=groups, ssa=binding.group(1),
            exact_shared_read_write_roots=sorted(set(groups[3]) & set(groups[4])),
            body_operation_counts=dict(collections.Counter(re.findall(r'"([\w.]+)"\(', chunk))),
            divsi_lines=re.findall(r'([^\n]*"arith.divsi"\([^\n]*)', chunk)))
    assert len(rows) == 28 and len({row['name'] for row in rows}) == 28
    for row in rows:
        count = sum(row['result_segment_sizes'])
        begin = row['result_segment_sizes'][0]
        writes = [row['ssa'] if count == 1 else row['ssa'] + '#' + str(i)
                  for i in range(begin, begin + row['result_segment_sizes'][1])]
        row['done_write_task_uses'] = [dict(task=other['name'], value=value)
                                     for other in rows for value in sum(other['operand_groups'][:3], [])
                                     if value in writes]
    return rows


def source_excerpt(source, relative, first, last, purpose):
    lines = source[relative].splitlines()
    assert 1 <= first <= last <= len(lines)
    selected = lines[first - 1:last]
    return dict(path=str(S / relative), source_sha256=INPUTS[str(S / relative)],
                first_line=first, last_line=last, purpose=purpose,
                excerpt_sha256=sha(('\n'.join(selected) + '\n').encode()),
                numbered_lines=[dict(line=first + i, text=line) for i, line in enumerate(selected)])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output-dir', type=Path, default=DEFAULT_OUT)
    args = parser.parse_args()
    out = args.output_dir.absolute()
    assert not out.exists(), 'Refuse to overwrite an immutable report directory.'
    script = Path(__file__).resolve()
    read(script)
    assert subprocess.check_output(['git', '-C', str(S), 'rev-parse', 'HEAD'], text=True).strip() == COMMIT
    assert not subprocess.check_output(['git', '-C', str(S), 'status', '--porcelain'], text=True).strip()
    source = {}
    equivalent = {}
    relatives = [CPP + 'JointNeighborhoodSearchPass.cpp', CPP + 'JointNeighborhoodActions.cpp',
                 CPP + 'MaterializeNeuraJointRewritePass.cpp', CPP + 'TaskflowFissionSourceReplay.cpp',
                 FISSION, HEADER]
    for relative in relatives:
        data = read(S / relative)
        blob = subprocess.check_output(['git', '-C', str(S), 'show', COMMIT + ':' + relative])
        assert data == blob, relative
        source[relative] = data.decode()
        if relative != CPP + 'JointNeighborhoodSearchPass.cpp':
            old = subprocess.check_output(['git', '-C', str(S), 'show', BASE + ':' + relative])
            assert data == old, relative
            equivalent[relative] = dict(source37_blob_sha256=sha(old), source38_blob_sha256=sha(blob),
                                        byte_identical=True)

    family_dir = B / 'v38-gcn-action-family-budget-readonly-20261012'
    family = obj(family_dir / 'REPORT.json', 'c9d8b0948fabb4522e42ccd38b82af3546bc48f3055d725f0edfbf80b94980a7')
    family_seal = obj(family_dir / 'FINAL.json', 'c5c6424e2225d3d4a110645b17a07f157615a0815c08c3b94fe962aec10bbcfd')
    assert family_seal['status'] == 'pass' and family_seal['input_pre_post_verified'] is True
    read(family_dir / 'REPORT.json', family_seal['report_sha256'])
    read(family_dir / 'REPORT.md', family_seal['markdown_sha256'])
    for key in ['additional_objective_calls', 'additional_native_calls', 'additional_numeric_calls']:
        assert family[key] == family_seal[key] == 0
    actual = family['source38']
    assert actual['source_commit'] == COMMIT and actual['objective_calls'] == 256
    assert actual['canonical_calls'] == 1 and actual['expansion_paid'] == 255

    legacy_dir = B / 'v37-gcn-materializer-legality-readonly-20261011-retry1'
    legacy = obj(legacy_dir / 'REPORT.json', '3f043893afd2c820abd8d3d0cc2270437cd9cefbe3dc73f984309394ed712f6a')
    legacy_seal = obj(legacy_dir / 'FINAL.json', 'df27af63110114f7a5f4c6811815aa0bb9fdc04c2fd1df3bd281ecd5f458b693')
    verify_artifacts(legacy_seal)
    evidence = obj(legacy_dir / 'CANONICAL-TASK-EVIDENCE.json')
    fission_evidence = obj(legacy_dir / 'FISSION-EVIDENCE.json')
    assert legacy['source_commit'] == BASE and legacy['source_git_clean_and_blob_verified'] is True
    canonical_path = R / 'full_prepared-v4/gcn/canonical.mlir'
    prepared_path = R / 'full_prepared-v4/gcn/prepared-source.mlir'
    for path in [canonical_path, prepared_path]:
        read(path, legacy['immutable_input_sha256'][str(path)])
    canonical = textual_tasks(canonical_path)
    prepared = textual_tasks(prepared_path)
    assert canonical == evidence['canonical_tasks'] and prepared == evidence['prepared_tasks']
    by_name = {row['name']: row for row in prepared}
    canonical_by_name = {row['name']: row for row in canonical}
    fission_meta = actual['fission_dimension']
    assert fission_meta == fission_evidence['source_fission_dimension']
    assert fission_meta['complete_cut_action_count'] == 0 and fission_meta['source_replay_verified'] is True
    assert source[CPP + 'JointNeighborhoodSearchPass.cpp'].count('enumerateTaskflowFissionNeighborhoodActions(') == 1
    assert 'for (const NeighborhoodAction &action : precomputedFissionActions)' in source[CPP + 'JointNeighborhoodActions.cpp']
    groups = collections.defaultdict(list)
    for entry in fission_meta['task_support']:
        name, state, reason = entry.split(':', 2)
        assert state == 'unsupported' and name in by_name
        groups[reason].append(name)
    assert sum(map(len, groups.values())) == 28 and len(groups) == 3
    shared_reason = 'fission requires a proof that each read input is disjoint from the task output'
    body_reason = 'fission rejects nested regions and unknown effects'
    abi_reason = 'fission requires tensor write results, matching read/write provenance, and no read/value result'
    assert [len(groups[x]) for x in [shared_reason, body_reason, abi_reason]] == [11, 4, 13]
    shared = [dict(task=name, prepared_line=by_name[name]['line'],
                   exact_shared_roots=by_name[name]['exact_shared_read_write_roots'])
              for name in groups[shared_reason]]
    assert all(row['exact_shared_roots'] for row in shared)
    effect_rows = [dict(task=name, prepared_line=by_name[name]['line'],
                        divsi_lines=by_name[name]['divsi_lines'],
                        operation_counts=by_name[name]['body_operation_counts']) for name in groups[body_reason]]
    assert all(row['operation_counts'].get('arith.divsi') == 1 and
               not any(op.startswith('scf.') for op in row['operation_counts']) for row in effect_rows)
    reads = [name for name in groups[abi_reason] if by_name[name]['result_segment_sizes'][0] != 0]
    assert len(reads) == 12 and set(groups[abi_reason]) - set(reads) == {'Task_25'}
    task25 = by_name['Task_25']
    assert task25['operand_segment_sizes'][1] == 5 and task25['operand_segment_sizes'][4] == 1
    assert task25['result_segment_sizes'] == [0, 1, 0]

    fusion_names = ['fusion', 'fusion-plus-shape', 'fusion-plus-tiling', 'sibling-fusion', 'tiling-plus-fusion']
    fusion_rows = {name: dict(actual['action_families'][name]) for name in fusion_names}
    assert sum(row['attempted'] for row in fusion_rows.values()) == 110226
    assert all(row['materialized'] == row['paid'] == 0 for row in fusion_rows.values())
    rejection_rows = {name: actual['rejection_reasons'][name] for name in fusion_names}
    assert all(sum(rejection_rows[name].values()) == fusion_rows[name]['attempted'] for name in fusion_names)
    pc = collections.Counter()
    for name in fusion_names[:3]:
        pc.update(rejection_rows[name])
    assert sum(pc.values()) == 35246
    assert pc['source_owned_materializer_rejected:post-Neura fusion requires a single-use intermediate state'] == 33242
    assert pc['source_owned_materializer_rejected:post-Neura fusion cannot prove nonconflicting intervening effects'] == 2004
    expected_tiling_reasons = {
        'source_owned_materializer_rejected:post-Neura tiling requires one output state and no yielded read/value state',
        'source_owned_materializer_rejected:dynamic output tiling requires one rank-2 output or a proven rank-1 in-place output',
        'source_owned_materializer_rejected:post-Neura tiling requires identity memrefs with rank no greater than the retained counter rank',
        'source_owned_materializer_rejected:retained counter domain is outside the proven memref shape',
        'source_owned_materializer_rejected:output counter domain is outside the proven shape',
    }
    assert set(rejection_rows['tiling-plus-fusion']) == expected_tiling_reasons
    assert actual['action_families']['fission']['attempted'] == actual['action_families']['fission']['menu'] == 0

    names = sorted(row['name'] for row in canonical)
    order = {row['name']: row['ordinal'] for row in canonical}
    pairs = [(a, b) for i, a in enumerate(names) for b in names[i + 1:]]
    reversed_pairs = [(a, b) for a, b in pairs if order[a] >= order[b]]
    assert len(pairs) == evidence['canonical_sibling_menu_pairs'] == 378
    assert [list(row) for row in reversed_pairs] == evidence['lexicographic_pairs_reversed_in_actual_block']
    assert len(reversed_pairs) == 136
    task7 = canonical_by_name['Task_7']
    task9 = canonical_by_name['Task_9']
    assert len(task7['done_write_task_uses']) == 12
    assert [row['task'] for row in task9['done_write_task_uses']] == ['Task_10', 'Task_10']

    proposal_dir = B / 'v38-gcn-fusion-prefix-proof-cache-readonly-20261012'
    proposal = obj(proposal_dir / 'REPORT.json', 'c519943a381641c26972245ec99f367995674104f9cd2d49a88b532de06c5721')
    proposal_seal = obj(proposal_dir / 'FINAL.json', '198845510f97026fa7ea003b3471d8fa29493fed6dda7c049851a3bff589b520')
    verify_artifacts(proposal_seal)
    assert proposal['source_validation']['38']['commit'] == COMMIT
    assert proposal_seal['runtime_admission'] is False and proposal['compile_or_experiment_run'] is False

    native_dir = B / 'v38-gcn-full-replica-native-difference-readonly-20261012'
    native = obj(native_dir / 'EXPLANATION.json', '7eca0251dc125438004fb802e8125bdfb045bf6fd0fc97d3f49eda8f6d08d3ad')
    native_seal = obj(native_dir / 'EXPLANATION-FINAL.json', '7020c9ae05962c016af9520da455d2ae7346aa2ecdc05b35ffff4478cd53e482')
    verify_artifacts(native_seal)
    assert native['summary']['source_commit'] == COMMIT
    assert native['full_selected_history_has_fusion'] is native['full_selected_history_has_fission'] is native['full_selected_history_has_tiling'] is False

    excerpts = [
        source_excerpt(source, FISSION, 203, 220, 'Same storage root never establishes disjointness.'),
        source_excerpt(source, FISSION, 267, 311, 'Early task ABI and storage support guards precede a DFG plan.'),
        source_excerpt(source, FISSION, 424, 431, 'Generic region/purity/effects guard; label is not a subpredicate trace.'),
        source_excerpt(source, FISSION, 876, 939, 'Early unsupported returns empty; dependency-aware cut DFS executes only after support.'),
        source_excerpt(source, CPP + 'JointNeighborhoodActions.cpp', 1639, 1719, 'SSA PC menu, composite primitive order, and unfiltered lexicographic sibling pairs.'),
        source_excerpt(source, CPP + 'JointNeighborhoodActions.cpp', 1721, 1747, 'Each parent menu appends the precomputed original-source fission actions.'),
        source_excerpt(source, CPP + 'JointNeighborhoodActions.cpp', 1751, 1809, 'Prepared source support reasons feed immutable pass-start fission actions.'),
        source_excerpt(source, CPP + 'JointNeighborhoodActions.cpp', 1907, 1927, 'Primitive failure returns before later primitives can execute.'),
        source_excerpt(source, CPP + 'MaterializeNeuraJointRewritePass.cpp', 1260, 1268, 'Tiling ABI failure precedes fusion in tile-then-fuse.'),
        source_excerpt(source, CPP + 'MaterializeNeuraJointRewritePass.cpp', 1361, 1368, 'Tiling retained-rank failure.'),
        source_excerpt(source, CPP + 'MaterializeNeuraJointRewritePass.cpp', 1388, 1393, 'Tiling dynamic output rank failure.'),
        source_excerpt(source, CPP + 'MaterializeNeuraJointRewritePass.cpp', 1412, 1419, 'Tiling output domain failure.'),
        source_excerpt(source, CPP + 'MaterializeNeuraJointRewritePass.cpp', 1437, 1446, 'Tiling retained domain failure.'),
        source_excerpt(source, CPP + 'MaterializeNeuraJointRewritePass.cpp', 2283, 2334, 'Directed block motion and intervening memory/dependency proof.'),
        source_excerpt(source, CPP + 'MaterializeNeuraJointRewritePass.cpp', 2353, 2425, 'Sibling completion states, dependency, counters, and alias requirements.'),
        source_excerpt(source, CPP + 'MaterializeNeuraJointRewritePass.cpp', 3163, 3245, 'PC ordered/channel/single-use/motion guards precede rewrite.'),
        source_excerpt(source, CPP + 'JointNeighborhoodSearchPass.cpp', 2450, 2487, 'Prepared/canonical proof and one-time cut catalogue setup.'),
        source_excerpt(source, CPP + 'JointNeighborhoodSearchPass.cpp', 1638, 1661, 'Every parent receives the same canonical fission action array.'),
        source_excerpt(source, CPP + 'JointNeighborhoodSearchPass.cpp', 3217, 3233, 'Refresh/round enumeration passes that unchanged precomputed array.'),
        source_excerpt(source, CPP + 'JointNeighborhoodSearchPass.cpp', 3281, 3320, 'Failed materialization records an attempt/reject without reaching scoring.'),
        source_excerpt(source, CPP + 'JointNeighborhoodSearchPass.cpp', 8913, 8924, 'Published fission catalogue/support metadata.'),
        source_excerpt(source, HEADER, 93, 113, 'Shared fusion alias proof and same-root rejection.'),
    ]
    summary = dict(
        source_commit=COMMIT, read_only=True, paper_admission=False,
        fission=dict(prepared_task_count=28, support_guard_rejections=28,
                     support_reason_counts={reason: len(tasks) for reason, tasks in groups.items()},
                     available_cut_actions=0, graph_partitionability_tested=False,
                     cut_cap_is_cause=False, attempted=0, materialized=0, paid=0),
        fusion=dict(fusion_related_attempts=110226, materialized=0, paid=0,
                    producer_consumer_first_fusion_attempts=35246, single_use_rejections=33242,
                    intervening_effect_proof_rejections=2004, sibling_attempts=66173,
                    tiling_plus_fusion_attempts=8807, tiling_plus_fusion_first_failure_stage='tiling',
                    all_menu_edges_proved_illegal=False),
        native_winner=dict(full_cycles=native['summary']['full_native_cycles'],
                           selected_history_uses_fusion=False, selected_history_uses_fission=False,
                           selected_history_uses_tiling=False),
        additional_objective_calls=0, additional_native_calls=0, additional_numeric_calls=0)
    report = dict(
        schema='orbit-v38-gcn-materializer-legality-readonly-v1',
        status='pass-sealed-readonly-support-boundary', source_commit=COMMIT,
        source_validation=dict(head_matches=True, worktree_clean=True, selected_files_match_git_blobs=True,
                               reference_source_commit=BASE, unchanged_legality_sources=equivalent),
        summary=summary,
        fission=dict(source_owned_pass_start_metadata=fission_meta,
                     support_guard_rejections=28, graph_partitionability_tested=False,
                     interpretation='All prepared tasks fail analyzeFission support before cut DFS. Empty supported catalogue does not prove a generally unpartitionable DFG.',
                     disjointness=dict(tasks=shared, cause='Exact identical read/output SSA roots; the current fission plan requires disjoint storage.'),
                     generic_body_guard=dict(tasks=effect_rows, observation='Each of four flat bodies has arith.divsi and no scf region. The combined isPure/isMemoryEffectFree/region diagnostic does not identify its failing subpredicate. No MLIR predicate was newly invoked.',
                                             actual_nested_regions_not_claimed=True, individual_dynamic_purity_result_recomputed=False),
                     task_abi=dict(tasks_with_done_read_completion=reads,
                                   task25=dict(task='Task_25', prepared_line=task25['line'],
                                               will_write_states=5, done_write_results=1, original_write_memrefs=1,
                                               done_read_results=0),
                                   interpretation='These interfaces are outside this fission adapter support contract, not evidence that the original task is invalid.'),
                     cut_cap=dict(max_actions_per_task=64, binding_here=False, reason='All tasks fail before DFS/cap handling.'),
                     generated_graphs_not_reenumerated=True,
                     controller_boundary='The original prepared source is enumerated once; every later parent menu receives the same canonicalFissionActions array. Its zero size means transformed parents never receive newly enumerated fission cuts in this run. This does not prove transformed DFGs unpartitionable.'),
        fusion=dict(family_counts=fusion_rows, rejection_reasons=rejection_rows,
                    producer_consumer_first_failure_totals=dict(pc),
                    first_failure_stage={'fusion':'fusion', 'fusion-plus-shape':'fusion',
                                         'fusion-plus-tiling':'fusion', 'sibling-fusion':'sibling-fusion',
                                         'tiling-plus-fusion':'tiling'},
                    canonical_examples=dict(
                        task7=dict(canonical_line=task7['line'], done_write_operand_uses=task7['done_write_task_uses'],
                                   use_count=12, interpretation='This existing multicast completion/value fan-out fails the current single-use producer contract.'),
                        task9=dict(canonical_line=task9['line'], done_write_operand_uses=task9['done_write_task_uses'],
                                   use_count=2, unique_consumer_count=1,
                                   interpretation='hasOneUse counts SSA operand uses, not distinct consumers; Task_10 uses the state twice.')),
                    limitation='Original first-failure counts do not disaggregate every sibling combined ordering/effects predicate, prove all pending edges illegal, or prove fusion mathematically impossible.'),
        catalogue=dict(
            producer_consumer_menu='Authenticated SSA edges are necessary but do not imply exclusive use, safe motion, matching counters or supported task ABI.',
            sibling_menu='Every lexicographically ordered unordered task pair; current materializer is the legality oracle.',
            canonical_unordered_pairs=378, canonical_reversed_in_actual_block=136,
            canonical_reversed_pair_examples=[list(row) for row in reversed_pairs[:8]],
            interpretation='The catalogue intentionally admits structurally unsupported trials and repeats prefixes across composites/refresh. Canonical ordering evidence is not a decomposition of all 61,519 transformed-parent combined failures.',
            menu_count_semantics=family['menu_count_semantics']),
        semantics_preserving_speedup_proposal=dict(
            status='unimplemented', original_proposal_report=str(proposal_dir / 'REPORT.json'),
            scope='Memoize only the authenticated first PC-fusion single-use rejection at the existing materializer dispatch boundary.',
            requirements=proposal['single_candidate']['required_key'],
            proof_admission=proposal['single_candidate']['proof_admission'],
            unchanged_on_hit=proposal['single_candidate']['unchanged_on_hit'],
            saves=proposal['single_candidate']['physical_work_saved_on_hit'],
            does_not_claim_to_save=proposal['single_candidate']['physical_work_not_claimed_saved'],
            bounded_sample=proposal['observed_prefix'],
            no_measured_speedup_claim=True),
        catalogue_tightening_is_separate=dict(
            semantics='A proven-invalid preflight at the original rejection point may preserve exact events; deleting menu entries or reorienting sibling pairs changes attempt IDs/order, zero-debit service and potentially the search trajectory.',
            admission='No change implemented. Any space/ordering/support extension needs separate preregistered policy and the existing native/numeric gates.'),
        future_questions=[
            'Preserving in-place read/write recurrence and done-read completion states would require a new verified fission support contract, not bypassing current guards.',
            'The generic four-task body rejection could be separated into source-owned structured predicate evidence in a future diagnostic; no individual purity evaluation was added here.',
            'Supporting fan-out-aware PC fusion or nonadjacent sibling motion requires preserving other consumers and alias/control/completion semantics.',
            'Exact-prefix memo adoption needs runtime off/on trace equivalence and conservative IR/source identity; repetition counts are not a CPU speedup measurement.'
        ],
        evidence_scope=dict(existing_closed_source38_frequency_report=str(family_dir / 'REPORT.json'),
                            reused_source37_static_evidence=str(legacy_dir / 'CANONICAL-TASK-EVIDENCE.json'),
                            static_evidence_reparsed_from_same_byte_ir=True,
                            inherited_seals_checked_for_referenced_small_artifacts=True,
                            transitive_large_raw_replay=False, live_journal_or_checkpoint_read=False,
                            new_compiler_invocation=False, source_or_bound_inputs_modified=False),
        source_excerpts_artifact=str(out / 'SOURCE-EXCERPTS.json'),
        additional_objective_calls=0, additional_native_calls=0, additional_numeric_calls=0,
        input_sha256=dict(INPUTS), input_pre_post_verified=True, epoch=time.time())

    f = S / FISSION
    actions = S / (CPP + 'JointNeighborhoodActions.cpp')
    legal = S / (CPP + 'MaterializeNeuraJointRewritePass.cpp')
    text = f'''Source38 GCN support boundary, read-only
======================================

Fission has no candidate because all 28 prepared tasks fail adapter support guards before DFG cut enumeration: 11 have an identical read/output storage root; 12 expose done-read completion results; Task_25 has five will-write states but one done-write/original-write interface; four flat division bodies receive the combined region/purity/effects rejection. This does not establish that their general DFGs cannot be split. The cut cap is not reached. [{f.name}]({f}:283), [{f.name}]({f}:424), [{f.name}]({f}:876).

The controller enumerates cuts once from the authenticated original prepared source and passes this same zero-length action array to every subsequent parent menu. It does not re-enumerate fission cuts for transformed parents. This is an implementation/support boundary, not a proof that all transformed DFGs are unpartitionable. [Pass initialization]({S / (CPP + 'JointNeighborhoodSearchPass.cpp')}:2450), [Parent menu]({actions}:1721).

The four generic body failures contain `arith.divsi` and no nested `scf` region. The source checks region count, `isPure` and `isMemoryEffectFree` together; this audit did not invoke those MLIR predicates anew and does not assign the exact failing subpredicate. [{f.name}]({f}:424).

The closed Full run tried 110,226 fusion-related actions, with zero materialized/paid actions. The first-fusion classes account for 35,246: 33,242 single-use failures and 2,004 intervening-effects proof failures. Canonical Task_7 has twelve output operand uses; Task_9 has two uses by the same Task_10. These dependencies defeat the current exclusive-use contract; they do not rule out a future fusion that preserves every external use. [{legal.name}]({legal}:3193), [{legal.name}]({legal}:3219).

Sibling fusion accounts for 66,173 attempts: 61,519 combined ordering/intervening-effects proof failures; 2,471 done-read interface failures; 1,317 inter-task dependencies; 504 ambiguous output aliases; 362 counter-domain mismatches. The combined reason does not reveal which individual predicate failed in each transformed parent. The canonical menu enumerates 378 lexicographically ordered pairs, of which 136 have the opposite actual block order; this canonical observation is not the full-run reason decomposition. [{actions.name}]({actions}:1706), [{legal.name}]({legal}:2289), [{legal.name}]({legal}:2366).

All 8,807 `tiling-plus-fusion` attempts fail a preceding tiling primitive. Fusion is never reached on those trials, so these failures are not counted as proof that fusion itself is illegal. `fusion-plus-shape` and `fusion-plus-tiling` run fusion first and fail there. [{actions.name}]({actions}:1660), [{actions.name}]({actions}:1671).

The catalogue uses authenticated producer-consumer edges and all unordered sibling pairs, leaving detailed legality to the materializer. Many zero-debit trials therefore repeat unsupported prefixes. Zero debit preserves the objective budget but still incurs attempt/clone/materializer/journal work. The selected Full native history uses shapes and replica only, with no fusion, fission or tiling.

The smallest proposed exact-trajectory optimization is the existing **negative proof memo for the first PC-fusion single-use rejection**. Admit only that structured pure-prefix failure and key it by authenticated exact materializer-entry IR, SSA uses, ordered operations, attributes/locations, source/compiler/verifier identity and typed primitive/history. Replay the same failure and preserve every attempt, candidate ID, cursor, diagnostic, zero-debit cap, feedback, beam and shortlist event. Unknown identity or any other failure takes the original route. This proposal is unimplemented and has no measured speedup. [Original proposal]({proposal_dir / 'REPORT.json'}).

Deleting/reorienting catalogue entries is a separate search-policy change: it changes queue service, attempt serials and zero-debit windows. It must not be presented as an exact cache optimization. No legalizer, source, model, bound input, paper or running Tiling artifact changed.

Evidence: [{family_dir.name}]({family_dir / 'REPORT.json'}), byte-identical Source37 legality files and freshly reparsed canonical/prepared IR, plus the sealed native explanation. `REPORT.json` contains absolute source lines, first-failure tables, scope limits and actual input hashes; `SOURCE-EXCERPTS.json` preserves the cited code. All actual inputs are checked before/after; additional objective/native/numeric calls are 0.
'''
    out.mkdir(parents=True, exist_ok=False)
    artifacts = {}
    def save(name, value):
        path = out / name
        payload = value if isinstance(value, str) else json.dumps(value, indent=2, sort_keys=True) + '\n'
        path.write_text(payload)
        artifacts[str(path)] = sha(path.read_bytes())
    save('SOURCE-EXCERPTS.json', dict(schema='orbit-frozen-source-excerpts-v1', source_commit=COMMIT, excerpts=excerpts))
    save('SUMMARY.json', summary)
    save('REPORT.json', report)
    save('REPORT.md', text)
    post = {path: sha(Path(path).read_bytes()) for path in INPUTS}
    assert post == INPUTS, 'Read-only inputs changed during analysis.'
    seal = dict(schema='orbit-readonly-report-seal-v1', status='sealed-independent-materializer-support-boundary',
                source_commit=COMMIT, report_sha256=artifacts[str(out / 'REPORT.json')],
                markdown_sha256=artifacts[str(out / 'REPORT.md')], script_path=str(script),
                script_sha256=INPUTS[str(script)], artifact_sha256=artifacts,
                input_sha256=INPUTS, input_pre_post_verified=True, runtime_admission=False,
                additional_objective_calls=0, additional_native_calls=0, additional_numeric_calls=0,
                epoch=time.time())
    save('FINAL.json', seal)
    print(json.dumps(dict(output=str(out), summary=summary, artifact_sha256=artifacts,
                         inputs=len(INPUTS)), indent=2, sort_keys=True))


if __name__ == '__main__':
    main()
