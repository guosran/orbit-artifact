#!/usr/bin/env python3
"""Static source/package identity audit; opens no runtime/device, builds nothing.

Counts are textual descriptor templates, never dynamic transfers or DDR bytes.
Unrolled single-region packages may separately establish exact invocation counts.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil


def identity(path):
    path=Path(path).resolve()
    return dict(path=str(path),sha256=hashlib.sha256(path.read_bytes()).hexdigest(),bytes=path.stat().st_size)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--compiled',type=Path,action='append',required=True)
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args();args.output.mkdir(parents=True,exist_ok=False)
    packages=[]
    for compiled_path in args.compiled:
        compiled=json.loads(compiled_path.read_text());manifest_path=Path(compiled['manifest'])
        manifest=json.loads(manifest_path.read_text())
        if identity(manifest_path)['sha256']!=compiled['manifest_sha256']:raise ValueError('changed manifest')
        item=dict(compiled=identity(compiled_path),manifest=identity(manifest_path),parent_graph_id=manifest['graph_id'],regions=[])
        for region in compiled['regions']:
            artifact=region['artifact'];elf=Path(artifact['elf_path']);project=elf.parent/'air_project'
            if identity(elf)['sha256']!=artifact['elf_sha256']:raise ValueError('changed ELF')
            files={p.name:identity(p) for p in [project/'aie.input.air.mlir',project/'npu.input.air.mlir',project/'placed.input.air.mlir',project/'full_elf_config.json'] if p.is_file()}
            native=manifest['regions'][region['index']]
            for key in ('source','air','npu_abi_path'):
                if key in native:
                    path=manifest_path.parent/native[key];files['native-'+key]=identity(path)
            aie=(project/'aie.input.air.mlir').read_text();runtime=(project/'npu.input.air.mlir').read_text()
            facts=dict(core_tiles=re.findall(r'aie.core\((%[\w]+)',aie),
                dma_start_templates=re.findall(r'aie.dma_start\((MM2S|S2MM),\s*(\d+)',aie),
                dma_bd_templates=re.findall(r'aie.dma_bd\([^\n]+',runtime),
                shim_allocations=re.findall(r'aie.shim_dma_allocation[^\n]+',runtime),
                flows=re.findall(r'aie.flow\([^\n]+',runtime),
                configure_templates=runtime.count('aiex.dma_configure_task_for'),
                start_templates=runtime.count('aiex.dma_start_task'),await_templates=runtime.count('aiex.dma_await_task'),
                free_templates=runtime.count('aiex.dma_free_task'),
                memtile_ops_present=bool(re.search(r'aie.memtile_dma|aie.memtile\b',runtime)),
                inference='textual template inventory; loop multiplicity/dynamic repeat counts not inferred')
            item['regions'].append(dict(index=region['index'],elf=identity(elf),files=files,facts=facts))
        packages.append(item)
    base=Path('/home/shiran/project/aie-toy/.venv/lib/python3.12/site-packages/mlir_aie/python/aie')
    tools=[Path('/home/shiran/project/aie-toy/.venv/bin')/x for x in ('aircc','air-opt','aie-opt','aie-translate')]
    trace=[base/'utils/trace'/x for x in ('setup.py','parse.py','config.py','event_ir.py')]
    trace += [base/'dialects/_aie_enum_gen.py']
    report=dict(schema='orbit.device-transfer.static-audit.v15',packages=packages,
        installed_files=[identity(p) for p in tools+trace if p.is_file()],observer=identity(__file__),
        device_opened=False,builds=0,claims=dict(dynamic_transfer_count=False,physical_bytes=False,device_duration=False,trace_capture=False),
        trace_capability='installed declarative configure_trace supports shim/core-memory events; integration/capture must be independently validated')
    (args.output/'inventory.json').write_text(json.dumps(report,indent=2)+'\n')
    shutil.copyfile(__file__,args.output/'audit-source.py')
    print(json.dumps(dict(status='audited',packages=len(packages),device_opened=False)))


if __name__=='__main__':main()
