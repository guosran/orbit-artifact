# Neura mapper input comparison

Both experiments select the existing Neura heuristic mapper. A crossed
Harris input-0 Task_1 diagnostic on one 2x2-PE CGRA gave:

| Input graph | Original F45 compiler II | ORBIT compiler II |
| --- | --- | --- |
| AMOEBA profiler graph | 10 | 10 |
| ORBIT replay graph | 7 | 7 |

The AMOEBA graph has 37 PE-consuming operations; ORBIT has 27. Relative to
ORBIT, AMOEBA has eight more grant_once, two more grant_predicate, one more
phi and one return_value, and two fewer constant operations. Data movements
and terminators are excluded from these counts. The two graphs are included
alongside the [recorded results](results.json).

The original profiler adds a dummy i1 return for a void kernel and runs its
full return/live-in/control-to-dataflow lowering pipeline. ORBIT wraps the
already-lowered kernel directly. Thus the graphs differ before mapping. For
this task, exchanging compilers does not change II; the input graph explains
the reported 10-versus-7 difference.

The heuristic implementation and common Mapping.cpp plus three mapping
headers are byte-identical in the audited sources. Surrounding resource-bound
and route-handling code has changes, so this diagnostic does not certify
identical behavior for every task. The optional template strategy was not used.

Reproduce the crossed comparison with the two corresponding built compilers
and the existing architecture YAML:

```sh
python3 replay_comparison.py --f45-optimizer "$F45_OPTIMIZER" \
  --orbit-optimizer "$ORBIT_OPTIMIZER" \
  --architecture ../../config/architectures/amoeba_4x4_cgra_2x2_context6.yaml \
  --output /tmp/neura-mapper-input-comparison
```

The launcher uses CPU0 and has no mapper wall-clock timeout. It runs only the
mapping pass on the included pre-mapper graphs. It does not modify baseline
cycles or claim a full hardware execution.
