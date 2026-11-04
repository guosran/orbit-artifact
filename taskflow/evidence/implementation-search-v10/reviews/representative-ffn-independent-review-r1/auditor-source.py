#!/usr/bin/env python3
"""Independently audit raw profiling NPZs and summarize host/static evidence.

Never imports a runtime, compiles or opens a device. Stage diagnostics and
host-only timelines are not on-device stage timers or hardware traces.
"""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import numpy as np


def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def read(path,identities):
    identities[str(path.resolve())]=sha(path)
    return json.loads(path.read_text())
def describe(values):
    x=np.asarray(values,dtype=np.float64)
    if not x.size:return dict(n=0)
    return dict(n=int(x.size),min=float(x.min()),q25=float(np.percentile(x,25)),median=float(np.median(x)),mean=float(x.mean()),q75=float(np.percentile(x,75)),max=float(x.max()),sample_std=float(x.std(ddof=1)) if x.size>1 else None)

def numeric(actual,reference):
    if actual.shape!=reference.shape or actual.dtype!=np.float32 or reference.dtype!=np.float32:
        raise ValueError('shape/FP32 mismatch')
    finite=bool(np.isfinite(actual).all() and np.isfinite(reference).all())
    if not finite:return dict(passed=False,finite=False)
    delta=np.abs(actual.astype(np.float64)-reference.astype(np.float64));normal=np.abs(reference)>=1e-6
    return dict(passed=bool(np.allclose(actual,reference,atol=1e-5,rtol=1e-5)),finite=True,
        shape=list(actual.shape),max_abs=float(delta.max()),normalized_l2=float(np.linalg.norm(delta)/max(np.linalg.norm(reference.astype(np.float64)),1e-30)),
        max_relative_reference_at_least_1e_minus6=float((delta[normal]/np.abs(reference[normal])).max()) if normal.any() else None,
        near_zero_max_abs=float(delta[~normal].max()) if (~normal).any() else None)


def host_parts(sample):
    totals={}
    for event in sample['events']:
        assert event['end_ns']>=event['start_ns']>=0
        key=event['kind']
        if key=='bo_sync':key+='_'+('to_device' if 'TO_DEVICE' in event['direction'] else 'from_device')
        totals[key]=totals.get(key,0)+(event['end_ns']-event['start_ns'])/1e6
    if not sample['events']:
        return dict(wait_ms=None,host_or_runtime_nonwait_ms=None,observer_record_ms=None,scope='minimal mode only whole host wall observed')
    assert sum(e['kind']=='xrt_start' for e in sample['events'])==sum(e['kind']=='xrt_wait' for e in sample['events'])==1
    runner_inner=sum(v for k,v in totals.items() if k not in ['host_prepare','host_output_copy','runner_run'])
    return dict(wait_ms=totals.get('xrt_wait',0),host_or_runtime_nonwait_ms=sample['wall_ms']-totals.get('xrt_wait',0),
        runner_unseparated_residual_ms=totals.get('runner_run',0)-runner_inner,observer_record_ms=sample['observer_record_ms'],
        observed_spans_ms=totals,scope='host API durations; runner span nests inner leaves; wait is runtime/device/polling combined, no device cycles')


def audit_profile(directory,identities):
    invocation=read(directory/'invocation.json',identities);names=list(invocation['identities']);all_samples=[];checks=[];loads=[]
    argv=invocation['argv']
    def option(name,default):
        for i,arg in enumerate(argv):
            if arg==name:return int(argv[i+1])
            if arg.startswith(name+'='):return int(arg.split('=',1)[1])
        return default
    warmups=option('--warmups',2);iterations=option('--iterations',3)
    source=directory/'profiler-source.py'
    assert sha(source)==invocation['script_sha256'];identities[str(source.resolve())]=sha(source)
    for case,identity in invocation['identities'].items():
        elf=identity.get('compile_record',{}).get('elf_path')
        if elf and Path(elf).exists():assert sha(Path(elf))==identity['elf_sha256']
        assert sha(Path(identity['abi_path']))==identity['abi_sha256']
    for seed in sorted(directory.glob('seed-*')):
        result=read(seed/'result.json',identities);provenance=read(seed/'input-identities.json',identities);loads.append(dict(seed=seed.name,load_ms=result['load_ms']))
        references={}
        for name in names:
            ip=seed/(name+'-inputs.npz');rp=seed/(name+'-reference.npz')
            assert sha(ip)==provenance[name]['inputs_sha256'] and sha(rp)==provenance[name]['reference_sha256']
            references[name]=dict(np.load(rp));identities[str(rp.resolve())]=sha(rp)
        samples=result['samples'];repeats=len(samples)//len(names);assert len(samples)==repeats*len(names)
        assert repeats==warmups+iterations
        expected_order=[(name,repeat) for repeat in range(repeats) for name in (names if repeat%2==0 else list(reversed(names)))]
        assert [(s['candidate'],s['repeat']) for s in samples]==expected_order
        for sample in samples:
            name=sample['candidate'];repeat=sample['repeat'];assert sample['warmup']==(repeat<warmups)
            path=seed/f'{name}-{repeat}.npz';actual=dict(np.load(path));reference=references[name]
            assert set(actual)==set(reference)
            for key,value in actual.items():checks.append(dict(seed=seed.name,candidate=name,repeat=repeat,warmup=sample['warmup'],output=key,output_sha256=sha(path),**numeric(value,reference[key])))
            all_samples.append(dict(seed=seed.name,candidate=name,repeat=repeat,warmup=sample['warmup'],wall_ms=sample['wall_ms'],**host_parts(sample)))
        for name in names:
            hot=[s['wall_ms'] for s in samples if s['candidate']==name and not s['warmup']]
            assert hot and float(np.median(hot))==result['hot_median_ms'][name]
    candidates={name:dict(hot_wall_ms=describe([s['wall_ms'] for s in all_samples if s['candidate']==name and not s['warmup']]),hot_wait_ms=describe([s['wait_ms'] for s in all_samples if s['candidate']==name and not s['warmup'] and s['wait_ms'] is not None]),elf_sha256=invocation['identities'][name]['elf_sha256']) for name in names}
    for name,value in candidates.items():
        valid=all(c['passed'] for c in checks if c['candidate']==name)
        value['numerical_passed']=valid
        value['numeric_gate_passed']=valid
        value['cost_model_eligibility']='not decided by numerical audit; requires target support, operation coverage and frozen train/holdout policy'
        value['hot_nonwait_ms']=describe([s['host_or_runtime_nonwait_ms'] for s in all_samples if s['candidate']==name and not s['warmup'] and s['host_or_runtime_nonwait_ms'] is not None])
    sums=[]
    for seed in sorted({s['seed'] for s in all_samples}):
        for repeat in sorted({s['repeat'] for s in all_samples if s['seed']==seed}):
            group={s['candidate'].rsplit('-',1)[-1]:s for s in all_samples if s['seed']==seed and s['repeat']==repeat}
            if all(stage in group for stage in ['gate','up','activation','down','full']):
                total=sum(group[stage]['wall_ms'] for stage in ['gate','up','activation','down'])
                sums.append(dict(seed=seed,repeat=repeat,warmup=group['full']['warmup'],sum_independent_stages_ms=total,full_wall_ms=group['full']['wall_ms'],stages_minus_full_ms=total-group['full']['wall_ms'],scope='independently compiled complete stage mains and contexts; not a decomposition of the full ELF device execution'))
    pairs=[]
    if len(names)==2:
        for seed in sorted({s['seed'] for s in all_samples}):
            for repeat in sorted({s['repeat'] for s in all_samples if s['seed']==seed}):
                group={s['candidate']:s for s in all_samples if s['seed']==seed and s['repeat']==repeat}
                pairs.append(dict(seed=seed,repeat=repeat,warmup=group[names[0]]['warmup'],second_minus_first_ms=group[names[1]]['wall_ms']-group[names[0]]['wall_ms']))
    throughput=[]
    for name,value in candidates.items():
        match=re.fullmatch(r'm(\d+)-(full|gate|up|down)',name)
        if match:
            m=int(match[1]);macs=(3 if match[2]=='full' else 1)*m*2048*11008;ms=value['hot_wall_ms']['median']
            throughput.append(dict(candidate=name,M=m,MACs=macs,FLOPs=2*macs,hot_wall_ms=ms,MAC_per_second=macs/(ms/1000),GFLOP_per_second=2*macs/(ms/1000)/1e9,scope='arithmetic count excludes activation; observed wall includes host/whole program overhead, not peak core throughput'))
    control_pairs=[]
    for name in names:
        if not name.endswith('-grouped'):continue
        split_name=name[:-len('grouped')]+'split'
        if split_name not in names:continue
        differences=[]
        for sample in all_samples:
            if sample['candidate']!=name or sample['warmup']:continue
            other=next(s for s in all_samples if s['seed']==sample['seed'] and s['repeat']==sample['repeat'] and s['candidate']==split_name)
            differences.append(other['wall_ms']-sample['wall_ms'])
        control_pairs.append(dict(grouped=name,split=split_name,both_numerically_valid=candidates[name]['numerical_passed'] and candidates[split_name]['numerical_passed'],split_minus_grouped_hot_ms=describe(differences)))
    evidence=read(directory/'evidence-costs.json',identities) if (directory/'evidence-costs.json').exists() else None
    return dict(status='passed' if checks and all(c['passed'] for c in checks) else 'numeric_failed',profile=directory.name,
        observer=invocation['observer'],seed_count=len(loads),output_checks=len(checks),checks=checks,samples=all_samples,candidates=candidates,
        context_loads=loads,control_pairs=control_pairs,sum_stages_vs_full=sums,throughput=throughput,paired_differences=pairs,paired_hot_difference_ms=describe([p['second_minus_first_ms'] for p in pairs if not p['warmup']]),
        evidence_costs=evidence,scope='profiling sample counts only; not automatically three-seed acceptance')


def audit_marked_trace(directory,identities):
    """CPU audit of the explicitly instrumented single-core GEMM window only."""
    identity=read(directory/'identity.json',identities)
    reference_paths=[Path(p) for p in identity['inputs'] if '/reference-' in p]
    assert len(reference_paths)==1
    reference_path=reference_paths[0]
    assert sha(reference_path)==identity['inputs'][str(reference_path)]
    values=dict(np.load(reference_path));assert len(values)==1;reference=next(iter(values.values()))
    checks=[]
    samples=read(directory/'samples.json',identities)
    for sample in samples:
        path=directory/f"{sample['mode']}-output-{sample['repeat']}.npy"
        checks.append(dict(mode=sample['mode'],repeat=sample['repeat'],sha256=sha(path),**numeric(np.load(path),reference)))
    compiled=read(directory/'compiled-identities.json',identities)
    for item in compiled.values():assert sha(Path(item['elf']))==item['elf_sha256']
    trace=directory/'trace';events=read(trace/'trace.cycles.json',identities);manifest=read(trace/'manifest.json',identities)
    saved_markers=read(trace/'marker-audit.json',identities)
    starts=[e for e in events if e.get('name')=='INSTR_EVENT_0' and e.get('ph')=='B']
    ends=[e for e in events if e.get('name')=='INSTR_EVENT_1' and e.get('ph')=='B']
    assert len(starts)==len(ends)==1 and starts[0]['ts']<ends[0]['ts']
    assert starts==saved_markers['markers']['INSTR_EVENT_0'] and ends==saved_markers['markers']['INSTR_EVENT_1']
    lower,upper=starts[0]['ts'],ends[0]['ts']
    def counts(subset):return dict(Counter(e['name']+':'+e.get('ph','') for e in subset))
    inside=[e for e in events if lower<=e.get('ts',-1)<=upper]
    vector_begins=[e for e in inside if e['name']=='INSTR_VECTOR' and e.get('ph')=='B']
    vector_ends=[e for e in inside if e['name']=='INSTR_VECTOR' and e.get('ph')=='E']
    assert len(vector_begins)==len(vector_ends)==1024
    assert all(a['ts']<=b['ts'] for a,b in zip(vector_begins,vector_ends))
    raw_path=trace/'trace.uint32.npy';identities[str(raw_path.resolve())]=sha(raw_path);raw=np.load(raw_path);nonzero=np.flatnonzero(raw)
    assert len(nonzero)==manifest['nonzero_words'] and len(events)==manifest['event_count']
    physical=trace/'physical.mlir';identities[str(physical.resolve())]=sha(physical);text=physical.read_text()
    assert text.count('aie.event(0)')==text.count('aie.event(1)')==1
    return dict(status='passed' if all(c['passed'] for c in checks) else 'numeric_failed',output_checks=checks,
        ordered_single_marker_pair=True,entry_device_cycles=lower,exit_device_cycles=upper,bracket_device_cycles=upper-lower,
        total_decoded_event_counts=counts(events),inside_inclusive_event_counts=counts(inside),
        before_event_counts=counts([e for e in events if 0<=e.get('ts',-1)<lower]),after_event_counts=counts([e for e in events if e.get('ts',-1)>upper]),
        raw_words=int(raw.size),raw_nonzero_words=int(nonzero.size),first_nonzero_word=int(nonzero[0]),last_nonzero_word=int(nonzero[-1]),zero_suffix_words=int(raw.size-nonzero[-1]-1),
        scope='one instrumented 1x64x16 GEMM compute-core interval; source marker0 follows input lock acquisition and initializer, marker1 precedes output lock releases; an acquire request is observed at the same cycle as marker0',
        limitations=['No hardware overflow counter or calibrated physical frequency; zero suffix does not prove absence of overflow','1024 paired vector-event intervals lie inside the bracket; event counts are not a semantic proof or a measured FLOP counter','TRUE remains open; only the explicitly bounded marker interval has a paired-boundary coverage check','Original generic manifest scope_markers text says no markers emitted; this is stale for the instrumented derivative, contradicted by saved physical.mlir and actual decoded ordered pair; original bytes preserved','No extrapolation of these device cycles to FFN, other shapes, other cores or total kernel wall time'])


def original_summary(directory,identities):
    audit=read(directory/'independent-audit.json',identities);assert audit['status']=='passed' and audit['full_outputs_checked']==3
    compile=read(directory/'extent8/compile.json',identities);assert sha(directory/'extent8/program.elf')==compile['elf_sha256']
    compiler=read(directory/'compiler-identity.json',identities);rows=[];calls=[]
    for path in sorted(directory.glob('seed-*/result.json')):
        r=read(path,identities);sample=r['samples'][0];assert len(r['samples'])==1 and len(sample['invocations'])==16
        totals={}
        for call in sample['invocations']:
            events=call['api_events'];parts={}
            for event in events:
                k=event['kind']
                if k=='actual_bo_sync':k+='_'+('to_device' if 'TO_DEVICE' in event['direction'] else 'from_device')
                parts[k]=parts.get(k,0)+(event['end_ns']-event['start_ns'])/1e6
            for k,v in parts.items():totals[k]=totals.get(k,0)+v
            calls.append(dict(seed=path.parent.name,index=call['index'],wall_ms=call['wall_ms'],observed_spans_ms=parts,non_api_residual_ms=call['wall_ms']-sum(parts.values())))
        macs=3*128*2048*11008;wall=sample['wall_ms'];rows.append(dict(seed=path.parent.name,load_ms=r['load_ms'],wall_ms=wall,observed_spans_ms=totals,non_api_residual_ms=wall-sum(totals.values()),between_calls_residual_ms=wall-sum(c['wall_ms'] for c in sample['invocations']),MACs=macs,FLOPs=2*macs,GFLOP_per_second=2*macs/(wall/1000)/1e9))
    return dict(status='passed-existing-independent-audit-reused',full_outputs_checked=3,compiler=compiler,elf_sha256=compile['elf_sha256'],compile_seconds=compile['seconds'],seeds=rows,calls=calls,m8_call_wall_ms=describe([c['wall_ms'] for c in calls]),
        boundary='original full program wall includes16 calls+per-call checkpoint/parts writes; wait observer starts before its wait-in-progress checkpoint, so wait is not pure kernel time; no activation FLOPs counted')


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--root',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--original-m128',type=Path);p.add_argument('--profile',action='append',default=[]);a=p.parse_args()
    output=a.output.resolve();output.mkdir(parents=True,exist_ok=False)
    (output/'auditor-source.py').write_bytes(Path(__file__).read_bytes())
    identities={str(Path(__file__).resolve()):sha(Path(__file__))}
    names=a.profile or ['profile-m1-r1','profile-m5-r1','profile-m8-r1','profile-residency-detailed-r1','profile-residency-minimal-r1','profile-controls-train-r1','profile-controls-r3-train-r1']
    reports=[];missing=[]
    for name in names:
        directory=a.root/name
        if not (directory/'results.json').exists():missing.append(name);continue
        report=audit_profile(directory,identities);reports.append(report);(output/(name+'.json')).write_text(json.dumps(report,indent=2)+'\n')
    original=original_summary(a.original_m128,identities) if a.original_m128 else None
    if original:(output/'original-m128.json').write_text(json.dumps(original,indent=2)+'\n')
    equivalence=None
    for r in reports:
        if 'm8-full' in r['candidates'] and original:
            equivalence=dict(current_m8_full_elf=r['candidates']['m8-full']['elf_sha256'],original_m128_extent8_elf=original['elf_sha256'],byte_identical=r['candidates']['m8-full']['elf_sha256']==original['elf_sha256'],scope='ELF byte identity only; AIR metadata/source hashes can differ; historical source/metadata not rewritten')
    observer_effect=[]
    detailed=next((r for r in reports if r['profile']=='profile-residency-detailed-r1'),None)
    minimal=next((r for r in reports if r['profile']=='profile-residency-minimal-r1'),None)
    if detailed and minimal:
        for name in detailed['candidates']:
            d=detailed['candidates'][name]['hot_wall_ms'];m=minimal['candidates'][name]['hot_wall_ms']
            observer_effect.append(dict(candidate=name,detailed_hot_ms=d,minimal_hot_ms=m,detailed_minus_minimal_median_ms=d['median']-m['median'],scope='separate runs, not randomized matched observer experiment; no exact overhead subtraction or causal attribution'))
    for relative in ['device-before.json','device-before.log','packet-trace-marked-r1/summary.json','packet-trace-marked-r1/trace/marker-audit.json']:
        path=a.root/relative
        if path.is_file():identities[str(path.resolve())]=sha(path)
    marked_trace=None
    if (a.root/'packet-trace-marked-r2/trace/marker-audit.json').is_file():
        marked_trace=audit_marked_trace(a.root/'packet-trace-marked-r2',identities)
        (output/'marked-trace-r2.json').write_text(json.dumps(marked_trace,indent=2)+'\n')
    summary=dict(status='passed' if reports and not missing and all(r['status']=='passed' for r in reports) and (marked_trace is None or marked_trace['status']=='passed') else 'incomplete-or-failed',profiles=[dict(profile=r['profile'],status=r['status'],output_checks=r['output_checks'],candidates=r['candidates'],throughput=r['throughput']) for r in reports],missing=missing,m8_elf_equivalence=equivalence,observer_effect_descriptive=observer_effect,marked_trace=marked_trace,
        clocks='device power mode reported Default; frequency not locked or sampled per invocation; electrical sensor IOCTL unsupported, no inferred power/energy',
        excluded_trace='packet-trace-marked-r1 numeric_failed and marker-order failure retained as diagnostic only; no trace fragment is used to attribute total kernel time',device_submissions=0,compilation=False)
    (output/'summary.json').write_text(json.dumps(summary,indent=2)+'\n');(output/'source-identities.json').write_text(json.dumps(identities,indent=2)+'\n');print(json.dumps(dict(status=summary['status'],profiles=len(reports),raw_output_checks=sum(r['output_checks'] for r in reports),m8_elf_equivalence=equivalence)))
    return 0 if summary['status']=='passed' else 1


if __name__=='__main__':raise SystemExit(main())
