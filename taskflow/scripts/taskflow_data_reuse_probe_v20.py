#!/usr/bin/env python3
"""SHA-frozen arithmetic replay over the existing locked NPU observer."""
import importlib.util
from pathlib import Path

import taskflow_program_probe_v16 as base


def fixture_module():
    path = Path(__file__).resolve().parents[1]/'test/TaskflowAIR/prepare_data_reuse_v20.py'
    spec = importlib.util.spec_from_file_location('data_reuse_fixture_v20', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module, path


original_freeze, original_validate = base.freeze, base.validate


def freeze(*args, **kwargs):
    original_freeze(*args, **kwargs)
    output = args[1]
    protocol = base.read(output)
    protocol['v20_wrapper'] = base.ident(__file__)
    protocol['decision_freeze'] = 'Exact candidates/graphs/actual checks and unchanged assumed model frozen before v20 NPU observations; no fitting.'
    protocol['comparison'] = 'Same arithmetic inputs and source-rounded FP32 plus independent unrounded FP64; host invocation distributions; no physical DMA/core timing claim.'
    for case in protocol['cases']:
        compiled = Path(case['plan']['path']).parent
        for key, filename in [('implementation_contract', 'implementation-contract.json'),
                              ('program_graph', 'program-graph.json'),
                              ('target_configuration', 'target.json'),
                              ('actual_facts', 'implementation-facts.json')]:
            case[key] = base.ident(compiled/filename)
        assert base.read(case['implementation_contract']['path'])['valid'] is True
        plan = base.read(case['plan']['path'])
        case['frozen_prediction'] = dict(ms=plan['estimated_ms'], graph_id=plan['program_graph_id'],
            groups=len(plan['execution_groups']), requested_transfer_bytes=plan['actual_dma_bytes'],
            peak_payload_bytes=plan['resident_bytes'])
    base.write(output, protocol)


def validate(protocol):
    original_validate(protocol)
    base.verify(protocol['v20_wrapper'])
    for case in protocol['cases']:
        for key in ['implementation_contract', 'program_graph', 'target_configuration', 'actual_facts']:
            base.verify(case[key])
        assert base.read(case['implementation_contract']['path'])['valid'] is True
        assert base.read(case['plan']['path'])['estimated_ms'] == case['frozen_prediction']['ms']
        fixture = base.read(case['fixture']['path'])
        assert fixture['schema'] == 'orbit.data-reuse.fixture.v20'
        assert fixture['fixture']['kind'] in ('interleaved', 'shared-input')


base.fixture_module, base.freeze, base.validate = fixture_module, freeze, validate
if __name__ == '__main__':
    base.main()
