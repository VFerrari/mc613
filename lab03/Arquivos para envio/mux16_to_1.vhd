library ieee;
use ieee.std_logic_1164.all;

entity mux16_to_1 is
  port(data : in std_logic_vector(15 downto 0);
       sel : in std_logic_vector(3 downto 0);
       output : out std_logic);
end mux16_to_1;

architecture rtl of mux16_to_1 is

 -- Mux4_to_1
	component mux4_to_1
		port(d3, d2, d1, d0 : in std_logic;
			  sel 			  : in std_logic_vector(1 downto 0);
			  output 		  : out std_logic);	 
	end component;
	
	signal t : std_logic_vector(3 downto 0);
	
begin
  Muxes: 
	for i in 0 to 3 generate
		Muxinhos: mux4_to_1 port map (
			data(4*i+3), data(4*i+2), data(4*i+1), 
			data(4*i), sel(1 downto 0), t(i) ) ;
	end generate;
	
	UltMux: mux4_to_1 port map 
		( t(3), t(2), t(1), t(0), sel(3 downto 2), output ) ;
		
end rtl;

