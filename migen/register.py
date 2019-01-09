from migen import Module, Signal, If


# TODO: Add tristate buffer
class Register(Module):
    def __init__(self):
        self.i_reg = Signal(16)
        self.i_reg_ie = Signal()
        self.i_reg_oe = Signal()
        self.o_reg = Signal(16)

        ###
        self._reg = Signal(16)
        self.sync += If(self.i_reg == 1 and self.o_reg != 1,
                            self._reg.eq(self.i_reg)
                        ).Else(
                            self._reg.eq(self._reg)
                     )

        self.sync += If(self.i_reg_oe == 1 and self.i_reg_ie != 1,
                            self.o_reg.eq(self._reg)
                        )
