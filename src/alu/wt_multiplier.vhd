------------------------------------------------------------
-- Title:       Wallace Tree Multiplier
-- Description: A wallace tree multiplier
-- Author:      Aaron Moser
-- Date:        14.01.2019
------------------------------------------------------------

-- Helper package
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package utils is
    function compress_3_2(a: std_logic; b: std_logic; c: std_logic) return std_logic_vector;
    function compress_2_2(a: std_logic; b: std_logic) return std_logic_vector;
    function prev_lvl_carry(this_weight: natural; this_lvl: natural) return natural;
    function this_lvl_bits(this_weight: natural; this_lvl: natural) return natural;
    function num_full_adders(this_weight: natural; this_lvl: natural) return natural;
    function num_half_adders(this_weight: natural; this_lvl: natural) return natural;
end package;

package body utils is
    function prev_lvl_carry(this_weight: natural; this_lvl: natural) return natural is
        -- Calculate the number of carry bits for a given weight and level
        variable this_weight_base_bits: natural := 0;
        variable this_num_bits: natural := 0;
        variable num_carry: natural := 0;
    begin
        -- Determine how many bits there are in the given weight in the base case
        if this_weight > 15 then
            if this_weight = 31 then
                this_weight_base_bits := 1;
            elsif this_weight = 16 then
                this_weight_base_bits := 32-this_weight;
            else
                this_weight_base_bits := 32-this_weight-1;
            end if;
        else
            this_weight_base_bits := this_weight+1;
        end if;

        if this_lvl > 0 then
            if this_weight > 0 then
                this_num_bits := this_lvl_bits(this_weight-1,this_lvl-1); -- How many bits are in the current level and weight
                num_carry := this_num_bits/3;
                num_carry := num_carry + (this_num_bits-num_carry*3)/2; -- Maximize reduction
            else
                num_carry := 0;
            end if;
        else
            num_carry := this_weight_base_bits/3;
            num_carry := num_carry + (this_weight_base_bits-num_carry*3)/2;
        end if;
        return num_carry;
    end function;

    function this_lvl_bits(this_weight: natural; this_lvl: natural) return natural is
        variable this_weight_base_bits: natural := 0;
        variable prev_lvl_bits: natural := 0;
        variable full_adder_sums: natural := 0;
        variable half_adder_sums: natural := 0;
        variable this_num_bits: natural := 0;
    begin
        -- Determine how many bits there are in the given weight in the base case
        if this_weight > 15 then
            if this_weight = 31 then
                this_weight_base_bits := 1;
            elsif this_weight = 16 then
                this_weight_base_bits := 32-this_weight;
            else
                this_weight_base_bits := 32-this_weight-1;
            end if;
        else
            this_weight_base_bits := this_weight+1;
        end if;

        if this_lvl > 0 then
            if this_weight > 0 then
                prev_lvl_bits := this_lvl_bits(this_weight,this_lvl-1);
                full_adder_sums := prev_lvl_bits/3;
                half_adder_sums := (prev_lvl_bits-full_adder_sums*3)/2;
                this_num_bits := prev_lvl_bits - 2*full_adder_sums -
                                 half_adder_sums +
                                 prev_lvl_carry(this_weight,this_lvl);
            else
                this_num_bits := this_weight_base_bits;
            end if;
        end if;
        return this_num_bits;
    end function;

    function num_full_adders(this_weight: natural; this_lvl: natural) return natural is
    begin
        return (this_lvl_bits(this_weight, this_lvl)/3);
    end function;

    function num_half_adders(this_weight: natural; this_lvl: natural) return natural is
        variable this_num_bits: integer := this_lvl_bits(this_weight, this_lvl);
        variable num_full_adds: integer := 0;
    begin
        num_full_adds := this_num_bits/3;
        return ((this_num_bits-num_full_adds*3)/2);
    end function;
end package body;

library ieee;
use ieee.std_logic_1164.all;
use work.utils.all;

entity wt_multiplier is
    port
    (
    i_op1: in std_logic_vector(15 downto 0);
    i_op2: in std_logic_vector(15 downto 0);
    o_op1: out std_logic_vector(31 downto 0);
    o_op2: out std_logic_vector(31 downto 0)
    );
end entity;

architecture behaviour of wt_multiplier is
    component claa_16bit
        port
        (
        i_opa: in std_logic_vector(15 downto 0);
        i_opb: in std_logic_vector(15 downto 0);
        i_c:   in std_logic;
        o_e:   out std_logic_vector(15 downto 0);
        o_p:   out std_logic;
        o_g:   out std_logic;
        o_c:   out std_logic
        );
    end component;

    type t_tree is array(31 downto 0, 15 downto 0, 6 downto 0) of std_logic;
    type t_init is array(15 downto 0, 15 downto 0) of std_logic; -- product tree

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
        variable this_carry_bits: natural := 0;
        variable num_full_adds: natural := 0;
        variable num_half_adds: natural := 0;
        variable num_wires: natural := 0;
    -- Fill the tree
    begin
        for i in 30 downto 0 loop
            if i <= 15 then
                -- Fill first half
                for j in i downto 0 loop
                    if (j = 15) xor (i-j = 15) then
                        tree(i,j,0) <= not init(j,i-j);
                    else
                        tree(i,j,0) <= init(j,i-j);
                    end if;
                end loop;
            else
                -- Fill second half
                for j in 15 downto i-16 loop
                    if (j = 15) xor (i-j = 15) then
                        tree(i,j-i+15,0) <= not init(j,i-j);
                    else
                        tree(i,j-i+15,0) <= init(j,i-j);
                    end if;
                end loop;
            end if;
        end loop;

        -- Fill the stages
        for k in 0 to 5 loop
            for i in 31 downto 0 loop
                this_carry_bits := prev_lvl_carry(16,i,k+1);

                num_full_adds := num_full_adders(i,k);
                for j in 0 to num_full_adds-1 loop
                    tree(i,this_carry_bits+j,k+1) <= tree(i,j*3,k) xor
                                                     tree(i,j*3+1,k) xor
                                                     tree(i,j*3+2,k);
                    if i < 31 then
                        tree(i+1,j,k+1) <= (tree(i,j*3,k) and tree(i,j*3+1,k))
                                           xor (tree(i,j*3+2,k) and
                                           (tree(i,j*3,k) xor
                                           tree(i,j*3+1,k)));
                    end if;
                end loop;

                num_half_adds := num_half_adders(i,k);
                for j in 0 to num_half_adds-1 loop
                    tree(i,this_carry_bits+num_full_adds+j,k+1) <=
                   tree(i,num_full_adds*3+j*2,k) xor
                   tree(i,num_full_adds*3+j*2+1,k);
                    if i < 31 then
                        tree(i+1,num_full_adds+j,k+1) <=
                       tree(i,num_full_adds*3+j*2,k) and
                       tree(i,num_full_adders*3+j*2+1,k);
                    end if;
                end loop;

                num_wires := this_lvl_bits(i,k) - num_full_adds*3 -
                num_half_adds*2;
                for j in 0 to num_wires-1 loop
                    tree(i,this_carry_bits + num_full_adds + num_half_adds +
                    j,k+1) <= tree(i,num_full_adds*3+num_half_adds*2+j,k);
                end loop;
            end loop;
        end loop;
    end process;

    output : for i in 31 downto 0 generate
        o_op1(i) <= w(i,0,6);
        o_op2(i) <= w(i,1,6);
    end generate;
end architecture;
