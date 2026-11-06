#!/usr/bin/env python3
"""Independent CPU audit of v15 source, static DMA descriptors and raw outputs.

No fitted coefficients, device execution, baseline subtraction or inferred DDR
traffic. Submit-to-wait-return remains a DMA+compute+stalls+runtime composite.
"""
import argparse
from collections import defaultdict
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys
import numpy as np


def read(p):return json.loads(Path(p).read_text())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def ident(p):return {'path':str(Path(p).resolve()),'sha256':sha(p)}
def verify(x):
    p=Path(x['path']);assert sha(p)==x['sha256'],f'changed evidence {p}'
    return p

def stats(a):
    x=np.asarray(a,dtype=float);assert x.size and np.isfinite(x).all()
    m=float(np.median(x));mad=float(np.median(abs(x-m)))
    return {'n':len(x),'median_ns':m,'mad_ns':mad,'p5_ns':float(np.percentile(x,5)),
        'p95_ns':float(np.percentile(x,95)),'max_ns':float(max(x)),
        'above_median_plus_6mad':int(np.sum(x>m+6*max(1,mad)))}

def source_contract(path,elements,adds):
    text=Path(path).read_text()
    loads=re.findall(r'(%[\w.$]+)\s*=\s*affine.load\s+(%[\w.$]+)\[([^\]]+)\]',text)
    stores=re.findall(r'affine.store\s+(%[\w.$]+),\s*(%[\w.$]+)\[([^\]]+)\]',text)
    loops=re.findall(r'affine.for\s+(%[\w.$]+)\s*=\s*0\s+to\s+(\d+)\s*\{',text)
    assert len(loads)==len(stores)==1 and len(loops)==2
    assert [int(v) for _,v in loops]==[1,elements]
    indices=[name for name,_ in loops]
    assert [v.strip() for v in loads[0][2].split(',')]==indices
    assert [v.strip() for v in stores[0][2].split(',')]==indices
    constants={m[1]:float(m[2]) for m in re.finditer(r'(%[\w.$]+)\s*=\s*arith.constant\s+([-+0-9.eE]+)\s*:\s*f32',text)}
    operations=[(m[1],m[2],m[3]) for m in re.finditer(r'(%[\w.$]+)\s*=\s*arith.addf\s+(%[\w.$]+),\s*(%[\w.$]+)\s*:\s*f32',text)]
    assert len(operations)==adds and set(re.findall(r'\barith\.(\w+)',text))<= {'constant','addf'}
    current=loads[0][0];ordered=[]
    for dest,left,right in operations:
        assert left==current and right in constants,'unsupported source expression: reference requires actual dependent add chain'
        ordered.append(constants[right]);current=dest
    assert stores[0][0]==current,'source store differs from the copied/added value'
    assert len(re.findall(r'\btaskflow.task\b',text))==1
    return {'input_value':loads[0][0],'source_order_constants':ordered,'loop_extents':[1,elements],
        'source':ident(path),'scope':'narrow independent source fixture validator; not a production parser/planner'}

def references(value,constants):
    exact=value.astype(np.float64);strict=value.copy()
    for constant in constants:
        c=np.float32(constant);strict=(strict.astype(np.float64)+float(c)).astype(np.float32);exact=exact+float(c)
    return strict,exact

def metrics(a,ref):
    delta=a.astype(np.float64)-ref.astype(np.float64);assert a.shape==ref.shape
    finite=bool(np.isfinite(a).all() and np.isfinite(ref).all())
    return {'passed':finite and bool(np.all(abs(delta)<=1e-5+1e-5*abs(ref))),
        'max_abs':float(np.max(abs(delta))),'relative_floor_1e-6':float(np.max(abs(delta)/np.maximum(abs(ref),1e-6))),
        'normalized_l2':float(np.linalg.norm(delta)/max(np.linalg.norm(ref),1e-30))}

def analyze(root,out):
    assert not out.exists();protocol=read(root/'protocol.json');identity=read(root/'identity.json');summary=read(root/'summary.json')
    assert summary['status']=='passed' and identity['protocol']['sha256']==sha(root/'protocol.json')
    assert identity['source_sha256']==sha(root/'runner-source.py')==summary['source_sha256']
    assert identity['cases']==protocol['cases']
    runtime=read(root/'runtime.json');assert runtime['active_contexts']==len(protocol['cases'])
    out.mkdir(parents=True);(out/'analyzer-source.py').write_bytes(Path(__file__).read_bytes())
    cases={c['id']:c for c in protocol['cases']};contracts={};static=[]
    runtime_auditor=Path(__file__).resolve().parents[1]/'TaskflowAIR/audit_runtime_transfers_v7.py'
    for case,c in cases.items():
        f=c['fixture'];artifact=read(verify(c['artifact']));abi=read(verify(c['abi']));plan=read(verify(c['plan']));source=verify(c['source'])
        assert sha(artifact['elf_path'])==artifact['elf_sha256']
        for physical in c['aie']:verify(physical)
        contracts[case]=source_contract(source,f['elements'],f['adds'])
        n=f['elements']//f['chunk'];assert f['elements']%f['chunk']==0
        expected=[('A','host_to_l1',4*f['elements'],n),('C','l1_to_host',4*f['elements'],n)]
        assert sorted((x['storage'],x['direction'],x['bytes'],x['count']) for x in plan['transfer_summary'])==expected
        assert plan['actual_dma_bytes']==8*f['elements'] and plan['transfer_count']==2*n and plan['phase_count']==n
        report=out/(case+'-static-runtime.json')
        cmd=[sys.executable,str(runtime_auditor),str(Path(artifact['elf_path']).parent),'--plan',str(c['plan']['path']),'--abi',str(c['abi']['path']),'--output',str(report)]
        completed=subprocess.run(cmd,capture_output=True,text=True)
        (out/(case+'-static-command.json')).write_text(json.dumps({'argv':cmd,'returncode':completed.returncode,'stdout':completed.stdout,'stderr':completed.stderr},indent=2)+'\n')
        assert completed.returncode==0 and read(report)['status']=='passed','static generated runtime DMA ledger mismatch'
        prep=read(root/('preparation-'+case+'.json'))
        assert prep['successful_constructor']
        assert prep['runtime_abi_proof']['logical_argument_count']==2
        for proof in prep['bound_pointer_proof']:
            assert proof['mapped_address']==proof['array_address'] and proof['bytes']==proof['actual_bo_extent']==4*f['elements']
        static.append({'case':case,'fixture':f,'source_contract':contracts[case],
            'native_input_bytes':4*f['elements'],'native_output_bytes':4*f['elements'],'native_segments_each_direction':n,
            'generated_runtime_descriptor_audit':ident(report),'plan':c['plan'],'ABI':c['abi'],'ELF':ident(artifact['elf_path']),
            'static_scope':'native tile/copy counts and final runtime BD-length×repeat sums; runtime may coalesce logical tiles, not measured transaction count/traffic'})
    expected={(case,seed,repeat) for case in cases for seed in protocol['seeds'] for repeat in range(protocol['warmups']+protocol['repeats'])}
    seen=set();groups=defaultdict(list);paired=defaultdict(dict);numeric=[];time_observations=[];maxerror=0;waitidentities=set()
    for line in (root/'samples.jsonl').read_text().splitlines():
        s=json.loads(line);case=s['case'];c=cases[case];key=(case,s['seed'],s['repeat']);assert key in expected and key not in seen;seen.add(key)
        assert s['warmup']==(s['repeat']<protocol['warmups']) and s['observer']==protocol['observer']
        assert s['case_identity_sha256']==hashlib.sha256(json.dumps(c,sort_keys=True,separators=(',',':')).encode()).hexdigest()
        with np.load(verify(s['inputs']),allow_pickle=False) as z:
            assert z.files==['A'];value=z['A'].copy();assert value.dtype==np.float32 and list(value.shape)==[1,c['fixture']['elements']]
        strict,exact=references(value,contracts[case]['source_order_constants'])
        with np.load(verify(s['reference']),allow_pickle=False) as z:assert z.files==['C'] and np.array_equal(z['C'],strict),'saved strict reference differs from actual source order'
        with np.load(verify(s['reference_f64']),allow_pickle=False) as z:assert z.files==['C'] and np.array_equal(z['C'],exact),'saved f64 reference differs from independently parsed source'
        with np.load(verify(s['outputs']),allow_pickle=False) as z:assert z.files==['C'];actual=z['C'].copy();assert actual.dtype==np.float32
        checks={'strict_f32_source_order':metrics(actual,strict),'unrounded_f64':metrics(actual,exact)}
        assert checks['strict_f32_source_order']['passed'],'independent strict numerical failure'
        if c['fixture']['adds']==0:assert np.array_equal(actual,value),'copy fixture must preserve every input element exactly'
        maxerror=max(maxerror,checks['unrounded_f64']['max_abs']);numeric.append({'case':case,'seed':s['seed'],'repeat':s['repeat'],'output':s['outputs'],'checks':checks})
        ev=s['events'];starts=[e for e in ev if e['kind']=='actual_xrt_start'];waits=[e for e in ev if e['kind']=='actual_xrt_wait'];syncs=[e for e in ev if e['kind']=='actual_bo_sync']
        assert len(starts)==len(waits)==1 and len(syncs)==3 and len(ev)==5
        assert [e['buffer_index'] for e in syncs]==[0,1,1]
        assert all('TO_DEVICE' in e['direction'] for e in syncs[:2]) and 'FROM_DEVICE' in syncs[2]['direction']
        assert syncs[0]['end_ns']<=syncs[1]['start_ns']<=syncs[1]['end_ns']<=starts[0]['start_ns']
        assert starts[0]['end_ns']<=waits[0]['start_ns']<=waits[0]['end_ns']<=syncs[2]['start_ns']
        duration=lambda e:e['end_ns']-e['start_ns']
        assert all(duration(e)>=0 for e in ev)
        composite=waits[0]['end_ns']-starts[0]['start_ns'];assert composite==s['dispatch_to_wait_end_ns']
        parts={'runner_wall_ns':s['runner_wall_ns'],'dispatch_to_wait_end_ns':composite,
            'start_ns':duration(starts[0]),'wait_ns':duration(waits[0]),'input_TO_ns':duration(syncs[0]),
            'output_poison_TO_ns':duration(syncs[1]),'output_FROM_ns':duration(syncs[2]),
            'start_to_wait_gap_ns':waits[0]['start_ns']-starts[0]['end_ns']}
        parts['host_other_gaps_ns']=s['runner_wall_ns']-sum(duration(e) for e in ev);assert parts['host_other_gaps_ns']>=0
        time_observations.append({'case':case,'seed':s['seed'],'repeat':s['repeat'],'warmup':s['warmup'],'parts':parts,'source_JSONL_record_sha256':hashlib.sha256(line.encode()).hexdigest()})
        waitidentities.add(json.dumps(s['selected_wait_backend'],sort_keys=True))
        if not s['warmup']:
            groups[case].append((s['seed'],parts))
            pairkey=(c['fixture']['elements'],c['fixture']['adds'],s['seed'],s['repeat'])
            paired[pairkey][case]={'parts':parts,'input_array_sha256':hashlib.sha256(value.tobytes()).hexdigest(),'chunk':c['fixture']['chunk']}
    assert seen==expected and len(seen)==summary['samples']==summary['actual_submissions']
    distributions=[]
    for case,records in groups.items():
        distributions.append({'case':case,'fixture':cases[case]['fixture'],'parts':{part:stats([x[part] for _,x in records]) for part in records[0][1]},
            'by_seed':{str(seed):{part:stats([x[part] for se,x in records if se==seed]) for part in records[0][1]} for seed in protocol['seeds']}})
    comparisons=defaultdict(list)
    for key,records in paired.items():
        names=sorted(records,key=lambda k:(records[k]['chunk'],k))
        for i,left in enumerate(names):
            for right in names[i+1:]:
                assert records[left]['input_array_sha256']==records[right]['input_array_sha256'],'matched size/repeat cases must consume same input values'
                comparisons[(left,right)].append(records[right]['parts']['dispatch_to_wait_end_ns']-records[left]['parts']['dispatch_to_wait_end_ns'])
    pairs=[{'left':l,'right':r,'right_minus_left_composite_ns':stats(v),
        'scope':'paired observed composite difference only; not isolated DMA or baseline-subtracted transfer latency'} for (l,r),v in comparisons.items()]
    result={'schema':'orbit.device-transfer.independent-analysis.v15','status':'passed','profile':ident(root/'summary.json'),
        'protocol':ident(root/'protocol.json'),'measurement_runner_source':ident(root/'runner-source.py'),
        'analyzer_source':ident(__file__),'runtime_auditor':ident(runtime_auditor),'samples':len(seen),'hot_samples':sum(len(v) for v in groups.values()),
        'raw_samples':ident(root/'samples.jsonl'),'raw_runtime_identity':ident(root/'runtime.json'),'all_individual_timing_observations':time_observations,'numerical_checks':numeric,'max_abs_unrounded_f64':maxerror,'cases':static,'distributions':distributions,'same_bytes_segment_pairs':pairs,
        'actual_selected_wait_backends':[json.loads(v) for v in sorted(waitidentities)],'active_contexts':runtime['active_contexts'],
        'coefficients_fitted':False,'device_transfer_time_ns':None,'physical_traffic_bytes':None,
        'limitations':['Dispatch-to-successful-wait-return includes device DMA, compute, stalls, host start/return gap and selected runtime polling; it is not a pure device clock.',
            'Logical source segments may coalesce into runtime BDs; neither count is measured physical transactions.',
            'Four-add contrast changes arithmetic while retaining source accesses; no transfer-dominance assumption or baseline subtraction.',
            'v14 fixed sync rows have three ABI buffers/two reused contexts; this two-buffer/new-context-population experiment is not a compatible price query.',
            'Actual host BO sync spans are reported separately; no reused v14 prices or inferred physical DDR bandwidth.',
            'No device trace was requested by this runner; any separate trace derivative needs its own coverage/perturbation audit.']}
    (out/'summary.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n')
    print(json.dumps({'status':'passed','samples':len(seen),'hot_samples':result['hot_samples'],'summary':ident(out/'summary.json')}))

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--input',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();analyze(a.input,a.output)

if __name__=='__main__':main()
