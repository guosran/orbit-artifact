#!/usr/bin/env python3
"""Record compiler-emitted mapper II beside C++ predictions; no search logic."""
from pathlib import Path
import argparse,json,re

def atomic(path,value):
    temp=path.with_suffix('.pending');temp.write_text(json.dumps(value,indent=2)+'\n');temp.replace(path)

def collect(stage):
    stage=stage.resolve()
    result=json.loads((stage/'result.json').read_text()); source=result.get('top5',[])+result.get('controls',[])
    rows=[]
    for block,directory in [('native_top5','native-top5'),('native_controls','native-controls')]:
        for native in result.get(block,{}).get('records',[]):
            selection=next((s for s in source if s.get('candidate_id')==native.get('candidate_id') and s.get('rank')==native.get('rank')),None)
            if selection is None: continue
            mapped=stage/directory/f"rank-{native['rank']}"/'mapped.mlir'
            values={}
            if mapped.is_file() and native.get('mapper_equality')=='pass':
                text=mapped.read_text();starts=list(re.finditer(r'taskflow\.task\s+@([^\s(\[]+)',text))
                for i,match in enumerate(starts):
                    segment=text[match.start():starts[i+1].start() if i+1<len(starts) else len(text)]
                    ii={int(x) for x in re.findall(r'\bcompiled_ii\s*=\s*([0-9]+)',segment)}
                    if len(ii)==1: values[match.group(1)]=next(iter(ii))
            costs=selection.get('score_record',{}).get('task_costs',[])
            complete=bool(costs) and {c['task'] for c in costs}==set(values)
            rows.append({'candidate_id':selection['candidate_id'],'rank':native['rank'],
                'control_role':native.get('control_role'),'mapper_equality':native.get('mapper_equality'),
                'mapped_mlir':str(mapped),'status':'pass' if complete else 'pending',
                'task_ii':[{'task':c['task'],'ML_predicted_II':c['predicted_ii'],
                    'real_mapper_II':values.get(c['task']) if complete else None,
                    'trip_count':c['trip_count'],'mapper_tile_rows':c['mapper_tile_rows'],
                    'mapper_tile_cols':c['mapper_tile_cols']} for c in costs]})
    evidence={'schema':'orbit-neighborhood-mapper-ii-evidence-v1','workload':result.get('workload'),
        'stage':result.get('stage'),'source':'C++ score record and mapper-verified task compiled_ii attributes',
        'records':rows}
    atomic(stage/'mapper-ii-evidence.json',evidence)
    return evidence

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--results-root',type=Path,required=True);a=p.parse_args()
    count=0
    for result in a.results_root.glob('*/*/result.json'):
        if json.loads(result.read_text()).get('top5'):collect(result.parent);count+=1
    print('recorded II evidence for',count,'stages')
