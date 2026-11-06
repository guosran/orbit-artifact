#!/usr/bin/env python3
"""Serial SHA-bound pair-protocol runner; no candidate or model decisions."""
import argparse,hashlib,json,subprocess,sys
from pathlib import Path
from collect_sync_target_v14 import collect_snapshot

def read(p):return json.loads(Path(p).read_text())
def write(p,j):p.write_text(json.dumps(j,indent=2)+'\n')
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--facts-index',type=Path,required=True);p.add_argument('--split',choices=['train','holdout'],required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--expected-runtime-snapshot',type=Path);p.add_argument('--timeout',type=int,default=180);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
 rows=[r for r in read(a.facts_index)['cases'] if r['split']==a.split];assert rows
 write(a.output/'runtime-before.json',collect_snapshot());completed=[]
 if a.expected_runtime_snapshot:assert read(a.output/'runtime-before.json')==read(a.expected_runtime_snapshot),'runtime/host condition differs from frozen target'
 for row in rows:
  protocol=Path(row['protocol']['path']);assert hashlib.sha256(protocol.read_bytes()).hexdigest()==row['protocol']['sha256'];out=a.output/row['pair_id'];cmd=[sys.executable,str(Path(__file__).with_name('taskflow_data_probe_v17.py')),'--protocol',str(protocol),'--output',str(out)]
  with (a.output/(row['pair_id']+'.log')).open('w') as log:
   status=subprocess.run(cmd,stdout=log,stderr=subprocess.STDOUT,timeout=a.timeout).returncode
  assert status==0,(row['pair_id'],status);assert read(out/'summary.json')['status']=='passed';completed.append({'pair_id':row['pair_id'],'split':a.split,'output':str(out),'protocol':row['protocol']});print(row['pair_id'],'passed',flush=True)
  write(a.output/'completed.json',completed)
 write(a.output/'runtime-after.json',collect_snapshot());assert read(a.output/'runtime-before.json')==read(a.output/'runtime-after.json');write(a.output/'summary.json',{'status':'passed','pairs':len(rows),'device_policy':'each process exclusively locks /tmp/npu.lock','split':a.split})
if __name__=='__main__':main()
