#!/usr/bin/env python3
"""Freeze an experimental composite from native feature plans and audited labels.

No compiler analysis or production cost implementation lives here. Holdout labels
are never opened by this fitter. Four nonnegative coefficients describe a whole
host call, not independently identified physical components.
"""
import argparse
import hashlib
import itertools
import json
import math
from pathlib import Path
import statistics

import numpy as np

TERMS = ('command_count', 'source_f32_product_operations',
         'source_math_exp_f32_operations', 'hardware_stage_count')


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def load_bound(entry, key):
    path = Path(entry[key])
    digest = sha(path)
    if digest != entry[key + '_sha256']:
        raise ValueError(f'{key} identity changed: {path}')
    return json.loads(path.read_text())


def native_features(entry):
    plan = load_bound(entry, 'plan')
    features = plan['direct_air_cost']['features']
    if features['schema'] != 'orbit.direct-air.features.v1':
        raise ValueError('native feature schema required')
    for name in TERMS:
        n = features['values'][name]
        if isinstance(n, bool) or not isinstance(n, int) or n < 0:
            raise ValueError(f'invalid native count {name}')
    if features['values']['command_count'] != 1:
        raise ValueError('single-command training only; partition host cost unknown')
    if features['values']['all_storage_f32'] != 1:
        raise ValueError('f32 storage required')
    return features


def audited_labels(entry):
    audit = load_bound(entry, 'audit')
    if audit.get('status') != 'passed':
        raise ValueError('independent raw-output audit must pass')
    if not any(c.get('candidate') == entry['name'] and c.get('passed') for c in audit.get('checks', [])):
        raise ValueError('candidate missing from independent raw-output audit')
    profile = load_bound(entry, 'profile')
    # An experiment with any failed result is excluded as a whole, rather than
    # selecting only its successful candidates or repeats.
    if any(seed['status'] != 'passed' for seed in profile['results']):
        raise ValueError('entire failed experiment is ineligible')
    hot = []
    for seed in profile['results']:
        for sample in seed['samples']:
            if not all(c['passed'] and c['finite'] for c in sample['checks'].values()):
                raise ValueError('numeric failure in experiment')
            if sample['candidate'] == entry['name'] and not sample['warmup']:
                value = sample['wall_ms']
                if not math.isfinite(value) or value <= 0:
                    raise ValueError('nonpositive/nonfinite wall label')
                hot.append(value)
    if not hot:
        raise ValueError('candidate has no hot samples')
    return hot


def nnls_small(x, y):
    """Exhaustive active sets; column-scaled least squares, no hidden intercept."""
    scale = np.maximum(np.linalg.norm(x, axis=0), 1.0)
    z = x / scale
    best = None
    for n in range(x.shape[1] + 1):
        for active in itertools.combinations(range(x.shape[1]), n):
            beta = np.zeros(x.shape[1])
            if active:
                values = np.linalg.lstsq(z[:, active], y, rcond=None)[0]
                if np.any(values < -1e-12):
                    continue
                beta[list(active)] = np.maximum(values, 0)
            residual = z @ beta - y
            loss = float(residual @ residual)
            if best is None or loss < best[0]:
                best = (loss, beta / scale, list(active))
    return best, int(np.linalg.matrix_rank(z)), np.linalg.svd(z, compute_uv=False).tolist()


def fit(manifest, manifest_path):
    if manifest['schema'] != 'orbit.direct-air.training.v1':
        raise ValueError('training manifest schema required')
    if manifest['timing_boundary'] != 'prepared-command-host-to-host':
        raise ValueError('unsupported timing boundary')
    if manifest['objective'] != 'relative-residual-floor-1ms':
        raise ValueError('objective must be frozen before holdout execution')
    target = manifest['target']
    if any(not target.get(k) for k in ('id', 'toolchain', 'runtime')):
        raise ValueError('explicit target/toolchain/runtime required')
    rows, holdouts, groups = [], [], {}
    sources, implementations, operations = set(), set(), set()
    source_values = {}
    for entry in manifest['cases']:
        split = entry['split']
        if split not in ('train', 'holdout'):
            raise ValueError('explicit train/holdout split required')
        group = entry['group_id']
        if groups.setdefault(group, split) != split:
            raise ValueError('group spans training and holdout')
        f = native_features(entry)
        sources.update(f['source_fingerprints'])
        for source in f['source_fingerprints']:
            source_values.setdefault(source, []).append(f['values'])
        implementations.update(f['implementations'])
        operations.update(f['source_operations'])
        x = [f['values'][key] for key in TERMS]
        base = {'name': entry['name'], 'group_id': group, 'features': dict(zip(TERMS, x)),
                'plan_sha256': entry['plan_sha256']}
        if split == 'holdout':
            # Do not resolve/open profile or audit paths for withheld cases.
            holdouts.append(base)
            continue
        samples = audited_labels(entry)
        base.update(label_median_ms=statistics.median(samples), hot_count=len(samples),
                    hot_min_ms=min(samples), hot_max_ms=max(samples),
                    profile_sha256=entry['profile_sha256'], audit_sha256=entry['audit_sha256'])
        rows.append(base)
    if not rows or not holdouts:
        raise ValueError('training and preselected unmeasured holdout sources required')
    if len({r['name'] for r in rows + holdouts}) != len(rows + holdouts):
        raise ValueError('duplicate candidate identity')
    x = np.array([[r['features'][key] for key in TERMS] for r in rows], dtype=float)
    y = np.array([r['label_median_ms'] for r in rows])
    weights = 1 / np.maximum(y, 1.0)
    (loss, coef, active), rank, singular = nnls_small(x * weights[:, None], y * weights)
    if rank < len(TERMS):
        raise ValueError(f'four-term feature matrix is rank deficient ({rank}); do not freeze unidentified model')
    predictions = x @ coef
    for row, predicted in zip(rows, predictions):
        row.update(predicted_ms=float(predicted), residual_ms=float(predicted-row['label_median_ms']))
    for row in holdouts:
        row['unvalidated_prediction_ms'] = sum(row['features'][k] * float(c) for k, c in zip(TERMS, coef))
    # Domain is predeclared in the manifest, not expanded after seeing holdout
    # labels. Holdout feature extrapolation remains visible in the report.
    ranges = manifest['feature_ranges']
    for row in rows + holdouts:
        row['within_declared_feature_ranges'] = all(
            low <= row['features'].get(k, -1) <= high for k, (low, high) in ranges.items())
    source_ranges = manifest.get('source_feature_ranges')
    if 'source_feature_ranges' in manifest:
        if not isinstance(source_ranges, dict) or not source_ranges or set(source_ranges) != sources:
            raise ValueError('source_feature_ranges must cover exactly the declared native source fingerprints')
        for source, entries in source_ranges.items():
            if not isinstance(entries, dict) or not entries:
                raise ValueError('each source requires nonempty native feature ranges')
            facts = source_values[source]
            for feature, limits in entries.items():
                if any(feature not in values for values in facts):
                    raise ValueError('per-source range key missing from native feature records: '+feature)
                if (not isinstance(limits, list) or len(limits) != 2 or
                    any(isinstance(v, bool) or not isinstance(v, int) or v < 0 or v > 2**63-1 for v in limits) or
                    limits[0] > limits[1]):
                    raise ValueError('invalid nonnegative int64 per-source feature range: '+feature)
                for values in facts:
                    actual = values[feature]
                    if isinstance(actual, bool) or not isinstance(actual, int) or not limits[0] <= actual <= limits[1]:
                        raise ValueError('declared source range excludes a native candidate fact: '+feature)
    model = {'schema': 'orbit.direct-air.cost.v1', 'kind': 'linear-composite',
             'calibration': 'calibrated', 'model_id': manifest['model_id'],
             'model_version': manifest['model_version'], 'training_manifest_digest': sha(manifest_path),
             'boundary': manifest['timing_boundary'], 'target': target,
             'domain': {'source_fingerprints': sorted(sources), 'implementations': sorted(implementations),
                        'operations': sorted(operations), 'feature_ranges': ranges},
             'terms': [{'feature': k, 'coefficient_ms': float(c)} for k, c in zip(TERMS, coef)]}
    if source_ranges is not None:
        model['domain']['source_feature_ranges'] = source_ranges
    report = {'schema': 'orbit.direct-air.fit.v1', 'status': 'frozen-training-fit',
              'manifest_sha256': sha(manifest_path), 'terms': list(TERMS), 'objective': manifest['objective'],
              'method': 'column-scaled exhaustive active-set nonnegative least squares',
              'feature_rank': rank, 'scaled_singular_values': singular,
              'active_terms': [TERMS[i] for i in active], 'weighted_squared_loss': loss,
              'training': rows, 'preselected_holdout_no_labels_read': holdouts,
              'boundary': 'prepared host input arrays through returned output; detailed observer wall_ms',
              'limitations': ['empirical composite; coefficients are not independently measured physical components',
                             'polling quantization and tiny samples limit small-stage inference',
                             'source product counts do not count generated soft-float helper calls',
                             'DMA facts are retained in native plans but not separately charged',
                             'partition/controller/slice/assembly overhead remains unknown',
                             'holdout predictions are unvalidated until a separate post-freeze evaluation']}
    return model, report


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--manifest', type=Path, required=True)
    p.add_argument('--output', type=Path, required=True)
    args = p.parse_args()
    model, report = fit(json.loads(args.manifest.read_text()), args.manifest)
    args.output.mkdir(parents=True, exist_ok=False)
    for name, value in [('model.json', model), ('fit.json', report)]:
        (args.output / name).write_text(json.dumps(value, indent=2, sort_keys=True, allow_nan=False)+'\n')
    print(json.dumps({'status': report['status'], 'model_sha256': sha(args.output/'model.json'),
                      'feature_rank': report['feature_rank']}))


if __name__ == '__main__':
    main()
