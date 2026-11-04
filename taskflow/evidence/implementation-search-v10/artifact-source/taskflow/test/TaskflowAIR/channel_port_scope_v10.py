#!/usr/bin/env python3
"""CPU textual-parser regression; declared fake IR is never compiled or run."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[2]
AUDITOR=ROOT/'test/TaskflowAIR/audit_channel_ports_v6.py'


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--output',type=Path,required=True)
    out=parser.parse_args().output.resolve();out.mkdir(parents=True,exist_ok=False)
    source='''module {
  aie.device(npu2) @orbit_segment {
    %tile = aie.tile(0, 2)
    %buf0 = aie.buffer(%tile) {sym_name = "buf0"} : memref<1xf32, 2 : i32>
    %mem = aie.mem(%tile) {
      %0 = aie.dma_start(S2MM, 1, ^bb0, ^bb1)
    ^bb0:
      aie.dma_bd(%buf0 : memref<1xf32, 2 : i32> offset = 0 len = 1)
      aie.next_bd ^bb0
    ^bb1:
      aie.end
    }
    %core = aie.core(%tile) {
      %view = memref.reinterpret_cast %buf0 to offset: [0], sizes: [1], strides: [1] {orbit.storage = "A"} : memref<1xf32, 2> to memref<1xf32, 2>
      // } fake device close; memref.reinterpret_cast %buf0 orbit.storage = "BAD"
      /* { outer /* } nested */ memref.reinterpret_cast %buf0 orbit.storage = "BAD" */
      "test.note"() {message = "brace } escaped \\" then { aie.device(npu2) @fake {"} : () -> ()
      aie.end
    }
  }
  func.func @host() {
    %host0 = memref.reinterpret_cast %results to offset: [0] {orbit.storage = "A"}
    %host1 = memref.reinterpret_cast %results to offset: [0] {orbit.storage = "Y"}
  }
}
'''
    plan=dict(capacity_bytes=24576,hardware_stages=[dict(begin_phase=0,allocated_bytes=4,legalize_channels=True)],channel_allocations=[dict(stage=0,storage='A',tile_direction='S2MM',tile_channel=1)])
    def run(name,text,configuration,success,error=None):
        directory=out/name;(directory/'hardware/air_project').mkdir(parents=True)
        (directory/'hardware/air_project/aie.input.air.mlir').write_text(text)
        (directory/'hardware/compile.json').write_text(json.dumps(dict(status='compiled')))
        (directory/'plan.json').write_text(json.dumps(configuration))
        command=[sys.executable,str(AUDITOR),str(directory/'hardware'),'--plan',str(directory/'plan.json'),'--output',str(directory/'audit.json')]
        result=subprocess.run(command,capture_output=True,text=True)
        (directory/'command.json').write_text(json.dumps(command,indent=2)+'\n');(directory/'stdout.log').write_text(result.stdout);(directory/'stderr.log').write_text(result.stderr)
        assert (result.returncode==0)==success,(name,result.stderr)
        if error:assert error in result.stderr,(name,result.stderr)
        return dict(name=name,returncode=result.returncode,expected='pass' if success else 'reject')
    checks=[run('host-trailing-ssa-and-quoted-comment-braces',source,plan,True)]
    conflict=source.replace('      aie.end\n    }\n  }','      %conflict = memref.reinterpret_cast %buf0 to offset: [0] {orbit.storage = "B"}\n      aie.end\n    }\n  }')
    checks.append(run('conflicting-real-buffer-inside-device',conflict,plan,False,'ambiguous buffer storage provenance'))
    bad=json.loads(json.dumps(plan));bad['channel_allocations'][0]['tile_channel']=0
    checks.append(run('wrong-port-still-rejected',source,bad,False,'emitted AIE port disagrees'))
    bad=json.loads(json.dumps(plan));bad['hardware_stages'][0]['allocated_bytes']=0
    checks.append(run('extra-payload-still-rejected',source,bad,False,'unplanned compute payload'))
    checks.append(run('missing-provenance-still-rejected',source.replace('orbit.storage = "A"','orbit.storage = "OTHER"',1),plan,False,'cannot correlate allocation'))
    result=dict(status='passed',checks=checks,auditor_sha256=hashlib.sha256(AUDITOR.read_bytes()).hexdigest(),compilation=False,device_submissions=0,scope='textual parser/checker fixtures only, not MLIR compiler or hardware validation')
    (out/'summary.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))


if __name__=='__main__':main()
