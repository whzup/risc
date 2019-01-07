from migen import *


class PC(Module):
    def __init__(self):
        '''
        Ports
        '''
        self.i_ce = Signal()
        self.i_je = Signal()
        self.i_j = Signal(16)
        self.o_count = Signal(16)

        ###

        '''
        Internal Signals
        '''
        self.sel = Signal()

        '''
        Logic
        '''
        self.comb += self.sel.eq(self.i_ce & self.i_je)
        self.sync += self.o_count.eq(Mux(self.sel, self.i_j, self.o_count + 1))
