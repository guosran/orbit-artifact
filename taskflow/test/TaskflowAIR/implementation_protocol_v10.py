#!/usr/bin/env python3
"""CPU preregistration/reference tests; no compiler, model fitting or device."""
import argparse
import copy
import importlib.util
import json
from pathlib import Path
import sys
import numpy as np

SOURCE = Path(__file__).with_name('prepare_implementation_search_v10.py')
spec = importlib.util.spec_from_file_location('prepare_v10', SOURCE)
prepare = importlib.util.module_from_spec(spec)
spec.loader.exec_module(prepare)
sys.path.insert(0,str(prepare.ROOT/'scripts'))
from taskflow_implementation_search_v10 import legal_candidate


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    out = args.output.resolve()
    out.mkdir(parents=True, exist_ok=False)
    matrix = dict(schema='orbit.implementation-search.matrix.v10', status='preregistered',
                  seeds=[11,23,47], timing=dict(observer='detailed',warmups=2,hot=5),
                  boundary='prepared-command-host-to-host', model_protocol=dict(scope='synthetic CPU protocol only'),
                  programs=[dict(id='small',m=3,k=5,n=7)], cells=[
                      dict(name='train',program='small',split='train',tile_sizes=[2,4,3],implementation='scalar:1',data_organization='phase-local'),
                      dict(name='held',program='small',split='holdout',tile_sizes=[1,4,3],implementation='scalar-product-vector-add-f32:8',data_organization='phase-local')])
    def reject(value):
        try:prepare.validate(value)
        except ValueError:return
        raise AssertionError('malformed preregistration accepted')
    unknown=dict(status='uncalibrated',evaluation=dict(status='uncalibrated',diagnostics=dict(status='uncalibrated',best_plan=dict(analysis_status='supported',codegen_status='requires_backend_verification',cost_status='uncalibrated',estimated_ms=None))))
    assert legal_candidate(unknown)
    for change in [('status','unsupported'),('analysis_status','unsupported'),('estimated_ms',1.0)]:
        bad_unknown=copy.deepcopy(unknown)
        if change[0]=='status':bad_unknown['status']=change[1]
        else:bad_unknown['evaluation']['diagnostics']['best_plan'][change[0]]=change[1]
        assert not legal_candidate(bad_unknown)
    bad=copy.deepcopy(matrix);bad['status']='draft';reject(bad)
    bad=copy.deepcopy(matrix);bad['cells'][1]=dict(bad['cells'][0],name='held',split='holdout');reject(bad)
    bad=copy.deepcopy(matrix);bad['cells'][0]['tile_sizes'][0]=True;reject(bad)
    prepare.save(out/'matrix.json',matrix)
    models=prepare.ARTIFACT_REPO/'reference/input0-neighborhood/models'
    record=prepare.prepare(out/'matrix.json',out/'prepared',models)
    assert record['timing_labels_read'] is False and record['device_submissions']==0
    directory=out/'prepared/inputs/small'
    for seed in [11,23,47]:
        with np.load(directory/f'inputs-{seed}.npz') as inputs,np.load(directory/f'reference-{seed}.npz') as refs:
            expected=(.5*(inputs['A'].astype(np.float64)@inputs['B'].astype(np.float64))).astype(np.float32)
            np.testing.assert_array_equal(refs['Y'],expected)
            assert refs['Y'].shape==(3,7) and refs['Y'].dtype==np.float32
    text=(directory/'source.mlir').read_text()
    assert 'memref<3x5xf32>' in text and 'memref<5x7xf32>' in text and 'memref<3x7xf32>' in text
    assert not any(name in text for name in ['orbit.mapping','orbit.air_tile_sizes','air.dma','FIFO'])
    assert prepare.cgra_identity(models)==record['cgra']
    summary=dict(status='passed',checks=['native legal unpriced candidate retained and illegal/priced mutants rejected','draft rejected','duplicate coordinate leakage rejected','bool tile rejected',
                 'three seed independent FP64 reference equations and FP32 output shapes',
                 'source remains computation/dependency only','existing CGRA model hashes unchanged'],
                 compilation=False,device_submissions=0,timing_labels_read=False,
                 scope='small CPU fixture; not a real preregistered hardware experiment')
    prepare.save(out/'summary.json',summary)
    print(json.dumps(summary))


if __name__=='__main__':
    main()
