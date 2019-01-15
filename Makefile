# -------------
# Usage: 
# The command `make TESTBENCH=entity` will create
# a .vcd file for the declared `entity` in the 
# `sim` folder.
# -------------


# GHDL
VHDL_VER    = 08
GHDL        = ghdl
GHDLFLAGS	= --std=$(VHDL_VER) --workdir=$(WORK)

# Directories
WORK        = work
SOURCE      = src
TEST		= tests
SIM			= sim

# Targets
FILES		= $(wildcard $(SOURCE)/*.vhd) $(wildcard $(SOURCE)/*/*.vhd)
TBS			:= $(wildcard $(TEST)/*.vhd)

.PHONY: clean

all: analyse_files analyse_tbs compile

analyse_files: $(FILES)
	$(GHDL) -a $(GHDLFLAGS) $(FILES)

analyse_tbs: $(TBS)
	$(GHDL) -a $(GHDLFLAGS) $(TBS)

clean:
	echo "Cleaning up ..."
	$(GHDL) --clean --workdir=$(SIM)

compile:
ifeq ($(strip $(TESTBENCH)),)
	@echo "TESTBENCH not set."
	@exit 2
endif
	$(GHDL) -i $(GHDLFLAGS) $(TESTS) $(FILES)
	$(GHDL) -m $(GHDLFLAGS) -g $(TESTBENCH)_tb
	$(GHDL) -r $(GHDLFLAGS) $(TESTBENCH)_tb --vcd=sim/$(TESTBENCH)_tb.vcd
