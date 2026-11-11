#!/usr/bin/env python3
"""Independent finite oracles and bounded process-isolated CP-SAT scaling.

The oracle contracts a selected exact cover using Kahn's algorithm. It does not
reuse the production rank constraints. Scheduling uses independent exhaustive
assignment/operation ordering. Benchmark objectives are synthetic, not NPU time.
"""
import argparse
import hashlib
import itertools
import json
import os
from pathlib import Path
import random
import signal
import subprocess
import time


def candidate_hash(problem):
    semantic = {k: v for k, v in problem.items() if k != 'options'}
    return hashlib.sha256(json.dumps(semantic, sort_keys=True, separators=(',', ':')).encode()).hexdigest()


def invoke(tool, problem, budget=2, outer=None):
    payload = dict(problem)
    payload.setdefault('options', dict(time_limit_seconds=budget, workers=1))
    started = time.monotonic()
    encoded = json.dumps(payload)
    process = subprocess.Popen([str(tool)], stdin=subprocess.PIPE,
        stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True,
        start_new_session=True)
    expired = False
    try:
        stdout, stderr = process.communicate(encoded,
            timeout=max(.0001,outer-(time.monotonic()-started)) if outer is not None else budget + 2)
    except subprocess.TimeoutExpired:
        expired = True
        os.killpg(process.pid, signal.SIGKILL)
        stdout, stderr = process.communicate()
    answer = None
    if not expired:
        answer = json.loads(stdout)
    return dict(result=answer, external_timeout=expired,
        process_ms=(time.monotonic()-started)*1000,
        returncode=process.returncode, stderr=stderr[-2000:])


def cover_cost(p, selected):
    owner, tiles, retained = {}, set(), set()
    for group, index in enumerate(selected):
        pattern = p['patterns'][index]
        tiles.add(pattern['tile'])
        for task in pattern['tasks']:
            if task in owner:
                return None
            owner[task] = group
        for storage in pattern.get('exclusive_storages', []):
            if storage in retained:
                return None
            retained.add(storage)
    if set(owner) != set(range(p['tasks'])) or len(tiles) != 1:
        return None
    adjacency = [set() for _ in selected]
    indegree = [0]*len(selected)
    for a, b in p['edges']:
        a, b = owner[a], owner[b]
        if a != b and b not in adjacency[a]:
            adjacency[a].add(b)
            indegree[b] += 1
    ready = [i for i, degree in enumerate(indegree) if not degree]
    visited = 0
    while ready:
        node = ready.pop()
        visited += 1
        for child in adjacency[node]:
            indegree[child] -= 1
            if not indegree[child]:
                ready.append(child)
    if visited != len(selected):
        return None
    return (p.get('tile_base_cost_ns', [0]*p['tiles'])[next(iter(tiles))]
            + sum(p['patterns'][i]['cost_ns'] for i in selected))


def cover_oracle(p):
    best = None
    def visit(covered, selected):
        nonlocal best
        if len(covered) == p['tasks']:
            cost = cover_cost(p, selected)
            if cost is not None and (best is None or cost < best):
                best = cost
            return
        task = next(t for t in range(p['tasks']) if t not in covered)
        for i, pattern in enumerate(p['patterns']):
            members = set(pattern['tasks'])
            if task in members and not covered.intersection(members):
                visit(covered | members, selected + [i])
    visit(set(), [])
    return best


def resource(p, tile, stage):
    t = p['tiles'][tile]
    return ('compute', tile) if stage == 1 else ('dma', t[
        'input_resource' if stage == 0 else 'output_resource'])


def fits(p, assignment):
    if p.get('exclusive_tiles', True) and len(set(assignment)) != len(assignment):
        return False
    memory, bds = [0]*len(p['tiles']), [0]*len(p['dma_resources'])
    for i, tile in enumerate(assignment):
        s, t = p['shards'][i], p['tiles'][tile]
        if tile not in s['candidate_tiles']:
            return False
        memory[tile] += s['static_bytes']
        bds[t['input_resource']] += s['input_bds']
        bds[t['output_resource']] += s['output_bds']
    return (all(n <= t['static_bytes'] for n, t in zip(memory, p['tiles']))
        and all(n <= r['max_bds'] for n, r in zip(bds, p['dma_resources'])))


def schedule_oracle(p):
    best = None
    for assignment in itertools.product(*(s['candidate_tiles'] for s in p['shards'])):
        if not fits(p, assignment):
            continue
        stage, end, resources = [0]*len(assignment), [0]*len(assignment), {}
        def visit(done):
            nonlocal best
            if best is not None and max(end, default=0) >= best:
                return
            if done == 3*len(assignment):
                best = max(end, default=0)
                return
            for i in range(len(assignment)):
                k = stage[i]
                if k == 3:
                    continue
                key = resource(p, assignment[i], k)
                duration = p['shards'][i][('input_ns', 'compute_ns', 'output_ns')[k]]
                old_end, old_resource = end[i], resources.get(key, 0)
                end[i] = (max(old_end, old_resource) if duration else old_end) + duration
                if duration:
                    resources[key] = end[i]
                stage[i] += 1
                visit(done + 1)
                stage[i] -= 1
                end[i] = old_end
                resources[key] = old_resource
        visit(0)
    return best


def check_schedule(p, answer):
    rows = answer['schedule']
    assert len(rows) == len(p['shards'])
    assignment, intervals, maximum = [None]*len(rows), {}, 0
    for row in rows:
        i, tile = row['shard'], row['tile']
        assert type(i) is int and 0 <= i < len(rows) and assignment[i] is None
        assert type(tile) is int and 0 <= tile < len(p['tiles'])
        assignment[i] = tile
        previous = 0
        for k, name in enumerate(('input', 'compute', 'output')):
            start, end = row[name+'_start_ns'], row[name+'_end_ns']
            assert type(start) is int and type(end) is int and start >= previous
            assert end-start == p['shards'][i][name+'_ns']
            previous = end
            if end > start:
                intervals.setdefault(resource(p, tile, k), []).append((start, end))
        maximum = max(maximum, previous)
    assert fits(p, assignment)
    for spans in intervals.values():
        spans.sort()
        assert all(a[1] <= b[0] for a, b in zip(spans, spans[1:]))
    assert maximum == answer['makespan_ns']
    return maximum


def pattern(tasks, tile, cost, **kw):
    return dict(tasks=tasks, tile=tile, cost_ns=cost, **kw)


def schedule_problem(n=2, tiles=2, shared=False):
    resources = [dict(id=i, max_bds=32) for i in range(1 if shared else 2*tiles)]
    return dict(kind='npu-schedule', exclusive_tiles=False,
        dma_resources=resources,
        tiles=[dict(id=i, column=i, row=2, static_bytes=4096,
            input_resource=0 if shared else 2*i,
            output_resource=0 if shared else 2*i+1,
            input_channel=0, output_channel=0) for i in range(tiles)],
        shards=[dict(id=i, input_ns=2+i, compute_ns=5+i, output_ns=2,
            static_bytes=16, input_bds=1, output_bds=1,
            candidate_tiles=list(range(tiles))) for i in range(n)])


def contracts(tool):
    cases = []
    for seed in range(16):
        rng = random.Random(seed)
        n, tiles = rng.randint(2, 6), rng.randint(1, 3)
        ps = [pattern([i], t, rng.randint(-5, 30)) for t in range(tiles) for i in range(n)]
        for t in range(tiles):
            for group in itertools.combinations(range(n), 2):
                if rng.random() < .35:
                    ps.append(pattern(list(group), t, rng.randint(-15, 20)))
        p = dict(tasks=n, tiles=tiles, patterns=ps,
            edges=[[a,b] for a in range(n) for b in range(a+1,n) if rng.random()<.3],
            tile_base_cost_ns=[rng.randint(0,100) for _ in range(tiles)])
        cases.append(('signed-random-'+str(seed), p))
    cases += [('contraction-cycle', dict(tasks=3, tiles=1, edges=[[0,1],[1,2]],
        patterns=[pattern([i],0,10) for i in range(3)]+[pattern([0,2],0,0)])),
        ('tile-conflict', dict(tasks=2,tiles=2,edges=[],patterns=[pattern([0],0,1),pattern([1],1,1)])),
        ('missing-task',dict(tasks=2,tiles=1,edges=[],patterns=[pattern([0],0,1)])),
        ('retained-storage-conflict',dict(tasks=4,tiles=1,edges=[],patterns=
            [pattern([i],0,10) for i in range(4)]+[
                pattern([0,1],0,1,exclusive_storages=[0]),pattern([2,3],0,1,exclusive_storages=[0])]))]
    for shared in (False, True):
        for n in (1,2,3):
            cases.append((f'schedule-{n}-{shared}',schedule_problem(n,2,shared)))
    p=schedule_problem(2,1);p['tiles'][0]['static_bytes']=16;cases.append(('static-sram-no-lifetime-release',p))
    p=schedule_problem(1,1,True);p['dma_resources'][0]['max_bds']=1;cases.append(('static-bd-input-output-sum',p))
    p=schedule_problem(3,2);p['exclusive_tiles']=True;cases.append(('exclusive-placement',p))
    p=schedule_problem(2,1);p['shards'][0].update(input_ns=0,compute_ns=0,output_ns=0);cases.append(('zero-duration',p))
    cases.append(('duplicate-source-edges',dict(tasks=2,tiles=1,edges=[[0,1],[0,1]],patterns=[pattern([0],0,1),pattern([1],0,1)])))
    p=schedule_problem(2,1,True);p['tiles'][0]['output_channel']=1;cases.append(('shared-resource-distinct-channel-labels',p))
    records=[]
    for name,p in cases:
        is_schedule=p.get('kind')=='npu-schedule'
        expected=schedule_oracle(p) if is_schedule else cover_oracle(p)
        measured=invoke(tool,p);answer=measured['result']
        assert not measured['external_timeout'] and measured['returncode']==0,(name,measured)
        assert answer['status']==('INFEASIBLE' if expected is None else 'OPTIMAL'),(name,expected,answer)
        if expected is not None:
            actual=check_schedule(p,answer) if is_schedule else cover_cost(p,answer['selected_pattern_indices'])
            assert actual==expected,(name,expected,actual)
            if not is_schedule:assert actual==answer['objective_ns']
        records.append(dict(name=name,expected=expected,**measured))
    for limit in ('time','size'):
        p=cases[0][1].copy();p['options']=dict(time_limit_seconds=1e-12 if limit=='time' else 1,workers=1,max_variables=1 if limit=='size' else 100000)
        r=invoke(tool,p);assert r['result']['status']==('UNKNOWN' if limit=='time' else 'RESOURCE_LIMIT'),r
        records.append(dict(name=limit,**r))
    for name,p,status in [
        ('source-cycle',dict(tasks=2,tiles=1,edges=[[0,1],[1,0]],patterns=[pattern([0,1],0,1)]),'INVALID_INPUT'),
        ('task-cap',dict(tasks=513,tiles=1,edges=[],patterns=[]),'RESOURCE_LIMIT')]:
        r=invoke(tool,p);assert r['result']['status']==status,(name,r)
        assert r['result']['solve_ms']==0,(name,r)
        records.append(dict(name=name,**r))
    for key in ('max_variables','max_constraints','max_memberships','max_edges','max_intersection_work','max_tiles'):
        p=dict(tasks=3,tiles=2,edges=[[0,1],[1,2]],patterns=[pattern([i],t,1) for t in range(2) for i in range(3)])
        p['options']={key:1,'time_limit_seconds':1}
        r=invoke(tool,p);assert r['result']['status']=='RESOURCE_LIMIT',(key,r)
        assert r['result']['solve_ms']==0,(key,r)
        records.append(dict(name=key,**r))
    assert candidate_hash(dict(tasks=2,options={'time_limit_seconds':.1}))==candidate_hash(dict(tasks=2,options={'time_limit_seconds':1}))
    return records


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
    p=argparse.ArgumentParser();p.add_argument('--tool',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--benchmark',choices=['cover','schedule']);p.add_argument('--campaign-seconds',type=float,default=80)
    a=p.parse_args();assert not a.output.exists(),'Use a fresh output';a.output.parent.mkdir(parents=True,exist_ok=True)
    if a.benchmark:
        rows=benchmark(a.tool,a.output,a.benchmark,a.campaign_seconds)
        print(json.dumps(dict(runs=len(rows),output=str(a.output))))
    else:
        rows=contracts(a.tool);a.output.write_text(json.dumps(dict(status='PASS',cases=rows),indent=2)+'\n');print(json.dumps(dict(status='PASS',cases=len(rows))))


if __name__=='__main__':main()
