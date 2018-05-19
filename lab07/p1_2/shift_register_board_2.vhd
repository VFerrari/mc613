library ieee;
use ieee.std_logic_1164.all;

entity shift_register_board_2 is
port(
    SW   				 : in  std_logic_vector(9 downto 0);
    LEDR				 	 : out std_logic_vector(5 downto 0)
  );
end shift_register_board_2;

architecture Behavior of shift_register_board_2 is

-- Register
component shift_register
	generic (N : integer := 6);
	port(clk     : in  std_logic;
		  mode    : in  std_logic_vector(1 downto 0);
		  ser_in  : in  std_logic;
		  par_in  : in  std_logic_vector((N - 1) downto 0);
		  par_out : out std_logic_vector((N - 1) downto 0));
end component;

begin
	shift: shift_register
					generic map(6)
					port map(SW(9), SW(8 downto 7), SW(6), SW(5 downto 0), LEDR);


end Behavior;