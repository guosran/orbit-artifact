#!/usr/bin/env python3
"""Replay unchanged F45 resource allocation with common actual mapper costs.

Consumes already captured canonical DFGs, native parent profiles and original
F45 allocator outputs. The compiler authenticates their exact source/body
binding before refreshing scheduler-dependent proof witnesses. The shared
production scheduler, an independent trace validator and the full-program
input0 numeric gate must all pass before cycles are published.
"""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import shutil
import sys

from run_common_amoeba_profiles import now, run, write
from validate_common_amoeba_retiming import validate_profile_inventory

ROOT = Path(__file__).resolve().parents[1]
WORKLOADS = ('gcn', 'harris', 'llama', 'lu', 'radar')


def capture(source: Path, target: Path) -> None:
    if target.exists():
        if target.read_bytes() != source.read_bytes():
            raise ValueError('existing exact-byte witness differs: ' + str(target))
    else:
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, target)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    for option in ('optimizer', 'source-contract', 'captured-root', 'output-root',
                   'architecture', 'network'):
        parser.add_argument('--' + option, type=Path, required=True)
    parser.add_argument('--llvm-build', type=Path,
                        default=Path('/home/x/shiran/llvm-project/build'))
    parser.add_argument('--reference-root', type=Path,
                        default=ROOT / '.work/selected-native-numeric-gate')
    parser.add_argument('--cpu', type=int, default=4)
    parser.add_argument('--workloads', nargs='+', choices=WORKLOADS,
                        default=list(WORKLOADS))
    args = parser.parse_args()
    if args.cpu not in range(12):
        parser.error('--cpu must be in the authorized range 0–11')
    os.sched_setaffinity(0, {args.cpu})
    args.output_root.mkdir(parents=True, exist_ok=True)
    contract = json.loads(args.source_contract.read_text())
    expected_pin = contract['immutable_optimizer_pin'].replace('${ARTIFACT_ROOT}', str(ROOT))
    if Path(expected_pin).resolve() != args.optimizer.resolve():
        raise ValueError('optimizer does not match the immutable source contract pin')
    state = {
        'schema': 'orbit-common-dfg-amoeba-native-replay-v1', 'status': 'running',
        'pid': os.getpid(), 'started_utc': now(), 'cpu_affinity': [args.cpu],
        'subprocess_timeout': None, 'input_index': 0, 'formal_go': False,
        'optimizer': str(args.optimizer.resolve()),
        'source_contract': str(args.source_contract.resolve()),
        'captured_root': str(args.captured_root.resolve()),
        'workloads': {w: {'status': 'queued'} for w in args.workloads},
        'allocation_policy': 'unchanged original F45 throughput-guided allocator',
        'scheduler': 'shared ORBIT production spatial-temporal scheduler',
        'replica_duration_policy': 'ceil(full common-parent mapped duration / original active replicas)',
    }
    capture(args.source_contract, args.output_root / 'source-contract.json')
    failed = False
    for workload in args.workloads:
        out = args.output_root / workload
        out.mkdir(exist_ok=True)
        row = state['workloads'][workload]
        row.update(status='running', phase='source-and-profile-binding', started_utc=now())
        write(args.output_root / 'runtime.json', state)
        try:
            original = args.captured_root / workload
            witness = out / 'inputs'
            for name in ('canonical.mlir', 'task-profiles.json', 'scheduled-common-input-f45.mlir'):
                capture(original / name, witness / name)
            records = {}
            for phase in ('profile', 'allocator'):
                path = original / (phase + '.command.json')
                record = json.loads(path.read_text())
                if record.get('status') != 'complete' or record.get('exit_code') != 0:
                    raise ValueError('captured actual ' + phase + ' command did not complete successfully')
                capture(path, witness / path.name)
                records[phase] = record
            capture(args.architecture, witness / 'architecture.yaml')
            capture(args.network, witness / 'network.yaml')
            profiles_path = witness / 'task-profiles.json'
            profiles = json.loads(profiles_path.read_text())
            tasks, _ = validate_profile_inventory(profiles, args.architecture.read_text())
            function = profiles['function']
            canonical = witness / 'canonical.mlir'
            scheduled = witness / 'scheduled-common-input-f45.mlir'
            facts = out / 'canonical-source-facts.json'
            run([str(args.optimizer), str(canonical), '--verify-each',
                 '--architecture-spec=' + str(args.architecture),
                 '--extract-joint-task-graph-facts=function=' + function +
                 ' fact-only=true max-fission-actions-per-task=0 output=' + str(facts),
                 '-o', os.devnull], out, 'source-facts')
            native_root = out / 'native'
            rank = native_root / 'rank-0'
            rank.mkdir(parents=True, exist_ok=True)
            native = rank / 'native.mlir'
            retiming = out / 'retiming.json'
            row.update(phase='shared-production-scheduler', task_count=len(tasks),
                       mapped_attempts=profiles['completed_candidate_count'])
            write(args.output_root / 'runtime.json', state)
            options = [
                'function=' + function, 'common-parent-profile-file=' + str(profiles_path),
                'common-canonical-module-file=' + str(canonical),
                'original-f45-replica-scaling=true',
                'reschedule-with-production-scheduler=true', 'output=' + str(retiming),
            ]
            run([str(args.optimizer), str(scheduled), '--verify-each',
                 '--architecture-spec=' + str(args.architecture),
                 '--joint-inter-task-network-spec=' + str(args.network),
                 '--retime-original-amoeba-fixed-decisions=' + ' '.join(options),
                 '--mlir-print-op-generic', '-o', str(native)], out, 'retime')
            row.update(phase='independent-trace')
            write(args.output_root / 'runtime.json', state)
            trace = out / 'independent-trace.json'
            run([sys.executable, str(ROOT / 'scripts/validate_common_amoeba_retiming.py'),
                 '--original-mlir', str(scheduled), '--result', str(retiming),
                 '--profiles', str(profiles_path), '--source-facts', str(facts),
                 '--architecture', str(args.architecture), '--network', str(args.network),
                 '--output', str(trace)], out, 'trace')
            checked = json.loads(trace.read_text())
            if checked['status'] != 'pass':
                raise ValueError('independent trace failed')
            row.update(phase='full-program-input0-numeric')
            write(args.output_root / 'runtime.json', state)
            numeric_root = out / 'numeric'
            run([sys.executable, str(ROOT / 'scripts/run_input0_numeric.py'),
                 '--workloads', workload, '--stage', 'common-amoeba', '--ranks', '0',
                 '--native-root', str(native_root), '--output-root', str(numeric_root),
                 '--optimizer', str(args.optimizer), '--llvm-build', str(args.llvm_build),
                 '--reference-root', str(args.reference_root), '--jobs', '1'], out, 'numeric')
            numeric_path = numeric_root / workload / 'common-amoeba-rank-0/result.json'
            numeric = json.loads(numeric_path.read_text())
            if numeric['status'] != 'pass' or numeric.get('scope') != 'mapped-native':
                raise ValueError('full-program numeric gate did not pass on actual native IR')
            result = {
                'schema': 'orbit-common-dfg-amoeba-baseline-result-v1',
                'status': 'native_replayed', 'workload': workload, 'input_index': 0,
                'native_cycles': checked['mapped_whole_program_cycles'],
                'mapper': 'pass', 'trace': 'pass', 'numeric': 'pass', 'formal_go': False,
                'retiming': str(retiming), 'independent_trace': str(trace),
                'numeric_evidence': str(numeric_path), 'native_mlir': str(native),
                'source_contract': state['source_contract'], 'optimizer': state['optimizer'],
                'captured_profiles': str(profiles_path), 'canonical_input': str(canonical),
                'original_f45_allocation': str(scheduled),
                'architecture': str(args.architecture), 'network': str(args.network),
                'allocation_policy': state['allocation_policy'], 'scheduler': state['scheduler'],
                'replica_duration_policy': state['replica_duration_policy'],
                'child_mapper_profiles_used': False, 'task_count': len(tasks),
                'profile_mapper_optimizer': records['profile']['argv'][0],
                'original_allocator_optimizer': records['allocator']['argv'][0],
                'numeric_element_comparisons': numeric.get('element_comparisons'),
            }
            write(out / 'result.json', result)
            row.update(status='complete', phase='complete', native_cycles=result['native_cycles'],
                       result=str(out / 'result.json'), ended_utc=now())
        except (OSError, ValueError, KeyError, TypeError, RuntimeError) as error:
            failed = True
            row.update(status='failed', error=str(error), ended_utc=now())
        write(args.output_root / 'runtime.json', state)
    state.update(status='incomplete' if failed else 'complete', ended_utc=now())
    write(args.output_root / 'runtime.json', state)
    return int(failed)


if __name__ == '__main__':
    raise SystemExit(main())
