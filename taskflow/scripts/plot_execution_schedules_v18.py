#!/usr/bin/env python3
"""Render saved C++ synthetic schedules; no planning or timing formula."""
import argparse,json
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
p=argparse.ArgumentParser();p.add_argument('--evidence',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
data=json.loads(a.evidence.read_text());fig,axes=plt.subplots(4,1,figsize=(11,9),layout='constrained')
for ax,key,title in zip(axes,['long_first_timing','short_first_timing','one_slot_timing','two_slot_timing'],['Two compute resources, long branch first','Same graph, short branch first','One reusable buffer slot','Two buffer slots']):
 activities=data[key]['activities'];resources=sorted({r for x in activities for r in x['resource_demands']});colors={'dma':'#e69f00','compute0':'#0072b2','compute1':'#009e73'}
 for x in activities:
  if x['start_ms'] is None or x['end_ms'] is None:continue
  for r in x['resource_demands']:
   row=resources.index(r);ax.barh(row,x['end_ms']-x['start_ms'],left=x['start_ms'],height=.62,color=colors.get(r,'#0072b2'),edgecolor='white');ax.text((x['start_ms']+x['end_ms'])/2,row,x['id'],ha='center',va='center',fontsize=8,color='white')
 end=max(x['end_ms'] for x in activities);ax.set_yticks(range(len(resources)),resources);ax.set_xlim(0,17);ax.set_xticks(range(0,18,2));ax.grid(axis='x',alpha=.2);ax.set_axisbelow(True);ax.set_title(f'{title}: {end:g} ms',loc='left',fontsize=11);ax.set_xlabel('Synthetic target time (ms), not NPU observations')
fig.savefig(a.output/'resource-schedules.png',dpi=160);fig.savefig(a.output/'resource-schedules.svg');(a.output/'source.json').write_text(json.dumps({'input':str(a.evidence.resolve()),'scope':'Exact saved C++ scheduling activities, synthetic assumed target only'},indent=2)+'\n')
