#!/usr/bin/env python3
"""Independently audit small exported add-scale ProgramGraphs and mapper receipts.

This is finite evidence validation, not planning, scoring, or hardware execution.
The root is an existing v12 compiler output containing summary.json and search/.
"""
import argparse
import collections
import hashlib
import itertools
import json
import math
import pathlib

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--root', required=True, type=pathlib.Path,
                    help='existing v12 compiler-output directory')
parser.add_argument('--output', required=True, type=pathlib.Path,
                    help='new audit evidence directory (must not exist)')
args = parser.parse_args()
root = args.root.resolve()
out = args.output.resolve()
if not (root / 'summary.json').is_file():
 parser.error('--root must contain compiler summary.json')
out.mkdir(parents=True, exist_ok=False)
summary=json.loads((root/'summary.json').read_text())
rows=[];checks=0

def check(value,label):
 global checks
 if not value: raise AssertionError(label)
 checks+=1

def points(region):
 return set(itertools.product(*(range(o,o+s) for o,s in zip(region['offsets'],region['sizes']))))

for candidate in summary['candidates']:
 path=root/'search/candidates'/candidate['candidate_id']/'program-graph.json'
 g=json.loads(path.read_text());l=g['ledger'];source=g['source'];regions=l['logical_regions'];events=l['events'];copies=l['copies'];versions=l['versions'];alloc=l['allocations']
 storages=source['storages'];byname={s['id']:i for i,s in enumerate(storages)}
 for storage,s in enumerate(storages):
  seen=set()
  for region in regions:
   if region['storage']!=storage:continue
   coordinates=points(region)
   check(not seen&coordinates,'nonoverlap cells')
   seen|=coordinates
  check(seen==set(itertools.product(*(range(n) for n in s['shape']))),'complete logical storage partition')
 for copy in copies:
  check(copy['version']<len(versions) and copy['allocation']<len(alloc),'copy references')
  check(all(copy['available_from']<=u<copy['released_after'] for u in copy['users']),'copy valid event interval')
 for edge in l['data_edges']:
  copy=copies[edge['copy']];v=versions[edge['version']]
  check(copy['version']==edge['version'] and v['region']==edge['region'] and v['producer']==edge['producer'],'data version/copy/region binding')
  check(edge['copy'] in events[edge['consumer']]['reads'],'data consumption incidence')
  check(edge['required_memory']==alloc[copy['allocation']]['memory'],'data memory requirement')
 task_events={e['task']:i for i,e in enumerate(events) if e['kind']=='compute'}
 for t,task in enumerate(source['tasks']):
  event=events[task_events[t]]
  for kind,field in [('read','reads'),('write','writes')]:
   expected=collections.defaultdict(set);actual=collections.defaultdict(set)
   for access in task['accesses']:
    if access[kind]:
     expected[byname[access['storage']]] |= set(itertools.product(*(range(a,b) for a,b in access['region'])))
   for c in event[field]:
    region=regions[versions[copies[c]['version']]['region']]
    actual[region['storage']] |= points(region)
   check(dict(expected)==dict(actual),'compute exact source access coverage')
 for i,event in enumerate(events):
  for copyid in event['reads']:
   creator=copies[copyid]['created_by']
   check(creator<0 or creator in event['depends_on'],'copy creator dependency')
  check(all(p<i for p in event['depends_on']),'acyclic backward dependencies')
 network=[];external=[];transport_pairs=set()
 for communication in g['communications']:
  region={'storage':communication['storage'],'offsets':communication['offsets'],'sizes':communication['sizes']}
  check(communication['bytes']==4*len(points(region)),'exact f32 cell transfer bytes')
  event=events[communication['event']]
  src=copies[event['reads'][0]];dst=copies[event['writes'][0]]
  check(src['version']==dst['version'],'transfer preserves version')
  check(regions[versions[src['version']]['region']]==region,'transfer exact version cell')
  if communication['resource']=='intertask.network':
   network.append(communication);producer=versions[src['version']]['producer']
   check(producer>=0 and events[producer]['kind']=='compute','network transfer source is computed data')
   transport_pairs.add((producer,task_events[event['task']]))
  else:
   external.append(communication)
   check(communication['resource']=='external.supply' and
         'external.memory' in [alloc[src['allocation']]['memory'],alloc[dst['allocation']]['memory']],'external supply boundary')
 for order in l['order_edges']:
  check((order['producer'],order['consumer']) not in transport_pairs,'pure order does not create transport')
  check(order['producer'] in events[order['consumer']]['depends_on'],'explicit pure order dependency')
 for memory in l['memory_architecture']['memories']:
  check(memory['capacity_bytes'] is None and memory['capacity_known'] is False,'unknown capacity explicit')
 for accounting in g['cost']['allocation_accounting']:
  check(accounting['capacity_bytes'] is None and accounting['capacity_verified'] is False,'capacity unverified in cost')
 check(g['schedule']['policy']=='dependency-order-witness' and g['schedule']['estimated_makespan_ms'] is None,'witness not millisecond estimate')
 check(all(e['start_ms'] is None and e['end_ms'] is None for e in g['schedule']['events']),'unknown event timing')
 for storage,s in enumerate(storages):
  if s['role']!='output':continue
  for cell,region in enumerate(regions):
   if region['storage']!=storage:continue
   latest=max((i for i,v in enumerate(versions) if v['region']==cell),default=-1)
   check(any(c['version']==latest and alloc[c['allocation']]['memory']=='external.memory' and c['released_after']==len(events) for c in copies),'final output cell external availability')
 check(sum(c['bytes'] for c in network)==64 and sum(c['bytes'] for c in external)==192 and l['transfer_bytes']==256,'once-counted internal and external traffic')
 # "actual" here means the mapped II was used in the production scheduler;
 # it is explicitly not a simulator/device execution measurement.
 receipt_path=root/'search/candidates'/candidate['candidate_id']/'evaluation/backend-receipt.json'
 receipt=json.loads(receipt_path.read_text())
 receipt_sha=hashlib.sha256(receipt_path.read_bytes()).hexdigest()
 declared=candidate['backend'].get('files',{}).get(str(receipt_path))
 check(declared is None or declared==receipt_sha,'saved raw receipt hash')
 check(receipt['graph_id']==g['id'],'raw receipt graph identity')
 check('not execution timing' in receipt['actual_schedule_scope'],'mapped-II schedule is not execution timing')
 facts=receipt['actual_duration_facts']
 check(len(facts)==len(source['tasks']),'one compiled-II duration per actual task')
 ii={row['task']:row['compiled_ii'] for row in receipt['actual_ii']}
 duration_by_task={}
 for fact in facts:
  check(fact['task'] not in duration_by_task,'unique actual task duration')
  check(fact['compiled_ii']>0 and fact['trip_count']>0 and math.isfinite(fact['startup_cycles']),'valid actual duration inputs')
  duration=math.ceil(fact['startup_cycles']+fact['compiled_ii']*(fact['trip_count']-1))
  check(fact['duration_cycles']==max(1,duration) and fact['compiled_ii']==ii[fact['task']],'actual task duration ceil and compiled II')
  duration_by_task[fact['task']]=fact['duration_cycles']
 actual_schedule=receipt['actual_task_schedule']
 check(len(actual_schedule)==len(duration_by_task),'actual schedule task coverage')
 for placement in actual_schedule:
  check(placement['end_cycle']-placement['start_cycle']==duration_by_task[placement['task']],'scheduler consumes actual compiled-II duration')
 check(receipt['actual_makespan_cycles']==max(p['end_cycle'] for p in actual_schedule),'actual-duration scheduler makespan')
 differential=receipt['actual_legacy_differential']
 check(isinstance(differential['requested'],bool) and differential['status'] in {'not_requested','identical','different'},'actual legacy differential fields')
 if differential['requested']:
  check('makespan_cycles' in differential and 'task_schedule' in differential and 'public_task_schedule' in differential and 'scope' in differential,'requested actual legacy differential evidence')
 shapes=collections.Counter(tuple(i['resource_shape']) for i in g['instances'])
 rows.append({'candidate_id':candidate['candidate_id'],'actions':candidate['action_chain'],'graph_id':g['id'],'graph_sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'source_tasks':len(source['tasks']),'regions':len(regions),'versions':len(versions),'copies':len(copies),'allocations':len(alloc),'data_edges':len(l['data_edges']),'order_edges':len(l['order_edges']),'internal_transfers':len(network),'internal_bytes':sum(c['bytes'] for c in network),'external_transfers':len(external),'external_bytes':sum(c['bytes'] for c in external),'shapes':[{ 'rows':s[0],'columns':s[1],'task_count':n} for s,n in shapes.items()],'predicted_backend_cycles':candidate['backend']['predicted_makespan_cycles'],'public_ms':g['schedule']['estimated_makespan_ms'],'mapped_ii_schedule_cycles':receipt['actual_makespan_cycles'],'actual_schedule_scope':receipt['actual_schedule_scope'],'receipt_sha256':receipt_sha,'actual_legacy_differential_status':differential['status']})
(out/'audit.json').write_text(json.dumps({'status':'passed','checks':checks,'scope':'independent enumeration of exported small finite graph facts; no compiler rebuild or execution','compiler_output':str(root),'input_summary_sha256':hashlib.sha256((root/'summary.json').read_bytes()).hexdigest(),'auditor_sha256':hashlib.sha256(pathlib.Path(__file__).read_bytes()).hexdigest(),'candidates':rows},indent=2)+'\n')
print(json.dumps({'status':'passed','checks':checks,'candidate_count':len(rows)}))
