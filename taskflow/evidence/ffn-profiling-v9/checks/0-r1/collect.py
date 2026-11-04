import json,pathlib,hashlib,subprocess
r=pathlib.Path('/home/shiran/project/orbit-artifact/results/taskflow/ffn-profiling-v9');o=pathlib.Path(__file__).parent;t=pathlib.Path('/home/shiran/project/orbit-artifact/builds/taskflow-v9/core/tools/taskflow-opt/taskflow-opt')
def sha(p):return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
cases=[]
for m in (1,5,8,3):
 for task in ('gate','up','activation','down','full'):
  cases.append((f'm{m}-{task}',r/f'baseline/m{m}/{task}','holdout' if m==3 else 'train',f'profile-m{m}-r1'))
for split in ('train','holdout'):
 for c in json.loads((r/f'cases-controls-r3-{split}.json').read_text()):
  cases.append((c['name'],pathlib.Path(c['hardware']).parent,split,'profile-controls-r3-train-r1'))
entries=[];bridges=[];ranges={k:[0,0] for k in ('command_count','source_f32_product_operations','source_math_exp_f32_operations','hardware_stage_count')}
for name,p,split,prof in cases:
 d=o/'features'/name;d.mkdir()
 cfg=json.loads((p/'target.json').read_text());cfg['generic_air']['cost_model']={'schema':'orbit.direct-air.cost.v1','kind':'features-only'};(d/'config.json').write_text(json.dumps(cfg))
 src=p/'transformed-taskflow.mlir';cmd=[str(t),str(src),'--generic-map','--target-config='+str(d/'config.json'),'--mapping-output='+str(d/'plan.json')]
 x=subprocess.run(cmd,capture_output=True,text=True);(d/'command.json').write_text(json.dumps({'argv':cmd,'tool_sha256':sha(t)}));(d/'stdout.log').write_text(x.stdout);(d/'stderr.log').write_text(x.stderr)
 if x.returncode:raise RuntimeError((name,x.stderr))
 old=json.loads((p/'plan.json').read_text());new=json.loads((d/'plan.json').read_text())
 # New model metadata intentionally changes plan identity; source and plan facts
 # are checked rather than claiming old code was executed with the new ID.
 for k in ('body_fingerprint','strategy','actual_dma_bytes','resident_bytes','capacity_bytes'):
  if old.get(k)!=new.get(k):raise RuntimeError((name,k,old.get(k),new.get(k)))
 if old.get('transfer_summary')!=new.get('transfer_summary'):raise RuntimeError((name,'transfers changed'))
 f=new['direct_air_cost']['features']['values']
 for k in ranges:ranges[k][1]=max(ranges[k][1],f[k])
 entry={'name':name,'split':split,'group_id':name,'plan':str(d/'plan.json'),'plan_sha256':sha(d/'plan.json')}
 if split=='train':
  for k,path in [('profile',r/prof/'results.json'),('audit',pathlib.Path('/home/shiran/project/orbit-artifact/.work/profiling-v9-audit/r4')/(prof+'.json'))]:entry[k]=str(path);entry[k+'_sha256']=sha(path)
 entries.append(entry)
 bridges.append({'name':name,'source_sha256':sha(p/'source.mlir'),'transformed_source_sha256':sha(src),'old_plan_sha256':sha(p/'plan.json'),'new_feature_plan_sha256':sha(d/'plan.json'),'old_plan_id':old.get('plan_id'),'new_feature_plan_id':new.get('plan_id'),'old_air_sha256':sha(p/'program.air.mlir'),'elf_sha256':sha(p/'hardware/program.elf'),'scope':'same preserved transformed source and checked body/strategy/DMA/region summary; features only, no new AIR compile or execution'})
toolchain=json.loads((r/'baseline/m1/gate/hardware/toolchain.json').read_text());runtime=json.loads((r/'profile-m1-r1/runner-identity.json').read_text())['sha256']
manifest={'schema':'orbit.direct-air.training.v1','model_id':'direct-air-scalar-f32-composite-v9','model_version':'1','timing_boundary':'prepared-command-host-to-host','objective':'relative-residual-floor-1ms','target':{'id':'local-xdna-v9-profile-host','toolchain':json.dumps(toolchain,sort_keys=True,separators=(',',':')),'runtime':'MultiLaunchRunner:'+runtime},'feature_ranges':ranges,'cases':entries,'notes':['M1/M5/M8 are pilot/training, including full; only M3/control17x80 are unmeasured holdout','group_id identifies exact source/shape; source families remain correlated; holdout is shape generalization, not unrelated workloads','entire separate-four-input controls experiment excluded','preselected holdout static features used for declared domain; holdout labels never opened']}
(o/'training-manifest.json').write_text(json.dumps(manifest,indent=2,sort_keys=True)+'\n');(o/'feature-identity-bridges.json').write_text(json.dumps(bridges,indent=2,sort_keys=True)+'\n');print(len(entries),'native feature plans collected')
