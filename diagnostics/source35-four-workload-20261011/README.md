# Frozen four-program evaluation, 11 October 2026

This snapshot contains the verified RADAR, LU, LLaMA and Harris evaluation: **24 independent ablation cells and 16 main-comparison cells**. Read the raw integer cycles and original candidate outcomes in [ablation.csv](ablation.csv), [main.csv](main.csv) and [evidence.json](evidence.json).

```sh
python3 scripts/show_source35_snapshot.py --check
python3 scripts/show_source35_snapshot.py
```

Fig3 uses **ORBIT = 1**, with `method cycles / ORBIT cycles`; lower is better. The geometric means for Seq25, Seq50 and Seq75 are 1.483753, 1.438008 and 1.515357. Each fixed split applies to every program.

## Protocol and versions

Each ablation starts independently from the same canonical program. The stages cumulatively permit `fixed 1×1 → shape → replica → tiling → fusion → fission`; co-tiling belongs to tiling. Each stage has a 256-objective-call cap. Fixed performs one objective call; all other published cells perform 256. Raw adjacent differences of ±1 cycle are reported as ties, without changing their integer values.

Joint and Sequential each have a total 256-call allowance. Seq25 allocates 64/192 calls to graph/resource phases, Seq50 128/128, and Seq75 192/64. Unused graph-phase calls are discarded, never transferred. Every published main cell uses its full allowance. Joint references the complete independently started Full256 ablation unit; it does not import a winner or rerun search, native mapping or numeric validation. The comparison accounts for 4,096 logical calls; the twelve new Sequential searches use 3,072 physical calls.

The original predicted top five are tried in rank order, without replacement. Every accepted candidate passes source replay, mapper equality, independent schedule tracing and strict numeric checks. RADAR Shape and Replica each retain two certified normal refusals by the frozen native scheduler (ranks 1 and 4), alongside three numerically verified candidates. They are recorded with null rejected cycles. All 16 main cells validate all five candidates. Fixed controls have one candidate.

The published [ORBIT repository](https://github.com/guosran/orbit) contains all required commits:

| Role | Commit | Recorded optimizer SHA-256 |
|---|---|---|
| Original search, Joint, Seq50/75 | `7c72cc4b4cd2d11f2c2449d8243dad93cf083067` | `2304dae3f8e1165950da939a84f58f5322371fa7edc74dd24ba5057991de4f6a` |
| Seq25 search | `93bfea39833ca88511ed7c7dc4e94bbffb943eee` | `4e0cd354b7731bb7989f1928373d2d0a4b895eb99bee6b52d52c6a7055fa68c9` |
| Frozen native mapper/scheduler | `9e7015c3bd4d44dd2ec37df6f02c09aaa0372e55` | `80f11127c25360b591cbd705d3e7d25d3060ba90cf2978f8d5a56133cf58a761` |

Seq25 adds only acceptance of `graph-budget-percent=25` and its diagnostic wording to the original source. Search, phase allocation, legal actions, model, costs, mapper and scheduler bodies are unchanged. Its actual source and binary are recorded separately; it is not claimed to be byte-identical to the original search binary. [protocol.json](protocol.json) records the guard-equivalence and original audit hashes.

The hardware/model inputs remain the existing [architecture](../../config/architectures/amoeba_4x4_cgra_2x2_context6.yaml), [explicit network](../../config/networks/amoeba_4x4_mesh_latency1_bandwidth32.yaml) and [direct ensemble](../../reference/input0-neighborhood/models/per-cgra-2x2/ensemble.json). Their hashes are bound in the snapshot. The reported cycles use native mapper II and the production scheduler.

## Preparing fresh commands on another machine

Use three clean ORBIT worktrees at the commits above and three separate build directories. The LLVM/MLIR revision and CMake/Ninja build commands are given in the [portable build guide](../../docs/INPUT0_NEIGHBORHOOD_REPRODUCIBILITY.md#historical-v38-source-and-build-inputs). Build each pinned source; newly built binaries receive fresh contracts rather than being relabelled with captured binary hashes.

The snapshot includes the exact canonical and prepared program bytes, compact case metadata, source-contract templates and captured C++ command templates. The preparer verifies the pinned source files, rebases captured input provenance paths, and writes a fresh protocol, source contract and command. It does not execute an experiment or resume an old result.

```sh
python3 scripts/prepare_source35_search_command.py \
  --kind main --method sequential25 --workload harris \
  --source-root /your/clean/orbit-seq25-checkout \
  --optimizer /your/seq25-build/tools/mlir-amoeba-opt/mlir-amoeba-opt \
  --output /your/fresh/harris-seq25
```

For an ablation, use `--kind ablation --stage fixed|shape|replica|tiling|fusion|fission` and the original search checkout. A Joint main result references the complete `fission` unit; the preparer rejects an additional Joint search. The generated `command.json` contains an argv list and working directory. Run it with an external 21,600-second limit and preserve outputs before replaying the original shortlist with the separately pinned native compiler. Existing [native replay](../../scripts/replay_cpp_global_top5.py), [trace validation](../../scripts/validate_embedded_native_trace.py) and [numeric replay](../../scripts/run_input0_numeric.py) tools expose their interfaces through `--help`.

Validation for this publication covers package hashes, all 40 result rows, budgets, ratios, source pins, candidate outcomes and actual command preparation on fresh paths. A new-machine end-to-end compiler build and full remeasurement have not been executed as part of this export. Full original journals, build closures, native/numeric outputs and lossless archive manifests remain on the experiment host; their sealed report hashes are indexed here. Captured input provenance paths are historical data, not required machine locations.

## Preserved negative results

[negative-results.json](negative-results.json) retains Source35 GCN's six stages, including its 5,156-cycle Full-versus-Replica regression, RADAR's original scheduler refusals, and the first Seq25 attempt's pre-search option rejection (zero objective/native/numeric calls). GCN was removed from this four-program evaluation by the author; subsequent GCN research belongs to a separate cohort. Earlier repository diagnostics and host negative evidence remain intact. No historical minimum or other controller version fills a row in this snapshot.
