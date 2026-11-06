#!/usr/bin/env python3
"""Reuse an exact frozen v13 model/data/contract via native search and exports.

No fitting, Python scoring, placement optimization, builds, or implicit hardware
submission. Default compiles; --execute explicitly permits the existing executor.
"""
import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time

ARTIFACT_ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ARTIFACT_ROOT/'python'))
from taskflow_paths import ARTIFACT_REPO


def sha(p):
    h=hashlib.sha256()
    with Path(p).open('rb') as stream:
        for b in iter(lambda:stream.read(1024*1024),b''):h.update(b)
    return h.hexdigest()

def read(p):return json.loads(Path(p).read_text())
def save(p,v):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(v,indent=2,allow_nan=False)+'\n')
def need(c,m):
    if not c:raise ValueError(m)
def identity(p):return dict(path=str(Path(p).resolve()),sha256=sha(p))
def resolve(base,v):
    p=Path(v);return p.resolve() if p.is_absolute() else (base/p).resolve()


def record(out,name,argv,env,device=False):
    directory=out/'commands'/name;directory.mkdir(parents=True,exist_ok=False)
    save(directory/'command.json',[str(x) for x in argv])
    start=time.perf_counter();utc=datetime.now(timezone.utc).isoformat()
    with (directory/'stdout.log').open('w') as log:
        result=subprocess.run([str(x) for x in argv],env=env,stdout=log,stderr=subprocess.STDOUT)
    save(directory/'result.json',dict(returncode=result.returncode,utc_start=utc,utc_end=datetime.now(timezone.utc).isoformat(),
        elapsed_wall_seconds=time.perf_counter()-start,device_submissions=None if device else 0,
        timing_scope='whole subprocess wall; execution submissions recovered from saved actual API events'))
    need(result.returncode==0,'command failed: '+name+' (see '+str(directory)+')')


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--tool',type=Path,required=True,help='existing AIR-enabled native taskflow-opt; never built here')
    parser.add_argument('--output',type=Path,required=True,help='new output directory')
    parser.add_argument('--dataset',type=Path,required=True,help='existing frozen dataset directory')
    parser.add_argument('--model-freeze',type=Path,required=True,help='existing model/freeze directory, reused unchanged')
    parser.add_argument('--execution-contract',type=Path,required=True)
    parser.add_argument('--aie-toy-root',type=Path,default=Path(os.environ.get('AIE_TOY_ROOT',ARTIFACT_REPO.parent/'aie-toy')))
    parser.add_argument('--llvm-build',type=Path,default=Path(os.environ.get('LLVM_BUILD','/home/shiran/project/llvm-project/build')))
    mode=parser.add_mutually_exclusive_group()
    mode.add_argument('--execute',action='store_true',help='compile then submit existing executor cases; hardware coordinator only')
    mode.add_argument('--plan-only',action='store_true',help='native search/export only; no compilation or submissions')
    args=parser.parse_args()
    args.output=args.output.resolve();need(not args.output.exists(),'output must be new')
    tool=args.tool.resolve();dataset=args.dataset.resolve();modeldir=args.model_freeze.resolve();contract_path=args.execution_contract.resolve()
    frozen=read(modeldir/'freeze.json');model_path=modeldir/'model.json';model=read(model_path)
    for key in ('model','dataset','training_audit','fitter'):
        need(sha(frozen[key]['path'])==frozen[key]['sha256'],'frozen dependency changed: '+key)
    need(sha(model_path)==frozen['model']['sha256'] and sha(dataset/'manifest.json')==frozen['dataset']['sha256'],'supplied model/dataset differs from freeze')
    contract=read(contract_path);executor=ARTIFACT_ROOT/'scripts/taskflow_heterogeneous_execute_v13.py'
    need(sha(executor)==contract['executor_sha256'],'current executor differs from supplied execution contract')
    for role,r in contract['files'].items():need(sha(r['path'])==r['sha256'],'execution contract file changed: '+role)
    contract_id=hashlib.sha256(json.dumps(contract,sort_keys=True,separators=(',',':')).encode()).hexdigest()
    need(contract_id==model['execution_contract_identity'],'model execution contract differs')
    data=read(dataset/'manifest.json');need(data['split_status']=='frozen-before-timing-labels','unfrozen dataset')
    env=os.environ.copy()
    envscript=args.aie_toy_root.resolve()/'scripts/env.sh'
    result=subprocess.run(['bash','-c','source "$1"; env -0','bash',str(envscript)],check=True,stdout=subprocess.PIPE,env=env)
    env.update(dict(item.decode().split('=',1) for item in result.stdout.split(b'\0') if item))
    py=args.aie_toy_root.resolve()/'.venv/bin/python'
    args.output.mkdir(parents=True)
    (args.output/'reproduction-source.py').write_bytes(Path(__file__).read_bytes())
    save(args.output/'input-identities.json',dict(tool=identity(tool),dataset=identity(dataset/'manifest.json'),
        model_freeze=identity(modeldir/'freeze.json'),model=identity(model_path),execution_contract=identity(contract_path),
        executor=identity(executor),environment_setup=identity(envscript),
        independent_auditor=identity(ARTIFACT_ROOT/'test/TaskflowMapping/heterogeneous_execution_audit_v13.py')))
    save(args.output/'scope.json',dict(schema='orbit.heterogeneous.reproduction.v13',
        reuse='exact supplied frozen model/data/execution contract; no fresh calibration or retraining',
        mode='plan-only' if args.plan_only else 'execute' if args.execute else 'compile-only',
        planning='original C++ cpu-npu search/export; Python preserves native ranking and final frontier order',
        budgets=dict(rounds=2,beam=3,evaluations=24,diversity_slots=1),
        hardware_requested=args.execute,model_changed=False))
    cases=[];bridges=[]
    # These are declared comparison controls, not Python-generated search candidates.
    baselines=[('all-cpu',['cpu']*3,[]),('all-npu',['npu']*3,[]),
               ('npu-npu-cpu',['npu','npu','cpu'],[]),('split-npu',['npu']*3,[1,2])]
    for fixture in data['cases']:
        if fixture['split']!='holdout':continue
        name=fixture['name'];source=resolve(dataset,fixture['source']['path'])
        need(sha(source)==fixture['source']['sha256'],'heldout source changed')
        config=dict(heterogeneous=dict(task_devices=['cpu']*3,cuts=[]),execution_contract=str(contract_path),
                    heterogeneous_model=str(model_path),search_diversity_slots=1)
        config_path=args.output/'configs'/f'{name}-search.json';save(config_path,config)
        search_dir=args.output/'search'/name
        record(args.output,name+'-search',[tool,source,'--search','--backend=cpu-npu','--evaluator=native',
            '--target-config='+str(config_path),'--search-output='+str(search_dir),'--max-rounds=2','--max-candidates=24','--beam-width=3'],env)
        search=read(search_dir/'search.json')
        need(search['backend']=='cpu-npu' and search['score_unit']=='ms' and search['ranking'],'native search has no ranked candidate')
        need(len(search['selections'])>=2,'native search did not complete two rounds')
        archive={r['candidate_id']:r for r in search['archive']}
        # Preserve the native global first rank AND every final-round selected entry.
        chosen=[('native-best',search['ranking'][0])]+[(f'native-round2-{i}',r['candidate_id']) for i,r in enumerate(search['selections'][-1]['selected'])]
        requests=[]
        for label,devices,cuts in baselines:
            control=dict(config,heterogeneous=dict(task_devices=devices,cuts=cuts))
            p=args.output/'configs'/f'{name}-{label}.json';save(p,control)
            requests.append((label,source,p,None))
        for label,cid in chosen:
            row=archive[cid];feedback=row['evaluation']
            need(feedback['status']=='passed' and feedback['evaluation_kind']=='model_prediction' and feedback['executed'] is False,'native selected feedback is not a calibrated prediction')
            native_source=search_dir/'candidates'/cid/'taskflow.mlir'
            need(native_source.read_text()==row['native_mlir'],'archived source bytes differ from native source')
            requests.append((label,native_source,config_path,cid))
        graph_to_case={}
        for label,selected_source,cfg,cid in requests:
            full_name=name+'-'+label;plan_dir=args.output/'plans'/full_name
            record(args.output,full_name+'-export',[tool,selected_source,'--target-config='+str(cfg),'--heterogeneous-output='+str(plan_dir)],env)
            manifest=read(plan_dir/'manifest.json')
            need(manifest['program_family_key']==model['program_family_key'] and manifest['execution_contract_identity']==contract_id,'exported model domain differs')
            bridge=dict(case=full_name,candidate_id=cid,source=identity(selected_source),manifest=identity(plan_dir/'manifest.json'),
                graph_id=manifest['graph_id'],plan_id=manifest['id'],native_ranking=search['ranking'].index(cid) if cid else None)
            if cid:
                need(manifest['graph_id']==archive[cid]['evaluation']['program_graph_id'],'exported graph differs from original search candidate')
                bridge['native_feedback']=archive[cid]['evaluation'];bridge['action_chain']=archive[cid]['action_chain']
            if manifest['graph_id'] in graph_to_case:
                bridge['duplicate_graph_alias_of']=graph_to_case[manifest['graph_id']];bridges.append(bridge);continue
            graph_to_case[manifest['graph_id']]=full_name;bridges.append(bridge)
            row=dict(name=full_name,manifest=str(plan_dir/'manifest.json'),inputs=[],reference=[])
            for pair in fixture['arrays']:
                for key in ('inputs','reference'):
                    p=resolve(dataset,pair[key]['path']);need(sha(p)==pair[key]['sha256'],'frozen holdout arrays changed');row[key].append(str(p))
            if not args.plan_only:
                compile_dir=args.output/'compiled'/full_name
                record(args.output,full_name+'-compile',[py,executor,'--manifest',plan_dir/'manifest.json','--output',compile_dir,'--llvm-build',args.llvm_build.resolve(),'--compile-only'],env)
                row['compiled']=str(compile_dir/'compiled/compiled.json');del row['manifest']
            cases.append(row)
    save(args.output/'cases.json',dict(cases=cases));save(args.output/'native-selection-bridges.json',dict(bridges=bridges,rule='native rank zero plus native last-round selected; graph-identical comparison aliases preserved but executed once'))
    if args.execute:
        record(args.output,'execute',[py,executor,'--cases',args.output/'cases.json','--output',args.output/'executed','--execute','--warmups','2','--iterations','5'],env,device=True)
        record(args.output,'independent-audit',[py,ARTIFACT_ROOT/'test/TaskflowMapping/heterogeneous_execution_audit_v13.py',
            '--execution-root',args.output/'executed','--cases',args.output/'cases.json','--fixtures',dataset,'--model-freeze',modeldir,'--split','holdout','--output',args.output/'independent-audit'],env)
    actual_starts=None
    if args.execute:
        actual_starts=sum(e['kind']=='actual_xrt_start' for s in read(args.output/'executed/summary.json')['samples'] for e in s['events'])
    save(args.output/'result.json',dict(status='passed',hardware_executed=args.execute,compiled=not args.plan_only,
        cases=len(cases),actual_xrt_submissions=actual_starts if args.execute else 0,
        model_changed=False,timing_labels_used_for_search=False,limitations='region-only resident NPU; no overlap; no speedup hypothesis guaranteed; exact frozen runtime required'))


if __name__=='__main__':main()
