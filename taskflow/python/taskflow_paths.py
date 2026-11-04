"""Shared paths for the standalone Taskflow experiment artifact.

No import opens a device or configures a build. Core sources and experimental
orchestration have distinct roots; migrated tests are selected explicitly.
"""
import os
from pathlib import Path

ARTIFACT_ROOT = Path(__file__).resolve().parents[1]
ARTIFACT_REPO = ARTIFACT_ROOT.parent
ORBIT_SRC = Path(os.environ.get('ORBIT_SRC', ARTIFACT_REPO.parent / 'orbit')).expanduser().resolve()
ORBIT_BUILD_ROOT = Path(os.environ.get('ORBIT_BUILD_ROOT', ARTIFACT_REPO / 'builds/taskflow')).expanduser().resolve()
CORE_BUILD = ORBIT_BUILD_ROOT / 'core'
AIR_BUILD = ORBIT_BUILD_ROOT / 'air'
AMOEBA_BUILD = ORBIT_BUILD_ROOT / 'amoeba'
RESULTS_ROOT = Path(os.environ.get('ORBIT_RESULTS_ROOT', ARTIFACT_REPO / 'results/taskflow')).expanduser().resolve()
MIGRATED_TESTS = frozenset(['test/TaskflowAIR/audit_channel_ports_v6.py', 'test/TaskflowAIR/audit_compare_v7.py', 'test/TaskflowAIR/audit_comparison.py', 'test/TaskflowAIR/audit_hardware.py', 'test/TaskflowAIR/audit_metrics_v6.py', 'test/TaskflowAIR/audit_program_v7.py', 'test/TaskflowAIR/audit_runtime_transfers_v7.py', 'test/TaskflowAIR/audit_storage_v6.py', 'test/TaskflowAIR/classify_exp_edges_v6.py', 'test/TaskflowAIR/diagnose_stage_v6.py', 'test/TaskflowAIR/make_fixtures.py', 'test/TaskflowAIR/prepare_exp_probe_v6.py', 'test/TaskflowAIR/prepare_ffn_stages_v7.py', 'test/TaskflowAIR/prepare_inputs.py', 'test/TaskflowAIR/prepare_program_mapping_v7.py', 'test/TaskflowAIR/prepare_v6.py', 'test/TaskflowAIR/search_cases_v7.py', 'test/TaskflowAIR/summarize_program_timing_v7.py', 'test/TaskflowAIR/summarize_v6.py', 'test/TaskflowAIR/summarize_v7.py', 'test/TaskflowAIR/test_program_manifest_v7.py', 'test/TaskflowMapping/calibrated_evidence_v4.py', 'test/TaskflowMapping/calibrated_original_search_v4.py', 'test/TaskflowMapping/compute_contract_v8.py', 'test/TaskflowMapping/fixtures/compute-contract-baseline-v8.jsonl', 'test/TaskflowMapping/fixtures/compute-contract-baseline-v8.provenance.json', 'test/TaskflowMapping/hardware_evidence.py', 'test/TaskflowMapping/structural_hardware_v4.py', 'test/TaskflowMapping/trace_v4.py', 'test/TaskflowValidation/evaluation_cache.py'])

def test_path(relative):
    """Resolve a migration-manifest test, or a retained core regression fixture."""
    relative = Path(relative)
    if relative.is_absolute() or '..' in relative.parts:
        raise ValueError('test_path requires a relative path without parent traversal')
    if not relative.parts or relative.parts[0] != 'test':
        relative = Path('test') / relative
    base = ARTIFACT_ROOT if relative.as_posix() in MIGRATED_TESTS else ORBIT_SRC
    return base / relative

if __name__ == '__main__':
    import argparse
    import json
    p = argparse.ArgumentParser()
    p.add_argument('--test')
    a = p.parse_args()
    if a.test:
        print(test_path(a.test))
    else:
        print(json.dumps({k: str(globals()[k]) for k in ('ARTIFACT_ROOT', 'ARTIFACT_REPO', 'ORBIT_SRC', 'ORBIT_BUILD_ROOT', 'CORE_BUILD', 'AIR_BUILD', 'AMOEBA_BUILD', 'RESULTS_ROOT')}, indent=2))
