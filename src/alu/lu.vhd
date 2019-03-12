-----------------------------------------------------------
-- An LU (logic unit) which is responsible for logical operations in the ALU.
-- Author: Aaron Moser
-- Date: 12.01.2019
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity lu is
  port
    (
      i_op1 : in  std_logic_vector(15 downto 0);
      i_op2 : in  std_logic_vector(15 downto 0);
      i_and : in  std_logic;
      i_or  : in  std_logic;
      i_xor : in  std_logic;
      i_not : in  std_logic;
      o_res : out std_logic_vector(15 downto 0);
      o_z   : out std_logic;
      o_n   : out std_logic
      );
end entity;

architecture behaviour of lu is
  signal res : std_logic_vector(15 downto 0);
begin
  logic_proc : process(all)
  begin
    if i_and = '1' then
      for i in 0 to 15 loop
        res(i) <= i_op1(i) and i_op2(i);
      end loop;
    elsif i_or = '1' then
      for i in 0 to 15 loop
        res(i) <= i_op1(i) or i_op2(i);
      end loop;
    elsif i_xor = '1' then
      for i in 0 to 15 loop
        res(i) <= i_op1(i) xor i_op2(i);
      end loop;
    else
      for i in 0 to 15 loop
        res(i) <= not i_op1(i);
      end loop;
    end if;
  end process;

  o_z   <= '1' when res = "0000000000000000" else '0';
  o_n   <= '1' when res(15) = '1'            else '0';
  o_res <= res;
end architecture;
