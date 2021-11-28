-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;

entity estados_encoder is

	port(
		--flanco : in	std_logic;
		A : in	std_logic;
		B : in	std_logic;
		reset	 : in	std_logic;
		output	 : out	std_logic
	);

end entity;

architecture rtl of estados_encoder is

	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2, s3, s4);

	-- Register to hold the current state
	signal state   : state_type;
	signal flanco : std_logic;

begin
	flanco <= A xor B;
	-- Logic to advance to the next state
	process (flanco ,  reset)
	begin
		if reset = '1' then
			state <= s0;
		--end if;
		elsif (flanco'event and flanco='1') then 
			case state is 
			  when s0 =>
					if A='1' then
						 state <= S2;
					elsif B='1' then
						 state <= S1;
					end if;
			  when s1 =>
					if A='1' then
						 state <= S4;
					else
						 state <= S1;
					end if;
			  when s2 =>
					if B='1' then
						 state <= S3;
					else
						 state <= S2;
					end if;
			  when s3 =>
					if A='1' then
						 state <= S2;
					elsif B='1' then
						 state <= S1;
					end if;
			  when s4 =>
					if A='1' then
						 state <= S2;
					elsif B='1' then
						 state <= S1;
					end if; 								
			end case;
	end if;
	end process;

	-- Output depends solely on the current state
	process (state)
	begin
		case state is
			when s0 =>
				output <= '1';
			when s1 =>
				output <= '0';
			when s2 =>
				output <= '1';
			when s3 =>
				output <= '1';
			when s4 =>
				output <= '0';
		end case;
	end process;

end rtl;


