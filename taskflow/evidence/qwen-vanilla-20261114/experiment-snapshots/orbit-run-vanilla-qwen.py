import fcntl,hashlib,json,os,subprocess,time
from pathlib import Path
vendor=Path('/home/shiran/project/aie-toy/vendor/Triton-XDNA')
air=Path('/home/shiran/project/aie-toy/build/qwen25-3b/Triton-XDNA/third_party/mlir-air-src')
root=Path('/home/shiran/project/orbit-artifact/results/taskflow/qwen-vanilla-20261114')
root.mkdir(exist_ok=False)
model=json.load(open('/home/shiran/project/aie-toy/results/qwen25-3b/model-paths.json'))
assert subprocess.check_output(['git','status','--porcelain','--untracked-files=no'],cwd=vendor)==b''
files={}
for name in ['examples/qwen25_3b_q4nx/qwen25_3b_q4nx_inference.py','examples/qwen25_3b_q4nx/config.py','examples/llm_q4nx/harness.py','examples/llm_q4nx/qwen25_prefill.py','examples/llm_q4nx/llama_prefill.py','examples/llm_q4nx/kernels.py']:
 files[name]=hashlib.sha256((vendor/name).read_bytes()).hexdigest()
argv=['/home/shiran/project/aie-toy/.venv/bin/python','-u',str(vendor/'examples/qwen25_3b_q4nx/qwen25_3b_q4nx_inference.py'),'--prefill-engine','triton','--backend','npu','--decode','npu','--prompt','785,6722,315,9625,374','--max-tokens','128','--max-seq','2048','--greedy','--model',model['model']]
env=os.environ.copy()
env.update(AIR_LLMS_ROOT=str(air/'programming_examples/llms'),XILINX_XRT='/usr',AMD_TRITON_NPU_RUNTIME='xrt',Q4NX_TOKENIZER_DIR=model['tokenizer'],HF_HUB_OFFLINE='1',TRANSFORMERS_OFFLINE='1',PYTHONDONTWRITEBYTECODE='1',OMP_NUM_THREADS='4',MKL_NUM_THREADS='4',OPENBLAS_NUM_THREADS='4')
for key in ['DECODE_ELF','COALESCE','PROJ_RC_CACHE','Q4NX_NPU_STATIC_WEIGHTS','Q4NX_EXACT_K']:env.pop(key,None)
metadata=dict(schema='orbit.vanilla-qwen-cli-run.v1',vendor_commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=vendor,text=True).strip(),air_commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=air,text=True).strip(),vendor_tracked_clean=True,source_sha256=files,command=argv,environment={k:env[k] for k in ['AIR_LLMS_ROOT','XILINX_XRT','AMD_TRITON_NPU_RUNTIME','Q4NX_TOKENIZER_DIR','HF_HUB_OFFLINE','TRANSFORMERS_OFFLINE','PYTHONDONTWRITEBYTECODE','OMP_NUM_THREADS','MKL_NUM_THREADS','OPENBLAS_NUM_THREADS']},measurement_scope='Direct original CLI. Process wall includes model load and native setup. Native printed compute timers retained separately; not the r19 ready executor.',status='RUNNING')
(root/'run.json').write_text(json.dumps(metadata,indent=2)+'\n')
with open('/tmp/npu.lock','a') as lock:
 fcntl.flock(lock,fcntl.LOCK_EX)
 directory=root/'attempt1';directory.mkdir()
 start=time.monotonic()
 with (directory/'stdout.log').open('w') as log:
  p=subprocess.Popen(['/usr/bin/time','-v','-o',str(directory/'resource.txt'),*argv],cwd=directory,env=env,stdout=log,stderr=subprocess.STDOUT)
  metadata.update(pid=p.pid,started_unix=time.time());(root/'run.json').write_text(json.dumps(metadata,indent=2)+'\n')
  rc=p.wait()
 metadata.update(status='COMPLETED',returncode=rc,process_wall_seconds=time.monotonic()-start,original_vendor_still_clean=subprocess.check_output(['git','status','--porcelain','--untracked-files=no'],cwd=vendor)==b'')
 (root/'run.json').write_text(json.dumps(metadata,indent=2)+'\n')
 print(json.dumps({k:v for k,v in metadata.items() if k not in ['source_sha256','environment']},indent=2),flush=True)
