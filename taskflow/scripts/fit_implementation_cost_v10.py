#!/usr/bin/env python3
"""Four-term whole-command experiment fit with static premeasurement design gate.

Native C++ owns feature collection, implementation legality and production cost
inference. This fitter only freezes empirical parameters from audited train labels.
"""
import argparse
import copy
import hashlib
import json
import math
from pathlib import Path
import statistics
import sys
import numpy as np
from fit_direct_air_cost_v9 import nnls_small, audited_labels
from taskflow_implementation_search_v10 import bound, load, save, sha, verify, verify_prepared, matches, request_matches
from collect_direct_air_feedback_v9 import compile_context
from taskflow_implementation_runtime_v10 import runtime_identity

TERMS=('command_count','implemented_scalar_f32_product_operations',
       'implemented_mixed8_f32_product_operations','hardware_stage_count')
REQUIRED=set(TERMS)|{'source_max_loop_0_iterations','source_max_loop_1_iterations','source_max_loop_2_iterations','max_tile_loop_0_iterations','max_tile_loop_1_iterations','max_tile_loop_2_iterations','source_phase_count','dma_bytes','resident_payload_bytes','capacity_bytes','core_count_per_stage','all_source_loops_affine','all_source_loops_unit_step','mixed8_lane_coverage_exact'}
ROOT=Path(__file__).resolve().parents[1]


def facts(row):
    plan=load(verify(row['plan']))
    f=plan['direct_air_cost']['features']
    if f['schema']!='orbit.direct-air.features.v1':
        raise ValueError('native features required')
    if not f['implementations'] or not set(f['implementations']) <= {'scalar:1','scalar-product-vector-add-f32:8'}:
        raise ValueError('undeclared implementation')
    for key,value in f['values'].items():
        if isinstance(value,bool) or not isinstance(value,int) or not 0<=value<=2**63-1:
            raise ValueError('native feature values require nonnegative int64')
    if f['values']['all_storage_f32']!=1 or f['values']['command_count']!=1:
        raise ValueError('single-command finite FP32 domain required')
    if not set(f['source_operations']) <= {'arith.addf:f32','arith.mulf:f32','arith.subf:f32'}:
        raise ValueError('uncovered source arithmetic; do not silently extend this model')
    for key in ['region_family_fingerprint','architecture_fingerprint']:
        if not isinstance(f.get(key),str) or len(f[key])!=64:
            raise ValueError('native family and architecture fingerprints required')
    for key in REQUIRED:
        if key not in f['values']:
            raise ValueError('new implementation-aware native feature absent: '+key)
    if f['values']['all_source_loops_affine']!=1 or f['values']['all_source_loops_unit_step']!=1:
        raise ValueError('native affine source scope required')
    if f['values']['implemented_mixed8_f32_product_operations'] and f['values']['mixed8_lane_coverage_exact']!=1:
        raise ValueError('native exact mixed8 lane coverage required')
    return f


def design(proposals, output):
    proposal=load(proposals/'proposal.json');prepared=Path(proposal['prepared'])
    verify(proposal['registration']);verify(proposal['matrix']);verify(proposal['coverage']);verify(proposal['tool'])
    matrix=verify_prepared(prepared)
    if matrix['model_protocol']['objective']!='relative-residual-floor-1ms':
        raise ValueError('undeclared fitting objective')
    if tuple(matrix['model_protocol']['terms'])!=TERMS:
        raise ValueError('four terms must match predeclared protocol')
    coverage=load(verify(proposal['coverage']))
    if any(r['status'] not in ('covered','native-rejection') for r in coverage):
        raise ValueError('native candidate coverage incomplete')
    selected=load(verify(proposal['selected']));features=[];ranges={};families=set();architectures=set();implementations=set();operations=set()
    declared={cell['name']:cell for cell in matrix['cells']}
    expected={name for name,cell in declared.items() if cell['split']!='negative'}
    if len(declared)!=len(matrix['cells']) or len(coverage)!=len(declared) or {r['cell'] for r in coverage}!=set(declared):
        raise ValueError('coverage does not exactly match registered cells')
    if any(row['split']!=declared[row['cell']]['split'] for row in coverage):
        raise ValueError('coverage split differs from preregistration')
    for row in coverage:
        if row['split']=='negative':
            if not row.get('replayed_rejections'):
                raise ValueError('negative requires bound native failed-request replay evidence')
            for artifact in row['replayed_rejections']:
                replay=load(verify(artifact))
                for key in ['source','command','stdout','stderr','config']:verify(replay[key])
                verify(replay['origin']['file'])
                if replay['returncode']==0 or not replay['capacity_diagnostic'] or sha(verify(replay['source']))!=replay['candidate_id'] or not request_matches(replay['requested_configuration'],declared[row['cell']]):
                    raise ValueError('negative replay differs from declared capacity request')

    if len(selected)!=len(expected) or {row['cell']['name'] for row in selected}!=expected:
        raise ValueError('selected cells missing/duplicated/extra')
    for row in selected:
        if row['cell']!=declared[row['cell']['name']] or not matches(load(verify(row['plan'])),row['cell']):
            raise ValueError('selected native plan/cell differs from exact preregistered coordinate')
    for row in selected:
        f=facts(row)
        features.append(dict(name=row['cell']['name'],split=row['cell']['split'],selection=row,features=f))
        families.add(f['region_family_fingerprint']);architectures.add(f['architecture_fingerprint'])
        implementations.update(f['implementations']);operations.update(f['source_operations'])
        if ranges and set(ranges)!=set(f['values']):
            raise ValueError('native feature set differs between declared cases')
        for key,value in f['values'].items():
            lo,hi=ranges.get(key,[value,value]);ranges[key]=[min(lo,value),max(hi,value)]
    train=[row for row in features if row['split']=='train']
    x=np.array([[row['features']['values'][k] for k in TERMS] for row in train],dtype=float)
    scale=np.maximum(np.linalg.norm(x,axis=0),1.0);z=x/scale
    singular=np.linalg.svd(z,compute_uv=False);rank=int(np.linalg.matrix_rank(z))
    condition=float(singular[0]/singular[-1]) if singular[-1]>0 else None
    output.mkdir(parents=True,exist_ok=False)
    save(output/'design-report.json',dict(rank=rank,required_rank=4,scaled_singular_values=singular.tolist(),
         column_scales=scale.tolist(),scaled_condition=condition,training_matrix=x.tolist(),
         condition_limit=matrix['model_protocol']['max_scaled_design_condition'],terms=list(TERMS),
         training_cases=[r['name'] for r in train],holdout_timing_labels_read=False))
    if rank!=4 or condition is None or condition>matrix['model_protocol']['max_scaled_design_condition']:
        raise ValueError('premeasurement design rank/condition gate failed; do not collect labels')
    save(output/'static-features.json',features)
    save(output/'design.json',dict(schema='orbit.implementation-search.design.v10',proposal=bound(proposals/'proposal.json'),
         matrix=bound(prepared/'matrix.json'),registration=bound(prepared/'preregistration.json'),tool=proposal['tool'],
         report=bound(output/'design-report.json'),features=bound(output/'static-features.json'),source=bound(Path(__file__)),
         domain=dict(family_fingerprints=sorted(families),architecture_fingerprints=sorted(architectures),
            implementations=sorted(implementations),operations=sorted(operations),feature_ranges=ranges,
            allow_tails=any(r['features']['values'].get('source_has_tile_tail',0)>0 for r in features)),
         terms=list(TERMS),objective=matrix['model_protocol']['objective'],comparators=matrix['model_protocol']['comparators'],timing_labels_read=False))
    return output/'design.json'


def check_design(directory):
    d=load(directory/'design.json')
    for key in ['proposal','matrix','registration','tool','report','features','source']:
        verify(d[key])
    for row in load(verify(d['features'])):
        for key in ['source','plan','config']:
            verify(row['selection'][key])
    return d


def fit(design_dir, compiled_dir, profile, audit_path, output, holdout_profile):
    d=check_design(design_dir)
    if holdout_profile.exists():
        raise ValueError('holdout already measured before parameter freeze')
    features=load(verify(d['features']));audit=load(audit_path);invocation=load(profile/'invocation.json')
    if audit['status']!='passed' or audit['profile']!=profile.name:
        raise ValueError('independent audit for exact training profile must pass')
    declared_train={row['name'] for row in features if row['split']=='train'}
    if set(invocation['identities'])!=declared_train:
        raise ValueError('training profile contains undeclared or heldout candidates')
    timing=load(verify(d['matrix']))['timing']
    actual_runtime,preparation=runtime_identity(profile,invocation,timing)
    compiled=load(compiled_dir/'compile-manifest.json');verify(compiled['cases']);verify(compiled['proposal']);verify(compiled['tool'])
    if compiled['proposal']['sha256']!=d['proposal']['sha256'] or compiled['tool']['sha256']!=d['tool']['sha256']:
        raise ValueError('feature/design compiler differs from executed package')
    rows=load(verify(compiled['cases']));packages={r['selection']['cell']['name']:r for r in rows}
    contexts=[];labels=[];train=[];bindings=[]
    for row in features:
        package=packages[row['name']]
        for key in ['source','plan','air','elf','abi','compile_record']:
            verify(package[key]);bindings.append(package[key])
        directory=Path(package['compiled']);native=load(directory/'invocation.json')
        if native['tool_sha256']!=d['tool']['sha256'] or sha(native['tool'])!=d['tool']['sha256']:
            raise ValueError('native lowering identity differs')
        native_flags=[('--target-config-sha256='+sha(directory/'target.json')) if flag.startswith('--target-config=') else flag for flag in native['flags']]
        contexts.append(dict(aircc=compile_context(load(directory/'hardware/command.json'),load(directory/'hardware/toolchain.json')),native_flags=native_flags))
        bindings.extend([bound(directory/'invocation.json'),bound(directory/'target.json'),bound(directory/'hardware/command.json'),bound(directory/'hardware/toolchain.json')])
        if row['split']!='train':
            continue
        identity=invocation['identities'][row['name']]
        if identity['elf_sha256']!=package['elf']['sha256'] or identity['abi_sha256']!=package['abi']['sha256']:
            raise ValueError('training profiler ran another ELF/ABI')
        entry=dict(name=row['name'],profile=str(profile/'results.json'),profile_sha256=sha(profile/'results.json'),
                   audit=str(audit_path),audit_sha256=sha(audit_path))
        values=audited_labels(entry);label=statistics.median(values)
        labels.append(label);train.append(dict(name=row['name'],hot_count=len(values),label_ms=label,
            native_features={k:row['features']['values'][k] for k in TERMS}))
    if any(c!=contexts[0] for c in contexts):
        raise ValueError('compiled hardware contexts differ; do not pool them')
    x=np.array([[r['native_features'][k] for k in TERMS] for r in train],dtype=float);y=np.array(labels,dtype=float)
    weight=1/np.maximum(y,1.0);(loss,coefficients,active),rank,singular=nnls_small(x*weight[:,None],y*weight)
    if rank!=4:
        raise ValueError('weighted training design became rank deficient')
    (simple_loss,simple_coefficients,simple_active),simple_rank,simple_singular=nnls_small(x[:,:3]*weight[:,None],y*weight)
    if simple_rank!=3:
        raise ValueError('three-term ablation design rank deficient')
    target=dict(id='direct-air-implementation-search-v10',runtime=actual_runtime,
        toolchain=json.dumps(dict(compile_context=contexts[0],native_lowering_sha256=d['tool']['sha256']),sort_keys=True,separators=(',',':')))
    output.mkdir(parents=True,exist_ok=False)
    save(output/'preparation-contract.json',preparation)
    label_manifest=dict(schema='orbit.implementation-search.training-labels.v10',design=bound(design_dir/'design.json'),profile=bound(profile/'results.json'),audit=bound(audit_path),invocation=bound(profile/'invocation.json'),cases=bound(Path(invocation['cases_path'])),preparation=bound(output/'preparation-contract.json'),training=train,target=target,holdout_timing_labels_read=False)
    save(output/'training-label-manifest.json',label_manifest)
    model=dict(schema='orbit.direct-air.cost.v1',kind='implementation-composite',calibration='calibrated',
        model_id='gemm-scale-scalar-mixed8-v10',model_version='1',training_manifest_digest=sha(output/'training-label-manifest.json'),
        target=target,boundary='prepared-command-host-to-host',domain=d['domain'],
        terms=[dict(feature=k,coefficient_ms=float(c)) for k,c in zip(TERMS,coefficients)])
    for row in train:
        row['predicted_ms']=sum(row['native_features'][k]*float(c) for k,c in zip(TERMS,coefficients))
    save(output/'model.json',model)
    simple=copy.deepcopy(model);simple['model_id']='gemm-scale-scalar-mixed8-v10-three-term-ablation'
    simple['terms']=[dict(feature=k,coefficient_ms=float(c)) for k,c in zip(TERMS,list(simple_coefficients)+[0.0])]
    save(output/'model-simple-3term.json',simple)
    save(output/'fit-simple-3term.json',dict(schema='orbit.implementation-search.fit.v10',status='frozen-training-fit',ablation='independent three-term NNLS; hardware_stage_count coefficient fixed to zero',objective=d['objective'],weighted_squared_loss=simple_loss,feature_rank=simple_rank,scaled_singular_values=simple_singular,active_terms=[TERMS[i] for i in simple_active],holdout_timing_labels_read=False))
    legacy=d['comparators']['legacy_theoretical']
    save(output/'legacy-theoretical.json',legacy)
    save(output/'fit.json',dict(schema='orbit.implementation-search.fit.v10',status='frozen-training-fit',training=train,
        objective=d['objective'],weighted_squared_loss=loss,feature_rank=rank,scaled_singular_values=singular,
        active_terms=[TERMS[i] for i in active],holdout_timing_labels_read=False,
        scope='whole prepared-command empirical composite; coefficients are not independent physical compute/DMA measurements'))
    save(output/'freeze.json',dict(schema='orbit.implementation-search.freeze.v10',design=bound(design_dir/'design.json'),
        model=bound(output/'model.json'),simple_model=bound(output/'model-simple-3term.json'),simple_fit=bound(output/'fit-simple-3term.json'),legacy_theoretical=bound(output/'legacy-theoretical.json'),fit=bound(output/'fit.json'),compiled=bound(compiled_dir/'compile-manifest.json'),
        profile=bound(profile/'results.json'),audit=bound(audit_path),invocation=bound(profile/'invocation.json'),
        training_labels=bound(output/'training-label-manifest.json'),preparation=bound(output/'preparation-contract.json'),source=bound(Path(__file__)),nnls_dependency=bound(ROOT/'scripts/fit_direct_air_cost_v9.py'),runtime_policy_source=bound(ROOT/'scripts/taskflow_implementation_runtime_v10.py'),runtime_dependency=bound(ROOT/'scripts/collect_direct_air_feedback_v9.py'),
        compiled_artifacts=bindings,reserved_holdout_profile=str(holdout_profile.resolve()),holdout_timing_labels_read=False))
    return output/'freeze.json'


def check_freeze(directory):
    freeze=load(directory/'freeze.json')
    for key in ['design','model','fit','compiled','profile','audit','invocation','source','nnls_dependency','preparation','training_labels','runtime_policy_source','runtime_dependency','simple_model','simple_fit','legacy_theoretical']:
        verify(freeze[key])
    for item in freeze['compiled_artifacts']:
        verify(item)
    labels=load(verify(freeze['training_labels']))
    for key in ['design','profile','audit','invocation','cases','preparation']:verify(labels[key])
    verify(load(verify(freeze['compiled']))['cases'])
    check_design(Path(freeze['design']['path']).parent)
    return freeze


def main():
    parser=argparse.ArgumentParser(description=__doc__);sub=parser.add_subparsers(dest='phase',required=True)
    p=sub.add_parser('design');p.add_argument('--proposals',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    p=sub.add_parser('fit')
    for key in ['design','compiled','profile','audit','output','holdout-profile']:p.add_argument('--'+key,type=Path,required=True)
    p=sub.add_parser('check-freeze');p.add_argument('--frozen',type=Path,required=True)
    args=parser.parse_args()
    if args.phase=='design':result=design(args.proposals.resolve(),args.output.resolve())
    elif args.phase=='fit':result=fit(args.design.resolve(),args.compiled.resolve(),args.profile.resolve(),args.audit.resolve(),args.output.resolve(),args.holdout_profile.resolve())
    else:result=check_freeze(args.frozen.resolve())['model']['sha256']
    print(json.dumps(dict(status='passed',phase=args.phase,result=str(result),device_submissions=0)))


if __name__=='__main__':
    main()
