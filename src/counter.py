from migen import Module, Signal, If


class Counter(Module):
    def __init__(self):
        self.i_ce = Signal()
        self.o_count = Signal(16)

        self.sync += If(self.ce, self.count.eq(self.count + 1))
