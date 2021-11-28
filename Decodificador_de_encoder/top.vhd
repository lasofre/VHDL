----------------------------------------------------------------------------------
-- UNIVERSIDAD TECNOLÓGICA NACIONAL - FACULTAD REGIONAL CORDOBA
-- Carrera: INGENIERIA ELECTRÓNICA.
-- Asignatura: TÉCNICAS DIGITALES IV (ELECTIVA).
-- Año: 2021.
-- Grupo nº: 02.
-- Integrantes:
--
-- Rodriguez Grandi, Ignacio
-- Bucca, Matías
-- Ramirez Torres, Jonas
-- Elizondo, Federico
--
-- Fecha de Entrega: 24/04/2021.
-- hardware utilizado
-- VHDL auxiliares utilizados
-- UCF utilizado
-- Práctico nº01: Decodificador de encoder visualizando en cuatro (4) display de 7 seg. 

-- Colocar algún consejo para recordar en el futuro
-- Nota: Si la placa que usas tiene un pulsador, revisar si al pulsar manda a masa o a vcc. MUY IMPORTANTE.
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library altera;
use altera.altera_syn_attributes.all;

entity top is
	port( 	
		A : in STD_LOGIC;
		B : in STD_LOGIC;
		Clk : in STD_LOGIC;
		R : in STD_LOGIC;
		LED : out STD_LOGIC;
		Enn : out	std_logic_vector(2 downto 0);
		Disp : out	std_logic_vector(6 downto 0));
end top;

architecture ppl_type of top is

COMPONENT cont_up_d 
    Port ( A_B : in  STD_LOGIC;
           U_D : in  STD_LOGIC;
           R : in  STD_LOGIC;
           BCD_OUT : out  STD_LOGIC_VECTOR (11 downto 0));
END COMPONENT;

COMPONENT display
    Port ( bcd : in  STD_LOGIC_VECTOR (11 downto 0);
			  input : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (6 downto 0);
           en : out  STD_LOGIC_VECTOR (2 downto 0));
END COMPONENT;
COMPONENT estados_encoder
	port(
		--flanco : in	std_logic;
		A : in	std_logic;
		B : in	std_logic;
		reset	 : in	std_logic;
		output	 : out	std_logic
	);

END COMPONENT;
COMPONENT pwm 
    Port ( clk : in  STD_LOGIC;
			  R : in  STD_LOGIC;
           ref : in  STD_LOGIC_VECTOR (11 downto 0);
           Output : out  STD_LOGIC);
END COMPONENT;

signal sU_D : STD_LOGIC;
signal sBCD_OUT: STD_LOGIC_VECTOR (11 downto 0);
signal sA: STD_LOGIC;
signal snR : STD_LOGIC;
begin
sA <= A or B;
snR<= not(R);
  INS_ESENC: estados_encoder PORT MAP(
		A=> A,
		B=> B,
		reset => snR,
		output =>sU_D 
  );

	INST_CONT: cont_up_d PORT MAP(
		A_B => sA,
      U_D => sU_D,
      R => snR,
      BCD_OUT => sBCD_OUT
	);
	
	INST_display: display PORT MAP(
		bcd => sBCD_OUT,
		input => Clk,
		output => Disp,
		en => Enn
		
	);	
	INST_pwm: pwm PORT MAP(
			  clk => Clk, 
			  R => snR,
           ref => sBCD_OUT,
           Output =>LED
	);
	

end;
