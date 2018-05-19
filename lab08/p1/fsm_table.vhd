library ieee;
use ieee.std_logic_1164.all;

entity fsm_table is
port (
     clock : in  std_logic;
     reset : in  std_logic;
     w     : in  std_logic;
     z     : out std_logic
);
end fsm_table;


architecture Behavior of fsm_table is

type State_type is (A, B, C, D);
signal state : State_type := A;

begin
	
	-- State machine
	process(clock)
	begin
		if (clock'event and clock = '1') then
			if (reset = '1') then
				state <= A;
			else
				case state is
				when A =>
					if (w = '0') then 
						state <= C;
					 else 
						state <= B;	
					end if;
				when B =>
					if (w = '0') then
						state <= D;
					else 
						state <= C;
					end if;
				when C =>
					if (w = '0') then 
						state <= B;
					else 
						state <= C;
					end if;
				when D =>
					if (w = '0') then
						state <= A;
					else 
						state <= C;
					end if;
				end case;
			end if;
		end if;
	end process;
	
	
	-- Output
	process (state, w)
	begin
		case state is
		when A =>
			z <= '1';
		when B =>
			z <= not(w);
		when C =>
			z <= '0';
		when D =>
			z <= w;
		end case;
	end process;
	
end Behavior;
