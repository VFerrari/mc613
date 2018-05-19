library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity bank is
	generic (
		WORDSIZE : natural := 32
	);
	port (
		WR_EN, RD_EN,
		clear,
		clock		: in 	std_logic;
		WR_ADDR,
		RD_ADDR1,
		RD_ADDR2	: in	std_logic_vector (4 downto 0);
		DATA_IN		: in	std_logic_vector (WORDSIZE-1 downto 0);
		DATA_OUT1,
		DATA_OUT2	: out	std_logic_vector (WORDSIZE-1 downto 0)
	);
	
end bank;

architecture direct of bank is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector(31 downto 0);
	type regis_t is array(31 downto 0) of word_t;

	-- Declare the Register signal.	
	signal regis : regis_t;
		
begin

	process(clock, clear)
	begin
		if (clear = '1') then
			regis <= ( others => (others => '0'));
		elsif(rising_edge(clock)) then
			if(WR_EN = '1') then
					regis(to_integer(unsigned(WR_ADDR))) <= DATA_IN;
			end if;
		end if;
	end process;

	DATA_OUT1 <=  (others => 'Z') when RD_EN = '0' else (others => '0') when RD_ADDR1 = "00000" else regis(to_integer(unsigned(RD_ADDR1)));
	DATA_OUT2 <= (others => 'Z') when RD_EN = '0' else (others => '0') when RD_ADDR2 = "00000" else regis(to_integer(unsigned(RD_ADDR2)));
	
end direct;

