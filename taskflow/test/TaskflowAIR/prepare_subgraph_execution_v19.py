#!/usr/bin/env python3
"""Numerical fixtures only. C++ discovers, checks and chooses resident subgraphs."""
import argparse, hashlib, json
from pathlib import Path
import numpy as np
ROOT=Path('/home/shiran/project/orbit')
STEPS=[('U','add',['A'],1.),('X','mul',['U'],2.),('Y','add',['X'],3.),('Z','sub',['X'],1.),('V','add',['Y','Z'],None),('W','mul',['V'],.5),('O','add',['W','Y'],None)]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def inputs_and_references(fixture,seed,repeat):
 assert fixture['kind'] in ('subgraphs-v19','partial-subgraph-v19')
 m,n=fixture['m'],fixture['n'];rng=np.random.default_rng(np.random.SeedSequence([seed,repeat,m,n]))
 a=rng.uniform(-.5,.5,(m,n)).astype(np.float32);strict={'A':a};exact={'A':a.astype(np.float64)}
 for out,op,ins,c in fixture['steps']:
  function={'add':np.add,'mul':np.multiply,'sub':np.subtract}[op]
  strict[out]=function(strict[ins[0]].astype(np.float64),float(c) if c is not None else strict[ins[1]].astype(np.float64)).astype(np.float32)
  exact[out]=function(exact[ins[0]],float(c) if c is not None else exact[ins[1]])
 return {'A':a},{k:strict[k] for k in fixture['outputs']},{k:exact[k] for k in fixture['outputs']}
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--kind',choices=['subgraphs-v19','partial-subgraph-v19'],default='subgraphs-v19');p.add_argument('--output',type=Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
 steps=STEPS if a.kind=='subgraphs-v19' else STEPS[:4]+[('O','add',['Y','Z'],None)]
 source=ROOT/'test/TaskflowAIR/fixtures'/f'{a.kind}.mlir';(a.output/'source.mlir').write_bytes(source.read_bytes())
 fixture=dict(kind=a.kind,m=17,n=136,steps=steps,outputs=['Z','O'],scalar_addsub=sum(s[1]!='mul' for s in steps)*17*136,scalar_products=sum(s[1]=='mul' for s in steps)*17*136)
 for seed in [11,23,47]:
  inputs,strict,exact=inputs_and_references(fixture,seed,0)
  for prefix,arrays in [('inputs',inputs),('reference',strict),('reference-f64',exact)]:np.savez(a.output/f'{prefix}-{seed}.npz',**arrays)
 (a.output/'fixture.json').write_text(json.dumps(dict(schema='orbit.subgraph-execution.fixture.v19',fixture=fixture,source_sha256=sha(a.output/'source.mlir'),generator_sha256=sha(__file__),total_array_payload_bytes=(len(steps)+1)*17*136*4,reference='FP32 source-order rounding plus unrounded FP64; atol=rtol1e-5',source_decisions='only computation and access semantics; C++ actions supply grouping and tiling'),indent=2)+'\n')
 print(json.dumps(dict(status='prepared',output=str(a.output),device_submissions=0)))
if __name__=='__main__':main()
