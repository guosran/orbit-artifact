#!/usr/bin/env python3
"""Dispatch actual source-owned materializations and check their evidence."""
import argparse
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import time
from prepare_input0_source_domains import CONTRACTS

ROOT = Path(__file__).resolve().parents[1]
PIN = None
OUTPUT = None
PREPARED = None
ARCH = ROOT / 'config/architectures/amoeba_4x4_cgra_2x2_context6.yaml'
NETWORK = ROOT / 'config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml'
SOURCE = None
CPU = 6
spec = importlib.util.spec_from_file_location(
    'fixed_validator', ROOT / 'scripts/validate_original_amoeba_fixed_retiming.py')
validator = importlib.util.module_from_spec(spec)
spec.loader.exec_module(validator)


def run(directory, step, argv):
    record = {'argv': argv, 'started_unix': time.time(), 'subprocess_timeout': None}
    with (directory / (step + '.stdout.log')).open('wb') as out, \
            (directory / (step + '.stderr.log')).open('wb') as err:
        result = subprocess.run(argv, stdout=out, stderr=err)
    record.update(exit_code=result.returncode, ended_unix=time.time())
    (directory / (step + '.command.json')).write_text(json.dumps(record, indent=2) + '\n')
    if result.returncode:
        raise RuntimeError(f'{step} failed exit {result.returncode}; see {directory / (step + ".stderr.log")}')
    return record


def check(workload, seed, expected_parents, expected_trips):
    directory = OUTPUT / workload
    directory.mkdir()
    function = CONTRACTS[workload]['function']
    function_option = ('--materialize-joint-task-replicas=function=' + function
                       + ' task=' + seed + ' original-amoeba-fixed-decision=true')
    canonical = PREPARED / workload / 'caller-bound.mlir'
    source = canonical
    if workload == 'gcn':
        active_root = directory / 'active-transfer-acceptance'
        run(directory, 'active-transfer-checks', [
            'taskset', '--cpu-list', str(CPU), sys.executable,
            str(SOURCE / 'test/multi-cgra/taskflow/joint-scheduling/run-static-active-transfer-kernel-memref-checks.py'),
            '--optimizer', str(PIN), '--gcn-input', str(canonical),
            '--architecture', str(ARCH), '--output-root', str(active_root)])
        source = active_root / 'gcn-active-transfer.mlir'
    materialized = directory / 'materialized.mlir'
    materialize_record = run(directory, 'materialize-all-original-replicas', [
        'taskset', '--cpu-list', str(CPU), str(PIN), str(source), '--verify-each',
        '--architecture-spec=' + str(ARCH), '--joint-inter-task-network-spec=' + str(NETWORK),
        function_option, '--mlir-print-op-generic', '-o', str(materialized)])
    partition_record = run(directory, 'verify-source-partition', [
        'taskset', '--cpu-list', str(CPU), str(PIN), str(materialized), '--verify-each',
        '--architecture-spec=' + str(ARCH),
        '--verify-source-iteration-domain-partitions=parent-module=' + str(source) + ' function=' + function,
        '-o', '/dev/null'])
    facts_file = directory / 'materialized-facts.json'
    run(directory, 'extract-materialized-facts', [
        'taskset', '--cpu-list', str(CPU), str(PIN), str(materialized), '--verify-each',
        '--architecture-spec=' + str(ARCH), '--joint-inter-task-network-spec=' + str(NETWORK),
        '--extract-joint-task-graph-facts=function=' + function + ' output=' + str(facts_file) + ' fact-only=true',
        '-o', '/dev/null'])
    manifest = validator.extract_attribute(materialized.read_text(), 'amoeba.original_amoeba.materialized_decisions')
    if not isinstance(manifest, list) or {row.get('parent_task') for row in manifest} != expected_parents or len(manifest) != len(expected_parents):
        raise RuntimeError('C++ materialized-decision manifest does not cover exactly the original multi-replica parents')
    facts = json.loads(facts_file.read_text())
    task_rows = {row['task_name']: row for row in facts['tasks']}
    children = []
    for group in manifest:
        replicas = group.get('replicas')
        if group.get('original_replica_count') != 2 or not isinstance(replicas, list) or len(replicas) != 2:
            raise RuntimeError('actual original scheduler count is not preserved')
        if group.get('parent_task') in task_rows:
            raise RuntimeError('expanded graph retains an original replicated task')
        for replica in replicas:
            name = replica.get('task_name')
            row = task_rows.get(name)
            if (not row or row.get('source_iteration_domain_certified') is not True
                    or row.get('source_iteration_domain_complete') is not True
                    or row.get('trip_count_known') is not True
                    or row.get('effective_mapper_firing_count') != expected_trips
                    or row.get('taskflow_trip_count') != expected_trips
                    or row.get('source_iteration_work_count') != expected_trips
                    or replica.get('source_work_count') != expected_trips):
                raise RuntimeError('actual child facts do not certify the expected complete source partition: ' + str(row))
            children.append({'parent_task': group['parent_task'],
                             'replica_id': replica['replica_id'],
                             'materialized_task': name,
                             'function': function,
                             'materialized_module': str(materialized),
                             'source_facts': str(facts_file),
                             'source_trip_count': row['effective_mapper_firing_count'],
                             'source_work_count': replica['source_work_count'],
                             'original_replica_shape': replica['replica_shape'],
                             'original_placements': replica['placements']})
    if len({row['materialized_task'] for row in children}) != 2 * len(expected_parents):
        raise RuntimeError('expanded child inventory is not unique and complete')
    result = {'status': 'pass', 'function': function, 'original_caller_bound_module': str(canonical),
              'canonical_partition_parent': str(source), 'materialized_module': str(materialized),
              'source_facts': str(facts_file), 'materialized_decisions': manifest, 'children': children,
              'expected_profile_rows': len(children) * 8, 'formal_go': False,
              'materialization': {'status': 'pass', 'exit_code': 0, 'command_record': materialize_record},
              'partition_verification': {'status': 'pass', 'exit_code': 0, 'command_record': partition_record}}
    (directory / 'acceptance.json').write_text(json.dumps(result, indent=2) + '\n')
    return result


def main():
    global PIN, OUTPUT, PREPARED, SOURCE, CPU
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--optimizer', type=Path, required=True)
    parser.add_argument('--output-root', type=Path, required=True)
    parser.add_argument('--prepared-root', type=Path, required=True,
                        help='fresh source/caller-bound modules at <root>/<workload>/caller-bound.mlir')
    parser.add_argument('--orbit-source', type=Path, required=True,
                        help='ORBIT source checkout supplying the actual GCN proof/negative checker')
    parser.add_argument('--cpu', type=int, choices=range(12), default=6)
    parser.add_argument('--workloads', nargs='+', choices=('gcn', 'harris', 'lu'),
                        default=['gcn', 'harris', 'lu'])
    args = parser.parse_args()
    PIN, OUTPUT = args.optimizer.resolve(), args.output_root.resolve()
    PREPARED, SOURCE, CPU = args.prepared_root.resolve(), args.orbit_source.resolve(), args.cpu
    if not PIN.is_file():
        raise SystemExit('immutable optimizer pin is not ready')
    OUTPUT.mkdir(parents=True, exist_ok=False)
    result = {'schema': 'orbit-original-replica-materializer-acceptance-v1', 'optimizer': str(PIN),
              'formal_go': False, 'workloads': {}}
    for workload, seed, parents, trips in (
            ('gcn', 'Task_16', {'Task_16', 'Task_17'}, 200),
            ('harris', 'Task_19', {'Task_19', 'Task_21'}, 3843),
            ('lu', 'Task_6', {'Task_6'}, 256)):
        if workload not in args.workloads:
            continue
        try:
            result['workloads'][workload] = check(workload, seed, parents, trips)
        except Exception as error:
            result['workloads'][workload] = {'status': 'failed', 'reason': str(error)}
        (OUTPUT / 'acceptance.json').write_text(json.dumps(result, indent=2) + '\n')
        print(workload, result['workloads'][workload]['status'], flush=True)
    if any(row['status'] != 'pass' for row in result['workloads'].values()):
        raise SystemExit(1)


if __name__ == '__main__':
    main()
