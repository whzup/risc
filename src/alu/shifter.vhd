library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter is
    port
    (
    i_op:   in std_logic_vector(15 downto 0);
    i_s:    in std_logic_vector(3 downto 0);
    i_ctrl: in std_logic; -- 1 right shift 0 left shift
    o_r:    out std_logic_vector(15 downto 0);
    o_c:    out std_logic
    );
end entity;

architecture behaviour of shifter is
    signal shift: std_logic_vector(15 downto 0);
    signal carry: std_logic;
begin

    shift_proc : process(all)
    begin
        if i_ctrl='0' then
            carry <= i_op(15);
            shift <= std_logic_vector(shift_left(unsigned(i_op), to_integer(unsigned(i_s))));
        else
            carry <= i_op(0);
            shift <= std_logic_vector(shift_right(unsigned(i_op), to_integer(unsigned(i_s))));
        end if;
    end process;

    o_r <= shift;
    o_c <= carry;
end architecture;
