#!/usr/bin/env python3
"""Prepare/run existing profiler and native predictions for a frozen experiment.

Only an experiment coordinator should invoke profile phases on the NPU. This
script adds no runtime: it calls the unchanged installed-runner profiler entry.
"""
import argparse
import json
import math
from pathlib import Path
import shutil
import sys
from taskflow_implementation_search_v10 import bound,load,save,sha,verify,run,semantic_plan
from fit_implementation_cost_v10 import check_design,check_freeze
from taskflow_implementation_runtime_v10 import runtime_identity

ROOT=Path(__file__).resolve().parents[1]


def profile(design_dir,compiled_dir,split,output,frozen=None,predictions=None):
    d=check_design(design_dir)
    record=load(compiled_dir/'compile-manifest.json');verify(record['cases']);verify(record['proposal'])
    if record['proposal']['sha256']!=d['proposal']['sha256']:
        raise ValueError('compiled candidates differ from static design')
    packages=load(verify(record['cases']));features=load(verify(d['features']))
    expected={r['name'] for r in features if r['split']==split}
    if not expected:
        raise ValueError('empty declared split')
    if split=='holdout':
        if frozen is None or predictions is None:
            raise ValueError('holdout requires frozen parameters and pre-execution native predictions')
        frozen_record=check_freeze(frozen);prediction=load(predictions)
        if (output/'profile-holdout').resolve()!=Path(frozen_record['reserved_holdout_profile']).resolve():
            raise ValueError('heldout output differs from reserved pre-fit profile path')
        if prediction['freeze']['sha256']!=sha(frozen/'freeze.json'):
            raise ValueError('prediction model identity differs from frozen model')
        verify(prediction['freeze']);verify(prediction['rows'])
        if {r['name'] for r in load(verify(prediction['rows']))}!=expected:
            raise ValueError('predictions do not cover exact heldout split')
        training_profile=Path(frozen_record['invocation']['path']).parent
        installed_runner=load(training_profile/'runner-identity.json')
        if sha(installed_runner['path'])!=installed_runner['sha256']:
            raise ValueError('installed runner source differs from frozen training runtime')
        profiler=training_profile/'profiler-source.py'
        if sha(profiler)!=load(verify(frozen_record['invocation']))['script_sha256']:
            raise ValueError('training profiler snapshot differs')
    else:
        if frozen is not None or predictions is not None:
            raise ValueError('training has no fitted model or heldout labels')
        profiler=ROOT/'scripts/taskflow_ffn_profile.py'
    output.mkdir(parents=True,exist_ok=False)
    executed=output/'profiler-executed.py';shutil.copy2(profiler,executed)
    prepared=Path(record['prepared']);rows=[]
    for package in packages:
        cell=package['selection']['cell'];name=cell['name']
        if cell['split']!=split:
            continue
        for key in ['elf','abi','plan','air','source','compile_record']:
            verify(package[key])
        abi=load(verify(package['abi']));inputs=prepared/'inputs'/cell['program']
        rows.append(dict(name=name,hardware=str(Path(package['compiled'])/'hardware'),abi=package['abi']['path'],
            static_indices=[],intermediate_indices=[i for i,b in enumerate(abi['buffers']) if b['role']=='temporary'],
            inputs=[str(inputs/f'inputs-{seed}.npz') for seed in [11,23,47]],
            reference=[str(inputs/f'reference-{seed}.npz') for seed in [11,23,47]]))
    if {r['name'] for r in rows}!=expected:
        raise ValueError('compiled packages do not cover exact split')
    save(output/'cases.json',rows)
    matrix=load(verify(d['matrix']));timing=matrix['timing'];name='profile-'+split
    save(output/'phase-inputs.json',dict(design=bound(design_dir/'design.json'),compiled=bound(compiled_dir/'compile-manifest.json'),
        split=split,profiler=bound(executed),frozen=bound(frozen/'freeze.json') if frozen else None,
        predictions=bound(predictions) if predictions else None,submission_scope='complete GEMM→scale program per command'))
    run(output,'profile',[sys.executable,executed,'--cases',output/'cases.json','--observer',timing['observer'],
        '--iterations',str(timing['hot']),'--warmups',str(timing['warmups']),'--output',output/name])
    run(output,'independent-audit',[sys.executable,ROOT/'test/TaskflowAIR/audit_profile_v9.py',
        '--root',output,'--profile',name,'--output',output/'independent-audit'])
    if split=='holdout':
        check_freeze(frozen)
        actual,contract=runtime_identity(output/name,load(output/name/'invocation.json'),timing)
        save(output/'heldout-preparation-contract.json',contract)
        if actual!=load(verify(frozen_record['model']))['target']['runtime']:
            raise ValueError('actual heldout runtime policy differs from frozen target; predictions ineligible')
    return output/name


def predict(frozen,output):
    record=check_freeze(frozen);design_path=Path(record['design']['path']).parent;d=check_design(design_path)
    compiled=load(verify(record['compiled']));packages={p['selection']['cell']['name']:p for p in load(verify(compiled['cases']))}
    if Path(record['reserved_holdout_profile']).exists():
        raise ValueError('heldout timing already exists before prediction freeze')
    output.mkdir(parents=True,exist_ok=False);model=load(verify(record['model']));rows=[];tool=verify(d['tool'])
    for row in load(verify(d['features'])):
        if row['split']!='holdout':
            continue
        name=row['name'];directory=output/name;directory.mkdir()
        selection=row['selection'];base_config=load(verify(selection['config']))
        models={'implementation_stage_4term':model,'simple_implementation_3term':load(verify(record['simple_model']))}
        models['legacy_theoretical']=None
        predictions={};plans={}
        for model_name,selected_model in models.items():
            config=json.loads(json.dumps(base_config));generic=config['generic_air']
            generic.pop('theoretical',None);generic.pop('cost_model',None);generic.pop('cost_target',None)
            if selected_model is None:
                generic['theoretical']=load(verify(record['legacy_theoretical']))['coefficients']
            else:
                generic['cost_model']=selected_model
                generic['cost_target']=dict(selected_model['target'],boundary=selected_model['boundary'])
            destination=directory/model_name;destination.mkdir()
            save(destination/'config.json',config)
            run(destination,'predict',[tool,verify(selection['source']),'--generic-map',
                '--target-config='+str(destination/'config.json'),'--mapping-output='+str(destination/'plan.json')])
            plan=load(destination/'plan.json');value=plan.get('estimated_ms')
            if semantic_plan(plan)!=semantic_plan(load(verify(selection['plan']))):
                raise ValueError('native prediction changed semantic plan')
            if isinstance(value,bool) or not isinstance(value,(float,int)) or not math.isfinite(value) or value<=0:
                raise ValueError('predeclared native prediction unknown/null or invalid: '+name+'/'+model_name)
            predictions[model_name]=value;plans[model_name]=bound(destination/'plan.json')
        rows.append(dict(name=name,program=selection['cell']['program'],prediction_ms=predictions['implementation_stage_4term'],
                         model_predictions_ms=predictions,native_prediction_plans=plans,
                         native_prediction_plan=plans['implementation_stage_4term'],compiled=packages[name]))
    proposal=load(verify(d['proposal']));prepared=Path(proposal['prepared']);matrix=load(verify(d['matrix']))
    search_source=prepared/'inputs/m32-k128-n64/source.mlir'
    if not search_source.is_file():
        raise ValueError('predeclared M32 whole-program search source missing')
    search_config=load(verify(proposal['config']))
    search_config['generic_air'].pop('theoretical',None)
    search_config['generic_air']['cost_model']=model
    search_config['generic_air']['cost_target']=dict(model['target'],boundary=model['boundary'])
    search_config['native_auto_candidates']['exploration_slots']=4
    save(output/'predictive-search-config.json',search_config)
    controls=matrix['native_search'];tiles=controls['root_tile']
    save(output/'predictive-search-inputs.json',dict(source=bound(search_source),tool=d['tool'],config=bound(output/'predictive-search-config.json'),
        model=record['model'],root_tile=tiles,max_rounds=controls['max_rounds'],max_candidates=controls['max_candidates'],beam_width=controls['beam_width'],
        selection='original C++ native automatic search; fixed four unknown exploration slots, no Python production ranking',
        downstream='root compiles/profiles a legal archive candidate outside prior measured table; do not call predeclared-cell validation production search'))
    save(output/'predictions.json',rows)
    save(output/'prediction-freeze.json',dict(schema='orbit.implementation-search.predictions.v10',freeze=bound(frozen/'freeze.json'),
        rows=bound(output/'predictions.json'),native_tool=d['tool'],model=record['model'],simple_model=record['simple_model'],legacy_theoretical=record['legacy_theoretical'],predictive_search=bound(output/'predictive-search-inputs.json'),holdout_timing_labels_read=False,
        scope='native model predictions frozen before heldout execution; no Python production inference'))
    return output/'prediction-freeze.json'



def predictive_search(predictions,output):
    prediction=load(predictions);record=load(verify(prediction['predictive_search']))
    frozen_path=verify(prediction['freeze']);check_freeze(frozen_path.parent)
    verify(prediction['model'])
    source=verify(record['source']);tool=verify(record['tool']);config=verify(record['config']);tiles=record['root_tile']
    output.mkdir(parents=True,exist_ok=False)
    run(output,'native-predictive-search',[tool,source,'--search','--backend=air','--air-distribute-initialization',
        '--tile-m='+str(tiles[0]),'--tile-n='+str(tiles[1]),'--tile-k='+str(tiles[2]),
        '--target-config='+str(config),'--search-output='+str(output/'search'),
        '--max-rounds='+str(record['max_rounds']),'--max-candidates='+str(record['max_candidates']),
        '--beam-width='+str(record['beam_width'])])
    save(output/'search-inputs.json',dict(predictions=bound(predictions),model=record['model'],configuration=record,
         scope='actual original C++ model-ranked automatic search; archive selection not replaced by Python',device_submissions=0))
    return output/'search/search.json'

def main():
    parser=argparse.ArgumentParser(description=__doc__);sub=parser.add_subparsers(dest='phase',required=True)
    p=sub.add_parser('profile')
    for key in ['design','compiled','output']:p.add_argument('--'+key,type=Path,required=True)
    p.add_argument('--split',choices=['train','holdout'],required=True);p.add_argument('--frozen',type=Path);p.add_argument('--predictions',type=Path)
    p=sub.add_parser('predict');p.add_argument('--frozen',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    p=sub.add_parser('predictive-search');p.add_argument('--predictions',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    args=parser.parse_args()
    if args.phase=='predictive-search':result=predictive_search(args.predictions.resolve(),args.output.resolve())
    elif args.phase=='predict':result=predict(args.frozen.resolve(),args.output.resolve())
    else:result=profile(args.design.resolve(),args.compiled.resolve(),args.split,args.output.resolve(),args.frozen.resolve() if args.frozen else None,args.predictions.resolve() if args.predictions else None)
    print(json.dumps(dict(status='passed',phase=args.phase,result=str(result))))


if __name__=='__main__':
    main()
