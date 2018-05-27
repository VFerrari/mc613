library ieee; 
use ieee.std_logic_1164.all;

entity jogadores is
	port(clk   : in std_logic;
		  reset : in std_logic;
		  troca : in std_logic;
		  n_jog : in std_logic_vector(2 downto 0);
		  comeco: out std_logic;
		  jog_at: out std_logic_vector(2 downto 0)
		 );
end jogadores;

architecture estados of jogadores is

type State_type is (jog1, jog2, jog3, jog4, jog5, jog6);
signal estado : State_type := jog1;

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				estado <= jog1;
			else
				case estado is
				when jog1 =>
					if (troca = '1') then
						if (n_jog > "001") then
							estado <= jog2;
						else
							estado <= jog1;
						end if;
					end if;
					
				when jog2 =>
					if (troca = '1') then
						if (n_jog > "010") then
							estado <= jog3;
						else
							estado <= jog1;
						end if;
					end if;
				
				when jog3 =>
					if (troca = '1') then
						if (n_jog > "011") then
							estado <= jog4;
						else
							estado <= jog1;
						end if;
					end if;
				
				when jog4 =>
					if (troca = '1') then
						if (n_jog > "100") then
							estado <= jog5;
						else
							estado <= jog1;
						end if;
					end if;
					
				when jog5 =>
					if (troca = '1') then
						if (n_jog > "101") then
							estado <= jog6;
						else
							estado <= jog1;
						end if;
					end if;
				
				when jog6 =>
					if (troca = '1') then
						estado <= jog1;
					end if;
				end case;
			end if;
		end if;
	end process;

	comeco <= '1' when estado = jog1 else '0';
	
	with estado select
		jog_at <= "001" when jog1,
					 "010" when jog2,
					 "011" when jog3,
					 "100" when jog4,
					 "101" when jog5,
					 "110" when jog6;
	
end estados;