------------------------------------------------------------
-- Title:       Clock Divider
-- Description: A simple clock divider for later testing
-- Author:      Aaron Moser
-- Date:        14.01.2019
------------------------------------------------------------

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
      i_clk   : in  std_logic;
      i_n_rst : in  std_logic;
      o_clk   : out std_logic
    );
end entity clock_divider;

architecture behaviour of clock_divider is
  signal next_count, count : natural := 0;
begin

  divide_proc : process(all)
  begin
    if next_count = div then
      o_clk <= '1';
      next_count <= 0;
    else
      o_clk      <= '0';
      next_count <= count + 1;
    end if;
  end process;

  sync_proc : process(all)
  begin
    if i_n_rst = '0' then
      count <= 0;
    elsif rising_edge(i_clk) then
      count <= next_count;
    end if;
  end process;

end architecture behaviour;
