------------------------------------------------------------
-- Title:       Carry Save Half Adder
-- Description: A simple carry save half adder
-- Author:      Aaron Moser
-- Date:        12.01.2019
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity cs_full_adder is
    port
    (
    i_opx: in std_logic;
    i_opy: in std_logic;
    o_e:   out std_logic;
    o_c:   out std_logic
    );
end;

architecture behaviour of cs_full_adder is
begin
    o_e <= i_opx xor i_opy;
    o_c <= i_opx and i_opy;
end;
