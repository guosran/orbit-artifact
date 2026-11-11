#!/usr/bin/env python3
"""Freeze one protocol per arithmetic program from deduplicated actual packages."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys


def identity(path):
    path = Path(path).resolve()
    return dict(path=str(path), sha256=hashlib.sha256(path.read_bytes()).hexdigest())


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--compiled-index', type=Path, required=True)
    parser.add_argument('--experiment-protocol', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output = args.output.resolve()
    args.output.mkdir(parents=True, exist_ok=False)
    compiled = json.loads(args.compiled_index.read_text())
    grouped = {}
    for case in compiled['cases']:
        grouped.setdefault(case['program'], []).append(case)
    records = []
    for program, cases in sorted(grouped.items()):
        baseline_names = {alias['actual_package'] for alias in compiled['aliases']
                          if alias['program'] == program and alias['label'] == 'baseline'}
        assert len(baseline_names) == 1
        baseline = next(case for case in cases if case['id'] in baseline_names)
        alternatives = sorted((case for case in cases if case != baseline), key=lambda case: case['id'])
        batches = [alternatives[i:i+7] for i in range(0, len(alternatives), 7)] or [[]]
        for batch_number, alternatives in enumerate(batches):
            selected = [baseline]+alternatives
            name = program+'-batch-'+str(batch_number)
            protocol = args.output/(name+'.json')
            command = [sys.executable, str(Path(__file__).with_name('taskflow_data_reuse_probe_v21.py'))]
            for case in selected:
                command += ['--case', case['prepared'], case['compiled']]
            command += ['--freeze', str(protocol), '--seeds', '11', '23', '47',
                        '--warmups', '1', '--repeats', '5', '--poll-us', '20']
            (args.output/(name+'.command.json')).write_text(json.dumps(command, indent=2)+'\n')
            with (args.output/(name+'.log')).open('w') as log:
                subprocess.run(command, stdout=log, stderr=subprocess.STDOUT, check=True)
            records.append(dict(program=program, batch=batch_number, cases=len(selected), protocol=identity(protocol),
                                baseline_control=baseline['id'], expected_calls_per_session=18*len(selected)))
    receipt = dict(status='PASS', device_submissions=0,
                   experiment_protocol=identity(args.experiment_protocol),
                   compiled_index=identity(args.compiled_index),
                   wrapper=identity(Path(__file__).with_name('taskflow_data_reuse_probe_v21.py')),
                   protocols=records,
                   observation='Two fresh locked process sessions per protocol, alternating forward/reverse order, same inputs and unchanged tolerance; one label per actual implementation. At most8contexts per batch, sorted actual package IDs, baseline repeats only as an explicitly identical control across batches. Cross-batch times are not paired algorithm comparisons.')
    (args.output/'index.json').write_text(json.dumps(receipt, indent=2)+'\n')
    print(json.dumps(receipt))


if __name__ == '__main__':
    main()
