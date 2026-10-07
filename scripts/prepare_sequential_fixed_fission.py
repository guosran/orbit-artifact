#!/usr/bin/env python3
"""Refresh costs and source witnesses without changing the fixed input programs."""
import argparse
import json
from pathlib import Path
import shutil
import time

import prepare_input0_source_domains as preparation
import run_sequential_comparison as comparison


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--runtime-root', type=Path, required=True)
    parser.add_argument('--original-input-root', type=Path, required=True)
    parser.add_argument('--output-root', type=Path, required=True)
    args = parser.parse_args()
    runtime, original, output = (p.resolve() for p in (
        args.runtime_root, args.original_input_root, args.output_root))
    if output.exists():
        raise ValueError('fresh preparation namespace required')
    output.mkdir(parents=True)
    optimizer = runtime / 'bin/mlir-amoeba-opt'
    original_artifact = original.parents[2]
    old_config = comparison.read(original / 'input0-chain.json')
    config = {'defaults': {}, 'workloads': {}}
    bindings = []
    started = time.monotonic()
    for workload in (*comparison.WORKLOADS, 'raytracing'):
        old = original / workload
        dest = output / workload
        dest.mkdir()
        canonical = dest / 'canonical.mlir'
        shutil.copyfile(old / 'canonical.mlir', canonical)
        command_paths = []
        function = None
        for label in ('facts', 'verify-source-domain', 'enumerate-candidate-space', 'predict-cost-catalog'):
            record = comparison.read(old / 'steps' / (label + '.command.json'))
            argv = [str(optimizer), *record['argv'][1:]]
            argv = [word.replace(str(old), str(dest))
                    .replace(str(original_artifact / 'config'), str(runtime / 'config'))
                    .replace(str(original_artifact / 'reference/input0-neighborhood/models'),
                             str(runtime / 'reference/input0-neighborhood/models')) for word in argv]
            # Old records may refer to the original artifact, whereas this
            # script runs in an isolated frozen runtime.
            for word in argv:
                if word.startswith('--extract-joint-task-graph-facts='):
                    function = word.split('function=', 1)[1].split()[0]
            preparation.invoke(argv, dest, label)
            command_paths.append(str(dest / 'steps' / (label + '.command.json')))
        entry = {**old_config.get('defaults', {}), **old_config['workloads'][workload]}
        configured_function = entry.get('function', function)
        if not function or function != configured_function:
            raise ValueError('function binding differs: ' + workload)
        new_entry = {'canonical': str(canonical), 'parent_cost_file': str(dest / 'cost-catalog.json'),
                     'cost_cache': str(dest / 'ml-cache.json'), 'function': function}
        if workload in comparison.WORKLOADS:
            shaped = old / 'taskflow-affine-noalias-shaped.mlir'
            prepared = dest / 'prepared-source.mlir'
            architecture = runtime / 'config/architectures/amoeba_4x4_cgra_2x2_context6.yaml'
            preparation.invoke([str(optimizer), str(shaped), '--verify-each', '--mlir-print-op-generic',
                '--architecture-spec=' + str(architecture), '--construct-hyperblock-from-task',
                '--classify-task-and-counter', '-o', str(prepared)], dest, 'prepare-fission-source')
            preparation.invoke([str(optimizer), str(prepared), '--verify-each',
                '--verify-taskflow-fission-source-replay=' + ' '.join((
                    'enumerate-function=' + function, 'max-fission-actions-per-task=64',
                    'output=' + str(dest / 'cut-census.json'))), '-o', '/dev/null'], dest, 'fission-cut-census')
            new_entry['prepared_source_file'] = str(prepared)
        config['workloads'][workload] = new_entry
        if canonical.read_bytes() != (old / 'canonical.mlir').read_bytes():
            raise ValueError('canonical bytes changed: ' + workload)
        bindings.append({'workload': workload, 'canonical': comparison.file_binding(canonical),
            'original_canonical': comparison.file_binding(old / 'canonical.mlir'),
            'original_catalog_reused': False, 'original_predictor_cache_reused': False,
            'steps': [comparison.file_binding(p) for p in sorted((dest / 'steps').glob('*.command.json'))]})
    comparison.replay.atomic_write(output / 'input0-chain.json', config)
    comparison.replay.atomic_write(output / 'preparation-binding.json', {
        'schema': 'orbit-fixed-trunk-sequential-fission-preparation-v1',
        'wall_seconds': time.monotonic() - started, 'inputs': bindings,
        'optimizer': comparison.file_binding(optimizer), 'training_or_calibration': False,
        'ray_policy': 'fresh II20 catalog; original Ray exclusion, no substitute program'})
    print(json.dumps({'status': 'prepared', 'config': str(output / 'input0-chain.json'),
                      'wall_seconds': time.monotonic() - started}), flush=True)


if __name__ == '__main__':
    main()
