library ieee;
use ieee.std_logic_1164.all;

entity kbd_alphanum is
  port (
    clk : in std_logic;
    key_on : in std_logic_vector(2 downto 0);
    key_code : in std_logic_vector(47 downto 0);
    HEX1 : out std_logic_vector(6 downto 0); -- GFEDCBA
    HEX0 : out std_logic_vector(6 downto 0) -- GFEDCBA
  );
end kbd_alphanum;

architecture rtl of kbd_alphanum is

-- Display
component bin2hex is
	port(bin : in std_logic_vector(3 downto 0);
		  off : in std_logic;
		  hex : out std_logic_vector(6 downto 0));
end component;

-- Select
component ascii_decoder is
	port(code : in std_logic_vector (7 downto 0);
		  shift : in std_logic;
		  caps : in std_logic;
		  ascii : out std_logic_vector (7 downto 0));
end component;


signal ascii : std_logic_vector(7 downto 0);
signal ascii_shift : std_logic_vector(7 downto 0);
signal shift : std_logic;
signal caps_atual  : std_logic;
signal caps_final  : std_logic;
signal final : std_logic_vector(7 downto 0);
signal off	 : std_logic;

begin
	shift <= '1' when key_code(7 downto 0) = x"12" else '1' when key_code(7 downto 0) = x"59" else '0';
	caps_atual <= '1' when key_code(7 downto 0) = x"58" else '1' when key_code(23 downto 16) = x"58" else '0';

	process(caps_atual)
	begin
		if (caps_atual = '1' ) then
			caps_final <= not(caps_final);
		end if;
	end process;
	
	first: ascii_decoder port map(key_code(7 downto 0), '0', caps_final, ascii);
	second: ascii_decoder port map(key_code(23 downto 16), shift, caps_final, ascii_shift);
								
	final <= ascii when shift='0' else ascii_shift;
	off <= '1' when final = x"FF" else '0';
		
	char_1: bin2hex port map (final(3 downto 0), off, HEX0);
	char_2: bin2hex port map (final(7 downto 4), off, HEX1);

end rtl;
