------------------------------------------------------------
-- Title:       Register
-- Description: A simple register
-- Author:      Aaron Moser
-- Date:        10.01.2019
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity reg is
    port
    (
    i_clk:   in std_logic;
    i_n_rst: in std_logic;
    i_reg:   in std_logic_vector(15 downto 0);
    i_ie:    in std_logic;
    i_oe:    in std_logic;
    o_reg:   out std_logic_vector(15 downto 0)
    );
end;

architecture behaviour of reg is
    signal reg : std_logic_vector(15 downto 0);
begin
    store_proc : process(all)
    begin
        if i_ie = '1' and i_oe = '0' then
            reg <= i_reg;
        end if;
    end process;

    sync_proc : process(all)
    begin
        if (i_n_rst = '0') then
            reg <= (others => '0');
        elsif rising_edge(i_clk) then
            o_reg <= reg;
        end if;
    end process;

end architecture;
