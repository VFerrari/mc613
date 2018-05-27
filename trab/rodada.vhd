library ieee ; 
use ieee.std_logic_1164.all ; 
use work.boliche_pack.all;

entity rodada is
port (clk    : in std_logic;
		reset  : in std_logic;
		arremesso : in std_logic;
		pinos  : in std_logic_vector(9 downto 0);
		turno  : in std_logic_vector(3 downto 0);
		jogada : out std_logic_vector(1 downto 0);
		pontos : out std_logic_vector(3 downto 0);
		strike : out std_logic;
		spare  : out std_logic;
		acabou : out std_logic
	  );
end rodada;

architecture comportamento of rodada is

type State_type is (primeira, segunda);
signal estado : State_type := primeira;
signal ativar : std_logic;
signal pinos_buff : std_logic_vector(9 downto 0);

begin

	ativar <= clk and arremesso;

	process(ativar)
	begin
		if (rising_edge(ativar)) then
			case estado is
			when primeira =>
			
				pinos_buff <= pinos;
				if (pinos_buff /= "1111111111") then
					
					strike <= '0';
					spare <= '0';
					jogada <= "10";
					acabou <= '0';
					estado <= segunda;
					
				else
					strike <= '1';
					spare <= '0';
					jogada <= "01";
					acabou <= '1';
					estado <= primeira;
					
				end if;
				
			when segunda =>
				pinos_buff <= pinos_buff or pinos;
				
				if (pinos_buff = "1111111111") then
					spare <= '1';
				else 
					spare <= '0';
				end if;
				
				strike <= '0';
				jogada <= "01";
				acabou <= '1';
				estado <= primeira;
				
			end case;
			
		end if;
	end process;
	
	C1: cont_1 port map (pinos_buff , pontos);
	

end comportamento;