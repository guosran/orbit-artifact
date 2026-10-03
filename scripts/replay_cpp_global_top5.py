#!/usr/bin/env python3
"""Invoke mapper/native processes for a C++ selected global shortlist.

The compiler owns selection, mapping, placement and communication. Python
asserts the emitted records and renders their evidence; no search is here.
"""
from __future__ import annotations
import argparse, gzip, importlib.util, json, re, subprocess
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime, timezone
import validate_embedded_native_trace as trace_validator
ROOT=Path(__file__).resolve().parents[1]

def write(p, value):
    p.parent.mkdir(parents=True, exist_ok=True)
    temp=p.with_name(p.name+'.partial');temp.write_text(json.dumps(value,indent=2,sort_keys=True)+'\n');temp.replace(p)

def invoke(argv, directory, label):
    directory.mkdir(parents=True, exist_ok=True)
    out=directory/(label+'.stdout.gz');err=directory/(label+'.stderr.gz')
    began=datetime.now(timezone.utc).isoformat()
    write(directory/(label+'.command.json'), {'argv':argv,'status':'running','started_utc':began,'stdout_log':str(out),'stderr_log':str(err)})
    with out.open('wb') as out_file,err.open('wb') as err_file:
        o=subprocess.Popen(['gzip','-c','-n'],stdin=subprocess.PIPE,stdout=out_file)
        e=subprocess.Popen(['gzip','-c','-n'],stdin=subprocess.PIPE,stdout=err_file)
        try: result=subprocess.run(argv,cwd=ROOT,stdout=o.stdin,stderr=e.stdin)
        finally:
            o.stdin.close();e.stdin.close();o.wait();e.wait()
    record={'argv':argv,'status':'finished','exit_code':result.returncode,'started_utc':began,'ended_utc':datetime.now(timezone.utc).isoformat(),'stdout_log':str(out),'stderr_log':str(err)}
    write(directory/(label+'.command.json'),record)
    return record

def replay(selection, args):
    score=selection['score_record'];cid=selection['candidate_id'];rank=selection['rank']
    header=json.loads(Path(selection['score_file_path']).read_text().splitlines()[0])
    production_scheduler=header.get('schedule_space')=='production-scheduler'
    dispatch_policy=header['dispatch_policy'] if production_scheduler else 'fixed'
    assert dispatch_policy in ('fixed','critical-path')
    d=args.output_dir/('rank-'+str(rank));d.mkdir(parents=True,exist_ok=True)
    result={'rank':rank,'candidate_id':cid,'graph_variant_id':selection['graph_variant_id'],
            'ranking_certified':selection['certified'],'predicted_cycles':selection['predicted_whole_program_cycles'],
            'numeric':'pending','independent_trace':'pending','mapper_equality':'pending','sram_gate':'pending',
            'status':'incomplete','production_ready':False,'started_utc':datetime.now(timezone.utc).isoformat()}
    manifest = args.manifest
    if args.graph_manifests:
        binding = json.loads(args.graph_manifests.read_text())
        manifest = Path(binding[selection['graph_variant_id']])
    elif selection['graph_variant_id'] != 'identity':
        manifest = Path(selection['candidate_manifest'])
    mapped=d/'mapped.mlir';native=d/'native.mlir'
    argv=[str(args.optimizer),selection['mapper_replay_path'],'--verify-each',f'--architecture-spec={args.architecture}']
    # Fresh identity inputs and older closure artifacts may lack the scored
    # semantic label. Bind every selection through the C++ enumerator before
    # strict materialization;
    # the materializer still checks every task, trip count and canonical shape
    # against the originally scored manifest.
    space=json.loads(manifest.read_text().splitlines()[0])
    if space.get('schema') == 'orbit-neighborhood-shape-selection-v1':
        # The source-owned selection binds one tuple to the exact program.
        # Re-enumeration would mutate that program and break its binding.
        assert space['record_type'] == 'selection'
        assert space['graph_variant_id'] == selection['graph_variant_id']
        assert space['candidate_id'] == score['shape_candidate_id']
    else:
        assert space['record_type']=='space' and space['representation']=='factored'
        assert space['graph_variant_id']==selection['graph_variant_id']
        argv.append(f'--enumerate-analytical-task-candidates=function={space["function"]} output={d}/replay-space.jsonl factored-output=true search-policy=complete-cartesian max-cgras-per-task={space["max_cgras_per_task"]} graph-variant-id={selection["graph_variant_id"]}')
    argv += [f'--materialize-analytical-task-candidate=candidates={manifest} candidate-id={score["shape_candidate_id"]}',
          f'--map-joint-scheduling-tasks=scores={selection["score_file_path"]} candidate-id={cid} mapping-cache-dir={args.mapping_cache}',
          '-o',str(mapped)]
    result['status']='mapper_running';write(d/'result.json',result)
    reusable=args.reuse_mapped_root/('rank-'+str(rank))/'mapped.mlir' if args.reuse_mapped_root else None
    reuse_ok=bool(reusable and reusable.is_file())
    if reuse_ok and production_scheduler:
        saved=reusable.read_text()
        reuse_ok=('joint_scheduling_scheduler_backend = "orchestrate-tasks-on-accelerators"' in saved and
                  f'joint_scheduling_production_dispatch_policy = "{dispatch_policy}"' in saved and
                  f'joint_scheduling_candidate_id = "{cid}"' in saved and
                  'amoeba.exact_schedule' not in saved and 'joint_scheduling_exact_dispatch_order' not in saved)
    if reuse_ok:
        import shutil
        shutil.copyfile(reusable,mapped)
        command={'exit_code':0,'reused_mapper_result':str(reusable)}
    else: command=invoke(argv,d,'mapper')
    result['mapper_command']=command
    if command['exit_code']:
        result.update(status='incomplete',blocker='mapper_process_failed');write(d/'result.json',result);return result
    text=mapped.read_text();count=len(score['task_costs'])
    result['mapper_equality']='pass' if text.count('amoeba.mapper_replay_verified')==count else 'fail'
    result['mapper_cache_hits']=int(re.search(r'joint_scheduling_mapper_cache_hits = ([0-9]+)',text).group(1))
    result['mapper_cache_misses']=int(re.search(r'joint_scheduling_mapper_cache_misses = ([0-9]+)',text).group(1))
    result['prediction_mapper_equal']='joint_scheduling_prediction_mapper_equal = true' in text
    argv=[str(args.optimizer),str(mapped),'--verify-each',f'--architecture-spec={args.architecture}',
          f'--orchestrate-tasks-on-accelerators=orchestration-strategy=analytical-based-task-orchestration scheduling-mode=spatial-temporal dispatch-policy={dispatch_policy} communication-mode=explicit exact-replay-timing=mapped','-o',str(native)]
    result['status']='native_running';write(d/'result.json',result)
    command=invoke(argv,d,'native');result['native_command']=command
    if command['exit_code']:
        result['status']='incomplete'
        result['blocker']='native_process_signal' if command['exit_code'] < 0 else ('production_scheduler_failed_under_real_mapper_durations' if production_scheduler else 'selected_exact_schedule_infeasible_under_real_mapper_durations');write(d/'result.json',result);return result
    costs={row['task']:row for row in score['task_costs']}
    candidate={'candidate_id':cid,'task_shapes':[{'task':entry['task'],'trip_count':costs[entry['task']]['trip_count'],
      'shape':{'rows':entry['rows'],'cols':entry['cols'],'cgra_count':entry['rows']*entry['cols'],
               'cgra_shape':str(entry['rows'])+'x'+str(entry['cols']),
               'mapper_tile_rows':costs[entry['task']]['mapper_tile_rows'],'mapper_tile_cols':costs[entry['task']]['mapper_tile_cols']}}
      for entry in score['task_schedule']]}
    try:
        text=native.read_text();trace=trace_validator.validate(text,candidate,selection['graph_variant_id'])
        actual=trace_validator.AttributeParser(trace_validator.extract_dictionary(text,'joint_scheduling_actual_trace')).document()
        selected={row['task']:row for row in score['task_schedule']}
        for row in actual['task_schedule']:
            expected=selected[row['task']]
            # Native cycles use actual mapped II; locations, dispatch and
            # deliberate idle remain compiler-selected. Timing drift is evidence.
            if not production_scheduler:
                assert {(p['row'],p['col']) for p in row['cgra_positions']}=={(r,c) for r in range(expected['row'],expected['row']+expected['rows']) for c in range(expected['col'],expected['col']+expected['cols'])}
        result.update(independent_trace=trace['status'],native_cycles=trace['native_cycles'],fixed_location_equality='scheduler-selected' if production_scheduler else 'pass', prediction_start_equality=all(row['start_cycle']==selected[row['task']]['start_cycle'] for row in actual['task_schedule']), replay_timing_policy='production-scheduler-with-mapped-durations' if production_scheduler else 'mapped-duration-preserve-location-dispatch-idle',status='native_replayed',scheduler_backend='orchestrate-tasks-on-accelerators' if production_scheduler else 'orbit-exact-enumerator')
        write(d/'independent-trace.json',trace)
    except (ValueError,KeyError,AssertionError) as error:
        result.update(status='incomplete',independent_trace='fail',blocker=str(error))
    if result['status'] == 'native_replayed':
        capacity = json.loads(args.sram_config.read_text())
        assert capacity['schema'] == 'orbit-vectorcgra-sram-configuration-v1'
        assert capacity['fabric_rows'] == capacity['fabric_columns'] == 4
        gate = d/'sram-gate.json'
        result['sram_command'] = invoke([
            str(args.optimizer), str(native), '--verify-each',
            '--verify-production-sram-native-capacity-gate=capacity-bytes-per-cgra={} grid-rows={} grid-columns={} output={}'.format(
                capacity['per_cgra_capacity_bytes'], capacity['fabric_rows'], capacity['fabric_columns'], gate),
            '-o', '/dev/null'], d, 'sram')
        result['sram_capacity_config'] = str(args.sram_config)
        if result['sram_command']['exit_code'] or not gate.is_file():
            result.update(sram_gate='pending', sram_blocker='native_sram_evidence_process_failed')
        else:
            evidence = json.loads(gate.read_text())
            assert evidence['schema'] == 'orbit-native-sram-capacity-gate-v1'
            assert evidence['status'] in ('pass','pending','fail')
            result.update(sram_gate=evidence['status'], sram_evidence=str(gate))
            if evidence['status'] != 'pass':
                result['sram_blocker'] = evidence['reason']
    result['ended_utc']=datetime.now(timezone.utc).isoformat();write(d/'result.json',result);return result

def main():
    p=argparse.ArgumentParser(description=__doc__)
    for flag in ['global-top5','manifest','optimizer','architecture','mapping-cache','output-dir']:
        p.add_argument('--'+flag,type=Path,required=True)
    p.add_argument('--jobs',type=int,default=2);p.add_argument('--reuse-mapped-root',type=Path)
    p.add_argument('--graph-manifests',type=Path)
    p.add_argument('--sram-config',type=Path,default=ROOT/'config/architectures/amoeba_4x4_vectorcgra_sram.json')
    a=p.parse_args()
    for key,value in vars(a).items():
        if isinstance(value,Path):setattr(a,key,value.resolve())
    rows=[json.loads(line) for line in a.global_top5.read_text().splitlines() if line.strip()]
    selected=[row for row in rows if row.get('record_type')=='selection']
    assert len(selected)==5 and len({(r['graph_variant_id'],r['candidate_id']) for r in selected})==5
    results=[]
    with ThreadPoolExecutor(max_workers=a.jobs) as pool:
        futures=[pool.submit(replay,r,a) for r in selected]
        for f in as_completed(futures):
            results.append(f.result());write(a.output_dir/'summary.json',{'status':'running','records':results,'selection_certified':rows[-1]['complete']})
            print(results[-1]['rank'],results[-1]['status'],results[-1].get('blocker',''),flush=True)
    results.sort(key=lambda r:r['rank'])
    write(a.output_dir/'summary.json',{'status':'native_replayed' if all(r['status']=='native_replayed' for r in results) else 'incomplete',
          'records':results,'selection_certified':rows[-1]['complete'],'numeric':'pending',
          'sram_gate':'pass' if all(r['sram_gate']=='pass' for r in results) else 'fail' if any(r['sram_gate']=='fail' for r in results) else 'pending','production_ready':False})

if __name__=='__main__':main()
