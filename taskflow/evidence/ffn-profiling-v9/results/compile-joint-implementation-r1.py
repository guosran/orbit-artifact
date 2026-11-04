import json,subprocess
from pathlib import Path
r=Path('/home/shiran/project/orbit-artifact/results/taskflow/ffn-profiling-v9')
rows=json.loads((r/'joint-profiled-implementation-proposals-r1/selected-four-cases.json').read_text())
records=[]
for row in rows:
 cid=row['candidate_id']; inp=r/'joint-implementation-input-r1'/cid;inp.mkdir(parents=True,exist_ok=False)
 (inp/'source.mlir').write_bytes(Path(row['source']).read_bytes())
 out=r/'joint-implementation-compiled-r1'/cid
 cmd=['bash','taskflow/scripts/run_taskflow_direct_air_v6_case.sh','--compile-only','--diagnostic','--input',str(inp),'--output',str(out),'--tool',str(r/'frozen-tools/taskflow-opt-v9-final-r1'),'--target-config',row['config'],'--runtime-transfer-audit']
 print(cid,row['properties'],flush=True)
 p=subprocess.run(cmd);records.append(dict(candidate_id=cid,command=cmd,returncode=p.returncode))
 (r/'compile-joint-implementation-results-r1.json').write_text(json.dumps(records,indent=2)+'\n')
 if p.returncode: raise SystemExit(p.returncode)
 p=subprocess.run(['/home/shiran/project/aie-toy/.venv/bin/python','taskflow/test/TaskflowAIR/audit_storage_v6.py',str(out/'hardware'),'--plan',str(out/'plan.json'),'--output',str(out/'storage-audit.json')])
 if p.returncode:raise SystemExit(p.returncode)
