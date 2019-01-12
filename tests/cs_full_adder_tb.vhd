library ieee;
use ieee.std_logic_1164.all;

entity cs_full_adder_tb is
end cs_full_adder_tb;

architecture behaviour of cs_full_adder_tb is
    component cs_full_adder is
        port
        (
        i_opx: in  std_logic;
        i_opy: in  std_logic;
        i_opz: in  std_logic;
        o_e:   out std_logic;
        o_c:   out std_logic
        );
    end component;

    signal opx_tb, opy_tb, opz_tb, e_tb, c_tb: std_logic;

begin
    dut : cs_full_adder port map
    (
    i_opx => opx_tb,
    i_opy => opy_tb,
    i_opz => opz_tb,
    o_e   => e_tb,
    o_c   => c_tb
    );

    stim_proc : process
    type pattern_type is record
        x, y, z : std_logic;
        e, c : std_logic;
    end record;

    type pattern_array is array(natural range <>) of pattern_type;
    constant patterns : pattern_array :=
        (('0', '0', '0', '0', '0'),
         ('0', '1', '0', '1', '0'),
         ('1', '0', '0', '1', '0'),
         ('1', '1', '0', '0', '1'),
         ('0', '0', '1', '1', '0'),
         ('0', '1', '1', '0', '1'),
         ('1', '0', '1', '0', '1'),
         ('1', '1', '1', '1', '1'));

    begin
        for i in patterns'range loop
            opx_tb <= patterns(i).x;
            opy_tb <= patterns(i).y;
            opz_tb <= patterns(i).z;

            wait for 1 ns;
            assert e_tb = patterns(i).e report "bad sum value" severity error;
            assert c_tb = patterns(i).c report "bad carry value" severity error;
        end loop;

        assert false report "CS full adder testbench finished" severity note;
        wait;
    end process;
end architecture;
