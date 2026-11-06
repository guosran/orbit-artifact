#!/usr/bin/env python3
"""Exact valid-archive bridge across a validation-only compiler guard."""
import argparse
import hashlib
import json
from pathlib import Path

p = argparse.ArgumentParser()
p.add_argument('--reference', type=Path, required=True)
p.add_argument('--current', type=Path, required=True)
p.add_argument('--output', type=Path, required=True)
a = p.parse_args()
a.output.mkdir(parents=True, exist_ok=False)

def read(path):
    return json.loads(path.read_text())

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

old_report = read(a.reference / 'search.json')
new_report = read(a.current / 'search.json')
old_rows = {x['search_key']: x for x in old_report['archive']}
new_rows = {x['search_key']: x for x in new_report['archive']}
assert old_rows.keys() == new_rows.keys(), 'validation-only guard changed archive'
rows = []
for key, old in old_rows.items():
    new = new_rows[key]
    old_dir, new_dir = a.reference / 'candidates' / key, a.current / 'candidates' / key
    row = {'candidate_id': key,
           'same_status': old['status'] == new['status'],
           'same_parent_and_actions': old['parent'] == new['parent'] and old['action_chain'] == new['action_chain'],
           'same_score': old.get('score') == new.get('score'),
           'same_source': (old_dir / 'taskflow.mlir').read_bytes() == (new_dir / 'taskflow.mlir').read_bytes()}
    for filename, label in [('program-graph.json', 'full_graph_equal'),
                             ('mapping-result.json', 'full_mapping_equal')]:
        left, right = old_dir / filename, new_dir / filename
        assert left.exists() == right.exists()
        if left.exists():
            x, y = read(left), read(right)
            if filename == 'mapping-result.json':
                x, y = x['best_plan'], y['best_plan']
            row[label] = x == y
    assert all(value for name, value in row.items() if name != 'candidate_id'), row
    rows.append(row)
assert old_report['ranking'] == new_report['ranking']
assert old_report['selections'] == new_report['selections']
(a.output / 'receipt.json').write_text(json.dumps({'status': 'PASS',
    'scope': 'Exact full source, public graph, priced native plan, score, action-chain and score-driven selection bridge across validation-only scope guard; no normalization or hardware submissions.',
    'reference': str(a.reference.resolve()), 'current': str(a.current.resolve()),
    'reference_archive_sha256': sha(a.reference / 'search.json'),
    'current_archive_sha256': sha(a.current / 'search.json'),
    'same_ranking_and_selections': True, 'device_submissions': 0, 'candidates': rows}, indent=2) + '\n')
print(len(rows), 'exact graphs/plans/sources/scores and selections')
