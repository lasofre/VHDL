library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity top is
 Port (clk50MHz : in std_logic; -- main clock
		 reset : in std_logic; -- global reset
		 posicion : in std_logic; --cambiar lineas de horizontal a vertical
		 hsync : out std_logic; -- hsync signal
		 vsync : out std_logic; --	vsync signal
		 RGB :out std_logic_vector (7 downto 0)); -- colour signal
end top;

architecture comportamiento of top is
--Componentes
----------------Contadores--------------------------------
COMPONENT contador_horizontal
	Port ( clk50MHz : in std_logic; -- reloj principal
		    reset : in std_logic; -- reset global
		    h_cuenta : out std_logic_vector (10 downto 0));
END COMPONENT;

COMPONENT contador_vertical
	Port ( hsync : in std_logic; -- horizontal sync signal
		    clk50MHz: in std_logic; -- main clock
		    reset : in std_logic; -- global reset
		    v_cuenta : out std_logic_vector (9 downto 0));
END COMPONENT;
----------------Señales Sinc------------------------------
COMPONENT generador_hsync
	Port ( h_cuenta : in std_logic_vector (10 downto 0);
		    clk50MHz : in std_logic;
		    reset : in std_logic;
		    hsync : out std_logic);
END COMPONENT;
COMPONENT generador_vsync
	Port ( v_cuenta : in std_logic_vector (9 downto 0);
		    clk50MHz : in std_logic;
		    reset : in std_logic;
		    vsync : out std_logic);
END COMPONENT;
----------------Imagen-----------------------------------
COMPONENT generador_blank
	Port ( hctr : in std_logic_vector (10 downto 0);
		    vctr : in std_logic_vector (9 downto 0);
		    blank : out std_logic);
END COMPONENT;
COMPONENT image_generator
Port (hctr : in std_logic_vector (10 downto 0);
		 vctr : in std_logic_vector (9 downto 0);
		 blank : in std_logic; -- blank interval signal
		 posicion : in std_logic; 
		 clk50MHz : in std_logic; -- main clock
		 reset : in std_logic; -- global reset
		 RGB : out std_logic_vector (7 downto 0));
END COMPONENT;
--COMPONENT generador_bola_mov
--Port( 
--		vsync : in std_logic;
--		hctr : in std_logic_vector (10 downto 0); -- contador hori
--		vctr : in std_logic_vector (9 downto 0); -- contador ver
--		blank : in std_logic; -- señal de oscurecimiento
--		clk50MHz : in std_logic; -- reloj principal
--		reset : in std_logic; -- reset global
--		RGB : out std_logic_vector (7 downto 0));
--END COMPONENT;
--COMPONENT pong_graph_st
--port(	
--		video_on: in std_logic;
--		pixel_y: in std_logic_vector (9 downto 0);
--		pixel_x: in std_logic_vector (10 downto 0);
--		graph_rgb : out std_logic_vector (7 downto 0)
--); 
--END COMPONENT;
COMPONENT ball_animate
port(	
		clk, reset : std_logic;
		video_on: in std_logic;
		pixel_x : in std_logic_vector (10 downto 0) ;
		pixel_y : in std_logic_vector (9 downto 0) ;
		graph_rgb : out std_logic
); 
END COMPONENT;




--Señales
--signal sClk: std_logic;
signal sRes: std_logic;
signal sH_cuenta: std_logic_vector (10 downto 0);
signal sV_cuenta: std_logic_vector (9 downto 0);
signal shsync: std_logic;
signal svsync: std_logic;
signal sblank: std_logic;
signal sRGB: std_logic_vector (7 downto 0);
signal sdibujar: std_logic;
begin
	--clk50MHz <= sClk;
	--reset <= sRes;
	hsync <= shsync;
	vsync <= svsync;
	RGB <= sRGB when (sdibujar='0') else not(sRGB);
	INST_con_hor: contador_horizontal PORT MAP(
		clk50MHz => clk50MHz,
		reset => not(reset),
		h_cuenta => sH_cuenta
	);
	INST_con_ver: contador_vertical PORT MAP(
		hsync => shsync,
		clk50MHz => clk50MHz,
		reset => not(reset),
		v_cuenta => sV_cuenta
	);
	INST_gen_hsync: generador_hsync PORT MAP(
		h_cuenta => sH_cuenta,
		clk50MHz => clk50MHz,
		reset => not(reset),
		hsync => shsync
	);
	INST_gen_vsync: generador_vsync PORT MAP(
		v_cuenta => sV_cuenta,
		clk50MHz => clk50MHz,
		reset => not(reset),
		vsync => svsync
	);
	INST_gen_blank: generador_blank PORT MAP(
		hctr => sH_cuenta,
		vctr => sV_cuenta,
		blank => sblank
	);
	INST_gen_img: image_generator PORT MAP(
		hctr => sH_cuenta,
	   vctr => sV_cuenta,
		blank => sblank,
		posicion => posicion,
	   clk50MHz => clk50MHz,
		reset => not(reset),
		RGB => sRGB
	);
	--INST_bola: generador_bola_mov PORT MAP(
		--vsync => svsync ,
		--hctr => sH_cuenta,
		--vctr =>sV_cuenta ,
		--blank => sblank,
		--clk50MHz =>clk50MHz ,
		--reset => not(reset),
		--RGB => RGB		
	--);
--	INST_pong: pong_graph_st PORT MAP(
--		video_on => sblank,
--		pixel_y => sV_cuenta,
--		pixel_x => sH_cuenta,
--		graph_rgb => RGB	
--	);
	INST_pong_animado: ball_animate PORT MAP(
		clk => clk50MHz ,
		reset => not(reset),
		video_on => sblank,
		pixel_x => sH_cuenta,
		pixel_y => sV_cuenta,
		graph_rgb => sdibujar	
	);
	
end comportamiento;