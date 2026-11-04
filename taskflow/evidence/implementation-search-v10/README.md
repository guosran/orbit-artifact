# Implementation search v10 evidence

This is a curated, byte-bound copy of the original local v10 experiment. The
manifest maps original acquisition paths/SHA256/size to repository-relative
copies. Large text is losslessly gzip encoded with both byte identities. Original
paths inside reports are unchanged historical facts. The verifier never opens
those original paths. Every one of the 474 output NPZs is checked against its
included independent FP32 reference at the unchanged atol=rtol=1e-5.

Verify offline (NumPy is the only non-stdlib dependency):

```sh
python export-source.py --verify .
```

The curated compiler witnesses contain all 24 complete program packages: 18
registered candidates, four native selected/control/exploration packages, and two
full M5 FFN packages. Search archives preserve native ranking/actions/parents and
uncalibrated reasons. Unpriced exploration remains separate from model winners.
No model parameters are changed by this export or verification.

`EXCLUSIONS.json` explicitly records omitted large FFN input/weight BOs and frozen
executables. Sources, seed/reference data, input SHA and commands make regeneration
reviewable; compiler caches and physical DDR traffic counters are not claimed.
The exact frozen-r3 source manifest binds executed native tools; export-time
repository HEAD/diff/worktree records describe delivery state separately. A later
commit receipt does not rewrite these original identities. Verification does not
establish device equivalence or significant performance gains, and does not run
the compiler/runtime/NPU. The full local raw evidence remains unchanged.
