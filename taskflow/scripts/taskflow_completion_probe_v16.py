#!/usr/bin/env python3
"""Matched v15 package replay with observable command-state polling intervals.

No production planning or fitting. The root agent serializes NPU execution.
Uses /tmp/npu.lock internally; invoke under an external timeout, without flock.
"""
import argparse
import fcntl
import json
from pathlib import Path
import sys
import time


def polling_wait(run, interval, calls, clock=time.perf_counter_ns, sleep=time.sleep):
    """Bracket command *visibility*, never DMA/core execution or device cycles."""
    record = {'poll_interval_seconds': interval, 'polls': [], 'sleeps': []}
    calls.append(record)
    while True:
        begin = clock()
        state = int(run.state())
        end = clock()
        record['polls'].append({'start_ns': begin, 'end_ns': end, 'state': state})
        if state not in (1, 2, 3, 7):
            break
        begin = clock()
        sleep(interval)
        record['sleeps'].append({'start_ns': begin, 'end_ns': clock()})
    if state != 4:
        record['status'] = 'failed'
        raise RuntimeError(f'NPU run ended in state {state}')
    record['status'] = 'completed'
    pending = [p for p in record['polls'] if p['state'] in (1, 2, 3, 7)]
    record['visible_completion_lower_ns'] = pending[-1]['start_ns'] if pending else None
    record['visible_completion_upper_ns'] = record['polls'][-1]['end_ns']
    record['visibility_bracket_ns'] = (record['visible_completion_upper_ns'] - record['visible_completion_lower_ns']) if pending else None
    record['scope'] = ('Host perf_counter_ns command state observations. Lower bound uses last pending query START; upper bound uses completed query END. '
                       'Conditional on monotone XRT state reporting; no lower bound on physical device completion; no physical DMA duration.')


def self_test():
    class Run:
        def __init__(self, states): self.states = iter(states)
        def state(self): return next(self.states)
    counter = iter(range(100, 1000, 10))
    calls = []
    polling_wait(Run([3, 4]), .0002, calls, lambda: next(counter), lambda _: None)
    r = calls[0]
    assert r['visible_completion_lower_ns'] == 100
    assert r['visible_completion_upper_ns'] == 150
    assert r['visibility_bracket_ns'] == 50 and len(r['sleeps']) == 1
    calls = []
    polling_wait(Run([4]), 0, calls)
    assert calls[0]['visible_completion_lower_ns'] is None
    try:
        polling_wait(Run([5]), 0, [])
    except RuntimeError:
        pass
    else:
        raise AssertionError('failed state accepted')
    print(json.dumps({'status': 'passed', 'checks': 5, 'device_submissions': 0}))


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--protocol', type=Path)
    p.add_argument('--output', type=Path)
    p.add_argument('--poll-us', type=float, default=200)
    p.add_argument('--validate-only', action='store_true')
    p.add_argument('--self-test', action='store_true')
    a = p.parse_args()
    if a.self_test:
        self_test(); return
    if not a.protocol or not a.output or a.poll_us < 0:
        p.error('protocol, new output and nonnegative poll-us required')
    import taskflow_device_transfer_microbench_v15 as base
    protocol = base.read(a.protocol)
    records = base.validate(protocol)
    a.output.mkdir(parents=True, exist_ok=False)
    base.write(a.output/'protocol.json', protocol)
    base.write(a.output/'identity.json', {'schema': 'orbit.completion-probe.v16',
        'source': base.ident(__file__), 'base_runner': base.ident(base.__file__),
        'protocol': base.ident(a.protocol), 'poll_us': a.poll_us,
        'device_open_requested': not a.validate_only,
        'claims': {'device_cycles': False, 'pure_dma_time': False, 'physical_completion_timestamp': False},
        'observer_change': 'forced polling backend; per-query in-memory timestamps; evidence IO after runner timer; condition differs from v15'})
    if a.validate_only:
        base.write(a.output/'summary.json', {'status': 'validated', 'cases': len(records), 'device_submissions': 0}); return
    from triton.backends.amd_triton_npu import multilaunch
    calls = []
    old_backend, old_interval = multilaunch._wait_nogil, multilaunch._POLL_INTERVAL
    def observed_polling(run):
        return polling_wait(run, a.poll_us / 1e6, calls)
    multilaunch._wait_nogil = observed_polling
    multilaunch._POLL_INTERVAL = a.poll_us / 1e6
    try:
        with open('/tmp/npu.lock', 'w') as lock:
            fcntl.flock(lock, fcntl.LOCK_EX)
            base.execute(protocol, records, a.output)
    finally:
        multilaunch._wait_nogil, multilaunch._POLL_INTERVAL = old_backend, old_interval
        with (a.output/'polling.jsonl').open('w') as f:
            for i, call in enumerate(calls):
                f.write(json.dumps(dict(call, call_ordinal=i), allow_nan=False) + '\n')
    samples = [json.loads(x) for x in (a.output/'samples.jsonl').read_text().splitlines()]
    assert len(samples) == len(calls), 'poll/sample correspondence mismatch'
    for sample, call in zip(samples, calls):
        starts = [e for e in sample['events'] if e['kind'] == 'actual_xrt_start']
        call['case'] = sample['case']; call['seed'] = sample['seed']; call['repeat'] = sample['repeat']
        call['warmup'] = sample['warmup']
        call['dispatch_to_visible_upper_ns'] = call['visible_completion_upper_ns'] - starts[0]['start_ns']
        call['dispatch_to_visible_lower_ns'] = (call['visible_completion_lower_ns'] - starts[0]['start_ns']) if call['visible_completion_lower_ns'] is not None else None
    with (a.output/'polling-bound-samples.jsonl').open('w') as f:
        for call in calls: f.write(json.dumps(call, allow_nan=False) + '\n')


if __name__ == '__main__': main()
