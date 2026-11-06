#!/usr/bin/env python3
"""Compiler orchestration only; original C++ search creates all candidates/plans.

Read existing official samples solely for exact source/graph-identity joins.
Conditional predictions never become absolute scores or performance ranking.
"""
from pathlib import Path
import json,subprocess,hashlib,statistics,csv,argparse
parser=argparse.ArgumentParser(description='Two-round unpriced original-C++ candidate diagnostic; no device execution')
parser.add_argument('--study-root',type=Path,required=True)
parser.add_argument('--output',type=Path,required=True)
args=parser.parse_args()
ROOT=args.study_root.resolve();OUT=args.output.resolve();OUT.mkdir(parents=True,exist_ok=False)
(OUT/'runner.py').write_text(Path(__file__).read_text())
CORE=ROOT/'build-core-r1/tools/taskflow-opt/taskflow-opt'
CONTRAST=CORE.parent/'taskflow-contrast-opt'
CONFIG=ROOT/'generated-pairs-r1/config.json'
MODEL=ROOT/'freeze-r2/model.json';TARGET=ROOT/'freeze-r2/target-binding.json'
def read(p):return json.loads(Path(p).read_text())
def write(p,v):Path(p).write_text(json.dumps(v,indent=2)+'\n')
def ident(p):p=Path(p);return dict(path=str(p.resolve()),sha256=hashlib.sha256(p.read_bytes()).hexdigest())
def run(d,name,cmd):
 cmd=list(map(str,cmd));write(d/(name+'.command.json'),cmd)
 p=subprocess.run(cmd,cwd='/home/shiran/project/orbit',capture_output=True,text=True)
 (d/(name+'.stdout')).write_text(p.stdout);(d/(name+'.stderr')).write_text(p.stderr);write(d/(name+'.result.json'),dict(returncode=p.returncode,device_submissions=0));return p
inputs={str(p):ident(p)['sha256'] for p in [CORE,CONTRAST,CONFIG,MODEL,TARGET,Path(__file__)]};write(OUT/'input-identities.json',inputs)
formal={c['id']:c for c in read(ROOT/'generated-pairs-r1/index.json')['cases']}
rows=[];programs=[];selected=[]
for pair in ['broadcast-m32n768','fanout-e768']:
 item=formal[pair];d=OUT/pair;d.mkdir();baseline=Path(item['baseline']['source']['path'])
 cmd=[CORE,baseline,'--search','--backend=air','--target-config='+str(CONFIG),'--search-output='+str(d/'search'),'--max-rounds=2','--max-candidates=24','--beam-width=4']
 p=run(d,'search',cmd);assert p.returncode==0,p.stderr
 search=read(d/'search/search.json');assert len(search['selections'])==2 and search['ranking']==[]
 actual={}
 for side in ['baseline','candidate']:
  digest=item[side]['source']['sha256'];assert ident(item[side]['source']['path'])['sha256']==digest
  sessions=[]
  for session in ['heldout-r1','cross-session-r1']:
   loc=ROOT/session/pair;protocol=read(loc/'protocol.json');case=next(c for c in protocol['cases'] if c['id']==pair+'-'+side)
   assert case['source']['sha256']==digest
   samples=[json.loads(l) for l in (loc/'samples.jsonl').read_text().splitlines()]
   own=[s for s in samples if s['case']==case['id']];assert own
   assert all(s['case_identity']['source']['sha256']==digest for s in own)
   hot=[s for s in own if not s['warmup']]
   sessions.append(dict(session=session,side=side,case_id=case['id'],raw_samples=ident(loc/'samples.jsonl'),protocol=ident(loc/'protocol.json'),compiled_source=case['source'],compiled_plan=case['plan'],compiled_elf=case['elf'],count=len(own),hot_count=len(hot),hot_runner_wall_median_ns=statistics.median(s['runner_wall_ns'] for s in hot),measurement_scope='Existing official source-SHA matched samples only; no new device execution'))
  actual[digest]=sessions
 archive={r['candidate_id']:r for r in search['archive']};legal=[]
 for row in search['archive']:
  assert row['score'] is None
  if row['status'] not in ['uncalibrated','passed']:continue
  assert row['status']=='uncalibrated'
  cid=row['candidate_id'];folder=d/'search/candidates'/cid;source=folder/'taskflow.mlir';assert ident(source)['sha256']==cid
  if row['parent']:assert row['action_chain']==archive[row['parent']]['action_chain']+[row['action']]
  mapping=read(folder/'mapping-result.json');plan=mapping['best_plan'];graph=read(folder/'program-graph.json')
  assert plan['estimated_ms'] is None and graph==plan['program_graph'] and graph['id']==row['program_graph_id']
  q=d/'queries'/cid;q.mkdir(parents=True)
  # A standalone same-source recheck exists even if paired same-implementation
  # guards reject feature collection before the CLI can emit its cost directory.
  p=run(q,'recheck',[CORE,source,'--generic-map','--target-config='+str(CONFIG),'--mapping-output='+str(q/'rechecked-plan.json')]);assert p.returncode==0,p.stderr
  checked=read(q/'rechecked-plan.json');assert checked['program_graph']==graph
  p=run(q,'contrast',[CONTRAST,baseline,'--candidate='+str(source),'--baseline-config='+str(CONFIG),'--candidate-config='+str(CONFIG),'--cost-model='+str(MODEL),'--target-binding='+str(TARGET),'--output='+str(q/'provider')])
  if p.returncode==0:
   cost=read(q/'provider/cost.json');facts=read(q/'provider/facts.json');export=read(q/'provider/candidate-plan.json')
   assert export['program_graph']==graph and facts['candidate']['graph_id']==graph['id']
   assert cost['baseline_duration_ns'] is None and cost['candidate_duration_ns'] is None
   prediction=dict(status=cost['status'],reason=cost['reason'],delta_ns=cost['candidate_minus_baseline_ns'],lower_delta_ns=cost['lower_delta_ns'],upper_delta_ns=cost['upper_delta_ns'],cost=ident(q/'provider/cost.json'),facts=ident(q/'provider/facts.json'))
  else:
   # This is an invocation rejection, not a fabricated provider output/cost.
   prediction=dict(status='query-rejected-not-applicable',reason=p.stderr.strip(),delta_ns=None,lower_delta_ns=None,upper_delta_ns=None,provider_cost=None,stderr=ident(q/'contrast.stderr'))
  result=dict(pair_id=pair,candidate_id=cid,parent=row['parent'],round=row['round'],actions=row['action_chain'],status=row['status'],absolute_score=None,source=ident(source),graph=ident(folder/'program-graph.json'),graph_id=graph['id'],plan_id=plan['plan_id'],strategy=plan['strategy'],choice=plan['program_mapping_choices'],tile_sizes=plan['tile_sizes'],dma_bytes=plan['actual_dma_bytes'],local_bytes=plan['resident_bytes'],prediction=prediction,actual=actual.get(cid,[]),graph_identity_rechecked=True)
  rows.append(result);legal.append(result)
 for side in ['baseline','candidate']:assert any(r['candidate_id']==item[side]['source']['sha256'] for r in legal),pair+' official '+side+' missing from archive'
 # Representative combinations chosen solely from action structure and scalar
 # legality, not from performance or predicted delta.
 combinations=[r for r in legal if len(r['actions'])==2 and any(a.startswith('auto_tiles_') for a in r['actions']) and all(not a.startswith('auto_implementation_') for a in r['actions'])]
 combinations.sort(key=lambda r:(not any(a.startswith('mapping_') for a in r['actions']),r['candidate_id']))
 if combinations:
  r=combinations[0];selected.append(dict(pair_id=pair,plain_fixture=item['prepared'],candidate_source=r['source'],candidate_id=r['candidate_id'],graph_id=r['graph_id'],actions=r['actions'],plan_id=r['plan_id'],selection='structural two-action scalar representative; no measured or predicted performance selection',compile_only=True,device_submissions=0))
 programs.append(dict(pair_id=pair,search=ident(d/'search/search.json'),automatic_proposals=ident(d/'search/automatic-proposals.json'),archive_count=len(search['archive']),legal_count=len(legal),rounds=2,ranking=search['ranking'],attempts=search['attempts']))
 print(pair,len(legal),'legal,',sum(r['prediction']['delta_ns'] is not None for r in legal),'conditional deltas',flush=True)
checks=[]
for row in rows:
 if row['actual']:
  graph=read(row['graph']['path'])
  for actual in row['actual']:
   compiled=read(actual['compiled_plan']['path']);assert compiled['program_graph']==graph
   checks.append(dict(pair=row['pair_id'],source_sha=row['candidate_id'],session=actual['session'],side=actual['side'],graph_id=row['graph_id'],compiled_graph_id=compiled['program_graph_id'],raw=actual['raw_samples'],match='Exact source SHA and full compiled ProgramGraph JSON equal automatic archive graph'))
 if row['prediction']['delta_ns'] is not None:
  frozen=read(ROOT/'freeze-r2'/row['pair_id']/'cost.json');assert frozen['candidate_minus_baseline_ns']==row['prediction']['delta_ns'];checks.append(dict(pair=row['pair_id'],cost_match=True,delta_ns=row['prediction']['delta_ns']))
write(OUT/'formal-identity-audit.json',dict(status='passed',checks=checks,device_submissions=0,performance_search=False))
write(OUT/'rows.json',rows);write(OUT/'representatives.json',dict(cases=selected,selection='Source/action structure only; no new hardware measurements'))
with (OUT/'table.csv').open('w',newline='') as f:
 w=csv.writer(f);w.writerow(['pair','candidate','round','actions','strategy','policy','tile','graph','dma_bytes','local_bytes','absolute_score','contrast_status','conditional_delta_ns','reason','actual_source_matched_sessions'])
 for r in rows:w.writerow([r['pair_id'],r['candidate_id'],r['round'],' -> '.join(r['actions']),r['strategy'],r['choice']['residency'],r['tile_sizes'],r['graph_id'],r['dma_bytes'],r['local_bytes'],'unknown',r['prediction']['status'],r['prediction']['delta_ns'],r['prediction']['reason'],'; '.join(x['session']+':'+x['side']+':median='+str(x['hot_runner_wall_median_ns'])+':raw='+x['raw_samples']['path'] for x in r['actual'])])
lines=['This is a two-round UNPRICED diagnostic of the original C++ generator, not a performance search. All absolute scores remain unknown; ranking is empty. Conditional contrasts never enter original search scores. Existing official measurements are joined only by exact source SHA; unmeasured plans are labelled unmeasured.\n','| Program | Source prefix | Round | Actions | Copy realization | Conditional delta ns | Coverage | Existing actual |','| --- | --- | --- | --- | --- | --- | --- | --- |']
for r in rows:
 pred=r['prediction'];value=str(pred['delta_ns']) if pred['delta_ns'] is not None else 'unknown';act=', '.join(x['session']+'/'+x['side']+': '+str(x['hot_runner_wall_median_ns']) for x in r['actual']) or 'unmeasured';reason=pred['reason'].replace('|','/').replace('\n',' ')
 lines.append('| '+ ' | '.join([r['pair_id'],r['candidate_id'][:12],str(r['round']),' → '.join(r['actions']) or 'identity',r['choice']['residency'],value,pred['status']+': '+reason,act])+' |')
(OUT/'TABLE.md').write_text('\n'.join(lines)+'\n')
after={p:ident(p)['sha256'] for p in inputs};write(OUT/'input-identities-after.json',after);assert inputs==after,'Frozen input/tool bytes changed'
write(OUT/'summary.json',dict(status='passed',programs=programs,legal_candidate_count=len(rows),conditional_delta_count=sum(r['prediction']['delta_ns'] is not None for r in rows),actual_source_matched_candidates=sum(bool(r['actual']) for r in rows),all_absolute_scores_unknown=True,performance_search=False,ranking=[],device_submissions=0,frozen_inputs_unchanged=True))
