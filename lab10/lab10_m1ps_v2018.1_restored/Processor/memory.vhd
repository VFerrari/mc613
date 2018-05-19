library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity memory is
	generic (
		WORDSIZE		: natural	:= 8;
		BITS_OF_ADDR	: natural	:= 16;
		MIF_FILE		: string	:= ""
	);
	port (
		clock   : in	std_logic;
		we      : in	std_logic;
		address : in	std_logic_vector(BITS_OF_ADDR-1 DOWNTO 0);
		datain  : in	std_logic_vector(WORDSIZE-1 DOWNTO 0);
		dataout : out	std_logic_vector(WORDSIZE-1 DOWNTO 0)
	);
end memory;


architecture rtl of memory is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((WORDSIZE-1) downto 0);
	type memory_t is array(2**BITS_OF_ADDR-1 downto 0) of word_t;
	
	-- Declare the RAM signal.	
	signal ram : memory_t;
	
	attribute ram_init_file : string;
	attribute ram_init_file of ram : signal is MIF_FILE;

begin

	process(clock)
	begin
	if(rising_edge(clock)) then
		if(we = '1') then
			ram(to_integer(unsigned(address))) <= datain;
		end if;
		
		dataout <= ram(to_integer(unsigned(address)));
		
	end if;
	end process;


end rtl;