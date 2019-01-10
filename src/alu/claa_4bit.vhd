------------------------------------------------------------
-- A 4-bit CLA adder (carry lookahead)
-- Author: Aaron Moser
-- Date: 10.01.2019
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity claa_4bit is
    port
    (
    opai : in std_logic_vector(3 downto 0);
    opbi : in std_logic_vector(3 downto 0);
    ci : in std_logic;
    eo : out std_logic_vector(3 downto 0);
    po : out std_logic;
    go : out std_logic;
    co : out std_logic
    );
end entity;

architecture behaviour of claa_4bit is
    -- Components
    component full_adder
        port
        (
        opai, opbi, ci: in std_logic;
        eo,   go,   po: out std_logic
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
    signal e_vec: std_logic_vector(3 downto 0);
    signal p_vec: std_logic_vector(3 downto 0);
    signal g_vec: std_logic_vector(3 downto 0);
    signal c_vec: std_logic_vector(3 downto 0);
begin
    -- Instantiate the components
    gen_adder : for i in 0 to 3 generate
        lsb_adder : if i=0 generate
            A0 : full_adder port map
            (
            opai => opai(i),
            opbi => opbi(i),
            ci   => ci,
            eo   => e_vec(i),
            go   => g_vec(i),
            po   => p_vec(i)
            );
        end generate lsb_adder;

        adder : if i>0 generate
            AX : full_adder port map
                (
                opai => opai(i),
                opbi => opbi(i),
                ci   => c_vec(i-1),
                eo   => e_vec(i),
                go   => g_vec(i),
                po   => p_vec(i)
                );
        end generate adder;
    end generate gen_adder;

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
