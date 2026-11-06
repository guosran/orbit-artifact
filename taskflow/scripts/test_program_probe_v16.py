#!/usr/bin/env python3
"""CPU guards for authenticated replay and frozen observer conditions."""
import argparse,json,subprocess,sys,tempfile
from pathlib import Path
import taskflow_program_probe_v16 as probe
from taskflow_device_transfer_microbench_v15 import read,write

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--protocol',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
 assert not a.output.exists();protocol=read(a.protocol);probe.validate(protocol);checks=[]
 with tempfile.TemporaryDirectory(prefix='orbit-v16-probe-guard-') as directory:
  root=Path(directory)
  for field in ['elf','plan','source','transformed','aie']:
   changed=json.loads(json.dumps(protocol));changed['cases'][0][field]['sha256']='0'*64
   try:probe.validate(changed)
   except AssertionError:checks.append('reject-stale-'+field)
   else:raise AssertionError('stale evidence accepted: '+field)
  for key in ['runner','installed_runtime','observer','polling_observer','fixture_generator','base_observer']:
   changed=json.loads(json.dumps(protocol));changed[key]['sha256']='0'*64
   try:probe.validate(changed)
   except AssertionError:checks.append('reject-stale-'+key)
   else:raise AssertionError('stale implementation accepted: '+key)
  changed=json.loads(json.dumps(protocol));changed['cases'].append(changed['cases'][0])
  try:probe.validate(changed)
  except AssertionError:checks.append('reject-duplicate-case')
  else:raise AssertionError('duplicate case accepted')
  command=[sys.executable,probe.__file__,'--protocol',str(a.protocol.resolve()),'--output',str(root/'should-not-exist'),'--poll-us',str(protocol['poll_us']+1),'--validate-only']
  result=subprocess.run(command,stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True)
  assert result.returncode!=0 and 'poll condition differs' in result.stderr
  assert not (root/'should-not-exist').exists();checks.append('reject-poll-change-before-output-or-device')
  command=[sys.executable,probe.__file__,'--protocol',str(a.protocol.resolve()),'--output',str(root/'valid'),'--validate-only']
  subprocess.run(command,check=True);assert read(root/'valid/summary.json')['device_submissions']==0
  checks.append('valid-replay-imports-no-device')
 write(a.output,dict(status='passed',device_submissions=0,checks=checks,protocol=str(a.protocol.resolve())))
 print(json.dumps(dict(status='passed',checks=len(checks),device_submissions=0)))

if __name__=='__main__':main()
