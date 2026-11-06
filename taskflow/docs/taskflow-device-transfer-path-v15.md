# Device tensor-transfer path audit, v15

This document combines a static path audit with the separately identified
coordinator-run trace experiment below. The audit itself performs no build,
device call, calibration or search, and preserves v13/v14 source, freezes and
raw results. The inventory is
[`path-audit-r1`](../../results/taskflow/device-transfer-v15/path-audit-r1/inventory.json),
with full selected-file hashes. Descriptor lengths below are requested tensor
bytes, not physical DDR transactions or measured bandwidth.

## Existing executable path

V14's m4/m16 full-NPU calls reuse the v13 compiled three-task actual source:
`T=A+B; U=2*T; C=U+B`. They are not transfer-only kernels. Each package has one
complete NPU region, one compute core at tile (0,2), three host ABI buffers,
and internal local T/U buffers. The parent ProgramGraph's region-visible
transfers project into the child's checked whole-resident AIR implementation.
The frozen executor binds mapped BOs and invokes the existing MultiLaunchRunner.

| Package | Each A/B/C tensor | Requested runtime tensor bytes/call | Runtime descriptor tasks |
|---|---:|---:|---|
| m4×64 | 1024 B | 3072 B | A import, B import, C export |
| m16×64 | 4096 B | 12288 B | A import, B import, C export |

For m4, final AIE runtime descriptors have element count 256 and unit element
stride; f32 gives 1024 B each. m16 uses 1024 elements. Direction names refer to
which side of a streaming endpoint moves memory:

| Tensor | Shim endpoint | Compute endpoint |
|---|---|---|
| A | MM2S channel 0 | S2MM channel 0 |
| B | MM2S channel 1 | S2MM channel 1 |
| C | S2MM channel 0 | MM2S channel 0 |

The final runtime configures/starts the C output task first with `issue_token`,
then starts A and B input tasks, awaits the output task, and frees input tasks.
This is an output completion-token dependency of this emitted program. It is
not three independently observed device transfer durations. Lock-protected
compute BDs and compiled core load/store/arithmetic loops provide the other end
of the stream. Host runner start/wait encloses their combined execution, DMA,
locking, queueing and possible stalls.

The runner performs three host TO sync API calls, including a conservative TO
on the output argument, then one FROM after wait. Those four API envelopes are
separate from the three tensor DMA directions. The BO-constructor implicit TO
observed in v14 occurs during preparation, before subsequent input resets. It
must not be counted as an extra compiled tensor transfer.

No explicit memory-tile DMA or SRAM staging endpoint appears in these inspected
final packages. Shim-to-core flows do not prove that row-1 switching or fixed
hardware FIFOs are absent. Local payload, reserved stack, code, trace buffers,
configuration state and unknown physical transport resources remain distinct.
The validated 24576-byte policy is a logical tensor-payload pool, not one bank's
physical capacity. Current source hashes are separately labeled from historical
package/ELF hashes; a source inspection cannot retroactively change a build ID.

## Common graph to DMA correspondence

Current `AIRBackend.cpp::tileDMA` locates the common transfer event by phase,
storage and bound input/output link. It rejects disagreement between the event's
transfer region and the phase witness, then emits external physical row-major
strides and densely packed local strides. The native transition witnesses are
not another authority for choosing tensor traffic. Allocation/event IDs in AIR
provide correspondence before installed AIR conversion; final channel symbols,
shim allocations, runtime ABI BDs, core BDs and ELF local-buffer addresses must
be audited afterward. A channel name alone establishes neither payload storage
nor physical traffic.

Historical controls retained in the audit include v6 add→scale 64×64, tiles
32×64 (four serial phases, 24576-byte payload, 81920 requested DMA bytes), and
GEMM 17×129×65, tiles 8×32×64 (all M/N/K tails; 11424-byte maximum payload,
131356 requested DMA bytes). The latter has nine checked hardware stages and
explicit FIFO legalization. Its actual success is evidence for that recorded
configuration, not arbitrary tail layouts or arbitrary channel fan-in. Current
public-graph lowering must retain its own fresh identities and checks.

## Supported granularity and proposed minimal control

The finite direct-AIR path supports static f32 identity-layout source memrefs,
exact affine rectangular accesses, and dense local rectangles. Host strides may
skip rows when a rectangular tile covers only some columns. An identity-layout
source restriction does not mean every tile is contiguous in the full tensor.
User-supplied arbitrary strided host layouts and guessed dynamic sizes are not
supported by that proof. Partial tiles use exact sizes; padding must be explicit,
not charged as invisible logical tensor bytes. Tiled execution is conservative
serial-by-phase, with explicit retained scopes and stage boundaries. Current
repeated-stage stream capability guards remain applicable; previous four-input
repeated-stage numeric failures are not repaired by this audit.

Use a single actual affine copy task, `output[i,j]=input[i,j]`, as the first
new control: one input, one output, observable complete output, scalar f32,
no math approximation, one complete runtime submission. Start with 64-byte
aligned requested lengths such as 1024 and 4096 B; this is a conservative smoke
choice, not an asserted minimum hardware alignment. The core still performs
loads/stores, so call it a **copy-program composite** until device events isolate
a useful transfer interval. Do not assert transfer domination from source shape.

A second control uses the same full logical copy and bytes with smaller checked
serial tiles. It tests descriptor/chunk overhead without Python changing IR or
making scheduling decisions. Require the original source body, full output
coverage and unchanged precision. Check per channel that total requested bytes
match between contiguous and chunked versions, while expected descriptor/task
counts change. Reject a control whose compiler coalesces all chunks if the
intended independent variable is task count. First avoid tails; then separately
use a nondivisible extent and independently audit final smaller BD lengths.

### Actual scout: chunk count and coalescing are different features

The coordinator's existing `scout-inputs-r1/seg8` compiled copy has E=2048,
256-element chunks: the native plan requests eight imports and eight exports.
The final shim runtime contains **two** task descriptors, each 2048 f32 elements,
because installed lowering coalesces the host side. The compute side has two
cyclic 256-element BD templates and an eight-iteration core loop. Thus the
native request count is 16, runtime task count is 2, and expected local chunk
transactions are 16. In this uniform coalesced path, R=E/C gives two runtime
BD tasks versus 2R expected local chunk transactions. Both account for the same
16384 requested bytes across the two directions. None is a physical byte count. The contiguous control's final
runtime count can also be 2; a runtime-task coefficient is not identifiable by
varying only this core chunking. Keep separate public request, runtime descriptor,
local chunk and core loop features. Shim traces should expect one start/finish
per direction for these emitted runtime tasks, not eight inferred chunk IDs.
The source and final IR/ELF hashes are retained in the audit directory.

## Installed tracing capability and acceptance boundary

The installed `aie.utils.trace.setup.configure_trace` accepts separate core,
core-memory, memory-tile and shim event lists (maximum eight slots). Its default
core list is instruction/stall/port activity, not DMA completion. Its shim event
list contains DMA start/finished-task events; generated AIE2 enums also expose
MM2S channel 1 start/finished events. This is a source/API capability, not a
successful AIR integration or device capture claim.

For the one-input/one-output copy, explicitly request shim MM2S0 start/finished
and S2MM0 start/finished: four slots. For m4/m16, request MM2S0, MM2S1 and S2MM0
pairs: six slots. The default shim list omits MM2S1, so accepting the default
would miss an input. Core-memory S2MM/MM2S pairs can provide a second endpoint
view only with separately proven routing and timestamp correspondence.

The old v9 trace script uses compute-core markers after input wait and before
output DMA. Its marked interval excludes those input/output transfers. Its
finite packet trace, PORT_RUNNING and core stalls are not device DMA timing.
A new compiler-owned diagnostic must start trace before runtime DMA starts and
stop/drain after output completion, record trace-buffer/resource changes, and
compare trace-off/on packages without weakening routing or numerical checks.
`start_trace` can add a buffer argument or reuse the output tail; either changes
the ABI/storage ledger and must be explicit. The existing implementation routes
trace egress through one shim and can perturb placement/channel pressure.

### Standard-tool instrumentation route

Installed `aircc --help` exposes only `--trace-size` and `--trace-offset`, not
`--trace-types` or custom event selection. The inspected AIR-to-NPU implementation
accepts trace sources only from core/memory tiles and hardcodes its event lists.
Thus its automatic trace option cannot establish the requested shim intervals.

A separate diagnostic can add declarative `aie.trace` operations to the complete
final NPU module: select the existing shim tile, `type=shimtile`, the four named
start/finished events, start broadcast 15 and stop broadcast 14. Add
`aie.trace.host_config` and `aie.trace.start_config` in the actual runtime sequence
before its first data task. Installed `aiecc` runs the standard trace stage;
its equivalent explicit standard pass pipeline is:

```text
builtin.module(aie.device(aie-insert-trace-flows,aie-trace-to-config,
  aie-trace-pack-reg-writes,aie-inline-trace-config),aie-fuse-trace-buffers)
```

The trace-flow pass appends stop-event generation at runtime-sequence end, after
its existing output await, and replaces a traced destination shim's self-broadcast
start/stop with USER_EVENT_1/0. The module-level fuse pass updates wrapper/callee
trace ABI together. Preserve the complete main wrapper rather than directly
launching an isolated device subkernel. This route uses installed instrumentation
APIs, not a new planner; successful lowering/capture still requires a separate
coordinator experiment. Production AIR remains byte-preserved and the diagnostic
derivative has its own identity and storage ledger.

In the inspected trace-flow pass, a fixed-length trace BD is queued; no explicit
trace-buffer drain await was found. Stop generation alone must not be called a
proven flush or complete readback of a short buffered packet stream. A selected
finished-task event may describe shim task completion rather than full downstream
consumer readiness; core locks and final output completion are separate evidence.
Missing terminal packets keep the interval unknown. No ad hoc nanosecond conversion
or physical-completion claim should fill that gap.

A meaningful smoke gate requires all of the following:

- Final ABI/channel/flow/core-BD correspondence and descriptor lengths; no hidden
  extra data DMA or unexplained tensor/trace allocation.
- Correct complete numerical outputs, successful original runner wait, and the
  exact source/AIR/ELF/tool/runtime/trace decoder identities.
- For every selected DMA channel, expected ordered start/finish counts with no
  missing/unterminated interval or ambiguous overlap. Event packets need not
  carry descriptor IDs; map them only when the static serial channel order and
  counts prove a unique association. Otherwise report unknown.
- Explicit finite-buffer completeness evidence. A correct output or nonzero
  trace buffer alone does not prove full trace coverage or no overflow.
- Native timestamp units retained as device cycles. No host/device alignment or
  calibrated nanosecond conversion is inferred from a viewer's display unit.

Even complete channel task intervals include device-side queue/stream/lock
conditions. They are not an off-chip byte counter or isolated physical memory
bandwidth. No coefficient or performance-search score is produced by this audit.

## Diagnostic preparation and overlap scope

[`prepare_device_dma_trace_v15.py`](../scripts/prepare_device_dma_trace_v15.py)
prepares, verifies and hashes paired diagnostic derivatives without compiling
or opening a device. Original production input bytes remain separately bound. It restricts the first smoke to the
actual one-input/one-output copy ABI with data shim channels MM2S0/S2MM0.
The first output-tail-reuse attempt compiled off but failed on: installed
`aiex.run` lowering rejects nested output-slice trace reuse. That failure is
preserved in the [r2 on-build log](../../results/taskflow/device-transfer-v15/path-audit-r1/trace-preparation-r2/on-build-r1/compile.log). The next preparation uses a separate standard
trace argument; the trace pass propagates it through the complete on wrapper.
The off derivative explicitly adds the same unused trace argument and forwards
it to its child. Both controls therefore use identical A/C/Trace BO extents,
with C unchanged and a separately allocated byte trace BO. This extra diagnostic
ABI is not silently imported into v14's calibrated three-data-argument domain.
The preparation receipt supplies standard `aiecc` command arrays, identities,
expected events and buffer obligations. Only the coordinator compiles/runs them.

The strict C++ final-IR audit in `DeviceTransferAudit` separately reconstructs
runtime/core descriptor geometry from parsed final AIE operations and correlates
source ABI, shim allocation, channel/flow endpoint, local copy buffer and public
transfer events. It restricts the supported path to a direct load→store,
zero-based unit-step copy with uniform chunks and no other arithmetic. The
caller must bind the parsed generic input, original AIR/compile-command chain
and ELF; a final-IR audit alone cannot authenticate machine-code equivalence.

One local input buffer and one output buffer do **not** prove physically serial
DMA. Lock release can allow the next input chunk and prior output chunk to
progress on different channels concurrently. Disabling ping-pong does not remove
that possibility. The public DMA provider and serial logical phase witness are
not a claim of one physical engine or complete resource scheduling. A guarded
submit-to-successful-wait composite contains whatever fixed-path overlap, core
copy work and stalls actually occur; its directional intervals must not be
summed into a purported pure-transfer total or physical bandwidth.

The companion `execute_device_dma_trace_v15.py` replays those two complete-main
ELFs with one shared three-BO set through unchanged MultiLaunchRunner. It resets
A, poisons C, clears Trace, and requires exactly three TO and two FROM calls in
both controls, plus one successful start/wait. Complete C must equal the frozen
copy reference exactly. It saves every raw trace, decodes one final on capture
through the existing decoder, and inventories event names/phases without
constructing missing task intervals or converting cycles to nanoseconds. The
script locks the NPU itself; do not wrap it in another NPU lock. Preparation and
CPU self-tests do not authorize a device-execution claim.


## First actual shim-trace attempt: zero capture preserved

The coordinator's [trace-execution-r1](../../results/taskflow/device-transfer-v15/trace-execution-r1/summary.json)
ran five off and five on calls, with two
warmups per mode. Independent offline checks confirm all ten C outputs exactly
match reference; every 4096-word trace array is zero. The existing decoder
rejects an empty/all-zero stream, so no DMA interval or trace duration is reported.
The bound review is
[path-audit-r1/trace-zero-review-r1](../../results/taskflow/device-transfer-v15/path-audit-r1/trace-zero-review-r1/review.json).

Both compiled main and child ELF metadata declare three data arguments. The
expanded on sequence patches trace BD15 to argument2, whose observed BO/map
extent is16384 B; A/C are8192 B each. Trace event configuration, shim packet
routing and USER_EVENT1 before data tasks / USER_EVENT0 after data completion
are present in emitted IR. These checks find no obvious omitted fourth data
argument or wrong trace-buffer index. They do not prove the hardware applied
all register writes or emitted packets.

The bound [expanded main sequence](../../results/taskflow/device-transfer-v15/path-audit-r1/trace-preparation-r3/on-build-r1/npu_seq_main_copy_path.mlir)
has data `npu.sync` at line197, stop writes at198–199, and immediately
`load_pdi @empty_1` at200. There is no trace S2MM1 drain await
between stop and reset. A short buffered trace stream being undrained or
truncated by reset is therefore a concrete hypothesis, not an established cause.
A local vendor core-trace test deliberately emits64 marker events to push bursts;
that workaround does not establish a legal shim flush API. No further hardware
attempt is justified here without a clear bounded mechanism.

Hot diagnostic medians (three calls/mode) are off/on runner wall328181/325631 ns,
start API6530/6680 ns, and wait envelope260563/260083 ns. These small host samples
are retained descriptions only: zero capture prevents a tracing-overhead claim,
and wait remains a compute/DMA/queue/stall composite. The original initial
`identity.json` retains `device_opened=false` because the observer did not update
that pre-execution field; actual call events and successful summary establish
the ten device calls. Original records are preserved without retroactive editing.


## Reproduction commands and remaining questions

Run from the artifact repository. These commands require the existing bound
packages and input/reference archives; they do not reconstruct historical
compiler binaries or silently replace old results. Use new output names. The
first command is CPU-only:

```bash
python3 taskflow/scripts/audit_device_transfer_paths_v15.py \
  --compiled results/taskflow/program-graph-heterogeneous-v13/training-compile-r1/m4-n64-all-npu/compiled/compiled.json \
  --compiled results/taskflow/program-graph-heterogeneous-v13/training-compile-r1/m16-n64-all-npu/compiled/compiled.json \
  --output results/taskflow/device-transfer-v15/path-audit-NEW
```

The following prepares the same finite shim-trace diagnostic from the saved
scout final AIE; preparation opens no device and performs no compilation:

```bash
source ../aie-toy/scripts/env.sh
BASE="$PWD/results/taskflow/device-transfer-v15"
NEW="$BASE/trace-reproduction-NEW"
python taskflow/scripts/prepare_device_dma_trace_v15.py \
  --aie "$BASE/scout-inputs-r1/seg8/hardware/air_project/npu.input.air.mlir" \
  --trace-bytes 16384 --peano "$PEANO_INSTALL_DIR" --output "$NEW"
```

The [r3 instrumentation receipt](../../results/taskflow/device-transfer-v15/path-audit-r1/trace-preparation-r3/instrumentation.json)
binds the actually compiled derivatives and standard `aiecc` argument arrays.
For a fresh reproduction, the coordinator can execute the new receipt's arrays
in separate working directories; this is compilation, not part of the static
audit:

```bash
python - "$NEW" <<'PYCOMPILE'
import json,pathlib,subprocess,sys
root=pathlib.Path(sys.argv[1])
record=json.loads((root/'instrumentation.json').read_text())
for mode,argv in record['compile_commands'].items():
    work=root/(mode+'-build-r1'); work.mkdir(exist_ok=False)
    with (work/'compile.log').open('w') as log:
        subprocess.run(argv,cwd=work,stdout=log,stderr=subprocess.STDOUT,check=True)
PYCOMPILE
```

Only after successful compile/ABI/resource inspection, the NPU coordinator can
run the unchanged-runner observer. It acquires `/tmp/npu.lock` itself, so do not
wrap it in another lock. `input_with_addresses.mlir` is the compiled file with
lowered trace configuration; prepass `on.mlir` is not a substitute.

```bash
python taskflow/scripts/execute_device_dma_trace_v15.py \
  --instrumentation "$NEW/instrumentation.json" \
  --off-elf "$NEW/off.elf" --on-elf "$NEW/on.elf" \
  --on-physical "$NEW/on-build-r1/input_with_addresses.mlir" \
  --inputs "$BASE/fixture-smoke-r1/inputs-11.npz" \
  --reference "$BASE/fixture-smoke-r1/reference-11.npz" \
  --kernel main:copy_path --device-name orbit_segment \
  --warmups 2 --repeats 3 --output "$BASE/trace-execution-NEW"
```

The unresolved audit questions are deliberately narrow:

- Why did the emitted trace path return no packets? Short-stream buffering,
  absent drain completion and immediate reconfiguration are plausible; no one
  is proven to be the cause.
- What DMA/channel overlap and stalls occur inside successful wait? Neither
  public serial chunk order nor two runtime BDs answers that physical question.
- Which hardware completion boundary do shim task events establish? The zero
  capture cannot establish endpoint durations, downstream readiness or DDR
  visibility.
- Does a different layout/tail/channel arrangement preserve the same path?
  Historical successes and this uniform-copy audit do not authorize that
  extrapolation. Fresh descriptor/resource checks are required.

The accepted path evidence remains exact logical geometry, compiled endpoints,
checked requested-byte accounting and successful copy outputs. Pure DMA timing,
physical traffic and trace completeness remain unknown.
