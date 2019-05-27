------------------------------------------------------------
-- Title:       ALU
-- Description: A simple ALU
-- Author:      Aaron Moser
-- Date:        23.01.2019
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity alu is
  port
    (
      i_op1   : in  std_logic_vector(15 downto 0);
      i_op2   : in  std_logic_vector(15 downto 0);
      i_opc   : in  std_logic_vector(4 downto 0);
      i_clk   : in  std_logic;
      o_res   : out std_logic_vector(15 downto 0);
      o_flags : out std_logic_vector(3 downto 0) -- Z F C N
      );
end entity;

architecture behaviour of alu is
  -- Adder
  component brent_kung_adder
    port
      (
        i_op1   : in  std_logic_vector(15 downto 0);
        i_op2   : in  std_logic_vector(15 downto 0);
        i_c     : in  std_logic;
        o_res   : out std_logic_vector(15 downto 0);
        o_flags : out std_logic_vector(3 downto 0)
        );
  end component;

  -- Logic Unit
  component lu
    port
      (
        i_op1 : in  std_logic_vector(15 downto 0);
        i_op2 : in  std_logic_vector(15 downto 0);
        i_and : in  std_logic;
        i_or  : in  std_logic;
        i_xor : in  std_logic;
        i_not : in  std_logic;
        o_res : out std_logic_vector(15 downto 0);
        o_flags : out std_logic_vector(3 downto 0)
        );
  end component;

  -- Shifter
  component shifter
    port
      (
        i_op    : in  std_logic_vector(15 downto 0);
        i_s     : in  std_logic_vector(3 downto 0);
        i_dir   : in  std_logic;
        i_rot   : in  std_logic;
        i_ar    : in  std_logic;
        o_res   : out std_logic_vector(15 downto 0);
        o_flags : out std_logic_vector(3 downto 0)
        );
  end component;

  -- Mulitplier
  component dadda_mult
    port
      (
        i_op1 : in  std_logic_vector(15 downto 0);
        i_op2 : in  std_logic_vector(15 downto 0);
        o_op1 : out std_logic_vector(31 downto 0);
        o_op2 : out std_logic_vector(31 downto 0)
        );
  end component;

  -- Decoder
  component op_decoder
    port
      (
        i_opc  : in  std_logic_vector(4 downto 0);
        o_add  : out std_logic;
        o_sub  : out std_logic;
        o_and  : out std_logic;
        o_or   : out std_logic;
        o_xor  : out std_logic;
        o_not  : out std_logic;
        o_dir  : out std_logic;
        o_rot  : out std_logic;
        o_ar   : out std_logic;
        o_mult : out std_logic
        );
  end component;

  -- Adder signals
  signal add_vec   : std_logic_vector(15 downto 0);
  signal inv_vec   : std_logic_vector(15 downto 0);
  signal sub_flag  : std_logic;
  signal add_res   : std_logic_vector(15 downto 0);
  signal add_flag  : std_logic;

  -- LU signals
  signal lu_res : std_logic_vector(15 downto 0);
  signal lu_and : std_logic;
  signal lu_or  : std_logic;
  signal lu_xor : std_logic;
  signal lu_not : std_logic;
  signal lu_flag : std_logic;

  -- Shifter signals
  signal shift  : std_logic_vector(3 downto 0);
  signal sh_res : std_logic_vector(15 downto 0);
  signal sh_dir : std_logic;
  signal sh_rot : std_logic;
  signal sh_ar  : std_logic;
  signal sh_flag : std_logic;

  -- Multiplier signal
  signal mul_op1 : std_logic_vector(31 downto 0);
  signal mul_op2 : std_logic_vector(31 downto 0);
  signal mul_flag : std_logic;

  -- Flags
  signal lu_flags : std_logic_vector(3 downto 0);
  signal sh_flags : std_logic_vector(3 downto 0);
  signal add_flags : std_logic_vector(3 downto 0);

  signal res : std_logic_vector(15 downto 0);
begin
  -- Instantiate the components
  bk_inst : brent_kung_adder port map
    (
      i_op1 => add_vec,
      i_op2 => inv_vec,
      i_c   => sub_flag,
      o_res => add_res,
      o_flags => add_flags
      );

  lu_int : lu port map
    (
      i_op1 => i_op1,
      i_op2 => i_op2,
      i_and => lu_and,
      i_or  => lu_or,
      i_xor => lu_xor,
      i_not => lu_not,
      o_res => lu_res,
      o_flags => lu_flags
      );

  shifter_inst : shifter port map
    (
      i_op  => i_op1,
      i_s   => shift,
      i_dir => sh_dir,
      i_rot => sh_rot,
      i_ar  => sh_ar,
      o_res => sh_res,
      o_flags => sh_flags
      );

  mult_inst : dadda_mult port map
    (
      i_op1 => i_op1,
      i_op2 => i_op2,
      o_op1 => mul_op1,
      o_op2 => mul_op2
      );

  decoder_inst : op_decoder port map
    (
      i_opc  => i_opc,
      o_add  => add_flag,
      o_sub  => sub_flag,
      o_and  => lu_and,
      o_or   => lu_or,
      o_xor  => lu_xor,
      o_not  => lu_not,
      o_dir  => sh_dir,
      o_rot  => sh_rot,
      o_ar   => sh_ar,
      o_mult => mul_flag
      );
  
  lu_flag <= '1' when lu_and = '1' or lu_or = '1' or lu_xor = '1' or lu_not = '1' else '0';
  sh_flag <= '1' when sh_dir = '1' or sh_rot = '1' or sh_ar = '1' else '0';
  shift <= i_op2(3 downto 0);

  add_proc : process(all)
  begin
    for i in 0 to 15 loop
      if sub_flag = '1' and mul_flag = '0' then
        inv_vec(i) <= not i_op2(i);
      elsif mul_flag = '1' and sub_flag = '0' then
        inv_vec(i) <= mul_op2(i);
        add_vec(i) <= mul_op1(i);
      else
        add_vec(i) <= i_op1(i);
      end if;
    end loop;
  end process;

  flag_proc : process(all)
  begin
      if sub_flag = '1' or add_flag = '1' or mul_flag = '1' then
          o_flags <= add_flags;
      elsif lu_or = '1' or lu_and = '1' or lu_xor = '1' or lu_not = '1' then
          o_flags <= lu_flags;
      elsif sh_dir = '1' or sh_rot = '1' or sh_ar = '1' then
          o_flags <= sh_flags;
      else
          o_flags <= "0000";
      end if;
  end process;

  sync_proc : process(all)
  begin
    if rising_edge(i_clk) then
      if add_flag = '1' or sub_flag = '1' or mul_flag = '1' then
        o_res <= add_res;
      elsif lu_flag = '1' then
        o_res <= lu_res;
      elsif sh_flag = '1' then
        o_res <= sh_res;
      end if;
    end if;
  end process;

end architecture;

-- Decoder
library ieee;
use ieee.std_logic_1164.all;

entity op_decoder is
port
    (
    i_opc  : in  std_logic_vector(4 downto 0);
    o_add  : out std_logic;
    o_sub  : out std_logic;
    o_and  : out std_logic;
    o_or   : out std_logic;
    o_xor  : out std_logic;
    o_not  : out std_logic;
    o_dir  : out std_logic;
    o_rot  : out std_logic;
    o_ar   : out std_logic;
    o_mult : out std_logic
    );
end entity;

architecture behaviour of op_decoder is
begin
o_sub  <= '1' when i_opc = "10000" else '0';
o_add  <= '1' when i_opc = "10001" else '0';
o_and  <= '1' when i_opc = "10010" else '0';
o_or   <= '1' when i_opc = "10011" else '0';
o_xor  <= '1' when i_opc = "10100" else '0';
o_not  <= '1' when i_opc = "10101" else '0';
o_dir  <= '1' when i_opc = "10110" or i_opc = "10111" or i_opc = "11000" else '0';
o_rot  <= '1' when i_opc = "10111" or i_opc = "11010" else '0';
o_ar   <= '1' when i_opc = "11000" or i_opc = "11011" else '0';
o_mult <= '1' when i_opc = "11100" else '0';
end architecture;
