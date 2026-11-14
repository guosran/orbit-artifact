# Taskflow unification integration closure

Search optimization and new performance campaigns are paused by user request.
This record closes the reviewed source-transform and correctness integration.
The final compiler delta is compiler-worktree.patch against the base commit in
summary.json; docs describe scope, remaining capabilities and an 11-PR plan.
No PRs have been opened by this integration step.

Public fission, fusion, tiling, replica obligations and proof services build and
pass focused tests both with Neura enabled and with Neura disabled. Neura maps
Amoeba CGRA only; AIR-to-AIE is a separate backend. The final completion-storage
binding fix passes a forged-input rejection and compatible-output-cast test.
All four prior AIE implementations pass the final checker again without NPU
submissions (final-aie-recheck/).

The sibling result tree results/taskflow/taskflow-unification-20261114/
source-npu-smoke-r1/ records four already compiled FP32 pointwise 64x64 variants
with three independent CPU reference inputs each: 12/12 NPU runs have zero
absolute and normalized-L2 error. No search, ELF recompilation, warmups or
performance comparison was performed after the pause. These receipts establish
this workload's numerical correctness, not full-Qwen coverage or speedup.

The separate gemm-lifecycle directory preserves earlier performance evidence
with its exact policy/baseline limits. Its v3 pause record is not an admitted
optimization. Large-grid placement and physical replica realization are still
explicitly unsupported by the generic adapter. Experimental adapters/runtime
code live in the artifact repository, outside compiler PR budgets.

Compiler documentation links refer to files in the original checkout; their
contents are also included in the patch. The distilled review-guidance digest
is recorded rather than publishing another mutable copy of the sealed history.
