library ieee;
use ieee.std_logic_1164.all;

entity shifter_tb is
end shifter_tb;

architecture behaviour of shifter_tb is
    component shifter is
        port
        (
        i_op:   in std_logic_vector(15 downto 0);
        i_s:    in std_logic_vector(3 downto 0);
        i_ctrl: in std_logic; -- 1 right shift 0 left shift
        o_r:    out std_logic_vector(15 downto 0);
        o_c:    out std_logic
        );
    end component;

    signal op_tb, r_tb:   std_logic_vector(15 downto 0);
    signal s_tb:          std_logic_vector(3 downto 0);
    signal ctrl_tb, c_tb: std_logic;

begin
    dut : shifter port map
    (
    i_op => op_tb,
    i_s => s_tb,
    i_ctrl => ctrl_tb,
    o_r => r_tb,
    o_c => c_tb
    );

    stim_proc : process
    type pattern_type is record
        op : std_logic_vector(15 downto 0);
        s : std_logic_vector(3 downto 0);
        ctrl : std_logic;
        r : std_logic_vector(15 downto 0);
        c :std_logic;
    end record;

    type pattern_array is array(natural range <>) of pattern_type;
    constant patterns : pattern_array :=
    (("0000000000000001", "0001", '0', "0000000000000010", '0'),
     ("0000000000000001", "1111", '0', "1000000000000000", '0'),
     ("0000000000000001", "0001", '1', "0000000000000000", '1'),
     ("0101010101010101", "0001", '0', "1010101010101010", '0'),
     ("0000000000000001", "0011", '0', "0000000000001000", '0'),
     ("0000000000000001", "0101", '1', "0000000000000000", '1'),
     ("0000000010000000", "0011", '1', "0000000000010000", '0'));

    begin
        for i in patterns'range loop
            op_tb <= patterns(i).op;
            s_tb <= patterns(i).s;
            ctrl_tb <= patterns(i).ctrl;
             wait for 1 ns;
             assert r_tb = patterns(i).r report "bad result" severity error;
             assert c_tb = patterns(i).c report "bad carry value" severity error;
         end loop;

         assert false report "Shifter testbench finished" severity note;
         wait;
     end process;
end architecture;

