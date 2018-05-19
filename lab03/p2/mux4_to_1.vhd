library ieee;
use ieee.std_logic_1164.all;

entity mux4_to_1 is
  port(d3, d2, d1, d0 : in std_logic;
       sel : in std_logic_vector(1 downto 0);
       output : out std_logic);
end mux4_to_1;

architecture rtl of mux4_to_1 is

 
 -- Dec2_to_4
	component dec2_to_4
		port(en, w1, w0: 		in  std_logic;
			  y3, y2, y1, y0: out std_logic);	 
	end component;	
	
	 -- Extra Logic
	component extra_logic
		port(w3, w2, w1, w0 : in  std_logic;
			  y3, y2, y1, y0 : in  std_logic;
			  f 				  : out std_logic);	 
	end component;	
	
	signal y3, y2, y1, y0 : std_logic;
	
begin

	deco: dec2_to_4 port map ('1', sel(1), sel(0), y3, y2, y1, y0 );
	logic: extra_logic port map (d3, d2, d1, d0, y3, y2, y1, y0, output);
 
end rtl;

