library ieee ; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.boliche_pack.all;
use work.boliche_tipos.all;

entity andamento is
	port(clk    		: in std_logic;
		  enable 		: in std_logic;
		  reset  		: in std_logic;
		  botao  		: in std_logic;
		  n_jog  		: in std_logic_vector(2 downto 0);
		  pinos  		: in std_logic_vector(9 downto 0);
		  pontos_atuais: out vetor_disp;
		  jogador_atual: out std_logic_vector(6 downto 1);
		  turno_atual  : out std_logic_vector(6 downto 0);
		  jogada_atual : out std_logic_vector(6 downto 0);
  		  pontos 		: out vetor_pontos;
		  fim_partida  : out std_logic
		 );
end andamento;


architecture jogo of andamento is

-- Sinais internos
signal pontos_jogo : vetor_pontos := (others => (others => '0'));
signal pontos_bcd  : std_logic_vector(11 downto 0);
signal pontos_ant  : std_logic_vector(8 downto 0);
signal inicia_jog  : std_logic;
signal delay   : std_logic := '0';
signal troca_jog   : std_logic := '0';
signal prox_jog    : std_logic := '0';
signal indice		 : integer range 1 to 6;

-- Sinais externos
signal pontos_buff : std_logic_vector(8 downto 0) := "000000000";
signal fim_turno   : std_logic := '0';
signal turno_at    : std_logic_vector (3 downto 0);
signal jogador_at	 : std_logic_vector (2 downto 0);
signal jogada_at   : std_logic_vector (1 downto 0);
signal salva_pontos: std_logic;

begin
	prox_jog <= inicia_jog when jogador_at = "000" else troca_jog;
	indice <= to_integer(unsigned(jogador_at));
	
	maq_jogs   : jogadores port map(clk, reset, prox_jog, n_jog, fim_turno, jogador_at);
	maq_turnos : turnos port map(clk, reset, fim_turno, turno_at, fim_partida);
	
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				pontos_jogo <= (others => (others => '0'));
				troca_jog <= '0';
				delay <= '0';
			elsif (salva_pontos = '1') then
				if (delay = '0' and troca_jog = '0') then
					delay <= '1';
				elsif (delay = '1') then
					troca_jog <= '1';
					delay <= '0';
					pontos_jogo(indice) <= pontos_buff;
				end if;
			else
				troca_jog <= '0';
			end if;	
		end if;
	end process;
	
	process(clk)
	begin
		if (rising_edge(clk)) then
		
			-- Inicia proximo turno se necessario
			if (jogador_at = "000" and prox_jog = '0') then
				inicia_jog <= '1';
			else
				inicia_jog <= '0';
			end if;
		end if;
	end process;
	
	--Pontos anteriores
	pontos_ant <= pontos_jogo(indice);
	
	--Logica geral
	logica : calcula_pontos port map(clk, enable, reset, botao, pinos, turno_at, jogador_at, pontos_ant, pontos_buff, jogada_at, salva_pontos);
	
	--Saidas
	bcd_pontos: conversor_bcd port map (clk, pontos_ant, pontos_bcd);
	G1: for i in 0 to 2 generate
		disp_pontos : bin2dec port map (pontos_bcd((i*4)+3 downto i*4), pontos_atuais(i));
	end generate;
	                                                                                                                                                                                                                                                                                                                                                                                      
	disp_turno : bin2dec port map(turno_at, turno_atual);
	disp_jogada: bin2dec port map("00" & jogada_at, jogada_atual);
	
	with jogador_at select
		jogador_atual <= "000001" when "001",
							  "000010" when "010",
							  "000100" when "011",
							  "001000" when "100",
							  "010000" when "101",
							  "100000" when others;

	pontos <= pontos_jogo;
	
end jogo;