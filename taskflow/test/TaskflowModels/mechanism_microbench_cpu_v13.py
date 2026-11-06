#!/usr/bin/env python3
"""CPU-only protocol gates and split-isolation tests; no device calibration."""
import argparse
import copy
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
from types import SimpleNamespace
from unittest.mock import patch


def save(path,value):
    path.write_text(json.dumps(value,indent=2)+'\n')


class Array:
    def __init__(self,size,data=None):self.data=bytearray(size) if data is None else data
    def fill(self,value):self.data[:]=bytes([value])*len(self.data)
    def sum(self,dtype=None):return sum(self.data)


class FakeNumpy:
    uint8='uint8'
    @staticmethod
    def empty(size,dtype):return Array(size)
    @staticmethod
    def frombuffer(data,dtype,count):return Array(count,data)
    @staticmethod
    def copyto(destination,source,casting):destination.data[:]=source.data
    @staticmethod
    def array_equal(a,b):return a.data==b.data
    @staticmethod
    def load(path):return {}


class FakeBO:
    def __init__(self,size):self.data=bytearray(size)
    def map(self):return self.data
    def sync(self,direction,size,offset):assert size==len(self.data) and offset==0


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--bench',type=Path,required=True)
    parser.add_argument('--protocol',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args();args.output.mkdir(parents=True,exist_ok=False)
    spec=importlib.util.spec_from_file_location('mechanism_under_test',args.bench)
    bench=importlib.util.module_from_spec(spec);spec.loader.exec_module(bench)
    protocol=bench.load_protocol(args.protocol);results=[]
    blockers=args.output/'blocked-imports';blockers.mkdir()
    for name in ('numpy','pyxrt','triton'):
        (blockers/(name+'.py')).write_text("raise RuntimeError('device/numerical runtime import forbidden in validate-only')\n")
    environment=dict(os.environ,PYTHONPATH=str(blockers))
    for split in ('training','holdout'):
        out=args.output/('validate-'+split)
        command=[sys.executable,str(args.bench),'--protocol',str(args.protocol),'--split',split,'--output',str(out),'--validate-only']
        run=subprocess.run(command,env=environment,capture_output=True,text=True)
        (args.output/(split+'.stdout')).write_text(run.stdout);(args.output/(split+'.stderr')).write_text(run.stderr)
        assert run.returncode==0,run.stderr
        assert json.loads((out/'identity.json').read_text())['split']==split
        assert json.loads((out/'validation.json').read_text())['device_opened'] is False
        assert not (out/'memory-samples.json').exists()
        results.append('validate-only-'+split+'-blocks-runtime-import')
    mutations=[('schema',lambda p:p.update(schema='invalid')),
        ('overlap',lambda p:p['holdout'].update(sizes_bytes=p['train']['sizes_bytes'][:1])),
        ('count',lambda p:p['train'].update(counts=[0])),
        ('state',lambda p:p.update(states=['guessed-device-dirty'])),
        ('direction',lambda p:p.update(directions=['INVALID'])),
        ('executor',lambda p:p['executor'].update(sha256='0'*64))]
    for name,mutate in mutations:
        bad=copy.deepcopy(protocol);mutate(bad);path=args.output/(name+'.json');save(path,bad)
        try:bench.load_protocol(path)
        except (ValueError,KeyError):results.append('reject-'+name)
        else:raise AssertionError('invalid protocol accepted: '+name)
    # Exercise the actual split loops with byte-array/BO stubs. These synthetic
    # durations are test artifacts, never training/calibration measurements.
    tiny=copy.deepcopy(protocol)
    tiny.update(train={'sizes_bytes':[2],'counts':[1]},holdout={'sizes_bytes':[3],'counts':[2]},
                states=['host-written','host-read'],warmups=0,repeats=1,
                prepare_repeats=1,program_warmups=0,program_repeats=1)
    sizes=[]
    def allocate(device,size):sizes.append(size);return FakeBO(size)
    xrt=SimpleNamespace(ext=SimpleNamespace(bo=allocate),xclBOSyncDirection=SimpleNamespace(
        XCL_BO_SYNC_BO_TO_DEVICE=1,XCL_BO_SYNC_BO_FROM_DEVICE=2))
    for split,expected in [('training',2),('holdout',3)]:
        out=args.output/('synthetic-memory-'+split);out.mkdir();sizes.clear()
        with patch.dict(sys.modules,{'numpy':FakeNumpy}):rows=bench.memory_benches(tiny,out,xrt,None,split)
        assert sizes==[expected] and {r['split'] for r in rows}=={split}
        assert {r['bytes_per_call'] for r in rows if r['mechanism']!='timer-empty'}=={expected}
        results.append('memory-executes-only-'+split)
    cases=[]
    for split in ('training','holdout'):
        compiled=args.output/(split+'.compiled.json');save(compiled,{'synthetic':True})
        data=args.output/(split+'.data.json');save(data,{})
        cases.append(dict(name=split,split=split,compiled=str(compiled),inputs=[str(data)],reference=[str(data)]))
    tiny['program_cases']=cases
    for split in ('training','holdout'):
        created=[]
        class Prepared:
            def __init__(self,path):
                assert Path(path).name==split+'.compiled.json','wrong split constructor called'
                created.append(path);self.manifest={'id':'synthetic','execution_contract_identity':'synthetic'}
                self.runtime_identity={};self.pointer_identity={};self.abi_pointer_proof=[]
            def close(self):pass
            def one(self,*args):return dict(passed=True,wall_ms=1,checks={},events=[],region_calls=[])
        out=args.output/('synthetic-program-'+split);out.mkdir()
        with patch.object(bench,'load_executor',return_value=SimpleNamespace(Prepared=Prepared)),patch.dict(sys.modules,{'numpy':FakeNumpy}):
            rows=bench.program_benches(tiny,out,split)
        assert len(created)==1 and {r['split'] for r in rows}=={split}
        assert not (out/('holdout' if split=='training' else 'training')).exists()
        results.append('program-executes-only-'+split)
    save(args.output/'summary.json',dict(status='passed',checks=len(results),results=results,
         device_opened=False,synthetic_timings_not_calibration=True))
    print(json.dumps(dict(status='passed',checks=len(results))))


if __name__=='__main__':main()
