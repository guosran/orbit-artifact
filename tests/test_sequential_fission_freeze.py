import copy
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('fission_freeze_checker',
    ROOT / 'reference/sequential-comparison/check-sequential-search-contract.py')
checker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checker)


class SourceFissionFreezeTests(unittest.TestCase):
    def fixture(self, root):
        fission = {'family': 'fission', 'primitives': [
            {'kind': 'fission', 'firstTask': 'Task_0', 'leftNodes': [0, 1, 2]}]}
        history = {'known': True, 'actions': [], 'fissionActions': [fission]}
        summary = dict(decision_flow='sequential', stage='full-joint-fission',
            objective_budget=4, graph_budget_percent=50, phase_budgets={'A': 2, 'B': 2},
            phase_evaluations={'A': 1, 'B': 1}, production_scheduler_calls=2,
            actual_mapper_search_calls=0, phase_a_anchor_candidate_id='anchor',
            frozen_fission_actions=[fission], cross_phase_dedup_promotions=0,
            cross_phase_dedup_promotion_trace_file='cross-phase-dedup-promotions.jsonl',
            phase_action_counts={'A': {'attempts': 1}, 'B': {'attempts': 1}},
            phase_candidate_attempts={'A': 2, 'B': 1}, candidate_attempts=3,
            round_score_quota=2, max_rounds=8, global_rounds_completed=2,
            phase_a_rounds_completed=1, phase_b_rounds_completed=1)
        (root / 'search-summary.json').write_text(json.dumps(summary))
        def journal(name, rows):
            (root / name).write_text(''.join(json.dumps(row) + '\n' for row in rows))
        journal('controls.jsonl', [
            {'control_role': 'identity', 'candidate_id': 'identity', 'action_history': {'known': True, 'actions': []}},
            {'control_role': 'search_anchor', 'candidate_id': 'anchor', 'action_history': history}])
        journal('top5.jsonl', [{'record_type': 'selection', 'action_history': {
            **history, 'actions': [{'family': 'shape'}]}}])
        journal('cross-phase-dedup-promotions.jsonl', [])
        journal('action-attempts.jsonl', [
            {'phase': 'A', 'action': fission},
            {'phase': 'B', 'action': {'family': 'shape'}, 'accepted': True, 'frozen_prefix_verified': True}])
        journal('budget-trace.jsonl', [
            {'phase': phase, 'cumulative_evaluations': index, 'scheduler_invoked': True,
             'elapsed_seconds': index, 'incumbent_cycles': 100} for index, phase in enumerate(('A', 'B'), 1)])
        journal('action-frontiers.jsonl', [
            {'phase': phase, 'phase_round': 0, 'global_action_menu_round': index,
             'filtered_shape': 0, 'filtered_replica': 0, 'filtered_graph': 0}
            for index, phase in enumerate(('A', 'B'))])
        return history

    def test_nonempty_fission_prefix_is_accepted(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp) / 'search'; root.mkdir()
            self.fixture(root)
            checker.check_sequential(root)

    def test_shape_suffix_cannot_hide_fission_change(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp) / 'search'; root.mkdir()
            history = copy.deepcopy(self.fixture(root))
            history['actions'] = [{'family': 'shape'}]
            history['fissionActions'][0]['primitives'][0]['leftNodes'] = [0, 1]
            (root / 'top5.jsonl').write_text(json.dumps({'record_type': 'selection', 'action_history': history}) + '\n')
            with self.assertRaisesRegex(SystemExit, 'source-fission'):
                checker.check_sequential(root)

    def test_summary_cannot_drop_source_fission_witness(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp) / 'search'; root.mkdir()
            self.fixture(root)
            path = root / 'search-summary.json'
            summary = json.loads(path.read_text())
            summary['frozen_fission_actions'] = []
            path.write_text(json.dumps(summary))
            with self.assertRaisesRegex(SystemExit, 'source-fission'):
                checker.check_sequential(root)
