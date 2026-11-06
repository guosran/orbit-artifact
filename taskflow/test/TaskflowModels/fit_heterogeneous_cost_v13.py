#!/usr/bin/env python3
"""Aggregate frozen-training composite region measurements; never plan or rank."""
import argparse
from collections import defaultdict
import hashlib
import json
import math
from pathlib import Path
import statistics
import numpy as np

SCHEMA = 'orbit.heterogeneous.region-cost.v13'


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    return json.loads(Path(path).read_text())


def resolve(base, value):
    path = Path(value)
    return path.resolve() if path.is_absolute() else (base / path).resolve()


def identity(path):
    return dict(path=str(Path(path).resolve()), sha256=sha(path))


def require(condition, message):
    if not condition:
        raise ValueError(message)


def positive(value):
    return isinstance(value, (int, float)) and not isinstance(value, bool) and math.isfinite(value) and value > 0


def distribution(values):
    require(bool(values), 'empty measurement group')
    median = statistics.median(values)
    return dict(n=len(values), minimum=min(values), median=median, maximum=max(values),
                median_absolute_deviation=statistics.median(abs(v-median) for v in values))


def knot(xname, x, samples):
    bindings = sorted({(s['result']['path'], s['result']['sha256'], s['outputs']['sha256']) for s in samples})
    digest = hashlib.sha256(json.dumps(bindings, separators=(',', ':')).encode()).hexdigest()
    return {xname: x, 'ms': statistics.median(s['ms'] for s in samples), 'n': len(samples),
            'raw_sha256': digest, 'raw_identity_scope': 'sha256 compact JSON sorted (result path, result SHA, outputs SHA) tuples',
            'distribution_ms': distribution([s['ms'] for s in samples])}


def numeric(actual_path, reference_path):
    metrics = {}
    with np.load(actual_path, allow_pickle=False) as actual, np.load(reference_path, allow_pickle=False) as reference:
        require(set(actual.files) == set(reference.files), 'output/reference names differ')
        for name in reference.files:
            a, r = actual[name], reference[name]
            require(a.dtype == np.float32 and a.shape == r.shape, 'output dtype/shape mismatch')
            d = np.abs(a.astype(np.float64)-r.astype(np.float64))
            finite = bool(np.isfinite(a).all() and np.isfinite(r).all())
            passed = finite and bool(np.all(d <= 1e-5 + 1e-5*np.abs(r.astype(np.float64))))
            require(passed, 'independent numerical verification failed: '+name)
            mask = np.abs(r) >= 1e-6
            norm = float(np.linalg.norm(r.astype(np.float64)))
            metrics[name] = dict(passed=True, max_abs=float(d.max(initial=0)),
                max_relative_reference_ge_1e_6=float((d[mask]/np.abs(r[mask])).max(initial=0)),
                normalized_l2=float(np.linalg.norm(d)/norm) if norm else (0.0 if not np.any(d) else None))
    return metrics


def fit(dataset_path, training_roots, training_cases):
    dataset_path = Path(dataset_path).resolve()
    dataset = read(dataset_path)
    require(dataset['schema'] == 'orbit.heterogeneous.fixtures.v13' and
            dataset['split_status'] == 'frozen-before-timing-labels', 'dataset is not frozen v13')
    require(dataset.get('timing_labels_present') is False, 'dataset must precede timing labels')
    training = [c for c in dataset['cases'] if c['split'] == 'training']
    require({tuple(c['shape']) for c in training} == {(4, 64), (16, 64)}, 'only frozen 4x64/16x64 training supported')
    allowed = {}
    for case in training:
        source = resolve(dataset_path.parent, case['source']['path'])
        require(sha(source) == case['source']['sha256'], 'frozen training source changed')
        for pair in case['arrays']:
            paths = [resolve(dataset_path.parent, pair[k]['path']) for k in ('inputs', 'reference')]
            for key, path in zip(('inputs', 'reference'), paths):
                require(sha(path) == pair[key]['sha256'], 'frozen training array changed')
            allowed[tuple(sha(p) for p in paths)] = (case, paths[1])
    require(len(training_roots) == len(training_cases) and bool(training_roots), 'one cases file required per training root')
    groups, boundaries = defaultdict(list), defaultdict(list)
    raw, provenance, seen = [], [], set()
    common_identity = {}
    for root_arg, cases_arg in zip(training_roots, training_cases):
        root_arg = Path(root_arg).resolve()
        summary_path = root_arg if root_arg.is_file() else root_arg/'summary.json'
        if not summary_path.exists() and root_arg.is_dir():
            summary_path = root_arg/'results.json'
        root = summary_path.parent
        cases_path = Path(cases_arg).resolve()
        rows = read(cases_path)['cases']
        case_rows = {r['name']: r for r in rows}
        require(len(rows) == len(case_rows), 'duplicate case names')
        bound = {}
        for name, row in case_rows.items():
            require('/' not in name and name not in ('.', '..'), 'unsafe case name')
            require(len(row['inputs']) == len(row['reference']) > 0, 'unpaired input/reference')
            pairs = []
            for inp, ref in zip(row['inputs'], row['reference']):
                pair = tuple(sha(resolve(cases_path.parent, p)) for p in (inp, ref))
                require(pair in allowed, 'non-training or altered input/reference: '+name)
                pairs.append(allowed[pair])
            require(len({p[0]['name'] for p in pairs}) == 1, 'case spans different source shapes')
            compiled_path = resolve(cases_path.parent, row['compiled']) if row.get('compiled') else root/name/'compiled'/'compiled.json'
            compiled = read(compiled_path)
            manifest_path = resolve(compiled_path.parent, compiled['manifest'])
            manifest = read(manifest_path)
            prep_path = root/name/'preparation.json'
            prep = read(prep_path)
            require(compiled['schema'] == 'orbit.heterogeneous.compiled.v13' and manifest['schema'] == 'orbit.heterogeneous.static.v13', 'unexpected executable manifest schema')
            require(sha(manifest_path) == compiled['manifest_sha256'] == prep['manifest_sha256'], 'native manifest identity mismatch')
            require(sha(compiled_path) == prep['compiled_sha256'] and manifest['id'] == compiled['plan_id'] == prep['plan_id'], 'compiled/preparation identity mismatch')
            for field in ('program_family_key', 'execution_contract_identity'):
                value = manifest.get(field)
                require(isinstance(value, str) and bool(value), 'missing native '+field)
                require(field not in common_identity or common_identity[field] == value,
                        'training cases differ in '+field)
                common_identity[field] = value
            shape = pairs[0][0]['shape']
            require(all(s['dtype'] == 'f32' and s['shape'] == shape for s in manifest['storage']), 'source storage differs from frozen shape')
            count = math.prod(shape)
            require({s['name']: s['role'] for s in manifest['storage']} == {'A':'input','B':'input','T':'temporary','U':'temporary','C':'output'}, 'unexpected fixture ABI')
            interface_bytes = sum(s['bytes'] for s in manifest['storage'] if s['role'] in ('input', 'output'))
            require(interface_bytes == 12*count, 'logical interface byte count differs')
            task_ids = [task for region in manifest['regions'] for task in region['tasks']]
            require(sorted(task_ids) == [0, 1, 2], 'regions must partition actual three source tasks')
            regions = {}
            require(len(compiled['regions']) == len(manifest['regions']), 'compiled region count differs')
            for region, executable in zip(manifest['regions'], compiled['regions']):
                device, tasks, work = region['device'], region['tasks'], region['work_elements']
                require(device in ('cpu', 'npu') and 1 <= len(tasks) <= 3 and positive(work), 'invalid native region feature')
                require(region.get('model_operations_supported') is True and work == count*len(tasks), 'native arithmetic work outside frozen one-op-per-task fixture')
                require(executable['device'] == device and executable['index'] == region['index'], 'compiled region binding differs')
                source = resolve(manifest_path.parent, region['source'])
                require(sha(source) == executable['source_sha256'], 'compiled child source changed')
                if device == 'cpu':
                    binary = resolve(compiled_path.parent, executable['library'])
                    expected_sha = executable['library_sha256']
                else:
                    binary = resolve(compiled_path.parent, executable['artifact']['elf_path'])
                    expected_sha = executable['artifact']['elf_sha256']
                require(sha(binary) == expected_sha, 'region executable changed')
                regions[region['index']] = (device, len(tasks), work)
            bound[name] = (pairs, regions, interface_bytes)
            provenance.append(dict(case=name, summary_path_pending=str(summary_path), cases=identity(cases_path),
                manifest=identity(manifest_path), compiled=identity(compiled_path), preparation=identity(prep_path),
                executor_sha256=compiled.get('executor_sha256'), runtime=prep.get('runtime')))
        # Only open timing labels after every declared case is proven training-only.
        for record in provenance:
            if record.get('summary_path_pending') == str(summary_path):
                del record['summary_path_pending']
                record['summary'] = identity(summary_path)
        summary = read(summary_path)
        require(summary['status'] == 'passed', 'failed training run must not be fitted')
        for sample in summary['samples']:
            name, seed, repeat = sample['case'], sample['seed_index'], sample['repeat']
            key = (str(root), name, seed, repeat)
            require(key not in seen, 'duplicate sample'); seen.add(key)
            require(name in bound, 'sample not in supplied cases')
            pairs, regions, byte_count = bound[name]
            require(type(seed) is int and 0 <= seed < len(pairs), 'bad seed index')
            result_path = root/name/f'seed-{seed}'/f'repeat-{repeat}'/'result.json'
            output_path = result_path.with_name('outputs.npz')
            result = read(result_path)
            require(all(sample[k] == v for k,v in result.items()), 'summary differs from raw sample')
            require(result['passed'] is True and result['input_reset_in_timing'] is True and result['final_output_copy_in_timing'] is True, 'unsupported sample boundary')
            metrics = numeric(output_path, pairs[seed][1])
            entry = dict(case=name, seed_index=seed, repeat=repeat, warmup=result['warmup'],
                         result=identity(result_path), outputs=identity(output_path), numerical=metrics)
            raw.append(entry)
            calls = result['region_calls']
            require([c['region'] for c in calls] == list(regions), 'missing/duplicate/out-of-order region calls')
            durations, last_end = [], None
            for call in calls:
                require(type(call['start_ns']) is int and type(call['end_ns']) is int and call['end_ns'] >= call['start_ns'], 'invalid region timestamp')
                require(last_end is None or call['start_ns'] >= last_end, 'overlapping serial region calls')
                last_end = call['end_ns']
                ms = (call['end_ns']-call['start_ns'])/1e6
                durations.append(ms)
                if not result['warmup']:
                    groups[regions[call['region']]].append(dict(entry, ms=ms))
            wall = result['wall_ms']
            require(positive(wall), 'invalid whole-call wall')
            residual = wall-sum(durations)
            require(math.isfinite(residual) and residual >= -1e-9, 'region calls exceed whole-call wall')
            if not result['warmup']:
                event_costs = defaultdict(float)
                for event in result['events']:
                    if event['kind'] in ('host_input_reset', 'host_final_output_copy'):
                        event_costs[event['kind']] += (event['end_ns']-event['start_ns'])/1e6
                require(sum(e['kind'] == 'host_input_reset' for e in result['events']) == 2 and
                        sum(e['kind'] == 'host_final_output_copy' for e in result['events']) == 1,
                        'missing actual reset/final-copy timing events')
                other = residual-sum(event_costs.values())
                require(other >= -1e-9, 'explicit host copies exceed boundary residual')
                boundaries[byte_count].append(dict(entry, ms=max(0.0,residual),
                    input_reset_ms=event_costs['host_input_reset'], final_output_copy_ms=event_costs['host_final_output_copy'],
                    other_outer_gaps_ms=max(0.0,other)))
    rows = []
    for device in ('cpu', 'npu'):
        for count in range(1,4):
            knots = [knot('work_elements', work, samples) for (dev,n,work),samples in sorted(groups.items()) if dev == device and n == count]
            rows.append(dict(device=device, task_count=count, status='calibrated' if len(knots)>=2 else 'uncalibrated', knots=knots))
    boundary_knots = [knot('bytes', value, samples) for value,samples in sorted(boundaries.items())]
    require(groups and boundaries, 'no hot training measurements')
    model = dict(schema=SCHEMA, program_family_key=common_identity['program_family_key'],
        execution_contract_identity=common_identity['execution_contract_identity'], region_models=rows,
        boundary_model=dict(status='calibrated' if len(boundary_knots)>=2 else 'uncalibrated', knots=boundary_knots),
        interpolation=dict(method='piecewise-linear', range='inclusive measured minimum to maximum only', extrapolation=False, minimum_distinct_knots=2),
        scope=dict(region='composite wall including dispatch, descriptors/ctypes or BO sync/start/wait and observer; no additional DMA/launch charge',
            boundary='whole wall minus sum of serial region walls; input reset, final output copy and other outer gaps charged once',
            prediction='sum of matching device/task_count region interpolations plus one boundary interpolation', units='milliseconds',
            physical_ddr_measurement=False, execution_clock_measurement=False, warmups_used=False,
            generalization='one fixed source arithmetic/SSA/access/dependency family under one execution contract only'),
        dataset_identity=identity(dataset_path), training_provenance=provenance,
        fitter=identity(__file__), uncertainty=dict(boundary_by_bytes=[dict(bytes=b,
            residual_ms=distribution([s['ms'] for s in ss]), input_reset_ms=distribution([s['input_reset_ms'] for s in ss]),
            final_output_copy_ms=distribution([s['final_output_copy_ms'] for s in ss]),
            other_outer_gaps_ms=distribution([s['other_outer_gaps_ms'] for s in ss])) for b,ss in sorted(boundaries.items())]))
    return model, dict(status='passed', numerical_contract=dict(atol=1e-5,rtol=1e-5), samples=raw,
                       timing_label_samples=sum(not r['warmup'] for r in raw), holdout_labels_read=False)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--dataset-frozen-manifest', type=Path, required=True)
    parser.add_argument('--training-root', type=Path, action='append', required=True, help='executor output directory or summary/results.json; paired with cases in argument order')
    parser.add_argument('--training-cases', type=Path, action='append', required=True, help='original executor cases JSON binding native compiled artifacts and training arrays')
    parser.add_argument('--output', type=Path, required=True, help='new directory')
    args = parser.parse_args()
    require(not args.output.exists(), 'output already exists')
    model, audit = fit(args.dataset_frozen_manifest, args.training_root, args.training_cases)
    args.output.mkdir(parents=True)
    (args.output/'fitter-source.py').write_bytes(Path(__file__).read_bytes())
    for name,value in [('model.json',model),('training-audit.json',audit)]:
        (args.output/name).write_text(json.dumps(value,indent=2,allow_nan=False)+'\n')
    (args.output/'freeze.json').write_text(json.dumps(dict(schema='orbit.heterogeneous.cost-freeze.v13',
        model=identity(args.output/'model.json'), training_audit=identity(args.output/'training-audit.json'),
        dataset=identity(args.dataset_frozen_manifest), fitter=identity(__file__), holdout_labels_read=False),indent=2)+'\n')
    print(json.dumps(dict(status='passed', model=str(args.output/'model.json'), model_sha256=sha(args.output/'model.json'))))


if __name__ == '__main__':
    main()
