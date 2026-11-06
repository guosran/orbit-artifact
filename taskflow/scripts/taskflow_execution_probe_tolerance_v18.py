#!/usr/bin/env python3
"""Computed-diamond references over the unchanged v16 host observation runner.

No production graph/planning/model. This adapter and generator are SHA-bound.
Source-order FP32 and independent unrounded FP64 use the existing project
1e-5 absolute/relative finite comparison. The failed bitwise trial is retained. All host boundary behavior is reused.
"""
import importlib.util
from pathlib import Path
import numpy as np
import taskflow_program_probe_v16 as base


def fixture_module():
 path=Path(__file__).resolve().parents[1]/'test/TaskflowAIR/prepare_execution_graph_v18.py'
 spec=importlib.util.spec_from_file_location('execution_fixture_v18',path)
 module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module,path


def freeze(*args,**kwargs):
 original_freeze(*args,**kwargs);output=args[1];protocol=base.read(output)
 protocol['v18_wrapper']=base.ident(__file__)
 protocol['numerical_tolerance']=dict(strict_f32=dict(atol=1e-5,rtol=1e-5),unrounded_f64=dict(atol=1e-5,rtol=1e-5))
 protocol['contract_revision']='Restore original arithmetic atol=rtol=1e-5 after retained one-warmup exact-bitwise failure; no model or candidate change.'
 protocol['v18_scope']='New computed-diamond execution-group study; old models remain unchanged and out of domain.'
 base.write(output,protocol)


def validate(protocol):
 original_validate(protocol);base.verify(protocol['v18_wrapper'])
 assert protocol['numerical_tolerance']==dict(strict_f32=dict(atol=1e-5,rtol=1e-5),unrounded_f64=dict(atol=1e-5,rtol=1e-5))
 for c in protocol['cases']:
  f=base.read(c['fixture']['path']);assert f['schema']=='orbit.execution-graph.fixture.v18' and f['fixture']['kind']=='diamond'


original_freeze,original_validate=base.freeze,base.validate
base.fixture_module=fixture_module;base.freeze=freeze;base.validate=validate

if __name__=='__main__':base.main()
