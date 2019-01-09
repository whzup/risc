library ieee;
use ieee.std_logic_1164.all;

entity reg is
    port
    (
    regi : std_logic_vector(15 downto 0);
    iei : std_logic;
    oei : std_logic;
    rego : std_logic_vector(15 downto 0)
    );
end;

architecture behav of reg is
    signal reg : std_logic_vector(15 downto 0);
begin
    comb : process(all)
    begin
        if iei = '1' and oei = '0' then
            reg <= regi;
        end if;
    end process;

