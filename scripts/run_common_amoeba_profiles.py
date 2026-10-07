#!/usr/bin/env python3
"""Map one canonical DFG per workload and run F45 allocation with those costs."""
from __future__ import annotations
import argparse,datetime,gzip,json,math,os,re,shutil,subprocess,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
WORKLOADS=('gcn','harris','llama','lu','radar','raytracing')
def now():return datetime.datetime.now(datetime.timezone.utc).isoformat()
def write(p,x):
 p.parent.mkdir(parents=True,exist_ok=True);q=p.with_name(p.name+'.partial');q.write_text(json.dumps(x,indent=2)+'\n');q.replace(p)
def closed_log(p):
 if not p.exists():return
 target=p.with_name(p.name+'.gz')
 with p.open('rb') as a,gzip.open(target,'wb',compresslevel=1) as b:shutil.copyfileobj(a,b)
 with p.open('rb') as a,gzip.open(target,'rb') as b:
  while True:
   x=a.read(1048576);y=b.read(1048576)
   if x!=y:raise ValueError('log compression bytes differ')
   if not x:break
 p.unlink()
def run(argv,out,label):
 record={'argv':argv,'status':'running','started_utc':now(),'subprocess_timeout':None};write(out/(label+'.command.json'),record)
 with (out/(label+'.stdout.log')).open('w') as a,(out/(label+'.stderr.log')).open('w') as b:
  proc=subprocess.Popen(argv,stdout=a,stderr=b);record['pid']=proc.pid;write(out/(label+'.command.json'),record);code=proc.wait()
 record.update(status='complete' if code==0 else 'failed',exit_code=code,ended_utc=now());write(out/(label+'.command.json'),record)
 closed_log(out/(label+'.stdout.log'));closed_log(out/(label+'.stderr.log'))
 if code:raise RuntimeError(label+' failed; see compressed stderr')
 return record
def check_profiles(path,architecture,diagnostic_ii_ceiling=20):
 from validate_common_amoeba_retiming import validate_profile_inventory
 validate_profile_inventory(json.loads(path.read_text()), architecture.read_text(), diagnostic_ii_ceiling)
 x=json.loads(path.read_text());assert x['format']=='amoeba-task-profile-v1'
 assert x['architecture_spec_text']==architecture.read_text() and not x['whole_program_scheduler_invoked']
 assert x['expected_candidate_count']==x['completed_candidate_count']==8*x['task_count']==len(x['candidate_attempts'])
 assert len(x['tasks'])==x['task_count'] and len(x['shape_domain'])==8
 for t in x['tasks']:
  assert t['source_iteration_domain_certified'] and t['source_iteration_domain_complete']
  for row in t['profiles']:
   assert row['mapper_succeeded'] and row['compiled_ii']>0 and row['steps']>0 and row['materialized_operation_count']>0
   assert row['estimated_latency']==math.ceil(row['structural_startup_cycles']+row['compiled_ii']*(row['sample_trip_count']-1))
   assert row['pre_mapper_wrapper_byte_count']==len(row['pre_mapper_wrapper_bytes'].encode())
 assert x['canonical_module_witness_byte_count']==len(x['canonical_module_witness_bytes'].encode())
 return x
def main():
 a=argparse.ArgumentParser(description=__doc__)
 a.add_argument('--optimizer',type=Path,required=True);a.add_argument('--original-optimizer',type=Path,required=True)
 a.add_argument('--source-contract',type=Path,required=True);a.add_argument('--source-root',type=Path,required=True)
 a.add_argument('--output-root',type=Path,required=True);a.add_argument('--architecture',type=Path,required=True)
 a.add_argument('--mapping-cache',type=Path,required=True);a.add_argument('--cpu',type=int,default=10)
 a.add_argument('--workloads',nargs='+',choices=WORKLOADS,default=list(WORKLOADS[:-1]))
 a.add_argument('--diagnostic-ii-ceiling',type=int,choices=(20,23),default=20)
 args=a.parse_args()
 if ('raytracing' in args.workloads) != (args.diagnostic_ii_ceiling==23) or (args.diagnostic_ii_ceiling==23 and args.workloads!=['raytracing']):a.error('original Ray requires a separate runtimeII23 diagnostic run')
 os.sched_setaffinity(0,{args.cpu});args.output_root.mkdir(parents=True,exist_ok=True)
 state={'schema':'orbit-common-dfg-amoeba-profiles-v1','status':'running','pid':os.getpid(),'started_utc':now(),'cpu_affinity':[args.cpu],'optimizer':str(args.optimizer.resolve()),'original_optimizer':str(args.original_optimizer.resolve()),'source_contract':str(args.source_contract.resolve()),'source_root':str(args.source_root.resolve()),'subprocess_timeout':None,'input_index':0,'training_ii_ceiling':20,'runtime_ii_ceiling':args.diagnostic_ii_ceiling,'runtime_extrapolation_enabled':args.diagnostic_ii_ceiling==23,'workloads':{w:{'status':'queued'} for w in args.workloads},'cycle_claim':'none; native shared-scheduler/trace/numeric gates follow actual F45 allocation'}
 write(args.output_root/'runtime.json',state);failed=False
 for w in args.workloads:
  out=args.output_root/w;out.mkdir(exist_ok=True);state['workloads'][w].update(status='running',phase='common-parent-mapper',started_utc=now());write(args.output_root/'runtime.json',state)
  try:
   source=args.source_root/w/'all-unit.mlir';copy=out/'canonical.mlir'
   if copy.exists():assert copy.read_bytes()==source.read_bytes()
   else:shutil.copy2(source,copy)
   fn=re.findall(r'sym_name = "([^"\n]+)"',copy.read_text());assert len(fn)==1;fn=fn[0]
   profiles=out/'task-profiles.json'
   if not profiles.exists():
    run([str(args.optimizer),str(copy),'--verify-each','--architecture-spec='+str(args.architecture),'--map-joint-scheduling-tasks=function='+fn+' candidate-id=candidate-0 parent-profile-output='+str(profiles)+' mapping-cache-dir='+str(args.mapping_cache),'--mlir-print-op-generic','-o',str(out/'profile-only.mlir')],out,'profile')
   x=check_profiles(profiles,args.architecture,args.diagnostic_ii_ceiling)
   state['workloads'][w].update(phase='f45-resource-allocation',task_count=x['task_count'],mapped_attempts=x['completed_candidate_count']);write(args.output_root/'runtime.json',state)
   scheduled=out/'scheduled-common-input-f45.mlir'
   run([str(args.original_optimizer),str(copy),'--verify-each','--architecture-spec='+str(args.architecture),'--orchestrate-task-on-cgra=orchestration-strategy=throughput-guided scheduling-mode=spatial-temporal task-profile-json='+str(profiles)+(' diagnostic-minimum-legal-profile-initialization=true' if args.diagnostic_ii_ceiling==23 else ''),'--mlir-print-op-generic','-o',str(scheduled)],out,'allocator')
   # F45 changes scheduler annotations included in the original source binding.
   # The common retimer authenticates canonical semantics and the raw wrapper
   # before refreshing that binding; a standalone bind pass must reject it.
   result={'schema':'orbit-common-dfg-f45-resource-selection-v1','status':'pass','function':fn,'canonical_input':str(copy),'profile_file':str(profiles),'allocated_input':str(scheduled),'common_mapper_profile_provenance':x['profile_provenance'],'task_count':x['task_count'],'canonical_input_bytes_equality':'pass','source_contract':state['source_contract'],'mapper_pin':state['optimizer'],'allocation_policy':'unchanged F45 throughput-guided spatio-temporal allocator','cycles':None,'native_validation':'pending','next_step':'replay_common_amoeba_baseline.py; compiler verifies exact canonical/profile binding before refresh'}
   write(out/'resource-result.json',result);state['workloads'][w].update(status='resource-ready',phase='native-validation-pending',result=str(out/'resource-result.json'),ended_utc=now())
  except Exception as e:
   failed=True;state['workloads'][w].update(status='failed',error=str(e),ended_utc=now())
  write(args.output_root/'runtime.json',state)
 state.update(status='incomplete' if failed else 'profiles-and-allocation-complete',ended_utc=now());write(args.output_root/'runtime.json',state)
 return int(failed)
if __name__=='__main__':raise SystemExit(main())
