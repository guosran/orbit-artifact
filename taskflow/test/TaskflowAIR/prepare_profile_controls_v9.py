#!/usr/bin/env python3
"""Generate compute-only stage controls and independent f64/f32 references.

No planning, compilation, runtime import or device execution. Shape split and
case set are declared before any timing. Native plans must check stage/DMA facts.
"""
import argparse
import hashlib
import json
from pathlib import Path

SEEDS=(11,23,47)
SHAPES=((8,64,'train'),(32,64,'train'),(17,80,'holdout'))


def task(name,reads,writes,m,n,operation,packed=False,lane_offset=0):
    ty=f'memref<{m}x{n}xf32>'
    def dtype(name):return f'memref<{m}x{n}x2xf32>' if packed and name.removesuffix('_b') in ['A','B'] else ty
    def operands(names):return ', '.join('%'+x for x in names)+' : '+', '.join(dtype(x) for x in names)
    all_names=reads+writes
    result='%done_'+name if len(writes)==1 else '%done_'+name+':'+str(len(writes))
    signature=ty if len(writes)==1 else '('+', '.join(ty for _ in writes)+')'
    text=f'''    {result} = taskflow.task @{name}
      will_reads({operands(reads)}) will_writes({operands(writes)})
      [original_read_memrefs({operands(reads)}), original_write_memrefs({operands(writes)})]
      : ({', '.join(dtype(x) for x in all_names)}) -> {signature} {{
    ^bb0({', '.join('%'+x+'_b: '+dtype(x) for x in all_names)}):
      affine.for %i = 0 to {m} {{
        affine.for %j = 0 to {n} {{
'''
    for index,out in enumerate(writes):
        a,b=reads if packed else reads[2*index:2*index+2]
        address='%i, %j, '+str(lane_offset+index) if packed else '%i, %j'
        text+=f'''          %a{index} = affine.load %{a}_b[{address}] : {dtype(a)}
          %b{index} = affine.load %{b}_b[{address}] : {dtype(b)}
          %v{index} = arith.{operation}f %a{index}, %b{index} : f32
          affine.store %v{index}, %{out}_b[%i, %j] : {ty}
'''
    text+='        }\n      }\n      taskflow.yield done_writes('+operands([x+'_b' for x in writes])+')\n    }\n'
    return text


def source(m,n,operation,grouping,packed=False):
    ty=f'memref<{m}x{n}xf32>'
    names=('A','B','Y','Z') if packed else ('A','B','D','E','Y','Z')
    def dtype(name):return f'memref<{m}x{n}x2xf32>' if packed and name in ['A','B'] else ty
    args=', '.join('%'+x+': '+dtype(x)+' {orbit.role = "'+('output' if x in ['Y','Z'] else 'input')+'", orbit.name = "'+x+'"}' for x in names)
    if packed:
        body=task('both',['A','B'],['Y','Z'],m,n,operation,True) if grouping=='grouped' else task('left',['A','B'],['Y'],m,n,operation,True)+task('right',['A','B'],['Z'],m,n,operation,True,1)
    else:
        body=task('both',['A','B','D','E'],['Y','Z'],m,n,operation) if grouping=='grouped' else task('left',['A','B'],['Y'],m,n,operation)+task('right',['D','E'],['Z'],m,n,operation)
    return 'module {\n  func.func @control_'+operation+'('+args+') attributes {orbit.noalias, llvm.emit_c_interface} {\n'+body+'    return\n  }\n}\n'


def save(path,value):path.write_text(json.dumps(value,indent=2)+'\n')
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--output',type=Path,required=True);parser.add_argument('--packed-two-input',action='store_true',help='pack old A/D and B/E into rank-3 A/B final axis; no arithmetic transform');a=parser.parse_args()
    import numpy as np
    out=a.output.resolve();out.mkdir(parents=True,exist_ok=False)
    declaration=dict(schema='orbit.profiling.control-split.v1',selection='fixed before compilation or timing',seeds=list(SEEDS),train_shapes=[[8,64],[32,64]],holdout_shapes=[[17,80]],operations=['add','mul'],groupings=['grouped','split'],tile_sizes=[8,64],numerical_contract='FP32 finite, atol=rtol=1e-5',not_random_holdout=True,packed_two_input=a.packed_two_input,input_layout='identity rank3 [M,N,2]; old A/D and B/E in last-axis lanes0/1' if a.packed_two_input else 'four independent identity rank2 inputs')
    save(out/'split-declaration.json',declaration)
    cases=[]
    for m,n,label in SHAPES:
        inputs={}
        for seed in SEEDS:
            rng=np.random.default_rng(seed)
            values={name:rng.uniform(-.75,.75,(m,n)).astype(np.float32) for name in ['A','B','D','E']}
            for name,x in values.items():
                x.flat[0]=0;x.flat[1]=1e-8;x.flat[2]=-1.;x.flat[-1]=.5 if name in ['A','D'] else -.25
            inputs[seed]=values
        for operation in ['add','mul']:
            for grouping in ['grouped','split']:
                name=f'{label}-m{m}-n{n}-{operation}-{grouping}';directory=out/name;directory.mkdir()
                (directory/'source.mlir').write_text(source(m,n,operation,grouping,a.packed_two_input))
                save(directory/'target.json',{'generic_air':{'tile_sizes':[8,64]}})
                for seed,values in inputs.items():
                    x={key:value.astype(np.float64) for key,value in values.items()}
                    ref={dst:(x[left]+x[right] if operation=='add' else x[left]*x[right]) for left,right,dst in [('A','B','Y'),('D','E','Z')]}
                    stored_inputs={'A':np.stack([values['A'],values['D']],axis=-1),'B':np.stack([values['B'],values['E']],axis=-1)} if a.packed_two_input else values
                    np.savez(directory/f'inputs-{seed}.npz',**stored_inputs)
                    np.savez(directory/f'reference-f64-{seed}.npz',**ref)
                    np.savez(directory/f'reference-{seed}.npz',**{key:value.astype(np.float32) for key,value in ref.items()})
                facts=dict(name=name,group_id=f'm{m}-n{n}-{operation}',split=label,shape=[m,n],operation=operation,grouping=grouping,task_count=1 if grouping=='grouped' else 2,
                    task_relation='independent outputs; no data or ordering dependency added',loop_structure='grouped single i/j nest contains both outputs; split has one i/j nest per task',input_regions='grouped reads both packed lanes; split each reads one lane with original stride2' if a.packed_two_input else 'independent full rank2 inputs',abi_order=['A','B','Y','Z'] if a.packed_two_input else ['A','B','D','E','Y','Z'],packed_two_input=a.packed_two_input,input_shape=[m,n,2] if a.packed_two_input else [m,n],output_shape=[m,n],dtype='f32',tile_sizes=[8,64],
                    arithmetic=dict(floating_binary_ops=2*m*n,scalar_loads=4*m*n,scalar_stores=2*m*n,scope='source FP32 operations only; loop/index/control overhead not assumed identical'),
                    expected_dma_bytes=24*m*n,expected_dma_scope='four full inputs once +two full outputs once, no padding/copies; native plan/final runtime must confirm rather than infer from this fixture',
                    expected_interior_hardware_stages=1 if grouping=='grouped' else 2,
                    tail_partition_may_add_stages=m%8!=0 or n%64!=0,
                    actual_hardware_stages=None,actual_dma_bytes=None,
                    expected_host_submissions=1,reference_method='independent arithmetic on exact input f32 values in f64; retain f64 and separately cast final values to f32 for unchanged acceptance')
                save(directory/'fixture.json',facts)
                cases.append(dict(**facts,source=f'{name}/source.mlir',target=f'{name}/target.json',inputs=[f'{name}/inputs-{seed}.npz' for seed in SEEDS],reference=[f'{name}/reference-{seed}.npz' for seed in SEEDS],reference_f64=[f'{name}/reference-f64-{seed}.npz' for seed in SEEDS],source_sha256=sha(directory/'source.mlir')))
    save(out/'manifest.json',dict(schema='orbit.profiling.controls.v1',split_declaration_sha256=sha(out/'split-declaration.json'),cases=cases,source_decisions='compute and ABI only; target config is separate; no Python mapping policy',stage_count_validation='actual generic plan and compiled firmware must be recorded by consumer; grouped/split expected stage count is not an observed result'))
    save(out/'file-manifest.json',{str(p.relative_to(out)):sha(p) for p in sorted(out.rglob('*')) if p.is_file()})
    print(json.dumps(dict(status='prepared',cases=len(cases),seeds=list(SEEDS),device_submissions=0,compilation=False)))


if __name__=='__main__':main()
