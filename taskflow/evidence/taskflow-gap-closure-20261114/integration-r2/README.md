# Taskflow gap-closure completion

This revision resolves the P1 retained in commit 03fc2b79. A minimal JSON parse/erase/copy reproducer confirmed the LLVM owned-key tombstone copy failure. The evaluator now receives a fresh filtered configuration; the original target remains bound to source and artifact receipts. The user explicitly authorized the fixed two-round, 24-candidate regression.

The generic evaluator fallback now receives replay-checked normalized source; placed evaluation retains its original replica/placement source. The final full and Neura-disabled integration suites both pass. Priced baselines and unpriced placed alternatives remain distinct.

All eight currently selected NPU correctness runs pass, with 147 actual submissions. Their 41 final AIE waves are independently rechecked by the latest rebuilt tool. See `validation.json` for exact selected run names, source identities and capability limits. Historical and failed attempts remain separate evidence; they are not added to the selected result.

The compiler worktree patch applies to the base in `sources.json`. Compiler changes remain uncommitted, and the sixteen feature PRs are a size-bounded plan, not published branches. Search-performance campaigns remain paused; these receipts make no speedup claim.
