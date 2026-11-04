#!/usr/bin/env bash
set -euo pipefail
cd /home/shiran/project/orbit-artifact
source /home/shiran/project/aie-toy/scripts/env.sh
out=$PWD/results/taskflow/ffn-profiling-v9
for stage in gate up activation down; do
 impl=scalar
 if [[ "$stage" != activation ]]; then impl=scalar-product-vector-add-f32; fi
 args=()
 if [[ "$impl" != scalar ]]; then args+=(--vector-lanes 8); fi
 bash taskflow/scripts/run_taskflow_direct_air_v6_case.sh --compile-only --diagnostic --input "$out/inputs/m8/$stage" --output "$out/mixed-m8-stages-r1/$stage" --tool "$out/frozen-tools/taskflow-opt-v9-final-r1" --target-config "$out/target.json" --distribute-initialization --approx-exp --implementation "$impl" "${args[@]}" --runtime-transfer-audit
 python taskflow/test/TaskflowAIR/audit_storage_v6.py "$out/mixed-m8-stages-r1/$stage/hardware" --plan "$out/mixed-m8-stages-r1/$stage/plan.json" --output "$out/mixed-m8-stages-r1/$stage/storage-audit.json"
done
python - "$out" <<'PY'
import json,sys
from pathlib import Path
r=Path(sys.argv[1]);rows=[]
for stage in ['gate','up','activation','down','full']:
 folder=r/('mixed-full-r1/m8' if stage=='full' else f'mixed-m8-stages-r1/{stage}')
 abi=json.loads((folder/'abi.json').read_text())
 rows.append(dict(name=f'm8-{stage}',hardware=str(folder/'hardware'),abi=str(folder/'abi.json'),static_indices=[i for i,b in enumerate(abi['buffers']) if b['role']=='input' and b['name'].startswith('W_')],intermediate_indices=[i for i,b in enumerate(abi['buffers']) if b['role']=='temporary'],inputs=[str(r/f'inputs/m8/{stage}/inputs-11.npz')],reference=[str(r/f'inputs/m8/{stage}/reference-11.npz')]))
(r/'cases-mixed-m8-stages-r1.json').write_text(json.dumps(rows,indent=2)+'\n')
PY
python taskflow/scripts/taskflow_ffn_profile.py --cases "$out/cases-mixed-m8-stages-r1.json" --iterations 1 --warmups 1 --observer detailed --output "$out/profile-mixed-m8-stages-r1"
python taskflow/test/TaskflowAIR/audit_profile_v9.py --root "$out" --profile profile-mixed-m8-stages-r1 --output .work/profiling-v9-audit/mixed-m8-stages-r1
