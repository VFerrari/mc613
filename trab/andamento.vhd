library ieee ; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
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
  		  pontos 		: out vetor_pontos;
		  fim_partida  : out std_logic
		 );
end andamento;


architecture jogo of andamento is

-- Sinais internos
signal pontos_jogo : vetor_pontos;
signal pontos_bcd  : std_logic_vector(11 downto 0);

-- Sinais externos
signal fim_turno   : std_logic := '1';
signal turno_at    : std_logic_vector (3 downto 0);
signal jogador_at	 : std_logic_vector (2 downto 0);
signal jogada_at   : std_logic_vector (2 downto 0);
signal prox_jog    : std_logic := '0';

begin
	maq_jogs   : jogadores port map(clk, reset, prox_jog, n_jog, fim_turno, jogador_at);
	maq_turnos : turnos port map(clk, reset, fim_turno, turno_at, fim_partida);

	process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				pontos_jogo <= (others => (others => '0'));
				pontos_bcd <= (others => '0');
			elsif (enable = '0') then
				prox_jog <= '0';
			end if;
		end if;
	end process;
	
	--Logica geral
	
	
	--Saidas
	bcd_pontos: conversor_bcd port map (pontos_jogo(to_integer(unsigned(jogador_at))-1), pontos_bcd);
	G1: for i in 0 to 2 generate
		disp_pontos : bin2dec port map (pontos_bcd(i+3 downto i), pontos_atuais(i));
	end generate;
	
	disp_turno : bin2dec port map(turno_at, turno_atual);
	disp_jogada: bin2dec port map(jogada_at, jogada_atual);
	
	jogador_atual <= jogador_at;
	pontos <= pontos_jogo;
	
end jogo;