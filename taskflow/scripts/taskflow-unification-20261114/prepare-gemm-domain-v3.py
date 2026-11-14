#!/usr/bin/env python3
"""Generate a source/target choice domain; ORBIT chooses/evaluates its states."""
import argparse,hashlib,importlib.util,json
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--runtime-source',type=Path,required=True);p.add_argument('--triton-root',type=Path,required=True);p.add_argument('--incumbent',type=Path,required=True);p.add_argument('--inputs',type=Path,required=True);p.add_argument('--reference',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--evaluator',type=Path,required=True);p.add_argument('--model-identity',type=Path);a=p.parse_args()
s=importlib.util.spec_from_file_location('domain_runtime',a.runtime_source);m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
target=m.source_target_contract(a.triton_root);shape=json.loads(a.inputs.read_text())['shape'];inc=json.loads((a.incumbent/'implementation.json').read_text());tile=inc['tiling']
base=dict(m=shape['M'],n=shape['N'],k=shape['K'],bm=tile['L2_M'],bn=tile['L2_N'],l1m=tile['L1_M'],l1n=tile['L1_N'],l2k=tile['L2_K'],l1k=tile['L1_K'],replicas=inc['resource']['task_instance_replicas'],column_offset=inc['resource'].get('column_offset',0),row_offset=inc['resource'].get('row_offset',2))
rows=list(m.gemm_parameter_domain(shape['M'],shape['N'],shape['K'],target))
keys=[k for k in base if k not in ('m','n','k')]
def identity(row): return hashlib.sha256(json.dumps(row,sort_keys=True,separators=(',',':')).encode()).hexdigest()
def rank(row):
 changed=sum(row[k]!=base[k] for k in keys)
 distance=sum(abs(row[k]-base[k])/max(1,base[k]) for k in keys)
 return changed,distance,identity(row)
rows.sort(key=rank)
# Give distinct transformation families a proposal before repeating a family.
# The full choice domain is retained; this is proposal ordering, not pruning.
first=[];seen=set()
def append(row):
 key=identity(row)
 if key not in seen: seen.add(key);first.append(row)
append(base)
for field in keys:
 candidates=[row for row in rows if row[field]!=base[field]]
 if candidates: append(candidates[0])
import itertools
for fields in itertools.combinations(keys,2):
 candidates=[row for row in rows if all(row[k]!=base[k] for k in fields)
     and all(row[k]==base[k] for k in keys if k not in fields)]
 if candidates:append(candidates[0])
for row in rows: append(row)
choices=[dict(id='original-source-call',mode='original-source-call'),dict(id='original-persistent',mode='original-persistent')]+[
 dict(id=identity(row),mode='generated',parameters=row) for row in first]
out=dict(schema='orbit.source-generated-gemm-domain.v3',target=target,
 provenance=dict(generator=m.identity(a.runtime_source),preparer=m.identity(__file__),evaluator=m.identity(a.evaluator),inputs=m.identity(a.inputs),reference=m.identity(a.reference),source_model=json.loads(a.inputs.read_text())['model']),
 domain_size=len(rows),incumbent=m.identity(a.incumbent/'implementation.json'),
 proposal_order='incumbent, nearest derived single-field and two-field family neighbors, then all remaining source-target choices',
 generator=m.identity(a.runtime_source),choices=choices,
 request_base=dict(warmups=2,repeats=9,runtime_source=str(a.runtime_source.resolve()),runtime_sha256=m.identity(a.runtime_source)['sha256'],evaluator_sha256=m.identity(a.evaluator)['sha256'],triton_root=str(a.triton_root.resolve()),inputs=str(a.inputs.resolve()),inputs_manifest=m.identity(a.inputs),reference=m.identity(a.reference),compile_timeout_seconds=180,measurement_timeout_seconds=120,capacity_bytes=256*1024*1024))
if a.model_identity:
 model=json.loads(a.model_identity.read_text())
 source_model=json.loads(a.inputs.read_text())['model']
 if model['path']!=source_model['path'] or model['bytes']!=source_model['bytes']:raise ValueError('model identity differs from source capture')
 out['provenance']['source_model']=model
 out['provenance']['model_identity_receipt']=m.identity(a.model_identity)
a.output.parent.mkdir(parents=True,exist_ok=True)
with a.output.open('x') as f:json.dump(out,f,separators=(',',':'));f.write('\n')
print(json.dumps(dict(domain=str(a.output),choices=len(choices),proposals=choices[:12])))
