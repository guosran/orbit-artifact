#!/usr/bin/env python3
"""Prepare preregistered whole-program inputs and independent references only.

The supplied matrix declares experimental cells, never a production plan. Native
C++ search must generate and check each cell before compilation or measurement.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'python'))
from taskflow_paths import ORBIT_SRC, ARTIFACT_REPO, test_path


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def save(path, value):
    Path(path).write_text(json.dumps(value, indent=2, sort_keys=True, allow_nan=False)+'\n')


def validate(matrix):
    if matrix.get('schema') != 'orbit.implementation-search.matrix.v10':
        raise ValueError('explicit v10 matrix schema required')
    if matrix.get('status') != 'preregistered':
        raise ValueError('draft matrices must not be sealed as preregistered')
    if matrix.get('seeds') != [11, 23, 47]:
        raise ValueError('this protocol fixes three seeds before measurement')
    if matrix.get('timing') != {'observer': 'detailed', 'warmups': 2, 'hot': 5}:
        raise ValueError('fixed prepared-command detailed-observer protocol required')
    if matrix.get('boundary') != 'prepared-command-host-to-host':
        raise ValueError('explicit whole-command boundary required')
    if not matrix.get('model_protocol'):
        raise ValueError('model terms/objective/domain protocol must be declared before timing')
    names = set()
    shapes = {}
    for program in matrix['programs']:
        name = program['id']
        if not re.fullmatch('[A-Za-z0-9_-]+', name) or name in shapes:
            raise ValueError('unique safe program IDs required')
        shape = tuple(program[k] for k in ('m', 'k', 'n'))
        if any(isinstance(v, bool) or not isinstance(v, int) or v <= 0 for v in shape):
            raise ValueError('positive integer program dimensions required')
        shapes[name] = shape
    coordinates = set()
    splits = set()
    for cell in matrix['cells']:
        if cell['program'] not in shapes or not re.fullmatch('[A-Za-z0-9_-]+', cell['name']) or cell['name'] in names:
            raise ValueError('unique cell name and declared program required')
        names.add(cell['name'])
        if cell['split'] not in ('train', 'holdout', 'negative'):
            raise ValueError('explicit train/holdout/negative split required')
        splits.add(cell['split'])
        tiles = cell['tile_sizes']
        if len(tiles) != 3 or any(isinstance(v, bool) or not isinstance(v, int) or v <= 0 for v in tiles):
            raise ValueError('three positive tile coordinates required')
        if cell['implementation'] not in ('scalar:1', 'scalar-product-vector-add-f32:8'):
            raise ValueError('only explicitly supported FP32 implementations are declared')
        if cell['data_organization'] not in ('phase-local', 'storage1-panel'):
            raise ValueError('explicit experimental data-organization coordinate required')
        coordinate = (shapes[cell['program']], tuple(tiles), cell['implementation'], cell['data_organization'])
        if coordinate in coordinates:
            raise ValueError('duplicate execution coordinate or train/holdout leakage')
        coordinates.add(coordinate)
    if not {'train', 'holdout'} <= splits:
        raise ValueError('training and predeclared holdout both required')
    return matrix


def cgra_identity(models):
    # Existing four-model provenance is checked, never retrained or reserialized.
    provenance = ROOT/'test/TaskflowMapping/fixtures/compute-contract-baseline-v8.provenance.json'
    expected = json.loads(provenance.read_text())['model_sha256']
    actual = {name: sha(models/name) for name in expected}
    if actual != expected:
        raise ValueError('existing CGRA model differs from delivered baseline provenance')
    return dict(provenance_path=str(provenance), provenance_sha256=sha(provenance),
                models=str(models), model_sha256=actual,
                scope='existing model-file identity only; scorer regression is a separate CPU gate')


def prepare(matrix_path, output, models):
    matrix_path = matrix_path.resolve()
    matrix = validate(json.loads(matrix_path.read_text()))
    cgra = cgra_identity(models)
    output.mkdir(parents=True, exist_ok=False)
    (output/'matrix.json').write_bytes(matrix_path.read_bytes())
    (output/'preparer-source.py').write_bytes(Path(__file__).read_bytes())
    generator = ROOT/'test/TaskflowAIR/prepare_program_mapping_v7.py'
    fixture = test_path('test/TaskflowAIR/fixtures/gemm-scale.mlir')
    records = []
    for program in matrix['programs']:
        directory = output/'inputs'/program['id']
        command = [sys.executable, str(generator), '--m', str(program['m']), '--k', str(program['k']),
                   '--n', str(program['n']), '--output', str(directory)]
        result = subprocess.run(command, capture_output=True, text=True)
        save(output/(program['id']+'.prepare-command.json'), dict(argv=command, returncode=result.returncode,
             generator_sha256=sha(generator), stdout=result.stdout, stderr=result.stderr))
        if result.returncode:
            raise ValueError('reference preparation failed: '+program['id'])
        records.append(dict(program=program['id'], files={str(p.relative_to(output)): sha(p)
                            for p in sorted(directory.iterdir()) if p.is_file()}))
    if cgra_identity(models) != cgra:
        raise ValueError('CGRA files changed during preparation')
    record = dict(schema='orbit.implementation-search.preregistration.v10', status='prepared-before-timing',
                  matrix_sha256=sha(output/'matrix.json'), preparer_sha256=sha(output/'preparer-source.py'),
                  generator_sha256=sha(generator), core_fixture=dict(path=str(fixture),sha256=sha(fixture)),
                  programs=records,cgra=cgra,timing_labels_read=False,device_submissions=0,
                  planning='none; original C++ archive must generate every declared candidate',
                  heldout_policy='no holdout measurement or labels until model and predictions are frozen')
    save(output/'preregistration.json',record)
    return record


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--matrix', type=Path, required=True, help='explicit final preregistered matrix JSON')
    parser.add_argument('--output', type=Path, required=True, help='new directory')
    parser.add_argument('--models', type=Path, default=ARTIFACT_REPO/'reference/input0-neighborhood/models')
    args = parser.parse_args()
    record = prepare(args.matrix, args.output.resolve(), args.models.resolve())
    print(json.dumps(dict(status=record['status'],device_submissions=0,timing_labels_read=False)))


if __name__ == '__main__':
    main()
