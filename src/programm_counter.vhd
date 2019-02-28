-----------------------------------------------------------
-- Title:       Program Counter
-- Description: A simple program counter
-- Author:      Aaron Moser
-- Date:        11.01.2019
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity programm_counter is
  port
    (
      i_n_rst : in  std_logic;
      i_ce    : in  std_logic;
      i_je    : in  std_logic;
      i_j     : in  std_logic_vector(15 downto 0);
      o_count : out std_logic_vector(15 downto 0)
      );
end entity;

architecture behaviour of programm_counter is
  signal sel               : std_logic;
  signal count, next_count : unsigned(15 downto 0);
begin
  counter_proc : process(all)
  begin
    -- TODO decide a fitting priority.
    sel <= i_ce and i_je;
    if i_je = '1' and i_ce = '0' then
      next_count <= unsigned(i_j);
    elsif i_ce = '1' then
      o_count    <= std_logic_vector(count);
      count      <= next_count;
      next_count <= count + 1;
    end if;
  end process;
end architecture;

