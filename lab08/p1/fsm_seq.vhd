library ieee;
use ieee.std_logic_1164.all;

entity fsm_seq is
port (
     clock : in  std_logic;
     reset : in  std_logic;
     w     : in  std_logic;
     z     : out std_logic
);
end fsm_seq;


architecture Behavior of fsm_seq is

type State_type is (A,B,C,D,E);
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
						then state <= B;
						else state <= A;
					end if;
				when B =>
					if (w = '0')
						then state <= B;
						else state <= C;
					end if;
				when C =>
					if (w = '0')
						then state <= D;
						else state <= A;
					end if;
				when D =>
					if (w = '0')
						then state <= B;
						else state <= E;
					end if;				
				when E =>
					if (w = '0')
						then state <= D;
						else state <= A;
					end if;
				end case;
			end if;
	end if;
	end process;

	-- Output
	z <= '1' when state = E else '0';

end Behavior;
