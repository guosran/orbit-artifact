#!/usr/bin/env python3
"""Generate checked-in reports from fresh machine-readable run results."""
import json
from pathlib import Path
import re

from common import RESULTS, ROOT, write_json
from system_status import status


def latest(suffix):
    paths = sorted(p for p in RESULTS.iterdir() if p.is_dir() and
                   re.search(r"-" + re.escape(suffix) + r"(?:-\d+)?$", p.name))
    if not paths:
        raise ValueError("required run missing: " + suffix)
    return paths[-1]


def data(path, name):
    return json.loads((path / name).read_text())


def relative(path):
    return str(path.relative_to(ROOT))


def semantic_report():
    full = latest("semantic"); smoke = latest("smoke")
    run = data(full, "run.json"); sem = data(full, "semantic_summary.json")
    exe = data(full, "execution_summary.json"); neg = data(full, "negative_control.json")
    tests = data(full, "test_summary.json"); env = data(full, "environment.json")
    validation = data(full, "validation.json")
    smoke_validation = data(smoke, "validation.json")
    smoke_sem = data(smoke, "semantic_summary.json")
    smoke_exe = data(smoke, "execution_summary.json")
    smoke_neg = data(smoke, "negative_control.json")
    expected = data(ROOT / "config", "expected_semantic_closure.json")
    metrics = [("Action attempts", sem["attempted_actions"], expected["attempted_actions"]),
               ("Unique semantic graphs", sem["unique_semantic_graphs"], expected["unique_semantic_graphs"]),
               ("Materialized witnesses", sem["materialized_witnesses"], expected["materialized_witnesses"]),
               ("MLIR verifier passes", sem["mlir_verified"], expected["mlir_verified"]),
               ("C++ graph fact matches", sem["graph_fact_matches"], expected["graph_fact_matches"]),
               ("Host executions", exe["host_execution_runs"], expected["host_execution_runs"]),
               ("Element comparisons", exe["element_comparisons"], expected["element_comparisons"]),
               ("Numeric mismatches", exe["numeric_mismatches"], expected["numeric_mismatches"]),
               ("Negative injected", neg["injected_mismatches"], expected["negative_control_injected_mismatches"]),
               ("Negative detected", neg["detected_mismatches"], expected["negative_control_detected_mismatches"])]
    rows = "\n".join("| %s | %s | %s |" % row for row in metrics)
    verdict = "GO" if validation["pass"] else "NO-GO"
    text = """# ORBIT semantic artifact report

**SEMANTIC MODULE %s.** The fresh run completed computation; frozen validation %s.

Artifact repository: `https://github.com/guosran/orbit-artifact`, branch `main`, checkpoint tag `semantic-closure-v0.1`. Source: `git@github.com:guosran/amoeba.git` at `%s`. Artifact harness commit used by the run: `%s`. Full result: `%s`. Smoke result: `%s`.

| Invariant | Observed | Frozen expected |
|---|---:|---:|
%s

The first validation difference is `%s`. The expected file was not changed. Smoke validation: `%s` (%s graphs, %s host executions, %s element comparisons, %s mismatches, negative control %s). The full run recorded %s focused Python passes and %s focused lit passes. Optional dependency state: `%s`; six historical broader-suite cases remain out of scope and were not rerun or marked passed. Full wall time: %s seconds.

The source was fetched into a new checkout with pinned Neura, and this run used a new Python virtual environment. The C++ optimizer was built in a separate artifact build directory. Docker reproduction was not verified. Reproduce with `./artifact.sh setup && ./artifact.sh build && ./artifact.sh smoke semantic && ./artifact.sh reproduce semantic`. The result is limited to the canonical static 8×8×8 i32 front end; no backend performance, RTL, or whole-workload speedup is inferred. Tables under the result directory are generated from its JSON summaries.
""" % (verdict, "passed" if validation["pass"] else "failed", run["amoeba_git_commit"],
       run["artifact_git_commit"], relative(full), relative(smoke), rows,
       validation.get("error", "none"), smoke_validation["pass"],
       smoke_sem["unique_semantic_graphs"], smoke_exe["host_execution_runs"],
       smoke_exe["element_comparisons"], smoke_exe["numeric_mismatches"],
       smoke_neg["detected_mismatches"], tests["python_passed"],
       tests["lit_passed"], env["optional_dependency_state"], run["wall_clock_seconds"])
    reconciliation = RESULTS / "action-count-reconciliation/action_count_diff.json"
    if reconciliation.exists():
        diff = json.loads(reconciliation.read_text())
        text += ("\nThe action ledger reconciles the difference as %s graph IDs gaining "
                 "one 20-action re-expansion each: %s added accepted duplicate-output calls "
                 "and %s added deterministic rejections. The old and current ledgers each "
                 "contain %s distinct canonical input/action combinations. Every added "
                 "combination already appeared in the old ledger; the two fresh current "
                 "enumerations agree exactly. This does not satisfy the frozen contract. "
                 "See `ACTION_COUNT_PROVENANCE.md` and `ACTION_COUNT_RECONCILIATION.md`.\n" %
                 (len(diff["extra_by_input_graph"]),
                  diff["added_groups"]["legality_result"].get("accepted", 0),
                  diff["added_groups"]["legality_result"].get("rejected", 0),
                  diff["current_unique_input_action_pairs"]))
    (ROOT / "docs/SEMANTIC_ARTIFACT_REPORT.md").write_text(text)
    return full, validation


def full_report(semantic_path, semantic_validation):
    modules = status()
    resource = data(latest("resource"), "resource_summary.json")
    spatial = data(latest("spatial"), "spatial_summary.json")
    temporal = data(latest("temporal"), "temporal_summary.json")
    cost = data(latest("cost"), "cost_summary.json")
    harness = data(RESULTS, "harness_tests.json")
    rows = "\n".join("| %s | %s | %s |" % (
        name, item["verdict"], item["run"] or "none") for name, item in modules["modules"].items())
    text = """# ORBIT full-system artifact report

**%s.** Semantic computation completed but its frozen validator %s. The other backend modules have only fixture-level or pending evidence; none is promoted to full-system GO.

| Module | Verdict | Generated result |
|---|---|---|
%s

## Current source-backed and fixture evidence

- Shape: %s source C++ rectangular candidates on a 4×4 **physical CGRA** fabric (%s total), with a separately declared four-CGRA per-task cap. Replica enumeration is absent from the pinned source.
- Spatial: %s placed tasks and one canonical channel transfer of %s bits with %s link reservation. Tensor-wide, tile-local and halo route matrices are pending.
- Temporal: resource-release fixture makespan %s cycles. The fixed/critical/pipeline/beam/exact activity-policy matrix is unavailable at the pinned source.
- Cost: %s candidate shape fixture scores, selected `%s`, using a declared analytical estimate; source production score pass was not run because its file-binding protocol conflicts with this artifact.
- Native replay: pending. Pinned mapper replay requires score/trace file bindings and has no current no-binding selected-candidate path.
- Paper: only semantic and fixture Markdown tables can currently be generated. Matched native baselines, performance tables and plots are pending.

The harness ran %s tests with %s failures and %s errors. Existing CNN/GPT-2/FFT results use an earlier dirty source/provisional protocol and remain historical or diagnostic; they do not enter current paper comparisons. No full-workload, RTL, systolic, or blocked-GEMM long run was started. See `RESULT_COMPARABILITY.md` and `LONG_RUN_STATUS.md`.

RTL simulation is optional and is not a final artifact gate. Native mapper replay and matched current-protocol baselines remain required.

For full-system GO, resolve the frozen semantic attempt-count conflict, implement/reproduce replica-aware resource candidates and the activity scheduler policy matrix, remove the native replay file-binding conflict through a reviewed source protocol, run matched current-protocol baselines and selected native replay, and generate every paper table and plot from complete results. The public artifact repository and tag are separate publication checks and do not substitute for these gates.
""" % (modules["full_system_verdict"], "passed" if semantic_validation["pass"] else "failed", rows,
       resource["candidate_count"], resource["fabric"]["physical_cgras"],
       len(spatial["placements"]), spatial["communication"]["payload_bits"],
       len(spatial["communication"]["route_link_reservations"]),
       temporal["makespan_cycles"], cost["candidate_count"], cost["selected_source_candidate_id"],
       harness["tests_run"], harness["failures"], harness["errors"])
    (ROOT / "docs/FULL_SYSTEM_ARTIFACT_REPORT.md").write_text(text)


if __name__ == "__main__":
    semantic, validation = semantic_report()
    full_report(semantic, validation)
