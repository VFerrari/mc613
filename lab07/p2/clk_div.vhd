library ieee;
use ieee.std_logic_1164.all;

entity clk_div is
  port (
    clk : in std_logic;
    clk_hz : out std_logic
  );
end clk_div;

architecture behavioral of clk_div is
begin
	process(clk)
		variable contador : integer := 0;
	begin
		if (clk'event and clk='1') then
			if (contador = 49999999) then
				clk_hz <= '1';
				contador := 0;
			else
				contador := contador+1;
				clk_hz <= '0';
			end if;
		end if;
		
	end process;
	
end behavioral;
