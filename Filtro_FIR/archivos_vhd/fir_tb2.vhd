--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:13:31 06/24/2021
-- Design Name:   
-- Module Name:   D:/xilinproyectos/filtro/fir_tb2.vhd
-- Project Name:  filtro
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fir
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.txt_util.all; 

entity fir_tb2 is
end entity;


architecture behav of fir_tb2 is

  signal clk_i   : std_logic :='0';
  signal reset_i : std_logic;
  signal x       : signed(11 downto 0);
  signal y       : signed(11 downto 0);

  file samples : TEXT open READ_MODE is "x.txt";
  file filtered : TEXT open WRITE_MODE is "output.txt";
begin

UUT : entity work.fir(behav) port map(clk_i,reset_i,x,y);

clk_i   <= not(clk_i) after 10 ns;
reset_i <= '0', '1' after 10 ns, '0' after 20 ns;

process(clk_i)
  variable sample_line : LINE;
  variable x_int : string(12 downto 1);

begin
  if(rising_edge(clk_i)) then
    readline(samples,sample_line);
    read(sample_line,x_int);
    x <= signed(to_std_logic_vector(x_int));
  end if; 
end process;


process(clk_i)
  variable output_line : LINE;
  variable x_int : string(12 downto 1);

begin
  if(falling_edge(clk_i)) then
    write(output_line,to_integer(y));
    writeline(filtered,output_line);

  end if; 
end process;

end architecture;
