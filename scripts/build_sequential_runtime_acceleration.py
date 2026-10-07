#!/usr/bin/env python3
"""Rebuild only the changed search pass, preserving a compatible baseline build."""
import argparse
import hashlib
import json
from pathlib import Path
import shlex
import shutil
import subprocess
import time

CPP = 'lib/Backend/Neura/Orchestration/JointScheduling/JointNeighborhoodSearchPass.cpp'
LIB = 'lib/Backend/Neura/Orchestration/JointScheduling/libMLIRAmoebaNeuraJointScheduling.a'
TARGET = 'tools/mlir-amoeba-opt/mlir-amoeba-opt'


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--baseline-build', type=Path, required=True)
    p.add_argument('--source-root', type=Path, required=True)
    p.add_argument('--work-dir', type=Path, required=True)
    p.add_argument('--optimizer', type=Path, required=True)
    a = p.parse_args()
    build, source, work, optimizer = (v.resolve() for v in
        (a.baseline_build, a.source_root, a.work_dir, a.optimizer))
    if optimizer.exists():
        raise ValueError('use a fresh optimizer pin; existing pins are immutable')
    cache = (build / 'CMakeCache.txt').read_text().splitlines()
    original_source = Path(next(x.split('=', 1)[1] for x in cache
                                if x.startswith('CMAKE_HOME_DIRECTORY:')))
    # Reusing other objects requires unchanged source/header bytes. Include
    # generated sources from the baseline build unchanged in compiler argv.
    different = []
    for path in original_source.rglob('*'):
        relative = path.relative_to(original_source)
        if path.is_file() and path.suffix in ('.cpp', '.h', '.td', '.inc'):
            target = source / relative
            if not target.is_file() or target.read_bytes() != path.read_bytes():
                different.append(str(relative))
    if different != [CPP] and sorted(different) != [CPP]:
        raise ValueError(f'baseline object reuse requires only the search CPP to differ: {different}')
    commands = subprocess.check_output(['ninja', '-C', str(build), '-t', 'commands', TARGET], text=True).splitlines()
    compile_line = next(x for x in commands if CPP in x and ' -c ' in x)
    compile_argv = [x.replace(str(original_source), str(source)) for x in shlex.split(compile_line)]
    work.mkdir(parents=True, exist_ok=True)
    optimizer.parent.mkdir(parents=True, exist_ok=True)
    obj = work / 'JointNeighborhoodSearchPass.cpp.o'
    for key, value in (('-o', str(obj)), ('-MF', str(obj) + '.d'), ('-MT', str(obj))):
        compile_argv[compile_argv.index(key) + 1] = value
    compile_argv.append('-g0')  # Debug information does not affect search behavior.
    library = work / 'libMLIRAmoebaNeuraJointScheduling.a'
    shutil.copyfile(build / LIB, library)
    subprocess.run(['strip', '--strip-debug', str(library)], check=True)
    started = time.time()
    print('Compile accelerated search pass', flush=True)
    subprocess.run(compile_argv, cwd=build, check=True)
    subprocess.run(['ar', 'r', str(library), str(obj)], check=True)
    tokens = shlex.split(commands[-1])
    begin = tokens.index('&&') + 1 if '&&' in tokens else 0
    end = tokens.index('&&', begin) if '&&' in tokens[begin:] else len(tokens)
    link_argv = [str(library) if x == LIB else x for x in tokens[begin:end]]
    if str(library) not in link_argv:
        raise ValueError('link command does not reference the expected search archive')
    link_argv[link_argv.index('-o') + 1] = str(optimizer)
    link_argv.append('-Wl,--strip-debug')
    print('Link accelerated immutable pin', flush=True)
    subprocess.run(link_argv, cwd=build, check=True)
    optimizer.chmod(0o555)
    record = {'schema': 'orbit-runtime-acceleration-build-v1',
        'baseline_build': str(build), 'source_root': str(source),
        'source_files_changed': different, 'compile_argv': compile_argv,
        'link_argv': link_argv, 'baseline_build_modified': False,
        'optimizer': str(optimizer), 'optimizer_sha256': hashlib.sha256(optimizer.read_bytes()).hexdigest(),
        'optimizer_bytes': optimizer.stat().st_size, 'wall_seconds': time.time() - started}
    (optimizer.parent.parent / 'build-provenance.json').write_text(json.dumps(record, indent=2) + '\n')
    print(json.dumps({k: v for k, v in record.items() if k not in ('compile_argv', 'link_argv')}))


if __name__ == '__main__':
    main()
