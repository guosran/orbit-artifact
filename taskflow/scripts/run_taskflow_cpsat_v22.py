#!/usr/bin/env python3
"""Reproduce native CP-SAT placement, final AIE contracts and serial NPU trials.

Python supplies arithmetic fixtures, compilation orchestration and independent
numeric references. All partition, reuse, placement and legality decisions live
in the C++ compiler. Load the existing aie-toy/scripts/env.sh first.
"""
import argparse
import fcntl
import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import statistics
import subprocess
import sys

HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE))
from taskflow_direct_air_execute import compile_air,run_artifact
import numpy as np


def save(path,value):path.write_text(json.dumps(value,indent=2)+'\n')
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def load(path):return json.loads(path.read_text())


def generator():
    spec=importlib.util.spec_from_file_location('fixtures',HERE.parent/'test/TaskflowAIR/prepare_data_reuse_v21.py')
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module


def worker(variant,fixture,output):
    output.mkdir(parents=True,exist_ok=False)
    artifact=load(variant/'hardware/compile.json');abi=load(variant/'abi.json')
    assert load(variant/'implementation-contract.json')['valid']
    assert sha(Path(artifact['elf_path']))==artifact['elf_sha256']
    rows=[]
    with open('/tmp/npu.lock','w') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX)
        for seed in (11,23,47):
            directory=output/str(seed);directory.mkdir()
            inputs=dict(np.load(fixture/f'inputs-{seed}.npz'))
            reference=dict(np.load(fixture/f'reference-{seed}.npz'))
            exact=dict(np.load(fixture/f'reference-f64-{seed}.npz'))
            result=run_artifact(artifact,abi,inputs,reference,directory,5,1e-5,1e-5,2)
            assert result['status']=='passed'
            assert all(n==1 for n in result['actual_submissions'])
            for sample in directory.glob('outputs-*.npz'):
                for name,value in dict(np.load(sample)).items():
                    assert np.isfinite(value).all() and np.allclose(value,exact[name],atol=1e-5,rtol=1e-5)
            rows.append(dict(seed=seed,median_ms=result['median_ms'],fp32_and_fp64_passed=True))
    save(output/'result.json',dict(status='PASS',seeds=rows))


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--tool',type=Path);p.add_argument('--config',type=Path);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--execute',action='store_true');p.add_argument('--worker',type=Path);p.add_argument('--fixture',type=Path)
    a=p.parse_args()
    if a.worker:return worker(a.worker,a.fixture,a.output)
    assert a.tool and a.config
    a.output.mkdir(parents=True,exist_ok=False);a.output=a.output.resolve();tool=a.tool.resolve()
    prepare=generator();cases=[]
    for rows,cols in ((17,64),(31,64)):
        cases.append((f'chain-{rows}x{cols}',dict(m=rows,n=cols,inputs=['I'],outputs=['R'],steps=[('T','add',['I'],1.),('R','mul',['T'],2.)]),(1,2)))
    cases.append(('fork-join-17x64',dict(m=17,n=64,inputs=['I'],outputs=['R'],steps=[
        ('X','add',['I'],1.),('Y','mul',['X'],2.),('Z','sub',['X'],1.),('R','add',['Y','Z'],None)]),(1,2)))
    cases.append(('chain-17x136-tail',dict(m=17,n=136,inputs=['I'],outputs=['R'],steps=[('T','add',['I'],1.),('R','mul',['T'],2.)]),(2,)))
    summary=[]
    save(a.output/'provenance.json',dict(tool=str(tool),tool_sha256=sha(tool),driver_sha256=sha(Path(__file__)),fixture_generator_sha256=sha(Path(prepare.__file__)),configuration=load(a.config),execute=a.execute,
        timing_scope='existing observed host-to-host runner; includes wait checkpoint serialization; no isolated device or overlap timing claim'))
    for name,fixture,counts in cases:
        case=a.output/name;case.mkdir();data=case/'fixture';data.mkdir()
        src=data/'source.mlir';src.write_text(prepare.source(fixture).replace('@data_reuse','@'+name.replace('-','_')))
        save(data/'fixture.json',fixture)
        for seed in (11,23,47):
            arrays=prepare.inputs_and_references(fixture,seed,0)
            for prefix,values in zip(('inputs','reference','reference-f64'),arrays):np.savez(data/f'{prefix}-{seed}.npz',**values)
        variants={}
        for count in counts:
            variant=case/f'cores-{count}';variants[count]=variant
            command=[str(tool),str(src),'--lower-multicore-to-air='+str(variant),'--npu-shards='+str(count),'--target-config='+str(a.config.resolve())]
            subprocess.run(command,check=True,capture_output=True,text=True,timeout=30)
            artifact=compile_air(variant/'program.air.mlir',variant/'hardware',stack_size=8192,omit_ping_pong=True)
            final=variant/'final-aie.generic.mlir'
            subprocess.run(['air-opt',str(variant/'hardware/air_project/npu.input.air.mlir'),'--mlir-print-op-generic','-o',str(final)],check=True,timeout=30)
            check=[str(tool),str(src),'--check-multicore-aie='+str(final),'--npu-shards='+str(count),'--target-config='+str(a.config.resolve()),'--implementation-output='+str(variant/'implementation-contract.json')]
            subprocess.run(check,check=True,capture_output=True,text=True,timeout=30)
            save(variant/'commands.json',dict(lower=command,check=check))
        trials=[]
        if a.execute:
            for repeat in range(3):
                for count in (counts if repeat%2==0 else tuple(reversed(counts))):
                    output=variants[count]/f'fresh-process-{repeat}'
                    command=[sys.executable,str(Path(__file__).resolve()),'--worker',str(variants[count]),'--fixture',str(data),'--output',str(output)]
                    r=subprocess.run(command,capture_output=True,text=True,timeout=60)
                    (variants[count]/f'fresh-process-{repeat}.stderr').write_text(r.stderr)
                    assert r.returncode==0,(name,count,repeat,r.stderr)
                    trials.append(dict(cores=count,repeat=repeat,**load(output/'result.json')))
        medians={str(count):statistics.median(s['median_ms'] for t in trials if t['cores']==count for s in t['seeds']) for count in counts} if trials else {}
        row=dict(case=name,variants=list(counts),trials=trials,median_of_seed_medians_ms=medians,
            ratio_one_over_two=medians.get('1',0)/medians['2'] if '1' in medians and '2' in medians else None)
        summary.append(row);save(a.output/'result.json',dict(status='PASS',cases=summary))
        print(json.dumps(dict(case=name,medians_ms=medians)),flush=True)
    assert sha(tool)==load(a.output/'provenance.json')['tool_sha256'],'compiler changed during experiment'


if __name__=='__main__':main()
