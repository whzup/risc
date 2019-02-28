library ieee;
use ieee.std_logic_1164.all;

entity shifter_tb is
end shifter_tb;

architecture behaviour of shifter_tb is
  component shifter is
    port
      (
        i_op  : in  std_logic_vector(15 downto 0);
        i_s   : in  std_logic_vector(3 downto 0);
        i_dir : in  std_logic;
        i_rot : in  std_logic;
        i_ar  : in  std_logic;
        o_r   : out std_logic_vector(15 downto 0);
        o_f   : out std_logic;
        o_z   : out std_logic
        );
  end component;

  signal op_tb, r_tb                       : std_logic_vector(15 downto 0);
  signal s_tb                              : std_logic_vector(3 downto 0);
  signal f_tb, dir_tb, rot_tb, ar_tb, z_tb : std_logic;

begin
  dut : shifter port map
    (
      i_op  => op_tb,
      i_s   => s_tb,
      i_dir => dir_tb,
      i_rot => rot_tb,
      i_ar  => ar_tb,
      o_r   => r_tb,
      o_f   => f_tb,
      o_z   => z_tb
      );

  stim_proc : process
    type pattern_type is record
      op  : std_logic_vector(15 downto 0);
      s   : std_logic_vector(3 downto 0);
      dir : std_logic;
      rot : std_logic;
      ar  : std_logic;
      r   : std_logic_vector(15 downto 0);
      f   : std_logic;
      z   : std_logic;
    end record;

    type pattern_array is array(natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      -- left shift
      (("0000000000000001", "0001", '1', '0', '0', "0000000000000010", '0', '0'),
       ("0000000000000001", "1111", '1', '0', '0', "1000000000000000", '0', '0'),
       ("0101010101010101", "0001", '1', '0', '0', "1010101010101010", '0', '0'),
       ("0101010101010101", "0011", '1', '0', '0', "1010101010101000", '0', '0'),
       ("0000000100000001", "0101", '1', '0', '0', "0010000000100000", '0', '0'),
       -- left rotate
       ("0000000000000001", "0011", '1', '1', '0', "0000000000001000", '0', '0'),
       ("0001001010010001", "1011", '1', '1', '0', "1000100010010100", '0', '0'),
       ("1110000000000001", "0111", '1', '1', '0', "0000000011110000", '0', '0'),
       ("0000000000000001", "0011", '1', '1', '0', "0000000000001000", '0', '0'),
       -- left arithmetic shift
       ("0000000000000001", "0001", '1', '0', '1', "0000000000000010", '0', '0'),
       ("0000000000000001", "1111", '1', '0', '1', "1000000000000000", '1', '0'),
       ("0000000000000011", "1111", '1', '0', '1', "1000000000000000", '1', '0'),
       ("0101010101010101", "0001", '1', '0', '1', "1010101010101010", '1', '0'),
       ("0101010101010101", "0011", '1', '0', '1', "1010101010101000", '1', '0'),
       ("0000000100000001", "0101", '1', '0', '1', "0010000000100000", '0', '0'),
       ("0000000100000001", "0111", '1', '0', '1', "1000000010000000", '1', '0'),
       -- right shift
       ("0000000000000001", "0001", '0', '0', '0', "0000000000000000", '0', '1'),
       ("0101010101010101", "0001", '0', '0', '0', "0010101010101010", '0', '0'),
       -- right rotate
       ("1111111111111111", "1111", '0', '1', '0', "1111111111111111", '0', '0'),
       ("0000000000000001", "0011", '0', '1', '0', "0010000000000000", '0', '0'),
       ("0001000000000001", "0100", '0', '1', '0', "0001000100000000", '0', '0'),
       ("0001001010010001", "1011", '0', '1', '0', "0101001000100010", '0', '0'),
       -- right arithmetic shift
       ("1000000000000001", "0011", '0', '0', '1', "1111000000000000", '0', '0'),
       ("0000000000000001", "0001", '0', '0', '1', "0000000000000000", '0', '1'),
       ("0101010101010101", "0001", '0', '0', '1', "0010101010101010", '0', '0'));

  begin
    for i in patterns'range loop
      op_tb  <= patterns(i).op;
      s_tb   <= patterns(i).s;
      dir_tb <= patterns(i).dir;
      rot_tb <= patterns(i).rot;
      ar_tb  <= patterns(i).ar;
      wait for 1 ns;
      assert r_tb = patterns(i).r report "bad result" severity error;
      assert f_tb = patterns(i).f report "bad overflow value" severity error;
      assert z_tb = patterns(i).z report "bad zero value" severity error;
    end loop;

    assert false report "Shifter testbench finished" severity note;
    wait;
  end process;
end architecture;

