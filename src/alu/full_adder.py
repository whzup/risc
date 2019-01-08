from migen import *


class FullAdder(Module):
    def __init__(self):
        self.i_op1 = Signal()
        self.i_op2 = Signal()
        self.i_c = Signal()
        self.o_s = Signal()
        self.o_p = Signal()
        self.o_q = Signal()

        ###

        self.comb += [
                self.o_s.eq(self.i_op1 ^ self.i_op2 ^ self.i_c),
                self.o_p.eq(self.i_op1 | self.i_op2),
                self.o_q.eq(self.i_op1 & self.i_op2)
                ]
