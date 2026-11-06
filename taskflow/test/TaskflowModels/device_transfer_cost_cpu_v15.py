#!/usr/bin/env python3
"""CPU-only model formula/guard contracts, no labels or devices."""
import argparse
import importlib.util
import json
from pathlib import Path
import tempfile
import types
import numpy as np


def module(path,name):
    s=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m

def main():
    p=argparse.ArgumentParser();p.add_argument('--output',type=Path,required=True);a=p.parse_args();assert not a.output.exists()
    here=Path(__file__).resolve().parent;f=module(here/'fit_device_transfer_v15.py','fit');v=module(here.parent/'TaskflowMapping/validate_device_transfer_cost_v15.py','validate');checks=[]
    def reject(fn):
        try:fn()
        except AssertionError:return
        raise AssertionError('negative accepted')
    x=np.array([[1,8*e] for e in (4096,16384,65536) for _ in range(3)],float)
    np.testing.assert_allclose(f.nnls2(x,x@np.array([270000,.7]))[0],[270000,.7],rtol=1e-10,atol=1e-7);checks.append('two-term-exact-identification')
    np.testing.assert_allclose(f.nnls2(x,x@np.array([0,.7]))[0],[0,.7],rtol=1e-9,atol=1e-7);checks.append('nonnegative-entry-boundary')
    reject(lambda:f.nnls2([[1,2],[1,2]],[1,2]));checks.append('rank-deficient-design-rejected')
    with tempfile.TemporaryDirectory() as td:
        root=Path(td);protocol=root/'protocol.json';protocol.write_text('{"split":"holdout"}')
        reject(lambda:f.fit(types.SimpleNamespace(output=str(root/'out'),protocol=str(protocol))));checks.append('held-labels-rejected-before-open')
    assert v.errors(500000,300000)['passed'] and not v.errors(700000,300000)['passed'];checks.append('registered-resolution-threshold')
    domain={k:k+'-exact' for k in ('runtime_identity','toolchain_identity','path_identity','observer_identity','condition_identity')};domain.update(architecture_identity='arch',implementation='identity-copy-f32',completion_boundary='submit-to-successful-wait-return',**f.BOUNDS)
    row={'domain':domain,'entry_ns':270000,'byte_ns':.7,'segment_ns':0}
    binding={k:domain[k] for k in ('runtime_identity','toolchain_identity','path_identity','observer_identity','condition_identity','completion_boundary')}
    fact={'binding':binding,'architecture_identity':'arch','implementation':'identity-copy-f32','descriptor_bytes':49152,'segment_count':3,'tile_elements':2048,'physical_ddr_bytes':None,'runtime_descriptor_count':2}
    assert v.model_match(row,fact)==270000+.7*49152;checks.append('predeclared-held3segments-accepted')
    broken=json.loads(json.dumps(fact));broken['binding']['condition_identity']='other';reject(lambda:v.model_match(row,broken));checks.append('condition-mismatch-rejected')
    broken=json.loads(json.dumps(fact));broken['implementation']='four-add';reject(lambda:v.model_match(row,broken));checks.append('compute-contrast-ood')
    cells=[{'descriptor_bytes':r[1],'median_ns':270000+.7*r[1]} for r in x]
    assert v.independent_kkt(row,cells)['passed'];checks.append('independent-kkt-optimality')
    reject(lambda:v.independent_kkt(row|{'byte_ns':1},cells));checks.append('wrong-frozen-parameters-rejected')
    a.output.mkdir(parents=True);(a.output/'summary.json').write_text(json.dumps({'status':'passed','checks':checks,'count':len(checks),'device_submissions':0},indent=2)+'\n');print(json.dumps({'status':'passed','checks':len(checks)}))

if __name__=='__main__':main()
