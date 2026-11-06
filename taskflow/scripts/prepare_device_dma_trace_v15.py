#!/usr/bin/env python3
"""Prepare paired measurement-only shim trace derivatives; no build or device.

The off control adds the same separate unused trace ABI argument. Both controls
require identical A/C/Trace BO extents; original production source is preserved. This script instruments an existing copy module, not a plan.
"""
import argparse
import hashlib
import json
from pathlib import Path
import shutil


def identity(p):
    return dict(path=str(Path(p).resolve()),sha256=hashlib.sha256(Path(p).read_bytes()).hexdigest())


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--aie',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--trace-bytes',type=int,default=16384)
    parser.add_argument('--peano',type=Path,required=True)
    parser.add_argument('--aiecc',type=Path,default=Path('/home/shiran/project/aie-toy/.venv/bin/aiecc'))
    args=parser.parse_args()
    if args.trace_bytes<=0 or args.trace_bytes%64:parser.error('positive 64-byte-aligned trace capacity required')
    if not args.peano.is_dir() or not args.aiecc.is_file():parser.error('existing toolchain required')
    from aie.ir import Context,Module,InsertionPoint,MemRefType,Location,IntegerType
    from aie.dialects import aie,aiex
    from aie.utils.trace import setup
    from aie.utils.trace.events import ShimTileEvent
    source=args.aie.read_bytes()
    with Context() as ctx, Location.unknown():
        ctx.allow_unregistered_dialects=True
        module=Module.parse(source.decode())
        off=Module.parse(source.decode())
        trace_type=MemRefType.get([args.trace_bytes],IntegerType.get_signless(8))
        def walk(operation):
            yield operation
            for region in operation.regions:
                for block in region.blocks:
                    for child in block.operations:yield from walk(child)
        for device in off.body.operations:
            for sequence in list(device.regions[0].blocks[0].operations):
                if sequence.name!='aie.runtime_sequence':continue
                sb=sequence.regions[0].blocks[0]
                if len(sb.arguments)!=2:raise ValueError('off control requires original two-argument sequences')
                trace_arg=sb.add_argument(trace_type,Location.unknown())
                for child in list(walk(sequence)):
                    if child.name=='aiex.run':
                        with InsertionPoint(child):aiex.RunOp(child.runtime_sequence_symbol,list(child.operands)+[trace_arg])
                        child.operation.erase()
        if not off.operation.verify():raise ValueError('paired off trace ABI failed verification')
        off_text=str(off)
        selected=[]
        for device in module.body.operations:
            if device.name!='aie.device':raise ValueError('expected complete final AIE module')
            block=device.regions[0].blocks[0]
            sequences=[op for op in block.operations if op.name=='aie.runtime_sequence' and
                       any(v.name=='aiex.dma_configure_task_for' for v in op.regions[0].blocks[0].operations)]
            if not sequences:continue
            if len(sequences)!=1:raise ValueError('one DMA sequence per data device required')
            sequence=sequences[0];sb=sequence.regions[0].blocks[0]
            configs=[op for op in sb.operations if op.name=='aiex.dma_configure_task_for']
            allocations=[op for op in block.operations if op.name=='aie.shim_dma_allocation']
            if len(allocations)!=2 or sorted((int(op.channel_dir),int(op.channel_index)) for op in allocations)!=[(0,0),(1,0)]:raise ValueError('first smoke requires exactly data S2MM0/MM2S0 shim allocations')
            if any(op.name=='aie.trace' for op in block.operations):raise ValueError('source already contains trace instrumentation')
            shims=[op for op in block.operations if op.name=='aie.tile' and op.is_shim_tile()]
            if len(configs)!=2 or len(sb.arguments)!=2 or len(shims)!=1:raise ValueError('requires existing one-input/one-output copy ABI and one shim')
            if int(shims[0].col)!=0:raise ValueError('first smoke requires shim column0')
            output_type=MemRefType(sb.arguments[1].type)
            if str(output_type.element_type)!='f32' or any(d<=0 for d in output_type.shape):raise ValueError('static f32 output required')
            elements=1
            for d in output_type.shape:elements*=d
            logical_bytes=elements*4
            with InsertionPoint(block.operations[-1]):
                setup.configure_trace([shims[0]],shimtile_events=[
                    ShimTileEvent.DMA_MM2S_0_START_TASK,ShimTileEvent.DMA_MM2S_0_FINISHED_TASK,
                    ShimTileEvent.DMA_S2MM_0_START_TASK,ShimTileEvent.DMA_S2MM_0_FINISHED_TASK])
            with InsertionPoint.at_block_begin(sb):
                setup.start_trace(trace_size=args.trace_bytes,reuse_output_buffer=False)
            selected.append(dict(logical_output_bytes=logical_bytes,trace_offset_bytes=0,
                output_bo_bytes_both_controls=logical_bytes,trace_bo_bytes_both_controls=args.trace_bytes,trace_argument=2,
                data_output_argument=1,events=['DMA_MM2S_0_START_TASK','DMA_MM2S_0_FINISHED_TASK','DMA_S2MM_0_START_TASK','DMA_S2MM_0_FINISHED_TASK']))
        if len(selected)!=1:raise ValueError('exactly one data device supported')
        if not module.operation.verify():raise ValueError('instrumented module failed verification')
        text=str(module)
    args.output=args.output.resolve();args.output.mkdir(parents=True,exist_ok=False)
    (args.output/'off.mlir').write_text(off_text+'\n');(args.output/'on.mlir').write_text(text+'\n')
    shutil.copyfile(__file__,args.output/'observer-source.py')
    commands={}
    for mode in ('off','on'):
        commands[mode]=[str(args.aiecc.resolve()),'--peano='+str(args.peano.resolve()),'-O','3',
            '--get-full-elf','--expand-load-pdis','--full-elf-name='+str(args.output/(mode+'.elf')),
            '--get-input-with-addresses','--get=npu_seq_{0}.mlir',
            '--tmpdir='+str(args.output/(mode+'.prj')),str(args.output/(mode+'.mlir'))]
    record=dict(schema='orbit.device-transfer.trace-derivative.v15',source=identity(args.aie),
        observer=identity(__file__),trace_setup=identity(setup.__file__),aiecc=identity(args.aiecc),
        derivatives={m:identity(args.output/(m+'.mlir')) for m in ('off','on')},
        buffers=selected,compile_commands=commands,device_opened=False,builds=0,
        claims=dict(trace_complete=False,device_duration=False,physical_bytes=False),
        requirements=['run compile commands in separate cwd per control to preserve all products',
          'same three A/C/Trace BO extents in both controls; separate trace argument2 is unused by off',
          'audit data channels0 and trace egressS2MM1/BD15 distinct after standard routing',
          'complete main wrapper only; no isolated subkernel launch',
          'trace start before data tasks; stop after output await; missing final packets remain unknown',
          'cycles remain cycles; no unverified ns conversion'])
    (args.output/'instrumentation.json').write_text(json.dumps(record,indent=2)+'\n')
    print(json.dumps(dict(status='prepared',output=str(args.output),device_opened=False,builds=0)))


if __name__=='__main__':main()
