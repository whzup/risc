--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;

--package dadda_utils is
--end package;
--
--package body dadda_utils is
--end package body;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
--use work.dadda_utils.all

entity dadda_mult is
    port
    (
      i_op1 : in std_logic_vector(15 downto 0);
      i_op2 : in  std_logic_vector(15 downto 0);
      o_op1 : out std_logic_vector(31 downto 0);
      o_op2 : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behaviour of dadda_mult is
    type nat_arr is array(integer range <>) of natural;
    constant stages : natural := 7;
    constant const_height : nat_arr(30 downto 0) := (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1);
    type t_tree is array(30 downto 0, 17 downto 0, stages-1 downto 0) of std_logic;
    constant max_height : nat_arr(stages-2 downto 0) := (2, 3, 4, 6, 9, 13);


    signal tree : t_tree;
    signal op1 : std_logic_vector(15 downto 0);
    signal op2 : std_logic_vector(15 downto 0);
begin

    op1 <= i_op1;
    op2 <= i_op2;
    dadda_proc : process(all)
        variable prod : std_logic;
        variable comp_count : natural;
        variable ha_flag : natural;
        variable a : std_logic;
        variable b : std_logic;
        variable c : std_logic;
        variable height : nat_arr(30 downto 0);
    begin
        -- Initialize
        for i in 15 downto 0 loop
            for j in 15 downto 0 loop
                prod := op1(i) and op2(j);
                if i+j < 15 then
                    tree(i+j, i, 0) <= prod;
                elsif i+j >= 15 then
                    tree(i+j, 15-i, 0) <= prod;
                end if;
            end loop;
        end loop;

        height := const_height;

        for k in 0 to stages-2 loop
            for i in 0 to 30 loop
                -- The height is already less than the maximal stage height
                if height(i) <= max_height(k) then
                    for j in 0 to height(i)-1 loop
                        tree(i,j,k+1) <= tree(i,j,k);
                    end loop;
                -- The height is max_height+1 -> apply a half adder
                elsif height(i) = max_height(k) + 1 then
                    -- Halfadder
                    tree(i+1,height(i+1),k) <= tree(i,0,k) and tree(i,1,k); -- carry
                    tree(i,0,k+1) <= tree(i,0,k) xor tree(i,1,k); -- result
                    -- Shift the rest down
                    for j in 0 to height(i)-1 loop
                        tree(i,j+1,k+1) <= tree(i,j+2,k);
                    end loop;
                    -- Adjust heights
                    height(i) := height(i) - 1;
                    height(i+1) := height(i+1) + 1;
                else
                    comp_count := 0;
                    ha_flag := 0;
                    while (height(i) > max_height(k)) loop
                        if height(i) = max_height(k) + 1 then
                            -- Half adder
                            tree(i+1,height(i+1),k)  <= tree(i,3*comp_count,k) and tree(i,3*comp_count+1,k); -- carry
                            tree(i,comp_count,k+1) <= tree(i,3*comp_count,k) xor tree(i,3*comp_count+1,k); -- result
                            -- Adjust heights
                            height(i)   := height(i) - 1;
                            height(i+1) := height(i+1) + 1;
                            ha_flag     := 1;
                        else
                            a := tree(i,3*comp_count,k);
                            b := tree(i,3*comp_count+1,k);
                            c := tree(i,3*comp_count+2,k);
                            -- Full adder
                            tree(i+1,height(i+1),k) <= (a and b) or (c and (a xor b)); -- carry
                            tree(i,comp_count,k+1)    <= a xor b xor c; --result
                            -- Adjust heights and counter
                            height(i)   := height(i) - 2;
                            height(i+1) := height(i+1) + 1;
                            comp_count  := comp_count + 1;
                        end if;
                        -- Shift the rest down
                        if ha_flag = 1 then
                            for j in 0 to 17-(3*comp_count+2) loop
                                tree(i,j+comp_count+1,k+1) <= tree(i,j+(3*comp_count+2),k);
                            end loop;
                        else
                            for j in 0 to 17-(3*comp_count) loop
                                tree(i,j+comp_count,k+1) <= tree(i,j+(3*comp_count),k);
                            end loop;
                        end if;
                    end loop;
                end if;
            end loop;
        end loop;
        tree(0,1,6) <= '0';
    end process;

    output_proc : process(tree)
    begin
        for i in 0 to 30 loop
            o_op1(i) <= tree(i,0,stages-1);
            o_op2(i) <= tree(i,1,stages-1);
        end loop;
        o_op1(31) <= '0';
        o_op2(31) <= '0';
    end process;
end architecture;
