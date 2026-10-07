#!/usr/bin/env python3
"""Prepare and dispatch source-backed original AMOEBA child profiles.

This driver consumes only a positive C++ materializer acceptance report.  It
does not derive child tasks, orientations, replica counts, or trip counts from
MLIR axes or loop bounds.  The accepted C++ materialized_decisions records are
the source of the selected task names; the report's children and C++ facts are
cross-checked against them before a profiler can run.
"""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import re
import subprocess
import sys
from datetime import datetime, timezone
from typing import Any


ARTIFACT_ROOT = Path(__file__).resolve().parents[1]
OUTPUT_ROOT = None
PIN = None
ARCH = ARTIFACT_ROOT / 'config/architectures/amoeba_4x4_cgra_2x2_context6.yaml'

SHAPES = {'1x1', '1x2', '1x3', '1x4', '2x1', '2x2', '3x1', '4x1'}
WORKLOADS = {
    'gcn': {'parents': {'Task_16', 'Task_17'}, 'trip_count': 200, 'children': 4, 'cpus': '0-3'},
    'harris': {'parents': {'Task_19', 'Task_21'}, 'trip_count': 3843, 'children': 4, 'cpus': '6-7'},
    'lu': {'parents': {'Task_6'}, 'trip_count': 256, 'children': 2, 'cpus': '8-9'},
}


class GateError(RuntimeError):
    pass


def require(condition: bool, message: str) -> None:
    if not condition:
        raise GateError(message)


def read_json(path: Path, label: str) -> Any:
    require(path.is_file(), f'missing {label}: {path}')
    try:
        return json.loads(path.read_text())
    except (OSError, json.JSONDecodeError) as exc:
        raise GateError(f'invalid {label} JSON at {path}: {exc}') from exc


def exact_path(value: Any, label: str) -> Path:
    require(isinstance(value, str) and value.strip() == value and bool(value),
            f'{label} must be an exact nonempty path string')
    path = Path(value)
    require(path.is_absolute(), f'{label} must be absolute: {value!r}')
    require(path.is_file(), f'{label} file is missing: {path}')
    return path


def command_argv(proof: Any, label: str, expected_pass: str, function: str,
                 materialized_module: Path, role: str) -> list[str]:
    require(isinstance(proof, dict), f'{label} proof record is missing')
    require(proof.get('status') == 'pass', f'{label} status must be exactly pass')
    require(proof.get('exit_code') == 0, f'{label} exit_code must be 0')
    record = proof.get('command_record')
    require(isinstance(record, dict), f'{label}.command_record is missing')
    require(record.get('exit_code') == 0, f'{label}.command_record.exit_code must be 0')
    argv = record.get('argv')
    require(isinstance(argv, list) and argv and all(isinstance(arg, str) for arg in argv),
            f'{label}.command_record.argv must be a nonempty string array')
    matching = [arg for arg in argv if expected_pass in arg]
    require(matching, f'{label} command does not contain C++ pass {expected_pass}')
    require(any(f'function={function}' in arg for arg in matching),
            f'{label} command does not bind the accepted function {function}')
    if role == 'materialization':
        require(any(materialized_module.as_posix() in arg for arg in argv),
                f'{label} command does not name the exact accepted materialized module')
        require(any(arg == '-o' for arg in argv), f'{label} command is missing -o output')
        output_index = argv.index('-o') + 1
        require(output_index < len(argv) and Path(argv[output_index]) == materialized_module,
                f'{label} command output is not the accepted materialized module')
    elif role == 'partition':
        require(str(materialized_module) in argv,
                f'{label} command does not verify the exact materialized module')
    return argv


def selected_shape(replica: dict[str, Any], label: str) -> str:
    shape = replica.get('replica_shape')
    if isinstance(shape, dict):
        value = shape.get('shape')
    else:
        value = shape
    require(isinstance(value, str) and re.fullmatch(r'[1-4]x[1-4]', value) is not None,
            f'{label} has no explicit C++ selected orientation')
    return value


def validate_acceptance(report_path: Path, workload_name: str) -> dict[str, Any]:
    require(workload_name in WORKLOADS, f'unknown workload {workload_name!r}')
    require(PIN.is_file() and os.access(PIN, os.X_OK), f'immutable f45 profiler pin is unavailable: {PIN}')
    require(ARCH.is_file(), f'original ctrl20/context6 architecture is unavailable: {ARCH}')
    report = read_json(report_path, 'acceptance report')
    require(report.get('schema') == 'orbit-original-replica-materializer-acceptance-v1',
            'unexpected acceptance report schema')
    require(report.get('formal_go') is False,
            'formal_go must remain false; SRAM/model status is not a profile-run gate')
    workloads = report.get('workloads')
    require(isinstance(workloads, dict), 'acceptance report has no workloads object')
    accepted = workloads.get(workload_name)
    require(isinstance(accepted, dict), f'acceptance report has no {workload_name} result')
    require(accepted.get('formal_go', False) is False,
            f'{workload_name} must not claim formal_go=true')
    require(accepted.get('status') == 'pass',
            f'{workload_name} workload status must be exactly pass')

    function = accepted.get('function')
    require(isinstance(function, str) and function and not any(ch.isspace() for ch in function),
            f'{workload_name} accepted function symbol is missing or malformed')
    module = exact_path(accepted.get('materialized_module'), f'{workload_name}.materialized_module')
    facts_path = exact_path(accepted.get('source_facts'), f'{workload_name}.source_facts')

    materialization_argv = command_argv(
        accepted.get('materialization'), f'{workload_name}.materialization',
        '--materialize-joint-task-replicas=', function, module, 'materialization')
    partition_argv = command_argv(
        accepted.get('partition_verification'), f'{workload_name}.partition_verification',
        '--verify-source-iteration-domain-partitions=', function, module, 'partition')
    # Both records must refer to the same complete MLIR file.  A positive status
    # without those concrete C++ pass invocations cannot authorize profiling.
    require(any(module.as_posix() in arg for arg in materialization_argv),
            'materialization command/module binding changed during validation')
    require(str(module) in partition_argv,
            'partition-verifier input/module binding changed during validation')

    decisions = accepted.get('materialized_decisions')
    children_report = accepted.get('children')
    require(isinstance(decisions, list),
            f'{workload_name}.materialized_decisions must be the extracted C++ decision array')
    require(isinstance(children_report, list), f'{workload_name}.children must be a C++-derived array')
    facts = read_json(facts_path, f'{workload_name} C++ source facts')
    fact_rows = facts.get('tasks') if isinstance(facts, dict) else None
    require(isinstance(fact_rows, list), 'C++ source-facts JSON has no tasks array')
    facts_by_name: dict[str, dict[str, Any]] = {}
    for row in fact_rows:
        require(isinstance(row, dict) and isinstance(row.get('task_name'), str),
                'C++ source-facts task row is malformed')
        name = row['task_name']
        require(name not in facts_by_name, f'duplicate task in C++ source facts: {name}')
        facts_by_name[name] = row

    config = WORKLOADS[workload_name]
    expected_parents = config['parents']
    require(len(decisions) == len(expected_parents),
            f'{workload_name} C++ manifest has wrong parent count')
    manifest_by_parent: dict[str, dict[str, Any]] = {}
    for group in decisions:
        require(isinstance(group, dict), 'C++ materialized_decisions entry is malformed')
        parent = group.get('parent_task')
        require(parent in expected_parents, f'unexpected C++ materialized parent: {parent!r}')
        require(parent not in manifest_by_parent, f'duplicate C++ materialized parent: {parent}')
        require(group.get('original_replica_count') == 2,
                f'{parent} must preserve the actual two-replica scheduler decision')
        replicas = group.get('replicas')
        require(isinstance(replicas, list) and len(replicas) == 2,
                f'{parent} C++ replica inventory must contain exactly two records')
        manifest_by_parent[parent] = group
    require(set(manifest_by_parent) == expected_parents,
            'C++ materialized_decisions does not cover the accepted original parents exactly')

    derived: list[dict[str, Any]] = []
    seen_names: set[str] = set()
    seen_ids: set[tuple[str, int]] = set()
    for parent in sorted(expected_parents):
        replicas = manifest_by_parent[parent]['replicas']
        ids = [replica.get('replica_id') if isinstance(replica, dict) else None for replica in replicas]
        require(sorted(ids) == [0, 1], f'{parent} C++ replica ids must be exactly 0 and 1')
        for replica in sorted(replicas, key=lambda item: item['replica_id']):
            replica_id = replica['replica_id']
            require((parent, replica_id) not in seen_ids, f'duplicate C++ parent/replica id {parent}/{replica_id}')
            seen_ids.add((parent, replica_id))
            name = replica.get('task_name')
            require(isinstance(name, str) and re.fullmatch(r'[A-Za-z_][A-Za-z0-9_.-]*', name) is not None,
                    f'{parent}/{replica_id} has invalid C++ child task name')
            require(name not in seen_names, f'duplicate C++ child task name {name}')
            seen_names.add(name)
            require(name not in expected_parents, f'expanded C++ child aliases parent task {name}')
            orientation = selected_shape(replica, f'{parent}/{replica_id}')
            if workload_name == 'lu':
                expected_orientation = '1x2' if replica_id == 0 else '2x1'
                require(orientation == expected_orientation,
                        f'LU replica {replica_id} C++ selected orientation must be {expected_orientation}')
            placements = replica.get('placements')
            require(isinstance(placements, list) and placements,
                    f'{name} is missing its concrete C++ scheduler placement record')
            for place in placements:
                require(isinstance(place, dict) and place.get('replica_id') == replica_id,
                        f'{name} placement does not match C++ replica id {replica_id}')

            source_count = replica.get('source_work_count')
            require(source_count == config['trip_count'],
                    f'{name} C++ source work count does not match accepted source trip count')
            fact = facts_by_name.get(name)
            require(fact is not None, f'{name} has no C++ source-facts row')
            for field in ('source_iteration_domain_certified', 'source_iteration_domain_complete', 'trip_count_known'):
                require(fact.get(field) is True, f'{name} C++ source fact {field} is not true')
            for field in ('effective_mapper_firing_count', 'taskflow_trip_count', 'source_iteration_work_count'):
                require(fact.get(field) == config['trip_count'],
                        f'{name} C++ source-facts {field} disagrees with the source trip count')
            child = {
                'parent_task': parent,
                'replica_id': replica_id,
                'materialized_task': name,
                'function': function,
                'materialized_module': str(module),
                'source_facts': str(facts_path),
                'source_trip_count': fact['effective_mapper_firing_count'],
                'source_work_count': source_count,
                'original_replica_shape': replica['replica_shape'],
                'selected_orientation': orientation,
                'original_placements': placements,
            }
            derived.append(child)

    require(len(derived) == config['children'],
            f'{workload_name} C++ materializer must provide {config["children"]} children')
    require(len(children_report) == len(derived),
            f'{workload_name}.children does not match C++ materialized_decisions count')
    report_children: dict[tuple[str, int], dict[str, Any]] = {}
    for child in children_report:
        require(isinstance(child, dict), f'{workload_name}.children contains a malformed row')
        key = (child.get('parent_task'), child.get('replica_id'))
        require(key not in report_children, f'{workload_name}.children has duplicate key {key}')
        report_children[key] = child
    for child in derived:
        key = (child['parent_task'], child['replica_id'])
        row = report_children.get(key)
        require(row is not None, f'{workload_name}.children is missing C++ decision {key}')
        for field in ('parent_task', 'replica_id', 'materialized_task', 'function',
                      'materialized_module', 'source_facts', 'source_trip_count',
                      'source_work_count', 'original_replica_shape', 'original_placements'):
            require(row.get(field) == child[field],
                    f'{workload_name}.children {key} field {field} disagrees with C++ decisions/facts')

    expected_rows = len(derived) * 8
    if 'expected_profile_rows' in accepted:
        require(accepted['expected_profile_rows'] == expected_rows,
                f'{workload_name}.expected_profile_rows disagrees with C++ child inventory')
    task_names = [row['materialized_task'] for row in derived]
    require(len(task_names) == len(set(task_names)), 'C++ selected child names are not unique')
    return {
        'workload': workload_name,
        'function': function,
        'materialized_module': module,
        'source_facts': facts_path,
        'materialized_decisions': decisions,
        'children': derived,
        'task_names': task_names,
        'expected_candidate_count': expected_rows,
        'cpu_list': config['cpus'],
        'acceptance_report': report_path,
    }


def utc_stamp() -> str:
    return datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')


def write_json(path: Path, value: Any) -> None:
    temp = path.with_suffix(path.suffix + '.tmp')
    temp.write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')
    temp.replace(path)


def print_ready(ready: dict[str, Any]) -> None:
    print(json.dumps({
        'status': 'ready',
        'formal_go': False,
        'workload': ready['workload'],
        'function': ready['function'],
        'materialized_module': str(ready['materialized_module']),
        'source_facts': str(ready['source_facts']),
        'task_names': ready['task_names'],
        'children': len(ready['children']),
        'candidate_rows': ready['expected_candidate_count'],
        'cpus': ready['cpu_list'],
    }, indent=2))


def verify_profile(path: Path, expected: dict[str, Any]) -> dict[str, Any]:
    profile = read_json(path, 'task profile output')
    names = set(expected['task_names'])
    require(profile.get('format') == 'amoeba-task-profile-v1', 'unexpected profiler JSON format')
    require(profile.get('function') == expected['function'], 'profile function does not match accepted module')
    require(profile.get('task_count') == len(names), 'profile task_count does not match selected C++ children')
    require(profile.get('expected_candidate_count') == expected['expected_candidate_count'],
            'profile expected_candidate_count does not match selected C++ children')
    require(profile.get('completed_candidate_count') == expected['expected_candidate_count'],
            'profile suite did not complete every selected candidate attempt')
    attempts = profile.get('candidate_attempts')
    tasks = profile.get('tasks')
    require(isinstance(attempts, list) and isinstance(tasks, list),
            'profile JSON is missing tasks or candidate_attempts arrays')
    require({item.get('task') for item in attempts if isinstance(item, dict)} == names,
            'profile attempts contain unexpected or missing selected tasks')
    require({item.get('task') for item in tasks if isinstance(item, dict)} == names,
            'profile task summaries contain unexpected or missing selected tasks')
    for name in names:
        rows = [row for row in attempts if row.get('task') == name]
        require(len(rows) == 8, f'{name} must have exactly eight explicit shape attempts')
        require({row.get('shape') for row in rows} == SHAPES,
                f'{name} does not include the complete eight-shape candidate set')
        require(sorted(row.get('candidate_index_in_task') for row in rows) == list(range(1, 9)),
                f'{name} candidate indices are incomplete or duplicated')
        require(all(isinstance(row.get('mapper_succeeded'), bool) for row in rows),
                f'{name} has an attempt without an explicit mapper success/failure result')
    return profile


def run_profile(ready: dict[str, Any], run_dir: Path) -> None:
    workload = ready['workload']
    module = ready['materialized_module']
    function = ready['function']
    profile_file = run_dir / 'task-profiles.json'
    body_file = run_dir / 'body-export.json'
    profiled_module = run_dir / 'profiled.mlir'
    state_file = run_dir / 'run-state.json'
    started = datetime.now(timezone.utc).isoformat()
    state = {
        'schema': 'amoeba-original-replica-profile-run-state-v1',
        'workload': workload,
        'status': 'running',
        'started_utc': started,
        'formal_go': False,
        'acceptance_report': str(ready['acceptance_report']),
        'function': function,
        'materialized_module': str(module),
    }
    write_json(state_file, state)
    try:
        (run_dir / 'acceptance-report.json').write_bytes(ready['acceptance_report'].read_bytes())
        write_json(run_dir / 'source-materialized-decisions.json', {
            'materialized_decisions': ready['materialized_decisions'],
            'children': ready['children'],
        })
        (run_dir / 'requested-task-names.txt').write_text(';'.join(ready['task_names']) + '\n')

        profile_arg = (
            f'--profile-task-candidates=output-json={profile_file} '
            f'max-composed-cgra-count=4 symbol-bound-trip-count=1 '
            f'task-names={";".join(ready["task_names"])}'
        )
        profile_argv = [
            'taskset', '--cpu-list', ready['cpu_list'], str(PIN), str(module),
            '--verify-each', f'--architecture-spec={ARCH}', profile_arg,
            '--mlir-print-op-generic', '-o', str(profiled_module),
        ]
        with (run_dir / 'profile.stdout.log').open('wb') as out, \
                (run_dir / 'profile.stderr.log').open('wb') as err:
            result = subprocess.run(profile_argv, stdout=out, stderr=err)
        write_json(run_dir / 'profile.command.json', {'argv': profile_argv, 'exit_code': result.returncode})
        require(result.returncode == 0, f'original f45 child profiler failed exit {result.returncode}')
        require(module.read_bytes() == profiled_module.read_bytes(),
                'profiling changed the complete accepted materialized module bytes')
        profile = verify_profile(profile_file, ready)

        body_arg = f'--verify-task-profiler-body-equivalence=output={body_file} function={function}'
        body_argv = [
            'taskset', '--cpu-list', ready['cpu_list'], str(PIN), str(module), body_arg,
            '--verify-each', '--mlir-print-op-generic', '-o', '/dev/null',
        ]
        with (run_dir / 'body-export.stdout.log').open('wb') as out, \
                (run_dir / 'body-export.stderr.log').open('wb') as err:
            result = subprocess.run(body_argv, stdout=out, stderr=err)
        write_json(run_dir / 'body-export.command.json', {'argv': body_argv, 'exit_code': result.returncode})
        require(result.returncode == 0, f'original f45 body export failed exit {result.returncode}')
        body = read_json(body_file, 'body export')
        require(body.get('format') == 'amoeba-pre-mapper-task-bodies-v1',
                'unexpected body export format')
        require(body.get('function') == function, 'body export function does not match accepted function')
        body_tasks = body.get('tasks')
        require(isinstance(body_tasks, list), 'body export has no tasks array')
        for child in ready['children']:
            matching = [item for item in body_tasks if isinstance(item, dict)
                        and item.get('task') == child['materialized_task']]
            require(len(matching) == 1, f"body export must preserve selected child {child['materialized_task']} once")
            require(matching[0].get('static_trip_count') == child['source_trip_count'],
                    f"body export changed source static trip count for {child['materialized_task']}")

        successes = sum(row['mapper_succeeded'] for row in profile['candidate_attempts'])
        failures = len(profile['candidate_attempts']) - successes
        manifest_children = []
        for child in ready['children']:
            manifest_children.append({
                'parent_task': child['parent_task'],
                'replica_id': child['replica_id'],
                'materialized_task': child['materialized_task'],
                'function': function,
                'materialized_module': str(module),
                'profile_file': str(profile_file),
                'body_export_file': str(body_file),
                'source_facts': child['source_facts'],
                'static_trip_count': child['source_trip_count'],
                'selected_orientation': child['selected_orientation'],
                'original_replica_shape': child['original_replica_shape'],
                'original_placements': child['original_placements'],
            })
        evidence = {
            'schema': 'amoeba-original-replica-profile-evidence-v1',
            'formal_go': False,
            'workload': workload,
            'acceptance_report': str(ready['acceptance_report']),
            'optimizer': str(PIN),
            'architecture': str(ARCH),
            'function': function,
            'materialized_module': str(module),
            'source_facts': str(ready['source_facts']),
            'profile_file': str(profile_file),
            'body_export_file': str(body_file),
            'profiled_module_byte_equal_to_input': True,
            'child_count': len(manifest_children),
            'expected_candidate_count': ready['expected_candidate_count'],
            'completed_candidate_count': profile['completed_candidate_count'],
            'mapper_success_count': successes,
            'explicit_mapper_failure_count': failures,
            'records': manifest_children,
        }
        write_json(run_dir / 'profile-evidence-detail.json', evidence)
        binding_fields = ('parent_task', 'replica_id', 'materialized_task',
                          'function', 'materialized_module', 'profile_file',
                          'body_export_file')
        write_json(run_dir / 'profile-evidence.json', {
            'schema': 'amoeba-original-replica-profile-evidence-v1',
            'records': [{key: row[key] for key in binding_fields}
                        for row in manifest_children],
        })
        state.update({
            'status': 'complete',
            'finished_utc': datetime.now(timezone.utc).isoformat(),
            'exit_code': 0,
            'profile_file': str(profile_file),
            'body_export_file': str(body_file),
            'profiled_module': str(profiled_module),
            'child_count': len(manifest_children),
            'expected_candidate_count': ready['expected_candidate_count'],
            'mapper_success_count': successes,
            'explicit_mapper_failure_count': failures,
        })
        write_json(state_file, state)
    except Exception as exc:
        state.update({
            'status': 'failed',
            'finished_utc': datetime.now(timezone.utc).isoformat(),
            'exit_code': 1,
            'error': str(exc),
        })
        write_json(state_file, state)
        raise


def launch(ready: dict[str, Any]) -> None:
    workload = ready['workload']
    run_dir = OUTPUT_ROOT / workload / f'run-{utc_stamp()}-{os.getpid()}'
    run_dir.mkdir(parents=True, exist_ok=False)
    (OUTPUT_ROOT / workload).mkdir(parents=True, exist_ok=True)
    (OUTPUT_ROOT / workload / 'latest-run.path').write_text(str(run_dir) + '\n')
    (run_dir / 'acceptance-report.path').write_text(str(ready['acceptance_report']) + '\n')
    control_path = run_dir / 'runner-control.log'
    command = [
        sys.executable, str(Path(__file__).resolve()),
        '--original-optimizer', str(PIN), '--output-root', str(OUTPUT_ROOT),
        '--architecture', str(ARCH),
        '--acceptance-report', str(ready['acceptance_report']),
        '--workload', workload,
        '--_run-dir', str(run_dir),
    ]
    with control_path.open('ab') as control:
        proc = subprocess.Popen(command, stdin=subprocess.DEVNULL, stdout=control,
                                stderr=subprocess.STDOUT, start_new_session=True,
                                close_fds=True)
    (run_dir / 'runner.pid').write_text(str(proc.pid) + '\n')
    print(json.dumps({
        'status': 'launched',
        'workload': workload,
        'pid': proc.pid,
        'cpus': ready['cpu_list'],
        'run_dir': str(run_dir),
        'formal_go': False,
    }, indent=2))


def status(workload: str) -> None:
    require(workload in WORKLOADS, f'unknown workload {workload!r}')
    latest = OUTPUT_ROOT / workload / 'latest-run.path'
    require(latest.is_file(), f'no runtime has been launched for {workload}')
    run_dir = Path(latest.read_text().strip())
    state = run_dir / 'run-state.json'
    if state.is_file():
        print(state.read_text(), end='')
        return
    pid_file = run_dir / 'runner.pid'
    require(pid_file.is_file(), f'run has neither state nor PID record: {run_dir}')
    print(json.dumps({'status': 'starting', 'pid': pid_file.read_text().strip(), 'run_dir': str(run_dir)}, indent=2))


def main() -> int:
    global PIN, OUTPUT_ROOT, ARCH
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--original-optimizer', type=Path, required=True,
                        help='immutable f45-derived profiler with selected task-name support')
    parser.add_argument('--output-root', type=Path, required=True,
                        help='new child-profile output root')
    parser.add_argument('--architecture', type=Path, default=ARCH)
    parser.add_argument('--acceptance-report', type=Path,
                        help='explicit accepted C++ materializer report (required for prepare/launch)')
    parser.add_argument('--workload', choices=sorted(WORKLOADS))
    action = parser.add_mutually_exclusive_group(required=False)
    action.add_argument('--prepare-only', action='store_true',
                        help='validate acceptance and print readiness without launching any process')
    action.add_argument('--launch', action='store_true', help='launch the detached profiler runtime')
    action.add_argument('--status', action='store_true', help='show latest workload run state')
    parser.add_argument('--confirm-positive-materializer', action='store_true',
                        help='internal dispatch guard required together with --launch')
    parser.add_argument('--_run-dir', type=Path, help=argparse.SUPPRESS)
    args = parser.parse_args()
    PIN, OUTPUT_ROOT, ARCH = args.original_optimizer.resolve(), args.output_root.resolve(), args.architecture.resolve()

    try:
        require(ARCH.read_bytes() == (ARTIFACT_ROOT / 'config/architectures/amoeba_4x4_cgra_2x2_context6.yaml').read_bytes(),
                'child profiles require the exact original ctrl20/context6 architecture')
        public_actions = sum((args.prepare_only, args.launch, args.status))
        if args._run_dir is None:
            require(public_actions == 1, 'select exactly one of --prepare-only, --launch, or --status')
        else:
            require(public_actions == 0, 'internal runtime cannot be combined with public actions')
        if args.status:
            require(args.workload is not None, '--status requires --workload')
            require(args.acceptance_report is None and not args.confirm_positive_materializer,
                    '--status does not accept an acceptance report or launch guard')
            status(args.workload)
            return 0

        require(args.acceptance_report is not None, '--acceptance-report is required')
        require(args.workload is not None, '--workload is required')
        report_path = args.acceptance_report.resolve(strict=True)
        ready = validate_acceptance(report_path, args.workload)

        if args._run_dir is not None:
            run_dir = args._run_dir.resolve(strict=True)
            expected_parent = (OUTPUT_ROOT / args.workload).resolve()
            require(run_dir.parent == expected_parent,
                    'internal run directory is outside the assigned workload evidence root')
            run_profile(ready, run_dir)
            return 0

        require(not args.confirm_positive_materializer or args.launch,
                '--confirm-positive-materializer is only valid with --launch')
        if args.prepare_only:
            print_ready(ready)
            return 0
        require(args.confirm_positive_materializer,
                '--launch requires --confirm-positive-materializer')
        launch(ready)
        return 0
    except (GateError, OSError, subprocess.SubprocessError) as exc:
        print(f'dispatch-profile-evidence: {exc}', file=sys.stderr)
        return 1


if __name__ == '__main__':
    raise SystemExit(main())
