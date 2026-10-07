from __future__ import annotations

import gzip
import hashlib
import importlib.util
import json
import sys
import tarfile
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
import compact_sequential_raw as storage
import summarize_sequential_comparison as summary

CONTRACT_PATH = ROOT / "reference/sequential-comparison/check-sequential-search-contract.py"
CONTRACT_SPEC = importlib.util.spec_from_file_location("sequential_search_contract", CONTRACT_PATH)
assert CONTRACT_SPEC is not None and CONTRACT_SPEC.loader is not None
contract = importlib.util.module_from_spec(CONTRACT_SPEC)
CONTRACT_SPEC.loader.exec_module(contract)


JOURNAL_CONTENTS = {
    "search/action-attempts.jsonl": b'{"attempt":1}\n{"attempt":2}\n',
    "search/budget-trace.jsonl": b'{"cumulative_evaluations":1}\n',
    "search/action-frontiers.jsonl": b'{"phase":"A"}\n',
    "search/cross-phase-dedup-promotions.jsonl": b"",
}


class JournalGzipTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="orbit-journal-gzip-test-")
        self.cell = Path(self.temp.name) / "gcn" / "joint"
        self.search = self.cell / "search"
        self.search.mkdir(parents=True)
        self.raw = {}
        for member, payload in JOURNAL_CONTENTS.items():
            path = self.cell / member
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(payload)
            self.raw[path] = payload
        self._seed_existing_auxiliary_archive()

    def tearDown(self):
        self.temp.cleanup()

    def _seed_existing_auxiliary_archive(self):
        archive = self.cell / "raw-auxiliary.tar.gz"
        with tarfile.open(archive, "w:gz"):
            pass
        (self.cell / "raw-auxiliary-manifest.json").write_text(json.dumps({
            "schema": "orbit-lossless-auxiliary-archive-v1",
            "files": [], "original_bytes": 0, "archive_bytes": archive.stat().st_size,
            "elapsed_seconds": 0.0,
        }))

    def _compact(self):
        with patch.object(storage.comparison, "complete", return_value=True):
            return storage.compact(self.cell)

    def test_existing_aux_archive_gzip_read_and_exact_restore(self):
        before_manifest = (self.cell / "raw-auxiliary-manifest.json").read_bytes()
        result = self._compact()
        self.assertIsNotNone(result)
        self.assertEqual(result["original_bytes"], sum(map(len, JOURNAL_CONTENTS.values())))
        self.assertGreater(result["archive_bytes"], 0)
        self.assertGreaterEqual(result["elapsed_seconds"], 0)
        self.assertEqual((self.cell / "raw-auxiliary-manifest.json").read_bytes(), before_manifest)

        manifest_path = self.cell / storage.JOURNAL_MANIFEST
        manifest = json.loads(manifest_path.read_text())
        self.assertEqual(manifest["schema"], storage.JOURNAL_SCHEMA)
        self.assertEqual(len(manifest["files"]), len(JOURNAL_CONTENTS))
        for path, original in self.raw.items():
            compressed = Path(str(path) + ".gz")
            row = next(item for item in manifest["files"] if item["path"] == path.relative_to(self.cell).as_posix())
            packed = compressed.read_bytes()
            self.assertEqual(row["raw_size"], len(original))
            self.assertEqual(row["raw_sha256"], hashlib.sha256(original).hexdigest())
            self.assertEqual(row["compressed_size"], len(packed))
            self.assertEqual(row["compressed_sha256"], hashlib.sha256(packed).hexdigest())
            self.assertEqual(gzip.decompress(packed), original)
            self.assertFalse(path.exists(), "plain source is removed only after manifest publication")
            expected_records = [
                json.loads(line) for line in original.decode().splitlines() if line.strip()
            ]
            self.assertEqual(storage.read_journal(path), expected_records)
            self.assertEqual(summary.read_jsonl(path), expected_records)
            self.assertEqual(contract.read_jsonl(path), expected_records)
            self.assertEqual(storage.existing_journal_path(path), compressed)

        storage.restore(self.cell)
        for path, original in self.raw.items():
            self.assertEqual(path.read_bytes(), original)
            self.assertEqual(storage.read_journal_bytes(path), original)

        # A repeated watcher pass must keep a restored plain journal intact.
        self.assertIsNone(self._compact())
        self.assertEqual({path: path.read_bytes() for path in self.raw}, self.raw)

    def test_corrupt_gzip_sha_fails_closed(self):
        self._compact()
        raw = next(iter(self.raw))
        compressed = Path(str(raw) + ".gz")
        compressed.write_bytes(compressed.read_bytes() + b"corruption")
        with self.assertRaisesRegex(ValueError, "gzip byte binding mismatch"):
            storage.read_journal(raw)

    def test_different_restored_raw_fails_closed(self):
        self._compact()
        storage.restore(self.cell)
        raw = next(iter(self.raw))
        raw.write_bytes(b'{"changed":true}\n')
        with self.assertRaisesRegex(ValueError, "raw byte binding mismatch"):
            storage.read_journal(raw)
        with self.assertRaisesRegex(ValueError, "raw byte binding mismatch"):
            storage.restore(self.cell)

    def test_unmanifested_gzip_is_never_overwritten(self):
        raw = next(iter(self.raw))
        compressed = Path(str(raw) + ".gz")
        compressed.write_bytes(b"prior evidence")
        with patch.object(storage.comparison, "complete", return_value=True):
            with self.assertRaisesRegex(FileExistsError, "unmanifested journal gzip"):
                storage.compact(self.cell)
        self.assertEqual(raw.read_bytes(), self.raw[raw])
        self.assertEqual(compressed.read_bytes(), b"prior evidence")

    def test_unfinished_cell_is_not_touched(self):
        with patch.object(storage.comparison, "complete", return_value=False):
            self.assertIsNone(storage.compact(self.cell))
        self.assertFalse((self.cell / "journal-gzip-manifest.json").exists())
        self.assertTrue(all(path.read_bytes() == data for path, data in self.raw.items()))

    def test_interrupted_cell_requires_exit_record_and_valid_bounds(self):
        (self.cell / "execution.json").write_text(json.dumps({"exit_code": 143}))
        (self.cell / "interruption-audit.json").write_text(json.dumps({
            "actual_objective_evaluations_lower_bound": 12,
            "actual_objective_evaluations_upper_bound": 140,
        }))
        with patch.object(storage.comparison, "complete", return_value=False):
            self.assertIsNone(storage.compact(self.cell))
            result = storage.compact(self.cell, allow_interrupted=True)
        self.assertIsNotNone(result)
        self.assertTrue((self.cell / storage.JOURNAL_MANIFEST).is_file())

    def test_interruption_audit_without_exit_record_does_not_compact(self):
        (self.cell / "interruption-audit.json").write_text(json.dumps({
            "actual_objective_evaluations_lower_bound": 12,
            "actual_objective_evaluations_upper_bound": 140,
        }))
        with patch.object(storage.comparison, "complete", return_value=False):
            self.assertIsNone(storage.compact(self.cell, allow_interrupted=True))
        self.assertTrue(all(path.read_bytes() == data for path, data in self.raw.items()))

    def test_observed_exit_with_lost_code_can_compact(self):
        (self.cell / "execution.json").write_text(json.dumps({
            "exit_code": None, "process_exit_observed": True,
            "cell_exit_code_not_retained": True,
        }))
        (self.cell / "interruption-audit.json").write_text(json.dumps({
            "actual_objective_evaluations_lower_bound": 12,
            "actual_objective_evaluations_upper_bound": 140,
        }))
        with patch.object(storage.comparison, "complete", return_value=False):
            self.assertIsNotNone(storage.compact(self.cell, allow_interrupted=True))


if __name__ == "__main__":
    unittest.main()
