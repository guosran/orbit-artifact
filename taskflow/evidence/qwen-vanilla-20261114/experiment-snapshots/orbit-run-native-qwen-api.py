"""Time original vendor functions with model/context preparation outside requests.

This is separate from the actual unchanged CLI logs. No ORBIT graph executor,
replacement arithmetic, launch batching or source modification is used.
"""
import fcntl,hashlib,json,os,sys,time
from pathlib import Path
root=Path('/home/shiran/project/orbit-artifact/results/taskflow/qwen-vanilla-20261114')
base=json.loads((root/'run.json').read_text());os.environ.update(base['environment'])
for key in ['DECODE_ELF','COALESCE','PROJ_RC_CACHE','Q4NX_NPU_STATIC_WEIGHTS','Q4NX_EXACT_K']:os.environ.pop(key,None)
vendor=Path('/home/shiran/project/aie-toy/vendor/Triton-XDNA')
model=json.load(open('/home/shiran/project/aie-toy/results/qwen25-3b/model-paths.json'))
out=root/'native-api';out.mkdir(exist_ok=False)
result=dict(schema='orbit.vanilla-qwen-native-api-steady.v1',status='WAITING_FOR_DEVICE',vendor_commit=base['vendor_commit'],air_commit=base['air_commit'],source_sha256=base['source_sha256'],warmups=1,repeats=3,actual_outputs=128,decode_calls_per_request=127,requested_context=2048,protocol='Unchanged Qwen25Prefill and original AIR _decode_loop; original model/decoder kept alive for warmup1/repeat3; this is separate from raw CLI setup-inclusive timing.',requests=[])
def save():(out/'result.json').write_text(json.dumps(result,indent=2)+'\n')
save()
with open('/tmp/npu.lock','a') as lock:
 fcntl.flock(lock,fcntl.LOCK_EX)
 sys.path.insert(0,str(vendor/'examples/qwen25_3b_q4nx'))
 import config
 sys.path.insert(0,config._SHARED)
 import harness,registry,decode_build
 harness.hold_npu()
 from qwen25_prefill import Qwen25Prefill
 import torch
 spec=registry.spec(config.MODEL_NAME)
 args=harness.build_parser(None,tuple(Qwen25Prefill.PLACEMENT)).parse_args(['--prefill-engine','triton','--backend','npu','--max-tokens','127','--max-seq','2048','--greedy','--model',model['model']])
 ids=[785,6722,315,9625,374]
 result.update(status='PREPARING',torch_cpu_threads=torch.get_num_threads());save()
 for rel,sha in base['source_sha256'].items():assert hashlib.sha256((vendor/rel).read_bytes()).hexdigest()==sha
 air=harness.air_inference_module(spec);decode_build.check_stamp(spec)
 begin=time.perf_counter()
 prefiller=harness.make_prefiller(Qwen25Prefill,config,'npu',None,2048,model['model'])
 decoder=air.FusedDecoder(model=model['model'],max_L=2048)
 result.update(preparation_seconds=time.perf_counter()-begin,actual_context=decoder.ATTN_MAXL,status='MEASURING');save()
 assert decoder.ATTN_MAXL==2048
 reference=None
 for ordinal in range(4):
  start=time.perf_counter()
  prefiller.clear_context()
  logits=prefiller.prefill(ids)
  first=int(torch.argmax(logits));first_done=time.perf_counter()
  K,V=prefiller.kv_stack()
  generated,decode_seconds=air._decode_loop(decoder,ids,first,127,K,V,stop_on_eos=False)
  stop=time.perf_counter()
  assert len(generated)==128 and first==config.EXPECT_FIRST
  gate=harness._decode_gate(air,spec,config,args,ids,generated)
  assert gate==0,'Original vendor quality gate failed'
  if reference is None:reference=generated
  assert generated==reference,'Generated tokens changed between native requests'
  row=dict(kind='warmup' if ordinal==0 else 'measured',index=ordinal,full_request_ms=(stop-start)*1000,ttft_ms=(first_done-start)*1000,decode_loop_ms=decode_seconds*1000,remaining_handoff_control_ms=((stop-start)-(first_done-start)-decode_seconds)*1000,original_gate_pass=True,outputs=generated)
  result['requests'].append(row);save()
  print(json.dumps({k:v for k,v in row.items() if k!='outputs'}),flush=True)
 for rel,sha in base['source_sha256'].items():assert hashlib.sha256((vendor/rel).read_bytes()).hexdigest()==sha
 result.update(status='PASS',all_original_sources_unchanged=True);save()
