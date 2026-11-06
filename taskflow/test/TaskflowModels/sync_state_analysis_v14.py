#!/usr/bin/env python3
"""CPU-only contracts for independent v14 prefix/reference analysis."""
import argparse
import copy
import importlib.util
import json
from pathlib import Path
import tempfile
import numpy as np

spec=importlib.util.spec_from_file_location('analysis',Path(__file__).with_name('analyze_sync_state_v14.py'))
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False);checks=[]
    cell=dict(bo_bytes=1024,offset_bytes=256,size_bytes=256,direction='TO_DEVICE',state='deliberately-wrong-cell-label')
    sample=dict(cell=cell,setup=[dict(kind='new-ext-bo-map-initialize',start_ns=0,end_ns=10),
        dict(kind='untimed-prior-TO-before-host-range-action',start_ns=11,end_ns=12),
        dict(kind='untimed-host-read-range',start_ns=13,end_ns=14,offset=256,bytes=256)])
    events=m.prefix_events(sample,'b');prefix,coverage=m.initial_signature(events,cell)
    assert prefix=='host-read-range-after-sync' and coverage=='none';checks.append('prefix comes from actual ordered setup, not cell state name')
    sample['setup'][-1]=dict(kind='untimed-host-write-range',start_ns=13,end_ns=14,offset=256,bytes=64)
    events=m.prefix_events(sample,'b');prefix,coverage=m.initial_signature(events,cell)
    assert prefix=='host-write-range-after-sync' and coverage=='partial';checks.append('actual host dirty subrange coverage preserved')
    d=m.stats([-7,-5,-3]);assert d['median_ns']==-5 and d['samples_over_10x_median'] is None;checks.append('signed overhead differences retained without fake positive-time outlier ratio')
    with tempfile.TemporaryDirectory() as tmp:
        tmp=Path(tmp);inp=tmp/'inputs.npz';ref=tmp/'reference.npz';out=tmp/'outputs.npz';saved=tmp/'savedref.npz'
        aa=np.full((4,64),.25,np.float32);bb=np.full_like(aa,.5);np.savez(inp,A=aa,B=bb);np.savez(ref,C=(2*(aa.astype('f8')+bb)+bb).astype('f4'))
        shadow=aa.copy();shadow.reshape(-1)[64:80]=np.float32(.125+(11%17)*.015625)
        expected=(2*(shadow.astype('f8')+bb.astype('f8'))+bb.astype('f8')).astype('f4');np.savez(out,C=expected);np.savez(saved,C=expected)
        run=dict(reason='after-measured-sync',outputs=m.ident(out),reference=m.ident(saved),runner_staging_copy_count=0,target_auto_to_skipped=True,
            events=[dict(kind='skipped_auto_to_A',actual_api_call=False),dict(kind='actual_xrt_start'),dict(kind='actual_xrt_wait')])
        sample=dict(cell=dict(direction='TO_DEVICE',offset_bytes=256,size_bytes=64),seed_index=0,seed=11,target=dict(storage=0),
            actual_setup_events=[dict(kind='HostWrite',offset_bytes=256,size_bytes=64)],verification_runs=[run])
        case=dict(inputs=[str(inp)],reference=[str(ref)])
        metrics=m.independently_check_program(sample,case,m.KNOWN_WRITE_SOURCE);assert metrics[0]['f64_unrounded']['passed'];checks.append('f64 full output independently reconstructed from NPZ and declared write range')
        wrong=np.zeros_like(expected);np.savez(out,C=wrong);np.savez(saved,C=wrong);run['outputs']=m.ident(out);run['reference']=m.ident(saved)
        try:m.independently_check_program(sample,case,m.KNOWN_WRITE_SOURCE)
        except ValueError as error:assert 'stored modified reference differs' in str(error)
        else:raise AssertionError('self-consistent fabricated output/ref accepted')
        checks.append('self-consistent wrong output and stored reference cannot replace source-derived expectation')
        np.savez(out,C=expected);np.savez(saved,C=expected);run['outputs']=m.ident(out);run['reference']=m.ident(saved)
        run['events'].append(dict(kind='actual_bo_sync',storage=0,direction='TO_DEVICE'))
        try:m.independently_check_program(sample,case,m.KNOWN_WRITE_SOURCE)
        except ValueError as error:assert 'hidden real target TO' in str(error)
        else:raise AssertionError('masked partial sync accepted')
        checks.append('hidden target full TO rejected by independent auditor')
    (a.output/'summary.json').write_text(json.dumps(dict(status='passed',count=len(checks),checks=checks,synthetic_inputs=True,device_submissions=0),indent=2)+'\n')
    print(json.dumps(dict(status='passed',checks=len(checks))))
if __name__=='__main__':main()
