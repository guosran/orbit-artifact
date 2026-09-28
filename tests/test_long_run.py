import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from modules.long_run import resume_plan


class LongRunTests(unittest.TestCase):
    def test_resume_skips_completed_cases(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            plan = {"schema": "orbit-long-run-plan-v1", "cases": [
                {"id": "one", "argv": [sys.executable, "-c", "print('one')"],
                 "cwd": str(root), "evidence_class": "native_mapper_replay"},
                {"id": "two", "argv": [sys.executable, "-c", "print('two')"],
                 "cwd": str(root), "evidence_class": "native_mapper_replay"}]}
            (root / "plan.json").write_text(json.dumps(plan))
            first = resume_plan(root)
            self.assertEqual(first["completed_this_invocation"], 2)
            second = resume_plan(root)
            self.assertEqual(second["skipped_completed"], 2)
            self.assertEqual(second["completed_this_invocation"], 0)

    def test_failed_case_not_promoted(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            plan = {"schema": "orbit-long-run-plan-v1", "cases": [
                {"id": "bad", "argv": [sys.executable, "-c", "raise SystemExit(3)"],
                 "cwd": str(root), "evidence_class": "native_mapper_replay"}]}
            (root / "plan.json").write_text(json.dumps(plan))
            with self.assertRaisesRegex(RuntimeError, "case failed"):
                resume_plan(root)
            case = json.loads((root / "cases/bad.json").read_text())
            self.assertEqual(case["status"], "execution_failed")
            self.assertNotEqual(case["exit_code"], 0)
            self.assertFalse((root / "long_run_status.json").exists())
