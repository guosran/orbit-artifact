# Qwen GEMM lifecycle and generated domain

Real model inputs: L0 QKV, M=5, K=2048, N=2560. Capture uses the unchanged original BF16 embedding and CPU RMSNorm prefix, then the original dequantized BF16 q|k|v weights. It stops at the GEMM boundary; this is not complete Qwen inference.

The custom runtime now offers an explicit persistent weight lease owning immutable padded BF16 snapshots and operand BOs, with host/device capacity checks and deterministic cleanup. Changing the original weight array cannot change a retained snapshot. Storage is device DDR; no SRAM residence is claimed. Existing sealed r18/r19 evidence remains untouched, and the prior receipt-bound runtime is archived here.

| Inclusive warm operator median, 3 samples | Run 2 (ms) | Run 3 (ms) |
|---|---:|---:|
| Original source call | 2.220 | 2.736 |
| Original persistent policy | 1.092 | 1.332 |
| Custom release after each call | 11.670 | 10.049 |
| Custom persistent context/weights | 1.829 | 1.138 |

The lifecycle confound is substantial. Relative order between the two persistent implementations changed between runs, so these small samples do not establish a reliable speedup. Run 3 preserves outputs: all 16 warmup/measured results are bit-identical to the original NPU output. The independent FP32 CPU-reference diagnostic fails equally for original and custom (max absolute error 0.0490613, relative L2 0.00602564); that failure remains recorded. No full-graph numerical gate has been weakened or passed by this standalone experiment.

Explicit weight snapshot/packing setup is outside persistent warm requests and inside release-policy requests. Cold setup and the first warmup remain separately recorded. Native inclusive service, context open, preparation, assembly and release are recorded; separate traced diagnostic dispatches split chain input staging, run creation/bind/submit, wait and output readback. Traced dispatches do not enter timing samples. The original non-chain launch exposes no MultiLaunchRunner boundary and is explicitly marked unavailable.

Capture peak RSS was 2,150,296 KiB; comparison peak RSS about 520 MiB. Per-key requested operand BOs are 12,337,152 bytes; opaque XRT allocations are outside that operand-only budget. The initial capture failed before touching NPU because resolving model.q4nx to its extensionless HF blob selected the wrong reader; the new attempt preserves the model filename and uses the original reader.

The current source/target generator emits 16,920 tuples for this shape, including equal-N replica counts 1/2/4/5/8, L1/L2 tiles and physical offsets. These are necessary supported-lowering constraints from the pinned source and hardware; compilation, mapping and numerical checks remain mandatory. A 12-evaluation experiment using the real C++ ORBIT beam is being prepared; this is not exhaustive search or the complete Qwen graph.

## Actual ORBIT search and independent validation

The actual C++ public ORBIT beam evaluated 12 choices from 16,921 declared choices (16,920 source/target-generated tuples plus original persistent baseline). The dimension is one compound kernel implementation tuple: this is not full Qwen graph search. Overall wall time was 37.774 seconds, including serial compilation and on-board evaluation, with no overall time cap. Eleven generated tuples were compiled; ten passed physical placement checks and bit-identical real-input comparison, while L1-M=128 remained Unknown after an AIR L3-access lowering failure. The domain was not exhausted and no global optimality is claimed.

The measured winner was L2=(128,256,128), L1=(64,64,64), replica=1, placement=(0,2). Its three-sample search score was 1.126842 ms against the initial original persistent baseline 1.397357 ms. The identity was then frozen before heldout validation.

**The apparent win did not survive validation.** Three fresh processes in AB/BA/AB order, each warm2/repeat9, gave original median 1.094834 ms and selected median 1.123433 ms. Ratio of medians was **0.97454×**; paired ratios were 0.97923, 0.85191 and 0.98190. All 66 warmup/measured outputs were bit-identical to the original NPU output. Cold snapshot packing/preparation and first context/BO dispatch are recorded separately.

The validated decision is to retain the original persistent baseline. This experiment demonstrates an actual source-generated compile/check/measure ORBIT search and exposes the lifecycle confound; it does not establish a Qwen speedup or completion of all graph dimensions.


## Actual 256-token source workload

`orbit-search-m256-and-heldout.json` records actual 256-token original embedding/RMS QKV input, M256/K2048/N2560 (2.684 GFLOP), not a small input merely padded to a large tile. Public ORBIT beam evaluated 24 of 16,921 source/target-derived choices in 215.96 s. Nineteen evaluations passed physical execution and raw uint32 equality; three compiler lowering failures and two XRT timeouts remain Unknown. Tiling, replicas and physical column/row placements were represented, including derived two-field neighbors. This is one compound operator implementation dimension, not the complete Qwen graph abstraction.

ORBIT retained original persistent at 1.497744 ms, compared with the best generated BM256/BN256/L2K64/L1M64/L1N64/L1K64/replica1/x0/y2 at 1.529303 ms during search. Thus the selected plan has 1x speedup.

A separately frozen **best generated challenger, not the selected ORBIT winner**, underwent three fresh-process AB/BA/AB checks (warm2/repeat9). All 66 outputs were bit exact. Ratio of medians was 1.09711x (original 1.667240 ms, challenger 1.519664 ms), but individual ratios [1.55621, 0.95924, 1.10498] include regression. This does not establish a stable speedup or justify full-model routing.

The raw-latency objective compares against a baseline measured once at search start; paired baselines measured within each generated evaluation drift (evaluation2 original 1.693789 ms versus generated 1.529303 ms). This scoring limitation is retained explicitly. A later normalized objective must be a separately versioned experiment, not a reinterpretation of the selected plan here.


### Baseline policy clarification and full function boundaries

`m256-baseline-policies.json` pins exact source and driver code. Pristine Qwen prefill QKV does **not** pass `stage_key`: it invokes no-chain row-block launches and restages weight operands. Its native driver nevertheless caches bounded hardware sessions; it is **not** the custom release-after-call policy. The explicit original persistent microbenchmark adds `stage_key` and retains the weight in device DDR. Custom persistence is also DDR residency, with no SRAM claim.

`comparison-m256.json` measures all four policies in a fresh process, fixed order, warm2/repeat9. Warm function medians (ms): original-source-call 3.387329; explicit original-persistent-policy 1.787087; custom release 11.814245; custom persistent 1.555302. All 44 outputs pass raw uint32 equality. This one-process policy comparison is separate from the three-process tiling diagnostic above.

Setup+first-call cold runtime costs (ms), same order: 495.277667 /34.534137 /16.343266 /10.806719. These include captured weight binding and first context preparation for the relevant policy, but exclude model loading and previously completed offline compilation. The custom compiler phase is reported separately. These are operator boundaries, not full-model TTFT.
