#!/usr/bin/env python3
"""CPU-only independent auditor tests; synthetic observations, zero device use."""
import importlib.util,json,tempfile,unittest
from pathlib import Path
import numpy as np
SCRIPT=Path(__file__).resolve().parents[2]/'scripts/audit_execution_observations_v18.py'
spec=importlib.util.spec_from_file_location('audit_v18',SCRIPT);audit=importlib.util.module_from_spec(spec);spec.loader.exec_module(audit)
class AuditTests(unittest.TestCase):
 def setUp(self):
  self.temp=tempfile.TemporaryDirectory();self.addCleanup(self.temp.cleanup);self.root=Path(self.temp.name);self.protocol=dict(seeds=[11],warmups=0,repeats=1,cases=[]);self.cases=[];self.rows=[]
  for i in range(4):
   dest=self.root/str(i);dest.mkdir();name=str(i);fixture=dest/'fixture.json';fixture.write_text(json.dumps(dict(fixture=dict(kind='diamond',m=2,n=2))));abi=dest/'abi.json';abi.write_text(json.dumps(dict(buffers=[dict(name=n) for n in ['A','B','C']])));case=dict(id=name,fixture=audit.ident(fixture),abi=audit.ident(abi));self.protocol['cases'].append(case);self.cases.append(dict(id=name,prediction_ns=20.))
   a=np.array([[-.45,0],[.25,1.5]],np.float32);x=(a.astype(np.float64)+1).astype(np.float32);strict=dict(B=(x.astype(np.float64)+2).astype(np.float32),C=(x.astype(np.float64)*2).astype(np.float32));exact=dict(B=a.astype(np.float64)+3,C=(a.astype(np.float64)+1)*2)
   for key,arr in [('inputs',dict(A=a)),('outputs',strict),('reference',strict),('reference_f64',exact)]:np.savez(dest/(key+'.npz'),**arr)
   events=[dict(kind='actual_bo_sync',start_ns=0,end_ns=1) for _ in range(5)]+[dict(kind='actual_xrt_start',start_ns=10,end_ns=11),dict(kind='actual_xrt_wait',start_ns=11,end_ns=20)]
   row=dict(case=name,seed=11,repeat=0,warmup=False,runner_wall_ns=20,dispatch_to_wait_end_ns=10,sync_subtotal_ns=5,other_runner_ns=5,events=events,case_identity=case)
   for key in ['inputs','outputs','reference','reference_f64']:row[key]=audit.ident(dest/(key+'.npz'))
   self.rows.append(row)
  (self.root/'summary.json').write_text(json.dumps(dict(status='passed',samples=4,actual_submissions=4)));self.flush()
 def flush(self):(self.root/'samples.jsonl').write_text('\n'.join(json.dumps(r) for r in self.rows)+'\n')
 def test_exact_rounding_and_all_pair_deltas(self):
  result=audit.evaluate(self.protocol,self.cases,self.root);self.assertEqual(result['output_arrays'],8);self.assertEqual(result['strict_f32_max_abs_error'],0);self.assertEqual(len(result['paired_contrasts']),6)
 def test_tampered_f32_rejected_even_with_updated_identity(self):
  row=self.rows[0];p=Path(row['outputs']['path']);z=np.load(p);b=z['B'].copy();c=z['C'].copy();z.close();b[0,0]=np.nextafter(b[0,0],np.float32(np.inf));np.savez(p,B=b,C=c);row['outputs']=audit.ident(p);self.flush()
  with self.assertRaises(AssertionError):audit.evaluate(self.protocol,self.cases,self.root)
 def test_same_inputs_required(self):
  row=self.rows[1];p=Path(row['inputs']['path']);z=np.load(p);a=z['A'].copy();z.close();a[0,0]=0;np.savez(p,A=a);row['inputs']=audit.ident(p);self.flush()
  with self.assertRaises(AssertionError):audit.evaluate(self.protocol,self.cases,self.root)
 def test_missing_raw_sample_rejected(self):
  self.rows.pop();self.flush()
  with self.assertRaises(AssertionError):audit.evaluate(self.protocol,self.cases,self.root)
if __name__=='__main__':unittest.main()
