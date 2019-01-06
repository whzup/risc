from migen import *
from pc import PC


dut = PC()


def pc_tb():
    for cycle in range(5):
        if cycle % 2:
            yield dut.i_ce.eq(0)
        else:
            yield dut.i_ce.eq(1)
        print("Cycle: {} Count: {}".format(cycle, (yield dut.o_count)))
    yield
    yield dut.i_je.eq(1)
    yield dut.i_j.eq(0xF7)
    yield


run_simulation(dut, pc_tb(), vcd_name="pc.vcd")
