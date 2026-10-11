# Source35 GCN: three validated finalists

| Space | Winner | Predicted rank/cycles | Native rank/cycles |
|---|---|---|---|
| shape | neighborhood-5213 | 0 / 926379 | 0 / 923357 |
| replica | neighborhood-1977 | 0 / 922980 | 0 / 921765 |
| fission | neighborhood-165562 | 2 / 929797 | 0 / 926921 |

Both the Shape and Replica winners are absent from the complete Full valid archive, including their exact final task-name/geometry vectors. This excludes a final predicted-Top5 omission of these winners. Full ranks all five finalists with the same native optimizer; its native winner is predicted rank 2 and beats ranks 0/1 by two cycles.

The first charged sequence divergence is call 4: Shape/Replica evaluate Task7→1×2, while Full evaluates replication of Task14. Both narrow-space winner paths start with canonical Task7→2×1 at call 6; Full instead spends call 6 on tiling Task27. The canonical parent survives all nineteen refreshes, but the existing sealed attempt analysis reports no Task7 shape attempts from that parent. This first loss is expansion coverage, not canonical-parent beam pruning.

Alternative pure Task7 prefixes are eventually generated. The pure 2×2 prefix (65591) is retained at refresh 6 and removed at refresh 7. A resource configuration matching Replica prefix 4 (116984: Task7=1×4 plus Task14 replicated twice) appears in round 9, but is absent at refresh 10 and has no valid children. Replica prefix 5 adds Task18→2×2 and is absent from the Full valid archive. These are necessary-condition resource matches; they do not equate run-local graph IDs.

Shape: 28 tasks, only shape actions. Replica: Task14 and Task20 each split into two replicas; no tiling/fusion/fission. Full: Task27 tiled four ways; Task14/Task16 replicated twice and Task20 four ways; no fusion/fission. Detailed final geometry, action labels, costs, all five native/numeric receipts, prefix matches and exact evidence hashes are in REPORT.json.

No scoring, native mapping or numeric execution was added. No checkpoint or giant Top5/result JSON was loaded. The archived refresh journal was verified and decoded to memory, without restoration. V37 comparison remains pending until its winner is sealed.
