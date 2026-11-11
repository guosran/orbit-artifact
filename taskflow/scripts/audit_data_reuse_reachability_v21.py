#!/usr/bin/env python3
"""Read-only finite predicate audit; no IR, groups, tiles, costs or search decisions."""
import argparse
import collections
import hashlib
import json
import math
from pathlib import Path

POLICIES=('strong-reuse-first','strong-tile-first','alternating','joint')

def read(path):return json.loads(Path(path).read_text())
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def facts(proposal):
    c=proposal['requested_configuration']
    groups=frozenset((tuple(g['tasks']),tuple(g['retained_storages'])) for g in c.get('residency_groups',[]))
    return {'candidate_id':proposal['candidate_id'],'configuration_id':proposal['configuration_id'],
            'organization':groups,'tile':tuple(c['tile_sizes'])}
def witnesses(pool,anchor):
    selected={}
    for candidate in pool.values():
        org=candidate['organization'];old=selected.get(org)
        if old is None or (candidate['tile']==anchor and old['tile']!=anchor) or (
            old['tile']!=anchor and (math.prod(candidate['tile']),candidate['tile'])>(math.prod(old['tile']),old['tile'])):
            selected[org]=candidate
    return {org:c['candidate_id'] for org,c in selected.items()}
def predicate(policy,round,parent,candidate,witness,stage_rounds):
    if policy=='strong-reuse-first':
        return candidate['candidate_id']==witness[candidate['organization']] if round<=stage_rounds else candidate['organization']==parent['organization']
    if policy=='strong-tile-first':return not candidate['organization'] if round<=stage_rounds else candidate['tile']==parent['tile']
    if policy=='alternating':return candidate['tile']==parent['tile'] if round%2 else candidate['organization']==parent['organization']
    if policy=='joint':return max(len(parent['organization']-candidate['organization']),len(candidate['organization']-parent['organization']))<=1
    if policy=='catalogue':return True
    raise ValueError(policy)
def stage(policy,round,n):
    if policy=='strong-reuse-first':return 'reuse' if round<=n else 'tile-frozen-organization'
    if policy=='strong-tile-first':return 'tile' if round<=n else 'reuse-frozen-tile'
    if policy=='alternating':return 'reuse-frozen-tile' if round%2 else 'tile-frozen-organization'
    return policy

def global_boolean(pool,baseline,rounds,stage_rounds):
    """Feasibility-only reachability over existing legal nodes; never optimize."""
    anchor=pool[baseline]['tile'];witness=witnesses(pool,anchor);result={}
    for policy in POLICIES:
        reached={baseline};layers=[];first={baseline:0};paths={baseline:[{'candidate_id':baseline,'round':0}]}
        for round in range(1,rounds+1):
            parents=set(reached);next_layer=set(parents)
            for cid,candidate in pool.items():
                if cid in next_layer:continue
                parent=next((p for p in sorted(parents) if predicate(policy,round,pool[p],candidate,witness,stage_rounds)),None)
                if parent is not None:
                    next_layer.add(cid);first.setdefault(cid,round);paths.setdefault(cid,paths[parent]+[{'candidate_id':cid,'round':round}])
            layers.append({'round':round,'stage':stage(policy,round,stage_rounds),
                'reachable_with_unrestricted_choices_and_carry':len(next_layer),
                'newly_reachable':sorted(next_layer-reached)})
            reached=next_layer
        result[policy]={'domain_count':len(pool),'reachable_by_final_round':len(reached),
            'unreachable_candidate_ids':sorted(set(pool)-reached),
            'layers':layers,'minimum_round_distribution':dict(sorted(collections.Counter(first.values()).items())),
            'witness_paths':paths,
            'interpretation':'Predicate-derived Boolean diagnostic only: all witness nodes already exist in the C++ legal catalogue; ignores scores, beam width, action ordering and budgets. No new materialization/planning/pricing.'}
    return result

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--matrix',type=Path,action='append',required=True)
    p.add_argument('--output',type=Path,required=True)
    a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
    runs=[];global_pools={};pool_identities={};edge_checks=0;shared_pool_comparisons=0
    for matrix in a.matrix:
        for receipt_path in sorted(matrix.glob('*/run.json')):
            receipt=read(receipt_path);condition=receipt['condition']
            if condition.get('historical') or condition['strategy'] not in POLICIES+('catalogue',):continue
            assert receipt['returncode']==0,receipt_path
            root=Path(receipt['search_directory']);report=read(root/'search.json')
            catalogue=read(root/'catalogue.json');proposals=catalogue['proposals']
            pool={x['candidate_id']:facts(x) for x in proposals};ids=set(pool)
            assert len(pool)==len(proposals)
            pool_key=(condition['program'],condition['tile_generator'],catalogue['catalogue_id'])
            full_identity=sorted((x['candidate_id'],x['configuration_id'],json.dumps(x['requested_configuration'],sort_keys=True)) for x in proposals)
            if pool_key in pool_identities:
                assert full_identity==pool_identities[pool_key],('shared catalogue differs',root,pool_key)
                shared_pool_comparisons+=1
            else:pool_identities[pool_key]=full_identity
            rows={x['search_key']:x for x in report['archive']}
            baseline=next(x['search_key'] for x in report['archive'] if not x['parent'])
            config=read(receipt_path.parent/'config.json');auto=config['native_auto_candidates'];n=auto['stage_rounds']
            rounds=len(report['selections']);policy=condition['strategy']
            if baseline not in pool:
                # A deadline can expire before the baseline is admitted by the
                # construction pass. Do not fabricate a common-domain proof.
                runs.append({'condition':condition,'search_directory':str(root),
                    'catalogue_id':catalogue['catalogue_id'],'catalogue_complete':catalogue['catalogue_complete'],
                    'audit_scope':'baseline absent from stopped admitted catalogue; no reachability assertion',
                    'domain_count':len(pool),'selections':rounds})
                continue
            anchor=pool[baseline]['tile'];witness=witnesses(pool,anchor)
            generated=read(root/'automatic-proposals.json')['parents'];by_round=collections.defaultdict(dict)
            actual_exclusions={}
            for entries in generated.values():
                if not entries:continue
                parent=entries[0]['parent'];round=entries[0]['round']
                assert parent in rows and parent in pool
                previous={baseline} if round==1 else {x['search_key'] for x in report['selections'][round-2]['selected']}
                assert parent in previous
                assert {e['candidate_id'] for e in entries}==ids and len(entries)==len(ids)
                for entry in entries:
                    cid=entry['candidate_id'];expected=predicate(policy,round,pool[parent],pool[cid],witness,n)
                    assert entry['admitted']==expected,(root,parent,round,cid)
                    assert entry['stage']==stage(policy,round,n)
                    edge_checks+=1
                    if not expected:actual_exclusions[(parent,round,cid)]=(entry['configuration_id'],entry['reason'],entry['stage'])
                by_round[round][parent]=entries
            exported=read(root/'strategy-exclusions.json')['exclusions']
            explicit={(e['parent'],e['round'],e['candidate_id']):(e['configuration_id'],e['reason'],e['stage']) for e in exported}
            assert len(explicit)==len(exported) and explicit==actual_exclusions
            phases=[];union_generated=set();union_selected=set();union_attempted=set();union_queried=set()
            for selection in report['selections']:
                round=selection['round'];parents={baseline} if round==1 else {e['search_key'] for e in report['selections'][round-2]['selected']}
                assert parents<=set(rows) and parents<=ids
                selected_admitted={cid for parent in parents for cid,c in pool.items() if predicate(policy,round,pool[parent],c,witness,n)}
                cpp_admitted={e['candidate_id'] for es in by_round[round].values() for e in es if e['admitted']}
                prefix=selection['proposal_prefix'];attempted={e['candidate_id'] for e in prefix if 'candidate_id' in e}
                newly={e['candidate_id'] for e in prefix if e['status']=='archived'}
                duplicates={e['candidate_id'] for e in prefix if e['status']=='duplicate'}
                assert attempted<=cpp_admitted and cpp_admitted<=selected_admitted
                assert newly=={x['search_key'] for x in report['archive'] if x['round']==round}
                carry={e['search_key'] for e in selection['selected'] if rows[e['search_key']]['round']<round}
                reasons=collections.Counter(e['reason'] for es in by_round[round].values() for e in es if not e['admitted'])
                phases.append({'round':round,'stage':stage(policy,round,n),
                    'selected_parent_ids':sorted(parents),
                    'parents_with_cpp_action_reports':sorted(by_round[round]),
                    'parents_with_attempted_actions':sorted({e['parent'] for e in prefix}),
                    'predicate_admitted_by_any_actual_selected_parent':sorted(selected_admitted),
                    'cpp_exported_admitted':sorted(cpp_admitted),
                    'excluded_by_policy_at_every_actual_selected_parent':sorted(ids-selected_admitted),
                    'selected_parent_admissions_without_cpp_generated_actions':sorted(selected_admitted-cpp_admitted),
                    'cpp_admitted_not_attempted_in_prefix':sorted(cpp_admitted-attempted),
                    'attempted_candidate_ids':sorted(attempted),'newly_queried_candidate_ids':sorted(newly),
                    'duplicate_candidate_ids':sorted(duplicates),'carried_selected_candidate_ids':sorted(carry),
                    'cpp_parent_edge_exclusion_reasons':dict(reasons),
                    'quota_stop':selection['quota_stop'],'score_query_quota':selection['score_query_quota'],
                    'score_queries':selection['score_queries']})
                union_generated|=cpp_admitted;union_selected|=selected_admitted
                union_attempted|=attempted;union_queried|=newly
            run={'condition':condition,'search_directory':str(root),'search_sha256':sha(root/'search.json'),
                'catalogue_id':catalogue['catalogue_id'],'catalogue_complete':catalogue['catalogue_complete'],
                'domain_count':len(ids),'phases':phases,
                'path_conditional_never_admitted_by_actual_selected_parents':sorted(ids-union_selected),
                'never_in_cpp_generated_admissions':sorted(ids-union_generated),
                'cpp_admitted_but_never_attempted':sorted(union_generated-union_attempted),
                'queried_archive_count':len(report['trace']),
                'interpretation':'Path-conditional exclusions are not proofs of global impossibility. Generated admissions, attempted prefixes, score queries and carried nodes are separate.'}
            runs.append(run)
            if catalogue['catalogue_complete']:
                identity=(condition['program'],condition['tile_generator'],catalogue['catalogue_id'])
                if identity not in global_pools:
                    global_pools[identity]={'program':condition['program'],'tile_generator':condition['tile_generator'],
                        'catalogue_id':catalogue['catalogue_id'],'domain_count':len(ids),
                        'source_catalogue':str(root/'catalogue.json'),'source_sha256':sha(root/'catalogue.json'),
                        'policies':global_boolean(pool,baseline,4,n)}
    result={'status':'PASS','device_submissions':0,'cpp_admission_edges_cross_checked':edge_checks,'exact_shared_pool_comparisons':shared_pool_comparisons,
        'method':'Read-only predicate verification on existing C++ legal catalogue nodes; no new source, tile, grouping, plan, price or optimized selection is generated.',
        'scope':'Complete-domain Boolean reachability ignores beam/scores/budget. Actual selected-path admissions and attempted/scored prefixes are reported separately. A common native materialization catalogue does not imply identical policy one-step edges.',
        'runs':runs,'complete_pool_boolean_diagnostics':list(global_pools.values())}
    (a.output/'report.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'status':'PASS','runs':len(runs),'complete_pools':len(global_pools),'cpp_edges':edge_checks,'shared_pool_comparisons':shared_pool_comparisons}))
if __name__=='__main__':main()
