#!/usr/bin/env python3
"""Static measured scaling plots; no extrapolated solver-time claims."""
import argparse,json
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
p=argparse.ArgumentParser();p.add_argument('--scaling',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();rows=json.loads(a.scaling.read_text());x=[r['tasks'] for r in rows]
plt.rcParams.update({'font.size':10,'svg.fonttype':'none'})
fig,axes=plt.subplots(1,2,figsize=(11,4.3),constrained_layout=True)
for key,label,marker in [('process_ms','whole process','o'),('model_build_ms','model + validation prefix','s'),('solve_ms','CP-SAT solve','^')]:axes[0].plot(x,[r[key] if r[key]>0 else float('nan') for r in rows],marker=marker,label=label)
axes[0].axhline(1000,color='gray',ls='--',lw=1,label='1 s soft search budget');axes[0].set(xscale='log',yscale='log',xlabel='source tasks (one partition variant, 2 cores)',ylabel='elapsed milliseconds',title='Measured CPU time; baseline retained on limits')
axes[0].set_ylim(.7,5000)
for r in rows:axes[0].annotate(r['status'],(r['tasks'],r['process_ms']),xytext=(0,7),textcoords='offset points',ha='right' if r is rows[-1] else 'center',fontsize=7,rotation=10)
axes[0].annotate('solve not invoked',(128,2),ha='right',fontsize=8,color='tab:green')
for key,label in [('variables','variables'),('constraints','constraints')]:axes[1].plot(x,[r[key] for r in rows],marker='o',label=label)
axes[1].axhline(100000,color='gray',ls='--',lw=1,label='variable guard');axes[1].set(xscale='log',yscale='log',xlabel='source tasks',ylabel='constructed model entries',title='128 tasks stopped during construction')
for ax in axes:ax.set_xticks(x,[str(t) for t in x]);ax.grid(alpha=.25);ax.legend(fontsize=8)
fig.suptitle('Public ProgramGraph joint CP-SAT v23 — explicit assumed costs, finite group size ≤ 4')
for suffix in ['png','svg']:fig.savefig(str(a.output)+'.'+suffix,dpi=180)
