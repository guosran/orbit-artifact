#!/usr/bin/env python3
"""Take one read-only /proc snapshot of the frozen GCN Tiling optimizer."""
import argparse
import datetime
import hashlib
import json
import os
from pathlib import Path

R = Path(__file__).resolve().parent
B = R / 'diagnosis/search-regression-repair-20261010'
SOURCE = '76345481683a2e199c0cad155de2acb51149f350'
OPT = '9996d1b97787242cea42d88511ce530bfa4cb523883705b0746a72a1ff17d7cc'
CPP = '47be60517ee87d6bd3dd901f2d6ecc6377ae4852173e361e48a9acc09d68db25'


def sha(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as stream:
        for chunk in iter(lambda: stream.read(4 << 20), b''):
            h.update(chunk)
    return h.hexdigest()


def write_new(path, value):
    with path.open('x') as stream:
        json.dump(value, stream, indent=2)
        stream.write('\n')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--pid', type=int, required=True)
    parser.add_argument('--start', required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    assert not args.output.exists()
    compiler = R / 'binaries/mlir-amoeba-opt-9996d1b97787242c'
    cpp = R / 'directional-critical-positive-compute-source/lib/Backend/Neura/Orchestration/JointScheduling/JointNeighborhoodSearchPass.cpp'
    launch = B / 'critical-positive-compute-v38-tiling256-continuation1/supervisor-launch.json'
    inputs = {str(path): sha(path) for path in (compiler, cpp, launch, Path(__file__).resolve())}
    assert inputs[str(compiler)] == OPT and inputs[str(cpp)] == CPP
    proc = Path('/proc') / str(args.pid)
    before = (proc / 'stat').read_text().rsplit(')', 1)[1].split()
    argv = [x.decode() for x in (proc / 'cmdline').read_bytes().split(b'\0') if x]
    assert Path(argv[0]).resolve() == compiler.resolve()
    assert before[19] == args.start and before[0] != 'Z'
    assert any('critical-positive-compute-v38-tiling256-continuation1/runs/b256/gcn/tiling' in value for value in argv)
    io = {name: int(value) for name, value in
          (line.split(':', 1) for line in (proc / 'io').read_text().splitlines())}
    after = (proc / 'stat').read_text().rsplit(')', 1)[1].split()
    assert before[19] == after[19] == args.start and after[0] != 'Z'
    report = {
        'schema': 'orbit-v38-gcn-process-io-single-snapshot-v1',
        'status': 'pass-readonly', 'source_commit': SOURCE,
        'optimizer_sha256': OPT, 'pid': args.pid,
        'process_start_ticks': args.start,
        'timestamp_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
        'state': after[0], 'argv_sha256': hashlib.sha256('\0'.join(argv).encode()).hexdigest(),
        'raw_process_io_counters': io,
        'user_cpu_ticks': int(after[11]), 'system_cpu_ticks': int(after[12]),
        'cpu_ticks_per_second': os.sysconf('SC_CLK_TCK'),
        'resident_bytes_at_snapshot': int(after[21]) * os.sysconf('SC_PAGE_SIZE'),
        'scope': 'One live optimizer process observed once; no journal, checkpoint or model contents read. No suspension or experiment launch.',
        'interpretation': 'Raw kernel counters are not per-file attribution, a CPU profile, remaining runtime, a whole-pipeline total or a measured optimization speedup.',
        'additional_objective_calls': 0, 'additional_native_calls': 0,
        'additional_numeric_calls': 0, 'input_sha256': inputs,
    }
    assert all(sha(path) == expected for path, expected in inputs.items())
    args.output.mkdir(parents=True)
    write_new(args.output / 'REPORT.json', report)
    write_new(args.output / 'FINAL.json', {
        'status': 'pass', 'input_pre_post_verified': True, 'input_sha256': inputs,
        'report_sha256': sha(args.output / 'REPORT.json'),
        'additional_objective_calls': 0, 'additional_native_calls': 0,
        'additional_numeric_calls': 0,
    })
    print(json.dumps({'status': 'pass', 'report': str(args.output / 'REPORT.json'),
                      'report_sha256': sha(args.output / 'REPORT.json'),
                      'final_sha256': sha(args.output / 'FINAL.json'),
                      'raw_process_io_counters': io}, indent=2))


if __name__ == '__main__':
    main()
