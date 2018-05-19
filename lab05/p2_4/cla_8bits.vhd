-- brief : lab05 - question 2

library ieee;
use ieee.std_logic_1164.all;

entity cla_8bits is
  port(
    x    : in  std_logic_vector(7 downto 0);
    y    : in  std_logic_vector(7 downto 0);
    cin  : in  std_logic;
    sum  : out std_logic_vector(7 downto 0);
    cout : out std_logic
  );
end cla_8bits;

architecture rtl of cla_8bits is

component full_adder is
	port (x, y : in std_logic;
			r 	  : out std_logic;
			cin  : in std_logic;
			cout : out std_logic);
end component;

signal g : std_logic_vector(7 downto 0);
signal p : std_logic_vector(7 downto 0);
signal c : std_logic_vector(8 downto 0);

begin
	g <= x and y;
	p <= x or y;

	--Calculando cin
	c(0) <= cin;
	c(1) <= g(0) or 
			 (p(0) and c(0));
	
	c(2) <= g(1) or
			 (p(1) and g(0)) or
			 (p(1) and p(0) and c(0));
			 
	c(3) <= g(2) or
			 (p(2) and g(1)) or
			 (p(2) and p(1) and g(0)) or 
			 (p(2) and p(1) and p(0) and c(0));
			 
	c(4) <= g(3) or 
			 (p(3) and g(2)) or 
			 (p(3) and p(2) and g(1)) or 
			 (p(3) and p(2) and p(1) and g(0)) or 
			 (p(3) and p(2) and p(1) and p(0) and c(0));
			 
	c(5) <= g(4) or 
			 (p(4) and g(3)) or
			 (p(4) and p(3) and g(2)) or
			 (p(4) and p(3) and p(2) and g(1)) or
			 (p(4) and p(3) and p(2) and p(1) and g(0)) or
			 (p(4) and p(3) and p(2) and p(1) and p(0) and c(0));
			 
	c(6) <= g(5) or 
			 (p(5) and g(4)) or
			 (p(5) and p(4) and g(3)) or
			 (p(5) and p(4) and p(3) and g(2)) or
			 (p(5) and p(4) and p(3) and p(2) and g(1)) or
			 (p(5) and p(4) and p(3) and p(2) and p(1) and g(0)) or
			 (p(5) and p(4) and p(3) and p(2) and p(1) and p(0) and c(0));
	
	c(7) <= g(6) or
			 (p(6) and g(5)) or
			 (p(6) and p(5) and g(4)) or
			 (p(6) and p(5) and p(4) and g(3)) or
			 (p(6) and p(5) and p(4) and p(3) and g(2)) or
			 (p(6) and p(5) and p(4) and p(3) and p(2) and g(1)) or
			 (p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and g(0)) or
			 (p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and p(0) and c(0));
	
	c(8) <= g(7) or 
			 (p(7) and g(6)) or
			 (p(7) and p(6) and g(5)) or
			 (p(7) and p(6) and p(5) and g(4)) or
			 (p(7) and p(6) and p(5) and p(4) and g(3)) or
			 (p(7) and p(6) and p(5) and p(4) and p(3) and g(2)) or
			 (p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and g(1)) or
			 (p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and g(0)) or
			 (p(7) and p(6) and p(5) and p(4) and p(3) and p(2) and p(1) and p(0) and c(0));
	
	G1: for i in 0 to 7 generate
		full_adder_i: full_adder port map (x(i), y(i), sum(i), c(i));
	end generate;

	cout <= c(8);
end rtl;

