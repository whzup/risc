library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter is
    port
    (
    i_op:   in std_logic_vector(15 downto 0);
    i_s:    in std_logic_vector(3 downto 0);
    i_ctrl: in std_logic; -- 1 right shift 0 left shift
    o_r:    out std_logic_vector(15 downto 0);
    o_c:    out std_logic
    );
end entity;

architecture behaviour of shifter is
    component mux is
        port
        (
        i_sig0 : in std_logic;
        i_sig1 : in std_logic;
        i_sel : in std_logic;
        o_sig : out std_logic
        );
    end component;

    signal shift: std_logic_vector(15 downto 0);
    signal carry: std_logic;

    -- shifting layer signals
    signal s_l0: std_logic_vector(15 downto 0);
    signal s_l1: std_logic_vector(15 downto 0);
    signal s_l2: std_logic_vector(15 downto 0);
    signal s_l3: std_logic_vector(15 downto 0);
begin

    gen_layer0_mux : for i in 0 to 15 generate
        mux_lower8 : if i <= 7 generate
            L8 : mux port map
            (
            i_sig0 => i_op(i),
            i_sig1 => '0',
            i_sel => i_s(3),
            o_sig => s_l0(i)
            );
        end generate;
        mux_upper8 : if i > 7 generate
            U8 : mux port map
            (
            i_sig0 => i_op(i),
            i_sig1 => i_op(i-8),
            i_sel => i_s(3),
            o_sig => s_l0(i)
            );
        end generate;
    end generate;

    gen_layer1_mux : for i in 0 to 15 generate
        mux_lower4 : if i <= 3 generate
            L4 : mux port map
            (
            i_sig0 => s_l0(i),
            i_sig1 => '0',
            i_sel => i_s(2),
            o_sig => s_l1(i)
            );
        end generate;
        mux_upper12 : if i > 3 generate
            U12 : mux port map
            (
            i_sig0 => s_l0(i),
            i_sig1 => s_l0(i-4),
            i_sel => i_s(2),
            o_sig => s_l1(i)
            );
        end generate;
    end generate;

    gen_layer2_mux : for i in 0 to 15 generate
        mux_lower2 : if i <= 1 generate
            L2 : mux port map
            (
            i_sig0 => s_l1(i),
            i_sig1 => '0',
            i_sel => i_s(1),
            o_sig => s_l2(i)
            );
        end generate;
        mux_upper14 : if i > 1 generate
            U14 : mux port map
            (
            i_sig0 => s_l1(i),
            i_sig1 => s_l1(i-2),
            i_sel => i_s(1),
            o_sig => s_l2(i)
            );
        end generate;
    end generate;
     
    gen_layer3_mux : for i in 0 to 15 generate
        mux_lower1 : if i = 0 generate
            L1 : mux port map
            (
            i_sig0 => s_l2(i),
            i_sig1 => '0',
            i_sel => i_s(0),
            o_sig => s_l3(i)
            );
        end generate;
        mux_upper15 : if i > 0 generate
            U15 : mux port map
            (
            i_sig0 => s_l2(i),
            i_sig1 => s_l2(i-1),
            i_sel => i_s(0),
            o_sig => s_l3(i)
            );
        end generate;
    end generate;

    o_r <= s_l3;
    o_c <= '0';
end architecture;
