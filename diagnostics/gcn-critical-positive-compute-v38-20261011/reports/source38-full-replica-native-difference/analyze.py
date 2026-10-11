#!/usr/bin/env python3
"""Compare two sealed native winners; never invoke mapping or scheduling."""
from collections import Counter
import argparse
import csv
import hashlib
import json
from pathlib import Path
import re
import sys

sys.dont_write_bytecode = True
ART = Path('/home/shiran/project/orbit-artifact/scripts')
sys.path.insert(0, str(ART))
import validate_embedded_native_trace as parser

OUT = Path(__file__).resolve().parent
B = OUT.parent
INPUTS = {}
SOURCE = '76345481683a2e199c0cad155de2acb51149f350'
POLICY = 'schedule-structure-critical-positive-compute-v38'
OLD_REPORT = B / 'v37-gcn-full-replica-native-difference-readonly-20261011/REPORT.json'
OLD_REPORT_SHA = 'd8939054e7abac670f83175f872f00174b46e4550874b59b0eaaee11b6dbbf4c'
PARSER_SHA = '0b782b9efb76c18e5e88f4c1bfa833ab461b55b1d4265bed4cc09a3e5680cde6'
OLD_ANALYZER_SHA = 'c2f1238c9e773db7b12d837df1badfe50ff0d457add3a13fda0d89bc77f618d7'


def sha(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as f:
        for block in iter(lambda: f.read(1 << 20), b''):
            h.update(block)
    return h.hexdigest()


def bind(path, expected=None):
    path = Path(path)
    digest = sha(path)
    assert expected is None or digest == expected, (path, digest, expected)
    INPUTS[str(path)] = digest
    return digest


def read(path, expected=None):
    bind(path, expected)
    return json.loads(Path(path).read_text())


def bound_read(path, bound):
    return read(path, bound[str(path)])


def blocks(text):
    name = None
    for number, line in enumerate(text.splitlines(), 1):
        if line.startswith('    %') and '"taskflow.task"' in line:
            assert name is None
            name = re.search(r'task_name = "([^"]+)"', line)[1]
        if name and line.startswith('    }) {'):
            yield name, number, line
            name = None
    assert name is None


def load_cell(cohort, method):
    root = B / cohort
    unit = root / f'runs/b256/gcn/{method}'
    native = root / f'native/b256/gcn/{method}'
    numeric = root / f'numeric/b256/gcn/{method}'
    completion = read(unit / 'completion.json')
    expected_status = 'pass-targeted-diagnostic'
    assert completion['status'] == expected_status and completion['budget'] == 256
    if expected_status == 'pass-targeted-diagnostic':
        assert completion['actual_objective_calls'] == 256 and completion['extra_objective_calls'] == 0
        assert completion['native_evaluated'] == completion['numeric_validated'] == 5
        assert completion['certified_scheduler_rejected'] == 0
        assert completion['original_receipts_preserved'] and completion['no_candidate_replacement']
    assert completion['source_commit'] == SOURCE and completion['policy'] == POLICY
    binding = read(unit / 'binding.json')
    assert binding['source_commit'] == SOURCE
    assert not (unit / 'failure.json').exists()
    audit_path = unit / 'search-audit.json'
    bind(audit_path, completion['artifact_hashes'][str(audit_path)])
    outcome_dir = unit / 'outcome-audit'
    outcome = read(outcome_dir / 'result.json', completion['artifact_hashes'][str(outcome_dir / 'result.json')])
    outcome_seal = read(outcome_dir / 'outcome-process-seal.json', completion['artifact_hashes'][str(outcome_dir / 'outcome-process-seal.json')])
    assert outcome['status'] == 'pass' and outcome['search_objective_calls'] == 256
    assert outcome['native_evaluated'] == outcome['numeric_validated'] == 5
    assert outcome['certified_scheduler_rejected'] == 0
    assert binding['feature_policy'] == ('all' if method == 'fission' else 'cumulative-replica') and binding['workers'] == 1
    assert binding['seed_manifest'] is None and not binding['same_version_oracle']
    seal_path = native / 'native-process-seal.json'
    seal = read(seal_path, completion['artifact_hashes'][str(seal_path)])
    receipt_path = native / 'native_replay_result.json'
    receipt = read(receipt_path, seal['native_receipt_sha256'])
    assert seal['status'] == 'pass' and receipt['status'] == 'complete'
    assert receipt['expected_ranks'] == 5
    ranks = sorted(receipt['native_shortlist'], key=lambda r: r['rank'])
    assert [r['rank'] for r in ranks] == list(range(5))
    bound = {**receipt['binding']['inputs'], **receipt['artifact_hashes'],
             **seal['artifact_hashes'], **completion['artifact_hashes']}
    for row in ranks:
        assert isinstance(row['native_cycles'], int) and row['native_cycles'] > 0
        assert row['mapper_equality'] == row['independent_trace'] == 'pass'
        assert row['source_fission_replay']['native_candidate_match']
        ns = numeric / f"rank-{row['rank']}/numeric-process-seal.json"
        nr = numeric / f"rank-{row['rank']}/result.json"
        nseal = bound_read(ns, bound)
        nresult = read(nr, nseal['numeric_result_sha256'])
        assert nseal['status'] == nresult['status'] == 'pass'
        assert nresult['positive']['comparisons'] > 0 and nresult['positive']['mismatches'] == 0
    winner = min(ranks, key=lambda r: (r['native_cycles'], r['rank']))
    expected_id, expected_cycles = winner['candidate_id'], winner['native_cycles']
    assert completion['native_cycles'] == expected_cycles
    rank = native / f"native/rank-{winner['rank']}"
    typed = bound_read(rank / 'source-fission-replay-actions.json', bound)
    result = bound_read(rank / 'result.json', bound)
    assert result['candidate_id'] == expected_id and result['native_cycles'] == expected_cycles
    independent = bound_read(rank / 'independent-trace.json', bound)
    assert independent['status'] == 'pass' and independent['native_cycles'] == expected_cycles
    score_path = unit / 'search/replay' / f'{expected_id}-score.jsonl'
    bind(score_path, bound[str(score_path)])
    with score_path.open() as f:
        score = next(r for r in map(json.loads, f) if r.get('record_type') == 'score')
    costs = {r['task']: r for r in score['task_costs']}
    predicted_schedule = {r['task']: r for r in score['task_schedule']}
    native_path = rank / 'native.mlir'
    bind(native_path, bound[str(native_path)])
    ir = native_path.read_text()
    trace = parser.AttributeParser(parser.extract_dictionary(ir, 'joint_scheduling_actual_trace')).document()
    assert trace['candidate_id'] == expected_id
    schedule = {r['task']: r for r in trace['task_schedule']}
    dispatch_raw = re.search(r'joint_scheduling_production_dispatch_order = (\[[^\]]*\])', ir)[1]
    dispatch = json.loads(dispatch_raw)
    assert set(dispatch) == set(schedule) and len(dispatch) == len(schedule)
    tasks = {}
    for name, number, line in blocks(ir):
        ii_values = [int(x) for x in re.findall(r'compiled_ii = (\d+) : i32', line)]
        assert ii_values and len(set(ii_values)) == 1
        ii = ii_values[0]
        trip = int(re.search(r'amoeba.selected_trip_count = (\d+)', line)[1])
        duration = int(re.search(r'profile_info = \{duration = (\d+)', line)[1])
        shape = re.search(r'amoeba.selected_cgra_shape = "([^"]+)"', line)[1]
        task = schedule[name]
        assert duration == task['end_cycle'] - task['start_cycle']
        startup = duration - ii * (trip - 1)
        assert startup == costs[name]['startup_cycles']
        tasks[name] = {'task': name, 'shape': shape, 'trip_count': trip, 'native_ii': ii,
                       'startup_cycles': startup, 'native_duration': duration,
                       'native_start': task['start_cycle'], 'native_end': task['end_cycle'],
                       'cgra_positions': task['cgra_positions'],
                       'predicted_ii': costs[name]['predicted_ii'],
                       'predicted_duration': costs[name]['predicted_duration'],
                       'predicted_start': predicted_schedule[name]['start_cycle'],
                       'predicted_end': predicted_schedule[name]['end_cycle'],
                       'native_source_line': number}
    assert set(tasks) == set(schedule)
    chain = []
    current = max(tasks, key=lambda name: tasks[name]['native_end'])
    seen = set()
    while current not in seen:
        seen.add(current)
        task = tasks[current]
        incoming = [(i, r) for i, r in enumerate(trace['routes']) if r['consumer'] == current]
        index, route = max(incoming, key=lambda pair: pair[1]['ready_cycle']) if incoming else (None, None)
        ready = route['ready_cycle'] if route else 0
        release = tasks[route['producer']]['native_end'] if route else 0
        transfer = route['transfer_cycles'] if route else 0
        reservation_wait = ready - release - transfer if route else 0
        residual = task['native_start'] - ready
        assert reservation_wait >= 0 and residual >= 0
        chain.append({'task': current, 'duration': task['native_duration'],
                      'start': task['native_start'], 'end': task['native_end'],
                      'route_index': index, 'route': route,
                      'transfer': transfer, 'reservation_wait': reservation_wait,
                      'start_residual': residual,
                      'path_latency': route['path_latency_cycles'] if route else 0})
        if not route:
            break
        current = route['producer']
    chain.reverse()
    totals = {k: sum(x[k] for x in chain) for k in ['duration', 'transfer', 'reservation_wait', 'start_residual']}
    assert sum(totals.values()) == expected_cycles
    totals['path_latency_included_in_transfer'] = sum(x['path_latency'] for x in chain)
    canonical = {p: bind(p, digest) for p, digest in binding['files'].items()
                 if '/full_prepared-v4/gcn/' in p}
    return {'completion': str(unit / 'completion.json'), 'completion_sha256': INPUTS[str(unit / 'completion.json')], 'outcome_seal': str(outcome_dir / 'outcome-process-seal.json'), 'search_root': str(unit), 'native_root': str(native), 'numeric_root': str(numeric),
            'source_commit': binding['source_commit'], 'policy': binding['directional_policy'],
            'native_optimizer_sha256': receipt['binding']['replay_compiler_sha256'],
            'native_mlir': str(native_path), 'canonical_inputs': canonical,
            'winner': {k: winner[k] for k in ['rank', 'candidate_id', 'predicted_cycles', 'native_cycles']},
            'shortlist': [{k: r[k] for k in ['rank', 'candidate_id', 'predicted_cycles', 'native_cycles']} for r in ranks],
            'all_five_native_numeric_sealed': True, 'typed_actions': typed['actions'],
            'action_families': dict(Counter(a['family'] for a in typed['actions'])),
            'tasks': tasks, 'native_trace': trace, 'dispatch_order': dispatch,
            'latest_route_completion_chain': chain, 'chain_totals': totals}



def canonical_lineage(cell):
    """Authenticate replica/tile aliases against the replayed typed history."""
    allowed = {'replica': set(), 'tile': set()}
    for action in cell['typed_actions']:
        for primitive in action['primitives']:
            kind = primitive['kind']
            if kind in allowed:
                allowed[kind].add(primitive['firstTask'])
    result = {}
    for task in cell['tasks']:
        if '.replica.' in task:
            prefix, suffix = task.split('.replica.', 1)
            assert prefix in allowed['replica'] and suffix.isdecimal()
            result[task] = prefix
        elif '.tile.' in task:
            prefix, suffix = task.split('.tile.', 1)
            assert prefix in allowed['tile'] and all(x.isdecimal() for x in suffix.split('.'))
            result[task] = prefix
        else:
            result[task] = task
    return result




def closed_key_task_attempts(cell):
    """Stream only the closed original funnel; no queue/menu reconstruction."""
    unit=Path(cell['search_root'])
    completion=read(unit/'completion.json',cell['completion_sha256'])
    sc=unit/'search-completion.json'
    search_completion=read(sc,completion['artifact_hashes'][str(sc)])
    assert search_completion['objective_calls']==256 and search_completion['inputs_pre_post_verified']
    funnel=unit/'search/diagnostics/family-funnel.jsonl'
    bind(funnel,search_completion['artifact_hashes'][str(funnel)])
    names=['Task_9','Task_10','Task_11','Task_12','Task_23','Task_24']
    stats={name:{'shape_attempts':0,'shape_charges':0,'geometries':{},'attempts':[]} for name in names}
    allocation={}; index=0; position=None; initial=None; charges=0
    with funnel.open() as f:
        for line in f:
            event=json.loads(line)
            if event.get('record_type')!='candidate_attempt':continue
            index+=1; prog=event['parent_progress']; action=event['action']; result=event['result']
            debit=result['scheduler_calls']
            assert debit in [0,1] and type(debit) is int
            if position is None:initial=position=prog['objective_evaluations_before']
            assert prog['attempt_global_index']==index
            assert prog['objective_evaluations_before']==position
            assert prog['objective_evaluations_after']==position+debit
            position+=debit; charges+=debit
            family=action['family']; parent=event['parent_id']; key=prog['parent_key']
            assert prog['family']==event['action_family']==family
            keysha=hashlib.sha256(key.encode()).hexdigest()
            bucket=allocation.setdefault(parent,{'same_run_semantic_parent_key_sha256':keysha,'families':{}})
            assert bucket['same_run_semantic_parent_key_sha256']==keysha
            count=bucket['families'].setdefault(family,{'attempts':0,'charges':0})
            count['attempts']+=1;count['charges']+=debit
            if family!='shape' or action['shapeTask'] not in stats:continue
            task=action['shapeTask']; geometry=f"{action['shapeRows']}x{action['shapeCols']}"
            r=stats[task];r['shape_attempts']+=1;r['shape_charges']+=debit
            n=r['geometries'].setdefault(geometry,{'attempts':0,'charges':0})
            n['attempts']+=1;n['charges']+=debit
            r['attempts'].append({'attempt_global_index':index,'round':event['round'],
                'parent_id':parent,'same_run_semantic_parent_key_sha256':keysha,
                'candidate_id':event['candidate_id'],'rows':action['shapeRows'],'cols':action['shapeCols'],
                'before':position-debit,'after':position,'debit':debit,
                'materialized':result['materialized'],'duplicate':result['duplicate'],
                'source_owned_action_signature':prog['action_signature']})
    assert position==256 and charges==256-initial
    return {'source':str(funnel),'exact_semantic_attempts':index,'attempt_charges':charges,
            'initial_canonical_charges':initial,'final_objective_position':position,
            'key_tasks':stats,'per_parent_family_allocation':allocation,
            'scope':'Closed funnel attempts and real scheduler-call debits; hashed source-owned parent key is a same-run identity only. No cross-version key join, beam-cut claim or legal-menu opportunity inference.'}


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--full-root', default='critical-positive-compute-v38-full256-continuation1')
    ap.add_argument('--replica-root', default='critical-positive-compute-v38-replica256-continuation1')
    args = ap.parse_args()
    assert not (OUT / 'REPORT.json').exists(), 'Completed reports are immutable.'
    for cohort, stage in [(args.full_root, 'fission'), (args.replica_root, 'replica')]:
        assert (B / cohort / f'runs/b256/gcn/{stage}/completion.json').is_file(), 'Wait for both original five-rank completion seals.'
    bind(__file__)
    bind(Path(parser.__file__), PARSER_SHA)
    bind(B / 'v37-gcn-full-replica-native-difference-readonly-20261011/analyze.py', OLD_ANALYZER_SHA)
    cells = {'replica': load_cell(args.replica_root, 'replica'),
             'full': load_cell(args.full_root, 'fission')}
    before, after = cells['replica'], cells['full']
    assert before['canonical_inputs'] == after['canonical_inputs']
    assert before['native_optimizer_sha256'] == after['native_optimizer_sha256']
    assert before['source_commit'] == after['source_commit'] == SOURCE
    assert before['policy'] == after['policy'] == POLICY
    assert before['native_optimizer_sha256'] == '80f11127c25360b591cbd705d3e7d25d3060ba90cf2978f8d5a56133cf58a761'
    aliases = {label: canonical_lineage(cell) for label, cell in cells.items()}
    chains = {label: cell['latest_route_completion_chain'] for label, cell in cells.items()}
    lineage_chains = {label: [aliases[label][step['task']] for step in chain]
                      for label, chain in chains.items()}
    additive = ['duration', 'transfer', 'reservation_wait', 'start_residual']
    delta = {key: after['chain_totals'][key] - before['chain_totals'][key] for key in additive}
    cycle_delta = after['winner']['native_cycles'] - before['winner']['native_cycles']
    assert sum(delta.values()) == cycle_delta
    paired = []
    chain_matches = lineage_chains['full'] == lineage_chains['replica']
    if chain_matches:
        for a, b in zip(chains['replica'], chains['full']):
            lineage = aliases['replica'][a['task']]
            assert lineage == aliases['full'][b['task']]
            terms = {key: b[key] - a[key] for key in additive}
            if any(terms.values()):
                paired.append({'canonical_lineage': lineage, 'replica': a, 'full': b,
                               'replica_task_cost': before['tasks'][a['task']],
                               'full_task_cost': after['tasks'][b['task']], 'delta': terms})
        assert {key: sum(r['delta'][key] for r in paired) for key in additive} == delta
    key_tasks = ['Task_9','Task_10','Task_11','Task_12','Task_23','Task_24','Task_18']
    representations = {label: {name: [cell['tasks'][task] for task in cell['tasks']
                                    if aliases[label][task] == name] for name in key_tasks}
                       for label, cell in cells.items()}
    key_attempts={label:closed_key_task_attempts(cell) for label,cell in cells.items()}
    old = read(OLD_REPORT, OLD_REPORT_SHA)
    assert old['status'] == 'pass-sealed-native-schedule-difference-accounting'
    cross_source = {label: {'reference_source_commit': old['cells'][label]['source_commit'],
                            'reference_winner': old['cells'][label]['winner'],
                            'new_winner': cell['winner'],
                            'native_cycles_delta': cell['winner']['native_cycles'] - old['cells'][label]['winner']['native_cycles'],
                            'chain_delta': {key: cell['chain_totals'][key] - old['cells'][label]['chain_totals'][key] for key in additive},
                            'scope': 'Cross-version single-policy-factor reference; local state IDs are never joined.'}
                    for label, cell in cells.items()}
    summary = {'source_commit': SOURCE, 'policy': POLICY,
               'replica_native_cycles': before['winner']['native_cycles'],
               'full_native_cycles': after['winner']['native_cycles'],
               'full_minus_replica': cycle_delta, 'chain_difference': delta,
               'all_five_native_numeric_sealed': True,
               'paired_canonical_completion_chains_match': chain_matches,
               'action_families': {label: cell['action_families'] for label, cell in cells.items()},
               'key_task_shape_attempt_counts': {label:{task:{'attempts':r['shape_attempts'],'charges':r['shape_charges']} for task,r in data['key_tasks'].items()} for label,data in key_attempts.items()},
               'cross_source_reference': cross_source, 'new_calls': 0,
               'paper_admission': False, 'formal_admission': False}
    report = {'schema': 'orbit-gcn-source38-full-replica-native-difference-readonly-v1',
              'status': 'pass-sealed-native-schedule-difference-accounting',
              'summary': summary, 'cells': cells, 'canonical_lineage_aliases': aliases,
              'canonical_completion_chains': lineage_chains, 'paired_chain_term_changes': paired,
              'key_task_native_representations': representations,
              'cross_source37_reference': cross_source, 'closed_key_task_shape_attempts':key_attempts,
              'mechanism_branch_scope': 'Native-only module. Parent opportunity/cut claims require separately sealed semantic trace evidence; no winner/prefix identity inferred from state numbers.',
              'chain_scope': 'Latest explicit incoming route selects a realized completing-producer chain. Path latency is included in transfer. Start residual is not called communication wait. Different histories/shapes/placements are observations, not isolated-action effects or prediction-error evidence for unmapped states.',
              'input_sha256': dict(INPUTS), 'new_objective_mapper_native_numeric_calls': 0,
              'checkpoint_or_archive_read': False, 'closed_funnel_stream_read':True,'paper_or_formal_admission': False}
    # Every actual input read must retain its exact bytes before any result is published.
    for path, digest in INPUTS.items():
        assert sha(path) == digest, ('Input changed during read-only analysis', path)
    (OUT/'REPORT.json').write_text(json.dumps(report, indent=2)+'\n')
    (OUT/'SUMMARY.json').write_text(json.dumps(summary, indent=2)+'\n')
    columns = ['task','shape','trip_count','native_ii','startup_cycles','native_duration',
               'native_start','native_end','predicted_ii','predicted_duration']
    for label, cell in cells.items():
        with (OUT/(label+'-tasks.csv')).open('w') as f:
            writer=csv.DictWriter(f,fieldnames=columns,extrasaction='ignore')
            writer.writeheader(); writer.writerows(cell['tasks'].values())
    lines=['# GCN Source38: Full versus Replica native winners','',
           f"Full: {after['winner']['native_cycles']:,} cycles; Replica: {before['winner']['native_cycles']:,}; Full − Replica: {cycle_delta:+,}. Both original five native/numeric receipt chains are sealed, with identical Source38 policy, canonical inputs and native optimizer.",'',
           '| Completing-chain term | Full − Replica |','|---|---:|']
    lines += [f'| {key} | {value:+,} |' for key,value in delta.items()]
    lines += ['', 'These terms sum exactly to the observed completion-cycle difference. Start residual includes non-route precedence/placement effects; it is not communication wait. Path latency is already included in transfer.', '',
              'The complete original per-task geometry, II, trip count, startup, duration, placement, routes and typed actions are retained in REPORT.json and the task CSVs. Multiple schedule inputs differ, so this accounting does not isolate any action’s causal effect or claim native prediction error for unmeasured parents.', '',
              'Source37 is retained only as a cross-version policy reference. Source38 Full/Replica form the same-version space comparison. Parent IDs are not compared across versions. Key-branch attempt/paid/cut evidence belongs in a separately closed trace report.', '',
              'Only closed original native artifacts and the sealed funnel were read; no objective, native mapping, numeric execution, checkpoint/archive scan, source change, or paper modification was performed.', '']
    (OUT/'REPORT.md').write_text('\n'.join(lines))
    artifacts={str(p):sha(p) for p in [OUT/'REPORT.json',OUT/'SUMMARY.json',OUT/'REPORT.md',
                                      OUT/'replica-tasks.csv',OUT/'full-tasks.csv',Path(__file__)]}
    (OUT/'FINAL.json').write_text(json.dumps({'schema':'orbit-readonly-report-seal-v1',
        'status':'sealed-independent-native-difference','artifact_sha256':artifacts,
        'input_sha256':dict(INPUTS),'input_pre_post_verified':True,'extra_calls':0},indent=2)+'\n')
    print(json.dumps({'output':str(OUT),'report_sha256':sha(OUT/'REPORT.json'),
                     'final_sha256':sha(OUT/'FINAL.json'),'summary':summary,'input_count':len(INPUTS)}))


if __name__ == '__main__':
    main()
