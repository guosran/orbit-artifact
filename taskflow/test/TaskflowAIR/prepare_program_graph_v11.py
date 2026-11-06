#!/usr/bin/env python3
"""Prepare plain computation/dependency MLIR and independent f64 references.

No graph/mapping/cost planning occurs here. C++ derives the ProgramGraph.
"""
import argparse,hashlib,json,re,sys
from pathlib import Path
import numpy as np
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'python'))
from taskflow_paths import ORBIT_SRC


def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def save(path,value):Path(path).write_text(json.dumps(value,indent=2)+'\n')


def fanout_source(size):
    # Same real MLIR as the established CPU fanout test; the second task result
    # is an ordering token only, not an invented data read or communication op.
    return '''module {
  func.func @fanout(%a: memref<16xf32> {orbit.role="input",orbit.name="A"}, %b: memref<16xf32> {orbit.role="output",orbit.name="B"}, %c: memref<16xf32> {orbit.role="output",orbit.name="C"}) attributes {orbit.noalias, llvm.emit_c_interface} {
    %x = memref.alloc() {orbit.name="X"} : memref<16xf32>
    %xd = taskflow.task @produce will_reads(%a : memref<16xf32>) will_writes(%x : memref<16xf32>) [original_read_memrefs(%a : memref<16xf32>), original_write_memrefs(%x : memref<16xf32>)] : (memref<16xf32>,memref<16xf32>) -> memref<16xf32> {
    ^bb0(%in: memref<16xf32>,%out: memref<16xf32>):
      affine.for %i=0 to 16 {
        %v=affine.load %in[%i] : memref<16xf32>
        %two=arith.constant 2.0 : f32
        %r=arith.mulf %v,%two : f32
        affine.store %r,%out[%i] : memref<16xf32>
      }
      taskflow.yield done_writes(%out : memref<16xf32>)
    }
    %bd = taskflow.task @first will_reads(%xd : memref<16xf32>) will_writes(%b : memref<16xf32>) [original_read_memrefs(%xd : memref<16xf32>), original_write_memrefs(%b : memref<16xf32>)] : (memref<16xf32>,memref<16xf32>) -> memref<16xf32> {
    ^bb0(%in: memref<16xf32>,%out: memref<16xf32>):
      affine.for %i=0 to 16 {
        %v=affine.load %in[%i] : memref<16xf32>
        affine.store %v,%out[%i] : memref<16xf32>
      }
      taskflow.yield done_writes(%out : memref<16xf32>)
    }
    %cd = taskflow.task @second will_reads(%xd,%bd : memref<16xf32>,memref<16xf32>) will_writes(%c : memref<16xf32>) [original_read_memrefs(%xd,%bd : memref<16xf32>,memref<16xf32>), original_write_memrefs(%c : memref<16xf32>)] : (memref<16xf32>,memref<16xf32>,memref<16xf32>) -> memref<16xf32> {
    ^bb0(%in: memref<16xf32>,%orderOnly: memref<16xf32>,%out: memref<16xf32>):
      affine.for %i=0 to 16 {
        %v=affine.load %in[%i] : memref<16xf32>
        affine.store %v,%out[%i] : memref<16xf32>
      }
      taskflow.yield done_writes(%out : memref<16xf32>)
    }
    memref.dealloc %x : memref<16xf32>
    return
  }
}
'''.replace('16xf32',str(size)+'xf32').replace('to 16 {','to '+str(size)+' {')


def prepare(case,output,m,k,n,size,seeds):
    output.mkdir(parents=True,exist_ok=False)
    if case=='fanout':
        source=fanout_source(size);reference='B=C=2*A using float64, then cast final outputs to f32'
        expected=dict(source_tasks=3,logical_data_dependencies=[['input:A','produce'],['produce','first'],['produce','second']],ordering_only=[['first','second']],X_bytes=4*size,policy_scope='CPU whole-task exact-region; no claim of arbitrary NPU cross-stage shared SRAM')
    else:
        original=ORBIT_SRC/'test/TaskflowAIR/fixtures/gemm-scale.mlir';source=original.read_text()
        shapes={'4x8':f'{m}x{k}','8x4':f'{k}x{n}','4x4':f'{m}x{n}'}
        source=re.sub(r'(?<=memref<)\d+x\d+(?=xf32)',lambda match:shapes[match[0]],source)
        source=re.sub(r'affine.for %(i|j|k) = 0 to \d+',lambda match:f'affine.for %{match[1]} = 0 to '+str(dict(i=m,j=n,k=k)[match[1]]),source)
        reference='Y=.5*(float64(A)@float64(B)), cast final output to f32; device retains ordered K FP32'
        expected=dict(source_tasks=2,logical_data_dependencies=[['gemm','scale']],ordering_only=[],M=m,K=k,N=n,policy_scope='Native tiling/phase-local or source-proven readonly B panel; C++ owns all planning')
    if any(x in source for x in ['orbit.mapping','orbit.air_tile_sizes','air.dma','channel','FIFO']):raise ValueError('fixture contains mapping/backend decisions')
    (output/'source.mlir').write_text(source)
    for seed in seeds:
        rng=np.random.default_rng(seed)
        if case=='fanout':
            a=rng.uniform(-.5,.5,(size,)).astype(np.float32);a[0]=0;y=(2*a.astype(np.float64)).astype(np.float32);inputs=dict(A=a);refs=dict(B=y,C=y.copy())
        else:
            a=rng.uniform(-.5,.5,(m,k)).astype(np.float32);b=rng.uniform(-.5,.5,(k,n)).astype(np.float32);a.flat[0]=b.flat[0]=0;inputs=dict(A=a,B=b);refs=dict(Y=(.5*(a.astype(np.float64)@b.astype(np.float64))).astype(np.float32))
        np.savez(output/f'inputs-{seed}.npz',**inputs);np.savez(output/f'reference-{seed}.npz',**refs)
    if case=='fanout':
        architecture=dict(domains=[dict(id='system',parent='',kind='system'),dict(id='device',parent='system',kind='device')],
            resources=[dict(id='cpu',kind='compute',device='cpu',capacity=1,domain='system'),dict(id='accelerator',kind='compute',device='accel',capacity=1,domain='device'),dict(id='dma',kind='transfer',device='system',capacity=1,domain='device')],
            memories=[dict(id='dram',kind='dram',domain='system',capacity_bytes=max(4096,8*size),accessible_devices=['cpu','accel'],accessible_resources=['cpu']),dict(id='sram',kind='shared-sram',domain='device',capacity_bytes=12*size,accessible_devices=['accel'],accessible_resources=['accelerator'])],
            links=[dict(id='import',source='dram',target='sram',resource='dma',domain='device',latency_ms=.1,bandwidth_bytes_per_ms=4*size,provenance=dict(kind='synthetic',source='v11 explicit CPU fixture test parameters; not measured hardware'))],
            assumptions=dict(initial_locations={'A':'dram'},output_locations={'B':'sram','C':'sram'}))
        placements=[dict(task=t,resource='cpu' if t==0 else 'accelerator',memory='dram' if t==0 else 'sram',implementation='scalar') for t in range(3)]
        estimates=[dict(task=p['task'],resource=p['resource'],implementation='scalar',duration=1,unit='ms',model='synthetic',model_version='v11-fixture',provenance='explicit CPU fixture duration, no calibration/model training',boundary='compute only supplied inputs',transfer_accounting='excludes_inter_task_transfers',supply_conditions_verified=True,included_costs=['body compute'],excluded_costs=['inter-task transfers']) for p in placements]
        for policy in ['phase-local','retain-across-users']:
            save(output/(policy+'.config.json'),dict(program_graph=dict(adapter='whole-task',architecture=architecture,choice=dict(policy=policy,placements=placements,compute_estimates=estimates))))
        topology=json.loads(json.dumps(architecture))
        topology['domains'] += [dict(id='tile0',parent='device',kind='tile'),dict(id='tile1',parent='device',kind='tile')]
        topology['resources'][1]['domain']='tile0'
        topology['resources'].append(dict(id='accelerator1',kind='compute',device='accel',capacity=1,domain='tile1'))
        topology['memories'][1]['accessible_resources']=['accelerator','accelerator1']
        topo_places=json.loads(json.dumps(placements));topo_places[2]['resource']='accelerator1'
        topo_estimates=json.loads(json.dumps(estimates));topo_estimates[2]['resource']='accelerator1'
        save(output/'shared-sram-retain.config.json',dict(program_graph=dict(adapter='whole-task',architecture=topology,choice=dict(policy='retain-across-users',placements=topo_places,compute_estimates=topo_estimates))))
        locals_arch=json.loads(json.dumps(topology))
        for number in [0,1]:
            locals_arch['memories'].append(dict(id='local'+str(number),kind='local-sram',domain='tile'+str(number),capacity_bytes=12*size,accessible_devices=['accel'],accessible_resources=['accelerator' if number==0 else 'accelerator1']))
            link=json.loads(json.dumps(architecture['links'][0]));link.update(id='to-local'+str(number),source='sram',target='local'+str(number));locals_arch['links'].append(link)
        local_places=json.loads(json.dumps(topo_places));local_places[1]['memory']='local0';local_places[2]['memory']='local1'
        locals_arch['assumptions']['output_locations']={'B':'local0','C':'local1'}
        for name,policy in [('separate-locals-retain','retain-across-users'),('separate-locals-phase','phase-local')]:
            save(output/(name+'.config.json'),dict(program_graph=dict(adapter='whole-task',architecture=locals_arch,choice=dict(policy=policy,placements=local_places,compute_estimates=topo_estimates))))
    save(output/'fixture.json',dict(schema='orbit.program-graph.fixture.v11',case=case,seeds=seeds,reference=reference,expected_source_facts=expected,precision='f32',acceptance=dict(finite=True,atol=1e-5,rtol=1e-5),source_sha256=sha(output/'source.mlir'),generator_sha256=sha(__file__),files={p.name:sha(p) for p in sorted(output.iterdir()) if p.is_file()}))


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--case',choices=['all','fanout','gemm-scale'],default='all');p.add_argument('--output',type=Path,required=True)
    for key,default in [('m',32),('k',128),('n',64),('size',16)]:p.add_argument('--'+key,type=int,default=default)
    p.add_argument('--seeds',type=int,nargs='+',default=[11,23,47]);a=p.parse_args()
    if min(a.m,a.k,a.n,a.size)<=0 or not a.seeds or len(set(a.seeds))!=len(a.seeds):p.error('positive shapes and unique seeds required')
    out=a.output.resolve()
    if a.case=='all':
        out.mkdir(parents=True,exist_ok=False)
        for case in ['fanout','gemm-scale']:prepare(case,out/case,a.m,a.k,a.n,a.size,a.seeds)
        save(out/'preparation.json',dict(cases=['fanout','gemm-scale'],device_submissions=0,planner='native C++ only; fixture generator emits source computation/dependency and references'))
    else:prepare(a.case,out,a.m,a.k,a.n,a.size,a.seeds)
    print(json.dumps(dict(status='prepared',output=str(out),device_submissions=0)))


if __name__=='__main__':main()
