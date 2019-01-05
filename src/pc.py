from migen import *
from counter import Counter


class PC(Module):
    def __init__(self):
        '''
        Ports
        '''
        self.i_ce = Signal()
        self.i_je = Signal()
        self.i_j = Signal(16)
        self.o_count = Signal(16)

        '''
        Internal Signals
        '''
        self.count = Signal(16)
        self.sel = Signal()

        '''
        Instances
        '''
        counter = Instance("Counter",
                           i_master_clk=ClockSignal(),
                           i_master_rst=ResetSignal(),
                           i_i_ce = self.ce,
                           o_o_count = self.count
                           )

        self.special += counter, reg
        
        '''
        Logic
        '''
        self.comb += self.sel.eq(self.ce & self.je)
        self.sync += self.o_count.eq(Mux(self.sel, self.j, self.count))
