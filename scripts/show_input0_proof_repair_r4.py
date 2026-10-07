#!/usr/bin/env python3
"""Read the fresh input0 Task6-proof-repair cohort without mixing older results."""
from pathlib import Path
import importlib.util
import json
R=Path(__file__).resolve().parents[1]
STAGES=('shape-temporal','shape-temporal-replica','shape-temporal-replica-tiling','full-joint')
MAIN='input0-neighborhood-2x2-v59-inplace-proof-r4';RAY='input0-ray-fission-2x2-v59-inplace-proof-r4';BASE='input0-all-unit-2x2-v59-inplace-proof-r4'
R5_STATE_SCHEMA='orbit-input0-memory-fusion-fission-runtime-v1'
R5_COHORT='input0-neighborhood-2x2-v60-memory-fusion-fission-r5-20261006'
R5_BASE='input0-all-unit-2x2-v60-memory-fusion-fission-r5-20261006'
R5_WORKLOADS=('llama','lu','harris','radar','gcn','raytracing')
R5_RUNTIME='/tmp/orbit-input0-v60-memory-fusion-fission-r5-20261006/runtime-frozen-r2'
R5_RESULTS_ROOT=f'/tmp/orbit-input0-v60-memory-fusion-fission-r5-20261006/results-original-ray-v2/{R5_COHORT}'
R9_STATE_SCHEMA='orbit-input0-memory-fusion-fission-runtime-v1'
R9_COHORT=R5_COHORT
R9_CONFIG='input0-chain-original-ray-ii23-r9-queue-v2.json'
R9_PROTOCOL='protocol-bound-original-ray-ii23-r9-queue-v2.json'
R9_RAY_PROTOCOL='protocol-bound-original-ray-ii23-r9-queue-v2-ray.json'
R9_RUNTIME='/tmp/orbit-input0-v60-memory-fusion-fission-r5-20261006/runtime-frozen-r6'
R9_RESULTS_ROOT=f'/tmp/orbit-input0-v60-memory-fusion-fission-r5-20261006/results-original-ray-v6/{R9_COHORT}'
R9_OPT_REL='.work/control-variables-and-tiling-20261006/mlir-amoeba-opt-memory-fusion-fission-r9-original-ray-ii23-stable-features-20261006'
R9_CONTRACT_REL='.work/control-variables-and-tiling-20261006/source-model-contract-memory-fusion-fission-r9-original-ray-ii23-stable-features-queue-v2-20261006.json'
R9_ACCEPTANCE_REL='.work/control-variables-and-tiling-20261006/memory-fusion-fission-r9-queue-v2-native-acceptance-20261006.json'
def read(p):
 try:
  x=json.loads(p.read_text());return x if isinstance(x,dict) else {}
 except (OSError,ValueError):return {}
def accepted_stage(p,state):
 x=read(p/'result.json');b=read(p/'source-binding.json')
 if (x.get('status')!='native_replayed' or x.get('numeric')!='pass' or b.get('optimizer')!=state.get('optimizer') or b.get('source_contract_file')!=state.get('source_contract') or b.get('stage_initialization')!='independent'):return '—'
 v=x.get('actual_stage_cycles');return f'{v:,}' if isinstance(v,int) and v>0 else '—'
def plain_path(p,kind):
 try:
  p=Path(p)
  if not p.is_absolute():return False
  current=Path(p.anchor)
  for part in p.parts[1:]:
   current=current/part
   if current.is_symlink():return False
  return p.is_dir() if kind=='dir' else p.is_file()
 except (OSError,TypeError,ValueError):return False
def same_bytes(a,b):
 try:
  if not plain_path(a,'file') or not plain_path(b,'file') or Path(a).stat().st_size!=Path(b).stat().st_size:return False
  with Path(a).open('rb') as left,Path(b).open('rb') as right:
   while True:
    x=left.read(1024*1024);y=right.read(1024*1024)
    if x!=y:return False
    if not x:return True
 except OSError:return False
def r5_original_input_bound(state):
 if state.get('schema')!=R5_STATE_SCHEMA or state.get('cohort_id')!=R5_COHORT:return False
 config_value=state.get('config');protocol_value=state.get('protocol')
 contract_value=state.get('source_contract');optimizer_value=state.get('optimizer')
 if not all(isinstance(x,str) and x for x in (config_value,protocol_value,contract_value,optimizer_value)):return False
 config_path=Path(config_value)
 if (config_path.name!='input0-chain-original-v2.json' or
     config_path.parent.name!=R5_COHORT or config_path.parent.parent.name!='.work'):return False
 artifact_root=config_path.parents[2]
 runtime=Path(R5_RUNTIME)
 if (Path(protocol_value)!=config_path.parent/'protocol-bound-original-v2.json' or
     Path(contract_value)!=runtime/'.work/control-variables-and-tiling-20261006/source-model-contract-memory-fusion-fission-r5-queue-v2-20261006.json' or
     Path(optimizer_value)!=runtime/'.work/control-variables-and-tiling-20261006/mlir-amoeba-opt-memory-fusion-fission-r5-20261006' or
     state.get('runtime_root')!=R5_RUNTIME or
     state.get('results_root')!=R5_RESULTS_ROOT or
     Path(state.get('accepted_source_contract',''))!=artifact_root/'.work/control-variables-and-tiling-20261006/source-model-contract-memory-fusion-fission-r5-queue-v2-20261006.json' or
     Path(state.get('accepted_optimizer',''))!=artifact_root/'.work/control-variables-and-tiling-20261006/mlir-amoeba-opt-memory-fusion-fission-r5-20261006' or
     not same_bytes(optimizer_value,state.get('accepted_optimizer')) or
     not same_bytes(contract_value,state.get('accepted_source_contract'))):return False
 config=read(config_path);entry=config.get('workloads',{}).get('raytracing',{})
 canonical=entry.get('canonical') if isinstance(entry,dict) else None
 expected=artifact_root/'.work/input0-neighborhood-2x2-v59-inplace-proof-r4/source-domain-prep/raytracing/canonical.mlir'
 return isinstance(canonical,str) and Path(canonical)==expected and plain_path(expected,'file')
def r5_legacy_supplement_profile(state):
 if state.get('schema')!=R5_STATE_SCHEMA or state.get('cohort_id')!=R5_COHORT:return None
 config_value=state.get('config');protocol_value=state.get('protocol')
 contract_value=state.get('source_contract');optimizer_value=state.get('optimizer')
 if not all(isinstance(x,str) and x for x in (config_value,protocol_value,contract_value,optimizer_value)):return None
 config_path=Path(config_value)
 if (config_path.name!='input0-chain.json' or config_path.parent.name!=R5_COHORT or
     config_path.parent.parent.name!='.work'):return None
 artifact_root=config_path.parents[2]
 runtime=config_path.parent/'runtime-frozen-r1'
 results=f'/tmp/orbit-input0-v60-memory-fusion-fission-r5-20261006/results/{R5_COHORT}'
 expected_contract=runtime/'.work/control-variables-and-tiling-20261006/source-model-contract-memory-fusion-fission-r5-20261006.json'
 expected_optimizer=runtime/'.work/control-variables-and-tiling-20261006/mlir-amoeba-opt-memory-fusion-fission-r5-20261006'
 if (Path(protocol_value)!=config_path.parent/'protocol-bound.json' or Path(contract_value)!=expected_contract or
     Path(optimizer_value)!=expected_optimizer or state.get('runtime_root')!=str(runtime) or
     state.get('results_root')!=results or not same_bytes(optimizer_value,state.get('accepted_optimizer')) or
     not same_bytes(contract_value,state.get('accepted_source_contract'))):return None
 config=read(config_path);entry=config.get('workloads',{}).get('raytracing',{})
 canonical=entry.get('canonical') if isinstance(entry,dict) else None
 expected=artifact_root/'.work/input0-ray-fission-2x2-v59-inplace-proof-r4/source-domain-prep/raytracing/canonical.mlir'
 architecture=runtime/'config/architectures/amoeba_4x4_cgra_2x2_context6.yaml'
 public_architecture=artifact_root/'config/architectures/amoeba_4x4_cgra_2x2_context6.yaml'
 if (not isinstance(canonical,str) or Path(canonical)!=expected or not plain_path(expected,'file') or
     not same_bytes(architecture,public_architecture)):return None
 return {'config_path':config_path,'runtime':runtime,'results_root':results,
         'architecture':architecture,'legacy_supplement':True}
def accepted_r5_fixed1x1(workload,state):
 if (state.get('schema')!=R5_STATE_SCHEMA or state.get('cohort_id')!=R5_COHORT or
     workload not in R5_WORKLOADS):return '—'
 optimizer=state.get('optimizer');contract=state.get('source_contract')
 if not isinstance(optimizer,str) or not isinstance(contract,str):return '—'
 if not same_bytes(optimizer,state.get('accepted_optimizer')) or not same_bytes(contract,state.get('accepted_source_contract')):return '—'
 current_profile=None
 if r5_original_input_bound(state):
  config_path=Path(state['config']);runtime=Path(state['runtime_root'])
  current_profile={'config_path':config_path,'runtime':runtime,'results_root':R5_RESULTS_ROOT,
                   'architecture':Path(state['architecture']),'legacy_supplement':False}
 else:current_profile=r5_legacy_supplement_profile(state)
 if current_profile is None:return '—'
 config_path=current_profile['config_path'];runtime=current_profile['runtime']
 artifact_root=config_path.parents[2]
 root_value=state.get('fixed1x1_results_root')
 if not isinstance(root_value,str):return '—'
 root=Path(root_value)
 if (not root.is_absolute() or root.parts[:2]!=('/','tmp') or root.name!=R5_BASE or
     not plain_path(root,'dir')):return '—'
 if (str(root.parent.parent.parent)!=current_profile['results_root'] or
     state.get('results_root')!=current_profile['results_root']):return '—'
 if not plain_path(root/'summary.json','file'):return '—'
 try:summary=json.loads((root/'summary.json').read_text())
 except (OSError,ValueError):return '—'
 if not isinstance(summary,list):return '—'
 summary_by_name={}
 for row in summary:
  if not isinstance(row,dict) or row.get('workload') not in R5_WORKLOADS or row['workload'] in summary_by_name:return '—'
  summary_by_name[row['workload']]=row
 if set(summary_by_name)!=set(R5_WORKLOADS) or summary_by_name[workload].get('status')!='complete':return '—'
 fixed=state.get('fixed1x1')
 fixed_workloads=fixed.get('workloads',{}) if isinstance(fixed,dict) else {}
 state_workloads=state.get('workloads',{})
 if not isinstance(fixed_workloads,dict) or not isinstance(state_workloads,dict):return '—'
 saved=fixed_workloads.get(workload,{})
 workload_state=state_workloads.get(workload,{})
 if not isinstance(saved,dict) or not isinstance(workload_state,dict):return '—'
 result_path=root/workload/'result.json'
 if not plain_path(result_path,'file'):return '—'
 if (saved.get('status')=='complete' and saved.get('result')!=str(result_path)) or (
     workload_state.get('baseline_status')=='complete' and
     workload_state.get('baseline_result')!=str(result_path)):return '—'
 result=read(result_path);commands=result.get('commands',{})
 if not isinstance(commands,dict):return '—'
 materialize=commands.get('materialize',{});mapper=commands.get('mapper',{})
 native=commands.get('native',{});numeric=commands.get('numeric',{})
 cycles=result.get('baseline_cycles')
 architecture=str(current_profile['architecture'])
 if current_profile['legacy_supplement']:
  if not same_bytes(architecture,artifact_root/'config/architectures/amoeba_4x4_cgra_2x2_context6.yaml'):return '—'
 else:
  frozen_architecture=state.get('frozen_architecture')
  if (not isinstance(frozen_architecture,str) or
      Path(architecture)!=artifact_root/'config/architectures/amoeba_4x4_cgra_2x2_context6.yaml' or
      Path(frozen_architecture)!=Path(runtime)/'config/architectures/amoeba_4x4_cgra_2x2_context6.yaml' or
      state.get('architecture_bytes_match_frozen') is not True or
      not same_bytes(architecture,frozen_architecture)):return '—'
 expected={'optimizer':optimizer,'source_contract':contract,'protocol':state.get('protocol'),
           'architecture':architecture,
           'inter_task_network':str(Path(runtime)/'config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml')}
 if any(result.get(key)!=value for key,value in expected.items()):return '—'
 network=Path(expected['inter_task_network'])
 try:
  if result.get('inter_task_network_text')!=network.read_text():return '—'
 except OSError:return '—'
 config=read(config_path);entry=config.get('workloads',{}).get(workload,{})
 source=entry.get('canonical') if isinstance(entry,dict) else None
 if not isinstance(source,str):return '—'
 source_path=Path(source)
 if not source_path.is_absolute():source_path=config_path.parent/source_path
 canonical_copy=root/workload/'canonical-input.mlir'
 if (result.get('workload')!=workload or result.get('status')!='complete' or result.get('numeric')!='pass' or
     result.get('independent_trace')!='pass' or result.get('mapper_equality')!='pass' or
     result.get('canonical_input')!=str(canonical_copy) or not same_bytes(source_path,canonical_copy) or
     not all(isinstance(command,dict) and command.get('status')=='finished' and command.get('exit_code')==0
             for command in (materialize,mapper,native,numeric)) or
     not isinstance(cycles,int) or isinstance(cycles,bool) or cycles<=0 or
     (isinstance(saved.get('baseline_cycles'),int) and saved.get('baseline_cycles')!=cycles) or
     (isinstance(workload_state.get('baseline_cycles'),int) and
      workload_state.get('baseline_cycles')!=cycles) or
     summary_by_name[workload].get('baseline_cycles')!=cycles):return '—'
 for key in ('status','baseline_cycles','optimizer','source_contract','protocol','architecture',
             'inter_task_network','canonical_input'):
  if summary_by_name[workload].get(key)!=result.get(key):return '—'
 return f'{cycles:,}'

_QUEUE_VALIDATOR=None
def queue_validator():
 global _QUEUE_VALIDATOR
 if _QUEUE_VALIDATOR is None:
  spec=importlib.util.spec_from_file_location('r9_queue_receipt_validator',R/'scripts/run_input0_memory_fusion_fission_queue.py')
  if spec is None or spec.loader is None:return None
  _QUEUE_VALIDATOR=importlib.util.module_from_spec(spec);spec.loader.exec_module(_QUEUE_VALIDATOR)
 return _QUEUE_VALIDATOR

def r9_profile(state):
 if (state.get('schema')!=R9_STATE_SCHEMA or state.get('cohort_id')!=R9_COHORT or
     state.get('runtime_root')!=R9_RUNTIME or state.get('results_root')!=R9_RESULTS_ROOT):return None
 config_path=R/'.work'/R9_COHORT/R9_CONFIG
 protocol_path=R/'.work'/R9_COHORT/R9_PROTOCOL
 optimizer=Path(R9_RUNTIME)/R9_OPT_REL;contract=Path(R9_RUNTIME)/R9_CONTRACT_REL
 accepted_optimizer=R/R9_OPT_REL;accepted_contract=R/R9_CONTRACT_REL
 marker_path=R/R9_ACCEPTANCE_REL
 if (Path(state.get('config',''))!=config_path or Path(state.get('protocol',''))!=protocol_path or
     Path(state.get('optimizer',''))!=optimizer or Path(state.get('source_contract',''))!=contract or
     Path(state.get('accepted_optimizer',''))!=accepted_optimizer or
     Path(state.get('accepted_source_contract',''))!=accepted_contract or
     Path(state.get('acceptance_marker',''))!=marker_path or
     not same_bytes(optimizer,accepted_optimizer) or not same_bytes(contract,accepted_contract)):
  return None
 marker=read(marker_path)
 if (marker.get('schema')!='orbit-memory-fusion-fission-native-acceptance-v1' or
     marker.get('status')!='accepted' or marker.get('optimizer')!=str(accepted_optimizer) or
     marker.get('source_contract')!=str(accepted_contract) or
     marker.get('protocol')!=str(protocol_path) or marker.get('config')!=str(config_path) or
     any(marker.get(key) is not True for key in (
      'canonical_lowering_verified','census_complete',
      'native_source_fusion_and_fission_verified','fixtures_passed','tamper_controls_passed'))):
  return None
 config=read(config_path);entries=config.get('workloads',{})
 if not isinstance(entries,dict) or set(entries)!=set(R5_WORKLOADS):return None
 frozen_network=Path(R9_RUNTIME)/'config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml'
 public_network=R/'config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml'
 if not same_bytes(frozen_network,public_network):return None
 selected={}
 state_bindings=state.get('workload_bindings')
 if not isinstance(state_bindings,dict):return None
 for workload in R5_WORKLOADS:
  item=entries[workload];observed=state_bindings.get(workload)
  if not isinstance(item,dict) or not isinstance(observed,dict):return None
  arch_text=item.get('architecture');protocol_text=item.get('protocol')
  if workload!='raytracing':
   arch_text=arch_text or str(R/'config/architectures/amoeba_4x4_cgra_2x2_context6.yaml')
   protocol_text=protocol_text or str(protocol_path)
  arch=Path(arch_text.replace('${ARTIFACT_ROOT}',str(R))) if isinstance(arch_text,str) else None
  selected_protocol=Path(protocol_text.replace('${ARTIFACT_ROOT}',str(R))) if isinstance(protocol_text,str) else None
  if arch is None or selected_protocol is None or not plain_path(arch,'file') or not plain_path(selected_protocol,'file'):
   return None
  if workload!='raytracing' and (arch!=R/'config/architectures/amoeba_4x4_cgra_2x2_context6.yaml' or selected_protocol!=protocol_path):return None
  if workload=='raytracing' and selected_protocol!=config_path.parent/R9_RAY_PROTOCOL:return None
  try:frozen_arch=Path(R9_RUNTIME)/arch.relative_to(R)
  except ValueError:return None
  if (observed.get('architecture')!=str(arch) or observed.get('frozen_architecture')!=str(frozen_arch) or
      observed.get('protocol')!=str(selected_protocol) or not same_bytes(arch,frozen_arch)):
   return None
  def resolve_config_path(value):
   if not isinstance(value,str) or not value:return None
   value=value.replace('${ARTIFACT_ROOT}',str(R))
   path=Path(value)
   return path if path.is_absolute() else config_path.parent/path
  catalog_path=resolve_config_path(item.get('parent_cost_file'))
  mapper_cost=resolve_config_path(item.get('cost_cache'))
  model_path=resolve_config_path(config.get('defaults',{}).get('model_cache'))
  if any(path is None or not plain_path(path,'file') for path in (catalog_path,mapper_cost,model_path)):return None
  cat=read(catalog_path)
  metadata=cat.get('predictor_metadata',{})
  if metadata.get('architecture_path')!=str(arch):return None
  canonical_value=item.get('canonical');prepared_value=item.get('prepared_source_file')
  if not isinstance(canonical_value,str) or not isinstance(prepared_value,str):return None
  canonical_path=Path(canonical_value.replace('${ARTIFACT_ROOT}',str(R)))
  prepared_path=Path(prepared_value.replace('${ARTIFACT_ROOT}',str(R)))
  if not canonical_path.is_absolute():canonical_path=config_path.parent/canonical_path
  if not prepared_path.is_absolute():prepared_path=config_path.parent/prepared_path
  source_identity_record=resolve_config_path(item.get('source_identity_record'))
  canonical_lowering_record=resolve_config_path(item.get('canonical_lowering_record'))
  if workload=='raytracing':
   if (source_identity_record!=R/'.work/source-fission-original-ray-repair-20261006/upstream-source-check/summary.json' or
       canonical_lowering_record!=R/'.work/source-fission-original-ray-repair-20261006/canonical-lowering-record.json' or
       not plain_path(source_identity_record,'file') or not plain_path(canonical_lowering_record,'file')):return None
  elif source_identity_record is not None or canonical_lowering_record is not None:return None
  selected[workload]={'architecture':arch,'frozen_architecture':frozen_arch,
                      'protocol':selected_protocol,'canonical':canonical_path,
                      'prepared':prepared_path,'parent_cost':catalog_path,
                      'mapper_cost':mapper_cost,'model':model_path,
                      'source_identity_record':source_identity_record,
                      'canonical_lowering_record':canonical_lowering_record}
 try:
  validator=queue_validator()
  if validator is None:return None
  validator._validate_acceptance_marker(
   marker_path,optimizer=accepted_optimizer,source_contract=accepted_contract,
   protocol=protocol_path,config_path=config_path)
  validator._validate_workload_bindings(
   {workload:{'architecture':binding['architecture'],'protocol':binding['protocol'],
              'parent_cost':binding['parent_cost']} for workload,binding in selected.items()},
   artifact_root=R,main_protocol_path=protocol_path,
   main_protocol=read(protocol_path),optimizer=accepted_optimizer,
   source_contract=accepted_contract,runtime_root=Path(R9_RUNTIME))
 except (OSError,ValueError,TypeError,KeyError,AttributeError,RuntimeError):
  return None
 result_root=Path(R9_RESULTS_ROOT);provenance=result_root/'provenance'
 if (not same_bytes(config_path,provenance/'input0-chain.json') or
     not same_bytes(R/'.work/source-fission-original-ray-repair-20261006/canonical-source-lowering-acceptance.json',
                    provenance/'canonical-source-lowering-acceptance.json')):return None
 for workload in R5_WORKLOADS:
  binding=selected[workload]
  if (not same_bytes(binding['protocol'],provenance/f'{workload}-protocol-bound.json') or
      not same_bytes(binding['architecture'],provenance/f'{workload}-public-architecture.yaml')):return None
 return {'state':state,'config_path':config_path,'protocol_path':protocol_path,
         'protocol_json':read(protocol_path),
         'optimizer':optimizer,'contract':contract,'runtime':Path(R9_RUNTIME),
         'results_root':Path(R9_RESULTS_ROOT),'network':frozen_network,
         'lowering':R/'.work/source-fission-original-ray-repair-20261006/canonical-source-lowering-acceptance.json',
         'bindings':selected}

def accepted_r9_stage(workload,stage,profile):
 if profile is None:return '—'
 root=profile['results_root'];binding=profile['bindings'][workload]
 stage_dir=root/workload/stage;result=read(stage_dir/'result.json');source_path=stage_dir/'source-binding.json';source=read(source_path)
 if (not plain_path(stage_dir,'dir') or result.get('status')!='native_replayed' or
     result.get('native_top5_status')!='native_replayed' or result.get('numeric')!='pass' or
     result.get('trace')!='pass' or source.get('schema')!='orbit-neighborhood-source-binding-v1' or
     source.get('protocol_schema')!=profile['protocol_json'].get('schema') or
     source.get('source_commit')!=profile['protocol_json'].get('source_commit') or
     source.get('scheduler')!=profile['protocol_json'].get('scheduler') or
     source.get('optimizer')!=str(profile['optimizer']) or
     source.get('source_contract_file')!=str(profile['contract']) or
     source.get('protocol')!=str(binding['protocol']) or
     source.get('architecture')!=str(binding['architecture']) or
     source.get('inter_task_network')!=str(profile['network']) or
     source.get('inter_task_network_text')!=profile['network'].read_text() or
     source.get('canonical_program')!=str(binding['canonical']) or
     source.get('parent_cost_file')!=str(binding['parent_cost']) or
     source.get('cost_cache')!=str(binding['mapper_cost']) or
     source.get('model_cache')!=str(binding['model']) or
     source.get('source_commit')!=profile['protocol_json'].get('source_commit') or
     source.get('stage_initialization')!='independent' or
     result.get('source_binding')!=str(source_path)):return '—'
 cycles=result.get('actual_stage_cycles')
 return f'{cycles:,}' if type(cycles) is int and cycles>0 else '—'

def accepted_r9_fixed1x1(workload,profile):
 if profile is None:return '—'
 state=profile['state'];root_text=state.get('fixed1x1_results_root')
 if not isinstance(root_text,str):return '—'
 root=Path(root_text)
 if (not root.is_absolute() or root.parts[:2]!=('/','tmp') or root.name!=R5_BASE or
     not plain_path(root,'dir') or str(root.parent.parent.parent)!=R9_RESULTS_ROOT):return '—'
 summary_path=root/'summary.json';result_path=root/workload/'result.json'
 if not plain_path(summary_path,'file') or not plain_path(result_path,'file'):return '—'
 try:summary=json.loads(summary_path.read_text())
 except (OSError,ValueError):return '—'
 if not isinstance(summary,list):return '—'
 matches=[row for row in summary if isinstance(row,dict) and row.get('workload')==workload]
 if len(matches)!=1:return '—'
 if workload=='raytracing' and matches[0].get('status')=='unsupported-model-domain':
  return 'N/A' if verified_r9_ray_domain_exclusion(workload,profile,root,result_path,matches[0]) else '—'
 if matches[0].get('status')!='complete':return '—'
 result=read(result_path);binding=profile['bindings'][workload];commands=result.get('commands',{})
 if not isinstance(commands,dict):return '—'
 expected={'optimizer':str(profile['optimizer']),'source_contract':str(profile['contract']),
           'protocol':str(binding['protocol']),'architecture':str(binding['architecture']),
           'inter_task_network':str(profile['network'])}
 if any(result.get(key)!=value for key,value in expected.items()):return '—'
 try:
  if result.get('inter_task_network_text')!=profile['network'].read_text():return '—'
 except OSError:return '—'
 canonical_copy=root/workload/'canonical-input.mlir';source=binding['canonical']
 if not source.is_absolute():source=profile['config_path'].parent/source
 cycles=result.get('baseline_cycles');saved=state.get('fixed1x1',{}).get('workloads',{}).get(workload,{})
 workload_state=state.get('workloads',{}).get(workload,{})
 if (result.get('workload')!=workload or result.get('status')!='complete' or
     result.get('numeric')!='pass' or result.get('independent_trace')!='pass' or
     result.get('mapper_equality')!='pass' or result.get('canonical_input')!=str(canonical_copy) or
     not same_bytes(source,canonical_copy) or
     any(not isinstance(commands.get(name),dict) or commands[name].get('status')!='finished' or
         commands[name].get('exit_code')!=0 for name in ('materialize','mapper','native','numeric')) or
     not isinstance(cycles,int) or isinstance(cycles,bool) or cycles<=0 or
     (saved.get('status')=='complete' and saved.get('baseline_cycles')!=cycles) or
     (workload_state.get('baseline_status')=='complete' and workload_state.get('baseline_cycles')!=cycles)):
  return '—'
 for key,value in expected.items():
  if matches[0].get(key)!=value:return '—'
 if matches[0].get('baseline_cycles')!=cycles:return '—'
 return f'{cycles:,}'

def verified_r9_ray_domain_exclusion(workload,profile,root,result_path,summary_row):
 if workload!='raytracing' or profile is None:return False
 state=profile['state']
 if state.get('fixed1x1_status')!='complete-with-model-domain-exclusion':return False
 result=read(result_path)
 fixed=state.get('fixed1x1',{});saved=fixed.get('workloads',{}).get('raytracing',{})
 workload_state=state.get('workloads',{}).get('raytracing',{})
 expected_receipt=str(root/'raytracing/model-domain-admission.json')
 if (saved.get('status')!='unsupported-model-domain' or saved.get('baseline_cycles') is not None or
     saved.get('domain_admission')!=expected_receipt or saved.get('result')!=str(result_path) or
     workload_state.get('baseline_status')!='unsupported-model-domain' or
     workload_state.get('baseline_cycles') is not None or workload_state.get('baseline_result')!=str(result_path) or
     summary_row.get('baseline_cycles') is not None):return False
 for key in ('optimizer','source_contract','protocol','architecture','inter_task_network','canonical_input'):
  if summary_row.get(key)!=result.get(key):return False
 try:
  queue=queue_validator()
  if queue is None:return False
  ctx={'artifact_root':R,'workload_bindings':{'raytracing':{
        'protocol':profile['bindings']['raytracing']['protocol'],
        'protocol_json':read(profile['bindings']['raytracing']['protocol']),
        'architecture':profile['bindings']['raytracing']['architecture']}},
       'resolved_config':{'raytracing':{
        'canonical':profile['bindings']['raytracing']['canonical'],
        'prepared':profile['bindings']['raytracing']['prepared'],
        'parent_cost':profile['bindings']['raytracing']['parent_cost'],
        'model':profile['bindings']['raytracing']['model'],
        'source_identity_record':profile['bindings']['raytracing']['source_identity_record'],
        'canonical_lowering_record':profile['bindings']['raytracing']['canonical_lowering_record']}},
       'optimizer':profile['optimizer'],'source_contract':profile['contract'],
       'runtime_root':profile['runtime'],
       'lowering':profile['lowering']}
  queue._verify_baseline_source_binding(result,workload,root,ctx)
  queue._verify_ray_model_domain_exclusion(result,summary_row,result_path,root,ctx)
 except (OSError,ValueError,TypeError,KeyError,AttributeError,RuntimeError):
  return False
 return True
def main():
 s=read(R/'.work/post-publication/full-input0-inplace-proof-r4-runtime-20261006.json')
 recovery=read(R/'.work/post-publication/full-input0-inplace-proof-r4-recovery-runtime-20261006.json')
 if recovery:s={**s,**recovery}
 retry=read(R/'.work/post-publication/full-input0-inplace-proof-r4-final-retry-runtime-20261006.json')
 radar_retry=read(R/'.work/post-publication/radar-r4-independent-retry-runtime-20261006.json')
 if radar_retry.get('status') in ('starting','running','complete','failed'):
  s.setdefault('workloads',{}).setdefault('radar',{})['status']=radar_retry.get('status')
 if retry.get('status')=='running':
  s['status']='recovering';s['phase']='GCN S2 canonical retry';s['pid']=retry.get('pid');s.setdefault('workloads',{}).setdefault('gcn',{})['status']='running'
 elif retry.get('status')=='complete':
  s.setdefault('workloads',{}).setdefault('gcn',{})['status']='complete'
  if all(j.get('status')=='complete' for j in s.get('workloads',{}).values()):s['status']='complete';s['phase']='finished'
 elif retry.get('status')=='failed':
  s['status']='incomplete';s.setdefault('workloads',{}).setdefault('gcn',{})['status']='failed'
 print('input0 完整重测 r4：Task6 证明修复；每阶段独立 canonical 初始化；4 rounds/4096 candidates/beam16/top5 native。')
 print('状态：'+str(s.get('status','未启动'))+'；阶段：'+str(s.get('phase','—'))+'；PID：'+str(s.get('pid','—'))+'；CPU0–11，最多12核，无 mapper timeout。')
 print(f"{'程序':>18} {'固定1x1':>15} {'S1':>15} {'S2':>15} {'S3':>15} {'S4':>15}")
 for label in ('llama','lu','harris','radar','gcn','raytracing-fission'):
  ray=label=='raytracing-fission';w='raytracing' if ray else label;root=R/'results'/(RAY if ray else MAIN);b=read(R/'results'/BASE/w/'result.json') if not ray else {};v=b.get('baseline_cycles')
  baseline=f'{v:,}' if b.get('status')=='complete' and all(b.get(k)=='pass' for k in ('numeric','mapper_equality','independent_trace')) and b.get('optimizer')==s.get('optimizer') and b.get('source_contract')==s.get('source_contract') and isinstance(v,int) else '—'
  values=[accepted_stage(root/w/st,s) for st in STAGES];print(' '.join(f'{t:>15}' for t in (label,baseline,*values)))
  pr=read(root/'parallel'/w/'progress.json');st=pr.get('stages',{});done=sum(value!='—' for value in values);failed=[i+1 for i,t in enumerate(STAGES) if st.get(t,{}).get('status')=='failed'];current=next((i+1 for i,t in enumerate(STAGES) if st.get(t,{}).get('status') not in ('complete','reused','failed')),None);job=s.get('workloads',{}).get(label,{})
  detail='；当前 S'+str(current) if job.get('status')=='running' and current else ''
  if failed:
   pending_gcn=label=='gcn' and failed==[2] and retry.get('status') in ('waiting','running')
   pending_radar=label=='radar' and radar_retry.get('status') in ('starting','running')
   if pending_gcn:detail+='；S2 上次恢复失败，canonical 重试'+('已排队' if retry.get('status')=='waiting' else '进行中')
   elif pending_radar:detail+='；失败阶段 canonical 重试进行中'
   else:detail+=('；上轮待恢复 S' if job.get('status')=='queued' else '；失败 S')+','.join(map(str,failed))
  print(f'  {done}/4 已通过；{job.get("status","queued")}{detail}')
 if retry.get('status')=='waiting':print('GCN S2 canonical 重试已排队；等待当前三条 CPU 队列结束，已通过阶段直接复用。')
 print('单位：整程序 native cycles，仅展示本轮通过 mapper/独立trace/numeric 的结果。')
 print('S1 shape+spatial-temporal；S2 +replica；S3 +tiling；S4 +fusion；每阶段均独立探索全部已开放维度。')
 fresh_current=read(R/'.work/post-publication/full-input0-memory-fusion-fission-r5-original-v2-runtime-20261006.json')
 fresh_old=read(R/'.work/post-publication/full-input0-memory-fusion-fission-r5-runtime-20261006.json')
 fresh=fresh_current or fresh_old
 if fresh:
  print('访存消除与通用 fission 重测 r5：'+str(fresh.get('status'))+'；'+str(fresh.get('phase','—'))+'；PID '+str(fresh.get('pid','—'))+'。')
  state_supported=fresh.get('schema')==R5_STATE_SCHEMA and fresh.get('cohort_id')==R5_COHORT
  if not state_supported:print('r5 coordinator schema/cohort unsupported; results are withheld.')
  original_input=r5_original_input_bound(fresh)
  if not original_input:
   correction=read(R/'.work/source-fission-original-ray-repair-20261006/correction-summary.json')
   if correction.get('status')=='input-restored-native-source-replay-pass-main-queue-not-restarted':
    print('Ray 原始 27-task canonical 已通过 source replay；r9 原始输入主队列尚未闭合，旧 r5 行仅作历史记录。')
  print(f"{'程序':>18} {'固定1x1':>15} {'S1':>15} {'S2':>15} {'S3':>15} {'S4':>15} {'S5':>15}")
  output=Path(fresh['results_root']) if isinstance(fresh.get('results_root'),str) else Path('/__no_r5_results__')
  for w in R5_WORKLOADS:
   values=[accepted_stage(output/w/st,fresh) for st in (*STAGES,'full-joint-fission')] if state_supported else ['—']*5
   baseline=accepted_r5_fixed1x1(w,fresh) if state_supported else '—'
   label=('raytracing' if original_input else 'raytracing-supplement') if w=='raytracing' else w
   job=fresh.get('workloads',{}).get(w,{})
   print(' '.join(f'{t:>15}' for t in (label,baseline,*values)))
   print('  '+str(sum(v!='—' for v in values))+'/5 已通过；'+str(job.get('status','queued'))+'；'+str(job.get('phase','等待')))
  print('S5 同时搜索 shape、replica、tiling、fusion、fission；五阶段各自从 canonical 开始，使用同一新 pin。')
 r9_path=R/'.work/post-publication/full-input0-memory-fusion-fission-r9-original-ray-ii23-queue-v2-runtime-20261006.json'
 fresh_r7=read(r9_path)
 if fresh_r7:
  profile=r9_profile(fresh_r7)
  print('原始 Ray、II23 诊断入口的 fusion/fission r9：'+str(fresh_r7.get('status'))+'；'+
        str(fresh_r7.get('phase','—'))+'；PID '+str(fresh_r7.get('pid','—'))+'。')
  if profile is None:
   print('r9 optimizer/source-contract/protocol/config/architecture binding 尚未通过逐字节检查；隐藏所有 r9 cycles。')
  print(f"{'程序':>18} {'固定1x1':>15} {'S1':>15} {'S2':>15} {'S3':>15} {'S4':>15} {'S5':>15}")
  results=profile['results_root'] if profile else Path('/__no_r9_results__')
  for workload in R5_WORKLOADS:
   baseline=accepted_r9_fixed1x1(workload,profile)
   values=[accepted_r9_stage(workload,stage,profile)
           for stage in (*STAGES,'full-joint-fission')]
   record=fresh_r7.get('workloads',{}).get(workload,{})
   print(' '.join(f'{x:>15}' for x in (workload,baseline,*values)))
   print('  '+str(sum(value!='—' for value in values))+'/5 已通过；'+
         str(record.get('status','queued'))+'；'+str(record.get('phase','等待')))
  if accepted_r9_fixed1x1('raytracing',profile)=='N/A':
   print('Ray 固定1x1 N/A：原始输入 Task_13 的 C++ analytical lower bound 83 超过 diagnostic runtime II=23（training II=20）；完成 domain check，未运行 mapper、accelerator native、trace 或 numeric。')
  if fresh_r7.get('fixed1x1_status') not in ('complete','complete-with-model-domain-exclusion'):
   print('r9 固定1x1 尚未闭合；仅展示各程序独立通过 native/trace/numeric 和精确 source binding 的值。')
 else:
  print('原始 Ray、II23 诊断入口的 fusion/fission r9：尚未启动；r5 错误输入结果继续保留为历史记录。')
 common=read(R/'results/input0-amoeba-common-dfg-r5-20261006/runtime.json') or read(R/'.work/input0-amoeba-common-dfg-r5-20261006/runtime.json')
 if common:
  print('AMOEBA 共同 DFG 对照：'+str(common.get('status'))+'；PID '+str(common.get('pid'))+'；实际 common mapper profiles → 原 F45 allocator → shared native/trace/numeric。')
  for w,job in common.get('workloads',{}).items():
   phase='profiles 和原 F45 分配已完成；后续 source-bind 失败，修复构建中' if job.get('error')=='source-bind failed; see compressed stderr' else str(job.get('phase','等待'))
   result=read(Path(job['result'])) if job.get('result') else {}
   cycles=result.get('native_cycles');cycle_text=f'；{cycles:,} cycles' if result.get('status')=='native_replayed' and all(result.get(k)=='pass' for k in ('mapper','trace','numeric')) and type(cycles) is int else ''
   print('  '+w+'：'+str(job.get('status','queued'))+'；'+phase+cycle_text)
 storage=read(R/'.work/post-publication/r4-live-temporary-cleanup-runtime-20261006.json')
 if storage:print('边跑边清理：'+str(storage.get('status'))+'；300 秒检查已关闭搜索；本监听器已删除 '+str(storage.get('removed_bytes',0))+' bytes。')
 sram=read(R/'diagnostics/vectorcgra-sram-20261006/native-r4-and-common-amoeba-r5/summary.json') or read(R/'diagnostics/vectorcgra-sram-20261006/native-r4/summary.json')
 if sram:print('VectorCGRA 参考实例：128 payload bytes/CGRA，共 2 KiB；已执行 '+str(len(sram.get('records',[])))+' 个 native 容量检查。实际驻留证明及 AMOEBA target admission 仍 pending。')
 if fresh and r5_original_input_bound(fresh):
  print('r5 使用原始 Ray tracing canonical；只显示逐程序独立校验通过的结果。S5 全队列原生验收仍待完成；保留 r4 四阶段结果，未加入 grouped QKV。')
 elif fresh:
  print('旧 r5 Ray 行仅为历史 fission 补充；修正版 r9 原始 Ray 队列仍单独跟踪。保留 r4 四阶段结果，未加入 grouped QKV。')
 else:
  print('修正版原始 Ray r9 队列待启动；保留 r4 四阶段结果，未加入 grouped QKV。')
if __name__=='__main__':main()
