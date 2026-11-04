# Grouped control correctness failure: static and saved-output diagnosis

No NPU or target compilation was run for this diagnosis. Existing source, plans, AIR/AIE/runtime IR, inputs and output arrays remain unchanged. The compiler is the frozen production scalar tool `c9ad0b198d8ca3b7cc6c5a5d7777ad3283a06f87eea3f7789492b8d2d56542ce`; these results do not use the new mixed arithmetic implementation.

The r2 grouped M32x64 source is one shared perfect `i,j` loop nest, with four loads and two arithmetic/store pairs per point. It is not the earlier independent-top-level-loop fixture. The prepared and compiled source bytes match. Facts have two loops, and the checked plan has four M8 phases with offsets [0,0], [8,0], [16,0], [24,0] for every region. The final AIE core correctly loops over each local [8,64] buffer. Therefore there is no evidence supporting an `emitTileBody` loop-shift fix for this input.

`diagnose_grouped_streams.py` reads all three saved seeds and all twelve saved repetitions for both add and multiply. All 144 actual output checks fail the unchanged original source reference/tolerance. A diagnostic alternative matches them as follows (subscript denotes an M8 chunk):

| Actual output chunk | Diagnostic operands |
|---|---|
| Y0 / Z0 | A0 op A1 / A2 op A3 |
| Y1 / Z1 | B0 op B1 / B2 op B3 |
| Y2 / Z2 | D0 op D1 / D2 op D3 |
| Y3 / Z3 | E0 op E1 / E2 op E3 |

Every multiply output is **bitwise identical** to this diagnostic alternative. Every add output differs from that alternative by at most 1.1920928955078125e-7. This alternative is a post-hoc diagnostic, not a replacement reference or relaxed numerical acceptance. The original numeric failure is retained.

The final runtime IR submits one whole 2048-element BO-major transfer for A, then B, D, E. The compute-side S2MM0 BD chain cycles four 512-element destinations in A/B/D/E buffer order. All four incoming logical channels converge on this one compute DMA port, while shim packet/port assignments differ. The observed arithmetic is strongly consistent with BO-major producer streams being consumed as tile-major local buffer slots. This does **not** prove the exact causal packet-routing mechanism: no packet trace or hardware event capture was taken. Source indexing, total byte counts and local allocation checks can all be correct while stream storage identities are wrong.

The immediate conservative capability boundary is narrower than a source-language rejection: serial-tiled hardware stages with more than one phase require at most two distinct actual input storage streams and two output storage streams. Counts come from checked transfers, not storage names or an arithmetic matcher. Single-phase and resident routes are preserved. This bound describes the currently validated target lowering, not a claim that the silicon has no packet-multiplexing capability. Correct support for larger repeated fan-in needs an explicit checked serialization/packet/resource schedule and fresh full-output validation.

`stream-match-evidence.json` binds each raw array, source, plan and generated IR by SHA. Reproduce its saved-output checks with the existing NumPy environment:

```bash
$AIE_TOY_ROOT/.venv/bin/python .work/ffn-profiling-preflight/control-failure-r1/diagnose_grouped_streams.py
```
