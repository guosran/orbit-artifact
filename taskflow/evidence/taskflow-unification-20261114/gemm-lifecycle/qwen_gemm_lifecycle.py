#!/usr/bin/env python3
"""Ownership/lifecycle contracts with a CPU runner; never opens an accelerator."""
import hashlib
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
import numpy as np
from ml_dtypes import bfloat16

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('gemm_variants', ROOT/'experimental/qwen-runtime-search/npu-gemm-variants.py')
gemm = importlib.util.module_from_spec(spec)
spec.loader.exec_module(gemm)

class FakeRunner:
    created = []
    def __init__(self, *unused):
        self.cache = {}
        self.uploads = self.calls = self.unloads = 0
        self.fail = False
        self.created.append(self)
    def run(self, inputs, *, bo_key, static_indices, **unused):
        self.calls += 1
        if self.fail:
            raise RuntimeError('injected dispatch failure')
        if bo_key not in self.cache:
            self.cache[bo_key] = {i: inputs[i].copy() for i in static_indices}
            self.uploads += len(static_indices)
        return {i+1: inputs[0].astype(np.float32) @ b.astype(np.float32)
                for i,b in self.cache[bo_key].items()}
    def unload(self):
        self.unloads += 1
        self.cache.clear()

class Lifecycle(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.path = Path(self.directory.name)
        for name in ('source.mlir','kernel.elf'):
            (self.path/name).write_text('test-only, no NPU binary')
        record = dict(source_air=gemm.identity(self.path/'source.mlir'),
            compiled_binary=gemm.identity(self.path/'kernel.elf'), kernel_name='test',
            shape=dict(M=2,N=6,K=4), padded_shape=dict(M=2,N=2,K=4,A_stride=4),
            resource=dict(task_instance_replicas=3))
        (self.path/'implementation.json').write_text(json.dumps(record))
        self.x = np.arange(8,dtype=np.float32).reshape(2,4).astype(bfloat16)
        self.w = np.arange(24,dtype=np.float32).reshape(4,6).astype(bfloat16)
        self.expected = self.x.astype(np.float32) @ self.w.astype(np.float32)
        FakeRunner.created.clear()
    def runtime(self, policy='persistent', **kw):
        return gemm.CompiledGemm(self.path,context_policy=policy,
            max_host_bytes=kw.get('host',4096),max_device_bytes=kw.get('device',4096),
            _runner_factory=FakeRunner)
    def test_persistent_lease_and_static_upload(self):
        with self.runtime() as runtime:
            lease=runtime.bind_weight(self.w,'L0')
            np.testing.assert_array_equal(runtime.run_bound(self.x,lease),self.expected)
            np.testing.assert_array_equal(runtime.run_bound(self.x,lease),self.expected)
            runner=FakeRunner.created[0]
            self.assertEqual((len(FakeRunner.created),runner.calls,runner.uploads),(1,2,3))
            self.assertFalse(runtime.events[-1]['first_dispatch'])
            self.assertGreater(runtime.events[-1]['live_operand_bo_bytes'],0)
            self.assertFalse(runtime.events[-1]['sram_residency_claim'])
        self.assertEqual(runner.unloads,1)
        self.assertEqual((runtime.host_bytes,runtime.device_bytes,len(runtime.weights)),(0,0,0))
        with self.assertRaises(ValueError): runtime.run_bound(self.x,lease)
    def test_owned_snapshot_survives_source_mutation(self):
        with self.runtime() as runtime:
            lease=runtime.bind_weight(self.w,'L0')
            self.w.fill(0)
            np.testing.assert_array_equal(runtime.run_bound(self.x,lease),self.expected)
            with self.assertRaises(ValueError): runtime.bind_weight(self.w,'L0')
    def test_foreign_lease(self):
        with self.runtime() as left, self.runtime() as right:
            lease=left.bind_weight(self.w,'L0')
            with self.assertRaises(ValueError): right.run_bound(self.x,lease)
            self.assertFalse(FakeRunner.created)
    def test_capacity_checked_before_device_open(self):
        for kwargs in ({'host':100},{'device':100}):
            with self.runtime(**kwargs) as runtime:
                with self.assertRaises(MemoryError): runtime.bind_weight(self.w,'L0')
                self.assertEqual((runtime.host_bytes,runtime.device_bytes),(0,0))
        self.assertFalse(FakeRunner.created)
    def test_explicit_capacity_and_lease_required(self):
        with self.assertRaises(ValueError): gemm.CompiledGemm(self.path,context_policy='persistent')
        with self.runtime() as runtime:
            with self.assertRaises(ValueError): runtime.run(self.x,self.w,'L0')
    def test_release_after_call_measures_binding_and_cleanup(self):
        runtime=self.runtime('release-after-call')
        for _ in range(2):
            np.testing.assert_array_equal(runtime.run(self.x,self.w,'L0'),self.expected)
            event=runtime.events[-1]
            self.assertEqual(event['wall_ns'],sum(event[k] for k in (
                'device_open_ns','host_prepare_ns','native_inclusive_service_ns',
                'host_assemble_ns','release_ns')))
            self.assertGreater(event['weight_binding_and_wrapper_ns'],0)
            self.assertEqual(event['live_operand_bo_bytes'],0)
        self.assertEqual(len(FakeRunner.created),2)
        self.assertTrue(all(r.unloads==1 for r in FakeRunner.created))
    def test_dispatch_error_cleans_all_ownership(self):
        runtime=self.runtime()
        lease=runtime.bind_weight(self.w,'L0')
        runtime.run_bound(self.x,lease)
        FakeRunner.created[0].fail=True
        with self.assertRaisesRegex(RuntimeError,'injected'): runtime.run_bound(self.x,lease)
        self.assertEqual((runtime.host_bytes,runtime.device_bytes,len(runtime.weights)),(0,0,0))
        self.assertIsNone(runtime.runner)
    def test_invalid_dtype_opens_no_device(self):
        runtime=self.runtime('release-after-call')
        with self.assertRaises(ValueError): runtime.run(self.x.astype(np.float32),self.w,'L0')
        self.assertFalse(FakeRunner.created)
        self.assertEqual(runtime.host_bytes,0)
    def test_source_domain_has_no_replica_two_whitelist(self):
        target=dict(columns=3,rows=2,minimum_l1=8,minimum_block_m=16,
                    max_l1_output_elements=256,pack=[8,8,8],minimum_block_k=16,
                    weight_dma_max_words=2**20)
        params=list(gemm.gemm_parameter_domain(5,96,64,target))
        self.assertGreater(len(params),18)
        self.assertTrue(any(p['replicas']==3 for p in params))
        self.assertTrue(any(p['l1k']!=p['l2k'] for p in params))
        self.assertTrue(any(p['row_offset']==3 for p in params))
        for p in params:
            self.assertLessEqual(p['column_offset']+p['replicas']*p['bm']//p['l1m'],3)
            self.assertLessEqual(p['row_offset']+p['bn']//p['l1n'],4)

if __name__ == '__main__': unittest.main()
