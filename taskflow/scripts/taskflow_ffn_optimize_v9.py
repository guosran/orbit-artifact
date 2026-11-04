#!/usr/bin/env python3
"""Reproduce implementation/residency experiments using existing compiler/runtime.

This is experiment orchestration. C++ materializes/checks every plan and search
action; installed AIR compiles it and the existing XRT runner executes it.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'python'))
from taskflow_paths import ORBIT_SRC
from taskflow_profiled_search_v9 import semantic_plan


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def save(path, value):
    Path(path).write_text(json.dumps(value, indent=2, allow_nan=False)+'\n')


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--baseline-root', type=Path, required=True,
                   help='fresh run_taskflow_ffn_profiling_v9.sh all output')
    p.add_argument('--output', type=Path, required=True, help='new directory')
    p.add_argument('--m', type=int, nargs='+', default=[1, 5, 8])
    p.add_argument('--iterations', type=int, default=1)
    p.add_argument('--warmups', type=int, default=1)
    p.add_argument('--m128', action='store_true',
                   help='also run one explicitly diagnostic complete M128 (16 M8 commands)')
    p.add_argument('--stages', action='store_true',
                   help='also profile independent optimized M8 stage mains and full main (one seed)')
    p.add_argument('--trace', action='store_true',
                   help='also obtain bounded one-core scalar/mixed packet windows')
    a = p.parse_args()
    baseline_entry, out = a.baseline_root.resolve(), a.output.resolve()
    state_path = baseline_entry/'workflow-state.json'
    if not state_path.is_file():
        p.error('baseline must be an audited fresh v9 workflow, with workflow-state.json')
    state = json.loads(state_path.read_text())
    if state.get('schema')!='orbit.ffn.workflow.v1' or state.get('phase')!='audited':
        p.error('baseline workflow must finish independent held-out auditing first')
    base = Path(state['package']).resolve()
    frozen_model = Path(state['frozen']).resolve()
    if sha(frozen_model/'freeze.json')!=state.get('freeze_sha256'):
        p.error('baseline frozen-model identity differs from audited workflow state')
    if not a.m or len(set(a.m)) != len(a.m) or any(m not in (1, 5, 8) for m in a.m):
        p.error('--m selects distinct prepared M1/M5/M8 programs')
    if a.iterations < 1 or a.warmups < 0:
        p.error('positive hot iterations and nonnegative warmups required')
    if a.stages and 8 not in a.m:
        p.error('--stages needs M8 in --m')
    if not shutil.which('air-opt') or not shutil.which('aircc'):
        p.error('source the existing AIE scripts/env.sh first (or use the shell entry)')
    tool = base/'frozen-tools/taskflow-opt'
    for m in a.m:
        for f in ('abi.json', 'hardware/compile.json', 'hardware/program.elf'):
            if not (base/f'baseline/m{m}/full'/f).is_file():
                p.error(f'missing prepared baseline {m}: {f}')
        for seed in (11, 23, 47):
            for prefix in ('inputs', 'reference'):
                if not (base/f'inputs/m{m}/full/{prefix}-{seed}.npz').is_file():
                    p.error(f'missing full-program {prefix} for M{m}/seed{seed}')
    if not tool.is_file():
        p.error('baseline has no frozen compiler')
    out.mkdir(parents=True, exist_ok=False)
    shutil.copy2(__file__, out/'orchestrator-source.py')
    (out/'commands').mkdir()
    (out/'frozen-tools').mkdir()
    frozen = out/'frozen-tools/taskflow-opt'
    shutil.copy2(tool, frozen)
    save(out/'invocation.json', dict(argv=sys.argv, baseline_root=str(base),
        audited_workflow_state=dict(path=str(state_path), sha256=sha(state_path)),
        scalar_frozen_model=dict(path=str(frozen_model/'freeze.json'), sha256=sha(frozen_model/'freeze.json')),
        compiler_sha256=sha(frozen), script_sha256=sha(__file__),
        contract='finite FP32 atol=rtol=1e-5; no BF16, FMA or K reassociation',
        backend='existing direct AIR and MultiLaunchRunner; no new runtime'))
    sequence = []

    def run(name, command):
        command = list(map(str, command))
        save(out/'commands'/f'{name}.json', command)
        with (out/'commands'/f'{name}.log').open('w') as log:
            r = subprocess.run(command, cwd=ROOT, stdout=log, stderr=subprocess.STDOUT)
        sequence.append(dict(name=name, returncode=r.returncode))
        save(out/'progress.json', sequence)
        if r.returncode:
            raise RuntimeError(f'{name} failed; see {out}/commands/{name}.log')
        print(f'{name}: PASS', flush=True)

    def py(name, path, *args):
        run(name, [sys.executable, ROOT/path, *args])

    def compile_case(name, inputs, destination, config, mixed=False, exp=False):
        command = ['bash', ROOT/'scripts/run_taskflow_direct_air_v6_case.sh',
            '--compile-only', '--diagnostic', '--input', inputs,
            '--output', destination, '--tool', frozen,
            '--target-config', config, '--distribute-initialization',
            '--runtime-transfer-audit']
        if mixed:
            command += ['--implementation', 'scalar-product-vector-add-f32', '--vector-lanes', '8']
        if exp:
            command += ['--approx-exp']
        run('compile-'+name, command)
        py('storage-'+name, 'test/TaskflowAIR/audit_storage_v6.py', destination/'hardware',
           '--plan', destination/'plan.json', '--output', destination/'storage-audit.json')

    def case(name, compiled, inputs, weights=False):
        abi = json.loads((compiled/'abi.json').read_text())
        return dict(name=name, hardware=str(compiled/'hardware'), abi=str(compiled/'abi.json'),
            static_indices=[i for i, b in enumerate(abi['buffers'])
                            if weights and b['role']=='input' and b['name'].startswith('W_')],
            intermediate_indices=[i for i, b in enumerate(abi['buffers']) if b['role']=='temporary'],
            inputs=[str(inputs/f'inputs-{s}.npz') for s in (11, 23, 47)],
            reference=[str(inputs/f'reference-{s}.npz') for s in (11, 23, 47)])

    def profile(name, rows, iterations, warmups):
        cases = out/f'cases-{name}.json'
        save(cases, rows)
        py('profile-'+name, 'scripts/taskflow_ffn_profile.py', '--cases', cases,
           '--output', out/('profile-'+name), '--iterations', iterations,
           '--warmups', warmups, '--observer', 'detailed')
        py('audit-'+name, 'test/TaskflowAIR/audit_profile_v9.py', '--root', out,
           '--profile', 'profile-'+name, '--output', out/('audit-'+name))

    py('baseline-freeze-check', 'scripts/taskflow_ffn_workflow_v9.py',
       'check-freeze', '--frozen', frozen_model)
    run('mixed-compiler-check', [sys.executable, ORBIT_SRC/'test/TaskflowAIR/mixed_f32_v9.py',
        '--tool', frozen, '--air-opt', shutil.which('air-opt'), '--output', out/'compiler-check'])
    config = out/'ffn-config.json'
    save(config, {'generic_air': {'tile_sizes': [8, 64, 64]}})
    for m in a.m:
        compiled, inputs = out/f'mixed-full/m{m}', base/f'inputs/m{m}/full'
        compile_case(f'full-m{m}', inputs, compiled, config, mixed=True, exp=True)
        profile(f'full-m{m}', [case(f'm{m}-full-scalar', base/f'baseline/m{m}/full', inputs, True),
            case(f'm{m}-full-mixed8', compiled, inputs, True)], a.iterations, a.warmups)

    if a.stages:
        rows = []
        for stage in ('gate', 'up', 'activation', 'down', 'full'):
            inputs = base/f'inputs/m8/{stage}'
            compiled = out/'mixed-full/m8' if stage=='full' else out/'mixed-m8-stages'/stage
            if stage!='full':
                # Activation remains the explicit scalar implementation used
                # by the mixed whole-program plan. No scalar model is applied.
                compile_case('m8-stage-'+stage, inputs, compiled, config,
                             mixed=stage!='activation', exp=True)
            row = case('m8-'+stage, compiled, inputs, weights=True)
            row['inputs'], row['reference'] = row['inputs'][:1], row['reference'][:1]
            rows.append(row)
        profile('m8-stages', rows, 1, 1)

    # Real non-divisible K/M and a generic oversized add->scale body. These are
    # fixture/reference generation only; both use the same generic compiler.
    for name, kind, m, k, n, tiles in [
            ('k-tail', 'gemm', 5, 129, 16, [2, 16, 64]),
            ('add-scale', 'add-scale', 64, 128, 64, [8, 32, 64])]:
        inputs, compiled = out/'control-inputs'/name, out/'control-compiled'/name
        py('prepare-'+name, 'test/TaskflowAIR/prepare_v6.py', '--case', kind,
           '--m', m, '--k', k, '--n', n, '--output', inputs)
        cfg = inputs/'target.json'
        save(cfg, {'generic_air': {'tile_sizes': tiles}})
        compile_case(name, inputs, compiled, cfg, mixed=True)
    profile('controls', [case(name, out/'control-compiled'/name, out/'control-inputs'/name)
            for name in ('k-tail', 'add-scale')], 3, 2)

    # Native whole-program search owns action generation, legality, candidate
    # IDs, deduplication and selection. Python selects fixed comparison cells.
    py('prepare-joint', 'test/TaskflowAIR/prepare_program_mapping_v7.py', '--output', out/'joint-input')
    proposals = out/'joint-proposals'
    py('joint-proposals', 'scripts/taskflow_profiled_search_v9.py', '--tool', frozen,
       '--source', out/'joint-input/source.mlir', '--implementation-proposals', '--output', proposals)
    selected = json.loads((proposals/'selected-four-cases.json').read_text())
    rows = []
    for selected_case in selected:
        cid = selected_case['candidate_id']
        inputs, compiled = out/'joint-materialized'/cid, out/'joint-compiled'/cid
        inputs.mkdir(parents=True, exist_ok=False)
        (inputs/'source.mlir').write_bytes(Path(selected_case['source']).read_bytes())
        compile_case('joint-'+cid, inputs, compiled, Path(selected_case['config']))
        # Fail before device execution if the backend did not implement the
        # exact native proposal. This is JSON evidence comparison, not planning.
        original = json.loads(Path(selected_case['features_plan']).read_text())
        actual = json.loads((compiled/'plan.json').read_text())
        record = json.loads((compiled/'hardware/compile.json').read_text())
        air = compiled/'hardware/input.air.mlir'
        elf = compiled/'hardware/program.elf'
        if sha(compiled/'source.mlir')!=selected_case['source_sha256']:
            raise ValueError('joint compiled source differs from proposal')
        if semantic_plan(original)!=semantic_plan(actual):
            raise ValueError('joint compiled plan differs from native proposal')
        for attr, value in [('orbit.mapping_plan', actual['plan_id']),
                            ('orbit.source_fingerprint', actual['body_fingerprint'])]:
            if set(re.findall(re.escape(attr)+r'\s*=\s*"([^"]+)"', air.read_text()))!={value}:
                raise ValueError('joint AIR identity differs from checked plan')
        if record['status']!='compiled' or sha(air)!=record['source_sha256'] or sha(elf)!=record['elf_sha256']:
            raise ValueError('joint compilation identity failed before profiling')
        save(compiled/'proposal-semantic-preflight.json', dict(status='passed',
            candidate_id=cid, source_sha256=sha(compiled/'source.mlir'),
            proposal_plan_sha256=sha(selected_case['features_plan']), compiled_plan_sha256=sha(compiled/'plan.json'),
            air_sha256=sha(air), elf_sha256=sha(elf),
            scope='exact source and full price-stripped native plan equality; AIR/compile/ELF binding; before device profiling'))
        rows.append(case(cid, compiled, out/'joint-input'))
    profile('joint', rows, 10, 2)
    py('collect-feedback', 'scripts/collect_direct_air_feedback_v9.py',
       '--proposal-cases', proposals/'selected-four-cases.json',
       '--proposal-summary', proposals/'summary.json', '--compiled-root', out/'joint-compiled',
       '--profile-directory', out/'profile-joint', '--audit', out/'audit-joint/profile-joint.json',
       '--output', out/'feedback')
    py('measured-search', 'scripts/taskflow_profiled_search_v9.py', '--tool', frozen,
       '--profile', out/'feedback/feedback-descriptor.json', '--output', out/'joint-measured-search')

    if a.trace:
        inputs = out/'trace-input'
        py('prepare-trace', 'test/TaskflowAIR/prepare_v6.py', '--case', 'gemm', '--m', 1,
           '--k', 64, '--n', 16, '--output', inputs)
        for kind in ('scalar', 'mixed8'):
            compiled = out/('trace-source-'+kind)
            compile_case('trace-'+kind, inputs, compiled, config, mixed=kind=='mixed8')
            py('trace-'+kind, 'scripts/taskflow_direct_air_trace_v9.py',
               '--air', compiled/'program.air.mlir', '--abi', compiled/'abi.json',
               '--inputs', inputs/'inputs-11.npz', '--reference', inputs/'reference-11.npz',
               '--mark-core-window', '--iterations', 5, '--output', out/('packet-trace-'+kind))
    if a.m128:
        inputs = out/'m128-input'
        py('prepare-m128', 'test/TaskflowAIR/prepare_v6.py', '--case', 'ffn', '--m', 128,
           '--k', 2048, '--n', 11008, '--seeds', 11, '--output', inputs)
        program = out/'m128-native-plan'
        run('lower-m128', [frozen, inputs/'source.mlir', '--air-distribute-initialization',
            '--air-approximate-exp', '--tile-m=8', '--tile-n=64', '--tile-k=64',
            '--implementation=scalar-product-vector-add-f32', '--vector-lanes=8',
            '--program-partition=8', '--lower-program-to-air='+str(program)])
        py('execute-m128', 'scripts/taskflow_direct_air_program.py', '--manifest', program/'manifest.json',
           '--inputs', inputs/'inputs-11.npz', '--reference', inputs/'reference-11.npz',
           '--diagnostic', '--output-dir', out/'m128-hardware')
        py('audit-m128', 'test/TaskflowAIR/audit_program_v7.py', out/'m128-hardware',
           '--allow-diagnostic', '--output', out/'m128-hardware/independent-audit.json')
        py('metrics-m128', 'test/TaskflowAIR/audit_metrics_v6.py', out/'m128-hardware',
           '--output', out/'m128-hardware/error-metrics.json')
    save(out/'result.json', dict(status='passed', commands=sequence, m=a.m,
        m128='one complete seed; explicitly diagnostic' if a.m128 else 'not executed',
        trace='bounded single-core diagnostic windows' if a.trace else 'not requested',
        stages='independent complete M8 stage mains, one seed' if a.stages else 'not requested',
        search='native C++ two-round implementation/residency search and exact observed feedback',
        model='scalar calibration belongs to baseline workflow; never applied to mixed implementation'))


if __name__ == '__main__':
    main()
