#!/usr/bin/env python3
from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import sys
import tempfile
import unittest


SCRIPTS = Path(__file__).resolve().parents[1] / "scripts"
sys.path.insert(0, str(SCRIPTS))


def load(filename):
    spec = importlib.util.spec_from_file_location("cleanup_neighborhood_temporaries", SCRIPTS / filename)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


cleanup = load("cleanup_neighborhood_temporaries.py")
import run_neighborhood_parallel_recovery as recovery


class NeighborhoodTemporaryCleanupTests(unittest.TestCase):
    def prepare(self, root: Path, *, active: bool = False) -> tuple[Path, Path]:
        stage = root / "stage"
        search = stage / "search"
        (search / "candidates").mkdir(parents=True)
        (search / "replay").mkdir()
        (search / "spaces" / "graph-0").mkdir(parents=True)
        (search / "witnesses" / "graph-0").mkdir(parents=True)
        command = {"status": "running" if active else "finished",
                   "exit_code": None if active else 0}
        result = {"status": "running" if active else "finished",
                  "exit_code": None if active else 0}
        (stage / "search.command.json").write_text(json.dumps(command))
        (stage / "search-result.json").write_text(json.dumps(result))

        selections = [{"record_type": "header", "schema": "fixture"}]
        for rank in range(5):
            candidate = search / "candidates" / f"winner-{rank}.mlir"
            score = search / "replay" / f"winner-{rank}-score.jsonl"
            manifest = search / "replay" / f"winner-{rank}-shape.json"
            for path in (candidate, score, manifest):
                path.write_text("source-owned fixture\n")
            selections.append({"record_type": "selection", "rank": rank,
                               "candidate_path": str(candidate),
                               "score_file": str(score),
                               "shape_manifest_file": str(manifest)})
        selections.append({"record_type": "footer", "complete": True})
        (search / "top5.jsonl").write_text("\n".join(json.dumps(row) for row in selections) + "\n")

        control_candidate = search / "candidates" / "identity.mlir"
        control_score = search / "replay" / "identity-score.jsonl"
        control_manifest = search / "replay" / "identity-shape.json"
        for path in (control_candidate, control_score, control_manifest):
            path.write_text("source-owned fixture\n")
        control = {"record_type": "control", "control_role": "identity",
                   "candidate_path": str(control_candidate),
                   "score_file": str(control_score),
                   "shape_manifest_file": str(control_manifest)}
        (search / "controls.jsonl").write_text(json.dumps(control) + "\n")

        (search / "candidates" / "orphan.mlir").write_text("unselected\n")
        (search / "replay" / "orphan-score.jsonl").write_text("unselected\n")
        (search / "replay" / "orphan-shape.json").write_text("unselected\n")
        (search / "costs-graph-catalogue-999.json").write_text("spill\n")
        (search / "archive-complete.jsonl").write_text("spill\n")
        (search / "spaces" / "graph-0" / "space.jsonl").write_text("spill\n")
        (search / "witnesses" / "graph-0" / "proof.json").write_text("spill\n")
        return stage, search

    def add_family_best_witness(self, stage: Path, search: Path, *,
                                missing_module: bool = False) -> Path:
        diagnostics = search / "diagnostics"
        diagnostics.mkdir(parents=True, exist_ok=True)
        module = search / "candidates" / "family-witness-module.mlir"
        cost = search / "costs-graph-catalogue-family.json"
        source_binding = search / "checkpoint.json.binding.json"
        for path, contents in (
                (module, "module witness\n"),
                (cost, '{"schema":"family-cost-witness"}\n'),
                (source_binding, '{"schema":"source-binding-witness"}\n'),
                (stage / "prepared-source.mlir", "prepared source witness\n"),
                (stage / "protocol.json", '{"schema":"protocol-witness"}\n'),
                (stage / "source-contract.json", '{"schema":"contract-witness"}\n'),
                (stage / "architecture.yaml", "architecture witness\n")):
            path.write_text(contents, encoding="utf-8")
        inline_module = "module { /* exact inline witness */ }"
        cost_json = json.dumps({"schema": "family-cost-witness"})
        witness = {
            "schema": cleanup._FAMILY_WITNESS_SCHEMA,
            "candidate_id": "neighborhood-family",
            "candidate_key": "graph-family|unit-shapes",
            "parent_candidate_id": "",
            "graph_variant_id": "graph-family",
            "graph_facts_key": "graph-family",
            "binding": {
                "architecture_path": str(stage / "architecture.yaml"),
                "prepared_source_path": str(stage / "prepared-source.mlir"),
                "protocol_path": str(stage / "protocol.json"),
                "source_contract_path": str(stage / "source-contract.json"),
                "source_binding_witness": str(source_binding),
            },
            "candidate_path_at_archive": str(
                search / "candidates" / "missing-family-module.mlir"
                if missing_module else module),
            "candidate_module_ir": inline_module,
            "candidate_module_bytes": len(inline_module.encode("utf-8")),
            "candidate_module_operation_count": 1,
            "cost_catalogue_path_at_archive": str(cost),
            "cost_catalogue_snapshot_available": True,
            "cost_catalogue_snapshot_bytes": len(cost_json.encode("utf-8")),
            "cost_catalogue_exact_json": cost_json,
            "task_choices": [],
            "task_costs": [],
            "task_schedule": [],
            "predicted_whole_program_cycles": 12,
            "action_history": {"schema": "orbit-joint-neighborhood-typed-actions-v1",
                               "known": True, "canonicalFactKey": "graph-family",
                               "actions": [], "fissionActions": []},
            "action_path": ["fission:Task_1:left=1", "shape:Task_1.split.1:2x1"],
            "typed_path_families": ["fission"],
        }
        path = diagnostics / "family-best-witness-neighborhood-family.json"
        path.write_text(json.dumps(witness, indent=2) + "\n", encoding="utf-8")
        return path

    def test_keeps_every_candidate_and_replay_file_named_by_shortlist_or_controls(self):
        with tempfile.TemporaryDirectory() as directory:
            stage, search = self.prepare(Path(directory))
            receipt = cleanup.cleanup_search_temporaries(stage)
            self.assertEqual(receipt["status"], "cleaned")
            self.assertTrue((search / "candidates" / "winner-0.mlir").is_file())
            self.assertTrue((search / "replay" / "winner-0-score.jsonl").is_file())
            self.assertTrue((search / "replay" / "identity-shape.json").is_file())
            self.assertFalse((search / "candidates" / "orphan.mlir").exists())
            self.assertFalse((search / "replay" / "orphan-score.jsonl").exists())
            self.assertTrue(any(item["path"].endswith("winner-0.mlir")
                                for item in receipt["retained"]))
            self.assertTrue((stage / "temporary-cleanup-receipt.json").is_file())

    def test_incomplete_active_search_refuses_before_deleting_any_spill(self):
        with tempfile.TemporaryDirectory() as directory:
            stage, search = self.prepare(Path(directory), active=True)
            receipt = cleanup.cleanup_search_temporaries(stage)
            self.assertEqual(receipt["status"], "refused")
            self.assertIn("still running", receipt["reason"])
            self.assertTrue((search / "costs-graph-catalogue-999.json").is_file())
            self.assertTrue((search / "candidates" / "orphan.mlir").is_file())

    def test_winner_and_final_validation_files_outside_search_are_retained(self):
        with tempfile.TemporaryDirectory() as directory:
            stage, search = self.prepare(Path(directory))
            (stage / "winner.json").write_text('{"candidate": "winner-0"}\n')
            (stage / "result.json").write_text('{"status": "native_replayed"}\n')
            (stage / "numeric-result.json").write_text('{"numeric": "pass"}\n')
            receipt = cleanup.cleanup_search_temporaries(stage)
            self.assertEqual(receipt["status"], "cleaned")
            self.assertTrue((stage / "winner.json").is_file())
            self.assertTrue((stage / "result.json").is_file())
            self.assertTrue((stage / "numeric-result.json").is_file())
            self.assertTrue((search / "candidates" / "winner-4.mlir").is_file())

    def test_closed_search_preserves_family_witness_dependencies_and_funnel_ledgers(self):
        with tempfile.TemporaryDirectory() as directory:
            stage, search = self.prepare(Path(directory))
            witness = self.add_family_best_witness(stage, search)
            for name, contents in (
                    ("archive.jsonl", "final archive\n"),
                    ("archive.journal.jsonl", "append journal\n"),
                    ("archive.jsonl.gz", "compressed final archive\n"),
                    ("archive.journal.jsonl.gz", "compressed journal\n"),
                    ("finalarchive.jsonl", "named final archive\n"),
                    ("candidate-family-funnel.jsonl", "candidate funnel\n"),
                    ("diagnostics/family-funnel.jsonl", "diagnostic funnel\n"),
                    ("diagnostics/family-funnel-summary.json", "{}\n")):
                path = search / name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(contents, encoding="utf-8")
            (search / "costs-graph-catalogue-unrelated.json").write_text(
                "unrelated cost spill\n", encoding="utf-8")
            (search / "archive-temporary.jsonl").write_text(
                "unrelated archive spill\n", encoding="utf-8")

            receipt = cleanup.cleanup_search_temporaries(stage)

            self.assertEqual(receipt["status"], "cleaned")
            self.assertTrue(witness.is_file())
            for name in ("archive.jsonl", "archive.journal.jsonl",
                         "archive.jsonl.gz", "archive.journal.jsonl.gz",
                         "finalarchive.jsonl", "candidate-family-funnel.jsonl",
                         "diagnostics/family-funnel.jsonl",
                         "diagnostics/family-funnel-summary.json"):
                self.assertTrue((search / name).is_file(), name)
            self.assertTrue((search / "costs-graph-catalogue-family.json").is_file())
            self.assertTrue((search / "candidates" / "family-witness-module.mlir").is_file())
            self.assertTrue((search / "checkpoint.json.binding.json").is_file())
            self.assertFalse((search / "costs-graph-catalogue-unrelated.json").exists())
            self.assertFalse((search / "archive-temporary.jsonl").exists())
            self.assertFalse((search / "candidates" / "orphan.mlir").exists())
            self.assertTrue(any(item["path"].endswith("costs-graph-catalogue-family.json")
                                for item in receipt["retained"]))
            self.assertTrue(any(item["path"].endswith("family-witness-module.mlir")
                                for item in receipt["retained"]))

    def test_malformed_family_witness_refuses_before_any_spill_is_deleted(self):
        with tempfile.TemporaryDirectory() as directory:
            stage, search = self.prepare(Path(directory))
            diagnostics = search / "diagnostics"
            diagnostics.mkdir()
            malformed = diagnostics / "family-best-witness-broken.json"
            malformed.write_text('{"schema":', encoding="utf-8")

            receipt = cleanup.cleanup_search_temporaries(stage)

            self.assertEqual(receipt["status"], "refused")
            self.assertIn("family-best witness is malformed", receipt["reason"])
            self.assertTrue((search / "costs-graph-catalogue-999.json").is_file())
            self.assertTrue((search / "candidates" / "orphan.mlir").is_file())
            self.assertTrue((search / "archive-complete.jsonl").is_file())

    def test_missing_archived_module_path_uses_exact_inline_module_witness(self):
        with tempfile.TemporaryDirectory() as directory:
            stage, search = self.prepare(Path(directory))
            witness = self.add_family_best_witness(
                stage, search, missing_module=True)

            receipt = cleanup.cleanup_search_temporaries(stage)

            self.assertEqual(receipt["status"], "cleaned")
            self.assertTrue(witness.is_file())
            self.assertTrue((search / "costs-graph-catalogue-family.json").is_file())
            self.assertFalse((search / "candidates" / "missing-family-module.mlir").exists())
            self.assertFalse((search / "candidates" / "orphan.mlir").exists())
            self.assertTrue(any(item["path"].endswith("missing-family-module.mlir")
                                and "inline-module-witness" in item["reason"]
                                for item in receipt["skipped"]))

    def test_missing_source_binding_reference_refuses_cleanup(self):
        with tempfile.TemporaryDirectory() as directory:
            stage, search = self.prepare(Path(directory))
            witness_path = self.add_family_best_witness(stage, search)
            witness = json.loads(witness_path.read_text(encoding="utf-8"))
            witness["binding"]["protocol_path"] = str(stage / "missing-protocol.json")
            witness_path.write_text(json.dumps(witness), encoding="utf-8")

            receipt = cleanup.cleanup_search_temporaries(stage)

            self.assertEqual(receipt["status"], "refused")
            self.assertIn("family-best witness references a missing file", receipt["reason"])
            self.assertTrue((search / "costs-graph-catalogue-999.json").is_file())
            self.assertTrue((search / "candidates" / "orphan.mlir").is_file())

    def test_symlinked_auxiliary_directory_is_never_followed(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            stage, search = self.prepare(root)
            outside = root / "outside"
            outside.mkdir()
            sentinel = outside / "keep.json"
            sentinel.write_text("outside the stage\n")
            spaces = search / "spaces"
            import shutil
            shutil.rmtree(spaces)
            try:
                spaces.symlink_to(outside, target_is_directory=True)
            except (OSError, NotImplementedError) as error:
                self.skipTest(f"symlinks are unavailable: {error}")
            receipt = cleanup.cleanup_search_temporaries(stage)
            self.assertEqual(receipt["status"], "cleaned")
            self.assertTrue(spaces.is_symlink())
            self.assertEqual(sentinel.read_text(), "outside the stage\n")
            self.assertTrue(any(item["reason"] == "symlink-not-followed"
                                for item in receipt["skipped"]))


class IncompleteSearchRestartTests(unittest.TestCase):
    def test_clears_partial_continuation_tree_and_keeps_stage_receipts(self):
        with tempfile.TemporaryDirectory() as directory:
            stage = Path(directory) / "stage"
            search = stage / "search"
            (search / "spaces").mkdir(parents=True)
            (search / "spaces" / "partial.jsonl").write_text("partial\n")
            (search / "candidate.mlir").write_text("partial\n")
            (stage / "search.stdout.log").write_text("diskguard failed\n")
            (stage / "search.stderr.log").write_text("diskguard details\n")
            evidence = {
                "search.command.json": json.dumps({"status": "finished", "exit_code": 1,
                    "stdout": str(stage / "search.stdout.log"),
                    "stderr": str(stage / "search.stderr.log")}) + "\n",
                "search-result.json": json.dumps({"status": "finished", "exit_code": 1,
                    "stdout": str(stage / "search.stdout.log"),
                    "stderr": str(stage / "search.stderr.log")}) + "\n",
                "result.json": '{"status":"incomplete","stop_reason":"diskguard"}\n',
                "chain-binding.json": '{"binding":"chain"}\n',
                "source-binding.json": '{"binding":"source"}\n',
                "checkpoint.json.binding.json": '{"binding":"checkpoint-source-witness"}\n',
            }
            for name, contents in evidence.items():
                (stage / name).write_text(contents)
            receipt = recovery._clear_incomplete_search(stage)
            self.assertEqual(receipt["status"], "cleared")
            self.assertEqual(list(search.iterdir()), [])
            for name in evidence:
                self.assertTrue((stage / name).is_file())
            archive = Path(receipt["archived_evidence_dir"])
            archived_command = json.loads((archive / "search.command.json").read_text())
            self.assertTrue(Path(archived_command["stdout"]).is_file())
            self.assertEqual(Path(archived_command["stdout"]).read_text(), "diskguard failed\n")
            self.assertTrue((archive / "result.json").is_file())
            self.assertEqual(set(receipt["preserved_stage_evidence"]),
                             {str(stage / name) for name in evidence})
            self.assertTrue((stage / "search-restart-receipt.json").is_file())

    def test_valid_checkpoint_protects_partial_search_tree(self):
        with tempfile.TemporaryDirectory() as directory:
            stage = Path(directory) / "stage"
            search = stage / "search"
            search.mkdir(parents=True)
            (search / "partial.json").write_text("partial\n")
            (stage / "checkpoint.json").write_text('{"checkpoint": true}\n')
            self.assertIsNone(recovery._clear_incomplete_search(stage))
            self.assertTrue((search / "partial.json").is_file())

    def test_complete_shortlist_and_control_ledger_protect_search_tree(self):
        with tempfile.TemporaryDirectory() as directory:
            stage = Path(directory) / "stage"
            search = stage / "search"
            search.mkdir(parents=True)
            rows = ([{"record_type": "header"}] +
                    [{"record_type": "selection", "rank": rank} for rank in range(5)] +
                    [{"record_type": "footer"}])
            (search / "top5.jsonl").write_text(
                "\n".join(json.dumps(row) for row in rows) + "\n")
            (search / "controls.jsonl").write_text(
                json.dumps({"record_type": "control", "control_role": "identity"}) + "\n")
            (search / "other-output.json").write_text("retained\n")
            self.assertIsNone(recovery._clear_incomplete_search(stage))
            self.assertTrue((search / "other-output.json").is_file())

    def test_active_native_command_refuses_restart_cleanup(self):
        with tempfile.TemporaryDirectory() as directory:
            stage = Path(directory) / "stage"
            search = stage / "search"
            (search / "native-top5" / "rank-0").mkdir(parents=True)
            (search / "partial.json").write_text("partial\n")
            active = stage / "native-top5" / "rank-0" / "native.command.json"
            active.parent.mkdir(parents=True, exist_ok=True)
            active.write_text(json.dumps({"status": "running"}))
            with self.assertRaises(recovery.chain.ChainError):
                recovery._clear_incomplete_search(stage)
            self.assertTrue((search / "partial.json").is_file())

    def test_archived_attempt_does_not_block_current_closed_search(self):
        with tempfile.TemporaryDirectory() as directory:
            stage = Path(directory) / "stage"
            (stage / "search").mkdir(parents=True)
            (stage / "search" / "archive.journal.jsonl").write_text("")
            archived = stage / "before-recovery-20261006" / "search.command.json"
            archived.parent.mkdir()
            archived.write_text(json.dumps({"status": "running"}))
            receipt = recovery._clear_incomplete_search(stage)
            self.assertEqual(receipt["status"], "cleared")
            self.assertEqual(json.loads(archived.read_text())["status"], "running")


if __name__ == "__main__":
    unittest.main()
