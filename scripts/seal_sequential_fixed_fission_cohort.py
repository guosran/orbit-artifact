#!/usr/bin/env python3
"""Bind an accepted runtime and write its matched main/supplement launch plan."""
import argparse
import json
from pathlib import Path
import sys

import run_sequential_comparison as comparison


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--runtime-root', type=Path, required=True)
    parser.add_argument('--main-root', type=Path, required=True)
    parser.add_argument('--supplement-root', type=Path, required=True)
    parser.add_argument('--staging-root', type=Path, required=True)
    parser.add_argument('--prior-pid', type=int, required=True)
    parser.add_argument('--prior-optimizer', type=Path, required=True)
    parser.add_argument('--llvm-build', type=Path, required=True)
    args = parser.parse_args()
    runtime, main_root, supplement = (p.resolve() for p in (
        args.runtime_root, args.main_root, args.supplement_root))
    artifact = Path(__file__).resolve().parents[1]
    acceptance_path = runtime / 'smoke-acceptance.json'
    acceptance = comparison.read(acceptance_path)
    optimizer = comparison.file_binding(runtime / 'bin/mlir-amoeba-opt')
    if acceptance.get('status') != 'accepted' or acceptance.get('optimizer') != optimizer:
        raise ValueError('accepted end-to-end smoke required before sealing')
    contract_path = runtime / 'source-model-contract.json'
    contract = comparison.read(contract_path)
    native_binding = comparison.read(artifact / 'results/sequential-comparison-4096-fast2-host/validation-payload-binding.json')
    files = {}
    for row in contract['replay_payloads']:
        files[row['path']] = comparison.file_binding(runtime / row['path'])
    for role, row in native_binding['files'].items():
        if role in files:
            continue
        target = runtime / role if not Path(role).is_absolute() else Path(role)
        files[role] = comparison.file_binding(target)
    for role in ('scripts/run_sequential_comparison.py', 'scripts/run_sequential_fixed_fission.py',
                 'scripts/compact_sequential_raw.py', 'scripts/spill_sequential_catalogues.py',
                 'scripts/cleanup_completed_sequential_intermediates.py',
                 'reference/sequential-comparison/check-sequential-search-contract.py'):
        files[role] = comparison.file_binding(runtime / role)
    environment = {'ORBIT_LLVM_BUILD': str(args.llvm_build.resolve())}
    common = [sys.executable, '-u', str(runtime / 'scripts/run_sequential_comparison.py'),
        '--config', str(runtime / 'inputs-preparation/input0-chain.json'),
        '--optimizer', optimizer['path'], '--source-contract-file', str(contract_path),
        '--model', str(runtime / 'reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json'),
        '--architecture', str(runtime / 'config/architectures/amoeba_4x4_cgra_2x2_context6.yaml'),
        '--inter-task-network', str(runtime / 'config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml'),
        '--sram-config', str(runtime / 'config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json'),
        '--protocol-template', str(runtime / 'reference/sequential-comparison/protocol-fixed-fission-template.json'),
        '--budget', '4096', '--max-rounds', '8192', '--round-score-quota', '512',
        '--workers', '2', '--cpus-per-worker', '4', '--search-stage', 'full-joint-fission', '--compact-completed']
    phases = []
    for role, output in (('main', main_root), ('supplement', supplement)):
        if output.exists():
            raise ValueError('fresh results namespace required: ' + str(output))
        output.mkdir(parents=True)
        argv = [*common, '--output-root', str(output)]
        workloads = list(comparison.WORKLOADS)
        methods = [row[0] for row in comparison.METHODS]
        if role == 'supplement':
            workloads = ['gcn', 'lu']
            methods = ['sequential-50-transfer']
            argv += ['--workloads', *workloads, '--methods', 'sequential-50',
                     '--sequential-budget-policy', 'transfer-unused']
        phase = {'role': role, 'output_root': str(output), 'argv': argv, 'cwd': str(runtime),
                 'workloads': workloads, 'methods': methods, 'expected_cells': len(workloads) * len(methods)}
        phases.append(phase)
        comparison.write_exact(output / 'launch.json', {'argv': argv, 'cwd': str(runtime),
            'environment': environment, 'log': str(output / 'coordinator.log'),
            'process_status_file': str(output / 'parallel-process.json')})
        comparison.write_exact(output / 'validation-payload-binding.json', {
            'schema': 'orbit-sequential-validation-payload-binding-v1',
            'source_contract': comparison.file_binding(contract_path), 'files': files,
            'captured_before_search': True, 'shared_compiler_with_main_and_supplement': True})
        comparison.write_exact(output / 'diagnostic-extra-costs.json', {
            'build': comparison.read(runtime / 'build-provenance.json'), 'smoke': acceptance,
            'preparation': comparison.read(runtime / 'inputs-preparation/preparation-binding.json'),
            'earlier_diagnostics': comparison.read(runtime / 'additional-diagnostic-costs.json'),
            'additional_transfer_smoke': comparison.read(runtime / 'additional-transfer-smoke.json'),
            'failed_compile_attempt': {'exit_code': 1, 'cause': 'ported resource-legality brace nesting; repaired before accepted build',
                                       'wall_seconds': None, 'timing_limitation': 'first failed attempt was not instrumented'},
            'additional_training_or_calibration': False})
    comparison.write_exact(supplement / 'supplement-state.json', {
        'status': 'waiting-main-process-exit', 'main_results_root': str(main_root),
        'policy': 'separate supplementary variant; fixed50/50 main unchanged'})
    # All immutable runtime files are bound. Mutable status/result roots live
    # outside this runtime, and the compiler uses per-cell private caches.
    rows = [comparison.file_binding(p) for p in sorted(runtime.rglob('*'))
            if p.is_file() and '__pycache__' not in p.parts and p.suffix != '.pyc'
            and p.name not in {'queue-manifest.json', 'queue-state.json', 'queue.log'}]
    manifest = {'schema': 'orbit-sequential-fixed-fission-queue-v1', 'artifact_root': str(artifact),
        'state_path': str(main_root / 'queue-state.json'), 'optimizer': optimizer,
        'acceptance_file': str(acceptance_path), 'runtime_bindings': rows, 'phases': phases,
        'environment': environment, 'staging_root': str(args.staging_root.resolve()),
        'prior_pid': args.prior_pid, 'prior_command_match': 'run_input0_memory_fusion_fission_queue.py',
        'prior_optimizer_paths': [str(args.prior_optimizer.resolve())],
        'cores': 8, 'lanes': 2, 'cores_per_lane': 4, 'objective_calls_per_flow': 4096,
        'main_graph_percent': 50, 'sensitivity_graph_percents': [25, 75],
        'wait_policy': 'Linux pidfd, no experiment-result polling',
        'report_argv': [sys.executable, str(runtime / 'scripts/show_sequential_comparison.py'),
            '--results-root', str(main_root), '--output-dir', str(artifact / 'diagnostics' / main_root.name),
            '--supplement-root', str(supplement), '--supplement-output-dir', str(artifact / 'diagnostics' / supplement.name)],
        'report_log': str(main_root / 'final-report.log')}
    path = runtime / 'queue-manifest.json'
    comparison.write_exact(path, manifest)
    print(json.dumps({'manifest': str(path), 'main_cells': 20, 'supplement_cells': 2,
                      'cores': 8, 'prior_pid': args.prior_pid}), flush=True)


if __name__ == '__main__':
    main()
