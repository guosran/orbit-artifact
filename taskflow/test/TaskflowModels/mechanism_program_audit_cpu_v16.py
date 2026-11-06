#!/usr/bin/env python3
"""CPU-only negative checks for the independent evidence gate (no NPU calls)."""
import copy
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
spec=importlib.util.spec_from_file_location('audit',Path(__file__).with_name('audit_mechanism_program_v16.py')); audit=importlib.util.module_from_spec(spec);spec.loader.exec_module(audit)
class AuditTest(unittest.TestCase):
    def setUp(self):
        self.tmp=tempfile.TemporaryDirectory();self.root=Path(self.tmp.name)
        self.model=self.put('model.json',{'coefficient':1})
        rows=[dict(case=c,graph_id='g'+c,plan_id='p'+c,artifact_sha256=c*64,prediction_ns=v,action_chain=['original-search-action']) for c,v in [('a',100),('b',110)]]
        self.pred=self.put('predictions.json',{'rows':rows})
        self.m=dict(schema='orbit.mechanism-program.audit-manifest.v16',frozen={'model':self.model,'predictions':self.pred},required_roles=['model','predictions'],predictions=self.pred,acceptance={'absolute_floor_ns':300000,'relative_fraction':.25},sessions=[])
        self.manifest=self.root/'manifest.json';self.write();receipt=audit.audit(self.manifest,False);self.m['freeze_receipt']=self.put('receipt.json',receipt)
    def tearDown(self):self.tmp.cleanup()
    def put(self,name,obj):
        p=self.root/name;p.write_text(json.dumps(obj));return audit.identity(p)
    def write(self):self.manifest.write_text(json.dumps(self.m))
    def session(self,other=False):
        records=[dict(case=c,graph_id='g'+c,plan_id='p'+c,artifact_sha256=c*64,seed=1,repeat=i,warmup=False,duration_ns=v) for i in range(3) for c,v in [('a',100),('b',1000 if other else 110)]]
        p=self.root/'samples.jsonl';p.write_text('\n'.join(json.dumps(x) for x in records))
        self.m['sessions']=[dict(id='holdout',kind='unseen-plan',cases=['a','b'],model_sha256=self.model['sha256'],samples=audit.identity(p),freeze_receipt_sha256=self.m['freeze_receipt']['sha256'])];self.write()
    def test_freeze_never_opens_samples(self):
        self.m['sessions']=[{'samples':{'path':'/definitely/absent'}}];self.write();self.assertFalse(audit.audit(self.manifest,False)['holdout_labels_read'])
    def test_tampered_freeze_rejects(self):
        Path(self.model['path']).write_text('{}')
        with self.assertRaises(AssertionError):audit.audit(self.manifest,False)
    def test_missing_prior_receipt_rejects(self):
        self.session();del self.m['freeze_receipt'];self.write()
        with self.assertRaises(KeyError):audit.audit(self.manifest,True)
    def test_wrong_artifact_rejects(self):
        self.session();p=Path(self.m['sessions'][0]['samples']['path']);s=p.read_text().replace('"ga"','"stale"');p.write_text(s);self.m['sessions'][0]['samples']=audit.identity(p);self.write()
        with self.assertRaises(AssertionError):audit.audit(self.manifest,True)
    def test_other_model_cannot_be_same_model_session(self):
        self.session();self.m['sessions'][0]['model_sha256']='0'*64;self.write()
        with self.assertRaises(AssertionError):audit.audit(self.manifest,True)
    def test_coarse_accuracy_does_not_authorize_ranking(self):
        self.session(other=True);r=audit.audit(self.manifest,True);self.assertTrue(all(x['passed'] for x in r['sessions'][0]['cells']));self.assertFalse(r['sessions'][0]['contrasts'][0]['ranking_supported']);self.assertFalse(r['search_ready'])
    def test_supported_difference_reported(self):
        self.session();r=audit.audit(self.manifest,True);self.assertTrue(r['ranking_all_observed_pairs_supported']);self.assertFalse(r['search_ready'])
if __name__=='__main__': unittest.main()
