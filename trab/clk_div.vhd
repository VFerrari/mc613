library ieee;
use ieee.std_logic_1164.all;

entity clk_div is
  generic(
	 DIVISOR: natural  := 49999999
  );
  port (
    clk : in std_logic;
	 en  : in std_logic;
    clk_lento : out std_logic
  );
end clk_div;

architecture behavioral of clk_div is
begin
	process(clk)
		variable contador : natural := 0;
	begin
		if (clk'event and clk='1') then
			if(en = '1') then
				if (contador = DIVISOR) then
					clk_lento <= '1';
					contador := 0;
				else
					contador := contador+1;
					clk_lento <= '0';
				end if;
			else
				contador := 0;
			end if;
		
		end if;
		
	end process;
	
end behavioral;