# ProgramGraph v11 validation

This stage puts actual Taskflow source facts, task instances, data versions,
location copies, transfers and conservative scheduling in one candidate-owned
ProgramGraph. C++ owns graph construction/checking, serialization, DOT export,
search and lowering. Python only prepares independent arrays, invokes tools and
audits emitted artifacts. v9/v10 measurements and models remain frozen.

`prepare_program_graph_v11.py` emits two plain computation/dependency programs:
A is `X=2*A`, `B=X`, `C=X`, with first→second ordering whose argument is never
loaded; B is complete GEMM→scale with explicit initialization and ordered K.
Three deterministic seeds have independent float64 references cast to f32.
Neither source contains mapping choices, channel operations or graph imports.

The Core `taskflow-program-graph-test` exercises both adapters through the common
checker and mutates source/instance domains, copy/version IDs, schedule coverage,
ordering, transfer rectangle/payload and accounting. Example A uses synthetic
CPU target costs explicitly, not CGRA/NPU calibration. Example B exercises
source-discovered read-only B-panel retention with tiling. The companion CPU
regression exports native graph JSON and DOT, checks two original C++ search
rounds, and rejects changed JSON/DOT on resume. These are compiler tests, not
numerical device acceptance.

```bash
# Prepare only, no compiler or device execution.
bash taskflow/scripts/run_taskflow_program_graph_v11.sh prepare NEW_OUTPUT
# Requires built Core taskflow-opt + taskflow-program-graph-test.
bash taskflow/scripts/run_taskflow_program_graph_v11.sh cpu NEW_OUTPUT
# Also requires the AIR-enabled tool and installed AIR/Peano toolchain.
# Compiles three complete GEMM-scale variants but does not submit NPU work.
bash taskflow/scripts/run_taskflow_program_graph_v11.sh compile-only NEW_OUTPUT
# Authorized hardware coordinator only: same checks/compiles, then actual runs.
bash taskflow/scripts/run_taskflow_program_graph_v11.sh all NEW_OUTPUT
```

`ORBIT_SRC`, `ORBIT_BUILD_ROOT`, `ORBIT_GRAPH_CORE_TOOL`,
`ORBIT_GRAPH_AIR_TOOL`, `AIE_TOY_ROOT` and `ORBIT_TEST_PYTHON` override paths.
The entry never rebuilds or selects a historical compiler implicitly. Command,
subprocess wall time, tool/source hashes and failure logs are retained in a new
output directory. Graphs and DOT come from C++, including search candidate
artifacts; Python does not recreate a production graph or sort search outcomes.

Actual NPU acceptance is coordinated separately by the root agent. It must bind
source/plan/graph/AIR/ABI/ELF, retain full outputs for all seeds and use unchanged
finite FP32 `atol=rtol=1e-5`. Independent runtime-transfer and final storage checks
remain required. A graph's event order is a conservative serial witness, not
measured device time. NPU support remains limited to legal native phase-local
and stage-local proven read-only panel realizations; arbitrary fanout shared SRAM
across device stages is not implied by the CPU example.

The whole-task CLI uses `--program-graph --target-config FILE`. Prepared A
configs contain `program_graph.adapter="whole-task"`, target `architecture`,
`choice.policy`, explicit placements and synthetic compute estimates. The host
program boundary has zero offload submissions; native B shares one submission
across all input dependencies. The fresh entry invokes five A configurations (including shared SRAM and
separate local memories) and
independently audits A and B. Native B uses the existing `--generic-map` path.

The exported schema is `orbit.program-graph.v1`: source facts, instances,
rectangular communications, execution-region boundaries, conservative schedule,
allocation-lifetime interpretation, the common ledger and cost summary. Its
identity binds the native canonical JSON excluding derived `id` and `cost`.
The independent audit reads that schema rather than inventing graph nodes:

```bash
python taskflow/test/TaskflowAIR/audit_program_graph_v11.py \
  --graph NEW/cpu/phase/program-graph.json --plan NEW/cpu/phase/plan.json \
  --fixture NEW/prepared/gemm-scale --case gemm-scale --output NEW/phase-audit.json
```

Optional `--air` checks the actual canonical AIR graph, copy-transfer,
computation-event and source-instance annotations. Static compact-loop template
IDs are not a device trace or a listing of every dynamic tile. Native
`--check-air` supplies the full template/backend correspondence check, and
hardware runtime-transfer/storage audits remain separate. Python checks source
snapshot/reference hashes and native source facts/ABI consistency; actual MLIR
SSA and access semantics remain the native independent checker's responsibility.

The hardware/all modes compile phase-local, retained B-panel and an actual
two-round automatic-search tile+retention candidate. They invoke the unchanged
existing profiler with three seeds, two warmups and five hot calls per program,
then independently read all 63 raw outputs against their references. Input BOs
are staged each call; temporary roles come from the ABI. Host timelines are not
device traces. The final submission count comes from completed profiler samples;
failed runs retain partial checkpoints. This entry source alone claims no
hardware or complete v11 acceptance. Historical v10 results do not substitute for v11
execution or common graph validation.

The graph also exports `computation_mlir`, the actual function body, and declared
input/output storage-location boundary maps. These are views of the same source
and ledger, not another computation semantics or a graph import interface. The
independent audit verifies the body fingerprint, boundary roles/locations, latest
live output versions, terminal completion coverage and shared submission IDs.
Native source-instance region checking additionally derives exact read/write
cell demand from real SSA/access regions, including self-initialization and
unions of split loop accesses. The artifact audit checks declared readonly
storage demand and forbids undeclared imports; it does not replace that C++
partial-region/SSA proof. `--negative-tests` mutates already exported facts in
memory and recomputes the outer ID before checking invariants; no executable
mock graph is emitted.

CPU evidence and the hardware boundary
---------------------------------------------

`results/taskflow/program-graph-v11/cpu-entry-r2/result.json` records a successful
CPU entry with Core SHA `cfd2472466682a4b71829686cd1bf933c490ab5ce41eaa464e70ee3e467d3f24`.
That run used the then-current common checker (34 assertions), exported 32
candidate graph artifacts and completed two native search rounds. Seven legal
candidate action chains combine automatic tiling and read-only retention.
Exact resume passed; independently changed graph JSON and DOT each caused
resume rejection, and restoring their bytes restored successful resume. The
negative commands deliberately return nonzero; their captured results are
expected failures rather than failed acceptance labels.

Each of five actual fanout exports also passed six independent in-memory
mutations (30 rejection checks across the five exports). These cover invalid
version producers, instance bounds, rectangle bytes, schedule predecessors,
early copy release and coherent removal of pure ordering. This is separate
from the C++ checker's actual-source tests, including coherent removal of a real
read and substitution of pure ordering with a fabricated data read. Counts must
remain tied to each checker binary; the later frozen checker adds two derived
peak-accounting assertions and reports 36.

For the same fanout source, shared-SRAM retention plans 64 transfer bytes;
separate local memories with retained transit plan 192, and separate local
memories with phase-local transit plan 256. Each has three data edges and one
pure-order edge. Their estimated complete times (4.1, 6.3 and 7.4 ms) are explicit
synthetic target examples, not measurements. All three host-program graphs
have zero offload submissions.

The concrete two-action search witness has candidate/source SHA
`671435a60e74773a567fb7ffe66fe36c56a3470d498be0d95d553b233b296d1b`
and graph ID `92b40acaa8416e07211306d95d1015cfb231a67b5a23dcbc2dfd1d89c348dfe4`.
Its recorded actions are `auto_tiles_8_16_16` followed by
`mapping_retain-across-users_storage_1_reuse_0_panel_1`. The hardware entry
compiles that actual archived source as its third program, alongside the two
fixed phase/retention witnesses. This sampling rule validates composition; it
does not claim a calibrated ranking or an optimal choice.

The coordinator completed `acceptance-r1` with tools from `frozen-tools-r1`.
The executed shell source SHA is
`424efddfb847b1b37f3a9b1d1765086d1bbda890464acf50046af3cd9e709242`.
That directory retains tool identities, source snapshot, exact commands and
subprocess wall times. Numerical, physical-storage and runtime-transfer
results are retained in that run. Its
raw independent audit checks each saved output against the original FP32
`atol=rtol=1e-5` contract and reports additional error metrics. Host API spans and
planned transfer bytes remain distinct from device cycles and measured DDR
traffic.


Completed whole-program device validation
-----------------------------------------

`acceptance-r1/result.json` and
`acceptance-r1/independent-numerical-audit/summary.json` both report success.
The same acceptance also passed all 36 frozen common-checker assertions and
10 compiler/search test groups, including two native AIR correspondence checks,
32 candidate graph artifacts and the JSON/DOT tamper/resume tests.
The root coordinator submitted 63 complete GEMM-scale calls: three programs,
three seeds, two warmups and five hot calls per seed/program. The independent
auditor reread all 63 raw Y arrays against the original float64-derived f32
references; all passed finite FP32 `atol=rtol=1e-5`. Maximum absolute error was
`7.152557373046875e-7`, maximum normalized L2 error
`2.3134276059199759e-7`, and maximum relative error with reference magnitude
at least `1e-6` was `2.0508682296359492e-4`. The latter is a separate diagnostic,
not a replacement for the combined absolute/relative acceptance rule.

| Complete program | Tile M/N/K | Planned DMA bytes | Maximum local payload bytes | Hot host-wall median ms |
| --- | --- | ---: | ---: | ---: |
| Phase-local | 8/16/32 | 221184 | 3584 | 18.562311 |
| Retained B-panel | 8/16/32 | 122880 | 9728 | 18.725276 |
| Original search tile+retention candidate | 8/16/16 | 122880 | 9216 | 18.440053 |

Each median has 15 hot samples. The distributions overlap; these measurements
do not establish a speedup. All programs have 65536 bytes of logical host BO
storage. The local payload is the validated compiler pool accounting, not a
claim that the device has one physical bank of that size. The separate final
AIE/linker storage audit and runtime-transfer audit passed for every package.
Their transfer counts verify emitted runtime descriptors against native plans;
planned DMA bytes are not physical DDR traffic measurements.

For all three packages, the exact original graph JSON and graph ID equal the
compiled plan's graph; source and plan SHAs match their semantic-bridge record.
The searched candidate's actual archived source was compiled unchanged.
Independent final readback is saved under
`.work/task-data-communications-v11/acceptance-final-read-r1/summary.json`.
It binds original/compiled graphs, plans, source, ELF, ABI and audit identities,
without modifying the frozen run.

The existing profiler measured detailed host-to-host prepared-call wall time;
context creation, input/reference loading, numerical checks and evidence I/O
remain separately recorded. The installed runner actually selected
`_wait_polling`, as captured in `profile-program-graph/wait-backend.json`.
Wait includes device completion and host/runtime polling. The host timeline
is not device trace evidence or a kernel-clock measurement. No additional
trace, calibrated model or arbitrary cross-stage residency claim follows from
this acceptance.

To reproduce with the delivered frozen tool directory (which also contains the
Core checker), from the artifact repository:

```bash
ORBIT_GRAPH_CORE_TOOL="$PWD/results/taskflow/program-graph-v11/frozen-tools-r1/core/taskflow-opt" \
ORBIT_GRAPH_AIR_TOOL="$PWD/results/taskflow/program-graph-v11/frozen-tools-r1/air/taskflow-opt" \
bash taskflow/scripts/run_taskflow_program_graph_v11.sh all NEW_OUTPUT
```

The frozen Core SHA is
`cfd2472466682a4b71829686cd1bf933c490ab5ce41eaa464e70ee3e467d3f24`,
Core checker SHA is
`01a7f57c6381581422475607180836d0cfa4366dce740c8d0f0722e256849db2`,
and AIR-enabled tool SHA is
`062d9990c6c49de1372507b45ce9ed976384f576cb48a7ea41d78bed4e0360f2`.
Historical failures and earlier checker identities remain in their original
attempt directories. The script supports built tools through path overrides;
this command states the exact tools used for the reported acceptance.

Final `core-regressions-final-r2/result.json` passes all38 Core/Amoeba/search/AIR
groups:36 common-graph assertions,79 data-organization checks,71 cost contracts
and15 graph-to-AIR binding checks are included. Independent Core's recorded
`ldd` has no Neura/AIR/AIE/XRT dependency. `delivery-audit-r1` additionally checks
canonical AIR for all three actually executed packages with the frozen compiler,
including the searched combination, and runs `git diff --check` on both working
trees. No new NPU work occurs in that read-only audit. `RESULTS.md` and
`DELIVERY.json` in the v11 result root summarize the final acceptance and scope.

`loop-fission-evidence-r1/summary.json` binds a real original-search
`split_outer_loops` transformation: one loop/three accesses becomes two
loops/six accesses, with refreshed source and graph identities. Its resident
copies and192 B traffic stay unchanged. This demonstrates loop-fission graph
refresh, not a new task-partition or NPU fission experiment.
