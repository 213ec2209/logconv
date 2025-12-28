import os
from pathlib import Path

import cocotb
from cocotb.triggers import Timer
from cocotb_tools.runner import get_runner
import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test_encryption_1(dut):
    """Test log conversion with fp16 value of 0x4000 (2)"""
    print("fp16tolog conversion")
    dut.fp16_in.value = 0x4000
    await Timer(5, unit="ns")  
   
    dut._log.info("fp16_in = %d,   log_out_q5_10= %x",
                  dut.fp16_in.value, dut.log_out_q5_10.value)
    assert dut.log_out_q5_10.value == 1024, "log conversion is not correct"  


@cocotb.test()
async def test_encryption_2(dut):
    """Test log conversion with fp16 value of 0x4200 (3)"""
    print("fp16tolog conversion")
    dut.fp16_in.value = 0x4200
    await Timer(5, unit="ns")  
   
    dut._log.info("fp16_in = %d,   log_out_q5_10= %x",
                  dut.fp16_in.value, dut.log_out_q5_10.value)
    assert dut.log_out_q5_10.value == 1536, "log conversion is not correct"

   

# CRITICAL: Pytest wrapper function
def test_logconv_runner():
    """Pytest wrapper to run cocotb tests"""
    sim = os.getenv("SIM", "icarus")
    proj_path = Path(__file__).resolve().parent
    
    sources = [
        proj_path / "logconv.v",
    ]
    
    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="logconv",
        always=True,
    )
    
    runner.test(
        hdl_toplevel="logconv",
        test_module="test_logconv_hidden"
    )
