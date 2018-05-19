library ieee ; 
use ieee.std_logic_1164.all ; 

entity latch_sr_nand is
	port(
		  S_n : in std_logic;
		  R_n : in std_logic;
		  Qa  : out std_logic;
		  Qb  : out std_logic
	);
		  
end latch_sr_nand;


architecture Behavior of latch_sr_nand is

signal Q2a, Q2b : std_logic;

begin
	Q2a <= S_n nand Q2b;
	Q2b <= R_n nand Q2a;
	
	Qa <= Q2a;
	Qb <= Q2b;

end Behavior;