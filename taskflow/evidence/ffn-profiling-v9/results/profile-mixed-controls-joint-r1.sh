#!/usr/bin/env bash
set -euo pipefail
cd /home/shiran/project/orbit-artifact
source /home/shiran/project/aie-toy/scripts/env.sh
out=$PWD/results/taskflow/ffn-profiling-v9
python taskflow/scripts/taskflow_ffn_profile.py --cases "$out/cases-mixed-controls-r1.json" --iterations 3 --warmups 2 --observer detailed --output "$out/profile-mixed-controls-r1"
python taskflow/scripts/taskflow_ffn_profile.py --cases "$out/cases-joint-implementation-r1.json" --iterations 10 --warmups 2 --observer detailed --output "$out/profile-joint-implementation-r1"
python taskflow/scripts/taskflow_direct_air_trace_v9.py --air "$out/mixed-trace-source-r1/program.air.mlir" --abi "$out/mixed-trace-source-r1/abi.json" --inputs "$out/inputs/trace-gemm/inputs-11.npz" --reference "$out/inputs/trace-gemm/reference-11.npz" --output "$out/packet-trace-mixed-r1" --mark-core-window --iterations 5
