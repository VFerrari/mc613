library ieee;
use ieee.std_logic_1164.all;

entity fsm_diag is
port (
     clock : in  std_logic;
     reset : in  std_logic;
     w     : in  std_logic;
     z     : out std_logic
);
end fsm_diag;


architecture Behavior of fsm_diag is

type State_type is (A,B,C,D);
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
					if (w = '0')
						then state <= A;
						else state <= B;
					end if;
				when B =>
					if (w = '0')
						then state <= C;
						else state <= B;
					end if;
				when C =>
					if (w = '0')
						then state <= C;
						else state <= D;
					end if;
				when D =>
					if (w = '0')
						then state <= A;
						else state <= D;
					end if;				
				end case;
			end if;
	end if;
	end process;

	-- Output
	z <= '1' when state = B else '0';

end Behavior;
