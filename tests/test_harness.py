import json
import os
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import common
import check_environment
import generate_tables
import run_semantic_closure
import validate_results


class HarnessTests(unittest.TestCase):
    def test_lock_file_parsing(self):
        lock = common.lock()
        self.assertEqual(lock["amoeba"]["commit"], "a57376e7043b1681e64e7169c5a8cb02eb192331")
        self.assertEqual(lock["llvm_mlir"]["commit"], "6146a88f60492b520a36f8f8f3231e15f3cc6082")

    def test_wrong_source_commit_rejected(self):
        with tempfile.TemporaryDirectory() as tmp, patch.object(common, "git", return_value="0" * 40):
            with self.assertRaisesRegex(ValueError, "wrong AMOEBA source commit"):
                common.require_source_clean(Path(tmp))

    def test_dirty_source_rejected(self):
        expected = common.lock()["amoeba"]["commit"]
        with tempfile.TemporaryDirectory() as tmp, patch.object(common, "git", side_effect=[expected, " M file"]):
            with self.assertRaisesRegex(ValueError, "source is dirty"):
                common.require_source_clean(Path(tmp))

    def test_optional_dependency_classification(self):
        with patch.object(check_environment.importlib.util, "find_spec", return_value=None):
            result = check_environment.probe()
        self.assertEqual(result["optional_dependency_state"], "optional_dependency_missing")
        self.assertEqual(result["optional"]["torch_mlir"], "optional_dependency_missing")

    def fixture(self, path):
        expected = json.loads((common.ROOT / "config/expected_semantic_closure.json").read_text())
        ids = json.loads((common.ROOT / "reference/semantic_closure_summary.json").read_text())["graph_ids"]
        run = {"artifact_schema_version": "orbit-semantic-artifact-v1", "artifact_git_commit": "a" * 40,
               "amoeba_git_commit": common.lock()["amoeba"]["commit"], "start_time": "start",
               "end_time": "end", "hostname": "fixture", "command": ["./artifact.sh", "reproduce", "semantic"],
               "status": "completed", "completed_stage": "numeric", "optional_dependency_state": "optional_dependency_missing",
               "output_paths": {}, "wall_clock_seconds": 1}
        semantic = {"schema": "orbit-semantic-summary-v1", "attempted_actions": expected["attempted_actions"],
                    "unique_semantic_graphs": expected["unique_semantic_graphs"], "graph_ids": ids,
                    "materialized_witnesses": 126, "mlir_verified": 126, "graph_fact_matches": 126,
                    "k_mode_counts": {"none": 1}, "fusion_mode_counts": {"none": 1},
                    "rejection_reasons": {"illegal": 1}, "rejection_count": 1,
                    "deduplication_ratio": .9, "composition_order_counts": {"tile_to_fuse": 1},
                    "coverage": {key: True for key in ("identity", "m_tiling", "n_tiling", "mn_tiling",
                      "sequential_k", "parallel_linear", "parallel_tree", "whole_fusion", "tile_local_fusion",
                      "reduction_consumer_fusion", "tile_to_fuse", "fuse_to_tile", "commutative_order_equivalence",
                      "rejected_illegal_compositions")}}
        execution = {"host_execution_runs": 504, "element_comparisons": 172800,
                     "numeric_mismatches": 0, "graph_ids": ids}
        common.write_json(path / "run.json", run)
        common.write_json(path / "semantic_summary.json", semantic)
        common.write_json(path / "execution_summary.json", execution)
        common.write_json(path / "environment.json", {"source_commit": run["amoeba_git_commit"],
                           "required_status": "available", "optional_dependency_state": "optional_dependency_missing"})
        common.write_json(path / "negative_control.json", {"injected_mismatches": 1, "detected_mismatches": 1})
        common.write_json(path / "test_summary.json", {"python_passed": 114, "lit_passed": 2, "optional_skipped": 6})
        (path / "commands.jsonl").write_text("{}\n")
        (path / "graph_inventory.jsonl").write_text("".join(json.dumps({"graph_id": graph_id}) + "\n" for graph_id in ids))

    def test_schema_validation(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp); self.fixture(path)
            self.assertTrue(validate_results.validate(path)["pass"])
            run = json.loads((path / "run.json").read_text()); del run["hostname"]
            common.write_json(path / "run.json", run)
            with self.assertRaisesRegex(ValueError, "schema missing field hostname"):
                validate_results.validate(path)

    def test_missing_result_fails_closed(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp); self.fixture(path); (path / "negative_control.json").unlink()
            with self.assertRaisesRegex(ValueError, "missing required result"):
                validate_results.validate(path)

    def test_wrong_graph_count_fails_closed(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp); self.fixture(path)
            data = json.loads((path / "semantic_summary.json").read_text())
            data["unique_semantic_graphs"] = 125
            common.write_json(path / "semantic_summary.json", data)
            with self.assertRaisesRegex(ValueError, "unique_semantic_graphs"):
                validate_results.validate(path)

    def test_negative_control_required(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp); self.fixture(path)
            common.write_json(path / "negative_control.json", {"injected_mismatches": 1, "detected_mismatches": 0})
            with self.assertRaisesRegex(ValueError, "negative_control_detected_mismatches"):
                validate_results.validate(path)

    def test_tables_from_fixture(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp); self.fixture(path); generate_tables.generate(path)
            self.assertIn("172800", (path / "tables/correctness.md").read_text())
            self.assertIn("optional_dependency_missing", (path / "tables/test_summary.md").read_text())

    def test_paths_containing_spaces(self):
        with tempfile.TemporaryDirectory(prefix="orbit path with spaces ") as tmp:
            path = Path(tmp)
            record = common.run_command([sys.executable, "-c", "import sys; print(sys.argv[1])", "with spaces"],
                                        path, path, "path-test")
            self.assertEqual(record["argv"][-1], "with spaces")
            self.assertIn("with spaces", (path / record["stdout_log"]).read_text())

    def test_rerun_new_directory(self):
        with tempfile.TemporaryDirectory() as tmp, patch.object(run_semantic_closure, "RESULTS", Path(tmp)):
            first = run_semantic_closure.new_run_directory("smoke")
            second = run_semantic_closure.new_run_directory("smoke")
            self.assertNotEqual(first, second)

    def test_interrupted_run_remains_incomplete(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp); self.fixture(path)
            run = json.loads((path / "run.json").read_text()); run["status"] = "incomplete"
            common.write_json(path / "run.json", run)
            with self.assertRaisesRegex(ValueError, "incomplete"):
                validate_results.validate(path)


if __name__ == "__main__":
    unittest.main()
