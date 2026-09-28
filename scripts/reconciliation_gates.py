"""Fail-closed promotion gates for semantic tags, native replay, and paper."""

HISTORICAL_V01_COMMIT = "a815e5b2e2f9d06b76fcbe6c05022db0fd78caec"


def require_patch_tag_ready(run, validation, expected, old_tag_commit):
    """Permit a new patch tag only after a complete fresh semantic run passes."""
    if old_tag_commit != HISTORICAL_V01_COMMIT:
        raise ValueError("historical v0.1 tag moved")
    if run.get("status") != "completed" or run.get("completed_stage") != "numeric":
        raise ValueError("clean full semantic reproduction incomplete")
    if run.get("command") != ["./artifact.sh", "reproduce", "semantic"]:
        raise ValueError("tag requires a full semantic reproduction command")
    if validation.get("pass") is not True:
        raise ValueError("semantic artifact contract has not passed")
    if run.get("amoeba_git_commit") != expected.get("source_commit"):
        raise ValueError("semantic source commit differs from release expectation")
    return True


def require_native_pair(baseline, selected):
    """Native replay requires two matched, actually loaded materializations."""
    from pathlib import Path
    import sys
    sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
    from modules.contracts import matched_for_paper

    if baseline.get("evidence_class") != "native_mapper_replay" or selected.get("evidence_class") != "native_mapper_replay":
        raise ValueError("analytical or predictor result cannot substitute for native replay")
    matched_for_paper(baseline, selected)
    for row in (baseline, selected):
        candidate = row.get("selected_candidate_id")
        if not candidate or row.get("materialized_candidate_id") != candidate or row.get("replay_loaded_candidate_id") != candidate:
            raise ValueError("native replay did not load the selected materialized candidate")
    return True


def paper_action_count(reconciliation_summary, semantic_validation):
    if reconciliation_summary.get("contract_verdict") != "GO" or semantic_validation.get("pass") is not True:
        raise ValueError("unresolved action count cannot enter paper table")
    value = reconciliation_summary.get("authoritative_attempted_actions")
    if type(value) is not int or value < 0:
        raise ValueError("authoritative action count missing")
    return value
