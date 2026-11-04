#!/usr/bin/env python3
"""CPU command-flow test: three native predictions and native predictive search.

All compiler results below are declared synthetic responses. No compiler/runtime
is executed; the subprocess only runs the pure-CPU fitter contract fixture.
"""
import argparse
import copy
from pathlib import Path
import subprocess
import sys
from unittest.mock import patch
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'scripts'))
import taskflow_implementation_experiment_v10 as experiment
from taskflow_implementation_search_v10 import load,save,bound


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--output',type=Path,required=True)
    out=parser.parse_args().output.resolve();out.mkdir(parents=True,exist_ok=False)
    subprocess.run([sys.executable,str(Path(__file__).with_name('implementation_fit_v10.py')),'--output',str(out/'fixture')],check=True,capture_output=True,text=True)
    commands=[]
    def native_fixture(directory,name,command):
        command=list(map(str,command));commands.append(command)
        if '--generic-map' in command:
            source=Path(command[1]);plan=load(source.parent/'plan.json')
            config=load(Path(next(x.split('=',1)[1] for x in command if x.startswith('--target-config='))))
            legacy='theoretical' in config['generic_air'];plan['estimated_ms']=.5 if legacy else .4
            destination=Path(next(x.split('=',1)[1] for x in command if x.startswith('--mapping-output=')))
            save(destination,plan)
        else:
            assert '--search' in command and '--backend=air' in command
            (directory/'search').mkdir();save(directory/'search/search.json',dict(scope='synthetic native-search response, no actual selection'))
    with patch.object(experiment,'run',side_effect=native_fixture):
        predictions=experiment.predict(out/'fixture/frozen',out/'predictions')
        search=experiment.predictive_search(predictions,out/'search')
    rows=load(out/'predictions/predictions.json');assert len(rows)==1 and len(rows[0]['model_predictions_ms'])==3
    assert len(commands)==4 and all('--generic-map' in c for c in commands[:3]) and '--search' in commands[3]
    config=load(out/'predictions/predictive-search-config.json');assert config['native_auto_candidates']['exploration_slots']==4
    assert 'native_air_tile_candidates' not in config and 'native_implementation_candidates' not in config
    assert config['generic_air']['cost_model']['kind']=='implementation-composite'
    freeze=load(out/'fixture/frozen/freeze.json');elf=next(Path(row['path']) for row in freeze['compiled_artifacts'] if row['path'].endswith('program.elf'))
    original=elf.read_bytes();elf.write_bytes(original+b' changed')
    with patch.object(experiment,'run',side_effect=native_fixture):
        try:experiment.predictive_search(predictions,out/'changed-artifact-search')
        except ValueError:pass
        else:raise AssertionError('predictive search admitted changed frozen artifact')
    elf.write_bytes(original)
    assert len(commands)==4

    result=dict(status='passed',checks=['separate three native model prediction commands','legacy theoretical and stage-zero ablation frozen independently','native original automatic predictive search command','fixed unknown exploration slots without manual candidate lists','recursive frozen compiled-artifact mutation rejected before search'],actual_compilation=False,device_submissions=0,scope='synthetic command-flow responses only; no actual native search/model validation')
    save(out/'summary.json',result);print(result)


if __name__=='__main__':main()
