LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY Lab02_1 IS
	PORT (A, B, C, D, E	:	IN STD_LOGIC ; 
			F	:	OUT STD_LOGIC ) ;
END Lab02_1 ;

ARCHITECTURE Behavior OF Lab02_1 IS
	SIGNAL m : STD_LOGIC_VECTOR (4 DOWNTO 0) ;
BEGIN
	m <= A & B & C & D & E ;
		F <= '1' WHEN (m="00000" OR 
							m="00010" OR 
							m="00101" OR 
							m="01000" OR 
							m="01101" OR 
							m="01111" OR 
							m="10010" OR 
							m="10101" OR 
							m="11000" OR 
							m="11101" OR 
							m="11111") ELSE '0' ;
	
END Behavior ;