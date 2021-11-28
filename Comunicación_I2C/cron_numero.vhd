library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cron_numero is
    Port ( clock   : in  STD_LOGIC;
			  i_reset : in  STD_LOGIC;
			  i_ds    : in  STD_LOGIC;
			  o_numero: out std_logic_vector (7 downto 0));
end cron_numero;

architecture Behavioral of cron_numero is
signal r_deci : STD_LOGIC_VECTOR (7 downto 0);
signal r_seg  : STD_LOGIC_VECTOR (7 downto 0);
signal r_min  : STD_LOGIC_VECTOR (7 downto 0);
signal i_sel  : STD_LOGIC_VECTOR (1 downto 0);
signal s_mux : integer range 1000 downto 0;
signal s_inc_s: STD_LOGIC;
signal s_inc_m: STD_LOGIC;
begin
--Decimas de segundo
process (clock ,i_reset)
begin
 if i_reset = '0' then
	r_deci <= "00000000";
 elsif clock='1' and clock'event then
		if i_ds = '1'  then
			if r_deci = "0001001" then 
				r_deci  <= "00000000";
				s_inc_s <= '1';
			else
				r_deci  <= r_deci + 1;
				s_inc_s <= '0';
			end if;
		end if;
 end if;
end process;
--segundos
process (clock,i_reset)
begin
 if i_reset = '0' then
	r_seg <= "00000000";
 elsif clock='1' and clock'event then
		if s_inc_s = '1' then
			if r_seg = "00111100" then 
				r_seg   <= "00000000";
				s_inc_m <= '1';
			else
				r_seg  <= r_seg + 1;
				s_inc_m <= '0';
			end if;
		end if;
 end if;
end process;
--minutos
process (clock,i_reset)
begin
 if i_reset = '0' then
	r_min <= "00000000";
 elsif clock='1' and clock'event then
		if s_inc_m = '1' then
			if r_min = "00111100" then 
				r_min  <= "00000000";
			else
				r_min  <= r_min + 1;
			end if;
		end if;
 end if;
end process;
--multiplexado de salida
process (clock,i_reset)
begin
 if i_reset = '0' then
	s_mux <= 0;
	i_sel <= "00";
 elsif clock='1' and clock'event then
	if s_mux = 1000 then 
		s_mux <= 0;
		if i_sel= "11" then
			i_sel<= "00";
		else
			i_sel<=i_sel + 1;
		end if;
	else
		s_mux  <= s_mux + 1;
	end if;
end if;
end process;



o_numero  <=   r_deci   when i_sel="00" else
				   r_seg    when i_sel="01" else
  			   	r_min    when i_sel="10" else
					"00000000";
end Behavioral;