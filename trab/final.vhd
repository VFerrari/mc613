library ieee ; 
use ieee.std_logic_1164.all ;

use work.boliche_pack.all;

entity final is
	port(clock       : in std_logic;
		  enable      : in std_logic;
		  reset       : in std_logic;
		  n_jog       : in std_logic_vector(2 downto 0);
		  pontos_1    : in std_logic_vector(8 downto 0);
		  pontos_2    : in std_logic_vector(8 downto 0);
		  pontos_3    : in std_logic_vector(8 downto 0);
		  pontos_4    : in std_logic_vector(8 downto 0);
		  pontos_5    : in std_logic_vector(8 downto 0);
		  pontos_6    : in std_logic_vector(8 downto 0);
		  disp_jog    : out std_logic_vector(6 downto 0);
		  disp_pontos1: out std_logic_vector(6 downto 0);
		  disp_pontos2: out std_logic_vector(6 downto 0);
		  disp_pontos3: out std_logic_vector(6 downto 0);
		 );
end final;


architecture placar of final is

signal muda_placar  : std_logic;
signal lixo			  : std_logic;
signal jog_atual    : std_logic_vector(2 downto 0) := "001";
signal jog_pontos	  : std_logic_vector(2 downto 0);
signal pontos_atuais: std_logic_vector(8 downto 0); 
signal pontos_bcd   : std_logic_vector(11 downto 0);

begin

	timing : clk_div generic map (149999999) port map(clock, enable, muda_placar);
	ordem  : jogadores port map(clock, reset, muda_placar, n_jog, lixo, jog_atual);
	
	with jog_atual select
		pontos_atuais <= pontos_1 when "001",
							  pontos_2 when "010",
							  pontos_3 when "011",
							  pontos_4 when "100",
							  pontos_5 when "101",
							  pontos_6 when others;

	with jog_atual select
	jog	 : bin2dec port map(jog_atual, disp_jog); 
	pont_menos_sig : bin2dec port map(pontos_bcd(3 downto 0), disp_pontos1);
	pont_meio_sig  : bin2dec port map(pontos_bcd(7 downto 4), disp_pontos2);
	pont_mais_sig  : bin2dec port map(pontos_bcd(11 downto 8), disp_pontos3); 

end placar;