library ieee ; 
use ieee.std_logic_1164.all ; 
use work.boliche_pack.all;

entity rodada is
port (clk    : in std_logic;
		reset  : in std_logic;
		enable : in std_logic;
		arremesso : in std_logic;
		pinos  : in std_logic_vector(9 downto 0);
		turno  : in std_logic_vector(3 downto 0);
		jogada : out std_logic_vector(1 downto 0);
		pontos1 : out std_logic_vector(3 downto 0);
		pontos2 : out std_logic_vector(3 downto 0);
		pontos3 : out std_logic_vector(3 downto 0);
		strikes : out std_logic_vector(0 to 2);
		spares  : out std_logic_vector(0 to 1);
		acabou : out std_logic
	  );
end rodada;

architecture comportamento of rodada is

type State_type is (primeira, segunda, terceira);
signal estado : State_type := primeira;
signal estado_ant : State_type;
signal ativar : std_logic;
signal pinos_1 : std_logic_vector(9 downto 0) := "0000000000";
signal pinos_2 : std_logic_vector(9 downto 0) := "0000000000";
signal pinos_3 : std_logic_vector(9 downto 0) := "0000000000";
signal pinos_cont_2 : std_logic_vector(9 downto 0) := "0000000000";
signal pinos_cont_3 : std_logic_vector(9 downto 0) := "0000000000";

signal strikes_buff : std_logic_vector(1 to 3) := "000";
signal spares_buff  : std_logic_vector(2 to 3) := "00";

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
				strikes_buff <= "000";
				spares_buff <= "00";
				pinos_1 <= "0000000000";
				pinos_2 <= "0000000000";
				pinos_3 <= "0000000000";
				estado <= primeira;
				estado_ant <= primeira;
				
			elsif(enable = '1') then
				case estado is
				
				when primeira =>
				
					pinos_1 <= pinos;
					if (pinos = "1111111111") then
						strikes_buff(1) <= '1';
						
						if (turno /= "1010") then
							estado <= primeira;
						else
							estado <= segunda;
						end if;
						
					else
						strikes_buff(1) <= '0';
						estado <= segunda;
					end if;
					
					strikes_buff(2) <= '0';
					strikes_buff(3) <= '0';
					spares_buff <= "00";
					estado_ant <= primeira;
					
				when segunda =>
				
					pinos_2 <= pinos;
					if (pinos = "1111111111" and ((pinos_1 xor pinos) = "0000000000")) then
						strikes_buff(2) <= '1';
						spares_buff(2) <= '0';
						estado <= terceira;
					elsif(pinos = "1111111111") then
						spares_buff(2) <= '1';
						strikes_buff(2) <= '0';
						
						if (turno = "1010") then
							estado <= terceira;
						else
							estado <= primeira;
						end if;
						
					else
						spares_buff(2) <= '0';
						strikes_buff(2) <= '0';
						
						if (pinos_1 = "1111111111") then
							estado <= terceira;
						else
							estado <= primeira;
						end if;
						
					end if;

					estado_ant <= segunda;					
				when terceira =>
				
					pinos_3 <= pinos;
					if(pinos = "1111111111" and (pinos_2 xor pinos) = "0000000000") then
						strikes_buff(3) <= '1';
						spares_buff(3) <= '0';
					elsif(pinos = "1111111111") then
						strikes_buff(3) <= '0';
						spares_buff(3) <= '1';
					else
						strikes_buff(3) <= '0';
						spares_buff(3) <= '0';
					end if;
					estado <= primeira;
					estado_ant <= terceira;
					
				end case;
			end if;
		end if;
	end process;
	
	jogada <= "11" when (estado = terceira and reset = '0') else "10" when (estado = segunda and reset = '0') else "01";
	acabou <= ativar when (estado = primeira and reset = '0' and enable = '1') else '0';
	
	pinos_cont_2 <= "0000000000" when (estado_ant = primeira) else (pinos_2 xor pinos_1) when strikes_buff(1) = '0' else pinos_2;
	pinos_cont_3 <= "0000000000" when (estado_ant /= terceira) else pinos_3 when (spares_buff(2) = '1' or strikes_buff(2) = '1') else (pinos_3 xor pinos_2);
	
	C1: cont_1 port map (pinos_1 , pontos1);
	C2: cont_1 port map (pinos_cont_2 , pontos2);
	C3: cont_1 port map (pinos_cont_3 , pontos3);
	
	strikes <= strikes_buff;
	spares <= spares_buff;
	
end comportamento; 	