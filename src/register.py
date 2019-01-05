from migen import Module, Signal, If


class Register(Module):
    def __init__(self):
        self.reg_i_en = Signal()
        self.reg_in = Signal(16)
        self.reg_o_en = Signal()
        self.reg_out = Signal(16)

        ###
        self._reg = Signal(16)
        self.sync += If(self.reg_in == 1 and self.reg_out != 1,
                            self._reg.eq(self.reg_in)
                        ).Else(
                            self._reg.eq(self._reg)
                     )

        self.sync += If(self.reg_o_en == 1 and self.reg_i_en != 1,
                            self.reg_out.eq(self._reg)
                        )
