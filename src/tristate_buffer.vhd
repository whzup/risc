library ieee;
use ieee.std_logic_1164.all;

entity tristate_buf is
--port definition
port(
	clk		 : in std_logic;
	reset_n  : in std_logic;
	enable_n : in std_logic;
	d_in  : in std_logic;
	d_out : out std_logic;
	);
end tristate_buf;

architecture behaviour of tristate_buf is
--signale
signal data, next_data	: std_logic;

begin

	flip_flops: process(all)
	begin
		if reset_n = '0' then
			data <= '0';
		elsif rising_edge(clk) then
			data <= next_data;
		end if;
	
	end process flip_flops;
	
	buffer_logic: process(all)
	begin
		next_data <= d_in;
	
		if enable_n = '0' then
			d_out <= data;
		else 
			d_out <= 'Z';
	end process buffer_logic;

	

end behaviour;
