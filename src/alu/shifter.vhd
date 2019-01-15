------------------------------------------------------------
-- Title:       Barrel Shifter
-- Description: A barrel shifter which is able to shift by a variable amount.
--              It consists of four layers of multiplexers, one for each bit
--              in the shifting value i_s.
-- Author:      Aaron Moser
-- Date:        14.01.2019
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Utility entity for the barrel shfiter
entity mux is
    port
    (
    i_sig0 : in std_logic;
    i_sig1 : in std_logic;
    i_sel : in std_logic;
    o_sig : out std_logic
    );
end entity;

architecture behaviour of mux is
begin
    o_sig <= i_sig0 when i_sel='0' else
             i_sig1 when i_sel='1';
end architecture;

-- Shifter
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter is
    port
    (
    i_op:  in std_logic_vector(15 downto 0);
    i_s:   in std_logic_vector(3 downto 0);
    i_dir: in std_logic; -- direction
    i_rot: in std_logic; -- rotate
    i_ar:  in std_logic; -- arithmetic shift
    o_r:   out std_logic_vector(15 downto 0); -- result
    o_f:   out std_logic; -- overflow flag
    o_z:   out std_logic  -- zero flag
    );
end entity;

architecture behaviour of shifter is
    component mux is
        port
        (
        i_sig0: in std_logic;
        i_sig1: in std_logic;
        i_sel:  in std_logic;
        o_sig:  out std_logic
        );
    end component;

    signal shift: std_logic_vector(15 downto 0);
    signal carry: std_logic;

    -- shifting layer signals
    signal rev_0: std_logic_vector(15 downto 0);
    signal rev_1: std_logic_vector(15 downto 0);
    signal rot_0: std_logic_vector(15 downto 0);
    signal s_l0: std_logic_vector(15 downto 0);
    signal s_l1: std_logic_vector(15 downto 0);
    signal s_l2: std_logic_vector(15 downto 0);
    signal s_l3: std_logic_vector(15 downto 0);
    signal s : std_logic;
begin

    -- Generate Multiplexer layers
    gen_rev0_mux : for i in 0 to 15 generate
        -- Reverse the bit order for a right shift
        rev0_mux : mux port map
        (
        i_sig0 => i_op(i),
        i_sig1 => i_op(15-i),
        i_sel => i_dir,
        o_sig => rev_0(i)
        );
    end generate;

    arith_mux : mux port map
        (
        i_sig1 => '0',
        i_sig0 => rev_0(15),
        i_sel => i_ar,
        o_sig => s
        );

    gen_rot_layer0 : for i in 0 to 7 generate
        ROT : mux port map
        (
        i_sig0 => s,
        i_sig1 => rev_0(i+8),
        i_sel => i_rot,
        o_sig => rot_0(i+8)
        );

    rot_layer0_proc : process(all)
    begin
        for i in 0 to 8 loop
            rot_0(i) <= rev_0(i);
        end loop;
    end process;

    gen_layer0_mux : for i in 0 to 15 generate
        mux_lower8 : if i <= 7 generate
            L8 : mux port map
            (
            i_sig0 => rev_0(i),
            i_sig1 => '0',
            i_sel  => i_s(3),
            o_sig  => s_l0(i)
            );
        end generate;
        mux_upper8 : if i > 7 generate
            U8 : mux port map
            (
            i_sig0 => rev_0(i),
            i_sig1 => i_op(i-8),
            i_sel  => i_s(3),
            o_sig  => s_l0(i)
            );
        end generate;
    end generate;

    gen_rot_layer1 : for i in 0 to 3 generate
        ROT : mux port map
        (
        i_sig0 => s,
        i_sig1 => rev_0(i+12),
        i_sel => i_rot,
        o_sig => rot_0(i+12)
        );

    rot_layer1_proc : process(all)
    begin
        for i in 0 to 12 loop
            rot_0(i) <= rev_0(i);
        end loop;
    end process;

    gen_layer1_mux : for i in 0 to 15 generate
        mux_lower4 : if i <= 3 generate
            L4 : mux port map
            (
            i_sig0 => s_l0(i),
            i_sig1 => '0',
            i_sel  => i_s(2),
            o_sig  => s_l1(i)
            );
        end generate;
        mux_upper12 : if i > 3 generate
            U12 : mux port map
            (
            i_sig0 => s_l0(i),
            i_sig1 => s_l0(i-4),
            i_sel  => i_s(2),
            o_sig  => s_l1(i)
            );
        end generate;
    end generate;

    gen_rot_layer2 : for i in 0 to 1 generate
        ROT : mux port map
        (
        i_sig0 => s,
        i_sig1 => rev_0(i+13),
        i_sel => i_rot,
        o_sig => rot_0(i+13)
        );

    rot_layer2_proc : process(all)
    begin
        for i in 0 to 13 loop
            rot_0(i) <= rev_0(i);
        end loop;
    end process;

    gen_layer2_mux : for i in 0 to 15 generate
        mux_lower2 : if i <= 1 generate
            L2 : mux port map
            (
            i_sig0 => s_l1(i),
            i_sig1 => '0',
            i_sel  => i_s(1),
            o_sig  => s_l2(i)
            );
        end generate;
        mux_upper14 : if i > 1 generate
            U14 : mux port map
            (
            i_sig0 => s_l1(i),
            i_sig1 => s_l1(i-2),
            i_sel  => i_s(1),
            o_sig  => s_l2(i)
            );
        end generate;
    end generate;

    gen_rot_layer3 : for i in 0 to 1 generate
        ROT : mux port map
        (
        i_sig0 => s,
        i_sig1 => rev_0(i+14),
        i_sel => i_rot,
        o_sig => rot_0(i+14)
        );

    rot_layer3_proc : process(all)
    begin
        for i in 0 to 14 loop
            rot_0(i) <= rev_0(i);
        end loop;
    end process;
     
    gen_layer3_mux : for i in 0 to 15 generate
        mux_lower1 : if i = 0 generate
            L1 : mux port map
            (
            i_sig0 => s_l2(i),
            i_sig1 => '0',
            i_sel  => i_s(0),
            o_sig  => s_l3(i)
            );
        end generate;
        mux_upper15 : if i > 0 generate
            U15 : mux port map
            (
            i_sig0 => s_l2(i),
            i_sig1 => s_l2(i-1),
            i_sel  => i_s(0),
            o_sig  => s_l3(i)
            );
        end generate;
    end generate;

    gen_rev1_mux : for i in 0 to 15 generate
        rev1_mux : mux port map
        (
        i_sig0 => s_l3(i),
        i_sig1 => s_l3(15-i),
        i_sel => i_dir,
        o_sig => rev_1(i)
        );
    end generate;

    o_r <= rev_1;
    o_z <= '1' when rev_1="0000000000000000" else '0';
    o_f <= '0';
end architecture;
