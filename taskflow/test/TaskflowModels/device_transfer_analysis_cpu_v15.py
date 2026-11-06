#!/usr/bin/env python3
"""CPU-only negatives for the independent v15 source/reference auditor."""
import argparse
import importlib.util
import json
from pathlib import Path
import tempfile
import numpy as np


def mod(path,name):
    s=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m

def main():
    p=argparse.ArgumentParser();p.add_argument('--output',type=Path,required=True);a=p.parse_args();assert not a.output.exists()
    here=Path(__file__).resolve().parent;m=mod(here/'analyze_device_transfer_v15.py','analysis');f=mod(here.parent/'TaskflowAIR/prepare_device_transfer_v15.py','fixture');checks=[]
    def reject(fn):
        try:fn()
        except AssertionError:return
        raise AssertionError('negative accepted')
    with tempfile.TemporaryDirectory() as td:
        path=Path(td)/'source.mlir'
        for adds in (0,4):
            path.write_text(f.source(1,2048,adds));c=m.source_contract(path,2048,adds)
            value=np.linspace(-.5,.5,2048,dtype='f4').reshape(1,-1)
            strict,exact=m.references(value,c['source_order_constants'])
            expected=value.copy()
            for constant in f.CONSTANTS[:adds]:expected=np.add(expected,np.float32(constant),dtype=np.float32)
            assert np.array_equal(strict,expected);checks.append(f'independent-source-and-reference-adds{adds}')
        path.write_text(f.source(1,2048,0).replace('%a[%i, %j]','%a[%i, 0]'));reject(lambda:m.source_contract(path,2048,0));checks.append('shifted-source-read-rejected')
        path.write_text(f.source(1,2048,4).replace('affine.store %v3','affine.store %x'));reject(lambda:m.source_contract(path,2048,4));checks.append('discarded-arithmetic-result-rejected')
        path.write_text(f.source(1,2048,4));reject(lambda:m.source_contract(path,2048,0));checks.append('wrong-declared-arithmetic-count-rejected')
    good=m.metrics(np.array([1],dtype='f4'),np.array([1],dtype='f8'));bad=m.metrics(np.array([2],dtype='f4'),np.array([1],dtype='f8'))
    assert good['passed'] and not bad['passed'];checks.append('numerical-corruption-rejected')
    assert m.stats([-3,-2,-1])['median_ns']==-2;checks.append('signed-paired-differences-retained')
    a.output.mkdir(parents=True);(a.output/'summary.json').write_text(json.dumps({'status':'passed','checks':checks,'count':len(checks),'device_submissions':0},indent=2)+'\n');print(json.dumps({'status':'passed','checks':len(checks)}))

if __name__=='__main__':main()
