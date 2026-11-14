# Taskflow gap-closure checkpoint

This checkpoint is incomplete: the fixed source-pipeline regression still throws `std::bad_alloc`. Bounded search-debug execution was rejected by automatic approval review and awaits explicit permission. No root cause or complete aggregate pass is claimed.

All eight currently selected NPU correctness runs pass, with 147 actual submissions. Their 41 final AIE waves are independently rechecked by the latest tool. See `validation.json` for exact selected run names, source identities and capability limits. Historical and failed attempts remain separate evidence; they are not added to the selected result.

The compiler worktree patch applies to the base in `sources.json`. Compiler changes remain uncommitted, and the sixteen feature PRs are a size-bounded plan, not published branches. Search-performance campaigns remain paused; these receipts make no speedup claim.
