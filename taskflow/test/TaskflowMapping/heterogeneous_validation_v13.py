#!/usr/bin/env python3
"""Offline fixture/reference validation for v13; no builds, models or devices.

Execution/region evidence will be added only after its native interface is
agreed. This first mode does not claim verification of MLIR computation semantics.
"""
import argparse
import hashlib
import json
from pathlib import Path


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def numerical_metrics(actual, reference):
    import numpy as np
    if actual.shape != reference.shape:
        return dict(passed=False,reason='shape mismatch')
    a, r = actual.astype(np.float64), reference.astype(np.float64)
    finite = bool(np.isfinite(a).all() and np.isfinite(r).all())
    if not finite:
        return dict(passed=False,finite=False)
    delta, magnitude = np.abs(a-r),np.abs(r)
    normal = magnitude >= 1e-6
    return dict(passed=bool(np.all(delta <= 1e-5+1e-5*magnitude)),finite=True,
        max_abs=float(delta.max()),normalized_l2=float(np.linalg.norm(delta)/max(np.linalg.norm(r),1e-300)),
        max_relative_reference_at_least_1e_minus6=float((delta[normal]/magnitude[normal]).max()) if normal.any() else None,
        near_zero_max_abs=float(delta[~normal].max()) if (~normal).any() else None)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--fixtures',type=Path,required=True,help='directory containing numerical fixture manifest.json')
    parser.add_argument('--output',type=Path,required=True)
    args = parser.parse_args()
    import numpy as np
    root,out=args.fixtures.resolve(),args.output.resolve()
    out.mkdir(parents=True,exist_ok=False)
    snapshot=out/'validator-source.py'
    snapshot.write_bytes(Path(__file__).read_bytes())
    manifest=json.loads((root/'manifest.json').read_text())
    assert manifest['schema']=='orbit.heterogeneous.fixtures.v13'
    assert manifest['timing_labels_present'] is False and manifest['production_planning'] is False
    assert manifest['split_status'] in ['proposal-not-frozen','frozen-before-timing-labels']
    assert sha(root/manifest['generator']['snapshot'])==manifest['generator']['sha256']
    seen_shapes,seen_names,checks,identities=set(),set(),[],{}
    for case in manifest['cases']:
        m,n=case['shape'];shape=(m,n)
        assert case['split'] in ['training','holdout','capacity-rejection'] and shape not in seen_shapes and case['name'] not in seen_names
        seen_shapes.add(shape);seen_names.add(case['name'])
        if 'static_protocol' in manifest:
            key={'training':'training_shapes','holdout':'holdout_shapes','capacity-rejection':'capacity_rejection_shapes'}[case['split']]
            assert list(shape) in manifest['static_protocol'][key]
            assert case['model_label_eligible'] == (case['split']!='capacity-rejection')
        source=root/case['source']['path']
        assert sha(source)==case['source']['sha256']
        assert not any(token in source.read_text() for token in ['orbit.air_tile_sizes','orbit.implementation','taskflow.channel','air.launch'])
        identities[str(source)]=sha(source)
        assert {row['seed'] for row in case['arrays']}==set(manifest['seeds'])
        for row in case['arrays']:
            paths={kind:root/row[kind]['path'] for kind in ['inputs','reference','intermediate_reference']}
            for kind,path in paths.items():
                assert sha(path)==row[kind]['sha256']
                identities[str(path)]=sha(path)
            with np.load(paths['inputs']) as inputs,np.load(paths['reference']) as output,np.load(paths['intermediate_reference']) as intermediate:
                assert set(inputs.files)=={'A','B'} and set(output.files)=={'C'} and set(intermediate.files)=={'T','U'}
                assert all(inputs[k].shape==shape and inputs[k].dtype==np.float32 for k in inputs.files)
                t=inputs['A'].astype(np.float64)+inputs['B'].astype(np.float64)
                references=dict(T=t.astype(np.float32),U=(2*t).astype(np.float32),C=(2*t+inputs['B'].astype(np.float64)).astype(np.float32))
                for name,value in dict(C=output['C'],T=intermediate['T'],U=intermediate['U']).items():
                    assert value.dtype==np.float32 and np.array_equal(value,references[name])
                    metric=numerical_metrics(value,references[name]);assert metric['passed']
                    checks.append(dict(case=case['name'],split=case['split'],seed=row['seed'],buffer=name,**metric))
    if 'static_protocol' in manifest:
        declared={tuple(shape) for key in ['training_shapes','holdout_shapes','capacity_rejection_shapes'] for shape in manifest['static_protocol'][key]}
        assert seen_shapes==declared, 'missing or extra declared shape'
        assert manifest['static_protocol']['seeds']==manifest['seeds']
    report=dict(status='passed',checks=checks,files=identities,manifest_sha256=sha(root/'manifest.json'),validator_sha256=sha(snapshot),
        device_submissions=0,compiled_execution=False,model_training=False,split_status=manifest['split_status'],
        source_semantics_verified_by_native=False,scope='Saved fixture source/array SHA and complete independent float64 reference readback; no timing labels or production plan. Native semantic/compiled execution checks remain required.')
    (out/'summary.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(dict(status='passed',reference_arrays=len(checks),compiled_execution=False)))


if __name__=='__main__':
    main()
