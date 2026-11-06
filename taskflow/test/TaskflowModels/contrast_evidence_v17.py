#!/usr/bin/env python3
"""Read-only primitives binding native contrast facts to actual v17 raw calls.

No NPU execution, graph planning, feature invention or production model config.
These functions build numerical evidence adapters from already compiled pairs.
"""
from collections import defaultdict
import hashlib
import json
from pathlib import Path
import re
import numpy as np
from audit_mechanism_program_v16 import read,verify,identity,stats


def plan_side(side):
    compiled=Path(side['compiled']);p=read(compiled/'plan.json');abi=read(compiled/'abi.json');meta=read(compiled/'hardware/compile.json')
    assert meta['status']=='compiled' and meta['elf_sha256']==identity(meta['elf_path'])['sha256']
    assert p['program_graph_id']==side['graph_id'] and side['candidate_id']==identity(side['source']['path'])['sha256']
    assert read(verify(side['graph']))==p['program_graph']
    return dict(graph_id=p['program_graph_id'],plan_id=p['plan_id'],artifact_sha256=meta['elf_sha256']),p,abi


def independent_copy_reference(case,inputs):
    text=verify(case['source']).read_text();fixture=read(verify(case['fixture']))['fixture'];kind=fixture['kind'];assert not re.search(r'\barith\.(?!constant)\w+',text),'all-copy source contains arithmetic'
    loads=re.findall(r'(%[\w.$]+)\s*=\s*affine.load\s+(%[\w.$]+)\[([^\]]+)\]',text)
    stores=re.findall(r'affine.store\s+(%[\w.$]+),\s*(%[\w.$]+)\[([^\]]+)\]',text)
    assert all(any(s[0]==l[0] for l in loads) for s in stores),'output store is not an actual loaded copy'
    a=inputs['A'];assert a.dtype==np.float32 and np.isfinite(a).all()
    if kind=='broadcast':
        assert len(loads)==len(stores)==1 and re.search(r'\[0,\s*%[\w.$]+\]',text)
        m,n=fixture['m'],fixture['n'];assert list(a.shape)==[1,n]
        return dict(C=np.broadcast_to(a,(m,n)).copy())
    assert kind=='fanout' and len(loads)==len(stores)==3
    assert a.shape==(fixture['m'],fixture['n'])
    return dict(B=a.copy(),C=a.copy())


def bound_measurements(pair,facts,root):
    """Validate one two-context pair process and return untouched hot pairs.

    facts is a serialized native GenericProgramContrastFacts object. This audits
    its quantities against actual plan/ABI and uses no inferred timing quantity.
    """
    root=Path(root);protocol=read(root/'protocol.json');summary=read(root/'summary.json');runtime=read(root/'runtime.json')
    assert summary['status']=='passed' and runtime['active_contexts']==2 and runtime['poll_us']==protocol['poll_us']
    assert len(protocol['cases'])==2 and len({c['id'] for c in protocol['cases']})==2
    sides={side:plan_side(pair[side]) for side in ['baseline','candidate']}
    case_by_side={}
    for side,(ident,p,abi) in sides.items():
        row=facts[side];assert row['graph_id']==ident['graph_id'] and row['plan_id']==ident['plan_id']
        matching=[c for c in protocol['cases'] if c['elf']['sha256']==ident['artifact_sha256'] and c['plan']['sha256']==identity(Path(pair[side]['compiled'])/'plan.json')['sha256']]
        assert len(matching)==1,'protocol package differs from native contrast side';case_by_side[side]=matching[0]
        q=row['quantities'];assert q['requested_dma_bytes']==p['actual_dma_bytes']
        assert q['hardware_stage_count']==(len(p['hardware_stages']) if p['strategy']=='serial-tiled' else 1)
        assert q['abi_to_sync_calls']==len(abi['buffers']) and q['abi_from_sync_calls']==len(abi['outputs'])
        assert q['abi_to_requested_bytes']==sum(int(np.prod(b['shape']))*4 for b in abi['buffers'])
        assert q['abi_from_requested_bytes']==sum(int(np.prod(b['shape']))*4 for b in abi['buffers'] if b['name'] in abi['outputs'])
    assert facts['supported'] and facts['change_class']==pair['change_class']
    assert facts['baseline']['body_fingerprint']==facts['candidate']['body_fingerprint']
    assert all(facts['delta_quantities'][k]==facts['candidate']['quantities'][k]-v for k,v in facts['baseline']['quantities'].items())
    case_side={c['id']:side for side,c in case_by_side.items()};seen=set();paired=defaultdict(dict);numerics=[]
    for line in (root/'samples.jsonl').read_text().splitlines():
        s=json.loads(line);assert s['case'] in case_side;side=case_side[s['case']];case=case_by_side[side];assert s['case_identity']==case
        key=(side,s['seed'],s['repeat']);assert key not in seen;seen.add(key)
        assert s['warmup']==(s['repeat']<protocol['warmups'])
        for field in ['source','fixture','elf','plan','abi','compile','transformed','aie']:verify(case[field])
        with np.load(verify(s['inputs']),allow_pickle=False) as z:inputs={k:z[k].copy() for k in z.files}
        expected=independent_copy_reference(case,inputs)
        with np.load(verify(s['outputs']),allow_pickle=False) as z:assert set(z.files)==set(expected) and all(np.array_equal(z[k],v) for k,v in expected.items())
        with np.load(verify(s['reference']),allow_pickle=False) as z:assert set(z.files)==set(expected) and all(np.array_equal(z[k],v) for k,v in expected.items())
        with np.load(verify(s['reference_f64']),allow_pickle=False) as z:assert set(z.files)==set(expected) and all(np.array_equal(z[k],v.astype(np.float64)) for k,v in expected.items())
        events=s['events'];start=[e for e in events if e['kind']=='actual_xrt_start'];wait=[e for e in events if e['kind']=='actual_xrt_wait'];syncs=[e for e in events if e['kind']=='actual_bo_sync'];assert len(start)==len(wait)==1
        assert s['dispatch_to_wait_end_ns']==wait[0]['end_ns']-start[0]['start_ns']
        assert s['sync_subtotal_ns']==sum(e['end_ns']-e['start_ns'] for e in syncs)
        assert s['runner_wall_ns']==s['dispatch_to_wait_end_ns']+s['sync_subtotal_ns']+s['other_runner_ns']
        q=facts[side]['quantities'];assert len(syncs)==q['abi_to_sync_calls']+q['abi_from_sync_calls']
        input_digest=hashlib.sha256(b''.join(k.encode()+inputs[k].tobytes() for k in sorted(inputs))).hexdigest()
        paired[s['seed'],s['repeat']][side]=dict(sample=s,input_digest=input_digest)
        numerics.append(dict(side=side,seed=s['seed'],repeat=s['repeat'],outputs=s['outputs'],exact_copy=True))
    expected={(side,seed,r) for side in ['baseline','candidate'] for seed in protocol['seeds'] for r in range(protocol['warmups']+protocol['repeats'])};assert seen==expected and len(seen)==summary['samples']==summary['actual_submissions']
    observations=[];all_pairs=[]
    for (seed,repeat),members in sorted(paired.items()):
        assert set(members)=={'baseline','candidate'} and members['baseline']['input_digest']==members['candidate']['input_digest'],'paired plans used different inputs'
        l,r=members['baseline']['sample'],members['candidate']['sample']
        all_pairs.append(dict(seed=seed,repeat=repeat,warmup=repeat<protocol['warmups'],baseline_ns=l['runner_wall_ns'],candidate_ns=r['runner_wall_ns']))
        if repeat<protocol['warmups']:continue
        delta={k:r[k]-l[k] for k in ['runner_wall_ns','dispatch_to_wait_end_ns','sync_subtotal_ns','other_runner_ns']}
        observations.append(dict(seed=seed,repeat=repeat,delta_ns=delta['runner_wall_ns'],parts=delta,baseline_ns=l['runner_wall_ns'],candidate_ns=r['runner_wall_ns']))
    return dict(pair_id=pair['pair_id'],change_class=facts['change_class'],protocol=identity(root/'protocol.json'),raw_samples=identity(root/'samples.jsonl'),runtime=identity(root/'runtime.json'),observations=observations,all_pairs=all_pairs,numerical_checks=numerics,baseline=sides['baseline'][0],candidate=sides['candidate'][0],scope='Exact source-validated all-copy outputs; host paired envelope, not device DMA time.')
