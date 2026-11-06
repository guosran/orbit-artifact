#!/usr/bin/env python3
"""Check native timing's derived physical buffer edges against public DAG reachability.

Model resource-calendar waiting is intentionally separate: it is an explicit
reservation assumption, not asserted to be a physical lock dependency.
"""
import argparse,json
from pathlib import Path
from audit_execution_observations_tolerance_v18 import read,ident,save

def audit(compiled):
 p=read(compiled/'plan.json');events=p['program_communication']['events'];anc=[set(e['depends_on']) for e in events]
 for i in range(len(events)):
  assert all(x<i for x in anc[i]),'native event witness must be topological'
  for parent in list(anc[i]):anc[i]|=anc[parent]
 t=p['direct_air_cost']['event_timing']['timing'];orders=t['buffer_ordering'];bad=[x for x in orders if x['predecessor']!=x['successor'] and x['predecessor'] not in anc[x['successor']]]
 return dict(plan=ident(compiled/'plan.json'),graph_id=p['program_graph']['id'],checked_physical_buffer_edges=len(orders),unexplained_physical_buffer_edges=bad,status='failed' if bad else 'passed',scope='Derived physical buffer edges must already be justified by native public readiness DAG. Conservative resource calendar reservations and memory occupancy are not physical edge assertions.')
def main():
 parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--compiled-index',type=Path,required=True);parser.add_argument('--output',type=Path,required=True);a=parser.parse_args();rows=[]
 for c in read(a.compiled_index)['cases']:rows.append(dict(id=c['id'],**audit(Path(c['compiled']))))
 result=dict(schema='orbit.native-timing-dependency-independent.v18',auditor=ident(__file__),compiled_index=ident(a.compiled_index),cases=rows,status='passed' if all(x['status']=='passed' for x in rows) else 'failed',device_submissions=0);save(a.output,result);print(json.dumps(dict(status=result['status'],unexplained=sum(len(x['unexplained_physical_buffer_edges']) for x in rows))));raise SystemExit(result['status']!='passed')
if __name__=='__main__':main()
