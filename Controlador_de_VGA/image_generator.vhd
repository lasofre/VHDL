library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity image_generator is
 Port (hctr : in std_logic_vector (10 downto 0);
		 vctr : in std_logic_vector (9 downto 0);
		 blank : in std_logic; -- blank interval signal
		 posicion : in std_logic; --cambiar lineas de horizontal a vertical
		 clk50MHz : in std_logic; -- main clock
		 reset : in std_logic; -- global reset
		 RGB : out std_logic_vector (7 downto 0)); --Colour signal
		 
end image_generator;
architecture Behavioral of image_generator is
signal hctr_int : integer range 1586 downto 0;
signal vctr_int : integer range 524 downto 0;
signal colorv: std_logic_vector (7 downto 0);
signal colorh: std_logic_vector (7 downto 0);
signal color: std_logic_vector (7 downto 0);
begin
hctr_int <= CONV_INTEGER (hctr);
vctr_int <= CONV_INTEGER (vctr);
-- utilizamos biestables de salida para evitar posibles Glitches
-- Iniiciaizamos los biestables a cero
process (clk50MHz,reset,color)
begin
 if reset = '1' then
 RGB <= "00000000";
 elsif clk50MHz='1' and clk50MHz'event then
 RGB <= color;
 end if;
end process;
-- Colores obtenidos en función de R G B (8 bits)
-- Circuito combinacional que genera los colores de cada franja
-- en función de la posición horizontal de cada punto
-- franja vertical blanca de la izda
colorv <= "11111111" when ((hctr_int >= 0) and (hctr_int < 158) and (blank = '1') and (posicion='1'))--blanco
else
-- aquí comienza la imagen de 640 x 480
-- que consiste en 7 barras verticales de diferentes colores
"11111100" when ((hctr_int >= 158) and (hctr_int < 316) and (blank = '1')and (posicion='1')) else --amarillo
"00011111" when ((hctr_int >= 316) and (hctr_int < 474) and (blank = '1') and (posicion='1'))else --cyan
"00011100" when ((hctr_int >= 474) and (hctr_int < 632) and (blank = '1')and (posicion='1')) else --verde
"11100011" when ((hctr_int >= 632) and (hctr_int < 790) and (blank = '1')and (posicion='1')) else --rosa
"11100000" when ((hctr_int >= 790) and (hctr_int < 948) and (blank = '1') and (posicion='1'))else --rojo
"00000011" when ((hctr_int >= 948) and (hctr_int < 1106) and (blank = '1')and (posicion='1')) else --azul
"00000000" when ((hctr_int >= 1106) and (hctr_int <= 1257) and (blank = '1')and (posicion='1')) else --negro
"00000000"; -- Intérvalos blank (blank = 0)
colorh <= 
"11111111" when ((vctr_int >= 0) and (vctr_int < 60) and (blank = '1') and (posicion='0')) else --blanco
"11111100" when ((vctr_int >= 60) and (vctr_int < 120) and (blank = '1') and (posicion='0')) else --amarillo
"00011111" when ((vctr_int >= 120) and (vctr_int < 180) and (blank = '1') and (posicion='0')) else --cyan
"00011100" when ((vctr_int >= 180) and (vctr_int < 240) and (blank = '1') and (posicion='0')) else --verde
"11100011" when ((vctr_int >= 240) and (vctr_int < 300) and (blank = '1') and (posicion='0')) else --rosa
"11100000" when ((vctr_int >= 300) and (vctr_int < 360) and (blank = '1') and (posicion='0')) else --rojo
"00000011" when ((vctr_int >= 360) and (vctr_int < 420) and (blank = '1') and (posicion='0')) else --azul
"00000000" when ((vctr_int >= 420) and (vctr_int <= 480) and (blank = '1') and (posicion='0')) else --negro
"00000000"; -- Intérvalos blank (blank = 0)
color <= colorv or colorh;
end Behavioral;