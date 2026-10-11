# Source38 GCN: matched Full and Replica native explanation

Full rank 0 / candidate 201371 completes in 918,724 cycles; Replica rank 0 / candidate 4645 completes in 920,639. Each original five-rank native/numeric chain is sealed at 256 actual objective calls. Source38, canonical inputs and native optimizer match.

| Completing-chain task | Replica shape / native II | Full shape / native II | Duration change |
|---|---|---|---:|
| Task_9 | 1x3 / 6 | 2x2 / 4 | -798 |
| Task_15 | 1x3 / 6 | 2x2 / 5 | -399 |
| Task_21 | 4x1 / 5 | 2x2 / 4 | -399 |
| Task_22 | 1x3 / 6 | 2x2 / 5 | -399 |
| Task_26 | 1x2 / 4 | 1x3 / 5 | +79 |

Exact observed difference: −798 −399 −399 −399 +79 +1 = −1,915 cycles. Startup terms and trip counts agree in each paired task. The +1 transfer difference is +2 route latency into Task21 and −1 into Task23; paired payloads and bandwidths agree. Reservation wait and non-route start residual do not change. Path latency is already included in transfer.

Among the six reference tasks, Task9 improves from 1×3 / II6 / 2,403 cycles to 2×2 / II4 / 1,605. Task10/11/23/24 remain 2×2 / II4 / 1,605 in both winners; Task12 remains 1×3 / II6 / 2,403. Task18 is also 2×2 / II4 / 1,605 in both. All seven have 400 iterations and startup9.

Full has 17 shape actions and one Task14 replica (factor2). Replica has 17 shape actions and replicas for Task14 (factor4) and Task20 (factor2). Full has 29 native tasks; Replica has 32. The Full winner uses no fusion, fission or tiling action. Its final state is therefore within Replica’s available space; the result demonstrates a different search trajectory and selected geometry combination, not a direct fusion/fission gain.

The original completing-producer chains match after authenticated replica aliases. Task9, Task15, Task21 and Task22 shorten that chain; Task26 becomes slower (1×2/II4 → 1×3/II5), offsetting 79 cycles. This is measured schedule accounting from original mapped durations and scheduling traces, not an isolated replacement experiment.

The closed semantic trace independently reports that Replica’s complete winner is absent from Full’s archive, with its first absent typed prefix at step5. Full still finds a different better combination. Candidate IDs are not treated as portable state identities, and this report does not reread the large archive or checkpoint.

Actual charged shape attempts for Task9/10/11/12/23/24 are Full 5/5/5/15/5/5 versus Replica 4/4/4/4/4/4. These are attempts across recorded parents, not distinct shapes or legal opportunities. Source37’s earlier failure remains a cross-version compute-tier reference, separate from this same-Source38 comparison.

The immutable REPORT/FINAL retain the original native receipts, typed histories, task CSVs, routes and closed-funnel allocation. This explanation has a separate pre/post input hash seal. No new scoring, mapping, numeric execution, model changes or paper modification occurred.
