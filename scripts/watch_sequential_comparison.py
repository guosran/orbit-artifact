#!/usr/bin/env python3
"""Release completed provisional CPU lanes and losslessly compact completed cells."""
from __future__ import annotations
import argparse
import json
from pathlib import Path
import time

import compact_sequential_raw as auxiliary
import neighborhood_replay as replay
import run_sequential_comparison as comparison
import summarize_sequential_comparison as summary


def provisional_cost(cell):
    result = comparison.read(cell / 'result.json')
    search = comparison.read(cell / 'search/search-summary.json')
    records = result['native_top5']['records'] + result['native_controls']['records']
    return {
        'policy': 'excluded from primary; earlier Joint4 controller failed total-depth audit',
        'execution': comparison.read(cell / 'execution.json'),
        'objective_evaluations': search['production_scheduler_calls'],
        'search_wall_seconds': result['search']['ended_unix'] - result['search']['started_unix'],
        'predictor': summary.prediction_accounting(cell),
        'validation_actual_mapper_calls': sum(r['actual_mapper_calls'] for r in records),
        'native_program_evaluations': len(records),
        'best_native_cycles': min(r['native_cycles'] for r in records),
        'search_stats': search,
    }


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--provisional-root', type=Path)
    p.add_argument('--release-dir', type=Path)
    p.add_argument('--results-root', type=Path, required=True)
    p.add_argument('--once', action='store_true')
    args = p.parse_args()
    if bool(args.provisional_root) != bool(args.release_dir):
        p.error('provisional root and release directory must be provided together')
    while True:
        if args.provisional_root:
            for index, workload in enumerate(('gcn', 'harris', 'llama')):
                cell = args.provisional_root / workload / 'joint'
                release = args.release_dir / f'lane-{index}.json'
                if release.exists() or not (cell / 'execution.json').exists():
                    continue
                if not comparison.complete(cell):
                    raise ValueError(f'provisional cell failed its existing native gates: {cell}')
                costs = provisional_cost(cell)
                replay.atomic_write(cell / 'provisional-costs.json', costs)
                auxiliary.compact(cell)
                replay.atomic_write(release, {
                    'exit_code': costs['execution']['exit_code'],
                    'prior_cell': str(cell.resolve()),
                    'cost_accounting': str((cell / 'provisional-costs.json').resolve()),
                    'policy': 'execution recorded only after prior cell process exits; auxiliary compaction completed before lane reuse',
                })
                print(json.dumps({'released_lane': index, 'prior_workload': workload}), flush=True)
        for cell in sorted(args.results_root.glob('*/*')):
            if not cell.is_dir() or not (cell / 'execution.json').exists():
                continue
            manifest = auxiliary.compact(cell)
            if manifest:
                print(json.dumps({'compacted_cell': str(cell), 'original_bytes': manifest['original_bytes'],
                                  'archive_bytes': manifest['archive_bytes']}), flush=True)
        if args.once or (args.results_root / 'batch.json').exists() and comparison.read(args.results_root / 'batch.json').get('status') == 'complete':
            break
        time.sleep(10)


if __name__ == '__main__':
    main()
