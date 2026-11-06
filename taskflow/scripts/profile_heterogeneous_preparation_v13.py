#!/usr/bin/env python3
"""Observe XRT constructor components of the frozen Prepared constructor.

Returns original pyxrt objects and changes no execution contract or runtime.
No run/start/kernel computation occurs. Context construction remains opaque
runtime/PDI work; neither a cold-device reset nor pure configuration is claimed.
"""
import argparse
import fcntl
import hashlib
import importlib.util
import json
from pathlib import Path
import sys
import time
import types

SOURCE_BYTES=Path(__file__).read_bytes()
SOURCE_SHA256=hashlib.sha256(SOURCE_BYTES).hexdigest()


def digest(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def save(path,value):Path(path).write_text(json.dumps(value,indent=2)+'\n')


def describe(value):
    if value is None or isinstance(value,(str,int,float,bool)):
        return value
    return {'type':type(value).__module__+'.'+type(value).__qualname__}


class NamespaceProxy:
    def __init__(self,raw,events,prefix):
        self.raw,self.events,self.prefix=raw,events,prefix
    def wrap(self,name):
        operation=getattr(self.raw,name)
        def observed(*args,**kwargs):
            event=dict(api=self.prefix+name,args=[describe(x) for x in args],
                       kwargs={k:describe(v) for k,v in kwargs.items()},start_ns=time.perf_counter_ns())
            end=None
            try:
                result=operation(*args,**kwargs)
                end=time.perf_counter_ns()
                event['status']='returned';event['return_type']=describe(result)
                return result
            except Exception as error:
                end=time.perf_counter_ns()
                event.update(status='failed',error=str(error));raise
            finally:
                event['end_ns']=end if end is not None else time.perf_counter_ns();event['elapsed_ns']=event['end_ns']-event['start_ns']
                self.events.append(event)
        return observed
    def __getattr__(self,name):return getattr(self.raw,name)


def module_proxy(raw,events):
    proxy=types.ModuleType('pyxrt')
    # Preserve file identity for existing contract checks. Constructor wrappers
    # delegate to the exact original module and return unwrapped raw objects.
    for field in ('__file__','__spec__','__loader__','__package__','__doc__'):
        if hasattr(raw,field):setattr(proxy,field,getattr(raw,field))
    proxy.__getattr__=lambda name:getattr(raw,name)
    def reject_run(*args,**kwargs):
        raise RuntimeError('Preparation-only observer forbids creation of an executable XRT run')
    proxy.run=reject_run
    root=NamespaceProxy(raw,events,'pyxrt.')
    for name in ('device','elf','hw_context'):setattr(proxy,name,root.wrap(name))
    ext=NamespaceProxy(raw.ext,events,'pyxrt.ext.')
    ext.kernel=ext.wrap('kernel');ext.bo=ext.wrap('bo');proxy.ext=ext
    return proxy


def load_protocol(path):
    data=json.loads(path.read_text())
    if data.get('schema')!='orbit.mechanism.microbench-protocol.v13':raise ValueError('wrong frozen protocol schema')
    executor=data['executor'];source=Path(executor['path'])
    if not source.is_absolute() or digest(source)!=executor['sha256']:raise ValueError('frozen executor source differs')
    names=set()
    for case in data['program_cases']:
        if case['name'] in names or case['split'] not in ('training','holdout'):raise ValueError('duplicate/invalid protocol program case')
        names.add(case['name'])
        if not Path(case['compiled']).is_absolute() or not Path(case['compiled']).is_file():raise ValueError('compiled package must exist')
    return data


def load_executor(spec):
    path=Path(spec['path']);sys.path.insert(0,str(path.parent))
    loader=importlib.util.spec_from_file_location('frozen_preparation_executor_v13',path)
    module=importlib.util.module_from_spec(loader);loader.loader.exec_module(module)
    if module.EXECUTOR_SOURCE_SHA256!=spec['sha256']:raise ValueError('loaded executor does not match frozen bytes')
    return module


def cpu_proxy_test():
    calls=[]
    class RawObject:pass
    class Raw:
        __file__=__file__
        def __init__(self):self.ext=types.SimpleNamespace(kernel=self.construct,bo=self.construct)
        def construct(self,*args,**kwargs):return RawObject()
        device=construct;elf=construct;hw_context=construct
    raw=Raw();proxy=module_proxy(raw,calls)
    values=[proxy.device(0),proxy.elf('file'),proxy.hw_context('d','e'),proxy.ext.kernel('c','k'),proxy.ext.bo('d',64)]
    assert all(type(x) is RawObject for x in values)
    assert [x['api'] for x in calls]==['pyxrt.device','pyxrt.elf','pyxrt.hw_context','pyxrt.ext.kernel','pyxrt.ext.bo']
    try:proxy.run()
    except RuntimeError:pass
    else:raise AssertionError('preparation observer allowed execution')
    assert proxy.__file__==raw.__file__
    assert all(x['elapsed_ns']>=0 for x in calls)
    return dict(status='passed',constructor_wrappers=5,raw_objects_preserved=True,device_opened=False)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--protocol',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--repeats',type=int,default=3)
    parser.add_argument('--validate-only',action='store_true',help='stdlib-only file/proxy tests; no pyxrt import/device')
    args=parser.parse_args()
    if args.repeats!=3:parser.error('this preregistered preparation diagnostic requires exactly three trials per case')
    protocol=load_protocol(args.protocol)
    args.output=args.output.resolve();args.output.mkdir(parents=True,exist_ok=False)
    (args.output/'protocol.json').write_bytes(args.protocol.read_bytes())
    (args.output/'observer-source.py').write_bytes(SOURCE_BYTES)
    identity=dict(protocol_sha256=digest(args.protocol),observer_sha256=SOURCE_SHA256,
                  frozen_executor=protocol['executor'],repeats=args.repeats,
                  measurement_scope='Prepared construction only; no execution or run.start',
                  order='protocol program_cases order, three consecutive trials per case',
                  cold_device_reset=False,elf_seen_scope='only this observer process; no claim about persistent driver/device caches')
    save(args.output/'identity.json',identity)
    if args.validate_only:
        save(args.output/'validation.json',cpu_proxy_test());return 0
    import pyxrt as raw
    identity.update(pyxrt_path=raw.__file__,pyxrt_sha256=digest(raw.__file__))
    save(args.output/'identity.json',identity)
    executor=load_executor(protocol['executor'])
    samples=[];seen_elf=set();prior_elf=None;ordinal=0
    try:
        with open('/tmp/npu.lock','w') as lock:
            fcntl.flock(lock,fcntl.LOCK_EX)
            for case in protocol['program_cases']:
                compiled=json.loads(Path(case['compiled']).read_text())
                elf_ids=[r['artifact']['elf_sha256'] for r in compiled['regions'] if r['device']=='npu']
                for trial in range(args.repeats):
                    events=[];item=None;original=sys.modules.get('pyxrt')
                    sample=dict(case=case['name'],split=case['split'],trial=trial,ordinal=ordinal,
                        compiled_sha256=digest(case['compiled']),first_prepared_in_process=ordinal==0,
                        elf_sha256=elf_ids,all_elf_seen_before=all(x in seen_elf for x in elf_ids) if elf_ids else None,
                        same_elf_set_as_previous=elf_ids==prior_elf if prior_elf is not None else False,
                        previous_elf_sha256=prior_elf,cross_elf_transition=prior_elf is not None and elf_ids!=prior_elf,
                        boundary='constructor API host spans; context is opaque PDI/runtime work, remaining is hashes/imports/CPU CDLL/arrays/maps/observer overhead')
                    sys.modules['pyxrt']=module_proxy(raw,events)
                    start=time.perf_counter_ns()
                    try:
                        item=executor.Prepared(case['compiled'])
                        end=time.perf_counter_ns()
                        sample.update(status='prepared',start_ns=start,end_ns=end,prepared_wall_ns=end-start,
                                      api_events=events,constructor_api_sum_ns=sum(e['elapsed_ns'] for e in events),
                                      remaining_preparation_ns=end-start-sum(e['elapsed_ns'] for e in events),
                                      runtime=item.runtime_identity,pointers=item.pointer_identity)
                    except Exception as error:
                        end=time.perf_counter_ns();sample.update(status='failed',error=str(error),start_ns=start,end_ns=end,
                                                                prepared_wall_ns=end-start,api_events=events)
                        raise
                    finally:
                        if original is None:sys.modules.pop('pyxrt',None)
                        else:sys.modules['pyxrt']=original
                        samples.append(sample);save(args.output/'samples.json',samples)
                        if item is not None:
                            close_start=time.perf_counter_ns();item.close();sample['close_wall_ns']=time.perf_counter_ns()-close_start
                            save(args.output/'samples.json',samples)
                    seen_elf.update(elf_ids);prior_elf=elf_ids;ordinal+=1
        save(args.output/'summary.json',dict(status='passed',samples=len(samples),kernel_dispatches=0,
            scope='host constructor API decomposition only; no configuration-only, cold-device, device-cycle or hardware traffic claim'))
        return 0
    except Exception as error:
        save(args.output/'failure.json',dict(status='failed',message=str(error),fallback=False));raise


if __name__=='__main__':raise SystemExit(main())
