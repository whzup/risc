library ieee;
use ieee.std_logic_1164.all;

entity lu_tb is
end lu_tb;

architecture behaviour of lu_tb is
  component lu is
    port
      (
        i_op1   : in  std_logic_vector(15 downto 0);
        i_op2   : in  std_logic_vector(15 downto 0);
        i_and   : in  std_logic;
        i_or    : in  std_logic;
        i_xor   : in  std_logic;
        i_not   : in  std_logic;
        o_res   : out std_logic_vector(15 downto 0);
        o_flags : out std_logic_vector(3 downto 0)
        );
  end component;

  signal op1_tb, op2_tb, res_tb        : std_logic_vector(15 downto 0);
  signal s_tb, flags_tb                : std_logic_vector(3 downto 0);
  signal and_tb, or_tb, xor_tb, not_tb : std_logic;

begin
  dut : lu port map
    (
      i_op1 => op1_tb,
      i_op2 => op2_tb,
      i_and => and_tb,
      i_or  => or_tb,
      i_xor => xor_tb,
      i_not => not_tb,
      o_res => res_tb,
      o_flags => flags_tb
      );

  stim_proc : process
    type pattern_type is record
      op1   : std_logic_vector(15 downto 0);
      op2   : std_logic_vector(15 downto 0);
      und   : std_logic;
      oder  : std_logic;
      xoder : std_logic;
      nicht : std_logic;
      res   : std_logic_vector(15 downto 0);
      flags : std_logic_vector(3 downto 0);
    end record;

    type pattern_array is array(natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      -- AND
      (("0111001010010001", "0111100111100101", '1', '0', '0', '0', "0111000010000001", "0000"),
       ("1001001010100001", "1000010001010101", '1', '0', '0', '0', "1000000000000001", "0001"),
       ("0000000000000000", "0000000000000000", '1', '0', '0', '0', "0000000000000000", "1000"),
       ("1111111111111111", "1111111111111111", '1', '0', '0', '0', "1111111111111111", "0001"),
            
       ("1001001010100001", "1000010001010101", '0', '1', '0', '0', "1001011011110101", "0001"),
       ("1111111111111111", "0000000000000000", '0', '1', '0', '0', "1111111111111111", "0001"),
       ("0000000000000000", "0000000000000000", '0', '1', '0', '0', "0000000000000000", "1000"),
       ("1111111111111111", "1111111111111111", '0', '1', '0', '0', "1111111111111111", "0001"),
             
       ("0100100110011101", "0111001010110101", '0', '0', '1', '0', "0011101100101000", "0000"),
       ("1111111111111111", "0000000000000000", '0', '0', '1', '0', "1111111111111111", "0001"),
       ("0000000000000000", "0000000000000000", '0', '0', '1', '0', "0000000000000000", "1000"),
       ("1111111111111111", "1111111111111111", '0', '0', '1', '0', "0000000000000000", "1000"),
             
       ("0000000000000000", "0000000000000000", '0', '0', '0', '1', "1111111111111111", "0001"),
       ("1111111111111111", "0000000000000000", '0', '0', '0', '1', "0000000000000000", "1000"),
       ("0100100101000101", "0100110110000001", '0', '0', '0', '1', "1011011010111010", "0001"));

  begin
    for i in patterns'range loop
      op1_tb <= patterns(i).op1;
      op2_tb <= patterns(i).op2;
      and_tb <= patterns(i).und;
      or_tb  <= patterns(i).oder;
      xor_tb <= patterns(i).xoder;
      not_tb <= patterns(i).nicht;
      wait for 1 ns;
      assert res_tb = patterns(i).res report "bad result" severity error;
      assert flags_tb = patterns(i).flags report "bad flag value" severity error;
    end loop;

    assert false report "Logic unit testbench finished" severity note;
    wait;
  end process;
end architecture;

