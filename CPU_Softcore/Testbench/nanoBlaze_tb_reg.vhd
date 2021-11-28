LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY nanoBlaze_tb_reg IS
END nanoBlaze_tb_reg;
 
ARCHITECTURE behavior OF nanoBlaze_tb_reg IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT out_regs
    PORT(
			clk, reset: in std_logic;
			sw: in std_ulogic_vector (7 downto 0) ;
			led: out std_ulogic_vector (7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal sw : std_ulogic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal led : std_ulogic_vector(7 downto 0);


   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: out_regs PORT MAP (
          clk => clk,
          reset => reset,
          sw => sw,
          led => led
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
      -- hold reset state for 100 ns.
      wait for 10 ns;	

      wait for clk_period*10;
		reset<='1';
		wait for 100 ns;
		reset<='0';
      wait;
   end process;

END;
