library ieee;
use ieee.std_logic_1164.all;

entity ripple_carry_board is
  port (
    SW : in std_logic_vector(7 downto 0);
    HEX4 : out std_logic_vector(6 downto 0);
    HEX2 : out std_logic_vector(6 downto 0);
    HEX0 : out std_logic_vector(6 downto 0);
    LEDR : out std_logic_vector(0 downto 0)
    );
end ripple_carry_board;



architecture rtl of ripple_carry_board is

-- Ripple Carry Adder
component ripple_carry is
	generic (N : integer);
	port (x,y : in std_logic_vector(N-1 downto 0);
			r 	 : out std_logic_vector(N-1 downto 0);
			cin : in std_logic;
			cout: out std_logic;
			overflow : out std_logic);
end component;

--Bin To Hex
component bin2hex is
	port(SW: in std_logic_vector(3 downto 0);
		  HEX0: out std_logic_vector(6 downto 0));
end component;

signal r : std_logic_vector(3 downto 0);
signal lixo : std_logic;

begin
	serie: ripple_carry
					generic map (4)
					port map (SW(7 downto 4), SW(3 downto 0), r, '0', lixo, LEDR(0));
	
	visor_x: bin2hex port map(SW(7 downto 4), HEX4);
	visor_y: bin2hex port map(SW(3 downto 0), HEX2);
	visor_r: bin2hex port map(r, HEX0);
	
end rtl;
