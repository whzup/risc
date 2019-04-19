library ieee;
use ieee.std_logic_1164.all;

entity alu_tb is
end alu_tb;

architecture behaviour of alu_tb is
    component alu is
    port
     (
      i_op1   : in  std_logic_vector(15 downto 0);
      i_op2   : in  std_logic_vector(15 downto 0);
      i_opc   : in  std_logic_vector(4 downto 0);
      i_clk   : in  std_logic;
      o_res   : out std_logic_vector(15 downto 0);
      o_flags : out std_logic_vector(3 downto 0) -- Z F C N
      );
  end component;

  signal op1_tb, op2_tb, res_tb : std_logic_vector(15 downto 0);
  signal opc_tb : std_logic_vector(4 downto 0);
  signal flags_tb : std_logic_vector(3 downto 0);
  signal clk_tb : std_logic := '0';

  procedure clk_gen(signal clk : out std_logic; constant FREQ : real) is
    constant PERIOD    : time := 1 sec / 500000;
    constant HIGH_TIME : time := PERIOD / 2;
    constant LOW_TIME  : time := PERIOD - HIGH_TIME;
  begin
      assert (HIGH_TIME /= 0 fs) report "clk_plain: High time is zero;" severity failure;
      loop
          clk <= '1';
          wait for HIGH_TIME;
          clk <= '0';
          wait for LOW_TIME;
      end loop;
  end procedure;

begin
   dut : alu port map
     (
      i_op1   => op1_tb,
      i_op2   => op2_tb,
      i_opc   => opc_tb,
      i_clk   => clk_tb,
      o_res   => res_tb,
      o_flags => flags_tb
      );

  stim_proc : process
    type pattern_type is record
      op1  : std_logic_vector(15 downto 0);
      op2  : std_logic_vector(15 downto 0);
      opc  : std_logic_vector(4 downto 0);
      res  : std_logic_vector(15 downto 0);
      flags  : std_logic_vector(3 downto 0);
    end record;

    type pattern_array is array(natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      -- left shift
    (("0000000000000000", "0000000000000000", "10000", "0000000000000000", "0001"),
     ("0000000000000000", "0000000000000000", "10000", "0000000000000000", "0001"));

  begin
    for i in patterns'range loop
      clk_gen(clk_tb, 5.0E8);
      op1_tb   <= patterns(i).op1;
      op2_tb   <= patterns(i).op2;
      opc_tb   <= patterns(i).opc;
      wait for 1 ns;
      assert res_tb   = patterns(i).res report "bad result" severity error;
      assert flags_tb = patterns(i).flags report "bad flag" severity error;
    end loop;

    assert false report "Shifter testbench finished" severity note;
    wait;
  end process;
end architecture;

