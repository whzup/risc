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
    generic
    (
        width : natural := 1
    );
    port
    (
    i_sig0 : in std_logic_vector(width-1 downto 0);
    i_sig1 : in std_logic_vector(width-1 downto 0);
    i_sel : in std_logic;
    o_sig : out std_logic_vector(width-1 downto 0)
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
    i_dir: in std_logic; -- direction 0 left 1 right
    i_rot: in std_logic; -- rotate
    i_ar:  in std_logic; -- arithmetic shift
    o_r:   out std_logic_vector(15 downto 0); -- result
    o_f:   out std_logic; -- overflow flag
    o_z:   out std_logic  -- zero flag
    );

    function reverse_vector(a: in std_logic_vector)
    return std_logic_vector is variable res : std_logic_vector(a'range);
        alias aa: std_logic_vector(a'reverse_range) is a;
    begin
        for i in aa'range loop
            res(i) := aa(i);
        end loop;
        return res;
    end function;

end entity;

architecture behaviour of shifter is
    component mux is
        generic
        (
        width : natural
        );
        port
        (
        i_sig0: in std_logic_vector(width-1 downto 0);
        i_sig1: in std_logic_vector(width-1 downto 0);
        i_sel:  in std_logic;
        o_sig:  out std_logic_vector(width-1 downto 0)
        );
    end component;

    signal shift: std_logic_vector(15 downto 0);
    signal carry: std_logic;

    -- Reverse signals
    signal rev_0: std_logic_vector(15 downto 0);
    signal rev_0_8: std_logic_vector(7 downto 0);
    signal rev_0_4: std_logic_vector(3 downto 0);
    signal rev_0_2: std_logic_vector(1 downto 0);
    signal rev_1: std_logic_vector(15 downto 0);
    
    -- Rotation signals
    signal rot_0: std_logic_vector(15 downto 0);
    signal rot_1: std_logic_vector(15 downto 0);
    signal rot_2: std_logic_vector(15 downto 0);
    signal rot_3: std_logic_vector(15 downto 0);

    -- Shifting signals
    signal s_l0: std_logic_vector(15 downto 0);
    signal s_l1: std_logic_vector(15 downto 0);
    signal s_l2: std_logic_vector(15 downto 0);
    signal s_l3: std_logic_vector(15 downto 0);

    -- Arithmetic shifting
    signal s : std_logic;
    signal s_2 : std_logic_vector(1 downto 0);
    signal s_4 : std_logic_vector(3 downto 0);
    signal s_8 : std_logic_vector(7 downto 0);
    signal s_tmp : std_logic;
    signal sl : std_logic;
    signal sr : std_logic;

    -- Overflow detection
    signal of_mux_out0 : std_logic_vector(7 downto 0);
    signal of_mux_out1 : std_logic_vector(3 downto 0);
    signal of_mux_out2 : std_logic_vector(1 downto 0);
    signal of_mux_out3 : std_logic;
begin
    s_8 <= (others => s);
    s_4 <= (others => s);
    s_2 <= (others => s);

    sl <= i_dir and i_ar;
    sr <= not i_dir and i_ar;

    rev_0_8 <= (others => rev_0(0));
    rev_0_4 <= (others => rev_0(0));
    rev_0_2 <= (others => rev_0(0));

    -- Generate Multiplexer layers
    -- Reverse the bit order for a right shift
    rev0_mux : mux
    generic map
        (
        width => 16
        )
    port map
        (
        i_sig0 => i_op,
        i_sig1 => reverse_vector(i_op),
        i_sel => i_dir,
        o_sig => rev_0
        );

    -- Arithmetic right shifting
    arith_mux : mux
    generic map
        (
        width => 1
        )
    port map
        (
        i_sig1(0) => '0',
        i_sig0(0) => rev_0(15),
        i_sel => sr,
        o_sig(0) => s
        );

    -- Zeroth rotation layer
    rot_l0_mux : mux
    generic map
        (
        width => 8
        )
    port map
        (
        i_sig0 => s_8,
        i_sig1 => rev_0(15 downto 8),
        i_sel => i_rot,
        o_sig => rot_0(15 downto 8)
        );

    rot_0(7 downto 0) <= rev_0(7 downto 0);

    -- 8-bit shift
    mux_lower8 : mux
    generic map
        (
        width => 8
        )
    port map
        (
        i_sig0 => rot_0(7 downto 0),
        i_sig1 => "00000000",
        i_sel  => i_s(3),
        o_sig  => s_l0(7 downto 0)
        );

    mux_upper8 : mux
    generic map
        (
        width => 8
        )
    port map
        (
        i_sig0 => rot_0(15 downto 8),
        i_sig1 => i_op(7 downto 0),
        i_sel  => i_s(3),
        o_sig  => s_l0(15 downto 8)
        );

    -- First rotation layer
    rot_l1_mux : mux
    generic map
        (
        width => 4
        )
    port map
        (
        i_sig0 => s_4,
        i_sig1 => s_l0(15 downto 12),
        i_sel => i_rot,
        o_sig => rot_1(15 downto 12)
        );

    rot_1(11 downto 0) <= s_l0(11 downto 0);

    -- 4-bit shift
    mux_lower4 : mux
    generic map
        (
        width => 4
        )
    port map
        (
        i_sig0 => rot_1(3 downto 0),
        i_sig1 => "0000",
        i_sel  => i_s(2),
        o_sig  => s_l1(3 downto 0)
        );

    mux_upper12 : mux
    generic map
        (
        width => 12
        )
    port map
        (
        i_sig0 => rot_1(15 downto 4),
        i_sig1 => rot_1(11 downto 0),
        i_sel  => i_s(2),
        o_sig  => s_l1(15 downto 4)
        );

        -- Second rotation layer
    rot_l2_mux : mux
    generic map
        (
        width => 2
        )
    port map
        (
        i_sig0 => s_2,
        i_sig1 => s_l1(15 downto 14),
        i_sel => i_rot,
        o_sig => rot_2(15 downto 14)
        );

    rot_2(13 downto 0) <= s_l1(13 downto 0);

        -- 2-bit shift
    mux_lower2 : mux
    generic map
        (
        width => 2
        )
    port map
        (
        i_sig0 => rot_2(1 downto 0),
        i_sig1 => "00",
        i_sel  => i_s(1),
        o_sig  => s_l2(1 downto 0)
        );

    mux_upper14 : mux
    generic map
        (
        width => 14
        )
    port map
        (
        i_sig0 => rot_2(15 downto 2),
        i_sig1 => rot_2(13 downto 0),
        i_sel  => i_s(1),
        o_sig  => s_l2(15 downto 2)
        );

    -- Third rotation layer
    rot_l3_mux : mux
    generic map
        (
        width => 1
        )
    port map
        (
        i_sig0(0) => s,
        i_sig1(0) => s_l2(15),
        i_sel => i_rot,
        o_sig(0) => rot_3(15)
        );

    rot_3(14 downto 0) <= s_l2(14 downto 0);
     
        -- 1-bit shift
    mux_lower1 : mux
    generic map
        (
        width => 1
        )
    port map
        (
        i_sig0(0) => rot_3(0),
        i_sig1(0) => '0',
        i_sel  => i_s(0),
        o_sig(0)  => s_tmp
        );

    mux_upper15 : mux
    generic map
        (
        width => 15
        )
    port map
        (
        i_sig0 => rot_3(15 downto 1),
        i_sig1 => rot_3(14 downto 0),
        i_sel  => i_s(0),
        o_sig  => s_l3(15 downto 1)
        );

    sla_mux : mux
    -- Arithmetic left shifting
    generic map
        (
        width => 1
        )
    port map
        (
        i_sig0(0) => s_tmp,
        i_sig1(0) => rev_0(0),
        i_sel => sl,
        o_sig(0) => s_l3(0)
        );

    -- Reverse the bit order again
    rev1_mux : mux
    generic map
        (
        width => 16
        )
    port map
        (
        i_sig0 => s_l3(15 downto 0),
        i_sig1 => reverse_vector(s_l3),
        i_sel => i_dir,
        o_sig => rev_1(15 downto 0)
        );

    -- Overflow detection
    of0_mux : mux
    generic map
        (
        width => 8
        )
    port map
        (
        i_sig0 => rev_0_8,
        i_sig1 => rev_0(8 downto 1),
        i_sel => i_s(3),
        o_sig => of_mux_out0(7 downto 0)
        );

    of1_mux : mux
    generic map
        (
        width => 4
        )
    port map
        (
        i_sig0 => rev_0_4,
        i_sig1 => s_l0(4 downto 1),
        i_sel => i_s(2),
        o_sig => of_mux_out1(3 downto 0)
        );

    of2_mux : mux
    generic map
        (
        width => 2
        )
    port map
        (
        i_sig0 => rev_0_2,
        i_sig1 => s_l1(2 downto 1),
        i_sel => i_s(1),
        o_sig => of_mux_out2(1 downto 0)
        );

    of3_mux : mux
    generic map
        (
        width => 1
        )
    port map
        (
        i_sig0(0) => rev_0(0),
        i_sig1(0) => s_l2(1),
        i_sel => i_s(0),
        o_sig(0) => of_mux_out3
        );

    overflow_proc : process(all)
        variable xor_out0 : std_logic_vector(7 downto 0);
        variable xor_out1 : std_logic_vector(3 downto 0);
        variable xor_out2 : std_logic_vector(1 downto 0);
        variable xor_out3 : std_logic;

        variable xor_in0 : std_logic_vector(7 downto 0) := (others => rev_0(0));
        variable xor_in1 : std_logic_vector(3 downto 0) := (others => rev_0(0));
        variable xor_in2 : std_logic_vector(1 downto 0) := (others => rev_0(0));

        variable of_tmp0 : std_logic := '1';
        variable of_tmp1 : std_logic := '1';
        variable of_tmp2 : std_logic := '1';
        variable of_tmp3 : std_logic := '1';

        variable and_red : std_logic;
    begin
        xor_out0 := of_mux_out0 xor xor_in0;
        xor_out1 := of_mux_out1 xor xor_in1;
        xor_out2 := of_mux_out2 xor xor_in2;
        xor_out3 := of_mux_out3 xor rev_0(0);

        for i in xor_out0'range loop
            of_tmp0 := of_tmp0 and xor_out0(i);
        end loop;
        for i in xor_out1'range loop
            of_tmp1 := of_tmp1 and xor_out1(i);
        end loop;
        for i in xor_out2'range loop
            of_tmp2 := of_tmp2 and xor_out2(i);
        end loop;
        of_tmp3 := xor_out3;

        and_red := of_tmp0 and of_tmp1 and of_tmp2 and of_tmp3;
        o_f <= sl and and_red;
    end process;

    o_r <= rev_1;
    o_z <= '1' when rev_1="0000000000000000" else '0';
end architecture;
