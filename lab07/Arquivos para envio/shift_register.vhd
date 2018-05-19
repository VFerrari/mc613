library ieee;
use ieee.std_logic_1164.all;

entity shift_register is
generic (N : integer := 6);
port(
    clk     : in  std_logic;
    mode    : in  std_logic_vector(1 downto 0);
    ser_in  : in  std_logic;
    par_in  : in  std_logic_vector((N - 1) downto 0);
    par_out : out std_logic_vector((N - 1) downto 0)
  );
end shift_register;

architecture rtl of shift_register is

signal reggae : std_logic_vector(N-1 downto 0);

begin
	process (mode, clk)
	begin
		if (clk'event and clk='1') then
		
			-- Shift left
			if (mode ="01") then
			
				for i in N-1 downto 1 loop
					reggae(i) <= reggae(i-1);
				end loop;
			
				reggae(0) <= ser_in;
			
			-- Shift right
			elsif(mode = "10") then
			
				for i in 0 to N-2 loop
					reggae(i) <= reggae(i+1);
				end loop;
				
				reggae(N-1) <= ser_in;

			-- Load
			elsif(mode = "11") then
				reggae <= par_in;
			end if;
		end if;
		
		par_out <= reggae;
	end process;
	
end rtl;
