----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:06:07 04/29/2021 
-- Design Name: 
-- Module Name:    frec_div - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity frec_div is
    Port ( clk : in  STD_LOGIC;
			  --R: in STD_LOGIC;
			  Co : out STD_LOGIC);
end frec_div;

architecture Behavioral of frec_div is
signal tmp: std_logic_vector(3 downto 0):="0000";
signal sR: STD_LOGIC;
begin
    process (clk)
    begin
        if (clk'event and clk='0') then
				if (sR='1') then 
					tmp <= "0000";
				else
					tmp <= tmp + 1;
				end if;
        end if;
    end process;
sR<= (tmp(3) and tmp(2) and tmp(1) and tmp(0));

Co<= tmp(3) and tmp(2) and tmp(1) and tmp(0);
end Behavioral;

