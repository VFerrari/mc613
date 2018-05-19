library ieee;
use ieee.std_logic_1164.all;

entity ascii_decoder is
	port(
		  code : in std_logic_vector (7 downto 0);
		  shift : in std_logic;
		  caps : in std_logic;
		  ascii : out std_logic_vector (7 downto 0)
	);
end ascii_decoder;

architecture dec of ascii_decoder is

signal temp, temp_high : std_logic_vector (7 downto 0);

begin

	-- Without shift or caps
	with code select
		temp  <= x"61" when x"1C", --a
					x"62" when x"32", --b
					x"63" when x"21", --c
					x"64" when x"23", --d
					x"65" when x"24", --e
					x"66" when x"2B", --f
					x"67" when x"34", --g
					x"68" when x"33", --h
					x"69" when x"43", --i
					x"6A" when x"3B", --j
					x"6B" when x"42", --k
					x"6C" when x"4B", --l
					x"6D" when x"3A", --m
					x"6E" when x"31", --n
					x"6F" when x"44", --o
					x"70" when x"4D", --p
					x"71" when x"15", --q
					x"72" when x"2D", --r
					x"73" when x"1B", --s
					x"74" when x"2C", --t
					x"75" when x"3C", --u
					x"76" when x"2A", --v
					x"77" when x"1D", --w
					x"78" when x"22", --x
					x"79" when x"35", --y
					x"7A" when x"1A", --z
					
					-- Numbers
					x"30" when x"45", --0
					x"31" when x"16", --1
					x"32" when x"1E", --2
					x"33" when x"26", --3
					x"34" when x"25", --4
					x"35" when x"2E", --5
					x"36" when x"36", --6
					x"37" when x"3D", --7
					x"38" when x"3E", --8
					x"39" when x"46", --9
					
					-- KP Numbers
					x"30" when x"70", --KP 0
					x"31" when x"69", --KP 1
					x"32" when x"72", --KP 2
					x"33" when x"7A", --KP 3
					x"34" when x"6B", --KP 4
					x"35" when x"73", --KP 5
					x"36" when x"74", --KP 6
					x"37" when x"6C", --KP 7
					x"38" when x"75", --KP 8
					x"39" when x"7D", --KP 9 
					
					x"FF" when others;
		
	-- With shift or caps
	with code select
		temp_high <= 
					x"41" when x"1C", --A
					x"42" when x"32", --B
					x"43" when x"21", --C
					x"44" when x"23", --D
					x"45" when x"24", --E
					x"46" when x"2B", --F
					x"47" when x"34", --G
					x"48" when x"33", --H
					x"49" when x"43", --I
					x"4A" when x"3B", --J
					x"4B" when x"42", --K
					x"4C" when x"4B", --L
					x"4D" when x"3A", --M
					x"4E" when x"31", --N
					x"4F" when x"44", --O
					x"50" when x"4D", --P
					x"51" when x"15", --Q
					x"52" when x"2D", --R
					x"53" when x"1B", --S
					x"54" when x"2C", --T
					x"55" when x"3C", --U
					x"56" when x"2A", --V
					x"57" when x"1D", --W
					x"58" when x"22", --X
					x"59" when x"35", --Y
					x"5A" when x"1A", --Z
					
					-- Numbers
					x"30" when x"45", --0
					x"31" when x"16", --1
					x"32" when x"1E", --2
					x"33" when x"26", --3
					x"34" when x"25", --4
					x"35" when x"2E", --5
					x"36" when x"36", --6
					x"37" when x"3D", --7
					x"38" when x"3E", --8
					x"39" when x"46", --9
					
					-- KP Numbers
					x"30" when x"70", --KP 0
					x"31" when x"69", --KP 1
					x"32" when x"72", --KP 2
					x"33" when x"7A", --KP 3
					x"34" when x"6B", --KP 4
					x"35" when x"73", --KP 5
					x"36" when x"74", --KP 6
					x"37" when x"6C", --KP 7
					x"38" when x"75", --KP 8
					x"39" when x"7D", --KP 9					
					
					x"FF" when others;
					
		ascii <= temp when (shift xor caps)='0' else temp_high;

end dec;