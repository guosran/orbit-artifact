import json,hashlib
from pathlib import Path
from fractions import Fraction
import numpy as np
ROOT=Path('/home/shiran/project/orbit-artifact'); P=ROOT/'results/taskflow/implementation-search-v10/design-final-r2'; OUT=Path(__file__).parent
load=lambda p:json.loads(Path(p).read_text()); sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
d=load(P/'design.json');rows=load(P/'static-features.json');r=load(P/'design-report.json');checks=[]
def check(ok,label):
 assert ok,label
 checks.append(label)
def bound(v):
 check(sha(v['path'])==v['sha256'],'identity '+v['path']);return load(v['path'])
for k in ['matrix','registration','report','proposal','features']:bound(d[k])
check(sha(d['tool']['path'])==d['tool']['sha256'],'tool bytes')
m=load(d['matrix']['path']); cells={c['name']:c for c in m['cells'] if c['split']!='negative'}
check(len(cells)==18 and {x['name'] for x in rows}==set(cells),'exact 18 declared cells')
check(len({x['name'] for x in rows})==18,'unique names')
terms=d['terms']; X=[]; fps=[];families=set();arches=set()
for row in rows:
 c=cells[row['name']];s=row['selection'];f=row['features'];v=f['values'];p=bound(s['plan']);check(sha(s['source']['path'])==s['source']['sha256'],'source bytes '+row['name']);bound(s['config'])
 check(s['cell']==c and row['split']==c['split'],'exact cell '+row['name'])
 check(p['direct_air_cost']['features']==f,'native facts '+row['name'])
 for k in ['all_source_loops_affine','all_source_loops_unit_step','all_storage_f32','mixed8_lane_coverage_exact']:check(v[k]==1,k+' '+row['name'])
 for k,val in v.items():check(type(val)==int and 0<=val<2**63,'integer '+k+' '+row['name'])
 h=hashlib.sha256(json.dumps(p['target_memory'],sort_keys=True,separators=(',',':')).encode()).hexdigest()
 check(h==f['architecture_fingerprint'],'architecture hash '+row['name'])
 families.add(f['region_family_fingerprint']);arches.add(h);fps.append(f['execution_fingerprint'])
 if row['split']=='train':X.append([v[k] for k in terms])
check(len(X)==12 and len(rows)-len(X)==6,'12 train six holdout')
check(len(set(fps))==18,'unique execution fingerprints')
check(sorted(families)==d['domain']['family_fingerprints'] and len(families)==1,'family whitelist')
check(sorted(arches)==d['domain']['architecture_fingerprints'] and len(arches)==1,'architecture whitelist')
for k,interval in d['domain']['feature_ranges'].items():check(interval==[min(x['features']['values'][k] for x in rows),max(x['features']['values'][k] for x in rows)],'exact envelope '+k)
check(X==r['training_matrix'],'matrix native values')
A=[[Fraction(z) for z in row] for row in X];rank=0
for j in range(4):
 pivot=next((i for i in range(rank,len(A)) if A[i][j]),None)
 if pivot is None:continue
 A[rank],A[pivot]=A[pivot],A[rank];x=A[rank][j];A[rank]=[z/x for z in A[rank]]
 for i in range(len(A)):
  if i!=rank:
   x=A[i][j];A[i]=[z-x*y for z,y in zip(A[i],A[rank])]
 rank+=1
check(rank==4==r['rank'],'independent exact rank4')
a=np.array(X,dtype=float);sv=np.linalg.svd(a/np.linalg.norm(a,axis=0),compute_uv=False);condition=float(sv[0]/sv[-1]);check(abs(condition-r['scaled_condition'])<1e-10,'independent normalized condition')
check(d['timing_labels_read'] is False and r['holdout_timing_labels_read'] is False,'static only declaration')
report=dict(status='passed',checks=len(checks),rank=rank,scaled_condition=condition,train_cases=12,holdout_cases=6,family_fingerprints=sorted(families),architecture_fingerprints=sorted(arches),read_scope='Only static design/matrix/registration/proposal/source/config/native plans and frozen tool bytes; no profile labels opened',caveats=['Tail15 hardware stages extrapolates training2/3/5 stages; module-wide channel conversion unseen in training. Static domain admission does not validate timing accuracy.'],design_sha256=sha(P/'design.json'))
(OUT/'report.json').write_text(json.dumps(report,indent=2)+'\n');(OUT/'checks.json').write_text(json.dumps(checks,indent=2)+'\n');print(json.dumps(report))
