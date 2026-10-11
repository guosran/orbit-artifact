# GCN Replica: Source38 versus Source37 native winners

Source38 completes in 920,639 cycles versus Source37’s 922,559, a change of -1,920. Both original five-candidate native/numeric chains are sealed at 256 charged objective calls and use identical canonical inputs and the same native optimizer.

| Completing-chain term | Source38 − Source37 |
|---|---:|
| duration | -2,710 |
| transfer | -4 |
| reservation_wait | +1,024 |
| start_residual | -230 |

| Paired chain task | Shape | Native II | Iterations | Duration change |
|---|---|---|---|---:|
| Task_9 | 2x1 → 1x3 | 5 → 6 | 400 → 400 | +399 |
| Task_10 | 1x3 → 2x2 | 6 → 4 | 400 → 400 | -798 |
| Task_15 | 1x1 → 1x3 | 8 → 6 | 400 → 400 | -798 |
| Task_18 | 1x3 → 2x2 | 6 → 4 | 400 → 400 | -798 |
| Task_21 | 2x2 → 4x1 | 4 → 5 | 400 → 400 | +399 |
| Task_22 | 1x1 → 1x3 | 8 → 6 | 400 → 400 | -798 |
| Task_26 | 1x1 → 1x2 | 8 → 4 | 80 → 80 | -316 |

These original trace terms sum exactly to the observed cycle change. Start residual includes non-route precedence/placement effects and is not communication wait; path latency is included in transfer.

This is a cross-version reference for the single compute-target-tier policy change. Native shapes, histories and placements can change together. Their observed accounting does not identify the causal effect of one shape or establish predictor error for an unmapped state. The matched Source38 Full/Replica comparison waits for both cohorts to close.

REPORT.json retains all original task profiles, placements, routes, action histories, representations and five-rank native receipts. No new scoring, mapping, numeric validation, checkpoint/archive scan, live Full read, source modification or paper edit occurred.
