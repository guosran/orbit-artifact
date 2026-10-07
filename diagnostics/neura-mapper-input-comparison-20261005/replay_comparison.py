#!/usr/bin/env python3
"""Cross two pre-mapper input graphs with the corresponding Neura compilers."""
import argparse
import json
from pathlib import Path
import re
import subprocess

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--f45-optimizer', type=Path, required=True)
parser.add_argument('--orbit-optimizer', type=Path, required=True)
parser.add_argument('--architecture', type=Path, required=True)
parser.add_argument('--output', type=Path, required=True)
args = parser.parse_args()
args.output.mkdir(parents=True, exist_ok=False)
root = Path(__file__).resolve().parent
results = []
for frontend in ['amoeba', 'orbit']:
    for compiler, binary in [('f45', args.f45_optimizer), ('orbit', args.orbit_optimizer)]:
        mapped = args.output / f'{frontend}-with-{compiler}.mlir'
        log = args.output / f'{frontend}-with-{compiler}.log'
        argv = ['taskset', '--cpu-list', '0', str(binary.resolve()),
                str(root / f'{frontend}-harris-task1-premapper.mlir'),
                '--verify-each=false', '--architecture-spec=' + str(args.architecture.resolve()),
                '--map-to-accelerator=x-tiles=2 y-tiles=2 dump-mapping-table=false',
                '-o', str(mapped.resolve())]
        with log.open('w') as stream:
            process = subprocess.run(argv, stdout=stream, stderr=subprocess.STDOUT)
        text = mapped.read_text() if mapped.is_file() else ''
        match = re.search(r'compiled_ii = (\d+) : i32', text)
        results.append({'frontend': frontend, 'compiler': compiler, 'argv': argv,
                        'exit_code': process.returncode, 'ii': int(match[1]) if match else None})
(args.output / 'results.json').write_text(json.dumps(results, indent=2) + '\n')
if [(row['exit_code'], row['ii']) for row in results] != [(0, 10), (0, 10), (0, 7), (0, 7)]:
    raise SystemExit('crossed comparison differs; inspect recorded logs and compiler provenance')
print(json.dumps(results, indent=2))
