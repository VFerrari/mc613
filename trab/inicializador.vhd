library ieee ; 
use ieee.std_logic_1164.all ; 

entity inicializador is
port (CLOCK_50 : in std_logic;
		enable   : in std_logic;
		confirma : in std_logic;
		quant    : in std_logic_vector(5 downto 0);
		fim		: out std_logic;
		n_jog		: out std_logic_vector(2 downto 0);
		display  : out std_logic_vector(6 downto 0)
		);
end inicializador ; 

architecture logica of inicializador is

signal n_jog_select : std_logic_vector(2 downto 0);

begin

	with quant select
		n_jog_select <= "001" when "000001",
							 "010" when "000010",
							 "011" when "000100",
							 "100" when "001000",
							 "101" when "010000",
							 "110" when "100000",
							 "000" when others;
							 
	with quant select
		display 		 <= "1111111" when "000000",
							 "1111001" when "000001",
							 "0100100" when "000010",
							 "0110000" when "000100",
							 "0011001" when "001000",
							 "0010010" when "010000",
							 "0000010" when "100000",
							 "0000110" when others;
							 
							
	process(CLOCK_50, enable, confirma, n_jog_select)
	begin
		if (rising_edge(CLOCK_50)) then
			if (enable = '1' and confirma = '1' and n_jog_select /= "000") then
			
				n_jog <= n_jog_select;
				fim <= '1';
			
			else
				fim <= '0';				
			end if;
		end if;
	end process;
	
	

end logica;