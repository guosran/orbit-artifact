#!/usr/bin/env python3
"""Export reviewable profiling evidence; omit large input BOs/build caches.

The full local result tree is preserved. This only copies explicit evidence and
provides a portable hash/raw-output verifier, without importing a runtime.
"""
import argparse
import gzip
import hashlib
import json
from pathlib import Path
import re
import shutil


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(path, value):
    path.write_text(json.dumps(value, indent=2, allow_nan=False)+'\n')


def metrics(actual, reference):
    import numpy as np
    finite = bool(np.isfinite(actual).all() and np.isfinite(reference).all())
    compatible = actual.shape==reference.shape and actual.dtype==reference.dtype==np.float32
    delta = abs(actual.astype(np.float64)-reference.astype(np.float64)) if compatible and finite else None
    mask = abs(reference)>=1e-6
    return dict(passed=compatible and finite and bool(np.allclose(actual, reference, atol=1e-5, rtol=1e-5)),
        finite=finite, shape=list(actual.shape), max_abs=float(delta.max()) if delta is not None else None,
        max_relative_at_reference_ge_1e_minus6=float((delta[mask]/abs(reference[mask])).max()) if delta is not None and mask.any() else None,
        near_zero_max_abs=float(delta[~mask].max()) if delta is not None and (~mask).any() else None)


def verify(directory):
    import numpy as np
    manifest = json.loads((directory/'manifest.json').read_text())
    for row in manifest['files']:
        p = directory/row['path']
        if p.stat().st_size!=row['bytes'] or sha(p)!=row['sha256']:
            raise ValueError('published file changed: '+str(p))
        if row.get('compression')=='gzip':
            raw=gzip.decompress(p.read_bytes())
            if len(raw)!=row['original_bytes'] or hashlib.sha256(raw).hexdigest()!=row['original_sha256']:
                raise ValueError('decompressed acquisition bytes differ: '+str(p))
    checks = []
    for row in manifest['numeric_pairs']:
        with np.load(directory/row['actual']) as actual, np.load(directory/row['reference']) as reference:
            if set(actual.files)!=set(reference.files):
                raise ValueError('output/reference names differ')
            computed = {key:metrics(actual[key], reference[key]) for key in actual.files}
        if computed!=row['metrics']:
            raise ValueError('raw numeric recheck differs: '+row['actual'])
        checks.append(dict(actual=row['actual'], accepted=all(v['passed'] for v in computed.values())))
    return dict(status='passed', files_checked=len(manifest['files']), numeric_pairs_checked=len(checks),
        accepted_output_files=sum(c['accepted'] for c in checks),
        preserved_failing_output_files=sum(not c['accepted'] for c in checks),
        scope='SHA/size and independent raw FP32 output/reference checks only; input BOs and full local caches intentionally omitted; no NPU execution')


def export(results, audits, original, out, extra):
    import numpy as np
    out.mkdir(parents=True, exist_ok=False)
    files = {}

    def copy(path, destination):
        if not path.is_file():
            return
        destination = out/destination
        if destination in files or destination.with_name(destination.name+'.gz') in files:
            return
        destination.parent.mkdir(parents=True, exist_ok=True)
        record=dict(source=str(path.resolve()))
        if path.suffix in {'.json','.mlir','.ll','.log','.txt','.patch','.stdout','.stderr'} and path.stat().st_size>131072:
            record.update(compression='gzip', original_sha256=sha(path), original_bytes=path.stat().st_size,
                          uncompressed_path=str(destination.relative_to(out)))
            destination=destination.with_name(destination.name+'.gz')
            destination.write_bytes(gzip.compress(path.read_bytes(),mtime=0))
        else:
            shutil.copy2(path, destination)
        files[destination] = dict(record,path=str(destination.relative_to(out)),
            bytes=destination.stat().st_size, sha256=sha(destination))

    def tree(source, prefix, predicate):
        if source.is_dir():
            for path in sorted(source.rglob('*')):
                if path.is_file() and predicate(path, path.relative_to(source)):
                    copy(path, Path(prefix)/path.relative_to(source))

    text = {'.json', '.md', '.py', '.sh', '.log', '.txt', '.sha256', '.patch', '.stdout', '.stderr'}
    for path in sorted(results.iterdir()):
        if path.is_file() and path.suffix in text:
            copy(path, Path('results')/path.name)
        elif path.is_dir() and path.name.startswith('profile-'):
            tree(path, Path('results')/path.name, lambda p,r:
                 p.suffix in text or (p.suffix=='.npz' and not p.name.endswith('-inputs.npz')))
        elif path.is_dir() and (path.name.startswith(('joint-', 'feedback-', 'mixed-code', 'mixed-full-code', 'mixed-m1-gate-'))
                               or path.name in ('frozen-model-r1', 'stream-guard-r1')):
            tree(path, Path('results')/path.name, lambda p,r:
                 'hardware' not in r.parts and 'air_project' not in r.parts and p.suffix in text | {'.mlir'})
    # Main compiler/plan/AIR/final AIE/LLVM/ELF witnesses. Other complete compiler
    # caches stay local; compile commands and fixture generators reproduce them.
    packages = ['baseline/m8/full', 'mixed-full-r1/m8', 'mixed-m128-r1/native-plan',
                'mixed-m128-r1/hardware', 'mixed-m8-stages-r1']
    compiled = results/'joint-implementation-compiled-r1'
    if compiled.is_dir():
        packages += [str(p.relative_to(results)) for p in sorted(compiled.iterdir()) if p.is_dir()]
    for name in packages:
        tree(results/name, Path('results')/name, lambda p,r:
            (p.suffix in text | {'.mlir', '.ll', '.elf'} or
             p.name=='reference.npz' or (p.name.startswith('outputs-') and p.suffix=='.npz')) and
            'inputs.npz'!=p.name and
            (not any(x in r.parts for x in ('air_project',)) or
             p.name in ('npu.input.air.mlir', 'aie.mlir', 'aiectrl.mlir') or
             p.name.startswith('peano-opted_') or p.suffix=='.elf'))
    # Complete bounded baseline trace and partial optimized trace both survive.
    for name in ('packet-trace-marked-r1', 'packet-trace-marked-r2', 'packet-trace-mixed-r1'):
        tree(results/name, Path('results')/name, lambda p,r:
             'air_project' not in r.parts and p.suffix in text | {'.npy', '.mlir'})
    tree(audits, 'audits', lambda p,r: p.suffix in text)
    if original:
        tree(original, 'original-m128', lambda p,r:
             (p.suffix in text | {'.mlir', '.elf'} or p.name in ('outputs-0.npz','reference.npz')) and 'air_project' not in r.parts)
    for index, path in enumerate(extra):
        prefix=Path('checks')/(str(index)+'-'+path.name)
        if path.is_file():
            copy(path,prefix)
        else:
            tree(path, prefix, lambda p,r:
                 p.suffix in text and 'build' not in r.parts and '__pycache__' not in r.parts)
    numeric = []
    for destination in list(files):
        if destination.suffix!='.npz':
            continue
        match = re.fullmatch(r'(.+)-(\d+)\.npz', destination.name)
        if match:
            reference = destination.with_name(match[1]+'-reference.npz')
            if destination.name.startswith('outputs-'):
                reference = destination.with_name('reference.npz')
            if reference in files:
                with np.load(destination) as actual, np.load(reference) as ref:
                    data = {key:metrics(actual[key], ref[key]) for key in actual.files}
                numeric.append(dict(actual=str(destination.relative_to(out)),
                    reference=str(reference.relative_to(out)), metrics=data))
    copy(Path(__file__), Path('export-source.py'))
    save(out/'manifest.json', dict(schema='orbit.ffn.profile.evidence.v9',
        files=sorted(files.values(), key=lambda row:row['path']), numeric_pairs=numeric,
        omissions='large generated input/weight BOs, compiler builds and most redundant intermediate caches; full local evidence retained unchanged',
        numeric_contract='finite FP32 atol=rtol=1e-5; preserved negative controls are explicitly failing pairs, not acceptance'))
    (out/'README.md').write_text('''# FFN profiling v9 evidence

These are byte-preserving copies of API samples, source/plan/compiler witnesses,
model/search/checkpoint reports, output/reference arrays and trace windows.
`manifest.json` binds their original paths, sizes and SHA256s. Large text files
are losslessly gzip-compressed, with original and compressed byte hashes checked.
Large generated
input/weight BOs and build caches remain in the complete local results and are
recreated by the profiling/optimization entries. Git does not contain those full
caches. Absolute acquisition paths inside old reports remain historical facts.

Verify without importing a runtime or opening the NPU:

```sh
python ../../scripts/export_ffn_profile_evidence_v9.py --verify .
python ../../scripts/export_ffn_profile_evidence_v9.py --unpack . --output /tmp/orbit-v9-evidence-NEW
```

Verification includes intentionally failing historical control outputs: it
requires their saved classifications and bytes to remain unchanged. This does
not turn them into accepted implementations. The original marked baseline trace
has a valid one-core compute bracket; the optimized trace lacks its end marker
and is partial. No trace supplies physical DDR traffic or whole-FFN cycle counts.
''')
    return verify(out)


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--results', type=Path)
    p.add_argument('--audits', type=Path)
    p.add_argument('--original-m128', type=Path)
    p.add_argument('--extra-check', action='append', type=Path, default=[])
    p.add_argument('--output', type=Path)
    p.add_argument('--verify', type=Path)
    p.add_argument('--unpack', type=Path, help='verify then restore original bytes into new --output')
    a = p.parse_args()
    if a.unpack:
        if not a.output:p.error('--unpack requires a new --output directory')
        source=a.unpack.resolve();result=verify(source)
        a.output.mkdir(parents=True,exist_ok=False)
        for row in json.loads((source/'manifest.json').read_text())['files']:
            destination=a.output/row.get('uncompressed_path',row['path'])
            destination.parent.mkdir(parents=True,exist_ok=True)
            raw=(source/row['path']).read_bytes()
            destination.write_bytes(gzip.decompress(raw) if row.get('compression')=='gzip' else raw)
        result['restored_original_bytes']=True
        save(a.output/'unpack-verification.json',result)
    elif a.verify:
        result = verify(a.verify.resolve())
    else:
        if not all((a.results, a.audits, a.output)):
            p.error('export requires --results, --audits and --output')
        result = export(a.results.resolve(), a.audits.resolve(),
                        a.original_m128.resolve() if a.original_m128 else None,
                        a.output.resolve(), [x.resolve() for x in a.extra_check])
        save(a.output/'verification.json', result)
    print(json.dumps(result))


if __name__=='__main__':
    main()
