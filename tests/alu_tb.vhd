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

  --procedure clk_gen(signal clk : out std_logic; constant FREQ : real) is
  --  constant PERIOD    : time := 1 sec / 500000;
  --  constant HIGH_TIME : time := PERIOD / 2;
  --  constant LOW_TIME  : time := PERIOD - HIGH_TIME;
  --begin
  --    assert (HIGH_TIME /= 0 fs) report "clk_plain: High time is zero;" severity failure;
  --    loop
  --        clk <= '1';
  --        wait for HIGH_TIME;
  --        clk <= '0';
  --        wait for LOW_TIME;
  --    end loop;
  --end procedure;

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

  CLOCK:
  clk_tb <=  '1' after 0.5 ns when clk_tb = '0' else
          '0' after 0.5 ns when clk_tb = '1';

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
    (("0000000000000000", "0000000000000000", "10000", "0000000000000000", "1010"),
       -- Add
      ("0000100110010000", "1100000000000011", "10001", "1100100110010011", "0001"),
      -- AND
      ("0111001010010001", "0111100111100101", "10010", "0111000010000001", "0000"),
      ("1001001010100001", "1000010001010101", "10010", "1000000000000001", "0001"),
     -- OR
      ("1001001010100001", "1000010001010101", "10011", "1001011011110101", "0001"),
      ("1111111111111111", "0000000000000000", "10011", "1111111111111111", "0001"),
      -- XOR
      ("0100100110011101", "0111001010110101", "10100", "0011101100101000", "0000"),
      -- NOT
      ("0100100101000101", "0100110110000001", "10101", "1011011010111010", "0001"),
      -- left shift
      ("0101010101010101", "0000000000000011", "10110", "1010101010101000", "0001"),
      ("0000000100000001", "0000000000000101", "10110", "0010000000100000", "0000"),
      -- left rotate
      ("0001001010010001", "0000000000001011", "10111", "1000100010010100", "0001"),
      ("1110000000000001", "0000000000000111", "10111", "0000000011110000", "0000"),
      -- left arithmetic shift
      ("0101010101010101", "0000000000000011", "11000", "1010101010101000", "0101"),
      ("0000000100000001", "0000000000000101", "11000", "0010000000100000", "0000"),
      -- right shift
      ("0101010101010101", "0000000000000001", "11001", "0010101010101010", "0000"),
      -- right rotate
      ("0001000000000001", "0000000000000100", "11010", "0001000100000000", "0000"),
      ("0001001010010001", "0000000000001011", "11010", "0101001000100010", "0000"),
      -- right arithmetic shift
      ("0000000000000001", "0000000000000001", "11011", "0000000000000000", "1010"),
      ("0101010101010101", "0000000000000001", "11011", "0010101010101010", "0000"),

      ("0000000000000000", "0000000000000000", "10000", "0000000000000000", "0001"));


  begin
    for i in patterns'range loop
      --clk_gen(clk_tb, 5.0E6);
      op1_tb   <= patterns(i).op1;
      op2_tb   <= patterns(i).op2;
      opc_tb   <= patterns(i).opc;
      wait for 1 ns;
      assert res_tb   = patterns(i).res report "bad result" severity error;
      assert flags_tb = patterns(i).flags report "bad flag" severity error;
    end loop;

    assert false report "ALU testbench finished" severity note;
    wait;
  end process;
end architecture;

