# Source-derived native proposals

The original C++ whole-program search driver supports opt-in automatic native proposals. Python does not generate a tile grid or plans. `GenericAnalysis` supplies source loop iteration domains; the target supplies memory capacity, implementation capabilities and tile alignment. The current native tile interface addresses source loop indices0/1/2, conventionally M/N/K, rather than inferring arbitrary reduction axes or recognizing named arithmetic.

Example target/search configuration:

```json
{
  "generic_air": {
    "capacity_bytes": 24576,
    "capabilities": {
      "tile_alignment": [1, 8, 1],
      "implementations": [
        {"kind": "scalar", "lanes": 1},
        {"kind": "scalar-product-vector-add-f32", "lanes": 8}
      ]
    }
  },
  "native_auto_candidates": {
    "mode": "joint",
    "max_tile_proposals": 12,
    "exploration_slots": 2
  }
}
```

Target memory architecture/binding is configured through the public static resource, memory and link types; search reads `GenericTargetCapabilities` and does not create a second memory model. Target alignment and optional search preference alignment are combined by their least common multiple. A finite neighborhood proposes half, double, minimum-aligned and full-dimension extents, beginning with spatial index1, then2 and0. Current tiles come from the materialized module, or from its checked plan when no explicit tiles exist. Each proposal is materialized in a clone, re-analyzed and passed through the actual public planner. Unavailable prechecks are recorded, with reasons and target-capability identity, in `automatic-proposals.json`. This phase has no cost-model requirement and does not mistake unknown link cost for illegal communication.

`joint` combines those tile actions, declared implementation actions and source-discovered retention choices. `tiling-only` excludes implementation/residency actions; `implementation-residency` excludes tile actions. Existing explicit candidate lists remain available; with automatic proposals disabled their path is unchanged. Automatic and explicit lists can be combined, subject to the chosen mode. Implementation legality, tails, source dependence and capacity remain planner/backend checks; discovering an opportunity does not prove it legal.

Each child still flows through the original transform, analysis, candidate identity, evaluation, archive, beam and checkpoint implementation. A tile action changes actual module attributes and its resulting plan. Retention can then compose in a second round, or vice versa. Candidate identity is the canonical materialized MLIR; target/model/configuration and native binary bindings remain part of evaluation identity. Resume reconstructs current proposals and replays actions rather than trusting action names alone. The default scalar implementation has one canonical spelling: absent implementation/lane attributes. Explicit scalar/1 requests and transitions back from mixed execution remove those attributes. Source inputs with legacy scalar/1 attributes are normalized before identity, so aliases cannot consume separate beam slots or extra action depth; other implementation choices retain their explicit attributes.

## Unknown-cost exploration

`exploration_slots` defaults to zero and must lie between zero and beam width. When positive, it reserves at most that many parent positions for **legal but uncalibrated** native plans. These candidates retain `status=uncalibrated` and `score=null`; they do not enter the scored ranking. Selection is deterministic by candidate key, deduplicated through the original archive, and labeled `uncalibrated-exploration`. Unsupported, failed, and budget-unmeasured candidates are ineligible. If fewer unknown candidates are available, ordinary scored candidates fill remaining positions.

An uncalibrated baseline can start exploration. A model OOD candidate need not disappear solely because no prediction is available. This is an explicit exploration budget, not an invented prediction or measured label. Checkpoint replay independently rebuilds uncalibrated plans and validates their null scores and selection history. A future device measurement belongs to a separately bound feedback provider.

The effective mapping target is resolved once: when the outer search configuration uses `mapping_config`, capabilities and automatic prechecks use that same nested configuration as evaluation. Search controls remain in the outer object. This prevents proposals from silently using default capacity while evaluation uses a different target.

Failed proposals are requests, not valid plans. `automatic-proposals.json` records their canonical native MLIR, candidate SHA, requested tile/policy/implementation fields and native planner error. Evaluated candidates also retain requested fields in `request.json`. An auditor can verify source bytes and replay the exact request through the compiler; an unsupported request does not gain a fabricated `best_plan`.

Large legal unknown plans retain complete `mapping-result.json` files once per candidate. Automatic exploration feedback/checkpoints carry only required legality flags, null estimate, plan identity and a canonical digest of the complete result. Resume rebuilds the plan with current analysis, compares its complete canonical digest and plan identity, and checks the summary; it does not establish validity merely by trusting a previous disk file. Explicit and scored/observed feedback paths keep their existing representation.

## CPU regression and limits

`test/TaskflowGeneric/automatic_search_v10.py --tool PATH --output NEW_DIRECTORY` exercises two rounds of each mode under identical configured round/evaluation/beam limits, audits real source/plan identities, checks tile→retention composition and target-capacity legality, resumes searches, rejects target-binding changes, and preserves the legacy explicit-list path. A separate no-model case checks two rounds of null-score exploration and rejects forged scores/selection reasons. Its explicit theoretical test provider is an uncalibrated proposal baseline, not performance evidence.

Equal evaluation limits do not mean equal compiler CPU cost: automatic prechecks also plan candidates, and modes visit different numbers of proposals. The proposal bound is per selected parent. Static byte counts are planned transfer payloads, not DDR counters. No multicore placement, hidden precision change, arbitrary cross-stage SRAM retention, or device execution is introduced by this search extension.
