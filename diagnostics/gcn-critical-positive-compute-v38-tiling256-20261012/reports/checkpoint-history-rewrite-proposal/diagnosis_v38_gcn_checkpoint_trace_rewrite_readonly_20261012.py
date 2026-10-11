#!/usr/bin/env python3
"""Audit frozen checkpoint writers and an existing single-process I/O receipt."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import time

R = Path('/home/shiran/project/orbit-repair-study')
B = R / 'diagnosis/search-regression-repair-20261010'
S = R / 'directional-critical-positive-compute-source'
COMMIT = '76345481683a2e199c0cad155de2acb51149f350'
CPP = 'lib/Backend/Neura/Orchestration/JointScheduling/'
SEARCH = CPP + 'JointNeighborhoodSearchPass.cpp'
COMMON = CPP + 'AnalyticalTaskCandidateCommon.cpp'
OUT = B / 'v38-gcn-checkpoint-trace-rewrite-readonly-20261012'
IO = B / 'v38-gcn-tiling-single-process-io-readonly-20261012'
TILING = B / 'critical-positive-compute-v38-tiling256-continuation1'
PROPOSAL = B / 'v38-gcn-fusion-prefix-proof-cache-readonly-20261012'
INPUTS = {}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def read(path, expected=None):
    path = Path(path).absolute()
    assert path.stat().st_size <= 4 * 1024 * 1024, path
    data = path.read_bytes()
    digest = sha(data)
    assert expected is None or digest == expected, (path, digest, expected)
    assert str(path) not in INPUTS or INPUTS[str(path)] == digest, path
    INPUTS[str(path)] = digest
    return data


def obj(path, expected=None):
    return json.loads(read(path, expected))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output-dir', type=Path, default=OUT)
    args = parser.parse_args()
    out = args.output_dir.absolute()
    assert not out.exists(), 'Refuse to overwrite a sealed report directory.'
    script = Path(__file__).resolve()
    read(script)
    assert subprocess.check_output(['git', '-C', str(S), 'rev-parse', 'HEAD'], text=True).strip() == COMMIT
    assert not subprocess.check_output(['git', '-C', str(S), 'status', '--porcelain'], text=True).strip()
    source = {}
    for relative in [SEARCH, COMMON]:
        data = read(S / relative)
        assert data == subprocess.check_output(['git', '-C', str(S), 'show', COMMIT + ':' + relative])
        source[relative] = data.decode()
    assert INPUTS[str(S / SEARCH)] == '47be60517ee87d6bd3dd901f2d6ecc6377ae4852173e361e48a9acc09d68db25'

    observation = obj(IO / 'REPORT.json', '7360ea7ac3f768873c99cb2b5a283b3a03a2f74b4c2a6b7fa3f14b3cc7e130d4')
    observation_seal = obj(IO / 'FINAL.json', 'd5577e6b4125b631573ae4368ec01f1567e4701c323620ef347bcbc8be555d27')
    assert observation_seal['status'] == 'pass' and observation_seal['input_pre_post_verified'] is True
    assert observation_seal['report_sha256'] == INPUTS[str(IO / 'REPORT.json')]
    assert observation_seal['input_sha256'] == observation['input_sha256']
    assert observation['source_commit'] == COMMIT
    assert observation['pid'] == 1206451 and observation['process_start_ticks'] == '36616743'
    assert observation['raw_process_io_counters']['write_bytes'] == 23343243264
    assert observation['raw_process_io_counters']['wchar'] == 23338523433
    assert observation['raw_process_io_counters']['syscw'] == 120844
    for key in ['additional_objective_calls', 'additional_native_calls', 'additional_numeric_calls']:
        assert observation[key] == observation_seal[key] == 0
    # No new /proc sampling. The immutable sampler's original four-input
    # pre/post proof is inherited, not a claim to reread a live file or binary.
    sampler = R / 'diagnosis_v38_gcn_process_io_once_20261012.py'
    read(sampler, observation['input_sha256'][str(sampler)])
    read(S / SEARCH, observation['input_sha256'][str(S / SEARCH)])
    launch_path = TILING / 'supervisor-launch.json'
    launch = obj(launch_path, observation['input_sha256'][str(launch_path)])
    pipeline_path = TILING / 'prepared-v1/pipeline-binding.json'
    runner_path = TILING / 'prepared-v1/gcn-256-runner-binding.json'
    pipeline = obj(pipeline_path, launch['input_sha256'][str(pipeline_path)])
    runner = obj(runner_path, launch['input_sha256'][str(runner_path)])
    assert pipeline['source_commit'] == runner['source_commit'] == COMMIT
    assert pipeline['optimizer_sha256'] == runner['optimizer_sha256'] == observation['optimizer_sha256']
    assert pipeline['feature_policy'] == runner['feature_policy'] == 'cumulative-tiling'
    assert pipeline['stage'] == 'tiling' and runner['scoring_workers'] == 1
    assert runner['checkpoint_actions'] == 4096
    argv = runner['argv']
    assert argv[argv.index('--checkpoint-actions') + 1] == '4096'
    assert '--refresh-frontier' in argv and '--parent-progress' in argv and '--directional-search' in argv
    assert '--critical-positive-compute' in argv and runner['budget_cap'] == 256
    proposal = obj(PROPOSAL / 'REPORT.json', 'c519943a381641c26972245ec99f367995674104f9cd2d49a88b532de06c5721')
    proposal_seal = obj(PROPOSAL / 'FINAL.json', '198845510f97026fa7ea003b3471d8fa29493fed6dda7c049851a3bff589b520')
    assert proposal_seal['artifact_sha256'][str(PROPOSAL / 'REPORT.json')] == INPUTS[str(PROPOSAL / 'REPORT.json')]
    assert proposal['source_validation']['38']['commit'] == COMMIT and proposal['compile_or_experiment_run'] is False
    assert proposal_seal['runtime_admission'] is False

    def lines_of(pattern):
        return [source[SEARCH].count('\n', 0, m.start()) + 1 for m in re.finditer(pattern, source[SEARCH])]
    assert lines_of(r'\bsaveCheckpoint\(') == [3137, 3249, 3496, 3824, 3888, 3930, 3987, 8258]
    assert lines_of(r'\bwriteFamilyFunnelSidecars\(') == [2812, 7914, 8352]
    assert lines_of(r'\bwriteOutputs\(') == [3989, 8778]
    call_sites = [
        dict(line=3137, trigger='Fresh canonical/import initialization', current_cohort=True),
        dict(line=3249, trigger='Empty pending queue: menus and directional round prepared', current_cohort=True),
        dict(line=3496, trigger='Single-worker committed attempts reach checkpoint-actions, or explicit pause', current_cohort=True,
             configured_interval=4096, interval_counts='attempts, not objective calls', explicit_pause_supported_here=False),
        dict(line=3824, trigger='Parallel owner-commit batch reaches attempt interval, or explicit pause', current_cohort=False,
             reason='This cohort has one scoring worker.'),
        dict(line=3888, trigger='Refresh round boundary after frontier merge and queue reset', current_cohort=True),
        dict(line=3930, trigger='Ordinary nonrefresh new beam selection', current_cohort=False,
             reason='This cohort has refresh-frontier enabled.'),
        dict(line=3987, trigger='Final search snapshot before writeOutputs', current_cohort=True),
    ]
    writers = [
        dict(path_role='archive journal', source_lines=[8269, 8279], behavior='Append only new indexed rows and dirty indexed amendments.',
             history_rewritten_at_every_checkpoint=False),
        dict(path_role='checkpoint JSON', source_lines=[8291, 8341, 8347, 8351],
             behavior='Serialize all familyFunnelEvents plus all parentProgressEvents/directionalEvents, full current queues/state, beam/pending and dictionaries; replace complete file.',
             history_rewritten_at_every_checkpoint=True),
        dict(path_role='diagnostics/family-funnel.jsonl', source_lines=[8132, 8134, 8151, 8160, 8228],
             behavior='All historical family events, then regenerated round-family/path-presence/current-unattempted frontier snapshot; replace complete file.',
             history_rewritten_at_every_checkpoint=True, append_current_whole_file_is_not_equivalent=True),
        dict(path_role='diagnostics/family-funnel-summary.json', source_lines=[7914, 7937, 8070, 8100, 8230],
             behavior='Recompute archive/beam/path ranks and round/current-pending summary, replace current summary.',
             history_rewritten_at_every_checkpoint=False, full_snapshot_recomputed=True),
        dict(path_role='parent-progress.jsonl', source_lines=[8357, 8359],
             behavior='Concatenate the entire parentProgressEvents vector and replace complete file.',
             history_rewritten_at_every_checkpoint=True),
        dict(path_role='directions.jsonl', source_lines=[8364, 8365],
             behavior='Concatenate the entire directionalEvents vector and replace complete file.',
             history_rewritten_at_every_checkpoint=True),
        dict(path_role='frontier-refresh.jsonl', source_lines=[3876], behavior='Append one refresh record.',
             history_rewritten_at_every_checkpoint=False),
        dict(path_role='archive.jsonl / budget-trace.jsonl / top5 / controls / search-summary',
             source_lines=[3989, 8788, 8815, 9014, 9015, 9016],
             behavior='Final writeOutputs publishes whole-run outputs; this is not the recurring checkpoint writer.',
             history_rewritten_at_every_checkpoint=False),
        dict(path_role='archive journal on supported restore', source_lines=[8475],
             behavior='Only a proven uncommitted suffix is truncated via atomic replacement after validating the committed prefix.',
             history_rewritten_at_every_checkpoint=False, current_cohort=False),
    ]
    excerpt_ranges = [
        (SEARCH, 177, 187, 'Search helper passes the full supplied text to the atomic writer.'),
        (COMMON, 640, 684, 'Write a new unique temporary file, close, then rename; not an incremental update.'),
        (SEARCH, 2347, 2347, 'Compiler default checkpoint-actions is 128; actual prepared cohort uses 4096.'),
        (SEARCH, 3133, 3140, 'Initialization checkpoint.'),
        (SEARCH, 3241, 3253, 'Checkpoint after new pending menu/directional round preparation.'),
        (SEARCH, 3491, 3504, 'Single-worker attempt-based interval.'),
        (SEARCH, 3817, 3836, 'Separate parallel-commit interval path, inactive for worker1.'),
        (SEARCH, 3873, 3891, 'Refresh append and recurring checkpoint.'),
        (SEARCH, 3923, 3933, 'Nonrefresh new-beam checkpoint.'),
        (SEARCH, 3983, 4001, 'Final checkpoint followed by final outputs.'),
        (SEARCH, 4106, 4127, 'Cumulative-tiling level3 excludes fusion primitives.'),
        (SEARCH, 6259, 6263, 'Directional events accumulate in an append-in-memory vector.'),
        (SEARCH, 7790, 7804, 'Every candidate-attempt event is retained in the in-memory family history.'),
        (SEARCH, 7914, 7960, 'Sidecar generation traverses/ranks the archive and derives path presence.'),
        (SEARCH, 8099, 8189, 'Regenerated current snapshot follows the complete historical family event stream.'),
        (SEARCH, 8222, 8236, 'Both family diagnostics files are atomically replaced.'),
        (SEARCH, 8258, 8297, 'Archive delta append, then complete family history copied into checkpoint array.'),
        (SEARCH, 8324, 8373, 'Full checkpoint/history fields, sidecar rewrites and journal prefix commit state.'),
        (SEARCH, 8394, 8411, 'Source38 critical/retained modes explicitly reject checkpoint restore.'),
        (SEARCH, 8453, 8476, 'Supported legacy restore authenticates archive committed prefix and discards suffix.'),
        (SEARCH, 8768, 8820, 'Final-only full budget/archive outputs.'),
    ]
    excerpts = []
    for relative, first, last, purpose in excerpt_ranges:
        lines = source[relative].splitlines()[first - 1:last]
        assert len(lines) == last - first + 1
        excerpts.append(dict(path=str(S / relative), source_sha256=INPUTS[str(S / relative)],
                             first_line=first, last_line=last, purpose=purpose,
                             excerpt_sha256=sha(('\n'.join(lines) + '\n').encode()),
                             numbered_lines=[dict(line=first + i, text=line) for i, line in enumerate(lines)]))
    summary = dict(source_commit=COMMIT, process_io_receipt=str(IO / 'REPORT.json'),
                   observed_pid=observation['pid'], observed_start_ticks=observation['process_start_ticks'],
                   observed_timestamp_utc=observation['timestamp_utc'],
                   raw_process_io_counters=observation['raw_process_io_counters'],
                   configured_checkpoint_actions=4096, checkpoint_interval_counts_attempts=True,
                   full_history_copied_into_checkpoint=True,
                   full_history_sidecar_rewrite_paths=['diagnostics/family-funnel.jsonl', 'parent-progress.jsonl', 'directions.jsonl'],
                   family_funnel_has_mutable_snapshot_tail=True, archive_journal_already_appends=True,
                   per_file_write_attribution_known=False, cpu_time_share_known=False,
                   optimization_implemented=False, measured_speedup=False, additional_process_samples=0,
                   additional_objective_calls=0, additional_native_calls=0, additional_numeric_calls=0,
                   paper_admission=False)
    report = dict(
        schema='orbit-v38-gcn-checkpoint-trace-rewrite-readonly-v1', status='pass-sealed-readonly-performance-candidate',
        source_commit=COMMIT, summary=summary, checkpoint_call_sites=call_sites, write_paths=writers,
        all_search_write_text_call_lines=lines_of(r'\bwriteTextAtomically\('),
        other_write_paths_scope='Candidate/prefix modules, immutable body/fact witnesses, score records, family-best witnesses and final outputs also use atomic writes. No per-file contribution is inferred from the single process I/O point.',
        standalone_sidecar_call_sites=[dict(line=2812, route='After a supported restore', current_cohort=False),
                                       dict(line=8352, route='Every saveCheckpoint', current_cohort=True)],
        observation=dict(receipt=observation, final_sha256=INPUTS[str(IO / 'FINAL.json')],
                         inherited_four_input_pre_post_verified=True,
                         inherited_input_sha256=observation['input_sha256'],
                         independently_reread_binary_or_proc=False),
        analysis=dict(
            proved='All cumulative event histories are serialized into each checkpoint and their diagnostic sidecars are fully replaced. The atomic helper writes the full text to a temporary file and renames it.',
            growth='For checkpoint j with historical event bytes H_j, history serialization/write work includes the sum of H_j across checkpoints, not just the final history size. Regular attempt-based intervals can therefore repeatedly process an increasing prefix; refresh/menu saves add more passes.',
            attribution='The recorded process-wide cumulative counters support prioritizing a history-rewrite candidate, but they do not identify which file produced the writes, quantify its CPU fraction, show I/O wait or measure an optimization.',
            legality_cache_difference='The existing PC-fusion negative-proof memo saves only repeated materializer-prefix work and expressly does not remove trace/checkpoint serialization. This observation is cumulative-tiling, whose level3 action filter excludes fusion primitives, so that fusion-only memo does not directly cover these attempts.'),
        single_factor_proposal=dict(
            status='unimplemented; no new source or experiment',
            scope='Opt-in storage-only event journals plus exact committed-prefix references in checkpoint; preserve the current logical controller and current snapshots.',
            event_histories=['familyFunnelEvents', 'parentProgressEvents', 'directionalEvents'],
            approach=[
                'Append each newly recorded historical event once to a separate immutable-order journal; checkpoint records exact file/source identity, committed byte prefix, event count and authentication hash.',
                'Keep beam, generated states, pending cursor/actions, parent-progress queues, attempts, directional counters/feedback/window/round state and archive indexed amendments exact in checkpoint.',
                'Separate family-funnel historical events from mutable round/path/current-pending snapshot records. Regenerate the latter as a current snapshot or reconstruct the exact legacy view when publishing/auditing; never append stale snapshot tails.',
                'Do not advance committed prefix counters until append/close failures and checkpoint publication have been handled. A later uncommitted suffix is ignored/truncated only after validating every committed journal prefix.',
                'Any alternate storage schema must be explicit/default off and update independent validators to replay the complete event stream with original ordering, typed identities, queue rotations/cursors and completeness checks.',
            ],
            invariants=[
                'Same action menus/order, candidate IDs, exact parent/action semantic attempts, materialization decisions, original zero/debit caps, refresh/beam and Top5 selection.',
                'Same total objective calls, prediction/native inputs, original five native receipts and all five strict numeric outcomes; no free candidate, replacement, certificate or winner injection.',
                'Same complete event history and reconstructed logical family-funnel view; final seals explicitly bind journal prefix/full final content, snapshot provenance and parser version.',
                'Supported older checkpoint restore routes retain their exact continuation/failure behavior. Source38 remains fresh-only and still rejects resume; this proposal does not grant it resume support.',
            ],
            validation_before_adoption=[
                'Controlled off/on small full-action trace replay under identical budget/model/domain/scheduler inputs, with complete semantic event/queue/frontier comparison and exact Top5 mapper input equality.',
                'Storage/crash-boundary checks for truncated/extra/amended prefixes and atomic failure ordering, independently of unsupported Source38 resume.',
                'One bounded same-cohort end-to-end comparison measuring wall/user/system CPU, peak RSS and process I/O, followed by original native5/numeric5 gates. Attribute per-file costs only if separately instrumented.',
            ]),
        limitations=['One process-wide I/O point is cumulative and has no interval rate or per-file attribution.',
                     'No live checkpoint, funnel, direction, archive, model or cost-catalogue contents were read.',
                     'No CPU percentage, file-specific byte share, ETA or performance improvement is claimed.',
                     'Current Tiling native quality remains owned by its original pipeline; this report admits no new cycles.'],
        source_excerpts_artifact=str(out / 'SOURCE-EXCERPTS.json'),
        additional_process_samples=0, additional_objective_calls=0, additional_native_calls=0,
        additional_numeric_calls=0, source_or_bound_inputs_modified=False, paper_admission=False,
        input_sha256=dict(INPUTS), input_pre_post_verified=True, epoch=time.time())
    search = S / SEARCH
    common = S / COMMON
    text = f'''Source38 checkpoint/history rewrite candidate, read-only
=======================================================

The frozen writer repeatedly serializes the complete family, parent-progress and directional event histories into every checkpoint, then replaces the corresponding history sidecars. The archive journal itself already appends only additions/indexed amendments. [{search.name}]({search}:8258), [{search.name}]({search}:8291), [{search.name}]({search}:8341).

The configured Tiling interval is 4,096 **attempts**, including zero-debit materialization failures, rather than 4,096 scheduler calls. New pending menus, refresh boundaries and finalization also save checkpoints. The source has separate parallel and nonrefresh paths; this actual cohort uses one worker and refresh. [{search.name}]({search}:3491), [{search.name}]({search}:3249), [{search.name}]({search}:3888), [{search.name}]({search}:3987).

| Writer | Current source behavior |
| --- | --- |
| Archive journal | Incremental indexed append |
| Checkpoint | Complete historical event arrays plus complete current state |
| family-funnel.jsonl | Complete event history plus regenerated current snapshot tail |
| family-funnel-summary.json | Recomputed current summary/path ranks/frontier |
| parent-progress.jsonl / directions.jsonl | Complete event histories |
| frontier-refresh.jsonl | One appended refresh record |
| archive/budget/Top5/controls | Whole-run publication at final writeOutputs |

`writeTextAtomically` passes the entire text to a newly created temporary file, closes it and renames it. It does not append/diff the history sidecars. Repeated saves therefore process the sum of their growing historical prefixes. This is a source-proven optimization candidate, not a measurement of its CPU share. [{common.name}]({common}:640), [{search.name}]({search}:8132), [{search.name}]({search}:8228), [{search.name}]({search}:8357).

The already sealed single-process observation at {observation['timestamp_utc']} records PID {observation['pid']}/start {observation['process_start_ticks']}: `wchar` 23,338,523,433; `write_bytes` 23,343,243,264; `syscw` 120,844. These are process-wide cumulative counters. They cannot assign bytes to a particular checkpoint/sidecar, establish CPU/I/O-wait percentages, predict remaining runtime or demonstrate a speedup. No additional process sampling occurred. [Observation]({IO / 'REPORT.json'}).

This differs from the existing PC-fusion negative-proof cache proposal, which addresses repeated legality analysis and explicitly leaves trace serialization intact. The observed run is cumulative-tiling: its level3 filter excludes fusion primitives, so a fusion-only memo does not directly address this process. [{search.name}]({search}:4106), [Proof memo proposal]({PROPOSAL / 'REPORT.json'}).

A separate single-factor experiment could append historical events once and let checkpoints authenticate exact committed journal prefixes. Current queue/frontier/directional state and event order must remain exact. The funnel's round/path/current-pending tail is a mutable snapshot and must be regenerated separately or reconstructed into the identical logical legacy view; blindly appending the existing file is incorrect. All input/stream completeness, native5/numeric5 and source/model gates remain. Source38 remains fresh-only: supported old restore behavior must be preserved, without claiming new Source38 resume support. [{search.name}]({search}:8099), [{search.name}]({search}:8394).

No patch or experiment was implemented. This report reads frozen source, prepared metadata and small sealed receipts only; it does not read live large journals or modify paper, models, source, bindings or the running Tiling pipeline. Additional objective/native/numeric calls are 0. `SOURCE-EXCERPTS.json` preserves all audited write/call paths.
'''
    out.mkdir(parents=True, exist_ok=False)
    artifacts = {}
    def save(name, value):
        path = out / name
        payload = value if isinstance(value, str) else json.dumps(value, indent=2, sort_keys=True) + '\n'
        path.write_text(payload)
        artifacts[str(path)] = sha(path.read_bytes())
    save('SOURCE-EXCERPTS.json', dict(schema='orbit-frozen-source-excerpts-v1', source_commit=COMMIT, excerpts=excerpts))
    save('SUMMARY.json', summary)
    save('REPORT.json', report)
    save('REPORT.md', text)
    assert {path: sha(Path(path).read_bytes()) for path in INPUTS} == INPUTS
    seal = dict(schema='orbit-readonly-report-seal-v1', status='sealed-independent-checkpoint-history-rewrite-candidate',
                source_commit=COMMIT, report_sha256=artifacts[str(out / 'REPORT.json')],
                markdown_sha256=artifacts[str(out / 'REPORT.md')], artifact_sha256=artifacts,
                script_path=str(script), script_sha256=INPUTS[str(script)], input_sha256=INPUTS,
                input_pre_post_verified=True, additional_process_samples=0, runtime_admission=False,
                additional_objective_calls=0, additional_native_calls=0, additional_numeric_calls=0,
                epoch=time.time())
    save('FINAL.json', seal)
    print(json.dumps(dict(output=str(out), artifact_sha256=artifacts, inputs=len(INPUTS)), indent=2))


if __name__ == '__main__':
    main()
