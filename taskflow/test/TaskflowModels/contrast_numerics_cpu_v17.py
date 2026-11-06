#!/usr/bin/env python3
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
import numpy as np
spec=importlib.util.spec_from_file_location('contrast',Path(__file__).with_name('contrast_numerics_v17.py'));m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
class ContrastTest(unittest.TestCase):
 def test_signed_feature_design(self):
  x=[[-1,-10],[-1,-30],[-2,-10]];b,d=m.solve(x,np.array(x)@np.array([7,2]));self.assertTrue(np.allclose(b,[7,2]));self.assertEqual(d['rank'],2)
 def test_zero_column_unknown(self):
  with self.assertRaisesRegex(AssertionError,'zero training column'):m.solve([[0,-10],[0,-30]],[-20,-60])
 def test_correlated_columns_unknown(self):
  with self.assertRaisesRegex(AssertionError,'rank'):m.solve([[-1,-10],[-2,-20],[-3,-30]],[-2,-4,-6])
 def test_no_intercept_invented(self):
  b,_=m.solve([[-1],[-2],[-3]],[3,6,9]);self.assertEqual(float(b[0]),0)
 def test_known_active_boundary(self):
  b,_=m.solve([[1,0],[0,1],[1,1]],[-3,5,2]);self.assertTrue(b[0]==0 and b[1]>0)
 def test_mixed_split_rejected_before_evidence(self):
  with tempfile.TemporaryDirectory() as d:
   p=Path(d)/'adapter.json';p.write_text(json.dumps(dict(split='train',feature_names=['bytes'],rows=[dict(pair_id='bad',split='holdout')],evidence=[{'path':'/never/open/heldout'}])))
   with self.assertRaisesRegex(AssertionError,'mixed/heldout'):m.calibrate(p)
 def test_all_raw_samples_and_seed_fits_preserved(self):
  with tempfile.TemporaryDirectory() as d:
   p=Path(d)/'adapter.json';p.write_text(json.dumps(dict(split='train',feature_names=['bytes'],rows=[dict(pair_id=str(i),split='train',feature_delta=[-i],observations=[dict(seed=s,repeat=r,delta_ns=-2*i) for s in [11,23] for r in [0,1]]) for i in [1,2,3]],evidence=[])))
   result=m.calibrate(p);self.assertEqual(len(result['per_seed_fits']),2);self.assertFalse(result['holdout_labels_read']);self.assertEqual(len(result['training_pairs'][0]['raw_paired_delta_ns']),4);self.assertAlmostEqual(result['coefficients_ns'][0],2)
if __name__=='__main__':unittest.main()
