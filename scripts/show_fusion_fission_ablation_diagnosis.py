#!/usr/bin/env python3
"""Read the sealed fusion/fission diagnosis once; never starts work or polls."""
import json
from pathlib import Path


def main():
    root = Path(__file__).resolve().parents[1] / 'diagnostics/fusion-fission-ablation-diagnosis-20261007'
    value = json.loads((root / 'summary.json').read_text())
    print('R9 fusion/fission 诊断：' + value['status'])
    print('独立诊断评估：' + str(value['budget']['conservative_objective_total_including_native']) + '/4096；原消融主表保留。')
    print('已证实：部分 Radar fusion 在评分前被 metadata 校验阻断；LU 已评分变换未入最终 native shortlist。')
    print('| 对照 | 原图 native | 变换图 native |')
    print('|---|---:|---:|')
    for case in value['results']:
        fixed = case['fixed']
        print('| ' + case['case'] + '（固定） | ' + str(fixed['original']['native']) + ' | ' + str(fixed['transformed']['native'] or 'N/A：评分前拒绝') + ' |')
        if case.get('matched_native_extra'):
            measured = case['matched_native_extra']
            print('| ' + case['case'] + '（64点中已测同资源） | ' + str(measured['original']) + ' | ' + str(measured['transformed']) + ' |')
    print('R9可比对照尚未找到增量加速；所有合法变换是否无收益：未知。')
    print('后续 R11b 有正确 PC fusion 固定对照加速，版本不同，未证明超过正式消融 winner。')
    print('Task7：仅已证实规则限制；没有正确且更快改写。')
    print('报告：' + str(root / 'README.md'))


if __name__ == '__main__':
    main()
