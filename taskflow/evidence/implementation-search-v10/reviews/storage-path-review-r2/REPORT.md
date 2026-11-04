# Compiled storage endpoints and allocations — read-only audit

This report reads the16 successful packages in `compiled-final-r1`; the two tail
packages that failed before aircc are excluded. It introduces no compiler run,
NPU submission or cost model. `physical-paths.json` binds each input IR, native
plan, ABI, linker script/core ELF and read-only `llvm-readelf` output. The saved
native compiler is d89fa2e3…; these packages are not identity evidence for the
forthcoming corrected tool/architecture.

All52 compute stages and168 runtime tensor directions were correlated through:

1. ABI argument/storage and the final runtime `dma_bd`;
2. its `shim_dma_allocation` symbol, direction and channel;
3. an `aie.flow` source/destination DMA endpoint pair;
4. compute `dma_start` direction/channel and its local buffer BD;
5. the buffer's `orbit.storage` use and space2 memref;
6. final linker address/extent and the matching core-ELF symbol address.

These are emitted endpoint/connectivity and allocation facts. `aie.flow` is not
a decoded per-hop switchbox/CDO route. A stream between row0 and row2 may traverse
row1 switching even without a row1 DMA/buffer endpoint. This is not a claim that
memory tiles are unused or that all internal transport bypasses them.

## Concrete retained-panel example

Package `train-m32-k128-n64-t8x32x32-mixed8-panel`, first GEMM device
`orbit_segment`, computes on tile(0,2), with shim tile(0,0):

| ABI storage | Emitted path | Local buffer | Core linker/ELF address | Bytes |
|---|---|---|---|---:|
| B, arg1 | BO → shim MM2S0 → flow → compute S2MM0 | buf2, `memref<4096xf32,2>` |0x74000|16384|
| A, arg0 | BO → shim MM2S1 → flow → compute S2MM1 | buf0, `memref<256xf32,2>` |0x7c000|1024|
| intermediate, arg3 | local buffer → compute MM2S0 → flow → shim S2MM0 → BO | buf1, `memref<256xf32,2>` |0x78000|1024|
| reserved stack | core stack symbol `_sp_start_value_DM_stack` | separate reservation |0x70000|4096|

The stack range is [0x70000,0x71000). Named tensor payload is18432 bytes,
matching the planned stage allocation; no extra named local tensor buffer was
added. Static runtime BDs report B16384B, A16384B, and intermediate4096B for this
stage, because tile transfers repeat. These totals are descriptor lengths times
recorded repetitions, not measured DDR/LPDDR transactions.

The linker's remaining section-placement windows are named bank0 at0x71000
(length0x3000), bank1 at0x74000(length0), bank2 at0x78400(length0x3c00), and bank3
at0x7c400(length0x3c00). Bank1's remaining section window is empty after the
16384-byte B allocation; it does not mean the hardware bank has zero capacity.
Addresses are the compiled core's data-address view, not global host physical
addresses. The report records these window names/addresses without turning them
into a silicon-capacity assertion.

The full program ABI contains A16384B, B32768B, Y8192B and intermediate8192B,
65536B in total. `intermediate` is a system BO used to spill the GEMM output and
feed the later scale device. It is not an8192-byte persistent extra L1 tensor.
The scale stage explicitly reads arg3 from that BO through shim MM2S/core S2MM
and sends Y back through core MM2S/shim S2MM. Different device stages can reuse
the same core-local addresses; their payloads must not be summed as simultaneous
residency or described as cross-stage SRAM sharing.

## Bank, memtile, FIFO and scratch boundaries

Across all16 packages, final linker/ELF buffer base addresses are drawn from
0x71000,0x74000,0x78000,0x7c000. Every corresponding ELF symbol matches its linker
assignment. All52 stages reserve4096 bytes for stack. Maximum named compute
payload is18432 bytes, versus the native validated24576-byte **logical payload
policy**; reported extra named local payload is zero. Stack, code and other
compiler/runtime obligations remain separate. The logical pool is not one
physical bank and24576 is not established here as any physical bank's capacity.
Successful installed placement/linking supplies a further implementation check;
it does not prove every allocation below the logical sum will fit every
physical placement constraint.

The intermediate `aie.input.air.mlir` contains row1 memory-tile declarations
(for the example,24 declarations across its three devices). In the inspected
placed/final NPU IR those unused declarations are removed: no row1 buffer,
memtile-DMA op or row1 flow endpoint remains. Each audited tensor endpoint path
is shim-to-compute or compute-to-shim. Thus this exact emitted configuration has
no **explicit memory-tile SRAM staging allocation in the inspected IR**. This
neither generalizes to other AIR options/candidates nor excludes row1 stream
switching, fixed hardware FIFOs, configuration storage or unobserved internal
transport resources. No L2/memtile capacity or measured L2 traffic is inferred.

No `aie.object_fifo` operation remains in these final IR files. Lock-protected
core DMA rings and their space2 buffers are explicit and included in the payload
ledger. This does not mean that the hardware contains no FIFO or that FIFO
capacity/latency has been measured. AIR channel declarations are not additional
unaccounted tensor allocations merely by being named channels.

The104 saved `llvm-readelf` section/symbol reports cover all52 core ELFs. No
nonempty allocatable non-executable data/rodata/bss section is present in these
specific core ELFs beyond the named linker symbols/reserved stack. Empty bank
sections and nonallocatable `.stack_sizes` metadata are retained in the raw
reports. This is evidence about explicit ELF allocation, not an observed maximum
stack depth or proof of absent hardware/firmware scratch. Program `.text` is
separate code storage and is not charged as tensor payload.

Installed `MultiLaunchRunner` uses `xrt.ext.bo(device,size)` for ordinary operand
BOs, caches each BO set by `bo_key`, maps/copies host inputs, invokes sync and
starts the existing kernel. The numerical experiment declares temporary buffers
as intermediates (zero once per BO set, no host tensor copy thereafter), inputs
as per-call staged and outputs as readback. The read-only allocation source is
bound in `source-identities.json`. No BO physical address, physical backing-bank
capacity, cache coherence traffic, external-memory bandwidth, power or hardware
traffic counter was obtained. In particular, BO sync timing may include cache
maintenance and must not be relabeled as measured off-chip tensor-transfer time.

The current public target intentionally represents logical system BO storage,
a validated local payload pool and precise host-worker compute access; NPU
computation reaches local data through declared transport. This audit gives
compiled endpoint/allocation evidence for that abstraction's implementation,
not a claim that the abstraction describes every physical bank, memory tile,
FIFO or switch. The old16 packages preserve their own earlier metadata; all
corrected target/ownership bindings and code-generation changes require fresh
native plan/AIR/ELF identities and a separate audit before new execution claims.
