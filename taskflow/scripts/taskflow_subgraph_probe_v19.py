#!/usr/bin/env python3
"""Partial/multiple resident-subgraph references over the unchanged v16 host observation runner.

No production graph/planning/model. This adapter and generator are SHA-bound.
Source-order FP32 and independent unrounded FP64 use the existing project
1e-5 absolute/relative finite comparison. The failed bitwise trial is retained. All host boundary behavior is reused.
"""
import importlib.util
from pathlib import Path
import numpy as np
import taskflow_program_probe_v16 as base


def fixture_module():
 path=Path(__file__).resolve().parents[1]/'test/TaskflowAIR/prepare_subgraph_execution_v19.py'
 spec=importlib.util.spec_from_file_location('subgraph_fixture_v19',path)
 module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module,path


def freeze(*args,**kwargs):
 original_freeze(*args,**kwargs);output=args[1];protocol=base.read(output)
 protocol['v19_wrapper']=base.ident(__file__)
 protocol['numerical_tolerance']=dict(strict_f32=dict(atol=1e-5,rtol=1e-5),unrounded_f64=dict(atol=1e-5,rtol=1e-5))
 protocol['contract_revision']='Unchanged project finite FP32 and independent FP64 atol=rtol1e-5; new semantic fixtures.'
 protocol['v19_scope']='Partial/multiple resident subgraphs; host-observed invocation; descriptor bytes are static, DMA/core timing unknown.'
 protocol['decision_freeze']='Model, exact candidates, predictions and decision rule frozen before prospective v19 performance.'
 protocol['comparison_method']=dict(metric='runner_wall_ns',pairing='same program, seed and repeat; alternating forward/reverse candidate order',warmups='excluded from statistics, still all correctness-checked',difference='candidate minus same-program baseline',judgement='report paired median/mean/p05/p95 and bootstrap95CI; real ordering requires sign agreement resolved in both sessions; no refitting',clock='host perf_counter_ns, polling completion visibility only; no physical DMA/core timestamps',model='same nine explicitly assumed v18 numbers for every v19 plan')
 for c in protocol['cases']:
  compiled=Path(c['plan']['path']).parent
  c['implementation_contract']=base.ident(compiled/'implementation-contract.json')
  c['program_graph']=base.ident(compiled/'program-graph.json')
  c['target_configuration']=base.ident(compiled/'target.json')
  c['actual_facts']=base.ident(compiled/'implementation-facts.json')
  assert base.read(c['implementation_contract']['path'])['valid'] is True
  plan=base.read(c['plan']['path'])
  c['frozen_prediction']=dict(ms=plan['estimated_ms'],graph_id=plan['program_graph_id'],groups=len(plan['execution_groups']),requested_transfer_bytes=plan['actual_dma_bytes'],peak_payload_bytes=plan['resident_bytes'])
 base.write(output,protocol)


def validate(protocol):
 original_validate(protocol);base.verify(protocol['v19_wrapper'])
 assert protocol['numerical_tolerance']==dict(strict_f32=dict(atol=1e-5,rtol=1e-5),unrounded_f64=dict(atol=1e-5,rtol=1e-5))
 for c in protocol['cases']:
  for key in ['implementation_contract','program_graph','target_configuration','actual_facts']:base.verify(c[key])
  assert base.read(c['implementation_contract']['path'])['valid'] is True
  assert base.read(c['plan']['path'])['estimated_ms']==c['frozen_prediction']['ms']
  f=base.read(c['fixture']['path']);assert f['schema']=='orbit.subgraph-execution.fixture.v19' and f['fixture']['kind'] in ('subgraphs-v19','partial-subgraph-v19')


original_freeze,original_validate=base.freeze,base.validate
base.fixture_module=fixture_module;base.freeze=freeze;base.validate=validate

if __name__=='__main__':base.main()
