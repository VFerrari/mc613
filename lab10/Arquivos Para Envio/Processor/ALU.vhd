LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY ALU IS
	GENERIC (
		WORDSIZE	: NATURAL := 4
	);
	PORT (
		A, B		: IN		STD_LOGIC_VECTOR (WORDSIZE-1 DOWNTO 0);
		Im			: IN		STD_LOGIC_VECTOR (15 DOWNTO 0);
		Op			: IN		STD_LOGIC_VECTOR (2 DOWNTO 0);
		F			: BUFFER	STD_LOGIC_VECTOR (WORDSIZE-1 DOWNTO 0);
		Z, C, V, N	: OUT		STD_LOGIC
	);
END ENTITY;

ARCHITECTURE Behavior OF ALU IS
BEGIN
	Operation:
	PROCESS (A, B, Im, Op, F)
		VARIABLE R : STD_LOGIC_VECTOR (WORDSIZE DOWNTO 0);
		VARIABLE W : STD_LOGIC_VECTOR (WORDSIZE-1 DOWNTO 0);
	BEGIN
		IF Op = "001" THEN
			W := (NOT B) + 1;
		ELSIF Op = "100" THEN
			IF (Im(15) = '0') THEN
				W := ("0000000000000000" & Im);
			ELSE
				W := ("1111111111111111" & Im);
			END IF;
		ELSE
			W := B;
		END IF;
	
		CASE Op IS
		WHEN "000" =>
			R := ('0' & A) + ('0' & W);
		WHEN "001" =>
			R := ('0' & A) + ('0' & W);
		WHEN "010" =>
			R := '0' & (A AND W);
		WHEN "100" =>
			R := ('0' & A) + ('0' & W);
		WHEN OTHERS =>
			R := '0' & (A OR W);
		END CASE;
		
		V <= (A(WORDSIZE-1) AND W(WORDSIZE-1) AND (NOT F(WORDSIZE-1))) OR ( (NOT A(WORDSIZE-1)) AND (NOT W(WORDSIZE-1)) AND F(WORDSIZE-1));
		
		IF (F = 0) THEN
			Z <= '1';
		ELSE
			Z <= '0';
		END IF;
		
		N <= R (WORDSIZE-1);
		C <= R (WORDSIZE);
		F <= R (WORDSIZE-1 DOWNTO 0);
		
	END PROCESS;
END ARCHITECTURE;