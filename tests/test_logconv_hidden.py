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

