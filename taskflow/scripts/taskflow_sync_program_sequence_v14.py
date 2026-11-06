#!/usr/bin/env python3
"""Observe unmodified frozen Prepared.one program sequences; no planner or model.

Only explicit execution opens devices. --validate-only and --self-test do not.
The sequence envelope includes Python/evidence I/O and must never be fit as an
API cost. Each raw one's wall_ms retains the frozen executor's original scope.
"""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import sys
import tempfile
import time

SOURCE = Path(__file__).read_bytes()
SOURCE_SHA = hashlib.sha256(SOURCE).hexdigest()
FROZEN_EXECUTOR_SHA = 'fc4c8f44a00cb35598da102e18d96814c733e92597a57cb49c4c46418af9324c'


def need(condition, message):
    if not condition:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def identity(path):
    return dict(path=str(Path(path).resolve()), sha256=sha(path))


def save(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, allow_nan=False) + '\n')


def load_module(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def load_protocol(path, split):
    protocol = json.loads(Path(path).read_text())
    need(protocol['schema'] == 'orbit.sync-state.protocol.v14', 'unsupported protocol schema')
    for role in ('executor', 'observer'):
        item = protocol[role]
        need(Path(item['path']).is_absolute() and sha(item['path']) == item['sha256'], 'changed ' + role)
    need(protocol['executor']['sha256'] == FROZEN_EXECUTOR_SHA, 'requires frozen fc4 executor')
    seeds = protocol['seeds']
    need(len(seeds) == 3 and len(set(seeds)) == 3 and all(type(s) is int for s in seeds), 'requires three unique protocol seeds')
    config = protocol['program_sequence']
    counts = config[split]['counts']
    need(counts == ([1, 4] if split == 'calibration' else [2, 7]), 'unsupported split sequence counts')
    need(config['warmups'] == 2 and config['repeats'] == 7, 'requires two warmup and seven hot sequences')
    cases = protocol['program_sequence_cases']
    need(len(cases) == 2 and len({c['name'] for c in cases}) == 2, 'requires exactly two existing cases')
    for case in cases:
        need(len(case['inputs']) == len(case['reference']) == len(seeds), 'input/reference seed coverage differs')
        for file in [case['compiled'], *case['inputs'], *case['reference']]:
            need(Path(file).is_absolute() and Path(file).is_file(), 'existing absolute case path required')
        need(Path(case['name']).name == case['name'] and case['name'] not in ('.','..'), 'case name must be a basename')
        compiled = json.loads(Path(case['compiled']).read_text())
        manifest = json.loads(Path(compiled['manifest']).read_text())
        need(sha(compiled['manifest']) == compiled['manifest_sha256'], 'compiled manifest changed')
        need(len(manifest['regions']) == 1 and manifest['regions'][0]['device'] == 'npu', 'requires one complete NPU region')
        need(len(manifest['regions'][0]['tasks']) == 3, 'requires existing complete three-task graph')
        region = manifest['regions'][0]
        abi = region.get('npu_abi', region['abi'])
        need(len(abi) == 3 and [b['argument'] for b in abi] == [0,1,2] and
             [b['role'] for b in abi].count('input') == 2 and [b['role'] for b in abi].count('output') == 1,
             'requires exact three-argument two-input/one-output NPU ABI; no scratch')
    for key in ('runtime_fingerprint', 'api_path_evidence'):
        item = protocol[key]
        need(sha(item['path']) == item['sha256'], 'changed ' + key)
    return protocol, config, cases


def sync_sites(result, region, bo_sizes):
    """Check the installed whole-buffer runner sequence; do not create syncs."""
    bindings = region.get('npu_abi', region['abi'])
    expected = [('installed-bound-bo-input-loop', b, 'TO_DEVICE') for b in bindings]
    expected += [('installed-bound-bo-readback-loop', b, 'FROM_DEVICE') for b in bindings if b['role'] == 'output']
    events = result['events']
    syncs = [(i, e) for i, e in enumerate(events) if e['kind'] == 'actual_bo_sync']
    starts = [i for i, e in enumerate(events) if e['kind'] == 'actual_xrt_start']
    waits = [i for i, e in enumerate(events) if e['kind'] == 'actual_xrt_wait']
    need(len(starts) == len(waits) == 1 and starts[0] < waits[0], 'requires one original submit/wait')
    need(len(syncs) == len(expected), 'installed sync count differs from actual ABI sequence')
    rows = []
    for ordinal, ((event_index, event), (site, binding, direction)) in enumerate(zip(syncs, expected)):
        need(event['region'] == region['index'] and event['storage'] == binding['storage'], 'sync storage/region order differs')
        need(direction in event['direction'], 'sync direction differs')
        need(event_index < starts[0] if direction == 'TO_DEVICE' else event_index > waits[0], 'sync site is not before submit/after wait')
        rows.append(dict(api_ordinal=ordinal, event_index=event_index, site=site,
            argument_ordinal=binding['argument'], argument_role=binding['role'], storage=binding['storage'],
            region=region['index'], copy=binding.get('copy'), direction=direction,
            invocation_form='implicit-full-buffer', observation_boundary='detailed-compatibility',
            requested_bo_size=bo_sizes[binding['storage']], requested_offset_bytes=0, actual_bo_extent=bo_sizes[binding['storage']],
            start_ns=event['start_ns'], end_ns=event['end_ns'], elapsed_ns=event['end_ns']-event['start_ns'],
            public_region_event_ids=event.get('public_region_event_ids', []),
            scope='frozen ObservedBO.sync event; includes enum string conversion and forwarding; distinct from prebound microbench',
            physical_bytes=None, physical_transfer_count=None))
    return rows


def sequence(prepared, inputs, reference, directory, count, warmup, region, sizes):
    rows = []
    begin = time.perf_counter_ns()
    for call in range(count):
        target = directory / ('call-' + str(call))
        result = prepared.one(inputs, reference, target, warmup)
        need(result['passed'], 'original output validation failed: ' + str(target))
        sites = sync_sites(result, region, sizes)
        rows.append(dict(call=call, raw_result=identity(target / 'result.json'),
                         raw_outputs=identity(target / 'outputs.npz'), one_wall_ms=result['wall_ms'], sync_api_sites=sites))
    end = time.perf_counter_ns()
    return dict(start_ns=begin, end_ns=end, outer_sequence_ns=end-begin, count=count,
                warmup=warmup, calls=rows, fit_outer_sequence=False, fit_one_wall=False,
                envelope='Prepared.one calls plus output/reference checks and evidence serialization; not API-only or device time')


def self_test():
    region = dict(index=0, abi=[dict(argument=0, storage=0, role='input'), dict(argument=1, storage=1, role='output')])
    events = [dict(kind='actual_bo_sync', storage=0, direction='TO_DEVICE'),
              dict(kind='actual_bo_sync', storage=1, direction='TO_DEVICE'),
              dict(kind='actual_xrt_start'), dict(kind='actual_xrt_wait'),
              dict(kind='actual_bo_sync', storage=1, direction='FROM_DEVICE')]
    for e in events:
        e.update(region=0, start_ns=1, end_ns=2)
    result = dict(passed=True, events=events, wall_ms=0.1)
    need([x['site'] for x in sync_sites(result, region, {0:16, 1:16})] == ['installed-bound-bo-input-loop', 'installed-bound-bo-input-loop', 'installed-bound-bo-readback-loop'], 'site regression')
    checks = 1
    for field, value in [('storage', 99), ('direction', 'FROM_DEVICE')]:
        bad = json.loads(json.dumps(result)); bad['events'][0][field] = value
        try:
            sync_sites(bad, region, {0:16, 1:16})
        except ValueError:
            checks += 1
        else:
            raise AssertionError('forged sync accepted')
    bad = dict(result, events=events[:-1])
    try:
        sync_sites(bad, region, {0:16, 1:16})
    except ValueError:
        checks += 1
    else:
        raise AssertionError('missing readback accepted')
    class Mock:
        def one(self, inputs, reference, directory, warmup):
            directory.mkdir(parents=True)
            save(directory/'result.json', result); (directory/'outputs.npz').write_bytes(b'mock')
            return result
    with tempfile.TemporaryDirectory() as tmp:
        row = sequence(Mock(), {}, {}, Path(tmp), 4, False, region, {0:16, 1:16})
        need(len(row['calls']) == 4 and not row['fit_outer_sequence'], 'sequence count/scope regression')
        checks += 1
    print(json.dumps(dict(status='passed', checks=checks, device_opened=False)))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--protocol', type=Path)
    parser.add_argument('--split', choices=('calibration', 'holdout'))
    parser.add_argument('--output', type=Path)
    parser.add_argument('--validate-only', action='store_true')
    parser.add_argument('--self-test', action='store_true')
    args = parser.parse_args()
    if args.self_test:
        self_test(); return
    need(args.protocol and args.split and args.output, '--protocol/--split/--output required')
    protocol, config, cases = load_protocol(args.protocol, args.split)
    helper_path = Path(__file__).with_name('collect_sync_target_v14.py')
    helper = load_module(helper_path, 'v14_sequence_target')
    expected = json.loads(Path(protocol['runtime_fingerprint']['path']).read_text())
    before = helper.collect_snapshot()
    need(before == expected, 'current runtime differs from frozen target')
    proof = json.loads(Path(protocol['api_path_evidence']['path']).read_text())
    need(proof['target_id'] == before['target_id'], 'probe target differs')
    for path, digest in proof['files'].items():
        need(sha(path) == digest, 'API proof file changed')
    args.output = args.output.resolve(); args.output.mkdir(parents=True, exist_ok=False)
    (args.output/'protocol.json').write_bytes(args.protocol.read_bytes())
    (args.output/'sequence-source.py').write_bytes(SOURCE)
    save(args.output/'runtime-fingerprint-before.json', before)
    metadata = dict(schema='orbit.sync-program-sequence.identity.v14', split=args.split,
        protocol=identity(args.protocol), source_sha256=SOURCE_SHA, executor=protocol['executor'], observer=protocol['observer'],
        runtime_collector=identity(helper_path), runtime_target_id=before['target_id'], device_opened=False,
        cases=[dict(name=c['name'], compiled=identity(c['compiled']), inputs=[identity(p) for p in c['inputs']],
                    reference=[identity(p) for p in c['reference']]) for c in cases])
    save(args.output/'identity.json', metadata)
    if args.validate_only:
        need(helper.collect_snapshot() == before, 'runtime changed during validation')
        save(args.output/'runtime-fingerprint-after.json', before)
        save(args.output/'summary.json', dict(status='validated', cases=2, device_submissions=0)); return
    sys.path.insert(0, str(Path(protocol['observer']['path']).parent))
    observer = __import__('taskflow_npu_trace_v3')
    need(identity(observer.__file__) == protocol['observer'], 'canonical observer differs')
    executor = load_module(protocol['executor']['path'], 'v14_sequence_frozen_executor')
    need(executor.EXECUTOR_SOURCE_SHA256 == FROZEN_EXECUTOR_SHA, 'loaded executor differs')
    import numpy as np
    prepared = {}
    samples = []
    try:
        for case in cases:
            begin = time.perf_counter_ns(); item = executor.Prepared(case['compiled']); end = time.perf_counter_ns()
            prepared[case['name']] = item
            sizes = {i:int(bo.raw.size()) for i,bo in item.bos.items()}
            need(all(sizes[i] == item.arrays[i].nbytes for i in sizes), 'actual BO size differs from ABI array')
            save(args.output/'preparation'/(case['name']+'.json'), dict(start_ns=begin,end_ns=end,
                scope='combined frozen Prepared constructor; not pure configuration', actual_bo_sizes={str(k):v for k,v in sizes.items()},
                abi_pointer_proof=item.abi_pointer_proof,pointers=item.pointer_identity,runtime=item.runtime_identity,
                compiled=identity(case['compiled']),manifest=identity(item.path),
                elf=[identity(r['artifact']['elf_path']) for r in item.compiled['regions']]))
        metadata['device_opened'] = True; save(args.output/'identity.json', metadata)
        for seed_index, seed in enumerate(protocol['seeds']):
            archives = {}
            for case in cases:
                with np.load(case['inputs'][seed_index]) as archive: inputs = {k:archive[k] for k in archive.files}
                with np.load(case['reference'][seed_index]) as archive: reference = {k:archive[k] for k in archive.files}
                archives[case['name']] = inputs, reference
            for count in config[args.split]['counts']:
                for repeat in range(config['warmups'] + config['repeats']):
                    order = cases if (seed_index+count+repeat)%2 == 0 else list(reversed(cases))
                    for case in order:
                        item = prepared[case['name']]
                        directory = args.output/'raw_one'/case['name']/('seed-'+str(seed))/('count-'+str(count))/('repeat-'+str(repeat))
                        row = sequence(item, *archives[case['name']], directory, count,
                            repeat < config['warmups'], item.manifest['regions'][0], {i:int(b.raw.size()) for i,b in item.bos.items()})
                        row.update(case=case['name'],seed=seed,repeat=repeat,split=args.split,
                            case_order=[c['name'] for c in order])
                        samples.append(row); save(args.output/'program-sequences.json', samples)
    finally:
        for item in prepared.values(): item.close()
        after = helper.collect_snapshot(); save(args.output/'runtime-fingerprint-after.json',after)
        need(after == before,'runtime changed during program sequences')
    save(args.output/'summary.json',dict(status='passed',split=args.split,sequences=len(samples),
        calls=sum(s['count'] for s in samples),all_outputs_checked=True,fit_outer_sequence=False,
        internal_npu_compute_dma_wait='unseparated composite; no fit',numerical_fallback=False))


if __name__ == '__main__':
    main()
