#!/usr/bin/env python3
"""v17 all-copy fixture adapter over the frozen v16 measurement implementation.

All context, bound-BO, lock, polling, timestamps and evidence behavior is reused.
This wrapper and the replacement reference generator are additionally SHA-bound.
No production graph, mapping, scheduler or configuration is implemented here.
"""
import importlib.util
from pathlib import Path
import numpy as np
import taskflow_program_probe_v16 as base


def fixture_module():
 path=Path(__file__).resolve().parents[1]/'test/TaskflowAIR/prepare_data_organization_v17.py'
 spec=importlib.util.spec_from_file_location('data_fixture_v17',path)
 module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module,path


def exact_copy_numeric(actual,strict,exact):
 result=original_numeric(actual,strict,exact)
 result['strict_f32_source_order']['passed']=bool(np.array_equal(actual,strict))
 result['unrounded_f64']['passed']=bool(np.array_equal(actual.astype(np.float64),exact))
 return result


def freeze(*args,**kwargs):
 original_freeze(*args,**kwargs)
 output=args[1];protocol=base.read(output)
 protocol['v17_wrapper']=base.ident(__file__)
 protocol['numerical_tolerance']=dict(exact_f32_copy=True,exact_f64_view=True)
 protocol['v17_scope']='All-copy data-organization contrasts; v16 parameters/model/domain unchanged.'
 base.write(output,protocol)


def validate(protocol):
 original_validate(protocol);base.verify(protocol['v17_wrapper'])
 assert protocol['numerical_tolerance']==dict(exact_f32_copy=True,exact_f64_view=True)
 for case in protocol['cases']:
  fixture=base.read(case['fixture']['path'])
  assert fixture['schema']=='orbit.data-organization.fixture.v17'
  assert fixture['fixture']['kind'] in ['broadcast','fanout']
  assert fixture['fixture']['scalar_products']==fixture['fixture']['scalar_addsub']==0


original_freeze,original_validate,original_numeric=base.freeze,base.validate,base.numeric
base.fixture_module=fixture_module;base.freeze=freeze;base.validate=validate;base.numeric=exact_copy_numeric

if __name__=='__main__':base.main()
