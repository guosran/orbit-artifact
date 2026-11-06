# Amoeba ProgramGraph migration v12

This experiment starts from the exact plain source
`orbit/test/TaskflowAIR/fixtures/add-scale.mlir`: two tasks compute
`T=A+B; C=2*T` on 4×4 f32 buffers. The same source is analyzed by Core and
adapted to Neura. Existing native model prediction, mapper and scheduler remain
the backend; no model is retrained, replaced with coefficients or synthesized
from task names. Python prepares data, invokes tools and audits evidence.

The final frozen acceptance described below passes real model, mapper and
scheduler checks and same-source AIR numerical validation. It does not claim
physical CGRA execution or unrestricted backend support. The entry selects the native default `[1,1]` CGRA shape and enables legacy
differential evidence; `ORBIT_AMOEBA_GRAPH_CONFIG` can supply a different native
configuration. Architecture facts and model queries remain native. There is no
synthetic fallback model or cost.

```bash
# Only prepare arrays/source. All outputs must be new directories.
bash taskflow/scripts/run_taskflow_program_graph_amoeba_v12.sh prepare NEW
# Run the native original-driver regression and unchanged real-model golden test.
ORBIT_AMOEBA_GRAPH_CONFIG=TARGET.json \
bash taskflow/scripts/run_taskflow_program_graph_amoeba_v12.sh cpu NEW
# Also compile the exact source through AIR, without device submissions.
ORBIT_AMOEBA_GRAPH_CONFIG=TARGET.json \
bash taskflow/scripts/run_taskflow_program_graph_amoeba_v12.sh compile-only NEW
# Authorized root hardware coordinator only: same flow, plus NPU validation.
ORBIT_AMOEBA_GRAPH_CONFIG=TARGET.json \
bash taskflow/scripts/run_taskflow_program_graph_amoeba_v12.sh all NEW
```

Tools are selected by `ORBIT_GRAPH_CORE_TOOL`, `ORBIT_GRAPH_AMOEBA_TOOL` and
`ORBIT_GRAPH_AIR_TOOL`, otherwise by the shared `ORBIT_BUILD_ROOT` paths. The
entry never builds. Existing CGRA models default to
`reference/input0-neighborhood/models` in the artifact repository, overridable
with `ORBIT_CGRA_MODELS`. The original pass receives explicit `model`, `architecture-path`,
`architecture-contract` and existing-model source-provenance options, plus the
same architecture through `--neura-architecture-spec`. The native configuration
contains choices such as `amoeba.default_shape=[1,1]` and
`amoeba.legacy_differential=true`; actual fabric and PE dimensions come from the
architecture parser. `ORBIT_CGRA_ARCHITECTURE` can override that file. Missing models fail explicitly. All commands,
subprocess wall times, source snapshots and SHA identities are preserved.

The compiler-only regression is
`orbit/test/TaskflowAmoeba/program_graph_v12.py --tool AMOEBA --core-tool CORE
--config TARGET.json --architecture ARCH.yaml --models EXISTING_MODELS --output NEW`. It invokes the original native driver with
`decision-flow=program-graph backend=amoeba`. Search must retain at least three
legal scored candidates, materialize a source-changing structural action and a
shape action, and prove a second-round parent lineage. JSON/DOT and source/graph
identities are checked against native feedback. Exact resume and restored replay
must agree; mutations of retained source-binding, version, data-edge and
reachability witnesses must fail replay. A coherent checkpoint score/feedback edit and a changed
actual source must also fail. These are reconstruction/binding
negatives, not a JSON program import or a replacement for the C++ semantic
checker.

The unchanged eight-candidate `compute_contract_v8.py` test additionally invokes
the real existing predictor and production Analytical scorer. Removing only the
published public compute value must reproduce the delivered pre-adapter golden
score rows, schedules and shortlist exactly. That existing fixture has one
firing and no explicit communication; it proves interface preservation rather
than multi-trip accuracy, real mapping success or ProgramGraph migration. The
new add/scale fixture has 16 source firings per task. The regression checks
receipt II/startup against the actual emitted model catalog, firing counts
against source iteration domains, integer durations against task start/end
cycles, and every compiled II against the mapped task signature. It binds
`neura-source.mlir`, `mapped.mlir`, `mapper-score.jsonl`, the model catalog and
`backend-receipt.json`. Requested legacy differential output must be retained;
untiled cases require identical old/common scheduling, while a tiled correction
must preserve both actual traces and explain its region accounting.

Resource units remain distinct: CGRA block count and occupied shape are not PE
rectangle size, and an irregular shape's occupied count need not equal its
bounding rectangle area. The initial v12 bridge deliberately uses rectangular
shape choices; it does not establish general irregular-shape support. Existing model inference is conditional mapped-DFG II
in cycles. Actual mapper II, predicted II, structural startup, source firing
count and scheduler duration need separate provenance. Unknown SRAM byte
capacity and external/local data-supply conditions must be reported as unknown,
not assigned a large sentinel capacity or silently marked verified. Without an
explicit validated clock, cycles remain cycles and milliseconds stay unknown;
the YAML simulator frequency is not a measured hardware clock.

The backend receipt exports its actual typed public-edge projection. The test
links every priced internal transfer to the common event, source version and
copy endpoints, verifies the exact rectangle and bytes-to-bits conversion, and
rejects missing or duplicate transfers. Control edges identify pure ordering or
data readiness without inventing another payload. The native evaluator also
requires that the production scheduler consumed those same graph/event/order
IDs. Original communication/dependency traces, actual architecture identity and
resource-binding scope are retained. Event-ordinal copy lifetimes are dependency
witnesses; they are not proofs of physical cycle-buffer capacity.

Common transfers must be charged once. A mapper compute value that excludes
inter-task movement can compose with common transfer scheduling, but the old
scheduler's communication cost cannot be added a second time. Legacy/common
schedule differences must state their placement, contention and serialization
policies rather than pretending that unlike timing boundaries are identical.
No physical CGRA execution is claimed by model, mapper or scheduler output.

For the optional NPU path, the generator copies the original source byte for
byte and emits three deterministic seed pairs. References evaluate `(A+B)*2`
in float64 and cast to f32. All inputs are staged per call; only ABI temporaries
are scratch. The existing profiler performs two warmups and five hot calls for
each seed. Independent audit rereads every saved C array against finite FP32
`atol=rtol=1e-5`. Expected 21 calls are counted from completed samples, not from a
predeclared success. AIR graph, runtime-transfer and physical-storage audits are
separate from numerical validation. Host timelines and wait spans are not CGRA
or NPU device-cycle traces, and planned transfers are not measured DDR traffic.

Earlier v9/v10/v11 tools, models, measurements and failures remain frozen under
their own identities. v12 writes only new results under
`results/taskflow/program-graph-amoeba-v12`.

Intermediate CPU evidence before final acceptance
--------------------------------------------------

`results/taskflow/program-graph-amoeba-v12/integration-cpu-r3/result.json`
reports CPU success with zero device submissions. Its native archive contains
six mapped, ML-scored candidates over two rounds: baseline, two resource shapes,
a real rectangular source partition and two combined shape/partition paths.
The independent Core checker passed 42 assertions, the then-executed compiler
harness passed 11 command groups, and all eight original-model contracts
preserved their pre-adapter scores and shortlist. The baseline and shape-only
legacy comparisons were identical. Tiled comparisons differed and retain both
schedules; this is not attributed solely to byte overcharge, because producer
pairing and region payload can both differ between representations.

That intermediate backend retained actual compiled II per task but did not yet
publish a fresh schedule using those compiled-II durations. It therefore cannot
serve as evidence for that later step. Read-only identity/receipt cross-checks
are saved in `.work/task-data-communications-v12/integration-r3-readback-r1`.
The newer strict regression requires compiled-II duration facts, the separate
post-mapper production schedule and its legacy communication/dependency traces.
Search scores remain ML predictions; a compiled-II schedule is still scheduler
model output, not execution timing. At that intermediate attempt, the rebuilt backend and optional same-source NPU
path were still pending; the final acceptance below supplies that later evidence.

The strengthened tile proof is intentionally conservative. One generated
negative initializes all of T, then reads `T[i,0]` while updating `T[i,j]` before
scaling the result. Native GenericAnalysis accepts its three-task source, but
the current adapter rejects its baseline access coverage before model/mapping;
it does not exercise a tiling action. `acceptance-r1` retains the original failed
test assertion that incorrectly expected such an action attempt.

A separate negative inserts unused foldable pure arithmetic before the add
loop. Its actual original source must pass model/mapping/scheduling, while the
native tiling action must explicitly record `semantic_invalid` because only
constant invariants are permitted outside the supported perfect nest. It uses
a two-evaluation budget so a successful baseline and action attempt are visible.
These tests distinguish source analysis, adapter eligibility and action legality;
neither is labeled a numerical failure or an executed unsafe transformation.
Target identity and target-config changes also have separate replay negatives;
the config mutation is a legal alternative shape and must fail checkpoint
identity binding rather than unrelated configuration parsing.

Final frozen acceptance
-----------------------

The root coordinator completed `acceptance-r2` in a clean environment. Its
`result.json` reports `all` success: 17 compiler regression groups, the unchanged
eight-candidate real-model golden test, and 21 NPU calls/outputs over three
seeds. The independent Core Amoeba graph checker contributes 42 semantic
assertions; those checker assertions are distinct from model, mapper and device
execution. `acceptance-r1` remains a failed test attempt: its cross-slice source
was valid but adapter-ineligible, so expecting a tiling attempt was incorrect.
The corrected test preserves that adapter rejection and separately proves an
actual native action rejection using a model/mapper-legal prologue baseline.

The final native archive contains six legal, scored and actually mapped
candidates across two search rounds. Real rectangular tiling changes the source
from two tasks with 16 firings each to eight tasks with four firings each.
Resource shape changes and both two-action orders are retained as actual
materialized source/configuration candidates. Exact resume, graph source,
target identity, version, edge and reachability mutations, coherent checkpoint
score forgery, changed source and changed legal target shape all have recorded
success/rejection results. Restoring the exact original bytes restores replay.

| Candidate | Source tasks | ML public schedule cycles | Compiled-II public schedule cycles | Compiled-II legacy schedule cycles |
| --- | ---: | ---: | ---: | ---: |
| Baseline, 1×1 CGRA | 2 | 67 | 69 | 69 |
| Shape 1×2 | 2 | 74 | 69 | 69 |
| Shape 2×1 | 2 | 66 | 69 | 69 |
| Rectangular tiling, 1×1 | 8 | 72 | 68 | 84 |
| Shape 2×1 → tiling | 8 | 68 | 68 | 84 |
| Tiling → shape 1×2 | 8 | 76 | 68 | 84 |

The unchanged ML predictor selects shape 2×1 at 66 predicted cycles. The separate
compiled-II schedule estimates 69 cycles for every untiled shape and 68 for
each tiled configuration. These are different model/evaluation boundaries, not
a hardware measurement or a claim that the predictor found the compiled-II
minimum. Actual mapped II is 2 for add and 1 for scale, including their tiled
children; startup and firing count remain separately bound in the receipts.
The original model files and parameters are unchanged, and this small six-point
comparison is not a new accuracy or generalization study.

Both ML-duration and compiled-II legacy comparisons are exactly identical for
baseline/shape-only cases, including payload endpoints and amounts. For tiled
cases, the public trace has four matching pairs
`add.tile.k → scale.tile.k`, each 128 bits. The legacy trace instead associates
`add.tile.3` with each of the four consumers, each carrying 512 bits. Thus the
migration changes producer pairing as well as payload granularity; it is not
just a byte-charge correction. Both traces and their schedules remain saved.
The lower public schedule estimate is not claimed as measured acceleration.

`independent-final-audit-r2/summary.json` reruns the SHA-bound executed compiler
evidence checker over all six retained receipts, catalogs, mapped IR and
production traces, and independently recomputes the three references from their
saved inputs. It rereads every raw NPU C array rather than trusting the profiler
pass flag. All 21 outputs are finite and pass unchanged FP32
`atol=rtol=1e-5`. Maximum absolute error is `1.1920928955078125e-7`, maximum
normalized L2 is `3.680515405998362e-8`, relative error for reference magnitude
at least `1e-6` is `1.4883142772053803e-7`, and near-zero maximum absolute error
is zero. Relative-floor/L2 metrics are diagnostic additions, not altered gates.

The same-source AIR package passes graph, final storage and runtime-transfer
audits. Its plan uses a 256 B local tensor pool, a 24576 B payload policy limit
and 192 planned DMA bytes; this is compiler accounting, not a physical bank
capacity or measured DDR traffic. The exact original source SHA
`167c00dcd93856c22dd7a17d1621b236361ef3b3fa1650d12c3fe90b845e3098`
and body fingerprint are checked across Core and AIR. Target-specific graph IDs
remain distinct. NPU validation covers the original add-scale program through
AIR; it does not execute Neura code or prove numerical CGRA hardware execution
of the six candidates.

Fifteen hot NPU host-wall samples have median 0.338853 ms; the host wait median
is 0.256505 ms. These prepared-call timings exclude separately recorded context
load, input/reference loading, numerical checks and evidence I/O. Actual selected
wait backend is `_wait_polling`, recorded after completed waits. Host timelines
are host-only. No v12 device trace was requested or collected. The reused v9
numeric auditor contains historical trace-exclusion prose; that generic text is
not evidence of any v12 trace experiment, positive or negative. The dedicated
v12 auditor explicitly records `device_trace=false` and uses no such prose.

Frozen identities and reproduction
----------------------------------

The measured shell source SHA is
`a4b543bdaa3885c49d6605afd5b872bd2fe5a806db7af3921951fd2422dfaf3b`;
the final executed compiler test SHA is
`6e152c1c2798c557afcb18af75727458673326c28e31bb1fdc39ba0adf83d392`.
The frozen Core tool SHA is
`5f0091f2a8e1b1453a9cb9f1e8d5851ae7f13a441d3ec7c1622ebf9f766c3ab1`
and Amoeba optimizer SHA is
`cab21e1b176f2f26698e265b067d909f6f416563c56815fd8aa1153d4be78f72`.
`acceptance-r2/input-identities.json`, `device-input-identities.json` and compiler
summary retain the other tool, architecture, model, graph, source and executable
identities. The actual NPU ELF SHA is
`6e3ea06d1d808702e1ae0c397697b78d355c77e9249a7e3db4b09b2860847b3e`.
Source snapshots and failed attempts remain intact.

For exact local replay with the frozen prebuilt tools, from the artifact
repository (the root hardware coordinator alone runs `all`):

```bash
artifact="$PWD"
frozen="$artifact/results/taskflow/program-graph-amoeba-v12/frozen-tools-r1"
env -i HOME="$HOME" USER="$(id -un)" PATH=/usr/bin:/bin \
  ORBIT_SRC="$artifact/../orbit" AIE_TOY_ROOT="$artifact/../aie-toy" \
  ORBIT_TEST_PYTHON="$artifact/../aie-toy/.venv/bin/python" \
  ORBIT_GRAPH_CORE_TOOL="$frozen/core/taskflow-opt" \
  ORBIT_GRAPH_AMOEBA_TOOL="$frozen/amoeba/mlir-amoeba-opt" \
  ORBIT_GRAPH_AIR_TOOL="$frozen/air/taskflow-opt" \
  ORBIT_CGRA_MODELS="$artifact/reference/input0-neighborhood/models" \
  bash taskflow/scripts/run_taskflow_program_graph_amoeba_v12.sh all NEW_OUTPUT

# Offline only: independently reread the new outputs and compiler evidence.
../aie-toy/.venv/bin/python \
  taskflow/test/TaskflowAIR/audit_program_graph_amoeba_v12.py \
  --acceptance NEW_OUTPUT --output NEW_INDEPENDENT_AUDIT
```

Use `cpu` or `compile-only` for no NPU submissions. For a new build, the same
entry accepts explicitly supplied current tools or shared build paths; it does
not rebuild or silently substitute the frozen binaries. The documented frozen
command identifies this measurement, not a claim that local binary artifacts
are shipped as source. Required LLVM/AIE tools, prebuilt optimizers and existing
model checkpoints must be available; missing dependencies fail explicitly.
