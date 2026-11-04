#!/usr/bin/env python3
"""CPU experiment orchestration: native features, audited fit, freeze and score.

There is no planner or production cost implementation here. Native taskflow-opt
owns feature plans; the existing experiment fitter owns its declared fit. This
helper never imports a runtime or executes holdout programs.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[1]
TERMS=('command_count','source_f32_product_operations','source_math_exp_f32_operations','hardware_stage_count')


def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def load(path):return json.loads(Path(path).read_text())
def save(path,value):Path(path).write_text(json.dumps(value,indent=2,sort_keys=True,allow_nan=False)+'\n')
def bound(path):return dict(path=str(Path(path).resolve()),sha256=sha(path))
def verify(item):
    path=Path(item['path'])
    if sha(path)!=item['sha256']:raise ValueError('frozen file changed: '+str(path))
    return path

def no_holdout_labels(package):
    # Existence checks only. Neither profiles nor holdout labels are opened.
    for name in ['profile-m3-holdout','profile-controls-holdout']:
        if (package/name).exists():raise ValueError('holdout execution already exists before freeze: '+name)

def package_cases(package):
    rows=[]
    for m in [1,5,8,3]:
        for stage in ['gate','up','activation','down','full']:
            rows.append((f'm{m}-{stage}',package/f'baseline/m{m}/{stage}', 'holdout' if m==3 else 'train',f'profile-m{m}-training'))
    controls=load(package/'controls-input/manifest.json')
    for row in controls['cases']:
        rows.append((row['name'],package/'controls-compiled'/row['name'],row['split'],'profile-controls-training'))
    return rows

def context(package,profile_names):
    contexts=[]
    for name in profile_names:
        folder=package/name;inv=load(folder/'invocation.json');runner=load(folder/'runner-identity.json')
        if sha(folder/'profiler-source.py')!=inv['script_sha256']:raise ValueError('profiler snapshot changed')
        wait=load(folder/'wait-backend.json') if (folder/'wait-backend.json').exists() else None
        wait_identity={k:wait.get(k) for k in ['selected','module','qualname','classification','selected_source_sha256','configured_poll_interval_seconds']} if wait else {'classification':'unknown-no-record'}
        contexts.append(dict(observer=inv['observer'],profiler=inv['script_sha256'],runner=runner['sha256'],wait=wait_identity))
    if any(c!=contexts[0] for c in contexts):raise ValueError('training contexts differ; do not silently pool them')
    if contexts[0]['observer']!='detailed':raise ValueError('this declared fit uses detailed-observer wall labels')
    return contexts[0]


def compiled_context(compiled,tool_identity):
    invocation=load(compiled/'invocation.json')
    if invocation['tool_sha256']!=tool_identity['sha256'] or sha(invocation['tool'])!=tool_identity['sha256']:
        raise ValueError('compiled native lowering tool differs from frozen feature tool')
    native=[]
    for flag in invocation['flags']:
        if flag.startswith('--target-config='):
            config=Path(flag.split('=',1)[1])
            if config.resolve()!=(compiled/'target.json').resolve():
                raise ValueError('native compile target path differs from package target')
            native.append('--target-config-sha256='+sha(config))
        else:native.append(flag)
    command=load(compiled/'hardware/command.json');aircc=[];i=1
    while i<len(command):
        arg=command[i]
        if arg=='--elf-name':i+=1
        elif arg.startswith('--elf-name='):pass
        elif arg.startswith('--peano='):aircc.append('--peano=<recorded-toolchain>')
        elif not arg.endswith('.mlir'):aircc.append(arg)
        i+=1
    return dict(native_lowering_sha256=invocation['tool_sha256'],native_flags=native,aircc_flags=aircc)

def collect(package,audit,tool,output):
    no_holdout_labels(package)
    output.mkdir(parents=True,exist_ok=False)
    tool_identity=bound(tool)
    profiles=['profile-m1-training','profile-m5-training','profile-m8-training','profile-controls-training']
    ctx=context(package,profiles);versions=None;compile_contexts=[];entries=[];bridges=[];bindings=[];source_ranges={};ranges={k:[0,0] for k in TERMS}
    (output/'collector-source.py').write_bytes(Path(__file__).read_bytes())
    for name,compiled,split,profile in package_cases(package):
        directory=output/'features'/name;directory.mkdir(parents=True)
        compile_ctx=compiled_context(compiled,tool_identity);compile_contexts.append(compile_ctx)
        cfg=load(compiled/'target.json');cfg.setdefault('generic_air',{})['cost_model']={'schema':'orbit.direct-air.cost.v1','kind':'features-only'}
        save(directory/'config.json',cfg)
        source=compiled/'transformed-taskflow.mlir'
        command=[str(tool),str(source),'--generic-map','--target-config='+str(directory/'config.json'),'--mapping-output='+str(directory/'plan.json')]
        save(directory/'command.json',dict(argv=command,tool=tool_identity))
        result=subprocess.run(command,capture_output=True,text=True)
        (directory/'stdout.log').write_text(result.stdout);(directory/'stderr.log').write_text(result.stderr);save(directory/'result.json',dict(returncode=result.returncode))
        if result.returncode:raise ValueError('native feature collection failed: '+name)
        old=load(compiled/'plan.json');new=load(directory/'plan.json')
        semantic=lambda p:{k:v for k,v in p.items() if k not in ['plan_id','direct_air_cost']}
        if semantic(old)!=semantic(new):raise ValueError('feature-only command changed semantic plan: '+name)
        features=new['direct_air_cost']['features'];values=features['values']
        if features['schema']!='orbit.direct-air.features.v1':raise ValueError('native features required')
        for key in TERMS:
            value=values[key]
            if isinstance(value,bool) or not isinstance(value,int) or value<0:raise ValueError('invalid native count')
            ranges[key][1]=max(ranges[key][1],value)
        for source_fingerprint in features['source_fingerprints']:
            local_ranges=source_ranges.setdefault(source_fingerprint,{})
            if local_ranges and set(local_ranges)!=set(values):
                raise ValueError('native feature key set changed within a source group')
            for key,value in values.items():
                if isinstance(value,bool) or not isinstance(value,int) or not 0<=value<=2**63-1:
                    raise ValueError('source-specific guards require nonnegative int64 native features')
                previous=local_ranges.get(key,[value,value])
                local_ranges[key]=[min(previous[0],value),max(previous[1],value)]
        entry=dict(name=name,group_id=name,split=split,plan=str(directory/'plan.json'),plan_sha256=sha(directory/'plan.json'))
        if split=='train':
            for key,path in [('profile',package/profile/'results.json'),('audit',audit/(profile+'.json'))]:
                entry[key]=str(path);entry[key+'_sha256']=sha(path)
        # Holdout entries intentionally have no profile/audit keys.
        entries.append(entry)
        paths={key:bound(compiled/relative) for key,relative in [('source','source.mlir'),('transformed','transformed-taskflow.mlir'),('plan','plan.json'),('air','program.air.mlir'),('elf','hardware/program.elf'),('invocation','invocation.json'),('target','target.json'),('aircc_command','hardware/command.json')]}
        bridges.append(dict(name=name,split=split,compile_context=compile_ctx,compiled=paths,feature_plan=bound(directory/'plan.json'),old_plan_id=old['plan_id'],feature_plan_id=new['plan_id'],semantic_plan_equal_excluding_price_and_id=True))
        bindings.extend(paths.values())
        current=load(compiled/'hardware/toolchain.json')
        if versions is not None and current!=versions:raise ValueError('compiled toolchains differ')
        versions=current
    # Configured fixture roles, not inferred data categories or a mapping policy.
    for path in [package/'cases-m3.json',package/'cases-controls-holdout.json',package/'controls-input/split-declaration.json']:
        bindings.append(bound(path))
    save(output/'feature-identity-bridges.json',bridges)
    manifest=dict(schema='orbit.direct-air.training.v1',model_id='direct-air-scalar-f32-composite-v9',model_version='fresh',timing_boundary='prepared-command-host-to-host',objective='relative-residual-floor-1ms',
        target=dict(id='fresh-direct-air-v9-detailed-fixed-fixture',toolchain=json.dumps(dict(versions=versions,native_lowering_sha256=tool_identity['sha256'],compile_contracts=sorted({json.dumps(c,sort_keys=True,separators=(',',':')) for c in compile_contexts})),sort_keys=True,separators=(',',':')),runtime=json.dumps(ctx,sort_keys=True,separators=(',',':'))),
        feature_ranges=ranges,source_feature_ranges=source_ranges,cases=entries,feature_identity_bridges_sha256=sha(output/'feature-identity-bridges.json'),notes=['predeclared M1/M5/M8 and packed controls train; M3/17x80 held out','holdout static features declare source-specific bounds but no timing labels opened; applicability is restricted to predeclared configurations','fixture W_* input system BOs static; other inputs restaged; no AIE residency inference'])
    save(output/'training-manifest.json',manifest)
    verify(tool_identity)
    save(output/'collection.json',dict(orchestration_source=bound(output/'collector-source.py'),schema='orbit.ffn.collection.v1',package=str(package),manifest=bound(output/'training-manifest.json'),bridges=bound(output/'feature-identity-bridges.json'),tool=bound(tool),compiled_and_cases=bindings,holdout_labels_read=False))
    return output/'training-manifest.json'

def freeze(collection,output):
    record=load(collection/'collection.json');package=Path(record['package']);no_holdout_labels(package)
    manifest_path=verify(record['manifest']);verify(record['bridges']);verify(record['orchestration_source']);verify(record['tool']);manifest=load(manifest_path)
    for entry in manifest['cases']:
        if entry['split']=='holdout' and any(k in entry for k in ['profile','audit']):raise ValueError('holdout label bindings forbidden')
    for item in record['compiled_and_cases']:verify(item)
    fitter=ROOT/'scripts/fit_direct_air_cost_v9.py'
    command=[sys.executable,str(fitter),'--manifest',str(manifest_path),'--output',str(output)]
    if output.exists():raise ValueError('fresh frozen-model directory required')
    result=subprocess.run(command,capture_output=True,text=True)
    if result.returncode:raise ValueError('fitter failed: '+result.stderr)
    save(output/'fitter-command.json',dict(argv=command,fitter=bound(fitter),stdout=result.stdout,stderr=result.stderr))
    save(output/'freeze.json',dict(schema='orbit.ffn.freeze.v1',orchestration_source=bound(Path(__file__)),package=str(package),collection=bound(collection/'collection.json'),manifest=bound(manifest_path),model=bound(output/'model.json'),fit=bound(output/'fit.json'),fitter=bound(fitter),compiled_and_cases=record['compiled_and_cases'],holdout_execution_before_freeze=False))
    return output/'freeze.json'

def check_freeze(frozen):
    record=load(frozen/'freeze.json')
    for key in ['collection','manifest','model','fit','fitter','orchestration_source']:verify(record[key])
    for item in record['compiled_and_cases']:verify(item)
    collection=load(verify(record['collection']));verify(collection['tool']);verify(collection['bridges'])
    manifest=load(verify(record['manifest']))
    for entry in manifest['cases']:
        if sha(entry['plan'])!=entry['plan_sha256']:raise ValueError('native feature plan changed')
        if entry['split']=='train':
            for key in ['profile','audit']:
                if sha(entry[key])!=entry[key+'_sha256']:raise ValueError('training evidence changed')
        elif any(k in entry for k in ['profile','audit']):raise ValueError('withheld labels entered frozen manifest')
    return record

def score(frozen,audit,output,holdout):
    record=check_freeze(frozen);fit=load(verify(record['fit']));model=load(verify(record['model']));actual={};evidence=[]
    collection=load(verify(record['collection']))
    bridges={row['name']:row for row in load(verify(collection['bridges']))}
    for profile in ['profile-m3-holdout','profile-controls-holdout']:
        audit_path=audit/(profile+'.json');data=load(audit_path)
        evidence.extend([bound(audit_path),bound(holdout/profile/'results.json')])
        if data['status']!='passed':raise ValueError('holdout raw-output audit must pass')
        actual.update(data['candidates'])
    held_context=context(holdout,['profile-m3-holdout','profile-controls-holdout'])
    if json.dumps(held_context,sort_keys=True,separators=(',',':'))!=model['target']['runtime']:
        raise ValueError('holdout runtime/observer/profiler context differs from frozen target')
    rows=[]
    for expected in fit['preselected_holdout_no_labels_read']:
        name=expected['name'];prediction=sum(term['coefficient_ms']*expected['features'][term['feature']] for term in model['terms'])
        if abs(prediction-expected['unvalidated_prediction_ms'])>1e-8:raise ValueError('frozen prediction differs')
        value=actual[name]
        if not value['numerical_passed']:raise ValueError('holdout numerical failure')
        if value.get('elf_sha256')!=bridges[name]['compiled']['elf']['sha256']:
            raise ValueError('audited holdout ELF differs from preselected compiled program: '+name)
        measured=value['hot_wall_ms']['median']
        rows.append(dict(name=name,prediction_ms=prediction,actual_hot_median_ms=measured,signed_relative_error_percent=100*(prediction-measured)/measured,hot_statistics=value['hot_wall_ms'],plan_sha256=expected['plan_sha256']))
    output.mkdir(parents=True,exist_ok=False)
    save(output/'holdout-score.json',dict(status='post-freeze-validation',model=record['model'],fit=record['fit'],rows=rows,evidence=evidence,parameters_changed=False,holdout_refit=False,scope='numerical success and performance error are separate; small median rank differences are not significance'))
    return output/'holdout-score.json'

def main():
    parser=argparse.ArgumentParser(description=__doc__);sub=parser.add_subparsers(dest='command',required=True)
    p=sub.add_parser('collect');p.add_argument('--package',type=Path,required=True);p.add_argument('--audit',type=Path,required=True);p.add_argument('--tool',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    p=sub.add_parser('freeze');p.add_argument('--collection',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    p=sub.add_parser('check-freeze');p.add_argument('--frozen',type=Path,required=True)
    p=sub.add_parser('score');p.add_argument('--frozen',type=Path,required=True);p.add_argument('--audit',type=Path,required=True);p.add_argument('--holdout',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    a=parser.parse_args()
    if a.command=='collect':result=collect(a.package.resolve(),a.audit.resolve(),a.tool.resolve(),a.output.resolve())
    elif a.command=='freeze':result=freeze(a.collection.resolve(),a.output.resolve())
    elif a.command=='check-freeze':result=check_freeze(a.frozen.resolve())['model']['sha256']
    else:result=score(a.frozen.resolve(),a.audit.resolve(),a.output.resolve(),a.holdout.resolve())
    print(json.dumps(dict(status='passed',command=a.command,result=str(result),device_submissions=0)))

if __name__=='__main__':main()
