# A RISC design

This is a digital design for a 16-bit RISC in VHDL. It will have a custom
instruction set architecture (ISA) and is mainly meant as an educational side
project.
For the simulation the open-source simulator
[GHDL](https://github.com/ghdl/ghdl) is used.

# Roadmap

Here is a quick outline on what the planned milestones for this project are:

+ An ALU with some advanced circuitry (e.g. carry-lookahead adder (CLAA),
  Wallace/Dadda tree multiplier).
+ A CPU with a control unit and 8 registers.
+ Additional memory, I/O and a stack so that it can be
  programmed.
+ Advanced features, i.e. simple pipelining and maybe even a floating point
  unit (FPU) or a memory management unit (MMU)
+ Assembler for the assembly so it could be programmed by a host
