library ieee ; 
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all; 
use work.boliche_pack.all;

entity final is
	port(clock       : in std_logic;
		  enable      : in std_logic;
		  reset       : in std_logic;
		  n_jog       : in std_logic_vector(2 downto 0);
		  jogs		  : in vetor_jogs;
		  pontos      : in vetor_pontos;
		  disp_pontos : out vetor_disp;
		  disp_jog    : out std_logic_vector(6 downto 0);
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
	
	pontos_atuais <= pontos(to_integer(jog_atual)-1);
	jog_pontos <= jogs(to_integer(jog_atual)-1);

	bcd				: conversor_bcd port map(pontos_atuais, pontos_bcd);    
	jog				: bin2dec port map(jog_pontos, disp_jog); 
	pont_menos_sig : bin2dec port map(pontos_bcd(3 downto 0), disp_pontos(2));
	pont_meio_sig  : bin2dec port map(pontos_bcd(7 downto 4), disp_pontos(1));
	pont_mais_sig  : bin2dec port map(pontos_bcd(11 downto 8), disp_pontos(0)); 

end placar;