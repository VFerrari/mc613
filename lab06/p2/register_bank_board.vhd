library ieee;
use ieee.std_logic_1164.all;

entity register_bank_board is
	port(
		SW  : in std_logic_vector(9 downto 0);
		KEY : in std_logic_vector(2 downto 0);
		HEX0: out std_logic_vector(6 downto 0)
	);
end register_bank_board;

architecture Behavior of register_bank_board is

-- Banco de Registradores
component register_bank is
  port (clk : in std_logic;
		  data_in : in std_logic_vector(3 downto 0);
		  data_out : out std_logic_vector(3 downto 0);
		  reg_rd : in std_logic_vector(2 downto 0);
		  reg_wr : in std_logic_vector(2 downto 0);
		  we : in std_logic;
		  clear : in std_logic);
end component;

-- Display de 7 segmentos
component bin2hex is
	port (SW  : in std_logic_vector(3 downto 0);
			HEX0: out std_logic_vector(6 downto 0));
end component;

signal saida_temp : std_logic_vector(3 downto 0);
begin

	banco  : register_bank port map(not(KEY(0)), SW(9 downto 6), saida_temp, SW(2 downto 0), SW(5 downto 3), not(KEY(1)), not(KEY(2)));
	display: bin2hex port map (saida_temp, HEX0);

end Behavior;