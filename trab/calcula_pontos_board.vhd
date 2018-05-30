library ieee;
use ieee.std_logic_1164.all;
use work.boliche_pack.all;

entity calcula_pontos_board is
	port(CLOCK_50 : in std_logic;
		  SW : in std_logic_vector(9 downto 0);
		  KEY: in std_logic_vector(3 downto 0);
		  HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : out std_logic_vector(6 downto 0)
		 );
end calcula_pontos_board;

architecture board of calcula_pontos_board is

signal pontos_jog : std_logic_vector(8 downto 0);
signal jogada_at : std_logic_vector (1 downto 0);
signal pontos_bcd: std_logic_vector(11 downto 0);

signal disps: std_logic_vector(20 downto 0) := "111111111111111111111";

begin

	calc : calcula_pontos port map(CLOCK_50, '1', not(KEY(0)), not(KEY(2)), "1111111" & SW(9 downto 7), SW(6 downto 3), SW(2 downto 0), pontos_jog, jogada_at, open);
	
	bcd   : conversor_bcd port map (CLOCK_50, pontos_jog, pontos_bcd);
	
	G1: for i in 0 to 2 generate
		disp_i : bin2dec port map (pontos_bcd((i*4)+3 downto i*4), disps((i*7)+6 downto i*7));
	end generate;
	
	HEX0 <= disps(6 downto 0);
	HEX1 <= disps(13 downto 7);
	HEX2 <= disps(20 downto 14);
	HEX3 <= "1111111";
	HEX4 <= "1111111";
	
	disp2 : bin2dec port map ("00" & jogada_at, HEX5);

end board;