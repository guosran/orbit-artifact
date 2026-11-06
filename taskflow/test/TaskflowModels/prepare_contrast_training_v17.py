#!/usr/bin/env python3
"""Wait for complete TRAIN pair runs, audit native identity/copies, fit delta-only.

Reads only rows marked train in the native index. It opens no performance file
until every expected training summary reports completion. No device calls and no
production planning/model configuration. Output is immutable independent audit
and numerical parameter-candidate evidence for the existing C++ provider.
"""
import argparse
import json
from pathlib import Path
import sys
import time
from collections import defaultdict
from audit_mechanism_program_v16 import read,verify,identity
from contrast_evidence_v17 import bound_measurements
from contrast_numerics_v17 import calibrate

FEATURES={'readonly-copy-retention':['input_delivery_count','requested_dma_bytes'],
          'intermediate-region-residency':['hardware_stage_count','materialized_region_realizations','requested_dma_bytes']}

def write(p,o):p.write_text(json.dumps(o,indent=2,allow_nan=False)+'\n')
def prepare(index,measurements,registration,out,wait_seconds):
    assert not out.exists(),'NEW output required'
    idx=read(index);rows=[c for c in idx['cases'] if c['split']=='train'];assert len(rows)==10
    assert len({c['pair_id'] for c in rows})==len(rows)
    deadline=time.monotonic()+wait_seconds;previous=None
    while True:
        missing=[]
        for c in rows:
            root=measurements/c['pair_id']
            if (root/'failure.json').exists():raise RuntimeError('retained training failure: '+str(root))
            if not (root/'summary.json').exists():missing.append(c['pair_id'])
            else:assert read(root/'summary.json')['status']=='passed'
        if not missing:break
        if missing!=previous:print(json.dumps(dict(status='waiting-training-completion',remaining=missing)),flush=True);previous=missing
        if time.monotonic()>=deadline:raise RuntimeError('training is incomplete; no performance labels opened')
        time.sleep(3)
    reg=read(registration);assert reg['model']['kind']=='contrast-composite'
    for cls,keys in FEATURES.items():assert reg['model']['classes'][cls]['terms']==keys,'registration and independent solver differ'
    out.mkdir(parents=True)
    grouped=defaultdict(list);evidence=[identity(index),identity(registration),identity(__file__),identity(Path(__file__).with_name('contrast_evidence_v17.py')),identity(Path(__file__).with_name('contrast_numerics_v17.py'))];audits=[]
    for c in rows:
        facts=read(verify(c['facts']));compiled_index=read(verify(c['compiled_index']));pairs=[p for p in compiled_index['cases'] if p['pair_id']==c['pair_id']];assert len(pairs)==1;pair=pairs[0]
        expected_protocol=verify(c['protocol']);actual=measurements/c['pair_id'];assert identity(actual/'protocol.json')['sha256']==identity(expected_protocol)['sha256']
        audit=bound_measurements(pair,facts,actual);write(out/(c['pair_id']+'-evidence.json'),audit);audits.append(identity(out/(c['pair_id']+'-evidence.json')))
        keys=FEATURES[c['change_class']]
        grouped[c['change_class']].append(dict(pair_id=c['pair_id'],split='train',feature_delta=[facts['delta_quantities'][k] for k in keys],observations=[dict(seed=o['seed'],repeat=o['repeat'],delta_ns=o['delta_ns']) for o in audit['observations']]))
        evidence.extend([c['facts'],c['compiled_index'],c['protocol'],audit['raw_samples'],audit['runtime']])
    fits=[]
    for cls,observations in grouped.items():
        adapter=out/(cls+'-training-adapter.json');write(adapter,dict(split='train',feature_names=FEATURES[cls],evidence=evidence,rows=observations))
        fit=calibrate(adapter);fitpath=out/(cls+'-fit.json');write(fitpath,fit)
        residual=max(p['absolute_error_ns'] for p in fit['training_pairs']);identified=[p for p in fit['leave_one_training_pair_out'] if p['status']=='identified'];all_loo=len(identified)==len(fit['training_pairs'])
        bound=None if not all_loo else residual+max(abs(p['error_ns']) for p in identified)
        fits.append(dict(change_class=cls,fit=identity(fitpath),coefficients_ns=dict(zip(FEATURES[cls],fit['coefficients_ns'])),training_max_absolute_median_residual_ns=residual,all_loo_identified=all_loo,descriptive_prediction_error_allowance_ns=bound,scope='Training maximum residual plus maximum leave-one-pair-out error; descriptive extrapolation allowance, not a confidence bound.'))
    result=dict(status='passed',scope='TRAIN-ONLY independent numerical/source/identity audit and parameter candidates. Heldout labels unopened.',holdout_labels_read=False,source_index=identity(index),registration=identity(registration),training_pair_count=len(rows),calls=sum(len(read(p['path'])['numerical_checks']) for p in audits),evidence=audits,classes=fits)
    write(out/'summary.json',result);print(json.dumps(result,indent=2),flush=True)

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--facts-index',type=Path,required=True);p.add_argument('--measurements',type=Path,required=True);p.add_argument('--registration',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--wait-seconds',type=int,default=0);a=p.parse_args();prepare(a.facts_index,a.measurements,a.registration,a.output,a.wait_seconds)
if __name__=='__main__':main()
