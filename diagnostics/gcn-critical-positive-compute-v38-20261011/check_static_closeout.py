#!/usr/bin/env python3
"""Check the closed package; the original prepared-v4 checker is in history/."""
from pathlib import Path
import runpy
runpy.run_path(str(Path(__file__).resolve().parent / 'check_package.py'), run_name='__main__')
