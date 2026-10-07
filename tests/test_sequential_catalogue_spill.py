import importlib.util
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import spill_sequential_catalogues as spill
import compact_sequential_raw as storage


class CatalogueSpillTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="orbit-catalogue-spill-")
        self.cell = Path(self.temp.name) / "results/gcn/joint"
        self.search = self.cell / "search"
        self.search.mkdir(parents=True)
        self.stage = Path(self.temp.name) / "staging"
        self.path = self.search / "costs-graph-catalogue-0.json"
        self.payload = b'{"entries": [], "source_witness": "immutable"}\n'
        self.path.write_bytes(self.payload)
        (self.cell / "checkpoint.json").write_text(json.dumps({
            "graph_cost_catalogues": [{"graph_key": "graph0", "path": str(self.path)}]}))

    def tearDown(self):
        self.temp.cleanup()

    def test_existing_reader_exact_path_archive_and_cleanup(self):
        unlisted = self.search / "costs-graph-catalogue-1.json"
        unlisted.write_bytes(b'{"uncommitted": true}')
        with self.path.open("rb") as existing_reader:
            self.assertEqual(spill.relocate(self.cell, self.stage), 1)
            self.assertEqual(existing_reader.read(), self.payload)
        self.assertTrue(self.path.is_symlink())
        self.assertEqual(self.path.read_bytes(), self.payload)
        self.assertFalse(unlisted.is_symlink())
        self.assertEqual(spill.relocate(self.cell, self.stage), 0)
        target = self.path.resolve()
        with patch.object(storage.comparison, "complete", return_value=True):
            storage.compact(self.cell)
        self.assertFalse(self.path.exists())
        self.assertTrue(target.exists())
        self.assertEqual(spill.cleanup_archived(self.cell), 1)
        self.assertFalse(target.exists())
        storage.restore(self.cell)
        self.assertEqual(self.path.read_bytes(), self.payload)
        self.assertFalse(self.path.is_symlink())

    def test_final_shortlist_disables_live_spill(self):
        (self.search / "global-top5.jsonl").write_text("final")
        self.assertEqual(spill.relocate(self.cell, self.stage), 0)
        self.assertFalse(self.path.is_symlink())

    def test_checkpoint_cannot_spill_outside_private_search(self):
        (self.cell / "checkpoint.json").write_text(json.dumps({
            "graph_cost_catalogues": [{"path": str(self.cell / "predictor-cache.json")}] }))
        with self.assertRaisesRegex(ValueError, "outside its private search"):
            spill.relocate(self.cell, self.stage)

    def test_existing_staged_evidence_is_not_overwritten(self):
        target = self.stage / "gcn/joint" / self.path.name
        target.parent.mkdir(parents=True)
        target.write_bytes(b"previous")
        with self.assertRaises(FileExistsError):
            spill.relocate(self.cell, self.stage)
        self.assertEqual(self.path.read_bytes(), self.payload)
        self.assertEqual(target.read_bytes(), b"previous")


if __name__ == "__main__":
    unittest.main()
