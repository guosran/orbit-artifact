# Source38 GCN Tiling comparison

This independent addon captures the closed canonical Tiling256 run and the three-domain Source38 comparison. It references the unchanged published Full/Replica package at `832b9379453520b4e35a60328574932dd7c854cb`. No previous search, native or numeric run was repeated for capture.

Replica / Tiling / Full cycles: **920639 / 918724 / 918724**. Raw differences: Tiling−Replica -1915, Full−Tiling +0, Full−Replica -1915. Absolute differences of at most one cycle are interpreted as ties; raw integers remain intact.

Each domain independently started from the canonical program with 256 objective calls, five original native finalists and five strict numeric validations. The three-domain total is 768 original calls, including 512 from the existing pair and 256 from Tiling. The earlier 64-call mechanism diagnostic is separate. Capture adds zero calls.

Only output and cumulative legal domain differ in the verified search argv. The same Source38 optimizer, predictor inputs and frozen native mapper/scheduler are retained. The materializer support-boundary report separates unsupported preconditions, first failures and untested partitionability; it does not count an earlier tiling failure as proof that fusion itself is illegal. Native improvements alone do not establish fusion/fission benefit or repair every missing branch.

The separate one-process I/O snapshot and checkpoint/history rewrite dossier are observational source evidence. The rewrite proposal is unimplemented: no CPU share, per-file I/O share or measured speedup is claimed. Capture adds zero process samples and preserves the old prepared scripts.

The small disk-headroom receipt preserves the original 50-GiB gate and verified lossless archival of a closed negative-run checkpoint; its gzip bytes are not bundled.

Run `python3 diagnostics/gcn-critical-positive-compute-v38-tiling256-20261012/check_package.py` from the artifact root. The checker verifies the sealed small receipts and immutable relative references. Large engine audits remain external hash-bound provenance; host absolute paths inside receipts are historical locations. ELF files, caches and large journals are omitted. Fresh-machine end-to-end reproduction has not been tested. No default, formal, main or paper admission is asserted.
