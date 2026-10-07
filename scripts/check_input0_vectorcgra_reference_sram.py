#!/usr/bin/env python3
"""Evaluate closed input0 native plans against the measured reference banks."""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]

def read(path):
    return json.loads(path.read_text())

def write(path, value):
    temporary = path.with_suffix('.partial')
    temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')
    temporary.replace(path)

def plans(baseline_root, stage_root, common_amoeba_root=None):
    for workload in ('gcn', 'harris', 'llama', 'lu', 'radar'):
        if common_amoeba_root is not None:
            common = common_amoeba_root / workload / 'result.json'
            if common.is_file():
                result = read(common)
                if result.get('status') == 'native_replayed' and all(
                        result.get(key) == 'pass' for key in ('numeric', 'mapper', 'trace')):
                    yield workload, 'common-amoeba', Path(result['native_mlir']), result['optimizer']
        baseline = baseline_root / workload
        if (baseline / 'result.json').is_file():
            result = read(baseline / 'result.json')
            if result.get('status') == 'complete' and all(
                    result.get(key) == 'pass' for key in ('numeric', 'mapper_equality', 'independent_trace')):
                yield workload, 'fixed1x1', baseline / 'native/rank-0/native.mlir', result['optimizer']
        stage = stage_root / workload / 'full-joint'
        if not (stage / 'winner.json').is_file() or not (stage / 'result.json').is_file():
            continue
        result, winner = read(stage / 'result.json'), read(stage / 'winner.json')
        if result.get('status') != 'native_replayed' or result.get('numeric') != 'pass':
            continue
        for kind in ('native-top5', 'native-controls'):
            summary = stage / kind / 'summary.json'
            if not summary.is_file():
                continue
            for row in read(summary).get('records', []):
                if row.get('candidate_id') != winner.get('candidate_id'):
                    continue
                if row.get('status') == 'native_replayed' and all(
                        row.get(key) == 'pass' for key in ('numeric', 'mapper_equality', 'independent_trace')):
                    yield workload, 'full-joint', stage / kind / ('rank-' + str(row['rank'])) / 'native.mlir', row['native_command']['argv'][0]

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--baseline-root', type=Path, required=True)
    parser.add_argument('--stage-root', type=Path, required=True)
    parser.add_argument('--common-amoeba-root', type=Path)
    parser.add_argument('--output-root', type=Path, required=True)
    parser.add_argument('--capacity-config', type=Path, default=ROOT / 'config/architectures/vectorcgra_4x4_cgra_2x2_reference_sram_128.json')
    parser.add_argument('--architecture', type=Path, default=ROOT / 'config/architectures/amoeba_4x4_cgra_2x2_context6.yaml')
    args = parser.parse_args()
    config = read(args.capacity_config)
    measurement = read(ROOT / config['elaboration_evidence'])
    capacity = config['per_cgra_capacity_bytes']
    if config['schema'] != 'orbit-vectorcgra-sram-configuration-v1' or config.get('capacity_status') != 'measured-reference-instance':
        raise ValueError('expected a measured reference-instance capacity configuration')
    if capacity != measurement['payload_capacity_bytes_per_cgra'] or capacity != config['num_banks_per_cgra'] * config['data_mem_size_per_bank_entries'] * config['payload_bits_per_entry'] // 8:
        raise ValueError('capacity disagrees with elaborated bank payload')
    if (config['fabric_rows'], config['fabric_columns'], config['per_cgra_tile_rows'], config['per_cgra_tile_columns']) != (4, 4, 2, 2):
        raise ValueError('reference instance has the wrong fabric/tile geometry')
    args.output_root.mkdir(parents=True, exist_ok=True)
    records = []
    for workload, label, native, optimizer in plans(args.baseline_root, args.stage_root, args.common_amoeba_root):
        directory = args.output_root / workload / label
        directory.mkdir(parents=True, exist_ok=True)
        evidence = directory / 'capacity-gate.json'
        argv = [optimizer, str(native), '--verify-each', '--architecture-spec=' + str(args.architecture),
                '--verify-production-sram-native-capacity-gate=capacity-bytes-per-cgra={} grid-rows=4 grid-columns=4 output={}'.format(capacity, evidence),
                '-o', os.devnull]
        command = {'argv': argv, 'started_utc': datetime.now(timezone.utc).isoformat(),
                   'status': 'running', 'subprocess_timeout': None}
        write(directory / 'command.json', command)
        with (directory / 'stdout.log').open('w') as stdout, (directory / 'stderr.log').open('w') as stderr:
            code = subprocess.run(argv, cwd=ROOT, stdout=stdout, stderr=stderr).returncode
        command.update(status='finished', exit_code=code, ended_utc=datetime.now(timezone.utc).isoformat())
        write(directory / 'command.json', command)
        record = {'workload': workload, 'plan': label, 'native': str(native), 'exit_code': code,
                  'evidence': str(evidence), 'configuration_scope': config['configuration_scope'], 'formal_go': False}
        if code == 0 and evidence.is_file():
            gate = read(evidence)
            record.update(status=gate['status'], reason=gate['reason'],
                          conservative_upper_bound_bytes_by_cgra=gate['conservative_upper_bound_bytes_by_cgra'],
                          actual_overflow_proven=gate['actual_overflow_proven'])
        else:
            record.update(status='process-failed', reason='see recorded stderr')
        records.append(record)
    summary = {'schema': 'orbit-input0-vectorcgra-reference-sram-v1', 'capacity_config': str(args.capacity_config),
               'per_cgra_payload_bytes': capacity, 'fabric_payload_bytes': capacity * 16,
               'configuration_scope': config['configuration_scope'], 'formal_go': False,
               'target_amoeba_capacity_status': 'unestablished', 'records': records}
    write(args.output_root / 'summary.json', summary)
    print(json.dumps({key: value for key, value in summary.items() if key != 'records'}))
    for row in records:
        print('{} {}: {}'.format(row['workload'], row['plan'], row['status']))
    return int(any(row['exit_code'] != 0 for row in records))

if __name__ == '__main__':
    raise SystemExit(main())
