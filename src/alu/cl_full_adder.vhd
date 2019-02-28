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
      i_opa : in  std_logic;
      i_opb : in  std_logic;
      i_c   : in  std_logic;
      o_e   : out std_logic;            -- sum value
      o_g   : out std_logic;            -- generation value
      o_p   : out std_logic             -- propagation value
      );
end;

architecture behaviour of cl_full_adder is
begin
  o_e <= i_opa xor i_opb xor i_c;
  o_g <= i_opa and i_opb;
  o_p <= i_opa or i_opb;
end;
