#!/usr/bin/env python3
"""Re-export frozen sources and enumerate the v19 identity-policy revision.

No compiled manifest, source, protocol or measurement is modified. Exact graph
activities must agree after removing only the newly explicit lifecycle label;
selected-plan differences must be confined to enumerated identity/diagnostics.
"""
import argparse
import copy
import hashlib
import json
from pathlib import Path
import subprocess


def read(path):
    return json.loads(Path(path).read_text())


def write(path, value):
    path.write_text(json.dumps(value, indent=2, allow_nan=False) + '\n')


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def differences(a, b, path=''):
    if isinstance(a, dict) and isinstance(b, dict):
        result = []
        for key in sorted(set(a) | set(b)):
            p = path + '/' + key
            if key not in a or key not in b:
                result.append({'path': p, 'old_present': key in a, 'new_present': key in b,
                               'old': a.get(key), 'new': b.get(key)})
            else:
                result.extend(differences(a[key], b[key], p))
        return result
    if isinstance(a, list) and isinstance(b, list) and len(a) == len(b):
        return [item for i, (x, y) in enumerate(zip(a, b))
                for item in differences(x, y, path + '/' + str(i))]
    return [] if a == b else [{'path': path, 'old': a, 'new': b}]


def communication_without_explicit_policy(communication):
    result = copy.deepcopy(communication)
    result.pop('semantic_digest', None)
    for region in result['execution_regions']:
        policy = region.pop('invocation_lifecycle', None)
        assert policy in (None, 'host-device')
    return result


def graph_without_explicit_policy(graph):
    result = copy.deepcopy(graph)
    result.pop('id', None)
    for region in result['execution_regions']:
        policy = region.pop('invocation_lifecycle', None)
        assert policy in (None, 'host-device')
    if 'ledger' in result:
        result['ledger'] = communication_without_explicit_policy(result['ledger'])
    return result


def selected_without_revision_metadata(plan):
    result = copy.deepcopy(plan)
    result.pop('discovered_mapping_opportunities', None)
    policy = result.pop('plan_identity_policy', None)
    assert policy in (None, 'orbit.chosen-plan.v19.excludes-proposal-diagnostics')
    for field in ('plan_id', 'program_graph_id'):
        result.pop(field, None)
    result['program_graph'] = graph_without_explicit_policy(result['program_graph'])
    binding = result['target_memory']['binding']
    resource = next(r for r in result['target_memory']['architecture']['resources']
                    if r['id'] == binding['compute_resource'])
    for task in result['tasks']:
        assert task['device'] == resource['device']
        if 'resource' in task:
            assert task.pop('resource') == resource['id']
        if 'spatial_owner' in task:
            assert task.pop('spatial_owner') == resource['domain']
        for old in ('herd', 'core'):
            if old in task:
                assert task.pop(old) == 0
    result['program_communication'] = communication_without_explicit_policy(result['program_communication'])
    cost = result['direct_air_cost']
    cost.pop('feature_digest', None)
    cost['features'].pop('execution_fingerprint', None)
    cost['event_timing']['timing'].pop('program_graph_id', None)
    return result


p = argparse.ArgumentParser(description=__doc__)
p.add_argument('--tool', type=Path, required=True)
p.add_argument('--indices', type=Path, nargs='+', required=True)
p.add_argument('--output', type=Path, required=True)
a = p.parse_args()
a.output.mkdir(parents=True, exist_ok=False)
before = sha(a.tool)
write(a.output / 'inputs.json', {'tool': str(a.tool.resolve()), 'tool_sha256': before,
    'indices': [{'path': str(i.resolve()), 'sha256': sha(i)} for i in a.indices]})
rows = []
for index in a.indices:
    for entry in read(index)['entries']:
        out = a.output / entry['name']
        out.mkdir()
        source = Path(entry['source'])
        assert sha(source) == entry['source_sha256']
        command = [str(a.tool.resolve()), str(source.resolve()), '--generic-map',
            '--target-config=' + entry['config'],
            '--mapping-output=' + str((out / 'plan.json').resolve()),
            '--program-timing-output=' + str((out / 'timing.json').resolve())]
        write(out / 'command.json', command)
        with (out / 'output.log').open('w') as log:
            status = subprocess.run(command, stdout=log, stderr=subprocess.STDOUT).returncode
        assert status == 0, entry['name']
        old = read(entry['mapping_result'])['best_plan']
        new = read(out / 'plan.json')
        diff = differences(old, new)
        write(out / 'all-differences.json', diff)
        old_graph, new_graph = old['program_graph'], new['program_graph']
        assert old_graph['region_events'] == new_graph['region_events'], 'lifecycle events changed'
        graph_equal = graph_without_explicit_policy(old_graph) == graph_without_explicit_policy(new_graph)
        normalized_old = selected_without_revision_metadata(old)
        normalized_new = selected_without_revision_metadata(new)
        unexpected = differences(normalized_old, normalized_new)
        write(out / 'unexpected-physical-differences.json', unexpected)
        record = {'name': entry['name'], 'source_sha256': entry['source_sha256'],
            'old_graph_id': old['program_graph_id'], 'new_graph_id': new['program_graph_id'],
            'old_plan_id': old['plan_id'], 'new_plan_id': new['plan_id'],
            'literal_ids_equal': old['plan_id'] == new['plan_id'],
            'exact_graph_except_new_explicit_lifecycle_policy': graph_equal,
            'all_selected_facts_equal_except_enumerated_metadata': not unexpected,
            'identical_predicted_ms': old['estimated_ms'] == new['estimated_ms'],
            'differences_enumerated': len(diff), 'device_submissions': 0}
        write(out / 'receipt.json', record)
        assert graph_equal and not unexpected and record['identical_predicted_ms'], entry['name']
        rows.append(record)
assert before == sha(a.tool)
assert all(sha(i) == row['sha256'] for i, row in zip(a.indices, read(a.output / 'inputs.json')['indices']))
write(a.output / 'summary.json', {'status': 'PASS', 'device_submissions': 0, 'cases': rows,
    'scope': 'Current compiler re-export of frozen old sources, explicit identity-policy/lifecycle revision; literal old IDs preserved and not claimed equal.'})
print(len(rows), 'frozen sources retain selected physical facts and predictions')
