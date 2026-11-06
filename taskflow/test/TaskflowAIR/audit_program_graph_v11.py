#!/usr/bin/env python3
"""Independent read-only audit of native ProgramGraph tables and acquisitions.

This checker consumes C++ facts. It does not infer source SSA, construct a plan,
render a replacement production graph, fit costs, compile or open a device.
"""
import argparse,hashlib,json,math,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]


def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def load(path):return json.loads(Path(path).read_text())
def require(value,message):
    if not value:raise ValueError(message)
def index(value,table,label):
    require(type(value)==int and 0<=value<len(table),'invalid '+label);return table[value]


def native_json(value):
    """LLVM JSON's sorted-key compact representation and 17-digit doubles."""
    if value is None:return 'null'
    if value is True:return 'true'
    if value is False:return 'false'
    if isinstance(value,int):return str(value)
    if isinstance(value,float):
        require(math.isfinite(value),'nonfinite graph JSON number')
        return format(value,'.17g')
    if isinstance(value,str):return json.dumps(value,ensure_ascii=False)
    if isinstance(value,list):return '['+','.join(native_json(x) for x in value)+']'
    if isinstance(value,dict):return '{'+','.join(native_json(k)+':'+native_json(value[k]) for k in sorted(value))+'}'
    raise ValueError('unsupported JSON type')


def validate(graph,case=None,plan=None):
    require(graph['schema']=='orbit.program-graph.v1','unknown graph schema')
    require(isinstance(graph['id'],str) and len(graph['id'])==64,'missing graph identity')
    material={key:value for key,value in graph.items() if key not in ['id','cost']}
    require(hashlib.sha256(native_json(material).encode()).hexdigest()==graph['id'],'graph canonical identity does not match checked tables')
    c=graph['ledger'];source=graph['source'];events=c['events'];copies=c['copies'];versions=c['versions'];regions=c['logical_regions'];allocations=c['allocations'];storages=source['storages'];tasks=source['tasks'];count=len(events)
    require(not c['expanded_details_omitted'],'independent audit requires bounded expanded native tables')
    require(source['body_fingerprint']==c['body_fingerprint'],'source/ledger identity mismatch')
    if 'computation_mlir' in graph:
        require(isinstance(graph['computation_mlir'],str) and hashlib.sha256(native_json(graph['computation_mlir']).encode()).hexdigest()==source['body_fingerprint'],'actual computation MLIR/fingerprint differs')
    if plan:
        require(plan['body_fingerprint']==source['body_fingerprint'] and plan['program_graph']==graph and plan['program_graph_id']==graph['id'],'native plan/graph/source mismatch')
    architecture=c['memory_architecture'];memories={m['id']:m for m in architecture['memories']};resources={r['id']:r for r in architecture['resources']};links={l['id']:l for l in architecture['links']}
    require({m['id']:m['capacity_bytes'] for m in c['memories']}=={name:m['capacity_bytes'] for name,m in memories.items()},'architecture/ledger memory capacities differ')
    def region_bytes(region):
        storage=index(region['storage'],storages,'region storage');shape=storage['shape'];require(storage['dtype']=='f32','this experiment requires f32');require(len(shape)==len(region['sizes'])==len(region['offsets']),'region rank differs')
        for offset,size,extent in zip(region['offsets'],region['sizes'],shape):require(type(offset)==type(size)==int and offset>=0 and size>0 and offset+size<=extent,'region outside storage')
        value=4*math.prod(region['sizes']);require(value<2**63,'region byte overflow');return value
    for r in regions:region_bytes(r)
    for v in versions:
        index(v['region'],regions,'version region');require(type(v['producer'])==int and -1<=v['producer']<count,'version producer missing')
        if v['producer']<0:require(storages[regions[v['region']]['storage']]['role']=='input','fabricated initial version')
    for a in allocations:
        index(a['storage'],storages,'allocation storage');require(a['memory'] in memories and type(a['bytes'])==int and a['bytes']>0 and 0<=a['begin_phase']<a['end_phase_exclusive'],'invalid allocation')
    latest={};created=set();users=[[] for _ in copies];consumer_edges=[[] for _ in copies];ancestry=[]
    for i,v in enumerate(versions):
        if v['producer']<0:require(v['region'] not in latest,'duplicate initial version');latest[v['region']]=i
    for i,copy in enumerate(copies):
        v=index(copy['version'],versions,'copy version');a=index(copy['allocation'],allocations,'copy allocation');r=regions[v['region']]
        require(a['storage']==r['storage'] and a['bytes']>=region_bytes(r) and copy['layout']=='row_major','copy allocation/region/layout differs')
        require(-1<=copy['created_by']<count and 0<=copy['available_from']<copy['released_after']<=count,'copy lifetime invalid')
        if copy['created_by']<0:require(v['producer']==-1 and copy['available_from']==0,'invalid external copy');created.add(i)
    communications={x['event']:x for x in graph['communications']};require(len(communications)==len(graph['communications']),'duplicate transfer event')
    instances={x['event']:x for x in graph['instances']};require(len(instances)==len(graph['instances']),'duplicate instance event');traffic=0
    for i,e in enumerate(events):
        task=index(e['task'],tasks,'event task');require(e['resource'] in resources,'event resource missing')
        deps=e['depends_on'];require(deps==sorted(set(deps)) and all(type(p)==int and 0<=p<i for p in deps),'dependency is not earlier unique event')
        ancestors=0
        for p in deps:ancestors|=ancestry[p]|(1<<p)
        ancestry.append(ancestors)
        require(len(set(e['reads']))==len(e['reads']) and len(set(e['writes']))==len(e['writes']),'duplicate read/write copy')
        for ci in e['reads']:
            copy=index(ci,copies,'event read');require(ci in created and copy['available_from']<=i<copy['released_after'],'read before creation/after release')
            v=versions[copy['version']];require(latest[v['region']]==copy['version'],'stale logical version read')
            require(copy['created_by']<0 or copy['created_by'] in deps,'missing copy creation dependence');users[ci].append(i)
        for ci in e['writes']:
            copy=index(ci,copies,'event write');require(ci not in created and copy['created_by']==i and copy['available_from']==i,'duplicate/wrong copy creation');v=versions[copy['version']]
            if e['kind']=='transfer':require(latest[v['region']]==copy['version'],'transfer changes version')
            else:require(v['producer']==i,'compute version producer mismatch');latest[v['region']]=copy['version']
            created.add(ci)
        if e['kind']=='transfer':
            require(i in communications and not e['data_edges'] and not e['order_edges'],'transfer omitted or fabricates logical edges');t=communications[i]
            require(t['source_copies']==e['reads'] and t['target_copies']==e['writes'] and t['dependencies']==deps and t['resource']==e['resource'] and t['link']==e['link'],'transfer binding mismatch')
            size=region_bytes(t);require(t['bytes']==size,'transfer rectangle bytes differ');link=links[t['link']]
            require(link['resource']==t['resource'] and len(e['reads'])==len(e['writes'])>0,'transfer resource/copy pairing invalid');total=0
            for from_id,to_id in zip(e['reads'],e['writes']):
                a,b=copies[from_id],copies[to_id];require(a['version']==b['version'],'copy transfer changes version');r=regions[versions[a['version']]['region']]
                require(r['storage']==t['storage'] and all(lo<=x and x+n<=lo+hi for lo,hi,x,n in zip(t['offsets'],t['sizes'],r['offsets'],r['sizes'])),'transfer omits referenced region')
                require(allocations[a['allocation']]['memory']==link['source'] and allocations[b['allocation']]['memory']==link['target'],'copy path endpoints differ');total+=region_bytes(r)
            require(total==size,'transfer region coverage/duplicate bytes mismatch');traffic+=size
        else:
            require(i in instances and i not in communications,'missing compute instance');inst=instances[i]
            require(inst['task']==e['task'] and inst['phase']==e['phase'] and inst['kind']==('source-initializer' if e['kind']=='initialize' else 'source-task'),'task/event instance mismatch')
            domain_task=index(inst['domain_task'],tasks,'domain task');domain=inst['domain'];require({d['loop'] for d in domain}==set(range(len(domain_task['loops']))) and len(domain)==len(domain_task['loops']),'instance domain coverage differs')
            for d in domain:
                loop=domain_task['loops'][d['loop']];require(loop['lower']<=d['lower']<d['upper']<=loop['upper'] and d['step']==loop['step'] and (d['lower']-loop['lower'])%loop['step']==0,'instance domain outside actual source loop')
            source_reads={x['storage'] for x in task['accesses'] if x['read']}
            source_writes={x['storage'] for x in task['accesses'] if x['write']}
            realized=lambda ids:{storages[regions[versions[copies[ci]['version']]['region']]['storage']]['id'] for ci in ids}
            require(realized(e['reads'])<=source_reads and source_reads-source_writes<=realized(e['reads']) and realized(e['writes'])==source_writes,'instance imports undeclared storage or omits readonly source demand/write')
            for ci in e['reads']+e['writes']:
                memory=memories[allocations[copies[ci]['allocation']]['memory']];accessible=memory.get('accessible_resources',[])
                require(e['resource'] in accessible if accessible else resources[e['resource']]['device'] in memory['accessible_devices'],'compute cannot access copy location')
    if 'boundaries' in graph:
        boundaries=graph['boundaries'];inputs={str(i) for i,x in enumerate(storages) if x['role']=='input'};outputs={str(i) for i,x in enumerate(storages) if x['role']=='output'}
        require(set(boundaries['inputs'])==inputs and set(boundaries['outputs'])==outputs,'source ABI boundary coverage differs')
        for key,memory in boundaries['inputs'].items():
            require(memory in memories,'input memory missing')
            for ri,r in enumerate(regions):
                if r['storage']==int(key):require(any(x['created_by']==-1 and versions[x['version']]['region']==ri and allocations[x['allocation']]['memory']==memory for x in copies),'declared input initial location unavailable')
        for key,memory in boundaries['outputs'].items():
            require(memory in memories,'output memory missing')
            for ri,r in enumerate(regions):
                if r['storage']==int(key):require(any(x['version']==latest[ri] and allocations[x['allocation']]['memory']==memory and x['released_after']==count for x in copies),'final latest output not live at declared boundary')
    require(len(created)==len(copies) and traffic==c['transfer_bytes']==graph['cost']['planned_transfer_bytes'],'created copies/transfer accounting differs')
    require(len(instances)==sum(e['kind']!='transfer' for e in events),'unrealized instance')
    for i,edge in enumerate(c['data_edges']):
        ci=edge['copy'];copy=index(ci,copies,'data edge copy');v=versions[copy['version']];event=index(edge['consumer'],events,'data consumer')
        require(event['kind']!='transfer' and ci in event['reads'] and edge['producer']==v['producer'] and edge['version']==copy['version'] and edge['region']==v['region'],'logical edge/copy/version mismatch')
        require(edge['required_memory']==allocations[copy['allocation']]['memory'] and edge['required_layout']==copy['layout'] and edge['required_dtype']==storages[regions[v['region']]['storage']]['dtype'],'consumption requirement differs');consumer_edges[ci].append(i)
    for i,copy in enumerate(copies):
        require(copy['users']==users[i] and copy['consumer_edges']==consumer_edges[i],'copy user/consumer incidence differs')
        maximal=[u for u in users[i] if not any((ancestry[v]>>u)&1 for v in users[i])]
        require(set(copy['last_users'])==set(maximal),'last user antichain differs')
    for edge in c['order_edges']:
        p,q=edge['producer'],edge['consumer'];require(0<=p<q<count and (ancestry[q]>>p)&1,'ordering edge not realized by dependencies')
        require(tasks[events[p]['task']]['id'] in tasks[events[q]['task']]['dependencies'],'ordering edge lacks source task dependency')
    task_ids={task['id']:i for i,task in enumerate(tasks)}
    raw_pairs={(events[x['producer']]['task'],events[x['consumer']]['task']) for x in c['data_edges'] if x['producer']>=0}
    expected_order={(task_ids[dep],i) for i,task in enumerate(tasks) for dep in task['dependencies'] if (task_ids[dep],i) not in raw_pairs}
    actual_order={(events[x['producer']]['task'],events[x['consumer']]['task']) for x in c['order_edges']}
    require(expected_order==actual_order,'pure source ordering coverage differs or becomes data demand')
    for i,e in enumerate(events):
        require(e['data_edges']==[j for j,x in enumerate(c['data_edges']) if x['consumer']==i] and e['order_edges']==[j for j,x in enumerate(c['order_edges']) if x['consumer']==i],'logical edge incidence differs')
        if e['kind']!='transfer':require([c['data_edges'][j]['copy'] for j in e['data_edges']]==e['reads'],'actual compute copy reads missing logical edges')
    peaks={}
    for memory,m in memories.items():
        boundaries={}
        for ai,a in enumerate(allocations):
            if a['memory']!=memory:continue
            if graph['allocation_lifetime']=='phase-pool':ranges=[(a['begin_phase'],a['end_phase_exclusive'])]
            else:
                ranges=sorted((x['available_from'],x['released_after']) for x in copies if x['allocation']==ai);merged=[]
                for lo,hi in ranges:
                    if merged and lo<=merged[-1][1]:merged[-1]=(merged[-1][0],max(hi,merged[-1][1]))
                    else:merged.append((lo,hi))
                ranges=merged
            for lo,hi in ranges:boundaries[lo]=boundaries.get(lo,0)+a['bytes'];boundaries[hi]=boundaries.get(hi,0)-a['bytes']
        live=peak=0
        for _,delta in sorted(boundaries.items()):live+=delta;peak=max(peak,live);require(0<=live<=m['capacity_bytes'],'memory capacity exceeded')
        peaks[memory]=peak
    schedule=graph['schedule'];require(schedule['policy']=='serial-event-order' and len(schedule['events'])==count,'schedule coverage differs')
    for i,item in enumerate(schedule['events']):
        require(item['event']==i and item['predecessors']==sorted(set(events[i]['depends_on']+([i-1] if i else []))),'schedule dependency/resource serialization differs')
        if item['start_ms'] is not None or item['end_ms'] is not None:require(item['start_ms'] is not None and item['end_ms'] is not None and 0<=item['start_ms']<=item['end_ms'],'invalid finite event times')
    submissions=0;covered=set()
    for region in graph['execution_regions']:
        lo,hi=region['begin_event'],region['end_event'];require(0<=lo<hi<=count and not covered.intersection(range(lo,hi)),'execution region overlap/coverage');covered.update(range(lo,hi));submission=region['submission_event'];submissions+=submission['count']
        consumed={p for e in events[lo:hi] for p in e['depends_on'] if p>=lo}
        require(region['completion_event']['after']==[i for i in range(lo,hi) if i not in consumed],'completion does not cover actual terminal events')
        require(region['input_data_edges']==[i for i,x in enumerate(c['data_edges']) if x['producer']<0 and lo<=x['consumer']<hi],'region input edge boundary differs')
        require(submission['shared_by_region_inputs'] and submission['id']==region['id']+'.submit' and region['completion_event']['id']==region['id']+'.complete','per-input launch or wrong boundary identity')
    require(len(covered)==count and submissions==graph['cost']['submission_count'],'whole program boundary/submit count differs')
    require(graph['cost']['complete_graph_ms']==schedule['estimated_makespan_ms'],'cost/schedule boundary differs')
    if schedule['estimated_makespan_ms'] is None:require(schedule['uncalibrated'],'unknown cost silently loses provenance')
    if case=='fanout':require(len(tasks)==3 and len(c['data_edges'])==3 and len(c['order_edges'])==1 and submissions==0,'fanout data/order/host boundary facts differ')
    if case=='gemm-scale':require(submissions==1,'GEMMscale inputs must share exactly one submission')
    return dict(status='passed',graph_id=graph['id'],source_body_fingerprint=source['body_fingerprint'],tasks=len(tasks),instances=len(instances),events=count,versions=len(versions),copies=len(copies),data_edges=len(c['data_edges']),order_edges=len(c['order_edges']),planned_transfer_bytes=traffic,peak_memory_bytes=peaks,submission_count=submissions,complete_graph_ms=schedule['estimated_makespan_ms'],scope='Independent native-table/identity/accounting checks; source SSA semantics remain C++ analysis/checker responsibility; no measured traffic or device timing inferred')


def negative_tests(graph,case):
    """Mutate actual exported facts in memory; never emit executable plans."""
    import copy
    checks=[]
    def rejected(name,mutate):
        value=copy.deepcopy(graph);mutate(value)
        # Rebind the public JSON hash, so failures exercise invariants rather
        # than only the outer SHA gate. The compiler never consumes these mocks.
        value['id']=hashlib.sha256(native_json({k:v for k,v in value.items() if k not in ['id','cost']}).encode()).hexdigest()
        try:validate(value,case)
        except (ValueError,IndexError,KeyError):checks.append(name);return
        raise ValueError('independent audit accepted mutation: '+name)
    rejected('invalid logical version producer',lambda g:g['ledger']['versions'][0].update(producer=len(g['ledger']['events'])))
    rejected('invalid instance source loop bound',lambda g:g['instances'][0]['domain'][0].update(upper=2**62))
    rejected('transfer rectangle byte mismatch',lambda g:g['communications'][0].update(bytes=g['communications'][0]['bytes']+4))
    rejected('schedule predecessor omission',lambda g:g['schedule']['events'][-1].update(predecessors=[]))
    rejected('copy released before final consumer',lambda g:next(x for x in g['ledger']['copies'] if x['users']).update(released_after=0))
    if graph['ledger']['order_edges']:
        def missing_order(g):
            c=g['ledger'];c['order_edges']=[];c['order_edge_count']=0
            for e in c['events']:e['order_edges']=[]
        rejected('coherent pure-order table/incidence deletion',missing_order)
    return checks


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--graph',type=Path,required=True);p.add_argument('--plan',type=Path);p.add_argument('--fixture',type=Path);p.add_argument('--air',type=Path);p.add_argument('--case',choices=['fanout','gemm-scale']);p.add_argument('--output',type=Path,required=True);p.add_argument('--negative-tests',action='store_true');a=p.parse_args()
    require(not a.output.exists(),'output must be new');graph=load(a.graph);result=validate(graph,a.case,load(a.plan) if a.plan else None)
    if a.negative_tests:result['negative_checks']=negative_tests(graph,a.case)
    artifacts=[a.graph,a.plan,Path(__file__)]
    if a.fixture:
        f=load(a.fixture/'fixture.json');require(sha(a.fixture/'source.mlir')==f['source_sha256'],'prepared source SHA differs')
        for name,digest in f['files'].items():require(sha(a.fixture/name)==digest,'prepared source/input/reference changed: '+name)
        expected=f['expected_source_facts'];stored={x['id']:x for x in graph['source']['storages']}
        if f['case']=='fanout':require(stored['A']['shape']==[expected['X_bytes']//4] and stored['B']['role']==stored['C']['role']=='output','fanout fixture/graph ABI differs')
        else:require(stored['A']['shape']==[expected['M'],expected['K']] and stored['B']['shape']==[expected['K'],expected['N']] and stored['Y']['shape']==[expected['M'],expected['N']],'GEMMscale fixture/graph ABI differs')
        artifacts.extend([a.fixture/'fixture.json',a.fixture/'source.mlir']);result['prepared_reference_scope']='Prepared source/seed-array SHA and ABI shape/role checks; actual source SSA/dependency analysis is independently checked by native C++'
    if a.air:
        import re
        text=a.air.read_text();ids=set(re.findall(r'orbit\.program_graph\s*=\s*"([^"]+)"',text));require(ids=={graph['id']},'AIR graph identity differs')
        ledger=graph['ledger'];event_ids=[int(x) for x in re.findall(r'orbit\.transfer_event\s*=\s*(\d+)\s*:',text)]
        for event in event_ids:require(index(event,ledger['events'],'AIR transfer event')['kind']=='transfer','AIR transfer ID is not a copy event')
        computations=[int(x) for x in re.findall(r'orbit\.computation_event\s*=\s*(\d+)\s*:',text)]
        for event in computations:require(index(event,ledger['events'],'AIR computation event')['kind']!='transfer','AIR computation ID is a transfer')
        instances=[int(x) for x in re.findall(r'orbit\.source_instance\s*=\s*(\d+)\s*:',text)]
        for instance in instances:index(instance,graph['instances'],'AIR source instance')
        require(event_ids and computations and instances,'AIR lacks common transfer/compute/source-instance witnesses')
        artifacts.append(a.air);result['AIR_ids']=dict(transfer_templates=len(event_ids),compute_templates=len(computations),source_instance_templates=len(instances),scope='Actual canonical AIR ID references checked; compact template annotations do not enumerate every dynamic phase. Native --check-air proves complete template/plan correspondence; no runtime trace implied.')
    result['artifacts']={str(path.resolve()):sha(path) for path in artifacts if path};a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))



if __name__=='__main__':main()
