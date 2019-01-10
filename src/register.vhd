library ieee;
use ieee.std_logic_1164.all;

entity reg is
    port
    (
    clk : std_logic;
    rstn : std_logic;
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

    sync : process(all)
    begin
        if (rstn = '0') then
            reg <= (others => '0');
        elsif (rising_edge(clk) = '1') then
            rego <= reg;
        end if;
    end process;

end architecture;
