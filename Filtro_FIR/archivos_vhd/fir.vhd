--------------------------------------------------------------------------
-- UNIVERSIDAD TECNOLÓGICA NACIONAL - FACULTAD REGIONAL CÓRDOBA
-- Carrera: INGENIERIA ELECTRÓNICA
-- Asignatura: TÉCNICAS DIGITALES IV (ELECTIVA)
-- Año: 2021
-- Grupo no: 02
-- Integrantes:
--             Rodriguez Grandi Ignacio. Legajo= 72880
--					Ramirez Torres, Jonas Gabriel. Legajo= 74042
--					Bucca, Matías. Legajo= 73063
--					Elizondo, Federico. Legajo=
-- Fecha de Entrega: 28/06/2021
-- Hardware utilizado: 
-- VHDL auxiliares utilizados: -txt_util.vhd
-- Script Matlab: -coeficientes.m
-- Testbench: -fir_tb2.vhd
-- UCF utilizado: -
-- Práctico No 5: Implementación de filtro FIR. 
-- Descripción: Filtro FIR con coeficientes generados mediante Matlab.
-- Dificultades y recordatorios: 
-- Nota:
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir is
port(
  clk_i : in std_logic;
  reset_i : in std_logic;
  x       : in signed(11 downto 0);
  y       : out signed(11 downto 0)
);
end entity;


architecture behav of fir is

  type fixed_t is array (0 to 31) of signed(11 downto 0);
  signal taps : fixed_t := (
	"000000000101",
	"000000000110",
	"000000001001",
	"000000001110",
	"000000010101",
	"000000011101",
	"000000101000",
	"000000110100",
	"000001000001",
	"000001001111",
	"000001011100",
	"000001101001",
	"000001110100",
	"000001111101",
	"000010000011",
	"000010000110",
	"000010000110",
	"000010000011",
	"000001111101",
	"000001110100",
	"000001101001",
	"000001011100",
	"000001001111",
	"000001000001",
	"000000110100",
	"000000101000",
	"000000011101",
	"000000010101",
	"000000001110",
	"000000001001",
	"000000000110",
	"000000000101");
 
  signal delay : fixed_t;

begin

delay_proc : process(clk_i, reset_i)
begin
  if(reset_i='1') then
    for i in 0 to 31 loop
      delay(i) <= (others=>'0');
    end loop;
  elsif(rising_edge(clk_i)) then
    delay(0) <= x;
    for i in 1 to 31 loop
      delay(i) <= delay(i-1);
    end loop;
  end if;
end process;

calc_proc : process(clk_i, reset_i)
  variable acum : signed(23 downto 0);
begin
  if(reset_i='1') then
    y <= (others=>'0');
    acum := (others=>'0');
  elsif (rising_edge(clk_i)) then
    acum:=(others=>'0');
    for i in 0 to 31 loop
      acum := acum + taps(i)*delay(i);
    end loop;
    y <= acum(23 downto 12);
  end if;
end process;

end architecture;