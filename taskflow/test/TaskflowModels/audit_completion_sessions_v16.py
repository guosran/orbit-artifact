#!/usr/bin/env python3
"""CPU-only same-frozen-model replay and changed-observer polling audit. No fit."""
import argparse
from collections import defaultdict
import json
from pathlib import Path
import statistics
import numpy as np
from audit_mechanism_program_v16 import read,sha,identity,verify,stats

def audit(root,old):
    gate=read(root/'v15-same-model-new-session-gate.json');model=read(verify(gate['model']));protocol=read(verify(gate['protocol']));row=model['rows'][0]
    assert gate['model']['sha256']=='cc02bfdf882f621fc0bc78f3d9b69a2d5c7c63978237e840cb78d000f124d9ab'
    before=read(root/'v15-cross-session-runtime-before.json');after=read(root/'v15-cross-session-runtime-after.json');binding=read(old/'runtime-condition-r2/binding.json')
    assert before==after and before['target_id']==binding['runtime_descriptor']['target_fingerprint_id']
    actual=root/'v15-same-model-new-session-r1';runtime=read(actual/'runtime.json');ident=read(actual/'identity.json')
    assert sha(actual/'protocol.json')==gate['protocol']['sha256']==ident['protocol']['sha256']
    assert runtime['active_contexts']==binding['condition']['prepared_context_count']==9
    assert runtime['installed_runner']['sha256']==binding['runtime_descriptor']['installed_runner_sha256']
    assert ident['source_sha256']==row['domain']['observer_identity']==sha(actual/'runner-source.py')
    cases={c['id']:c for c in protocol['cases']}; groups=defaultdict(list);outputs=0
    for line in (actual/'samples.jsonl').read_text().splitlines():
        s=json.loads(line);wait=s['selected_wait_backend'];assert wait['qualname']=='_wait_polling' and wait['poll_interval_seconds']==.0002
        with np.load(verify(s['inputs']),allow_pickle=False) as z:a=z['A'].copy()
        with np.load(verify(s['outputs']),allow_pickle=False) as z:c=z['C'].copy()
        assert np.array_equal(a,c);outputs+=1
        if not s['warmup']:groups[s['case']].append(s['dispatch_to_wait_end_ns'])
    cells=[]
    for name,values in sorted(groups.items()):
        p=row['entry_ns']+row['byte_ns']*8*cases[name]['fixture']['elements'];st=stats(values);error=abs(p-st['median_ns']);limit=max(300000,.25*st['median_ns'])
        cells.append(dict(case=name,prediction_ns=p,distribution=st,absolute_error_ns=error,relative_error=error/st['median_ns'],threshold_ns=limit,passed=error<=limit))
    assert outputs==297 and sum(len(v) for v in groups.values())==243
    polling=[]
    for poll in (0,20,200,1000):
        path=root/f'polling-{poll}us-r1';samples=[json.loads(s) for s in (path/'samples.jsonl').read_text().splitlines()];bounds=[json.loads(s) for s in (path/'polling-bound-samples.jsonl').read_text().splitlines()]
        assert len(samples)==len(bounds);g=defaultdict(lambda:defaultdict(list))
        for s,b in zip(samples,bounds):
            assert (s['case'],s['seed'],s['repeat'])==(b['case'],b['seed'],b['repeat'])
            with np.load(verify(s['inputs']),allow_pickle=False) as z:a=z['A'].copy()
            with np.load(verify(s['outputs']),allow_pickle=False) as z:c=z['C'].copy()
            assert np.array_equal(a,c)
            polls=b['polls'];assert polls[-1]['state']==4 and all(p['state'] in (1,2,3,7) for p in polls[:-1])
            assert b['visible_completion_upper_ns']==polls[-1]['end_ns']
            if len(polls)>1:assert b['visible_completion_lower_ns']==polls[-2]['start_ns'] and b['visibility_bracket_ns']==polls[-1]['end_ns']-polls[-2]['start_ns']
            else:assert b['visible_completion_lower_ns'] is None and b['visibility_bracket_ns'] is None
            if not s['warmup']:
                g[s['case']]['completion'].append(s['dispatch_to_wait_end_ns']);g[s['case']]['polls'].append(len(polls))
                if b['visibility_bracket_ns'] is not None:g[s['case']]['visibility_bracket'].append(b['visibility_bracket_ns'])
        polling.append(dict(poll_us=poll,identity=identity(path/'identity.json'),samples=identity(path/'samples.jsonl'),observations=[dict(case=k,quantities={key:stats(v) for key,v in values.items()}) for k,values in sorted(g.items())]))
    return dict(schema='orbit.completion-sessions.independent.v16',status='passed',auditor=identity(__file__),gate=identity(root/'v15-same-model-new-session-gate.json'),runtime_before=identity(root/'v15-cross-session-runtime-before.json'),runtime_after=identity(root/'v15-cross-session-runtime-after.json'),same_model_new_session=dict(model=gate['model'],conditions_matched=True,exact_outputs=outputs,cells=cells,passed=sum(c['passed'] for c in cells),mape_percent=100*statistics.mean(c['relative_error'] for c in cells)),changed_observer_polling=polling,limitations=['Same-model new-session pass/failure is evaluated without refitting.','Polling conditions use different observer instrumentation and context population; none is frozen-v15 same-condition replay.','Visibility brackets assume monotone XRT state reporting and bound host command visibility only, not physical device or DMA completion.','Polling groups ran in separate sequential sessions, so between-group differences may contain session/state confounding; they cannot identify polling-caused device slowdown.','sleep(0) yields to the OS; zero requested sleep does not imply zero elapsed wait.'])

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--root',type=Path,required=True);p.add_argument('--v15',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();assert not a.output.exists();result=audit(a.root,a.v15);a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(json.dumps(result,indent=2)+'\n');s=result['same_model_new_session'];print(json.dumps(dict(status='passed',cells_passed=s['passed'],mape_percent=s['mape_percent'],outputs=s['exact_outputs'])))
if __name__=='__main__':main()
