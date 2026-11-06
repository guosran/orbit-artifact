#!/usr/bin/env python3
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
spec=importlib.util.spec_from_file_location('audit',Path(__file__).with_name('audit_contrast_v17.py'));a=importlib.util.module_from_spec(spec);spec.loader.exec_module(a)
class Gates(unittest.TestCase):
 def setUp(self):
  self.t=tempfile.TemporaryDirectory();self.r=Path(self.t.name)
  model=self.save('model.json',{'scope':'synthetic'})
  side=lambda g:dict(graph_id=g,plan_id=g+'p',artifact_sha256=g*64)
  self.row=dict(pair_id='p',orientation='candidate-minus-baseline',contrast_class='input',condition_id='synthetic-2ctx',covered_change='synthetic-input-transfer-composite',baseline=side('a'),candidate=side('b'),prediction_delta_ns=-100000,common_work_policy='changed-implementation-coupled-contrast',implementation_evidence=[model])
  pred=self.save('predictions.json',{'rows':[self.row]})
  metrics=self.save('metrics.json',dict(orientation='candidate-minus-baseline',resolution_floor_ns=50000,difference_absolute_floor_ns=25000,difference_relative_fraction=.3,require_seed_sign_agreement=True,required_classes=['input'],min_resolved_pairs_per_class=1))
  self.m=dict(schema='orbit.contrast.audit-adapter.v17',required_roles=['model','predictions','metrics'],frozen={'model':model,'predictions':pred,'metrics':metrics},sessions=[])
  self.path=self.r/'manifest.json';self.update();self.m['freeze_receipt']=self.save('receipt.json',a.run(self.path,False))
 def tearDown(self):self.t.cleanup()
 def save(self,name,x):
  p=self.r/name;p.write_text(json.dumps(x));return a.identity(p)
 def update(self):self.path.write_text(json.dumps(self.m))
 def session(self,deltas=None):
  if deltas is None:deltas=[-100000]*6
  protocol=self.save('protocol.json',dict(pair_ids=['p'],seeds=[11,23],warmups=0,repeats=3))
  rows=[dict(pair_id='p',seed=seed,repeat=i,warmup=False,condition_id=self.row['condition_id'],baseline=self.row['baseline'],candidate=self.row['candidate'],baseline_ns=1000000,candidate_ns=1000000+deltas[j*3+i]) for j,seed in enumerate([11,23]) for i in range(3)]
  p=self.r/'samples.jsonl';p.write_text('\n'.join(json.dumps(x) for x in rows));self.m['sessions']=[dict(id='holdout',kind='unseen-pairs',freeze_receipt_sha256=self.m['freeze_receipt']['sha256'],model_sha256=self.m['frozen']['model']['sha256'],samples=a.identity(p),protocol=protocol)];self.update()
 def test_freeze_does_not_open_samples(self):
  self.m['sessions']=[{'samples':{'path':'/absent/performance'}}];self.update();self.assertFalse(a.run(self.path,False)['holdout_labels_read'])
 def test_resolved_gain_passes(self):
  self.session();r=a.run(self.path,True);self.assertTrue(r['contrast_gate_passed'])
 def test_noise_does_not_pass(self):
  self.session([-100000,100000,-100000,100000,-100000,100000]);r=a.run(self.path,True);self.assertFalse(r['contrast_gate_passed']);self.assertEqual(r['sessions'][0]['pairs'][0]['status'],'inconclusive')
 def test_wrong_sign_fails(self):
  self.session([100000]*6);r=a.run(self.path,True);self.assertEqual(r['sessions'][0]['pairs'][0]['status'],'failed')
 def test_recalibration_cannot_be_same_model(self):
  self.session();self.m['sessions'][0]['model_sha256']='changed';self.update()
  with self.assertRaises(AssertionError):a.run(self.path,True)
 def test_artifact_identity_mismatch_rejected(self):
  self.session();p=Path(self.m['sessions'][0]['samples']['path']);p.write_text(p.read_text().replace('"graph_id": "a"','"graph_id": "stale"'));self.m['sessions'][0]['samples']=a.identity(p);self.update()
  with self.assertRaisesRegex(AssertionError,'differs'):a.run(self.path,True)
 def test_same_source_is_not_cancellation_proof(self):
  row=dict(self.row,implementation_evidence=[])
  with self.assertRaisesRegex(AssertionError,'same-source'):a.validate_predictions({'rows':[row]})
if __name__=='__main__':unittest.main()
