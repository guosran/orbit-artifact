#!/usr/bin/env python3
"""Report every preliminary validation and superseded run separately from primary results."""
import argparse
import json
from pathlib import Path
import summarize_sequential_comparison as summary
import run_sequential_comparison as comparison

DEFAULT_ROOTS = (
    '.work/sequential-pilot-32', '.work/sequential-serial-pilot-32',
    '.work/sequential-pilot-32-depth8', '.work/sequential-pilot-32-depth8-v3',
    '.work/sequential-pilot-32-final',
    '.work/sequential-fast-pilot-32', '.work/sequential-fast-canary-gcn-4096',
    '.work/sequential-fast2-pilot-32',
    '.work/sequential-speed-reference-gcn-32', '.work/sequential-speed-fast2-gcn-32',
    'results/sequential-comparison-4096', 'results/sequential-comparison-4096-depth8',
    'results/sequential-comparison-4096-final',
    'results/sequential-comparison-4096-fast2',
)


def collect(root):
    rows = []
    for relative in DEFAULT_ROOTS:
        for path in sorted((root / relative).glob('*/*/execution.json')):
            cell = path.parent
            execution = comparison.read(path)
            stats_path = cell / 'search/search-summary.json'
            interruption_path = cell / 'interruption-audit.json'
            row = {'cell': str(cell.relative_to(root)), 'primary_result': False,
                   'elapsed_seconds_including_validation': execution['elapsed_seconds'],
                   'elapsed_seconds_are_exact': execution.get('elapsed_seconds_are_exact', True),
                   'exit_code': execution['exit_code'], 'execution': str(path.relative_to(root))}
            if interruption_path.is_file():
                audit = comparison.read(interruption_path)
                row.update(status='interrupted-provisional',
                           objective_evaluations_lower_bound=audit['actual_objective_evaluations_lower_bound'],
                           objective_evaluations_upper_bound=audit['actual_objective_evaluations_upper_bound'],
                           validation_mapper_calls=audit['validation_mapper_calls'], native_program_evaluations=0,
                           interruption_audit=str(interruption_path.relative_to(root)),
                           uncommitted_costs='exact totals unavailable; retained checkpoint bounds and completed stderr audits; partial predictor work may be missing')
            elif stats_path.is_file():
                stats = comparison.read(stats_path)
                result = comparison.read(cell / 'result.json')
                native = result['native_top5']['records'] + result['native_controls']['records']
                row.update(status='completed-validation', objective_evaluations=stats['production_scheduler_calls'],
                           candidate_attempts=stats.get('candidate_attempts'),
                           search_seconds=result['search']['ended_unix']-result['search']['started_unix'],
                           validation_mapper_calls=sum(r['actual_mapper_calls'] for r in native),
                           native_program_evaluations=len(native), statistics=str(stats_path.relative_to(root)))
            else:
                raise ValueError(f'preliminary execution lacks stats or interruption evidence: {cell}')
            predictor = summary.prediction_accounting(cell)
            row['completed_predictor_invocation_counts'] = {k: predictor[k] for k in (
                'predictor_invocations','feature_queries','prediction_requests','model_inferences',
                'predictor_cache_queries','predictor_cache_hits','predictor_wall_seconds')}
            row['predictor_counts_are_exact'] = row['status'] == 'completed-validation'
            rows.append(row)
    completed = [r for r in rows if r['status'] == 'completed-validation']
    interrupted = [r for r in rows if r['status'] == 'interrupted-provisional']
    totals = {'cells': len(rows), 'completed_cells':len(completed), 'interrupted_cells':len(interrupted),
        'elapsed_cell_seconds_sum':sum(r['elapsed_seconds_including_validation'] for r in rows),
        'elapsed_cell_seconds_sum_contains_lower_bounds':any(not r['elapsed_seconds_are_exact'] for r in rows),
        'objective_evaluations_lower_bound':sum(r['objective_evaluations'] for r in completed)+sum(r['objective_evaluations_lower_bound'] for r in interrupted),
        'objective_evaluations_upper_bound':sum(r['objective_evaluations'] for r in completed)+sum(r['objective_evaluations_upper_bound'] for r in interrupted),
        'validation_mapper_calls':sum(r['validation_mapper_calls'] for r in rows),
        'native_program_evaluations':sum(r['native_program_evaluations'] for r in rows),
        'model_inferences_completed_audit_lower_bound':sum(r['completed_predictor_invocation_counts']['model_inferences'] for r in rows)}
    ray = []
    for directory in sorted((root / '.work').glob('sequential-ray-preflight*')):
        for log in directory.rglob('*.stderr.log'):
            audits = [json.loads(line.split('[ORBIT-PREDICTOR-AUDIT] ',1)[1]) for line in log.read_text().splitlines()
                      if line.startswith('[ORBIT-PREDICTOR-AUDIT] ')]
            ray.append({'log':str(log.relative_to(root)), 'objective_evaluations':0, 'mapper_calls':0,
                        'completed_predictor_audits':audits, 'domain_gate':'original Ray unsupported; excluded from supported-workload primary table'})
    initialization_failures = [{**comparison.read(path), 'audit': str(path.relative_to(root))}
        for relative in DEFAULT_ROOTS for path in (root / relative).glob('*/*/initialization-failure-audit.json')]
    return {'schema':'orbit-sequential-extra-costs-v1', 'policy':'all preliminary32 validation, runtime diagnostics and superseded4096 runs excluded from primary and sensitivity results; no ratio selection from these runs',
            'initialization_failures': initialization_failures,
            'cells':rows, 'totals':totals, 'ray_preflights':ray,
            'shared_existing_preparation':'prepared v38 canonical sources/model/cache reused; no new training/calibration; each method receives identical seed bytes and records its frontend and resource feasibility reads',
            'cost_scope':'sum of cell elapsed times, not elapsed batch time; parallel cells overlap; interrupted predictor counts are explicitly lower bounds; ENOSPC reconstruction uses command-start to last retained stderr timestamp and marks elapsed totals as nonexact'}


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--artifact-root',type=Path,default=Path(__file__).resolve().parents[1])
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args();value=collect(args.artifact_root)
    comparison.replay.atomic_write(args.output,value)
    print(json.dumps(value['totals'],indent=2))

if __name__=='__main__':main()
