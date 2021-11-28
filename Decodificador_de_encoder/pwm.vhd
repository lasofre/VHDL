----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:38:27 05/10/2021 
-- Design Name: 
-- Module Name:    pwm - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm is
    Port ( clk : in  STD_LOGIC;
			  R : in  STD_LOGIC;
           ref : in  STD_LOGIC_VECTOR (11 downto 0);
           Output : out  STD_LOGIC);
end pwm;

architecture Behavioral of pwm is

COMPONENT contador_4bits
	Port ( X : in  STD_LOGIC;
			 UD : in  STD_LOGIC;
			 R : in  STD_LOGIC;
			 S : in  STD_LOGIC;
			 Co : out STD_LOGIC;
			 Output : out  STD_LOGIC_VECTOR (3 downto 0));
END COMPONENT;

signal sCo : STD_LOGIC_VECTOR (1 downto 0);
signal sCuenta : STD_LOGIC_VECTOR (11 downto 0); 


begin
	INST_CONT5: contador_4bits PORT MAP(
		X => clk,
		UD => '1',
		R => R,
		S => '0',
		Co => sCo(0),
		Output => sCuenta(3 downto 0)
	);
	INST_CONT6: contador_4bits PORT MAP(
		X => sCo(0),
		UD => '1',
		R => R,
		S => '0',
		Co => sCo(1),
		Output => sCuenta(7 downto 4)
	);
	INST_CONT7: contador_4bits PORT MAP(
		X => sCo(1),
		UD => '1',
		R =>  R,
		Co => open,
		S => '0',
		Output => sCuenta(11 downto 8)
	);	 
Output<= '1' when (sCuenta < ref)   else '0';

	
	
end Behavioral;


