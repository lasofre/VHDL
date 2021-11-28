----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:23:30 04/13/2021 
-- Design Name: 
-- Module Name:    BCD_SEG - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux12_4 is
    Port ( MUX_IN : in  STD_LOGIC_VECTOR (11 downto 0);
           MUX_OUT : out  STD_LOGIC_VECTOR (3 downto 0);
			  SEL : in  STD_LOGIC_VECTOR (1 downto 0));
end mux12_4;

architecture Behavioral of mux12_4 is

begin

MUX_OUT(0) <= MUX_IN(0) when SEL = "00" else 
				  MUX_IN(4)when SEL = "01" else 
				  MUX_IN(8)when SEL = "10" else 'Z';
				  
MUX_OUT(1) <= MUX_IN(1) when SEL = "00" else 
				  MUX_IN(5)when SEL = "01" else 
				  MUX_IN(9)when SEL = "10" else 'Z';
				  
MUX_OUT(2) <= MUX_IN(2) when SEL = "00" else 
				  MUX_IN(6)when SEL = "01" else 
				  MUX_IN(10)when SEL = "10" else 'Z';
				  
MUX_OUT(3) <= MUX_IN(3) when SEL = "00" else 
				  MUX_IN(7)when SEL = "01" else 
				  MUX_IN(11)when SEL = "10" else 'Z';

				

end Behavioral;



