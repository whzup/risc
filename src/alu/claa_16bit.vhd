------------------------------------------------------------
-- Title:       16-bit Carry Lookahead Adder
-- Description: The adder is comprised of four 4-bit CLA adders and one
--              LCU (lookahead carry unit) which calculates the carries.
-- Author:      Aaron Moser
-- Date:        10.01.2019
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity claa_16bit is
  port
    (
      i_opa : in  std_logic_vector(15 downto 0);
      i_opb : in  std_logic_vector(15 downto 0);
      i_c   : in  std_logic;
      o_e   : out std_logic_vector(15 downto 0);
      o_p   : out std_logic;
      o_g   : out std_logic;
      o_flags : out std_logic_vector(3 downto 0)
      );
end entity;

architecture behaviour of claa_16bit is
  -- Components
  component claa_4bit
    port
      (
        i_opa, i_opb  : in  std_logic_vector(3 downto 0);
        i_c           : in  std_logic;
        o_e           : out std_logic_vector(3 downto 0);
        o_p, o_g, o_c : out std_logic
        );
  end component;

  component lcu
    port
      (
        i_c        : in  std_logic;
        i_p, i_g   : in  std_logic_vector(3 downto 0);
        o_c        : out std_logic_vector(3 downto 0);
        o_pg, o_gg : out std_logic
        );
  end component;

  -- Signals
  signal e_vec : std_logic_vector(15 downto 0);
  signal p_vec : std_logic_vector(3 downto 0);
  signal g_vec : std_logic_vector(3 downto 0);
  signal c_vec : std_logic_vector(3 downto 0);

  signal add_z : std_logic := '0';
  signal add_f : std_logic := '0';
  signal add_c : std_logic := '0';
  signal add_n : std_logic := '0';
begin
  gen_claa : for i in 0 to 3 generate
    lsb_claa : if i = 0 generate
      A0 : claa_4bit port map
        (
          i_opa => i_opa(3 downto 0),
          i_opb => i_opb(3 downto 0),
          i_c   => i_c,
          o_e   => e_vec(3 downto 0),
          o_g   => g_vec(i),
          o_p   => p_vec(i)
          );
    end generate lsb_claa;

    claa : if i > 0 generate
      AX : claa_4bit port map
        (
          i_opa => i_opa(4*i+3 downto 4*i),
          i_opb => i_opb(4*i+3 downto 4*i),
          i_c   => c_vec(i-1),
          o_e   => e_vec(4*i+3 downto 4*i),
          o_g   => g_vec(i),
          o_p   => p_vec(i)
          );
    end generate claa;
  end generate gen_claa;

  lcu_inst : lcu port map
    (
      i_c  => i_c,
      i_p  => p_vec,
      i_g  => g_vec,
      o_c  => c_vec,
      o_pg => o_p,
      o_gg => o_g
      );

  o_e <= e_vec;
  add_z <= '1' when e_vec = "0000000000000000" else '0';
  add_f <= '1' when (i_opa(15) and i_opb(15) and not e_vec(15)) or
           (not i_opa(15) and not i_opb(15) and e_vec(15));
  add_n <= '1' when e_vec(15) = '1' else '0';
  add_c <= c_vec(3);
  o_flags <= add_z & add_f & add_c & add_n;
end architecture behaviour;
