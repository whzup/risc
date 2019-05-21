------------------------------------------------------------
-- Title:       Brent-Kung-Adder
-- Description: 
-- Author:      Aaron Moser
-- Date:        20.05.2019
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity brent_kung_adder is
  port
    (
      i_op1 : in std_logic_vector(15 downto 0);
      i_op2   : in  std_logic_vector(15 downto 0);
      i_c     : in  std_logic;
      o_res   : out std_logic_vector(15 downto 0);
      o_flags : out std_logic_vector(3 downto 0)
    );
end entity;

architecture behaviour of brent_kung_adder is

  constant stages : natural := 8;
  constant ct_stages : natural := 5;
  constant ict_stages : natural := 3;

  type t_tree is array(15 downto 0, stages-1 downto 0) of std_logic_vector(1 downto 0);
  
  signal carry_tree : t_tree;
  signal g_vec : std_logic_vector(15 downto 0);
  signal p_vec : std_logic_vector(15 downto 0);
  signal sum   : std_logic_vector(15 downto 0);

  signal add_z : std_logic;
  signal add_f : std_logic;
  signal add_c : std_logic;
  signal add_n : std_logic;

  function circ_op(g : in std_logic_vector(1 downto 0);
                   p : in std_logic_vector(1 downto 0)) return std_logic_vector is
    variable tmp1 : std_logic;
    variable tmp2 : std_logic;
    variable res : std_logic_vector(1 downto 0);
  begin
    tmp1 := g(0) or (p(0) and g(1));
    tmp2 := p(0) and p(1);
    res := tmp1 & tmp2;
    return res;
  end function;

begin

  carry_proc : process(all)
  begin

    g_vec(0) <= (i_op1(0) and i_op2(0)) or (i_c and (i_op1(0) xor i_op2(0)));
    p_vec(0) <= i_op1(0) xor i_op2(0) xor i_c;
    for i in 1 to 15 loop
      g_vec(i) <= i_op1(i) and i_op2(i);
      p_vec(i) <= i_op1(i) xor i_op2(i);
    end loop;

    -- Carry Tree
    for k in 0 to ct_stages-1 loop
      for i in 0 to 15 loop
        -- Leaves
        if k = 0 then
          carry_tree(i,0) <= g_vec(i) & p_vec(i);
        else
          if (i mod 2**k = 2**k-1) then
            if 2**k-1 >= 0 then
              carry_tree(i,k) <= circ_op(carry_tree(i,k-1), carry_tree(i-2**k+1,k-1));
            else
              carry_tree(i,k) <= carry_tree(i,k-1);
            end if;
          else
            carry_tree(i,k) <= carry_tree(i,k-1);
          end if;
        end if;
      end loop;
    end loop;

    -- Inverse Carry Tree
    for k in ct_stages to stages-1 loop
      for i in 0 to 15 loop
        if (i-2**(stages-k) mod 2**(stages-k+1) = 2**(stages-k+1)-1) then
          if i-2**(stages-k) >= 0 then
            carry_tree(i,k) <= circ_op(carry_tree(i,k-1), carry_tree(i-2**(stages-k),k-1));
          else
            carry_tree(i,k) <= carry_tree(i,k-1);
          end if;
        else
          carry_tree(i,k) <= carry_tree(i,k-1);
        end if;
      end loop;
    end loop;

  end process;

  sum_proc : process(all)
  begin
    sum(0) <= carry_tree(0,0)(1);
    for i in 1 to 15 loop
      sum(i) <= carry_tree(i,0)(1) xor carry_tree(i-1,stages-1)(0);
    end loop;
  end process;

  add_z <= '1' when sum = "0000000000000000" else '0';
  add_f <= '1' when (i_op1(15) and i_op2(15) and not sum(15)) or
           (not i_op1(15) and not i_op2(15) and sum(15)) else '0';
  add_n <= '1' when sum(15) = '1' else '0';
  add_c <= carry_tree(15,stages-1)(1);

  o_flags <= add_z & add_f & add_c & add_n;
  o_res <= sum;
end architecture; 