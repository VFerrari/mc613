library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
use work.boliche_pack.all;
use work.boliche_tipos.all;

entity calcula_pontos is
port (clk    		: in std_logic;
		enable      : in std_logic;
		reset 		: in std_logic;
		botao       : in std_logic;
		pinos       : in std_logic_vector(9 downto 0);
		turno       : in std_logic_vector(3 downto 0);
		jog_atual	: in std_logic_vector(2 downto 0);
		pontos_jog	: out std_logic_vector(8 downto 0);
		jogada_atual: out std_logic_vector(1 downto 0);
		acabou 		: out std_logic
	  );
end calcula_pontos;

architecture calc of calcula_pontos is

--Sinais

signal pontos_totais  : vetor_pontos;
signal strikes	 : vetor_st_total;
signal spares	 : vetor_sp_total;
signal pontos_1   : std_logic_vector(3 downto 0) := "0000";
signal pontos_2   : std_logic_vector(3 downto 0) := "0000";
signal pontos_3   : std_logic_vector(3 downto 0) := "0000";
signal jogada_at : std_logic_vector(1 downto 0) := "00";

signal ativar         : std_logic := '0';
signal prox_jog    : std_logic := '0';


signal temp  : std_logic_vector(8 downto 0) := "000000000";
signal lixo  : std_logic_vector(1 downto 0) := "01";

begin
								
	rod: rodada port map(clk, 
							   reset, 
							   enable,
							   botao, 
							   pinos,
							   turno,
							   jogada_at,
							   pontos_1, 
							   pontos_2,
							   pontos_3, 
							   strikes(to_integer(unsigned(jog_atual))) (to_integer(unsigned(turno))), 
							   spares(to_integer(unsigned(jog_atual))) (to_integer(unsigned(turno))), 
							   prox_jog);

	process(clk)
	begin
		if(rising_edge(clk)) then
			ativar <= prox_jog; --reset or prox_jog;
		end if;
	end process;
	
	process(ativar)
		variable ind_jog : integer;
		variable ind_tur: integer;
		variable pontos_rod: std_logic_vector(8 downto 0);
		variable pontos1, pontos2, pontos3 : std_logic_vector(3 downto 0);
		
	begin
		if(rising_edge(ativar)) then
			if(reset = '1') then
				pontos_totais <= (others => (others => '0'));
				strikes <= (others => (others => (others => '0')));
				spares <= (others => (others => (others => '0')));
				
			elsif(enable = '1') then
				ind_jog    := to_integer(unsigned(jog_atual));
				pontos_rod := "000000000";
				pontos1    := pontos_1;
				pontos2    := pontos_2;
				pontos3    := pontos_3;					
				
				--Caso especial : turno 1 (soma os pontos apenas)
				if (turno = "0001") then
					pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1) + unsigned(pontos2));
				
				--Caso especial : turno 2 (soma os pontos e verifica turno 1)
				elsif (turno = "0010") then			
					pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1) + unsigned(pontos2));
					
					-- Casos de strike e spare no turno 1
					if (strikes(ind_jog)(1)(1) = '1') then
						pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1) + unsigned(pontos2));
					elsif (spares(ind_jog)(1)(2) = '1') then
						pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1));
					end if;
				
				-- Turnos de 3 a 9
				elsif (turno < "1010") then
					ind_tur := to_integer(unsigned(turno));
					
					-- Soma dos pontos
					pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1) + unsigned(pontos2));
					
					-- Caso de spare no turno anterior
					if(spares(ind_jog)(ind_tur-1)(2) = '1') then
						pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1));						
					
					-- Caso de strike no turno anterior
					elsif(strikes(ind_jog)(ind_tur-1)(1) = '1') then
						pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1) + unsigned(pontos2));
						
						-- Caso de duplo strike (woah)
						if (strikes(ind_jog)(ind_tur-2)(1) = '1') then
							pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1));
						end if;
					end if;
					
				-- Turno final - ate 3 jogadas
				else
				
					-- Soma dos pontos
					pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1) + unsigned(pontos2) + unsigned(pontos3));
					
					-- Caso strike no turno 9
					if (strikes(ind_jog)(9)(1) = '1') then
						pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1) + unsigned(pontos2));
					
						-- Caso de duplo strike (woah)
						if (strikes(ind_jog)(8)(1) = '1') then
							pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1));
						end if;
						
					-- Caso spare no turno 9
					elsif (spares(ind_jog)(9)(2) = '1') then
						pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1));
					end if;
				end if;
				
				--pontos_totais(ind_jog) <= std_logic_vector(unsigned(pontos_totais(ind_jog)) + unsigned(pontos_rod));
				temp <= std_logic_vector(unsigned(pontos_rod));
				
			end if;
		end if;
	end process;
	
	--pontos_jog <= pontos_totais(to_integer(unsigned(jog_atual)));
	pontos_jog <= temp;
	jogada_atual <= jogada_at;
	acabou <= prox_jog;
	
end calc;