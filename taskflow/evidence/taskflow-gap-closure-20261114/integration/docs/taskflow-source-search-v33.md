# Public Taskflow source search

Taskflow owns actual source transformations, ordered action replay, source
normalization, candidate identity and the source beam. Backend adapters own
resource capabilities, physical realization and costs. The Neura pass names
remain compatibility entry points for the same public materializers.

Neura implements Amoeba CGRA mapping only. AMD NPU realization uses the
independent AIR-to-AIE backend. Sharing Taskflow source facts and transformations
does not transfer a placement or mapping proof between these targets.

## Work status

Search optimization and new performance campaigns are paused at the user's
request. Existing search results are retained with their original baselines and
limitations. Correctness fixes, transformation composition, independent AIR/AIE
checking, code review and artifact cleanup continue. Correctness-only execution
of already compiled candidates does not establish a speedup.

`fusion` merges an operator graph. `fission` makes predecessor-closed DFG cuts
and materializes cut values as storage operations. Storage, copy operations and
edges express data residence; no separate fusion/residence boolean grants
physical reuse. Current source materializers conservatively reject unsupported
control, recurrence and alias patterns.

## Entry points

- `TaskflowFission.h`, `TaskflowFusion.h`, `TaskflowTiling.h`: real source
  legality, materialization and replay. Fission supports actions on derived
  children, hence ordered multistage cuts.
- `SourceActions.h`: transactional compound actions plus backend extensions.
  Resource shape proposals are passed separately to the evaluator; their
  existence does not prove placement or occupancy.
- `TaskflowSourceNormalization.h`: deterministic replay-checked counter and
  hyperblock lowering into actual affine loop nests. Source identity and
  physical-normalization identity remain separate.
- `SourceSearch.h`: backend-neutral beam with capability and evaluation
  callbacks. Only finite, priced, feasible states survive. Unknown mapping,
  timeout and missing price never become proved infeasibility.
- `TaskTiling.h`: source-task-local axis choices in `orbit.task_tiles`.
  Initializer insertion and heterogeneous projection preserve/reindex choices.

## Actual driver selection

Use the existing `taskflow-opt --search --backend=air` with an actual MLIR
source and a target containing:

```json
{
  "source_auto_candidates": {
    "function": "pointwise",
    "rows": 1,
    "cols": 1,
    "max_fission_actions": 64,
    "tiling": true,
    "fusion": true,
    "fission": true,
    "replica": true,
    "mapping": true,
    "task_tiling": true,
    "wall_seconds": 0
  }
}
```

Normal target/cost configuration is included in the same JSON. Zero wall quota
means no walltime limit; existing round, candidate and beam budgets still bound
exploration. The CLI writes original source, target, selected source and
normalized modules, ordered replay and `search.json` to a **new** directory.
The public engine also accepts seeded action history and a stop callback.
The CLI currently requires a fresh source-search invocation; the legacy native
search's checkpoint protocol is not accepted as a source-search checkpoint.

The generic AIR adapter can validate only 1x1 resource choices here. Larger
resource proposals remain explicitly unknown until a shape-aware backend
supplies a physical implementation. A theoretical cost configuration produces
contract-test scores, not measurements or a calibrated NPU speedup.

The same source beam now receives native mapping/residence and task-local tile
proposals through `SourceMappingActions.h`. It writes actual `orbit.mapping`
and `orbit.task_tiles` choices, bound to normalized source body, ordered task
and storage IDs, and target capabilities. Structural graph changes invalidate
old ordinal choices; explicit policy withdrawal and regeneration avoid silently
retargeting them. Family/task rotation keeps fission menus from consuming the
entire evaluation budget before native mapping actions are explored.
`phase_ms` separates proposal enumeration, materialization, action replay,
normalization, capability checking and evaluation.

`TaskflowReplica.h` shares the checked disjoint-domain partition implementation
with source tiling. Replicas carry an independent-resource obligation; they do
not multiply source work. Current generic AIR rejects that obligation until an
adapter can prove concurrent physical placement, including through direct
mapping APIs. Nested unsupported replica-group transformations fail explicitly.

For affine-native per-task tile search, use
`native_auto_candidates.tile_scope="task"`. The native driver enumerates
source-task/axis pages over positive integer tile sizes, applies actual
`orbit.task_tiles`, checks the planner and preserves checkpoint replay.
The default module protocol is retained for historical receipts. Catalogue and
CP-SAT native domains still use their separately declared global-tile schema;
combining those algorithms with task scope is rejected explicitly.

## Domain and validation limits

Source factor bounds come from actual counter extents. New Neura automatic
factor mode is zero; explicitly selected historical 4/8 profiles preserve their
old replay contract. Shape bounds come from target geometry. Exploration
budgets do not redefine legality. Fission ranks exact small-DFG cuts or a
bounded larger frontier by structural resource pressure and distinct live-value
traffic. This heuristic is not itself real mapper feedback; backend callbacks
must provide the physical decision and timing. Reports never claim complete
domain coverage or a global optimum from the beam.

Full Qwen source extraction currently binds external kernel arithmetic and ABI.
Public source transforms becoming available does not prove every Qwen decoder
operator has a checked lowering. In particular, fixed kernel packing, online
attention recurrence and KV state need their own legal implementation domains.
Original full-model evidence remains separate from new lifecycle or transform
experiments.

## Review sequence

The measured split, dependencies, shared-file hunk ownership and validation
requirements are in [taskflow-source-pr-plan.md](taskflow-source-pr-plan.md).
Each PR includes its final implementation, comments and relevant tests. Runtime
experiment code and evidence go directly to `orbit-artifact`.
