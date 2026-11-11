#!/usr/bin/env python3
"""Export static distributions from read-only audited observations."""
import argparse
import json
from pathlib import Path

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

p = argparse.ArgumentParser(description=__doc__)
p.add_argument('--results', type=Path, required=True)
p.add_argument('--output', type=Path, required=True)
a = p.parse_args()
a.output.mkdir(parents=True, exist_ok=False)
plt.rcParams.update({'font.size': 10, 'svg.fonttype': 'none'})
fig, axes = plt.subplots(1, 2, figsize=(13, 4.6), gridspec_kw={'width_ratios': [1.7, 1]})
for ax, kind in zip(axes, ['interleaved', 'shared-input']):
    doc = json.loads((a.results/f'observation-{kind}-audit-r1/report.json').read_text())
    names = list(doc['sessions'][0]['distributions'])
    for index, session in enumerate(doc['sessions']):
        values = [session['distributions'][name]['raw'] for name in names]
        positions = np.arange(len(names))+(index-.5)*.3
        box = ax.boxplot(values, positions=positions, widths=.25, patch_artist=True,
                         tick_labels=None, showfliers=True)
        for patch in box['boxes']:
            patch.set_facecolor(['#5592b5', '#c7a16c'][index])
        ax.scatter([], [], label=f'Session {index+1}', color=['#5592b5', '#c7a16c'][index])
    ax.set_xticks(np.arange(len(names)), [name.replace('-', '\n') for name in names], rotation=25, ha='right')
    ax.set_title(kind.replace('-', ' ').title())
    ax.set_ylabel('Prepared host invocation (ms)')
    ax.grid(axis='y', alpha=.2)
    ax.legend(loc='upper right')
fig.suptitle('ORBIT v20: complete outputs pass; host timing varies across contexts and sessions')
fig.tight_layout()
fig.savefig(a.output/'npu-distributions.svg', bbox_inches='tight')
fig.savefig(a.output/'npu-distributions.png', dpi=180, bbox_inches='tight')
plt.close(fig)
print(json.dumps(dict(status='PASS', output=str(a.output))))
