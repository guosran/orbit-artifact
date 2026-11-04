#!/usr/bin/env python3
"""CPU-only workflow protocol tests with declared synthetic native plans.

The fake native command emits supplied fixture JSON, never analyzes/maps source.
The actual experiment fitter runs on synthetic labels; no runtime is imported.
"""
import argparse
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
from types import SimpleNamespace
from unittest.mock import patch
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'python'))
from taskflow_paths import ARTIFACT_ROOT
spec=importlib.util.spec_from_file_location('workflow',ARTIFACT_ROOT/'scripts/taskflow_ffn_workflow_v9.py')
w=importlib.util.module_from_spec(spec);spec.loader.exec_module(w)


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--output',type=Path,required=True);a=parser.parse_args();out=a.output.resolve();out.mkdir(parents=True,exist_ok=False)
    package=out/'package';package.mkdir();audit=out/'training-audit';audit.mkdir();tool=out/'fake-native-tool';tool.write_text('CPU mock: emits declared plans; not an executable compiler')
    rows=[];plans={};samples=[];checks=[]
    vectors=[(1,0,0,1),(1,0,0,2),(1,10,0,1),(1,0,10,1),(1,5,5,1),(1,3,4,1)]
    for i,vector in enumerate(vectors):
        name=f'train{i}' if i<5 else 'held';directory=package/'compiled'/name;(directory/'hardware').mkdir(parents=True)
        for file in ['source.mlir','transformed-taskflow.mlir','program.air.mlir','hardware/program.elf']:(directory/file).write_text('synthetic nonexecutable '+name+' '+file)
        w.save(directory/'target.json',{'generic_air':{'tile_sizes':[1]}});w.save(directory/'hardware/toolchain.json',{'runtime':'synthetic'})
        w.save(directory/'invocation.json',dict(tool=str(tool),tool_sha256=w.sha(tool),flags=['--target-config='+str(directory/'target.json')]))
        w.save(directory/'hardware/command.json',['aircc','--device=npu2','--stack-size=4096',str(directory/'program.air.mlir')])
        plan=dict(plan_id='old-'+name,body_fingerprint='fixture-'+name,strategy='synthetic',actual_dma_bytes=0)
        w.save(directory/'plan.json',plan)
        new=dict(plan,plan_id='features-'+name,direct_air_cost={'features':{'schema':'orbit.direct-air.features.v1','values':dict(zip(w.TERMS,vector),all_storage_f32=1),'source_fingerprints':['fixture-'+name],'implementations':['scalar:1'],'source_operations':['arith.addf:f32','arith.mulf:f32','math.exp:f32']}})
        plans[str(directory/'transformed-taskflow.mlir')]=new
        split='train' if i<5 else 'holdout';profile='profile-m1-training' if i<5 else 'FORBIDDEN-HOLDOUT-LABEL'
        rows.append((name,directory,split,profile))
        if i<5:
            samples.append(dict(candidate=name,warmup=False,wall_ms=sum(x*c for x,c in zip(vector,[.4,.1,.2,.01])),checks={'Y':{'passed':True,'finite':True}}));checks.append(dict(candidate=name,passed=True))
    prof=package/'profile-m1-training';prof.mkdir();w.save(prof/'results.json',{'results':[dict(status='passed',samples=samples)]});w.save(audit/'profile-m1-training.json',dict(status='passed',checks=checks))
    for name in ['cases-m3.json','cases-controls-holdout.json']:w.save(package/name,[])
    (package/'controls-input').mkdir();w.save(package/'controls-input/split-declaration.json',dict(split='synthetic predeclared'))
    original_run=subprocess.run;commands=[]
    def fake_run(command,**kwargs):
        commands.append(command)
        if command[0]==str(tool):
            path=Path(next(x.split('=',1)[1] for x in command if x.startswith('--mapping-output=')));w.save(path,plans[command[1]])
            return SimpleNamespace(returncode=0,stdout='synthetic native plan fixture',stderr='')
        assert 'fit_direct_air_cost_v9.py' in command[1], 'unexpected compiler/runtime execution'
        return original_run(command,**kwargs)
    first=rows[0][1];original_invocation=w.load(first/'invocation.json')
    w.save(first/'invocation.json',dict(original_invocation,tool_sha256='different'))
    try:w.compiled_context(first,w.bound(tool))
    except ValueError:pass
    else:raise AssertionError('different compiled native tool admitted')
    w.save(first/'invocation.json',original_invocation)
    collection=out/'features'
    with patch.object(w,'package_cases',return_value=rows),patch.object(w,'context',return_value={'runtime':'explicit CPU mock'}),patch.object(w.subprocess,'run',side_effect=fake_run):
        manifest_path=w.collect(package,audit,tool,collection)
        manifest=w.load(manifest_path);held=next(x for x in manifest['cases'] if x['split']=='holdout');assert 'profile' not in held and 'audit' not in held
        assert manifest['source_feature_ranges']['fixture-held']['source_f32_product_operations']==[3,3]
        assert all(set(x)==set(plans[next(iter(plans))]['direct_air_cost']['features']['values']) for x in manifest['source_feature_ranges'].values())
        frozen=out/'model';w.freeze(collection,frozen)
    assert len(commands)==7 and not any('FORBIDDEN-HOLDOUT-LABEL' in str(c) for c in commands)
    assert w.load(frozen/'model.json')['target']['toolchain'].find(w.sha(tool))>=0
    assert w.load(frozen/'model.json')['domain']['source_feature_ranges']==manifest['source_feature_ranges']
    w.check_freeze(frozen);saved=(frozen/'model.json').read_bytes();report=w.load(frozen/'fit.json')
    assert len(report['preselected_holdout_no_labels_read'])==1
    # Neither altered parameters nor altered native plans can pass the barrier.
    (frozen/'model.json').write_bytes(saved+b' ')
    try:w.check_freeze(frozen)
    except ValueError:pass
    else:raise AssertionError('changed model admitted')
    (frozen/'model.json').write_bytes(saved)
    plan=Path(held['plan']);saved_plan=plan.read_bytes();plan.write_bytes(saved_plan+b' ')
    try:w.check_freeze(frozen)
    except ValueError:pass
    else:raise AssertionError('changed native features admitted')
    plan.write_bytes(saved_plan)
    holdout_audit=out/'held-audit';holdout_audit.mkdir()
    for name in ['profile-m3-holdout','profile-controls-holdout']:
        directory=out/'held-profile'/name;directory.mkdir(parents=True);w.save(directory/'results.json',{'synthetic':True})
    held_elf=w.sha(package/'compiled/held/hardware/program.elf')
    w.save(holdout_audit/'profile-m3-holdout.json',dict(status='passed',candidates={'held':dict(numerical_passed=True,elf_sha256=held_elf,hot_wall_ms={'median':1.52})}))
    w.save(holdout_audit/'profile-controls-holdout.json',dict(status='passed',candidates={}))
    with patch.object(w,'context',return_value={'runtime':'explicit CPU mock'}):
        scored=w.score(frozen,holdout_audit,out/'score',out/'held-profile')
    assert (frozen/'model.json').read_bytes()==saved
    with patch.object(w,'context',return_value={'runtime':'different observer context'}):
        try:w.score(frozen,holdout_audit,out/'wrong-score',out/'held-profile')
        except ValueError:pass
        else:raise AssertionError('changed holdout context admitted')
    assert abs(w.load(scored)['rows'][0]['prediction_ms']-1.51)<1e-8
    wrong=w.load(holdout_audit/'profile-m3-holdout.json');wrong['candidates']['held']['elf_sha256']='wrong'
    w.save(holdout_audit/'profile-m3-holdout.json',wrong)
    with patch.object(w,'context',return_value={'runtime':'explicit CPU mock'}):
        try:w.score(frozen,holdout_audit,out/'wrong-elf-score',out/'held-profile')
        except ValueError:pass
        else:raise AssertionError('different heldout ELF admitted')
    (package/'profile-m3-holdout').mkdir()
    try:w.no_holdout_labels(package)
    except ValueError:pass
    else:raise AssertionError('preexisting holdout execution admitted before freeze')
    result=dict(status='passed',checks=['compiled lowering SHA and flags bound to target','different compiled native tool rejected','source-specific native guards emitted and propagated unchanged to frozen model','native features emitted only by mocked native CLI','holdout label keys absent before fit','real existing fitter with synthetic labels','model mutation rejected','native plan mutation rejected','post-freeze scoring without refit','changed heldout runtime context rejected','different heldout ELF rejected','preexisting holdout execution rejected'],compilation=False,device_submissions=0,runtime_imported=False)
    w.save(out/'summary.json',result);print(json.dumps(result))


if __name__=='__main__':main()
