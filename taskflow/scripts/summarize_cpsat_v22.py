#!/usr/bin/env python3
"""Export reviewable CP-SAT evidence; retain full raw runs in ignored results."""
import argparse
import collections
import hashlib
import json
from pathlib import Path
import shutil


def load(p):return json.loads(p.read_text())
def save(p,v):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(v,indent=2)+'\n')
def copy(src,dst):dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dst)


def main():
    p=argparse.ArgumentParser();p.add_argument('--results',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    a=p.parse_args();a.output.mkdir(parents=True,exist_ok=True)
    cpu=a.results/'cpsat-v22-cpu-r5';hw=a.results/'cpsat-v22-hardware-r3';reg=a.results/'cpsat-v22-regressions-r1'
    summary=dict(schema='orbit.cpsat.validation.v22',status='PASS',cpu={},native=[],hardware={},regressions={},scope='finite surrogate optimization and certified independent npu2 shards; no global optimum, measured overlap or stable speedup claim')
    for name in ('contracts.json','cover.jsonl','schedule.jsonl','provenance.json','default-off.json'):
        copy(cpu/name,a.output/'cpu'/name)
    for folder in ('native-contracts','native-scaling'):
        copy(cpu/folder/'result.json',a.output/'cpu'/(folder+'.json'))
    # Baselines were written and independently validated before worker launch.
    for f in cpu.glob('*-baseline-*.json'):copy(f,a.output/'cpu'/f.name)
    for kind in ('cover','schedule'):
        rows=[json.loads(l) for l in (cpu/(kind+'.jsonl')).read_text().splitlines()]
        states=collections.Counter((str(r['budget_seconds']),r['solver_status']) for r in rows)
        summary['cpu'][kind]=dict(runs=len(rows),statuses={str(b)+':'+s:n for (b,s),n in states.items()},
            solver_incumbents=sum(r['valid_incumbent'] for r in rows),baseline_selected=sum(r['returned_solution_source']=='BASELINE' for r in rows),
            baseline_validated_runs=sum(r['checked_fallback_available'] for r in rows),max_total_ms=max(r['total_ms'] for r in rows),
            max_peak_rss_kib=max((r['result'] or {}).get('peak_rss_kib',0) for r in rows))
    for r in load(cpu/'native-scaling/result.json')['cases']:
        x=next(iter(r['proposals']['parents'].values()))[0]
        summary['native'].append(dict(tasks=int(r['name']),process_ms=r['elapsed_ms'],generation_ms=x['generation_ms'],pricing_ms=x['pricing_ms'],
            model_build_ms=x['solver']['model_build_ms'],solve_ms=x['solver']['solve_ms'],recheck_ms=x['recheck_ms'],patterns=x['patterns'],tiles=x['tiles'],
            cost_calls=r['stats']['raw_cost_provider_calls'],best_local_ns=x['best_local_ns'],rechecked_ns=x['rechecked_ns'],domain_truncated=x['domain_truncated'],
            max_pricing_call_ms=x['max_complete_pricing_call_ms'],peak_rss_kib=x['solver']['peak_rss_kib']))
    for i in (1,2,3):
        raw=a.results/f'cpsat-v22-hardware-r{i}'
        copy(raw/'result.json',a.output/'hardware'/f'campaign-r{i}.json')
        copy(raw/'provenance.json',a.output/'hardware'/f'provenance-r{i}.json')
    summary['hardware']['campaigns']=[load(a.results/f'cpsat-v22-hardware-r{i}'/'result.json') for i in (1,2,3)]
    samples=arrays=0;maximum=0.
    for case in load(hw/'result.json')['cases']:
        root=hw/case['case'];target=a.output/'hardware'/case['case']
        copy(root/'fixture/source.mlir',target/'source.mlir');copy(root/'fixture/fixture.json',target/'fixture.json')
        for n in case['variants']:
            variant=root/f'cores-{n}';dst=target/f'cores-{n}'
            for name in ('program.air.mlir','final-aie.generic.mlir','implementation-contract.json','commands.json','abi.json','target.json'):
                copy(variant/name,dst/name)
            manifest=load(variant/'manifest.json')
            save(dst/'placement.json',{k:v for k,v in manifest.items() if k!='shards'}|{'shards':[{'row_offset':s['row_offset'],'row_count':s['row_count'],'source_fingerprint':s['source_fingerprint']} for s in manifest['shards']]})
            for f in variant.glob('fresh-process-*/[0-9]*/result.json'):
                result=load(f)
                for s in result['samples']:
                    samples+=1;arrays+=len(s['checks'])
                    for c in s['checks'].values():maximum=max(maximum,c['max_abs'])
                assert result['status']=='passed' and all(n==1 for n in result['actual_submissions'])
    summary['hardware'].update(final_campaign_calls=samples,final_campaign_complete_arrays=arrays,fp32_max_abs=maximum,
        seeds_per_program=3,fresh_processes_per_variant=3,warmups_per_seed=2,hot_samples_per_seed=5,fp64_checked=True,atol=1e-5,rtol=1e-5,
        performance_conclusion='No stable measured speedup across campaigns. r1 overlapped a Core build; r2 and r3 had no concurrent builds or timing campaigns from this task.')
    for folder in ('core','combined'):
        result=load(reg/folder/'result.json');summary['regressions'][folder]=dict(status=result['status'],groups=len(result['tests']))
        copy(reg/folder/'result.json',a.output/'regressions'/(folder+'.json'))
    copy(reg/'result.json',a.output/'regressions/replay.json')
    copy(reg/'original-lit.stdout',a.output/'regressions/lit.stdout')
    for f in (reg/'original-amoeba-cgra').rglob('*.json'):
        if f.stat().st_size<100000:copy(f,a.output/'regressions/original-amoeba-cgra'/f.relative_to(reg/'original-amoeba-cgra'))
    contract=a.results/'cpsat-v22-multicore-contract-r2/result.json';copy(contract,a.output/'multicore-contracts.json')
    summary['regressions'].update(cp_sat_contracts=len(load(cpu/'contracts.json')['cases']),native_contracts=len(load(cpu/'native-contracts/result.json')['cases']),
        multicore_cases=len(load(contract)['cases']),lit=35)
    save(a.output/'summary.json',summary)
    # Archive identities of all raw logs, ELFs, complete outputs and baselines.
    roots=[f for f in a.results.glob('cpsat-v22-*') if f.is_dir()]
    manifest={}
    for root in roots:
        for f in root.rglob('*'):
            if f.is_file():manifest[str(f.relative_to(a.results))]=dict(bytes=f.stat().st_size,sha256=hashlib.sha256(f.read_bytes()).hexdigest())
    save(a.output/'raw-manifest.json',dict(raw_root=str(a.results),files=manifest))
    print(json.dumps(dict(status='PASS',raw_files=len(manifest),final_calls=samples,output=str(a.output))))


if __name__=='__main__':main()
