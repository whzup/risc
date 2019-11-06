------------------------------------------------------------
-- Title:       Tristate Buffer
-- Description: 
-- Author:      Aaron Moser
-- Date:        28.05.2019
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity tristate_buf is
port
  (
    i_d     : in std_logic;
    i_n_en  : in std_logic;
    o_d     : out std_logic
  );
end tristate_buf;

architecture behaviour of tristate_buf is
begin

with i_n_en select o_d <=
  "Z" when '0',
  i_d when '1';

end behaviour;
