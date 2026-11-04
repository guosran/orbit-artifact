import hashlib,json,subprocess
from pathlib import Path
r=Path('/home/shiran/project/orbit-artifact/results/taskflow/ffn-profiling-v9')
rows=json.loads((r/'joint-profiled-search-proposals-r1/cases.json').read_text());result=[]
for row in rows:
 out=r/'search-compiled-r2'/row['name']
 inp=r/'search-inputs-r2'/row['name'];inp.mkdir(parents=True,exist_ok=False)
 (inp/'source.mlir').write_bytes(Path(row['source']).read_bytes())
 cmd=['bash','taskflow/scripts/run_taskflow_direct_air_v6_case.sh','--compile-only','--diagnostic','--input',str(inp),'--output',str(out),'--tool',str(r/'frozen-tools/taskflow-opt-mixed-r2'),'--target-config',row['config'],'--runtime-transfer-audit']
 print(row['name'],row['properties'],flush=True)
 p=subprocess.run(cmd)
 result.append(dict(candidate_id=row['candidate_id'],command=cmd,returncode=p.returncode))
 (r/'compile-search-r2-results.json').write_text(json.dumps(result,indent=2)+'\n')
 if p.returncode:raise SystemExit(p.returncode)
