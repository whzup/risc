------------------------------------------------------------
-- A 16-bit CLA adder (carry lookahead)
-- Author: Aaron Moser
-- Date: 10.01.2019
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity claa_16bit is
    port
    (
    opai: in std_logic_vector(15 downto 0);
    opbi: in std_logic_vector(15 downto 0);
    ci:   in std_logic;
    eo:   out std_logic_vector(15 downto 0);
    po:   out std_logic;
    go:   out std_logic;
    co:   out std_logic
    );
end entity;

architecture behaviour of claa_16bit is
    -- Components
    component claa_4bit
        port
        (
        opai, opbi: in std_logic_vector(3 downto 0);
        ci:         in std_logic;
        eo:         out std_logic_vector(3 downto 0);
        po, go, co: out std_logic
        );
    end component;

    component lcu
        port
        (
        ci:       in std_logic;
        pi, gi:   in std_logic_vector(3 downto 0);
        co:       out std_logic_vector(3 downto 0);
        pgo, ggo: out std_logic
        );
    end component;

    -- Signals
    signal e_vec: std_logic_vector(15 downto 0);
    signal p_vec: std_logic_vector(3 downto 0);
    signal g_vec: std_logic_vector(3 downto 0);
    signal c_vec: std_logic_vector(3 downto 0);

begin
    gen_claa : for i in 0 to 3 generate
        lsb_claa : if i=0 generate
            A0 : claa_4bit port map
                (
                opai => opai(4*i+3 downto 4*i),
                opbi => opbi(4*i+3 downto 4*i),
                ci   => ci,
                eo   => e_vec(4*i+3 downto 4*i),
                go   => g_vec(i),
                po   => p_vec(i)
                );
        end generate lsb_claa;

        claa : if i>0 generate
            AX : claa_4bit port map
                (
                opai => opai(4*i+3 downto 4*i),
                opbi => opbi(4*i+3 downto 4*i),
                ci   => c_vec(i-1),
                eo   => e_vec(4*i+3 downto 4*i),
                go   => g_vec(i),
                po   => p_vec(i)
                );
        end generate claa;
    end generate gen_claa;

    lcu_inst : lcu port map
    (
    ci  => ci,
    pi  => p_vec,
    gi  => g_vec,
    co  => c_vec,
    pgo => po,
    ggo => go
    );

    eo <= e_vec;
    co <= c_vec(3);
end architecture behaviour;
