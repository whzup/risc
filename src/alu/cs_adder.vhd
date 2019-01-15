------------------------------------------------------------
-- Title:       Carry Save Adder
-- Description: A simple carry save adder
-- Author:      Aaron Moser
-- Date:        12.01.2019
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity cs_adder is
    generic
    (
        op_size: natural
    );
    port
    (
        i_op: in std_logic_vector(op_size-1 downto 0);
        o_e:  out std_logic_vector(op_size-1 downto 0);
        o_c : out std_logic
    );
end entity;

architecture behaviour of cs_adder is
begin
end architecture;
