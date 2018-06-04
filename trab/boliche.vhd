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
signal fim_ini, fim_meio : std_logic;
signal avanca : std_logic;

-- Sinais de jogo
signal n_jog : std_logic_vector(2 downto 0);
signal pontos			 : vetor_pontos;
signal jogs				 : vetor_jogs;
signal pos_pontos		 : vetor_pontos;

-- Sinais de saida

-- Display
signal disp_ini : std_logic_vector(6 downto 0);
signal turno_disp : std_logic_vector(6 downto 0);
signal jogada_disp : std_logic_vector(6 downto 0);
signal pontos_meio 	 : vetor_disp;
signal pontos_d       : vetor_disp;
signal disp_jog_fim : std_logic_vector(6 downto 0);
signal gira_visores : std_logic_vector(6 downto 0);
signal para_de_girar: std_logic := '1';

-- Leds
signal leds_meio  : std_logic_vector(6 downto 1);
signal leds_fim   : std_logic_vector(6 downto 1);
signal leds			: std_logic_vector(6 downto 1);


begin

	-- Maquina de estados principal
	avanca <= fim_ini when secao(0) = '1' else (fim_meio or not(KEY(1))) when secao(1) = '1' else '0';
	maq : controle port map(CLOCK_50, not(KEY(0)), avanca, secao);
	
	-- Inicio
	ini:  inicializador port map(CLOCK_50,
										  secao(0),			-- Enable
										  not(KEY(3)), 	-- Confirma
										  SW(6 downto 1), -- Selecionador
										  fim_ini, 			-- Sinal de fim
										  n_jog, 			-- Numero de jogadores
										  disp_ini);		-- Display
										  
	-- Andamento do jogo
	meio: andamento 	  port map(CLOCK_50,
										  secao(1),			-- Enable 
										  not(KEY(0)), 	-- Reset
										  not(KEY(2)), 	-- Confirma
										  n_jog, 			-- Numero de jogadores
										  SW(9 downto 0), -- Pinos
										  pontos_meio, 	-- Pontos atuais (do jogador atual, Display)
										  leds_meio, 		-- Jogador atual (LED)
										  turno_disp, 		-- Turno atual   (Display)
										  jogada_disp, 	-- Jogada atual  (Display)
										  pontos, 			-- Pontos de todos os jogadores
										  gira_visores, 	-- Visores girando (Display)
										  para_de_girar,  -- Sinal para parar de girar os visores
										  fim_meio);		-- Sinal de fim.
										  
	-- Ordenacao
	sort: ordena 		  port map(CLOCK_50, 
										  pontos, 			-- Pontos dos jogadores (em ordem do jogo)
										  pos_pontos, 		-- Pontos dos jogadores (em ordem decrescente)
										  jogs);				-- Indices do jogo dos jogadores (ordenado por posicao).
	
	-- Final
	fim:  final 		  port map(CLOCK_50, 
										  secao(2) and para_de_girar, 		-- Enable
										  not(KEY(0)), 							-- Reset
										  n_jog, 									-- Numero de jogadores
										  jogs, 										-- Jogadores (ordenados por posicao)
										  pos_pontos, 								-- Pontos (em ordem decrescente)
										  pontos_d, 								-- Pontos de um jogador (Display)
										  disp_jog_fim);							-- Jogador correspondente a pontuacao (Display)
	
	
	-- Display
	HEX0 <= gira_visores	  when para_de_girar = '0' else 
			  pontos_d(2)    when secao(2) 		= '1'	else 
			  pontos_meio(0) when secao(1) 		= '1' else 
			  disp_ini 		  when secao(0) 		= '1'	else "1111111";
			  
	HEX1 <= gira_visores   when para_de_girar = '0' else 
			  pontos_d(1)    when secao(2) 		= '1' else 
			  pontos_meio(1) when secao(1) 		= '1' else "1111111";
			  
	HEX2 <= gira_visores   when para_de_girar = '0' else 
			  pontos_d(0) 	  when secao(2) 		= '1' else 
			  pontos_meio(2) when secao(1) 		= '1' else "1111111";
			  
	HEX3 <= gira_visores when para_de_girar = '0' else   "1111111";
	
	HEX4 <= gira_visores when para_de_girar = '0' else 
			  jogada_disp  when secao(1) 		 = '1' else   "1111111";
			  
	HEX5 <= gira_visores when para_de_girar = '0' else 
			  turno_disp 	when secao(1) 		 = '1' else 
			  disp_jog_fim when secao(2) 		 = '1' else   "1111111";
	
	
	-- LEDS

	-- LEDS finais
	leds_fim(1) <= '1' when pos_pontos(1) = pontos(1) else '0';
	leds_fim(2) <= '1' when pos_pontos(1) = pontos(2) else '0';
	leds_fim(3) <= '1' when pos_pontos(1) = pontos(3) else '0';
	leds_fim(4) <= '1' when pos_pontos(1) = pontos(4) else '0';
	leds_fim(5) <= '1' when pos_pontos(1) = pontos(5) else '0';
	leds_fim(6) <= '1' when pos_pontos(1) = pontos(6) else '0';
	
	LEDR <= ("000" & leds_meio & '0') when (secao(1) = '1') else 
			  ("000" & leds_fim & '0')  when (secao(2) = '1') else "0000000000";
	
	
end logica;