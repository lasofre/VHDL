----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:19:06 04/13/2021 
-- Design Name: 
-- Module Name:    Contador_4bits - Behavioral 
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

entity Contador_4bits is
    Port ( X : in  STD_LOGIC;
           UD : in  STD_LOGIC;
           R : in  STD_LOGIC;
			  S : in STD_LOGIC;
			  Co : out STD_LOGIC;
           Output : out  STD_LOGIC_VECTOR (3 downto 0));
end Contador_4bits;

architecture Behavioral of Contador_4bits is

signal tmp: std_logic_vector(3 downto 0):="0000";
signal sS: STD_LOGIC;
signal sR: STD_LOGIC;
    
begin
    process (X, sR, sS)
    begin
	     if (sR='1') then 
				tmp <= "0000";
		  elsif (sS='1') then 
				tmp <= "1001";
        elsif (X'event and X='1') then
				if (UD='1') then
					tmp <= tmp + 1;
				else
					tmp <= tmp - 1;
				end if;
        end if;
    end process;
	--1010
	sR<= (tmp(3) and not(tmp(2)) and tmp(1) and not(tmp(0)) and UD) or R;
	--0000
	sS<= (tmp(3) and tmp(2) and tmp(1) and tmp(0) and not(UD))or S;
	
	cO <= (tmp(3) and not(tmp(2)) and tmp(1) and not(tmp(0)) and UD) or (tmp(3) and tmp(2) and tmp(1) and tmp(0) and not(UD));
   Output <= tmp;

end Behavioral;


