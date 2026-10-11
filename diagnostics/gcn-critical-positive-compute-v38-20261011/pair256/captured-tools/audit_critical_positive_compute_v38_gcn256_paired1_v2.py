#!/usr/bin/env python3
"""Bounded independent Source38 Full/Replica256 replay, copied from the sealed64 all-parent audit."""
import hashlib
import json
from collections import Counter, defaultdict, deque
from pathlib import Path
import sys
import time
import subprocess

sys.path.insert(0, str(Path(__file__).resolve().parent / "diagnosis/python-deps"))
import ijson
import diagnosis_window_axis_tie_v35_uniform_20261011_ready5_joint_audit as W
from diagnosis_directional_tiling_chain_audit import root_members, checkpoint_events, tie, signature, target
import diagnosis_critical_positive_compute_v38_direction_replay as V

R = Path(__file__).resolve().parent
B = R / 'diagnosis/search-regression-repair-20261010'
UNIT = OUT = COHORT = None
STAGE = FEATURE = None
FINAL_ROUND = None
COMMIT = '76345481683a2e199c0cad155de2acb51149f350'
POLICY = 'schedule-structure-critical-positive-compute-v38'
PROGRESS = 'semantic-parent-family-ordered-suffix-v1'


def require(ok, message):
    if not ok:
        raise ValueError(message)


def sha(path):
    path = Path(path)
    before = path.stat()
    digest = hashlib.sha256()
    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1 << 20), b''):
            digest.update(block)
    after = path.stat()
    require((before.st_size, before.st_mtime_ns) == (after.st_size, after.st_mtime_ns), 'File changed during hash')
    return digest.hexdigest()


def rows(path):
    with Path(path).open() as stream:
        for line in stream:
            if line.strip():
                yield json.loads(line)


def check(hashes):
    for path, digest in hashes.items():
        require(sha(path) == digest, 'Hash differs: ' + path)


def edge(parent, action_signature):
    return hashlib.sha256(json.dumps([parent, action_signature], separators=(',', ':')).encode()).digest()


def checkpoint_action_signature(action):
    # The frozen checkpoint serializer uses snake_case while typed sidecars use
    # camelCase. Normalize only those source-defined field spellings.
    typed = dict(family=action['family'], label=action['label'],
        shapeTask=action['shape_task'], shapeRows=action['shape_rows'],
        shapeCols=action['shape_cols'], canonicalReset=action['canonical_reset'],
        primitives=[dict(kind=p['kind'], firstTask=p['first_task'],
            secondTask=p['second_task'], mode=p['mode'], axis=p['axis'],
            factor=p['factor'], leftNodes=p['left_nodes']) for p in action['primitives']])
    return signature(typed)


def write(path, value):
    with path.open('x') as stream:
        json.dump(value, stream, indent=2); stream.write('\n')


def main():
    require(not OUT.exists(), 'Preserve prior audit; never overwrite')
    closure_path = UNIT / 'search-completion.json'
    require(closure_path.exists(), 'Search is not closed')
    OUT.mkdir(parents=True)
    started = time.monotonic()
    inputs = {}
    def bind(path):
        path = Path(path).resolve(); inputs[str(path)] = sha(path)
    for p in [Path(__file__), R / 'diagnosis_directional_tiling_chain_audit.py', Path(W.__file__), Path(V.__file__), FINAL_ROUND]:
        bind(p)
    prereg=json.loads(FINAL_ROUND.read_text())
    require(prereg['source_commit']==COMMIT and prereg['objective_cap_per_case']==256 and
        prereg['stage']==STAGE and prereg['feature_policy']==FEATURE and prereg['paper_admission'] is False and
        prereg['main_execution'] is False, 'Source38 continuation scope differs')
    gate_root=B/'critical-positive-compute-v38-mechanism1/audit'
    gate=json.loads((gate_root/'FINAL.json').read_text())
    require(gate['status']=='pass' and gate['mechanism_positive'] is True and gate['source_commit']==COMMIT and
        gate['report_sha256']==sha(gate_root/'REPORT.json') and gate['markdown_sha256']==sha(gate_root/'REPORT.md') and
        prereg['mechanism64_final_sha256']==sha(gate_root/'FINAL.json') and
        prereg['mechanism64_report_sha256']==sha(gate_root/'REPORT.json'), 'Sealed64 mechanism gate differs')
    bind(gate_root/'FINAL.json');bind(gate_root/'REPORT.json');bind(gate_root/'REPORT.md')
    gate_report=json.loads((gate_root/'REPORT.json').read_text());check(gate_report['input_sha256']);inputs.update(gate_report['input_sha256'])
    complete = json.loads(closure_path.read_text())
    require(complete['status'] == 'search-completed-unverified', 'Unexpected search closure')
    check(complete['artifact_hashes'])
    driver = json.loads((UNIT / 'driver-binding.json').read_text())
    auth_path = COHORT/'prepared-v2/ROOT-authorization.json'
    plan_path = COHORT/'prepared-v2/gcn-256-runner-binding.json'
    auth = json.loads(auth_path.read_text()); plan = json.loads(plan_path.read_text())
    require(sha(auth_path) == driver['root_authorization_sha256'] and
        sha(plan_path) == driver['runner_binding_sha256'] == auth['runner_binding_sha256'],
        'Root authorization or prepared command changed')
    require(driver['argv'] == auth['argv'] == plan['argv'] and driver['output'] == str(UNIT),
        'Executed command is not the exact Root-authorized fresh output')
    require(auth['status'] == 'pass' and auth['objective_cap_per_case'] == 256 and
        auth['native_attempts_per_case']==5 and auth['numeric_all_accepted_authorized'] is True and
        auth['scope']==f"source38-independent-gcn-{'full' if STAGE=='fission' else 'replica'}256-exact5-continuation" and
        auth['stage']==STAGE and plan['feature_policy']==FEATURE and
        plan['preregistration_sha256']==sha(FINAL_ROUND),
        'Authorization scope differs')
    proof_path = B / 'critical-positive-compute-v38-prepared1/source-proof.json'
    proof = json.loads(proof_path.read_text())
    source = Path(proof['source']); rel = proof['cpp_relative']
    require(proof['new_commit'] == COMMIT and proof['base_commit'] == '151cf509063bf93276665cea05fb71235f6dd123', 'Source proof cohort differs')
    require(subprocess.check_output(['git','-C',str(source),'rev-parse','HEAD'],text=True).strip() == COMMIT and
        not subprocess.check_output(['git','-C',str(source),'status','--porcelain'],text=True).strip(), 'Source not frozen clean')
    old = subprocess.check_output(['git','-C',str(source),'show',proof['base_commit']+':'+rel])
    new = (source/rel).read_bytes()
    require(hashlib.sha256(old).hexdigest() == proof['base_cpp_sha256'] and sha(source/rel) == proof['new_cpp_sha256'], 'Source proof bytes differ')
    require(subprocess.check_output(['git','-C',str(source),'diff','--binary',proof['base_commit'],COMMIT]) == Path(proof['diff_path']).read_bytes() and
        sha(proof['diff_path']) == proof['diff_sha256'], 'Exact source delta changed')
    for region in proof['unchanged_regions']:
        start=region['start'].encode(); end=region['end'].encode()
        a=old.index(start); b=old.index(end,a); c=new.index(start); d=new.index(end,c)
        # The original category-head region records its inclusive terminal marker.
        if end.endswith(b'      }\n'): b+=len(end); d+=len(end)
        require(old[a:b] == new[c:d] and hashlib.sha256(old[a:b]).hexdigest() == region['sha256'], 'Unchanged search/materializer region changed')
    for path in [auth_path,plan_path,proof_path,Path(proof['diff_path'])]: bind(path)
    check(driver['source_hashes'])
    inputs.update(driver['source_hashes'])
    inputs.update(complete['artifact_hashes'])
    bind(closure_path)
    bind(COHORT/'supervisor-launch.json')
    s = UNIT / 'search'
    result = root_members(UNIT / 'result.json', {'status', 'binding', 'objective_evaluations', 'artifact_hashes'})
    require(result['status'] == 'completed' and result['objective_evaluations'] == 256, 'Exact256 independent search did not complete')
    check(result['artifact_hashes'])
    binding = result['binding']
    require(binding['source_commit'] == driver['source_commit'] == COMMIT, 'Not the frozen Source38 compute-tier source')
    require(driver['actual_policy'] == POLICY and driver['objective_call_cap'] == 256, 'Driver policy/budget differs')
    check(binding['files'])
    inputs.update(binding['files'])
    expected = dict(flow='joint', budget=256, rounds=20, beam=16, diversity=4, workers=1,
        round_quota_scale=1, fair_pending=True, refresh_frontier=True, parent_progress=True,
        feature_policy=FEATURE, shape_enumeration_order='ascending', bootstrap_supported_shapes=True,
        checkpoint_actions=4096, directional_search=True, directional_policy=POLICY,
        retained_communication_window=True, critical_positive_compute=True, paper_admission=False,
        diagnostic_path=None, diagnostic_continue=False, seed_manifest=None)
    for key, value in expected.items():
        require(binding.get(key) == value, 'Control differs: ' + key)
    summary = root_members(s / 'search-summary.json', {'production_scheduler_calls',
        'unique_complete_candidates_scored', 'directional_policy', 'retained_communication_window', 'critical_positive_compute'},
        required={'production_scheduler_calls', 'directional_policy', 'retained_communication_window', 'critical_positive_compute'})
    checkpoint = root_members(s / 'checkpoint.json', {'scored_candidates', 'directional_policy',
        'retained_communication_window', 'critical_positive_compute'})
    require(summary['production_scheduler_calls'] == checkpoint['scored_candidates'] == 256, 'Budget summary/checkpoint mismatch')
    require(summary['directional_policy'] == checkpoint['directional_policy'] == POLICY and
        summary['retained_communication_window'] is checkpoint['retained_communication_window'] is True,
        'Policy metadata differs')
    require(summary['critical_positive_compute'] is checkpoint['critical_positive_compute'] is True, 'Compute tier flag differs')
    budget = list(rows(s / 'budget-trace.jsonl'))
    require([v['cumulative_evaluations'] for v in budget] == list(range(1, 257)), 'Noncontiguous budget')
    paid = {v['candidate_id']:v['cumulative_evaluations'] for v in budget}
    require(len(paid) == 256, 'Candidate charged twice')
    valid = {}
    for row in rows(s / 'archive.jsonl'):
        if row.get('valid'):
            valid[row['candidate_id']] = row
    require(len(valid) <= 256, 'Unexpected uncharged valid configurations')
    root = valid.get('neighborhood-0')
    require(root and root['action_history']['known'] is True and not root['action_history']['actions'] and
        not root['action_history']['fissionActions'] and all(v['rows']==v['cols']==1 for v in root['shapes']),
        'Initial candidate is not the unmodified canonical1x1 identity')
    for row in valid.values():
        require(row['action_history']['known'] is True and all(v['rows']>0 and v['cols']>0 and v['rows']*v['cols']<=4 for v in row['shapes']),
            'Persisted typed candidate leaves the frozen shape domain')
    refresh = {e['round']:e for e in rows(s / 'frontier-refresh.jsonl')}
    allocations = defaultdict(Counter)
    seen = set()
    attempts = {}
    position = None
    initial_position = None
    queues = {}
    progress = iter(rows(s / 'parent-progress.jsonl'))
    pe = next(progress, None)
    progress_counts = Counter()
    round_shape_menus = {}
    round_all_menus = {}

    def apply(p):
        kind = p['record_type']; progress_counts[kind] += 1
        require(p['policy'] == PROGRESS, 'Progress policy differs')
        key = p['parent_key'], p.get('family')
        if kind == 'parent_retired':
            for k in list(queues):
                if k[0] == p['parent_key']: del queues[k]
        elif kind == 'queue_update':
            q = queues.setdefault(key, dict(remaining=deque(), cursor=0, attempts=0))
            before = list(q['remaining'])
            require(before == p['previous_remaining'] and q['cursor'] == p['cursor']
                and q['attempts'] == p['stream_attempts'], 'Previous progress queue differs')
            retained = p['retained_remaining']; appended = p['appended_signatures']
            remaining = iter(before)
            require(all(any(x == v for x in remaining) for v in retained), 'Retained suffix reordered')
            require(set(before)-set(retained) == set(p['removed_signatures']), 'Removed signatures differ')
            require(set(retained).isdisjoint(appended) and len(set(retained+appended)) == len(retained+appended), 'Queue duplicates')
            q['remaining'] = deque(retained+appended)
        elif kind == 'directional_reorder':
            require(p['directional_policy'] == POLICY, 'Reorder has wrong policy')
            q = queues[key]; before = list(q['remaining']); offset = p['selected_offset']
            require(before == p['before_remaining'] and q['cursor'] == p['cursor'], 'Reorder input differs')
            require(0 < offset < len(before) and before[offset] == p['action_signature'], 'Reorder selected offset differs')
            after = [before[offset]] + before[:offset] + before[offset+1:]
            require(after == p['after_remaining'], 'Reorder is not exact rotation')
            q['remaining'] = deque(after)
        else:
            raise ValueError('Unknown progress event: ' + kind)

    count = 0
    missing = []
    funnel_path = s / 'diagnostics/family-funnel.jsonl'
    for event in rows(funnel_path):
        if event.get('record_type') != 'candidate_attempt': continue
        count += 1
        while pe is not None and pe['round'] <= event['round'] and (
            pe['record_type'] != 'directional_reorder' or pe['attempt_global_index'] <= count):
            apply(pe); pe = next(progress, None)
        if event['round'] not in round_shape_menus:
            round_all_menus[event['round']] = [(key,sig) for (key,family),q in queues.items() for sig in q['remaining']]
            round_shape_menus[event['round']] = {key: list(q['remaining']) for (key,family),q in queues.items() if family == 'shape'}
        p = event['parent_progress']; action = event['action']; sig = signature(action)
        require(p['policy'] == PROGRESS and p['action_signature'] == sig and p['target'] == target(action)
            and p['family'] == event['action_family'] == action['family'], 'Typed progress identity differs')
        require(p['parent_key'] == valid[event['parent_id']]['candidate_key'], 'Parent semantic key differs')
        digest = edge(p['parent_key'], sig)
        require(digest not in seen, 'Exact semantic edge committed twice'); seen.add(digest)
        q = queues[p['parent_key'], p['family']]
        require(q['cursor'] == p['cursor_before'] and q['attempts']+1 == p['stream_attempts'], 'Progress cursor/attempts differ')
        require(q['remaining'] and q['remaining'][0] == sig and q['cursor']+len(q['remaining']) == p['queue_size'], 'Committed edge not legal queue head')
        q['remaining'].popleft(); q['cursor'] += 1; q['attempts'] += 1
        require(p['cursor_after'] == p['cursor_before']+1 == q['cursor'], 'Cursor does not advance once')
        if position is None:
            position = p['objective_evaluations_before']
            initial_position = position
        debit = int(event['result']['scheduler_calls'])
        require(p['attempt_global_index'] == count and p['objective_evaluations_before'] == position
            and p['objective_evaluations_after'] == position+debit and debit in (0,1), 'Charge progression differs')
        if debit: require(paid[event['candidate_id']] == position+1, 'Funnel/budget charge differs')
        else: require(event['candidate_id'] not in paid, 'Zero-debit candidate charged')
        position += debit
        # Retain a small committed witness for join, not the full action/history/archive record.
        attempts[count] = dict(candidate_id=event['candidate_id'], parent_id=event['parent_id'],
            parent_key=p['parent_key'], signature=sig, family=action['family'], target=p['target'],
            round=event['round'], debit=debit, before=position-debit, after=position,
            materialized=event['result']['materialized'], duplicate=event['result']['duplicate'])
        allocations[event['parent_id']][action['family']+'_attempts'] += 1
        allocations[event['parent_id']][action['family']+'_charges'] += debit
        if event['parent_id'] == 'neighborhood-0' and action['family'] == 'shape' and action['shapeTask'] == 'Task_7':
            missing.append(dict(attempts[count], rows=action['shapeRows'], cols=action['shapeCols'], attempt_global_index=count))
    while pe is not None:
        require(pe['record_type'] != 'directional_reorder', 'Reorder without committed attempt')
        apply(pe); pe = next(progress, None)
    require(position == 256, 'Funnel does not reconcile final budget')
    with (s / 'checkpoint.json').open('rb') as stream:
        stored = set()
        for text in ijson.items(stream, 'parent_progress_queues.attempted_edges.item'):
            parent, action = json.loads(text); digest = edge(parent, signature(action))
            require(digest not in stored, 'Checkpoint duplicates exact edge'); stored.add(digest)
    require(stored == seen, 'Checkpoint edge set differs')
    saved_queues = {}
    with (s / 'checkpoint.json').open('rb') as stream:
        for parent in ijson.items(stream, 'parent_progress_queues.parents.item'):
            for family in parent['families']:
                cursor = family['cursor']
                saved_queues[parent['parent_key'], family['family']] = dict(
                    remaining=deque(signature(a) for a in family['actions'][cursor:]),
                    cursor=cursor, attempts=family['attempts'])
    require(saved_queues == queues, 'Final queues differ from independent replay')
    for field, filename in [('parent_progress_events','parent-progress.jsonl'),
                             ('directional_events','directions.jsonl'),
                             ('family_funnel_events','diagnostics/family-funnel.jsonl')]:
        journal = iter(rows(s / filename))
        for value in checkpoint_events(s / 'checkpoint.json', field):
            require(next(journal, None) == value, 'Checkpoint journal differs: ' + field)
        if field != 'family_funnel_events':
            require(next(journal, None) is None, 'Checkpoint omits journal suffix: ' + field)
        else:
            # The frozen source appends derived diagnostics to the stored committed
            # history. Authenticate every pending edge against the final checkpoint;
            # summary rows are permitted only after the exact history prefix and
            # contain no committed attempt or budget event.
            header = root_members(s / 'checkpoint.json', {'pending_action_cursor','beam'})
            beam_ids = [p['candidate_id'] for p in header['beam']]
            with (s / 'checkpoint.json').open('rb') as stream:
                pending = (p for n,p in enumerate(ijson.items(stream,'pending_neighbors.item'))
                           if n >= header['pending_action_cursor'])
                pending_count = 0
                suffix_counts = Counter()
                for v in journal:
                    kind = v['record_type']; suffix_counts[kind] += 1
                    require(kind in {'round_family','typed_path_presence','pending_unattempted'},
                            'Unrecorded attempt or unexpected family-funnel tail')
                    if kind == 'pending_unattempted':
                        p = next(pending, None)
                        require(p is not None and v['parent_id'] == beam_ids[p['parent']]
                            and signature(v['action']) == checkpoint_action_signature(p['action'])
                            and v['status'] == 'not_attempted_at_checkpoint',
                            'Pending diagnostic suffix differs from checkpoint')
                        pending_count += 1
                require(next(pending, None) is None, 'Pending diagnostic suffix is incomplete')
    witness_header = root_members(s / 'checkpoint.json', {'witness_dictionary'})
    W.WITNESS_MAPS[str(UNIT)] = {v['id']: v['path'] for v in witness_header['witness_dictionary']}
    for v in witness_header['witness_dictionary']: bind(v['path'])
    directions = {}
    pools = {}
    observations = {}
    feedback = Counter()
    local_zero = Counter()
    occupancy_zero = Counter()
    feedback_paid = Counter()
    compute_evidence = []
    parent_event_set = set()
    prepared_round_set = set()
    tier_guided_paid = []
    catalogue_data = {}
    mode_counts = Counter()
    mode_charges = Counter()
    windows = []
    current = None
    committed = set()
    last_closed = None
    decisions = []
    for event in rows(s / 'directions.jsonl'):
        require(event['policy'] == POLICY, 'Direction event policy differs')
        kind = event['record_type']; round_ = event['round']
        if kind == 'round_allowance':
            require(round_ not in prepared_round_set,'Duplicate prepared-round allowance')
            prepared_round_set.add(round_)
        elif kind == 'frontier_decision':
            live = {p['key'] for p in refresh[round_]['beam']}
            for k in list(feedback):
                if k[0] not in live: del feedback[k]
            for counters in [local_zero,occupancy_zero,feedback_paid]:
                for k in list(counters):
                    if k[0] not in live: del counters[k]
        elif kind == 'retained_communication_shape_pool':
            parent = valid[event['parent_id']]
            key = parent['candidate_key']
            r = refresh[round_]
            old = {valid[i]['candidate_key'] for i in r['old_parents']}
            live = {p['key'] for p in r['beam']}
            require(event['parent_key'] == key and key in old & live and round_ > 0,
                'Shape pool parent is not retained from the previous beam')
            tasks,payloads,makespan = W.observed_tasks({'unit':UNIT}, parent)
            groups = {}
            for sig in round_shape_menus[round_].get(key, []):
                a = W.action_from_signature(sig)
                require(a['family'] == 'shape' and not a['primitives'], 'Shape stream is not pure shape')
                name = a['shapeTask']; t = tasks.get(name)
                if not t or not (t['critical_chain_proxy'] or t['terminal_critical']): continue
                bits = max((float(v) for (source,dest),v in payloads.items() if name in (source,dest)), default=0)
                if bits <= 0 or feedback[key,'shape',name] != 0 or local_zero[key,'shape',name] >= 2: continue
                g = groups.setdefault(name, dict(priority=bits, incident=t['known_incident_payload_bits'], signatures=[]))
                g['signatures'].append(sig)
            expected_pool = []
            if groups:
                name = min(groups, key=lambda n:(-groups[n]['priority'], -groups[n]['incident'], n))
                g = groups[name]
                params = sorted(g['signatures'], key=lambda sig:(W.parameter_penalty(W.action_from_signature(sig),tasks),sig))[:3]
                expected_pool = [dict(category='communication',family='shape',target=name,
                    reason='largest known incident pair payload on critical endpoint; shape layout benefit unproved',
                    priority_proxy=g['priority'], known_incident_payload_bits=str(g['incident']),
                    preferred_attempts=0,action_signatures=params)]
            require(event['typed_graph_known'] is True and event['window_directions'] == expected_pool,
                'Window pool cannot be reconstructed from authenticated graph/schedule, legal shapes and exact feedback')
            require((round_,key) not in pools, 'Shape pool duplicated')
            pools[round_,key] = expected_pool
            observations[round_,key] = tasks
        elif kind == 'parent_directions':
            key = event['parent_key']; parent = valid[event['parent_id']]
            require(key == parent['candidate_key'], 'Ordinary catalog semantic parent differs')
            identity = round_,key,parent['candidate_id']
            require(identity not in parent_event_set,'Duplicate parent direction catalog')
            expected_parents = [dict(id='neighborhood-0',key=valid['neighborhood-0']['candidate_key'])] if round_==0 else refresh[round_]['beam']
            require(any(p['id']==parent['candidate_id'] and p['key']==key for p in expected_parents),'Direction parent is not in actual round beam')
            parent_event_set.add(identity)
            tasks,payloads,makespan = W.observed_tasks({'unit':UNIT}, parent)
            require(event['typed_graph_known'] is True and event['makespan'] == makespan and
                event['task_observations'] == [tasks[n] for n in sorted(tasks)],
                'Parent observations cannot be reconstructed from archived typed graph/schedule')
            # Authenticate graph/schedule before considering any logged tier bit.
            # A successful observed_tasks replay establishes graph-known true.
            pending = round_all_menus[round_]
            cache_path = Path(parent['cost_catalogue_path'])
            bind(cache_path)
            cache = json.loads(cache_path.read_text())
            catalogue_known = isinstance(cache.get('entries'),list)
            gains = W.remaining_shape_opportunities(parent,pending,catalogue_data) if catalogue_known else {}
            require(event['shape_catalogue_known'] is catalogue_known and
                event['shape_compute_opportunities'] == [dict(task=n,remaining_compute_gain_cycles=gains[n])for n in sorted(gains)],
                'Supported positive opportunities differ from existing catalogue and legal pending actions')
            f = {k:[v,feedback_paid[k]]for k,v in feedback.items()}
            f.update({(p,'__communication_zero_streak:'+family,t):[v,0]for (p,family,t),v in local_zero.items()})
            f.update({(p,'__occupancy_zero_streak',t):[v,0]for (p,t),v in occupancy_zero.items()})
            expected_directions, expected_groups = V.derive_directions(parent,pending,tasks,payloads,f,gains,
                graph_known=True,catalogue_known=catalogue_known)
            require(event.get('critical_positive_compute') is True and
                event.get('compute_priority_groups') == expected_groups,
                'Complete compute group tiers differ from graph, catalogue, menu and positive gain reconstruction')
            require(event['directions'] == expected_directions,
                'Category-head target, tier, within-tier priority/tie, parameter order or feedback differs')
            old_directions = W.derive_directions(parent,pending,tasks,payloads,dict(f),gains) if catalogue_known else None
            expected_compute = next((d for d in expected_directions if d['category']=='compute'),None)
            old_compute = next((d for d in old_directions if d['category']=='compute'),None) if old_directions else None
            compute_evidence.append(dict(parent_id=parent['candidate_id'],round=round_,
                critical_positive_available=any(g['critical_positive_compute']for g in expected_groups),
                old_compute_target=old_compute['target'] if old_compute else None,
                selected_compute_target=expected_compute['target'] if expected_compute else None,
                changed_target=bool(old_compute and expected_compute and old_compute['target']!=expected_compute['target']),
                groups=expected_groups))
            directions[round_,key] = event['directions']
        elif kind == 'retained_communication_window_decision':
            r = refresh[round_]
            old = {valid[i]['candidate_key'] for i in r['old_parents']}
            live = {p['key'] for p in r['beam']}
            expected_eligible = []
            for key in old & live:
                for ordinal,d in enumerate(pools.get((round_,key), [])):
                    if d['category'] != 'communication' or not d['action_signatures']: continue
                    require(d['preferred_attempts'] == feedback[key,d['family'],d['target']], 'Pool feedback differs')
                    if d['preferred_attempts'] == 0:
                        expected_eligible.append((key,d['family'],d['target'],tuple(d['action_signatures'])))
            actual_eligible = []
            for e in event['eligible']:
                require(e['parent_key'] in old & live and e['preferred_attempts'] == 0, 'New window parent is not old/live/unserved')
                d = next(d for d in pools[round_,e['parent_key']] if d['family'] == e['family'] and d['target'] == e['target'])
                require(d['category'] == 'communication' and 1 <= len(e['action_signatures']) <= 3
                    and d['action_signatures'] == e['action_signatures'], 'Window parameters differ from existing direction')
                actual_eligible.append((e['parent_key'],e['family'],e['target'],tuple(e['action_signatures'])))
            require(set(actual_eligible) == set(expected_eligible), 'Eligible old communication directions differ')
            if event['eligible']:
                by_id = {p['id']:p for p in r['beam']}
                best = min(event['eligible'], key=lambda e:(-e['priority_proxy'],
                    -int(e['known_incident_payload_bits']),tie(valid[e['parent_id']]),
                    next(n for n,d in enumerate(pools[round_,e['parent_key']]) if d['family']==e['family'] and d['target']==e['target'])))
                require(event['selected_parent_id'] == best['parent_id'], 'Best online direction differs')
            else: require(event['selected_parent_id'] == '', 'Empty eligible set selected a parent')
            require(event['extra_budget'] == 0, 'Decision adds budget')
            decisions.append(dict(round=round_, selected_parent_id=event['selected_parent_id'],
                eligible_count=len(event['eligible']), replaces_structural=event['replaces_refresh_structural_window']))
        elif kind == 'followup_window':
            if event['event'] == 'open':
                require(current is None, 'Window stacked')
                current = dict(round=round_, parent_id=event['parent_id'], parent_key=event['parent_key'],
                    trigger=event['trigger_family'], params=event.get('exact_parameter_signatures',[]),
                    charged=event.get('initial_charged', 0), zero=0, selections=[])
                if 'initial_charged' not in event:
                    require(event['trigger_family'] in {'replica','fission'} or 'fusion' in event['trigger_family'] or 'tiling' in event['trigger_family'],
                        'Only frozen refresh structural opens may omit their zero initial counter')
                if current['params']:
                    require(current['trigger'] == 'retained-communication-direction' and current['charged'] == 0
                        and event['charged_allowance'] == 4 and event['zero_debit_cap'] == 64
                        and event['extra_budget'] == 0, 'New window bounds differ')
                    if last_closed and 'retained communication direction replaces refresh structural window' in last_closed['reason']:
                        require(last_closed['round'] == round_ and last_closed['charged'] == 0,
                            'Replaced structural window had already consumed quota')
                windows.append(current)
            else:
                require(current is not None and current['parent_key'] == event['parent_key'], 'Window close lacks matching open')
                require(current['charged'] == event['charged'] and current['zero'] == event['zero_debit'], 'Window counter differs')
                require(current['charged'] <= 4 and current['zero'] <= 64, 'Window cap exceeded')
                current['close_reason'] = event['reason']; last_closed = dict(round=round_, charged=current['charged'], reason=event['reason'])
                current = None
        elif kind == 'candidate_selection':
            index = event['attempt_global_index']; a = attempts[index]
            require(a['candidate_id'] == event['candidate_id'] and a['parent_key'] == event['parent_key']
                and a['signature'] == event['action_signature'] and a['debit'] == event['debit']
                and a['before'] == event['objective_evaluations_before'] and a['after'] == event['objective_evaluations_after'],
                'Direction/funnel commit differs')
            require(event['round']==a['round'] and event['parent_id']==a['parent_id'] and
                event['family']==a['family'] and event['target']==a['target'] and
                signature(event['action'])==a['signature'], 'Selection typed identity labels differ from committed attempt')
            mode_counts[event['mode']] += 1; mode_charges[event['mode']] += event['debit']
            if event['mode']=='guided':
                matched = [d for d in directions.get((round_,event['parent_key']),[])
                    if d['family']==event['family'] and d['target']==event['target']]
                require(len(matched)==1 and event['action_signature'] in matched[0]['action_signatures'],
                    'Guided action is not one of the reconstructed direction parameters')
            if event['mode'] in {'guided','window'}:
                k = event['parent_key'],event['family'],event['target']
                feedback[k] += 1; feedback_paid[k] += event['debit']
            if event['debit'] and event['mode']=='guided' and event['family']=='shape':
                d = next((d for d in directions.get((round_,event['parent_key']),[])if d['category']=='compute' and d['target']==event['target']),None)
                e = next((v for v in reversed(compute_evidence)if v['parent_id']==event['parent_id'] and v['round']==round_),None)
                if d and e and any(g['target']==d['target'] and g['critical_positive_compute']for g in e['groups']):
                    tier_guided_paid.append(dict(parent_id=event['parent_id'],candidate_id=event['candidate_id'],round=round_,target=event['target'],signature=event['action_signature'],before=a['before'],after=a['after']))
            if event['mode'] == 'window':
                require(current is not None and current['parent_key'] == event['parent_key'], 'Window selection uses other parent')
                if current['params']:
                    require(a['family'] == 'shape', 'Retained shape window selected a different family')
                    remaining = [p for p in current['params'] if edge(current['parent_key'],p) not in committed]
                    require(remaining and remaining[0] == event['action_signature'], 'Exact parameters not attempted in original order')
                current['charged'] += event['debit']; current['zero'] += int(event['debit'] == 0)
                current['selections'].append(dict(a, attempt_global_index=index))
                require(current['charged'] <= 4 and current['zero'] <= 64, 'Window cap exceeded at commit')
            if event['family'] in {'shape','fusion','fusion-plus-shape','producer-consumer-co-tiling'}:
                k = event['parent_key'],event['family'],event['target']
                local_zero[k] = 0 if event['debit'] else local_zero[k]+1
            if event['family'] in {'replica','tiling','k-tiling','fission'}:
                k = event['parent_key'],event['target']
                occupancy_zero[k] = 0 if event['debit'] else occupancy_zero[k]+1
            committed.add(edge(event['parent_key'],event['action_signature']))
    require(len(committed) == count and committed == seen, 'Directions omit/repeat attempts')
    expected_parent_events = {(r,p['key'],p['id']) for r in prepared_round_set for p in
        ([dict(id='neighborhood-0',key=valid['neighborhood-0']['candidate_key'])] if r==0 else refresh[r]['beam'])}
    require(parent_event_set == expected_parent_events,'Prepared rounds do not contain exactly one direction catalog for every actual beam parent')
    new_windows = [w for w in windows if w['trigger'] == 'retained-communication-direction']
    retained_shape_charges = sum(w['charged'] for w in new_windows)
    first_miss = next((v for v in missing if (v['rows'],v['cols']) == (2,1)), None)
    if first_miss:
        child = valid.get(first_miss['candidate_id'])
        first_miss['predicted_cycles'] = child['predicted_whole_program_cycles'] if child else None
        first_miss['beam_membership'] = [dict(round=r, rank=next(n for n,p in enumerate(v['beam']) if p['id']==first_miss['candidate_id']))
            for r,v in refresh.items() if any(p['id']==first_miss['candidate_id'] for p in v['beam'])]
    def in_domain(action):
        if FEATURE=='all':return True
        return action['family']!='fission' and all(p['kind'] in {'lineage-replacement','lineage-reset','replica'}for p in action.get('primitives',[]))
    for record in rows(funnel_path):
        if record.get('record_type')=='candidate_attempt':
            require(in_domain(record['action']), 'Committed action leaves cumulative-replica domain')
    for record in valid.values():
        history=record['action_history']
        require(FEATURE=='all' or (not history['fissionActions'] and all(in_domain(a)for a in history['actions'])),
            'Persisted history leaves cumulative-replica domain')
    for (parent,family),q in queues.items():
        for sig in q['remaining']:
            require(in_domain(W.action_from_signature(sig)), 'Final pending menu leaves cumulative-replica domain')
    inputs.update(catalogue_data.get('opportunity_catalogues',{}))
    report = dict(schema='orbit-v38-gcn-paired256-critical-positive-compute-search-audit-v1', status='pass',
        source_commit=binding['source_commit'], optimizer_sha256=driver['optimizer_sha256'],
        actual_policy=POLICY, policy=POLICY, workload='gcn', stage=STAGE, feature_policy=FEATURE, auditor_sha256=sha(__file__), objective_calls=256, native_calls=0, numeric_calls=0,
        exact_semantic_attempts=count, zero_debit_attempts=count-(256-initial_position),
        global_exact_edge_duplicates=0, independent_progress_replay='pass',
        checkpoint_edge_and_queue_replay='pass', checkpoint_sidecar_journals='pass; funnel committed prefix plus exact pending suffix',
        family_funnel_derived_suffix_counts=dict(suffix_counts),
        retained_window_decisions=decisions, retained_communication_windows=new_windows,
        retained_communication_shape_charges=retained_shape_charges,
        independent_shape_pool_graph_schedule_menu_reconstruction='pass',
        shape_pools_reconstructed=len(pools),
        canonical_task7_shape_attempts=missing, canonical_task7_first_2x1=first_miss,
        attempts_by_mode=dict(mode_counts), charges_by_mode=dict(mode_charges),
        parent_family_allocation={p:dict(c) for p,c in allocations.items()},
        shortlist_predicted_minimum=min(v['predicted_whole_program_cycles'] for v in valid.values()),
        runtime_seconds=time.monotonic()-started, paper_admission=False, formal_admission=False,
        mechanism_positive=bool(tier_guided_paid),
        critical_positive_compute=True, independent_all_compute_groups='pass',
        prepared_round_count=len(prepared_round_set), all_parent_direction_coverage='exact round beam set, no duplicates',
        reconstructed_parent_direction_count=len(compute_evidence),
        changed_compute_target_count=sum(e['changed_target']for e in compute_evidence),
        compute_tier_evidence=compute_evidence, first_tier_guided_paid=tier_guided_paid,
        validator_recovery=False,
        preregistration_sha256=sha(FINAL_ROUND),
        limitation='This is independent canonical Source38 budget256 search; paired Full/Replica differs only in cumulative feature-policy and output. Native/numeric outcomes require separate original exact5 sealing. Source37 is a different-policy reference. Actual typed graph observations must reconstruct successfully; unknown graph receipts fail closed. Valid catalogues with no entries array use the unchanged old compute fallback, and every read catalogue is hash-bound.',
        input_sha256=inputs)
    check(inputs)
    write(OUT / 'REPORT.json', report)
    write(UNIT/'search-audit.json',report)
    positive = report['mechanism_positive']
    text = f"GCN {STAGE}256 completes256 charged calls; no native or numeric calls. All compute tiers and category heads independently replay; {len(tier_guided_paid)} paid guided shapes use a critical-positive compute target. The preregistered mechanism gate {'passes' if positive else 'fails'}. The canonical Task7→2x1 reference is observed separately, never forced.\n\n"
    text += f"There are {len(new_windows)} retained communication windows and {count} unique semantic parent/action attempts. Every committed edge, queue cursor, budget debit, and stored journal agrees with the independent replay. The derived family-funnel tail contains only expected summary/pending records; its pending edges match the final checkpoint exactly. All windows keep the original four-charge/64-zero-debit caps.\n\n"
    if first_miss: text += f"The first 2x1 entry is {first_miss['candidate_id']}, attempt {first_miss['attempt_global_index']}, round {first_miss['round']}, debit {first_miss['before']}→{first_miss['after']}, predicted cycles {first_miss['predicted_cycles']}.\n\n"
    text += report['limitation']+'\n'
    (OUT / 'REPORT.md').write_text(text)
    write(OUT / 'FINAL.json', dict(status='pass', input_pre_post_verified=True,
        report_sha256=sha(OUT / 'REPORT.json'), markdown_sha256=sha(OUT / 'REPORT.md'),
        source_commit=binding['source_commit'], mechanism_positive=positive,
        extra_objective_calls=0, native_calls=0, numeric_calls=0))
    print(json.dumps(dict(status='pass', mechanism_positive=positive, output=str(OUT),
        first_miss=first_miss, exact_semantic_attempts=count)), flush=True)


if __name__ == '__main__':
    import argparse
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--search-root',type=Path,required=True)
    parser.add_argument('--workload',choices=['gcn'],required=True)
    parser.add_argument('--budget',type=int,choices=[256],required=True)
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args()
    UNIT=args.search_root.resolve();STAGE=UNIT.name
    require(STAGE in {'fission','replica'}, 'Unknown cumulative domain')
    FEATURE={'fission':'all','replica':'cumulative-replica'}[STAGE]
    COHORT=B/f"critical-positive-compute-v38-{'full' if STAGE=='fission' else 'replica'}256-continuation1"
    require(UNIT==COHORT/'runs/b256/gcn'/STAGE and args.output.resolve()==UNIT/'search-audit.json', 'Prepared namespace differs')
    OUT=UNIT/'mechanism-audit';FINAL_ROUND=COHORT/'prepared-v2/PREREGISTRATION.json'
    main()
