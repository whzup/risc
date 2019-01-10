-----------------------------------------------------------
-- An LCU (lookahead-carry unit) which determines the carries
-- based on generation and propagation calculations
-- Author: whzup
-- Date: 10.01.2019
-----------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity lcu is
    port
    (
    ci:  in std_logic;
    pi:  in std_logic_vector(3 downto 0);
    gi:  in std_logic_vector(3 downto 0);
    co:  out std_logic_vector(3 downto 0);
    pgo: out std_logic;
    ggo: out std_logic
    );
end;

architecture behavior of lcu is
signal pg : std_logic;
signal gg : std_logic;
signal c_vec : std_logic_vector(3 downto 0);
begin
    comb : process(all)
    -- Calculate the propagation, generation, and the carry
    begin
        pg <= pi(0) and pi(1) and pi(2) and pi(3);
        gg <= gi(3) or (gi(2) and pi(3)) or (gi(1) and pi(3) and pi(2)) or (gi(0) and pi(3) and pi(2) and pi(1));

        c_vec(0) <= gi(0) or (pi(0) and ci);
        for i in 1 to 3 loop
            c_vec(i) <= gi(i) or (pi(i) and c_vec(i-1));
        end loop;
    end process;

    pgo <= pg;
    ggo <= gg;
    co <= c_vec;
end architecture;
