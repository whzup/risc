from migen import *
from edge_detector import EdgeDetector


dut = EdgeDetector()


def edge_detector_tb():
    yield dut.i_sig.eq(1)
    yield
    yield
    yield


run_simulation(dut, edge_detector_tb(), vcd_name="edge_detector.vcd")
