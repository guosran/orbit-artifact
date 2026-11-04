#!/usr/bin/env python3
"""Profile existing ELF dispatch with the installed runner; no compilation or planner.

All timestamps are host observations. Detailed hooks perturb execution; minimal
uses the identical runner/arguments without API/numpy hooks for paired control.
"""
import argparse
from contextlib import contextmanager
import fcntl
import hashlib
import json
from pathlib import Path
import shutil
import sys
import time


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def save(path, value):
    Path(path).write_text(json.dumps(value, indent=2, allow_nan=False)+'\n')


class Recorder:
    def __init__(self, enabled=True):
        self.enabled = enabled
        self.events = []
        self.last_buffer = None

    def call(self, kind, function, *args, **kwargs):
        # Metadata belongs to the event, never to the wrapped API.
        metadata = kwargs.pop('_metadata', {})
        if not self.enabled:
            return function(*args, **kwargs)
        begin = time.perf_counter_ns()
        status = 'passed'
        try:
            return function(*args, **kwargs)
        except BaseException:
            status = 'failed'
            raise
        finally:
            end = time.perf_counter_ns()
            event = dict(kind=kind, start_ns=begin, end_ns=end, status=status, **metadata)
            self.events.append(event)
            # Only a lower-bound portion of observer bookkeeping, not full hook
            # overhead: Python dispatch, timer reads and return path remain.
            event['observer_record_ns'] = time.perf_counter_ns()-end


class ProfileBO:
    def __init__(self, raw, recorder, index):
        self.raw, self.recorder, self.index = raw, recorder, index

    def __getattr__(self, name):
        return getattr(self.raw, name)

    def map(self, *args, **kwargs):
        self.recorder.last_buffer = self.index
        return self.recorder.call('bo_map', self.raw.map, *args,
                                  _metadata=dict(buffer_index=self.index), **kwargs)

    def sync(self, direction, *args, **kwargs):
        return self.recorder.call('bo_sync', self.raw.sync, direction, *args,
            _metadata=dict(buffer_index=self.index, direction=str(direction)), **kwargs)


class ProfileRun:
    def __init__(self, raw, recorder):
        self.raw, self.recorder = raw, recorder

    def __getattr__(self, name):
        return getattr(self.raw, name)

    def set_arg(self, index, value):
        return self.recorder.call('xrt_set_arg', self.raw.set_arg, index,
            value.raw if isinstance(value, ProfileBO) else value,
            _metadata=dict(buffer_index=index))

    def start(self):
        return self.recorder.call('xrt_start', self.raw.start)


class ProfileXRT:
    def __init__(self, raw, recorder):
        self.raw, self.recorder, self.next_bo = raw, recorder, 0
        self.ext = self

    def __getattr__(self, name):
        return getattr(self.raw, name)

    def bo(self, *args, **kwargs):
        index = self.next_bo
        self.next_bo += 1
        raw = self.recorder.call('bo_allocate', self.raw.ext.bo, *args,
                                 _metadata=dict(buffer_index=index), **kwargs)
        return ProfileBO(raw, self.recorder, index)

    def run(self, *args, **kwargs):
        raw = self.recorder.call('xrt_run_create', self.raw.run, *args, **kwargs)
        return ProfileRun(raw, self.recorder)


@contextmanager
def observe(runner, module, recorder):
    """Transient process-local wrappers; installed source and run logic unchanged."""
    if not recorder.enabled:
        yield
        return
    import numpy as np
    original_xrt, original_wait, original_copy = runner._xrt, module._wait, np.copyto
    runner._xrt = ProfileXRT(original_xrt, recorder)
    # Cached BOs refer to the first wrapper/recorder, so use one observer for the
    # complete context lifetime, with a fresh events list for each run.
    def wait(run):
        return recorder.call('xrt_wait', original_wait,
                             run.raw if isinstance(run, ProfileRun) else run)
    def copy(dst, src, *args, **kwargs):
        return recorder.call('numpy_copyto_in_runner', original_copy, dst, src,
            *args, _metadata=dict(buffer_index=recorder.last_buffer,
                                  bytes=int(dst.nbytes)), **kwargs)
    module._wait, np.copyto = wait, copy
    try:
        yield
    finally:
        module._wait, np.copyto, runner._xrt = original_wait, original_copy, original_xrt


def metrics(actual, expected):
    import numpy as np
    if actual.dtype != np.float32 or expected.dtype != np.float32:
        raise ValueError('profiling requires original FP32 output and independent reference')
    if actual.shape != expected.shape:
        raise ValueError('output/reference shape mismatch')
    finite = bool(np.isfinite(actual).all() and np.isfinite(expected).all())
    if not finite:
        return dict(passed=False, finite=False, shape=list(actual.shape))
    delta = np.abs(actual.astype(np.float64)-expected.astype(np.float64))
    normal = np.abs(expected)>=1e-6
    return dict(passed=bool(np.allclose(actual, expected, atol=1e-5, rtol=1e-5)),
        finite=True, shape=list(actual.shape), max_abs=float(delta.max()),
        normalized_l2=float(np.linalg.norm(delta)/max(np.linalg.norm(expected.astype(np.float64)),1e-30)),
        max_relative_reference_at_least_1e_minus6=float((delta[normal]/np.abs(expected[normal])).max()) if normal.any() else None,
        near_zero_max_abs=float(delta[~normal].max()) if (~normal).any() else None)


def prepare(abi, inputs):
    import numpy as np
    arrays=[]
    for b in abi['buffers']:
        if b['dtype']!='f32':
            raise ValueError('only unchanged FP32 ABI is supported')
        value=inputs.get(b['name'])
        if value is None:
            value=np.zeros(b['shape'],dtype=np.float32)
        if value.dtype!=np.float32 or list(value.shape)!=b['shape']:
            raise ValueError('input ABI shape/dtype mismatch: '+b['name'])
        arrays.append(np.ascontiguousarray(value))
    return arrays


def resolve_cases(path):
    rows=json.loads(path.read_text())
    if not isinstance(rows,list) or not rows:
        raise ValueError('cases must be a nonempty list')
    cases=[]
    def resolve(value):
        p=Path(value)
        return (path.parent/p).resolve() if not p.is_absolute() else p.resolve()
    for row in rows:
        name=row['name']
        if not name or Path(name).name!=name or name in ('.','..') or any(c['name']==name for c in cases):
            raise ValueError('unsafe or duplicate case name')
        compile_record=None
        if 'hardware' in row:
            hardware=resolve(row['hardware'])
            compile_record=json.loads((hardware/'compile.json').read_text())
            if compile_record['status']!='compiled':
                raise ValueError('case is not compiled')
            elf=hardware/'program.elf'
            if not elf.exists():elf=Path(compile_record['elf_path'])
            if digest(elf)!=compile_record['elf_sha256']:
                raise ValueError('ELF differs from original compile identity')
            kernel=compile_record['kernel_name'];abi_path=resolve(row['abi']) if 'abi' in row else hardware/'abi.json'
        else:
            elf=resolve(row['elf']);kernel=row['kernel'];abi_path=resolve(row['abi'])
        abi=json.loads(abi_path.read_text());outputs={i for i,b in enumerate(abi['buffers']) if b['name'] in abi['outputs']}
        if not outputs:raise ValueError('missing output ABI')
        static=set(row.get('static_indices',[]));scratch=set(row.get('intermediate_indices',[]))
        if static & outputs or static & scratch or any(not isinstance(i,int) or i<0 or i>=len(abi['buffers']) for i in static|scratch):
            raise ValueError('invalid static/scratch declarations')
        cases.append(dict(name=name,elf=str(elf),kernel=kernel,abi=abi,outputs=outputs,static=static,scratch=scratch,
            input_paths=[resolve(x) for x in ([row['inputs']] if isinstance(row.get('inputs'),str) else row.get('inputs',[]))],
            reference_paths=[resolve(x) for x in ([row['reference']] if isinstance(row.get('reference'),str) else row.get('reference',[]))],
            identity=dict(elf_sha256=digest(elf),abi_path=str(abi_path),abi_sha256=digest(abi_path),compile_record=compile_record)))
    return cases


def measure(runner, module, case, inputs, expected, recorder, detailed):
    """Identical preparation/dispatch/readback algorithm in both observer modes."""
    import numpy as np
    recorder.events=[]
    begin=time.perf_counter_ns()
    arrays=recorder.call('host_prepare',prepare,case['abi'],inputs)
    values=recorder.call('runner_run',runner.run,arrays,bo_key='profile',
        static_indices=case['static'],intermediate_indices=case['scratch'],output_indices=case['outputs'])
    def output_copy():
        return {case['abi']['buffers'][i]['name']:values[i].reshape(arrays[i].shape).copy() for i in case['outputs']}
    outputs=recorder.call('host_output_copy',output_copy)
    end=time.perf_counter_ns()
    if set(outputs)!=set(expected):
        raise ValueError('ABI output names differ from independent reference')
    check_begin=time.perf_counter_ns()
    check={name:metrics(value,expected[name]) for name,value in outputs.items()}
    check_end=time.perf_counter_ns()
    return outputs,dict(wall_start_ns=begin,wall_ms=(end-begin)/1e6,checks=check,
        numeric_check_start_ns=check_begin,numeric_check_ms=(check_end-check_begin)/1e6,
        events=[{**e,'start_ns':e['start_ns']-begin,'end_ns':e['end_ns']-begin} for e in recorder.events],
        observer_record_ms=sum(e['observer_record_ns'] for e in recorder.events)/1e6 if detailed else None,
        host_breakdown=breakdown(recorder.events) if detailed else None)


def wait_backend_identity(module):
    """Report actual cached selection; a source polling constant proves no choice."""
    import inspect
    selected=getattr(module,'_wait_nogil',None)
    owner=getattr(selected,'__module__',None)
    qualified=getattr(selected,'__qualname__',getattr(selected,'__name__',None))
    source=None
    if selected is not None:
        try:source=inspect.getsourcefile(selected)
        except (TypeError,OSError):pass
        if not source:source=getattr(sys.modules.get(owner),'__file__',None)
    module_path=getattr(module,'__file__',None)
    return dict(selected=selected is not None,module=owner,qualname=qualified,
        classification='unknown-unselected-or-unavailable' if selected is None else ('polling' if selected is getattr(module,'_wait_polling',None) else 'native-or-other-callable'),
        selected_source_path=source,selected_source_sha256=digest(source) if source and Path(source).is_file() else None,
        multilaunch_source_path=module_path,multilaunch_source_sha256=digest(module_path) if module_path and Path(module_path).is_file() else None,
        configured_poll_interval_seconds=getattr(module,'_POLL_INTERVAL',None),
        scope='Cached installed multilaunch._wait_nogil inspected after completed waits; polling interval applies only if polling was selected. Native support selection is not inferred from source constants. Missing fields remain unknown; no device timing inferred.')


def host_activity(records, kind, function, *args, **kwargs):
    """Observe outside-run evidence I/O without recursive report-write claims."""
    begin=time.perf_counter_ns()
    status='passed'
    try:
        return function(*args, **kwargs)
    except BaseException:
        status='failed'
        raise
    finally:
        records.append(dict(kind=kind,start_ns=begin,end_ns=time.perf_counter_ns(),status=status))


def breakdown(events):
    """Do not double count nested runner duration and inner API spans."""
    totals={}
    for e in events:
        key=e['kind']
        if key=='bo_sync':key+='_'+('to_device' if 'TO_DEVICE' in e['direction'] else 'from_device')
        totals[key]=totals.get(key,0)+(e['end_ns']-e['start_ns'])/1e6
    inner=sum(v for k,v in totals.items() if k not in ['runner_run','host_prepare','host_output_copy'])
    totals['runner_unseparated_residual_ms']=totals.get('runner_run',0)-inner
    return dict(milliseconds=totals,scope='runner_run nests API and staging spans; residual includes view/validation/scratch fill and observer/runner gaps; sum leaves only')


def trace_event(event, origin, label):
    return dict(name=event['kind'],cat='host-observation-not-device',ph='X',pid=1,tid=0,
        ts=(origin+event['start_ns'])/1000,dur=(event['end_ns']-event['start_ns'])/1000,
        args=dict(case=label,**{k:v for k,v in event.items() if k not in ['kind','start_ns','end_ns']}))


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--cases',type=Path,required=True)
    p.add_argument('--inputs',type=Path,action='append',default=[],help='common seed inputs unless overridden by each case')
    p.add_argument('--reference',type=Path,action='append',default=[])
    p.add_argument('--output',type=Path,required=True)
    p.add_argument('--iterations',type=int,default=3)
    p.add_argument('--warmups',type=int,default=2)
    p.add_argument('--observer',choices=['minimal','detailed'],default='detailed')
    a=p.parse_args()
    if len(a.inputs)!=len(a.reference) or a.iterations<1 or a.warmups<0:
        p.error('matching input/reference files, >=1 hot sample and >=0 warmups required')
    cases=resolve_cases(a.cases.resolve())
    seed_counts=set()
    for case in cases:
        case['input_paths']=case['input_paths'] or a.inputs
        case['reference_paths']=case['reference_paths'] or a.reference
        if not case['input_paths'] or len(case['input_paths'])!=len(case['reference_paths']):
            p.error('each case needs matched inputs/reference seed paths, via case overrides or common CLI')
        seed_counts.add(len(case['input_paths']))
    if len(seed_counts)!=1:p.error('all interleaved cases must have the same number of input/reference seeds')
    out=a.output.resolve();out.mkdir(parents=True,exist_ok=False)
    save(out/'invocation.json',dict(argv=sys.argv,cases_path=str(a.cases.resolve()),cases_sha256=digest(a.cases),
        script_sha256=digest(__file__),observer=a.observer,precision='FP32',atol=1e-5,rtol=1e-5,
        mode='profiling; sample counts alone are not multi-seed acceptance',identities={c['name']:c['identity'] for c in cases}))
    shutil.copy2(__file__,out/'profiler-source.py')
    import numpy as np
    from triton.backends.amd_triton_npu import multilaunch
    save(out/'runner-identity.json',dict(path=multilaunch.__file__,sha256=digest(multilaunch.__file__),installed_source_modified=False,
        implementation='existing MultiLaunchRunner.run; transient wrapper only',bo_write='installed runner stages via map/frombuffer/numpy.copyto; no BO.write API',bo_read='sync FROM_DEVICE then map/frombuffer returns view; final host copy timed separately'))
    calibration=Recorder();noop=lambda:None
    start=time.perf_counter_ns()
    for _ in range(1000):noop()
    plain=time.perf_counter_ns()-start;start=time.perf_counter_ns()
    for _ in range(1000):calibration.call('noop',noop)
    observed=time.perf_counter_ns()-start
    save(out/'observer-calibration.json',dict(repetitions=1000,plain_ns=plain,observed_ns=observed,scope='CPU noop loop only; illustrative observer overhead, not a correction to device samples'))
    trace=[];results=[];activities=[];epoch=time.perf_counter_ns()
    with open('/tmp/npu.lock','w') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX)
        profile_loop_begin=time.perf_counter_ns()
        for seed in range(next(iter(seed_counts))):
            folder=out/f'seed-{seed}';folder.mkdir()
            inputs_by_case={};references_by_case={};input_identities={}
            for case in cases:
                ip=case['input_paths'][seed];rp=case['reference_paths'][seed];name=case['name']
                host_activity(activities,'input_file_copy',shutil.copy2,ip,folder/(name+'-inputs.npz'))
                host_activity(activities,'reference_file_copy',shutil.copy2,rp,folder/(name+'-reference.npz'))
                inputs_by_case[name]=host_activity(activities,'input_load',lambda:dict(np.load(ip)))
                references_by_case[name]=host_activity(activities,'reference_load',lambda:dict(np.load(rp)))
                input_identities[name]=dict(inputs_path=str(ip.resolve()),inputs_sha256=digest(ip),reference_path=str(rp.resolve()),reference_sha256=digest(rp))
            host_activity(activities,'input_identity_save',save,folder/'input-identities.json',input_identities)
            runners={};loads={};samples=[]
            try:
                for case in cases:
                    begin=time.perf_counter_ns();runners[case['name']]=multilaunch.MultiLaunchRunner(case['elf'],case['kernel']);end=time.perf_counter_ns()
                    loads[case['name']]=(end-begin)/1e6;trace.append(trace_event(dict(kind='context_load',start_ns=begin-epoch,end_ns=end-epoch),0,case['name']))
                for repeat in range(a.iterations+a.warmups):
                    for case in (cases if repeat%2==0 else list(reversed(cases))):
                        runner=runners[case['name']];recorder=Recorder(a.observer=='detailed')
                        # Cache wrappers must remain stable across repeats.
                        if hasattr(runner,'_profile_recorder'):recorder=runner._profile_recorder
                        else:runner._profile_recorder=recorder
                        # Cached BO wrappers retain the same recorder.
                        # Steady-state calls perform no new allocations.
                        with observe(runner,multilaunch,recorder):
                            outputs,sample=measure(runner,multilaunch,case,inputs_by_case[case['name']],references_by_case[case['name']],recorder,a.observer=='detailed')
                        run_origin=sample['wall_start_ns']-epoch
                        sample.update(candidate=case['name'],repeat=repeat,warmup=repeat<a.warmups)
                        samples.append(sample)
                        trace.append(dict(name='complete_run_wall',cat='host-not-device',ph='X',pid=1,tid=0,ts=run_origin/1000,dur=sample['wall_ms']*1000,args=dict(seed=seed,candidate=case['name'],repeat=repeat)))
                        trace.extend(trace_event(e,run_origin,case['name']) for e in sample['events'])
                        host_activity(activities,'output_npz_save',np.savez,folder/f'{case["name"]}-{repeat}.npz',**outputs)
                        host_activity(activities,'sample_checkpoint_save',save,folder/'samples-in-progress.json',samples)
                        host_activity(activities,'progress_print',lambda:print(json.dumps(dict(seed=seed,candidate=case['name'],repeat=repeat,wall_ms=sample['wall_ms'],passed=all(c['passed'] for c in sample['checks'].values()))),flush=True))
            except BaseException as error:
                save(folder/'failure.json',dict(type=type(error).__name__,message=str(error),samples=samples,
                    partial_events=getattr(locals().get('recorder'),'events',[])))
                save(out/'host-timeline.json',dict(traceEvents=trace,displayTimeUnit='ms',scope='HOST ONLY; no device trace'))
                raise
            finally:
                for runner in runners.values():
                    host_activity(activities,'context_unload',runner.unload)
            result=dict(status='passed' if all(c['passed'] for s in samples for c in s['checks'].values()) else 'numeric_failed',load_ms=loads,samples=samples,
                hot_median_ms={c['name']:float(np.median([s['wall_ms'] for s in samples if s['candidate']==c['name'] and not s['warmup']])) for c in cases})
            results.append(result)
            host_activity(activities,'seed_result_save',save,folder/'result.json',result)
            host_activity(activities,'aggregate_result_checkpoint_save',save,out/'results.json',dict(results=results))
        profile_loop_end=time.perf_counter_ns()
    numeric_ms=sum(s['numeric_check_ms'] for r in results for s in r['samples'])
    run_ms=sum(s['wall_ms'] for r in results for s in r['samples'])
    context_ms=sum(v for r in results for v in r['load_ms'].values())
    activity_ms={}
    for event in activities:
        activity_ms[event['kind']]=activity_ms.get(event['kind'],0)+(event['end_ns']-event['start_ns'])/1e6
        trace.append(trace_event(dict(event,start_ns=event['start_ns']-epoch,end_ns=event['end_ns']-epoch),0,'outside-run'))
    for result in results:
        for sample in result['samples']:
            begin=sample['numeric_check_start_ns']-epoch
            trace.append(trace_event(dict(kind='numeric_check',start_ns=begin,end_ns=begin+int(sample['numeric_check_ms']*1e6)),0,sample['candidate']))
    profile_ms=(profile_loop_end-profile_loop_begin)/1e6
    save(out/'evidence-costs.json',dict(measurement_source='host perf_counter_ns',profile_loop_wall_ms=profile_ms,
        sum_run_walls_ms=run_ms,profile_loop_minus_run_walls_ms=profile_ms-run_ms,context_load_ms=context_ms,numeric_check_ms=numeric_ms,
        activity_ms=activity_ms,activities=activities,
        unseparated_loop_residual_ms=profile_ms-run_ms-context_ms-numeric_ms-sum(activity_ms.values()),
        scope='loop starts after lock acquisition and ends after final aggregate result checkpoint; includes context load/unload, input copy/load, run walls, numerics, output save/checkpoints/progress and loop overhead',
        final_writes_excluded=['evidence-costs.json','host-timeline.json','measurement-boundary.json','wait-backend.json'],
        excluded_startup='imports, case/ELF identity validation, output directory creation, initial source/provenance save, observer calibration, lock wait; no recursive measurement of final reports'))
    save(out/'host-timeline.json',dict(traceEvents=trace,displayTimeUnit='ms',scope='HOST ONLY; no device trace'))
    save(out/'measurement-boundary.json',dict(observer=a.observer,whole_wall='host prepare + unchanged existing runner + final output copy; context load/input-reference load/numerics/output serialization excluded',
        detailed='Nested host spans overlap; do not sum runner_run with its inner API/copy events. numpy_copyto_in_runner labels installed BO staging writes in inspected implementation.',
        unseparated='runner argument validation, view construction, scratch fill, Python/runner gaps remain residual; BO map is not BO data copy, sync is not measured DDR traffic, wait includes runtime polling and device wait',
        observer_cost_scope='observer_record_ms measures only part of event construction/list append; dispatch/timers/return overhead is not isolated. Compare minimal/detailed as paired instrumentation controls; never subtract blindly.',
        device_trace=False,compilation=False,installed_packages_modified=False))
    save(out/'wait-backend.json',wait_backend_identity(multilaunch))
    return 0 if all(r['status']=='passed' for r in results) else 1


if __name__=='__main__':
    raise SystemExit(main())
