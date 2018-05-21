library ieee;
use ieee.std_logic_1164.all;

entity bin2dec is
	port (
			bin: in std_logic_vector(3 downto 0);
			dec: out std_logic_vector(6 downto 0)
	);
end bin2dec;

architecture Behavior of bin2dec is
begin
	with bin select
		dec  <= "1000000" when "0000",
				  "1111001" when "0001",
				  "0100100" when "0010",
				  "0110000" when "0011",
				  "0011001" when "0100",
				  "0010010" when "0101",
				  "0000010" when "0110",
				  "1111000" when "0111",
				  "0000000" when "1000",
				  "0010000" when "1001",
				  "1111111" when others ;
end Behavior;