#!/usr/bin/env python3
"""CPU-only tests for native-order selection and immutable compile handoff."""
import argparse,copy,hashlib,json,sys,tempfile
from pathlib import Path
from unittest.mock import patch
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'scripts'))
import taskflow_implementation_experiment_v10 as E


def main():
    p=argparse.ArgumentParser();p.add_argument('--output',type=Path,required=True);args=p.parse_args();args.output.mkdir(parents=True,exist_ok=False)
    checks=[]
    def ok(value,label):
        if not value:raise AssertionError(label)
        checks.append(label)
    def rejects(fn,label):
        try:fn()
        except (ValueError,KeyError):checks.append(label);return
        raise AssertionError(label)
    with tempfile.TemporaryDirectory() as temp:
        root=Path(temp);search=root/'search';search.mkdir();archive=[];plans=[]
        for i in range(4):
            source=f'module {{ // candidate{i}\n}}\n';cid=hashlib.sha256(source.encode()).hexdigest();directory=search/'candidates'/cid;directory.mkdir(parents=True)
            (directory/'taskflow.mlir').write_text(source)
            plan=dict(body_fingerprint='body',tile_sizes=[i+1,16,32],cost_status='calibrated',estimated_ms=float(4-i),direct_air_cost={'features':{'execution_fingerprint':str(i),'implementations':['scalar:1']}},program_mapping_choices={'data_organization':'phase-local'})
            E.save(directory/'mapping-result.json',{'status':'passed','best_plan':plan});plans.append(plan)
            archive.append(dict(candidate_id=cid,native_mlir=source,parent='',action='native',action_chain=[],round=1,status='passed',evaluation=dict(status='passed',evaluation_kind='model_prediction',evidence_path=str(directory/'mapping-result.json'),score=dict(provenance='calibrated-direct-air-model',unit='ms',value=float(4-i),physical_hardware_measurement=False))))
        report={'archive':archive,'ranking':[r['candidate_id'] for r in archive],'evaluations':4,'attempts':4}
        exclusions={'projection_fields':['body_fingerprint','tile_sizes'],'excluded':[dict(execution_fingerprint='1',semantic_configuration={k:plans[1][k] for k in ['body_fingerprint','tile_sizes']})]}
        call=lambda:E.ranked_selection(report,search,[plans[0]],exclusions)
        winner,decisions=call();ok(winner['row']['candidate_id']==archive[2]['candidate_id'],'native order retained despite lower later score')
        ok([x['reason'] for x in decisions[:2]]==['previously-measured-training-configuration','previously-measured-v9-semantic-configuration'],'training and historical semantic exclusions')
        winner,_=E.ranked_selection(report,search,[plans[0]],exclusions,False);ok(winner['row']['candidate_id']==archive[0]['candidate_id'],'control uses original native first rank')
        changed=copy.deepcopy(report);changed['archive'][2]['evaluation']['evaluation_kind']='observed_measurement'
        winner,_=E.ranked_selection(changed,search,[plans[0]],exclusions);ok(winner['row']['candidate_id']==archive[3]['candidate_id'],'uncalibrated or nonprediction skipped')
        source=search/'candidates'/archive[2]['candidate_id']/'taskflow.mlir';original=source.read_bytes();source.write_text('tampered')
        rejects(call,'source identity mutation rejected');source.write_bytes(original)
        mapping=Path(archive[2]['evaluation']['evidence_path']);original=mapping.read_bytes();bad=json.loads(original);bad['best_plan']['estimated_ms']=999;E.save(mapping,bad)
        rejects(call,'native score plan mismatch rejected');mapping.write_bytes(original)
        changed=copy.deepcopy(report);changed['ranking'].append(changed['ranking'][0]);rejects(lambda:E.ranked_selection(changed,search,[],exclusions),'duplicate native ranking rejected')
        unknown=copy.deepcopy(report);entry=unknown['archive'][3];entry['status']='uncalibrated';entry['score']=None
        entry['evaluation'].update(status='uncalibrated',evaluation_kind='static_estimate');entry['evaluation'].pop('score')
        unknown_plan=copy.deepcopy(plans[3]);unknown_plan.update(estimated_ms=None,cost_status='out_of_domain',analysis_status='supported',codegen_status='requires_backend_verification')
        unknown_plan['direct_air_cost']['reason']='native feature outside calibrated range'
        E.save(Path(entry['evaluation']['evidence_path']),{'status':'uncalibrated','best_plan':unknown_plan})
        chosen,decision=E.unknown_selection(unknown,search,[plans[0]],exclusions,[plans[2]])
        ok(chosen['row']['candidate_id']==entry['candidate_id'] and chosen['native_rank'] is None,'unknown uses stable archive order outside model ranking')
        ok(decision[-1]['score'] is None and decision[-1]['calibration_rejection']=='native feature outside calibrated range','unknown retains null score and calibrated rejection')
        entry['score']=0
        rejects(lambda:E.unknown_selection(unknown,search,[],exclusions,[]),'numeric price cannot masquerade as unknown')
        entry['score']=None
        rejects(lambda:E.unknown_selection(unknown,search,[],exclusions,[unknown_plan]),'already-selected unknown excluded')
        rejects(lambda:E.select_candidate(root,root,root,root,exploration_budget=2),'hardware exploration budget is bounded')
        # The real selection assembly uses the same optional budget branch;
        # exercise budget0/1 end-to-end without compiler/device dependencies.
        native=root/'native';native.write_text('tool');cfg=root/'config.json';E.save(cfg,{'generic_air':{'cost_model':{}}})
        frozen_root=root/'frozen';frozen_root.mkdir();E.save(frozen_root/'freeze.json',{})
        model=root/'model.json';E.save(model,{})
        features=root/'features.json';E.save(features,[{'split':'train','selection':{'plan':E.bound(Path(archive[0]['evaluation']['evidence_path']))}}]*12)
        proposal_root=root/'original-proposal.json';E.save(proposal_root,{'prepared':str(root)})
        pred=root/'predictions.json';E.save(pred,{'freeze':E.bound(frozen_root/'freeze.json')})
        inp_root=root/'entry';inp_root.mkdir();(inp_root/'search').mkdir();E.save(inp_root/'search/search.json',unknown)
        # Use a patched selector only to avoid moving the candidate directory;
        # the selector's order/exclusion behavior was tested above on real files.
        E.save(inp_root/'search-inputs.json',{'predictions':E.bound(pred),'configuration':{'config':E.bound(cfg),'tool':E.bound(native)}})
        manifest=root/'exclusions.json';historical={'projection_fields':['body_fingerprint','tile_sizes'],'excluded':[]}
        for i in range(4):historical['excluded'].append({'source':E.bound(native),'plan':E.bound(Path(archive[1]['evaluation']['evidence_path'])),'transformed_source':E.bound(native),'semantic_configuration':{k:plans[1][k] for k in ['body_fingerprint','tile_sizes']}})
        for k in ['case_manifest','observed_table','raw_manifest']:historical[k]=E.bound(native)
        E.save(manifest,historical)
        design={'features':E.bound(features),'tool':E.bound(native),'proposal':E.bound(proposal_root),'registration':E.bound(cfg),'matrix':E.bound(cfg)}
        frozen_record={'design':E.bound(cfg),'model':E.bound(model)}
        # Historical native plans are direct plan objects, as in delivered exclusions.
        direct=root/'direct-plan.json';E.save(direct,plans[1])
        for r in historical['excluded']:r['plan']=E.bound(direct)
        E.save(manifest,historical)
        def winner_for(plan,row):return dict(row=row,plan=plan,mapping=Path(row['evaluation']['evidence_path']),source=search/'candidates'/row['candidate_id']/'taskflow.mlir',native_rank=0)
        with patch.object(E,'check_freeze',return_value=frozen_record),patch.object(E,'check_design',return_value=design),patch.object(E,'ranked_selection',return_value=(winner_for(plans[2],archive[2]),[])),patch.object(E,'unknown_selection',return_value=(winner_for(unknown_plan,entry),[])) as unknown_mock:
            E.select_candidate(inp_root,frozen_root,root/'budget0',manifest,exploration_budget=0)
            ok(unknown_mock.call_count==0 and len(E.load(root/'budget0/selected-cases.json'))==1,'budget0 performs no unknown selection')
            E.select_candidate(inp_root,frozen_root,root/'budget1',manifest,exploration_budget=1)
            ok(unknown_mock.call_count==1 and len(E.load(root/'budget1/selected-cases.json'))==2,'budget1 adds exactly one unknown case')
        # check_selection must inspect bound outputs before invoking any compiler.
        out=root/'selection';out.mkdir();frozen=root/'freeze.json';E.save(frozen,{})
        artifact=out/'artifact.json';E.save(artifact,{})
        proposal=out/'proposal.json';E.save(proposal,{k:E.bound(artifact) for k in ['registration','matrix','tool','selected']})
        E.save(out/'selection-freeze.json',dict(freeze=E.bound(frozen),design=E.bound(artifact),exclusions=E.bound(artifact),source=E.bound(artifact),proposal=E.bound(proposal),selected=E.bound(artifact),searches=[]))
        artifact.write_text('tampered')
        with patch.object(E,'check_freeze',return_value={}):rejects(lambda:E.check_selection(out),'bound selection artifact mutation rejected')
    E.save(args.output/'summary.json',dict(status='passed',checks=checks,device_submissions=0,compiler_invocations=0,source=E.bound(Path(E.__file__))))
    print(json.dumps({'status':'passed','checks':len(checks)}))


if __name__=='__main__':main()
