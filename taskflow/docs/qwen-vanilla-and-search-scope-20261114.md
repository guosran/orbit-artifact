# Qwen original-CLI measurements and search-scope correction, 2026-11-14

The unchanged Triton-XDNA CLI ran successfully on the NPU in three fresh processes. A separate warm comparison invokes the original unmodified functions with model/context preparation outside the request timer. The existing ORBIT r19 selected graph was replayed on the same board; this experiment does not add a new search result or a new fusion implementation.

## Results

Model: Qwen2.5-3B-Instruct Q4NX, all 36 layers and LM head. Prompt IDs `[785,6722,315,9625,374]`; actual generated outputs 128; 127 decode calls after the prefill first token. CPU thread count 4. Warm protocol: one warmup and three measured requests per implementation, sequential runs, context length 2048.

| Prepared warm request | Original unchanged functions | ORBIT existing selected plan |
| --- | ---: | ---: |
| Full-request samples, ms | 7475.656 / 7542.131 / 7533.805 | 6658.336 / 6951.956 / 6551.491 |
| Median full request, ms | 7533.805 | 6658.336 |
| Median time to first token, ms | 1303.535 | 480.992 |

The measured full-request speedup is **1.1315×**, or **11.62% lower latency**, on this prompt. This is a small sequential three-repeat experiment without a confidence-interval claim. It does not attribute the gain to an individual transform.

The native warm wrapper constructs the original `Qwen25Prefill` and original AIR `FusedDecoder` before timing. Each request includes context clear, original prefill, first-token selection, KV stack/seed, and original `_decode_loop`; numerical gate checking is outside the timer. ORBIT includes its existing per-call boundary instrumentation. Preparation and model loading are outside both warm request timers.

### Direct original CLI

The original CLI uses commit `79d7ae3d1df7b52d87595f774bf6421b07cb9162` with the pinned AIR dependency `66a24f982a1e78553f682c5740d50c2216444584`. Both repositories' tracked files remained clean. The exact argv and environment, six original source hashes, stdout and resource records are in [the evidence bundle](../evidence/qwen-vanilla-20261114/raw-cli/exact-cli-results.json).

The three setup-inclusive fresh-process wall times are **40.236 / 53.749 / 37.376 seconds**. These include model load and native initialization and are **not** the baseline used for the warm speedup. The native CLI selects the smallest cached decoder context, 256 here; the separate native API wrapper explicitly uses 2048 to match ORBIT. Native printed prefill/decode timers have the original limited decimal precision and do not form an independently measured complete-request boundary.

The original driver initializes `gen_ids = [first]` and then performs `n_tokens` decode iterations. Therefore `--max-tokens 127` produces 128 actual outputs for this invocation. The initial diagnostic used 128 and produced 129; it is preserved and explicitly excluded from the 128-output comparison. All three exact-output CLI runs passed the unchanged first-token and stock decode gates.

### Numerical acceptance and replay integrity

The fresh ORBIT run passes the independent timing/physical-execution/memory audit, and passes the established original mutual-top-5 gate against both the previous r19 capture and the HF reference (first 32 steps). Its 128 saved logit rows are bit-for-bit identical to the previous r19 result. Audit references are nonempty and no code-drift or numerical-gate override was used.

**Native original and ORBIT token sequences agree for the first 96 outputs and first differ at zero-based output index 96** (native token 9625, ORBIT token 14648). They are not full-output-equivalent. The HF reference also has an earlier top-1 divergence while passing the established top-5 tolerance. Passing that gate does not establish full 128-token semantic equivalence or bitwise equality with the native run. Raw native runs retain their stock first-token/10-token gate; no new native logits capture was fabricated.

The selected graph ID remains `c5d291cb9a5b74162395951b50fe3fd9b315a453ed45eec52e22da2a36c2b5c7`. Six retired historical producer scripts were restored byte-for-byte from the pre-cleanup source archive into a new isolated run directory. Only their locations and the new output/CPU-preparation paths were rebound in a new receipt; old sealed receipts and the compiler working tree were not modified. Pre/post verification found no file drift. The initial replay attempt deadlocked on a redundant parent lock before measurement; it is excluded and retained as a failed diagnostic. The successful retry uses the frozen runner's own device lock.

## What fusion currently means

Fusing a small producer/consumer with a large operator can reduce launches and intermediate transfers. Whether it wins also depends on layout conversion, synchronization, scratch capacity, pipeline overlap and the tiling it permits. A candidate catalogue must contain those physical implementations before placement search can compare them.

The current compiled FFN manifest says `single-xrt-dispatch-multiple-firmware-array-configurations`: one host submission sequences separate up, gate, SwiGLU and down configurations. Intermediate tensors use **device DDR BOs** and `sram_residency_claim` is false. This is host submission fusion, not an implementation of a GEMM epilogue or an on-chip FFN producer/consumer pipeline. The selected configuration uses only the L35 reload/up-gate FFN candidate. The 37 compiled CPU regions also have **zero proven native multi-operator fusion** in the generated-code audit; a region label alone is insufficient proof.

Consequently the current result does **not** establish that small operators are best left on CPU. True GEMM-plus-small-operator fusion must be included and measured before making that conclusion. The selected FFN's causal contribution to full-request latency has not been isolated with an otherwise-identical counterfactual.

## What tiling currently covers

The catalogue contains **18 distinct compiled GEMM artifacts**, instantiated at 36 layer positions (**648 implementation choices, not 648 distinct tilings**). Variants include L2 `(M,N,K)` of `(128,256,64)`, `(128,512,256)`, `(256,256,64)` and gate/up `(128,256,32)`, 2×4 or 4×4 core shapes, and two-way output-N replication at column offsets 0 or 4. Full per-artifact parameters, residence policies and sampled L0 prices are in [search-scope.json](../evidence/qwen-vanilla-20261114/search-scope.json).

| L0 callback, ms | Original NPU route | Custom GEMM candidates |
| --- | ---: | ---: |
| QKV | 1.964 | 8.114–10.656 |
| Output projection | 1.128 | 5.462–7.276 |
| Down projection | 2.635 | 22.382–25.065 |

These are inclusive callback prices, not isolated kernel-cycle measurements. The custom route closes its context after each call, clears padded host weight packs and allocates/uploads device BOs again. Retaining the original BF16 weight view does not retain the packed weights or device BOs. The original route has a different persistent/static weight lifecycle. Therefore the loss is confounded by preparation and residence policy; it is not evidence that tiling itself cannot improve performance.

Decoder search currently chooses among four complete decoder contexts (coalescing × pure-host RoPE prefetch). It does **not** explore arbitrary internal decoder GEMM/attention tilings. The full-request result should not be described as exhaustive search over all fusion, tiling, dataflow and residence implementations. Useful follow-on implementation work is matched-lifecycle tiling variants, real on-chip producer/consumer fusion, and decoder-internal tiling; those are open gaps, not completed by this measurement.

## How the original launches work

For this model `auto` resolves to Triton prefill; a fused prefill implementation is unsupported. The original prefill `_layer` executes helper operations sequentially, with matmul/RMSNorm/SwiGLU available on NPU and attention/RoPE/residual work on CPU. A logical GEMM can itself perform **multiple** launches: `triton_matmul` loops over M tiles and calls `launch` inside that loop. RMSNorm is also row-tiled. Thus “exactly one launch per logical operator” is inaccurate.

Decode differs: each generated token uses one original `FusedDecoder.dispatch` covering **all 36 layers and LM head** on the device. That host/device dispatch can sequence multiple internal kernels/configurations. The original is not a CPU loop launching every individual decode operator.

Source locations at the recorded commits: Triton-XDNA `examples/llm_q4nx/llama_prefill.py:670` (`_layer`), `kernels.py:675` (`triton_matmul`) and `:797` (M-tile launch loop); pinned AIR `programming_examples/llms/qwen25_3b_q4/qwen25_3b_q4_inference.py:121` (`FusedDecoder`), `:324` (`dispatch`) and `:461` (`_decode_loop`).

The older local build copy has a patched `kernels.py` (an extra shared-weight BO binding) and is **not** pristine vanilla. This experiment deliberately runs the clean vendor checkout. Earlier policy replays should not be relabeled as unchanged original-CLI runs.

## Evidence boundaries

[Machine summary](../evidence/qwen-vanilla-20261114/results.json), [native API results](../evidence/qwen-vanilla-20261114/native-api/result.json), [independent ORBIT audit](../evidence/qwen-vanilla-20261114/orbit-selected/independent-audit.json), [source verification](../evidence/qwen-vanilla-20261114/source-verification.json), and [experiment script snapshots](../evidence/qwen-vanilla-20261114/experiment-snapshots/) are committed. [The local input index](../evidence/qwen-vanilla-20261114/local-input-index.json) binds the large local frozen inputs, full traces and captures by hash; this compact bundle is not a self-contained replay installation and does not include weights/executables/captures.

Native `/usr/bin/time` reports max RSS 15,956,532 KiB; its `Swaps: 0` is not a sampled process VmSwap measurement. No zero-swap claim is made for that run. ORBIT's original measured RSS/VmSwap guard passed. Only this one prompt/request size was measured.
