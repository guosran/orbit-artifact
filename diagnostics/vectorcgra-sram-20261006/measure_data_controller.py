#!/usr/bin/env python3
"""Elaborate per-bank RTL from VectorCGRA's exact 4x4/2x2 test config."""
import importlib.machinery
import importlib.util
import json
import os
import platform
import sys
from pathlib import Path
from types import CodeType, FunctionType, ModuleType

import pymtl3
import pymtl3.stdlib.basic_rtl as basic_rtl_primitives

# The repository snapshot has the custom fork's RegisterFile bytecode but not
# its Python source. Load that exact primitive from the existing cgra_env
# snapshot; use the installed standard Mux only to satisfy the legacy import
# (the tested channel is combinational, so no queue or Mux is instantiated).
_primitive_root = Path(
    "/home/x/shiran/project/VectorCGRA/cgra_env/lib/python3.8/site-packages/"
    "pymtl3/stdlib/primitive"
)
_reference_source = Path(
    "/home/x/shiran/.local/lib/python3.8/site-packages/"
    "pymtl3/stdlib/basic_rtl/register_files.py"
)
_primitive_name = "pymtl3.stdlib.primitive"
_primitive_package = ModuleType(_primitive_name)
_primitive_package.__path__ = [str(_primitive_root)]
_primitive_package.__package__ = _primitive_name
sys.modules[_primitive_name] = _primitive_package

def _rehome_code(code):
    constants = tuple(
        _rehome_code(value) if isinstance(value, CodeType) else value
        for value in code.co_consts
    )
    return code.replace(co_filename=str(_reference_source), co_consts=constants)

_fullname = _primitive_name + ".register_files"
_pyc = _primitive_root / "__pycache__" / "register_files.cpython-38.pyc"
_loader = importlib.machinery.SourcelessFileLoader(_fullname, str(_pyc))
_spec = importlib.util.spec_from_loader(_fullname, _loader)
_register_files = importlib.util.module_from_spec(_spec)
sys.modules[_fullname] = _register_files
_loader.exec_module(_register_files)
for _value in vars(_register_files).values():
    if isinstance(_value, type):
        for _member in vars(_value).values():
            if isinstance(_member, FunctionType):
                _member.__code__ = _rehome_code(_member.__code__)
_primitive_package.RegisterFile = _register_files.RegisterFile
_primitive_package.Mux = basic_rtl_primitives.Mux

from pymtl3 import mk_bits
from VectorCGRA.lib.messages import mk_data, mk_mem_access_pkt
from VectorCGRA.mem.data.DataMemWrapperRTL import DataMemWrapperRTL

# Values copied from initialize_test_harness() and
# test_multi_CGRA_systolic_4x4_2x2() in multi_cgra/test/MeshMultiCgraRTL_test.py.
fabric_rows = 4
fabric_columns = 4
tile_rows = 2
tile_columns = 2
banks_per_cgra = 2
words_per_bank = 16
payload_bits = 32
num_cgras = fabric_rows * fabric_columns
num_tiles = tile_rows * tile_columns
num_rd_tiles = tile_rows + tile_columns - 1
global_data_words = banks_per_cgra * words_per_bank * num_cgras
DataType = mk_data(payload_bits, 1)

MemReadType = mk_mem_access_pkt(
    DataType, num_rd_tiles, banks_per_cgra + 1, global_data_words,
    num_cgras, num_tiles, num_rd_tiles
)
MemWriteType = mk_mem_access_pkt(
    DataType, num_rd_tiles, banks_per_cgra + 1, global_data_words,
    num_cgras, num_tiles, num_rd_tiles
)
MemResponseType = mk_mem_access_pkt(
    DataType, banks_per_cgra + 1, num_rd_tiles, global_data_words,
    num_cgras, num_tiles, num_rd_tiles
)

# DataMemControllerRTL creates one such wrapper per local bank. Elaborate each
# wrapper exactly as that controller does; this avoids elaborating the full
# 4x4 fabric, as required for this capacity measurement.
banks = [
    DataMemWrapperRTL(
        DataType, MemReadType, MemWriteType, MemResponseType,
        global_data_words, words_per_bank, True
    )
    for _ in range(banks_per_cgra)
]
for bank in banks:
    bank.elaborate()

bank_depths = [len(bank.memory.regs) for bank in banks]
assert len(bank_depths) == banks_per_cgra, bank_depths
assert bank_depths == [words_per_bank] * banks_per_cgra, bank_depths
payload_nbits = DataType.get_field_type("payload").nbits
stored_word_nbits = DataType.nbits
assert payload_nbits == payload_bits, payload_nbits
assert stored_word_nbits == 35, stored_word_nbits

result = {
    "execution_environment": {
        "python": platform.python_version(),
        "pymtl3_core_package": str(Path(pymtl3.__file__).resolve()),
        "cpu_affinity": sorted(os.sched_getaffinity(0)),
        "primitive_source": "existing cgra_env CPython 3.8 RegisterFile bytecode; installed basic_rtl Mux import alias only",
    },
    "experiment_geometry": {
        "fabric_rows": fabric_rows,
        "fabric_columns": fabric_columns,
        "tile_rows_per_cgra": tile_rows,
        "tile_columns_per_cgra": tile_columns,
    },
    "elaborated_component": "VectorCGRA.mem.data.DataMemWrapperRTL (one per configured bank)",
    "fabric_cgra_count": num_cgras,
    "banks_per_cgra": len(banks),
    "measured_words_per_bank": bank_depths,
    "global_data_addressable_words": global_data_words,
    "payload_bits_per_data_word": payload_nbits,
    "rtl_registerfile_bits_per_data_word_including_sidebands": stored_word_nbits,
    "payload_capacity_bits_per_cgra": banks_per_cgra * words_per_bank * payload_nbits,
    "payload_capacity_bytes_per_cgra": banks_per_cgra * words_per_bank * payload_nbits // 8,
    "rtl_registerfile_state_bits_per_cgra_including_sidebands": banks_per_cgra * words_per_bank * stored_word_nbits,
    "rtl_registerfile_state_bytes_per_cgra_including_sidebands": banks_per_cgra * words_per_bank * stored_word_nbits // 8,
    "payload_capacity_bytes_across_fabric": num_cgras * banks_per_cgra * words_per_bank * payload_nbits // 8,
    "rtl_registerfile_state_bytes_across_fabric_including_sidebands": num_cgras * banks_per_cgra * words_per_bank * stored_word_nbits // 8,
    "test_helper_ctrl_mem_items": 16,
    "test_helper_registers_per_tile": 16,
}

out = Path(__file__).with_name("data_controller_measurement.json")
out.write_text(json.dumps(result, indent=2) + "\n")
print(json.dumps(result, indent=2))
