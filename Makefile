VHDL_VER    = 08
GHDL        = ghdl
WORK        = work
SOURCE      = src/*.vhd src/*/*.vhd
SIM			= sim
TESTS       = tests/${TESTBENCH}.vhd
GHDLFLAGS	= --std=$(VHDL_VER) --workdir=$(SIM) --work=$(WORK)

.PHONY: clean

all: compile

compile:
ifeq ($(strip $(TESTBENCH)),)
	@echo "TESTBENCH not set."
	@exit 2
endif

	$(GHDL) -i $(GHDLFLAGS) $(TESTS) $(SOURCE)
	$(GHDL) -m $(GHDLFLAGS) $(TESTBENCH)
	@mv $(TESTBENCH) sim/$(TESTBENCH)

clean:
	echo "Cleaning up ..."
	$(GHDL) --clean --workdir=$(SIM)
