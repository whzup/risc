from migen import *
from register import Register


dut = Register()


def reg_tb():
    yield dut.reg_i_en.eq(1)
    yield dut.reg_in.eq(0x01)
    yield
    yield dut.reg_i_en.eq(0)
    yield dut.reg_o_en.eq(1)
    yield
    yield
    assert (yield dut.reg_out) == 0x01

run_simulation(dut, reg_tb(), vcd_name="register.vcd")
