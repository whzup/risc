-- Clock divider
library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_divider is
    generic
    (
        div : natural := 2048
    );
    port
    (
        clk:     in std_logic;
        rstn:    in std_logic;
        clk_out: out std_logic
    );
end entity clock_divider;

architecture behaviour of clock_divider is
signal count : natural := 0;
signal next_count : natural := 0; 
begin

divide : process(all)
begin
    if (count = div) then
        clk_out <= '1';
        count <= 0;
    else
        clk_out <= '0';
        next_count <= count + 1;
    end if;
end process divide;

ff : process(all)
begin
    if (rstn = '0') then
        next_count <= 0;
    elsif rising_edge(clk) then
        next_count <= count;
    end if;
end process ff;

end architecture behaviour;
