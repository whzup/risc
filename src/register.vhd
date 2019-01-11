library ieee;
use ieee.std_logic_1164.all;

entity reg is
    port
    (
    clk:  in std_logic;
    rstn: in std_logic;
    regi: in std_logic_vector(15 downto 0);
    iei:  in std_logic;
    oei:  in std_logic;
    rego: out std_logic_vector(15 downto 0)
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

    sync : process(all)
    begin
        if (rstn = '0') then
            reg <= (others => '0');
        elsif rising_edge(clk) then
            rego <= reg;
        end if;
    end process;

end architecture;
