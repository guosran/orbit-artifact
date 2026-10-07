# LLaMA GEMM source and materializer proof: R11b

This receipt separates source-level sibling facts from actual compiler materialization. It records three pairwise GEMM sibling rewrites that the R11b post-Neura materializer accepted, and three direct GEMM producer-consumer rewrites it rejected at the static Taskflow counter-domain check. It contains no search, native mapping, or performance result. The structured values and local provenance pointers are in [summary.json](summary.json).

## Source census and how to read it

The prepared LLaMA facts are in `mode=fact_only`, with nine tasks and eleven dependency records. The sibling scanner considers all 36 unordered task pairs. Three pairs are source-legal; the other 33 rows carry `source_status=illegal` and `sibling_contract_rejected`. That is the complete sibling-pair inventory only, not the whole transformation space or graph candidate surface.

For a sibling row, `source_status=legal` means the source predicate accepts the ordered pair as movable, with equal loop domains, no Taskflow dependency either way, and a shared read/input. It does not prove post-Neura materialization. The three legal pairs were conservatively labeled `materialization_status=unknown`, reason `needs-stateful-kernel-support`, because the facts pass does not run the separate materializer for kernels with carried state.

The facts artifact's `legal_actions=[]` and zero `action_diagnostics.considered` are emitted under `fact_only` mode. They are not counts for generated menu entries, attempted transformations, scoring, or selection. The `dependencies` array is a Taskflow dependence census, not a fusion action menu. Its three direct GEMM RAW edges selected for PC dry-runs are Task_0→Task_3, Task_1→Task_3, and Task_2→Task_6.

## Actual compiler dry-runs

Each tested sibling pair passed the frozen R11b post-Neura materializer and produced a fused task with sibling metadata. This demonstrates materializability for these exact prepared IR pairs; it does not establish that the full LLaMA search generated or scored them.

| Pair | Facts status | Materializer result | Emitted fused task |
|---|---|---|---|
| Task_0 + Task_1 | source legal; materialization unknown / `needs-stateful-kernel-support` | passed, exit 0 | `Task_0.fuse.Task_1` |
| Task_0 + Task_2 | source legal; materialization unknown / `needs-stateful-kernel-support` | passed, exit 0 | `Task_0.fuse.Task_2` |
| Task_1 + Task_2 | source legal; materialization unknown / `needs-stateful-kernel-support` | passed, exit 0 | `Task_1.fuse.Task_2` |

Tasks 0–2 have static dimensions `[320, 256, 256]`, 20,971,520 source firings, produced shape `[320, 256]`, caller shape `[512, 256]`, two auxiliary reads, and K extent 256. Their canonical kernels contain carried reserve/phi state. The facts extractor's conservative stateful gate is in `ExtractJointTaskGraphFactsPass.cpp:1977-2001`; the separate sibling materializer proves per-slot reserve/phi independence at `MaterializeNeuraJointRewritePass.cpp:2213-2280` and invokes that proof at 2443-2448. The dry-runs passed the sibling materializer's distinct-output and read/write alias checks at lines 2400-2424.

The prepared external-caller proof records eight separately allocated memref roots. This supports the no-alias source proof for the tested IR. It is not a search-wide alias census.

| Direct RAW pair | Producer static dims / firings | Consumer static dims / firings | Result |
|---|---|---|---|
| Task_0 → Task_3 | `[320, 256, 256]` / 20,971,520 | `[320, 320, 256]` / 26,214,400 | rejected: `post-Neura fusion requires matching static Taskflow counter domains` |
| Task_1 → Task_3 | `[320, 256, 256]` / 20,971,520 | `[320, 320, 256]` / 26,214,400 | rejected: same diagnostic |
| Task_2 → Task_6 | `[320, 256, 256]` / 20,971,520 | `[320, 256, 320]` / 26,214,400 | rejected: same diagnostic |

Each direct RAW edge carries 524,288 bytes in the source facts. The PC guard is `MaterializeNeuraJointRewritePass.cpp:3246-3254`; it precedes the later stateless-kernel guard at 3272-3280. These probes therefore establish the first PC blocker as unequal static counter domains. They do not establish whether later state or output restrictions would also reject the same PC pairs.

## Runtime and cohort status

The probes invoked the frozen R11b executable at `/tmp/orbit-input0-fusion-fission-r11b-20261007/runtime-frozen-r11b/.work/control-variables-and-tiling-20261007/mlir-amoeba-opt-fusion-fission-funnel-r11b-20261007` against the prepared `canonical.mlir`, pinned to CPUs 8–11. Full commands, exit codes, stdout, stderr, and output MLIR paths are recorded in `/tmp/orbit-r11b-llama-fusion-restriction-proof-20261007/commands.json`; a compact probe narrative is in that directory's `report.md`. These machine paths document this capture only and are not reusable clean-clone bindings.

At the recorded full-run batch snapshot, the R11b cohort was still running on LU, and no LLaMA full-stage search result was available. This receipt does not turn an absent LLaMA shortlist into a zero score or a completed cohort. For separate completed R11b controls, see [the controlled fusion/fission receipt](../fusion-fission-controlled-r11b-20261007/README.md); those controls are not LLaMA full-stage results.

Source guard locations refer to the ORBIT source namespace `4547a38` in `lib/Backend/Neura/Orchestration/JointScheduling/ExtractJointTaskGraphFactsPass.cpp` and `MaterializeNeuraJointRewritePass.cpp`. Absolute capture paths in `summary.json` are provenance pointers only.
