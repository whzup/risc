from migen import *
from counter import Counter


dut = Counter()


def counter_tb():
    for cycle in range(20):
        if cycle % 2:
            yield dut.i_ce.eq(0)
        else:
            yield dut.i_ce.eq(1)
        print("Cycle: {} Count: {}".format(cycle, (yield dut.o_count)))
        yield


run_simulation(dut, counter_tb(), vcd_name="counter.vcd")
