# CP-SAT v22 evidence index

Read [the validation report](../../docs/taskflow-cpsat-v22-validation.md) and
[summary.json](summary.json) first. [scaling.svg](scaling.svg) separates bounded
solver samples from full native discovery/pricing/checking.

- `cpu/`: accepted r5 synthetic rows, pre-worker validated baseline witnesses,
  42 oracle/limit cases, six native contracts and five native scaling cases.
- `hardware/`: all three campaign summaries; accepted actual AIR/AIE and full
  per-core implementation receipts for seven r3 variants of four source graphs.
- `multicore-contracts.json`: one positive and 14 corrupted AIE cases. A semantic
  receipt is required; crashes/parse-only failures are not accepted negatives.
- `regressions/`: Core44, combined61, original Neura/CGRA and unfiltered lit35.
- `raw-manifest.json`: SHA256 and size of 20,592 local raw files at export time,
  including complete outputs, ELFs, baseline witnesses and failed campaigns.
- `campaign-r3-source/`: exact pre-relocation experiment sources matching that
  older campaign's recorded source hashes. Performance orchestration has since
  moved to artifact `taskflow/scripts/`; production optimization stays in Core.

Authoritative local raw roots are sibling `results/taskflow/cpsat-v22-*`.
The preferred solver campaign is r5. r1 used an insufficient return reserve;
r2/r3 exercised the revised phase budgets; r4 preserved a Python import failure
during reproduction relocation. No old run was overwritten. Hardware r1
included an overlapping Core build and is exploratory. Both r2 and r3 avoid
concurrent builds/timing campaigns from this task, and their differing timings
preclude a stable acceleration claim. All final 441 r3 calls and complete arrays
pass both numerical references at unchanged tolerance.

Full raw compiler/regression artifacts remain ignored; their identities are
listed here. Absolute paths and tool hashes describe the validation host and
must not be silently reassigned to another compiler. Reproduce into fresh
output directories with the documented explicit tool paths.
