#!/usr/bin/env python3
"""Publication-independent static figure from the preserved JSON measurements."""
import argparse
import json
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

p=argparse.ArgumentParser();p.add_argument('--evidence',type=Path,required=True);a=p.parse_args()
summary=json.loads((a.evidence/'summary.json').read_text())
rows=[json.loads(l) for l in (a.evidence/'cpu/cover.jsonl').read_text().splitlines()]
fig,(left,right)=plt.subplots(1,2,figsize=(11,4.2),layout='constrained')
for tiles in (1,4,8):
    rs=[r for r in rows if r['tiles']==tiles and r['budget_seconds']==1]
    xs=[r['n'] for r in rs];ys=[r['total_ms'] for r in rs]
    line,=left.plot(xs,ys,marker='o',label=f'{tiles} tile(s)')
    for r in rs:
        left.annotate({'OPTIMAL':'O','FEASIBLE':'F','UNKNOWN':'U','EXTERNAL_TIMEOUT':'T'}[r['solver_status']],
            (r['n'],r['total_ms']),xytext=(0,7),textcoords='offset points',ha='center',fontsize=8,color=line.get_color())
left.axhline(1000,color='gray',linestyle='--',linewidth=1,label='1 s external budget')
left.set(xscale='log',yscale='log',xlabel='Tasks (synthetic window-cover problem)',ylabel='Total measured time (ms)',title='Bounded solver campaign')
left.set_xticks([8,16,32,64,128,256],labels=['8','16','32','64','128','256']);left.legend(fontsize=8)
left.text(.02,.02,'O=optimal  F=feasible  U=unknown  T=external timeout',transform=left.transAxes,fontsize=7)
rs=summary['native'];x=np.arange(len(rs));bottom=np.zeros(len(rs))
for field,label in [('generation_ms','Discovery'),('pricing_ms','Full-plan pricing'),('model_build_ms','CP-SAT model'),('solve_ms','CP-SAT solve'),('recheck_ms','Final recheck')]:
    y=np.array([r[field]/1000 for r in rs]);right.bar(x,y,bottom=bottom,label=label);bottom+=y
other=np.maximum(0,np.array([r['process_ms']/1000 for r in rs])-bottom)
right.bar(x,other,bottom=bottom,label='CLI / driver / evaluation')
for i,r in enumerate(rs):right.text(i,r['process_ms']/1000+.05,f"{r['solve_ms']:.1f} ms",ha='center',fontsize=8)
right.axhline(5,color='gray',linestyle='--',linewidth=1)
right.set(xticks=x,xticklabels=[str(r['tasks'])+('†' if r['domain_truncated'] else '') for r in rs],
    xlabel='Native chain tasks († incomplete local domain)',ylabel='Full process time (s)',title='Native pipeline: labels show solve time',ylim=(0,5.7))
right.legend(fontsize=7,ncol=2,loc='upper left')
fig.suptitle('ORBIT CP-SAT v22: bounded samples, no asymptotic runtime claim',fontsize=12)
fig.savefig(a.evidence/'scaling.svg');fig.savefig(a.evidence/'scaling.png',dpi=160);plt.close(fig)
