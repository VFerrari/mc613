library ieee ; 
use ieee.std_logic_1164.all ;

use work.boliche_pack.all;

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

-- Sinais de saida
signal disp_ini : std_logic_vector(6 downto 0);

begin
	maq : controle port map(CLOCK_50, not(KEY(0)), fim_ini, secao);
	
	ini: inicializador port map(CLOCK_50, secao(0), not(KEY(3)), SW(6 downto 1), fim_ini, n_jog, disp_ini);
	--meio: andamento port map(CLOCK_50, secao(1), not (KEY(0)), SW);
	--fim: final port map(CLOCK_50, secao(2), not(KEY(0)), );
	
	HEX0 <= disp_ini when secao(0) = '1' else "1111111";
	
end logica;