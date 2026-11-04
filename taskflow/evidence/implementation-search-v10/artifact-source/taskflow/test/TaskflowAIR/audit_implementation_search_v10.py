#!/usr/bin/env python3
"""Independent raw numerical audit plus descriptive frozen prediction validation.

Ranking/regret here is an experiment report, never production search selection.
No model is fitted or updated from held-out results.
"""
import argparse
import itertools
import json
import math
from pathlib import Path
import statistics
import sys

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'scripts'))
from taskflow_implementation_search_v10 import load,save,bound,verify,sha,run
from fit_implementation_cost_v10 import check_freeze,check_design
from taskflow_implementation_runtime_v10 import runtime_identity


def comparison(rows,actual,raw):
    errors=[];groups={}
    for row in rows:
        name=row['name'];prediction=row['prediction_ms'];observed=actual[name]
        if not observed['numerical_passed'] or not observed.get('numeric_gate_passed'):
            raise ValueError('heldout numerical failure')
        measured=observed['hot_wall_ms']['median']
        if any(isinstance(v,bool) or not isinstance(v,(int,float)) or not math.isfinite(v) or v<=0 for v in [prediction,measured]):
            raise ValueError('positive finite predictions and observed medians required')
        error=100*(prediction-measured)/measured
        errors.append(dict(name=name,program=row['program'],prediction_ms=prediction,actual_median_ms=measured,
                           signed_relative_error_percent=error,absolute_relative_error_percent=abs(error),statistics=observed['hot_wall_ms']))
        groups.setdefault(row['program'],[]).append(errors[-1])
    summaries=[]
    for program,candidates in groups.items():
        best_prediction=min(c['prediction_ms'] for c in candidates);best_actual=min(c['actual_median_ms'] for c in candidates)
        selected=[c for c in candidates if abs(c['prediction_ms']-best_prediction)<=1e-12]
        pairs=[]
        for first,second in itertools.combinations(candidates,2):
            deltas=[]
            for seed in raw['results']:
                a={s['repeat']:s['wall_ms'] for s in seed['samples'] if s['candidate']==first['name'] and not s['warmup']}
                b={s['repeat']:s['wall_ms'] for s in seed['samples'] if s['candidate']==second['name'] and not s['warmup']}
                if set(a)!=set(b):raise ValueError('paired hot repeat coverage differs')
                deltas.extend(a[k]-b[k] for k in sorted(a))
            pd=first['prediction_ms']-second['prediction_ms'];md=first['actual_median_ms']-second['actual_median_ms']
            pairs.append(dict(first=first['name'],second=second['name'],prediction_difference_ms=pd,median_difference_ms=md,
                prediction_tie=abs(pd)<=1e-12,strict_order_reversal=(pd*md<0),
                paired_hot_differences_ms=deltas,paired_median_difference_ms=statistics.median(deltas) if deltas else None))
        summaries.append(dict(program=program,predicted_minimizers=[c['name'] for c in selected],
            actual_median_minimizers=[c['name'] for c in candidates if c['actual_median_ms']==best_actual],
            descriptive_regret_percent_range=[min(100*(c['actual_median_ms']/best_actual-1) for c in selected),max(100*(c['actual_median_ms']/best_actual-1) for c in selected)],
            pairwise=pairs,scope='point-estimate descriptive ranking; ties preserved, no significance or causal speedup claim'))
    return dict(rows=errors,MAPE_percent=statistics.mean(r['absolute_relative_error_percent'] for r in errors),
                max_absolute_relative_error_percent=max(r['absolute_relative_error_percent'] for r in errors),groups=summaries)


def audit(frozen,predictions,profile,output):
    record=check_freeze(frozen);pre=load(predictions);verify(pre['freeze']);verify(pre['rows'])
    if pre['freeze']['sha256']!=sha(frozen/'freeze.json') or profile.resolve()!=Path(record['reserved_holdout_profile']).resolve():
        raise ValueError('heldout/freeze identity differs from reserved experiment')
    phase_inputs=load(profile.parent/'phase-inputs.json')
    if phase_inputs['predictions']['sha256']!=sha(predictions):
        raise ValueError('audited predictions differ from pre-execution heldout phase identity')
    model=load(verify(record['model']));d=check_design(Path(record['design']['path']).parent);timing=load(verify(d['matrix']))['timing']
    identity,preparation=runtime_identity(profile,load(profile/'invocation.json'),timing)
    if identity!=model['target']['runtime']:
        raise ValueError('actual heldout runtime policy differs from frozen target')
    output.mkdir(parents=True,exist_ok=False)
    run(output,'raw-audit',[sys.executable,ROOT/'test/TaskflowAIR/audit_profile_v9.py','--root',profile.parent,
        '--profile',profile.name,'--output',output/'raw-audit'])
    actual=load(output/'raw-audit'/(profile.name+'.json'))
    if actual['status']!='passed':raise ValueError('independent heldout raw numerical audit failed')
    rows=load(verify(pre['rows']));invocation=load(profile/'invocation.json')
    if set(actual['candidates'])!={r['name'] for r in rows}:
        raise ValueError('exact frozen prediction/output coverage required')
    for row in rows:
        verify(row['native_prediction_plan'])
        for key in ['source','plan','air','elf','abi','compile_record']:verify(row['compiled'][key])
        expected=row['compiled'];observed=invocation['identities'][row['name']]
        if observed['elf_sha256']!=expected['elf']['sha256'] or observed['abi_sha256']!=expected['abi']['sha256']:
            raise ValueError('heldout profiler ELF/ABI differs from preselected prediction')
        for model_name,artifact in row['native_prediction_plans'].items():
            native=load(verify(artifact))
            if native['estimated_ms']!=row['model_predictions_ms'][model_name]:
                raise ValueError('prediction row differs from native frozen output')
        if row['prediction_ms']!=row['model_predictions_ms']['implementation_stage_4term']:
            raise ValueError('primary prediction differs from four-term model')
    report=comparison(rows,actual['candidates'],load(profile/'results.json'))
    report['model_comparisons']={model_name:comparison([dict(row,prediction_ms=row['model_predictions_ms'][model_name]) for row in rows],actual['candidates'],load(profile/'results.json')) for model_name in ['legacy_theoretical','simple_implementation_3term','implementation_stage_4term']}
    report['legacy_theoretical_scope']='original C++ uncalibrated v9 sensitivity coefficients, evaluated on current native facts; static boundary omissions preserved, not a newly fitted calibrated predictor'
    report.update(status='post-freeze-independent-validation',parameters_changed=False,heldout_refit=False,
        model=record['model'],prediction_freeze=bound(predictions),raw_audit=bound(output/'raw-audit'/(profile.name+'.json')),
        profile=bound(profile/'results.json'),preparation=preparation,
        scope='finite FP32 atol=rtol=1e-5 raw checks; numeric validity is separate from model accuracy; host waits include runtime/device/DMA/stalls')
    save(output/'validation.json',report);return output/'validation.json'


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    for key in ['frozen','predictions','profile','output']:parser.add_argument('--'+key,type=Path,required=True)
    args=parser.parse_args();print(audit(args.frozen.resolve(),args.predictions.resolve(),args.profile.resolve(),args.output.resolve()))


if __name__=='__main__':main()
