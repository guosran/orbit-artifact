#!/usr/bin/env python3
"""Training-only calibration of a guarded duplex-copy completion envelope.

Two nonnegative parameters: entry + byte*both-direction descriptor payload.
segment_ns is a fixed omitted term, not independently calibrated or free DMA.
"""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import sys
import numpy as np

IDENTITIES=('runtime_identity','toolchain_identity','path_identity','observer_identity','condition_identity')
TRAIN={(e,c) for e in (4096,16384,65536) for c in (64,256,1024)}
BOUNDS={'min_bytes':32768,'max_bytes':524288,'min_segments':3,'max_segments':1024,'min_tile_elements':64,'max_tile_elements':2048}

def read(p):return json.loads(Path(p).read_text())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def ident(p):return {'path':str(Path(p).resolve()),'sha256':sha(p)}
def verify(x):
    assert sha(x['path'])==x['sha256'],f"changed evidence {x['path']}"
    return Path(x['path'])
def encoded(x):return (json.dumps(x,indent=2,sort_keys=True,allow_nan=False)+'\n').encode()

def nnls2(x,y):
    x=np.asarray(x,float);y=np.asarray(y,float);scale=np.linalg.norm(x,axis=0);z=x/scale
    assert np.linalg.matrix_rank(z)==2,'unidentifiable entry/byte design'
    choices=[np.zeros(2)]
    unconstrained=np.linalg.lstsq(z,y,rcond=None)[0]/scale
    if np.min(unconstrained)>=-1e-8:choices.append(np.maximum(unconstrained,0))
    for j in range(2):
        b=np.zeros(2);b[j]=max(0,float(x[:,j]@y/(x[:,j]@x[:,j])));choices.append(b)
    b=min(choices,key=lambda b:float(np.sum((x@b-y)**2)))
    assert np.any(b>0)
    return b,{'rank':2,'normalized_condition':float(np.linalg.cond(z)),'squared_error_ns2':float(np.sum((x@b-y)**2))}

def fit(a):
    out=Path(a.output);assert not out.exists(),'NEW output required'
    protocol=read(a.protocol)
    assert protocol.get('split')=='calibration','calibration split required before opening labels'
    identity=read(Path(a.calibration_root)/'identity.json')
    assert identity['protocol']['sha256']==sha(a.protocol)==sha(Path(a.calibration_root)/'protocol.json')
    assert identity['source_sha256']==sha(Path(a.calibration_root)/'runner-source.py')
    assert read(Path(a.calibration_root)/'summary.json')['status']=='passed'
    audit=read(a.audit);assert audit['status']=='passed'
    assert audit['profile']['sha256']==sha(Path(a.calibration_root)/'summary.json')
    assert audit['raw_samples']['sha256']==sha(Path(a.calibration_root)/'samples.jsonl')
    assert audit['measurement_runner_source']['sha256']==identity['source_sha256']
    assert audit['active_contexts']==9 and len(protocol['cases'])==9 and protocol['observer']=='minimal'
    binding=read(a.bindings);index=read(a.facts)
    assert index['schema']=='orbit.device-transfer.facts-index.v15'
    cases={c['id']:c for c in protocol['cases']};assert set(index['cases'])==set(cases)
    assert {(c['fixture']['elements'],c['fixture']['chunk']) for c in cases.values()}==TRAIN
    assert all(c['fixture']['adds']==0 for c in cases.values())
    assert binding['condition']['prepared_context_count']==9
    assert binding['observer_identity']==identity['source_sha256']
    runtime=read(Path(a.calibration_root)/'runtime.json')
    descriptor=binding['runtime_descriptor']
    assert descriptor['installed_runner_sha256']==runtime['installed_runner']['sha256']
    assert descriptor['poll_interval_seconds']==.0002
    assert hashlib.sha256(json.dumps(descriptor,sort_keys=True,separators=(',',':')).encode()).hexdigest()==binding['runtime_identity']
    assert a.runtime_before and a.runtime_after,'actual calibration runtime captures required'
    before,after=read(a.runtime_before),read(a.runtime_after)
    assert before==after and before['target_id']==descriptor['target_fingerprint_id']
    assert hashlib.sha256(json.dumps(binding['condition'],sort_keys=True,separators=(',',':')).encode()).hexdigest()==binding['condition_identity']
    assert hashlib.sha256(json.dumps(binding['toolchain'],sort_keys=True,separators=(',',':')).encode()).hexdigest()==binding['toolchain_identity']
    registration=protocol['preregistered_model']
    assert registration['domain']==BOUNDS and set(map(tuple,registration['train']))==TRAIN
    assert registration['formula']=='entry_ns + byte_ns * total_both_direction_descriptor_bytes'
    assert registration['acceptance']['absolute_floor_ns']==300000 and registration['acceptance']['relative_fraction']==.25
    facts={};architecture=set();receipts=[]
    for name,c in cases.items():
        fact=read(verify(index['cases'][name]));artifact=read(verify(c['artifact']));f=c['fixture']
        assert fact['schema']=='orbit.device-transfer.facts.v15' and fact['implementation']=='identity-copy-f32'
        assert all(fact['binding'][k]==binding[k] for k in IDENTITIES)
        assert fact['binding']['artifact_sha256']==artifact['elf_sha256']==sha(artifact['elf_path'])
        assert fact['elements']==f['elements'] and fact['tile_elements']==f['chunk'] and fact['segment_count']==f['elements']//f['chunk']
        assert fact['descriptor_bytes']==fact['requested_bytes']==8*f['elements']
        assert fact['runtime_descriptor_count']==2 and fact['core_transactions']==2*fact['segment_count']
        assert fact['physical_ddr_bytes'] is None
        architecture.add(fact['architecture_identity']);facts[name]=fact
        receipts.append({'case':name,'facts':index['cases'][name],'ELF':ident(artifact['elf_path']),'native_plan':c['plan'],'source':c['source']})
    assert len(architecture)==1
    groups={k:{'all':[],'seeds':{}} for k in cases};seen=set()
    expected={(k,seed,repeat) for k in cases for seed in protocol['seeds'] for repeat in range(protocol['warmups']+protocol['repeats'])}
    for line in (Path(a.calibration_root)/'samples.jsonl').read_text().splitlines():
        s=json.loads(line);key=(s['case'],s['seed'],s['repeat']);assert key in expected and key not in seen;seen.add(key)
        assert s['warmup']==(s['repeat']<protocol['warmups'])
        selected=s['selected_wait_backend'];assert selected['qualname']=='_wait_polling' and selected['poll_interval_seconds']==.0002
        ev=s['events'];start=[e for e in ev if e['kind']=='actual_xrt_start'];wait=[e for e in ev if e['kind']=='actual_xrt_wait'];assert len(start)==len(wait)==1
        duration=wait[0]['end_ns']-start[0]['start_ns'];assert duration==s['dispatch_to_wait_end_ns']>0
        if not s['warmup']:
            groups[s['case']]['all'].append(duration);groups[s['case']]['seeds'].setdefault(str(s['seed']),[]).append(duration)
    assert seen==expected
    names=sorted(cases);x=[[1,facts[n]['descriptor_bytes']] for n in names];y=[float(np.median(groups[n]['all'])) for n in names]
    for g in groups.values():
        assert set(map(int,g['seeds']))==set(protocol['seeds']) and all(len(v)==protocol['repeats'] for v in g['seeds'].values())
    params,diagnostic=nnls2(x,y)
    seedfits={seed:nnls2(x,[np.median(groups[n]['seeds'][seed]) for n in names])[0].tolist() for seed in groups[names[0]]['seeds']}
    sizefits={}
    for size in (4096,16384,65536):
        kept=[j for j,n in enumerate(names) if facts[n]['elements']!=size]
        b,d=nnls2([x[j] for j in kept],[y[j] for j in kept]);sizefits[str(size)]={'entry_ns':float(b[0]),'byte_ns':float(b[1]),**d}
    raw={'protocol':ident(a.protocol),'profile_identity':ident(Path(a.calibration_root)/'identity.json'),'samples':ident(Path(a.calibration_root)/'samples.jsonl'),
        'independent_audit':ident(a.audit),'bindings':ident(a.bindings),'runtime_before':ident(a.runtime_before),'runtime_after':ident(a.runtime_after),'facts_index':ident(a.facts),'case_receipts':receipts}
    rawbytes=encoded(raw);rawdigest=hashlib.sha256(rawbytes).hexdigest()
    domain={k:binding[k] for k in IDENTITIES};domain.update(architecture_identity=next(iter(architecture)),implementation='identity-copy-f32',completion_boundary='submit-to-successful-wait-return',**BOUNDS)
    model={'schema':'orbit.device-transfer.model.v15','units':'ns','model_id':'duplex-copy-completion-training-median-v15-r1',
        'rows':[{'domain':domain,'entry_ns':float(params[0]),'segment_ns':0,'byte_ns':float(params[1]),
            'provenance':{'kind':'training-mechanism-envelope','source':'nonnegative entry+payload regression on nine equally weighted calibration-cell medians; actual copy path only'},'raw_manifest_sha256':rawdigest}],
        'cost_name':'duplex-copy submit-to-wait completion envelope',
        'omitted_term':'segment coefficient fixed0 because constant runtime BDcount2 and exploratory differences below resolution do not identify separate segment startup; no claim of free physical DMA',
        'label_scope':'actual start API entry through successful original runtime wait return; includes DMA, local scalar copy/load-store, locks, configuration, stalls and polling; BO sync outside interval',
        'acceptance':{'absolute_floor_ns':300000,'relative_fraction':.25,'comparison':'per heldout cell median'},
        'resolution_ns':300000,'extrapolation':'heldout3segments is preregistered below training minimum4; unseen2048 tile elements also extend calibration max1024; no interpolation claim',
        'physical_bandwidth':None,'full_program_cost':None,'training_only':True}
    cells=[{'case':n,'elements':facts[n]['elements'],'tile_elements':facts[n]['tile_elements'],'segments':facts[n]['segment_count'],'descriptor_bytes':facts[n]['descriptor_bytes'],
        'hot_samples':len(groups[n]['all']),'median_ns':y[j],'prediction_ns':float(params[0]+params[1]*x[j][1]),'absolute_error_ns':float(abs(params[0]+params[1]*x[j][1]-y[j]))} for j,n in enumerate(names)]
    report={'schema':'orbit.device-transfer.fit.v15','status':'passed','holdout_labels_read':False,'formula':'entry_ns + byte_ns * runtime_descriptor_both_direction_bytes','fixed_segment_ns':0,
        'parameters':{'entry_ns':float(params[0]),'byte_ns':float(params[1])},'diagnostic':diagnostic,'cells':cells,
        'training_only_per_seed_fits_entry_byte':seedfits,'training_only_leave_one_elements_out':sizefits,
        'condition':binding['condition'],'raw_manifest_sha256':rawdigest,'no_physical_bandwidth_claim':True}
    out.mkdir(parents=True);(out/'raw-manifest.json').write_bytes(rawbytes)
    (out/'model.json').write_bytes(encoded(model));(out/'fit-report.json').write_bytes(encoded(report));shutil.copyfile(__file__,out/'fitter-source.py')
    (out/'freeze.json').write_bytes(encoded({'schema':'orbit.device-transfer.freeze.v15','training_only':True,
        'files':{n:ident(out/n) for n in ('model.json','fit-report.json','raw-manifest.json','fitter-source.py')},'protocol':ident(a.protocol)}))
    print(json.dumps({'status':'passed','model':ident(out/'model.json'),'parameters':report['parameters']}))

def main():
    p=argparse.ArgumentParser(description=__doc__);s=p.add_subparsers(dest='command',required=True);f=s.add_parser('fit')
    for k in ('protocol','calibration-root','audit','bindings','facts','runtime-before','runtime-after','output'):f.add_argument('--'+k,required=True)
    a=p.parse_args();fit(a)

if __name__=='__main__':main()
