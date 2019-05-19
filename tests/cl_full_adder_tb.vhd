library ieee;
use ieee.std_logic_1164.all;

entity cl_full_adder_tb is
end entity;

architecture behaviour of cl_full_adder_tb is
  component cl_full_adder is
    port
      (
        i_op1 : in  std_logic;
        i_op2 : in  std_logic;
        i_c   : in  std_logic;
        o_res : out std_logic;
        o_g   : out std_logic;
        o_p   : out std_logic
        );
  end component;

  signal opa_tb, opb_tb, c_tb, e_tb, g_tb, p_tb : std_logic;

begin
  dut : cl_full_adder port map
    (
      i_op1 => opa_tb,
      i_op2 => opb_tb,
      i_c   => c_tb,
      o_res => e_tb,
      o_g   => g_tb,
      o_p   => p_tb
      );

  stim_proc : process
    type pattern_type is record
      a, b, c : std_logic;
      e, g, p : std_logic;
    end record;

    type pattern_array is array(natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (('0', '0', '0', '0', '0', '0'),
       ('0', '1', '0', '1', '0', '1'),
       ('1', '0', '0', '1', '0', '1'),
       ('1', '1', '0', '0', '1', '1'),
       ('0', '0', '1', '1', '0', '0'),
       ('0', '1', '1', '0', '0', '1'),
       ('1', '0', '1', '0', '0', '1'),
       ('1', '1', '1', '1', '1', '1'));

  begin
    for i in patterns'range loop
      opa_tb <= patterns(i).a;
      opb_tb <= patterns(i).b;
      c_tb   <= patterns(i).c;

      wait for 1 ns;
      assert e_tb = patterns(i).e report "bad sum value" severity error;
      assert g_tb = patterns(i).g report "bad gen value" severity error;
      assert p_tb = patterns(i).p report "bad prop value" severity error;
    end loop;

    assert false report "CL full adder testbench finished" severity note;
    wait;
  end process;
end architecture;
