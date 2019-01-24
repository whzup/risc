------------------------------------------------------------
-- Title:       ALU
-- Description: A simple ALU
-- Author:      Aaron Moser
-- Date:        23.01.2019
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity alu is
    port
    (
    i_op1: in std_logic_vector(15 downto 0);
    i_op2: in std_logic_vector(15 downto 0);
    i_opc: in std_logic_vector(15 downto 0);
    o_res: out std_logic_vector(15 downto 0);
    o_z:   out std_logic;
    o_f:   out std_logic;
    o_c:   out std_logic
    ); 
end entity;

architecture behaviour of alu is
    -- Adder
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

    -- Logic Unit
    component lu
        port
        (
        i_op1: in std_logic_vector(15 downto 0);
        i_op2: in std_logic_vector(15 downto 0);
        i_and: in std_logic;
        i_or:  in std_logic;
        i_xor: in std_logic;
        i_not: in std_logic;
        o_res: out std_logic_vector(15 downto 0);
        o_z:   out std_logic
        );
    end component;

    -- Shifter
    component shifter
        port
        (
        i_op:  in std_logic_vector(15 downto 0);
        i_s:   in std_logic_vector(3 downto 0);
        i_dir: in std_logic;
        i_rot: in std_logic;
        i_ar:  in std_logic;
        o_r:   out std_logic_vector(15 downto 0);
        o_f:   out std_logic;
        o_z:   out std_logic
        );
    end component
begin
end architecture;
