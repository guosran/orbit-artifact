# Frozen expected result

`config/expected_semantic_closure.json` is the authority for required numeric invariants: 5,280 action attempts, 126 graphs, 126 witnesses, 126 verifier passes, 126 graph-fact matches, 504 host executions, 172,800 element comparisons, zero numeric mismatches, and one injected and detected mismatch. The validator checks these in that order and stops at the first difference.

The 126 expected graph IDs are in `reference/semantic_closure_summary.json`. They identify source-owned semantic graphs. The reference is a comparison target only; every run creates new C++ manifest, witness replay, host numeric audit, and derived summaries. Tables are generated from run JSON, never copied from this document.

The pinned closure commit's prior manifest contained 5,920 action attempts, so the action invariant is known to be at risk. A new run determines the result; do not reinterpret a failed validator as a pass.

