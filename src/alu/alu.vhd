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
    o_c:   out std_logic;
    o_n:   out std_logic
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
    end component;
    
    -- Adder signals
    signal inv_vec:  std_logic_vector(15 downto 0);
    signal sub_flag: std_logic;
    signal add_res:  std_logic_vector(15 downto 0);
    signal add_c:    std_logic;

    -- LU signals
    signal lu_res: std_logic_vector(15 downto 0);
    signal lu_z:   std_logic;

    -- Shifter signals
    signal shift : std_logic_vector(3 downto 0);
    signal sh_res: std_logic_vector(15 downto 0);
    signal sh_f:   std_logic;
    signal sh_z:   std_logic;

begin
    -- Instantiate the components
    claa_inst : claa_16bit port map
    (
    i_opa => i_op1,
    i_opb => inv_vec,
    i_c   => sub_flag,
    o_e   => add_res,
    o_p   => open,
    o_g   => open,
    o_c   => add_c
    );

    lu_int : lu port map
    (
    i_op1  => i_op1,
    i_op2  => i_op2,
    i_and  => open,
    i_or   => open,
    i_xor  => open,
    i_not  => open,
    o_res  => lu_res,
    o_z    => lu_z
    );

    shifter_inst : shifter port map
    (
    i_op  => i_op1,
    i_s   => shift,
    i_dir => open,
    i_rot => open,
    i_ar  => open,
    o_r   => sh_res,
    o_f   => sh_f,
    o_z   => sh_z
    );

end architecture;
