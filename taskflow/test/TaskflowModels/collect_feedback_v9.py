#!/usr/bin/env python3
"""CPU provenance/count/actual-wait negatives for a real collected descriptor."""
import argparse
import copy
import importlib.util
import json
from pathlib import Path
import tempfile

p=argparse.ArgumentParser(description=__doc__);p.add_argument('--descriptor',type=Path,required=True)
p.add_argument('--output',type=Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
script=Path(__file__).resolve().parents[2]/'scripts/collect_direct_air_feedback_v9.py'
spec=importlib.util.spec_from_file_location('collector',script);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
d=m.load(a.descriptor);profile=Path(d['profile_results']['path']).parent;audit=m.load(d['audit']['path']);inv=m.load(d['invocation']['path']);checks=[]
def passed(name):checks.append(name)
def rejects(name,call):
    try:call()
    except (ValueError,KeyError):passed(name);return
    raise AssertionError(name+' unexpectedly accepted')
# Positive collector uses exact historical artifacts, without running hardware.
root=Path(d['cases'][0]['compiled_source']['path']).parents[1]
result,proof=m.collect(d['proposal_cases']['path'],d['proposal_summary']['path'],root,profile,d['audit']['path'])
assert result['target']==d['target'] and result['cases']==d['cases'];passed('recollect-real-identities')
v=copy.deepcopy(audit);v['checks'].pop();v['output_checks']-=1
rejects('missing-raw-check',lambda:m.validate_profile(profile,v,inv))
v=copy.deepcopy(audit);v['seed_count']+=1
rejects('wrong-seed-count',lambda:m.validate_profile(profile,v,inv))
v=copy.deepcopy(audit);name=next(iter(v['candidates']));v['candidates'][name]['hot_wall_ms']['n']+=1
rejects('wrong-hot-count',lambda:m.validate_profile(profile,v,inv))
v=copy.deepcopy(audit);v['candidates'][name]['elf_sha256']='0'*64
rejects('wrong-audited-elf',lambda:m.validate_profile(profile,v,inv))
v=copy.deepcopy(audit);v['checks'].append(copy.deepcopy(v['checks'][0]));v['output_checks']+=1
rejects('duplicate-raw-check',lambda:m.validate_profile(profile,v,inv))
with tempfile.TemporaryDirectory() as tmp:
    tmp=Path(tmp)
    for name in ('runner-identity.json','wait-backend.json','profiler-source.py','measurement-boundary.json'):
        (tmp/name).write_bytes((profile/name).read_bytes())
    original=m.load(tmp/'wait-backend.json');v=copy.deepcopy(original);v['selected']=False;m.write(tmp/'wait-backend.json',v)
    rejects('unselected-wait-backend',lambda:m.runtime_identity(tmp,inv))
    v=copy.deepcopy(original);v['multilaunch_source_sha256']='0'*64;m.write(tmp/'wait-backend.json',v)
    rejects('runner-wait-mismatch',lambda:m.runtime_identity(tmp,inv))
    m.write(tmp/'wait-backend.json',original)
    boundary=m.load(tmp/'measurement-boundary.json');changed=copy.deepcopy(boundary);changed['whole_wall']='device cycles only';m.write(tmp/'measurement-boundary.json',changed)
    rejects('wrong-whole-command-boundary',lambda:m.runtime_identity(tmp,inv))
    m.write(tmp/'measurement-boundary.json',boundary);(tmp/'profiler-source.py').write_text('changed profiler')
    rejects('changed-profiler-snapshot',lambda:m.runtime_identity(tmp,inv))
with tempfile.TemporaryDirectory() as tmp:
    tmp=Path(tmp);case_path=tmp/'executed-cases.json'
    rows=m.load(inv['cases_path']);m.write(case_path,rows)
    changed_inv=copy.deepcopy(inv);changed_inv['cases_path']=str(case_path)
    # A byte change with the old recorded digest is rejected.
    rows[0]['static_indices']=[1];m.write(case_path,rows)
    rejects('tampered-executed-cases',lambda:m.case_preparation_contract(profile,changed_inv))
    # Synthetic metadata sensitivity only: deliberately update this unit-test
    # invocation digest, without relabeling any existing measurement artifact.
    changed_inv['cases_sha256']=m.sha(case_path)
    original_runtime=m.runtime_identity(profile,inv)
    changed_runtime=m.runtime_identity(profile,changed_inv)
    context={'device':'test','flags':[],'toolchain':{'test':'synthetic'}}
    assert original_runtime!=changed_runtime
    assert m.target_identity(context,original_runtime)['id']!=m.target_identity(context,changed_runtime)['id']
    passed('static-BO-strategy-changes-target-identity')
    # Normalizing the same set does not depend on index-list order.
    rows=m.load(inv['cases_path']);rows[0]['static_indices']=[1,0];m.write(case_path,rows)
    changed_inv['cases_sha256']=m.sha(case_path);first=m.runtime_identity(profile,changed_inv)
    rows[0]['static_indices']=[0,1];m.write(case_path,rows);changed_inv['cases_sha256']=m.sha(case_path)
    assert first==m.runtime_identity(profile,changed_inv);passed('BO-index-set-order-canonical')
rejects('missing-device-command',lambda:m.compile_context(['aircc','--no-xbridge'],{'llvm':'version'}))
m.write(a.output/'result.json',{'status':'passed','checks':len(checks),'names':checks,
 'descriptor':m.descriptor(a.descriptor),'hardware_executed':False,'planning_or_scoring':False})
print(json.dumps({'status':'passed','checks':len(checks),'hardware_executed':False}))
