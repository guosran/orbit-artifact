#!/usr/bin/env python3
"""Curate immutable v10 evidence and verify it offline without original paths.

Export performs only file/git reads and writes a NEW evidence directory. It never
imports a runtime, plans, compiles, scores candidates, fits, or opens a device.
Large text is losslessly gzip encoded; original and copied byte hashes are kept.
"""
import argparse,gzip,hashlib,json,os,re,shutil,subprocess
from datetime import datetime,timezone
from pathlib import Path

TEXT={'.json','.jsonl','.md','.py','.sh','.log','.txt','.sha256','.patch','.stdout','.stderr','.mlir','.ll','.script','.h','.cpp'}
LIMIT=100_000_000


def sha(path):
    h=hashlib.sha256()
    with Path(path).open('rb') as stream:
        for chunk in iter(lambda:stream.read(1024*1024),b''):h.update(chunk)
    return h.hexdigest()


def load(path):return json.loads(Path(path).read_text())
def save(path,value):Path(path).write_text(json.dumps(value,indent=2,sort_keys=True,allow_nan=False)+'\n')


def metrics(actual,reference):
    import numpy as np
    if actual.shape!=reference.shape or actual.dtype!=np.float32 or reference.dtype!=np.float32:
        raise ValueError('raw output/reference shape or FP32 dtype differs')
    finite=bool(np.isfinite(actual).all() and np.isfinite(reference).all())
    if not finite:return dict(passed=False,finite=False)
    delta=np.abs(actual.astype(np.float64)-reference.astype(np.float64));normal=np.abs(reference)>=1e-6
    return dict(passed=bool(np.allclose(actual,reference,atol=1e-5,rtol=1e-5)),finite=True,shape=list(actual.shape),max_abs=float(delta.max()),
        normalized_l2=float(np.linalg.norm(delta)/max(np.linalg.norm(reference.astype(np.float64)),1e-30)),
        max_relative_reference_ge_1e_minus6=float((delta[normal]/np.abs(reference[normal])).max()) if normal.any() else None,
        near_zero_max_abs=float(delta[~normal].max()) if (~normal).any() else None)


def safe_path(directory,relative):
    path=directory/relative
    if Path(relative).is_absolute() or '..' in Path(relative).parts or not path.resolve().is_relative_to(directory.resolve()):
        raise ValueError('unsafe evidence-relative path')
    return path


def verify(directory):
    """Only package-relative files are opened; original acquisition paths unused."""
    import numpy as np
    manifest=load(directory/'manifest.json');paths=set();originals={}
    for row in manifest['files']:
        path=safe_path(directory,row['path'])
        if row['path'] in paths:raise ValueError('duplicate manifest path')
        paths.add(row['path'])
        if path.is_symlink() or path.stat().st_size!=row['bytes'] or sha(path)!=row['sha256']:
            raise ValueError('copied bytes changed: '+row['path'])
        if row.get('compression')=='gzip':
            raw=gzip.decompress(path.read_bytes())
            if len(raw)!=row['original_bytes'] or hashlib.sha256(raw).hexdigest()!=row['original_sha256']:
                raise ValueError('original acquisition bytes differ: '+row['path'])
        elif row.get('source') and (row['original_bytes']!=row['bytes'] or row['original_sha256']!=row['sha256']):
            raise ValueError('byte-preserving identity mismatch')
        if row.get('source'):originals[row['source']]=row['path']
    actual_paths={str(p.relative_to(directory)) for p in directory.rglob('*') if p.is_file()}
    if actual_paths-paths-{'manifest.json','verification.json'}:
        raise ValueError('unlisted files in evidence package')
    checks=[]
    for row in manifest['numeric_pairs']:
        with np.load(safe_path(directory,row['actual'])) as actual,np.load(safe_path(directory,row['reference'])) as reference:
            if set(actual.files)!=set(reference.files):raise ValueError('raw output key mismatch')
            observed={key:metrics(actual[key],reference[key]) for key in actual.files}
        if observed!=row['metrics'] or not all(x['passed'] for x in observed.values()):
            raise ValueError('raw numerical recheck failed: '+row['actual'])
        checks.append(row['profile'])
    coverage={name:checks.count(name) for name in sorted(set(checks))}
    if coverage!=manifest['expected_raw_output_files']:
        raise ValueError('raw acquisition coverage mismatch')
    if len(checks)!=474 or manifest['compiled_packages']!=24:
        raise ValueError('required evidence coverage incomplete')
    return dict(status='passed',files_checked=len(paths),copied_bytes=sum(r['bytes'] for r in manifest['files']),
        original_bytes=sum(r.get('original_bytes',r['bytes']) for r in manifest['files']),compiled_packages=24,
        raw_output_files_checked=len(checks),raw_output_coverage=coverage,source_mappings=len(originals),
        maximum_file_bytes=max(r['bytes'] for r in manifest['files']),original_absolute_paths_opened=False,
        scope='Offline copied/decompressed SHA+size and all474 independent finite FP32 output/reference checks; no original paths, runtime, compiler or device required')


class Exporter:
    def __init__(self,results,out,artifact,core):
        out.mkdir(parents=True,exist_ok=False)
        self.results,self.out,self.artifact,self.core=results,out,artifact,core
        self.files={};self.sources={};self.omissions=[];self.numeric=[];self.packages=[]

    def destination(self,path):
        path=path.absolute()
        for root,prefix in [(self.results,'results'),(self.artifact/'.work/implementation-search-v10','reviews'),(self.artifact,'artifact-source'),(self.core,'core-source')]:
            if path.is_relative_to(root):return Path(prefix)/path.relative_to(root)
        return Path('external-source')/(hashlib.sha256(str(path).encode()).hexdigest()[:12]+'-'+path.name)

    def omit(self,path,reason,known_sha=None):
        if not path.is_file():return
        self.omissions.append(dict(source=str(path.absolute()),bytes=path.stat().st_size,known_original_sha256=known_sha,reason=reason))

    def copy(self,path,destination=None):
        path=Path(path).absolute()
        if not path.is_file():raise FileNotFoundError(path)
        source=str(path)
        if source in self.sources:return self.sources[source]
        if path.stat().st_size>=LIMIT:
            raise ValueError('selected file exceeds100MB: '+source)
        rel=Path(destination) if destination else self.destination(path)
        if rel.suffix in TEXT and path.stat().st_size>262144:rel=rel.with_name(rel.name+'.gz');compression='gzip'
        else:compression=None
        target=safe_path(self.out,str(rel));target.parent.mkdir(parents=True,exist_ok=True)
        digest=sha(path);size=path.stat().st_size
        if compression:target.write_bytes(gzip.compress(path.read_bytes(),mtime=0))
        else:shutil.copy2(path,target)
        if sha(path)!=digest:raise ValueError('source changed during export: '+source)
        if str(rel) in self.files:raise ValueError('destination collision: '+str(rel))
        self.files[str(rel)]=dict(path=str(rel),source=source,original_sha256=digest,original_bytes=size,
            sha256=sha(target),bytes=target.stat().st_size,**({'compression':compression} if compression else {}))
        self.sources[source]=str(rel);return str(rel)

    def generated(self,relative,value):
        path=safe_path(self.out,relative);path.parent.mkdir(parents=True,exist_ok=True)
        if isinstance(value,str):path.write_text(value)
        else:save(path,value)
        self.files[relative]=dict(path=relative,sha256=sha(path),bytes=path.stat().st_size,scope='export-time generated index; not a rewritten acquisition file')

    def tree(self,path,predicate=lambda p,r:True):
        for file in sorted(path.rglob('*')):
            if file.is_file() and predicate(file,file.relative_to(path)):self.copy(file)

    def top(self,path):
        for file in sorted(path.iterdir()):
            if file.is_file() and file.suffix in TEXT:self.copy(file)

    def bound_references(self,value):
        if isinstance(value,dict):
            if set(['path','sha256'])<=set(value) and isinstance(value['path'],str):
                path=Path(value['path'])
                if path.is_file() and path.suffix in TEXT|{'.npz','.elf'} and path.stat().st_size<LIMIT:
                    if sha(path)!=value['sha256']:raise ValueError('bound dependency differs: '+str(path))
                    self.copy(path)
            for item in value.values():self.bound_references(item)
        elif isinstance(value,list):
            for item in value:self.bound_references(item)

    def package(self,path):
        self.packages.append(str(path))
        def choose(file,rel):
            if 'air_project' not in rel.parts:return file.suffix in TEXT|{'.elf','.npz'} and file.name not in ('inputs.npz',) and not file.name.endswith('-inputs.npz')
            return (file.name in ['npu.input.air.mlir','aie.input.air.mlir','placed.input.air.mlir','full_elf_config.json'] or
                file.name.startswith('peano-opted_') and file.suffix=='.ll' or
                file.name.startswith('ldScripts_') and file.name.endswith('.ld.script') or
                file.suffix=='.elf' and any(part.startswith('elfs_') for part in rel.parts))
        self.tree(path,choose)

    def profile(self,relative,profile_name,expected):
        import numpy as np
        parent=self.results/relative;profile=parent/profile_name
        self.tree(parent,lambda p,r:'air_project' not in r.parts and p.suffix in TEXT|{'.npz'} and not p.name.endswith('-inputs.npz'))
        count=0
        for seed in sorted(profile.glob('seed-*')):
            provenance=load(seed/'input-identities.json')
            for name,identity in provenance.items():
                self.omit(seed/(name+'-inputs.npz'),'FFN input BO/weight copies omitted; see preserved input-identities.json and reproducible fixture',identity.get('inputs_sha256')) if relative=='representative-ffn-final-r1' else None
            result=load(seed/'result.json')
            for sample in result['samples']:
                actual=seed/(sample['candidate']+'-'+str(sample['repeat'])+'.npz');reference=seed/(sample['candidate']+'-reference.npz')
                with np.load(actual) as a,np.load(reference) as b:
                    if set(a.files)!=set(b.files):raise ValueError('raw keys differ')
                    values={key:metrics(a[key],b[key]) for key in a.files}
                self.numeric.append(dict(profile=profile_name,actual=self.copy(actual),reference=self.copy(reference),metrics=values))
                count+=1
        if count!=expected:raise ValueError('raw profile coverage differs '+profile_name)
        # Small GEMMscale per-case inputs are included too, so local audit data
        # can be reproduced completely. FFN weights remain explicit omissions.
        if relative!='representative-ffn-final-r1':
            self.tree(profile,lambda p,r:p.name.endswith('-inputs.npz'))
        runner=load(profile/'runner-identity.json')
        if Path(runner['path']).is_file():self.copy(Path(runner['path']))

    def repo_state(self,name,repo):
        def git(*args):return subprocess.check_output(['git','-C',str(repo),*args])
        head=git('rev-parse','HEAD').decode().strip();status=git('status','--porcelain=v1').decode()
        self.generated('repository-state/'+name+'-HEAD.txt',head+'\n')
        self.generated('repository-state/'+name+'-status.txt',status)
        self.generated('repository-state/'+name+'-tracked-worktree.patch',git('diff','--binary','HEAD').decode())
        candidates=git('ls-files','--modified','--others','--exclude-standard','-z').decode().split('\0');rows=[]
        for relative in sorted(set(candidates)):
            path=repo/relative
            if not relative or not path.is_file() or path.suffix not in TEXT:continue
            if any(part in ['evidence','results','.work','presentations'] for part in path.relative_to(repo).parts):continue
            rows.append(dict(path=relative,sha256=sha(path),bytes=path.stat().st_size,copy=self.copy(path)))
        self.generated('repository-state/'+name+'-worktree-manifest.json',dict(base_HEAD=head,files=rows,
            scope='Base commit plus tracked diff and listed modified/untracked source bytes; generated evidence/results/caches and presentations excluded. Frozen-r3 manifest separately identifies code corresponding to executed native binaries. A later commit receipt must be separate, not rewrite this identity.'))


def export(results,out,artifact,core):
    if out.exists():raise FileExistsError('output must be NEW: '+str(out))
    e=Exporter(results,out,artifact,core)
    e.copy(Path(__file__),Path("export-source.py"))
    # Current protocol and static-native design, including unchanged small inputs.
    e.tree(results/'preregistered-inputs-r6')
    e.tree(results/'design-final-r2')
    proposals=results/'proposals-final-r4';e.top(proposals)
    for program in ['m16-k128-n64','m32-k128-n64','m17-k129-n80']:
        root=proposals/program;e.top(root)
        for name in ['search.json','automatic-proposals.json']:
            if (root/'search'/name).exists():e.copy(root/'search'/name)
        if (root/'negative-replays').exists():e.tree(root/'negative-replays')
    for selected in load(proposals/'selected-cases.json'):
        e.bound_references(selected)
        candidate=Path(selected['source']['path']).parent
        for name in ['request.json','response.json','mapping-result.json']:
            if (candidate/name).exists():e.copy(candidate/name)
    # 18 accepted packages and four downstream native selected packages.
    for group in ['compiled-final-r3','native-selected-compiled-final-r1']:
        e.top(results/group)
        for package in load(results/group/'compiled-cases.json'):e.package(Path(package['compiled']))
        for path in sorted((results/group).glob('input-*/source.mlir')):e.copy(path)
    # Pure-model and prediction data plus all native search archives (not duplicate
    # checkpoints or the full redundant mapping cache for every explored row).
    for name in ['frozen-model-final-r1','predictions-final-r1','native-selection-final-r1','heldout-validation-final-r1','native-selected-validation-final-r1']:
        e.tree(results/name,lambda p,r:p.suffix in TEXT)
    for name in ['predictive-search-final-r1','search-controls-final-r1']:
        root=results/name;e.top(root)
        for path in root.rglob('*'):
            if not path.is_file():continue
            rel=path.relative_to(root)
            if 'candidates' not in rel.parts and path.name not in ['checkpoint.json'] and path.suffix in TEXT:e.copy(path)
    for selected in load(results/'native-selection-final-r1/selected-cases.json'):e.bound_references(selected)
    for row in load(results/'predictions-final-r1/predictions.json'):e.bound_references(row)
    for relative,profile,count in [('train-final-r1','profile-train',252),('holdout-final-r1','profile-holdout',126),('native-selected-profile-final-r1','profile-selected',84),('representative-ffn-final-r1','profile-full-m5',12)]:
        if relative=='representative-ffn-final-r1':
            # Profile metadata only here; package evidence separately avoids weights.
            e.top(results/relative)
            e.tree(results/relative/'independent-audit',lambda p,r:p.suffix in TEXT)
            # profile() sees parent package dirs but rejects their large input BOs.
        e.profile(relative,profile,count)
    # Complete FFN main packages; no subkernel stand-in or model-domain claim.
    for name in ['baseline','lifted']:e.package(results/'representative-ffn-final-r1'/name)
    ffn=results/'representative-ffn-inputs-r1'
    e.tree(ffn,lambda p,r:p.name not in ['inputs-11.npz','inputs-23.npz','inputs-47.npz'])
    for seed in [11,23,47]:
        profile=results/'representative-ffn-final-r1/profile-full-m5'/('seed-'+str(seed))
        # Profiler seed directories use seed-0/1/2 rather than seed values; take
        # acquisition hashes from all recorded input-identities instead.
        known=[]
        for path in (results/'representative-ffn-final-r1/profile-full-m5').glob('seed-*/input-identities.json'):
            for value in load(path).values():
                if Path(value.get('inputs_path','')).name==f'inputs-{seed}.npz':known.append(value['inputs_sha256'])
        e.omit(ffn/f'inputs-{seed}.npz','Large full FFN input weights omitted; regenerate with preserved fixture generator/source/command/seeds',known[0] if known else None)
    # CPU summaries/commands and boundary regressions; deliberately omit builds.
    for name in ['clean-shell-cpu-final-r1','full-regressions-r6','automatic-search-cpu-r2','tail-channel-scope-cpu-r1','cpu-transit-final-r1','memory-binding-air-r3','physical-storage-final-r1','final-tool-bridge-r1']:
        root=results/name
        if not root.exists():continue
        e.tree(root,lambda p,r:p.suffix in TEXT and (len(r.parts)==1 or p.name in ['summary.json','result.json','scope.json','tool-identities.json','report.json'] or p.name.endswith('.command.json')) and not any(x in r.parts for x in ['build','air_project','candidates']))
    for path in results.iterdir():
        if path.is_file() and path.suffix in TEXT:e.copy(path)
    # Frozen native source identities, but not distributed executable tools.
    e.tree(results/'frozen-tools-r3',lambda p,r:'source' in r.parts or p.suffix in TEXT)
    for name in ['taskflow-opt-core','taskflow-opt-air']:e.omit(results/'frozen-tools-r3'/name,'Frozen executable omitted; tool-identities.json and exact frozen source manifest preserved',sha(results/'frozen-tools-r3'/name))
    e.omit(proposals/'frozen-tools/taskflow-opt','Frozen executable omitted; proposals tool SHA preserved',sha(proposals/'frozen-tools/taskflow-opt'))
    # Preserve minimal historical tail failures, original false-positive checker,
    # CPU negatives, fixed checker source and the fresh corrected audits.
    for group in ['compiled-final-r1','compiled-final-r2']:
        for path in (results/group).glob('holdout-m17-*'):
            if path.is_dir():
                e.tree(path,lambda p,r:p.suffix in TEXT and ('air_project' not in r.parts or p.name in ['aie.input.air.mlir','npu.input.air.mlir']))
        e.top(results/group)
    for group in ['proposals-final-r1','proposals-final-r2']:
        for name in ['coverage.json','proposal.json']:
            path=results/group/name
            if path.exists():e.copy(path)
    reviews=artifact/'.work/implementation-search-v10'
    for name in ['channel-port-verifier-fix-r1','closure-cpu-r4','closure-final-identities-r1','closure-orchestrator-preserved-r1','design-validation-review-r2','storage-path-review-r2','compile-partial-review-r1','representative-ffn-independent-review-r1','coverage-review-final-r1']:
        path=reviews/name
        if path.exists():e.tree(path,lambda p,r:p.suffix in TEXT)
    # Delivery source/dependencies (not production-generated candidate changes).
    for path in (artifact/'taskflow/scripts').glob('*v10*'):
        if path.is_file():e.copy(path)
    for path in (artifact/'taskflow/test/TaskflowAIR').glob('*v10*'):
        if path.is_file():e.copy(path)
    for name in ['audit_channel_ports_v6.py','audit_storage_v6.py','audit_runtime_transfers_v7.py','audit_profile_v9.py','prepare_v6.py','prepare_program_mapping_v7.py','prepare_ffn_stages_v7.py','prepare_inputs.py']:
        path=artifact/'taskflow/test/TaskflowAIR'/name
        if path.exists():e.copy(path)
    for name in ['taskflow_ffn_profile.py','taskflow_direct_air_execute.py','run_taskflow_direct_air_v6_case.sh','fit_direct_air_cost_v9.py','taskflow_profiled_search_v9.py','collect_direct_air_feedback_v9.py','taskflow_paths.sh']:
        path=artifact/'taskflow/scripts'/name
        if path.exists():e.copy(path)
    for path in (artifact/'taskflow/test/TaskflowAIR/fixtures').glob('*v10*'):e.copy(path)
    e.copy(Path(__file__),Path('export-source.py'))
    e.repo_state('core',core);e.repo_state('artifact',artifact)
    # The frozen manifests bind more small script/native dependencies. Copy all
    # already-declared small files without following arbitrary directories.
    for name in ['freeze.json','training-label-manifest.json']:
        e.bound_references(load(results/'frozen-model-final-r1'/name))
    e.generated('EXCLUSIONS.json',dict(files=e.omissions,policies=[
        'No full FFN input/weight BO copies; original input SHA/source/generator/seeds/references retained.',
        'No executable frozen taskflow-opt builds; exact executable SHA and frozen-r3 source manifest retained.',
        'No compiler object/CDO/PDI/bin caches, probe duplicates or duplicate search checkpoints.',
        'No complete historical failed repetitions: two tail minima, old checker bytes/logs and corrected audits retained.',
        'All original raw files stay in the full local results tree unchanged; original absolute paths remain acquisition facts.']))
    e.generated('README.md','''# Implementation search v10 evidence

This is a curated, byte-bound copy of the original local v10 experiment. The
manifest maps original acquisition paths/SHA256/size to repository-relative
copies. Large text is losslessly gzip encoded with both byte identities. Original
paths inside reports are unchanged historical facts. The verifier never opens
those original paths. Every one of the 474 output NPZs is checked against its
included independent FP32 reference at the unchanged atol=rtol=1e-5.

Verify offline (NumPy is the only non-stdlib dependency):

```sh
python export-source.py --verify .
```

The curated compiler witnesses contain all 24 complete program packages: 18
registered candidates, four native selected/control/exploration packages, and two
full M5 FFN packages. Search archives preserve native ranking/actions/parents and
uncalibrated reasons. Unpriced exploration remains separate from model winners.
No model parameters are changed by this export or verification.

`EXCLUSIONS.json` explicitly records omitted large FFN input/weight BOs and frozen
executables. Sources, seed/reference data, input SHA and commands make regeneration
reviewable; compiler caches and physical DDR traffic counters are not claimed.
The exact frozen-r3 source manifest binds executed native tools; export-time
repository HEAD/diff/worktree records describe delivery state separately. A later
commit receipt does not rewrite these original identities. Verification does not
establish device equivalence or significant performance gains, and does not run
the compiler/runtime/NPU. The full local raw evidence remains unchanged.
''')
    coverage={'profile-train':252,'profile-holdout':126,'profile-selected':84,'profile-full-m5':12}
    if len(e.packages)!=24:raise ValueError('expected24 compiler packages')
    manifest=dict(schema='orbit.implementation.evidence.v10',created_utc=datetime.now(timezone.utc).isoformat(),
        original_results=str(results),files=sorted(e.files.values(),key=lambda x:x['path']),numeric_pairs=e.numeric,
        expected_raw_output_files=coverage,compiled_packages=len(e.packages),compiled_package_original_paths=e.packages,
        unsealed_metadata=['manifest.json','verification.json'],
        boundary='Original byte identities retained; selected copies and exact raw numerical verification, not rerun measurements')
    save(out/'manifest.json',manifest);report=verify(out);save(out/'verification.json',report);return report


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--verify',type=Path);p.add_argument('--results',type=Path);p.add_argument('--output',type=Path)
    p.add_argument('--artifact-source',type=Path,default=Path(__file__).resolve().parents[2]);p.add_argument('--core-source',type=Path)
    a=p.parse_args()
    if a.verify:report=verify(a.verify.resolve())
    else:
        if not a.results or not a.output:p.error('export requires --results and NEW --output')
        core=a.core_source or Path(os.environ.get('ORBIT_SRC',str(a.artifact_source.parent/'orbit')))
        report=export(a.results.resolve(),a.output.resolve(),a.artifact_source.resolve(),core.resolve())
    print(json.dumps(report))


if __name__=='__main__':main()
