#!/usr/bin/env python3
"""Bounded source-bound public joint CP-SAT campaign; raw failures are retained."""
import argparse,hashlib,json,platform,subprocess,time
from pathlib import Path

def source(tasks,rows=8,columns=8):
 ty=f'memref<{rows}x{columns}xf32>'
 text=f'module {{func.func @chain_{tasks}(%X: {ty} {{orbit.role="input",orbit.name="X"}},%Y: {ty} {{orbit.role="output",orbit.name="Y"}}) attributes {{orbit.noalias,llvm.emit_c_interface}} {{\n'
 for t in range(tasks-1):text+=f'%T{t}=memref.alloc() {{orbit.name="T{t}"}} : {ty}\n'
 for t in range(tasks):
  arg='%X' if t==0 else f'%d{t-1}';out='%Y' if t==tasks-1 else f'%T{t}'
  text+=f'''%d{t}=taskflow.task @stage{t} will_reads({arg} : {ty}) will_writes({out} : {ty}) [original_read_memrefs({arg} : {ty}),original_write_memrefs({out} : {ty})] : ({ty},{ty})->{ty} {{
 ^bb0(%x: {ty},%o: {ty}):
 affine.for %i=0 to {rows} {{affine.for %j=0 to {columns} {{%v=affine.load %x[%i,%j] : {ty}
 %c=arith.constant 1.0 : f32
 %r=arith.addf %v,%c : f32
 affine.store %r,%o[%i,%j] : {ty}}}}}
 taskflow.yield done_writes(%o : {ty})
 }}\n'''
 for t in range(tasks-1):text+=f'memref.dealloc %T{t} : {ty}\n'
 return text+'return\n}}\n'

def config(tasks,chunks):
 params={k:dict(value=v,unit='bytes/ns' if k.endswith('bandwidth') else 'ns',provenance=dict(kind='assumed',source='v23 explicit scaling model; no hardware timing claim')) for k,v in {'compute.startup':4,'compute.operation':1,'compute.memory_access':.5,'configuration.startup':1000,'host.submit':100,'host.complete':100,'communication.startup':100,'communication.bandwidth':8}.items()}
 return dict(generic_air=dict(capacity_bytes=24576,cost_model=dict(kind='event-mechanism',schema='orbit.direct-air.cost.v1',mode='estimate',model_id='v23-scaling',implementations=['scalar'],boundary='one-invocation',parameters=params)),program_joint=dict(chunks=chunks,max_instances=1024,max_groups=4096,max_group_tasks=4,max_configurations=min(128,max(4,(tasks+3)//4*max(1,8//min(chunks))))))

def main():
 p=argparse.ArgumentParser();p.add_argument('--compiler',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--sizes',default='2,4,8,16,32,64,128');p.add_argument('--seconds',type=float,default=1);p.add_argument('--cores',type=int,default=2);p.add_argument('--chunks',default='8');a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False);(a.output/'provenance.json').write_text(json.dumps(dict(compiler_sha256=hashlib.sha256(a.compiler.read_bytes()).hexdigest(),script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),platform=platform.platform(),seconds=a.seconds,cores=a.cores,chunks=a.chunks,hardware_executed=False),indent=2));records=[]
 for tasks in map(int,a.sizes.split(',')):
  case=a.output/str(tasks);case.mkdir();src=case/'source.mlir';src.write_text(source(tasks));cfg=case/'target.json';cfg.write_text(json.dumps(config(tasks,list(map(int,a.chunks.split(',')))),indent=2));start=time.perf_counter();cmd=[str(a.compiler),str(src),'--target-config='+str(cfg),'--joint-program-search='+str(case/'search'),'--joint-seconds='+str(a.seconds),'--npu-shards='+str(a.cores)];record=dict(tasks=tasks,command=cmd)
  try:r=subprocess.run(cmd,capture_output=True,text=True,timeout=max(10,a.seconds+5));record.update(returncode=r.returncode,stdout=r.stdout,stderr=r.stderr)
  except subprocess.TimeoutExpired as e:record.update(returncode=124,status='external_timeout',stderr=str(e));(case/'external-timeout.json').write_text(json.dumps(record,indent=2))
  record['process_ms']=(time.perf_counter()-start)*1000
  output=case/'search/solution.json'
  if output.exists():
   d=json.loads(output.read_text());record.update({k:d.get(k) for k in ['status','selection','has_plan','has_objective','budget_exhausted','generation_ms','model_build_ms','solve_ms','total_ms','variables','constraints','branches','conflicts','peak_rss_kib','relative_gap','best_bound_ns','domain_complete','makespan_ns','message']})
   domain=json.loads((case/'search/domain.json').read_text());record.update(variants=len(domain['variants']),groups=len(domain['local_groups']),instances=[len(v['compute_ns']) for v in domain['variants']],copies=[len(v['version_bytes']) for v in domain['variants']])
  record['saved_baseline']=(case/'search/baseline.json').exists();records.append(record);print(json.dumps(record),flush=True);(a.output/'scaling.json').write_text(json.dumps(records,indent=2))
if __name__=='__main__':main()
