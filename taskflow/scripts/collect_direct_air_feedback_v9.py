#!/usr/bin/env python3
"""Collect an audited, SHA-bound descriptor for native observed feedback.

No score, median, mapping, search, compilation or device execution occurs here.
The separate taskflow_profiled_search_v9.py --profile path consumes the descriptor.
"""
import argparse
from collections import Counter
import hashlib
import importlib.util
import json
from pathlib import Path
import re

_helper=Path(__file__).with_name('taskflow_profiled_search_v9.py')
_spec=importlib.util.spec_from_file_location('profiled_search_helpers',_helper)
_helpers=importlib.util.module_from_spec(_spec);_spec.loader.exec_module(_helpers)
sha,write,semantic_plan=_helpers.sha,_helpers.write,_helpers.semantic_plan
BOUNDARY=_helpers.BOUNDARY
RECORDED_WHOLE_WALL='host prepare + unchanged existing runner + final output copy; context load/input-reference load/numerics/output serialization excluded'


def load(path):return json.loads(Path(path).read_text())
def descriptor(path):
    path=Path(path).resolve()
    return {'path':str(path),'sha256':sha(path)}
def digest_string(value):return isinstance(value,str) and re.fullmatch('[0-9a-f]{64}',value) is not None
def canonical(value):return json.dumps(value,sort_keys=True,separators=(',',':'),allow_nan=False)


def case_preparation_contract(profile,invocation):
    cases_path=Path(invocation['cases_path'])
    if not digest_string(invocation.get('cases_sha256')) or sha(cases_path)!=invocation['cases_sha256']:
        raise ValueError('executed case list differs from invocation cases SHA')
    rows=load(cases_path)
    if not isinstance(rows,list) or not rows:raise ValueError('executed case list must be nonempty')
    seeds=sorted(profile.glob('seed-*/result.json'))
    if not seeds:raise ValueError('actual per-seed call history required for BO hot state')
    histories={path.parent.name:load(path)['samples'] for path in seeds}
    names=set();policies=[]
    for row in rows:
        name=row['name']
        if name in names:raise ValueError('duplicate executed case name')
        names.add(name);identity=invocation['identities'][name]
        abi_path=Path(identity['abi_path'])
        if sha(abi_path)!=identity['abi_sha256']:raise ValueError('executed case ABI changed')
        # The invocation saves the profiler-resolved ABI. Absolute case paths
        # can also be cross-checked directly; relative paths retain that saved
        # resolution rather than guessing a historical working directory.
        declared=Path(row['abi']) if 'abi' in row else Path(row['hardware'])/'abi.json'
        if declared.is_absolute() and sha(declared)!=identity['abi_sha256']:
            raise ValueError('case-list ABI differs from executed invocation ABI')
        abi=load(abi_path);buffers=abi['buffers'];output_names=abi['outputs']
        if not output_names or len(set(output_names))!=len(output_names) or any(n not in {b['name'] for b in buffers} for n in output_names):
            raise ValueError('invalid executed output ABI')
        outputs=sorted(i for i,b in enumerate(buffers) if b['name'] in output_names)
        def indices(key):
            values=row.get(key,[])
            if not isinstance(values,list) or any(isinstance(i,bool) or not isinstance(i,int) or i<0 or i>=len(buffers) for i in values):
                raise ValueError('invalid executed '+key)
            return sorted(set(values))
        static=indices('static_indices');scratch=indices('intermediate_indices')
        if set(static)&(set(scratch)|set(outputs)) or set(scratch)&set(outputs):
            raise ValueError('overlapping static/scratch/output BO policies')
        if 'output_indices' in row and indices('output_indices')!=outputs:
            raise ValueError('case output indices disagree with actual ABI outputs')
        if 'outputs' in row and row['outputs']!=output_names:
            raise ValueError('case output names disagree with actual ABI outputs')
        warmup_counts={};hot_counts={}
        for seed,samples in histories.items():
            calls=[sample for sample in samples if sample['candidate']==name]
            if not calls or any(type(sample['warmup']) is not bool for sample in calls):
                raise ValueError('missing/invalid actual case call history')
            prefix=0;seen_hot=False
            for sample in calls:
                if sample['warmup']:
                    if seen_hot:raise ValueError('warmup appears after labeled hot BO calls')
                    prefix+=1
                else:seen_hot=True
            if not seen_hot:raise ValueError('case has no actual labeled hot calls')
            warmup_counts[seed]=prefix;hot_counts[seed]=len(calls)-prefix
        if all(n>=1 for n in warmup_counts.values()):state='warmup-before-all-labeled-hot'
        elif all(n==0 for n in warmup_counts.values()):state='no-warmup-cold-or-mixed'
        else:state='mixed-warmup-presence'
        policies.append({'profile_name':name,'abi_sha256':identity['abi_sha256'],
            'static_indices':static,'intermediate_indices':scratch,'output_indices':outputs,
            'output_names':output_names,'per_call_input_indices':sorted(set(range(len(buffers)))-set(static)-set(scratch)-set(outputs)),
            'hot_state':state,'actual_warmups_by_seed':warmup_counts,'labeled_hot_calls_by_seed':hot_counts})
    if names!=set(invocation['identities']):raise ValueError('case list/invocation candidate coverage mismatch')
    contract={'schema':'orbit.executed-bo-preparation.v1','case_policies':sorted(policies,key=lambda p:p['profile_name']),
        'scope':'existing profiler/runner BO preparation and sample-marked warmup state; not on-chip residency or a physical cache measurement'}
    return contract,descriptor(cases_path)


def runtime_identity(profile,invocation,preparation=None):
    runner=load(profile/'runner-identity.json');wait=load(profile/'wait-backend.json')
    if not digest_string(runner.get('sha256')) or wait.get('selected') is not True:
        raise ValueError('recorded runner SHA and actually selected wait backend required')
    if not wait.get('module') or not wait.get('qualname') or not digest_string(wait.get('selected_source_sha256')):
        raise ValueError('selected wait backend module/qualname/source SHA required')
    if wait.get('multilaunch_source_sha256')!=runner['sha256']:
        raise ValueError('wait/runner source identity mismatch')
    profiler=profile/'profiler-source.py'
    if sha(profiler)!=invocation.get('script_sha256'):
        raise ValueError('archived profiler source differs from invocation')
    observer=invocation.get('observer');boundary=load(profile/'measurement-boundary.json')
    if boundary.get('whole_wall')!=RECORDED_WHOLE_WALL:
        raise ValueError('profile timing boundary is not the supported prepared complete-command wall')
    if not observer or boundary.get('observer')!=observer:
        raise ValueError('observer/boundary identity mismatch')
    if preparation is None:preparation,_=case_preparation_contract(profile,invocation)
    return ('MultiLaunchRunner:'+runner['sha256']+';observer:'+observer+
        ';profiler:'+invocation['script_sha256']+';selected-wait:'+wait['module']+'.'+
        wait['qualname']+'@'+wait['selected_source_sha256']+';bo-preparation:'+hashlib.sha256(canonical(preparation).encode()).hexdigest())


def compile_context(command,toolchain):
    if not isinstance(command,list) or not command or not toolchain:
        raise ValueError('recorded compiler command/toolchain required')
    device=None;flags=[];i=1
    while i<len(command):
        arg=command[i]
        if arg=='--device':
            if i+1>=len(command):raise ValueError('recorded --device has no argument')
            i+=1;device=command[i];flags.extend(['--device',device])
        elif arg.startswith('--device='):
            device=arg.split('=',1)[1];flags.extend(['--device',device])
        elif arg=='--elf-name':
            if i+1>=len(command):raise ValueError('recorded --elf-name has no argument')
            i+=1
        elif arg.startswith('--elf-name='):pass
        elif arg.startswith('--peano='):flags.append('--peano=<recorded-llvm-aie-version>')
        elif not arg.endswith('.mlir'):flags.append(arg)
        i+=1
    if not device:raise ValueError('actual aircc --device missing from compile command')
    return {'device':device,'flags':flags,'toolchain':toolchain}


def validate_profile(profile,audit,invocation):
    results=load(profile/'results.json')
    if audit.get('status')!='passed' or audit.get('profile')!=profile.name:
        raise ValueError('independent audit must pass for this profile directory')
    if audit.get('observer')!=invocation.get('observer'):
        raise ValueError('audit observer differs from invocation')
    seeds=sorted(profile.glob('seed-*/result.json'))
    if not seeds or audit.get('seed_count')!=len(seeds):
        raise ValueError('audit seed count mismatch')
    if Counter(canonical(load(p)) for p in seeds)!=Counter(canonical(v) for v in results['results']):
        raise ValueError('aggregate profile results differ from per-seed results')
    expected=set();hot=Counter()
    for path in seeds:
        seed=load(path)
        if seed.get('status')!='passed':raise ValueError('entire failed experiment ineligible')
        for sample in seed['samples']:
            name=sample['candidate']
            for output,check in sample['checks'].items():
                if not check.get('passed') or not check.get('finite'):
                    raise ValueError('numeric failure in experiment')
                key=(path.parent.name,name,sample['repeat'],sample['warmup'],output)
                if key in expected:raise ValueError('duplicate profile sample/output')
                expected.add(key)
            if not sample['warmup']:hot[name]+=1
    actual=set()
    for check in audit['checks']:
        if not check.get('passed') or not check.get('finite') or not digest_string(check.get('output_sha256')):
            raise ValueError('audit raw output check not passed/SHA-bound')
        key=tuple(check[k] for k in ('seed','candidate','repeat','warmup','output'))
        if key in actual:raise ValueError('duplicate independent audit output')
        actual.add(key)
    if actual!=expected or audit.get('output_checks')!=len(actual):
        raise ValueError('independent audit output coverage/count mismatch')
    for name,count in hot.items():
        candidate=audit['candidates'][name]
        if not candidate.get('numerical_passed') or not candidate.get('numeric_gate_passed') or candidate['hot_wall_ms']['n']!=count:
            raise ValueError('audit candidate eligibility/hot sample count mismatch')
        if candidate['elf_sha256']!=invocation['identities'][name]['elf_sha256']:
            raise ValueError('audit/invocation candidate ELF mismatch')
    return hot,len(actual)


def target_identity(context,runtime):
    environment={'compile_context':context,'runtime':runtime,'boundary':BOUNDARY}
    return {'id':'recorded-aircc-device:'+context['device']+';context:'+hashlib.sha256(canonical(environment).encode()).hexdigest(),
        'toolchain':canonical(context['toolchain']),'runtime':runtime}


def collect(proposal_cases,proposal_summary,compiled_root,profile,audit_path):
    proposal_cases,proposal_summary,compiled_root,profile,audit_path=[Path(p).resolve() for p in (proposal_cases,proposal_summary,compiled_root,profile,audit_path)]
    if proposal_cases.parent!=proposal_summary.parent:
        raise ValueError('proposal cases/summary directory mismatch')
    invocation=load(profile/'invocation.json');audit=load(audit_path)
    hot,output_count=validate_profile(profile,audit,invocation)
    preparation,executed_cases=case_preparation_contract(profile,invocation)
    runtime=runtime_identity(profile,invocation,preparation)
    entries=[];contexts=[];evidence=[];names=set();seen=set()
    for case in load(proposal_cases):
        cid=case['candidate_id']
        if cid in seen:raise ValueError('duplicate proposal candidate')
        seen.add(cid)
        for key in ('source','config','features_plan'):
            if sha(Path(case[key]))!=case[key+'_sha256']:
                raise ValueError('proposal '+key+' identity changed')
        features=load(case['features_plan'])['direct_air_cost']['features']
        if not digest_string(case['execution_fingerprint']) or features['execution_fingerprint']!=case['execution_fingerprint']:
            raise ValueError('proposal execution key differs from native feature plan')
        directory=compiled_root/cid;hardware=directory/'hardware'
        source=directory/'source.mlir';plan_path=directory/'plan.json';air=hardware/'input.air.mlir'
        elf=hardware/'program.elf';record=load(hardware/'compile.json');plan=load(plan_path)
        if sha(source)!=case['source_sha256'] or semantic_plan(plan)!=semantic_plan(load(case['features_plan'])):
            raise ValueError('compiled source/full semantic plan differs from native proposal')
        air_text=air.read_text()
        for attr,value in [('orbit.mapping_plan',plan['plan_id']),('orbit.source_fingerprint',plan['body_fingerprint'])]:
            if set(re.findall(re.escape(attr)+r'\s*=\s*"([^"]+)"',air_text))!={value}:
                raise ValueError('AIR mapping/source metadata differs from compiled plan')
        if record.get('status')!='compiled' or record.get('bf16_emulation') is not False or record['source_sha256']!=sha(air) or record['elf_sha256']!=sha(elf):
            raise ValueError('FP32 compile AIR/ELF identity mismatch')
        name=case.get('profile_name',cid)
        if name not in invocation['identities']:
            matches=[n for n,v in invocation['identities'].items() if v['elf_sha256']==sha(elf)]
            if len(matches)!=1:raise ValueError('profile candidate name/ELF mapping ambiguous')
            name=matches[0]
        if name in names:raise ValueError('multiple proposals map to one profiled candidate')
        names.add(name);identity=invocation['identities'][name]
        if identity['elf_sha256']!=sha(elf) or identity['compile_record']['source_sha256']!=sha(air) or identity['abi_sha256']!=sha(hardware/'abi.json'):
            raise ValueError('profile invocation AIR/ELF/ABI identity mismatch')
        if name not in hot or audit['candidates'][name]['elf_sha256']!=sha(elf):
            raise ValueError('candidate missing audited hot samples')
        lowering=load(directory/'invocation.json')
        if not digest_string(lowering.get('tool_sha256')) or sha(Path(lowering['tool']))!=lowering['tool_sha256']:
            raise ValueError('native lowering compiler identity mismatch')
        toolchain=load(hardware/'toolchain.json')
        toolchain['orbit-native-lowering-sha256']=lowering['tool_sha256']
        contexts.append(compile_context(load(hardware/'command.json'),toolchain))
        entries.append({'candidate_id':cid,'profile_name':name,'compiled_source':descriptor(source),
            'compiled_plan':descriptor(plan_path),'compiled_air':descriptor(air),'elf':descriptor(elf),
            'compile_record':descriptor(hardware/'compile.json')})
        evidence.append({'candidate_id':cid,'abi':descriptor(hardware/'abi.json'),
            'toolchain':descriptor(hardware/'toolchain.json'),'compile_command':descriptor(hardware/'command.json'),
            'native_lowering_invocation':descriptor(directory/'invocation.json'),'native_lowering_tool':descriptor(lowering['tool']),
            'hot_sample_count':hot[name],'execution_fingerprint':case['execution_fingerprint']})
    if not entries:raise ValueError('no observed proposal cases')
    if any(context!=contexts[0] for context in contexts):
        raise ValueError('compile device/flags/toolchain differ; separate observed target tables required')
    context=contexts[0]
    target=target_identity(context,runtime)
    result={'schema':'orbit.profiled-search.feedback.v1','boundary':BOUNDARY,'target':target,
        'proposal_summary':descriptor(proposal_summary),'proposal_cases':descriptor(proposal_cases),
        'profile_results':descriptor(profile/'results.json'),'audit':descriptor(audit_path),
        'invocation':descriptor(profile/'invocation.json'),'profile_cases':executed_cases,'cases':entries}
    proof={'status':'passed','cases':evidence,'raw_output_checks':output_count,
        'executed_cases':executed_cases,'bo_preparation_contract':preparation,
        'bo_preparation_digest':hashlib.sha256(canonical(preparation).encode()).hexdigest(),
        'runtime_records':{name:descriptor(profile/name) for name in ('runner-identity.json','wait-backend.json','profiler-source.py','measurement-boundary.json')},
        'target_scope':'device name comes from recorded aircc command; context hashes recorded toolchain/flags/runtime, not physical device serial/clock attestation',
        'scope':'descriptor collection only; no median/score/planning/search/compile/device execution'}
    result['collection_evidence']=proof
    return result,proof


def main():
    p=argparse.ArgumentParser(description=__doc__)
    for name in ('proposal-cases','proposal-summary','compiled-root','profile-directory','audit','output'):
        p.add_argument('--'+name,type=Path,required=True)
    a=p.parse_args()
    result,proof=collect(a.proposal_cases,a.proposal_summary,a.compiled_root,a.profile_directory,a.audit)
    a.output.mkdir(parents=True,exist_ok=False)
    write(a.output/'feedback-descriptor.json',result);write(a.output/'feedback-target.json',result['target']);write(a.output/'collection.json',proof)
    print(json.dumps({'status':'passed','cases':len(result['cases']),'descriptor':str((a.output/'feedback-descriptor.json').resolve()),'hardware_executed':False}))


if __name__=='__main__':main()
