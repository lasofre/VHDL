library ieee;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;
entity out_regs is
GENERIC( 
	 addressBitNb           : positive := 8;
	 registerBitNb          : positive := 8;
	 programCounterBitNb    : positive := 10;
	 stackPointerBitNb      : positive := 5;
	 registerAddressBitNb   : positive := 4;
	 scratchpadAddressBitNb : natural  := 6
  );
port(
	clk, reset: in std_logic;
	sw: in std_ulogic_vector (7 downto 0) ;
	led: out std_ulogic_vector (7 downto 0)
);
end out_regs;
architecture arch of out_regs is

signal salida : std_ulogic_vector (7 downto 0) ;
signal entrada : std_ulogic_vector (7 downto 0) ;
signal led_reg : std_ulogic_vector (7 downto 0) ;
signal sWriteStorbe : std_logic;

COMPONENT nanoblaze
  GENERIC( 
    addressBitNb           : positive := 8;
    registerBitNb          : positive := 8;
    programCounterBitNb    : positive := 10;
    stackPointerBitNb      : positive := 5;
    registerAddressBitNb   : positive := 4;
    scratchpadAddressBitNb : natural  := 6
  );
  PORT( 
    reset       : IN     std_ulogic;
    clock       : IN     std_ulogic;
    en          : IN     std_ulogic;
    dataAddress : OUT    unsigned(addressBitNb-1 DOWNTO 0);
    dataOut     : OUT    std_ulogic_vector(registerBitNb-1 DOWNTO 0);
    dataIn      : IN     std_ulogic_vector(registerBitNb-1 DOWNTO 0);
    readStrobe  : OUT    std_uLogic;
    writeStrobe : OUT    std_uLogic;
    int         : IN     std_uLogic;
    intAck      : OUT    std_ulogic
  );
END COMPONENT;




begin

inst_nanoblaze: nanoblaze
 GENERIC MAP (
    addressBitNb           => addressBitNb,
    registerBitNb          => registerBitNb, 
    programCounterBitNb    => programCounterBitNb, 
    stackPointerBitNb      => stackPointerBitNb, 
    registerAddressBitNb   => registerAddressBitNb, 
    scratchpadAddressBitNb => scratchpadAddressBitNb
 )
port map(
    reset  => reset,
    clock  => clk,
    en     => '1',
    dataAddress => open,
    dataOut     => salida,
    dataIn      => entrada,
    readStrobe  => open,
    writeStrobe => sWriteStorbe,
    int         => '0',
    intAck      => open
);
--============================================= 
-- output interface
--============================================= 
process (clk)
begin
if rising_edge(clk) then
	if sWriteStorbe ='1' then
		led_reg <= salida;
	end if;
end if;
end process;
led <= led_reg;

--============================================= 
-- input interface
--============================================= 

entrada <= sw;

end arch;