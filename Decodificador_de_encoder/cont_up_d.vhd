----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:25:21 04/28/2021 
-- Design Name: 
-- Module Name:    cont_up_d - Behavioral 
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

entity cont_up_d is
    Port ( A_B : in  STD_LOGIC;
           U_D : in  STD_LOGIC;
           R : in  STD_LOGIC;
           BCD_OUT : out  STD_LOGIC_VECTOR (11 downto 0));
end cont_up_d;

architecture Behavioral of cont_up_d is

COMPONENT contador_4bits
	Port ( X : in  STD_LOGIC;
			 UD : in  STD_LOGIC;
			 R : in  STD_LOGIC;
			 S : in  STD_LOGIC;
			 Co : out STD_LOGIC;
			 Output : out  STD_LOGIC_VECTOR (3 downto 0));
END COMPONENT;

signal sCo : STD_LOGIC_VECTOR (1 downto 0);

begin
	INST_CONT0: contador_4bits PORT MAP(
		X => A_B,
		UD => U_D,
		R => R,
		S => '0',
		Co => sCo(0),
		Output => BCD_OUT(3 downto 0)
	);
	INST_CONT1: contador_4bits PORT MAP(
		X => sCo(0),
		UD => U_D,
		R => R,
		S => '0',
		Co => sCo(1),
		Output => BCD_OUT(7 downto 4)
	);
	INST_CONT2: contador_4bits PORT MAP(
		X => sCo(1),
		UD => U_D,
		R =>  R,
		--Co => ,
		S => '0',
		Output => BCD_OUT(11 downto 8)
	);	 
	 
end Behavioral;

