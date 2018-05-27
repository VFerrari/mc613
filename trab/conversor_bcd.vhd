library ieee ; 
use ieee.std_logic_1164.all ;

entity conversor_bcd is
	port(bin : in std_logic_vector(11 downto 0);
		  bcd : out std_logic_vector(11 downto 0)
		 );
end conversor_bcd;

architecture conv of conversor_bcd is
begin

end conv;