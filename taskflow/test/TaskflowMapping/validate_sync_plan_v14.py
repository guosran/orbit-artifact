#!/usr/bin/env python3
"""Offline bridge from executed ABI/events to Core sync state and API costs.

Python selects evidence and serializes observed operations; C++ classifies state.
No device access, model fitting, production graph construction, or hardware timing.
"""
import argparse
import copy
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import time


def read(p):return json.loads(Path(p).read_text())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def ident(p):return {'path':str(Path(p).resolve()),'sha256':sha(p)}
def verify(x):
    assert sha(x['path'])==x['sha256'],f"changed file {x['path']}"
    return Path(x['path'])
def write(p,x):p.write_text(json.dumps(x,indent=2,sort_keys=True)+'\n')
def command(argv,out):
    start=time.perf_counter();r=subprocess.run(list(map(str,argv)),capture_output=True,text=True)
    write(out,{'argv':list(map(str,argv)),'elapsed_wall_seconds':time.perf_counter()-start,'returncode':r.returncode,'stdout':r.stdout,'stderr':r.stderr})
    assert r.returncode==0,r.stderr

def program_stream(case,call,prep,manifest,bindings,model):
    """Recorded host resets, source-bound poison, actual submits/waits/ABI effects."""
    raw=read(verify(call['raw_result']));events=[];queries=[]
    bystorage={b['storage']:b for b in bindings['bindings']};abi=manifest['regions'][0]['npu_abi']
    def rng(storage):
        b=bystorage[storage];return {'bo':b['physical_id'],'generation':b['generation'],'offset':b['storage_offset'],'bytes':b['observed_extent_bytes']}
    def add(kind,**kw):
        e={'id':len(events)+1,'kind':kind,**kw};events.append(e);return e['id']
    # Prepared.one poisons output before wall timer. This is a source-bound fact,
    # not an isolated timed observation or invented poison timestamp.
    assert len([a for a in abi if a['role']=='output'])==1
    add('HostWrite',range=rng(2),provenance={'kind':'source-bound-output-NaN-poison','source':ident(Path(__file__).resolve().parents[2]/'scripts/taskflow_heterogeneous_execute_v13.py'),'timestamp':None})
    sites={e['event_index']:e for e in call['sync_api_sites']}
    for index,event in enumerate(raw['events']):
        kind=event['kind']
        evidence={'raw_result':call['raw_result'],'event_index':index,'recorded_start_ns':event['start_ns'],'recorded_end_ns':event['end_ns']}
        if kind=='host_input_reset':
            assert event['bytes']==rng(event['storage'])['bytes']
            add('HostWrite',range=rng(event['storage']),provenance=evidence)
        elif kind=='actual_bo_sync':
            site=sites[index];r=rng(site['storage']);op='sync-'+str(index)
            assert site['start_ns']==event['start_ns'] and site['end_ns']==event['end_ns']
            before=add('SyncBegin',range=r,operation=op,direction=site['direction'],provenance=evidence)
            queries.append({'before_event':before,'range':r,'context':{'call_form':'implicit-full-buffer','observation_boundary':'detailed-compatibility','runtime_identity':bindings['runtime_identity'],'observer_identity':bindings['observer_identity']},
                'site':site['site'],'argument_ordinal':site['argument_ordinal'],'count':1,'observed_extent_bytes':site['actual_bo_extent'],'condition_identity':bindings['condition_identity'],'source_api':site})
            add('SyncComplete',range=r,operation=op,direction=site['direction'],provenance=evidence)
        elif kind=='actual_xrt_start':
            add('DeviceSubmit',operation='actual-region-0',accesses=[{'range':rng(a['storage']),'read':a['role']=='input','write':a['role']=='output'} for a in abi],provenance=evidence)
        elif kind=='actual_xrt_wait':add('WaitSuccess',operation='actual-region-0',provenance=evidence)
        elif kind=='host_final_output_copy':add('HostRead',range=rng(2),provenance=evidence)
    return {'schema':'orbit.sync-observation.stream.v14','sample_key':'actual-program:'+case,'registrations':[{'bo':b['physical_id'],'generation':b['generation'],'total_bytes':b['observed_extent_bytes'],'copies':b['copies']} for b in bindings['bindings']],
        'scope':'actual recorded API/reset order plus explicitly labeled frozen-source poison; device access read/write from executed region ABI, no timestamps enter C++ state','raw_sample':call['raw_result'],'events':events,'queries':queries}

def micro_streams(root,model):
    path=Path(__file__).resolve().parents[1]/'TaskflowModels/analyze_sync_state_v14.py'
    spec=importlib.util.spec_from_file_location('existing_analyzer',path);an=importlib.util.module_from_spec(spec);spec.loader.exec_module(an)
    identity=read(root/'identity.json');streams=[];seen=set()
    assert identity['split']=='holdout'
    for line in (root/'samples-index.jsonl').read_text().splitlines():
        index=json.loads(line);s=read(verify(index['sample']));c=s['cell']
        if s['warmup'] or c['id'] in seen or c['observer_mode']!='batch' or c['state']!='unchanged-repeat' or c['direction']!='TO_DEVICE':continue
        seen.add(c['id']);bo='sample-local-standalone';events=an.prefix_events(s,bo);queries=[]
        matching=[r for r in model['rows'] if r['formula']=='batch-entry-plus-cachelines' and r['domain']['call_form']==c['invocation_form']];assert len(matching)==1
        d=matching[0]['domain'];extent=s['bo']['actual_size']
        for api in range(c['sequence_count']):
            r={'bo':bo,'generation':0,'offset':c['offset_bytes'],'bytes':c['size_bytes']};op='actual-sync-'+str(api)
            before=len(events)+1
            events.append({'kind':'SyncBegin','range':r,'operation':op,'direction':c['direction'],'timestamp_ns':None,'provenance':'actual counted invocation order; batch has no per-call timestamps'})
            query={'before_event':before,'range':r,'api_index':api,'context':{'call_form':'implicit-full-buffer' if c['invocation_form']=='whole-implicit' else 'explicit-range','observation_boundary':'batch-outer','runtime_identity':identity['runtime_target_id'],'observer_identity':identity['source_sha256']}}
            if api==0:query.update(site='prebound-contiguous-sync-loop',argument_ordinal=-1,count=c['sequence_count'],observed_extent_bytes=extent,condition_identity=d['condition_identity'])
            # Subsequent queries deliberately lack a performance context: the
            # single real batch outer timer must never be charged n times.
            queries.append(query);events.append({'kind':'SyncComplete','range':r,'operation':op,'direction':c['direction'],'timestamp_ns':None,'provenance':'successful returned actual API; no physical completion clock'})
        for j,e in enumerate(events):e['id']=j+1
        streams.append({'schema':'orbit.sync-observation.stream.v14','sample_key':c['id']+':'+str(s['seed'])+':'+str(s['repeat']),
            'registration':{'bo':bo,'generation':0,'total_bytes':extent,'copies':[]},'events':events,'queries':queries,'raw_sample':index['sample'],
            'scope':'existing analyzer prefix_events normalization; actual source-bound fill/prior TO; no Python state labels used for classification','cell':c})
    assert len(streams)==36
    return streams,ident(path)

def main():
    p=argparse.ArgumentParser(description=__doc__)
    for k in ('root','sync-tool','replay-tool','output'):p.add_argument('--'+k,required=True)
    a=p.parse_args();root=Path(a.root).resolve();out=Path(a.output).resolve();assert not out.exists();out.mkdir(parents=True)
    modelpath=root/'model-freeze-r2/model.json';model=read(modelpath);frozen=read(root/'model-freeze-r2/freeze.json')
    for x in frozen['files'].values():verify(x)
    held=root/'program-holdout-r1'
    running_identity=read(held/'identity.json')
    executor=Path(__file__).resolve().parents[2]/'scripts/taskflow_heterogeneous_execute_v13.py'
    assert sha(executor)==running_identity['executor']['sha256']
    seq=read(held/'program-sequences.json');programs=[];bridges=[];calls=0;apis=0;costsum=0
    for short in ('m4','m16'):
        case=short+'-n64-all-npu';projection=root/('program-projection-'+short+'-r1')
        graph=read(projection/'program-graph.json');trace=read(projection/'sync-boundary-trace.json');cost=read(projection/'sync-cost.json');facts=read(projection/'mechanism-facts.json')
        prep=read(held/'preparation'/(case+'.json'));manifest=read(verify(prep['manifest']));compiled=read(verify(prep['compiled']))
        assert graph['id']==manifest['graph_id']==manifest['graph']['id']==trace['graph_id']==cost['graph_id']==facts['program_graph_id']
        assert graph['computation_mlir']==manifest['graph']['computation_mlir']
        assert graph['source']==manifest['graph']['source']
        assert compiled['manifest_sha256']==sha(prep['manifest']['path'])
        region=manifest['regions'][0];assert len(manifest['regions'])==1 and region['device']=='npu'
        original_dir=Path(prep['manifest']['path']).parent
        original_region=compiled['regions'][0]
        assert sha(original_dir/region['source'])==original_region['source_sha256']
        assert sha(original_dir/region['air'])==original_region['air_sha256']
        assert sha(original_dir/region['npu_abi_path'])==original_region['abi_sha256']
        abi_file=read(original_dir/region['npu_abi_path'])
        assert abi_file['buffers']==[{k:x[k] for k in ('dtype','name','role','shape')} for x in region['npu_abi']]
        for elf in prep['elf']:verify(elf)
        assert [(x['argument'],x['role'],x['storage'],x['copy']) for x in region['npu_abi']]==[(0,'input',0,0),(1,'input',1,1),(2,'output',2,7)]
        bindings=read(root/'program-bindings-r1'/(case+'.bindings.json'))
        assert trace['bindings']==bindings['bindings']
        for b in bindings['bindings']:
            ptr=next(x for x in prep['abi_pointer_proof'] if x['storage']==b['storage'])
            assert ptr['aliases_bo'] and ptr['array_address']==ptr['bo_map_address'] and b['physical_id']=='mapped-address-'+str(ptr['array_address'])
            assert b['observed_extent_bytes']==prep['actual_bo_sizes'][str(b['storage'])] and b['generation']==0
            assert b['copies']==[ptr['copy']] and b['storage_offset']==ptr['offset_bytes']==0
        assert len(trace['queries'])==len(cost['queries'])==4
        assert cost['known_sync_api_subtotal_ns']==10092.5 and cost['whole_program_ns'] is None and cost['physical_transfer_bytes'] is None
        assert cost['parameter_file_sha256']==sha(modelpath)
        for q in cost['queries']:
            d=q['request'];e=q['evaluation'];r=model['rows'][e['matched_row']]
            assert e['status']=='predicted' and not e['complete_program_cost'] and e['physical_bytes'] is None
            assert d['site']==r['domain']['site'] and d['argument_ordinal']==r['domain']['argument_ordinal'] and d['condition_identity']==r['domain']['condition_identity']
            assert d['count']==1 and e['duration_ns']==r['call_ns']
        source=Path(prep['manifest']['path']).parent/'taskflow.mlir'
        fresh=out/('fresh-projection-'+short)
        command([a.sync_tool,source,'--target-config',root/'program-bindings-r1'/(case+'.config.json'),'--runtime-bindings',root/'program-bindings-r1'/(case+'.bindings.json'),'--sync-model',modelpath,'--output',fresh],out/(short+'-projection-command.json'))
        for name in ('program-graph.json','mechanism-facts.json','sync-boundary-trace.json','sync-cost.json'):
            assert read(fresh/name)==read(projection/name),f'fresh CPU projection changed {name}'
        chosen=None
        for s in seq:
            if s['case']!=case:continue
            for call in s['calls']:
                raw=read(verify(call['raw_result']));verify(call['raw_outputs']);calls+=1
                sites=call['sync_api_sites'];assert len(sites)==4
                assert [(x['argument_ordinal'],x['direction']) for x in sites]==[(0,'TO_DEVICE'),(1,'TO_DEVICE'),(2,'TO_DEVICE'),(2,'FROM_DEVICE')]
                for site,q in zip(sites,cost['queries']):
                    ev=raw['events'][site['event_index']];assert ev['kind']=='actual_bo_sync' and ev['start_ns']==site['start_ns'] and ev['end_ns']==site['end_ns']
                    assert site['storage']==q['storage'] and site['site']==q['request']['site'] and site['actual_bo_extent']==q['request']['observed_extent_bytes']
                    apis+=1;costsum+=q['evaluation']['duration_ns']
                assert len([e for e in raw['events'] if e['kind']=='actual_xrt_start'])==len([e for e in raw['events'] if e['kind']=='actual_xrt_wait'])==1
                staging=[e for e in raw['events'] if e['kind']=='runner_staging_observation']
                assert len(staging)==1 and staging[0]['numpy_copyto_calls']==[] and staging[0]['all_arguments_bound']
                resets=[e for e in raw['events'] if e['kind']=='host_input_reset']
                assert {e['storage'] for e in resets}=={0,1} and len(resets)==2
                assert all(e['bytes']==prep['actual_bo_sizes'][str(e['storage'])] for e in resets)
                start=next(e for e in raw['events'] if e['kind']=='actual_xrt_start');wait=next(e for e in raw['events'] if e['kind']=='actual_xrt_wait')
                assert all(e['end_ns']<=sites[0]['start_ns'] for e in resets)
                assert all(e['end_ns']<=start['start_ns'] for e in sites[:3])
                assert start['end_ns']<=wait['start_ns']<=wait['end_ns']<=sites[3]['start_ns']
                assert raw['input_reset_in_timing'] and raw['final_output_copy_in_timing']
                if chosen is None and not s['warmup']:chosen=call
        programs.append(program_stream(case,chosen,prep,manifest,bindings,model))
        bridges.append({'case':case,'graph_id':graph['id'],'original_manifest':prep['manifest'],'original_compiled':prep['compiled'],'projection':ident(projection/'sync-cost.json'),'static_states':[q['query']['state'] for q in trace['queries']]})
    assert calls==486 and apis==1944
    micro,analyzer=micro_streams(root/'holdout-r1',model)
    streams=programs+micro;streamfile=out/'curated-observed-streams.jsonl'
    streamfile.write_text(''.join(json.dumps(x,separators=(',',':'))+'\n' for x in streams))
    replayfile=out/'cpp-replay.jsonl'
    command([a.replay_tool,'--input',streamfile,'--output',replayfile,'--sync-model',modelpath],out/'replay-command.json')
    answers=[json.loads(line) for line in replayfile.read_text().splitlines()];assert len(answers)==38
    for expected,actual in zip(streams,answers):
        assert not actual['timing_used_as_state'] and actual['sample_key']==expected['sample_key']
        if expected['sample_key'].startswith('actual-program:'):
            bridge=next(x for x in bridges if x['case']==expected['sample_key'].split(':')[1])
            assert [q['query']['state'] for q in actual['queries']]==bridge['static_states']
            assert sum(q['cost']['duration_ns'] for q in actual['queries'])==10092.5
        else:
            qs=actual['queries'];assert qs[0]['cost']['status']=='predicted'
            assert all(q['query']['state']=='post-TO-no-access' for q in qs)
            assert all(q['cost'] is None and q['cost_status']=='state-only' for q in qs[1:])
            c=expected['cell'];row=next(x for x in model['rows'] if x['formula']=='batch-entry-plus-cachelines' and x['domain']['call_form']==c['invocation_form'])
            calculated=row['entry_ns']+c['sequence_count']*(row['call_ns']+row['cacheline_ns']*c['size_bytes']/64)
            assert abs(qs[0]['cost']['duration_ns']-calculated)<1e-8
    summary={'schema':'orbit.sync-plan.independent-validation.v14','status':'passed','original_program_calls':calls,'actual_sync_API_records':apis,
        'covered_sync_api_subtotal_sum_ns':costsum,'whole_program_cost':None,'physical_traffic':None,'program_bridges':bridges,
        'replayed_program_calls':2,'replayed_micro_sequences':36,'cpp_replayed_queries':sum(len(x['queries']) for x in answers),
        'micro_batch_charges':36,'later_micro_queries_state_only':sum(len(x['queries'])-1 for x in answers[2:]),
        'model':ident(modelpath),'sync_tool':ident(a.sync_tool),'replay_tool':ident(a.replay_tool),'normalizer':analyzer,
        'observed_streams':ident(streamfile),'cpp_replay':ident(replayfile),
        'scope':['Static projection is a checked successful-path expectation, not a replay of measured timestamps.',
            'Runtime replay uses actual reset/sync/start/wait order and executed ABI reads/writes; source-bound output poison has no invented timestamp.',
            'Actual C++ SyncState supplies classifications; Python does not assign authoritative states.',
            'Generation0 identifies this observed BO registration lifetime, not allocator history before preparation.',
            'Batch cost charged once per real outer span; no compute/wait/internal DMA/physical DDR charge.']}
    write(out/'summary.json',summary);shutil.copyfile(__file__,out/'auditor-source.py');print(json.dumps({'status':'passed','summary':ident(out/'summary.json')}))

if __name__=='__main__':main()
