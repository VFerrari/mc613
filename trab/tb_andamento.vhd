library ieee;
use ieee.std_logic_1164.all;
use work.boliche_pack.all;
use work.boliche_tipos.all;

entity tb_andamento is
end tb_andamento;


architecture tb of tb_andamento is
	signal clk			: std_logic;
	signal botao  		:  std_logic;
	signal pinos  		:  std_logic_vector(9 downto 0) := "1000000000";
	signal pontos_atuais:  vetor_disp;
	signal jogador_atual:  std_logic_vector(6 downto 1);
	signal turno_atual  :  std_logic_vector(6 downto 0);
	signal jogada_atual :  std_logic_vector(6 downto 0);
  	signal pontos 		:  vetor_pontos;
	signal fim_partida  : std_logic;
begin
	process(clk)
	begin
		clk <= not(clk) after 50 ps;
	end process;

	anda : andamento port map (clk, '1', '0', botao, "011", pinos, pontos_atuais, jogador_atual, turno_atual, jogada_atual, pontos, fim_partida);

	process
	begin
		botao <= '0';

		wait for 2 ns;
		botao <= '1';

		wait for 2 ns;
		botao <= '0';
		
		wait for 2 ns;
		botao <= '1';

		wait for 2 ns;
		botao <= '0';
		
		wait for 2 ns;
		botao <= '1';

		wait for 2 ns;
		botao <= '0';
		
		wait for 2 ns;
		botao <= '1';

		wait for 2 ns;
		botao <= '0';

		wait for 2 ns;
		botao <= '1';

		wait for 2 ns;
		botao <= '0';
		
		wait for 2 ns;
		botao <= '1';

		wait for 2 ns;
		botao <= '0';

		wait for 2 ns;
		botao <= '1';

		wait for 2 ns;
		botao <= '0';
		
		wait for 2 ns;
		botao <= '1';

		wait for 2 ns;
		botao <= '0';


		wait for 2 ns;
		botao <= '1';

		wait for 2 ns;
		botao <= '0';
		
		wait for 2 ns;
		botao <= '1';

		wait for 2 ns;
		botao <= '0';

		wait for 2 ns;
		botao <= '1';

		wait for 2 ns;
		botao <= '0';
		
		wait for 2 ns;
		botao <= '1';

		wait for 2 ns;
		botao <= '0';
		
	end process;
end tb;