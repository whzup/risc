from migen import *
from cla_adder import CLAAdder


# def check_case(dut, op1, op2, eo, co):
#     yield dut.op1.eq(op1)
#     yield dut.op2.eq(op2)
#     # Wait 20 cycles
#     for cycle in range(20):
#         yield
#     assert (yield dut.eo) == eo
#     assert (yield dut.co) == co


dut = CLAAdder()


def stimulate():
    yield dut.op1.eq(0x01)
    yield dut.op2.eq(0x01)
    yield
    yield
    yield dut.op1.eq(0x03)
    yield dut.op2.eq(0x05)
    yield
    yield
    yield dut.op1.eq(0x08)
    yield dut.op2.eq(0x10)
    yield
    yield


run_simulation(dut, stimulate(), vcd_name="cla_adder.vcd")
