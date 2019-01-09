from migen import Module, Signal, Cat


class CLAAdder(Module):
    def __init__(self):
        self.op1 = Signal(16)
        self.op2 = Signal(16)
        self.eo = Signal(16)
        self.co = Signal()

        ###

        self.gen_vec = Signal(17)
        self.prop_vec = Signal(17)
        self.carry_vec = Signal(17)
        self.eo_vec = Signal(17)

        self.comb += [
            self.gen_vec.eq(self.op1 & self.op2),
            self.prop_vec.eq(self.op1 | self.op2),
        ]

        for h in range(2, 17, 2):
            for i in range(h, 17, h):
                self.comb += [
                    self.gen_vec[i].eq(
                        self.gen_vec[i]
                        | (self.gen_vec[int(i - h / 2)] & self.gen_vec[i])
                    ),
                    self.prop_vec[i].eq(
                        self.prop_vec[i] & self.prop_vec[int(i - h / 2)]
                    ),
                ]

        for h in reversed([2 ** x for x in range(0, 4)]):
            for i in range(h, 17, 2 * h):
                self.comb += self.carry_vec[i].eq(
                    self.gen_vec[i] | self.carry_vec[i - h] & self.prop_vec[i]
                )

        self.comb += self.eo.eq(
            Cat(
                (self.op1 ^ self.op2 ^ self.carry_vec),
                self.carry_vec[16],
            )
        )
