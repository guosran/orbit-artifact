#!/usr/bin/env python3
"""Read-only independent full-array and paired host timing audit. No fitting."""
import argparse
import hashlib
import itertools
import json
from pathlib import Path

import numpy as np


def read(path):
    return json.loads(Path(path).read_text())


def verify(identity):
    path = Path(identity['path'])
    assert hashlib.sha256(path.read_bytes()).hexdigest() == identity['sha256'], str(path)


def dist(values):
    array = np.asarray(values, dtype=np.float64)
    assert len(array) and np.isfinite(array).all()
    return dict(n=len(array), mean=float(array.mean()), median=float(np.median(array)),
                p05=float(np.quantile(array, .05)), p95=float(np.quantile(array, .95)),
                min=float(array.min()), max=float(array.max()), raw=array.tolist())


def oracle(inputs, kind):
    a, d = (inputs[key].astype(np.float64) for key in ['A', 'D'])
    round32 = lambda value: value.astype(np.float32).astype(np.float64)
    if kind == 'interleaved':
        x = round32(a+1)
        y, z = round32(x+a), round32(x-1)
        strict = dict(O=round32(y+z), H=round32(round32(d*2)+3))
        exact = dict(O=3*a+1, H=2*d+3)
    elif kind == 'shared-input':
        strict = dict(O=round32(round32(a+1)+round32(a*2)), U=round32(d+3))
        exact = dict(O=3*a+1, U=d+3)
    elif kind == 'coupling':
        x = round32(a+1)
        y = round32(2*x)
        z, r = round32(y+a), round32(x-1)
        strict = dict(O=round32(z+r), H=round32(round32(2*d)+3))
        exact = dict(O=4*a+2, H=2*d+3)
    else:
        raise ValueError('unknown frozen arithmetic fixture kind: '+str(kind))
    return strict, exact


def audit(session, protocol):
    rows = [json.loads(line) for line in (session/'samples.jsonl').read_text().splitlines()]
    cases = {case['id']: case for case in protocol['cases']}
    expected = set(itertools.product(cases, protocol['seeds'],
        range(protocol['warmups']+protocol['repeats'])))
    seen, inputs_seen, hot, arrays, maxerror = set(), {}, {key: {} for key in cases}, 0, 0.
    maxerror64 = 0.
    assert read(session/'protocol.json') == protocol
    assert read(session/'summary.json')['actual_submissions'] == len(expected) == len(rows)
    for row in rows:
        key = row['case'], row['seed'], row['repeat']
        assert key in expected and key not in seen
        seen.add(key)
        case = cases[row['case']]
        assert row['case_identity'] == case
        fixture = read(case['fixture']['path'])['fixture']
        for field in ['inputs', 'outputs', 'reference', 'reference_f64']:
            verify(row[field])
        with np.load(row['inputs']['path'], allow_pickle=False) as archive:
            inputs = {name: archive[name].copy() for name in archive.files}
        assert set(inputs) == set(fixture['inputs'])
        for value in inputs.values():
            assert value.shape == (fixture['m'], fixture['n']) and value.dtype == np.float32 and np.isfinite(value).all()
        pair = row['seed'], row['repeat']
        if pair in inputs_seen:
            assert all(np.array_equal(value, inputs_seen[pair][name]) for name, value in inputs.items())
        else:
            inputs_seen[pair] = inputs
        strict, exact = oracle(inputs, fixture['kind'])
        with np.load(row['outputs']['path'], allow_pickle=False) as actual, \
             np.load(row['reference']['path'], allow_pickle=False) as reference, \
             np.load(row['reference_f64']['path'], allow_pickle=False) as reference64:
            assert set(actual.files) == set(reference.files) == set(reference64.files) == set(strict)
            for name in actual.files:
                value = actual[name]
                assert value.dtype == np.float32 and value.shape == strict[name].shape and np.isfinite(value).all()
                assert np.array_equal(reference[name], strict[name])
                assert reference64[name].dtype == np.float64 and np.array_equal(reference64[name], exact[name])
                assert np.allclose(value, strict[name], atol=1e-5, rtol=1e-5)
                assert np.allclose(value, exact[name], atol=1e-5, rtol=1e-5)
                arrays += 1
                maxerror = max(maxerror, float(np.abs(value.astype(np.float64)-strict[name]).max()))
                maxerror64 = max(maxerror64, float(np.abs(value.astype(np.float64)-exact[name]).max()))
        events = row['events']
        starts = [event for event in events if event['kind'] == 'actual_xrt_start']
        waits = [event for event in events if event['kind'] == 'actual_xrt_wait']
        syncs = [event for event in events if event['kind'] == 'actual_bo_sync']
        assert len(starts) == len(waits) == 1
        assert len(syncs) == len(read(case['abi']['path'])['buffers'])+len(strict)
        assert row['runner_wall_ns'] == row['dispatch_to_wait_end_ns']+row['sync_subtotal_ns']+row['other_runner_ns']
        assert row['warmup'] == (row['repeat'] < protocol['warmups'])
        if not row['warmup']:
            hot[row['case']][pair] = row['runner_wall_ns']/1e6
    assert seen == expected
    rng = np.random.default_rng(2001)
    pairs = []
    for left, right in itertools.combinations(cases, 2):
        keys = sorted(hot[left])
        assert keys == sorted(hot[right])
        delta = np.array([hot[right][key]-hot[left][key] for key in keys])
        bootstrap = np.median(rng.choice(delta, (5000, len(delta)), replace=True), axis=1)
        interval = list(map(float, np.quantile(bootstrap, [.025, .975])))
        prediction = cases[right]['frozen_prediction']['ms']-cases[left]['frozen_prediction']['ms']
        model_tied = abs(prediction) <= 1e-12
        pairs.append(dict(left=left, right=right, predicted_delta_ms=prediction, model_tied=model_tied, model_tie_epsilon_ms=1e-12,
            observed_delta_ms=dist(delta), paired_median_bootstrap95_ms=interval,
            resolved=interval[0] > 0 or interval[1] < 0,
            sign_agreement=None if model_tied else bool(np.sign(prediction) == np.sign(np.median(delta)))))
    return dict(status='PASS', session=str(session), calls=len(rows), output_arrays=arrays,
        max_abs_error_f32=maxerror, max_abs_error_f64=maxerror64, distributions={key: dist(list(values.values())) for key, values in hot.items()},
        pairs=pairs, strict_untied_pairs=sum(not x['model_tied'] for x in pairs),
        resolved_wrong_order_pairs=sum(not x['model_tied'] and x['resolved'] and not x['sign_agreement'] for x in pairs))


def validate_protocol(protocol):
    for field in ['fixture_generator', 'runner', 'observer', 'polling_observer',
                  'installed_runtime', 'base_observer', 'v21_wrapper']:
        verify(protocol[field])
    for case in protocol['cases']:
        for field in ['fixture', 'source', 'compile', 'elf', 'abi', 'plan', 'transformed',
                      'aie', 'implementation_contract', 'program_graph', 'target_configuration', 'actual_facts']:
            verify(case[field])
        plan = read(case['plan']['path'])
        assert plan['program_graph'] == read(case['program_graph']['path'])
        assert case['frozen_prediction'] == dict(ms=plan['estimated_ms'],
            graph_id=plan['program_graph_id'], groups=len(plan['execution_groups']),
            requested_transfer_bytes=plan['actual_dma_bytes'], peak_payload_bytes=plan['resident_bytes'])
        assert read(case['implementation_contract']['path'])['valid'] is True
        def strip_annotations(value):
            if isinstance(value, list):
                return [strip_annotations(item) for item in value]
            if isinstance(value, dict):
                return {key: strip_annotations(item) for key, item in value.items()
                        if key != 'proposed_bindings' and not key.startswith('orbit.')}
            return value
        operations = strip_annotations(read(case['actual_facts']['path'])['operations'])
        actual_digest = hashlib.sha256(json.dumps(operations, sort_keys=True,
            separators=(',', ':')).encode()).hexdigest()
        assert actual_digest == case['actual_structure_sha256']


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument('--protocol', type=Path)
    mode.add_argument('--manifest', type=Path)
    parser.add_argument('--session', type=Path, action='append')
    parser.add_argument('--sessions-root', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=False)
    batches = []
    if args.manifest:
        assert args.sessions_root and not args.session
        manifest = read(args.manifest)
        for field in ['experiment_protocol', 'compiled_index', 'wrapper']:
            verify(manifest[field])
        seen = set()
        for entry in manifest['protocols']:
            key = entry['program'], entry['batch']
            assert key not in seen
            seen.add(key)
            verify(entry['protocol'])
            protocol = read(entry['protocol']['path'])
            validate_protocol(protocol)
            assert len(protocol['cases']) == entry['cases']
            assert entry['baseline_control'] in {case['id'] for case in protocol['cases']}
            sessions = [args.sessions_root / f"npu-{entry['program']}-batch-{entry['batch']}-session-{number}"
                        for number in [1, 2]]
            results = [audit(session, protocol) for session in sessions]
            assert all(row['calls'] == entry['expected_calls_per_session'] for row in results)
            batches.append(dict(program=entry['program'], batch=entry['batch'],
                                protocol=entry['protocol'], sessions=results))
        results = [row for batch in batches for row in batch['sessions']]
    else:
        assert args.session and not args.sessions_root
        protocol = read(args.protocol)
        validate_protocol(protocol)
        results = [audit(session, protocol) for session in args.session]
    report = dict(status='PASS', calls=sum(row['calls'] for row in results),
        output_arrays=sum(row['output_arrays'] for row in results),
        max_abs_error_f32=max(row['max_abs_error_f32'] for row in results),
        max_abs_error_f64=max(row['max_abs_error_f64'] for row in results),
        sessions=results if not batches else [], batches=batches,
        scope='All three explicit arithmetic oracles. Pairs and bootstrap intervals only within each batch/session; no cross-batch timing pooling. Aggregate counts and maximum numerical errors only. No refitting; not independent-day evidence.')
    (args.output/'report.json').write_text(json.dumps(report, indent=2, allow_nan=False)+'\n')
    print(json.dumps(dict(status='PASS', calls=report['calls'], output_arrays=report['output_arrays'])))


if __name__ == '__main__':
    main()
