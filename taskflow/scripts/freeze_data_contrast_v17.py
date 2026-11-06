#!/usr/bin/env python3
"""Package registered training parameters and invoke the C++ contrast provider.

This wrapper does not derive plans or predict times. All prediction values and
eligibility decisions are emitted by taskflow-contrast-opt on original sources.
"""
import argparse,datetime,hashlib,json,subprocess
from pathlib import Path

def read(p):return json.loads(Path(p).read_text())
def write(p,j):p.write_text(json.dumps(j,indent=2,allow_nan=False)+'\n')
def identity(p):return dict(path=str(Path(p).resolve()),sha256=hashlib.sha256(Path(p).read_bytes()).hexdigest())
def digest(j):return hashlib.sha256(json.dumps(j,sort_keys=True,separators=(',',':')).encode()).hexdigest()
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--results',type=Path,required=True);p.add_argument('--tool',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();r=a.results.resolve();a.output=a.output.resolve();a.output.mkdir(parents=True,exist_ok=False)
 registration=read(r/'study-registration-r2.json');training=read(r/'independent-training-r1/summary.json');assert training['holdout_labels_read'] is False;assert all(c['all_loo_identified'] for c in training['classes'])
 source=read(r/'native-contrast-facts-r1/index.json');facts={x['pair_id']:read(x['facts']['path']) for x in source['cases']};runtime=read(r/'calibration-r1/runtime-before.json');assert runtime==read(r/'calibration-r1/runtime-after.json')
 protocol=read(source['cases'][0]['protocol']['path']);condition=digest({'measurement':registration['measurement'],'v17_wrapper':protocol['v17_wrapper'],'observer':protocol['observer'],'polling_observer':protocol['polling_observer'],'installed_runtime':protocol['installed_runtime']})
 target={'id':'orbit-v17-single-npu-paired-copy-contrasts','runtime':runtime['target_id'],'toolchain':digest([read(r/name)['tool'] for name in ['compiled-pairs-r1/index.json','compiled-pairs-r2extra/index.json']]),'condition':condition};write(a.output/'target-binding.json',target)
 manifest={'summary':identity(r/'independent-training-r1/summary.json'),'registration':identity(r/'study-registration-r2.json'),'training_evidence':training['evidence'],'fits':[x['fit'] for x in training['classes']],'runtime':identity(r/'calibration-r1/runtime-before.json')};write(a.output/'training-manifest.json',manifest)
 model={'schema':'orbit.direct-air.cost.v1','kind':'contrast-composite','model_id':'v17-registered-training-r2-contrast-r1','units':'ns','training_manifest_digest':identity(a.output/'training-manifest.json')['sha256'],'boundary':'prepared-command-host-to-host','target':target,'rows':[],'limits':['Exclusive changed-implementation composite, no additional v16 or DMA/compute/submit charges.','Absolute durations and shared baseline offset unknown; no full search score.','Pure DMA/core/overlap/physical DDR traffic not identified.','Nonnegative boundary coefficient zero does not prove zero mechanism cost.']}
 for c in training['classes']:
  cls=c['change_class'];rows=[f for f in facts.values() if f['change_class']==cls]
  domain={key:sorted({f['baseline'][field] for f in rows}) for key,field in [('family_fingerprints','family_fingerprint'),('architecture_fingerprints','architecture_fingerprint')]};domain['implementations']=sorted({impl for f in rows for impl in f['baseline']['implementations']})
  for side in ['baseline','candidate']:
   domain[side]={key:[min(f[side]['quantities'][key] for f in rows),max(f[side]['quantities'][key] for f in rows)] for key in rows[0][side]['quantities']}
  model['rows'].append({'change_class':cls,'domain':domain,'terms':[{'feature':key,'coefficient_ns':value} for key,value in c['coefficients_ns'].items()],'prediction_error_bound_ns':c['descriptive_prediction_error_allowance_ns'],'coverage':registration['model']['classes'][cls]['coverage'],'uncertainty_scope':c['scope']})
 write(a.output/'model.json',model);predictions=[];all_predictions=[]
 for row in source['cases']:
  compiled=next(x for x in read(row['compiled_index']['path'])['cases'] if x['pair_id']==row['pair_id']);out=a.output/row['pair_id'];cmd=[str(a.tool),compiled['baseline']['source']['path'],'--candidate',compiled['candidate']['source']['path'],'--cost-model',str(a.output/'model.json'),'--target-binding',str(a.output/'target-binding.json'),'--output',str(out)]
  p=subprocess.run(cmd,text=True,capture_output=True);(a.output/(row['pair_id']+'.log')).write_text(p.stdout+p.stderr);assert p.returncode==0,p.stderr
  f=read(out/'facts.json');assert f==facts[row['pair_id']];cost=read(out/'cost.json');assert cost['candidate_minus_baseline_ns'] is not None;proto=read(row['protocol']['path']);sides={side:{'graph_id':f[side]['graph_id'],'plan_id':f[side]['plan_id'],'artifact_sha256':next(x for x in proto['cases'] if x['id']==row['pair_id']+'-'+side)['elf']['sha256']} for side in ['baseline','candidate']}
  result={'pair_id':row['pair_id'],'split':row['split'],'orientation':'candidate-minus-baseline','contrast_class':f['change_class'],'condition_id':condition,**sides,'prediction_delta_ns':cost['candidate_minus_baseline_ns'],'lower_delta_ns':cost['lower_delta_ns'],'upper_delta_ns':cost['upper_delta_ns'],'unknown_reason':'','covered_change':f['covered_change'],'common_work_policy':'changed-implementation-coupled-contrast','implementation_evidence':[identity(r/'compiled-combined-implementation-audit-r2/inventory.json'),identity(r/'runner-abi-audit-r1/inventory.json'),identity(r/'runner-abi-audit-r1/zero-arithmetic-proof-28.json')],'facts':identity(out/'facts.json'),'cost':identity(out/'cost.json'),'protocol':row['protocol']};all_predictions.append(result)
  if row['split']=='holdout':predictions.append(result)
 write(a.output/'predictions.json',{'rows':predictions});write(a.output/'all-predictions.json',{'rows':all_predictions})
 m=registration['metrics'];write(a.output/'metrics.json',{'orientation':'candidate-minus-baseline','resolution_floor_ns':m['resolution_absolute_floor_ns'],'require_seed_sign_agreement':True,'difference_absolute_floor_ns':m['prediction_error_absolute_floor_ns'],'difference_relative_fraction':m['prediction_error_relative_fraction'],'required_classes':m['required_classes'],'min_resolved_pairs_per_class':m['min_resolved_pairs_per_class']})
 native_cases=[dict(row,facts=identity(a.output/row['pair_id']/'facts.json'),cost=identity(a.output/row['pair_id']/'cost.json')) for row in source['cases']]
 index={'cases':native_cases,'created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'holdout_labels_read':False,'frozen':{key:identity(a.output/name) for key,name in [('model','model.json'),('target','target-binding.json'),('training','training-manifest.json'),('predictions','predictions.json'),('all_predictions','all-predictions.json'),('metrics','metrics.json')]}}
 for key,path in [('registration',r/'study-registration-r2.json'),('facts_index',r/'native-contrast-facts-r1/index.json'),('main_compiled',r/'compiled-pairs-r1/index.json'),('extra_compiled',r/'compiled-pairs-r2extra/index.json'),('contrast_tool',a.tool),('freeze_wrapper',Path(__file__)),('batch_wrapper',Path(__file__).with_name('run_data_contrast_batch_v17.py'))]:index['frozen'][key]=identity(path)
 index['frozen_inputs']=index['frozen'];write(a.output/'index.json',index);print(json.dumps({'status':'frozen-predictions-produced','holdout_labels_read':False,'predictions':[(x['pair_id'],x['prediction_delta_ns']) for x in predictions]}))
if __name__=='__main__':main()
