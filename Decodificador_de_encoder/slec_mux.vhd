-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;

entity slec_mux is

	port(
		input	 : in	std_logic;
		--reset	 : in	std_logic;
		output	 : out	std_logic_vector(1 downto 0)
	);

end entity;

architecture rtl of slec_mux is
	COMPONENT frec_div
    Port ( clk : in  STD_LOGIC;
			  --R: in STD_LOGIC;
			  Co : out STD_LOGIC);
	END COMPONENT;

	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2);

	-- Register to hold the current state
	signal state   : state_type;
	signal sInput : std_logic;

begin
	INST_DIV_FREC_15: frec_div PORT MAP(
		clk => input,
		Co => sInput	
	);





	-- Logic to advance to the next state
	process (sInput)
	begin
		if (rising_edge(sInput)) then
			case state is
				when s0=>
					state <= s1;
				when s1=>
					state <= s2;
				when s2=>
					state <= s0;
			end case;
		end if;
	end process;

	-- Output depends solely on the current state
	process (state)
	begin
		case state is
			when s0 =>
				output <= "00";
			when s1 =>
				output <= "01";
			when s2 =>
				output <= "10";
			when others =>
				output <= "11";
		end case;
	end process;

end rtl;

