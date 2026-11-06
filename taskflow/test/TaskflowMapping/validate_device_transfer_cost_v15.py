#!/usr/bin/env python3
"""Independent frozen-model error audit, never a production planner or scorer."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import sys
import numpy as np


def read(p):return json.loads(Path(p).read_text())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def ident(p):return {'path':str(Path(p).resolve()),'sha256':sha(p)}
def verify(x):
    assert sha(x['path'])==x['sha256'],f"changed evidence {x['path']}"
    return Path(x['path'])

def errors(predicted,actual):
    error=abs(predicted-actual);limit=max(300000,.25*actual)
    return {'prediction_ns':float(predicted),'actual_ns':float(actual),'signed_error_ns':float(predicted-actual),
        'absolute_error_ns':float(error),'relative_error':float(error/actual),'limit_ns':float(limit),'passed':bool(error<=limit)}

def independent_kkt(row,cells):
    x=np.asarray([[1,c['descriptor_bytes']] for c in cells],float);y=np.asarray([c['median_ns'] for c in cells],float)
    b=np.asarray([row['entry_ns'],row['byte_ns']]);scale=np.linalg.norm(x,axis=0);z=x/scale
    assert np.linalg.matrix_rank(z)==2
    gradient=z.T@(x@b-y);tol=1e-7*max(1,float(np.linalg.norm(y)))
    for j in range(2):
        if b[j]>1e-9:assert abs(gradient[j])<tol,'training-only optimum stationarity failed'
        else:assert gradient[j]>=-tol,'training-only boundary optimum failed'
    assert row['segment_ns']==0
    return {'passed':True,'rank':2,'normalized_condition':float(np.linalg.cond(z)),'scaled_gradient':gradient.tolist(),
        'scope':'independent convex optimality check of frozen training coefficients; no refit'}

def audit_run(root,out):
    analyzer=Path(__file__).resolve().parents[1]/'TaskflowModels/analyze_device_transfer_v15.py'
    argv=[sys.executable,str(analyzer),'--input',str(root),'--output',str(out)]
    r=subprocess.run(argv,capture_output=True,text=True)
    assert r.returncode==0,r.stderr
    return read(out/'summary.json'),{'argv':argv,'returncode':r.returncode,'stdout':r.stdout,'stderr':r.stderr}

def model_match(row,fact):
    d=row['domain'];binding=fact['binding']
    for key in ('runtime_identity','toolchain_identity','path_identity','observer_identity','condition_identity'):
        assert d[key]==binding[key],f'mismatched exact domain {key}'
    assert d['architecture_identity']==fact['architecture_identity']
    assert d['implementation']==fact['implementation']=='identity-copy-f32'
    assert d['completion_boundary']==binding['completion_boundary']=='submit-to-successful-wait-return'
    assert d['min_bytes']<=fact['descriptor_bytes']<=d['max_bytes']
    assert d['min_segments']<=fact['segment_count']<=d['max_segments']
    assert d['min_tile_elements']<=fact['tile_elements']<=d['max_tile_elements']
    assert fact['physical_ddr_bytes'] is None and fact['runtime_descriptor_count']==2
    return row['entry_ns']+row['byte_ns']*fact['descriptor_bytes']

def main():
    p=argparse.ArgumentParser(description=__doc__)
    for k in ('calibration-root','holdout-root','model-root','facts-calibration','facts-holdout','output'):p.add_argument('--'+k,type=Path,required=True)
    p.add_argument('--runtime-before',type=Path,required=True);p.add_argument('--runtime-after',type=Path,required=True)
    p.add_argument('--holdout-gate',type=Path);p.add_argument('--evaluations',type=Path,help='optional index cases->{path,sha256} of actual C++ model evaluations')
    a=p.parse_args();assert not a.output.exists();model=read(a.model_root/'model.json');freeze=read(a.model_root/'freeze.json')
    for x in freeze['files'].values():verify(x)
    assert len(model['rows'])==1 and model['schema']=='orbit.device-transfer.model.v15' and model['units']=='ns'
    row=model['rows'][0];assert row['segment_ns']==0 and all(np.isfinite(row[k]) and row[k]>=0 for k in ('entry_ns','byte_ns'))
    assert sha(a.model_root/'raw-manifest.json')==row['raw_manifest_sha256']
    raw_manifest=read(a.model_root/'raw-manifest.json');binding=read(verify(raw_manifest['bindings']))
    before,after=read(a.runtime_before),read(a.runtime_after)
    assert before==after and before['target_id']==binding['runtime_descriptor']['target_fingerprint_id']
    assert row['domain']['runtime_identity']==binding['runtime_identity']
    assert model['acceptance']=={'absolute_floor_ns':300000,'relative_fraction':.25,'comparison':'per heldout cell median'}
    if a.holdout_gate:assert sha(a.model_root/'model.json') in a.holdout_gate.read_text(),'gate must bind exact pre-held parameter bytes'
    assert read(a.calibration_root/'protocol.json')['split']=='calibration'
    assert read(a.holdout_root/'protocol.json')['split']=='holdout'
    a.output.mkdir(parents=True)
    calibration,cc=audit_run(a.calibration_root,a.output/'independent-calibration')
    holdout,hc=audit_run(a.holdout_root,a.output/'independent-holdout')
    assert calibration['active_contexts']==holdout['active_contexts']==9
    assert calibration['measurement_runner_source']['sha256']==holdout['measurement_runner_source']['sha256']==row['domain']['observer_identity']
    assert calibration['actual_selected_wait_backends']==holdout['actual_selected_wait_backends']
    facts_c=read(a.facts_calibration);facts_h=read(a.facts_holdout);training=[];held=[];individual=[];seed=[]
    for report,index,split in [(calibration,facts_c,'calibration'),(holdout,facts_h,'holdout')]:
        cases={c['case']:c for c in report['cases']};assert set(index['cases'])==set(cases)
        for distribution in report['distributions']:
            name=distribution['case'];fact=read(verify(index['cases'][name]));c=cases[name]
            assert c['fixture']['adds']==0
            assert fact['descriptor_bytes']==c['native_input_bytes']+c['native_output_bytes']
            assert fact['segment_count']==c['native_segments_each_direction']
            assert fact['binding']['artifact_sha256']==c['ELF']['sha256']
            prediction=model_match(row,fact);actual=distribution['parts']['dispatch_to_wait_end_ns']['median_ns']
            cell={'case':name,'fixture':c['fixture'],'descriptor_bytes':fact['descriptor_bytes'],'segments':fact['segment_count'],
                'distribution':distribution['parts']['dispatch_to_wait_end_ns'],'facts':index['cases'][name],**errors(prediction,actual)}
            if split=='calibration':training.append(cell)
            else:
                cell['segment3_below_training_min4']=fact['segment_count']==3
                cell['tile2048_above_training_max1024']=fact['tile_elements']==2048
                held.append(cell)
                for se,parts in distribution['by_seed'].items():seed.append({'case':name,'seed':se,**errors(prediction,parts['dispatch_to_wait_end_ns']['median_ns'])})
                for sample in report['all_individual_timing_observations']:
                    if sample['case']==name and not sample['warmup']:
                        individual.append({'case':name,'seed':sample['seed'],'repeat':sample['repeat'],**errors(prediction,sample['parts']['dispatch_to_wait_end_ns'])})
    assert len(training)==len(held)==9
    kkt=independent_kkt(row,[{'descriptor_bytes':r['descriptor_bytes'],'median_ns':r['actual_ns']} for r in training])
    cpp=[]
    if a.evaluations:
        ei=read(a.evaluations)
        for name,witness in ei['cases'].items():
            e=read(verify(witness));cell=next(c for c in held if c['case']==name)
            assert e['status']=='predicted' and abs(e['duration_ns']-cell['prediction_ns'])<1e-8
            assert e['parameter_file_sha256']==sha(a.model_root/'model.json')
            cpp.append({'case':name,'evaluation':witness,'matched_prediction':True})
    result={'schema':'orbit.device-transfer.cost-validation.v15','structural_numerical_status':'passed','model':ident(a.model_root/'model.json'),
        'heldout_runtime_before':ident(a.runtime_before),'heldout_runtime_after':ident(a.runtime_after),'calibration':training,'holdout':held,'training_optimality':kkt,'holdout_per_seed':seed,'holdout_all_individual_hot_errors':individual,
        'heldout_passed_cells':sum(c['passed'] for c in held),'heldout_cells':len(held),
        'heldout_MAPE':float(np.mean([c['relative_error'] for c in held])),'heldout_max_absolute_error_ns':max(c['absolute_error_ns'] for c in held),
        'heldout_individual_fraction_meeting_cell_threshold':sum(c['passed'] for c in individual)/len(individual),
        'holdout_numerical_outputs':holdout['samples'],'max_abs_unrounded_f64':holdout['max_abs_unrounded_f64'],
        'actual_CPP_evaluation_comparisons':cpp,'commands':[cc,hc],
        'scope':['No parameters changed and no holdout labels used to fit.',
            'Threshold applies to cell medians; individual-sample errors and tails are reported without confidence guarantees.',
            'Differences below300us do not support a performance ranking.',
            'Byte coefficient prices the guarded duplex-copy completion envelope, including fixed copy/core/runtime/polling effects; not isolated DMA or physical bandwidth.',
            'Segment0 is an omitted independent coefficient, not free physical transfer; all observed work is included in the composite label.',
            'No automatic v14 BOsync coefficient transfer, no baseline subtraction, no whole-program price.']}
    (a.output/'summary.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n');shutil.copyfile(__file__,a.output/'auditor-source.py')
    print(json.dumps({'status':'passed','heldout_cells':len(held),'heldout_passed':result['heldout_passed_cells'],'MAPE':result['heldout_MAPE'],'summary':ident(a.output/'summary.json')}))

if __name__=='__main__':main()
