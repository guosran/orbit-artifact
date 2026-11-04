# FFN profiling v9 evidence

These are byte-preserving copies of API samples, source/plan/compiler witnesses,
model/search/checkpoint reports, output/reference arrays and trace windows.
`manifest.json` binds their original paths, sizes and SHA256s. Large text files
are losslessly gzip-compressed, with original and compressed byte hashes checked.
Large generated
input/weight BOs and build caches remain in the complete local results and are
recreated by the profiling/optimization entries. Git does not contain those full
caches. Absolute acquisition paths inside old reports remain historical facts.

Verify without importing a runtime or opening the NPU:

```sh
python ../../scripts/export_ffn_profile_evidence_v9.py --verify .
python ../../scripts/export_ffn_profile_evidence_v9.py --unpack . --output /tmp/orbit-v9-evidence-NEW
```

Verification includes intentionally failing historical control outputs: it
requires their saved classifications and bytes to remain unchanged. This does
not turn them into accepted implementations. The original marked baseline trace
has a valid one-core compute bracket; the optimized trace lacks its end marker
and is partial. No trace supplies physical DDR traffic or whole-FFN cycle counts.
