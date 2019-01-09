-- Clock divider
library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_div is
    generic
    (
        div : natural := 2048
    );
    port
    (
        clk_in : in std_logic;
        res_n_in : in std_logic;
        clk_out : out std_logic 
    );
end entity clock_div;

architecture behaviour of clock_div is
signal count : natural := 0;
signal next_count : natural := 0; 
begin

divide : process(all)
begin
    if (count = div) then
        clk <= 1;
        count <= 0;
    else
        clk <= 0;
        next_count <= count + 1;
    end if;
end process divide;

ff : process(all)
begin
    if (reset_n = '0') then
        next_count <= 0;
    elsif (rising_edge(clk) = '1') then
        next_count <= count;
    end if;
end process ff;

end architecture behaviour;
