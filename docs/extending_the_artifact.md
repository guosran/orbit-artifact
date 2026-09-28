# Extending the artifact

The present schema is deliberately limited to front-end semantic closure. A future PolyBench or other workload adapter should add a separately pinned source fixture and its own manifest/schema, preserving the canonical result untouched. Workload equivalence must be established before reporting graph counts.

Backend capability projection should consume semantic graph IDs and explicit backend requirements in a new result family. Native cost should use measured backend runs with commands, machine metadata, and provenance; it must be labeled separately from analytical predictions. Neither new path should silently change `expected_semantic_closure.json` or reinterpret host JIT correctness as backend performance.

