-----------------------------------------------------------
-- Title:       Lookahead Carry Unit
-- Description: An LCU (lookahead-carry unit) which determines the carries
--              based on generation and propagation calculations
-- Author:      Aaron Moser
-- Date:        10.01.2019
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity lcu is
  port
    (
      i_c  : in  std_logic;
      i_p  : in  std_logic_vector(3 downto 0);
      i_g  : in  std_logic_vector(3 downto 0);
      o_c  : out std_logic_vector(3 downto 0);
      o_pg : out std_logic;
      o_gg : out std_logic
      );
end;

architecture behaviour of lcu is
  signal pg    : std_logic;
  signal gg    : std_logic;
  signal c_vec : std_logic_vector(3 downto 0);
begin
  prop_gen_carry_proc : process(all)
  -- Calculate the propagation, generation, and the carry
  begin
    pg <= i_p(0) and i_p(1) and i_p(2) and i_p(3);
    gg <= i_g(3) or (i_g(2) and i_p(3)) or (i_g(1) and i_p(3) and i_p(2)) or (i_g(0) and i_p(3) and i_p(2) and i_p(1));

    c_vec(0) <= i_g(0) or (i_p(0) and i_c);
    for i in 1 to 3 loop
      c_vec(i) <= i_g(i) or (i_p(i) and c_vec(i-1));
    end loop;
  end process;

  o_pg <= pg;
  o_gg <= gg;
  o_c  <= c_vec;
end architecture;
