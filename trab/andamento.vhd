library ieee ; 
use ieee.std_logic_1164.all;
use work.boliche_pack.all;
use work.boliche_tipos.all;

entity andamento is
	port(clk    		: in std_logic;
		  reset  		: in std_logic;
		  enable 		: in std_logic;
		  botao  		: in std_logic;
		  n_jog  		: in std_logic_vector(2 downto 0);
		  pinos  		: in std_logic_vector(9 downto 0);
		  pontos_atuais: out vetor_disp;
		  jogador_atual: out std_logic_vector(2 downto 0);
		  turno_atual  : out std_logic_vector(6 downto 0);
		  jogada_atual : out std_logic_vector(6 downto 0);
  		  pontos 		: out vetor_pontos
		  fim_partida  : out std_logic;
		 );
end andamento;


architecture jogo of andamento is

signal pontos_jogo : vetor_pontos;
signal pontos_bcd  : std_logic_vector(11 downto 0);
signal fim_turno   : std_logic := '1';
signal turno_at    : std_logic_vector (3 downto 0);
signal jogador_at	 : std_logic_vector (2 downto 0);
signal jogada_at   : std_logic_vector (2 downto 0);
signal prox_jog    : std_logic;

begin
	maq_jogs   : jogadores port map(clk, reset, prox_jog, n_jog, fim_turno, jogador_at);
	maq_turnos : turnos port map(clk, reset, fim_turno, turno_at, fim_partida);

	--Logica geral
	
	
	--Saidas
	bcd_pontos: conversor_bcd port map (clk, reset, "000" & pontos_jogo(to_integer(unsigned(jogador_at))-1), pontos_bcd);
	G1: for i in 0 to 2 generate
		disp_pontos : bin2dec port map (pontos_bcd(i+3 downto i), pontos_atuais(i));
	
	disp_turno : bin2dec port map(turno_at, turno_atual);
	disp_jogada: bin2dec port map(jogada_at, jogada_atual);
	
	jogador_atual <= jogador_at;
	pontos <= pontos_jogo;
	
end jogo;