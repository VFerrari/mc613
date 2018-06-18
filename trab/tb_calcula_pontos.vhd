library ieee;
use ieee.std_logic_1164.all;
use work.boliche_pack.calcula_pontos;

entity tb_calcula_pontos is
end tb_calcula_pontos;

architecture tb of tb_calcula_pontos is

signal clk : std_logic := '0';
signal botao       :  std_logic;
signal pinos       :  std_logic_vector(9 downto 0);
signal turno       :  std_logic_vector(3 downto 0);
signal jog_atual	:  std_logic_vector(2 downto 0);
signal pontos_jog	:  std_logic_vector(8 downto 0);
signal jogada_atual:  std_logic_vector(1 downto 0);
signal strike, spare : std_logic;
signal acabou 		:  std_logic;

begin
	process(clk)
	begin
		clk <= not(clk) after 50 ps;
	end process;

	calc : calcula_pontos port map(clk, '1', '0', botao, pinos, turno, jog_atual, "000000000", pontos_jog, jogada_atual, strike, spare, acabou);
	
	process
	begin
		pinos <= "1110001110";
		turno <= "0010";
		jog_atual <= "001";
		botao <= '0';
		
		wait for 2 ns;
		botao <= '1';
	
		wait for 2 ns;
		botao <= '0';
		pinos <= "1111111110";

		wait for 2 ns;
		botao <= '1';

		wait for 2 ns;
		pinos <= "0000000001";
		turno <= "0010";
		jog_atual <= "010";
		botao <= '0';
		
		wait for 2 ns;
		botao <= '1';
	
		wait for 2 ns;
		botao <= '0';
		pinos <= "1111111111";

		wait for 2 ns;
		botao <= '1';

		wait for 2 ns;
		pinos <= "1111111111";
		turno <= "0011";
		jog_atual <= "001";
		botao <= '0';
		
		wait for 2 ns;
		botao <= '1';
		
		wait for 2 ns;
		botao <= '0';
		pinos <= "0101010101";
		jog_atual <= "010";
		
		wait for 2 ns;
		botao <= '1';
		
		wait for 2 ns;
		botao <= '0';
		
		wait;		
	end process;

end tb;