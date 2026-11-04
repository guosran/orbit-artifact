#!/usr/bin/env python3
"""Independent selected-search raw-output, identity and descriptive timing audit.

Read-only compiler/runtime evidence; no compilation, device calls or fitting.
"""
import argparse,itertools,json,math,statistics,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'scripts'))
from taskflow_implementation_search_v10 import bound,load,save,sha,verify,run,semantic_plan
from taskflow_implementation_experiment_v10 import check_selection,ranked_selection,unknown_selection
from fit_implementation_cost_v10 import check_freeze,check_design
from taskflow_implementation_runtime_v10 import runtime_identity
from audit_implementation_search_v10 import comparison


def audit(selection,compiled,profile,output):
    selected=check_selection(selection);frozen=verify(selected['freeze']).parent;f=check_freeze(frozen)
    d=check_design(Path(f['design']['path']).parent);timing=load(verify(d['matrix']))['timing'];model=load(verify(f['model']))
    binding=load(compiled/'selection-binding.json')
    if binding['selection']!=bound(selection/'selection-freeze.json'):
        raise ValueError('compiled selection identity differs')
    manifest=load(verify(binding['compiled']));packages=load(verify(manifest['cases']));rows=load(verify(selected['selected']))
    if [p['selection'] for p in packages]!=rows or manifest['proposal']!=bound(selection/'proposal.json'):
        raise ValueError('compiled case order/proposal identity differs')
    invocation=load(profile/'invocation.json');actual_runtime,preparation=runtime_identity(profile,invocation,timing)
    if actual_runtime!=model['target']['runtime']:
        raise ValueError('actual selected runtime policy differs from frozen model target')
    names=[p['selection']['cell']['name'] for p in packages]
    if list(invocation['identities'])!=names:
        raise ValueError('profile case order differs from frozen selection')
    exclusion=load(verify(selected['exclusions']));features=load(verify(d['features']))
    training=[load(verify(x['selection']['plan'])) for x in features if x['split']=='train'];prior=[]
    for entry,row in zip(selected['searches'],rows):
        report=load(verify(entry['search']));plan=load(verify(row['plan']))
        if entry['role']=='unpriced-hardware-exploration':
            recomputed,_=unknown_selection(report,Path(entry['search']['path']).parent,training,exclusion,prior)
        else:
            recomputed,_=ranked_selection(report,Path(entry['search']['path']).parent,training,exclusion,entry['novelty_required'])
        if recomputed['row']['candidate_id']!=row['candidate_id'] or recomputed['plan']!=plan:
            raise ValueError('chosen case differs from original native order/exclusion rule')
        prior.append(plan)
    output.mkdir(parents=True,exist_ok=False)
    run(output,'raw-audit',[sys.executable,ROOT/'test/TaskflowAIR/audit_profile_v9.py','--root',profile.parent,
        '--profile',profile.name,'--output',output/'raw-audit'])
    numerical=load(output/'raw-audit'/(profile.name+'.json'))
    if numerical['status']!='passed' or set(numerical['candidates'])!=set(names):
        raise ValueError('selected raw numerical audit failed or case coverage differs')
    predictions=[];identities=[]
    for package,entry in zip(packages,selected['searches']):
        row=package['selection'];name=row['cell']['name'];identity=invocation['identities'][name]
        for key in ['source','plan','air','elf','abi','compile_record']:verify(package[key])
        actual=load(verify(package['plan']));expected=load(verify(row['plan']));compile_record=load(verify(package['compile_record']))
        if (package['source']['sha256']!=row['source']['sha256'] or semantic_plan(actual)!=semantic_plan(expected) or
            identity['elf_sha256']!=package['elf']['sha256'] or identity['abi_sha256']!=package['abi']['sha256'] or
            compile_record['source_sha256']!=package['air']['sha256'] or compile_record['elf_sha256']!=package['elf']['sha256'] or
            compile_record['status']!='compiled' or compile_record.get('bf16_emulation') is not False):
            raise ValueError('selected source/native plan/AIR/ELF/ABI/FP32 identities differ')
        air=Path(package['air']['path']).read_text()
        for key,value in [('orbit.mapping_plan',actual['plan_id']),('orbit.source_fingerprint',actual['body_fingerprint'])]:
            import re
            if set(re.findall(re.escape(key)+r'\s*=\s*"([^"]+)"',air))!={value}:raise ValueError('AIR native provenance differs')
        hardware=Path(package['compiled'])/'hardware'
        run(output,'storage-'+name,[sys.executable,ROOT/'test/TaskflowAIR/audit_storage_v6.py',hardware,'--plan',verify(package['plan']),'--output',output/(name+'-storage.json')])
        run(output,'runtime-'+name,[sys.executable,ROOT/'test/TaskflowAIR/audit_runtime_transfers_v7.py',hardware,'--plan',verify(package['plan']),'--abi',verify(package['abi']),'--output',output/(name+'-runtime.json')])
        channel='not-applicable-no-planned-channel-allocations'
        if actual.get('channel_allocations'):
            run(output,'channels-'+name,[sys.executable,ROOT/'test/TaskflowAIR/audit_channel_ports_v6.py',hardware,'--plan',verify(package['plan']),'--output',output/(name+'-channels.json')]);channel='passed'
        identities.append(dict(name=name,role=entry['role'],candidate_id=row['candidate_id'],source=package['source'],plan=package['plan'],air=package['air'],elf=package['elf'],abi=package['abi'],compile_record=package['compile_record'],channel_audit=channel,native_prediction=entry['prediction']))
        if entry['role']!='unpriced-hardware-exploration':
            predictions.append(dict(name=name,program=row['program'],prediction_ms=expected['estimated_ms']))
        elif expected.get('estimated_ms') is not None or entry['score'] is not None:
            raise ValueError('unknown exploration acquired a prediction')
    raw=load(profile/'results.json');calibrated=comparison(predictions,numerical['candidates'],raw)
    pairs=[]
    for first,second in itertools.combinations(names,2):
        deltas=[]
        for seed in raw['results']:
            a={s['repeat']:s['wall_ms'] for s in seed['samples'] if s['candidate']==first and not s['warmup']}
            b={s['repeat']:s['wall_ms'] for s in seed['samples'] if s['candidate']==second and not s['warmup']}
            if not a or set(a)!=set(b):raise ValueError('hot pairing incomplete')
            deltas.extend(b[k]-a[k] for k in sorted(a))
        pairs.append(dict(first=first,second=second,second_minus_first_ms=deltas,paired_median_ms=statistics.median(deltas),paired_mean_ms=statistics.mean(deltas),n=len(deltas)))
    summary=dict(status='passed',numerical_output_checks=numerical['output_checks'],cases=identities,
        calibrated_prediction_validation=calibrated,all_case_pairwise=pairs,parameters_changed=False,refit=False,
        selection=bound(selection/'selection-freeze.json'),compiled=bound(compiled/'selection-binding.json'),profile=bound(profile/'results.json'),
        numerical_audit=bound(output/'raw-audit'/(profile.name+'.json')),preparation=preparation,
        wait_backend=bound(profile/'wait-backend.json') if (profile/'wait-backend.json').exists() else None,
        scope='whole prepared-command host wall; native prediction ties preserved; unknown exploration has no model prediction; descriptive paired differences do not prove causal/significant gain; wait includes runtime/device/DMA/stalls')
    save(output/'validation.json',summary);return output/'validation.json'


def main():
    p=argparse.ArgumentParser(description=__doc__)
    for k in ['selection','compiled','profile','output']:p.add_argument('--'+k,type=Path,required=True)
    a=p.parse_args();print(audit(a.selection.resolve(),a.compiled.resolve(),a.profile.resolve(),a.output.resolve()))


if __name__=='__main__':main()
