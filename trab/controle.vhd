library ieee ; 
use ieee.std_logic_1164.all ;

entity controle is
port(clk  : in std_logic;
	  reset: in std_logic;
	  w    : in std_logic;
	  z    : out std_logic_vector(2 downto 0)
	 );

end controle;

architecture comportamento of controle is

type State_type is (inicio, meio, fim);
signal estado : State_type := inicio;

signal troca : std_logic;

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			troca <= reset or w;
		end if;
	end process;
	
	process(troca)
	begin
		if (rising_edge(troca)) then
			if (reset = '1') then
				estado <= inicio;
			else
				case estado is
				when inicio =>
					estado <= meio;
				
				when meio =>
					estado <= fim;
				
				when fim =>
					estado <= fim;
				end case;
			end if;
		end if;
	end process;
	
	z <= "001" when estado = inicio else "010" when estado = meio else "100";

end comportamento;