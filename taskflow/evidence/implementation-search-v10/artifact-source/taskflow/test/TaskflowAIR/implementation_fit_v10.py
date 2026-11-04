#!/usr/bin/env python3
"""CPU protocol tests using explicitly synthetic native facts and labels."""
import argparse
import importlib.util
import json
from pathlib import Path
import sys
from unittest.mock import patch

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'scripts'))
import fit_implementation_cost_v10 as fit
from taskflow_implementation_search_v10 import bound,save,sha


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--output',type=Path,required=True)
    out=parser.parse_args().output.resolve();out.mkdir(parents=True,exist_ok=False)
    prepared=out/'prepared';prepared.mkdir();(prepared/'inputs/m32-k128-n64').mkdir(parents=True);(prepared/'inputs/m32-k128-n64/source.mlir').write_text('synthetic nonexecutable search source');tool=out/'fake-native-tool';tool.write_text('nonexecutable synthetic native fixture')
    matrix=dict(native_search=dict(root_tile=[8,16,32],max_rounds=1,max_candidates=4,beam_width=2),timing=dict(observer='detailed',warmups=2,hot=5),model_protocol=dict(terms=list(fit.TERMS),max_scaled_design_condition=1e6,objective='relative-residual-floor-1ms',comparators=dict(legacy_theoretical=dict(coefficients=dict(launch_ms=.1,per_scalar_operation_ms=1e-6,per_transfer_byte_ms=1e-7),calibration='CPU synthetic old-theory config'))))
    save(prepared/'matrix.json',matrix);save(prepared/'preregistration.json',dict(matrix_sha256=sha(prepared/'matrix.json'),programs=[]))
    proposals=out/'proposals';proposals.mkdir();selected=[];compiled=out/'compiled';compiled.mkdir();packages=[]
    vectors=[(1,10,0,2),(1,20,0,2),(1,0,10,2),(1,0,20,5),(1,20,0,5),(1,0,30,3)]
    samples=[];identities={};checks=[];coef=[.2,.01,.008,.002]
    for i,vector in enumerate(vectors):
        name=f'cell{i}';split='train' if i<5 else 'holdout';directory=compiled/name;(directory/'hardware').mkdir(parents=True)
        for namefile in ['source.mlir','program.air.mlir','abi.json','hardware/program.elf','hardware/compile.json']:(directory/namefile).write_text('synthetic '+name+' '+namefile)
        save(directory/'target.json',dict(generic_air={},native_auto_candidates=dict(mode='joint',max_tile_proposals=12,exploration_slots=2)));save(directory/'hardware/toolchain.json',{'synthetic':True});save(directory/'hardware/command.json',['aircc','--device=npu2','--stack-size=4096',str(directory/'program.air.mlir')]);save(directory/'invocation.json',dict(tool=str(tool),tool_sha256=sha(tool),flags=['--target-config='+str(directory/'target.json')]))
        values=dict(zip(fit.TERMS,vector),all_storage_f32=1,source_has_tile_tail=int(split=='holdout'))
        values.update({key:1 for key in fit.REQUIRED if key not in values})
        f=dict(schema='orbit.direct-air.features.v1',region_family_fingerprint='a'*64,architecture_fingerprint='b'*64,implementations=['scalar:1' if vector[1] else 'scalar-product-vector-add-f32:8'],source_operations={'arith.addf:f32':10,'arith.mulf:f32':10},values=values)
        save(directory/'plan.json',dict(tile_sizes=[1,8,1],program_mapping_choices={'data_organization':'phase-local'},task_implementations=[dict(kind='scalar' if vector[1] else 'scalar-product-vector-add-f32',lanes=1 if vector[1] else 8)],direct_air_cost=dict(features=f)))
        row=dict(cell=dict(name=name,split=split,program=name,tile_sizes=[1,8,1],implementation='scalar:1' if vector[1] else 'scalar-product-vector-add-f32:8',data_organization='phase-local'),source=bound(directory/'source.mlir'),plan=bound(directory/'plan.json'),config=bound(directory/'target.json'))
        selected.append(row);packages.append(dict(selection=row,compiled=str(directory),**{k:bound(directory/v) for k,v in dict(source='source.mlir',plan='plan.json',air='program.air.mlir',elf='hardware/program.elf',abi='abi.json',compile_record='hardware/compile.json').items()}))
        if split=='train':
            identities[name]=dict(elf_sha256=sha(directory/'hardware/program.elf'),abi_sha256=sha(directory/'abi.json'))
            samples.append(dict(candidate=name,warmup=False,wall_ms=sum(c*x for c,x in zip(coef,vector)),checks={'Y':dict(passed=True,finite=True)}));checks.append(dict(candidate=name,passed=True))
    matrix['cells']=[r['cell'] for r in selected];save(prepared/'matrix.json',matrix);save(prepared/'preregistration.json',dict(matrix_sha256=sha(prepared/'matrix.json'),programs=[]))
    save(proposals/'coverage.json',[dict(cell=r['cell']['name'],split=r['cell']['split'],status='covered') for r in selected]);save(proposals/'selected-cases.json',selected)
    save(proposals/'proposal.json',dict(prepared=str(prepared),registration=bound(prepared/'preregistration.json'),matrix=bound(prepared/'matrix.json'),coverage=bound(proposals/'coverage.json'),selected=bound(proposals/'selected-cases.json'),config=selected[0]['config'],tool=bound(tool)))
    design=out/'design';fit.design(proposals,design)
    save(compiled/'compiled-cases.json',packages);save(compiled/'compile-manifest.json',dict(cases=bound(compiled/'compiled-cases.json'),proposal=bound(proposals/'proposal.json'),tool=bound(tool)))
    profile=out/'profile-train';profile.mkdir();save(profile/'cases.json',[dict(name=n) for n in identities]);save(profile/'invocation.json',dict(identities=identities,cases_path=str(profile/'cases.json')));save(profile/'results.json',dict(results=[dict(status='passed',samples=samples)]))
    audit=out/'audit.json';save(audit,dict(status='passed',profile='profile-train',checks=checks))
    with patch.object(fit,'runtime_identity',return_value=('explicit CPU mock runtime',{'scope':'CPU synthetic preparation'})):
        fit.fit(design,compiled,profile,audit,out/'frozen',out/'heldout/profile-holdout')
    frozen=out/'frozen';model=json.loads((frozen/'model.json').read_text());assert model['kind']=='implementation-composite'
    assert model['training_manifest_digest']==sha(frozen/'training-label-manifest.json')
    assert json.loads((frozen/'model-simple-3term.json').read_text())['terms'][3]['coefficient_ms']==0
    assert json.loads((frozen/'fit-simple-3term.json').read_text())['feature_rank']==3
    assert model['domain']['family_fingerprints']==['a'*64] and model['domain']['architecture_fingerprints']==['b'*64]
    assert 'source_fingerprints' not in model['domain'] and model['domain']['allow_tails'] is True
    for term,expected in zip(model['terms'],coef):assert abs(term['coefficient_ms']-expected)<1e-10
    assert json.loads((frozen/'fit.json').read_text())['holdout_timing_labels_read'] is False
    fit.check_freeze(frozen);original=(frozen/'model.json').read_bytes();(frozen/'model.json').write_bytes(original+b' ')
    try:fit.check_freeze(frozen)
    except ValueError:pass
    else:raise AssertionError('mutated model admitted')
    (frozen/'model.json').write_bytes(original)
    badinv=dict(identities=dict(identities,cell5=identities['cell0']),cases_path=str(profile/'cases.json'));save(profile/'invocation.json',badinv)
    with patch.object(fit,'runtime_identity',return_value=('explicit CPU mock runtime',{'scope':'CPU synthetic preparation'})):
        try:fit.fit(design,compiled,profile,audit,out/'bad-fit',out/'heldout/profile-holdout')
        except ValueError:pass
        else:raise AssertionError('heldout identity admitted to training')
    save(profile/'invocation.json',dict(identities=identities,cases_path=str(profile/'cases.json')))
    result=dict(status='passed',checks=['static rank-four design before labels','known four nonnegative coefficients recovered','native family/architecture domain, no source-SHA gate','predeclared tails retained','holdout labels not consumed','model mutation rejected','holdout candidate in training rejected'],compilation=False,device_submissions=0,scope='synthetic native facts/labels only; no hardware calibration')
    save(out/'summary.json',result);print(json.dumps(result))


if __name__=='__main__':main()
