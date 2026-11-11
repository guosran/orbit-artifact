#!/usr/bin/env python3
"""SHA-frozen arithmetic replay over the existing locked NPU observer."""
import importlib.util
import hashlib
import json
from pathlib import Path

import taskflow_program_probe_v16 as base


def fixture_module():
    path = Path(__file__).resolve().parents[1]/'test/TaskflowAIR/prepare_data_reuse_v21.py'
    spec = importlib.util.spec_from_file_location('data_reuse_fixture_v21', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module, path


original_freeze, original_validate = base.freeze, base.validate


def actual_signature(path):
    def clean(value):
        if isinstance(value, list):
            return [clean(item) for item in value]
        if isinstance(value, dict):
            return {key: clean(item) for key, item in value.items()
                    if key != 'proposed_bindings' and not key.startswith('orbit.')}
        return value
    operations = clean(base.read(path)['operations'])
    return hashlib.sha256(json.dumps(operations, sort_keys=True,
        separators=(',', ':')).encode()).hexdigest()


def freeze(*args, **kwargs):
    original_freeze(*args, **kwargs)
    output = args[1]
    protocol = base.read(output)
    protocol['v21_wrapper'] = base.ident(__file__)
    protocol['decision_freeze'] = 'Exact candidates/graphs/actual checks and unchanged assumed model frozen before v21 NPU observations; no fitting.'
    protocol['comparison'] = 'Same arithmetic inputs and source-rounded FP32 plus independent unrounded FP64; host invocation distributions; no physical DMA/core timing claim.'
    for case in protocol['cases']:
        compiled = Path(case['plan']['path']).parent
        for key, filename in [('implementation_contract', 'implementation-contract.json'),
                              ('program_graph', 'program-graph.json'),
                              ('target_configuration', 'target.json'),
                              ('actual_facts', 'implementation-facts.json')]:
            case[key] = base.ident(compiled/filename)
        assert base.read(case['implementation_contract']['path'])['valid'] is True
        case['actual_structure_sha256'] = actual_signature(case['actual_facts']['path'])
        plan = base.read(case['plan']['path'])
        case['frozen_prediction'] = dict(ms=plan['estimated_ms'], graph_id=plan['program_graph_id'],
            groups=len(plan['execution_groups']), requested_transfer_bytes=plan['actual_dma_bytes'],
            peak_payload_bytes=plan['resident_bytes'])
    structures = [(base.read(case['fixture']['path'])['fixture']['kind'],
                   case['actual_structure_sha256']) for case in protocol['cases']]
    assert len(set(structures)) == len(structures), 'same actual implementation must have one measured case and multiple aliases'
    base.write(output, protocol)


def validate(protocol):
    original_validate(protocol)
    base.verify(protocol['v21_wrapper'])
    for case in protocol['cases']:
        for key in ['implementation_contract', 'program_graph', 'target_configuration', 'actual_facts']:
            base.verify(case[key])
        assert base.read(case['implementation_contract']['path'])['valid'] is True
        assert actual_signature(case['actual_facts']['path']) == case['actual_structure_sha256']
        assert base.read(case['plan']['path'])['estimated_ms'] == case['frozen_prediction']['ms']
        fixture = base.read(case['fixture']['path'])
        assert fixture['schema'] == 'orbit.data-reuse.fixture.v21'
        assert fixture['fixture']['kind'] in ('interleaved', 'shared-input', 'coupling')


base.fixture_module, base.freeze, base.validate = fixture_module, freeze, validate
if __name__ == '__main__':
    base.main()
