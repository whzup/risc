from migen import *


class EdgeDetector(Module):
    def __init__(self):
        self.i_sig = Signal()
        self.o_sig = Signal()

        ###

        self.prev = Signal()
        self.sync += [
                self.o_sig.eq(self.i_sig ^ self.prev),
                self.prev.eq(self.i_sig)
                ]
