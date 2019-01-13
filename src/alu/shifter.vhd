library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
    port
    (
    i_sig : in std_logic_vector(1 downto 0);
    i_sel : in std_logic;
    o_sig : out std_logic
    );
end entity;

architecture behaviour of mux is
begin
    o_sig <= i_sig(0) when i_sel='0' else
             i_sig(1) when i_sel='1';
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
        i_sig : in std_logic_vector(15 downto 0);
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

    gen_layer0_mux : for i in 15 to 0 generate
        mux_lower8 : if i <= 7 generate
            L8 : mux port map
            (
            i_sig => '0' & i_sig(i),
            i_sel => i_s(3),
            o_sig => s_l0(i)
            );
        end generate;
        mux_upper8 : if i > 7 generate
            U8 : mux port map
            (
            i_sig => i_sig(i-8) & i_sig(i),
            i_sel => i_s(3),
            o_sig => s_l0(i)
            );
        end generate;
    end generate;

    gen_layer1_mux : for i in 15 to 0 generate
        mux_lower4 : if i <= 3 generate
            L4 : mux port map
            (
            i_sig => '0' & s_l0(i),
            i_sel => i_s(2),
            o_sig => s_l1(i)
            );
        end generate;
        mux_upper12 : if i > 3 generate
            U12 : mux port map
            (
            i_sig => s_l0(i-4) & s_l0(i),
            i_sel => i_s(2),
            o_sig => s_l1(i)
            );
        end generate;
    end generate;

    gen_layer2_mux : for i in 15 to 0 generate
        mux_lower2 : if i <= 1 generate
            L2 : mux port map
            (
            i_sig => '0' & s_l1(i),
            i_sel => i_s(1),
            o_sig => s_l2(i)
            );
        end generate;
        mux_upper14 : if i > 1 generate
            U14 : mux port map
            (
            i_sig => s_l1(i-2) & s_l1(i),
            i_sel => i_s(1),
            o_sig => s_l2(i)
            );
        end generate;
    end generate;
     
    gen_layer3_mux : for i in 15 to 0 generate
        mux_lower1 : if i = 0 generate
            L1 : mux port map
            (
            i_sig => '0' & s_l2(i),
            i_sel => i_s(0),
            o_sig => s_l3(i)
            );
        end generate;
        mux_upper15 : if i > 0 generate
            U15 : mux port map
            (
            i_sig => s_l2(i-1) & s_l2(i),
            i_sel => i_s(0),
            o_sig => s_l3(i)
            );
        end generate;
    end generate;

    -- shift_proc : process(all)
    -- begin
    --     if i_ctrl='0' then
    --         carry <= i_op(15);
    --         shift <= std_logic_vector(shift_left(unsigned(i_op), to_integer(unsigned(i_s))));
    --     else
    --         carry <= i_op(0);
    --         shift <= std_logic_vector(shift_right(unsigned(i_op), to_integer(unsigned(i_s))));
    --     end if;
    -- end process;

    o_r <= s_l3;
    o_c <= '0';
end architecture;
