#!/usr/bin/env python3
"""Process-isolated synthetic scaling; native C++ owns production optimization."""
import argparse
import hashlib
import importlib.util
import json
import random
from pathlib import Path
import sys
import time
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'python'))
from taskflow_paths import ORBIT_SRC
spec=importlib.util.spec_from_file_location('contracts',ORBIT_SRC/'test/TaskflowGeneric/cpsat_search_contract.py')
contracts=importlib.util.module_from_spec(spec);spec.loader.exec_module(contracts)
invoke=contracts.invoke
cover_cost=contracts.cover_cost
check_schedule=contracts.check_schedule
fits=contracts.fits
resource=contracts.resource
pattern=contracts.pattern
schedule_problem=contracts.schedule_problem

def candidate_hash(problem):
    semantic = {k: v for k, v in problem.items() if k != 'options'}
    return hashlib.sha256(json.dumps(semantic, sort_keys=True, separators=(',', ':')).encode()).hexdigest()


def baseline(p):
    """Cheap feasible reference, independently validated before starting CP-SAT."""
    if p.get('kind') != 'npu-schedule':
        best=None;singletons={}
        for i,x in enumerate(p['patterns']):
            if len(x['tasks'])!=1:continue
            key=(x['tile'],x['tasks'][0]);old=singletons.get(key)
            if old is None or x['cost_ns']<p['patterns'][old]['cost_ns']:singletons[key]=i
        for tile in range(p['tiles']):
            chosen=[]
            for task in range(p['tasks']):
                index=singletons.get((tile,task))
                if index is None:break
                chosen.append(index)
            if len(chosen)==p['tasks']:
                cost=cover_cost(p,chosen)
                if cost is not None and (best is None or cost<best[0]):best=(cost,chosen)
        assert best is not None
        cost,chosen=best
        return cost,chosen,dict(selected_pattern_indices=chosen)
    assignment=[i%len(p['tiles']) for i in range(len(p['shards']))]
    assert fits(p,assignment)
    rows=[dict(shard=i,tile=t) for i,t in enumerate(assignment)]
    available={}
    for k,name in enumerate(('input','compute','output')):
        for i,tile in enumerate(assignment):
            previous=0 if not k else rows[i][('input','compute')[k-1]+'_end_ns']
            key=resource(p,tile,k);start=max(previous,available.get(key,0))
            end=start+p['shards'][i][name+'_ns']
            rows[i][name+'_start_ns']=start;rows[i][name+'_end_ns']=end
            available[key]=end
    answer=dict(schedule=rows,makespan_ns=max(r['output_end_ns'] for r in rows))
    return check_schedule(p,answer),None,answer


def benchmark(tool, output, kind, campaign_seconds):
    started=time.monotonic();records=[]
    for n in ([8,16,32,64,128,256] if kind=='cover' else [4,8,16,32,64]):
        for tiles in ([1,4,8] if kind=='cover' else [2,4,8]):
            t=time.monotonic()
            if kind=='cover':
                rng=random.Random(n*100+tiles)
                ps=[pattern([i],tile,rng.randint(10,50)) for tile in range(tiles) for i in range(n)]
                for tile in range(tiles):
                    for size in (2,3,4,7):
                        for i in range(n-size+1):ps.append(pattern(list(range(i,i+size)),tile,rng.randint(5,40)*size))
                p=dict(tasks=n,tiles=tiles,patterns=ps,edges=[[i,i+1] for i in range(n-1)])
            else:
                p=schedule_problem(n,tiles,True)
                for s in p['shards']:s['compute_ns']=17+(s['id']*37)%101
                p['dma_resources'][0]['max_bds']=2*n
            baseline_started=time.monotonic();baseline_cost,hint,witness=baseline(p)
            baseline_ms=(time.monotonic()-baseline_started)*1000
            baseline_path=output.parent/f'{kind}-baseline-{n}-{tiles}.json'
            baseline_path.write_text(json.dumps(dict(candidate_sha256=candidate_hash(p),cost_ns=baseline_cost,solution=witness,independently_validated=True),indent=2)+'\n')
            generation=(time.monotonic()-t)*1000
            for budget in (.1,1.):
                if time.monotonic()-started+budget+1>campaign_seconds:
                    return records
                # Outer total deadline includes startup/build/solve/IPC. The
                # solver gets 65% so process startup, parsing and serialization fit.
                p['options']=dict(time_limit_seconds=max(.001,budget*.65-generation/1000),workers=1,max_patterns=50000,hint_pattern_indices=hint or [])
                measured=invoke(tool,p,budget,outer=max(.001,budget-generation/1000))
                verify_started=time.monotonic();answer=measured['result'];valid=False
                if answer and answer['status'] in ('OPTIMAL','FEASIBLE'):
                    if kind=='cover':valid=cover_cost(p,answer['selected_pattern_indices'])==answer['objective_ns']
                    else:check_schedule(p,answer);valid=True
                incumbent=answer['makespan_ns' if kind=='schedule' else 'objective_ns'] if valid else None
                verification=(time.monotonic()-verify_started)*1000
                record=dict(kind=kind,n=n,tiles=tiles,budget_seconds=budget,generation_ms=generation,baseline_ms=baseline_ms,baseline_cost_ns=baseline_cost,baseline_artifact=baseline_path.name,
                    solver_status=(answer or {}).get("status","EXTERNAL_TIMEOUT"),returned_solution_source="SOLVER" if incumbent is not None and incumbent<=baseline_cost else "BASELINE",
                    solver_incumbent_ns=incumbent,returned_cost_ns=min(baseline_cost,incumbent) if incumbent is not None else baseline_cost,
                    checked_fallback_available=True,
                    total_ms=generation+measured['process_ms']+verification,verification_ms=verification,valid_incumbent=valid,
                    candidate_sha256=candidate_hash(p),**measured)
                records.append(record)
                with output.open('a') as f:f.write(json.dumps(record)+'\n')
    return records


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--tool',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--benchmark',choices=['cover','schedule'],required=True)
    p.add_argument('--campaign-seconds',type=float,default=80)
    a=p.parse_args();assert not a.output.exists(),'Use a fresh output';a.output.parent.mkdir(parents=True,exist_ok=True)
    rows=benchmark(a.tool,a.output,a.benchmark,a.campaign_seconds)
    print(json.dumps(dict(runs=len(rows),output=str(a.output))))


if __name__=='__main__':main()
