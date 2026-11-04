#!/usr/bin/env python3
"""Fixture oracle for emitted GEMM→scale M32/K128/N64 mixed8 local indices.

Checks actual index SSA in AIR. This is a test of the known fixture, not compiler
planning, source matching in production, or proof of installed/device execution.
"""
import argparse
import json
from pathlib import Path
import re


def audit(text, panel):
    constants, definitions, storage, regions = {}, {}, {}, []
    accesses=[];helper_groups={}
    def linear(value,seen=()):
        assert value not in seen,'index cycle'
        if value in constants:return {} if constants[value]==0 else {'#constant':constants[value]}
        if value not in definitions:return {value:1}
        op,args=definitions[value];left,right=(linear(v,seen+(value,)) for v in args)
        if op=='muli':
            if not left or not right:return {}
            if set(right)=={'#constant'}:left,right=right,left
            assert set(left)=={'#constant'},'nonlinear fixture index'
            return {k:v*left['#constant'] for k,v in right.items() if v*left['#constant']}
        out=dict(left)
        for k,v in right.items():out[k]=out.get(k,0)+(v if op=='addi' else -v)
        return {k:v for k,v in out.items() if v}
    for line in text.splitlines():
        match=re.search(r'(%[\w.$]+) = "arith.constant"\(\).*value = (-?\d+) : index',line)
        if match:constants[match[1]]=int(match[2])
        match=re.search(r'(%[\w.$]+) = "arith.(addi|subi|muli)"\(([^)]+)\)',line)
        if match:definitions[match[1]]=(match[2],[v.strip() for v in match[3].split(',')])
        match=re.search(r'(%[\w.$]+) = "memref.reinterpret_cast".*orbit.storage = "([^"]+)"',line)
        if match:storage[match[1]]=match[2]
        match=re.search(r'(%[\w.$]+) = "memref.cast"\((%[\w.$]+)\)',line)
        if match and match[2] in storage:storage[match[1]]=storage[match[2]]
        if line.rstrip().endswith('({'):
            loop=re.search(r'"scf.for"\(([^)]+)\)',line)
            regions.append({'bounds':tuple(constants.get(v.strip()) for v in loop[1].split(',')[:3]),'iv':None} if loop else None)
        block=re.search(r'\^bb\d+\((%[\w.$]+): index',line)
        if block and regions and regions[-1] is not None:regions[-1]['iv']=block[1]
        active=[r for r in regions if r is not None]
        gemm=len(active)>=3 and [r['bounds'] for r in active[-3:-1]]==[(0,8,1),(0,32,8)]
        if gemm:assert active[-1]['bounds']==(0,32,1),'source K order/step changed'
        access=re.search(r'"(memref.load|vector.transfer_read|vector.transfer_write)"\(([^)]+)\)',line)
        if access:
            args=[v.strip() for v in access[2].split(',')];start=2 if access[1]=='vector.transfer_write' else 1
            value=args[start-1];name=storage.get(value)
            if gemm:
                i,j,k=[r['iv'] for r in active[-3:]]
                if name=='A':wanted=[{i:1},{k:1}]
                elif name=='B':
                    wanted=[{k:1},{j:1}]
                    if panel:
                        assert active[-4]['bounds']==(0,4,1),'missing compact ordered four-K loop'
                        wanted[0][active[-4]['iv']]=32
                else:
                    assert name=='intermediate',(name,line)
                    wanted=[{i:1},{j:1}]
                actual=[linear(v) for v in args[start:start+2]]
                assert actual==wanted,('update local address mismatch',name,actual,wanted)
                accesses.append({'task':'gemm-update','storage':name,'operation':access[1],'indices':args[start:start+2],'simplified':actual,'expected':wanted})
            elif len(active)>=2 and [r['bounds'] for r in active[-2:]]==[(0,8,1),(0,32,8)]:
                # Source scale has two spatial loops and no reduction loop.
                assert name in ('intermediate','Y'),(name,line)
                wanted=[{r['iv']:1} for r in active[-2:]];actual=[linear(v) for v in args[start:start+2]]
                assert actual==wanted,('scale local address mismatch',name,actual,wanted)
                accesses.append({'task':'scale','storage':name,'operation':access[1],'simplified':actual,'expected':wanted})
        if gemm and 'callee = @__mulsf3' in line:
            lane=int(re.search(r'orbit.scalarized_lane = (\d+)',line)[1]);helper_groups.setdefault(active[-1]['iv'],[]).append(lane)
        if line.lstrip().startswith('})'):regions.pop()
    assert accesses and any(a['task']=='scale' for a in accesses)
    assert helper_groups and all(sorted(v)==list(range(8)) for v in helper_groups.values()),helper_groups
    assert not re.search(r'"arith\.(mulf|divf)".*vector<',text)
    assert '"vector.reduction"' not in text and '"vector.fma"' not in text
    assert re.search(r'"arith.addf".*vector<8xf32>',text)
    return {'checked_accesses':accesses,'ordered_K_helper_groups':helper_groups,
            'scope':'known actual GEMM→scale fixture AIR index SSA and ordered scalar-product/vector-add structure; no device/installed-code proof'}


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--proposals',type=Path,required=True)
    p.add_argument('--output',type=Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
    results=[]
    for case in json.loads((a.proposals/'cases.json').read_text()):
        text=(a.proposals/'air-proof'/case['candidate_id']/'program.air.mlir').read_text()
        result=audit(text,case['experiment_coordinate']=='storage1-panel')
        (a.output/(case['candidate_id']+'.json')).write_text(json.dumps(result,indent=2)+'\n')
        # Independent negative: remove one B-panel/global-K component or swap
        # one local A index. The canonical C++ checker is a separate gate.
        original=text
        if case['experiment_coordinate']=='storage1-panel':
            line=next(l for l in text.splitlines() if '"vector.transfer_read"' in l and 'memref<128x32xf32' in l)
            # Its global K SSA addi definition contains the actual leaf K IV.
            kindex=re.search(r'"vector.transfer_read"\(%[\w.$]+, (%[\w.$]+),',line)[1]
            definition=next(l for l in text.splitlines() if l.lstrip().startswith(kindex+' = "arith.addi"'))
            leaf=re.search(r'"arith.addi"\((%[\w.$]+),',definition)[1]
            text=text.replace(line,line.replace(', '+kindex+',',', '+leaf+','),1)
        else:
            line=next(l for l in text.splitlines() if '"memref.load"' in l and 'memref<8x32xf32' in l)
            match=re.search(r'"memref.load"\((%[\w.$]+), (%[\w.$]+), (%[\w.$]+)\)',line)
            text=text.replace(line,line.replace(match[0],f'"memref.load"({match[1]}, {match[3]}, {match[2]})'),1)
        assert text!=original
        try:audit(text,case['experiment_coordinate']=='storage1-panel')
        except AssertionError:pass
        else:raise AssertionError('index mutation accepted')
        results.append({'candidate_id':case['candidate_id'],'positive':'passed','index_mutation_rejected':True})
    (a.output/'result.json').write_text(json.dumps({'status':'passed','checks':results,'hardware_executed':False},indent=2)+'\n')
    print(json.dumps({'status':'passed','candidates':len(results),'index_mutants_rejected':len(results),'hardware_executed':False}))


if __name__=='__main__':main()
