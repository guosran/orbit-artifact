#!/usr/bin/env python3
"""Summarize independent batch/session observations without cross-batch pairing."""
import argparse,json
from pathlib import Path
import numpy as np

def read(p):return json.loads(Path(p).read_text())
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--audit',type=Path,required=True);p.add_argument('--manifest',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
 audit=read(a.audit);manifest=read(a.manifest);compiled=read(manifest['compiled_index']['path']);aliases=compiled['aliases'];batches=[]
 import matplotlib;matplotlib.use('Agg')
 import matplotlib.pyplot as plt
 for batch in audit['batches']:
  entry=next(x for x in manifest['protocols'] if (x['program'],x['batch'])==(batch['program'],batch['batch']));protocol=read(entry['protocol']['path']);cases={x['id']:x for x in protocol['cases']};sessions=batch['sessions'];assert len(sessions)==2
  left={(x['left'],x['right']):x for x in sessions[0]['pairs']};right={(x['left'],x['right']):x for x in sessions[1]['pairs']};assert set(left)==set(right)
  paired=[]
  for pair,x in left.items():
   y=right[pair];assert x['predicted_delta_ms']==y['predicted_delta_ms'] and x['model_tied']==y['model_tied']
   signs=[int(np.sign(z['observed_delta_ms']['median'])) for z in [x,y]]
   paired.append(dict(left=pair[0],right=pair[1],predicted_delta_ms=x['predicted_delta_ms'],model_tied=x['model_tied'],session_observed_median_signs=signs,stable_observed_sign=signs[0]==signs[1],resolved_both=x['resolved'] and y['resolved'],stable_resolved_wrong_order=not x['model_tied'] and x['resolved'] and y['resolved'] and signs[0]==signs[1] and not x['sign_agreement'] and not y['sign_agreement']))
  observed=[]
  for case,identity in cases.items():
   observed.append(dict(case=case,baseline_control=case==entry['baseline_control'],frozen_prediction=identity['frozen_prediction'],actual_structure_sha256=identity['actual_structure_sha256'],aliases=[x for x in aliases if x['actual_package']==case],session_distributions=[x['distributions'][case] for x in sessions]))
  ranks=[sorted(cases,key=lambda c:session['distributions'][c]['median']) for session in sessions]
  batches.append(dict(program=batch['program'],batch=batch['batch'],cases=observed,session_median_orders=ranks,pairs=paired,stable_resolved_wrong_order_count=sum(x['stable_resolved_wrong_order'] for x in paired)))
  fig,axes=plt.subplots(2,1,figsize=(11,7))
  ids=list(cases)
  for axis,session in zip(axes,sessions):
   axis.boxplot([session['distributions'][c]['raw'] for c in ids],tick_labels=[c.split('-',1)[1] for c in ids],showfliers=True);axis.set_ylabel('Prepared host invocation wall ms');axis.set_title(Path(session['session']).name);axis.grid(axis='y',alpha=.2)
  fig.suptitle(f"{batch['program']} batch {batch['batch']}: independent session distributions; no cross-batch pairing",fontsize=10);fig.tight_layout();fig.savefig(a.output/f"{batch['program']}-batch-{batch['batch']}-distributions.svg");plt.close(fig)
 result=dict(status='PASS',scope='Within each fixed batch and process session only. Session sign stability is descriptive evidence from two processes, not independent-day replication. Model ties <=1e-12 ms excluded from strict ranking. No pooled baseline or cross-batch rank.',batches=batches,stable_resolved_wrong_order_pairs=sum(x['stable_resolved_wrong_order_count'] for x in batches))
 (a.output/'report.json').write_text(json.dumps(result,indent=2,allow_nan=False)+'\n');print(json.dumps(dict(status='PASS',batches=len(batches),stable_resolved_wrong_order_pairs=result['stable_resolved_wrong_order_pairs'])))
if __name__=='__main__':main()
