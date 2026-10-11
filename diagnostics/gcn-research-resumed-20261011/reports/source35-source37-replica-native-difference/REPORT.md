# GCN Replica: Source35 versus Source37

The sealed rank-0 winners are 1977 (Source35: 921,765 cycles) and 1978 (Source37: 922,559), a +794 difference. Both original five-candidate native and numeric seal chains pass. Native optimizer and canonical/prepared inputs match; search policies differ.

| Task on final completion chain | Shape35→37 | Native II35→37 | Duration difference |
|---|---|---|---:|
| Task_9 | 2x2→2x1 | 4→5 | +399 |
| Task_15 | 1x2→1x1 | 5→8 | +1197 |
| Task_18 | 2x2→1x3 | 4→6 | +798 |
| Task_23 | 1x3→2x2 | 6→4 | -798 |
| Task_24 | 1x3→2x2 | 6→4 | -798 |

These five actual task-duration changes sum to +798. Transfers on the same latest-route completion chain decrease by 4 cycles, entirely from path latency: payload and bandwidth on paired chain routes agree. Route reservation wait remains zero and start residual remains 230 in both schedules. The accounting is exact: +798−4=+794.

Common-task startup costs do not change. Source35 has 15 shape actions and two replicas (Task14/20); Source37 has 14 shape actions and one replica (Task14). Task8 changes 1×3/II4→2×1/II5 but is outside this completion chain. Task20 changes from two 1×1 replicas (640 iterations/II8 each) to one 1×2 task (1,280 iterations/II6); it is also outside the observed final chain. The +794 should not be assigned solely to removing Task20 replication.

This is a difference between two completed actual schedules. Several shapes and placements change together; it does not establish isolated causal benefits of any one transformation. No new mapping, scoring, scheduling, numeric run, live Full trace, or giant checkpoint read occurred.

Source35 native: [native.mlir](/home/shiran/project/orbit-repair-study/diagnosis/search-regression-repair-20261010/uniform-v35-20261011-retry2/native/b256/gcn/replica/native/rank-0/native.mlir); Source37 native: [native.mlir](/home/shiran/project/orbit-repair-study/diagnosis/search-regression-repair-20261010/retained-communication-shape-window-v37-replica256-continuation1/native/b256/gcn/replica/native/rank-0/native.mlir). Full per-task timings, routes, dispatch orders, typed histories and input hashes are in REPORT.json and the two task CSVs.
