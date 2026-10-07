#!/usr/bin/env python3
"""Check common actual mapper costs and the shared AMOEBA scheduling trace."""
from __future__ import annotations

import argparse
import json
import math
from pathlib import Path
import sys
import validate_original_amoeba_fixed_retiming as existing

BINDING_SCHEMA = 'orbit-original-f45-common-parent-profile-binding-v1'
PROFILE_PROVENANCE = 'source-owned-common-parent-profile-only-mapped-duration-v1'
SHAPES = ('1x1', '1x2', '2x1', '1x3', '3x1', '2x2', '1x4', '4x1')
FORMULA = 'ceil(structural_startup_cycles + compiled_ii * (sample_trip_count - 1))'
REPLICA_POLICY = {
    'schema': 'amoeba-original-f45-replica-scaling-v1',
    'duration_formula': 'ceil(ceil(structural_startup_cycles + compiled_ii * (actual_mapper_firings - 1)) / original_active_replicas)',
    'replica_duration_rule': 'ceil-full-parent-mapped-duration-over-original-active-replicas-v1',
    'child_mapper_profiles_used': False, 'status': 'original-f45-scheduler-estimate',
}

def require(condition, message):
    if not condition:
        raise ValueError(message)

def validate_profile_inventory(profiles, architecture_text):
    require(profiles.get('format') == 'amoeba-task-profile-v1' and
            profiles.get('profile_provenance') == PROFILE_PROVENANCE and
            profiles.get('duration_formula') == FORMULA and
            profiles.get('architecture_spec_text') == architecture_text and
            profiles.get('whole_program_scheduler_invoked') is False and
            profiles.get('source_iteration_domain_coverage_verified') is True,
            'profile formula, architecture, provenance or source coverage differs')
    require(profiles.get('shape_domain') == list(SHAPES), 'profile oriented shape domain differs')
    require(profiles.get('hardware_coordinates') == {
        'multi_cgra_grid_rows': 4, 'multi_cgra_grid_cols': 4,
        'per_cgra_tile_rows': 2, 'per_cgra_tile_cols': 2,
        'total_mapper_rows': 8, 'total_mapper_cols': 8}, 'profile hardware coordinates differ')
    for kind in ('module', 'function'):
        witness = profiles.get('canonical_' + kind + '_witness_bytes')
        require(isinstance(witness, str) and len(witness.encode()) ==
                profiles.get('canonical_' + kind + '_witness_byte_count'), 'canonical witness byte count differs')
    tasks = existing.task_map(profiles.get('tasks'), 'common mapper tasks')
    attempts = profiles.get('candidate_attempts')
    require(isinstance(attempts, list) and len(attempts) == 8 * len(tasks) ==
            profiles.get('completed_candidate_count') == profiles.get('expected_candidate_count') and
            len(tasks) == profiles.get('task_count'), 'common mapper attempt inventory is incomplete')
    expected = [(name, i + 1, shape) for name in tasks for i, shape in enumerate(SHAPES)]
    require([(a.get('task'), a.get('candidate_index_in_task'), a.get('shape')) for a in attempts] == expected,
            'common mapper attempt order, task or orientation inventory differs')
    selected = {}
    for name, task in tasks.items():
        require(task.get('source_iteration_domain_certified') is True and
                task.get('source_iteration_domain_complete') is True and
                task.get('source_iteration_domain_status') == 'certified-complete', name + ': incomplete source domain')
        trip = existing.require_int(task.get('sample_trip_count'), name + '.trip', 1)
        rows = task.get('profiles')
        require(isinstance(rows, list), name + ': profile rows missing')
        by_shape = {}
        for row in rows:
            shape = row.get('composed_cgra_shape')
            require(shape in SHAPES and shape not in by_shape, name + ': duplicate/unknown profile orientation')
            cg_rows, cg_cols = existing.shape_dims(shape, name + '.shape')
            ii = existing.require_int(row.get('compiled_ii'), name + '.compiled_ii', 1)
            startup = existing.require_int(row.get('structural_startup_cycles'), name + '.startup', 0)
            existing.require_int(row.get('steps'), name + '.steps', 1)
            existing.require_int(row.get('materialized_operation_count'), name + '.ops', 1)
            require(row.get('mapper_succeeded') is True and row.get('sample_trip_count') == trip and
                    row.get('estimated_latency') == math.ceil(startup + ii * (trip - 1)) and
                    row.get('duration_formula') == FORMULA and row.get('duration_provenance') == PROFILE_PROVENANCE and
                    row.get('composed_cgra_count') == cg_rows * cg_cols and
                    (row.get('mapper_tile_rows'), row.get('mapper_tile_cols')) == (2 * cg_rows, 2 * cg_cols),
                    name + ': actual mapper duration/coordinates differ')
            require(all(row.get(key) == task.get(key) for key in (
                'source_iteration_domain_certified', 'source_iteration_domain_complete',
                'source_iteration_domain_status', 'source_iteration_work_count')),
                name + ': profile source-domain facts disagree')
            witness = row.get('pre_mapper_wrapper_bytes')
            require(isinstance(witness, str) and witness and len(witness.encode()) == row.get('pre_mapper_wrapper_byte_count'),
                    name + ': exact raw mapper wrapper witness missing')
            by_shape[shape] = row
        for attempt in (a for a in attempts if a['task'] == name):
            succeeded = attempt.get('mapper_succeeded')
            require(type(succeeded) is bool and attempt.get('profile_created') is succeeded and
                    (attempt['shape'] in by_shape) is succeeded,
                    name + ': successful/failed attempt inventory disagrees with actual profiles')
        selected[name] = by_shape
    return tasks, selected

def validate(ir, result, profiles, source_facts, architecture_text, network_text):
    tasks, profile_rows = validate_profile_inventory(profiles, architecture_text)
    require(result.get('schema') == 'amoeba-original-fixed-decision-retiming-v1' and result.get('valid') is True and
            result.get('formal_go') is False and result.get('diagnostic_only') is True,
            'common retiming result is invalid or overstates formal admission')
    trace = result.get('fixed_decision_trace')
    require(isinstance(trace, dict) and trace.get('schema') == 'amoeba-fixed-decision-trace-v1', 'common trace missing')
    binding = result.get('common_mapper_profile_binding')
    require(isinstance(binding, dict) and binding == trace.get('common_mapper_profile_binding') and
            binding.get('schema') == BINDING_SCHEMA and binding.get('schema_version') == 1 and binding.get('verified') is True and
            result.get('common_mapper_profile_binding_verified') is True and trace.get('common_mapper_profile_binding_verified') is True,
            'common raw mapper/profile binding is missing or differs')
    require(binding.get('profile_provenance') == profiles['profile_provenance'] and
            binding.get('function') == profiles['function'] == result.get('function') and
            binding.get('candidate_scope') == profiles['candidate_scope'] and
            binding.get('candidate_id') == profiles['candidate_id'] == result.get('candidate_id') and
            binding.get('canonical_witness_format') == profiles['canonical_witness_format'] and
            binding.get('architecture_spec_text') == architecture_text and
            binding.get('child_mapper_profiles_used') is False and
            binding.get('semantic_module_binding_status') == 'verified-pre-f45-canonical-after-exact-scheduler-annotation-projection-v1' and
            binding.get('source_iteration_binding_refresh_status') == 'refreshed-after-canonical-taskflow-and-mapper-wrapper-verification',
            'common canonical/architecture/semantic proof provenance differs')
    for key in ('canonical_module_witness_byte_count', 'canonical_function_witness_byte_count'):
        require(binding.get(key) == profiles[key], 'common canonical witness size differs')
    require((binding.get('grid_rows'), binding.get('grid_cols'), binding.get('per_cgra_tile_rows'), binding.get('per_cgra_tile_cols')) == (4, 4, 2, 2),
            'common target geometry differs')
    require(result.get('replica_timing_policy') == trace.get('replica_timing_policy') == REPLICA_POLICY,
            'common parent/N F45 policy differs')
    existing._validate_production_scheduler_contract(result, trace, True)
    require(result.get('iteration_domain_coverage_verified') is True and
            trace.get('iteration_domain_coverage_verified') is True and
            result.get('iteration_domain_coverage_status') == trace.get('iteration_domain_coverage_status'),
            'source iteration-domain coverage is incomplete')
    source_rows = existing.task_map(existing.extract_attribute(ir, 'amoeba.task_scheduler_task_schedule'), 'original source schedule', 'task_name')
    source_dispatch = existing.extract_attribute(ir, 'amoeba.task_scheduler_dispatch_order')
    original = existing.task_map(result.get('original_decisions'), 'original F45 decisions')
    costs = existing.task_map(result.get('task_costs'), 'common actual costs')
    bindings = existing.task_map(trace.get('task_profile_bindings'), 'common actual profile bindings')
    schedules = existing.task_map(trace.get('task_schedule'), 'common production schedule')
    facts = existing.task_map(source_facts.get('tasks'), 'independent source facts', 'task_name')
    require(all(set(table) == set(tasks) for table in (source_rows, original, costs, bindings, schedules, facts)),
            'source/mapper/cost/schedule task coverage differs')
    dependencies = source_facts.get('dependencies')
    require(source_facts.get('function') == result['function'] and isinstance(dependencies, list) and
            all(type(edge.get('payload_bits')) is int and edge['payload_bits'] >= 0
                for edge in dependencies if edge.get('kind') in ('raw', 'value')),
            'independent source graph identity or payload proof differs')
    dispatch = result['dispatch_order']
    require(len(source_dispatch) == len(tasks) and set(source_dispatch) == set(tasks) and
            len(dispatch) == len(tasks) and set(dispatch) == set(tasks), 'dispatch task coverage differs')
    intervals, cells, occupancy = {}, {}, {}
    for name in tasks:
        source, cost, bound, schedule = source_rows[name], costs[name], bindings[name], schedules[name]
        existing._original_replica_geometry(source, original[name], name, allow_omitted_singleton_replicas=True)
        require(source.get('dispatch_index') == source_dispatch.index(name), name + ': original dispatch index differs')
        shape, active = source['composed_cgra_shape'], source['active_replicas']
        require(shape in profile_rows[name] and type(active) is int and active > 0, name + ': selected mapper orientation missing')
        profile = profile_rows[name][shape]
        trip = tasks[name]['sample_trip_count']
        full = profile['estimated_latency']
        duration = (full + active - 1) // active
        require(source.get('duration') == duration and
                bound.get('f45_source_scheduler_duration_cycles') == duration and
                cost.get('f45_source_scheduler_duration_cycles') == duration,
                name + ': preserved F45 duration differs from selected common parent/N cost')
        require(bound.get('schema') == BINDING_SCHEMA and bound.get('current_ir_wrapper_exact_match_verified') is True and
                bound.get('mapper_succeeded') is True and bound.get('static_trip_count') == trip and
                bound.get('pre_mapper_wrapper_bytes') == profile['pre_mapper_wrapper_bytes'] and
                bound.get('pre_mapper_wrapper_byte_count') == profile['pre_mapper_wrapper_byte_count'],
                name + ': raw current mapper wrapper or firing count differs')
        for key in ('compiled_ii', 'steps', 'sample_trip_count', 'materialized_operation_count', 'structural_startup_cycles',
                    'source_iteration_domain_status', 'source_iteration_domain_complete', 'source_iteration_work_count'):
            require(bound.get(key) == profile.get(key), name + ': bound profile ' + key + ' differs')
        require(bound.get('common_parent_full_mapped_duration_cycles') == full and
                bound.get('mapped_duration_cycles') == duration and bound.get('original_active_replicas') == active and
                bound.get('selected_profile_shape') == shape and bound.get('selected_cgra_count') == profile['composed_cgra_count'] and
                (bound.get('selected_mapper_tile_rows'), bound.get('selected_mapper_tile_cols')) == (profile['mapper_tile_rows'], profile['mapper_tile_cols']),
                name + ': parent/N mapped duration or selected shape differs')
        require(cost.get('trip_count') == trip and cost.get('profile_compiled_ii') == profile['compiled_ii'] and
                cost.get('structural_startup_cycles') == profile['structural_startup_cycles'] and
                cost.get('full_parent_mapped_duration_cycles') == full and cost.get('mapped_duration_cycles') == duration,
                name + ': actual mapper cost differs')
        for key in ('source_iteration_domain_status', 'source_iteration_domain_complete', 'source_iteration_work_count'):
            require(facts[name].get(key) == tasks[name].get(key), name + ': independently extracted source domain differs')
        cg_rows, cg_cols = existing.shape_dims(shape, name + '.selected_shape')
        positions = existing._validate_production_scheduler_task_cells(schedule, name, cg_rows, cg_cols, profile['composed_cgra_count'], active)
        start = existing.require_int(schedule.get('start_cycle'), name + '.start', 0)
        end = existing.require_int(schedule.get('end_cycle'), name + '.end', 1)
        require(end - start == duration == schedule.get('duration_cycles'), name + ': native scheduled duration differs')
        intervals[name] = (start, end)
        cells[name] = {(cell['row'], cell['col']) for cell in positions}
        for cell in cells[name]:
            occupancy.setdefault(cell, []).append((start, end))
    for uses in occupancy.values():
        uses.sort()
        require(all(a[1] <= b[0] for a, b in zip(uses, uses[1:])), 'common production CGRA occupancy overlaps')
    cycles = max(end for _, end in intervals.values())
    require(cycles == result.get('mapped_whole_program_cycles') == result.get('predicted_whole_program_cycles'), 'common actual makespan differs')
    communication = existing._validate_expanded_communication_trace(
        result, trace, dispatch, intervals, cells, existing.parse_inter_task_network(network_text), architecture_text,
        result['graph_variant_id'], result['function'], '', set(), 0, source_dispatch, source_facts['dependencies'])
    return {'schema': 'orbit-common-amoeba-retiming-validation-v1', 'status': 'pass',
            'mapped_whole_program_cycles': cycles, 'task_count': len(tasks),
            'dependency_count': communication['dependency_count'], 'routed_data_pairs': communication['routed_data_pairs'],
            'common_raw_mapper_profile_binding': 'pass', 'independent_source_domain_and_network_trace': 'pass',
            'replica_timing_policy': REPLICA_POLICY, 'formal_go': False}

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('original-mlir', 'result', 'profiles', 'source-facts', 'architecture', 'network', 'output'):
        parser.add_argument('--' + name, type=Path, required=True)
    args = parser.parse_args()
    try:
        value = validate(args.original_mlir.read_text(), json.loads(args.result.read_text()),
                         json.loads(args.profiles.read_text()), json.loads(args.source_facts.read_text()),
                         args.architecture.read_text(), args.network.read_text())
    except (OSError, ValueError, KeyError, TypeError) as error:
        value = {'schema': 'orbit-common-amoeba-retiming-validation-v1', 'status': 'fail', 'error': str(error)}
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(value, indent=2) + '\n')
    print(json.dumps(value))
    return int(value['status'] != 'pass')

if __name__ == '__main__':
    raise SystemExit(main())
