#!/usr/bin/env python3
"""Verify and show the portable, frozen four-program Source35 result snapshot."""
import argparse
import csv
import hashlib
import json
import math
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
DEFAULT=ROOT/'diagnostics/source35-four-workload-20261011'


def sha(path):
    with Path(path).open('rb') as stream:
        return hashlib.file_digest(stream,'sha256').hexdigest()


def load(directory):
    manifest=json.loads((directory/'MANIFEST.json').read_text())
    for name,digest in manifest['artifact_sha256'].items():
        path=ROOT/name
        if sha(path)!=digest:raise ValueError('Snapshot changed: '+name)
    protocol=json.loads((directory/'protocol.json').read_text())
    with (directory/'ablation.csv').open() as stream:ablation=list(csv.DictReader(stream))
    with (directory/'main.csv').open() as stream:main=list(csv.DictReader(stream))
    evidence=json.loads((directory/'evidence.json').read_text())['cells']
    workloads=protocol['active_workloads'];stages=protocol['stages'];methods=protocol['methods']
    assert len(ablation)==24 and {(r['workload'],r['stage']) for r in ablation}=={(w,s) for w in workloads for s in stages}
    assert len(main)==16 and {(r['workload'],r['method']) for r in main}=={(w,m) for w in workloads for m in methods}
    assert len(evidence)==40
    for kind,key,rows in [('ablation','stage',ablation),('main','method',main)]:
        for row in rows:
            matches=[e for e in evidence if e['kind']==kind and e['workload']==row['workload'] and e[key]==row[key]]
            assert len(matches)==1
            cell=matches[0]
            for field in ['native_cycles','objective_calls','budget_cap','native_evaluated','native_replayed','numeric_validated','certified_scheduler_rejected']:
                assert int(row[field])==cell[field], 'CSV/evidence mismatch: '+field
            outcomes=cell['outcomes']
            assert len(outcomes)==int(row['native_evaluated'])
            assert [o['rank'] for o in outcomes]==list(range(len(outcomes)))
            accepted=[o for o in outcomes if o['outcome']=='native-accepted']
            rejected=[o for o in outcomes if o['outcome']=='scheduler-rejected']
            assert len(accepted)==int(row['native_replayed']) and len(rejected)==int(row['certified_scheduler_rejected'])
            assert all(o['native_cycles'] is None for o in rejected)
            assert all(o[f]=='pass' for o in accepted for f in ['source_integrity','mapper_integrity','native_trace','strict_numeric'])
            assert min(o['native_cycles'] for o in accepted)==int(row['native_cycles'])
    for row in [*ablation,*main]:
        assert int(row['native_cycles'])>0 and int(row['budget_cap'])==256
        assert int(row['native_evaluated'])==int(row['native_replayed'])+int(row['certified_scheduler_rejected'])
        assert int(row['numeric_validated'])==int(row['native_replayed'])>0
    for w in workloads:
        values=[int(next(r for r in ablation if r['workload']==w and r['stage']==s)['native_cycles']) for s in stages]
        assert all(b-a<=1 for a,b in zip(values,values[1:])), 'Unreported cumulative regression: '+w
    for row in main:
        source=protocol['seq25_search_source_commit'] if row['method']=='sequential25' else protocol['base_search_source_commit']
        assert row['source_commit']==source and int(row['objective_calls'])==256
        joint=int(next(r for r in main if r['workload']==row['workload'] and r['method']=='joint')['native_cycles'])
        assert math.isclose(float(row['method_cycles_over_ORBIT_cycles']),int(row['native_cycles'])/joint,rel_tol=1e-14)
    return protocol,ablation,main


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--snapshot',type=Path,default=DEFAULT)
    parser.add_argument('--check',action='store_true')
    args=parser.parse_args();protocol,ablation,rows=load(args.snapshot.resolve())
    if args.check:
        print('PASS: 24 ablation cells, 16 main cells, source/budget/native outcomes and all package hashes')
        return
    print('Native cycles; ORBIT is the same paid Full256 unit as the last ablation stage.')
    print('Program  ORBIT  Seq25  Seq50  Seq75')
    for w in protocol['active_workloads']:
        print(w.upper(),*(next(r['native_cycles'] for r in rows if r['workload']==w and r['method']==m) for m in protocol['methods']))
    print('Geomean cycles / ORBIT (lower better):')
    for m in protocol['methods']:
        values=[float(r['method_cycles_over_ORBIT_cycles']) for r in rows if r['method']==m]
        print(m,format(math.exp(sum(map(math.log,values))/len(values)),'.6f'))


if __name__=='__main__':main()
