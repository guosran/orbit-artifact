#!/usr/bin/env python3
"""Independent small-fixture source/numerical check; no generator import or NPU."""
import argparse
import json
from pathlib import Path
import re
import numpy as np
from audit_mechanism_program_v16 import read,verify,identity
from analyze_device_transfer_v15 import source_contract,references

def expected(case,inputs):
    text=verify(case['source']).read_text();fixture=read(verify(case['fixture']))['fixture'];kind=fixture['kind']
    if kind in ('copy','elementwise'):
        contract=source_contract(case['source']['path'],inputs['A'].shape[1],fixture['adds'])
        strict,exact=references(inputs['A'],contract['source_order_constants']);return {'C':strict},{'C':exact}
    if kind=='gemm':
        # Narrow validator of this real affine GEMM body. It does not lower IR.
        a,b=inputs['A'],inputs['B'];assert a.ndim==b.ndim==2 and a.shape[1]==b.shape[0]
        m,k=a.shape;n=b.shape[1]
        assert set(re.findall(r'\barith\.(\w+)',text))=={'constant','mulf','addf'}
        if 'orbit.distributed_initialization' in text:
            assert len(re.findall(r'\btaskflow.task\b',text))==2
            assert [int(v) for v in re.findall(r'affine.for %\w+ = 0 to (\d+)',text)]==[m,n,m,n,k]
            assert 'affine.store %cst, %arg5[%arg6, %arg7]' in text
            assert 'affine.load %arg3[%arg6, %arg8]' in text and 'affine.load %arg4[%arg8, %arg7]' in text and 'affine.load %arg5[%arg6, %arg7]' in text
            assert '%3 = arith.mulf %0, %1' in text and '%4 = arith.addf %2, %3' in text and 'affine.store %4, %arg5[%arg6, %arg7]' in text
        else:
            assert len(re.findall(r'\btaskflow.task\b',text))==1
            assert re.search(r'%p\s*=\s*arith.mulf\s+%x,\s*%w',text)
            assert re.search(r'%sum\s*=\s*arith.addf\s+%old,\s*%p',text)
            assert 'affine.load %A_b[%i, %k]' in text and 'affine.load %B_b[%k, %j]' in text and 'affine.load %C_b[%i, %j]' in text
            assert 'affine.store %sum, %C_b[%i, %j]' in text and 'affine.store %zero, %C_b[%i, %j]' in text
            for axis,extent in [('i',m),('j',n),('k',k)]:assert re.search(r'affine.for %'+axis+r'\s*=\s*0 to '+str(extent)+r'\s*\{',text)
        strict=np.zeros((m,n),np.float32)
        for q in range(k):
            product=(a[:,q,None].astype(np.float64)*b[None,q,:].astype(np.float64)).astype(np.float32)
            strict=(strict.astype(np.float64)+product.astype(np.float64)).astype(np.float32)
        return {'C':strict},{'C':a.astype(np.float64)@b.astype(np.float64)}
    assert kind=='fanout' and len(re.findall(r'\btaskflow.task\b',text))==3
    assert len(re.findall(r'\barith.mulf\b',text))==1 and not re.findall(r'\barith.addf\b',text)
    assert '%two=arith.constant 2.0 : f32' in text and '%r=arith.mulf %v,%two : f32' in text
    assert text.count('affine.load %in[%i, %j]')==3 and text.count('affine.store %v,%out[%i, %j]')==2
    exact=inputs['A'].astype(np.float64)*2;strict=exact.astype(np.float32)
    return dict(B=strict,C=strict.copy()),dict(B=exact,C=exact.copy())

def audit(root):
    protocol=read(root/'protocol.json');cases={c['id']:c for c in protocol['cases']};seen=set();checks=[];maximum=0
    for line in (root/'samples.jsonl').read_text().splitlines():
        s=json.loads(line);c=cases[s['case']];assert c==s['case_identity'];key=(s['case'],s['seed'],s['repeat']);assert key not in seen;seen.add(key)
        for k in ['fixture','source','compile','elf','abi','plan','transformed','aie']:verify(c[k])
        with np.load(verify(s['inputs']),allow_pickle=False) as z:inputs={k:z[k].copy() for k in z.files}
        strict,exact=expected(c,inputs)
        with np.load(verify(s['reference']),allow_pickle=False) as z:assert set(z.files)==set(strict) and all(np.array_equal(z[k],v) for k,v in strict.items())
        with np.load(verify(s['reference_f64']),allow_pickle=False) as z:assert set(z.files)==set(exact) and all(np.array_equal(z[k],v) for k,v in exact.items())
        row=[]
        with np.load(verify(s['outputs']),allow_pickle=False) as z:
            assert set(z.files)==set(strict)
            for k in strict:
                value=z[k];assert np.isfinite(value).all() and value.dtype==np.float32
                for name,ref in [('source_order_f32',strict[k]),('unrounded_f64',exact[k])]:
                    error=abs(value.astype(np.float64)-ref.astype(np.float64));assert np.all(error<=1e-5+1e-5*abs(ref));maximum=max(maximum,float(error.max()));row.append(dict(output=k,reference=name,max_abs=float(error.max())))
        checks.append(dict(case=s['case'],seed=s['seed'],repeat=s['repeat'],checks=row,outputs=s['outputs']))
    target={(c,seed,r) for c in cases for seed in protocol['seeds'] for r in range(protocol['warmups']+protocol['repeats'])};assert seen==target
    return dict(schema='orbit.program-numerics.independent.v16',status='passed',protocol=identity(root/'protocol.json'),auditor=identity(__file__),calls=len(checks),max_abs=maximum,checks=checks,scope='Narrow source-validated GEMM/fanout/copy/add fixtures; no production planner or compiler fallback; original FP32 atol=rtol=1e-5 unchanged.')
def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--input',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();assert not a.output.exists();r=audit(a.input);a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({k:r[k] for k in ['status','calls','max_abs']}))
if __name__=='__main__':main()
