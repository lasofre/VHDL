-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;

entity state_enable is

	port(
		clk		 : in	std_logic;
		input	 : in	std_logic;
		reset	 : in	std_logic;
		output	 : out	std_logic
	);

end entity;


architecture rtl of state_enable is
signal s_cuenta_int : integer range 10000 downto 0;
signal enable_int: std_logic;
begin	
process (clk,reset)
    begin
	 if reset = '0' then
		s_cuenta_int <= 0;
	 elsif clk='1' and clk'event and enable_int ='1' then
			if s_cuenta_int = 10000 then 
				s_cuenta_int <= 0;
			else
				s_cuenta_int <= s_cuenta_int + 1;
			end if;
	 end if;
end process;

process (clk,reset)
    begin
	 if reset = '0' then
		enable_int <= '0';
	 elsif clk='1' and clk' event then
			if input = '1' then 
				enable_int   <= '1';
			elsif s_cuenta_int = 10000 then
				enable_int   <= '0';
			end if;
	 end if;
end process;	

output <= enable_int;

	
end rtl;
