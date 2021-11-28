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

entity BCD_SEG is
    Port ( BCD_IN : in  STD_LOGIC_VECTOR (3 downto 0);
           SEG_OUT : out  STD_LOGIC_VECTOR (6 downto 0));
end BCD_SEG;

architecture Behavioral of BCD_SEG is

begin

process (BCD_IN)
begin
   case BCD_IN is
      when "0000" => SEG_OUT <= "1011111"; --0
      when "0001" => SEG_OUT <= "0001100"; --1
      when "0010" => SEG_OUT <= "0111011"; --2
      when "0011" => SEG_OUT <= "0111110"; --3
      when "0100" => SEG_OUT <= "1101100"; --4
      when "0101" => SEG_OUT <= "1110110"; --5
      when "0110" => SEG_OUT <= "1110111"; --6
      when "0111" => SEG_OUT <= "0011100"; --7
		when "1000" => SEG_OUT <= "1111111"; --8
		when "1001" => SEG_OUT <= "1111100"; --9
      when others => SEG_OUT <= "0000000";
   end case;
end process;

				

end Behavioral;
