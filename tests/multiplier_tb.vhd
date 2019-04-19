library ieee;
use ieee.std_logic_1164.all;

entity wt_multiplier_tb is
end entity;

architecture behaviour of wt_multiplier_tb is
  component wt_multiplier is
  port
      (
      i_op1 : in  std_logic_vector(15 downto 0);
      i_op2 : in  std_logic_vector(15 downto 0);
      o_op1 : out std_logic_vector(31 downto 0);
      o_op2 : out std_logic_vector(31 downto 0)
      );
  end component;

  component claa_16bit is
    port
      (
        i_opa, i_opb  : in  std_logic_vector(15 downto 0);
        i_c           : in  std_logic;
        o_e           : out std_logic_vector(15 downto 0);
        o_p, o_g, o_c : out std_logic
        );
  end component;

  signal iop1_tb, iop2_tb : std_logic_vector(15 downto 0);
  signal oop1_tb, oop2_tb : std_logic_vector(31 downto 0);

begin
  dut : wt_multiplier port map
    (
      i_op1 => iop1_tb,
      i_op2 => iop2_tb,
      o_op1 => oop1_tb,
      o_op2 => oop2_tb
      );

  stim_proc : process
    type pattern_type is record
      iop1, iop2 : std_logic_vector(15 downto 0);
      oop1, oop2 : std_logic_vector(31 downto 0);
    end record;

    type pattern_array is array(natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("0000000000000000", "0000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000"),
       ("0000000000000001", "0000000000000001", "00000000000000000000000000000000", "00000000000000000000000000000000"),
       ("0010010100111000", "0001000111100000", "00000000000000000000000000000000", "00000000000000000000000000000000"));

  begin
    for i in patterns'range loop
      iop1_tb <= patterns(i).iop1;
      iop2_tb <= patterns(i).iop2;

      wait for 5 ns;
      assert oop1_tb = patterns(i).oop1 report "bad output operand 1 value" severity error;
      assert oop2_tb = patterns(i).oop2 report "bad output operand 2 value" severity error;
    end loop;

    assert false report "Wallace Tree Multiplier testbench finished" severity note;
    wait;
  end process;
end;
