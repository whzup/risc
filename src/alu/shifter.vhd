library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter is
    port
    (
    opi:   in std_logic_vector(15 downto 0);
    si:    in std_logic_vector(3 downto 0);
    ctrli: in std_logic; -- 1 right shift 0 left shift
    ro:    out std_logic_vector(15 downto 0);
    co:    out std_logic
    );
end entity;

architecture behaviour of shifter is
    signal shift : unsigned(3 downto 0);
    signal carry : std_logic;
begin

    comb : process(ctrli)
    begin
        if ctrli='0' then
            carry <= opi(15);
            shift <= shift_left(unsigned(opi), to_integer(unsigned(si)));
        else
            carry <= opi(0);
            shift <= shift_right(unsigned(opi), to_integer(unsigned(si)));
        end if;
    end process;

    ro <= std_logic_vector(shift);
    co <= carry;
end architecture;
