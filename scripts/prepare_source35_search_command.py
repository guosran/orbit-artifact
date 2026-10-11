#!/usr/bin/env python3
"""Prepare a fresh portable C++ search command; never run or resume a search."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

from show_source35_snapshot import ROOT,DEFAULT,load


def sha(path):
    with Path(path).open('rb') as stream:return hashlib.file_digest(stream,'sha256').hexdigest()


def write(path,value):
    with path.open('x') as stream:json.dump(value,stream,indent=2);stream.write('\n')


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--workload',choices=['radar','lu','llama','harris'],required=True)
    parser.add_argument('--kind',choices=['ablation','main'],required=True)
    parser.add_argument('--stage',choices=['fixed','shape','replica','tiling','fusion','fission'])
    parser.add_argument('--method',choices=['joint','sequential25','sequential50','sequential75'])
    parser.add_argument('--source-root',type=Path,required=True)
    parser.add_argument('--optimizer',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args();load(DEFAULT)
    records=json.loads((DEFAULT/'templates/search-commands.json').read_text())['commands']
    found=[r for r in records if r['kind']==args.kind and r['workload']==args.workload and
        (r.get('stage')==args.stage if args.kind=='ablation' else r.get('method')==args.method)]
    if len(found)!=1:parser.error('Select exactly a stage for ablation or a method for main')
    record=found[0]
    if record.get('whole_paid_unit_reuse'):
        parser.error('Joint references the complete paid fission unit; prepare --kind ablation --stage fission once')
    source=args.source_root.resolve();optimizer=args.optimizer.resolve();output=args.output.resolve()
    commit=subprocess.check_output(['git','-C',str(source),'rev-parse','HEAD'],text=True).strip()
    if commit!=record['captured_source_commit']:raise ValueError('Wrong pinned compiler source commit')
    if subprocess.check_output(['git','-C',str(source),'status','--porcelain'],text=True).strip():raise ValueError('Use a clean pinned source checkout')
    if not optimizer.is_file():raise ValueError('Optimizer does not exist')
    if output.exists():raise ValueError('Use a fresh output path; no implicit rerun/resume')
    contract=json.loads((DEFAULT/f"templates/{record['source_group']}-source-contract.json").read_text())
    for relative,digest in contract['source_sha256'].items():
        if sha(source/relative)!=digest:raise ValueError('Pinned compiler source differs: '+relative)
    # The rebuilt optimizer gets a fresh contract. Captured binary hashes
    # remain historical measurements, not a requirement on a new build.
    substitutions={'${ARTIFACT_ROOT}':str(ROOT),'${ORBIT_SOURCE}':str(source),
        '${ORBIT_OPTIMIZER}':str(optimizer),'${RUN_ROOT}':str(output),'${INPUT_ROOT}':str(output/'inputs')}
    def expand(value):
        text=json.dumps(value)
        for token,replacement in substitutions.items():text=text.replace(token,replacement)
        if '${' in text:raise ValueError('Unexpanded template token')
        return json.loads(text)
    contract=expand(contract);contract['optimizer_sha256']=sha(optimizer)
    case=json.loads((DEFAULT/'inputs'/args.workload/'case.json').read_text())
    # Only embedded provenance paths change. Original snapshot bytes stay
    # hash-bound; the fresh canonical/program contract records the new paths.
    input_bytes={}
    for name in ['canonical.mlir','prepared-source.mlir']:
        text=(DEFAULT/'inputs'/args.workload/name).read_text()
        old_artifact='/home/shiran/project/orbit-artifact/'
        old_prepared='/home/shiran/project/orbit-repair-study/full_prepared-v4/'+args.workload+'/taskflow-affine.mlir'
        # Check the captured bytes before rebasing: the new checkout may itself
        # live below /home/shiran, so checking that prefix afterward is wrong.
        if '/home/shiran/' in text.replace(old_artifact,'').replace(old_prepared,''):
            raise ValueError('Unknown historical input path needs explicit rebasing')
        text=text.replace(old_artifact,str(ROOT)+'/')
        text=text.replace(old_prepared,str(output/'inputs/prepared-source.mlir'))
        input_bytes[name]=text
    output.mkdir(parents=True);(output/'inputs').mkdir()
    for name,text in input_bytes.items():(output/'inputs'/name).write_text(text)
    case.update(canonical=str(output/'inputs/canonical.mlir'),prepared_source=str(output/'inputs/prepared-source.mlir'))
    write(output/'inputs/case.json',case);write(output/'source-contract.json',contract)
    write(output/'protocol.json',expand(record['protocol']))
    write(output/'command.json',dict(argv=expand(record['command']),cwd=str(ROOT),source_commit=commit,
        optimizer_sha256=sha(optimizer),execution_started=False,objective_budget_cap=256,
        timeout_seconds=21600,source_contract=str(output/'source-contract.json'),
        input_sha256={str(p):sha(p) for p in [output/'inputs/canonical.mlir',output/'inputs/prepared-source.mlir',output/'source-contract.json',output/'protocol.json']}))
    print(output/'command.json')


if __name__=='__main__':main()
