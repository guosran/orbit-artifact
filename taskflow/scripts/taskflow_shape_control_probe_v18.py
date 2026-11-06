#!/usr/bin/env python3
"""Historical all-copy shape controls using finite FP32 tolerance and v16 observer.

Fixture generation reuses v17 identity-copy equations. No graph/planning/model.
"""
import importlib.util
from pathlib import Path
import taskflow_program_probe_v16 as base


def fixture_module():
 path=Path(__file__).resolve().parents[1]/'test/TaskflowAIR/prepare_data_organization_v17.py'
 spec=importlib.util.spec_from_file_location('shape_control_fixture_v18',path);module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module,path


def freeze(*args,**kwargs):
 original_freeze(*args,**kwargs);output=args[1];protocol=base.read(output)
 protocol['shape_control_wrapper']=base.ident(__file__)
 protocol['shape_control_scope']='Same historical v17 RAW-only identity-copy source and inputs; original C++ shape-major action; finite f32/f64 atol=rtol=1e-5 for both plans. No old model reused.'
 base.write(output,protocol)


def validate(protocol):
 original_validate(protocol);base.verify(protocol['shape_control_wrapper'])
 assert protocol['numerical_tolerance']==dict(atol=1e-5,rtol=1e-5)
 for case in protocol['cases']:
  fixture=base.read(case['fixture']['path']);assert fixture['schema']=='orbit.data-organization.fixture.v17'
  assert fixture['fixture']['kind']=='fanout' and fixture['fixture']['scalar_products']==fixture['fixture']['scalar_addsub']==0


original_freeze,original_validate=base.freeze,base.validate
base.fixture_module=fixture_module;base.freeze=freeze;base.validate=validate
if __name__=='__main__':base.main()
