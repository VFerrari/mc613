library ieee;
use ieee.std_logic_1164.all;

entity xbar_gen is
  generic (N : integer);
  port(s: in std_logic_vector (N-1 downto 0);
       y1, y2: out std_logic);
end xbar_gen;

architecture rtl of xbar_gen is

	-- Xbar singular
	component xbar_v2
		port ( x1, x2, s : in std_logic;
				 y1, y2: out std_logic);		 
	end component;	
	
	-- Saidas temporarias
	signal x1 : std_logic_vector (N downto 0);
	signal x2 : std_logic_vector (N downto 0);
	
begin
	x1(0) <= '1';
	x2(0) <= '0';
	
	G1: for i in 0 to N-1 generate
		xbar_i: xbar_v2 port map (x1(i), x2(i), s(i), x1(i+1), x2(i+1));
	end generate;
	
	y1 <= x1(N);
	y2 <= x2(N);

end rtl;

