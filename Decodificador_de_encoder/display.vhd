----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:54:31 04/28/2021 
-- Design Name: 
-- Module Name:    display - Behavioral 
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

entity display is
    Port ( bcd : in  STD_LOGIC_VECTOR (11 downto 0);
			  input : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (6 downto 0);
           en : out  STD_LOGIC_VECTOR (2 downto 0));
end display;

architecture Behavioral of display is
COMPONENT BCD_SEG
    Port ( BCD_IN : in  STD_LOGIC_VECTOR (3 downto 0);
           SEG_OUT : out  STD_LOGIC_VECTOR (6 downto 0));
END COMPONENT;

COMPONENT mux12_4
    Port ( MUX_IN : in  STD_LOGIC_VECTOR (11 downto 0);
           MUX_OUT : out  STD_LOGIC_VECTOR (3 downto 0);
			  SEL : in  STD_LOGIC_VECTOR (1 downto 0));
END COMPONENT;
COMPONENT slec_mux
		port(
			input	 : in	std_logic;
			--reset	 : in	std_logic;
			output	 : out	std_logic_vector(1 downto 0)
		);
END COMPONENT;
signal sSelec: std_logic_vector(1 downto 0);
signal sSalMux: std_logic_vector(3 downto 0);


begin
	INST_MUX12_4: mux12_4 PORT MAP(
		MUX_IN => bcd,
		SEL => sSelec,
		MUX_OUT => sSalMux	
	);
	INST_BCD: BCD_SEG PORT MAP(
		BCD_IN => sSalMux , 
		SEG_OUT => output	
	);
	 INST_SELMUX: slec_mux PORT MAP(
		input => input,
		output => sSelec
	);

en <= "011" when sSelec = "00" else 
		"101" when sSelec = "01" else 
		"110" when sSelec = "10" else "111";



end Behavioral;

