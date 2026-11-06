#!/usr/bin/env python3
"""CPU-only calibration/validation contracts; no runtime or hardware imports."""
import argparse
import importlib.util
import json
from pathlib import Path
import tempfile
import numpy as np


def module(path,name):
    spec=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);return m

def main():
    p=argparse.ArgumentParser();p.add_argument('--output',required=True);a=p.parse_args()
    here=Path(__file__).resolve().parent;f=module(here/'fit_sync_cost_v14.py','fit');v=module(here.parent/'TaskflowMapping/validate_sync_cost_v14.py','validate')
    checks=[]
    def check(name,fn):fn();checks.append(name)
    def reject(fn):
        try:fn()
        except (AssertionError,ValueError):return
        raise AssertionError('negative incorrectly accepted')
    x=np.array([[1,n,n*b/64] for n in (1,4,16) for b in (1024,8192,32768,131072)],float)
    check('identifiable-exact-three-term',lambda:np.testing.assert_allclose(f.nnls3(x,x@np.array([80,120,.4]))[0],[80,120,.4],rtol=1e-8,atol=1e-7))
    check('nonnegative-boundary-solution',lambda:np.testing.assert_allclose(f.nnls3(x,x@np.array([0,120,.4]))[0],[0,120,.4],rtol=1e-8,atol=1e-7))
    check('reject-rank-deficient-design',lambda:reject(lambda:f.nnls3([[1,1,2],[1,1,4],[1,1,8]],[1,2,3])))
    check('acceptance-absolute-floor',lambda: (_ for _ in ()).throw(AssertionError()) if not v.assess(800,400,500,.15)['measurement_accuracy_passed'] else None)
    check('accuracy-failure-not-structural-pass',lambda: (_ for _ in ()).throw(AssertionError()) if v.assess(1200,400,500,.15)['measurement_accuracy_passed'] else None)
    with tempfile.TemporaryDirectory() as td:
        root=Path(td);(root/'identity.json').write_text(json.dumps({'split':'holdout'}))
        check('fit-rejects-heldout-before-label-open',lambda:reject(lambda:f.context(root,root/'absent-protocol','calibration')))
        (root/'file').write_text('frozen');w=f.ident(root/'file');(root/'file').write_text('tampered')
        check('raw-evidence-tamper-rejected',lambda:reject(lambda:v.verify(w)))
    descriptor={'schema':'orbit.sync-observation-condition.v14','allocation_scope':'fresh-ext-bo-per-sample','prepared_context_count':0,'source_sha256':'a'*64}
    import hashlib
    cid=hashlib.sha256(json.dumps(descriptor,sort_keys=True,separators=(',',':')).encode()).hexdigest()
    row={'domain':{'site':'prebound-contiguous-sync-loop','runtime_identity':'runtime','observer_identity':'a'*64,'condition_identity':cid}}
    model={'conditions':{cid:descriptor},'rows':[row]};identity={'source_sha256':'a'*64,'runtime_target_id':'runtime','program_input_identities':{}}
    check('exact-condition-match',lambda:v.matching_row(model,identity,False,site='prebound-contiguous-sync-loop'))
    check('runtime-mismatch-rejected',lambda:reject(lambda:v.matching_row(model,identity|{'runtime_target_id':'other'},False,site='prebound-contiguous-sync-loop')))
    check('context-mismatch-rejected',lambda:reject(lambda:v.matching_row(model,identity|{'program_input_identities':{'unexpected':{}}},False,site='prebound-contiguous-sync-loop')))
    out=Path(a.output);assert not out.exists();out.mkdir(parents=True)
    (out/'summary.json').write_text(json.dumps({'status':'passed','checks':checks,'count':len(checks),'device_submissions':0},indent=2)+'\n')
    print(json.dumps({'status':'passed','checks':len(checks)}))

if __name__=='__main__':main()
