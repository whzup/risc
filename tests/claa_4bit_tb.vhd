library ieee;
use ieee.std_logic_1164.all;

entity claa_4bit_tb is
end claa_4bit_tb;

architecture behavior of claa_4bit_tb is
    component claa_4bit is
        port
        (
        opai, opbi:   in std_logic_vector(3 downto 0);
        ci:           in std_logic;
        eo:           out std_logic_vector(3 downto 0);
        po,   go, co: out std_logic
        );
    end component;

    signal opa_tb, opb_tb, eo_tb:      std_logic_vector(3 downto 0);
    signal ci_tb, po_tb, go_tb, co_tb: std_logic;

begin
    dut : claa_4bit port map
    (
    opai => opa_tb,
    opbi => opb_tb,
    ci => ci_tb,
    eo => eo_tb,
    po => po_tb,
    go => go_tb,
    co => co_tb
    );

    stim_proc : process
    type pattern_type is record
        a, b:       std_logic_vector(3 downto 0);
        ci:         std_logic;
        eo:         std_logic_vector(3 downto 0);
        po, go, co: std_logic;
    end record;

    type pattern_array is array(natural range <>) of pattern_type;
    constant patterns : pattern_array :=
    (("0000", "0000", '0', "0000", '0', '0', '0'),
     ("0001", "0001", '1', "0011", '0', '0', '0'),
     ("0010", "0100", '0', "0110", '0', '0', '0'),
     ("0100", "1100", '0', "0000", '0', '1', '1'),
     ("1000", "0111", '0', "1111", '1', '0', '0'),
     ("1010", "0101", '1', "0000", '1', '0', '1'),
     ("1111", "1111", '0', "1110", '1', '1', '1'),
     ("1000", "1000", '0', "0000", '0', '1', '1'));

    begin
        for i in patterns'range loop
            opa_tb <= patterns(i).a;
            opb_tb <= patterns(i).b;
            ci_tb <= patterns(i).ci;

            wait for 5 ns;
            assert eo_tb = patterns(i).eo report "bad sum value" severity error;
            assert po_tb = patterns(i).po report "bad gen value" severity error;
            assert go_tb = patterns(i).go report "bad prop value" severity error;
            assert co_tb = patterns(i).co report "bad carry value" severity error;
        end loop;
        
        assert false report "CLAA testbench finished" severity note;
        wait;
    end process;
end;
