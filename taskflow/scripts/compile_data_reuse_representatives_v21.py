#!/usr/bin/env python3
"""Compile distinct selected C++ sources; alias identical actual implementations."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys


def read(path):
    return json.loads(Path(path).read_text())


def actual_signature(path):
    def clean(value):
        if isinstance(value, list):
            return [clean(item) for item in value]
        if isinstance(value, dict):
            return {key: clean(item) for key, item in value.items()
                    if key != 'proposed_bindings' and not key.startswith('orbit.')}
        return value
    operations = clean(read(path)['operations'])
    return hashlib.sha256(json.dumps(operations, sort_keys=True,
        separators=(',', ':')).encode()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--matrix', type=Path, action='append', required=True)
    parser.add_argument('--air-tool', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--include-reference', action='store_true')
    args = parser.parse_args()
    args.output = args.output.resolve()
    args.output.mkdir(parents=True, exist_ok=False)
    entries, aliases, sources = [], [], {}
    for matrix in args.matrix:
        index = read(matrix/'index.json')
        for record in index['runs']:
            condition = record['condition']
            if condition.get('historical'):
                continue
            kind = condition['budget_kind']
            selected = ((kind == 'raw-complete-cost-provider-calls')
                        or (kind == 'wall-time-ms')
                        or (args.include_reference and kind == 'offline-reference'))
            if not selected:
                continue
            search = Path(record['search_directory'])
            report = read(search/'search.json')
            program = condition['program']
            rows = {row['search_key']: row for row in report['archive']}
            baseline = next(row for row in rows.values() if not row['parent'])
            choices = [('baseline', baseline)]
            if report['ranking']:
                choices.append((condition['strategy']+'-'+condition['tile_generator']+'-'+kind+'-'+str(condition['budget']),
                                rows[report['ranking'][0]]))
            for label, row in choices:
                if row['status'] != 'passed':
                    continue
                key = program, row['search_key']
                if key not in sources:
                    name = program+'-'+row['search_key'][:12]
                    sources[key] = name
                    folder = search/'candidates'/row['search_key']
                    fixture = matrix.parent/f'fixture-{program}-r1'
                    if not fixture.exists():
                        fixture = Path('/home/shiran/project/orbit-artifact/results/taskflow/data-reuse-v21')/f'fixture-{program}-r1'
                    entries.append(dict(name=name, program=program,
                        source=str((folder/'taskflow.mlir').resolve()), source_sha256=row['search_key'],
                        config=str((search.parent/'config.json').resolve()),
                        mapping_result=str((folder/'mapping-result.json').resolve()),
                        graph_file=str((folder/'program-graph.json').resolve()),
                        action_chain=row['action_chain'], estimated_ms=row['score'],
                        plain_fixture=str(fixture.resolve())))
                aliases.append(dict(program=program, label=label, condition=condition,
                                    candidate_id=row['search_key'], package=sources[key]))
    assert entries, 'no priced selected candidate sources found'
    representatives = args.output/'representatives.json'
    representatives.write_text(json.dumps(dict(entries=entries, aliases=aliases), indent=2)+'\n')
    command = [sys.executable, str(Path(__file__).with_name('compile_subgraph_representatives_v19.py')),
        '--index', str(representatives), '--plain-fixture', entries[0]['plain_fixture'],
        '--tool', str(args.air_tool.resolve()), '--output', str(args.output/'compiled')]
    (args.output/'compile-command.json').write_text(json.dumps(command, indent=2)+'\n')
    subprocess.run(command, check=True)
    compiled = read(args.output/'compiled/index.json')
    by_name = {entry['name']: entry for entry in entries}
    unique, signatures, alias_names = [], {}, {}
    for case in compiled['cases']:
        entry = by_name[case['id']]
        signature = actual_signature(Path(case['compiled'])/'implementation-facts.json')
        key = entry['program'], signature
        if key not in signatures:
            signatures[key] = case['id']
            unique.append(dict(case, program=entry['program'], actual_structure_sha256=signature))
        alias_names[case['id']] = signatures[key]
    for alias in aliases:
        alias['actual_package'] = alias_names[alias['package']]
    (args.output/'unique-implementations.json').write_text(json.dumps(dict(
        status='PASS', compiled_packages=len(compiled['cases']), cases=unique,
        aliases=aliases, device_submissions=0,
        signature_scope='Same arithmetic program, actual final-AIE operations/SSA/regions/operands/properties; proposed bindings and orbit attributes excluded. Distinct source labels never measured separately when this actual structure matches.'), indent=2)+'\n')
    print(json.dumps(dict(status='PASS', compiled=len(compiled['cases']),
                          actual_unique=len(unique), device_submissions=0)))


if __name__ == '__main__':
    main()
