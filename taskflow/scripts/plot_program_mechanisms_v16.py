#!/usr/bin/env python3
"""Static exported evidence figures; never generates a plan or model."""
import argparse,json,pathlib,statistics
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

def main():
 p=argparse.ArgumentParser();p.add_argument('--root',type=pathlib.Path,required=True);p.add_argument('--output',type=pathlib.Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
 read=lambda p:json.loads(pathlib.Path(p).read_text())
 predictions={r['case']:r for r in read(a.root/'frozen-predictions-r1/predictions.json')['rows']}
 sessions={name:[json.loads(l) for l in (a.root/name/'samples.jsonl').read_text().splitlines()] for name in ['holdout-r1','same-model-cross-session-r1']}
 fig,axes=plt.subplots(1,2,figsize=(11,4),layout='constrained')
 for ax,(session,samples) in zip(axes,sessions.items()):
  for case in sorted({s['case'] for s in samples}):
   vals=np.array([s['runner_wall_ns']/1e6 for s in samples if s['case']==case and not s['warmup']]);median=float(np.median(vals));pred=predictions[case]['prediction_ns']/1e6
   color='#c54a38' if case.startswith('add') else '#245a81'
   ax.errorbar([pred],[median],yerr=[[median-float(np.quantile(vals,.1))],[float(np.quantile(vals,.9))-median]],fmt='o',color=color,capsize=3)
   if not case.startswith('auto'):ax.annotate(case,(pred,median),fontsize=7,xytext=(4,4),textcoords='offset points')
  ax.plot([0,5],[0,5],color='0.65',linestyle='--',linewidth=1);ax.set(xlim=(0,5),ylim=(0,5),xlabel='Frozen prediction (ms)',ylabel='Observed runner median (ms)',title=session);ax.grid(alpha=.15)
 fig.suptitle('Same frozen parameters; bars show raw hot-sample p10–p90, not confidence intervals')
 fig.savefig(a.output/'heldout-prediction.svg');fig.savefig(a.output/'heldout-prediction.png',dpi=180);plt.close(fig)
 samples=sessions['holdout-r1'];fig,ax=plt.subplots(figsize=(9,4),layout='constrained')
 for i,(left,right) in enumerate([('auto1','auto2'),('auto1','auto3'),('auto2','auto3')]):
  l={(s['seed'],s['repeat']):s['runner_wall_ns'] for s in samples if s['case']==left and not s['warmup']};rr={(s['seed'],s['repeat']):s['runner_wall_ns'] for s in samples if s['case']==right and not s['warmup']};v=np.array([(rr[k]-l[k])/1e3 for k in l]);lo,hi=np.quantile(v,[.1,.9]);med=float(np.median(v));pd=(predictions[right]['prediction_ns']-predictions[left]['prediction_ns'])/1e3
  ax.scatter(v,np.full(len(v),i)+np.linspace(-.08,.08,len(v)),s=12,alpha=.35,color='#245a81');ax.plot([lo,hi],[i,i],linewidth=6,alpha=.35,color='#245a81');ax.scatter([med],[i],s=65,marker='|',color='black');ax.scatter([pd],[i],marker='D',s=45,color='#c54a38',label='Frozen predicted difference' if i==0 else None)
 ax.axvline(0,color='0.5',linestyle='--');ax.set(yticks=range(3),yticklabels=['auto2 − auto1','auto3 − auto1','auto3 − auto2'],xlabel='Paired runner time difference (µs)',title='Automatic candidates: all differences unresolved at registered noise gate');ax.legend(loc='lower left');ax.grid(axis='x',alpha=.15);fig.savefig(a.output/'automatic-differences.svg');fig.savefig(a.output/'automatic-differences.png',dpi=180);plt.close(fig)
 case='fanout16n96';rows=[s for s in samples if s['case']==case and not s['warmup']];median=statistics.median(s['runner_wall_ns'] for s in rows);s=min(rows,key=lambda s:abs(s['runner_wall_ns']-median));events=s['events'];origin=min(e['start_ns'] for e in events);fig,ax=plt.subplots(figsize=(10,3.7),layout='constrained')
 pred=predictions[case]['prediction_ns']/1e3;ax.broken_barh([(0,pred)],(2.1,.45),facecolors='#819c8c');ax.text(pred/2,2.32,'Predicted whole invocation: internal DMA/core/config/polling timing unidentified',ha='center',va='center',fontsize=8)
 starts=next(e for e in events if e['kind']=='actual_xrt_start');wait=next(e for e in events if e['kind']=='actual_xrt_wait');start=(starts['start_ns']-origin)/1e3;span=(wait['end_ns']-starts['start_ns'])/1e3;ax.broken_barh([(start,span)],(1.1,.45),facecolors='#245a81');ax.text(start+span/2,1.32,'Observed submit → successful wait (composite)',ha='center',va='center',color='white',fontsize=8)
 for e in events:
  if e['kind']=='actual_bo_sync':ax.broken_barh([((e['start_ns']-origin)/1e3,(e['end_ns']-e['start_ns'])/1e3)],(.1,.45),facecolors='#c69239')
 ax.set(yticks=[.32,1.32,2.32],yticklabels=['Actual BO sync API spans','Actual completion envelope','Frozen predicted timeline'],xlabel='µs (actual spans relative to first recorded API; prediction starts at zero)',ylim=(-.1,2.8),title=f'Fanout16×96: predicted {pred:.3f} µs; representative runner {s["runner_wall_ns"]/1e3:.3f} µs');ax.grid(axis='x',alpha=.15);fig.savefig(a.output/'fanout-observation-timeline.svg');fig.savefig(a.output/'fanout-observation-timeline.png',dpi=180);plt.close(fig)
 (a.output/'scope.json').write_text(json.dumps({'source_sessions':list(sessions),'sample_case':case,'representative_seed':s['seed'],'representative_repeat':s['repeat'],'timing':'host-only composite; no invented internal intervals','errorbars':'empirical p10/p90 not confidence intervals'},indent=2)+'\n')
if __name__=='__main__':main()
