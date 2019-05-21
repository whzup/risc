library ieee;
use ieee.std_logic_1164.all;

entity brent_kung_adder_tb is
end entity;

architecture behaviour of brent_kung_adder_tb is
  component brent_kung_adder is
    port
      (
        i_op1, i_op2  : in  std_logic_vector(15 downto 0);
        i_c           : in  std_logic;
        o_res         : out std_logic_vector(15 downto 0);
        o_flags       : out std_logic_vector(3 downto 0)
        );
  end component;

  signal opa_tb, opb_tb, eo_tb : std_logic_vector(15 downto 0);
  signal ci_tb                 : std_logic;
  signal flags_tb              : std_logic_vector(3 downto 0);
begin
  dut : brent_kung_adder port map
    (
      i_op1   => opa_tb,
      i_op2   => opb_tb,
      i_c     => ci_tb,
      o_res   => eo_tb,
      o_flags => flags_tb
      );

  stim_proc : process
    type pattern_type is record
      a, b  : std_logic_vector(15 downto 0);
      c     : std_logic;
      e     : std_logic_vector(15 downto 0);
      flags : std_logic_vector(3 downto 0);
    end record;

    type pattern_array is array(natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("0000000000000000", "0000000000000000", '0', "0000000000000000", "1000"),
       ("0000000000000001", "0000000000000001", '0', "0000000000000010", "0000"),
       ("0000000000000001", "0000000000000001", '1', "0000000000000011", "0000"),
       ("1111111111111100", "0000000000000011", '0', "1111111111111111", "0001"),
       ("1010101010101010", "0101010101010101", '1', "0000000000000000", "1010"),
       ("0001000010001011", "0100001000000100", '1', "0101001010010000", "0000"),
       ("0001000010001011", "0100001000000100", '0', "0101001010001111", "0000"),
       ("0000100110010000", "1100000000000011", '0', "1100100110010011", "0001"),
       ("0000000000001111", "0000000000001111", '0', "0000000000011110", "0000"),
       ("0000000011111111", "0000000011111111", '1', "0000000111111111", "0000"));

  begin
    for i in patterns'range loop
      opa_tb <= patterns(i).a;
      opb_tb <= patterns(i).b;
      ci_tb  <= patterns(i).c;

      wait for 5 ns;
      assert eo_tb = patterns(i).e report "bad sum value" severity error;
      assert flags_tb = patterns(i).flags report "bad flag value" severity error;
    end loop;

    assert false report "Brent-Kung Adder testbench finished" severity note;
    wait;
  end process;
end;
