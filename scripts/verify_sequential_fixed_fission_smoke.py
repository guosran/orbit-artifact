#!/usr/bin/env python3
"""Run fresh bounded native checks before accepting a matched fission runtime."""
import argparse
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
import time

import run_sequential_comparison as comparison
import summarize_sequential_comparison as summary
from sequential_validation_audit import require_complete_validation


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--runtime-root', type=Path, required=True)
    parser.add_argument('--output-root', type=Path, required=True)
    parser.add_argument('--transfer-output-root', type=Path, required=True)
    parser.add_argument('--llvm-build', type=Path, required=True)
    args = parser.parse_args()
    runtime = args.runtime_root.resolve()
    acceptance_path = runtime / 'smoke-acceptance.json'
    if acceptance_path.exists() or args.output_root.exists() or args.transfer_output_root.exists():
        raise ValueError('fresh diagnostic and acceptance paths required')
    checker_path = runtime / 'reference/sequential-comparison/check-sequential-search-contract.py'
    spec = importlib.util.spec_from_file_location('smoke_search_checker', checker_path)
    checker = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(checker)
    optimizer = comparison.file_binding(runtime / 'bin/mlir-amoeba-opt')
    common = [sys.executable, '-u', str(runtime / 'scripts/run_sequential_comparison.py'),
        '--config', str(runtime / 'inputs-preparation/input0-chain.json'),
        '--optimizer', optimizer['path'], '--source-contract-file', str(runtime / 'source-model-contract.json'),
        '--model', str(runtime / 'reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json'),
        '--architecture', str(runtime / 'config/architectures/amoeba_4x4_cgra_2x2_context6.yaml'),
        '--inter-task-network', str(runtime / 'config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml'),
        '--sram-config', str(runtime / 'config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json'),
        '--protocol-template', str(runtime / 'reference/sequential-comparison/protocol-fixed-fission-template.json'),
        '--budget', '32', '--max-rounds', '64', '--round-score-quota', '4',
        '--workers', '1', '--cpus-per-worker', '4', '--search-stage', 'full-joint-fission', '--compact-completed']
    env = dict(os.environ, ORBIT_LLVM_BUILD=str(args.llvm_build.resolve()))
    started = time.monotonic()
    records, launches = [], []
    for root, workloads, methods, transfer in (
        (args.output_root.resolve(), ['lu', 'harris'], ['joint', 'sequential-50'], False),
        (args.transfer_output_root.resolve(), ['lu'], ['sequential-50'], True)):
        root.mkdir(parents=True)
        argv = [*common, '--output-root', str(root), '--workloads', *workloads, '--methods', *methods]
        if transfer:
            argv += ['--sequential-budget-policy', 'transfer-unused']
        launch = {'argv': argv, 'cwd': str(runtime), 'environment': {'ORBIT_LLVM_BUILD': env['ORBIT_LLVM_BUILD']}}
        comparison.write_exact(root / 'smoke-launch.json', launch)
        launches.append(str(root / 'smoke-launch.json'))
        with (root / 'smoke-coordinator.log').open('w') as log:
            code = subprocess.call(argv, cwd=runtime, env=env, stdout=log, stderr=subprocess.STDOUT)
        if code:
            raise RuntimeError(f'native smoke failed, exit {code}: {root}/smoke-coordinator.log')
        for workload in workloads:
            for original_method in methods:
                method = 'sequential-50-transfer' if transfer else original_method
                cell = root / workload / method
                require_complete_validation(comparison.read(cell / 'result.json'))
                row = summary.cell_summary(cell, workload, method)
                search = row['search_stats']
                if (search.get('runtime_replay_cache_enabled') is not False or
                        search.get('typed_action_replay_cache_hits') != 0 or
                        search.get('typed_action_replay_skipped_steps') != 0):
                    raise ValueError('comparison must use authenticated complete replay without prefix memo reuse')
                if method != 'joint':
                    checker.check_sequential(cell / 'search')
                records.append({'workload': workload, 'method': method, 'cell': str(cell),
                    'objective_calls': row['objective_evaluations'], 'phase_calls': search['phase_evaluations'],
                    'native_program_evaluations': row['validation']['native_program_evaluations'],
                    'actual_mapper_calls': row['validation']['actual_task_mapper_calls'],
                    'final_native_cycles': row['final_native_cycles'],
                    'search_wall_seconds': row['search_wall_seconds'],
                    'candidate_attempts': row['candidate_attempts'],
                    'legal_candidates': row['legal_candidates'],
                    'frozen_fission_actions': search.get('frozen_fission_actions'),
                    'numeric_trace_mapper_gates': 'all seven passed',
                    'formal_result_reuse': False})
    if comparison.file_binding(runtime / 'bin/mlir-amoeba-opt') != optimizer:
        raise ValueError('optimizer changed during smoke')
    acceptance = {'schema': 'orbit-sequential-fixed-fission-smoke-v1', 'status': 'accepted',
        'optimizer': optimizer, 'launches': launches, 'records': records,
        'wall_seconds': time.monotonic() - started,
        'objective_calls': sum(r['objective_calls'] for r in records),
        'native_program_evaluations': sum(r['native_program_evaluations'] for r in records),
        'actual_mapper_calls': sum(r['actual_mapper_calls'] for r in records),
        'formal_result_reuse': False,
        'checks': ['phase action filtering', 'frozen structural and fission prefix',
            'shared objective cap', 'phase cache and incumbent handoff',
            'native replay, coverage, dependencies, resources, mapper equality, trace and numerics']}
    comparison.write_exact(acceptance_path, acceptance)
    print(json.dumps(acceptance), flush=True)


if __name__ == '__main__':
    main()
