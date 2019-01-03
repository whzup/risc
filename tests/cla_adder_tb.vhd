library ieee;
use ieee.std_logic_1164.all;

entity cla_adder_tb is
end cla_adder_tb;

architecture behaviour of cla_adder_tb is
    signal op1_in : std_logic_vector(15 downto 0);
    signal op2_in : std_logic_vector(15 downto 0);
    signal sum_out : std_logic_vector(15 downto 0);
    signal carry_out : std_logic;

    component cla_adder
        port
        (
            op1_in : in std_logic_vector(15 downto 0);
            op2_in : in std_logic_vector(15 downto 0);
            sum_out : out std_logic_vector(15 downto 0);
            carry_out : out std_logic
        );
    end component;

    for adder_0: cla_adder use entity work.cla_adder;
    signal op1_in, op2_in, sum_out : std_logic_vector(15 downto 0);
    signal carry_out : std_logic;

begin
    adder_0: cla_adder port map
    (
        op1_in => op1_in,
        op2_in => op2_in,
        sum_out => sum_out,
        carry_out => carry_out
    );

    process
        type pattern_type is record
            op1_in, op2_in : std_logic_vector(15 downto 0);
            sum_out : std_logic_vector(15 downto 0);
            carry_out : std_logic;
        end record;

        type pattern_array is array (natural range <>) of pattern_type;
        constant patterns : pattern_array :=
            (
                ("0000000000000000", "0000000000000000", "0000000000000000", '0'),
                ("0000000000000001", "1111111111111111", "0000000000000000", '1'),
                ("1111111111111111", "0000000000000001", "0000000000000000", '1'),
                ("0000000000000000", "0000000000000000", "0000000000000000", '0'),
                ("0000000000000000", "0000000000000000", "0000000000000000", '0'),
                ("0000000000000000", "0000000000000000", "0000000000000000", '0'),
                ("0000000000000000", "0000000000000000", "0000000000000000", '0'),
                ("0000000000000000", "0000000000000000", "0000000000000000", '0')
            );
    begin
        for i in patterns'range loop
            op1_in <= patterns(i).op1_in;
            op2_in <= patterns(i).op2_in;
            wait for 1 ns;
            assert sum_out = patterns(i).sum_out;
                report "Bad sum value" severity error;
            assert carry_out = patterns(i).carry_out;
                report "Bad carry value" severity error;
        end loop;
        assert false report "end of test" severity note;
        wait;
    end process;
end architecture behaviour;

