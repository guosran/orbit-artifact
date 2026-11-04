import collections,hashlib,json,re,subprocess
from pathlib import Path
BASE=Path('/home/shiran/project/orbit-artifact/results/taskflow/implementation-search-v10/compiled-final-r1')
OUT=Path(__file__).resolve().parent
READELF=Path('/home/shiran/project/aie-toy/.venv/lib/python3.12/site-packages/llvm-aie/bin/llvm-readelf')
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
bound=lambda p:dict(path=str(p),sha256=sha(p))
def region(text,start):
 begin=text.index('{',start);depth=1;end=begin+1
 while depth:
  depth+=(text[end]=='{')-(text[end]=='}');end+=1
 return text[begin+1:end-1]
def devices(text):
 return {m[1]:region(text,m.start()) for m in re.finditer(r'aie.device\(npu2\) @([\w.$]+)\s*\{',text)}
def data(body):
 tiles={m[1]:[int(m[2]),int(m[3])] for m in re.finditer(r'%([\w.$]+) = aie.tile\((\d+), (\d+)\)',body)}
 buffers=[]
 for m in re.finditer(r'%([\w.$]+) = aie.buffer\(%([\w.$]+)\)[^\n]*?: (memref<[^>]+>)',body):
  buffers.append(dict(symbol=m[1],tile=tiles[m[2]],type=m[3]))
 flows=[]
 for m in re.finditer(r'aie.flow\(%([\w.$]+), DMA : (\d+), %([\w.$]+), DMA : (\d+)\)',body):
  flows.append(dict(source=tiles[m[1]],source_dma_channel=int(m[2]),destination=tiles[m[3]],destination_dma_channel=int(m[4])))
 return dict(tiles=tiles,buffers=buffers,flows=flows,object_fifo_ops=len(re.findall(r'\baie\.object_?fifo',body)),memtile_dma_ops=len(re.findall(r'\baie\.memtile_dma',body)))
packages=[]
for folder in sorted(BASE.iterdir()):
 project=folder/'hardware/air_project'
 if not (project/'npu.input.air.mlir').exists():continue
 compile_record=json.loads((folder/'hardware/compile.json').read_text());assert compile_record['status']=='compiled'
 storage=json.loads((folder/'storage-audit.json').read_text());runtime=json.loads((folder/'runtime-transfer-audit.json').read_text());abi=json.loads((folder/'abi.json').read_text());plan=json.loads((folder/'plan.json').read_text())
 views={name:{stage:data(body) for stage,body in devices((project/name).read_text()).items()} for name in ['aie.input.air.mlir','placed.input.air.mlir','npu.input.air.mlir']}
 final=views['npu.input.air.mlir'];stages=[]
 for stage in storage['stages']:
  name=stage['linker_script'].removeprefix('ldScripts_').removesuffix('_core_0_2.ld.script');body=devices((project/'npu.input.air.mlir').read_text())[name];script=project/stage['linker_script'];text=script.read_text()
  windows=[dict(name=m[1],origin=int(m[2],16),length=int(m[3],16)) for m in re.finditer(r'\b(bank[0-3]) \(!RX\) : ORIGIN = (0x[0-9A-Fa-f]+), LENGTH = (0x[0-9A-Fa-f]+)',text)]
  buffer_storage={m[1]:m[2] for m in re.finditer(r'memref.reinterpret_cast %([\w.$]+)[^\n]*?orbit.storage = "([^"]+)"',body)}
  dmabuffers=[]
  for m in re.finditer(r'aie.dma_start\((MM2S|S2MM), (\d+), \^([\w]+),',body):
   label=re.search(r'^\s*\^'+re.escape(m[3])+r':(.*?)(?=^\s*\^[\w]+:|\Z)',body[m.end():],re.M|re.S)
   assert label,(folder.name,name,m[3])
   bd=re.search(r'aie.dma_bd\(%([\w.$]+) : (memref<[^>]+>) offset = (\d+) len = (\d+)',label[1]);assert bd
   dmabuffers.append(dict(direction=m[1],channel=int(m[2]),buffer=bd[1],storage=buffer_storage.get(bd[1]),type=bd[2],bd_elements=int(bd[4])))
  elfdir=project/('elfs_'+name+'_core_0_2');elf=next(elfdir.glob('*.elf'))
  commands=[];sections={};symbol_values={}
  for option,suffix in [('-SW','sections'),('-s','symbols')]:
   command=[str(READELF),option,str(elf)];r=subprocess.run(command,capture_output=True,text=True);assert r.returncode==0
   log=OUT/(folder.name+'--'+name+'--'+suffix+'.txt');log.write_text(r.stdout);commands.append(dict(argv=command,returncode=r.returncode,output=bound(log)))
   if option=='-SW':
    for m in re.finditer(r'^\s*\[\s*\d+\]\s+(\.\S+)\s+\S+\s+([0-9A-Fa-f]+)\s+[0-9A-Fa-f]+\s+([0-9A-Fa-f]+)\s+\S+\s+([A-Z]*)',r.stdout,re.M):
     sections[m[1]]=dict(address=int(m[2],16),bytes=int(m[3],16),flags=m[4])
   else:
    for m in re.finditer(r'^\s*\d+:\s+([0-9A-Fa-f]+)\s+\d+\s+\S+\s+\S+\s+\S+\s+\S+\s+(\S+)',r.stdout,re.M):symbol_values[m[2]]=int(m[1],16)
  for b in stage['buffers']:
   assert symbol_values[b['name']]==b['address'];b['storage']=buffer_storage.get(b['name']);b['address_hex']=hex(b['address'])
  assert symbol_values['_sp_start_value_DM_stack']==stage['stack_address']
  stage=dict(stage,device=name,linker_windows=windows,local_dma_buffers=dmabuffers,core_elf=bound(elf),readelf_commands=commands,elf_sections=sections,
      extra_nontext_alloc_sections={k:v for k,v in sections.items() if 'A' in v['flags'] and 'X' not in v['flags'] and v['bytes']>0},physical_symbol_values_verified=True)
  ledger=next(s for s in runtime['stages'] if s['device']==name);channels={m[1]:(m[2],int(m[3])) for m in re.finditer(r'aie.shim_dma_allocation @([\w.$]+)\([^\n]*?, (MM2S|S2MM), (\d+)\)',body)}
  paths=[]
  for task in ledger['tasks']:
   direction,channel=channels[task['channel']];flow=[f for f in final[name]['flows'] if (f['source']==[0,0] and f['source_dma_channel']==channel) if direction=='MM2S'] if direction=='MM2S' else [f for f in final[name]['flows'] if f['destination']==[0,0] and f['destination_dma_channel']==channel]
   assert len(flow)==1,(name,task,flow)
   core_direction='S2MM' if direction=='MM2S' else 'MM2S';core_channel=flow[0]['destination_dma_channel'] if direction=='MM2S' else flow[0]['source_dma_channel']
   local=[b for b in dmabuffers if b['direction']==core_direction and b['channel']==core_channel];assert len(local)==1 and local[0]['storage']==task['storage'],(name,task,local)
   paths.append(dict(storage=task['storage'],abi_argument=task['argument'],direction=task['direction'],static_runtime_bytes=task['bytes'],runtime_channel=task['channel'],shim_direction=direction,shim_channel=channel,flow=flow[0],core_direction=core_direction,core_channel=core_channel,local_buffer=local[0],path='ABI system BO -> shim MM2S -> stream flow -> compute S2MM -> space2 buffer' if direction=='MM2S' else 'space2 buffer -> compute MM2S -> stream flow -> shim S2MM -> ABI system BO'))
  stage['paths']=paths;stages.append(stage)
 package=dict(case=folder.name,compiled_elf_sha256=compile_record['elf_sha256'],native_tool=json.loads((folder/'invocation.json').read_text())['tool_sha256'],architecture_fingerprint=plan['direct_air_cost']['features']['architecture_fingerprint'],views=views,stages=stages,host_abi_buffers=storage['host_abi_buffers'],plan_capacity_policy_bytes=plan['capacity_bytes'],sources=[bound(folder/n) for n in ['plan.json','abi.json','storage-audit.json','runtime-transfer-audit.json','hardware/compile.json']]+[bound(project/n) for n in views])
 packages.append(package)
assert len(packages)==16
stages=[s for p in packages for s in p['stages']];views=[v for p in packages for v in p['views']['npu.input.air.mlir'].values()]
summary=dict(status='observed-artifacts-audited',cases=len(packages),compute_stages=len(stages),runtime_tensor_paths=sum(len(s['paths']) for s in stages),max_compute_payload_bytes=max(s['buffer_payload_bytes'] for s in stages),max_extra_local_payload_bytes=max(s['extra_local_payload_bytes'] for s in stages),stack_reserved_bytes=sorted({s['stack_reserved_bytes'] for s in stages}),final_declared_row1_tiles=sum(sum(t[1]==1 for t in v['tiles'].values()) for v in views),final_row1_allocated_buffers=sum(sum(b['tile'][1]==1 for b in v['buffers']) for v in views),final_memtile_dma_ops=sum(v['memtile_dma_ops'] for v in views),final_object_fifo_ops=sum(v['object_fifo_ops'] for v in views),final_flows_with_row1_endpoint=sum(sum(f['source'][1]==1 or f['destination'][1]==1 for f in v['flows']) for v in views),nonempty_extra_nontext_alloc_sections=[dict(case=p['case'],stage=s['device'],sections=s['extra_nontext_alloc_sections']) for p in packages for s in p['stages'] if s['extra_nontext_alloc_sections']],scope='read-only old16 compiled packages, exact static paths and linker/ELF evidence, not measured traffic/capacity/progress; future tool/architecture must be rebound')
(OUT/'physical-paths.json').write_text(json.dumps(dict(summary=summary,packages=packages,readelf=bound(READELF)),indent=2)+'\n')
print(json.dumps(summary))
