library ieee;
use ieee.std_logic_1164.all;

entity zbuffer is
  port(x: in std_logic_vector (3 downto 0);
		 e: in std_logic;
       f: out std_logic_vector(3 downto 0));
end zbuffer;

architecture Behavior of zbuffer is
begin
	f <= "ZZZZ" when e='0' else x;
end Behavior;