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

    type t_red0 is array(30 downto 0, 15 downto 0) of std_logic;
    type t_red1 is array(30 downto 0, 10 downto 0) of std_logic;
    type t_red2 is array(30 downto 0, 8 downto 0) of std_logic;
    type t_red3 is array(30 downto 0, 5 downto 0) of std_logic;
    type t_red4 is array(30 downto 0, 3 downto 0) of std_logic;
    type t_red5 is array(30 downto 0, 2 downto 0) of std_logic;
    type t_red6 is array(30 downto 0, 1 downto 0) of std_logic;


    signal layer0 : t_red0;
    signal layer1 : t_red1;
    signal layer2 : t_red2;
    signal layer3 : t_red3;
    signal layer4 : t_red4;
    signal layer5 : t_red5;
    signal layer6 : t_red6;

begin
    layer0_red_proc : process(all)
    -- Fill the zeroth layer
    begin
        for i in 0 to 15 loop
            for j in 0 to 15 loop
                layer0(i+j, i) <= i_op1(i) and i_op2(i);
            end loop;
        end loop;
    end process;

    layer1_red_proc : process(all)
    -- Fill the first layer
    begin
        layer1(0,0) <= layer0(0,0);
        layer1(1,0) <= compress_2_2(layer0(1,0), layer0(1,1))(0);
        layer1(2,1) <= compress_2_2(layer0(1,0), layer0(1,1))(1);
        for i in 0 to 14 loop
            layer1(i+2,0) <= compress_3_2(layer0(i+2,0), layer0(i+2,1), layer0(i+2,2))(0);
            layer1(i+3,1) <= compress_3_2(layer0(i+2,0), layer0(i+2,1), layer0(i+2,2))(1);
        end loop;
        layer1(16,0) <= compress_2_2(layer0(16,1), layer0(16,2))(0);
        layer1(17,3) <= compress_2_2(layer0(16,1), layer0(16,2))(1);
        layer1(17,2) <= layer0(17,2);

        for i in 15 to 30 loop
            layer1(i,15) <= layer0(i,15);
        end loop;
    end process;

end architecture;
