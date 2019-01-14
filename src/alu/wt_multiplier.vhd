------------------------------------------------------------
-- Title:       Wallace Tree Multiplier
-- Description: A wallace tree multiplier
-- Author:      Aaron Moser
-- Date:        14.01.2019
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity wt_multiplier is
    port
    (
    i_opa: in std_logic_vector(15 downto 0);
    i_opb: in std_logic_vector(15 downto 0);
    i_p: out std_logic_vector(31 downto 0)
    );
end entity;

architecture behaviour of wt_multiplier is
    component cs_full_adder
        port
        (
        i_opx, i_opy, i_opz : in std_logic;
        o_e, o_c : out std_logic
        );
    end component;

    component cs_half_adder
        port
        (
        i_opx, i_opy : in std_logic;
        o_e, o_c : out std_logic
        );
    end component;

begin

end architecture;
