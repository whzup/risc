library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
    port
    (
    opai : in std_logic;
    opbi : in std_logic;
    ci : in std_logic;
    eo : out std_logic;
    go : out std_logic;
    po : out std_logic
    );
end;

architecture behav of full_adder is
begin
    eo <= opai xor opbi xor ci;
    go <= opai and opbi;
    po <= opai or opbi;
end;
