library ieee ; 
use ieee.std_logic_1164.all ; 

entity rodada is
port (pinos  : in std_logic_vector(9 downto 0);
		jogador: in std_logic_vector(2 downto 0);
		turno  : in std_logic_vector(3 downto 0);
		jogada : out std_logic_vector(1 downto 0);
		pontos : out std_logic_vector(3 downto 0);
		strike : out std_logic;
		spare  : out std_logic
	  );
end rodada;

architecture comportamento of rodada is

begin

end comportamento;