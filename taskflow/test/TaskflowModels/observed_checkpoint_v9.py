#!/usr/bin/env python3
"""Read-only measured-feedback metadata audit plus isolated checkpoint mutants.

Uses prior SHA-bound observations; never submits hardware or edits original evidence.
"""
import argparse
import copy
import hashlib
import json
from pathlib import Path
import subprocess

p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--tool',type=Path,required=True)
p.add_argument('--measured',type=Path,required=True)
p.add_argument('--output',type=Path,required=True)
a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)

def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def write(path,value):path.write_text(json.dumps(value,indent=2,sort_keys=True)+'\n')
source_checkpoint=a.measured/'search/checkpoint.json'
checkpoint_bytes=source_checkpoint.read_bytes()
report=json.loads((a.measured/'search/search.json').read_text())
scored=[r for r in report['archive'] if r['status']=='passed']
assert scored
for row in scored:
    response=row['evaluation'];score=response['score']
    assert response['evaluation_kind']=='measured_feedback'
    assert score['provenance']=='exact-observation-table'
    assert score['physical_hardware_measurement'] is True
    assert response['executed'] is False
    assert 'prior complete-command observations' in response['measurement_reuse']
checks=['all_scored_feedback_metadata']
base=json.loads((a.measured/'native-search.command.json').read_text())
base[0]=str(a.tool.resolve())
# The driver's checkpoint binding covers source/config/evaluator/budget, not the
# report directory. Use independent checkpoint/output paths; originals stay read-only.
base=[('--search-output='+str((a.output/'resumed-search').resolve())) if arg.startswith('--search-output=') else arg for arg in base]
checkpoint=a.output/'isolated-checkpoint.json'
base += ['--resume','--checkpoint='+str(checkpoint.resolve())]

def run(name,value,success):
    write(checkpoint,value)
    result=subprocess.run(base,text=True,capture_output=True)
    write(a.output/(name+'.command.json'),base)
    (a.output/(name+'.stdout')).write_text(result.stdout)
    (a.output/(name+'.stderr')).write_text(result.stderr)
    write(a.output/(name+'.exit.json'),{'returncode':result.returncode})
    if success:
        assert result.returncode==0,(name,result.stderr)
    else:
        assert result.returncode!=0 and 'measurement/prediction provenance mismatch' in result.stderr,(name,result.returncode,result.stderr)
    checks.append(name)

original=json.loads(checkpoint_bytes)
run('resume',original,True)
mutations=[('evaluation-kind',lambda e:e.update(evaluation_kind='static_estimate')),
 ('score-provenance',lambda e:e['score'].update(provenance='static-plan-estimate')),
 ('hardware-source-flag',lambda e:e['score'].update(physical_hardware_measurement=False)),
 ('fresh-execution-flag',lambda e:e.update(executed=True))]
for name,change in mutations:
    value=copy.deepcopy(original)
    row=next(r for r in value['archive'] if r['status']=='passed')
    change(row['evaluation'])
    run('reject-'+name,value,False)
assert source_checkpoint.read_bytes()==checkpoint_bytes
checks.append('original_checkpoint_unchanged')
write(a.output/'result.json',{'status':'passed','checks':len(checks),'names':checks,
 'observed_scored_candidates':len(scored),'compiler_sha256':sha(a.tool),
 'source_checkpoint_sha256':sha(source_checkpoint),'hardware_executed':False,
 'scope':'exact historical measurement feedback and isolated checkpoint provenance mutations'})
print(json.dumps({'status':'passed','checks':len(checks),'observed_scored_candidates':len(scored),'hardware_executed':False}))
