# VectorCGRA data-memory capacity measurement

The matching existing VectorCGRA configuration is `test_multi_CGRA_systolic_4x4_2x2`: a 4x4 CGRA fabric with 2x2 tiles per CGRA, two data-memory banks per CGRA, and 16 entries per bank. Its logical data payload is 32 bits per entry. That is **32 words / 128 bytes per CGRA**, or **2 KiB of payload storage across the 16-CGRA fabric**.

A small elaboration of two `DataMemWrapperRTL` bank instances with those test parameters observed 16 `RegisterFile` entries in each bank. `mk_data(32, 1)` has a 32-bit payload but the elaborated entry is 35 bits because it also contains predicate, bypass, and delay fields. Thus the wrapper's current RTL state is 1,120 bits / 140 bytes per CGRA including metadata. The capacity gate measures application memref bytes, so 128 payload bytes per CGRA is the matching quantity for that gate; 140 bytes is the separate bit count of this RegisterFile-backed RTL representation.

## Measurement command and result

Command (one CPU, pinned to CPU 10; no fabric-wide build or simulation):

```sh
cd /home/x/shiran/project/VectorCGRA && taskset -c 10 env PYTHONPATH=/home/x/shiran/project PYTHONDONTWRITEBYTECODE=1 python3 /home/x/shiran/project/orbit-artifact/.work/vectorcgra-sram-measurement-20261006/measure_data_controller.py
```

The run used Python 3.8.10 and confirmed affinity `[10]`. It elaborated the actual VectorCGRA `DataMemWrapperRTL`, twice (once per configured bank), and asserted both observed register arrays have depth 16. The full output is in `data_controller_measurement.json` and `run.log`; the reproduction script is `measure_data_controller.py`.

The installed PyMTL core available here is upstream 3.1.16, while the project guidance requires its custom fork. The repository's `cgra_env` snapshot contains the custom `RegisterFile` bytecode but omits its Python source. The script loads that existing bytecode and aliases the installed `Mux` solely to satisfy the legacy primitive import; with this selected test's combinational memory channel, no queue/Mux instance is elaborated. No dependencies were installed and no source files were edited; the pre-existing dirty VectorCGRA submodule state was preserved. Treat this as a focused bank-wrapper elaboration, not as a full-fabric run in the project's prescribed fork environment.

## Configuration and topology evidence

- `multi_cgra/test/MeshMultiCgraRTL_test.py:4274-4283` sets fabric rows/columns to 4x4, tiles per CGRA to 2x2, banks to 2, and bank depth to 16 for the exact named test.
- `multi_cgra/test/MeshMultiCgraRTL_test.py:136-162` computes global data words as `depth * banks * num_cgras`, sets the payload width to 32 bits, and creates `DataType = mk_data(32, 1)`. Lines 181-189 show that this test helper separately uses 16 registers per register bank and partitions the global address space into equal per-CGRA ranges.
- `mem/data/DataMemControllerRTL.py:163-175` creates one `DataMemWrapperRTL` per bank, plus one extra crossbar output used for nonlocal accesses. `mem/data/DataMemWrapperRTL.py:39-52` constructs each bank as `RegisterFile(DataType, per_bank_data_mem_size, 1, 1)`; its comment explicitly calls replacement with SRAM a TODO. Therefore the source proves configured bank words and modeled state, not a synthesized SRAM macro or area.
- `cgra/CgraWithContextSwitchRTL.py:101-109` instantiates one data-memory controller inside each CGRA. Its `:247-258` connections expose memory ports only to the boundary row/column PEs; the banks are centralized and shared within a CGRA, not individually private per PE.
- The helper at `MeshMultiCgraRTL_test.py:185-189` gives each of the 16 CGRAs a consecutive range of 32 word addresses. `DataMemControllerRTL.py:211-229` selects a local bank for addresses in that range and uses bank index `num_banks_per_cgra` for an address outside the local range. Lines `:461-480` route this extra port to the inter-CGRA NoC. The selected test does not define an external DRAM capacity; remote means another CGRA's local bank, not off-chip storage.

## Separate architecture resources and remaining uncertainty

The AMOEBA target config `config/architectures/amoeba_4x4_cgra_2x2_context6.yaml:5-19` specifies a 4x4 CGRA grid, 2x2 PEs per CGRA, `ctrl_mem_items: 20`, `context_mem_items: 6`, and `num_registers: 32`, but has no data-memory bank count, word depth, or payload width. The existing `amoeba_4x4_cgra_2x2_sram_pending.json` records that omission. Also, the exact-geometry VectorCGRA test helper uses `ctrl_mem_size=16` and 16 tile registers, so it does not instantiate every target context/control/register count verbatim.

These are distinct structures: `TileWithContextSwitchRTL.py:101-114` constructs a register cluster, control memory, and context-switch control separately; `CtrlMemDynamicRTL.py:67-70` stores control words in its own register file. None of those counts should be added to the per-CGRA data-memory payload capacity. The selected VectorCGRA test is a reproducible *configured reference instance*, not evidence that the AMOEBA paper or AMOEBA experiment hardware used 128 bytes per CGRA. I found no separate production/deployment memory configuration specifying SRAM banks, depth, and width for this AMOEBA target; the 128-byte setting is source-backed for this VectorCGRA test only.

The older `amoeba_4x4_vectorcgra_sram.json` capacity (8 banks x 256 entries x 32 payload bits = 8,192 bytes per CGRA) cites `test_verilog_homo_2x2_4x4`, whose test invocation uses a 2x2 CGRA fabric and 4x4 tiles per CGRA (`MeshMultiCgraRTL_test.py:4198-4208`), so it is the wrong geometry for the current 4x4-fabric / 2x2-tile target. Do not apply its 8 KiB value to this experiment.

For a capacity-gate run **if** the project adopts this exact VectorCGRA test as its target memory instance, use `capacity-bytes-per-cgra=128`, `grid-rows=4`, and `grid-columns=4`. The gate accepts one bytes-per-CGRA value and applies it to every CGRA. The exporter charges whole original memref backings per observed SRAM coordinate (`ProductionSramNativeUpperBound.cpp:229-244,379-416`); an upper bound above 128 bytes remains `pending`, not an actual overflow (`ProductionSramNativeCapacityGate.cpp:125-152`). Until the AMOEBA experiment hardware explicitly adopts these bank/depth/width settings—or a primary hardware config supplies its own—the correct AMOEBA target-capacity status remains pending.

The machine-readable proposed instance record is `proposed-vectorcgra-sram-configuration.json`.
