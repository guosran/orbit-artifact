#!/usr/bin/env python3
"""Plot independently audited paired raw distributions; no prediction or fitting."""
import argparse,csv,json
from pathlib import Path
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

def main():
 p=argparse.ArgumentParser();p.add_argument('--review',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False);j=json.loads(a.review.read_text());fig,axes=plt.subplots(1,2,figsize=(13,5),constrained_layout=True);table=[]
 for ax,cls,title in zip(axes,['readonly-copy-retention','intermediate-region-residency'],['Input-copy retention: unresolved','Intermediate residency: tail configuration change']):
  position=0;labels=[]
  for session in j['sessions']:
   for row in session['pairs']:
    if row['contrast_class']!=cls:continue
    position+=1;values=np.array(row['observed_paired_delta']['raw_ns'])/1000;prediction=row['prediction_delta_ns']/1000
    ax.boxplot([values],positions=[position],widths=.45,whis=(10,90),showfliers=True,patch_artist=True,boxprops={'facecolor':'#d7e6f3'},medianprops={'color':'#1f4266'})
    ax.scatter([position],[prediction],marker='D',color='#cf5728',zorder=4,label='Frozen prediction' if position==1 else None)
    labels.append(row['pair_id'].replace('broadcast-','')+'\n'+('primary' if session['kind']=='unseen-pairs' else 'new process'))
    table.append({'session':session['id'],'pair':row['pair_id'],'predicted_us':prediction,'paired_median_us':row['observed_paired_delta']['median_ns']/1000,'p10_us':row['paired_p10_ns']/1000,'p90_us':row['paired_p90_ns']/1000,'error_us':row['error_ns']/1000,'resolved':row['measurement_resolved'],'status':row['status']})
  ax.axhline(0,color='grey',lw=.7);ax.set_xticks(range(1,position+1),labels,fontsize=8);ax.set_ylabel('Candidate minus baseline (us)');ax.set_title(title,fontsize=10);ax.grid(axis='y',alpha=.2);ax.legend(fontsize=8)
 fig.suptitle('Frozen v17 contrasts:45 hot paired samples per cell; box=P25/P75, whiskers=P10/P90\nAll outside-whisker samples retained; empirical ranges are not confidence intervals',fontsize=10)
 for ext in ['svg','png','pdf']:fig.savefig(a.output/('paired-differences.'+ext),dpi=180)
 with (a.output/'paired-summary.csv').open('w') as f:w=csv.DictWriter(f,fieldnames=list(table[0]));w.writeheader();w.writerows(table)
 print(json.dumps({'status':'passed','rows':len(table),'input_review':str(a.review)}))
if __name__=='__main__':main()
