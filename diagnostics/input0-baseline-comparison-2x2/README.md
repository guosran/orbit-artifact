# Input0 baseline comparison

The [figure](input0-amoeba-comparison.svg) compares all five validated ORBIT stages with preserved original AMOEBA decisions on the common 4x4-CGRA, 2x2-PE, context6, II20 architecture and explicit mesh network. [CSV](comparison.csv) and [JSON](comparison.json) retain integer cycles, including the fixed 1x1-CGRA baseline.

S5 cycle reductions from AMOEBA are GCN 28.29%, Harris 47.77%, LLaMA 21.92%, LU 26.00%, and Radar 13.61%. AMOEBA multi-replica durations retain the original ceiling-division estimate; ORBIT uses the actual rewritten bodies and mapped costs. All admitted rows pass numeric, mapper binding and independent trace. SRAM remains pending and formal GO is false.

Regenerate from portable evidence:

```sh
python3 scripts/plot_input0_baseline_comparison.py \
  --stages diagnostics/input0-neighborhood-2x2-v38-frozen/neighborhood-final-results.json \
  --baselines reference/input0-neighborhood/evidence/2x2-original-amoeba-baselines.json \
  --supplemental reference/input0-neighborhood/evidence/2x2-supplemental-baselines.json \
  --output-dir diagnostics/input0-baseline-comparison-2x2
```

Ray's original II20 exclusions, II23 original-AMOEBA diagnostic, and II20 fission supplement retain their separate scopes and are not included in this percentage plot.
