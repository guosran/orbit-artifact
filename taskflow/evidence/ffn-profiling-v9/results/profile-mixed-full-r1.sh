#!/usr/bin/env bash
set -euo pipefail
cd /home/shiran/project/orbit-artifact
source /home/shiran/project/aie-toy/scripts/env.sh
out=$PWD/results/taskflow/ffn-profiling-v9
for m in 1 5 8; do
 python taskflow/scripts/taskflow_ffn_profile.py --cases "$out/cases-mixed-full-m$m-r1.json" --iterations 1 --warmups 1 --observer detailed --output "$out/profile-mixed-full-m$m-r1"
done
