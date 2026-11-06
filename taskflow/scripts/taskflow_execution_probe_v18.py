#!/usr/bin/env python3
"""Computed-diamond references over the unchanged v16 host observation runner.

No production graph/planning/model. This adapter and generator are SHA-bound.
Strict source-order FP32 is exact; independent unrounded FP64 uses the existing
1e-5 absolute/relative finite comparison. All host boundary behavior is reused.
"""
import importlib.util
from pathlib import Path
import numpy as np
import taskflow_program_probe_v16 as base


def fixture_module():
 path=Path(__file__).resolve().parents[1]/'test/TaskflowAIR/prepare_execution_graph_v18.py'
 spec=importlib.util.spec_from_file_location('execution_fixture_v18',path)
 module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module,path


def source_order_numeric(actual,strict,exact):
 result=original_numeric(actual,strict,exact)
 result['strict_f32_source_order']['passed']=bool(np.array_equal(actual,strict))
 return result


def freeze(*args,**kwargs):
 original_freeze(*args,**kwargs);output=args[1];protocol=base.read(output)
 protocol['v18_wrapper']=base.ident(__file__)
 protocol['numerical_tolerance']=dict(strict_f32='exact finite source order',unrounded_f64=dict(atol=1e-5,rtol=1e-5))
 protocol['v18_scope']='New computed-diamond execution-group study; old models remain unchanged and out of domain.'
 base.write(output,protocol)


def validate(protocol):
 original_validate(protocol);base.verify(protocol['v18_wrapper'])
 assert protocol['numerical_tolerance']==dict(strict_f32='exact finite source order',unrounded_f64=dict(atol=1e-5,rtol=1e-5))
 for c in protocol['cases']:
  f=base.read(c['fixture']['path']);assert f['schema']=='orbit.execution-graph.fixture.v18' and f['fixture']['kind']=='diamond'


original_freeze,original_validate,original_numeric=base.freeze,base.validate,base.numeric
base.fixture_module=fixture_module;base.freeze=freeze;base.validate=validate;base.numeric=source_order_numeric

if __name__=='__main__':base.main()
