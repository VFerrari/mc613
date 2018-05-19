library ieee;
use ieee.std_logic_1164.all;

entity alu is
  port (
    a, b : in std_logic_vector(3 downto 0);
    F : out std_logic_vector(3 downto 0);
    s0, s1 : in std_logic;
    Z, C, V, N : out std_logic
  );
end alu;

architecture behavioral of alu is

--Ripple Carry Adder
component ripple_carry is
	generic (N : integer);
	port (x,y : in std_logic_vector(N-1 downto 0);
			r 	 : out std_logic_vector(N-1 downto 0);
			cin : in std_logic;
			cout: out std_logic;
			overflow : out std_logic);
end component;

signal s : std_logic_vector(1 downto 0);
signal m : std_logic_vector(3 downto 0); -- b pos. ou neg.

signal r_soma : std_logic_vector(3 downto 0); --Saida soma/subtracao.
signal resultado : std_logic_vector(3 downto 0); -- Buffer de saida.

signal ctemp, vtemp : std_logic;

begin
	s <= s1 & s0;
	
	with s0 select
		m <= b when '0',
			  (b xor "1111") when '1';
	
	op: ripple_carry
					generic map(4)
					port map (a, m, r_soma, s0, ctemp, vtemp);
	
	with s select
		resultado <= (a and b) when "10",
						 (a or b) when "11",
						 r_soma when others;
		
	Z <= '1' when  resultado= "0000" else '0';
	V <= vtemp when s1 = '0' else '0';
	C <= '0' when s1 = '1' else '0' when s0='1' else ctemp;
	N <= r_soma(3) when s1 = '0' else '0';

	F <= resultado;
	
end behavioral;
