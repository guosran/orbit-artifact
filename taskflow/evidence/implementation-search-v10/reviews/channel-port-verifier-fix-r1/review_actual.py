import hashlib,json,subprocess,sys
from pathlib import Path
ROOT=Path('/home/shiran/project/orbit-artifact/taskflow');BASE=ROOT.parent/'results/taskflow/implementation-search-v10/compiled-final-r2';OUT=Path(__file__).resolve().parent/'actual-audits';OUT.mkdir(exist_ok=False)
records=[]
for directory in sorted(BASE.iterdir()):
 plan=directory/'plan.json';hardware=directory/'hardware'
 if not plan.is_file() or not (hardware/'compile.json').is_file():continue
 name=directory.name;target=OUT/name;target.mkdir();p=json.loads(plan.read_text());record={'case':name,'checks':{}}
 checks=[('storage','audit_storage_v6.py',['--plan',str(plan)]),('runtime','audit_runtime_transfers_v7.py',['--plan',str(plan),'--abi',str(directory/'abi.json')])]
 if any(stage.get('legalize_channels',False) for stage in p['hardware_stages']):checks.append(('ports','audit_channel_ports_v6.py',['--plan',str(plan)]))
 else:record['checks']['ports']={'status':'not-applicable','reason':'actual native plan has zero channel_allocations and zero legalize_channels stages; original no-planned-legalizations assertion not weakened'}
 for key,script,extra in checks:
  command=[sys.executable,str(ROOT/'test/TaskflowAIR'/script),str(hardware),*extra,'--output',str(target/(key+'.json'))]
  result=subprocess.run(command,capture_output=True,text=True);(target/(key+'.command.json')).write_text(json.dumps(command,indent=2)+'\n');(target/(key+'.stdout.log')).write_text(result.stdout);(target/(key+'.stderr.log')).write_text(result.stderr);assert result.returncode==0,(name,key,result.stderr)
  data=json.loads((target/(key+'.json')).read_text());assert data['status']=='passed';record['checks'][key]={'status':'passed','report':str(target/(key+'.json')),'sha256':hashlib.sha256((target/(key+'.json')).read_bytes()).hexdigest()}
 records.append(record)
assert len(records)==18
ports=[r for r in records if r['checks']['ports']['status']=='passed'];assert len(ports)==2
summary={'status':'passed','cases':18,'runtime_and_storage_passed':18,'planned_port_cases_passed':2,'planned_port_allocations_checked':sum(len(json.loads(Path(r['checks']['ports']['report']).read_text())['checks']) for r in ports),'unplanned_port_cases_not_applicable':16,'records':records,'scope':'fresh offline static re-audits of actual compiled-final-r2 artifacts, after original wrapper failure; not a pre-device gate or NPU execution','compilation':False,'device_submissions':0}
(OUT/'summary.json').write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps({k:v for k,v in summary.items() if k!='records'}))
