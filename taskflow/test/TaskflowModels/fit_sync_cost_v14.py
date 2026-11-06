#!/usr/bin/env python3
"""Training-only sync API calibration. No device access or production planning."""
import argparse
import hashlib
import itertools
import json
from pathlib import Path
import shutil
import sys

import numpy as np


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def load(p):
    return json.loads(Path(p).read_text())


def canonical(x):
    return json.dumps(x, sort_keys=True, separators=(',', ':')).encode()


def ident(p):
    p = Path(p).resolve()
    return {'path': str(p), 'sha256': sha(p)}


def verify(x):
    assert sha(x['path']) == x['sha256'], f"changed evidence: {x['path']}"
    return Path(x['path'])


def stats(xs):
    a = np.asarray(xs, dtype=float)
    m = float(np.median(a))
    return {'n': len(xs), 'median_ns': m, 'mad_ns': float(np.median(abs(a-m))),
            'p5_ns': float(np.percentile(a, 5)), 'p95_ns': float(np.percentile(a, 95)),
            'max_ns': float(max(a))}


def context(root, protocol, split, program=False):
    root = Path(root)
    i = load(root/'identity.json')
    assert i['split'] == split, 'labels from wrong split refused before reading samples'
    assert i['protocol']['sha256'] == sha(protocol)
    assert sha(root/'protocol.json') == sha(protocol)
    before, after = load(root/'runtime-fingerprint-before.json'), load(root/'runtime-fingerprint-after.json')
    assert before == after
    assert before['target_id'] == i['runtime_target_id']
    expected = load(verify(load(protocol)['runtime_fingerprint']))
    assert before == expected, 'runtime snapshot differs from protocol-bound target'
    assert load(root/'summary.json')['status'] == 'passed'
    source = root/('sequence-source.py' if program else 'microbench-source.py')
    assert sha(source) == i['source_sha256']
    return i


def conditions(i, program=False):
    descriptor = {
        'schema': 'orbit.sync-observation-condition.v14',
        'allocation_scope': 'reused-prepared-bound-bo' if program else 'fresh-ext-bo-per-sample',
        'prepared_context_count': len(i['cases']) if program else len(i['program_input_identities']),
        'source_sha256': i['source_sha256'],
        'executor_sha256': i['executor']['sha256'] if program else None,
        'observer_sha256': i['observer']['sha256'] if program else i['source_sha256'],
        'precondition': ('actual Prepared.one input reset and output NaN poison; successful device wait before readback'
                         if program else 'one untimed prior same-form TO; no subsequent mapped access; prebound method and positional arguments'),
        'timing_scope': 'original ObservedBO.sync inner API span' if program else 'single outer timer around prebound Python sync loop',
    }
    return hashlib.sha256(canonical(descriptor)).hexdigest(), descriptor


def read_micro(root, protocol, split):
    i = context(root, protocol, split)
    assert not i['program_input_identities'], 'standalone model refuses loaded program contexts'
    groups, excluded = {}, {}
    registered = {c['id']: c for c in load(protocol)['cells'] if c['split'] == split}
    for line in (Path(root)/'samples-index.jsonl').read_text().splitlines():
        record = json.loads(line)
        p = verify(record['sample'])
        s = load(p)
        c = s['cell']
        assert s['split'] == split and c == registered[s['cell_id']]
        assert s['unit'] == 'ns'
        if s['warmup']:
            continue
        primary = (c['observer_mode'] == 'batch' and c['state'] == 'unchanged-repeat'
                   and c['direction'] == 'TO_DEVICE' and c['program_case'] is None)
        if not primary:
            excluded[c['id']] = {'cell': c, 'reason': 'diagnostic observer/state; no model score'}
            continue
        assert s['bo']['type'] == 'pyxrt.ext.bo'
        assert s['bo']['actual_size'] == c['bo_bytes']
        assert s['actual_sync_extent']['offset'] == c['offset_bytes']
        assert s['actual_sync_extent']['bytes'] == c['size_bytes']
        assert c['size_bytes'] % 64 == 0 and c['offset_bytes'] % 64 == 0
        assert s['actual_api_call_count'] == c['sequence_count']
        assert [e['kind'] for e in s['setup']] == ['new-ext-bo-map-initialize', 'untimed-prior-sync']
        assert len(s['state_transitions']) == c['sequence_count']
        assert all(e['state_before'] == 'after-TO_DEVICE-sync' and e['dirty_range'] is None for e in s['state_transitions'])
        g = groups.setdefault(c['id'], {'cell': c, 'values': [], 'seeds': {}, 'evidence': []})
        value = s['outer_sequence_ns']
        assert value > 0 and s['end_ns']-s['start_ns'] == value
        g['values'].append(value)
        g['seeds'].setdefault(str(s['seed']), []).append(value)
        g['evidence'].append(record['sample'])
    expected = {k for k,c in registered.items() if c['observer_mode']=='batch' and c['state']=='unchanged-repeat' and c['direction']=='TO_DEVICE' and c['program_case'] is None}
    assert set(groups) == expected
    for g in groups.values():
        assert set(map(int,g['seeds'])) == set(load(protocol)['seeds'])
        assert len(g['values']) == len(g['seeds'])*g['cell']['repeats']
    return i, groups, list(excluded.values())


def read_program(root, protocol, split):
    i = context(root, protocol, split, True)
    assert len(i['cases']) == 2
    groups = {}
    seqs = load(Path(root)/'program-sequences.json')
    for s in seqs:
        assert s['split'] == split
        if s['warmup']:
            continue
        assert len(s['calls']) == s['count'] and not s['fit_outer_sequence'] and not s['fit_one_wall']
        for call in s['calls']:
            raw_result = load(verify(call['raw_result'])); verify(call['raw_outputs'])
            sites = call['sync_api_sites']
            assert [(x['argument_ordinal'], x['direction']) for x in sites] == [(0,'TO_DEVICE'),(1,'TO_DEVICE'),(2,'TO_DEVICE'),(2,'FROM_DEVICE')]
            for e in sites:
                assert e['invocation_form'] == 'implicit-full-buffer'
                assert e['observation_boundary'] == 'detailed-compatibility'
                assert e['requested_offset_bytes'] == 0 and e['requested_bo_size'] == e['actual_bo_extent']
                assert e['elapsed_ns'] == e['end_ns']-e['start_ns'] and e['elapsed_ns'] > 0
                event = raw_result['events'][e['event_index']]
                assert event['kind'] == 'actual_bo_sync'
                assert event['start_ns'] == e['start_ns'] and event['end_ns'] == e['end_ns']
                assert event['storage'] == e['storage'] and event['region'] == e['region']
                assert event['direction'].endswith('XCL_BO_SYNC_BO_'+e['direction'])
                key = (e['site'],e['argument_ordinal'],e['direction'],s['case'],s['count'])
                g = groups.setdefault(key, {'site':e['site'],'argument_ordinal':e['argument_ordinal'],
                    'direction':e['direction'],'case':s['case'],'count':s['count'],'bytes':e['requested_bo_size'],
                    'values':[],'seeds':{},'evidence':[]})
                assert g['bytes'] == e['requested_bo_size']
                g['values'].append(e['elapsed_ns'])
                g['seeds'].setdefault(str(s['seed']),[]).append(e['elapsed_ns'])
                g['evidence'].append(call['raw_result'])
    assert len(groups) == 16, 'requires two sizes, two sequence counts and four sites'
    settings = load(protocol)['program_sequence']
    expected_counts = set(settings[split]['counts'])
    assert {g['count'] for g in groups.values()} == expected_counts
    for g in groups.values():
        assert set(map(int,g['seeds'])) == set(load(protocol)['seeds'])
        assert all(len(v) == settings['repeats']*g['count'] for v in g['seeds'].values())
    return i, groups


def nnls3(x,y):
    x,y = np.asarray(x,dtype=float),np.asarray(y,dtype=float)
    scale = np.linalg.norm(x,axis=0)
    assert np.all(scale>0)
    z = x/scale
    assert np.linalg.matrix_rank(z) == 3, 'unidentifiable training design'
    best = (float(y@y), np.zeros(3))
    for n in range(1,4):
        for active in itertools.combinations(range(3),n):
            a = np.linalg.lstsq(z[:,active],y,rcond=None)[0]
            if np.min(a) < -1e-7:
                continue
            b = np.zeros(3); b[list(active)] = np.maximum(a,0)/scale[list(active)]
            loss = float(np.sum((x@b-y)**2))
            if loss < best[0]: best = loss,b
    assert np.any(best[1] > 0)
    return best[1], {'rank':3,'normalized_condition':float(np.linalg.cond(z)), 'squared_error_ns2':best[0]}


def fit(args):
    out = Path(args.output)
    assert not out.exists(), 'NEW output required'
    protocol = Path(args.protocol).resolve()
    mi, mg, excluded = read_micro(args.calibration_root,protocol,'calibration')
    pi, pg = read_program(args.program_calibration_root,protocol,'calibration')
    assert mi['runtime_target_id'] == pi['runtime_target_id']
    for key in ('observer','executor','runtime_collector'):
        assert mi[key]['sha256'] == pi[key]['sha256']
    mc,md = conditions(mi); pc,pd = conditions(pi,True)
    raw = {'protocol':ident(protocol),'micro_identity':ident(Path(args.calibration_root)/'identity.json'),
           'micro_index':ident(Path(args.calibration_root)/'samples-index.jsonl'),
           'program_identity':ident(Path(args.program_calibration_root)/'identity.json'),
           'program_samples':ident(Path(args.program_calibration_root)/'program-sequences.json')}
    rawsha = hashlib.sha256(canonical(raw)).hexdigest()
    rows, reports = [], []
    base = {'runtime_identity':mi['runtime_target_id'],'alignment_bytes':64}
    for form in ('whole-implicit','whole-explicit','region-explicit'):
        gs = [g for g in mg.values() if g['cell']['invocation_form']==form]
        x = [[1,g['cell']['sequence_count'],g['cell']['sequence_count']*g['cell']['size_bytes']/64] for g in gs]
        y = [np.median(g['values']) for g in gs]
        coeff, report = nnls3(x,y)
        assert len(gs) == 12
        domain = dict(base,site='prebound-contiguous-sync-loop',argument_ordinal=-1,call_form=form,
            observer_boundary='batch-outer',direction='TO_DEVICE',observer_identity=mi['source_sha256'],
            condition_identity=mc,allowed_states=['post-TO-no-access'],
            min_bytes=min(g['cell']['size_bytes'] for g in gs),max_bytes=max(g['cell']['size_bytes'] for g in gs),
            min_count=1,max_count=23)
        rows.append({'domain':domain,'formula':'batch-entry-plus-cachelines','entry_ns':float(coeff[0]),
            'call_ns':float(coeff[1]),'cacheline_ns':float(coeff[2]),'raw_manifest_sha256':rawsha,
            'provenance':'equal-weight per-calibration-cell median NNLS; outer Python-loop timer, not physical transfer time'})
        report['training_only_seed_fits'] = {seed: nnls3(x,[np.median(g['seeds'][seed]) for g in gs])[0].tolist() for seed in gs[0]['seeds']}
        report['training_only_leave_one_requested_size_out'] = {}
        for size in sorted({g['cell']['size_bytes'] for g in gs}):
            kept = [j for j,g in enumerate(gs) if g['cell']['size_bytes'] != size]
            estimate, diagnostic = nnls3([x[j] for j in kept],[y[j] for j in kept])
            report['training_only_leave_one_requested_size_out'][str(size)] = {'coefficients':estimate.tolist(), **diagnostic}
        report.update(form=form,coefficients=coeff.tolist(),cells=[{'cell':g['cell'],**stats(g['values']),
            'seed_statistics':{k:stats(v) for k,v in g['seeds'].items()}} for g in gs])
        reports.append(report)
    sitekeys = sorted({(g['site'],g['argument_ordinal'],g['direction']) for g in pg.values()})
    for site,ordinal,direction in sitekeys:
        gs = [g for g in pg.values() if (g['site'],g['argument_ordinal'],g['direction'])==(site,ordinal,direction)]
        assert sorted(g['bytes'] for g in gs)==[1024,1024,4096,4096]
        value = float(np.median([np.median(g['values']) for g in gs]))
        assert value > 0
        domain = dict(base,site=site,argument_ordinal=ordinal,call_form='whole-implicit',observer_boundary='detailed-compatibility',
            direction=direction,observer_identity=pi['observer']['sha256'],condition_identity=pc,
            allowed_states=['host-write-observed','host-write-since-sync'] if direction=='TO_DEVICE' else ['after-device-write-complete'],
            min_bytes=1024,max_bytes=4096,min_count=1,max_count=1)
        rows.append({'domain':domain,'formula':'fixed-api-site','entry_ns':0,'call_ns':value,'cacheline_ns':0,
            'raw_manifest_sha256':rawsha,'provenance':'median of four calibration-cell medians; original ObservedBO inner API spans only'})
        reports.append({'site':site,'argument_ordinal':ordinal,'direction':direction,'call_ns':value,
            'cells':[{k:g[k] for k in ('case','count','bytes')}|stats(g['values']) for g in gs]})
    model = {'schema':'orbit.sync-api.model.v14','model_id':'training-cell-median-v14-r1','units':'ns','rows':rows,
        'conditions':{mc:md,pc:pd},'training_evidence':raw,
        'limitations':['No physical traffic or bandwidth claim.','Batch entry includes wrapper/timer/loop transient.',
            'Program site parameters price original detailed observer spans; no micro/program context pooling.',
            'Compute, wait, full wall and unsupported states remain unpriced.','v13 boundaries/forms differ; no comparable physical baseline.']}
    out.mkdir(parents=True)
    def write(name,x): (out/name).write_text(json.dumps(x,indent=2,sort_keys=True)+'\n')
    write('raw-manifest.json',raw)
    write('model.json',model)
    write('fit-report.json',{'schema':'orbit.sync-api.fit.v14','status':'passed','training_only':True,
        'holdout_labels_read':False,'rows':reports,'excluded_diagnostic_cells':excluded,'condition_identities':{mc:md,pc:pd}})
    shutil.copyfile(__file__,out/'fitter-source.py')
    write('freeze.json',{'schema':'orbit.sync-api.freeze.v14','training_only':True,
        'files':{n:ident(out/n) for n in ('model.json','fit-report.json','raw-manifest.json','fitter-source.py')},
        'protocol':ident(protocol),'condition_identities':{'micro':mc,'program':pc}})
    print(json.dumps({'status':'passed','model':ident(out/'model.json'),'conditions':{'micro':mc,'program':pc}}))


def main():
    p=argparse.ArgumentParser(description=__doc__); sub=p.add_subparsers(dest='command',required=True)
    f=sub.add_parser('fit'); f.add_argument('--protocol',required=True);f.add_argument('--calibration-root',required=True)
    f.add_argument('--program-calibration-root',required=True);f.add_argument('--output',required=True)
    a=sub.add_parser('audit')
    for k in ('protocol','calibration-root','program-calibration-root','holdout-root','program-holdout-root','model-root','output'):
        a.add_argument('--'+k,required=True)
    a.add_argument('--holdout-gate')
    args=p.parse_args()
    if args.command=='fit': fit(args)
    else:
        import subprocess
        target=Path(__file__).resolve().parents[1]/'TaskflowMapping'/'validate_sync_cost_v14.py'
        return subprocess.call([sys.executable,str(target)]+sys.argv[2:])
    return 0

if __name__=='__main__': sys.exit(main())
