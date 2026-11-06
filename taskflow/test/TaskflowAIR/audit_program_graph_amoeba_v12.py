#!/usr/bin/env python3
"""Offline v12 final evidence readback; never builds or submits hardware.

Replays the SHA-bound executed compiler evidence checker, then independently
reads every actual NPU output and recomputes references from saved inputs. No
historical v9 trace annotations are treated as v12 evidence.
"""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import statistics
import sys


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--acceptance', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    import numpy as np
    root, out = args.acceptance.resolve(), args.output.resolve()
    out.mkdir(parents=True, exist_ok=False)
    snapshot = out/'auditor-source.py'
    snapshot.write_bytes(Path(__file__).read_bytes())
    files = {str(snapshot):sha(snapshot)}
    def read(path):
        files[str(path)] = sha(path)
        return json.loads(path.read_text())
    executed = root/'compiler-test-source.py'
    compiler = read(root/'compiler/summary.json')
    assert sha(executed) == compiler['test_source_sha256']
    files[str(executed)] = sha(executed)
    spec = importlib.util.spec_from_file_location('sha_bound_v12_evidence_checker', executed)
    checker = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(checker)
    architecture = Path(compiler['architecture']['path'])
    assert sha(architecture) == compiler['architecture']['sha256']
    candidates = []
    for row in compiler['candidates']:
        directory = root/'compiler/search/candidates'/row['candidate_id']
        graph, mapping = read(directory/'program-graph.json'), read(directory/'mapping-result.json')
        assert mapping['program_graph'] == graph and mapping['program_graph_id'] == graph['id'] == row['graph_id']
        assert sha(directory/'taskflow.mlir') == row['source_sha256']
        assert sha(directory/'program-graph.json') == row['graph_sha256']
        assert sha(directory/'program-graph.dot') == row['dot_sha256']
        for name, digest in row['backend']['files'].items():
            path = Path(name)
            assert sha(path) == digest
            files[str(path)] = digest
        backend = checker.audit_backend(directory,graph,mapping,architecture)
        assert backend == row['backend']
        candidates.append(dict(candidate_id=row['candidate_id'],action_chain=row['action_chain'],backend=backend))
    assert len(candidates) == 6
    legacy = read(root/'legacy-model-contract/summary.json')
    assert legacy['status'] == 'passed' and legacy['contracts_checked'] == 8
    assert legacy['scores_and_shortlist_unchanged'] is True
    cases = read(root/'profile-cases.json')
    assert len(cases) == 1 and cases[0]['name'] == 'same-source-air'
    case = cases[0]
    results = read(root/'profile-same-source/results.json')['results']
    assert len(results) == len(case['inputs']) == len(case['reference']) == 3
    checks, hot_walls, hot_waits = [], [], []
    for seed, result in enumerate(results):
        input_path, reference_path = Path(case['inputs'][seed]), Path(case['reference'][seed])
        files[str(input_path)], files[str(reference_path)] = sha(input_path), sha(reference_path)
        with np.load(input_path) as inputs, np.load(reference_path) as saved:
            assert set(inputs.files) == {'A','B'} and set(saved.files) == {'C'}
            reference = ((inputs['A'].astype(np.float64)+inputs['B'].astype(np.float64))*2).astype(np.float32)
            assert np.array_equal(saved['C'], reference)
        samples = result['samples']
        assert len(samples) == 7 and sorted(s['repeat'] for s in samples) == list(range(7))
        for sample in samples:
            assert sample['candidate'] == case['name'] and sample['warmup'] == (sample['repeat'] < 2)
            path = root/'profile-same-source'/f'seed-{seed}'/f"{case['name']}-{sample['repeat']}.npz"
            files[str(path)] = sha(path)
            with np.load(path) as actual:
                assert set(actual.files) == {'C'}
                value = actual['C']
                assert value.dtype == np.float32 and value.shape == reference.shape == (4,4)
                delta = np.abs(value.astype(np.float64)-reference.astype(np.float64))
                magnitude = np.abs(reference.astype(np.float64))
                finite = bool(np.isfinite(value).all() and np.isfinite(reference).all())
                passed = finite and bool(np.all(delta <= 1e-5+1e-5*magnitude))
                assert passed, (seed,sample['repeat'],'independent numeric mismatch')
                checks.append(dict(seed_index=seed,repeat=sample['repeat'],warmup=sample['warmup'],passed=passed,
                    max_abs=float(delta.max()),normalized_l2=float(np.linalg.norm(delta)/max(np.linalg.norm(reference.astype(np.float64)),1e-300)),
                    relative_reference_at_least_1e_minus6=float((delta[magnitude>=1e-6]/magnitude[magnitude>=1e-6]).max()) if np.any(magnitude>=1e-6) else None,
                    near_zero_max_abs=float(delta[magnitude<1e-6].max()) if np.any(magnitude<1e-6) else None))
            if not sample['warmup']:
                hot_walls.append(sample['wall_ms'])
                hot_waits.append(sum((e['end_ns']-e['start_ns'])/1e6 for e in sample['events'] if e['kind']=='xrt_wait'))
    assert len(checks) == 21 and len(hot_walls) == 15
    package = root/'compiled-air'
    for name in ['storage-audit.json','runtime-transfer-audit.json','graph-audit.json']:
        assert read(package/name)['status'] == 'passed'
    bridge = read(root/'same-source-backend-bridge.json')
    assert sha(root/'prepared/source.mlir') == sha(package/'source.mlir') == bridge['source_sha256']
    assert read(package/'plan.json')['body_fingerprint'] == bridge['body_fingerprint']
    for path in [package/'hardware/program.elf', package/'abi.json',root/'reproduction-source.sh',root/'profiler-executed.py']:
        files[str(path)] = sha(path)
    wait = read(root/'profile-same-source/wait-backend.json')
    report = dict(status='passed',auditor=dict(path=str(snapshot),sha256=sha(snapshot),argv=sys.argv),compiler_candidates=candidates,model_contracts=8,numerical_checks=checks,
        max_abs=max(c['max_abs'] for c in checks),max_normalized_l2=max(c['normalized_l2'] for c in checks),
        max_relative_reference_at_least_1e_minus6=max(c['relative_reference_at_least_1e_minus6'] for c in checks),
        near_zero_max_abs=max(c['near_zero_max_abs'] for c in checks if c['near_zero_max_abs'] is not None),
        hot_samples=len(hot_walls),hot_host_wall_median_ms=statistics.median(hot_walls),hot_host_wait_median_ms=statistics.median(hot_waits),
        actual_selected_wait=wait,files=files,device_submissions=0,compilation=False,device_trace=False,
        scope='Read-only SHA/receipt/actual-mapped-IR/production-trace recheck via exact executed contract checker; independent NumPy recomputation of all references and raw outputs. CGRA schedule cycles are estimates; NPU host wall is a separate boundary. No inherited v9 trace prose used as v12 evidence.')
    (out/'summary.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(dict(status='passed',compiler_candidates=len(candidates),output_checks=len(checks),max_abs=report['max_abs'])))


if __name__ == '__main__':
    main()
