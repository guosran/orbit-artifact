#!/usr/bin/env python3
"""Fresh numerical fixtures → original C++ four-policy search → actual compile/freeze."""
import argparse
import json
from pathlib import Path
import subprocess
import sys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ['core-tool', 'air-tool', 'config', 'output']:
        parser.add_argument('--'+name, type=Path, required=True)
    args = parser.parse_args()
    args.output = args.output.resolve()
    args.output.mkdir(parents=True, exist_ok=False)
    scripts = Path(__file__).resolve().parent
    orbit = scripts.parents[1].parent/'orbit'

    def run(name, command):
        command = list(map(str, command))
        (args.output/(name+'.command.json')).write_text(json.dumps(command, indent=2)+'\n')
        with (args.output/(name+'.log')).open('w') as log:
            result = subprocess.run(command, stdout=log, stderr=subprocess.STDOUT)
        (args.output/(name+'.result.json')).write_text(json.dumps(dict(
            returncode=result.returncode, device_submissions=0))+'\n')
        assert result.returncode == 0, name

    fixtures = []
    for kind in ['interleaved', 'shared-input']:
        fixture = args.output/f'fixture-{kind}-r1'
        run('prepare-'+kind, [sys.executable, scripts.parent/'test/TaskflowAIR/prepare_data_reuse_v20.py',
            '--kind', kind, '--output', fixture])
        fixtures.append(fixture)
    comparison = args.output/'comparison-r1'
    run('comparison', ['/usr/bin/python3', orbit/'test/TaskflowGeneric/data_reuse_search_v20.py',
        '--tool', args.core_tool, '--config', args.config, '--output', comparison,
        '--source', fixtures[0]/'source.mlir', '--source', fixtures[1]/'source.mlir',
        '--tile-m', '12', '--tile-n', '136', '--max-candidates', '96', '--beam-width', '2'])
    for case, kind in enumerate(['interleaved', 'shared-input']):
        compiled = args.output/f'compiled-{kind}-r1'
        run('compile-'+kind, [sys.executable, scripts/'compile_data_reuse_study_v20.py',
            '--comparison', comparison, '--air-tool', args.air_tool,
            '--case', str(case), '--output', compiled])
        cases = json.loads((compiled/'compiled/index.json').read_text())['cases']
        freeze_args = []
        for row in cases:
            freeze_args += ['--case', row['prepared'], row['compiled']]
        run('freeze-'+kind, [sys.executable, scripts/'taskflow_data_reuse_probe_v20.py',
            '--freeze', args.output/f'freeze-{kind}-r1/protocol.json',
            '--seeds', '11', '23', '47', '--warmups', '1', '--repeats', '5',
            '--poll-us', '20', *freeze_args])
    (args.output/'result.json').write_text(json.dumps(dict(status='PASS', device_submissions=0,
        scope='Actual C++ two-round searches, four policies, strict unknowns/checkpoints; actual AIR/AIE checks and full graph/plan equality, frozen observations pending'), indent=2)+'\n')
    print(json.dumps(dict(status='PASS', output=str(args.output), device_submissions=0)))


if __name__ == '__main__':
    main()
