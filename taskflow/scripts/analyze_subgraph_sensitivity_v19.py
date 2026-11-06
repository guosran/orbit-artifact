#!/usr/bin/env python3
"""Reprice immutable original-driver graphs with C++; no Python planner or fit."""
import argparse
import csv
import hashlib
import json
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import subprocess


def read(path):
    return json.loads(Path(path).read_text())


def write(path, value):
    path.write_text(json.dumps(value, indent=2, allow_nan=False) + '\n')


def identity(path):
    path = Path(path)
    return {'path': str(path.resolve()), 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()}


p = argparse.ArgumentParser(description=__doc__)
for key in ('search-root', 'config', 'tool', 'output'):
    p.add_argument('--' + key, type=Path, required=True)
p.add_argument('--jobs', type=int, default=2)
p.add_argument('--beam-width', type=int, default=2)
a = p.parse_args()
assert 1 <= a.jobs <= 8
a.output.mkdir(parents=True, exist_ok=False)
tool = identity(a.tool)
report = read(a.search_root / 'search.json')
rows = []
for row in report['archive']:
    key = row['search_key']
    directory = a.search_root / 'candidates' / key
    if row['status'] in ('passed', 'uncalibrated') and (directory / 'program-graph.json').exists():
        rows.append((row, directory / 'taskflow.mlir', read(directory / 'program-graph.json')))
assert rows
base = read(a.config)
variations = [('reference', {})]
for factor in (.5, 2.):
    variations.append(('communication-bandwidth-x' + str(factor),
                       {'communication.bandwidth': base['generic_air']['cost_model']['parameters']['communication.bandwidth']['value'] * factor}))
for value in (10000., 80000.):
    variations.append(('configuration-startup-' + str(int(value)), {'configuration.startup': value}))
for factor in (.5, 2.):
    variations.append(('compute-operation-and-memory-x' + str(factor),
                       {key: base['generic_air']['cost_model']['parameters'][key]['value'] * factor
                        for key in ('compute.operation', 'compute.memory_access')}))
summary, table = [], []
for name, changes in variations:
    out = a.output / name
    out.mkdir()
    config = read(a.config)
    for key, value in changes.items():
        config['generic_air']['cost_model']['parameters'][key]['value'] = value
    write(out / 'config.json', config)

    def evaluate(entry):
        row, source, expected = entry
        dest = out / row['search_key']
        dest.mkdir()
        command = [str(a.tool.resolve()), str(source.resolve()), '--generic-map',
                   '--target-config=' + str((out / 'config.json').resolve()),
                   '--mapping-output=' + str((dest / 'plan.json').resolve()),
                   '--program-timing-output=' + str((dest / 'timing.json').resolve())]
        write(dest / 'command.json', command)
        with (dest / 'output.log').open('w') as log:
            result = subprocess.run(command, stdout=log, stderr=subprocess.STDOUT)
        assert result.returncode == 0, (name, row['search_key'])
        plan = read(dest / 'plan.json')
        assert plan['program_graph'] == expected, 'price perturbation changed graph'
        return {'candidate_id': row['search_key'], 'round': row['round'],
                'action_chain': row['action_chain'], 'score_ms': plan['estimated_ms'],
                'model_status': plan['direct_air_cost']['status'],
                'graph_id': plan['program_graph_id'], 'plan': identity(dest / 'plan.json'),
                'timing': identity(dest / 'timing.json')}

    with ThreadPoolExecutor(max_workers=a.jobs) as pool:
        evaluated = list(pool.map(evaluate, rows))
    ranked = sorted((x for x in evaluated if x['score_ms'] is not None),
                    key=lambda x: (x['score_ms'], x['candidate_id']))
    unknown = [x for x in evaluated if x['score_ms'] is None]
    first = sorted((x for x in ranked if x['round'] == 1),
                   key=lambda x: (x['score_ms'], x['candidate_id']))
    best = ranked[0]['score_ms'] if ranked else None
    record = {'variation': name, 'parameter_values_changed': changes, 'ranking': ranked,
              'unknown': unknown, 'best_score_ms': best,
              'tied_best_candidates': [x['candidate_id'] for x in ranked if abs(x['score_ms'] - best) <= 1e-12],
              'round_one_selected_parents': [x['candidate_id'] for x in first[:a.beam_width]]}
    write(out / 'ranking.json', record)
    summary.append(record)
    for x in evaluated:
        table.append({'variation': name, 'candidate_id': x['candidate_id'],
                      'round': x['round'], 'score_ms': x['score_ms'], 'model_status': x['model_status'],
                      'actions': ' -> '.join(x['action_chain'])})
    print(name, 'priced', len(ranked), 'unknown', len(unknown), 'best', best, flush=True)
assert identity(a.tool) == tool
reference_winners = set(summary[0]['tied_best_candidates'])
reference_parents = set(summary[0]['round_one_selected_parents'])
write(a.output / 'summary.json', {'schema': 'orbit.subgraph-sensitivity.v19', 'status': 'PASS',
    'tool': tool, 'archive': identity(a.search_root / 'search.json'), 'config': identity(a.config),
    'checked_candidates': len(rows), 'device_submissions': 0, 'variations': summary,
    'reference_winner_survives_all': all(reference_winners.intersection(x['tied_best_candidates']) for x in summary),
    'reference_parent_set_unchanged_all': all(reference_parents == set(x['round_one_selected_parents']) for x in summary),
    'scope': 'Same immutable legal graphs re-evaluated by the public C++ model under declared parameter perturbations; no calibration, new candidates or hardware observations.'})
with (a.output / 'scores.csv').open('w') as f:
    writer = csv.DictWriter(f, fieldnames=list(table[0]))
    writer.writeheader()
    writer.writerows(table)
