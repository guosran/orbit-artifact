# Sequential graph-then-resource comparison

This experiment compares two constructed decision flows: **Joint** and
**Sequential**. Neither arm is named after another system. The S1–S5 cumulative
ablation is a different experiment and does not supply the Joint arm.

The compiler implementation is maintained as a patch in this artifact, applied
to an isolated ORBIT source checkout. Python launches the same C++ pass and
reuses the existing shortlist, real mapper, native production scheduler,
independent trace and numeric replay path.

## Fixed contract

The five measured programs are `gcn harris llama lu radar`, with the current
v38 input-0 canonical programs and source iteration proofs. Hardware is the
4×4 CGRA fabric with 2×2 PEs per CGRA, context memory 6 and control memory 20.
The model is the unchanged four-member `orbit-per-cgra-2x2-direct-4member-v1`
ensemble. Communication uses the directed 4×4 mesh, one-cycle links and
32 bits/cycle. Both flows use the production spatial-temporal scheduler with
critical-path dispatch and explicit communication. The registry contains no
arbitrary start-time placement action.

Original Ray remains out of the model domain. Its Task_13 has a source-proved
lower-bound II above 20 for all eight permitted shapes. The fission supplement
does not replace it in this comparison. SRAM byte capacity remains pending;
reported cycles describe native production scheduling with measured mapper II.

## Decisions and phases

The resource decisions are oriented CGRA shape and replica factor/axis. Graph
decisions are tiling (including supported K modes), fusion, sibling fusion,
producer/consumer co-tiling and co-K-tiling, fuse-then-tile and tile-then-fuse.
They use the existing bounded registry and materializers, including its
proof-dependent rejection rules. No new transformation is introduced.

The shape menu is `1×1, 1×2, 2×1, 1×3, 3×1, 1×4, 2×2, 4×1`
in CGRA units. Global round zero offers the first three; later rounds offer all eight. B
continues the global menu index after A; it does not repeat round zero.
Replica and tiling initially offer factor two, then factors two/four/eight,
with independent source-authenticated cumulative caps of eight. Factor one
is the initial/unreplicated state and is reachable through withdrawal.
Replica axes come from the existing output-coordinate proof; when unknown,
the registry proposes axes zero/one and the materializer decides legality.
Regular tiling uses axes zero/one. Co-tiling and co-K-tiling use factor two.
Fusion-plus-tiling and tiling-plus-fusion use the existing axis-zero factor-two
combinations. Retained/forwarded and sibling fusion preserve their current
proof requirements. Identity/reset and lineage withdrawal are controller
actions; B withdrawal may remove only resource history after the A prefix.

Stage A projects mixed graph/resource actions such as fusion-plus-shape onto
their graph component. It searches no shape or replica decision. Both arms
start from the same legal canonical configuration, with replica factor one.
Existing task names keep their shapes. For a new `.tile.` or `.replica.`
task, the existing materializer inherits the shape of its name's parent prefix.
For a `.fuse.` task it uses the common parent shape when equal, otherwise the
left parent's shape, then the right parent's shape if the left is absent;
without a known parent it uses 1×1. These are source-owned name/lineage rules,
not a cost-based choice. When that shape is outside the supported model domain, the fixed resource
policy chooses the first supported shape by area and deterministic orientation
order. This is a feasibility rule, without makespan or latency optimization.
The fallback scans the fixed eight-shape menu above, skips the already queried
inherited shape, and stops at the first supported entry. The common predictor
may materialize its full eight-shape catalogue, but A consults only the support
flag for assignment; it never ranks shapes by latency or makespan.
An uncosted or unschedulable candidate is rejected, never assigned zero cost.
Stage A evaluates complete-program predicted makespan, with the same
communication and production scheduler as Joint.

Stage B starts from A's best legal graph and configuration. Its authenticated
structural action history is frozen. Only shape and replica suffix actions may
be applied or withdrawn. Replica may create physical task shards and joins;
the freeze concerns the logical program and structural decisions. The exact
frozen history and source partition proofs distinguish this invariant from
physical task-name or graph-key equality. Canonical reset and removal of an
A graph action are forbidden in B. The A winner is retained as an incumbent
and a real-mapper validation control.

## Budget and cache accounting

The matched search allowance is **4096 complete-program objective calls**.
Every production scheduler invocation consumes one unit, including identity
initialization and scheduler rejection. Materialization attempts, task-cost
queries and model inferences are measured separately. Canonical duplicates
reuse the known objective and do not consume another invocation.

Sequential's main allocation is A=2048, B=2048. Sensitivity runs use
A=1024/B=3072 and A=3072/B=1024. A's identity consumes its allocation; passing
the incumbent into B uses the already computed objective. Unspent A allowance
is not transferred. All are caps: early exhaustion of new legal candidates from a phase's retained beam
is reported (this is not an exhaustive graph-space claim). The main table never selects the best ratio per
program. Any envelope over three ratios consumes three Sequential allowances.

The common controller has beam width 16, four diversity slots and the same
initial/later action menu. Each expansion frontier has a fixed **512 objective
call quota**, identical in Joint, A and B and in all three split allocations.
A phase cutoff can stop a frontier before its quota. The shared global round
safety ceiling is 8192 (twice the total objective allowance); it is not a search
budget or an independent phase depth limit. Search continues until the objective
cap or exhaustion of new legal neighbors of the retained beam. Productive frontiers must add a newly
scored state or a one-time promoted A cache representative; this ceiling exceeds
the resulting objective-plus-promotion bound. B continues the cumulative menu
index after the actual A frontiers. There is no fixed A4/B4 allocation.

The current v38 template has a four-round cap and divides the remaining objective
allowance across remaining rounds. That cap also stops search independently of
4096, so matching iteration counts would not match cross-method objective work.
This comparison binds the fixed-quota controller above for both arms.
This is an explicitly bound objective-controlled protocol, not a reinterpretation
of S5. The legacy entry keeps its adaptive per-round quota unless the new common
`round-score-quota` option is supplied. Reduced-budget validation uses the same
rule `ceil(total allowance / 8)` for both methods (quota four for allowance 32).
The deterministic controller is run once per distinct configuration. Preliminary
Joint4/Sequential4+4 and Joint8/Sequential4+4 proposals were superseded during
controller/cache audits and are excluded from primary results. Their completed
or interrupted cost evidence is retained separately; interrupted uncommitted
work is bounded explicitly instead of reported as exact zero.

Every workload/method has its own copy of the same prepared canonical
predictor cache, and a fresh empty mapper cache. Transformed-graph and complete
objective caches are private to a method; Sequential preserves them across A
and B. The common canonical preparation is reused and its recorded queries
are reported separately. No arm consumes another arm's warmed mapper cache.
Search wall time includes initialization, legal resource assignment, rewrites,
prediction, scheduling and search output. Final mapper/native/numeric work is
reported separately from the search allowance.

The direct ensemble recomputes supported predictions even on scalar-cache
hits, to validate cached equality. Actual inference calls and cache lookups
are therefore counted separately; a cache miss is not used as a proxy for
inference. Failed and partially completed predictor invocations retain their
query and timing audit as well.

Final validation is identical for both flows: five C++ predicted shortlist
records, an identity control, and a `search_anchor` control. Joint's anchor is
its best legal incumbent within the first 50% of objective calls; Sequential's
is the A winner. The initial control is common to both arms. Actual cycles
are the best validated native result across these records. Dedicated pre-call logs
count actual task mapping requests, including failed attempts; hits, mapper process invocations and native
program evaluations are also reported. Predicted makespan curves are separate
from final native cycles.

## Run

The active batch uses the verified runtime accelerations and synchronous
lossless compaction described in [SEQUENTIAL_RUNTIME_ACCELERATION.md](SEQUENTIAL_RUNTIME_ACCELERATION.md).
The following is the preserved reference implementation recipe; use fresh pin
and output paths. The previous primary batch exited on ENOSPC and is retained
separately rather than mixed into the new primary results.

Use a fresh output namespace and a compiler built from the accompanying
Sequential source patch. The standard source-contract writer records the
exact compiler, model and replay payloads. The prerequisite patch preserves the current checkout's pre-existing source-domain/old-baseline fixes; `compiler-sequential.patch`
contains the three new search/accounting source changes. The cost namespace remains the
published `6a1b6fcf6e155651e96b3b881565ad58fdf0c03e`; it identifies model cost
provenance, not the changed compiler's implementation revision.

```sh
# From orbit-artifact; preserve the existing source checkout and its dirty work.
git -C ../orbit worktree add --detach "$PWD/.work/sequential-source-repro" 99ded7396f31c71ee0946389c6946a5f58c770c6
git -C .work/sequential-source-repro apply "$PWD/reference/sequential-comparison/existing-source-prerequisite.patch"
git -C .work/sequential-source-repro apply "$PWD/reference/sequential-comparison/compiler-sequential.patch"
cmake -S .work/sequential-source-repro -B .work/sequential-build-repro -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DMLIR_DIR=/home/x/shiran/llvm-project/build/lib/cmake/mlir \
  -DLLVM_DIR=/home/x/shiran/llvm-project/build/lib/cmake/llvm
ninja -C .work/sequential-build-repro tools/mlir-amoeba-opt/mlir-amoeba-opt -j1
mkdir -p .work/sequential-comparison-reference-repro/bin
cp .work/sequential-build-repro/tools/mlir-amoeba-opt/mlir-amoeba-opt .work/sequential-comparison-reference-repro/bin/mlir-amoeba-opt
strip --strip-debug .work/sequential-comparison-reference-repro/bin/mlir-amoeba-opt
python3 scripts/write_neighborhood_source_contract.py \
  --source-root .work/sequential-source-repro --build-root .work/sequential-build-repro \
  --optimizer .work/sequential-comparison-reference-repro/bin/mlir-amoeba-opt \
  --model-root reference/input0-neighborhood/models/per-cgra-2x2 \
  --source-commit 6a1b6fcf6e155651e96b3b881565ad58fdf0c03e \
  --sram-config config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json \
  --inter-task-network config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml \
  --output .work/sequential-comparison-reference-repro/source-model-contract.json
export ORBIT_LLVM_BUILD=/home/x/shiran/llvm-project/build
python3 scripts/run_sequential_comparison.py \
  --config .work/input0-neighborhood-2x2-v38/source-domain-prep/input0-chain.json \
  --optimizer .work/sequential-comparison-reference-repro/bin/mlir-amoeba-opt \
  --source-contract-file .work/sequential-comparison-reference-repro/source-model-contract.json \
  --model reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json \
  --architecture config/architectures/amoeba_4x4_cgra_2x2_context6.yaml \
  --inter-task-network config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml \
  --sram-config config/architectures/amoeba_4x4_cgra_2x2_sram_pending.json \
  --output-root results/sequential-comparison-4096-reference-repro \
  --budget 4096 --max-rounds 8192 --round-score-quota 512 --workers 3 --cpus-per-worker 4

python3 scripts/summarize_sequential_comparison.py \
  --results-root results/sequential-comparison-4096-reference-repro \
  --output-dir diagnostics/sequential-comparison-4096-reference-repro --render-plots
```

The coordinator reuses completed validated cells and may replay a completed
search without acquiring another search budget. An interrupted standalone
search is not silently restarted or migrated: inspect the saved exact binding
and use a fresh namespace (Sequential pause/resume is explicitly rejected).
Executable, source contract, protocol and input byte hashes must match before any result reuse. Native retries archive prior evidence and start with a fresh empty mapper cache; all attempt mapper costs are reported. Historical and new output trees stay separate.

## Evidence

The source reconstruction acceptance is in
`reference/sequential-comparison/source-delivery-acceptance.json`; the fixed
compiler and LLVM build provenance is in
`reference/sequential-comparison/build-provenance.json`.

Each cell retains the C++ action archive, budget trajectory, exact binding,
typed action histories, five selected plans, controls, mapped and native MLIR,
independent traces, per-rank numeric evidence and raw statistics. The exporter
produces final-cycle tables, split sensitivity, evaluation and wall-time
convergence plots. Speedup is always **Sequential cycles / Joint cycles**;
values above one favor Joint. Conclusions must follow the measured results,
including small differences and Sequential wins.

The separately labelled unused-budget transfer variant and the LLaMA archive/
beam diagnosis are documented in [SEQUENTIAL_DIAGNOSTICS.md](SEQUENTIAL_DIAGNOSTICS.md).
They do not change the original fixed 50/50 main table.

Completed cells may have losslessly compressed auxiliary catalogues and journals
in `raw-auxiliary.tar.gz`; the manifest records every original byte hash and
compaction time. Selected plans, native traces and budget curves remain directly
readable. Restore the exact auxiliary paths before offline continuation/replay:

```sh
python3 scripts/compact_sequential_raw.py --restore-cell results/sequential-comparison-4096-final/gcn/joint
```

Initial feasibility-only bootstrap catalogue reads predate the new C++ counters.
The exporter reconstructs their exact query list from the immutable initial
catalogue and checks the selected shapes against the compiler's emitted identity.
These auxiliary reads, canonical model-domain frontend verification queries,
phase-A feasibility queries, actual model inferences, and scheduler calls are
reported separately. No additional training or calibration is performed.

The report cross-checks every final mapper pre-call audit against its selected
shape candidate and recorded invocation count. Archived cost catalogues remain
linked by tar member path and original SHA-256; prediction totals require the
retained per-invocation audit even after auxiliary compaction.

Cross-stage canonical dedup preserves an authenticated B replay representative
even when the previously retained A history differs. It reuses the canonical
objective, rebinds ordered task names only after shape/trip-count checks, preserves
control snapshots, and exposes that state to the B frontier once. Promotion
records retain both histories and the original objective provenance; repeated
cache hits do not re-enqueue the same representative. This handles physical
replica expansion without unfreezing any structural action.


The preserved reference run additionally passed three `--lane-release-files` from
`.work/sequential-pilot-32-final/radar/{sequential-75,joint,sequential-25}/execution.json`
in CPU-lane order. These guards wait for the previous owner of the same CPU
set to exit; they do not change any search parameter. The exact full command,
CPU affinity, payload bytes and waiting times are retained in
`results/sequential-comparison-4096-final/experiment-plan.json` and `lane-releases/`.
That batch exited on ENOSPC. The active runtime-accelerated batch and its synchronous storage policy are documented separately; the reference example above uses a fresh output namespace.

Restricted validation and excluded preliminary work are separately itemized in
`diagnostics/sequential-comparison-4096/extra-initialization-and-validation-costs.json`;
this includes completed predictor audit counts and explicitly bounded interrupted
objective costs. The final compiler's eight LU/Radar validation cells are in
`pilot-final-acceptance.json`. Original Ray domain rejection under this same
compiler is in `ray-domain-preflight.json`. No training or calibration was rerun.

The final exporter additionally checks aggregate numerical statuses, the two
numeric command exit codes, exact shortlist ranks 0–4, control ranks 5–6 and
role/candidate alignment. It permits identity and search_anchor to reference
the same candidate while requiring two distinct validation roles. Validation
dependency bytes, independent reference libraries, the LLaMA harness and LLVM
numeric tools are captured in `validation-payload-binding.json`. Failed retry
query totals are reported as lower bounds when pre-failure cache counters are
unavailable; actual mapper pre-call audits remain counted for every attempt.

The exact protocol change is itemized in `protocol-audit.json`. The active
`decision_flow_comparison` block overrides inherited legacy seed/control
descriptions in the common template: standalone flows admit canonical identity
only, retain identity/search_anchor, and reject S1–S5 or historical winner seeds.


One-shot status query and final audited export (does not restart or poll searches):

```sh
python3 /home/x/shiran/project/orbit-artifact/scripts/show_sequential_comparison.py
```

While pending it prints per-cell checkpoint counts. Once all twenty cells pass,
it verifies dependency byte bindings, phase/freeze/cache invariants and native
validation, then generates the main and sensitivity tables, convergence figures,
final-artifact index, winner history evidence and a factual Chinese paper paragraph.
