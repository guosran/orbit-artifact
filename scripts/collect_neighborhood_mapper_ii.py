#!/usr/bin/env python3
"""Record compiler-emitted mapper II beside C++ predictions; no search logic."""
from pathlib import Path
import argparse,json,re

TASK_OPS = ('taskflow.task', 'neura.task')
PRETTY_TASK = re.compile(r'\s+@([^\s(\[]+)')
GENERIC_TASK_NAME = re.compile(r'\btask_name\s*=\s*"([^"\\]*(?:\\.[^"\\]*)*)"')
COMPILED_II = re.compile(r'\bcompiled_ii\s*=\s*([0-9]+)')

def task_starts(ir):
    """Find task operations without mistaking quoted source-body text for IR."""
    starts=[]; position=0
    while position < len(ir):
        if ir[position] == '"':
            begin=position; position+=1
            while position < len(ir):
                if ir[position] == '\\': position+=2; continue
                if ir[position] == '"': break
                position+=1
            token=ir[begin+1:position]
            position+=1
            if token in TASK_OPS:
                operand=position
                while operand < len(ir) and ir[operand].isspace(): operand+=1
                if operand < len(ir) and ir[operand] == '(':
                    starts.append((begin,None))
            continue
        if position == 0 or ir[position-1].isspace():
            for operation in TASK_OPS:
                if not ir.startswith(operation,position): continue
                name=PRETTY_TASK.match(ir,position+len(operation))
                if name: starts.append((position,name.group(1)))
                break
        position+=1
    return starts

def unquoted_text(text):
    """Blank string contents so serialized IR cannot look like attributes."""
    output=[]; position=0
    while position < len(text):
        begin=text.find('"',position)
        if begin < 0:
            output.append(text[position:]); break
        output.append(text[position:begin])
        end=begin+1
        while end < len(text):
            if text[end] == '\\': end+=2; continue
            if text[end] == '"': end+=1; break
            end+=1
        output.append(''.join('\n' if char=='\n' else ' ' for char in text[begin:end]))
        position=end
    return ''.join(output)

def task_ii_values(ir):
    """Return task-name to compiled-II values from generic or pretty MLIR."""
    starts=task_starts(ir); values={}
    for index,(begin,pretty_name) in enumerate(starts):
        end=starts[index+1][0] if index+1<len(starts) else len(ir)
        segment=ir[begin:end]
        name=pretty_name
        if name is None:
            match=GENERIC_TASK_NAME.search(segment)
            name=match.group(1) if match else None
        if name is None: continue
        ii={int(value) for value in COMPILED_II.findall(unquoted_text(segment))}
        if len(ii)==1: values[name]=next(iter(ii))
    return values

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
                values=task_ii_values(mapped.read_text())
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
