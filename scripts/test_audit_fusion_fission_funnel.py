import json
import gzip
import tempfile
import unittest
from pathlib import Path

from audit_fusion_fission_funnel import (
    build_audit,
    candidate_compact,
    classify_action,
    family_funnel,
    family_presence,
    load_checkpoint,
    summarize_new_logs,
)


class FusionFissionClassificationTests(unittest.TestCase):
    def test_co_tiling_family_with_tile_primitives_is_not_fusion(self):
        action = {
            "family": "producer-consumer-co-tiling",
            "label": "co-tile:Task_0:Task_1",
            "primitives": [
                {"kind": "tile", "firstTask": "Task_0"},
                {"kind": "tile", "firstTask": "Task_1"},
            ],
        }
        self.assertEqual(classify_action(action), {"co_tiling"})
        candidate = {"candidate_id": "co-tiled", "action_history": {"actions": [action]}}
        self.assertFalse(family_presence(candidate)["fusion"])
        self.assertTrue(family_presence(candidate)["co_tiling"])

    def test_actual_fusion_primitive_wins_over_misleading_co_tiling_family(self):
        action = {
            "family": "producer-consumer-co-tiling",
            "primitives": [{"kind": "fusion", "mode": "producer-consumer-forwarded"}],
        }
        self.assertEqual(classify_action(action), {"fusion"})

    def test_typed_fission_history_is_separate_from_ordinary_actions(self):
        candidate = {
            "candidate_id": "split",
            "action_history": {
                "actions": [{"family": "shape", "primitives": []}],
                "fissionActions": [{"kind": "source-cut", "task": "Task_0"}],
            },
        }
        compact = candidate_compact(candidate)
        self.assertEqual(compact["ordinary_action_count"], 1)
        self.assertEqual(compact["typed_fissionActions_count"], 1)
        self.assertTrue(compact["semantic_family_presence"]["fission"])


class FunnelEvidenceTests(unittest.TestCase):
    def test_checkpoint_gzip_snapshot_is_read_without_decompression_to_disk(self):
        with tempfile.TemporaryDirectory() as temp:
            stage = Path(temp)
            checkpoint = {"pending_action_cursor": 7, "pending_neighbors": [{"action": {"family": "fusion"}}]}
            with gzip.open(stage / "checkpoint.json.gz", "wt", encoding="utf-8") as stream:
                json.dump(checkpoint, stream)
            loaded, source = load_checkpoint(stage)
            self.assertEqual(source, "checkpoint.json.gz")
            self.assertEqual(loaded["pending_action_cursor"], 7)
            self.assertFalse((stage / "checkpoint.json").exists())

    def test_old_missing_event_history_stays_unknown_and_does_not_assign_aggregate_rejects(self):
        candidate = {"candidate_id": "plain", "action_history": {"actions": [], "fissionActions": []}}
        funnel = family_funnel(
            family="fission",
            stage_label="S5",
            census={"value": 30, "status": "exact", "source": "harris/cut-census.json"},
            menu={"status": "unknown_checkpoint_missing"},
            checkpoint=None,
            candidates=[candidate],
            top5_native=[],
            controls=[],
            selected_id="plain",
            selected_candidate_source=candidate,
            logged=None,
            workload="harris",
            stage_name="full-joint-fission",
        )
        self.assertEqual(funnel["legal_action_census"]["value"], 30)
        self.assertEqual(funnel["global_search_top5"]["candidate_count"], 0)
        self.assertEqual(funnel["funnel_counts"]["successful_materializations"]["status"], "unknown_r9_per_family_event_log_absent")
        self.assertEqual(funnel["funnel_counts"]["materializer_rejects"]["value"], None)
        self.assertIsNone(funnel["path_presence_counts"]["scored_candidates"]["value"])

    def test_new_round_family_and_path_presence_schema_are_consumed_separately(self):
        with tempfile.TemporaryDirectory() as temp:
            stage = Path(temp)
            diag = stage / "diagnostics"
            diag.mkdir()
            summary = {
                "current_edge_by_family": {
                    "fusion": {
                        "menu": 12,
                        "generated": 8,
                        "attempted": 8,
                        "materialized": 6,
                        "reject": 2,
                        "fresh_cost_scored": 5,
                        "cache_reused": 1,
                        "unique": 4,
                        "duplicate": 1,
                        "scheduler_calls": 5,
                        "archive": 4,
                    }
                },
                "typed_path_presence_by_family": {
                    "fusion": {
                        "scored": 4,
                        "scored_candidate_ids": ["c1", "c2", "c3", "c4"],
                        "beam": 2,
                        "beam_candidate_ids": ["c1", "c2"],
                        "archive": 3,
                        "archive_candidate_ids": ["c1", "c2", "c3"],
                        "top5": 1,
                        "top5_candidates": [{"candidate_id": "c1", "score": 10, "global_rank": 0}],
                        "global_ranks": [0],
                        "best": {"candidate_id": "c1", "score": 10, "global_rank": 0},
                    }
                },
                "path_presence_semantics": "candidate may count in multiple families",
            }
            (diag / "family-funnel-summary.json").write_text(json.dumps(summary))
            (diag / "family-funnel.jsonl").write_text(json.dumps({
                "record_type": "round_family",
                "round": 1,
                "action_family": "fusion",
                "menu": 12,
                "generated": 8,
                "attempted": 8,
                "materialized": 6,
                "reject": 2,
                "fresh_cost_scored": 5,
            }) + "\n")
            logged = summarize_new_logs(stage)
            self.assertEqual(logged["current_edge_by_family"]["fusion"]["current_edge_metrics"]["fresh_cost_scored"]["value"], 5)
            self.assertEqual(logged["path_presence"]["by_family"]["fusion"]["scored_candidate_ids"], ["c1", "c2", "c3", "c4"])
            self.assertNotIn("beam", logged["current_edge_by_family"]["fusion"]["source_counters"])

    def test_candidate_attempt_jsonl_fallback_counts_family_outcomes(self):
        with tempfile.TemporaryDirectory() as temp:
            stage = Path(temp)
            diag = stage / "diagnostics"
            diag.mkdir()
            rows = [
                {
                    "record_type": "candidate_attempt",
                    "round": 1,
                    "action_family": "fusion",
                    "candidate_id": "fused-1",
                    "parent_id": "root",
                    "action": {"family": "fusion"},
                    "typed_primitive_kinds": ["fusion"],
                    "typed_action_history": {"fissionActions": [], "actions": []},
                    "result": {
                        "attempted": True,
                        "materialized": True,
                        "reject_reason": None,
                        "unique": True,
                        "duplicate": False,
                        "fresh_cost_prepared": True,
                        "cache_reused": False,
                        "scheduler_calls": 1,
                        "scheduler_pass": True,
                        "scheduler_reject": False,
                        "archive": True,
                    },
                },
                {
                    "record_type": "typed_path_presence",
                    "round": 1,
                    "family": "fusion",
                    "scored": 1,
                    "scored_candidate_ids": ["fused-1"],
                    "beam": 1,
                    "beam_candidate_ids": ["fused-1"],
                    "archive": 1,
                    "archive_candidate_ids": ["fused-1"],
                    "top5": 1,
                    "top5_candidates": [{"candidate_id": "fused-1", "score": 9, "global_rank": 0}],
                },
            ]
            (diag / "family-funnel.jsonl").write_text("".join(json.dumps(row) + "\n" for row in rows))
            logged = summarize_new_logs(stage)
            counters = logged["current_edge_by_family"]["fusion"]["current_edge_metrics"]
            self.assertEqual(counters["attempted"]["value"], 1)
            self.assertEqual(counters["successful_materializations"]["value"], 1)
            self.assertEqual(counters["fresh_cost_scored"]["status"], "unknown_not_emitted")
            self.assertEqual(logged["candidate_attempt_event_index_by_family"]["fusion"]["source_line_first"], 1)
            self.assertEqual(logged["round_path_presence_rows_by_family"]["fusion"][0]["top5"], 1)

    def test_cli_root_selection_is_generic_and_corrects_harris_top5(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            results = root / "results"
            census = root / "census"
            for workload in ("llama", "lu", "harris", "radar", "gcn", "raytracing"):
                cut_dir = census / workload
                cut_dir.mkdir(parents=True)
                (cut_dir / "cut-census.json").write_text(json.dumps({"status": "complete", "tasks": []}))
                for stage_name in ("full-joint", "full-joint-fission"):
                    stage = results / workload / stage_name
                    (stage / "search").mkdir(parents=True)
                    (stage / "native-top5").mkdir()
                    (stage / "native-controls").mkdir()
                    (stage / "search" / "search-summary.json").write_text("{}")
                    candidates = []
                    if workload == "harris":
                        action = {
                            "family": "producer-consumer-co-tiling",
                            "primitives": [{"kind": "tile"}, {"kind": "tile"}],
                        }
                        candidates = [
                            {"candidate_id": f"h{i}", "action_history": {"actions": [action], "fissionActions": []}}
                            for i in range(5)
                        ]
                    (stage / "result.json").write_text(json.dumps({"top5": candidates}))
                    (stage / "checkpoint.json").write_text(json.dumps({"pending_neighbors": [], "pending_action_cursor": 0, "beam": []}))
                    (stage / "native-top5" / "summary.json").write_text(json.dumps({"records": []}))
                    (stage / "native-controls" / "summary.json").write_text(json.dumps({"records": []}))
                    (stage / "previous-winner.jsonl").write_text("")
            audit = build_audit(results, census)
            self.assertEqual(audit["global_findings"]["fusion_top5_candidate_counts"]["harris"]["S4"], 0)
            self.assertEqual(audit["global_findings"]["co_tiling_top5_candidate_counts"]["harris"]["S4"], 5)


if __name__ == "__main__":
    unittest.main()
