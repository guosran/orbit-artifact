#!/usr/bin/env python3
"""One-shot progress query; audit and export the complete comparison when ready."""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import subprocess
import sys

import compact_sequential_raw as journal_storage
import run_sequential_comparison as comparison
from sequential_validation_audit import require_complete_validation

ROOT = Path(__file__).resolve().parents[1]


def audit_bindings(root, cells=None, *, validation_binding=None):
    cache = {}
    recorded = {}
    plan = comparison.read(root / 'experiment-plan.json')
    for item in plan['coordinator_payloads']:
        payload = item['exact_bytes'].encode()
        recorded[(item['path'], hashlib.sha256(payload).hexdigest(), len(payload))] = payload
    parallel_path = root / 'runtime-parallelism.json'
    if parallel_path.is_file():
        parallel = comparison.read(parallel_path)
        for item in parallel['runtime_bindings']:
            if comparison.file_binding(item['path']) != item:
                raise ValueError('八核运行的版本绑定已改变：' + item['path'])
        snapshot = comparison.read(parallel['source_snapshot_manifest'])
        for item in snapshot['files']:
            payload = Path(item['snapshot_path']).read_bytes()
            if len(payload) != item['size'] or hashlib.sha256(payload).hexdigest() != item['sha256']:
                raise ValueError('保留的原始运行脚本已改变：' + item['snapshot_path'])
            recorded[(item['original_path'], item['sha256'], item['size'])] = payload
    recovery_path = root / 'runtime-recovery.json'
    if recovery_path.is_file():
        for item in comparison.read(recovery_path)['runtime_bindings']:
            if comparison.file_binding(item['path']) != item:
                raise ValueError('磁盘恢复协调脚本的版本绑定已改变：' + item['path'])
    def verify(row):
        if (row['path'], row['sha256'], row['size']) in recorded:
            return
        path = Path(row['path'])
        if str(path) not in cache:
            cache[str(path)] = comparison.file_binding(path)
        if cache[str(path)] != row:
            raise ValueError(f'执行证据的字节绑定已改变：{path}')
    binding = (comparison.read(root / 'validation-payload-binding.json')
               if validation_binding is None else validation_binding)
    verify(binding['source_contract'])
    for row in binding['files'].values():
        verify(row)
    # The recorded coordinator/replay payload is authoritative for this batch.
    selected_cells = cells if cells is not None else [
        (workload, method) for workload in comparison.WORKLOADS
        for method, _, _ in comparison.METHODS]
    for workload, method in selected_cells:
        cell = root / workload / method
        for key, row in comparison.read(cell / 'comparison-binding.json')['content_binding'].items():
            verify(row)


def export_evidence(root, output):
    report = comparison.read(output / 'results.json')
    index = []
    for cell in report['all_cells']:
        path = root / cell['workload'] / cell['method']
        budget_trace = journal_storage.existing_journal_path(path / 'search/budget-trace.jsonl')
        action_trace = journal_storage.existing_journal_path(path / 'search/action-attempts.jsonl')
        frontiers = journal_storage.existing_journal_path(path / 'search/action-frontiers.jsonl')
        winner = cell['winner']
        directory = 'native-controls' if winner['control_role'] else 'native-top5'
        rank = path / directory / f"rank-{winner['rank']}"
        index.append({'workload': cell['workload'], 'method': cell['method'],
            'final_native_cycles': cell['final_native_cycles'],
            'winner': winner, 'result': str(path / 'result.json'),
            'selected_native_evidence_files': [str(p) for p in sorted(rank.rglob('*')) if p.is_file()],
            'search_statistics': str(path / 'search/search-summary.json'),
            'budget_trace': str(budget_trace),
            'action_trace': str(action_trace),
            'frontiers': str(frontiers),
            'raw_auxiliary_manifest': str(path / 'raw-auxiliary-manifest.json'),
            'journal_gzip_manifest': str(path / 'journal-gzip-manifest.json'),
            'numeric_commands': {key: comparison.read(path / 'result.json')[key]
                                 for key in ('numeric_top5_command','numeric_controls_command')}})
    comparison.replay.atomic_write(output / 'final-artifact-index.json', index)
    main = report['main']
    joint = [r['workload'] for r in main if r['sequential_over_joint'] > 1.01]
    sequential = [r['workload'] for r in main if r['sequential_over_joint'] < .99]
    close = [r['workload'] for r in main if .99 <= r['sequential_over_joint'] <= 1.01]
    cap = comparison.read(root / 'protocol.json')['search']['max_unique_complete_candidates_scored']
    sentences = [f'在五个固定 input-0 程序、相同变换能力、成本模型、生产调度器和每流程 {cap} 次完整程序目标评估上限下，我们比较了 Joint 与预先指定 50%/50% 分配的 Sequential。所有最终 cycles 均来自相同的五项 shortlist 加两项控制方案的真实 mapper 复评与完整程序重调度，且最终方案通过数值、分区覆盖、依赖和资源占用检查。']
    if joint:
        sentences.append('Joint 在 ' + '、'.join(joint) + ' 上至少降低约 1% 的 cycles。')
    if sequential:
        sentences.append('Sequential 在 ' + '、'.join(sequential) + ' 上至少降低约 1% 的 cycles。')
    if close:
        sentences.append('两种流程在 ' + '、'.join(close) + ' 上的 cycles 差异在约 1% 以内。')
    sentences.append('加速比统一定义为 Sequential cycles / Joint cycles。阶段比例敏感性单独报告，主表没有逐程序挑选比例；评估上限与实际消耗分别记录，提前停止只表示保留 beam 不再产生合法新候选。结果描述给定搜索协议下经复评的 best-found 方案，不构成全局最优性证明；原始 Ray 仍因模型支持域而排除，SRAM 容量契约仍为 pending。')
    (output / 'paper-conclusion-zh.md').write_text(''.join(sentences) + '\n')
    histories = []
    for cell in report['all_cells']:
        actions = cell['winner']['selection'].get('action_history', {}).get('actions', [])
        histories.append({'workload':cell['workload'], 'method':cell['method'],
            'native_cycles':cell['final_native_cycles'],
            'predicted_native_winner_cycles':cell['predicted_winner_cycles'],
            'native_winner_rank':cell['winner']['rank'],
            'native_winner_control_role':cell['winner']['control_role'],
            'winner_action_history':actions,
            'winner_source_fission_history':cell['winner']['selection'].get('action_history', {}).get('fissionActions', []),
            'phase_a_anchor_native_cycles':cell['anchor_native_cycles']})
    comparison.replay.atomic_write(output / 'winner-search-differences.json', histories)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    pointer = ROOT / 'reference/sequential-comparison/active-run.json'
    active = comparison.read(pointer) if pointer.is_file() else {}
    parser.add_argument('--results-root', type=Path,
                        default=ROOT / active.get('results_root', 'results/sequential-comparison-4096-final'))
    parser.add_argument('--output-dir', type=Path,
                        default=ROOT / active.get('output_dir', 'diagnostics/sequential-comparison-4096'))
    parser.add_argument('--supplement-root', type=Path,
                        default=ROOT / active.get('supplement_root', 'results/sequential-budget-transfer-4096'))
    parser.add_argument('--supplement-output-dir', type=Path,
                        default=ROOT / active.get('supplement_output_dir', 'diagnostics/sequential-budget-transfer-4096'))
    args = parser.parse_args()
    root, output = args.results_root.resolve(), args.output_dir.resolve()
    queue_path = root / 'queue-state.json'
    queue = comparison.read(queue_path) if queue_path.is_file() else {}
    if queue.get('status') == 'waiting-prior-process-exit':
        print(f"新的八核批次等待已有实验 PID {queue['prior_pid']} 退出；使用 pidfd，不轮询结果。")
    def supplement_query():
        if (args.supplement_root / 'supplement-state.json').is_file():
            import show_sequential_budget_transfer as supplement
            return supplement.show(args.supplement_root.resolve(), root, args.supplement_output_dir.resolve())
        return 0
    ready = 0
    errors = []
    print('程序 / 方法：状态；已提交的目标评估数（运行中是下界）')
    for workload in comparison.WORKLOADS:
        for method, _, _ in comparison.METHODS:
            cell = root / workload / method
            result = cell / 'result.json'
            status, calls = '排队', '—'
            if result.exists():
                try:
                    require_complete_validation(comparison.read(result))
                    ready += 1
                    status = '验证通过'
                except ValueError as error:
                    status = '待验证或验证失败'
                    errors.append(f'{workload}/{method}: {error}')
            checkpoint = cell / 'checkpoint.json'
            if status == '验证通过':
                calls = comparison.read(cell / 'search/search-summary.json')['production_scheduler_calls']
            elif checkpoint.exists():
                calls = comparison.read(checkpoint).get('scored_candidates', '—')
                if status == '排队':
                    status = '搜索中'
            print(f'{workload:6} / {method:13}: {status}；{calls}')
    print(f'完整验证 {ready}/20。')
    if ready != 20:
        for error in errors:
            print(error)
        batch = root / 'batch.json'
        failed = (batch.exists() and comparison.read(batch).get('status') == 'incomplete') or queue.get('status') == 'failed'
        if queue.get('status') == 'failed':
            print('后台队列失败：' + queue.get('error', '详见 queue-state.json'))
        process_status = root / 'parallel-process.json'
        if not process_status.exists():
            process_status = root / 'batch-process.json'
        if process_status.exists():
            process = comparison.read(process_status)
            failed = failed or process.get('status') == 'failed'
            if process.get('status') == 'failed':
                print('后台协调器已退出，退出码：' + str(process.get('exit_code')))
        if failed:
            print('批次存在失败项，详情见各单元 result.json 与 coordinator.stderr.log。')
        elif queue.get('status') == 'waiting-prior-process-exit':
            print('批次已排队；此命令仅查询一次，不轮询、不重跑搜索。')
        else:
            print('后台继续运行；此命令仅查询一次，不轮询、不重跑搜索。')
        supplement_status = supplement_query()
        return 2 if failed else supplement_status
    batch = root / 'batch.json'
    if not batch.exists() or comparison.read(batch).get('status') != 'complete':
        print('单元已验证，正在等待协调器提交批次记录；稍后再次执行此命令。')
        return 0
    audit_bindings(root)
    checker_path = ROOT / 'reference/sequential-comparison/check-sequential-search-contract.py'
    spec = importlib.util.spec_from_file_location('sequential_search_contract', checker_path)
    checker = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(checker)
    for workload in comparison.WORKLOADS:
        for split in (50,25,75):
            checker.check_sequential(root / workload / f'sequential-{split}' / 'search')
    command = [sys.executable, str(ROOT / 'scripts/summarize_sequential_comparison.py'),
               '--results-root', str(root), '--output-dir', str(output), '--render-plots']
    subprocess.run(command, cwd=ROOT, check=True, stdout=subprocess.DEVNULL)
    export_evidence(root, output)
    print((output / 'results.md').read_text())
    print('证据审计通过。主表、敏感性结果、曲线和最终方案索引：' + str(output))
    return supplement_query()


if __name__ == '__main__':
    try:
        raise SystemExit(main())
    except (ValueError, OSError, subprocess.CalledProcessError) as error:
        raise SystemExit('查询或证据审计失败：' + str(error))
