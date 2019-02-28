------------------------------------------------------------
-- Title:       4-bit Carry Lookahead Adder
-- Description: The adder is comprised of four full adders and one
--              LCU (lookahead carry unit) which calculates the carries.
-- Author:      Aaron Moser
-- Date:        10.01.2019
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity claa_4bit is
  port
    (
      i_opa : in  std_logic_vector(3 downto 0);
      i_opb : in  std_logic_vector(3 downto 0);
      i_c   : in  std_logic;
      o_e   : out std_logic_vector(3 downto 0);
      o_p   : out std_logic;
      o_g   : out std_logic;
      o_c   : out std_logic
      );
end entity;

architecture behaviour of claa_4bit is
  -- Components
  component cl_full_adder
    port
      (
        i_opa, i_opb, i_c : in  std_logic;
        o_e, o_g, o_p     : out std_logic
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
  signal e_vec : std_logic_vector(3 downto 0);
  signal p_vec : std_logic_vector(3 downto 0);
  signal g_vec : std_logic_vector(3 downto 0);
  signal c_vec : std_logic_vector(3 downto 0);
begin
  -- Instantiate the components
  gen_adder : for i in 0 to 3 generate
    lsb_adder : if i = 0 generate
      A0 : cl_full_adder port map
        (
          i_opa => i_opa(i),
          i_opb => i_opb(i),
          i_c   => i_c,
          o_e   => e_vec(i),
          o_g   => g_vec(i),
          o_p   => p_vec(i)
          );
    end generate lsb_adder;

    adder : if i > 0 generate
      AX : cl_full_adder port map
        (
          i_opa => i_opa(i),
          i_opb => i_opb(i),
          i_c   => c_vec(i-1),
          o_e   => e_vec(i),
          o_g   => g_vec(i),
          o_p   => p_vec(i)
          );
    end generate adder;
  end generate gen_adder;

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
  o_c <= c_vec(3);
end architecture behaviour;
