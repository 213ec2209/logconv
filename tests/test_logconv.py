import os
import random
from pathlib import Path
import cocotb
from cocotb import start_soon
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge, NextTimeStep, ReadOnly, RisingEdge, Timer
from cocotb_tools.runner import get_runner
@cocotb.test()
async def example_test(dut):
    pass
def test_logconv_runner():
    sim = os.getenv("SIM", "icarus")
    proj_path = Path(__file__).resolve().parent.parent
    sources = [proj_path / "sources/logconv.v",
               proj_path /"sources/bk_adder16bit.v" ,
                ]
    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="logconv",
        always=True,
    )
    runner.test(hdl_toplevel="logconv", test_module="test_logconv")
