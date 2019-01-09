VHDL_VER    = 08
GHDL        = ghdl
WORK        = ./work
SOURCE      = ./src
TESTS       = ./tests
GHDLFLAGS	= --std=$(VHDL_VER) --workdir=$(WORK)

test: $(SOURCE)/alu/full_adder.o $(TESTS)/%.o $(SOURCE)/% $(TESTS)/%
	$(GHDL) -r $(GHDLFLAGS) $(TESTS)/% --vcd=%.vcd

%: %.o
	$(GHDL) -e $(GHDLFLAGS) $@

%.o: %.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
