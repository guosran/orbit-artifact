import copy
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from modules.contracts import layered_ids, matched_for_paper, rank_candidates, validate_candidate


def candidate():
    row = {
        "workload_id": "fixture-8x8", "source_commit": "a57376e", "semantic_graph_id": "graph:fixture",
        "shape": [2, 2], "physical_cgras": 4, "replicas": 1,
        "shards": [{"replica_id": "replica:0", "range": [0, 8]}],
        "mapped_dfg_ids": ["dfg:whole"], "placement": [0, 1, 4, 5],
        "routes": [], "resource_allocation": {"cgras": [0, 1, 4, 5]},
        "activities": [{"activity": "task:0", "start": 0, "end": 10}],
        "timed_reservations": [], "replay_protocol": "fixture-v1", "backend": "neura",
        "replay_run_id": "run:0", "evidence_class": "analytical_estimate",
        "semantic_legal": True, "backend_legal": True, "artifact_available": True,
        "measurement_available": True, "status": "accepted",
        "cost": {"value": 10, "unit": "cycles", "source": "analytical_estimate"},
        "architecture_id": "fabric-4x4", "fabric_rows": 4, "fabric_cols": 4,
        "fabric_capacity": 16, "max_cgras_per_task": 4, "occupied_cgras": 4,
        "logical_tile_ids": ["tile:0"], "replica_ids": ["replica:0"],
        "replication_generated_tile_local_edges": [], "replica_dfg_complete": True,
        "scheduler_policy": "fixed", "selected_replay_id": None,
        "comparability": "current_reproducible", "run_complete": True,
        "case_role": "optimized"
    }
    row.update(layered_ids(row))
    return row


class ContractTests(unittest.TestCase):
    def test_layer_stability_and_change(self):
        a = candidate(); b = copy.deepcopy(a); b["shape"] = [1, 4]; b.update(layered_ids(b))
        self.assertEqual(a["semantic_graph_id"], b["semantic_graph_id"])
        self.assertNotEqual(a["resource_candidate_id"], b["resource_candidate_id"])
        c = copy.deepcopy(a); c["placement"] = [8, 9, 12, 13]; c.update(layered_ids(c))
        self.assertEqual(a["resource_candidate_id"], c["resource_candidate_id"])
        self.assertNotEqual(a["spatial_candidate_id"], c["spatial_candidate_id"])
        d = copy.deepcopy(a); d["activities"][0]["start"] = 1; d.update(layered_ids(d))
        self.assertEqual(a["spatial_candidate_id"], d["spatial_candidate_id"])
        self.assertNotEqual(a["temporal_schedule_id"], d["temporal_schedule_id"])

    def test_tile_and_replica_ids_independent(self):
        row = candidate(); row["replica_ids"] = ["tile:0"]
        with self.assertRaisesRegex(ValueError, "replica IDs"):
            validate_candidate(row)

    def test_replication_does_not_generate_tile_local_edge(self):
        row = candidate(); row["replication_generated_tile_local_edges"] = ["producer->consumer"]
        with self.assertRaisesRegex(ValueError, "cannot generate"):
            validate_candidate(row)

    def test_evidence_class_validation(self):
        row = candidate(); row["evidence_class"] = "unlabeled"
        with self.assertRaisesRegex(ValueError, "evidence class"):
            validate_candidate(row)

    def test_censored_cost_cannot_rank(self):
        row = candidate(); row["status"] = "measurement_censored"; row["measurement_available"] = False
        row["cost"] = None; row.update(layered_ids(row))
        self.assertEqual(rank_candidates([row]), [])
        row["cost"] = {"value": -1, "unit": "cycles", "source": "analytical_estimate"}
        with self.assertRaisesRegex(ValueError, "cost must be null"):
            rank_candidates([row])

    def test_unavailable_is_not_zero(self):
        row = candidate(); row["status"] = "artifact_missing"; row["measurement_available"] = False
        row["artifact_available"] = False; row["cost"]["value"] = 0
        with self.assertRaisesRegex(ValueError, "cost must be null"):
            validate_candidate(row)

    def test_resource_budget_and_per_task_limit(self):
        row = candidate(); row["fabric_capacity"] = 4
        with self.assertRaisesRegex(ValueError, "resource-budget mismatch"):
            validate_candidate(row)
        row = candidate(); row["physical_cgras"] = 5; row.update(layered_ids(row))
        with self.assertRaisesRegex(ValueError, "per-task"):
            validate_candidate(row)
        row = candidate(); row["max_cgras_per_task"] = 16
        with self.assertRaisesRegex(ValueError, "per-task CGRA limit"):
            validate_candidate(row)

    def test_exact_oracle_limited(self):
        row = candidate(); row["scheduler_policy"] = "exact"
        row["activities"] = [{"activity": str(i), "start": i, "end": i + 1} for i in range(9)]
        row.update(layered_ids(row))
        with self.assertRaisesRegex(ValueError, "small-graph"):
            validate_candidate(row)

    def test_selected_replay_identity(self):
        row = candidate(); row["status"] = "selected"; row["selected_replay_id"] = "wrong"
        with self.assertRaisesRegex(ValueError, "replay identity"):
            validate_candidate(row)
        row["selected_replay_id"] = row["replay_id"]
        self.assertTrue(validate_candidate(row))

    def test_historical_result_cannot_enter_paper(self):
        base = candidate(); base["case_role"] = "baseline"; base["comparability"] = "historical_only"
        with self.assertRaisesRegex(ValueError, "historical"):
            matched_for_paper(base, candidate())

    def test_incomplete_long_run_cannot_enter_paper(self):
        base = candidate(); base["case_role"] = "baseline"; base["run_complete"] = False
        with self.assertRaisesRegex(ValueError, "incomplete"):
            matched_for_paper(base, candidate())

    def test_paper_requires_matched_baseline(self):
        base = candidate(); base["case_role"] = "baseline"; base["fabric_capacity"] = 8
        with self.assertRaisesRegex(ValueError, "resource-budget mismatch"):
            matched_for_paper(base, candidate())
        base = candidate(); base["case_role"] = "baseline"; base["architecture_id"] = "other"
        with self.assertRaisesRegex(ValueError, "architecture_id"):
            matched_for_paper(base, candidate())


if __name__ == "__main__":
    unittest.main()
