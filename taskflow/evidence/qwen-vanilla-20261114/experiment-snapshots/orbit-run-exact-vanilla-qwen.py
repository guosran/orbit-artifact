import fcntl,json,os,re,subprocess,time
from pathlib import Path
root=Path('/home/shiran/project/orbit-artifact/results/taskflow/qwen-vanilla-20261114')
base=json.loads((root/'run.json').read_text())
assert base['status']=='COMPLETED' and base['returncode']==0
argv=list(base['command']);argv[argv.index('--max-tokens')+1]='127'
env=os.environ.copy();env.update(base['environment'])
for k in ['DECODE_ELF','COALESCE','PROJ_RC_CACHE','Q4NX_NPU_STATIC_WEIGHTS','Q4NX_EXACT_K']:env.pop(k,None)
results=[]
with open('/tmp/npu.lock','a') as lock:
 fcntl.flock(lock,fcntl.LOCK_EX)
 for i in range(3):
  out=root/f'exact-cli-{i+1}';out.mkdir(exist_ok=False)
  start=time.monotonic()
  with (out/'stdout.log').open('w') as log:
   run=subprocess.run(['/usr/bin/time','-v','-o',str(out/'resource.txt'),*argv],cwd=out,env=env,stdout=log,stderr=subprocess.STDOUT)
  text=(out/'stdout.log').read_text();tokens=re.search(r'^\[e2e\] ids (\[.*\])$',text,re.M)
  ids=json.loads(tokens.group(1)) if tokens else []
  row=dict(run=i+1,returncode=run.returncode,process_wall_seconds=time.monotonic()-start,actual_output_count=len(ids),tokens=ids,source_first_token_gate='first token 12095 (expect 12095)' in text,source_decode_gate='decode ids match the recorded 10' in text)
  for key,pattern in [('native_prefill_seconds',r'P=5 load [\d.]+s prefill ([\d.]+)s'),('native_decode_seconds',r'\[inference\] decode: 127 tokens in ([\d.]+)s'),('native_reported_ttft_including_load_seconds',r'Time to first token \(TTFT\): ([\d.]+)s'),('native_generation_wall_including_decoder_setup_seconds',r'\[e2e\] 128 tokens in ([\d.]+)s')]:
   match=re.search(pattern,text);row[key]=float(match.group(1)) if match else None
  row['admitted']=run.returncode==0 and len(ids)==128 and row['source_first_token_gate'] and row['source_decode_gate']
  results.append(row)
  (root/'exact-cli-results.json').write_text(json.dumps(dict(schema='orbit.vanilla-qwen-cli-exact-output.v1',command=argv,protocol='Three fresh original CLI processes; native setup is retained. Printed native timers have source formatting precision. These are not warmup1/repeat3 steady requests.',runs=results),indent=2)+'\n')
  print(json.dumps({k:v for k,v in row.items() if k!='tokens'}),flush=True)
  if not row['admitted']:raise SystemExit('Original CLI gate failed; no timing promotion')
