#!/usr/bin/env python3
"""Read saved failed outputs only; no device/compiler calls and no new reference acceptance."""
import hashlib
import json
import re
import shutil
from pathlib import Path
import numpy as np

out = Path(__file__).resolve().parent
repo = out.parents[2]
root = repo/'results/taskflow/ffn-profiling-v9'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
records, identities = [], {}
for operation, apply in [('add', np.add), ('mul', np.multiply)]:
    name = f'train-m32-n64-{operation}-grouped'
    compiled = root/'controls-compiled'/name
    source = root/'controls-input-r2'/name/'source.mlir'
    assert source.read_bytes() == (compiled/'source.mlir').read_bytes()
    assert source.read_text().count('affine.for') == 2
    invocation = json.loads((compiled/'invocation.json').read_text())
    identities[name] = dict(source_sha256=sha(source), compiler_sha256=invocation['tool_sha256'])
    for f in ['source.mlir','facts.json','plan.json','program.air.mlir','hardware/compile.json',
              'hardware/air_project/aie.input.air.mlir','hardware/air_project/npu.input.air.mlir']:
        p = compiled/f
        identities[name][f] = dict(path=str(p), sha256=sha(p))
        shutil.copy2(p,out/(name+'__'+f.replace('/','__')))
    for seed in range(3):
        directory = root/f'profile-controls-train-r1/seed-{seed}'
        input_path = directory/(name+'-inputs.npz')
        reference_path = directory/(name+'-reference.npz')
        inputs, reference = np.load(input_path), np.load(reference_path)
        # Explicit diagnostic alternative, not the source equation: flatten
        # producers BO-major A0,A1,A2,A3,B0,... and consume four tiles per core
        # iteration as the A/B/D/E local buffer sequence.
        producer_tiles = [(storage, tile, inputs[storage][tile*8:(tile+1)*8])
            for storage in ('A','B','D','E') for tile in range(4)]
        files = sorted((p for p in directory.glob(name+'-*.npz')
            if re.fullmatch(re.escape(name)+r'-\d+\.npz',p.name)), key=lambda p:int(p.stem.rsplit('-',1)[1]))
        assert len(files) == 12
        for path in files:
            output = np.load(path)
            for storage, offset in [('Y',0),('Z',2)]:
                actual, correct = output[storage], reference[storage]
                hypothesis = np.empty_like(actual)
                pairs = []
                for tile in range(4):
                    lhs, rhs = producer_tiles[tile*4+offset:tile*4+offset+2]
                    hypothesis[tile*8:(tile+1)*8] = apply(lhs[2],rhs[2])
                    pairs.append([list(lhs[:2]),list(rhs[:2])])
                record = dict(case=name,seed=seed,repeat=int(path.stem.rsplit('-',1)[1]),output=storage,
                    raw_path=str(path), raw_sha256=sha(path), inputs_sha256=sha(input_path), reference_sha256=sha(reference_path),
                    source_max_abs=float(np.max(np.abs(actual-correct))),
                    source_allclose_original_tolerance=bool(np.allclose(actual,correct,atol=1e-5,rtol=1e-5)),
                    diagnostic_concatenation_pairs=pairs,
                    diagnostic_max_abs=float(np.max(np.abs(actual-hypothesis))),
                    diagnostic_bitwise_equal=bool(np.array_equal(actual,hypothesis)))
                assert not record['source_allclose_original_tolerance']
                if operation == 'mul': assert record['diagnostic_bitwise_equal']
                else: assert record['diagnostic_max_abs'] <= 2e-7
                records.append(record)
summary = dict(source_is_one_shared_perfect_two_loop_nest=True,source_matches_compiled_source=True,
    compiler_kind='frozen scalar production; not mixed experiment',
    output_checks=len(records),all_source_checks_failed=True,
    mul_diagnostic_all_bitwise_equal=all(r['diagnostic_bitwise_equal'] for r in records if '-mul-' in r['case']),
    add_diagnostic_max_abs=max(r['diagnostic_max_abs'] for r in records if '-add-' in r['case']),
    interpretation='Strong consistency with producer-stream concatenation into a repeated shared S2MM buffer chain. No packet trace or hardware event capture proves the causal routing mechanism.',
    scope='Post-hoc diagnostic alternative only; actual source reference/tolerance and failure status remain unchanged.',
    identities=identities,records=records,hardware_executed=False,compiled=False)
(out/'stream-match-evidence.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:summary[k] for k in ['output_checks','mul_diagnostic_all_bitwise_equal','add_diagnostic_max_abs','all_source_checks_failed']}))
