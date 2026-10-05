# Ray input-0, original AMOEBA II23 diagnostic

Validated makespan: **216,454 cycles**. Actual mapper binding, independent trace and complete numeric execution pass; numeric compared 61,892 elements with zero mismatches. The trace contains 27 tasks, 66 typed dependencies and 39 routed data pairs. SRAM remains unknown and `formal_go=false`.

This supplement uses runtime II23 with the unchanged training-II20 model and feature normalization. It also uses the explicit minimum-legal-profile initializer; original f45's default initializer failed when Task_13 had no one-CGRA profile. Task_13 uses its sole actual successful 2×2-CGRA profile, compiled II23, steps90, 1,472 macro firings and a fully expanded eight-step internal body. The complete suite has 216 attempts, 209 successes and seven explicit Task_13 failures.

`evidence.json.gz` contains exact text snapshots of the run, parent mapper/body files, source/model contract, command records and 13-case adapter/retimer acceptance. `manifest.json` inventories their original artifact-relative paths and byte sizes. The archive round-trip was compared directly with every original text payload; no hashes or binary compiler files are included. Embedded paths retain the measured-run provenance. Reproduction generates fresh paths and bindings as described in [the guide](../../docs/ORIGINAL_AMOEBA_INPUT0.md).

Read without extracting into a live run tree:

```python
import gzip, json
with gzip.open("evidence.json.gz", "rt") as stream:
    evidence = json.load(stream)
files = {row["path"]: row["text"] for row in evidence["files"]}
```

The frozen [summary](../../reference/input0-neighborhood/evidence/2x2-ii23-ray-diagnostic.json) is also used by the result viewer when local runtime directories are absent. The standard II20 ORBIT table and Ray fission supplement remain separate.
