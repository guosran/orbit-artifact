#!/usr/bin/env python3
"""Synthetic feedback contract tests using the real native driver; no hardware.

Placeholder AIR/ELF files here test bridge checks, not codegen or execution.
Their invented labels are never calibration/measurement evidence.
"""
import argparse
import copy
import importlib.util
import json
from pathlib import Path

p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--tool',type=Path,required=True)
p.add_argument('--proposals',type=Path,required=True)
p.add_argument('--output',type=Path,required=True)
a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
script=Path(__file__).resolve().parents[2]/'scripts/taskflow_profiled_search_v9.py'
spec=importlib.util.spec_from_file_location('profiled',script);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
checks=0

def record(name,value):
    path=a.output/name
    if isinstance(value,bytes):path.write_bytes(value)
    elif isinstance(value,str):path.write_text(value)
    else:m.write(path,value)
    return {'path':str(path.resolve()),'sha256':m.sha(path)}

cases=json.loads((a.proposals/'cases.json').read_text());case=next(c for c in cases if not c['parent'])
plan=json.loads(Path(case['features_plan']).read_text());name='synthetic-baseline'
air=record('fake.air.mlir',f'module attributes {{orbit.mapping_plan = "{plan["plan_id"]}", orbit.source_fingerprint = "{plan["body_fingerprint"]}"}} {{}}')
elf=record('fake.elf',b'SYNTHETIC-NOT-AN-ELF')
compile_record={'status':'compiled','source_sha256':air['sha256'],'elf_sha256':elf['sha256']}
manifest={'schema':'orbit.profiled-search.feedback.v1','boundary':m.BOUNDARY,
 'target':{'id':'synthetic-contract-only','toolchain':'test','runtime':'test'},
 'proposal_summary':{'path':str((a.proposals/'summary.json').resolve()),'sha256':m.sha(a.proposals/'summary.json')},
 'proposal_cases':{'path':str((a.proposals/'cases.json').resolve()),'sha256':m.sha(a.proposals/'cases.json')},
 'profile_results':record('profile.json',{'results':[{'status':'passed','samples':[{'candidate':name,'warmup':False,'wall_ms':2.0,'checks':{'Y':{'passed':True,'finite':True}}}]}]}),
 'audit':record('audit.json',{'status':'passed','checks':[{'candidate':name,'passed':True}]}),
 'invocation':record('invocation.json',{'identities':{name:{'elf_sha256':elf['sha256'],'compile_record':compile_record}}}),
 'cases':[{'candidate_id':case['candidate_id'],'profile_name':name,
  'compiled_source':{'path':case['source'],'sha256':case['source_sha256']},
  'compiled_plan':{'path':case['features_plan'],'sha256':case['features_plan_sha256']},
  'compiled_air':air,'elf':elf,'compile_record':record('compile.json',compile_record)}]}
path=a.output/'manifest.json';m.write(path,manifest)
positive=a.output/'positive';positive.mkdir()
result=m.feedback(a.tool.resolve(),path,positive)
assert result['observed_rows']==1;checks+=1
report=json.loads((positive/'search/search.json').read_text())
base=next(r for r in report['archive'] if not r['parent'])
assert base['status']=='passed' and base['score']==2.0;checks+=1
assert any(r['status']=='uncalibrated' and r['score'] is None for r in report['archive']);checks+=1

def rejects(name,change):
    global checks
    value=copy.deepcopy(manifest);change(value)
    p=a.output/(name+'.json');m.write(p,value);out=a.output/name;out.mkdir()
    try:m.feedback(a.tool.resolve(),p,out)
    except (ValueError,RuntimeError,KeyError):checks+=1;return
    raise AssertionError(name+' unexpectedly accepted')
rejects('changed-bound-file',lambda v:v['cases'][0]['elf'].update(sha256='0'*64))
rejects('wrong-candidate-source',lambda v:v['cases'][0].update(compiled_source=air))
rejects('duplicate-candidate',lambda v:v['cases'].append(copy.deepcopy(v['cases'][0])))
rejects('wrong-boundary',lambda v:v.update(boundary='device-cycles'))
rejects('missing-audit-candidate',lambda v:v['cases'][0].update(profile_name='not-audited'))
# This is explicitly a synthetic API test, not a measurement publication.
m.write(a.output/'result.json',{'status':'passed','checks':checks,'hardware_executed':False,
 'scope':'synthetic invented labels and placeholder AIR/ELF; real Core generic-map/search driver'})
print(json.dumps({'status':'passed','checks':checks,'hardware_executed':False}))
