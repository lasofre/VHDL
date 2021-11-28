
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity frec_div is
    Port ( 
			  clock      : in  STD_LOGIC;
			  i_reset    : in STD_LOGIC;
			  o_ds       : out STD_LOGIC);
end frec_div;

architecture Behavioral of frec_div is
signal s_cuenta_int : integer range 50000000 downto 0;
begin
process (clock,i_reset)
begin
 if i_reset = '0' then
	s_cuenta_int <= 0;
 elsif clock='1' and clock'event then
		if s_cuenta_int = 5000000 then 
			s_cuenta_int <= 0;
			o_ds  <= '1';
		else
			s_cuenta_int <= s_cuenta_int + 1;
			o_ds  <= '0';
		end if;
 end if;
end process;
end Behavioral;