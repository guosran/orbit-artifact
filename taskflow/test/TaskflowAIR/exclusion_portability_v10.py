#!/usr/bin/env python3
"""CPU fixture portability/negative tests; optional read-only selection bridge."""
import argparse,copy,json,sys
from pathlib import Path
from unittest.mock import patch
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'scripts'))
import taskflow_implementation_experiment_v10 as E


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--experiment-results',type=Path,help='Optional existing v10 result root; original native order only, no compiler/device execution')
    a=p.parse_args();out=a.output.resolve();out.mkdir(parents=True,exist_ok=False)
    fixture=ROOT/'test/TaskflowAIR/fixtures/implementation_prior_exclusions_v10.json';d=E.load(fixture);checks=[]
    E.check_exclusions(d);checks.append('all15 delivered witness SHA and semantic coordinates verified')
    changed=copy.deepcopy(d)
    items=[changed[k] for k in ['case_manifest','observed_table','raw_manifest']]+[r[k] for r in changed['excluded'] for k in ['source','plan','transformed_source']]
    for row in items:row['path']='/definitely-not-present-old-v9/'+Path(row['path']).name
    E.check_exclusions(changed);checks.append('all original absolute acquisition paths absent without affecting checks')
    for kind in ['missing','tampered','escape']:
        bad=copy.deepcopy(changed)
        if kind=='missing':bad['case_manifest']['artifact_relative_path']='taskflow/test/TaskflowAIR/fixtures/definitely-missing-v10.json'
        elif kind=='tampered':bad['case_manifest']['sha256']='0'*64
        else:bad['case_manifest']['artifact_relative_path']='../outside'
        try:E.check_exclusions(bad)
        except (ValueError,OSError):checks.append(kind+' witness rejected')
        else:raise AssertionError(kind)
    ids=None
    if a.experiment_results:
        original=Path.open
        def guarded(path,*args,**kwargs):
            if '/results/taskflow/ffn-profiling-v9/' in str(path):raise AssertionError('historical raw path accessed: '+str(path))
            return original(path,*args,**kwargs)
        r=a.experiment_results.resolve()
        with patch.object(Path,'open',guarded):E.select_candidate(r/'predictive-search-final-r1',r/'frozen-model-final-r1',out/'selection',fixture,[r/'search-controls-final-r1/tiling-only',r/'search-controls-final-r1/implementation-residency'],1)
        old=E.load(r/'native-selection-final-r1/selected-cases.json');new=E.load(out/'selection/selected-cases.json')
        ids=[x['candidate_id'] for x in new]
        if [x['candidate_id'] for x in old]!=ids:raise AssertionError('selection changed')
        checks.append('actual readonly native selection same four candidate IDs with historical v9 opens forbidden')
    E.save(out/'summary.json',dict(status='passed',checks=checks,candidate_ids=ids,source=E.bound(Path(E.__file__)),test_source=E.bound(Path(__file__)),fixture=E.bound(fixture),compiler_invocations=0,device_submissions=0,old_evidence_modified=False))
    print(json.dumps({'status':'passed','checks':len(checks)}))


if __name__=='__main__':main()
