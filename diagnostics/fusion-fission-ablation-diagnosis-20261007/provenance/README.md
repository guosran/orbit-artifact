# R9 primary-diagnosis provenance

This package records the last complete R9 primary diagnosis from `input0-neighborhood-2x2-v60-memory-fusion-fission-r5-20261006`. It was added on branch `codex/r9-primarydiagnosis-provenance-20261007`, based on artifact commit `3580fafe693109c21300171b41a5d215bc94cbdc`.

The completed result root reports `complete` for six workloads and five stages each, with final validation `native replay, independent trace, numeric, and exact source binding passed`. `commands.json` preserves the top-level command, workload recovery argv, and the recorded search, replay, numeric-top5, and numeric-controls command JSON objects for all 30 stages. Those historical records were read only; no experiment command was executed to make this package.

`provenance.json` inventories the 27 authoritative result-binding snapshots and computes BLAKE2b-256 digests. It verifies exact byte equality between the R6 frozen-runtime optimizer and source-contract files and their matching binding snapshots. The 19 contract replay payloads also match the R6 runtime files byte for byte; the embedded model text matches its bound `ensemble.json` snapshot. The contract's 140 source bodies match the reconstructed read-only source tree.

The source delta in `source-contract-vs-published-a75c848.patch` is reconstructed from those 140 embedded `{path,text}` bodies and `git show` reads at published source commit `a75c848eccc010a5c6923cc16fc0e3d6073da73a`. Its summary reports 113 identical blobs, 20 modified blobs, and 7 paths with no blob at that commit. The seven absent base blobs are represented from `/dev/null` and marked `base_blob_absent` in the JSON summary; they are not treated as known empty files.

`working-tree-artifact-main.*` and `working-tree-source-main.*` preserve the observed status and tracked diff of the current root checkouts. They describe present-day checkout state only and are explicitly excluded from the R9 runtime identity. The current `/project/orbit` HEAD is recorded as an observation; the runtime source identity comes from the R9 contract and its exact frozen inputs, not that current checkout.

For separate sequential Task 7 context, this package points to the existing [case.json](/home/x/shiran/project/orbit-artifact/diagnostics/sequential-comparison-fixed-fission-4096-llama/multi-output-case/case.json) and [case.md](/home/x/shiran/project/orbit-artifact/diagnostics/sequential-comparison-fixed-fission-4096-llama/multi-output-case/case.md) without copying the extracted C++ files. A sources-only body comparison records three R9/sequential differences and four R9/R11b differences; R11b is comparison-only, not an R9 runtime input.

Hash fields use BLAKE2b-256. No SHA-256 digests were computed for this package. JSON files were parsed after writing as a static syntax check; no test suite, build, search, mapper, native replay, or numeric command was run.
