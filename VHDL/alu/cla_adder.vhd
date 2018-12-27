-- Carry Look Ahead Adder
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cla_adder is
    port
    (
    op1_in : in std_logic_vector(15 downto 0);
    op2_in : in std_logic_vector(15 downto 0);
    sum_out : out std_logic_vector(15 downto 0);
    carry_out : out std_logic
    );
end entity cla_adder;

architecture behaviour of cla_adder is
signal gen_vec : std_logic_vector(16 downto 0);
signal prop_vec : std_logic_vector(16 downto 0);
signal carry_vec : std_logic_vector(16 downto 0);
signal sum_vec : std_logic_vecotr(15 downto 0);

begin

-- calculate propagation p[i, i] and generation g[i, i] values
prop_gen_layer_0 : process(all)
begin
    for i in 0 to 15 loop
        gen_vec(i+1) <= op1_in(i) and op2_in(i);
        prop_vec(i+1) <= op1_in(i) or op2_in(i);
    end loop;
end process prop_gen_layer_0;

-- calculate second layer of propagation and generation
prop_gen_layer_1 : process(all)
    variable TMP : integer range 0 to 16;
begin
    for h in 1 to 8 loop
        TMP := 2*h;
        while (TMP <= 16) loop
            gen_vec(TMP) <= gen_vec(TMP) or (gen_vec(TMP-h) and prop_vec(TMP));
            prop_vec(TMP) <= prop_vec(TMP) and prop_vec(TMP-h);
        end loop;
    end loop;
end process prop_gen_layer_1;

-- calculate carry bits
carry : process(all)
    variable TMP_1 : integer := 8;
    variable TMP_2 : integer range 0 to 16;
begin
    while (TMP_1 >= 1) loop
        TMP_2 := TMP_1;
        while (TMP_2 <= 16) loop
            carry_vec(TMP_2) <= gen_vec(TMP_2) or (carry_vec(TMP_2 - TMP_1) and prop_gen(TMP_2));
            TMP_2 := 2*TMP_1;
        end loop;
    end loop;
end process carry;

-- calculate sum bits
sum : process(all)
begin
    for i in 0 to 14 loop
        sum_vec(i) <= op1_in(i) xor op2_in(i) xor carry_vec(i);
    end loop;
end process sum;

sum_vec(15) <= carry_vec(15);
sum_out <= sum_vec;

end architecture behaviour;
