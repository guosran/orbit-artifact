"""Focused regression tests for the runtime-equivalence normalizer."""
from __future__ import annotations

import importlib.util
from pathlib import Path
from tempfile import TemporaryDirectory
from types import SimpleNamespace
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "check_sequential_runtime_equivalence.py"
SPEC = importlib.util.spec_from_file_location("check_sequential_runtime_equivalence", SCRIPT)
assert SPEC is not None and SPEC.loader is not None
CHECKER = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(CHECKER)


class DifferenceComparatorTests(unittest.TestCase):
    def compare(self, reference, candidate, **kwargs):
        comparator = CHECKER.DifferenceComparator(
            Path("/tmp/reference-cell"), ".work/reference-cell",
            Path("/tmp/candidate-cell"), ".work/candidate-cell",
            **kwargs,
        )
        comparator.compare(reference, candidate, [])
        return comparator

    def test_content_verified_input_paths_and_elapsed_time_are_allowed(self):
        with TemporaryDirectory() as temporary:
            base = Path(temporary)
            reference_input = base / "reference" / "inputs" / "lu"
            candidate_input = base / "candidate" / "inputs" / "lu"
            reference_input.mkdir(parents=True)
            candidate_input.mkdir(parents=True)
            for input_root in (reference_input, candidate_input):
                (input_root / "canonical.mlir").write_bytes(b"same input")

            comparison = self.compare(
                {"source": str(reference_input / "canonical.mlir"), "elapsed_seconds": 9.5},
                {"source": str(candidate_input / "canonical.mlir"), "elapsed_seconds": 7.0},
                reference_input_root=reference_input,
                candidate_input_root=candidate_input,
                workload="lu",
                input_paths_verified=True,
            )

            self.assertEqual(comparison.mismatch_count, 0)
            self.assertEqual(comparison.allowed_counts["validated_input_paths"], 1)
            self.assertEqual(comparison.allowed_counts["wall_elapsed_timing"], 1)

    def test_input_paths_stay_strict_without_matching_content_proof(self):
        with TemporaryDirectory() as temporary:
            base = Path(temporary)
            reference_input = base / "reference" / "inputs" / "lu"
            candidate_input = base / "candidate" / "inputs" / "lu"
            reference_input.mkdir(parents=True)
            candidate_input.mkdir(parents=True)
            (reference_input / "canonical.mlir").write_bytes(b"old")
            (candidate_input / "canonical.mlir").write_bytes(b"changed")
            self.assertNotEqual(
                CHECKER._tree_manifest(reference_input),
                CHECKER._tree_manifest(candidate_input),
            )

            comparison = self.compare(
                {"input_path": str(reference_input / "canonical.mlir")},
                {"input_path": str(candidate_input / "canonical.mlir")},
                reference_input_root=reference_input,
                candidate_input_root=candidate_input,
                workload="lu",
                input_paths_verified=False,
            )

            self.assertEqual(comparison.mismatch_count, 1)
            self.assertEqual(comparison.allowed_counts["validated_input_paths"], 0)

    def test_only_exact_recorded_build_pin_paths_normalize(self):
        comparison = self.compare(
            {"numeric_command": {"argv": ["--optimizer", "/build/ref/mlir-opt", "--model", "/models/a.json"]}},
            {"numeric_command": {"argv": ["--optimizer", "/build/candidate/mlir-opt", "--model", "/models/a.json"]}},
            reference_pins={"optimizer": ["/build/ref/mlir-opt"]},
            candidate_pins={"optimizer": ["/build/candidate/mlir-opt"]},
        )
        self.assertEqual(comparison.mismatch_count, 0)
        self.assertEqual(comparison.allowed_counts["pinned_build_role_paths"], 1)

        unpinned_compiler = self.compare(
            {"compiler_path": "/build/ref/mlir-opt", "compile_model": "/model/ref.json"},
            {"compiler_path": "/build/candidate/mlir-opt", "compile_model": "/model/candidate.json"},
        )
        self.assertEqual(unpinned_compiler.mismatch_count, 2)

    def test_materializer_timing_changes_do_not_hide_query_counts(self):
        comparison = self.compare(
            {"runtime_materializer_active_refresh_milliseconds": 20, "cache_hits": 4},
            {"runtime_materializer_active_refresh_milliseconds": 40, "cache_hits": 5})
        self.assertEqual(comparison.mismatch_count, 1)
        self.assertEqual(comparison.mismatches[0]["path"], "/cache_hits")

    def test_numeric_path_alias_is_limited_to_the_verified_exact_token(self):
        proof = {("result.json", "numeric_top5_command", "argv", 1):
                 {"reference": "/old/script.py", "candidate": "/new/script.py", "proof": "bound exact bytes"}}
        comparison = self.compare(
            {"numeric_top5_command": {"argv": ["python", "/old/script.py"]}, "other": "/old/script.py"},
            {"numeric_top5_command": {"argv": ["python", "/new/script.py"]}, "other": "/new/script.py"},
            verified_numeric_paths=proof)
        # Tokens here lack the required result.json scope, so neither normalizes.
        self.assertEqual(comparison.mismatch_count, 2)
        comparator = CHECKER.DifferenceComparator(Path("/tmp/reference-cell"), ".work/reference-cell",
            Path("/tmp/candidate-cell"), ".work/candidate-cell", verified_numeric_paths=proof)
        comparator.compare({"numeric_top5_command": {"argv": ["python", "/old/script.py"]}},
                           {"numeric_top5_command": {"argv": ["python", "/new/script.py"]}}, ["result.json"])
        self.assertEqual(comparator.mismatch_count, 0)

    def test_exact_new_runtime_and_checkpoint_telemetry_are_allowed(self):
        reference = {"runtime_existing": 1, "predictor": {"feature_query_count": 17}}
        candidate = {
            "runtime_existing": 1,
            "runtime_new_cache_hits": 4,
            "predictor": {"feature_query_count": 17},
            "typed_action_replay_cache_hits": 32,
            "typed_action_replay_cache_misses": 1,
            "typed_action_replay_skipped_steps": 83,
            "periodic_checkpoint_windows": 58,
            "skipped_periodic_checkpoint_writes": 57,
        }
        comparison = self.compare(reference, candidate)
        self.assertEqual(comparison.mismatch_count, 0)
        self.assertEqual(comparison.allowed_counts["sequential_optimization_telemetry"], 5)
        self.assertEqual(comparison.allowed_counts["additive_runtime_fields"], 1)

        changed_feature_count = self.compare(
            {"predictor": {"feature_query_count": 17}},
            {"predictor": {"feature_query_count": 18}},
        )
        self.assertEqual(changed_feature_count.mismatch_count, 1)

    def test_checkpoint_write_period_is_allowed_only_at_search_control_paths_and_reported(self):
        comparison = self.compare(
            {"checkpoint_write_period": 1},
            {"checkpoint_write_period": 32},
        )
        self.assertEqual(comparison.mismatch_count, 1)

        exact_path = CHECKER.DifferenceComparator(
            Path("/tmp/reference-cell"), ".work/reference-cell",
            Path("/tmp/candidate-cell"), ".work/candidate-cell",
        )
        exact_path.compare(
            {"checkpoint_write_period": 1},
            {"checkpoint_write_period": 32},
            ["search", "search-summary.json"],
        )
        self.assertEqual(exact_path.mismatch_count, 0)
        self.assertEqual(exact_path.allowed_counts["checkpoint_write_period"], 1)
        value = exact_path.allowed_values["checkpoint_write_period"][0]
        self.assertEqual(value["reference"]["effective_value"], 1)
        self.assertEqual(value["candidate"]["effective_value"], 32)

        unrelated_checkpoint_setting = CHECKER.DifferenceComparator(
            Path("/tmp/reference-cell"), ".work/reference-cell",
            Path("/tmp/candidate-cell"), ".work/candidate-cell",
        )
        unrelated_checkpoint_setting.compare(
            {"other": {"checkpoint_write_period": 1}},
            {"other": {"checkpoint_write_period": 32}},
            ["search", "action-attempts.jsonl"],
        )
        self.assertEqual(unrelated_checkpoint_setting.mismatch_count, 1)

    def test_shapes_scores_histories_budgets_and_order_remain_strict(self):
        reference = {
            "records": [
                {
                    "candidate_id": "neighborhood-0",
                    "shapes": [{"task": "Task_0", "rows": 1, "cols": 2}],
                    "score_record": {"predicted_whole_program_cycles": 120},
                    "action_history": ["shape:Task_0:1x2", "tile:Task_1:factor=2"],
                    "budget": 5,
                },
                {"candidate_id": "neighborhood-1", "rank": 1},
            ]
        }
        mutations = {
            "shape": (lambda value: value["records"][0]["shapes"][0].update(rows=2), "/records/0/shapes/0/rows"),
            "score": (lambda value: value["records"][0]["score_record"].update(predicted_whole_program_cycles=121), "/records/0/score_record/predicted_whole_program_cycles"),
            "history": (lambda value: value["records"][0]["action_history"].append("replica:Task_2"), "/records/0/action_history/length"),
            "budget": (lambda value: value["records"][0].update(budget=6), "/records/0/budget"),
            "order": (lambda value: value["records"].reverse(), "/records/0/candidate_id"),
        }
        for name, (mutate, expected_path) in mutations.items():
            with self.subTest(name=name):
                import copy
                candidate = copy.deepcopy(reference)
                mutate(candidate)
                comparison = self.compare(reference, candidate)
                self.assertGreater(comparison.mismatch_count, 0)
                self.assertIn(expected_path, [item["path"] for item in comparison.mismatches])

    def test_mapper_attribution_exception_is_rank_scoped_and_aggregate_counters_stay_strict(self):
        reference = [{"rank": 2, "result": {"candidate_id": "n2", "actual_mapper_calls": 1, "mapper_cache_hits": 9, "mapper_cache_misses": 1}}]
        candidate = [{"rank": 2, "result": {"candidate_id": "n2", "actual_mapper_calls": 0, "mapper_cache_hits": 10, "mapper_cache_misses": 0}}]
        comparator = CHECKER.DifferenceComparator(
            Path("/tmp/reference-cell"), ".work/reference-cell",
            Path("/tmp/candidate-cell"), ".work/candidate-cell",
        )
        comparator.compare(reference, candidate, ["native-top5", "results"])
        self.assertEqual(comparator.mismatch_count, 0)
        self.assertEqual(comparator.allowed_counts["accepted_parallel_cache_attribution"], 3)

        root_counter = self.compare(
            {"actual_mapper_calls": 1},
            {"actual_mapper_calls": 0},
        )
        self.assertEqual(root_counter.mismatch_count, 1)

    def test_mapper_audit_allows_candidate_ownership_shift_but_keeps_semantic_fields_strict(self):
        old = SimpleNamespace(mapper_call_audits=[
            {"audit": [{"candidate_id": "n1", "mapper_tile_rows": 2, "mapper_tile_cols": 2}]},
            {"audit": [{"candidate_id": "n2", "mapper_tile_rows": 4, "mapper_tile_cols": 2}]},
        ])
        new = SimpleNamespace(mapper_call_audits=[
            {"audit": [{"candidate_id": "n3", "mapper_tile_rows": 2, "mapper_tile_cols": 2}]},
            {"audit": [{"candidate_id": "n2", "mapper_tile_rows": 4, "mapper_tile_cols": 2}]},
        ])
        self.assertEqual(CHECKER._flatten_mapper_audits(old), CHECKER._flatten_mapper_audits(new))
        self.assertNotEqual(
            CHECKER._mapper_audit_candidate_counts(old),
            CHECKER._mapper_audit_candidate_counts(new),
        )

        new.mapper_call_audits[0]["audit"][0]["mapper_body_sha256"] = "changed"
        self.assertNotEqual(CHECKER._flatten_mapper_audits(old), CHECKER._flatten_mapper_audits(new))


if __name__ == "__main__":
    unittest.main()
