#!/usr/bin/env python3
"""Experiment orchestration around the original native joint-search driver.

Declared cells select an experimental comparison only. Python never creates a
mapping, rewrites candidate IR, assigns a score or chooses the production beam.
"""
import argparse
from concurrent.futures import ThreadPoolExecutor
import hashlib
import json
import re
from pathlib import Path
import shutil
import subprocess
import time
from datetime import datetime, timezone
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT/'python'))
from taskflow_paths import ORBIT_SRC
from taskflow_profiled_search_v9 import semantic_plan


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def load(path):
    return json.loads(Path(path).read_text())


def save(path, value):
    Path(path).write_text(json.dumps(value, indent=2, sort_keys=True, allow_nan=False)+'\n')


def bound(path):
    return dict(path=str(Path(path).resolve()),sha256=sha(path))


def verify(item):
    path=Path(item['path'])
    if sha(path)!=item['sha256']:
        raise ValueError('bound artifact changed: '+str(path))
    return path


def run(out, name, command):
    command=list(map(str,command))
    save(out/(name+'.command.json'),command)
    started=datetime.now(timezone.utc).isoformat();begin=time.perf_counter()
    try:
        result=subprocess.run(command,cwd=ROOT,capture_output=True,text=True)
    except BaseException as error:
        save(out/(name+'.result.json'),dict(returncode=None,utc_start=started,utc_end=datetime.now(timezone.utc).isoformat(),elapsed_wall_seconds=time.perf_counter()-begin,exception=repr(error),timing_scope='subprocess.run call including process launch and captured I/O; excludes surrounding evidence writes'))
        raise
    elapsed=time.perf_counter()-begin;ended=datetime.now(timezone.utc).isoformat()
    (out/(name+'.stdout.log')).write_text(result.stdout)
    (out/(name+'.stderr.log')).write_text(result.stderr)
    save(out/(name+'.result.json'),dict(returncode=result.returncode,utc_start=started,utc_end=ended,elapsed_wall_seconds=elapsed,timing_scope='subprocess.run call including process launch and captured I/O; excludes surrounding evidence writes; not device kernel time'))
    if result.returncode:
        raise ValueError('command failed: '+name)


def verify_prepared(prepared):
    record=load(prepared/'preregistration.json')
    if sha(prepared/'matrix.json')!=record['matrix_sha256']:
        raise ValueError('registered matrix changed')
    for program in record['programs']:
        for relative,digest in program['files'].items():
            if sha(prepared/relative)!=digest:
                raise ValueError('registered source/input/reference changed: '+relative)
    return load(prepared/'matrix.json')



def legal_candidate(row):
    evaluation=row.get('evaluation',{})
    if row.get('status')=='passed':
        return evaluation.get('status')=='passed'
    diagnostics=evaluation.get('diagnostics',{})
    plan=diagnostics.get('best_plan',{})
    score=evaluation.get('score')
    no_price=score is None or (isinstance(score,dict) and score.get('value') is None)
    return (row.get('status')=='uncalibrated' and evaluation.get('status')=='uncalibrated'
            and diagnostics.get('status')=='uncalibrated' and plan.get('analysis_status')=='supported'
            and plan.get('codegen_status')=='requires_backend_verification'
            and plan.get('cost_status')=='uncalibrated' and plan.get('estimated_ms') is None and no_price)


def request_matches(request,cell):
    kind,lanes=cell['implementation'].rsplit(':',1)
    return (request.get('mapping_readable') is True and request.get('tile_sizes')==cell['tile_sizes']
        and request.get('implementation')==kind and request.get('vector_lanes')==int(lanes)
        and (request.get('data_organization')=='phase-local' if cell['data_organization']=='phase-local'
             else request.get('data_organization')=='retain-across-users' and request.get('storage')==1))


def replay_negative(output,tool,config,program,cell,candidate_id,source_text,request,origin):
    directory=output/program/'negative-replays'/candidate_id;directory.mkdir(parents=True,exist_ok=False)
    source=directory/'source.mlir';source.write_text(source_text)
    if sha(source)!=candidate_id:
        raise ValueError('failed request canonical source SHA differs from native candidate ID')
    command=[str(tool),str(source),'--generic-map','--target-config='+str(config),'--mapping-output='+str(directory/'plan.json')]
    started=datetime.now(timezone.utc).isoformat();begin=time.perf_counter()
    result=subprocess.run(command,cwd=ROOT,capture_output=True,text=True)
    elapsed=time.perf_counter()-begin;ended=datetime.now(timezone.utc).isoformat()
    save(directory/'command.json',dict(argv=command,tool=bound(tool)))
    (directory/'stdout.log').write_text(result.stdout);(directory/'stderr.log').write_text(result.stderr)
    capacity='capacity' in (result.stdout+result.stderr).lower()
    evidence=dict(cell=cell['name'],candidate_id=candidate_id,source=bound(source),requested_configuration=request,
        origin=origin,utc_start=started,utc_end=ended,elapsed_wall_seconds=elapsed,timing_scope='failed native generic-map subprocess including capture, excludes evidence writes',command=bound(directory/'command.json'),stdout=bound(directory/'stdout.log'),stderr=bound(directory/'stderr.log'),config=bound(config),returncode=result.returncode,capacity_diagnostic=capacity,
        scope='replayed failed native request; explicitly not a valid mapping witness or timing label')
    save(directory/'replay.json',evidence)
    if result.returncode==0 or not capacity:
        raise ValueError('predeclared negative did not reproduce native capacity rejection')
    return bound(directory/'replay.json')

def matches(plan, cell):
    if plan.get('tile_sizes')!=cell['tile_sizes']:
        return False
    choices=plan.get('program_mapping_choices',{})
    phase=choices.get('data_organization')=='phase-local'
    panel=choices.get('data_organization')=='retain-across-users' and choices.get('storage')==1
    if not (phase if cell['data_organization']=='phase-local' else panel):
        return False
    implementations={(x['kind'],x['lanes']) for x in plan.get('task_implementations',[])}
    if cell['implementation']=='scalar:1':
        return bool(implementations) and implementations=={('scalar',1)}
    return ('scalar-product-vector-add-f32',8) in implementations and implementations <= {
        ('scalar',1),('scalar-product-vector-add-f32',8)}


def propose(prepared, tool, output):
    matrix=verify_prepared(prepared)
    output.mkdir(parents=True,exist_ok=False)
    (output/'orchestrator-source.py').write_bytes(Path(__file__).read_bytes())
    (output/'frozen-tools').mkdir()
    frozen=output/'frozen-tools/taskflow-opt'
    shutil.copy2(tool,frozen)
    controls=matrix['native_search']
    auto=dict(controls['native_auto_candidates'])
    auto.setdefault('exploration_slots',controls['beam_width'])
    config=dict(model_version='v10-preregistered-native-auto-unpriced',
                generic_air=dict(capacity_bytes=24576,cost_model=dict(schema='orbit.direct-air.cost.v1',kind='features-only')),
                native_auto_candidates=auto,search_diversity_slots=controls['diversity_slots'])
    if 'search_preferences' in controls:
        config['search_preferences']=controls['search_preferences']
    save(output/'search-config.json',config)
    accepted=[];rejected=[];failed_requests=[]
    for program in matrix['programs']:
        name=program['id'];directory=output/name;directory.mkdir()
        source=prepared/'inputs'/name/'source.mlir'
        root=controls['root_tile']
        run(directory,'search',[frozen,source,'--search','--backend=air','--air-distribute-initialization',
            f'--tile-m={root[0]}',f'--tile-n={root[1]}',f'--tile-k={root[2]}',
            '--target-config='+str(output/'search-config.json'),'--search-output='+str(directory/'search'),
            '--max-rounds='+str(controls['max_rounds']),'--max-candidates='+str(controls['max_candidates']),
            '--beam-width='+str(controls['beam_width'])])
        report=load(directory/'search/search.json')
        automatic=directory/'search/automatic-proposals.json'
        if automatic.exists():
            for parent,requests in load(automatic).get('parents',{}).items():
                for request in requests:
                    if not request.get('planner_supported',False) and 'native_mlir' in request:
                        failed_requests.append(dict(program=name,candidate_id=request['candidate_id'],source=request['native_mlir'],request=request.get('requested_configuration',{}),origin=dict(kind='automatic-preflight',file=bound(automatic),parent=parent)))

        for row in report['archive']:
            if not legal_candidate(row):
                rejected.append(dict(program=name,record=row))
                request_path=directory/'search/candidates'/row['candidate_id']/'request.json'
                if request_path.exists() and isinstance(row.get('native_mlir'),str):
                    failed_requests.append(dict(program=name,candidate_id=row['candidate_id'],source=row['native_mlir'],request=load(request_path).get('requested_configuration',{}),origin=dict(kind='archive-rejection',file=bound(request_path))))
                continue
            cid=row['candidate_id'];candidate=directory/'search/candidates'/cid
            candidate_source=candidate/'taskflow.mlir';plan=candidate/'features-plan.json'
            run(directory,'features-'+cid,[frozen,candidate_source,'--generic-map',
                '--target-config='+str(output/'search-config.json'),'--mapping-output='+str(plan)])
            actual=load(plan)
            if actual.get('estimated_ms') is not None:
                raise ValueError('unpriced proposal unexpectedly contains a numeric score')
            accepted.append(dict(program=name,candidate_id=cid,parent=row['parent'],action_chain=row['action_chain'],
                                 source=bound(candidate_source),plan=bound(plan),config=bound(output/'search-config.json')))
    selections=[];coverage=[]
    for cell in matrix['cells']:
        if cell['split']=='negative':
            requests={r['candidate_id']:r for r in failed_requests if r['program']==cell['program'] and request_matches(r['request'],cell)}
            evidence=[]
            for request in requests.values():
                evidence.append(replay_negative(output,frozen,output/'search-config.json',cell['program'],cell,
                    request['candidate_id'],request['source'],request['request'],request['origin']))
            coverage.append(dict(cell=cell['name'],split='negative',replayed_rejections=evidence,
                                 status='native-rejection' if evidence else 'not-covered'))
            continue
        hits=[r for r in accepted if r['program']==cell['program'] and matches(load(verify(r['plan'])),cell)]
        unique={load(verify(r['plan']))['direct_air_cost']['features']['execution_fingerprint'] for r in hits}
        if len(hits)!=1 or len(unique)!=1:
            coverage.append(dict(cell=cell['name'],split=cell['split'],status='not-covered-or-ambiguous',candidates=[r['candidate_id'] for r in hits]))
        else:
            selections.append(dict(cell=cell,**hits[0]))
            coverage.append(dict(cell=cell['name'],split=cell['split'],status='covered',candidate_id=hits[0]['candidate_id']))
    save(output/'coverage.json',coverage)
    save(output/'native-rejections.json',rejected)
    save(output/'accepted-candidates.json',accepted)
    save(output/'selected-cases.json',selections)
    save(output/'proposal.json',dict(schema='orbit.implementation-search.proposals.v10',prepared=str(prepared),
         registration=bound(prepared/'preregistration.json'),matrix=bound(prepared/'matrix.json'),tool=bound(frozen),
         config=bound(output/'search-config.json'),selected=bound(output/'selected-cases.json'),coverage=bound(output/'coverage.json'),
         label_scope='no timing labels read; native original search owns all transforms/legality/beam/exploration'))
    if any(row['status'] not in ('covered','native-rejection') for row in coverage):
        raise ValueError('native archive did not cover declared cells; adjust only original generator budgets and preserve this attempt')
    return output/'proposal.json'


def compile_cases(proposals, output, jobs=1):
    record=load(proposals/'proposal.json');verify(record['registration']);verify(record['matrix']);tool=verify(record['tool'])
    selected=load(verify(record['selected']))
    output.mkdir(parents=True,exist_ok=False)
    if jobs not in (1,2,4):
        raise ValueError('compile jobs must be 1, 2 or 4')
    def compile_one(row):
        name=row['cell']['name'];materialized=output/('input-'+name);materialized.mkdir()
        (materialized/'source.mlir').write_bytes(verify(row['source']).read_bytes())
        destination=output/name
        run(output,'compile-'+name,['bash',ROOT/'scripts/run_taskflow_direct_air_v6_case.sh','--compile-only','--diagnostic',
            '--input',materialized,'--output',destination,'--tool',tool,'--target-config',verify(row['config']),
            '--distribute-initialization','--runtime-transfer-audit'])
        run(output,'storage-'+name,[sys.executable,ROOT/'test/TaskflowAIR/audit_storage_v6.py',destination/'hardware',
            '--plan',destination/'plan.json','--output',destination/'storage-audit.json'])
        actual=load(destination/'plan.json');expected=load(verify(row['plan']))
        if sha(destination/'source.mlir')!=row['source']['sha256'] or semantic_plan(actual)!=semantic_plan(expected):
            raise ValueError('compiled program differs from original native proposal: '+name)
        compile_record=load(destination/'hardware/compile.json');air=destination/'hardware/input.air.mlir';elf=destination/'hardware/program.elf'
        for attr,value in [('orbit.mapping_plan',actual['plan_id']),('orbit.source_fingerprint',actual['body_fingerprint'])]:
            if set(re.findall(re.escape(attr)+r'\s*=\s*"([^"]+)"',air.read_text()))!={value}:
                raise ValueError('compiled AIR native mapping/source identity differs')
        if compile_record['status']!='compiled' or compile_record.get('bf16_emulation') is not False or compile_record['source_sha256']!=sha(air) or compile_record['elf_sha256']!=sha(elf):
            raise ValueError('compiled AIR/ELF identity mismatch')
        return dict(selection=row,compiled=str(destination),source=bound(destination/'source.mlir'),
            plan=bound(destination/'plan.json'),air=bound(air),elf=bound(elf),abi=bound(destination/'abi.json'),
            compile_record=bound(destination/'hardware/compile.json'))
    with ThreadPoolExecutor(max_workers=jobs) as pool:
        records=list(pool.map(compile_one,selected))
    save(output/'compiled-cases.json',records)
    save(output/'compile-manifest.json',dict(schema='orbit.implementation-search.compiled.v10',proposal=bound(proposals/'proposal.json'),
        cases=bound(output/'compiled-cases.json'),prepared=record['prepared'],tool=record['tool'],compile_jobs=jobs,device_submissions=0))
    return output/'compile-manifest.json'


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    sub=parser.add_subparsers(dest='phase',required=True)
    p=sub.add_parser('propose');p.add_argument('--prepared',type=Path,required=True);p.add_argument('--tool',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    p=sub.add_parser('compile');p.add_argument('--proposals',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--jobs',type=int,choices=[1,2,4],default=1)
    args=parser.parse_args()
    if args.phase=='propose':result=propose(args.prepared.resolve(),args.tool.resolve(),args.output.resolve())
    else:result=compile_cases(args.proposals.resolve(),args.output.resolve(),args.jobs)
    print(json.dumps(dict(status='passed',phase=args.phase,result=str(result),device_submissions=0)))


if __name__=='__main__':
    main()
