#!/usr/bin/env python3
"""CPU checks for reusable runtime policy and descriptive validation formulas."""
import argparse
import copy
import hashlib
import importlib.util
import json
from pathlib import Path
import sys
from unittest.mock import patch
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'scripts'))
import taskflow_implementation_runtime_v10 as runtime
spec=importlib.util.spec_from_file_location('audit_v10',Path(__file__).with_name('audit_implementation_search_v10.py'))
audit=importlib.util.module_from_spec(spec);spec.loader.exec_module(audit)
from taskflow_implementation_search_v10 import save


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--output',type=Path,required=True)
    out=parser.parse_args().output.resolve();out.mkdir(parents=True,exist_ok=False)
    abi=out/'abi.json';save(abi,dict(buffers=[dict(role='input'),dict(role='input'),dict(role='output'),dict(role='temporary')]))
    timing=dict(observer='detailed',warmups=2,hot=5)
    def exact(names):
        return dict(case_policies=[dict(profile_name=name,abi_sha256=name,static_indices=[],intermediate_indices=[3],output_indices=[2],per_call_input_indices=[0,1],hot_state='warmup-before-all-labeled-hot',actual_warmups_by_seed={str(i):2 for i in range(3)},labeled_hot_calls_by_seed={str(i):5 for i in range(3)}) for name in names])
    def identify(names,contract):
        inv=dict(observer='detailed',identities={name:dict(abi_path=str(abi)) for name in names})
        with patch.object(runtime,'case_preparation_contract',return_value=(contract,{'synthetic':True})),patch.object(runtime,'exact_runtime_identity',side_effect=lambda p,i,preparation:hashlib.sha256(json.dumps(preparation,sort_keys=True).encode()).hexdigest()):
            return runtime.runtime_identity(out,inv,timing)
    one,evidence1=identify(['one'],exact(['one']));two,evidence2=identify(['newname','other'],exact(['newname','other']))
    assert one==two and evidence1['exact_per_case_contract']!=evidence2['exact_per_case_contract']
    for key,value in [('static_indices',[0]),('actual_warmups_by_seed',{'0':1,'1':2,'2':2})]:
        bad=exact(['one']);bad['case_policies'][0][key]=value
        try:identify(['one'],bad)
        except ValueError:pass
        else:raise AssertionError('changed preparation policy admitted')
    rows=[dict(name='a',program='p',prediction_ms=1),dict(name='b',program='p',prediction_ms=2)]
    actual={name:dict(numerical_passed=True,numeric_gate_passed=True,hot_wall_ms=dict(median=value)) for name,value in [('a',2),('b',1)]}
    raw=dict(results=[dict(samples=[dict(candidate=name,repeat=0,warmup=False,wall_ms=value) for name,value in [('a',2),('b',1)]])])
    report=audit.comparison(rows,actual,raw);assert report['MAPE_percent']==75
    assert report['groups'][0]['descriptive_regret_percent_range']==[100,100] and report['groups'][0]['pairwise'][0]['strict_order_reversal']
    rows[1]['prediction_ms']=1;ties=audit.comparison(rows,actual,raw);assert ties['groups'][0]['descriptive_regret_percent_range']==[0,100] and ties['groups'][0]['pairwise'][0]['prediction_tie']
    actual['a']['numerical_passed']=False
    try:audit.comparison(rows,actual,raw)
    except ValueError:pass
    else:raise AssertionError('numeric failure scored as eligible')
    result=dict(status='passed',checks=['canonical runtime policy independent of case name/count with exact evidence preserved','static-input policy mismatch rejected','warmup mismatch rejected','known MAPE/ranking/regret formulas','prediction ties preserved as regret range','numerical failure excluded'],compilation=False,device_submissions=0,scope='synthetic CPU protocol only; not hardware/model validation')
    save(out/'summary.json',result);print(json.dumps(result))


if __name__=='__main__':main()
