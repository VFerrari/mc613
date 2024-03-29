library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conversor_bcd is
   port(clk       : in std_logic;
		  binario_in: in std_logic_vector(8 downto 0);
        bcd		 : out std_logic_vector(11 downto 0)
		 );
end conversor_bcd;


architecture conv of conversor_bcd is

signal dec : integer range 0 to 300;
signal un, dez, cent : integer range 0 to 9;

begin
	dec <= to_integer(unsigned(binario_in));
	
	process(clk)
		variable dez_buf : integer range 0 to 99;
	begin
		if(rising_edge(clk)) then
			dez_buf := (dec mod 100);
			dez_buf := (dez_buf / 10);
			
			un <= (dec mod 10);
			dez <= dez_buf;
			cent <= (dec / 100);
		end if;
	end process;

	bcd(11 downto 8) <= std_logic_vector(to_unsigned(cent,4));
	bcd(7 downto 4) <= std_logic_vector(to_unsigned(dez, 4));
	bcd(3 downto 0) <= std_logic_vector(to_unsigned(un, 4));
	
end conv;