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

def semantic_configuration(plan, fields):
    """Exact native semantic coordinates; no model score or alternate planner."""
    return {key:plan[key] for key in fields}


def ranked_selection(report, search_directory, training_plans, exclusions, require_novel=True):
    """Filter original native order, including its tie order. Never re-sort."""
    archive={row['candidate_id']:row for row in report['archive']}
    if len(archive)!=len(report['archive']) or len(set(report['ranking']))!=len(report['ranking']):
        raise ValueError('duplicate native candidate identity/ranking')
    fields=exclusions['projection_fields'];decisions=[];winner=None
    training=[(p['direct_air_cost']['features']['execution_fingerprint'],semantic_configuration(p,fields)) for p in training_plans]
    for rank,cid in enumerate(report['ranking']):
        row=archive[cid];evaluation=row.get('evaluation',{});score=evaluation.get('score',{})
        reason=None;plan=None;mapping=None
        if (row.get('status')!='passed' or evaluation.get('status')!='passed' or
            evaluation.get('evaluation_kind')!='model_prediction' or
            score.get('provenance')!='calibrated-direct-air-model' or
            score.get('physical_hardware_measurement') is not False or
            score.get('unit')!='ms' or not isinstance(score.get('value'),(int,float)) or
            isinstance(score.get('value'),bool) or not math.isfinite(score['value']) or score['value']<=0):
            reason='not-calibrated-native-model-prediction'
        else:
            mapping=Path(evaluation['evidence_path']).resolve()
            expected=(search_directory/'candidates'/cid/'mapping-result.json').resolve()
            if mapping!=expected:
                raise ValueError('native mapping evidence outside candidate directory')
            result=load(mapping);plan=result.get('best_plan')
            if result.get('status')!='passed' or not isinstance(plan,dict):
                raise ValueError('native ranked candidate has no supported mapping')
            if plan.get('cost_status')!='calibrated' or plan.get('estimated_ms')!=score['value']:
                raise ValueError('native ranking/plan price identity differs')
            source=search_directory/'candidates'/cid/'taskflow.mlir'
            if sha(source)!=cid or source.read_text()!=row['native_mlir']:
                raise ValueError('native source/archive identity differs')
            fp=plan['direct_air_cost']['features']['execution_fingerprint'];coordinate=semantic_configuration(plan,fields)
            if require_novel and any(fp==priorfp or coordinate==prior for priorfp,prior in training):
                reason='previously-measured-training-configuration'
            if require_novel and any(fp==old['execution_fingerprint'] or coordinate==old['semantic_configuration'] for old in exclusions['excluded']):
                reason='previously-measured-v9-semantic-configuration'
        decisions.append(dict(native_rank=rank,candidate_id=cid,reason=reason or 'selected-first-eligible-native-ranked-candidate',native_prediction=score))
        if reason is None:
            winner=dict(row=row,plan=plan,mapping=mapping,source=source,native_rank=rank)
            break
    if winner is None:
        raise ValueError('no eligible native-ranked calibrated candidate')
    return winner,decisions


def unknown_selection(report, search_directory, training_plans, exclusions, selected_plans):
    """One explicitly unpriced hardware exploration, in native archive order."""
    fields=exclusions['projection_fields'];decisions=[]
    prior=training_plans+selected_plans
    for index,row in enumerate(report['archive']):
        cid=row['candidate_id'];evaluation=row.get('evaluation',{});reason=None;plan=None
        if row.get('status')!='uncalibrated' or evaluation.get('status')!='uncalibrated':
            reason='not-native-legal-uncalibrated'
        elif row.get('score') is not None or evaluation.get('score') is not None:
            raise ValueError('uncalibrated exploration must have null price')
        else:
            mapping=Path(evaluation['evidence_path']).resolve()
            if mapping!=(search_directory/'candidates'/cid/'mapping-result.json').resolve():
                raise ValueError('exploration mapping outside candidate directory')
            result=load(mapping);plan=result.get('best_plan')
            if (result.get('status')!='uncalibrated' or not isinstance(plan,dict) or
                plan.get('analysis_status')!='supported' or plan.get('codegen_status')!='requires_backend_verification' or
                plan.get('cost_status') not in ['uncalibrated','out_of_domain'] or plan.get('estimated_ms') is not None):
                raise ValueError('uncalibrated candidate lacks native legal mapping witness')
            source=search_directory/'candidates'/cid/'taskflow.mlir'
            if sha(source)!=cid or source.read_text()!=row['native_mlir']:
                raise ValueError('exploration source/archive identity differs')
            coordinate=semantic_configuration(plan,fields);fp=plan['direct_air_cost']['features']['execution_fingerprint']
            if any(fp==p['direct_air_cost']['features']['execution_fingerprint'] or coordinate==semantic_configuration(p,fields) for p in prior):
                reason='previously-trained-or-selected-semantic-configuration'
            elif any(fp==p['execution_fingerprint'] or coordinate==p['semantic_configuration'] for p in exclusions['excluded']):
                reason='previously-measured-v9-semantic-configuration'
        decisions.append(dict(native_archive_index=index,candidate_id=cid,reason=reason or 'selected-first-eligible-unpriced-native-archive-entry',score=None,
            calibration_rejection=plan.get('direct_air_cost',{}).get('reason') if plan else None))
        if reason is None:
            return dict(row=row,plan=plan,mapping=mapping,source=source,native_rank=None),decisions
    raise ValueError('no eligible legal unknown candidate for explicit exploration budget')


def exclusion_witness(item):
    """Resolve delivered prior witnesses without reading acquisition paths."""
    relative=item.get('artifact_relative_path')
    if relative is None:return verify(item)  # legacy immutable evidence
    relative=Path(relative)
    if relative.is_absolute() or '..' in relative.parts:
        raise ValueError('unsafe artifact-relative exclusion witness')
    path=ROOT.parent/relative
    fixture_root=ROOT/'test/TaskflowAIR/fixtures'
    if not path.resolve().is_relative_to(fixture_root.resolve()):
        raise ValueError('exclusion witness outside delivered fixture directory')
    if sha(path)!=item['sha256']:
        raise ValueError('delivered exclusion witness changed: '+str(path))
    return path


def check_exclusions(exclusions):
    if len(exclusions['excluded'])!=4:
        raise ValueError('expected four historical measured semantic exclusions')
    for key in ['case_manifest','observed_table','raw_manifest']:exclusion_witness(exclusions[key])
    for old in exclusions['excluded']:
        for key in ['source','plan','transformed_source']:exclusion_witness(old[key])
        if semantic_configuration(load(exclusion_witness(old['plan'])),exclusions['projection_fields'])!=old['semantic_configuration']:
            raise ValueError('historical exclusion coordinates differ from original plan')


def select_candidate(search, frozen, output, exclusions_path, controls=(), exploration_budget=0):
    if exploration_budget not in (0,1):raise ValueError("hardware exploration budget must be 0 or 1")
    record=check_freeze(frozen);d=check_design(Path(record['design']['path']).parent)
    features=load(verify(d['features']));training_plans=[load(verify(r['selection']['plan'])) for r in features if r['split']=='train']
    if len(training_plans)!=12:
        raise ValueError('expected exact frozen twelve training configurations')
    exclusions=load(exclusions_path)
    check_exclusions(exclusions)
    inputs=load(search/'search-inputs.json');prediction_path=verify(inputs['predictions']);prediction=load(prediction_path)
    if prediction['freeze']!=bound(frozen/'freeze.json'):
        raise ValueError('search does not bind requested frozen model')
    config=verify(inputs['configuration']['config']);tool=verify(inputs['configuration']['tool'])
    if sha(tool)!=d['tool']['sha256']:
        raise ValueError('search native tool differs from frozen design')
    if load(config)['generic_air']['cost_model']!=load(verify(record['model'])):
        raise ValueError('predictive search configuration model differs from frozen parameters')
    searches=[('joint',search/'search/search.json',config,True)]
    for control in controls:
        inp=load(control/'inputs.json');verify(inp['source']);verify(inp['tool']);verify(inp['frozen_prediction'])
        if inp['frozen_prediction']!=inputs['predictions'] or inp['tool']['sha256']!=sha(tool):
            raise ValueError('control search freeze/tool differs')
        control_config=verify(inp['config'])
        if load(control_config)['generic_air']['cost_model']!=load(verify(record['model'])):
            raise ValueError('control model differs from frozen parameters')
        searches.append((inp['mode'],control/'search/search.json',control_config,False))
    if exploration_budget:
        searches.append(('unknown-exploration-1',search/'search/search.json',config,None))
    output.mkdir(parents=True,exist_ok=False);shutil.copy2(Path(__file__),output/'orchestrator-source.py')
    shutil.copy2(exclusions_path,output/'prior-exclusions.json')
    selections=[];search_records=[];selected_plans=[]
    for name,path,cfg,novel in searches:
        report=load(path)
        if novel is None:
            winner,decisions=unknown_selection(report,path.parent,training_plans,exclusions,selected_plans)
        else:
            winner,decisions=ranked_selection(report,path.parent,training_plans,exclusions,novel)
        row=winner['row'];plan=winner['plan'];selected_plans.append(plan);directory=output/name;directory.mkdir()
        save(directory/'native-plan.json',plan);save(directory/'decisions.json',decisions)
        parents=[];archive={r['candidate_id']:r for r in report['archive']};current=row
        while current:
            parents.append({k:current[k] for k in ['candidate_id','parent','action','action_chain','round']})
            parent=current['parent']
            if not parent:break
            if parent in [p['candidate_id'] for p in parents]:raise ValueError('cyclic native action lineage')
            current=archive[parent]
        save(directory/'parents.json',parents)
        implementations=plan['direct_air_cost']['features']['implementations']
        cell=dict(name=name,program='m32-k128-n64',split='selected',tile_sizes=plan['tile_sizes'],
                  implementation='scalar-product-vector-add-f32:8' if 'scalar-product-vector-add-f32:8' in implementations else 'scalar:1',
                  data_organization=plan['program_mapping_choices']['data_organization'])
        selections.append(dict(cell=cell,program=cell['program'],candidate_id=row['candidate_id'],parent=row['parent'],
            action_chain=row['action_chain'],source=bound(winner['source']),plan=bound(directory/'native-plan.json'),config=bound(cfg)))
        search_records.append(dict(mode=name,search=bound(path),mapping=bound(winner['mapping']),
            decisions=bound(directory/'decisions.json'),parents=bound(directory/'parents.json'),native_rank=winner['native_rank'],
            prediction=row['evaluation'],evaluations=report['evaluations'],attempts=report['attempts'],
            novelty_required=novel is not False,role='unpriced-hardware-exploration' if novel is None else ('model-ranked-novel-selection' if novel else 'search-control'),score=None if novel is None else row['evaluation']['score'],calibration_rejection=plan['direct_air_cost'].get('reason') if novel is None else None))
    save(output/'selected-cases.json',selections)
    proposal=load(verify(d['proposal']))
    save(output/'proposal.json',dict(schema='orbit.implementation-search.selected-proposals.v10',
        prepared=proposal['prepared'],registration=d['registration'],matrix=d['matrix'],tool=d['tool'],
        selected=bound(output/'selected-cases.json')))
    save(output/'selection-freeze.json',dict(schema='orbit.implementation-search.selection.v10',
        freeze=bound(frozen/'freeze.json'),design=record['design'],exclusions=bound(output/'prior-exclusions.json'),
        source=bound(output/'orchestrator-source.py'),proposal=bound(output/'proposal.json'),selected=bound(output/'selected-cases.json'),
        searches=search_records,rule='first calibrated native ranking entry after semantic exclusions; native tie order unchanged; controls use first calibrated native rank without novelty exclusions',
        labels_read=False,hardware_exploration_budget=exploration_budget,budget_scope='same declared search ceilings; actual evaluation counts differ, not equal-work assertion',device_submissions=0))
    return output/'selection-freeze.json'


def check_selection(directory):
    record=load(directory/'selection-freeze.json');check_freeze(verify(record['freeze']).parent)
    for key in ['design','exclusions','source','proposal','selected']:verify(record[key])
    proposal=load(verify(record['proposal']))
    for key in ['registration','matrix','tool','selected']:verify(proposal[key])
    for row in load(verify(record['selected'])):
        for key in ['source','plan','config']:verify(row[key])
    for search in record['searches']:
        for key in ['search','mapping','decisions','parents']:verify(search[key])
    return record


def compile_selected(selection, output, jobs=1):
    check_selection(selection)
    from taskflow_implementation_search_v10 import compile_cases
    result=compile_cases(selection,output,jobs)
    check_selection(selection)
    save(output/'selection-binding.json',dict(selection=bound(selection/'selection-freeze.json'),compiled=bound(result),
        scope='existing native wrapper compile-only, original profiler consumes compiled-cases; no device submissions'))
    return result


def prepare_selected_profile(selection, compiled_dir, output):
    selected=check_selection(selection);frozen=verify(selected['freeze']).parent;record=check_freeze(frozen)
    binding=load(compiled_dir/'selection-binding.json')
    if binding['selection']!=bound(selection/'selection-freeze.json'):
        raise ValueError('compiled selection freeze differs')
    compiled=load(verify(binding['compiled']));verify(compiled['proposal'])
    if compiled['proposal']!=bound(selection/'proposal.json'):
        raise ValueError('compiled proposals differ from native selection')
    packages=load(verify(compiled['cases']));selections=load(verify(selected['selected']))
    if [p['selection'] for p in packages]!=selections:
        raise ValueError('compiled case order or identity differs from selected native order')
    prepared=Path(compiled['prepared']);d=check_design(Path(record['design']['path']).parent)
    matrix=load(verify(d['matrix']));timing=matrix['timing'];rows=[]
    profiler=Path(record['invocation']['path']).parent/'profiler-source.py'
    if sha(profiler)!=load(verify(record['invocation']))['script_sha256']:
        raise ValueError('frozen training profiler source differs')
    for package in packages:
        for key in ['elf','abi','plan','air','source','compile_record']:verify(package[key])
        cell=package['selection']['cell'];abi=load(verify(package['abi']));inputs=prepared/'inputs'/cell['program']
        pairs={kind:[bound(inputs/f'{kind}-{seed}.npz') for seed in [11,23,47]] for kind in ['inputs','reference']}
        rows.append(dict(name=cell['name'],hardware=str(Path(package['compiled'])/'hardware'),abi=package['abi']['path'],
            static_indices=[],intermediate_indices=[i for i,b in enumerate(abi['buffers']) if b['role']=='temporary'],
            inputs=[x['path'] for x in pairs['inputs']],reference=[x['path'] for x in pairs['reference']]))
    output.mkdir(parents=True,exist_ok=False);shutil.copy2(profiler,output/'profiler-executed.py');save(output/'cases.json',rows)
    command=[sys.executable,str(output/'profiler-executed.py'),'--cases',str(output/'cases.json'),'--observer',timing['observer'],
        '--iterations',str(timing['hot']),'--warmups',str(timing['warmups']),'--output',str(output/'profile-selected')]
    save(output/'profile-command.json',command)
    save(output/'profile-inputs.json',dict(schema='orbit.implementation-search.selected-profile.v10',selection=bound(selection/'selection-freeze.json'),
        compiled=bound(compiled_dir/'selection-binding.json'),cases=bound(output/'cases.json'),profiler=bound(output/'profiler-executed.py'),
        command=bound(output/'profile-command.json'),timing=timing,device_submissions=0,
        input_references=[bound(Path(path)) for row in rows for key in ['inputs','reference'] for path in row[key]],
        boundary='prepared-command-host-to-host',order='existing profiler alternating forward/reverse candidate order; same seeds/hot/warm and no static inputs as training',
        budget_scope='same search ceilings, different actual evaluation counts; tied model estimates do not imply measured gain'))
    return output/'profile-command.json'


def main():
    parser=argparse.ArgumentParser(description=__doc__);sub=parser.add_subparsers(dest='phase',required=True)
    p=sub.add_parser('profile')
    for key in ['design','compiled','output']:p.add_argument('--'+key,type=Path,required=True)
    p.add_argument('--split',choices=['train','holdout'],required=True);p.add_argument('--frozen',type=Path);p.add_argument('--predictions',type=Path)
    p=sub.add_parser('predict');p.add_argument('--frozen',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    p=sub.add_parser('predictive-search');p.add_argument('--predictions',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    p=sub.add_parser('select');p.add_argument('--search',type=Path,required=True);p.add_argument('--frozen',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--control',type=Path,action='append',default=[]);p.add_argument('--exclusions',type=Path,default=ROOT/'test/TaskflowAIR/fixtures/implementation_prior_exclusions_v10.json');p.add_argument('--exploration-budget',type=int,choices=[0,1],default=0)
    p=sub.add_parser('compile-selected');p.add_argument('--selection',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--jobs',type=int,choices=[1,2,4],default=1)
    p=sub.add_parser('prepare-selected-profile');p.add_argument('--selection',type=Path,required=True);p.add_argument('--compiled',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    args=parser.parse_args()
    if args.phase=='prepare-selected-profile':result=prepare_selected_profile(args.selection.resolve(),args.compiled.resolve(),args.output.resolve())
    elif args.phase=='select':result=select_candidate(args.search.resolve(),args.frozen.resolve(),args.output.resolve(),args.exclusions.resolve(),[p.resolve() for p in args.control],args.exploration_budget)
    elif args.phase=='compile-selected':result=compile_selected(args.selection.resolve(),args.output.resolve(),args.jobs)
    elif args.phase=='predictive-search':result=predictive_search(args.predictions.resolve(),args.output.resolve())
    elif args.phase=='predict':result=predict(args.frozen.resolve(),args.output.resolve())
    else:result=profile(args.design.resolve(),args.compiled.resolve(),args.split,args.output.resolve(),args.frozen.resolve() if args.frozen else None,args.predictions.resolve() if args.predictions else None)
    print(json.dumps(dict(status='passed',phase=args.phase,result=str(result))))


if __name__=='__main__':
    main()
