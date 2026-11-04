#!/usr/bin/env python3
"""CPU orchestration of the native proposal/measured-feedback search driver.

Python records compiler artifacts and aggregates audited hot wall medians only.
It does not implement mapping, legality, cost prediction, or beam selection.
"""
import argparse
import copy
import hashlib
import json
import os
import re
from pathlib import Path
import statistics
import subprocess

ARTIFACT = Path(__file__).resolve().parents[2]
DEFAULT_RESULTS = Path(os.environ.get('ORBIT_RESULTS_ROOT', ARTIFACT/'results/taskflow'))
DEFAULT_TOOL = Path(os.environ.get('ORBIT_BUILD_ROOT', ARTIFACT/'builds/taskflow-v9'))/'core/tools/taskflow-opt/taskflow-opt'
BOUNDARY = 'prepared-command-host-to-host'
PRICE_KEYS = {'direct_air_cost','plan_id','cost_status','cost_provenance',
              'estimated_ms','theoretical_coefficients'}


def write(path, value):
    Path(path).write_text(json.dumps(value, indent=2, sort_keys=True, allow_nan=False)+'\n')


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def bound(descriptor):
    p = Path(descriptor['path']).resolve()
    if sha(p) != descriptor['sha256']:
        raise ValueError(f'bound artifact changed: {p}')
    return p


def run(out, name, command):
    command = list(map(str, command))
    write(out/(name+'.command.json'), command)
    r = subprocess.run(command, text=True, capture_output=True)
    (out/(name+'.stdout')).write_text(r.stdout)
    (out/(name+'.stderr')).write_text(r.stderr)
    write(out/(name+'.exit.json'), {'returncode':r.returncode})
    if r.returncode:
        raise RuntimeError(f'{name} failed: {r.stderr}')


def search(tool, source, config, out, tile_n=64):
    run(out, 'native-search', [tool, source, '--search', '--backend=air',
        '--air-distribute-initialization', '--tile-m=8', f'--tile-n={tile_n}', '--tile-k=32',
        f'--target-config={config}', f'--search-output={out}/search',
        '--max-rounds=2', '--max-candidates=32', '--beam-width=4'])
    return json.loads((out/'search/search.json').read_text())


def proposal(tool, source, out, implementation_proposals=False, scalar_proposals=None):
    source_copy = out/'input.mlir'
    source_copy.write_bytes(source.read_bytes())
    config = {'model_version':'v9-proposal-only-uncalibrated-sensitivity',
        'generic_air':{'capacity_bytes':24576,'theoretical':{'launch_ms':.1,
            'per_scalar_operation_ms':1e-6,'per_transfer_byte_ms':1e-7}},
        'native_air_tile_candidates':[[8,32,32],[8,16,32]],
        'native_mapping_candidates':'discover','search_diversity_slots':1}
    if implementation_proposals:
        config['model_version']='v9-joint-implementation-proposal-only-uncalibrated-sensitivity'
        config['native_air_tile_candidates']=[[8,64,32],[8,32,32],[8,16,32]]
        config['native_implementation_candidates']=[
            {'kind':'scalar-product-vector-add-f32','lanes':8},
            {'kind':'scalar-product-vector-add-f32','lanes':4}]
    write(out/'proposal-config.json',config)
    report = search(tool,source_copy,out/'proposal-config.json',out,32 if implementation_proposals else 64)
    features_config = copy.deepcopy(config)
    features_config['generic_air'].pop('theoretical')
    features_config['generic_air']['cost_model']={'schema':'orbit.direct-air.cost.v1','kind':'features-only'}
    write(out/'features-config.json',features_config)
    rows = {r['candidate_id']:r for r in report['archive']}
    cases, rejected = [], []
    for row in report['archive']:
        cid = row['candidate_id']
        if row['parent'] and row['action_chain'] != rows[row['parent']]['action_chain']+[row['action']]:
            raise ValueError('native parent/action chain inconsistent')
        if row['status'] != 'passed':
            rejected.append({'candidate_id':cid,'status':row['status'],
                             'action_chain':row['action_chain'],'evaluation':row['evaluation']})
            continue
        directory = out/'search/candidates'/cid
        candidate_source = directory/'taskflow.mlir'
        plan_path = directory/'features-plan.json'
        run(out,'features-'+cid,[tool,candidate_source,'--generic-map',
            f'--target-config={out}/features-config.json',f'--mapping-output={plan_path}'])
        plan = json.loads(plan_path.read_text())
        facts = plan['direct_air_cost']['features']
        if plan['direct_air_cost']['status'] != 'uncalibrated' or plan['estimated_ms'] is not None:
            raise ValueError('feature materialization must remain unpriced')
        cases.append({'name':cid,'candidate_id':cid,'parent':row['parent'],'round':row['round'],
            'action':row['action'],'action_chain':row['action_chain'],
            'source':str(candidate_source),'source_sha256':sha(candidate_source),
            'config':str(out/'features-config.json'),'config_sha256':sha(out/'features-config.json'),
            'features_plan':str(plan_path),'features_plan_sha256':sha(plan_path),
            'plan_id':plan['plan_id'],'body_fingerprint':plan['body_fingerprint'],
            'execution_fingerprint':facts['execution_fingerprint'],
            'properties':{'tile_sizes':plan['tile_sizes'],'mapping':plan['program_mapping_choices'],
                'implementations':plan['task_implementations'],'dma_bytes':plan['actual_dma_bytes'],
                'hardware_stage_count':len(plan['hardware_stages']),'payload_bytes':plan['resident_bytes']},
            'proposal_only_uncalibrated_score':row['score'],
            'score_boundary':'uncalibrated source-operation/DMA sensitivity for proposal enumeration only',
            'hardware_executed':False})
    summary={'status':'proposals-ready','legal_candidates':len(cases),
        'rejected':rejected,'native_ranking':report['ranking'],
        'compiler_sha256':sha(tool),'input_sha256':sha(source_copy),
        'search_selection':'native C++ driver; theoretical proposal scores are not calibrated measurements',
        'hardware_executed':False}
    if implementation_proposals:
        def mixed(case):
            return any(i['kind']=='scalar-product-vector-add-f32' and i['lanes']==8
                       for i in case['properties']['implementations'])
        def coordinate(case):
            prop=case['properties'];mapping=prop['mapping']
            if prop['tile_sizes']!=[8,32,32]:return None
            if mapping['data_organization']=='phase-local':return 'phase-local'
            if mapping['storage']==1 and mapping['data_organization']=='retain-across-users':return 'storage1-panel'
            return None
        # Fixed experimental coordinates, not a Python ranking/beam selector.
        selected=[c for c in cases if mixed(c) and coordinate(c)]
        controls=[c for c in cases if not mixed(c) and coordinate(c)]
        if len(selected)!=2 or len(controls)!=2:
            raise ValueError('native search did not expose both prescribed mixed/scalar comparison coordinates')
        if not any('implementation_scalar-product-vector-add-f32_4' in r['action_chain'] and r['status']=='unsupported' for r in rejected):
            raise ValueError('expected four-lane target-unavailable negative absent')
        old={} if scalar_proposals is None else {c['execution_fingerprint']:c for c in json.loads(scalar_proposals.read_text())}
        for control in controls:
            prior=old.get(control['execution_fingerprint'])
            if scalar_proposals and (not prior or prior['source_sha256']!=control['source_sha256']):
                raise ValueError('same-coordinate scalar source/execution bridge failed')
            control['existing_scalar_proposal']=prior
        for case in selected:
            control=next(c for c in controls if coordinate(c)==coordinate(case))
            case['scalar_control_candidate_id']=control['candidate_id']
            case['scalar_control_execution_fingerprint']=control['execution_fingerprint']
            case['experiment_coordinate']=coordinate(case)
        write(out/'all-cases.json',cases)
        write(out/'scalar-controls.json',controls)
        write(out/'selected-four-cases.json',selected+controls)
        summary['root_seed']={'tile_sizes':[8,32,32],'data_organization':'phase-local',
            'reason':'same computation, capacity-enabling N32 seed; mapping plus implementation can compose within two native rounds'}
        summary['compile_cases']=len(selected)
        summary['experimental_selection']='fixed N32 phase-local/storage1-panel mixed8 coordinates; native archive/selection unchanged'
        summary['feedback_proposal_cases']=str(out/'all-cases.json')
        cases=selected
    write(out/'cases.json',cases)
    write(out/'summary.json',summary)
    result={'status':'proposals-ready','cases':str(out/'cases.json'),'legal_candidates':summary['legal_candidates']}
    if implementation_proposals:result['compile_cases']=len(cases)
    return result


def semantic_plan(plan):
    return {k:v for k,v in plan.items() if k not in PRICE_KEYS}


def feedback(tool, manifest_path, out):
    """Manifest schema is documented in --help; every external file SHA-bound."""
    manifest=json.loads(manifest_path.read_text())
    if manifest['schema']!='orbit.profiled-search.feedback.v1' or manifest['boundary']!=BOUNDARY:
        raise ValueError('exact whole-command feedback schema/boundary required')
    proposal_dir=bound(manifest['proposal_summary']).parent
    cases_path=bound(manifest['proposal_cases'])
    if cases_path.parent!=proposal_dir:
        raise ValueError('proposal summary/cases directory mismatch')
    cases={c['candidate_id']:c for c in json.loads(cases_path.read_text())}
    raw_path=bound(manifest['profile_results']);audit_path=bound(manifest['audit']);inv_path=bound(manifest['invocation'])
    raw=json.loads(raw_path.read_text());audit=json.loads(audit_path.read_text());inv=json.loads(inv_path.read_text())
    if audit.get('status')!='passed' or any(s['status']!='passed' for s in raw['results']):
        raise ValueError('entire experiment must be independently audited and numerically passed')
    target=manifest['target']
    if any(not target.get(k) for k in ('id','toolchain','runtime')):
        raise ValueError('explicit target/toolchain/runtime required')
    observed=[];bridges=[];seen=set()
    for entry in manifest['cases']:
        cid=entry['candidate_id'];case=cases[cid];name=entry['profile_name']
        if cid in seen:raise ValueError('duplicate candidate observation')
        seen.add(cid)
        for key in ('source','config','features_plan'):
            if sha(Path(case[key]))!=case[key+'_sha256']:
                raise ValueError('proposal artifact changed')
        source=bound(entry['compiled_source']);air=bound(entry['compiled_air']);plan_path=bound(entry['compiled_plan']);elf=bound(entry['elf']);record_path=bound(entry['compile_record'])
        if sha(source)!=case['source_sha256']:
            raise ValueError('compiled Taskflow differs from native proposal')
        original=json.loads(Path(case['features_plan']).read_text());compiled=json.loads(plan_path.read_text())
        refreshed=out/('rechecked-'+cid+'.json')
        run(out,'recheck-'+cid,[tool,source,'--generic-map',f'--target-config={case["config"]}',f'--mapping-output={refreshed}'])
        current=json.loads(refreshed.read_text())
        if current['direct_air_cost']['features']['execution_fingerprint']!=case['execution_fingerprint'] or semantic_plan(current)!=semantic_plan(original):
            raise ValueError('current native checker execution differs from proposal identity')
        if semantic_plan(original)!=semantic_plan(compiled):
            raise ValueError('compiled plan semantics differ from native feature plan')
        air_text=air.read_text()
        for attr,value in [('orbit.mapping_plan',compiled['plan_id']),('orbit.source_fingerprint',compiled['body_fingerprint'])]:
            if set(re.findall(re.escape(attr)+r'\s*=\s*"([^"]+)"',air_text))!={value}:
                raise ValueError('compiled AIR mapping/source identity differs from checked plan')
        record=json.loads(record_path.read_text())
        if record.get('status')!='compiled' or record['elf_sha256']!=sha(elf) or record['source_sha256']!=sha(air):
            raise ValueError('compiled AIR/ELF identity bridge failed')
        identity=inv['identities'][name]
        if identity['elf_sha256']!=sha(elf) or identity['compile_record']['source_sha256']!=sha(air):
            raise ValueError('profile invocation executed another AIR/ELF package')
        if not any(c.get('candidate')==name and c.get('passed') for c in audit.get('checks',[])):
            raise ValueError('candidate absent from independent output audit')
        hot=[]
        for seed in raw['results']:
            for sample in seed['samples']:
                if not all(v['passed'] and v['finite'] for v in sample['checks'].values()):
                    raise ValueError('numerical failure in experiment')
                if sample['candidate']==name and not sample['warmup']:
                    hot.append(sample['wall_ms'])
        if not hot or any(isinstance(v,bool) or not isinstance(v,(int,float)) or not 0<v<float('inf') for v in hot):
            raise ValueError('positive finite audited hot wall samples required')
        observed.append({'execution_fingerprint':case['execution_fingerprint'],
            'median_ms':statistics.median(hot),'sample_count':len(hot),'target':target,'boundary':BOUNDARY})
        bridges.append({'candidate_id':cid,'profile_name':name,'compiled_artifacts':entry,
            'execution_fingerprint':case['execution_fingerprint'],'source_sha256':sha(source),
            'air_sha256':sha(air),'elf_sha256':sha(elf),'compiled_plan_sha256':sha(plan_path),
            'scope':'exact source bytes + full price-stripped plan JSON equality + compile AIR/ELF and invocation ELF hashes'})
    raw_manifest={'schema':'orbit.observed-command.raw.v1','feedback_manifest_sha256':sha(manifest_path),
        'profile_results_sha256':sha(raw_path),'audit_sha256':sha(audit_path),'invocation_sha256':sha(inv_path),
        'bridges':bridges,'label':'hot host wall median; observed complete command, not prediction'}
    write(out/'observed-raw-manifest.json',raw_manifest)
    for row in observed:row['raw_manifest_sha256']=sha(out/'observed-raw-manifest.json')
    model={'schema':'orbit.direct-air.cost.v1','kind':'observed-table','model_id':'profiled-native-search-v9',
        'model_version':sha(manifest_path),'target':target,'boundary':BOUNDARY,'rows':observed}
    write(out/'observed-model.json',model)
    config=json.loads((proposal_dir/'proposal-config.json').read_text())
    config['generic_air'].pop('theoretical')
    config['model_version']='v9-exact-observed-native-search'
    config['generic_air']['cost_model']=model
    config['generic_air']['cost_target']=dict(target,boundary=BOUNDARY)
    write(out/'observed-config.json',config)
    source=proposal_dir/'input.mlir'
    seed=json.loads((proposal_dir/'summary.json').read_text()).get('root_seed',{}).get('tile_sizes',[8,64,32])
    report=search(tool,source,out/'observed-config.json',out,seed[1])
    write(out/'summary.json',{'status':'native-measured-search-complete','observed_rows':len(observed),
        'model_sha256':sha(out/'observed-model.json'),'ranking':report['ranking'],
        'compiler_sha256':sha(tool),'hardware_executed_by_this_script':False,
        'cost':'exact observed whole-command feedback; unmatched executions remain null'})
    return {'status':'native-measured-search-complete','observed_rows':len(observed)}


def main():
    p=argparse.ArgumentParser(description=__doc__,epilog='Feedback manifest: schema orbit.profiled-search.feedback.v1; boundary; target; SHA-bound {path,sha256} proposal_summary/proposal_cases/profile_results/audit/invocation; cases[{candidate_id,profile_name,compiled_source,compiled_air,compiled_plan,elf,compile_record}], each compiled artifact also {path,sha256}.')
    p.add_argument('--tool',type=Path,default=DEFAULT_TOOL)
    p.add_argument('--source',type=Path,help='explicit computation-only Taskflow source, required when proposing; generated by the reproduction entry')
    p.add_argument('--implementation-proposals',action='store_true',help='N32 seed and native mixed8/mixed4 implementation actions; emit two mixed compile cases plus scalar control bridges')
    p.add_argument('--scalar-proposals',type=Path,help='existing scalar cases.json for exact source/execution-key control bridges')
    p.add_argument('--profile',type=Path,help='audited, SHA-bound feedback manifest; rerun native search with observed table')
    p.add_argument('--output',type=Path,required=True)
    args=p.parse_args()
    if not args.profile and not args.source:
        p.error('--source is required for proposal generation; use a freshly generated Taskflow input')
    out=args.output.resolve();out.mkdir(parents=True,exist_ok=False)
    (out/'orchestrator.py').write_bytes(Path(__file__).read_bytes())
    write(out/'orchestration.json',{'argv':os.sys.argv,'script_sha256':sha(Path(__file__)),
        'tool':str(args.tool.resolve()),'tool_sha256':sha(args.tool),'NPU_execution':False})
    print(json.dumps(feedback(args.tool.resolve(),args.profile.resolve(),out) if args.profile else proposal(args.tool.resolve(),args.source.resolve(),out,args.implementation_proposals,args.scalar_proposals)))


if __name__=='__main__':main()
