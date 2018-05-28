library ieee ; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.boliche_pack.all;
use work.boliche_tipos.all;

entity boliche is
port (SW  : in std_logic_vector(9 downto 0) ; 
		KEY : in std_logic_vector(3 downto 0) ;
		CLOCK_50 : in std_logic;
		LEDR: out std_logic_vector(9 downto 0);
		HEX0,	HEX1,	HEX2,	HEX3,	HEX4,	HEX5: out std_logic_vector(6 downto 0)
		);
end boliche ; 

architecture logica of boliche is

--Sinais de controle
signal secao  : std_logic_vector(2 downto 0) := "001";
signal fim_ini, fim_meio, fim_ord : std_logic;
signal avanca : std_logic;

-- Sinais de jogo
signal n_jog : std_logic_vector(2 downto 0);

-- Sinais de saida
signal disp_ini : std_logic_vector(6 downto 0);

signal jog_atual : std_logic_vector(6 downto 0);
signal turno_atual : std_logic_vector(6 downto 0);
signal jogada_atual : std_logic_vector(6 downto 0);

--Teste
signal disp_jog_fim : std_logic_vector(6 downto 0);
signal pontos_meio 	 : vetor_disp;
signal pontos_d       : vetor_disp;
signal pontos			 : vetor_pontos := ("000101010", "100000000", "100101100", "000010101", "000000000","001010000");
signal jogs				 : vetor_jogs;
signal pos_pontos		 : vetor_pontos;


begin
	avanca <= fim_ini when secao(0) = '1' else fim_ord when secao = "000" else '0';
	maq : controle port map(CLOCK_50, not(KEY(0)), avanca, secao);
	
	ini: inicializador port map(CLOCK_50, secao(0), not(KEY(3)), SW(6 downto 1), fim_ini, n_jog, disp_ini);
	meio: andamento port map(CLOCK_50, secao(1), not (KEY(0)), not(KEY(3)), n_jog, SW(9 downto 0), pontos_meio, jog_atual, turno_atual, jogada_atual, pontos, fim_meio);
	sort: ordena port map(CLOCK_50, pontos, pos_pontos, jogs);
	fim: final port map(CLOCK_50, secao(2), not(KEY(0)), n_jog, jogs, pos_pontos, pontos_d, disp_jog_fim);
	
	HEX0 <= pontos_d(2) when secao(1) = '1' else disp_ini when secao(0) = '1' else "1111111";
	HEX1 <= pontos_d(1) when secao(1) = '1' else "1111111";
	HEX2 <= pontos_d(0) when secao(1) = '1' else "1111111";
	HEX3 <= "1111111";
	HEX4 <= "1111111";
	HEX5 <= disp_jog_fim when secao(1) = '1' else "1111111";
	
	LEDR(to_integer(unsigned(jogs(1)))) <= '1' when secao(1) = '1' else '0';
	
end logica;