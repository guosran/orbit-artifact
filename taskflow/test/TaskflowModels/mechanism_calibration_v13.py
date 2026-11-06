#!/usr/bin/env python3
"""Synthetic CPU contracts for mechanism NNLS and training-only input guards."""
import argparse
import importlib.util
import json
from pathlib import Path
import tempfile
import numpy as np

spec=importlib.util.spec_from_file_location('calibrate',Path(__file__).with_name('calibrate_mechanisms_v13.py'))
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    a.output.mkdir(parents=True,exist_ok=False);checks=[]
    samples=[dict(bytes=b,count=c,api_ms=c*(0.012+0.000003*b)) for b in (1024,4096,16384,65536) for c in (1,4)]
    f=m.nnls_two(samples);assert abs(f['alpha_ms']-0.012)<1e-12 and abs(f['beta_ms_per_byte']-0.000003)<1e-15;checks.append('exact positive two-coefficient law recovered')
    samples=[dict(bytes=b,count=c,api_ms=c*0.025) for b in (1024,4096,16384) for c in (1,4)]
    f=m.nnls_two(samples);assert abs(f['alpha_ms']-.025)<1e-12 and f['beta_ms_per_byte']<1e-18;checks.append('zero size slope remains unresolved; not physical bandwidth')
    f=m.nnls_two([dict(bytes=b,count=c,api_ms=c*0.000002*b) for b in (1024,4096,16384) for c in (1,4)])
    assert f['alpha_ms']<1e-12 and abs(f['beta_ms_per_byte']-.000002)<1e-15;checks.append('alpha-zero nonnegative boundary supported')
    f=m.nnls_two([dict(bytes=1024,count=c,api_ms=.1*c) for c in (1,4)])
    assert f['status']=='uncalibrated' and f['alpha_ms'] is None;checks.append('rank-deficient sizes never fabricate two parameters')
    f=m.nnls_two([dict(bytes=b,count=c,api_ms=c*(.01+e)) for b in (1,2) for c in (1,4) for e in (-.002,.002)])
    assert f['beta_resolution']=='unresolved-at-observed-noise';checks.append('tiny-byte noisy slope explicitly unresolved')
    f=m.nnls_two([dict(bytes=0,count=c,api_ms=.02*c) for c in (1,4)],True)
    assert abs(f['alpha_ms']-.02)<1e-12 and f['beta_ms_per_byte']==0;checks.append('actual-submit fit alpha only')
    for sample in (dict(bytes=1,count=1,api_ms=-1),dict(bytes=1,count=0,api_ms=1),dict(bytes=1,count=True,api_ms=1),dict(bytes=1,count=1,api_ms=float('nan'))):
        try:m.nnls_two([sample])
        except ValueError:pass
        else:raise AssertionError('invalid sample accepted')
    checks.append('negative/nonfinite/nonpositive/bool measurements rejected')
    with tempfile.TemporaryDirectory() as tmp:
        root=Path(tmp);protocol=root/'protocol.json';protocol.write_text(json.dumps(dict(schema='orbit.mechanism.microbench-protocol.v13')))
        (root/'freeze.json').write_text(json.dumps(dict(protocol_sha256=m.sha(protocol))))
        run=root/'run';run.mkdir();(run/'identity.json').write_text(json.dumps(dict(split='holdout')))
        # Label files do not exist: rejection must precede opening any label path.
        try:m.load_training(protocol,run)
        except ValueError as error:assert 'refuses holdout' in str(error)
        else:raise AssertionError('heldout run accepted')
        checks.append('heldout identity rejected before label files are opened')
        # Stub byte identities, never real runtime imports; exercise exact per-API state progression.
        fake=root/'fake-runtime';fake.write_bytes(b'CPU test identity only')
        proto=dict(schema='orbit.mechanism.microbench-protocol.v13',executor=dict(path=str(fake),sha256=m.sha(fake)),
            train=dict(sizes_bytes=[1024,4096],counts=[1,4]),copy_paths=[],directions=['TO_DEVICE'],states=['host-written'],
            warmups=0,repeats=1,program_cases=[])
        protocol.write_text(json.dumps(proto));(root/'freeze.json').write_text(json.dumps(dict(protocol_sha256=m.sha(protocol))))
        snapshot=run/'microbench-source.py';snapshot.write_bytes(b'CPU stub snapshot only')
        (run/'protocol.json').write_bytes(protocol.read_bytes())
        (run/'identity.json').write_text(json.dumps(dict(split='training',protocol_sha256=m.sha(protocol),microbench_sha256=m.sha(snapshot),
            executor=proto['executor'],pyxrt_path=str(fake),pyxrt_sha256=m.sha(fake),multilaunch_path=str(fake),multilaunch_sha256=m.sha(fake))))
        memory=[]
        for size in proto['train']['sizes_bytes']:
            events=[dict(index=i,start_ns=10*i,end_ns=10*i+5,elapsed_ns=5) for i in range(4)]
            memory.append(dict(split='training',mechanism='bo-sync-TO_DEVICE',state='host-written',count=4,bytes_per_call=size,
                repeat=0,warmup=False,start_ns=0,end_ns=40,api_total_ns=20,outer_sequence_ns=40,api_events=events))
        (run/'memory-samples.json').write_text(json.dumps(memory));(run/'program-samples.json').write_text('[]')
        _,_,groups,_=m.load_training(protocol,run)
        assert len(groups[('bo-sync-TO_DEVICE','host-written')])==2
        assert len(groups[('bo-sync-TO_DEVICE','after-TO_DEVICE-sync')])==6
        assert all(v['count']==1 and v['raw']['api_index']==0 for v in groups[('bo-sync-TO_DEVICE','host-written')])
        assert all(v['count']==1 and v['raw']['api_index']>0 for v in groups[('bo-sync-TO_DEVICE','after-TO_DEVICE-sync')])
        checks.append('sync first-state and subsequent same-buffer state decomposed per actual API index')
    (a.output/'summary.json').write_text(json.dumps(dict(status='passed',checks=checks,count=len(checks),synthetic=True,device_submissions=0),indent=2)+'\n')
    print(json.dumps(dict(status='passed',checks=len(checks))))
if __name__=='__main__':main()
