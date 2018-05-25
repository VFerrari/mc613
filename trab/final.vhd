library ieee ; 
use ieee.std_logic_1164.all ;

use work.boliche_pack.all;

entity final is
	port(clock      : in std_logic;
		  enable     : in std_logic;
		  reset      : in std_logic;
		  n_jog      : in std_logic_vector(3 downto 0);
		  pontos_1   : in std_logic_vector(8 downto 0);
		  pontos_2   : in std_logic_vector(8 downto 0);
		  pontos_3   : in std_logic_vector(8 downto 0);
		  pontos_4   : in std_logic_vector(8 downto 0);
		  pontos_5   : in std_logic_vector(8 downto 0);
		  pontos_6   : in std_logic_vector(8 downto 0);
		  disp_jog   : out std_logic_vector(6 downto 0);
		  disp_pontos: out std_logic_vector(6 downto 0);
		 );
end final;


architecture placar of final is

signal muda_placar : std_logic;

begin

	timing : clk_div generic map (149999999) port map(clock, enable, muda_placar);

	process(muda_placar, reset)
	begin
		if (rising_edge(muda_placar)) then
			if (enable = '1') then
			
			else
				
			end if;
		end if;
	end process;


end placar;