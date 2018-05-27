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
signal pinos_buff : std_logic_vector(9 downto 0) := "0000000000";

begin
		
	process(clk)
	begin
		if(rising_edge(clk)) then
			ativar <= reset or arremesso;
		end if;
	end process;
		
	process(ativar)
	begin
		if (rising_edge(ativar)) then
			if(reset = '1') then
				strike <= '0';
				spare <= '0';
				pinos_buff <= "0000000000";
				estado <= primeira;
			else
				case estado is
				when primeira =>
				
					pinos_buff <= pinos;
					if (pinos = "1111111111") then
						
						strike <= '1';
						spare <= '0';
						estado <= primeira;
					else
						strike <= '0';
						spare <= '0';
						estado <= segunda;
					end if;
					
				when segunda =>
					pinos_buff <= pinos;
					if (pinos = "1111111111") then
						spare <= '1';
					else 
						spare <= '0';
					end if;
					
					strike <= '0';
					estado <= primeira;
					
				end case;
			end if;
		end if;
	end process;
	
	jogada <= "10" when (estado = segunda and reset = '0') else "01";
	acabou <= ativar when (estado = primeira and reset = '0') else '0';
	
	C1: cont_1 port map (pinos_buff , pontos);
	

end comportamento; 	