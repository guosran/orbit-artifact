import copy
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from sequential_budget_audit import expected_phase_budgets


class SequentialBudgetTransferAuditTests(unittest.TestCase):
    def fixture(self):
        return dict(sequential_budget_policy="transfer-unused", phase_evaluations={"A": 5, "B": 4091},
                    phase_a_stop_reason="no-new-legal-candidates", transferred_evaluation_count=2043,
                    nominal_phase_budgets={"A": 2048, "B": 2048},
                    effective_phase_budgets={"A": 5, "B": 4091})

    def test_exhaustion_transfers_only_unused_calls(self):
        self.assertEqual(expected_phase_budgets(self.fixture(), 4096, 50, "transfer-unused"),
                         {"A": 5, "B": 4091})

    def test_transfer_cannot_be_reported_as_original_fixed_split(self):
        with self.assertRaisesRegex(ValueError, "main table"):
            expected_phase_budgets(self.fixture(), 4096, 50)

    def test_round_cap_pause_and_fatal_stop_cannot_transfer(self):
        for reason in ("max-rounds", "explicit-pause", "fatal-write-or-contract-error", "phase-budget-exhausted"):
            with self.subTest(reason=reason):
                value = self.fixture(); value["phase_a_stop_reason"] = reason
                with self.assertRaisesRegex(ValueError, "only on candidate exhaustion"):
                    expected_phase_budgets(value, 4096, 50, "transfer-unused")
                value.update(transferred_evaluation_count=0, effective_phase_budgets={"A": 2048, "B": 2048})
                self.assertEqual(expected_phase_budgets(value, 4096, 50, "transfer-unused"),
                                 {"A": 2048, "B": 2048})

    def test_metadata_cannot_mint_extra_allowance(self):
        for key, bad in (("transferred_evaluation_count", 2044),
                         ("effective_phase_budgets", {"A": 5, "B": 4092}),
                         ("nominal_phase_budgets", {"A": 4096, "B": 4096})):
            value = copy.deepcopy(self.fixture()); value[key] = bad
            with self.subTest(key=key), self.assertRaises(ValueError):
                expected_phase_budgets(value, 4096, 50, "transfer-unused")


if __name__ == "__main__":
    unittest.main()
