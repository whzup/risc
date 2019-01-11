library ieee;
use ieee.std_logic_1164.all;

entity claa_16bit_tb is
end claa_16bit_tb;

architecture behavior of claa_16bit_tb is
    component claa_16bit is
        port
        (
        opai, opbi:   in std_logic_vector(15 downto 0);
        ci:           in std_logic;
        eo:           out std_logic_vector(15 downto 0);
        po,   go, co: out std_logic
        );
    end component;

    signal opa_tb, opb_tb, eo_tb:      std_logic_vector(15 downto 0);
    signal ci_tb, po_tb, go_tb, co_tb: std_logic;

begin
    dut : claa_16bit port map
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
        a, b:       std_logic_vector(15 downto 0);
        ci:         std_logic;
        eo:         std_logic_vector(15 downto 0);
        po, go, co: std_logic;
    end record;

    type pattern_array is array(natural range <>) of pattern_type;
    constant patterns : pattern_array :=
    (("0000000000000000", "0000000000000000", '0', "0000000000000000", '0', '0', '0'),
     ("0000000000000001", "0000000000000001", '0', "0000000000000010", '0', '0', '0'),
     ("0000000000000001", "0000000000000001", '1', "0000000000000011", '0', '0', '0'),
     ("1111111111111100", "0000000000000011", '0', "1111111111111111", '1', '0', '0'),
     ("1010101010101010", "0101010101010101", '1', "0000000000000000", '1', '0', '1'),
     ("0001000010001011", "0100001000000100", '1', "0101001010010000", '0', '0', '0'),
     ("0001000010001011", "0100001000000100", '0', "0101001010001111", '0', '0', '0'),
     ("0000100110010000", "1100000000000011", '0', "1100100110010011", '0', '0', '0'),
     ("0000000000001111", "0000000000001111", '0', "0000000000011110", '0', '0', '0'),
     ("0000000011111111", "0000000011111111", '1', "0000000111111111", '0', '0', '0'));

    begin
        for i in patterns'range loop
            opa_tb <= patterns(i).a;
            opb_tb <= patterns(i).b;
            ci_tb <= patterns(i).ci;

            wait for 5 ns;
            assert eo_tb = patterns(i).eo report "bad sum value" severity error;
            assert po_tb = patterns(i).po report "bad prop value" severity error;
            assert go_tb = patterns(i).go report "bad gen value" severity error;
            assert co_tb = patterns(i).co report "bad carry value" severity error;
        end loop;
        
        assert false report "CLAA testbench finished" severity note;
        wait;
    end process;
end;
