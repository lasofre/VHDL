--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:00:56 06/22/2021
-- Design Name:   
-- Module Name:   D:/xilinproyectos/coloquio/contador_TB.vhd
-- Project Name:  coloquio
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: contador
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY tb_top IS
END tb_top;
 
ARCHITECTURE behavior OF tb_top IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
		clock     : in std_LOGIC;
		i_reset   : in std_LOGIC;
		i_inpar   : in std_LOGIC;
		o_ackerr  : out std_LOGIC;
      io_sda    : inout  STD_LOGIC; 
      io_scl    : inout  STD_LOGIC   
		);
    END COMPONENT;
    

   --Inputs
   signal s_inpar : std_logic:= '0';
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal s_sda : std_logic;
	signal s_ackerr : std_logic;
	signal s_scl : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
			clock     => clk,
			i_reset   => reset,
			i_inpar   => s_inpar,
			o_ackerr   => s_ackerr,
			io_sda    => s_sda,
			io_scl    => s_scl 
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      
      wait for 100 ns;
		reset<='0';
		s_inpar<='0';
      wait for clk_period*5;
		reset<='1';
		s_inpar<='1';
		wait for 1 ms;
   end process;
	

END;
