library ieee;
use ieee.std_logic_1164.all;

entity dec2_to_4 is
  port(en, w1, w0: in std_logic;
       y3, y2, y1, y0: out std_logic);
end dec2_to_4;

architecture rtl of dec2_to_4 is

signal enw: std_logic_vector(2 downto 0);
signal y: std_logic_vector(3 downto 0);

begin
  enw <= en & w1 & w0;
  
  with enw select
		y <= "0001" when "100",
			  "0010" when "101",
			  "0100" when "110",
			  "1000" when "111",
			  "0000" when others;
			  
	y0 <= y(0);
	y1 <= y(1);
	y2 <= y(2);
	y3 <= y(3);
end rtl;

