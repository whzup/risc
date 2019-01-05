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
    in1 = Signal(16)
    in2 = Signal(16)
    in1 = 0x02
    in2 = 0x03

    yield dut.op1.eq(in1)
    yield dut.op2.eq(in2)
    yield


run_simulation(dut, stimulate(), vcd_name="cla_adder.vcd")
