#!/usr/bin/env python3
"""Export existing public plans and model schedules; never infer device timing."""
import argparse,csv,json
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import Patch

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--index',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False);idx=json.loads(a.index.read_text());selected=[c for c in idx['cases'] if c['id'] in ['baseline','mixed_boundary','two_groups','tiling_composed']];fig,axes=plt.subplots(len(selected),1,figsize=(13,8),sharex=True)
 colors={'compute':'#1f77b4','transfer':'#ff7f0e','configure':'#9467bd','host':'#7f7f7f'}
 for ax,c in zip(axes,selected):
  plan=json.loads((Path(c['compiled'])/'plan.json').read_text());g=plan['program_graph'];timing=plan['direct_air_cost']['event_timing']['timing'];critical=set(timing['critical_path']);rows=[]
  for activity in timing['activities']:
   ident=activity['id'];event=g['ledger']['events'][activity['events'][0]] if activity['events'] else None
   kind=event['kind'] if event else ('configure' if ident.startswith('group.configure.') else 'host');kind='compute' if kind=='initialize' else kind
   lane={'compute':2,'transfer':1,'configure':3,'host':0}[kind];start=activity['start_ms'];duration=activity['duration_ms']
   if start is not None and duration is not None:ax.barh(lane,duration,left=start,height=.65,color=colors[kind],edgecolor='black' if ident in critical else 'white',linewidth=.6)
   rows.append(activity)
  ax.set_yticks([0,1,2,3],['host','DMA','core','config']);ax.set_title(f"{c['id']}: {len(plan['execution_groups'])} configurations, {plan['actual_dma_bytes']} requested B, {plan['resident_bytes']} local payload B",fontsize=10,loc='left');ax.grid(axis='x',alpha=.2)
  (a.output/(c['id']+'-schedule.json')).write_text(json.dumps(timing,indent=2)+'\n')
  fields=['copy','allocation','memory','storage','version','region','producer_event','readers','available_ordinal','released_ordinal']
  with (a.output/(c['id']+'-copies.csv')).open('w') as f:
   writer=csv.DictWriter(f,fields);writer.writeheader()
   for ci,copy in enumerate(g['ledger']['copies']):
    alloc=g['ledger']['allocations'][copy['allocation']];version=g['ledger']['versions'][copy['version']]
    writer.writerow(dict(copy=ci,allocation=copy['allocation'],memory=alloc['memory'],storage=alloc['storage'],version=copy['version'],region=version.get('region'),producer_event=copy['created_by'],readers=copy['users'],available_ordinal=copy['available_from'],released_ordinal=copy['released_after']))
 axes[-1].set_xlabel('Estimated elapsed ms (assumed model; not device timestamps)');fig.suptitle('Existing ProgramTiming resource schedules; black borders mark predicted critical path',fontsize=12);fig.tight_layout();fig.savefig(a.output/'assumed-schedules.svg');fig.savefig(a.output/'assumed-schedules.png',dpi=170);plt.close(fig)
 plan=json.loads((Path(selected[2]['compiled'])/'plan.json').read_text());g=plan['program_graph'];dot=['digraph semantic {','rankdir=LR;']
 for task in plan['tasks']:dot.append(f't{task["index"]} [label="Task {task["index"]}: {task["task"]}"];')
 for edge in g['source_dependencies']:dot.append(f't{edge["producer_task"]} -> t{edge["consumer_task"]} [label="{",".join(edge["kinds"])}"];')
 dot+=['}'];(a.output/'semantic.dot').write_text('\n'.join(dot)+'\n');(a.output/'README.md').write_text('Schedules are produced by the frozen assumption model, not measured device timelines. Copy CSVs record half-open ordinal validity witnesses; these are not completion timestamps. Actual overwrite readiness uses creators and all users, with explicit implementation dependencies. The full source/graph/native plans live in the compiled index.\n')
 print(json.dumps(dict(status='exported',output=str(a.output),hardware_executed=False)))
if __name__=='__main__':main()
