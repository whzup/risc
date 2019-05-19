------------------------------------------------------------
-- Title:       Carry Lookahead Full Adder
-- Description: A simple carry lookahead full adder
-- Author:      Aaron Moser
-- Date:        10.01.2019
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity cl_full_adder is
  port
    (
      i_op1 : in  std_logic;
      i_op2 : in  std_logic;
      i_c   : in  std_logic;
      o_res : out std_logic;            -- sum value
      o_g   : out std_logic;            -- generation value
      o_p   : out std_logic             -- propagation value
      );
end;

architecture behaviour of cl_full_adder is
begin
  o_res <= i_op1 xor i_op2 xor i_c;
  o_g <= i_op1 and i_op2;
  o_p <= i_op1 or i_op2;
end;
