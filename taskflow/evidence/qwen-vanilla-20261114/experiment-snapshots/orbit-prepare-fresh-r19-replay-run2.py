import copy,hashlib,json,subprocess,tarfile
from pathlib import Path
root=Path('/home/shiran/project/orbit-artifact/results/taskflow/qwen-vanilla-20261114')
oldroot=Path('/home/shiran/project/orbit-artifact/results/taskflow/qwen-ready-r19/heldout-selected-frontier-r3-r19-v1-prepared')
out=root/'orbit-selected-run2';out.mkdir(exist_ok=False)
def load(p):return json.loads(Path(p).read_text())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def digest(x):return hashlib.sha256(json.dumps(x,sort_keys=True,separators=(',',':'),allow_nan=False).encode()).hexdigest()
def write(p,x):
 with Path(p).open('x') as f:json.dump(x,f,indent=2);f.write('\n')
receipt=load(oldroot/'command-receipt.json');parent_sha=sha(oldroot/'command-receipt.json');replay=load(oldroot/'replay.json');spec=load(oldroot/'spec.json')
restored={}
with tarfile.open('/home/shiran/project/orbit-artifact/.work/source-snapshots/orbit-e850af2ae623-before-review-cleanup.tar.gz') as archive:
 for row in receipt['registered_files']:
  p=Path(row['file'])
  if p.is_file():continue
  relative=p.relative_to('/home/shiran/project/orbit')
  data=archive.extractfile('orbit-frozen/'+str(relative)).read()
  assert hashlib.sha256(data).hexdigest()==row['sha256'],str(p)
  target=out/'archived-producers'/relative;target.parent.mkdir(parents=True,exist_ok=True)
  with target.open('xb') as f:f.write(data)
  restored[str(p)]=dict(file=str(target),requested_file=str(target),sha256=row['sha256'])
assert len(restored)==6,restored
spec['cpu_prepare_directory']=str(out/'cpu-preparation')
write(out/'spec.json',spec)
replay['spec']=spec
for i,row in enumerate(replay['source_files']):
 if row['file'] in restored:replay['source_files'][i]={**row,**restored[row['file']]}
replay['replay_id']=digest({k:v for k,v in replay.items() if k!='replay_id'})
write(out/'replay.json',replay)
command=receipt['command']
for flag,path in [('--replay',out/'replay.json'),('--ready-spec',out/'spec.json'),('--output',out/'execution')]:command[command.index(flag)+1]=str(path)
replacement={str(oldroot/'replay.json'):out/'replay.json',str(oldroot/'spec.json'):out/'spec.json'}
for rows in [receipt['files'],receipt['registered_files']]:
 for i,row in enumerate(rows):
  path=row['file']
  if path in restored:rows[i]={**row,**restored[path]}
  elif path in replacement:
   target=replacement[path];rows[i]={**row,'file':str(target),'requested_file':str(target),'sha256':sha(target)}
receipt['replay_id']=replay['replay_id']
proof=dict(schema='orbit.replay-archive-path-relocation.v1',parent_receipt=str(oldroot/'command-receipt.json'),parent_receipt_sha256=parent_sha,old_replay_id=load(oldroot/'replay.json')['replay_id'],new_replay_id=replay['replay_id'],program_graph_id=replay['program_graph_id'],source_id=replay['source_id'],restored_historical_producers=[dict(old_file=p,**r) for p,r in restored.items()],other_changes='Fresh execution and CPU compiler proof directories only. Same selected graph, runtime source bytes, prices, source, input/model and numerical gates; old sealed evidence is not edited.')
write(out/'relocation-proof.json',proof)
receipt['files'].append(dict(file=str(out/'relocation-proof.json'),requested_file=str(out/'relocation-proof.json'),sha256=sha(out/'relocation-proof.json')))
write(out/'command-receipt.json',receipt)
execute=['/home/shiran/project/aie-toy/.venv/bin/python','/home/shiran/project/orbit/experimental/qwen-runtime-search/execute-r19-prepared.py','--receipt',str(out/'command-receipt.json'),'--receipt-sha256',sha(out/'command-receipt.json'),'--log',str(out/'executor.log'),'--result',str(out/'execution-result.json'),'--timeout','600']
write(out/'execute-command.json',execute)
print(json.dumps(dict(command_receipt=str(out/'command-receipt.json'),sha256=sha(out/'command-receipt.json'),restored_producers=len(restored)),indent=2))
