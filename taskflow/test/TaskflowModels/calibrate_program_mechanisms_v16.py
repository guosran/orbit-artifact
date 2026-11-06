#!/usr/bin/env python3
"""Training-only NNLS; native C++ features and evaluator own all production plans."""
import argparse,datetime,hashlib,itertools,json,pathlib,subprocess,statistics
import numpy as np

def read(p):return json.loads(pathlib.Path(p).read_text())
def sha(p):return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
def ident(p):return {'path':str(pathlib.Path(p).resolve()),'sha256':sha(p)}
def write(p,v):pathlib.Path(p).write_text(json.dumps(v,indent=2,allow_nan=False)+'\n')
def nnls(x,y):
 x=np.asarray(x,float);y=np.asarray(y,float);scale=np.linalg.norm(x,axis=0);assert np.all(scale>0);z=x/scale;n=x.shape[1];assert np.linalg.matrix_rank(z)==n
 best=None
 for mask in itertools.product([False,True],repeat=n):
  cols=np.flatnonzero(mask);b=np.zeros(n)
  if len(cols):
   v=np.linalg.lstsq(z[:,cols],y,rcond=None)[0]
   if np.min(v)<-1e-9:continue
   b[cols]=np.maximum(v,0)
  residual=float(np.sum((z@b-y)**2))
  if best is None or residual<best[0]:best=residual,b/scale
 return best[1],{'rank':n,'normalized_condition':float(np.linalg.cond(z)),'squared_error_ms2':best[0],'scaled_gradient':(z.T@(x@best[1]-y)).tolist()}
def main():
 p=argparse.ArgumentParser();p.add_argument('--calibration',type=pathlib.Path,required=True);p.add_argument('--features',type=pathlib.Path,required=True);p.add_argument('--registration',type=pathlib.Path,required=True);p.add_argument('--target-snapshot',type=pathlib.Path,required=True);p.add_argument('--form',choices=['four','five'],required=True);p.add_argument('--output',type=pathlib.Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
 registration=read(a.registration);index=read(a.features);proto=read(a.calibration/'protocol.json');runtime=read(a.calibration/'runtime.json');samples=[json.loads(l) for l in (a.calibration/'samples.jsonl').read_text().splitlines()]
 assert runtime['active_contexts']==8 and runtime['poll_us']==20
 assert len(proto['cases'])==8 and len(samples)==8*3*11 and read(a.calibration/'summary.json')['status']=='passed'
 byplan={c['plan']['sha256']:c['id'] for c in proto['cases']}
 rows=[dict(c,case=byplan[sha(pathlib.Path(c['compiled'])/'plan.json')]) for c in index['cases'] if c['split']=='train']
 keys=['command_count','hardware_stage_count','dma_bytes','source_scalar_f32_operations'] if a.form=='four' else ['command_count','hardware_stage_count','dma_bytes','implemented_scalar_f32_product_operations','implemented_scalar_f32_addsub_operations']
 x=[];y=[];cells=[]
 for r in rows:
  f=read(r['features']['path']);assert sha(r['features']['path'])==r['features']['sha256'];values=[s['runner_wall_ns']/1e6 for s in samples if s['case']==r['case'] and not s['warmup']];assert len(values)==27
  x.append([f['values'][key] for key in keys]);y.append(float(np.median(values)));cells.append(dict(case=r['case'],case_id=r['id'],graph_id=r['graph_id'],quantities=x[-1],median_ms=y[-1],raw_hot_ms=values))
 b,diagnostic=nnls(x,y)
 for i,c in enumerate(cells):c.update(prediction_ms=float(np.array(x[i])@b),absolute_error_ms=abs(float(np.array(x[i])@b)-y[i]))
 raw={'registration':ident(a.registration),'features':ident(a.features),'calibration_samples':ident(a.calibration/'samples.jsonl'),'calibration_protocol':ident(a.calibration/'protocol.json'),'runtime':ident(a.calibration/'runtime.json'),'target_snapshot':ident(a.target_snapshot),'fitter':ident(__file__)};write(a.output/'raw-manifest.json',raw)
 condition={'context_count':8,'poll_us':20,'runner':proto['runner'],'installed_runner':proto['installed_runtime'],'bo_policy':'prepared caller-bound, all ABI TO and outputs FROM','observers':{k:proto[k] for k in ['observer','polling_observer','base_observer']},'boundary':'prepared-command-host-to-host'}
 write(a.output/'condition.json',condition);target={'id':read(a.target_snapshot)['target_id'],'toolchain':'native-direct-AIR-v15-sha-bound-package-compilation','runtime':sha(a.output/'condition.json'),'boundary':'prepared-command-host-to-host'};write(a.output/'target.json',target)
 allfeatures=[read(r['features']['path']) for r in index['cases']]
 model={'schema':'orbit.direct-air.cost.v1','kind':'linear-composite','calibration':'calibrated','model_id':'v16-shared-scalar-implementation-'+a.form,'model_version':'v16-r1-'+a.form,'training_manifest_digest':sha(a.output/'raw-manifest.json'),'boundary':'prepared-command-host-to-host','target':target,'domain':{'source_fingerprints':sorted(set(s for f in allfeatures for s in f['source_fingerprints'])),'implementations':['scalar:1'],'operations':sorted(set(k for f in allfeatures for k in f['source_operations'])),'feature_ranges':{k:[min(f['values'][k] for f in allfeatures),max(f['values'][k] for f in allfeatures)] for k in allfeatures[0]['values']}},'terms':[{'feature':key,'coefficient_ms':float(value)} for key,value in zip(keys,b)],'label_scope':'Prepared bound-BO runner wall: actual sync/start/wait and runner work. Excludes caller input reset/output poisoning, preparation, references and evidence IO. Scalar software multiplication and lane-insert/add/extract share this implementation envelope; no independent pure-DMA duration.','parameter_identifiability':'Training design rank does not establish causal separation of overlapped DMA/core/runtime effects. Scalar product term includes correlated GEMM loads/loops/add recurrence; additive charge is one composite.'}
 write(a.output/'model.json',model)
 seedfits={}
 for seed in proto['seeds']:
  sy=[float(np.median([s['runner_wall_ns']/1e6 for s in samples if s['case']==r['case'] and s['seed']==seed and not s['warmup']])) for r in rows]
  sb,sd=nnls(x,sy);seedfits[str(seed)]={'parameters_ms':sb.tolist(),**sd}
 write(a.output/'fit-report.json',{'form':a.form,'features':keys,'parameters_ms':b.tolist(),'diagnostic':diagnostic,'training_cells':cells,'training_mape_percent':100*float(np.mean([c['absolute_error_ms']/c['median_ms'] for c in cells])),'per_seed_fits':seedfits,'heldout_labels_read':False})
 write(a.output/'freeze.json',{'created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'files':{p.name:ident(p) for p in a.output.iterdir() if p.is_file()},'heldout_labels_read':False,'scope':'Parameters frozen after training; separate native C++ prediction/freeze gate required before heldout execution.'})
 print(json.dumps({'form':a.form,'coefficients':dict(zip(keys,b.tolist())),'training_mape_percent':read(a.output/'fit-report.json')['training_mape_percent'],'heldout_labels_read':False}))
if __name__=='__main__':main()
