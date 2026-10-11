# GCN Source37: Full versus Replica native winners

Full rank 0 / candidate 150507 completes in 931,310 cycles; Replica rank 0 / candidate 1978 completes in 922,559. The observed difference is +8,751. Both searches use Source37, 256 actual calls, identical canonical/prepared inputs and the same native optimizer. Each original five-candidate native/numeric chain is sealed and passes. These are independent research results, outside the four-workload paper cohort.

| Chain task / representation (Replica → Full) | Shape | Native II | Iterations | Duration difference |
|---|---|---|---|---:|
| Task_9 | 2x1 → 1x1 | 5 → 8 | 400 → 400 | +1,197 |
| Task_10 | 1x3 → 1x1 | 6 → 8 | 400 → 400 | +798 |
| Task_11 | 2x2 → 1x1 | 4 → 8 | 400 → 400 | +1,596 |
| Task_12 | 1x3 → 1x1 | 6 → 8 | 400 → 400 | +798 |
| Task_16 → Task_16.replica.1 | 2x2 → 1x1 | 5 → 10 | 400 → 200 | -5 |
| Task_18 → Task_18.replica.0 | 1x3 → 1x1 | 6 → 10 | 400 → 200 | -404 |
| Task_23 | 2x2 → 1x1 | 4 → 10 | 400 → 400 | +2,394 |
| Task_24 | 2x2 → 1x1 | 4 → 10 | 400 → 400 | +2,394 |
| Task_27 → Task_27.tile.0.3 | 1x1 → 1x1 | 2 → 2 | 16 → 4 | -24 |

Task9/10/11/12/23/24 add 9,177 execution cycles. Full leaves these tasks at 1×1; their native IIs are higher than in the Replica winner. The selected Task16 replica, Task18 replica and final Task27 tile shorten chain durations by 5, 404 and 24 cycles respectively. Startup terms in all nine paired duration changes agree. Thus execution time increases by 8,744 cycles.

The paired chain routes carry the same payloads and use the same 32-bit/cycle bandwidth. Their transfer difference is exactly +7 path-latency cycles, from changed placements. Reservation wait on this chain remains zero, and the unclassified start residual remains 230 cycles in both schedules. Exact arithmetic: 9,177 − 433 + 7 = 8,751.

Full has seven shape actions, two replica actions (Task16 and Task18) and one tile action (Task27, axis 0, factor 4); it has no fusion or fission action. Replica has fourteen shape actions and one replica action (Task14). Full has 33 native tasks versus Replica’s 29. Task14 changes from two 1×1 replicas to one 2×2 task; Task16/18 change from shaped tasks to two 1×1 replicas each; Task27 changes to four 1×1 tiles.

Task18 is not 2×2 in the Full winner. Its two actual native instances are 1×1, II 10, 200 iterations and 1,999 cycles each. The latest-route chain passes through Task18.replica.0 between Task17 and Task19. Replica instead uses one Task18 at 1×3, II 6, 400 iterations and 2,403 cycles. This observed Task18 duration term favors Full by 404; it does not establish what a different 2×2 state would achieve. No counterfactual mapping or scoring was performed.

Task8 changes 2×1 → 1×2 but keeps II 5 and duration 6,404. Task20 changes 1×2 → 2×1 but keeps II 6 and duration 7,683. Task14’s representation and duration change outside this selected completion chain. Full per-task profiles, placements, routes, typed histories and alternative replica/tile instances are retained in REPORT.json and the task CSVs.

This compares two completed schedules with several simultaneous structural and geometry differences. The duration and route terms explain their measured schedule difference; they are not isolated-action causal estimates. A latest-route chain can select one of tied incoming routes; the chosen original trace route and every term are recorded. Non-route precedence or placement effects are retained as residuals rather than called communication wait.

Replica original native: [native.mlir](/home/shiran/project/orbit-repair-study/diagnosis/search-regression-repair-20261010/retained-communication-shape-window-v37-replica256-continuation1/native/b256/gcn/replica/native/rank-0/native.mlir); Full original native: [native.mlir](/home/shiran/project/orbit-repair-study/diagnosis/search-regression-repair-20261010/retained-communication-shape-window-v37-full256-continuation1/native/b256/gcn/fission/native/rank-0/native.mlir). Both rank-0 prediction winners are also the best native candidate among their original five. Archive or queue opportunity loss is outside this native-only report.

No new objective calls, native mapping, numeric execution, archive/checkpoint scan, live source/driver read, or paper modification occurred.
