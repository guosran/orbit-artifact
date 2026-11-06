#!/usr/bin/env python3
"""Freeze/evaluate actual native contrast outputs and raw two-context pair runs.

This adapter never changes the C++ model or planner. `freeze` only reads native
predictions/static metadata, never heldout observations. `evaluate` revalidates
source/copy/graph/ABI/ELF/clock correspondence before the paired difference gate.
"""
import argparse
import json
import math
from pathlib import Path
from audit_mechanism_program_v16 import read,verify,identity,sha
from audit_contrast_v17 import run
from contrast_evidence_v17 import plan_side,bound_measurements

def write(p,o):p.write_text(json.dumps(o,indent=2,allow_nan=False)+'\n')
def pair_record(row):
    index=read(verify(row['compiled_index']));matches=[p for p in index['cases'] if p['pair_id']==row['pair_id']];assert len(matches)==1;return matches[0]

def freeze(index,model_path,registration,out,target_binding=None):
    assert not out.exists();out.mkdir(parents=True)
    idx=read(index);model=read(model_path);reg=read(registration)
    assert model['kind']=='contrast-composite' and model['schema']=='orbit.direct-air.cost.v1'
    if target_binding is not None:assert read(target_binding)==model['target'],'actual target binding differs from frozen model'
    modelrows={r['change_class']:r for r in model['rows']};condition=model['target']['condition'];predictions=[];native=[]
    for row in idx['cases']:
        facts=read(verify(row['facts']));pair=pair_record(row);folder=Path(row['facts']['path']).parent;costpath=verify(row['cost']) if 'cost' in row else folder/'cost.json';cost=read(costpath)
        assert facts['change_class']==row['change_class'] and facts['supported'];sides={s:plan_side(pair[s])[0] for s in ['baseline','candidate']}
        for side in sides:
            assert sides[side]['graph_id']==facts[side]['graph_id'] and sides[side]['plan_id']==facts[side]['plan_id']
            timing=read(folder/(side+'-timing.json'));assert timing['complete_invocation']['makespan_ms'] is None,'contrast fit became an absolute search score'
        terms=modelrows[facts['change_class']]['terms'];expected=sum(t['coefficient_ns']*facts['delta_quantities'][t['feature']] for t in terms)
        prediction=cost['candidate_minus_baseline_ns'];assert cost['change_class']==facts['change_class']
        if prediction is not None:
            assert math.isclose(prediction,expected,rel_tol=1e-12,abs_tol=1e-5)
            bound=modelrows[facts['change_class']]['prediction_error_bound_ns']
            assert math.isclose(cost['lower_delta_ns'],prediction-bound,rel_tol=1e-12,abs_tol=1e-5) and math.isclose(cost['upper_delta_ns'],prediction+bound,rel_tol=1e-12,abs_tol=1e-5)
            assert len(cost['contributions'])==len(terms)
            for term,contribution in zip(terms,cost['contributions']):
                key=term['feature'];assert contribution['feature']==key and contribution['coefficient_ns']==term['coefficient_ns'] and contribution['delta']==facts['delta_quantities'][key]
                assert contribution['baseline']==facts['baseline']['quantities'][key] and contribution['candidate']==facts['candidate']['quantities'][key]
        records=[identity(costpath),row['facts'],row['compiled_index'],row['protocol']]
        for s in ['baseline','candidate']:
            assert read(verify(pair[s]['graph']))==read(Path(pair[s]['compiled'])/'plan.json')['program_graph'];records.extend([pair[s]['source'],pair[s]['graph'],pair[s]['graph_equality']])
        predictions.append(dict(pair_id=row['pair_id'],split=row['split'],orientation='candidate-minus-baseline',contrast_class=facts['change_class'],condition_id=condition,covered_change=facts['covered_change'],baseline=sides['baseline'],candidate=sides['candidate'],prediction_delta_ns=prediction,unknown_reason=cost['reason'] if prediction is None else '',common_work_policy='changed-implementation-coupled-contrast',implementation_evidence=records,parameter_contributions=cost['contributions'],native_cost=identity(costpath)))
        native.append(row)
    metrics=reg['metrics'];mp=out/'metrics.json';write(mp,dict(orientation='candidate-minus-baseline',resolution_floor_ns=metrics['resolution_absolute_floor_ns'],difference_absolute_floor_ns=metrics['prediction_error_absolute_floor_ns'],difference_relative_fraction=metrics['prediction_error_relative_fraction'],require_seed_sign_agreement=True,required_classes=metrics['required_classes'],min_resolved_pairs_per_class=metrics['min_resolved_pairs_per_class']))
    pp=out/'predictions.json';write(pp,{'rows':predictions});np=out/'native-index.json';write(np,idx)
    frozen=dict(model=identity(model_path),registration=identity(registration),predictions=identity(pp),metrics=identity(mp),native_index=identity(np),native_source_index=identity(index),auditor=identity(__file__),evidence_auditor=identity(Path(__file__).with_name('contrast_evidence_v17.py')),gate_auditor=identity(Path(__file__).with_name('audit_contrast_v17.py')))
    if target_binding is not None:frozen['target_binding']=identity(target_binding)
    for role,record in idx.get('frozen_inputs',{}).items():
        verify(record)
        if role in frozen:
            if role in ['model','registration','target_binding']:assert frozen[role]['sha256']==record['sha256'],'conflicting frozen model/registration/target role'
            elif frozen[role]['sha256']!=record['sha256']:frozen['native_'+role]=record
        else:frozen[role]=record
    manifest=out/'manifest.json';write(manifest,dict(schema='orbit.contrast.audit-adapter.v17',required_roles=list(frozen),frozen=frozen,sessions=[]))
    receipt=run(manifest,False);write(out/'freeze-receipt.json',receipt)
    print(json.dumps(dict(status='frozen',pairs=len(predictions),holdout_labels_read=False,receipt=identity(out/'freeze-receipt.json'))))

def evaluate(frozen,out,sessions):
    assert not out.exists();out.mkdir(parents=True)
    manifest=read(frozen/'manifest.json');manifest['freeze_receipt']=identity(frozen/'freeze-receipt.json');rows=read(verify(manifest['frozen']['native_index']))['cases'];pred={r['pair_id']:r for r in read(verify(manifest['frozen']['predictions']))['rows']};manifest['sessions']=[]
    for name,root in sessions:
        samples=[];pair_ids=[];first_protocol=None;evidence=[]
        for row in rows:
            if row['split']!='holdout':continue
            actual=Path(root)/row['pair_id'];assert (actual/'summary.json').exists(),'complete heldout process required'
            assert sha(actual/'protocol.json')==row['protocol']['sha256'];protocol=read(verify(row['protocol']))
            this={k:protocol[k] for k in ['seeds','warmups','repeats','poll_us']}
            if first_protocol is None:first_protocol=this
            assert this==first_protocol
            facts=read(verify(row['facts']));audit=bound_measurements(pair_record(row),facts,actual);write(out/(name+'-'+row['pair_id']+'-evidence.json'),audit);evidence.append(identity(out/(name+'-'+row['pair_id']+'-evidence.json')))
            pr=pred[row['pair_id']];pair_ids.append(row['pair_id'])
            for pair in audit['all_pairs']:
                samples.append(dict(pair_id=row['pair_id'],seed=pair['seed'],repeat=pair['repeat'],warmup=pair['warmup'],condition_id=pr['condition_id'],baseline=pr['baseline'],candidate=pr['candidate'],baseline_ns=pair['baseline_ns'],candidate_ns=pair['candidate_ns']))
        sp=out/(name+'-samples-adapter.jsonl');sp.write_text('\n'.join(json.dumps(s) for s in samples)+'\n');pp=out/(name+'-protocol-adapter.json');write(pp,dict(pair_ids=pair_ids,**first_protocol,evidence=evidence))
        manifest['sessions'].append(dict(id=name,kind='unseen-pairs' if name=='heldout' else 'same-model-new-session',freeze_receipt_sha256=manifest['freeze_receipt']['sha256'],model_sha256=manifest['frozen']['model']['sha256'],samples=identity(sp),protocol=identity(pp)))
    path=out/'manifest.json';write(path,manifest);result=run(path,True);write(out/'review.json',result);print(json.dumps(dict(status='passed',contrast_gate_passed=result['contrast_gate_passed'],sessions=[dict(id=s['id'],classes=s['by_class'],gate=s['contrast_gate_passed']) for s in result['sessions']]),indent=2))

def main():
    p=argparse.ArgumentParser(description=__doc__);sub=p.add_subparsers(dest='mode',required=True);f=sub.add_parser('freeze');f.add_argument('--native-index',type=Path,required=True);f.add_argument('--model',type=Path,required=True);f.add_argument('--registration',type=Path,required=True);f.add_argument('--output',type=Path,required=True);f.add_argument('--target-binding',type=Path);e=sub.add_parser('evaluate');e.add_argument('--frozen',type=Path,required=True);e.add_argument('--output',type=Path,required=True);e.add_argument('--session',nargs=2,action='append',required=True,metavar=('NAME','ROOT'));a=p.parse_args()
    if a.mode=='freeze':freeze(a.native_index,a.model,a.registration,a.output,a.target_binding)
    else:evaluate(a.frozen,a.output,a.session)
if __name__=='__main__':main()
