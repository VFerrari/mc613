library ieee;
use ieee.std_logic_1164.all ; 

entity latch_d_gated is
	port(
		  D	 : in std_logic;
		  Clk	 : in std_logic;
		  Q 	 : out std_logic;
		  Q_n  : out std_logic
	);
		  
end latch_d_gated;


architecture Behavior of latch_d_gated is

begin
	process (Clk, D)
	begin
		if Clk = '1' then
			Q <= D;
		end if;
	end process;
end Behavior;