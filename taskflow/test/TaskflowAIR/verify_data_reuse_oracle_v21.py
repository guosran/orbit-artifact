#!/usr/bin/env python3
"""Independent polynomial checks for the three frozen arithmetic programs.

This validates numerical fixtures only. Candidate generation, legality, mapping,
search ordering and scoring stay in the production C++ compiler.
"""
import argparse, importlib.util, json, hashlib
from pathlib import Path
import numpy as np


def main():
 p=argparse.ArgumentParser(description=__doc__)
 p.add_argument('--generator',type=Path,required=True);p.add_argument('--fixture',type=Path,action='append',required=True);p.add_argument('--output',type=Path,required=True)
 a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
 spec=importlib.util.spec_from_file_location('fixture_generator',a.generator);generator=importlib.util.module_from_spec(spec);spec.loader.exec_module(generator)
 rows=[]
 for directory in a.fixture:
  record=json.loads((directory/'fixture.json').read_text());fixture=record['fixture'];kind=fixture['kind'];maximum=0.;checks=0
  for seed in [11,23,47]:
   for repeat in [0,1,5]:
    inputs,strict,exact=generator.inputs_and_references(fixture,seed,repeat)
    A,D=inputs['A'].astype(np.float64),inputs['D'].astype(np.float64)
    if kind=='interleaved': polynomial={'O':3*A+1,'H':2*D+3}
    elif kind=='shared-input':polynomial={'O':3*A+1,'U':D+3}
    elif kind=='coupling':polynomial={'O':4*A+2,'H':2*D+3}
    else:raise ValueError(kind)
    for name,expected in polynomial.items():
     assert np.array_equal(exact[name],expected),(kind,name,'unrounded polynomial')
     assert strict[name].dtype==np.float32 and np.isfinite(strict[name]).all()
     maximum=max(maximum,float(np.abs(strict[name].astype(np.float64)-expected).max()))
     assert np.allclose(strict[name],expected,atol=1e-5,rtol=1e-5)
     if repeat==0:
      with np.load(directory/f'reference-{seed}.npz') as stored:assert np.array_equal(stored[name],strict[name])
      with np.load(directory/f'reference-f64-{seed}.npz') as stored:assert np.array_equal(stored[name],exact[name])
     checks+=1
  rows.append({'kind':kind,'dimensions':[fixture['m'],fixture['n']],'oracle_array_checks':checks,'max_source_rounded_vs_polynomial_abs':maximum,'source_sha256':hashlib.sha256((directory/'source.mlir').read_bytes()).hexdigest(),'fixture_sha256':hashlib.sha256((directory/'fixture.json').read_bytes()).hexdigest()})
 result={'status':'passed','checks':rows,'generator_sha256':hashlib.sha256(a.generator.read_bytes()).hexdigest(),'scope':'Independent unrounded polynomial plus stored source-rounded array reproducibility; no production plan decision or NPU execution','device_submissions':0}
 (a.output/'summary.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))

if __name__=='__main__':main()
