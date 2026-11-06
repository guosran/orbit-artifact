#!/usr/bin/env python3
"""Prepare an identity-bound GDB/strace BO-sync path diagnostic.

Preparation is CPU-only. The emitted commands open the NPU and synchronize one
BO but create no run/kernel computation; only the NPU coordinator executes them.
Breakpoints bind one exact installed shim binary, not arbitrary XRT revisions.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

LIBRARY=Path('/usr/lib/x86_64-linux-gnu/libxrt_driver_xdna.so.2.21.75')
LIBRARY_SHA='e1250451844744149420986ba707f9f1e301530e92663c69e534c7195cc1e9c1'
SYNC='_ZN9shim_xdna6buffer4syncEN8xrt_core13buffer_handle9directionEmm'
DRIVER='_ZN9shim_xdna6buffer14sync_by_driverEN8xrt_core13buffer_handle9directionEmm'


def digest(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def save(path,value):Path(path).write_text(json.dumps(value,indent=2)+'\n')


def config_snapshot():
    keys=('XRT_INI_PATH','XRT_INI_DIR','XRT_LOG_LEVEL','XRT_EMULATION_MODE','XILINX_XRT')
    candidates={Path.cwd()/'xrt.ini',Path.home()/'xrt.ini'}
    configured=os.environ.get('XRT_INI_PATH')
    if configured:candidates.add(Path(configured).expanduser())
    directory=os.environ.get('XRT_INI_DIR')
    if directory:candidates.add(Path(directory).expanduser()/'xrt.ini')
    # Candidate capture does not prove which configuration file XRT selected.
    files=[]
    for path in sorted(candidates):
        files.append(dict(path=str(path.resolve()),exists=path.is_file(),sha256=digest(path) if path.is_file() else None))
    return dict(cwd=str(Path.cwd()),environment={k:os.environ.get(k) for k in keys},candidate_files=files,
                selected_config_file_observed=False)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--python',type=Path,default=Path('/home/shiran/project/aie-toy/.venv/bin/python'))
    parser.add_argument('--bytes',type=int,default=8192,help='BO allocation bytes')
    parser.add_argument('--range-size',type=int,default=4096)
    parser.add_argument('--offset',type=int,default=128)
    args=parser.parse_args()
    if args.bytes<=0 or args.range_size<=0 or args.offset<0 or args.offset+args.range_size>args.bytes:
        parser.error('positive in-bounds BO sync range required')
    if digest(LIBRARY)!=LIBRARY_SHA:raise RuntimeError('installed shim differs from breakpoint-bound binary')
    if not args.python.is_file() or not shutil.which('gdb') or not shutil.which('strace'):
        raise RuntimeError('existing Python/GDB/strace required')
    args.output=args.output.resolve();args.output.mkdir(parents=True,exist_ok=False)
    (args.output/'observer-source.py').write_bytes(Path(__file__).read_bytes())
    config=config_snapshot()
    for index,entry in enumerate(config['candidate_files']):
        if entry['exists']:
            copy=args.output/('config-candidate-'+str(index)+'.ini');copy.write_bytes(Path(entry['path']).read_bytes());entry['snapshot']=copy.name
    code='''import ctypes,hashlib,json,os
from pathlib import Path
OUT=Path(__file__).resolve().parent
freeze=json.loads((OUT/'freeze.json').read_text())
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
for path,expected in freeze['files'].items():
 if sha(path)!=expected:raise RuntimeError('Diagnostic file identity changed: '+path)
config=freeze['config']
if os.getcwd()!=config['cwd']:raise RuntimeError('Diagnostic cwd changed; config search scope differs')
for key,expected in config['environment'].items():
 if os.environ.get(key)!=expected:raise RuntimeError('Diagnostic config environment changed: '+key)
for item in config['candidate_files']:
 path=Path(item['path'])
 if path.is_file()!=item['exists'] or (path.is_file() and sha(path)!=item['sha256']):raise RuntimeError('Config candidate changed: '+str(path))
import pyxrt
if sha(pyxrt.__file__)!=freeze['pyxrt_sha256']:raise RuntimeError('Loaded pyxrt changed')
def marker(label):os.write(1,('ORBIT '+label+'\\n').encode())
marker('DEVICE_CREATE_BEGIN')
device=pyxrt.device(0)
marker('DEVICE_CREATE_END')
marker('BO_CREATE_BEGIN')
bo=pyxrt.ext.bo(device,freeze['allocation_bytes'])
marker('BO_CREATE_END')
marker('BO_MAP_BEGIN')
mapping=bo.map()
marker('BO_MAP_END address='+hex(ctypes.addressof(ctypes.c_char.from_buffer(mapping))))
marker('HOST_FILL_BEGIN')
mapping[:]=b'\\x3c'*freeze['allocation_bytes']
marker('HOST_FILL_END')
records=[]
for direction in ('TO_DEVICE','FROM_DEVICE'):
 enum=getattr(pyxrt.xclBOSyncDirection,'XCL_BO_SYNC_BO_'+direction)
 for overload in ('full','explicit-region'):
  label=direction+' '+overload
  marker('SYNC_BEGIN '+label)
  if overload=='full':bo.sync(enum)
  else:bo.sync(enum,freeze['range_size'],freeze['offset'])
  marker('SYNC_END '+label)
  records.append(dict(direction=direction,overload=overload,size=bo.size() if overload=='full' else freeze['range_size'],offset=0 if overload=='full' else freeze['offset']))
(OUT/('probe-'+os.environ.get('ORBIT_SYNC_TRACE_MODE','manual')+'.json')).write_text(json.dumps(dict(status='passed',calls=records,kernel_dispatches=0,pyxrt_path=pyxrt.__file__,pyxrt_sha256=sha(pyxrt.__file__)),indent=2)+'\\n')
del mapping,bo,device
'''
    probe=args.output/'probe.py';probe.write_text(code)
    gdb="set pagination off\nset confirm off\nset breakpoint pending on\nset print thread-events off\nset disable-randomization off\npython\nimport gdb,json\nstate={'calls':0,'base':None,'flush_reported':False,'paths':set(),'self':None}\ndef emit(record):\n gdb.write('ORBIT_GDB '+json.dumps(record)+'\\n');gdb.flush()\nclass Branch(gdb.Breakpoint):\n def __init__(self,address,kind):\n  self.kind=kind\n  super().__init__(address,internal=False)\n def stop(self):\n  if self.kind!='USER_CLFLUSH' or not state['flush_reported']:\n   record={'kind':self.kind,'call':state['calls'],'self':state['self'],'pc':hex(int(gdb.parse_and_eval('$pc')))}\n   if self.kind=='USER_CLFLUSH':\n    record.update(address=hex(int(gdb.parse_and_eval('$rax'))),stride=int(gdb.parse_and_eval('$rcx')))\n    state['flush_reported']=True\n   emit(record);state['paths'].add(state['calls'])\n  return False\nclass Entry(gdb.Breakpoint):\n def stop(self):\n  state['calls']+=1;state['flush_reported']=False\n  state['self']=hex(int(gdb.parse_and_eval('$rdi')))\n  record={'kind':'SYNC_ENTRY','call':state['calls'],'self':state['self'],'direction':int(gdb.parse_and_eval('$esi')),'size':int(gdb.parse_and_eval('$rdx')),'offset':int(gdb.parse_and_eval('$rcx'))}\n  if state['calls']<=8:record['backtrace']=gdb.execute('bt 10',to_string=True)\n  emit(record)\n  if state['base'] is None:\n   state['base']=int(gdb.parse_and_eval('(void *)&SYNC_SYMBOL'))\n   Branch('*'+hex(state['base']+0x98),'USER_CLFLUSH')\n   Branch('*'+hex(state['base']+0x32),'COHERENT_EARLY_RETURN')\n  return False\nEntry('SYNC_SYMBOL')\nBranch('DRIVER_SYMBOL','DRIVER_SYNC')\nend\nrun\npython\nif state['calls']<4 or len(state['paths'])<4:\n raise gdb.GdbError('Incomplete sync-path diagnostic; do not treat as a successful branch observation')\nemit({'status':'observed','entries':state['calls'],'classified_entries':len(state['paths'])})\nend\n".replace('SYNC_SYMBOL',SYNC).replace('DRIVER_SYMBOL',DRIVER)
    gdbfile=args.output/'path.gdb';gdbfile.write_text(gdb)
    pyinfo=subprocess.run([str(args.python),'-c','import pyxrt;print(pyxrt.__file__)'],capture_output=True,text=True,check=True)
    pypath=Path(pyinfo.stdout.strip())
    files={str(LIBRARY):LIBRARY_SHA,str(pypath):digest(pypath),str(probe):digest(probe),str(gdbfile):digest(gdbfile),str(args.python.resolve()):digest(args.python)}
    for bound in (Path('/usr/lib/x86_64-linux-gnu/libxrt_coreutil.so.2.21.75'),
                  Path('/lib/modules')/os.uname().release/'kernel/drivers/accel/amdxdna/amdxdna.ko.zst',
                  Path(shutil.which('gdb')),Path(shutil.which('strace'))):
        if not bound.is_file():raise RuntimeError('Required diagnostic binding is missing: '+str(bound))
        files[str(bound)]=digest(bound)
    freeze=dict(schema='orbit.sync-path-diagnostic.v14',files=files,pyxrt_sha256=digest(pypath),config=config,
                allocation_bytes=args.bytes,range_size=args.range_size,offset=args.offset,
                shim_symbol=SYNC,shim_vma=0x39350,clflush_offset=0x98,coherent_return_offset=0x32,
                loaded_module_srcversion=Path('/sys/module/amdxdna/srcversion').read_text().strip(),
                kernel_release=os.uname().release,kernel_dispatches=0,timing_measurement=False,
                observer_sha256=digest(__file__),entry_stack_limit=8,entry_backtrace_frames=10,marker_stream='stdout',merge_debugger_streams_required=True)
    save(args.output/'freeze.json',freeze)
    commands=dict(cwd=str(Path.cwd()),
        gdb=['env','ORBIT_SYNC_TRACE_MODE=gdb',shutil.which('gdb'),'-q','--batch','-iex','set debuginfod enabled off','-x',str(gdbfile),'--args',str(args.python),str(probe)],
        strace=['env','ORBIT_SYNC_TRACE_MODE=strace',shutil.which('strace'),'-f','-ttt','-T','-e','trace=ioctl,write','-o',str(args.output/'strace.log'),str(args.python),str(probe)],
        note='Execute separately under coordinator; merge stdout and stderr into one ordered log for GDB. Stdout markers distinguish device, BO constructor, map, host fill, and four manual syncs. First8 entry stacks and self pointers identify automatic/nested calls. No kernel computation or timing interpretation.')
    save(args.output/'commands.json',commands)
    print(json.dumps(dict(status='prepared',output=str(args.output),device_opened=False,commands='commands.json')))


if __name__=='__main__':main()
