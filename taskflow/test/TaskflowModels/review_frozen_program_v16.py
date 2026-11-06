#!/usr/bin/env python3
"""Adapt actual native evidence to independent frozen-program audit, no fitting."""
import argparse
import itertools
import json
import math
from pathlib import Path
import statistics
from audit_mechanism_program_v16 import read,verify,identity,sha,stats,audit,quantile

def write(p,o):p.write_text(json.dumps(o,indent=2,allow_nan=False)+'\n')
def review(root,out,sessions):
    out.mkdir(parents=True,exist_ok=False)
    manifest=read(root/'pre-holdout-audit-manifest-r1.json')
    prior=root/'freeze-only-receipt-r1.json';receipt=read(prior)
    assert receipt['frozen']==manifest['frozen'] and receipt['holdout_labels_read'] is False
    for record in manifest['frozen'].values():verify(record)
    model=read(verify(manifest['frozen']['model']));pred=read(verify(manifest['predictions']));rows={r['case']:r for r in pred['rows']};features=read(verify(manifest['frozen']['features']))
    byfeature={c['id']:c for c in features['cases']};identity_checks=[]
    for name,row in rows.items():
        frow=byfeature[row['case_id']];f=read(verify(frow['features']))['values'];expected=1e6*sum(term['coefficient_ms']*f[term['feature']] for term in model['terms'])
        assert math.isclose(row['prediction_ns'],expected,rel_tol=1e-12,abs_tol=1e-6)
        timing=read(verify(row['timing']));native=read(Path(frow['compiled'])/'plan.json')
        assert native['program_graph_id']==row['graph_id'] and native['plan_id']==row['plan_id']
        fresh=read(Path(frow['features']['path']).parent/'plan.json')
        assert native['program_graph']==fresh['program_graph']
        # Actual frozen C++ timing owns complete invocation and has one priced
        # composite; internal descriptive DMA/core activities are not recharged.
        graph=timing['program_timing'] if 'program_timing' in timing else timing.get('evaluation',timing)
        identity_checks.append(dict(case=name,graph_id=row['graph_id'],plan_id=row['plan_id'],prediction_ns=expected,timing=row['timing'],compiled_plan=identity(Path(frow['compiled'])/'plan.json')))
    manifest['freeze_receipt']=identity(prior);manifest['sessions']=[];originals=[]
    for session in sessions:
        source=root/session;proto=read(source/'protocol.json');runtime=read(source/'runtime.json');condition=read(verify(manifest['frozen']['condition']))
        assert runtime['active_contexts']==condition['context_count']==8 and runtime['poll_us']==condition['poll_us']==20
        assert proto['runner']==condition['runner'] and proto['installed_runtime']==condition['installed_runner']
        for k,v in condition['observers'].items():assert proto[k]==v
        assert read(source/'summary.json')['status']=='passed'
        target=read(verify(manifest['frozen']['heldout_protocol']));assert proto==target
        samples=[]
        for line in (source/'samples.jsonl').read_text().splitlines():
            s=json.loads(line);c=s['case_identity'];r=rows[s['case']];plan=read(verify(c['plan']))
            assert plan['program_graph_id']==r['graph_id'] and plan['plan_id']==r['plan_id'] and c['elf']['sha256']==r['artifact_sha256'];verify(c['elf'])
            start=next(e for e in s['events'] if e['kind']=='actual_xrt_start');wait=next(e for e in s['events'] if e['kind']=='actual_xrt_wait');syncs=[e for e in s['events'] if e['kind']=='actual_bo_sync']
            assert s['dispatch_to_wait_end_ns']==wait['end_ns']-start['start_ns']
            assert s['sync_subtotal_ns']==sum(e['end_ns']-e['start_ns'] for e in syncs)
            assert s['runner_wall_ns']==s['dispatch_to_wait_end_ns']+s['sync_subtotal_ns']+s['other_runner_ns']
            samples.append(dict(case=s['case'],seed=s['seed'],repeat=s['repeat'],warmup=s['warmup'],duration_ns=s['runner_wall_ns'],graph_id=r['graph_id'],plan_id=r['plan_id'],artifact_sha256=r['artifact_sha256']))
        p=out/(session+'-adapter.jsonl');p.write_text('\n'.join(json.dumps(x) for x in samples)+'\n')
        manifest['sessions'].append(dict(id=session,kind='unseen-plan' if session=='holdout-r1' else 'same-model-new-session',model_sha256=manifest['frozen']['model']['sha256'],cases=[c['id'] for c in proto['cases']],samples=identity(p),freeze_receipt_sha256=sha(prior)))
        originals.append(dict(session=session,samples=identity(source/'samples.jsonl'),identity=identity(source/'identity.json'),runtime=identity(source/'runtime.json'),protocol=identity(source/'protocol.json')))
    mp=out/'audit-manifest.json';write(mp,manifest);result=audit(mp,True)
    result['original_sessions']=originals;result['native_identity_checks']=identity_checks
    automatic=read(verify(manifest['frozen']['automatic_candidates']));auto={c['id']:c for c in automatic['cases']}
    for name,c in auto.items():
        bridge=read(Path(c['compiled']).parent/'graph-identity-bridge.json');searched=read(verify(bridge['searched_graph']));compiled=read(verify(bridge['compiled_plan']))
        assert searched==compiled['program_graph'] and rows[name]['candidate_id']==c['candidate_id'] and rows[name]['action_chain']==c['action_chain']
        assert c['candidate_id']==sha(Path(c['prepared'])/'source.mlir')
    for session in result['sessions']:
        pairs=[]
        for pair in session['contrasts']:
            if pair['left'] not in auto or pair['right'] not in auto:continue
            st=pair['paired_observation'];cellmap={c['case']:c for c in session['cells']};delta=cellmap[pair['right']]['distribution']['median_ns']-cellmap[pair['left']]['distribution']['median_ns'];variation=quantile(st['raw_ns'],.9)-quantile(st['raw_ns'],.1);pd=pair['predicted_right_minus_left_ns']
            resolved=abs(delta)>variation
            passed=resolved and pd is not None and pd*delta>0 and abs(pd-delta)<.5*abs(delta)
            pairs.append(dict(left=pair['left'],right=pair['right'],observed_median_difference_ns=delta,observed_paired_delta_ns=st['median_ns'],predicted_delta_ns=pd,paired_p90_minus_p10_ns=variation,measurement_resolved=resolved,ranking_passed=passed,raw_paired_deltas_ns=st['raw_ns']))
        # Registration's cell medians and paired-difference stability are distinct.
        session['automatic_candidate_registered_pairs']=pairs
        session['registered_search_gate_passed']=session['mape_percent']<=20 and all(p['ranking_passed'] for p in pairs if p['measurement_resolved']) and any(p['measurement_resolved'] for p in pairs)
    result['search_ready']=all(s['registered_search_gate_passed'] for s in result['sessions']) and bool(result['sessions'])
    result['frozen_model_unchanged']=sha(manifest['frozen']['model']['path'])==manifest['frozen']['model']['sha256']
    result['scope']='Same frozen model and native graphs, new unseen plans and separate matched-condition process; source fingerprints are preregistered finite domain, not arbitrary-program extrapolation.'
    write(out/'review.json',result)
    print(json.dumps(dict(search_ready=result['search_ready'],sessions=[dict(id=s['id'],mape_percent=s['mape_percent'],passed=sum(c['passed'] is True for c in s['cells']),cells=len(s['cells']),automatic_pairs=s['automatic_candidate_registered_pairs']) for s in result['sessions']]),indent=2))
def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--root',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--session',action='append',required=True);a=p.parse_args();review(a.root,a.output,a.session)
if __name__=='__main__':main()
