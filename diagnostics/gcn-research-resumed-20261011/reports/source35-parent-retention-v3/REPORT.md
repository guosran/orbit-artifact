# Source35 GCN parent retention

Independent replay matches every generated-frontier selection and all nineteen refresh beams and cost-slot roles. Source and compressed journals are bound by exact SHA; decompression is memory-only.

| Parent | First cut | Pool rank (0-based) | Predicted cycles | Cost-slot threshold | Gap |
|---|---|---:|---:|---:|---:|
| neighborhood-116984 | frontier_decision, round 10, call 131 | 21 | 941663 | 941635 | 28 |
| neighborhood-65591 | frontier_decision, round 7, call 92 | 26 | 942392 | 942364 | 28 |

Both targets are outside the twelve cost slots. The remaining diversity slots also go to cheaper distinct last-action/shape signatures. These signatures do not ensure distinct structural DFGs or critical-path opportunities. The original canonical control still retains one diversity slot.

The first-cut table comes from journal-order replay of all generated-frontier decisions as well as refresh decisions. Both targets survive generation-side selection; these are their earliest actual cuts.

Online schedule/structure features guide action selection only after parent admission. REPORT.json records the actual retained-parent direction events, Task7 observations and critical-chain proxies. 116984 has no parent-direction event because it never becomes a next-round parent. 65591 does become a round 6 parent; its removal ends future queue eligibility.

| Parent | Attempts before retirement | Charged calls | Zero-debit attempts |
|---|---:|---:|---:|
| neighborhood-116984 | 0 | 0 | 0 |
| neighborhood-65591 | 1175 | 1 | 1174 |

65591 receives no shape/replica attempt. Its only charged follow-up is Task27 tiling by two at call 90→91 (child 81817); all 1,175 attempts use original ordering. 116984 receives no expansion at all. These are different failure mechanisms: little useful exploration before retirement versus no post-generation opportunity.

| Observed parent | Round | Predicted cycles | Task7 shape | Task7 duration | Readiness-gap proxy | Compute / communication / occupancy directions |
|---|---:|---:|---|---:|---:|---|
| neighborhood-65591 | 6 | 942392 | 2×2 | 69 | 733 | shape:Task_14 / fusion:Task_10\|Task_7 / replica:Task_14 |
| neighborhood-81766 | 7 | 941635 | 1×4 | 75 | 0 | shape:Task_14 / fusion:Task_10\|Task_7 / replica:Task_14 |
| neighborhood-95281 | 10 | 941635 | 1×4 | 75 | 0 | shape:Task_20 / shape:Task_18 / replica:Task_8 |
| neighborhood-116913 | 10 | 941635 | 1×4 | 75 | 0 | shape:Task_14 / fusion:Task_10\|Task_7 / replica:Task_14 |

Task7 is a critical-chain proxy in all four observations and has 100,696,064 known incident payload bits. 65591 and retained 81766 have identical selected directions and priorities (5,753 cycles, 8,388,608 bits, 14,466.25 CGRA-cycles) despite different Task7 geometry. The readiness-gap field is only a proxy; the source records actual_wait_causes_known=false, so it is not measured communication waiting. 116984 has no recorded online-direction features; none are fabricated for comparison.

The following snapshots are the last records available before the cut, excluding next-round observations emitted after beam selection. Missing means the newly generated state had no parent-direction record yet.

| Cut round | Candidate | Last observation round | Task7 remaining gain | Task18 remaining gain | Task18 critical | Compute direction | Communication direction |
|---:|---|---:|---:|---:|---|---|---|
| 10 | neighborhood-116984 | absent | — | — | — | — | — |
| 10 | neighborhood-95281 | 9 | 6 | 2026 | True | shape:Task_8 (5484) | shape:Task_7 (8388608) |
| 10 | neighborhood-116913 | absent | — | — | — | — | — |
| 7 | neighborhood-65591 | 6 | 0 | 2026 | True | shape:Task_14 (5753) | fusion:Task_10\|Task_7 (8388608) |
| 7 | neighborhood-81766 | absent | — | — | — | — | — |
| 7 | neighborhood-81764 | absent | — | — | — | — | — |

For 65591 before refresh 7, Task18 is visible: its remaining gain is 2,026 cycles and it is critical, giving a compute priority of 4,052. That loses to noncritical Task14 at 5,753; Task20 also has 5,753, and the ordinary target-name tie selects Task14. Task7 has zero remaining compute gain in this cached legal suffix, despite being critical. Task18 is therefore not selected as the compute direction, and the actual attempt journal contains no shape attempt for this parent. This is observed prioritization and allocation, not proof that a Task18 action would improve native cycles.

Before refresh 10, retained 95281 last records Task18 gain 2,026 and critical=true, but its compute direction is Task8 at 5,484. Its communication direction is Task7 shape. After refresh 10, its next-round communication direction changes to Task18 shape; this later observation is separately identified above and was not available when the beam was selected. Newly retained parents 81766/81764 and 116913 have no prior parent-direction record at their respective cut, so post-selection records must not be used to explain the earlier ranking.

Remaining gains come from the already-generated cost catalogue and legal pending shape actions. The weighted compute proxy is the recorded remaining gain multiplied by two for a recorded critical/terminal task, as in the existing source; this analysis makes no predictor query. Positive gain being recorded does not imply that task wins the one compute-direction slot or receives a charged attempt.

Beam ranking and diversity: [JointNeighborhoodSearchPass.cpp](/home/shiran/project/orbit-repair-study/directional-window-axis-tie-source/lib/Backend/Neura/Orchestration/JointScheduling/JointNeighborhoodSearchPass.cpp:5875); cost comparison: [stateLess](/home/shiran/project/orbit-repair-study/directional-window-axis-tie-source/lib/Backend/Neura/Orchestration/JointScheduling/JointNeighborhoodSearchPass.cpp:642); generated pruning: [generated_frontier](/home/shiran/project/orbit-repair-study/directional-window-axis-tie-source/lib/Backend/Neura/Orchestration/JointScheduling/JointNeighborhoodSearchPass.cpp:3455); refresh pruning/queue retirement: [refresh](/home/shiran/project/orbit-repair-study/directional-window-axis-tie-source/lib/Backend/Neura/Orchestration/JointScheduling/JointNeighborhoodSearchPass.cpp:3843).

No exact-parent native whole-program result is available for these two intermediate configurations. This proves the cost/diversity admission mechanism and ensuing queue loss; it does not establish predictor error. No scoring, mapping, numeric execution, giant checkpoint read, or live V37 access occurred.
