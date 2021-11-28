library ieee;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all;

entity ball_animate is

port(
		clk, reset : std_logic;
		video_on: in std_logic;
		pixel_x : in std_logic_vector (10 downto 0) ;
		pixel_y : in std_logic_vector (9 downto 0) ;
		graph_rgb : out std_logic
);
end ball_animate;

architecture arch of ball_animate is
signal refr_tick : std_logic;
-- x, y coordinates (0,0) to (639,479)
signal pix_x: unsigned (10 downto 0);
signal pix_y: unsigned (9 downto 0);
constant MAX_Y: integer :=480;
constant MAX_X: integer :=1257;
-------------------------------------------------
-- square ball
-------------------------------------------------
constant BALL_SIZE: integer:=16; -- 8
-- ball left, right boundary
signal ball_x_l: unsigned (10 downto 0) ;
signal ball_x_r: unsigned (10 downto 0) ;
-- ball top , bottom boundary
signal ball_y_t , ball_y_b : unsigned (9 downto 0) ;
-- reg to track left , top boundary
signal ball_x_reg , ball_x_next : unsigned (10 downto 0) ;
signal ball_y_reg , ball_y_next : unsigned (9 downto 0) ;
-- reg to track ball speed
signal x_delta_reg , x_delta_next : unsigned(10 downto 0) ;
signal y_delta_reg , y_delta_next : unsigned(9 downto 0) ; 

-- ball velocity can be pos or neg
constant BALL_V_P: unsigned (9 downto 0):=to_unsigned (2,10);
constant BALL_V_N: unsigned (9 downto 0):=unsigned (to_signed (-2,10)); 
constant BALL_V_P_X: unsigned (10 downto 0):=to_unsigned (2,11);
constant BALL_V_N_X: unsigned (10 downto 0):=unsigned (to_signed (-2,11));
--------------------------------------------------
-- round ball image ROM
--------------------------------------------------
type rom_type is array (0 to 7) of std_logic_vector(0 to 15);
-- ROM definition
constant BALL_ROM: rom_type :=
(
	"0000111111110000", -- 	  ****
	"0011111111111100", --   ******
	"1111111111111111", --  ********
	"1111111111111111", --  ********
	"1111111111111111", --  ********
	"1111111111111111", --  ********
	"0011111111111100", --   ****** 
	"0000111111110000"  --    ****
);
signal rom_addr , rom_col : unsigned (3 downto 0) ;
signal rom_data: std_logic_vector (15 downto 0) ;
signal rom_bit : std_logic;
---------------------------------------------------
-- object output signals
---------------------------------------------------
signal sq_ball_on, rd_ball_on: std_logic;
-- signals for random number
signal count_i      : std_logic_vector (9 downto 0);
signal feedback     : std_logic;

begin
--------------------------------------------------
--random number
--------------------------------------------------
feedback <= not(count_i(9) xor count_i(5));  

process (reset, clk) 
	  begin
	  if (reset = '1') then
			count_i <= (others=>'0');
	  elsif (rising_edge(clk)) then
			count_i <= count_i(8 downto 0) & feedback;
	  end if;
end process;
	 
-- registers
process (clk,reset)
begin
	if reset='1' then
		ball_x_reg <= (others=>'0');
		ball_y_reg <= (others=>'0');
		x_delta_reg <= ("00000000100");
		y_delta_reg <= ("0000000100");
	elsif (clk'event and clk='1') then
		ball_x_reg <= ball_x_next ;
		ball_y_reg <= ball_y_next ;
		x_delta_reg <= x_delta_next ;
		y_delta_reg <= y_delta_next;
   end if ;
end process;
pix_x <= unsigned(pixel_x);
pix_y <= unsigned(pixel_y); 
--refr_tick: 1-clock tick asserted at start of v-sync i.e., when the screen is refreshed (60 Hz) 
refr_tick <= '1' when (pix_y = 481) and (pix_x = 0) else
'0';
------------------------------------------------------
-- square ball
------------------------------------------------------
-- boundary
ball_x_l <= ball_x_reg;
ball_y_t <= ball_y_reg;
ball_x_r <= ball_x_l + BALL_SIZE - 1;
ball_y_b <= ball_y_t + BALL_SIZE - 9;
-- pixel within ball 
sq_ball_on <=
'1' when (ball_x_l <= pix_x) and (pix_x <= ball_x_r) and
(ball_y_t <= pix_y) and (pix_y <= ball_y_b) else
'0'; 
-- map current pixel location to ROM addr/col
rom_addr <= pix_y(3 downto 0) - ball_y_t(3 downto 0);
rom_col <= pix_x(3 downto 0) - ball_x_l(3 downto 0);
rom_data <= BALL_ROM(to_integer(rom_addr));
rom_bit <= rom_data(to_integer(rom_col)); 
-- pixel within ball
rd_ball_on <= '1' when (sq_ball_on='1') and (rom_bit='1') else
'0';

--ball rgb output
--ball_rgb <= "11100000";
--new ball position
ball_x_next <=  ball_x_reg + x_delta_reg when refr_tick= '1' else ball_x_reg;
ball_y_next <=  ball_y_reg + y_delta_reg when refr_tick= '1' else ball_y_reg;
--new ball velocity
process (x_delta_reg , y_delta_reg , ball_y_t , ball_x_l , ball_x_r ,ball_y_b,feedback)
begin
	x_delta_next <= x_delta_reg;
	y_delta_next <= y_delta_reg ;
	if ball_y_t < 1 then -- reach top
		y_delta_next <= BALL_V_P;
		if feedback='0' then
			x_delta_next <= BALL_V_P_X;
		else
			x_delta_next <= BALL_V_N_X;
		end if;
	elsif ball_y_b > (MAX_Y - 1) then -- reach bottom	
		y_delta_next <= BALL_V_N;
		if feedback='0' then
			x_delta_next <= BALL_V_P_X;
		else
			x_delta_next <= BALL_V_N_X;
		end if;
	elsif ball_x_l < 1 then -- reach left
		x_delta_next <= BALL_V_P_X; -- bounce back 
		if feedback='0' then
			y_delta_next <= BALL_V_P;
		else
			y_delta_next <= BALL_V_N;
		end if;
	elsif ball_x_r > (MAX_X - 1) then -- reach right	
		x_delta_next <= BALL_V_N_X;
		if feedback='0' then
			y_delta_next <= BALL_V_P;
		else
			y_delta_next <= BALL_V_N;
		end if;
	end if;
end process;
-------------------------------------------------------------------
--rgb multiplexing circuit
-------------------------------------------------------------------
process(video_on,rd_ball_on)
begin
	if video_on= '0' then
		graph_rgb <= '0'; --blank
	else
		if rd_ball_on= '1' then
			graph_rgb <= '1';
		else
			graph_rgb <= '0'; -- yellow background	
		end if;
	end if;
end process;
end arch;


