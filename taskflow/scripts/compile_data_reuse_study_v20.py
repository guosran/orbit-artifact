#!/usr/bin/env python3
"""Select evidence coverage from checked C++ archives and compile unchanged sources."""
import argparse
import json
from pathlib import Path
import subprocess
import sys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--comparison', type=Path, required=True)
    parser.add_argument('--air-tool', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--case', type=int, choices=[0, 1], required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=False)
    entries, aliases, available = [], {}, []
    case = args.comparison/f'case-{args.case}'
    kind = ['interleaved', 'shared-input'][args.case]
    fixture = args.comparison.parent/f'fixture-{kind}-r1'

    def add(label, entry):
        name = next((item['name'] for item in entries
                     if item['source_sha256'] == entry['source_sha256']), None)
        if name is None:
            name = label
            entries.append(dict(entry, name=name, plain_fixture=str(fixture.resolve())))
        aliases[label] = name

    for policy in ['v19-contiguous', 'fixed-tiling', 'reuse-then-tiling', 'data-reuse-joint']:
        directory = case/policy
        search = directory/'search'
        report = json.loads((search/'search.json').read_text())
        candidates = []
        for row in report['archive']:
            if row['status'] != 'passed':
                continue
            folder = search/'candidates'/row['search_key']
            result = json.loads((folder/'mapping-result.json').read_text())
            plan = result['best_plan']
            candidate = dict(source=str((folder/'taskflow.mlir').resolve()),
                source_sha256=row['search_key'], config=str((directory/'config.json').resolve()),
                graph_file=str((folder/'program-graph.json').resolve()),
                mapping_result=str((folder/'mapping-result.json').resolve()),
                action_chain=row['action_chain'], estimated_ms=row['score'], plan=plan)
            candidates.append(candidate)
            available.append(candidate)
            if row['round'] == 0:
                add('baseline', candidate)
        add(policy, min(candidates, key=lambda item: (item['estimated_ms'], item['source_sha256'])))
    if args.case == 0:
        # Mechanism representatives are already generated/checked search plans;
        # these predicates select coverage, never manufacture a group or score.
        partial = [item for item in available if len(item['plan']['residency_scopes']) == 1
                   and item['plan']['residency_scopes'][0]['boundary_exports']
                   and any(right > left+1 for left, right in zip(
                       item['plan']['residency_scopes'][0]['tasks'],
                       item['plan']['residency_scopes'][0]['tasks'][1:]))
                   and len(item['plan']['residency_scopes'][0]['tasks']) == 2]
        add('partial-consumer-boundary', min(partial, key=lambda item: (item['estimated_ms'], item['source_sha256'])))
        other = [item for item in available if len(item['plan']['residency_scopes']) == 1
                 and not item['plan']['residency_scopes'][0]['boundary_exports']
                 and len(item['plan']['residency_scopes'][0]['tasks']) == 2]
        add('independent-opportunity', min(other, key=lambda item: (item['estimated_ms'], item['source_sha256'])))
    for item in entries:
        del item['plan']
    index = args.output/'representatives.json'
    index.write_text(json.dumps(dict(entries=entries, policy_aliases=aliases), indent=2)+'\n')
    command = [sys.executable, str(Path(__file__).with_name('compile_subgraph_representatives_v19.py')),
        '--index', str(index.resolve()), '--plain-fixture', str(fixture.resolve()),
        '--tool', str(args.air_tool.resolve()), '--output', str((args.output/'compiled').resolve())]
    (args.output/'compile-command.json').write_text(json.dumps(command, indent=2)+'\n')
    subprocess.run(command, check=True)
    print(json.dumps(dict(status='PASS', case=args.case, packages=len(entries),
                          policy_aliases=aliases, device_submissions=0)))


if __name__ == '__main__':
    main()
