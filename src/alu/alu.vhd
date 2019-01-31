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
    i_op1:   in std_logic_vector(15 downto 0);
    i_op2:   in std_logic_vector(15 downto 0);
    i_opc:   in std_logic_vector(4 downto 0);
    i_clk:   in std_logic;
    o_res:   out std_logic_vector(15 downto 0);
    o_z:     out std_logic;
    o_f:     out std_logic;
    o_c:     out std_logic;
    o_n:     out std_logic
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

    -- Mulitplier
    component wt_multiplier
        port
        (
        i_op1: in std_logic_vector(15 downto 0);
        i_op2: in std_logic_vector(15 downto 0);
        o_op1: out std_logic_vector(31 downto 0);
        o_op2: out std_logic_vector(31 downto 0)
        );
    end component;
    
    -- Decoder
    component op_decoder
        port
        (
        i_opc:  in std_logic_vector(4 downto 0);
        o_sub:  out std_logic;
        o_and:  out std_logic;
        o_or:   out std_logic;
        o_xor:  out std_logic;
        o_not:  out std_logic;
        o_dir:  out std_logic;
        o_rot:  out std_logic;
        o_ar:   out std_logic;
        o_mult: out std_logic
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
    signal lu_and: std_logic;
    signal lu_or:  std_logic;
    signal lu_xor: std_logic;
    signal lu_not: std_logic;

    -- Shifter signals
    signal shift : std_logic_vector(3 downto 0);
    signal sh_res: std_logic_vector(15 downto 0);
    signal sh_dir: std_logic;
    signal sh_rot: std_logic;
    signal sh_ar:  std_logic;
    signal sh_f:   std_logic;
    signal sh_z:   std_logic;

    -- Multiplier signal
    signal mul_op1: std_logic_vector(31 downto 0);
    signal mul_op2: std_logic_vector(31 downto 0);


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
    i_and  => lu_and,
    i_or   => lu_or,
    i_xor  => lu_xor,
    i_not  => lu_not,
    o_res  => lu_res,
    o_z    => lu_z
    );

    shifter_inst : shifter port map
    (
    i_op  => i_op1,
    i_s   => shift,
    i_dir => sh_dir,
    i_rot => sh_rot,
    i_ar  => sh_ar,
    o_r   => sh_res,
    o_f   => sh_f,
    o_z   => sh_z
    );

    mult_inst : wt_multiplier port map
    (
    i_op1 => i_op1,
    i_op2 => i_op2,
    o_op1 => mul_op1,
    o_op2 => mul_op1
    );

    decoder_inst : op_decoder port map
    (
    i_opc  => i_opc,
    o_sub  => sub_flag,
    o_and  => lu_and,
    o_or   => lu_or,
    o_xor  => lu_xor,
    o_not  => lu_not,
    o_dir  => sh_dir,
    o_rot  => sh_rot,
    o_ar   => sh_ar,
    o_mult => mul_flag
    );
    
    sync_proc : process(all)
    begin
        if rising_edge(i_clk) then
            o_res <= res;
        end if;
    end process;

end architecture;

-- Decoder
library ieee;
use ieee.std_logic_1164.all;

entity op_decoder is
    port
    (
    i_opc:  in std_logic_vector(4 downto 0);
    o_sub:  out std_logic;
    o_and:  out std_logic;
    o_or:   out std_logic;
    o_xor:  out std_logic;
    o_not:  out std_logic;
    o_dir:  out std_logic;
    o_rot:  out std_logic;
    o_ar:   out std_logic;
    o_mult: out std_logic
    );
end entity;

architecture behaviour of op_decoder is
begin
    o_sub  <= '1' when i_opc = "10000" else '0';
    o_and  <= '1' when i_opc = "10001" else '0';
    o_or   <= '1' when i_opc = "10010" else '0';
    o_xor  <= '1' when i_opc = "10011" else '0';
    o_not  <= '1' when i_opc = "10100" else '0';
    o_dir  <= '1' when i_opc = "10101" else '0';
    o_rot  <= '1' when i_opc = "10110" else '0';
    o_ar   <= '1' when i_opc = "11000" else '0';
    o_mult <= '1' when i_opc = "11001" else '0';
end architecture;
