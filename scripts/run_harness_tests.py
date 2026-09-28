#!/usr/bin/env python3
"""Run harness tests and publish a compact machine-readable test result."""
from pathlib import Path
import sys
import unittest

from common import RESULTS, now, write_json

suite = unittest.defaultTestLoader.discover(str(Path(__file__).resolve().parents[1] / "tests"))
started = now()
result = unittest.TextTestRunner(verbosity=2).run(suite)
write_json(RESULTS / "harness_tests.json", {
    "schema": "orbit-harness-tests-v1", "start_time": started, "end_time": now(),
    "tests_run": result.testsRun, "failures": len(result.failures),
    "errors": len(result.errors), "skipped": len(result.skipped),
    "pass": result.wasSuccessful()})
sys.exit(0 if result.wasSuccessful() else 1)
