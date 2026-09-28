# Full-system scope and module gates

ORBIT's intended chain is semantic graph rewrite → shape/replication → spatial orchestration → temporal scheduling → cost/ranking → selected-candidate native replay → paper output. A result at one layer does not certify a later layer.

| Module | Required evidence for GO | Current integration |
|---|---|---|
| A: semantic | Fresh 126 graphs, witnesses, verifier/facts, 504 host runs, frozen invariants | Executable harness; action-attempt expectation conflicts with pinned source |
| B: resource | Logical tiles vs replicas, feasible shapes, DFG instances, fixed fabric comparison | Schema and validator; production replay pending |
| C: spatial | Canonical TaskEdgeGraph payload, placement, routes, link reservations, occupancy | Contract pending production adapter |
| D: temporal | Fixed, critical, pipeline, beam, scoped exact policies and dynamic ready-set traces | Contract pending production adapter |
| E: cost | Analytical/predictor/native classes, censoring, deterministic ranking | Shared result contract; production data pending |
| Replay | Selected candidate materialized and native replayed | Pending |
| Paper | Matched, complete current-protocol results generate all used tables and plots | Pending |

The reference fabric for backend comparisons is **4×4 physical CGRAs, 16 total**, with a **maximum four CGRAs per task/replica** where that experiment's mapper imposes the cap. A physical CGRA's internal PE array is a separate architectural dimension. `max-cgras-per-task` is never total fabric capacity. Semantic graph identity excludes shape, replication, placement, routes, and time; layered candidate IDs record those choices separately.

Core reproduction must eventually include the semantic closure, shape/replica factorial, spatial and temporal microbenchmarks, cost/ranking, and one selected native replay. Full reproduction additionally needs matched full workloads and long native mapping. RTL simulation is optional; final artifact GO does not require an RTL run. The present repository reports missing modules as pending rather than filling them with historical numbers.

## Rewrite attempt definition

The pinned C++ pass reports `statistics.action_attempts` as the number of calls to `applyAction`: for every dequeued rewrite state, it calls each concrete action/parameter entry in the 20-entry registry once, incrementing before legality. Rejected actions, full-domain tile-size no-ops, and accepted transitions to an existing graph count. A graph requeued because a more executable witness path was found is expanded again and its 20 calls count again. The root identity graph is a state, not an action attempt. Output canonicalization and deduplication happen after the call. Materialization failures and missing witnesses do not stop subsequent enumeration. Witness replay, verifier calls, host execution, Python reference actions, and whole-run retries do not contribute. Different rewrite paths to the same canonical graph contribute only when the source pass actually requeues and expands that state.

This operational metric is **not** the number of distinct `(canonical input graph, action, parameters)` combinations. Both the historical and pinned protocols have 3,960 such combinations. The historical operational count of 5,280 included 1,320 repeat calls; the pinned count of 5,920 includes 1,960. [Action count provenance](ACTION_COUNT_PROVENANCE.md) and [reconciliation](ACTION_COUNT_RECONCILIATION.md) explain why neither raw count currently satisfies the frozen semantic contract without a protocol decision.
