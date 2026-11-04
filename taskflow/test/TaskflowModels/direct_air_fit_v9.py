#!/usr/bin/env python3
"""Experiment-fitter boundary tests; synthetic records, no device/calibration."""
import hashlib
import importlib.util
import json
from pathlib import Path
import tempfile

script = Path(__file__).resolve().parents[2] / 'scripts/fit_direct_air_cost_v9.py'
spec = importlib.util.spec_from_file_location('fitter', script)
fitter = importlib.util.module_from_spec(spec)
spec.loader.exec_module(fitter)
checks = 0
with tempfile.TemporaryDirectory() as tmp:
    root = Path(tmp)
    def bound(entry, name, value):
        p = root / f'{entry["name"]}-{name}.json'
        p.write_text(json.dumps(value))
        entry[name] = str(p)
        entry[name+'_sha256'] = hashlib.sha256(p.read_bytes()).hexdigest()
    rows = []
    for i, x in enumerate([(1,0,0,1),(1,0,0,2),(1,10,0,1),(1,0,10,1),(1,5,5,1)]):
        entry = {'name':f'row{i}', 'split':'holdout' if i==4 else 'train', 'group_id':str(i)}
        values = dict(zip(fitter.TERMS,x));values['all_storage_f32']=1
        bound(entry,'plan',{'direct_air_cost':{'features':{'schema':'orbit.direct-air.features.v1',
            'values':values,'source_fingerprints':[str(i)],'implementations':['scalar:1'],
            'source_operations':{'arith.mulf:f32':x[1]}}}})
        if i==4:
            entry['profile']='/must/not/read/holdout'
            entry['audit']='/must/not/read/holdout'
        else:
            y=sum(a*b for a,b in zip(x,(1,2,3,4)))
            bound(entry,'audit',{'status':'passed','checks':[{'candidate':entry['name'],'passed':True}]})
            bound(entry,'profile',{'results':[{'status':'passed','samples':[{'candidate':entry['name'],
                'warmup':False,'wall_ms':y,'checks':{'Y':{'passed':True,'finite':True}}}]}]})
        rows.append(entry)
    manifest = {'schema':'orbit.direct-air.training.v1','timing_boundary':'prepared-command-host-to-host',
        'objective':'relative-residual-floor-1ms','target':{'id':'test','toolchain':'test','runtime':'test'},
        'model_id':'synthetic','model_version':'1','cases':rows,
        'feature_ranges':{k:[0,20] for k in fitter.TERMS}}
    path = root/'manifest.json';path.write_text(json.dumps(manifest))
    model, report = fitter.fit(manifest,path)
    assert all(abs(t['coefficient_ms']-c)<1e-8 for t,c in zip(model['terms'],(1,2,3,4)));checks+=1
    assert report['preselected_holdout_no_labels_read'][0]['unvalidated_prediction_ms']>0;checks+=1
    def rejected(change):
        global checks
        m=json.loads(json.dumps(manifest));change(m)
        try:fitter.fit(m,path)
        except (ValueError,KeyError):checks+=1;return
        raise AssertionError('accepted malformed training contract')
    rejected(lambda m:m['cases'][0].update(plan_sha256='wrong'))
    rejected(lambda m:m['cases'][-1].update(group_id='0'))
    rejected(lambda m:m.update(objective='post-holdout-tuned'))
    rejected(lambda m:m['cases'][0].update(name='missing-from-audit'))
    rejected(lambda m:m.update(cases=[m['cases'][0],m['cases'][-1]]))
    guarded=json.loads(json.dumps(manifest))
    guarded['source_feature_ranges']={}
    for entry in guarded['cases']:
        features=json.loads(Path(entry['plan']).read_text())['direct_air_cost']['features']
        for source in features['source_fingerprints']:
            guarded['source_feature_ranges'][source]={k:[v,v] for k,v in features['values'].items()}
    guarded_path=root/'guarded-manifest.json';guarded_path.write_text(json.dumps(guarded))
    guarded_model,_=fitter.fit(guarded,guarded_path)
    assert guarded_model['domain']['source_feature_ranges']==guarded['source_feature_ranges'];checks+=1
    assert guarded_model['terms']==model['terms'];checks+=1
    def bad_guard(change):
        global checks
        m=json.loads(json.dumps(guarded));change(m['source_feature_ranges'])
        try:fitter.fit(m,guarded_path)
        except (ValueError,KeyError):checks+=1;return
        raise AssertionError('accepted invalid source configuration domain')
    bad_guard(lambda ranges:ranges.pop('4'))
    bad_guard(lambda ranges:ranges.update(foreign={'command_count':[1,1]}))
    bad_guard(lambda ranges:ranges['0'].update(foreign_feature=[0,1]))
    bad_guard(lambda ranges:ranges['0'].update(command_count=[True,1]))
    bad_guard(lambda ranges:ranges['0'].update(command_count=[-1,1]))
    bad_guard(lambda ranges:ranges['0'].update(command_count=[1,2**63]))
    bad_guard(lambda ranges:ranges['0'].update(command_count=[2,1]))
    bad_guard(lambda ranges:ranges['0'].update(command_count=[0,0]))
    bad_guard(lambda ranges:ranges.update({'0':{}}))
print(json.dumps({'status':'passed','checks':checks,'scope':'synthetic experiment fitter only'}))
