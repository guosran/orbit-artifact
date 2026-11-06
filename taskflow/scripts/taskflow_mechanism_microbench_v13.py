#!/usr/bin/env python3
"""Measure explicit host-copy/XRT API mechanisms from a frozen protocol.

No placements, plans, scoring, kernels, or numerical fallback are generated.
Sync may be cache maintenance rather than DMA; start/wait and preparation remain
composite host API measurements, not hardware traffic or pure compute timing.
"""
import argparse
import fcntl
import hashlib
import importlib.util
import json
import platform
from pathlib import Path
import sys
import time

SOURCE_BYTES = Path(__file__).read_bytes()
SOURCE_SHA256 = hashlib.sha256(SOURCE_BYTES).hexdigest()


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def save(path, data):
    Path(path).write_text(json.dumps(data, indent=2) + '\n')


def load_protocol(path):
    path = path.resolve()
    p = json.loads(path.read_text())
    if p.get('schema') != 'orbit.mechanism.microbench-protocol.v13':
        raise ValueError('unsupported frozen microbench protocol')
    for split in ('train', 'holdout'):
        for key in ('sizes_bytes', 'counts'):
            values = p[split][key]
            if not values or len(set(values)) != len(values) or any(type(x) is not int or x <= 0 for x in values):
                raise ValueError('positive unique frozen sizes/counts required')
    if set(p['train']['sizes_bytes']) & set(p['holdout']['sizes_bytes']):
        raise ValueError('training and holdout sizes must be disjoint')
    for key, supported in (('states', {'untouched','host-read','host-written'}),
                           ('directions', {'TO_DEVICE','FROM_DEVICE'}),
                           ('copy_paths', {'host-to-host','host-to-mapped-bo','mapped-bo-to-host'})):
        if not p[key] or len(set(p[key])) != len(p[key]) or not set(p[key]) <= supported:
            raise ValueError('unsupported/duplicate frozen ' + key)
    for key in ('warmups','repeats','prepare_repeats','program_warmups','program_repeats'):
        if type(p[key]) is not int or p[key] < (0 if 'warmup' in key else 1):
            raise ValueError('invalid frozen repeat count: ' + key)
    executor = p['executor']
    if not Path(executor['path']).is_absolute() or digest(executor['path']) != executor['sha256']:
        raise ValueError('frozen executor source is missing or changed')
    names = set()
    for case in p.get('program_cases', []):
        if case['name'] in names or case['split'] not in ('training','holdout'):
            raise ValueError('duplicate program name or unsupported split')
        names.add(case['name'])
        if not case['inputs'] or len(case['inputs']) != len(case['reference']):
            raise ValueError('program needs independently supplied input/reference pairs')
        for value in [case['compiled'], *case['inputs'], *case['reference']]:
            if not Path(value).is_absolute() or not Path(value).is_file():
                raise ValueError('frozen program file must be an existing absolute path')
    return p


def setup_state(state, arrays, ordinal):
    # An operational host-state definition; does not assert physical cache state.
    if state == 'host-written':
        for i, array in enumerate(arrays):
            array.fill((ordinal + 17*i) % 251)
    elif state == 'host-read':
        for array in arrays:
            int(array.sum(dtype='uint64'))


def timed_sequence(operation, count):
    events = []
    begin = time.perf_counter_ns()
    for index in range(count):
        start = time.perf_counter_ns()
        operation()
        end = time.perf_counter_ns()
        events.append(dict(index=index, start_ns=start, end_ns=end, elapsed_ns=end-start))
    end = time.perf_counter_ns()
    return dict(start_ns=begin, end_ns=end, outer_sequence_ns=end-begin,
                api_total_ns=sum(e['elapsed_ns'] for e in events), api_events=events)


def memory_benches(protocol, output, xrt, device, selected_split):
    import numpy as np
    preparation, results = [], []
    for split in ('train' if selected_split=='training' else 'holdout',):
        for size in protocol[split]['sizes_bytes']:
            begin = time.perf_counter_ns()
            host_a, host_b = np.empty(size, np.uint8), np.empty(size, np.uint8)
            host_a.fill(13);host_b.fill(97)
            preparation.append(dict(kind='host_array_preparation',split=split,bytes_each=size,
                                    start_ns=begin,end_ns=time.perf_counter_ns()))
            begin = time.perf_counter_ns()
            bo = xrt.ext.bo(device, size)
            preparation.append(dict(kind='bo_constructor',split=split,bytes=size,
                                    start_ns=begin,end_ns=time.perf_counter_ns()))
            begin = time.perf_counter_ns()
            mapping = bo.map(); mapped = np.frombuffer(mapping,dtype=np.uint8,count=size)
            mapped.fill(31)
            preparation.append(dict(kind='bo_map_and_view_preparation',split=split,bytes=size,
                                    start_ns=begin,end_ns=time.perf_counter_ns()))
            for count in protocol[split]['counts']:
                mechanisms = [('timer-empty',lambda:None,[],None)]
                for path in protocol['copy_paths']:
                    source,destination = {'host-to-host':(host_a,host_b),
                        'host-to-mapped-bo':(host_a,mapped),'mapped-bo-to-host':(mapped,host_b)}[path]
                    mechanisms.append((path,lambda s=source,d=destination:np.copyto(d,s,casting='no'),[source,destination],(source,destination)))
                for direction in protocol['directions']:
                    enum = getattr(xrt.xclBOSyncDirection,'XCL_BO_SYNC_BO_'+direction)
                    mechanisms.append(('bo-sync-'+direction,lambda e=enum:bo.sync(e,size,0),[mapped],None))
                for state in protocol['states']:
                    for mechanism,operation,arrays,check in mechanisms:
                        for repeat in range(protocol['warmups']+protocol['repeats']):
                            setup_state(state,arrays,repeat)
                            sample=timed_sequence(operation,count)
                            if check is not None and not np.array_equal(*check):
                                raise RuntimeError('host copy content check failed')
                            sample.update(unit='ns',mechanism=mechanism,split='training' if split=='train' else 'holdout',
                                bytes_per_call=0 if mechanism=='timer-empty' else size,count=count,state=state,
                                repeat=repeat,warmup=repeat<protocol['warmups'],
                                requested_bytes=0 if mechanism=='timer-empty' else size*count,
                                family='timer-empty' if mechanism=='timer-empty' else ('bo-sync' if mechanism.startswith('bo-sync-') else 'host-copy'),
                                copy_path=mechanism if mechanism in protocol['copy_paths'] else None,
                                direction=mechanism[len('bo-sync-'):] if mechanism.startswith('bo-sync-') else None,
                                measurement_scope='sum of individually bracketed host API spans in ns; outer sequence additionally includes timer/loop/list-recording overhead; state setup and validation outside both clocks',
                                physical_ddr_measurement=False,
                                check='byte equality outside clock' if check is not None else 'no device-producer/content claim for raw sync')
                            results.append(sample)
            save(output/'memory-samples.json',results)
            save(output/'memory-preparation.json',preparation)
            # Retain every BO/map through its own size experiments only.
            del mapped,mapping,bo
    save(output/'memory-preparation.json',preparation)
    save(output/'memory-samples.json',results)
    return results


def load_executor(spec):
    path = Path(spec['path'])
    sys.path.insert(0,str(path.parent))
    loader=importlib.util.spec_from_file_location('orbit_frozen_executor_v13',path)
    module=importlib.util.module_from_spec(loader);loader.loader.exec_module(module)
    if module.EXECUTOR_SOURCE_SHA256 != spec['sha256']:
        raise ValueError('imported executor differs from preregistered bytes')
    return module


def program_benches(protocol,output,selected_split):
    import numpy as np
    executor=load_executor(protocol['executor'])
    prepared, preparations, samples = [], [], []
    try:
        for case in protocol.get('program_cases',[]):
            if case['split']!=selected_split:continue
            directory=output/case['name'];directory.mkdir()
            record=dict(case=case['name'],split=case['split'],compiled=case['compiled'],compiled_sha256=digest(case['compiled']),
                        input_sha256=[digest(x) for x in case['inputs']],reference_sha256=[digest(x) for x in case['reference']],trials=[])
            for repeat in range(protocol['prepare_repeats']):
                start=time.perf_counter_ns(); item=executor.Prepared(case['compiled']);end=time.perf_counter_ns()
                record['trials'].append(dict(repeat=repeat,start_ns=start,end_ns=end,elapsed_ns=end-start,
                    scope='Prepared constructor: manifest/source/tool/contract hashes, CPU CDLL, XRT device/ELF/hw_context/kernel and BO/map construction combined; not isolated configuration cost'))
                if repeat+1<protocol['prepare_repeats']:
                    item.close()
            record.update(plan_id=item.manifest['id'],runtime=item.runtime_identity,pointers=item.pointer_identity,
                          abi_pointer_proof=item.abi_pointer_proof,execution_contract_identity=item.manifest['execution_contract_identity'])
            save(directory/'preparation.json',record);preparations.append(record)
            data=[(dict(np.load(i)),dict(np.load(r))) for i,r in zip(case['inputs'],case['reference'])]
            prepared.append((case,item,directory,data))
        # Stable preregistered round-robin order; no ranking or placement choice.
        maximum_seeds=max((len(x[3]) for x in prepared),default=0)
        for seed in range(maximum_seeds):
            for repeat in range(protocol['program_warmups']+protocol['program_repeats']):
                for case,item,directory,data in prepared:
                    if seed>=len(data):continue
                    split='train' if case['split']=='training' else 'holdout'
                    for count in protocol[split]['counts']:
                        sequence_begin=time.perf_counter_ns(); calls=[]
                        for call in range(count):
                            call_dir=directory/('seed-'+str(seed))/('count-'+str(count))/('repeat-'+str(repeat))/('call-'+str(call))
                            result=item.one(*data[seed],call_dir,repeat<protocol['program_warmups'])
                            if not result['passed']:raise RuntimeError('actual compiled-program numerical validation failed: '+str(call_dir))
                            waiter = getattr(getattr(item,'module',None),'_wait_nogil',None)
                            owner = sys.modules.get(getattr(waiter,'__module__',''))
                            waiter_file = getattr(owner,'__file__',None)
                            waiter_identity=dict(module=getattr(waiter,'__module__',None),name=getattr(waiter,'__qualname__',None),
                                path=waiter_file,sha256=digest(waiter_file) if waiter_file and Path(waiter_file).is_file() else None)
                            calls.append(dict(evidence=str(call_dir/'result.json'),wall_ms=result['wall_ms'],selected_wait_backend=waiter_identity,
                                              checks=result['checks'],events=result['events'],region_calls=result['region_calls']))
                        end=time.perf_counter_ns()
                        samples.append(dict(case=case['name'],split=case['split'],seed_index=seed,count=count,
                            repeat=repeat,warmup=repeat<protocol['program_warmups'],outer_sequence_ns=end-sequence_begin,
                            program_wall_sum_ns=sum(c['wall_ms']*1e6 for c in calls),calls=calls,
                            outer_scope='includes evidence serialization between calls; use individual frozen-executor walls for program cost',
                            start_wait_scope='existing observer API spans; wait includes compute/DMA/stall/scheduling and selected waiter overhead'))
                        save(output/'program-samples.json',samples)
        save(output/'program-preparation.json',preparations)
        return samples
    finally:
        for _,item,_,_ in prepared:item.close()


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--protocol',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--split',choices=('training','holdout'),required=True)
    parser.add_argument('--validate-only',action='store_true',help='stdlib-only preregistration/file check; no XRT import/device')
    args=parser.parse_args();protocol=load_protocol(args.protocol)
    args.output=args.output.resolve();args.output.mkdir(parents=True,exist_ok=False)
    (args.output/'protocol.json').write_bytes(args.protocol.read_bytes())
    (args.output/'microbench-source.py').write_bytes(SOURCE_BYTES)
    identity=dict(split=args.split,protocol_sha256=digest(args.protocol),microbench_sha256=SOURCE_SHA256,
                  python=sys.version,platform=dict(system=platform.system(),machine=platform.machine(),release=platform.release(),node=platform.node()),
                  clock=dict(name='perf_counter_ns',implementation=time.get_clock_info('perf_counter').implementation),
                  executor=protocol['executor'],physical_ddr_measurement=False)
    save(args.output/'identity.json',identity)
    if args.validate_only:
        save(args.output/'validation.json',dict(status='passed',device_opened=False));return 0
    import pyxrt
    import numpy as np
    from triton.backends.amd_triton_npu import multilaunch
    identity.update(numpy_version=np.__version__,numpy_source=np.__file__,numpy_source_sha256=digest(np.__file__),
                    pyxrt_path=pyxrt.__file__,pyxrt_sha256=digest(pyxrt.__file__),
                    multilaunch_path=multilaunch.__file__,multilaunch_sha256=digest(multilaunch.__file__))
    save(args.output/'identity.json',identity)
    try:
        with open('/tmp/npu.lock','w') as lock:
            fcntl.flock(lock,fcntl.LOCK_EX)
            start=time.perf_counter_ns();device=pyxrt.device(0);end=time.perf_counter_ns()
            save(args.output/'device-preparation.json',dict(start_ns=start,end_ns=end,elapsed_ns=end-start,
                 device_bdf=str(device.get_info(pyxrt.xrt_info_device.bdf))))
            memory=memory_benches(protocol,args.output,pyxrt,device,args.split)
            programs=program_benches(protocol,args.output,args.split)
        save(args.output/'summary.json',dict(status='passed',memory_samples=len(memory),program_sequences=len(programs),
            interpretation={'copy':'host np.copyto API spans on declared host/mapped views; not DRAM-only bandwidth',
              'sync':'full-size pyxrt bo.sync API; may be DMA or cache maintenance; no physical traffic measurement',
              'start':'actual run.start API host span; not isolated firmware dispatch cost',
              'wait':'actual installed selected waiter plus compute/DMA/stalls/scheduling, not pure compute',
              'prepare':'constructor wall is composite; no isolated PDI/configuration inference',
              'native_dma':'static checked child bytes/counts remain uncalibrated internal cost; no physical-flow inference',
              'state':'operational host read/write/untouched setup outside timing; cache/DRAM state not independently controlled'}))
        return 0
    except Exception as error:
        save(args.output/'failure.json',dict(status='failed',message=str(error),numerical_fallback=False));raise


if __name__=='__main__':
    raise SystemExit(main())
