#!/usr/bin/env python3
"""Exercise the real ORBIT adapter with a deterministic non-hardware evaluator."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
BINARY=Path(sys.argv.pop(1)).resolve()
class Adapter(unittest.TestCase):
 def setUp(self):
  self.temp=tempfile.TemporaryDirectory();self.addCleanup(self.temp.cleanup);self.root=Path(self.temp.name)
  self.evaluator=self.root/'evaluate.py'
  self.evaluator.write_text('''import argparse,json,pathlib
p=argparse.ArgumentParser();p.add_argument('--request');p.add_argument('--output');a=p.parse_args()
r=json.loads(pathlib.Path(a.request).read_text());v=r['candidate']
result=dict(feasible=v.get('known',True),feasibility_known=v.get('known',True),cost_ms=v.get('cost'),message='test evaluator')
(pathlib.Path(a.output)/'result.json').write_text(json.dumps(result))
''')
 def launch(self,choices,budget=3):
  domain=self.root/'domain.json';domain.write_text(json.dumps(dict(choices=choices,request_base={})))
  return subprocess.run([str(BINARY),str(domain),str(self.evaluator),sys.executable,str(self.root/'search'),str(budget)],capture_output=True,text=True)
 def test_actual_beam_selects_measured_cost(self):
  r=self.launch([dict(id='baseline',cost=3),dict(id='tile',cost=1),dict(id='other',cost=2)])
  self.assertEqual(r.returncode,0,r.stderr)
  result=json.loads((self.root/'search/search.json').read_text())
  self.assertEqual(result['selected']['id'],'tile')
  self.assertIsNone(result['overall_wall_cap_seconds'])
  self.assertIn('sha256',result['adapter_executable'])
  self.assertIn('sha256',result['evaluator_script'])
 def test_quota_is_incomplete_not_domain_pruning(self):
  r=self.launch([dict(id='baseline',cost=3),dict(id='unvisited',cost=1)],budget=1)
  self.assertEqual(r.returncode,0,r.stderr)
  result=json.loads((self.root/'search/search.json').read_text())
  self.assertEqual(result['domain_choices'],2)
  self.assertEqual(result['selected']['id'],'baseline')
  self.assertFalse(result['report'].get('finite_domain_exhausted',False))
 def test_unknown_is_not_zero_cost(self):
  r=self.launch([dict(id='baseline',cost=3),dict(id='unknown',known=False)],budget=2)
  self.assertEqual(r.returncode,0,r.stderr)
  result=json.loads((self.root/'search/search.json').read_text())
  self.assertEqual(result['selected']['id'],'baseline')
 def test_existing_evidence_is_preserved(self):
  (self.root/'search').mkdir();(self.root/'search/keep').write_text('unchanged')
  r=self.launch([dict(id='baseline',cost=3)])
  self.assertEqual(r.returncode,2)
  self.assertEqual((self.root/'search/keep').read_text(),'unchanged')
if __name__=='__main__': unittest.main()
