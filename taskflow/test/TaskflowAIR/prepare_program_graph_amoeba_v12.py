#!/usr/bin/env python3
"""Prepare exact plain Core add-scale source and independent FP64 references.

No mapping decisions, generated backend kernels, models, or planning occur here.
"""
import argparse
import hashlib
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / 'python'))
from taskflow_paths import ORBIT_SRC


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', type=Path, default=ORBIT_SRC/'test/TaskflowAIR/fixtures/add-scale.mlir')
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--seeds', type=int, nargs='+', default=[11, 23, 47])
    args = parser.parse_args()
    import numpy as np
    out = args.output.resolve()
    out.mkdir(parents=True, exist_ok=False)
    source = args.source.resolve()
    # Exact fixed fixture, rather than silently assigning references to another
    # source. Native source/graph checks remain separate in the compiler tests.
    expected = ORBIT_SRC/'test/TaskflowAIR/fixtures/add-scale.mlir'
    if source.read_bytes() != expected.read_bytes():
        raise ValueError('v12 add-scale reference supports the exact delivered source fixture only')
    (out/'source.mlir').write_bytes(source.read_bytes())
    digest = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
    arrays = []
    for seed in args.seeds:
        rng = np.random.default_rng(seed)
        a = rng.uniform(-.75, .75, (4, 4)).astype(np.float32)
        b = rng.uniform(-.75, .75, (4, 4)).astype(np.float32)
        a.flat[::7] = 0
        b.flat[::5] = 0
        expected_output = ((a.astype(np.float64)+b.astype(np.float64))*2).astype(np.float32)
        inputs, reference = out/f'inputs-{seed}.npz', out/f'reference-{seed}.npz'
        np.savez(inputs, A=a, B=b)
        np.savez(reference, C=expected_output)
        arrays.append(dict(seed=seed,inputs=dict(path=inputs.name,sha256=digest(inputs)),reference=dict(path=reference.name,sha256=digest(reference))))
    report = dict(schema='orbit.program-graph-amoeba.fixture.v12',source=dict(origin=str(source),path='source.mlir',sha256=digest(source)),generator=dict(path=str(Path(__file__).resolve()),sha256=digest(Path(__file__))),seeds=args.seeds,arrays=arrays,reference='float64 (A+B)*2 from original source; cast to f32',shape=[4,4],inputs=['A','B'],outputs=['C'],temporary=['T'],arithmetic='16 addf + 16 mulf',numerical_contract=dict(dtype='f32',atol=1e-5,rtol=1e-5,finite=True),scope='plain actual Taskflow source copied byte-for-byte; no model inference, planning, mapping or device execution')
    (out/'fixture.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(dict(status='prepared',source_sha256=digest(source),seeds=args.seeds)))


if __name__ == '__main__':
    main()
