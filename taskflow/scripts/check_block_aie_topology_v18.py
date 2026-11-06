#!/usr/bin/env python3
"""Independent bidirectional causality proof for current computed pointwise diamond.

Supports one-core closed three-task blocks and materialized one-task groups.
Actual group ordering comes from final configure/run/output-await evidence, never
from public dependencies. Not a scheduler, cost model, counter or device probe.
"""
import argparse,json,re
from pathlib import Path
from audit_program_implementation_v16 import identity,regions


def closure(parents):
 result=[set(x) for x in parents];n=len(result)
 for _ in range(n):
  changed=False
  for i in range(n):
   assert all(0<=p<n for p in result[i])
   grow=set().union(*(result[p] for p in list(result[i]))) if result[i] else set()
   if not grow<=result[i]:result[i]|=grow;changed=True
  if not changed:break
 assert all(i not in result[i] for i in range(n)), 'causal cycle'
 return result


def check(compiled,plan_view=None):
 plan_path=plan_view or compiled/'plan.json';plan=json.loads(plan_path.read_text());g=plan['program_graph'];c=plan['program_communication'];events=c['events'];n=len(events)
 assert plan['strategy']=='serial-tiled'
 retained=plan['program_mapping_choices'].get('task_group',[])==[0,1,2]
 assert not retained or plan['program_mapping_choices']['retained_storages']==[3]
 abi=json.loads((compiled/'abi.json').read_text());assert [x['name'] for x in abi['buffers']]==(['A','B','C'] if retained else ['A','B','C','X'])
 aiep=compiled/'hardware/air_project/npu.input.air.mlir';aie=aiep.read_text();physical={};wrapper=[]
 for dev,body,_ in regions(aie,r'aie\.device\([^)]*\)(?:\s+@([\w.$]+))?\s*\{'):
  cores=list(regions(body,r'%[\w.$]+ = aie\.core\((%[\w.$]+)\)\s*\{'))
  if not cores:
   for _,sequence,_ in regions(body,r'aie.runtime_sequence @[\w.$]+\([^\n]*\)\s*\{'):
    for configure,part,_ in regions(sequence,r'aiex.configure @([\w.$]+)\s*\{'):
     calls=re.findall(r'aiex.run @([\w.$]+)',part);assert len(calls)==1;wrapper.append((configure[1],calls[0]))
   continue
  assert len(cores)==1 and len(re.findall(r'aie.tile\(0, 2\)',body))==1 and dev[1]
  _,core,_=cores[0];adds=[m.start() for m in re.finditer(r'\barith.addf\b',core)];assert len(adds)==(3 if retained else 1)
  views={view:storage for view,storage in re.findall(r'(%[\w.$]+) = memref.reinterpret_cast [^\n]+orbit.storage = "([ABCX])"',core)}
  buffers={storage:buffer for buffer,storage in re.findall(r'memref.reinterpret_cast (%[\w.$]+)[^\n]+orbit.storage = "([ABCX])"',core)}
  loads=[views[x] for x in re.findall(r'memref.load (%[\w.$]+)',core)];stores=[views[x] for x in re.findall(r'memref.store [^,]+, (%[\w.$]+)',core)]
  if retained:assert loads==['A','X','X'] and stores==['X','B','C'] and len(set(buffers.values()))==4
  else:assert len(loads)==len(stores)==1 and (loads[0],stores[0]) in [('A','X'),('X','B'),('X','C')]
  roles={}
  for m in re.finditer(r'aie.dma_start\((MM2S|S2MM),\s*\d+,\s*\^([\w]+)',body):
   block=re.search(r'\^'+m[2]+r':[^\n]*\n(.*?)(?=\n\s*\^|\Z)',body[m.end():],re.S)
   if not block:continue
   bd=re.findall(r'aie.dma_bd\((%[\w.$]+)',block[1]);locks=re.findall(r'aie.use_lock\((%[\w.$]+), (AcquireGreaterEqual|Release)',block[1]);assert len(bd)==1 and len(locks)==2
   storage=next(s for s,b in buffers.items() if b==bd[0]);direction='input' if storage==loads[0] and (not retained or storage=='A') else 'output'
   assert m[1]==('S2MM' if direction=='input' else 'MM2S')
   # DMA takes free input / ready output and publishes ready input / free output.
   acquire=locks[1][0];release=locks[0][0]
   take=[m.start() for m in re.finditer(r'aie.use_lock\('+re.escape(acquire)+r', AcquireGreaterEqual',core)];give=[m.start() for m in re.finditer(r'aie.use_lock\('+re.escape(release)+r', Release',core)]
   assert len(take)==len(give)==1 and take[0]<min(adds) and give[0]>max(adds)
   roles[storage]=dict(buffer=bd[0],direction=direction,core_acquire=acquire,core_release=release)
  assert set(roles)==({'A','B','C'} if retained else {loads[0],stores[0]})
  seqs=list(regions(body,r'aie.runtime_sequence @([\w.$]+)\([^\n]*\)\s*\{'));assert len(seqs)==1;seq=seqs[0][1]
  lengths=[int(x) for x in re.findall(r'aie.dma_bd\(%arg\d+[^\n]* len = (\d+)',seq)]
  assert lengths==[8192]*(3 if retained else 2), 'unsupported: proof currently covers complete E8192 runtime streams'
  output_count=2 if retained else 1
  assert seq.count('aiex.dma_start_task')==len(lengths) and seq.count('aiex.dma_await_task')==output_count
  # All starts precede the child output await; no per-block host sequencing.
  assert seq.rfind('aiex.dma_start_task')<seq.find('aiex.dma_await_task')
  phases=[int(x) for x in re.findall(r'orbit.phase = (\d+)',core)];assert phases
  physical[dev[1]]=dict(symbol=dev[1],sequence=seqs[0][0][1],begin_phase=min(phases),lock_roles=roles,loads=loads,stores=stores,whole_runtime_BD_elements=lengths,output_awaits=output_count)
 assert len(wrapper)==len(physical)==len(g['execution_groups'])==len(plan['hardware_stages'])
 assert {x[0] for x in wrapper}==set(physical)
 ordered=[]
 for symbol,sequence in wrapper:
  record=physical[symbol];assert record['sequence']==sequence;ordered.append(record)
 actual=[set() for _ in events];common=[set(e['depends_on']) for e in events]
 def edge(parent,child):actual[child].add(parent)
 group_receipts=[];all_blocks=[];seen=set();previous_terminal=None
 for position,record in enumerate(ordered):
  matches=[(i,x) for i,x in enumerate(g['execution_groups']) if x['begin_phase']==record['begin_phase']];assert len(matches)==1
  gi,group=matches[0];assert gi not in seen;seen.add(gi)
  assert group['spatial_owner']=='npu.tile(0,2)' and group['memory']=='aie_l1' and group['resource']=='npu.compute'
  members={i for i,e in enumerate(events) if group['begin_phase']<=e['phase']<group['end_phase']};assert members==set(group['member_events'])
  width=3 if retained else 1;assert (group['end_phase']-group['begin_phase'])%width==0
  blocks=[]
  for begin in range(group['begin_phase'],group['end_phase'],width):
   cs=[i for i in members if events[i]['kind']=='compute' and begin<=events[i]['phase']<begin+width];ins=[i for i in members if events[i]['kind']=='transfer' and begin<=events[i]['phase']<begin+width and events[i]['link']=='host_to_l1'];outs=[i for i in members if events[i]['kind']=='transfer' and begin<=events[i]['phase']<begin+width and events[i]['link']=='l1_to_host'];assert len(cs)==width and len(ins)==1 and len(outs)==(2 if retained else 1)
   if retained:
    bytask={events[i]['task']:i for i in cs};out={events[i]['task']:i for i in outs};assert set(bytask)=={0,1,2} and set(out)=={1,2}
    ain,p,b,z=ins[0],bytask[0],bytask[1],bytask[2];edge(ain,p);edge(p,b);edge(b,z);edge(z,out[1]);edge(z,out[2]);block=dict(Ain=ain,P=p,B=b,C=z,Bout=out[1],Cout=out[2],terminal=[out[1],out[2]])
    if blocks:
     prev=blocks[-1];edge(prev['C'],ain);edge(prev['Bout'],p);edge(prev['Cout'],p);edge(prev['P'],ain);edge(prev['B'],p);edge(prev['C'],p);edge(prev['Bout'],b);edge(prev['Cout'],z)
   else:
    ain,compute,out=ins[0],cs[0],outs[0];edge(ain,compute);edge(compute,out);block=dict(Ain=ain,compute=compute,out=out,terminal=[out])
    if blocks:edge(blocks[-1]['compute'],ain);edge(blocks[-1]['out'],compute)
   blocks.append(block);all_blocks.append(block)
  assert {i for b in blocks for k,v in b.items() if k!='terminal' for i in [v]}==members
  # This barrier is established by actual wrapper configure/run order and the
  # preceding child's complete whole-stream output await, independently of g.
  if previous_terminal:
   for parent in previous_terminal:edge(parent,blocks[0]['Ain'])
  previous_terminal=blocks[-1]['terminal']
  for dependency in group['dependencies']:
   assert dependency<gi
   for child in members:common[child].update(g['execution_groups'][dependency]['member_events'])
  group_receipts.append(dict(public_group=gi,actual_wrapper_position=position,symbol=record['symbol'],members=len(members),declared_group_dependencies=group['dependencies'],actual_whole_output_await_before_next_config=True))
 assert seen==set(range(len(g['execution_groups'])))
 ancestors=closure(actual);declared=closure(common);violations=[];missing=[]
 for child,parents in enumerate(common):
  for parent in parents:
   if parent not in ancestors[child]:violations.append(dict(parent=parent,child=child,parent_kind=events[parent]['kind'],child_kind=events[child]['kind']))
 for child,parents in enumerate(actual):
  for parent in parents:
   if parent not in declared[child]:missing.append(dict(parent=parent,child=child,reason='physical readiness/release/reuse or actual configure boundary missing from public closure'))
 assert all(x.get('spatial_owner')=='npu.tile(0,2)' and x['addressing']=='reusable-slot' for x in g['allocation_bindings'] if x.get('spatial_owner'))
 return dict(status='passed' if not violations and not missing else 'failed',scope='Current computed E8192 pointwise diamond only: one core per actual configuration; closed three-task retained blocks or materialized one-task stages; complete fixed runtime streams. Static causality, not timing.',compiled=str(compiled),plan=identity(plan_path),compiled_plan=identity(compiled/'plan.json'),mutated_view=plan_view is not None,graph_id=g['id'],aie=identity(aiep),observer=identity(__file__),blocks=len(all_blocks),groups=group_receipts,actual_configuration_order=[x[0] for x in wrapper],physical_evidence=ordered,dependency_edges_checked=sum(map(len,common)),physical_required_edges_checked=sum(map(len,actual)),violations=violations,missing_required_edges=missing,legacy_schedule_policy=g['schedule']['policy'],schedule_scope='Legacy serialized schedule is a conservative timing reservation witness, not runtime arbitration. Typed event and declared execution-group dependencies are causal requirements.',device_submissions=0,resource_boundary='Physical single compute core and individual DMA channel lock roles are inspected. No DMA duration/shared-bandwidth capacity inferred. Group causality independently follows actual wrapper configure/run and full output awaits. Host polling visibility is outside this proof.')


def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--compiled',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--plan-view',type=Path);a=p.parse_args();assert not a.output.exists();r=check(a.compiled,a.plan_view);a.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(dict(status=r['status'],edges=r['dependency_edges_checked'],violations=len(r['violations']),missing_required=len(r['missing_required_edges']))));raise SystemExit(r['status']!='passed')

if __name__=='__main__':main()
