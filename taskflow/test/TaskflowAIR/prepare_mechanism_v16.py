#!/usr/bin/env python3
"""Small computation fixtures; C++ owns graph, tiling, residency and lowering."""
import argparse
import importlib.util
import json
from pathlib import Path
import sys
import numpy as np
ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT/'scripts'))
from taskflow_device_transfer_microbench_v15 import sha, write


def load(name):
    spec = importlib.util.spec_from_file_location(name, Path(__file__).with_name(name+'.py'))
    module = importlib.util.module_from_spec(spec); spec.loader.exec_module(module); return module


def source(kind, m, k, n, adds):
    if kind == 'gemm': return load('prepare_v6').fixture('gemm', m, k, n)
    if kind == 'fanout':
        text = load('prepare_program_graph_v11').fanout_source(m*n)
        text = text.replace(f'memref<{m*n}xf32>',f'memref<{m}x{n}xf32>')
        text = text.replace(f'affine.for %i=0 to {m*n} {{', f'affine.for %i=0 to {m} {{\n        affine.for %j=0 to {n} {{')
        text = text.replace('[%i]', '[%i, %j]').replace('      taskflow.yield', '      }\n      taskflow.yield')
        return text
    transfer = load('prepare_device_transfer_v15')
    old = transfer.CONSTANTS
    transfer.CONSTANTS = tuple(old[i%len(old)] for i in range(adds))
    return transfer.source(m,n,adds)


def inputs_and_references(fixture, seed, repeat):
    kind,m,k,n,adds = (fixture[x] for x in ('kind','m','k','n','adds'))
    rng=np.random.default_rng(np.random.SeedSequence([seed,repeat,m,k,n]))
    def draw(shape): return rng.uniform(-.5,.5,shape).astype(np.float32)
    if kind=='gemm':
        a,b=draw((m,k)),draw((k,n)); strict=np.zeros((m,n),np.float32)
        for q in range(k):
            product=(a[:,q,None].astype(np.float64)*b[None,q,:].astype(np.float64)).astype(np.float32)
            strict=(strict.astype(np.float64)+product.astype(np.float64)).astype(np.float32)
        return dict(A=a,B=b), dict(C=strict), dict(C=a.astype(np.float64)@b.astype(np.float64))
    a=draw((m,n))
    if kind=='fanout':
        s=(a.astype(np.float64)*2).astype(np.float32); e=a.astype(np.float64)*2
        return dict(A=a),dict(B=s,C=s.copy()),dict(B=e,C=e.copy())
    strict=a.copy();exact=a.astype(np.float64)
    constants=(.03125,.0625,-.015625,.0078125)
    for i in range(adds):
        c=constants[i%4];strict=(strict.astype(np.float64)+c).astype(np.float32);exact+=c
    return dict(A=a),dict(C=strict),dict(C=exact)


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--kind',choices=['copy','elementwise','gemm','fanout'],required=True)
    for key,default in [('m',1),('k',32),('n',4096),('adds',0)]:p.add_argument('--'+key,type=int,default=default)
    p.add_argument('--tile',type=int,nargs='+',required=True)
    p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    assert min(a.m,a.k,a.n)>0 and a.adds>=0 and all(x>0 for x in a.tile)
    assert a.kind=='elementwise' or a.adds==0
    a.output.mkdir(parents=True,exist_ok=False)
    (a.output/'source.mlir').write_text(source(a.kind,a.m,a.k,a.n,a.adds))
    config={'generic_air':{'tile_sizes':a.tile}}
    write(a.output/'config.json',config)
    fixture=dict(kind=a.kind,m=a.m,k=a.k,n=a.n,adds=a.adds,tile=a.tile)
    for seed in (11,23,47):
        inputs,strict,exact=inputs_and_references(fixture,seed,0)
        np.savez(a.output/f'inputs-{seed}.npz',**inputs)
        np.savez(a.output/f'reference-{seed}.npz',**strict)
        np.savez(a.output/f'reference-f64-{seed}.npz',**exact)
    write(a.output/'fixture.json',dict(schema='orbit.mechanism.fixture.v16',fixture=fixture,
        source_sha256=sha(a.output/'source.mlir'),generator_sha256=sha(__file__),
        scalar_operations=(2*a.m*a.n*a.k if a.kind=='gemm' else (a.m*a.n if a.kind=='fanout' else a.adds*a.m*a.n)),
        reference='ordered f32 multiply/add or source-order elementwise; separate unrounded f64',
        scope='computation fixture only; C++ independently derives all physical activities'))
    print(json.dumps(dict(status='prepared',output=str(a.output),device_submissions=0)))

if __name__=='__main__':main()
