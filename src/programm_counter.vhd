-----------------------------------------------------------
-- A program counter (PC)
-- Author: Aaron Moser
-- Date: 11.01.2019
-----------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity programm_counter is
    port
    (
    rstn: in std_logic;
    cei:  in std_logic;
    jei:  in std_logic;
    ji:   in std_logic_vector(15 downto 0);
    counto : out std_logic_vector(15 downto 0)
    );
end entity;

architecture behaviour of programm_counter is
    signal sel : std_logic;
    signal count, next_count : unsigned(15 downto 0);
begin
    counter : process(all)
    begin
        -- TODO decide a fitting priority.
        sel <= cei and jei;
        if jei = '1' and cei = '0' then
            next_count <= unsigned(ji);
        elsif cei = '1' then
            counto <= std_logic_vector(count);
            count <= next_count;
            next_count <= count + 1;
        end if;
    end process;
end architecture;

