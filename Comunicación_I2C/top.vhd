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
-- VHDL auxiliares utilizados:
-- Testbench: -tb_top.vhd
-- UCF utilizado: -
-- Práctico No 3:  Opción A: Comunicación I2C 
-- Descripción: Realizar la descripción de una comunicación I2C para poder controlar un
-- display inteligente de 2 x 16 caracteres mediante la utilización de un
-- dispositivo serie/ paralelo controlado por un bus I2C.
-- Dificultades y recordatorios: 
-- Nota:
---------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

entity top is
GENERIC(
    input_clk : INTEGER := 50_000_000; --input clock speed from user logic in Hz
    bus_clk   : INTEGER := 100_000);   --speed the i2c bus (scl) will run at in Hz
port(
		clock     : in std_LOGIC;
		i_reset   : in std_LOGIC;
		o_ackerr  : out std_LOGIC;
      io_sda    : inout  STD_LOGIC; 
      io_scl    : inout  STD_LOGIC   
	  );
end top;

architecture Behavioral of top is

COMPONENT i2c_master is
GENERIC(
    input_clk : INTEGER := 50_000_000; --input clock speed from user logic in Hz
    bus_clk   : INTEGER := 100_000);   --speed the i2c bus (scl) will run at in Hz
PORT(
    clk       : in     STD_LOGIC;                    --system clock
    reset_n   : in     STD_LOGIC;                    --active low reset
    ena       : in     STD_LOGIC;                    --latch in command
    addr      : in     STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
    rw        : in     STD_LOGIC;                    --'0' is write, '1' is read
    data_wr   : in     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
    busy      : out    STD_LOGIC;                    --indicates transaction in progress
    data_rd   : out    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
    ack_error : buffer STD_LOGIC;                    --flag if improper acknowledge from slave
    sda       : inout  STD_LOGIC;                    --serial data output of i2c bus
    scl       : inout  STD_LOGIC);                   --serial clock output of i2c bus
END COMPONENT;

COMPONENT frec_div is
PORT(
	 clock      : in  STD_LOGIC;
	 i_reset    : in  STD_LOGIC;
	 o_ds       : out STD_LOGIC);
END COMPONENT;

COMPONENT state_enable is 
	port(
		clk		 : in	std_logic;
		input	 : in	std_logic;
		reset	 : in	std_logic;
		output	 : out	std_logic
	);
END COMPONENT;

COMPONENT cron_numero is
 Port ( clock   : in  STD_LOGIC;
		  i_reset : in  STD_LOGIC;
		  i_ds    : in  STD_LOGIC;
		  o_numero: out std_logic_vector (7 downto 0));
END COMPONENT;




signal r_enable : std_logic;
signal s_ds  : std_logic;
signal s_busy: std_logic;
signal r_busy: std_logic;
signal r_ack_error: std_logic;
signal s_data_wr  : std_logic_vector (7 downto 0);
signal r_data_rd  : std_logic_vector (7 downto 0);
signal r_sel : std_logic_vector (1 downto 0);

begin

i2cmaster_inst: i2c_master
  generic map (
    input_clk => input_clk,
    bus_clk   => bus_clk
  )
  PORT MAP (
    clk       => clock,
    reset_n   => i_reset,
    ena       => r_enable,
    addr      => "0000111",
    rw        => '0',
    data_wr   => s_data_wr,
    busy      => s_busy,
    data_rd   => r_data_rd,
    ack_error => o_ackerr,
    sda       => io_sda,
    scl       => io_scl
  );
frec_div_inst: frec_div
 PORT MAP (
    clock   => clock,
    i_reset => i_reset,
    o_ds    => s_ds
  );

state_enable_inst: state_enable
 PORT MAP (
    clk   => clock,
    reset => i_reset,
    input => s_ds,
	 output=> r_enable
  );
 cronometro_inst: cron_numero
 PORT MAP(
	clock  => clock,
   i_reset => i_reset,
   i_ds    => s_ds,
   o_numero => s_data_wr
 );
 
 

end Behavioral;
