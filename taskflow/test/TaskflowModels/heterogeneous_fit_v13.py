#!/usr/bin/env python3
"""CPU-only synthetic timing contract tests. This does not calibrate a device."""
import argparse
import copy
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('fitter', HERE/'fit_heterogeneous_cost_v13.py')
fitter = importlib.util.module_from_spec(spec)
spec.loader.exec_module(fitter)


def save(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2)+'\n')


def run(output):
    output.mkdir(parents=True, exist_ok=False)
    checks = []
    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp)
        dataset = root/'dataset'
        subprocess.run([sys.executable, str(HERE.parent/'TaskflowAIR'/'prepare_heterogeneous_v13.py'),
                        '--output', str(dataset), '--freeze-protocol'], check=True, capture_output=True)
        frozen = dataset/'manifest.json'
        data = fitter.read(frozen)
        profiles, cases = root/'profile', []
        samples = []
        for case in data['cases']:
            if case['split'] != 'training':
                continue
            for device in ('cpu','npu'):
                name = case['name']+'-'+device
                base = root/'compiled'/name
                base.mkdir(parents=True)
                binary = base/'binary'; binary.write_bytes(b'synthetic-not-executable')
                regions, compiled_regions = [], []
                # One 1-task and one 2-task region per case, both dimensions.
                for index,tasks in enumerate(([0],[1,2])):
                    child = base/f'child-{index}.mlir'; child.write_text('synthetic source identity')
                    regions.append(dict(index=index,device=device,tasks=tasks,source=str(child),
                        work_elements=len(tasks)*case['shape'][0]*case['shape'][1],model_operations_supported=True))
                    executable = dict(index=index,device=device,source_sha256=fitter.sha(child))
                    if device == 'cpu':
                        executable.update(library=str(binary),library_sha256=fitter.sha(binary))
                    else:
                        executable['artifact']=dict(elf_path=str(binary),elf_sha256=fitter.sha(binary))
                    compiled_regions.append(executable)
                manifest = base/'manifest.json'
                save(manifest,dict(schema='orbit.heterogeneous.static.v13',id=name,regions=regions,
                    program_family_key='synthetic-fixed-family',execution_contract_identity='synthetic-fixed-execution-contract',
                    storage=[dict(name=n,role=r,dtype='f32',shape=case['shape'],bytes=4*case['shape'][0]*case['shape'][1])
                             for n,r in [('A','input'),('B','input'),('T','temporary'),('U','temporary'),('C','output')]]))
                compiled = base/'compiled.json'
                save(compiled,dict(schema='orbit.heterogeneous.compiled.v13',manifest=str(manifest),
                    manifest_sha256=fitter.sha(manifest),plan_id=name,regions=compiled_regions))
                save(profiles/name/'preparation.json',dict(plan_id=name,manifest_sha256=fitter.sha(manifest),compiled_sha256=fitter.sha(compiled)))
                pair = case['arrays'][0]
                cases.append(dict(name=name,compiled=str(compiled),inputs=[str(dataset/pair['inputs']['path'])],reference=[str(dataset/pair['reference']['path'])]))
                for repeat in range(2):
                    # Synthetic 1ms + 2ms region, 0.5ms boundary, warmup intentionally different.
                    multiplier=10 if repeat == 0 else 1
                    calls=[dict(region=0,start_ns=1000000,end_ns=1000000+1000000*multiplier),
                           dict(region=1,start_ns=2000000+1000000*multiplier,end_ns=2000000+3000000*multiplier)]
                    result=dict(warmup=repeat==0,passed=True,wall_ms=3*multiplier+0.5,
                        input_reset_in_timing=True,final_output_copy_in_timing=True,region_calls=calls,
                        events=[dict(kind='host_input_reset',start_ns=0,end_ns=50000),
                                dict(kind='host_input_reset',start_ns=0,end_ns=50000),
                                dict(kind='host_final_output_copy',start_ns=0,end_ns=100000)])
                    path=profiles/name/'seed-0'/f'repeat-{repeat}'
                    save(path/'result.json',result)
                    shutil.copyfile(dataset/pair['reference']['path'],path/'outputs.npz')
                    samples.append(dict(case=name,seed_index=0,repeat=repeat,**result))
        save(profiles/'summary.json',dict(status='passed',samples=samples))
        cases_path=root/'cases.json'; save(cases_path,dict(cases=cases))
        model,audit=fitter.fit(frozen,[profiles],[cases_path])
        assert model['program_family_key']=='synthetic-fixed-family'
        assert model['execution_contract_identity']=='synthetic-fixed-execution-contract'
        checks.append('model binds one native source family and execution contract')
        assert len(audit['samples'])==8 and audit['timing_label_samples']==4
        checks.append('all raw outputs independently checked; warmup labels excluded')
        for row in model['region_models']:
            assert row['status']==('calibrated' if row['task_count']<3 else 'uncalibrated')
            assert all(k['ms']==row['task_count'] for k in row['knots'])
        assert all(k['ms']==0.5 and k['n']==2 for k in model['boundary_model']['knots'])
        checks.append('per-device/count medians; exact residual boundary; missing rows uncalibrated')
        assert model['interpolation']['extrapolation'] is False
        checks.append('inclusive measured interpolation only; no extrapolation contract')
        def rejected(label, action, restore):
            action()
            try:
                fitter.fit(frozen,[profiles],[cases_path])
            except (ValueError, KeyError):
                checks.append(label)
            else:
                raise AssertionError('accepted: '+label)
            finally:
                restore()
        original_cases=copy.deepcopy(cases)
        hold=next(c for c in data['cases'] if c['split']=='holdout')['arrays'][0]
        bad=copy.deepcopy(cases);bad[0]['inputs']=[str(dataset/hold['inputs']['path'])];bad[0]['reference']=[str(dataset/hold['reference']['path'])]
        rejected('holdout arrays rejected before reading any timing labels',lambda:save(cases_path,dict(cases=bad)),lambda:save(cases_path,dict(cases=original_cases)))
        path=root/'compiled'/cases[0]['name']/'manifest.json'
        original=fitter.read(path);bad=copy.deepcopy(original);bad['regions'][0]['work_elements']=1
        rejected('native manifest tampering rejected',lambda:save(path,bad),lambda:save(path,original))
        # Rebind modified manifests coherently, so these test domain identity rather than a SHA failure.
        compiled_path=Path(cases[0]['compiled'])
        prep_path=profiles/cases[0]['name']/'preparation.json'
        compiled_original=fitter.read(compiled_path);prep_original=fitter.read(prep_path)
        def change_identity(field, value):
            changed=copy.deepcopy(original)
            if value is None:
                del changed[field]
            else:
                changed[field]=value
            save(path,changed)
            compiled_changed=copy.deepcopy(compiled_original)
            compiled_changed['manifest_sha256']=fitter.sha(path)
            save(compiled_path,compiled_changed)
            prep_changed=copy.deepcopy(prep_original)
            prep_changed['manifest_sha256']=fitter.sha(path)
            prep_changed['compiled_sha256']=fitter.sha(compiled_path)
            save(prep_path,prep_changed)
        def restore_identities():
            save(path,original);save(compiled_path,compiled_original);save(prep_path,prep_original)
        for field in ('program_family_key','execution_contract_identity'):
            rejected('missing '+field+' rejected',lambda f=field:change_identity(f,None),restore_identities)
            rejected('mismatched '+field+' rejected',lambda f=field:change_identity(f,'different-identity'),restore_identities)
        rawpath=profiles/cases[0]['name']/'seed-0'/'repeat-1'/'outputs.npz'
        original_bytes=rawpath.read_bytes()
        import numpy as np
        def corrupt():
            np.savez(rawpath,C=np.full(data['cases'][0]['shape'],float('nan'),dtype=np.float32))
        rejected('raw numerical failure rejected independently of passed flag',corrupt,lambda:rawpath.write_bytes(original_bytes))
        save(output/'summary.json',dict(status='passed',checks=checks,count=len(checks),
            synthetic_timings=True,device_submissions=0,device_calibration=False))
    print(json.dumps(dict(status='passed',checks=len(checks),output=str(output))))


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,required=True)
    run(parser.parse_args().output)
