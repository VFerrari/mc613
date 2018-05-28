library ieee;
use ieee.std_logic_1164.all;

package boliche_tipos is

	type vetor_pontos is array (1 to 6) of std_logic_vector(8 downto 0);
	type vetor_jogs is array (1 to 6) of std_logic_vector(2 downto 0);
	type vetor_stsp is array (1 to 6) of std_logic_vector(1 to 9);
	type vetor_strike_spec is array (1 to 6) of std_logic_vector(1 to 3);
	type vetor_spare_spec is array (1 to 6) of std_logic_vector(1 to 2);
	type vetor_disp is array (0 to 2) of std_logic_vector(6 downto 0);
	
	
end package;
