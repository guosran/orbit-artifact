# Public Taskflow graph readiness, 2026-11-14

This records implemented contracts and completed correctness validation. Search
and performance experiments remain paused. These results do not establish
whole-Qwen graph search, a Qwen speedup, or support for every physical mapping.
The integration coordinator ran the linked tests and device checks below;
syntax-only checks during development are not counted as runtime validation.

| Contract | Implemented consumer | Completed validation | Physical boundary |
| --- | --- | --- | --- |
| Fanout, RAW/WAR/WAW, mutable state, retained cut buffers | Generic analysis, native mapping, communication, source-backed ProgramGraph checker | Representation/boundary coverage: 15 checks in full and Neura-disabled builds | Exact pointwise state updates can retain and reuse matching tile regions. Unknown aliasing, shifted dependences and reductions cannot inherit this proof. |
| One initialized and returned state identity | Shared input/output role helpers, real source access/version/copy events, heterogeneous ABI | State sequence: 26 checks; heterogeneous-state contracts pass | Input and output views of a state use the same host root; local RMW import and export pools remain distinct when required. |
| Fixed backing capacity with a changing valid prefix | Invocation provider supplies each actual specialized source graph; handoffs intersect its existing copy regions | Real capacity-eight prefix-four then prefix-eight fixture passes within the state suite | Updated prefix and untouched initial suffix retain their own versions. This is not an unspecialized symbolic-loop proof. |
| Runtime invocation arguments and finite expansion | Checked specialization, deferred replay and invocation dispatch | Specialization: 24 checks; deferred plans: 20 checks | Scalar/memref guards bind the actual source before analysis. Caller materialization quota exhaustion means unexpanded/unvalidated, not infeasible. |
| Static scalar recurrence | Complete source SCF carry clone, full carried-axis mapping, physical source body | Semantic carry: 6 checks; source recurrence regressions pass | Carried axes cannot be split or vectorized without the corresponding scalar-state spill proof. |
| Source replicas and physical placement | One global normalized source, exact concrete task choices, real copy ledger, physical target owners | Physical mapping: 16 checks in full and Neura-disabled builds | Local slots and a full region-addressed host BO are explicit. Without native choices the fallback uses exact source cells; native choices use real tile instances and reuse. |
| Native tiling, dataflow, retention and implementation combined with placement | Complete numeric-source native plan projected to physical owners, preserving actual instances, copy slots, DMA order and all dependencies | Native physical projection: 22 checks; source-bound shape 2×2 with task-local tiles produces eight actual instances in the AIR placement contract | A source group is instantiated into legal per-owner retained scopes. A private local copy cannot be silently broadcast across cores. Original source bindings are checked before the internal numeric clone; final graphs bind the original source and all replica/placement obligations. The policy shape 2×2 path also passed eight waves over three seeds: 24 NPU submissions with zero maximum absolute error, on the same BO without intermediate uploads. |
| Nested replica hierarchy | Public source path parser and target-domain scope checker | Nested physical hierarchy: 13 checks | The public proof checks actual occupied owner sets against the real target hierarchy. A shared coarse ancestor alone does not establish a physical overlap or a placement certificate. Named and nested physical NPU paths still require their own final AIR/AIE receipt. |
| Public multiple-output partition/replica | One child completion per declared output, separately checked joins and real read barriers | Full r4 and Neura-disabled r5 source contracts pass, including multi-output/noalias positives | AIR transfer isolation currently allows at most one host-output event per configuration. Multiple live local outputs still need a safe physical cut/proof or explicit rejection. |
| Physical stage-boundary copies | Optional boundary BO in the existing ProgramDataOrganization ledger; actual export, eviction and subsequent reload | Full and Neura-disabled boundary coverage passes all 15 checks, including real export/reload and mutation negatives | Each write exports its real version, later reads import the matching version, and prefetch observes source predecessors. Native retained-local selections keep their separate existing behavior. |
| Multiple executable configurations | Common event permutation plus checked invocation-wave regions and lifecycle events | Physical mapping suite covers two serial waves, two submissions and boundary BO visibility | Every wave submits/completes once, waits for its predecessor, and crosses no live local-copy frontier. Inputs become device-visible once before the first wave; outputs become host-visible once after the last. Launch and wait prices remain unknown until calibrated. |
| Actual NPU wave execution | Source-bound global graph, AIR selections, compiled configurations and shared physical BO runtime | Eight current cases total 147 correct submissions; each has `max_abs=0`, zero warmups and no private host staging between waves | These prove the listed concrete graphs/geometries, including nested replicas and two separate DFGs. They do not prove a speedup or arbitrary multiple-live-output AIE lowering. |

The exact selected-pool AIE checker rebuild passes in both configurations.
Its actual wave-zero positive and missing-active-view-tag negative pass with
active payload, owner and alias proofs preserved. The current eight-case receipt is complete. The latest checker passes all 41
current AIE waves after the shape/nested cases were rebuilt from the same
source/target. Source, target and final AIE SHA identities were checked against
immutable receipts; this recheck required zero extra NPU submissions.

| Current device case | Waves/configurations | Actual submissions |
| --- | ---: | ---: |
| `shape2x2-r2` | 4 | 12 |
| `state2x2-r1` | 4 per call | 36 (three calls × three seeds) |
| `crosscore-r1` | 2 | 6 |
| `three-row-r4` | 7 | 21 |
| `nested2x2-r2` | 4 | 12 |
| `policy-shape2x2-r1` | 8 | 24 |
| `multidfg-shape2x2-r3` | 8 | 24 |
| `replica-shape1x2-r1` | 4 | 12 |
| **Current total** | **41** | **147** |

`three-row-r4` uses the new per-task boundary spill/reload path; obsolete
`three-row-r1` submissions are historical and are excluded from this total.
The multi-DFG case has two DFGs at shape 2×2 (eight real instances); the last
case has two source replicas, each expanded to shape 1×2. All current cases
use the same BO within their execution chain.

The source regressions also pass the 61-check fusion suite and actual scan,
triangular/last-value, read/modify/write and ordered-replay cases. Source
coverage, public graph validation, emitted AIR, final AIE verification and NPU
numerical checks are separate evidence levels; success at one level does not
silently certify the next.

The AIR adapter owner corrected the review P1 where a default target
configuration with an explicitly anchored unit placement dereferenced a missing
`generic_air` object, and added an actual-lowering regression. Its final
integration result is tracked by the coordinator. Cost receipts
must distinguish modeled invocation count/order from uncalibrated numerical
launch costs. Physical host-capacity facts must also be distinguished from an
arithmetic allocation ceiling.

## Final integration and PR ownership

The latest full and Neura-disabled focused runs pass boundary coverage (15),
physical mapping (16), native projection (22) and AIR multi-DFG source contracts.
The approved fixed source-pipeline regression now passes in both configurations
with two rounds, at most 24 candidates and beam width three, submitting zero
NPU work. Fresh owned evaluator JSON avoids the independently reproduced LLVM
tombstone-copy crash; generic fallback normalizes and verifies the actual
source. A genuinely scored best is required; placed alternatives stay unpriced,
with no estimated milliseconds or physical-execution claim, and original target
receipt bytes remain unchanged. The final full and Neura-disabled aggregate
runs both exit zero, including the fixed pipeline and all agreed AIR contracts.
The rebuilt tool also passes all 41 current AIE-wave rechecks with zero additional
device submissions. LLVM dry-format passes all 111 changed C++/header files.
Both final P1s are fixed and validated; no P0/P1 remains open in this integration
scope. This completed bounded regression does not resume performance search.

The measured [16-feature PR plan](taskflow-source-pr-plan.md) owns each final
implementation with its tests: public multi-output/replica completion in PR 2,
source fission in PR 3, normalization in PR 8, physical owner-set proof/event
permutation/boundary data organization in PR 14, native policy projection in
PR 15, and actual AIR/AIE lowering and wave execution in PR 16. PR 14 includes
the real boundary spill/reload path and its lifecycle negatives; it is not a
later fix-only PR. PR 15 owns this readiness record and the integrated review
and split plan. Every proposed PR remains below 2,000 added-plus-deleted lines;
actual parent-relative branch measurements are required before publication.
