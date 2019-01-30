------------------------------------------------------------
-- Title:       Wallace Tree Multiplier
-- Description: A wallace tree multiplier
-- Author:      Aaron Moser
-- Date:        14.01.2019
------------------------------------------------------------

-- Helper package
library ieee;
use ieee.std_logic_1164.all;

package compressors is
    function compress_3_2(a: std_logic; b: std_logic; c: std_logic) return std_logic_vector;
    function compress_2_2(a: std_logic; b: std_logic) return std_logic_vector;
end package;

package body compressors is
    -- Full adder
    function compress_3_2(a: std_logic; b: std_logic; c: std_logic) return std_logic_vector is
        variable res : std_logic_vector(1 downto 0);
    begin
        res(0) := a xor b xor c;
        res(1) := (a and b) or (a and c) or (b and c);
        return res;
    end function;

    -- Half adder
    function compress_2_2(a: std_logic; b: std_logic) return std_logic is
        variable res : std_logic_vector(1 downto 0);
    begin
        res(0) := a xor b;
        res(1) := a and b;
        return res;
    end function;
end package body;

library ieee;
use ieee.std_logic_1164.all;
use work.compressors.all;

entity wt_multiplier is
    port
    (
    i_op1: in std_logic_vector(15 downto 0);
    i_op2: in std_logic_vector(15 downto 0);
    i_p: out std_logic_vector(31 downto 0)
    );
end entity;

architecture behaviour of wt_multiplier is
    component cs_full_adder
        port
        (
        i_opx, i_opy, i_opz : in std_logic;
        o_e, o_c : out std_logic
        );
    end component;

    component cs_half_adder
        port
        (
        i_opx, i_opy : in std_logic;
        o_e, o_c : out std_logic
        );
    end component;

    type t_tree is array(31 downto 0, 15 downto 0, 6 downto 0) of std_logic;
    type t_init is array(15 downto 0, 15 downto 0) of std_logic; -- product tree

    signal opa, opb, sum : std_logic_vector(31 downto 0);

    signal init : t_init;
    signal tree : t_tree;

begin
    init_proc : process(all)
    -- Fill the zeroth layer
    begin
        for i in 0 to 15 loop
            for j in 0 to 15 loop
                init(i,j) <= i_op1(i) and i_op2(i);
            end loop;
        end loop;
    end process;

    wallace_tree_proc : process(all)
    -- Fill the tree
    begin
        for i in 30 downto 0 loop
            for j in i downto 0 loop
                tree(i,k,0) <= init(j,i-j);
            end loop;
        end loop;
    end process;

end architecture;
