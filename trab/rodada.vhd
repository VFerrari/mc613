library ieee ; 
use ieee.std_logic_1164.all ; 
use work.boliche_pack.all;

entity rodada is
port (clk    : in std_logic;
		reset  : in std_logic;
		enable : in std_logic;
		arremesso : in std_logic;
		pinos  : in std_logic_vector(9 downto 0);
		jogada : out std_logic_vector(1 downto 0);
		pontos1 : out std_logic_vector(3 downto 0);
		pontos2 : out std_logic_vector(3 downto 0);
		strike : out std_logic;
		spare  : out std_logic;
		acabou : out std_logic
	  );
end rodada;

architecture comportamento of rodada is

type State_type is (primeira, segunda);
signal estado : State_type := primeira;
signal ativar : std_logic;
signal pinos_1 : std_logic_vector(9 downto 0) := "0000000000";
signal pinos_2 : std_logic_vector(9 downto 0) := "0000000000";

signal pinos_cont_2 : std_logic_vector(9 downto 0) := "0000000000";

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
				pinos_1 <= "0000000000";
				pinos_2 <= "0000000000";
				estado <= primeira;
			elsif (enable = '1') then
				case estado is
				when primeira =>
				
					pinos_1 <= pinos;
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
					pinos_2 <= pinos;
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
	acabou <= ativar when (estado = primeira and reset = '0' and enable = '1') else '0';
	
	pinos_cont_2 <= "0000000000" when (estado = segunda or pinos_1 = "1111111111") else (pinos_2 xor pinos_1);
	
	C1: cont_1 port map (pinos_1 , pontos1);
	C2: cont_1 port map (pinos_cont_2 , pontos2);
	

end comportamento; 	