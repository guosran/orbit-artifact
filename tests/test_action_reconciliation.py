import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from action_reconciliation import compare, ledger, same_current_run, semantic_action_key
from reconcile_action_counts import write_ledger
from reconciliation_gates import (HISTORICAL_V01_COMMIT, paper_action_count,
                                  require_native_pair, require_patch_tag_ready)


def synthetic_manifest(upgraded):
    a = {"kind": "A", "tile_size": None, "executable": False}
    b = {"kind": "B", "tile_size": None, "executable": upgraded}
    root = {"graph_id": "root", "k_policy": "sequential", "fusion": {"producer_consumer": "none"},
            "witness": {"actions": [], "executable": True}}
    child = {"graph_id": "child", "k_policy": "sequential", "fusion": {"producer_consumer": "none"},
             "witness": {"actions": [b if upgraded else a], "executable": upgraded}}
    transitions = [
        {"source_graph_id": "root", "depth": 1, "action": a, "accepted": True,
         "result_graph_id": "child", "reason_code": None},
        {"source_graph_id": "root", "depth": 1, "action": b, "accepted": True,
         "result_graph_id": "child", "reason_code": None, "duplicate_state": True},
    ]
    rejected = [{"source_graph_id": "child", "depth": 2, "action": action,
                 "accepted": False, "result_graph_id": None, "reason_code": "ILLEGAL"}
                for _ in range(2 if upgraded else 1) for action in (a, b)]
    return {"complete": True, "action_catalog": [a, b],
            "candidate_graph_ids": ["root", "child"], "candidates": [root, child],
            "transitions": transitions, "rejections": rejected,
            "statistics": {"action_attempts": 6 if upgraded else 4,
                           "unique_graph_states": 2, "max_depth": 2,
                           "accepted_transitions": 2, "rejected_transitions": len(rejected)}}


class ActionReconciliationTests(unittest.TestCase):
    def setUp(self):
        self.old = synthetic_manifest(False)
        self.current = synthetic_manifest(True)

    def test_old_current_ledger_parsing_and_chronology(self):
        old = ledger(self.old, "old")
        current = ledger(self.current, "current")
        self.assertEqual([r["attempt_index"] for r in old], list(range(4)))
        self.assertEqual([r["attempt_index"] for r in current], list(range(6)))
        self.assertEqual([r["action_name"] for r in current], ["A", "B", "A", "B", "A", "B"])
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "ledger.jsonl"
            write_ledger(path, current)
            self.assertEqual([json.loads(line) for line in path.read_text().splitlines()], current)

    def test_definition_rejection_and_canonical_duplicate_count(self):
        rows = ledger(self.current, "current")
        self.assertEqual(len(rows), 6)
        self.assertEqual(sum(r["legality_result"] == "rejected" for r in rows), 4)
        self.assertTrue(rows[1]["canonicalized_to_existing_graph"])
        self.assertEqual(len({semantic_action_key(row) for row in rows}), 4)

    def test_witness_upgrade_requeue_is_separate_from_validation(self):
        old = ledger(self.old, "old")
        current = ledger(self.current, "current")
        diff = compare(old, current, self.old, self.current)
        self.assertEqual(diff["added_record_occurrences"], 2)
        self.assertEqual(diff["new_input_action_pairs"], 0)
        self.assertEqual(diff["extra_by_input_graph"], {"child": 2})
        self.assertEqual([row["input_witness_available"] for row in current[2:]], [False, False, True, True])
        modified = copy.deepcopy(self.current)
        modified["validation_records"] = [{"passed": True} for _ in range(10)]
        self.assertEqual(len(ledger(modified, "current")), 6)

    def test_retry_is_separate_run_not_added_attempts(self):
        first = ledger(self.current, "current")
        rerun = ledger(copy.deepcopy(self.current), "current")
        self.assertEqual(first, rerun)
        self.assertTrue(same_current_run(self.current, copy.deepcopy(self.current)))
        self.assertEqual(compare(first, rerun, self.current, self.current)["added_record_occurrences"], 0)

    def test_missing_record_fails_closed(self):
        broken = copy.deepcopy(self.current)
        broken["rejections"].pop()
        with self.assertRaisesRegex(ValueError, "action records do not match"):
            ledger(broken, "current")

    def test_release_preserves_v01_and_requires_full_pass(self):
        run = {"status": "completed", "completed_stage": "numeric",
               "command": ["./artifact.sh", "reproduce", "semantic"],
               "amoeba_git_commit": "pinned"}
        expected = {"source_commit": "pinned"}
        with self.assertRaisesRegex(ValueError, "historical v0.1 tag moved"):
            require_patch_tag_ready(run, {"pass": True}, expected, "wrong")
        with self.assertRaisesRegex(ValueError, "has not passed"):
            require_patch_tag_ready(run, {"pass": False}, expected, HISTORICAL_V01_COMMIT)
        run["status"] = "incomplete"
        with self.assertRaisesRegex(ValueError, "incomplete"):
            require_patch_tag_ready(run, {"pass": True}, expected, HISTORICAL_V01_COMMIT)

    def test_native_replay_cannot_use_analytical_substitute(self):
        baseline = {"evidence_class": "analytical_estimate"}
        selected = {"evidence_class": "native_mapper_replay"}
        with self.assertRaisesRegex(ValueError, "cannot substitute"):
            require_native_pair(baseline, selected)

    def test_paper_handoff_rejects_unresolved_action_count(self):
        with self.assertRaisesRegex(ValueError, "unresolved action count"):
            paper_action_count({"contract_verdict": "NO-GO"}, {"pass": False})


if __name__ == "__main__":
    unittest.main()
