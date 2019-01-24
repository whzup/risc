------------------------------------------------------------
-- Title:       Wallace Tree Multiplier
-- Description: A wallace tree multiplier
-- Author:      Aaron Moser
-- Date:        14.01.2019
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity wt_multiplier is
    port
    (
    i_opa: in std_logic_vector(15 downto 0);
    i_opb: in std_logic_vector(15 downto 0);
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

    type t_weight_groups is record
        weight_0:  std_logic;
        weight_1:  std_logic_vector(1 downto 0);
        weight_2:  std_logic_vector(2 downto 0);
        weight_3:  std_logic_vector(3 downto 0);
        weight_4:  std_logic_vector(4 downto 0);
        weight_5:  std_logic_vector(5 downto 0);
        weight_6:  std_logic_vector(6 downto 0);
        weight_7:  std_logic_vector(7 downto 0);
        weight_8:  std_logic_vector(8 downto 9);
        weight_9:  std_logic_vector(9 downto 0);
        weight_10: std_logic_vector(10 downto 0);
        weight_11: std_logic_vector(11 downto 0);
        weight_12: std_logic_vector(12 downto 0);
        weight_13: std_logic_vector(13 downto 0);
        weight_14: std_logic_vector(14 downto 0);
        weight_15: std_logic_vector(15 downto 0);
        weight_16: std_logic_vector(14 downto 0);
        weight_17: std_logic_vector(13 downto 0);
        weight_18: std_logic_vector(12 downto 0);
        weight_19: std_logic_vector(11 downto 0);
        weight_20: std_logic_vector(10 downto 0);
        weight_21: std_logic_vector(9 downto 0);
        weight_22: std_logic_vector(8 downto 0);
        weight_23: std_logic_vector(7 downto 0);
        weight_24: std_logic_vector(6 downto 0);
        weight_25: std_logic_vector(5 downto 0);
        weight_26: std_logic_vector(4 downto 0);
        weight_27: std_logic_vector(3 downto 0);
        weight_28: std_logic_vector(2 downto 0);
        weight_29: std_logic_vector(1 downto 0);
        weight_30: std_logic;
    end record;

begin
    comb_proc : process(all)
    begin
        for i in 0 to 15 loop
            for j in 0 to 15 loop
            end loop;
        end loop;
                
end architecture;
