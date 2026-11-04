#!/usr/bin/env python3
"""CPU protocol mocks for profiling hooks; never imports XRT or opens a device."""
import argparse
import builtins
from unittest.mock import patch
import importlib.util
import json
from pathlib import Path
import sys
from types import SimpleNamespace
import numpy as np
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'python'))
from taskflow_paths import ARTIFACT_ROOT
spec=importlib.util.spec_from_file_location('ffn_profile',ARTIFACT_ROOT/'scripts/taskflow_ffn_profile.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)


class BO:
    def __init__(self,device,size):self.memory=bytearray(size)
    def map(self):return memoryview(self.memory)
    def sync(self,direction):pass


class Run:
    def __init__(self,kernel):self.args={}
    def set_arg(self,index,bo):
        assert isinstance(bo,BO),'observer must unwrap real BO before API set_arg'
        self.args[index]=bo
    def start(self):
        # Test-only device stand-in: duplicate input bytes without numpy.copyto,
        # so this mock does not produce a bogus host BO-write event.
        self.args[1].memory[:]=self.args[0].memory


class Runner:
    """Small public-protocol fake: reuse BOs and existing-style staging/readback."""
    def __init__(self,*args):
        self._xrt=SimpleNamespace(ext=SimpleNamespace(bo=BO),run=Run)
        self._bos={};self.device=None;self.kernel=None
    def run(self,arrays,*,bo_key,static_indices=(),intermediate_indices=(),output_indices=()):
        first=bo_key not in self._bos
        if first:self._bos[bo_key]=[self._xrt.ext.bo(None,a.nbytes) for a in arrays]
        bos=self._bos[bo_key]
        for i,a in enumerate(arrays):
            if not first and i in set(static_indices)|set(intermediate_indices):continue
            if i in intermediate_indices:a.fill(0)
            np.copyto(np.frombuffer(bos[i].map(),np.uint8),a.view(np.uint8),casting='no')
            bos[i].sync('TO_DEVICE')
        run=self._xrt.run(None)
        for i,b in enumerate(bos):run.set_arg(i,b)
        run.start();module._wait(run)
        result={}
        for i in output_indices:
            bos[i].sync('FROM_DEVICE');result[i]=np.frombuffer(bos[i].map(),arrays[i].dtype)
        return result

    def unload(self):self._bos={}


module=SimpleNamespace(_wait=lambda run:None)

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
    abi=dict(buffers=[dict(name='X',dtype='f32',shape=[4]),dict(name='Y',dtype='f32',shape=[4])],outputs=['Y'])
    case=dict(abi=abi,outputs={1},static={0},scratch=set())
    inputs=dict(X=np.array([0,1,-2,1e-8],dtype=np.float32));reference=dict(Y=inputs['X'].copy())
    checks=[];outputs_by_mode={};original_copy=np.copyto;original_wait=module._wait
    for detailed in [False,True]:
        runner=Runner();recorder=m.Recorder(detailed);samples=[]
        for repeat in range(2):
            with m.observe(runner,module,recorder):got,sample=m.measure(runner,module,case,inputs,reference,recorder,detailed)
            assert np.copyto is original_copy and module._wait is original_wait
            assert sample['checks']['Y']['passed']
            outputs_by_mode[detailed]=got['Y'];samples.append(sample)
        if detailed:
            events=[e for s in samples for e in s['events']]
            assert sum(e['kind']=='bo_allocate' for e in events)==2
            assert [sum(e['kind']=='numpy_copyto_in_runner' for e in s['events']) for s in samples]==[2,1]
            assert [sum(e['kind']=='bo_sync' and e['direction']=='TO_DEVICE' for e in s['events']) for s in samples]==[2,1]
            assert all(sum(e['kind']=='xrt_start' for e in s['events'])==sum(e['kind']=='xrt_wait' for e in s['events'])==1 for s in samples)
            assert all(e['end_ns']>=e['start_ns']>=0 and e['observer_record_ns']>=0 for e in events)
            trace=m.trace_event(samples[0]['events'][0],0,'mock');assert trace['cat']=='host-observation-not-device' and trace['ph']=='X'
            assert samples[0]['checks']['Y']['near_zero_max_abs']==0
        else:assert all(not s['events'] and s['observer_record_ms'] is None for s in samples)
        checks.append('detailed cached BO/API counts' if detailed else 'minimal no API hooks')
        m.save(a.output/('detailed-samples.json' if detailed else 'minimal-samples.json'),samples)
    assert np.array_equal(outputs_by_mode[True],outputs_by_mode[False]);checks.append('identical algorithm/results in observer modes')
    # Restore hooks even when installed wait fails; retain failure event.
    runner=Runner();recorder=m.Recorder();module._wait=lambda run:(_ for _ in ()).throw(RuntimeError('mock timeout'))
    failing_wait=module._wait
    try:
        with m.observe(runner,module,recorder):m.measure(runner,module,case,inputs,reference,recorder,True)
    except RuntimeError:pass
    else:raise AssertionError('wait failure was swallowed')
    assert module._wait is failing_wait and np.copyto is original_copy
    assert any(e['kind']=='xrt_wait' and e['status']=='failed' for e in recorder.events)
    module._wait=original_wait;checks.append('failure retained and hooks restored')
    assert not m.metrics(np.array([np.inf],np.float32),np.array([0],np.float32))['passed']
    assert not m.metrics(np.array([1.1],np.float32),np.array([1],np.float32))['passed']
    for actual,expected in [(np.zeros(1,np.float64),np.zeros(1,np.float32)),(np.zeros(2,np.float32),np.zeros(1,np.float32))]:
        try:m.metrics(actual,expected)
        except ValueError:pass
        else:raise AssertionError('invalid shape/dtype admitted')
    checks.append('finite/tolerance/shape/FP32 contract')
    # Case input overrides are independent from ABI/core source paths and retain
    # literal compiled identities; no actual ELF load is performed by resolver.
    package=a.output/'package';package.mkdir();(package/'program.elf').write_bytes(b'CPU fixture, not executable')
    m.save(package/'abi.json',abi)
    m.save(package/'compile.json',dict(status='compiled',elf_sha256=m.digest(package/'program.elf'),kernel_name='main:mock'))
    m.save(a.output/'cases.json',[dict(name='mock',hardware='package',inputs=['in-11.npz','in-23.npz'],reference=['ref-11.npz','ref-23.npz'],static_indices=[0])])
    resolved=m.resolve_cases(a.output/'cases.json')[0]
    assert resolved['input_paths']==[(a.output/'in-11.npz').resolve(),(a.output/'in-23.npz').resolve()]
    assert resolved['reference_paths']==[(a.output/'ref-11.npz').resolve(),(a.output/'ref-23.npz').resolve()]
    assert resolved['static']=={0}
    (package/'program.elf').write_bytes(b'changed identity')
    try:m.resolve_cases(a.output/'cases.json')
    except ValueError:pass
    else:raise AssertionError('changed ELF admitted')
    checks.append('per-case seed paths and pre-device ELF identity')
    # End-to-end CLI orchestration, file evidence and timing with no real runtime.
    (package/'program.elf').write_bytes(b'CPU fixture, not executable')
    m.save(a.output/'main-cases.json',[dict(name='mock',hardware='package',static_indices=[0])])
    np.savez(a.output/'in.npz',**inputs);np.savez(a.output/'ref.npz',**reference)
    main_output=a.output/'mock-cli'
    arguments=['profile','--cases',str(a.output/'main-cases.json'),'--inputs',str(a.output/'in.npz'),
        '--reference',str(a.output/'ref.npz'),'--output',str(main_output),'--iterations','2','--warmups','1']
    real_import=builtins.__import__
    def mock_import(name,*args,**kwargs):
        if name=='triton.backends.amd_triton_npu':return SimpleNamespace(multilaunch=module)
        return real_import(name,*args,**kwargs)
    def mock_open(path,*args,**kwargs):
        if str(path)=='/tmp/npu.lock':path=a.output/'mock-lock'
        return builtins.open(path,*args,**kwargs)
    module.MultiLaunchRunner=Runner;module.__file__=__file__
    with patch.object(sys,'argv',arguments),patch.object(builtins,'__import__',side_effect=mock_import),patch.object(m,'open',mock_open,create=True):
        assert m.main()==0
    costs=json.loads((main_output/'evidence-costs.json').read_text())
    assert costs['profile_loop_wall_ms']>=costs['sum_run_walls_ms']>0
    assert costs['numeric_check_ms']>=0 and costs['context_load_ms']>=0
    assert costs['unseparated_loop_residual_ms']>=0
    for kind in ['input_file_copy','reference_file_copy','input_load','reference_load','output_npz_save','sample_checkpoint_save','progress_print']:
        assert costs['activity_ms'][kind]>=0
    assert len([e for e in costs['activities'] if e['kind']=='output_npz_save'])==3
    assert 'evidence-costs.json' in costs['final_writes_excluded']
    timeline=json.loads((main_output/'host-timeline.json').read_text());assert timeline['scope']=='HOST ONLY; no device trace'
    assert len([e for e in timeline['traceEvents'] if e['name']=='complete_run_wall'])==3
    checks.append('CPU mocked CLI I/O timing and host-only timeline')
    wait_info=json.loads((main_output/'wait-backend.json').read_text())
    assert wait_info['selected'] is False and wait_info['classification']=='unknown-unselected-or-unavailable'
    def polling(run):pass
    fake=SimpleNamespace(_wait_nogil=polling,_wait_polling=polling,_POLL_INTERVAL=.0002,__file__=__file__)
    selected=m.wait_backend_identity(fake)
    assert selected['classification']=='polling' and selected['configured_poll_interval_seconds']==.0002
    fake._wait_nogil=lambda run:None
    assert m.wait_backend_identity(fake)['classification']=='native-or-other-callable'
    checks.append('actual cached wait backend identity, including unavailable mock')

    report=dict(status='passed',checks=checks,device_submissions=0,installed_runtime_imported=False,compilation=False)
    m.save(a.output/'summary.json',report);print(json.dumps(report))


if __name__=='__main__':main()
